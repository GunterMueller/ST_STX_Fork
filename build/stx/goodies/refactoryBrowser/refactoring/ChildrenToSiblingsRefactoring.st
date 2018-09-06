"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

ClassRefactoring subclass:#ChildrenToSiblingsRefactoring
	instanceVariableNames:'parent subclasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!ChildrenToSiblingsRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk name: aClassName class: aClass subclasses: subclassCollection 
	^(self new)
		model: aRBSmalltalk;
		name: aClassName
			class: aClass
			subclasses: subclassCollection;
		yourself
!

name: aClassName class: aClass subclasses: subclassCollection 
	^(self new)
		name: aClassName
			class: aClass
			subclasses: subclassCollection;
		yourself
! !

!ChildrenToSiblingsRefactoring methodsFor:'initialize-release'!

name: aClassName class: aClass subclasses: subclassCollection 
	className := aClassName asSymbol.
	parent := self model classFor: aClass.
	subclasses := subclassCollection 
				collect: [:each | self model classFor: each]
! !

!ChildrenToSiblingsRefactoring methodsFor:'preconditions'!

preconditions
        ^subclasses 
                inject: ((RBCondition isMetaclass: parent) 
                                errorMacro: 'Superclass must not be a metaclass') not 
                                & (RBCondition isValidClassName: className) 
                                        & (RBCondition isGlobal: className in: self model) not
                into: 
                        [:sub :each | 
                        sub 
                                & ((RBCondition isMetaclass: each) 
                                                errorMacro: 'Subclass must <1?not :>be a metaclass') not 
                                        & (RBCondition isImmediateSubclass: each of: parent)]
! !

!ChildrenToSiblingsRefactoring methodsFor:'printing'!

storeOn: aStream 
        aStream nextPut: $(.
        self class storeOn: aStream.
        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            aStream
                    nextPutAll: ' name: ';
                    nextPutAll: (className asSymbol storeString); 
                    nextPutAll: ' class: '.
        ] ifFalse:[
            aStream
                    nextPutAll: ' name: #';
                    nextPutAll: className;
                    nextPutAll: ' class: '.
        ].
        parent storeOn: aStream.
        aStream nextPutAll: ' subclasses: '.
        subclasses asArray storeOn: aStream.
        aStream nextPut: $)
! !

!ChildrenToSiblingsRefactoring methodsFor:'private-accessing'!

abstractSuperclass
	^self model classNamed: className asSymbol
! !

!ChildrenToSiblingsRefactoring methodsFor:'private-methods'!

computeSubclassSupersOf: aClass 
	| selectors |
	selectors := Set new.
	aClass subclasses do: 
			[:each | 
			each selectors 
				do: [:sel | selectors addAll: (each parseTreeFor: sel) superMessages]].
	^selectors
!

createSubclassResponsibilityFor: aSelector in: aClass 
	| source |
	(aClass superclass definesMethod: aSelector) ifTrue: [^self].
	source := self subclassResponsibilityFor: aSelector in: aClass.
	source isNil ifTrue: [^self].
	aClass superclass compile: source
		classified: (aClass protocolsFor: aSelector)
!

pushUp: aSelector in: aClass 
	| source |
	source := aClass sourceCodeFor: aSelector.
	source isNil 
		ifFalse: 
			[aClass superclass compile: source
				classified: (aClass protocolsFor: aSelector)]
!

pushUpMethodsFrom: aClass 
	| selectorsToPushUp |
	selectorsToPushUp := self selectorsToPushUpFrom: aClass.
	aClass selectors do: 
			[:each | 
			(selectorsToPushUp includes: each) 
				ifTrue: [self pushUp: each in: aClass]
				ifFalse: [self createSubclassResponsibilityFor: each in: aClass]].
	selectorsToPushUp do: [:each | aClass removeMethod: each]
!

selectorsToPushUpFrom: aClass 
	| superSelectors |
	superSelectors := self computeSubclassSupersOf: aClass.
	^aClass selectors select: 
			[:each | 
			(superSelectors includes: each) or: [self shouldPushUp: each from: aClass]]
!

shouldPushUp: aSelector from: aClass 
	^((aClass isMeta 
		ifTrue: [subclasses collect: [:each | each metaclass]]
		ifFalse: [subclasses]) 
			detect: [:each | (each directlyDefinesMethod: aSelector) not]
			ifNone: [nil]) notNil
!

subclassResponsibilityFor: aSelector in: aClass 
	| methodNode position source |
	source := aClass sourceCodeFor: aSelector.
	methodNode := RBParser parseMethod: source onError: [:err :pos | ^nil].
	position := methodNode arguments isEmpty 
				ifTrue: [methodNode selectorParts last stop]
				ifFalse: [methodNode arguments last stop].
	^'<1s><n><t>self subclassResponsibility' 
		expandMacrosWith: (source copyFrom: 1 to: position)
! !

!ChildrenToSiblingsRefactoring methodsFor:'private-variables'!

pullUpClassInstanceVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass metaclass.
	parent metaclass instanceVariableNames do: 
			[:each | 
			self performComponentRefactoring: (PullUpInstanceVariableRefactoring 
						model: self model
						variable: each
						class: newSuperclass)]
!

pullUpClassVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent classVariableNames do: 
			[:each | 
			self performComponentRefactoring: (PullUpClassVariableRefactoring 
						model: self model
						variable: each
						class: newSuperclass)]
!

pullUpInstanceVariables
	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent instanceVariableNames do: 
			[:each | 
			self performComponentRefactoring: (PullUpInstanceVariableRefactoring 
						model: self model
						variable: each
						class: newSuperclass)]
!

pullUpPoolVariables
	"Don't remove the pool variables from the subclass since they might be referenced there."

	| newSuperclass |
	newSuperclass := self abstractSuperclass.
	parent poolDictionaryNames 
		do: [:each | newSuperclass addPoolDictionary: each]
! !

!ChildrenToSiblingsRefactoring methodsFor:'transforming'!

addSuperclass
	self performComponentRefactoring: (AddClassRefactoring 
				model: self model
				addClass: className
				superclass: parent superclass
				subclasses: (Array with: parent)
				category: parent category)
!

changeIsKindOfReferences
	| replacer |
	replacer := ParseTreeRewriter new.
	replacer replace: '``@object isKindOf: ' , parent name
		with: '``@object isKindOf: ' , className.
	self convertAllReferencesToClass: parent using: replacer
!

pushUpMethods
	self pushUpMethodsFrom: parent.
	self pushUpMethodsFrom: parent metaclass
!

pushUpVariables
	self pullUpInstanceVariables.
	self pullUpClassInstanceVariables.
	self pullUpClassVariables.
	self pullUpPoolVariables
!

reparentSubclasses
	self model reparentClasses: subclasses to: self abstractSuperclass
!

transform
	self
		addSuperclass;
		pushUpVariables;
		pushUpMethods;
		changeIsKindOfReferences;
		reparentSubclasses
! !

!ChildrenToSiblingsRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/ChildrenToSiblingsRefactoring.st,v 1.13 2004-06-18 08:15:22 ca Exp $'
! !

"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBNamespace
	instanceVariableNames:'changes environment newClasses removedClasses changedClasses
		rootClasses implementorsCache sendersCache'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Model'
!


!RBNamespace class methodsFor:'instance creation'!

new
	^(super new)
		initialize;
		yourself
!

onEnvironment: aBrowserEnvironment 
	^(self new)
		environment: aBrowserEnvironment;
		yourself
! !

!RBNamespace methodsFor:'accessing'!

allClassesDo: aBlock 
	| seen evalBlock |
	seen := Set new.
	evalBlock := 
			[:each | 
			seen add: each first name.
			aBlock
				value: each first;
				value: each last].
	newClasses do: evalBlock.
	changedClasses do: evalBlock.
	environment classesDo: 
			[:each | 
			each isMeta 
				ifFalse: 
					[((seen includes: each name) or: [self hasRemoved: (self classNameFor: each)]) 
						ifFalse: 
							[| class |
							class := self classFor: each.
							class ifNotNil:[
							    aBlock
								value: class;
								value: class metaclass]]]]
!

allImplementorsOf: aSelector 
	^implementorsCache at: aSelector
		ifAbsentPut: [self privateImplementorsOf: aSelector]
!

allReferencesTo: aSymbol do: aBlock 
	(sendersCache at: aSymbol
		ifAbsentPut: 
			[| refs |
			refs := OrderedCollection new.
			self allClassesDo: 
					[:each | 

					(each whichSelectorsReferToSymbol: aSymbol) 
						do: [:sel | refs add: (each methodFor: sel)]].
			refs]) 
			do: aBlock
!

allReferencesToClass: aRBClass do: aBlock 
	self allClassesDo: 
			[:each | 
			(each whichSelectorsReferToClass: aRBClass) 
				do: [:sel | aBlock value: (each methodFor: sel)]]
!

changes
	^changes
!

changes: aCompositeRefactoryChange
    changes := aCompositeRefactoryChange

    "Modified (format): / 03-04-2014 / 11:51:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environment
	^environment
!

environment: aBrowserEnvironment 
	environment := aBrowserEnvironment
!

name
	^changes name
!

name: aString
	^changes name: aString
!

rootClasses
	rootClasses isNil 
		ifTrue: 
			[rootClasses := OrderedCollection new.
			Class rootsOfTheWorld do: 
					[:each | 
					| class |
					class := self classFor: each.
					(class notNil and: [class superclass isNil]) 
						ifTrue: [rootClasses add: class]]].
	^rootClasses
! !

!RBNamespace methodsFor:'accessing-classes'!

classFor: aBehavior 
        | nonMetaclass cls |
        aBehavior isNil ifTrue: [^nil].
        (aBehavior isBehavior and:[aBehavior theNonMetaclass isJavaClass]) ifTrue:[
            ^ nil "/Sorry, no RB support for Java (yet)
        ].
        nonMetaclass := aBehavior isMeta 
                                ifTrue: [aBehavior soleInstance]
                                ifFalse: [aBehavior].
        cls := aBehavior isMeta 
                ifTrue: [self metaclassNamed: nonMetaclass name]
                ifFalse: [self classNamed: nonMetaclass name].
        cls isNil ifTrue:[
            " self halt:'oops - class not found by name'. "
            ^ aBehavior
        ].
        ^ cls

    "Modified: / 25-08-2013 / 14:29:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamed: aSymbol 
        | class index classes |
        aSymbol isNil ifTrue: [^nil].

        (self hasRemoved: aSymbol) ifTrue: [^nil].
        (newClasses includesKey: aSymbol) 
                ifTrue: [^(newClasses at: aSymbol) first].
        (changedClasses includesKey: aSymbol) 
                ifTrue: [^(changedClasses at: aSymbol) first].
        (class := environment at: aSymbol ifAbsent: [nil]) isBehavior 
                ifTrue: 
                        [classes := self createNewClassFor: class.
                        ^class isMeta ifTrue: [classes last] ifFalse: [classes first]].
        index := aSymbol 
                                indexOfSubCollection: ' class'
                                startingAt: 1
                                ifAbsent: [^nil].
        class := self classNamed: (aSymbol copyFrom: 1 to: index - 1) asSymbol.
        ^class isNil ifTrue: [nil] ifFalse: [class metaclass]
!

createNewClassFor: aBehavior 
	| nonMeta meta className |
	className := (aBehavior isMeta 
				ifTrue: [aBehavior soleInstance]
				ifFalse: [aBehavior]) name.
	nonMeta := (RBClass existingNamed: className)
				model: self;
				yourself.
	meta := (RBMetaclass existingNamed: className)
				model: self;
				yourself.
	^changedClasses at: className put: (Array with: nonMeta with: meta)
!

metaclassNamed: aSymbol 
	| class |
	aSymbol isNil ifTrue: [^nil].
	(self hasRemoved: aSymbol) ifTrue: [^nil].
	(newClasses includesKey: aSymbol) ifTrue: [^(newClasses at: aSymbol) last].
	(changedClasses includesKey: aSymbol) 
		ifTrue: [^(changedClasses at: aSymbol) last].
	(class := environment at: aSymbol ifAbsent: [nil]) isBehavior 
		ifTrue: [^(self createNewClassFor: class) last].
	^nil
!

whichCategoryIncludes: aSymbol
	^self environment whichCategoryIncludes: aSymbol
! !

!RBNamespace methodsFor:'changes'!

defineClass: aString 
        | change newClass newClassName |
        change := changes defineClass: aString.
        newClassName := change changeClassName.
        newClass := self classNamed: newClassName.
        newClass isNil 
                ifTrue: 
                        [| newMetaclass |
                        removedClasses
                                remove: newClassName ifAbsent: [];
                                remove: newClassName , ' class' ifAbsent: [].
                        newClass := RBClass named: newClassName.
                        newMetaclass := RBMetaclass named: newClassName.
                        newClass model: self.
                        newMetaclass model: self.
                        newClasses at: newClassName put: (Array with: newClass with: newMetaclass)].
        newClass superclass: (self classNamed: change superclassName).
        newClass superclass isNil 
                ifTrue: 
                        [self rootClasses add: newClass.
                        newClass metaclass superclass: (self classFor: Object class superclass)]
                ifFalse: [newClass metaclass superclass: newClass superclass metaclass].
        newClass instanceVariableNames: change instanceVariableNames.
        newClass classVariableNames: change classVariableNames.
        newClass poolDictionaryNames: change poolDictionaryNames.
        newClass setCategory: change category.
        ^change
!

removeClass: aRBClass 
	self removeClassNamed: aRBClass name
!

removeClassNamed: aSymbol 
        |cls|

        cls := self classNamed: aSymbol.
        cls isNil ifTrue:[^ self].

        cls subclasses 
                do: [:each | self removeClassNamed: each name].
        removedClasses
                add: aSymbol;
                add: aSymbol , ' class'.
        newClasses removeKey: aSymbol ifAbsent: [].
        changedClasses removeKey: aSymbol ifAbsent: [].
        self flushCaches.
        ^changes removeClassNamed: aSymbol
!

renameClass: aRBClass to: aSymbol around: aBlock 
	| change value dict |
	change := RenameClassChange rename: aRBClass name to: aSymbol.
	self performChange: change around: aBlock.
	self flushCaches.
	dict := (newClasses includesKey: aSymbol) 
				ifTrue: [newClasses]
				ifFalse: [changedClasses].
	removedClasses
		add: aRBClass name;
		add: aRBClass name , ' class'.
	value := dict at: aRBClass name.
	dict removeKey: aRBClass name.
	dict at: aSymbol put: value.
	value first name: aSymbol.
	value last name: aSymbol.
	value first subclasses do: [:each | each superclass: value first].
	value last subclasses do: [:each | each superclass: value last].
	^change
!

reparentClasses: aRBClassCollection to: newClass 
	aRBClassCollection do: 
			[:aClass | 
			self defineClass: (self replaceClassNameIn: aClass definitionString
						to: newClass name)]
! !

!RBNamespace methodsFor:'initialize-release'!

initialize
	changes := CompositeRefactoryChange new.
	environment := BrowserEnvironment new.
	newClasses := IdentityDictionary new.
	changedClasses := IdentityDictionary new.
	removedClasses := Set new.
	implementorsCache := IdentityDictionary new.
	sendersCache := IdentityDictionary new
! !

!RBNamespace methodsFor:'private'!

classNameFor: aBehavior 
	^(aBehavior isMeta ifTrue: [aBehavior soleInstance] ifFalse: [aBehavior]) 
		name
!

hasCreatedClassFor: aBehavior 
	| className |
	className := self classNameFor: aBehavior.
	^(newClasses includesKey: className) 
		or: [changedClasses includesKey: className]
!

privateImplementorsOf: aSelector 
	| classes |
	classes := Set new.
	self allClassesDo: 
			[:each | 

			(each directlyDefinesMethod: aSelector) ifTrue: [classes add: each]].
	^classes
! !

!RBNamespace methodsFor:'private-changes'!

addChangeToClass: aRBClass 
	^changedClasses at: aRBClass name
		put: (Array with: aRBClass nonMetaclass with: aRBClass metaclass)
!

addClassVariable: aString to: aRBClass 
	^changes addClassVariable: aString to: aRBClass
!

addInstanceVariable: aString to: aRBClass 
	^changes addInstanceVariable: aString to: aRBClass
!

addPool: aString to: aRBClass 
	^changes addPool: aString to: aRBClass
!

changeClass: aRBClass 
	changedClasses at: aRBClass name
		put: (Array with: aRBClass nonMetaclass with: aRBClass metaclass).
	self flushCaches
!

compile: aString in: aRBClass classified: aSymbol 
	| change |
	change := changes 
				compile: aString
				in: aRBClass
				classified: aSymbol.
	self flushCaches.
	^change
!

flushCaches
	implementorsCache := IdentityDictionary new.
	sendersCache := IdentityDictionary new
!

performChange: aCompositeRefactoryChange around: aBlock 
	| oldChanges |
	changes addChange: aCompositeRefactoryChange.
	oldChanges := changes.
	changes := aCompositeRefactoryChange.
	aBlock ensure: [changes := oldChanges].
	^aCompositeRefactoryChange
!

removeClassVariable: aString from: aRBClass 
	^changes removeClassVariable: aString from: aRBClass
!

removeInstanceVariable: aString from: aRBClass 
	^changes removeInstanceVariable: aString from: aRBClass
!

removeMethod: aSelector from: aRBClass 
	self flushCaches.
	^changes removeMethod: aSelector from: aRBClass
!

renameClassVariable: oldName to: newName in: aRBClass around: aBlock 
	^self performChange: (RenameClassVariableChange 
				rename: oldName
				to: newName
				in: aRBClass)
		around: aBlock
!

renameInstanceVariable: oldName to: newName in: aRBClass around: aBlock 
	^self performChange: (RenameInstanceVariableChange 
				rename: oldName
				to: newName
				in: aRBClass)
		around: aBlock
!

replaceClassNameIn: definitionString to: aSymbol 
	| parseTree |
	parseTree := RBParser parseExpression: definitionString.
	parseTree receiver: (RBVariableNode named: aSymbol).
	^parseTree formattedCode
! !

!RBNamespace methodsFor:'testing'!

hasRemoved: aSymbol 
	^removedClasses includes: aSymbol
!

includesClassNamed: aSymbol 
	^(self classNamed: aSymbol) notNil
!

includesGlobal: aSymbol 
	(self hasRemoved: aSymbol) ifTrue: [^false].
	(self includesClassNamed: aSymbol) ifTrue: [^true].
	environment at: aSymbol ifAbsent: [^false].
	^true
! !

!RBNamespace class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/helpers/RBNamespace.st,v 1.13 2014-04-03 09:51:17 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


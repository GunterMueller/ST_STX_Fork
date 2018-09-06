"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

VariableRefactoring subclass:#CreateAccessorsForVariableRefactoring
	instanceVariableNames:'getterMethod setterMethod classVariable needsReturn'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!CreateAccessorsForVariableRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk variable: aVarName class: aClass classVariable: aBoolean 
	^(self 
		model: aRBSmalltalk
		variable: aVarName
		class: aClass)
		classVariable: aBoolean;
		yourself
!

variable: aVarName class: aClass classVariable: aBoolean 
	^(self variable: aVarName class: aClass)
		classVariable: aBoolean; yourself
! !

!CreateAccessorsForVariableRefactoring methodsFor:'initialize-release'!

classVariable: aBoolean 
	classVariable := aBoolean
! !

!CreateAccessorsForVariableRefactoring methodsFor:'performing'!

variableAssociation
        ^self associationForClassVariable: variableName
                in: class
                ifAbsent: [self refactoringError: 'Variable not found']
!

writersFor: aClass 
        ^classVariable
                ifTrue: [aClass whichSelectorsReferTo: self variableAssociation]
                ifFalse: [aClass whichSelectorsWrite: variableName]
! !

!CreateAccessorsForVariableRefactoring methodsFor:'preconditions'!

preconditions
	^classVariable 
		ifTrue: [RBCondition definesClassVariable: variableName asSymbol in: class]
		ifFalse: [RBCondition definesInstanceVariable: variableName in: class]
! !

!CreateAccessorsForVariableRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' variable: '.
	variableName storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' classVariable: '.
	classVariable storeOn: aStream.
	aStream nextPut: $)
! !

!CreateAccessorsForVariableRefactoring methodsFor:'private-accessing'!

definingClass
	^classVariable ifTrue: [class metaclass] ifFalse: [class]
!

findGetterMethod
	| definingClass matcher |
	definingClass := self definingClass.
	matcher := ParseTreeSearcher getterMethod: variableName.
	^self possibleGetterSelectors detect: 
			[:each | 
			(self 
				checkClass: definingClass
				selector: each
				using: matcher) notNil 
				and: [(definingClass subclassRedefines: each) not]]
		ifNone: [nil]
!

findSetterMethod
	| definingClass matcher |
	definingClass := self definingClass.
	matcher := self needsReturnForSetter 
				ifTrue: [ParseTreeSearcher returnSetterMethod: variableName]
				ifFalse: [ParseTreeSearcher setterMethod: variableName].
	^self possibleSetterSelectors detect: 
			[:each | 
			(self 
				checkClass: definingClass
				selector: each
				using: matcher) notNil 
				and: [(definingClass subclassRedefines: each) not]]
		ifNone: [nil]
!

getterMethod
	^getterMethod
!

methodsReferencingVariable
	^classVariable 
		ifTrue: [self definingClass whichSelectorsReferToClassVariable: variableName]
		ifFalse: 
			[self definingClass whichSelectorsReferToInstanceVariable: variableName]
!

possibleGetterSelectors
	^self methodsReferencingVariable select: [:each | each numArgs == 0]
!

possibleSetterSelectors
	^self methodsReferencingVariable select: [:each | each numArgs == 1]
!

setterMethod
	^setterMethod
! !

!CreateAccessorsForVariableRefactoring methodsFor:'testing'!

needsReturnForSetter
	needsReturn isNil 
		ifTrue: 
			[needsReturn := self 
						usesAssignmentOf: variableName
						in: class
						classVariable: classVariable].
	^needsReturn
!

usesAssignmentOf: aString in: aClass classVariable: isClassVar 
        | matcher definingClass |
        matcher := ParseTreeSearcher new.
        matcher
                answer: false;
                matches: aString , ' := ``@object'
                        do: [:aNode :answer | answer or: [aNode isUsed]].

        definingClass := isClassVar ifTrue: [aClass nonMetaclass] ifFalse: [aClass].
        ^(definingClass withAllSubclasses , (isClassVar 
                                ifTrue: [definingClass metaclass withAllSubclasses]
                                ifFalse: [#()]) 
                detect: 
                        [:each | 
                        ((isClassVar 
                                ifTrue: [each whichSelectorsReferToClassVariable: aString]
                                ifFalse: [each whichSelectorsReferToInstanceVariable: aString]) detect: 
                                                [:sel | 
                                                self 
                                                        checkClass: each
                                                        selector: sel
                                                        using: matcher]
                                        ifNone: [nil]) notNil]
                ifNone: [nil]) notNil
! !

!CreateAccessorsForVariableRefactoring methodsFor:'transforming'!

createGetterAccessor
	getterMethod := self findGetterMethod.
	getterMethod isNil ifTrue: [getterMethod := self defineGetterMethod]
!

createSetterAccessor
	setterMethod := self findSetterMethod.
	setterMethod isNil ifTrue: [setterMethod := self defineSetterMethod]
!

defineGetterMethod
	| selector definingClass |
	definingClass := self definingClass.
	selector := self safeMethodNameFor: definingClass
				basedOn: variableName asString.
	definingClass 
		compile: ('<1s><n><t>^<2s>' expandMacrosWith: selector with: variableName)
		classified: #(#accessing).
	^selector
!

defineSetterMethod
	| selector definingClass string |
	definingClass := self definingClass.
	string := self needsReturnForSetter 
				ifTrue: ['<1s> anObject<n><t>^<2s> := anObject']
				ifFalse: ['<1s> anObject<n><t><2s> := anObject'].
	selector := self safeMethodNameFor: definingClass
				basedOn: variableName asString , ':'.
	definingClass 
		compile: (string expandMacrosWith: selector with: variableName)
		classified: #accessing.
	^selector
!

transform
	self
		createGetterAccessor;
		createSetterAccessor
! !

!CreateAccessorsForVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/CreateAccessorsForVariableRefactoring.st,v 1.10 2015-01-30 23:11:54 cg Exp $'
! !


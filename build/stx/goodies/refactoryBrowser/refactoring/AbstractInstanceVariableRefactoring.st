"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#AbstractInstanceVariableRefactoring
	instanceVariableNames:'accessorsRefactoring'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AbstractInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^RBCondition directlyDefinesInstanceVariable: variableName in: class
! !

!AbstractInstanceVariableRefactoring methodsFor:'private-accessing'!

accessorsRefactoring
	^accessorsRefactoring isNil 
		ifTrue: 
			[accessorsRefactoring := CreateAccessorsForVariableRefactoring 
						model: self model
						variable: variableName
						class: class
						classVariable: false]
		ifFalse: [accessorsRefactoring]
! !

!AbstractInstanceVariableRefactoring methodsFor:'transforming'!

abstractReferences
	| replacer |
	replacer := ParseTreeRewriter 
				variable: variableName
				getter: self accessorsRefactoring getterMethod
				setter: self accessorsRefactoring setterMethod.
	self 
		convertClasses: class withAllSubclasses
		select: 
			[:aClass | 
			(aClass whichSelectorsReferToInstanceVariable: variableName) reject: 
					[:each | 
					aClass == class and: 
							[each == self accessorsRefactoring getterMethod 
								or: [each == self accessorsRefactoring setterMethod]]]]
		using: replacer
!

createAccessors
	self performComponentRefactoring: self accessorsRefactoring
!

transform
	self createAccessors.
	self abstractReferences
! !

!AbstractInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AbstractInstanceVariableRefactoring.st,v 1.12 2004-06-28 07:23:19 ca Exp $'
! !

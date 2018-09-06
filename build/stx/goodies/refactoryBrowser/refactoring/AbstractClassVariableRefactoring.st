"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#AbstractClassVariableRefactoring
	instanceVariableNames:'accessorsRefactoring'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AbstractClassVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isMetaclass: class) not 
                & (RBCondition directlyDefinesClassVariable: variableName asSymbol in: class) 
                        & ((RBCondition withBlock: 
                                                [(#(#Object #Behavior #ClassDescription #Class) includes: class name) not]) 
                                        errorMacro: 'This refactoring does not work for Object, Behavior, ClassDescription, or Class')
! !

!AbstractClassVariableRefactoring methodsFor:'private-accessing'!

accessorsRefactoring
	^accessorsRefactoring isNil 
		ifTrue: 
			[accessorsRefactoring := CreateAccessorsForVariableRefactoring 
						model: self model
						variable: variableName asString
						class: class
						classVariable: true]
		ifFalse: [accessorsRefactoring]
! !

!AbstractClassVariableRefactoring methodsFor:'transforming'!

abstractClassReferences
	| replacer |
	replacer := ParseTreeRewriter 
				variable: variableName
				getter: self accessorsRefactoring getterMethod
				setter: self accessorsRefactoring setterMethod.
	self 
		convertClasses: class metaclass withAllSubclasses
		select: 
			[:aClass | 
			(aClass whichSelectorsReferToClassVariable: variableName) reject: 
					[:each | 
					aClass == class metaclass and: 
							[each == self accessorsRefactoring getterMethod 
								or: [each == self accessorsRefactoring setterMethod]]]]
		using: replacer
!

abstractInstanceReferences
	| replacer |
	replacer := ParseTreeRewriter 
				classVariable: variableName
				getter: self accessorsRefactoring getterMethod
				setter: self accessorsRefactoring setterMethod.
	self 
		convertClasses: class withAllSubclasses
		select: [:aClass | aClass whichSelectorsReferToClassVariable: variableName]
		using: replacer
!

createAccessors
	self performComponentRefactoring: self accessorsRefactoring
!

transform
	self createAccessors.
	self abstractInstanceReferences.
	self abstractClassReferences
! !

!AbstractClassVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AbstractClassVariableRefactoring.st,v 1.11 2004-06-18 08:15:20 ca Exp $'
! !

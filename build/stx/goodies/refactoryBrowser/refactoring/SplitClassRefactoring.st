"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#SplitClassRefactoring
	instanceVariableNames:'class instanceVariables newClassName referenceVariableName
		newClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!SplitClassRefactoring class methodsFor:'instance creation'!

class: class instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	^(self new)
		class: class
			instanceVariables: instVars
			newClassName: className
			referenceVariableName: newVariable;
		yourself
!

model: aRBSmalltalk class: class instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	^(self new)
		model: aRBSmalltalk;
		class: class
			instanceVariables: instVars
			newClassName: className
			referenceVariableName: newVariable;
		yourself
! !

!SplitClassRefactoring methodsFor:'initialize-release'!

class: aClass instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	class := self model classFor: aClass.
	instanceVariables := instVars.
	newClassName := className.
	referenceVariableName := newVariable
! !

!SplitClassRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isValidClassName: newClassName) 
                & (RBCondition isGlobal: newClassName in: self model) not 
                        & (RBCondition isValidInstanceVariableName: referenceVariableName for: class) 
                        & (RBCondition hierarchyOf: class definesVariable: referenceVariableName) 
                                        not 
                        & (RBCondition isGlobal: referenceVariableName in: self model) not 
                        & (RBCondition definesTemporaryVariable: referenceVariableName in: class) 
                                        not
! !

!SplitClassRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' instanceVariables: '.
	instanceVariables asArray storeOn: aStream.
	aStream
		nextPutAll: ' newClassName: #';
		nextPutAll: newClassName;
		nextPutAll: ' referenceVariableName: ''';
		nextPutAll: referenceVariableName;
		nextPutAll: ''')'
! !

!SplitClassRefactoring methodsFor:'private-transforming'!

abstractReferenceTo: each 
        | setterMethod replacer accessorRef getterMethod |
        accessorRef := CreateAccessorsForVariableRefactoring 
                                variable: each
                                class: newClass
                                classVariable: false.
        self performComponentRefactoring: accessorRef.
        getterMethod := accessorRef getterMethod.
        setterMethod := accessorRef setterMethod.
        replacer := ParseTreeRewriter 
                                variable: each
                                getter: getterMethod
                                setter: setterMethod
                                receiver: referenceVariableName.
        self 
                convertClasses: class withAllSubclasses
                select: [:aClass | aClass whichSelectorsReferToInstanceVariable: each]
                using: replacer.
        self performComponentRefactoring: (RemoveInstanceVariableRefactoring 
                                variable: each
                                class: class)
!

addClass
	self performComponentRefactoring: (AddClassRefactoring 
				model: self model
				addClass: newClassName
				superclass: Object
				subclasses: #()
				category: class category).
	newClass := self model classNamed: newClassName
!

addInstanceVariables
	instanceVariables do: 
			[:each | 
			self performComponentRefactoring: (AddInstanceVariableRefactoring 
						model: self model
						variable: each
						class: newClass)]
! !

!SplitClassRefactoring methodsFor:'transforming'!

abstractVariableReferences
	instanceVariables do: [:each | self abstractReferenceTo: each]
!

createNewClass
	self
		addClass;
		addInstanceVariables
!

createReference
	self performComponentRefactoring: (AddInstanceVariableRefactoring 
				variable: referenceVariableName
				class: class)
!

transform
	self
		createNewClass;
		createReference;
		abstractVariableReferences
! !

!SplitClassRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/SplitClassRefactoring.st,v 1.5 2004-06-18 08:14:43 ca Exp $'
! !

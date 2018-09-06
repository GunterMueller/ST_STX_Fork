"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#RenameClassVariableRefactoring
	instanceVariableNames:'newName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RenameClassVariableRefactoring class methodsFor:'instance creation'!

model: aRBSmalltalk rename: aVarName to: aName in: aClass 
	^(self new)
		model: aRBSmalltalk;
		rename: aVarName
			to: aName
			in: aClass;
		yourself
!

rename: aVarName to: aName in: aClass
	^self new
		rename: aVarName
		to: aName
		in: aClass
! !

!RenameClassVariableRefactoring methodsFor:'initialize-release'!

rename: aVarName to: aName in: aClass
	self variable: aVarName class: aClass.
	newName := aName
! !

!RenameClassVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isMetaclass: class) not 
                & (RBCondition isValidClassVarName: newName asString for: class) 
                        & (RBCondition definesClassVariable: variableName asString in: class) 
                        & (RBCondition hierarchyOf: class definesVariable: newName asString) not 
                        & (RBCondition isGlobal: newName asString in: self model) not
! !

!RenameClassVariableRefactoring methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' rename: ''';
		nextPutAll: variableName;
		nextPutAll: ''' to: ''';
		nextPutAll: newName;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream nextPut: $)
! !

!RenameClassVariableRefactoring methodsFor:'transforming'!

renameReferences
        | replacer subclasses replClass|

        RBParser isSmalltalkX ifTrue:[
            replClass := ParseTreeSourceRewriter
        ] ifFalse:[
            replClass := ParseTreeRewriter
        ].

        replacer := replClass 
                                rename: variableName
                                to: newName
                                handler: 
                                        [self 
                                                refactoringError: ('<1s> is already defined as a method or block temporary <n> variable in this class or one of its subclasses' 
                                                                expandMacrosWith: newName)].
        subclasses := class withAllSubclasses asSet.
        subclasses addAll: class metaclass withAllSubclasses.
        self 
                convertClasses: subclasses
                select: [:aClass | aClass whichSelectorsReferToClassVariable: variableName]
                using: replacer
!

transform
	class 
		renameClassVariable: variableName
		to: newName
		around: [self renameReferences]
! !

!RenameClassVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RenameClassVariableRefactoring.st,v 1.16 2004-06-18 08:15:28 ca Exp $'
! !

"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RestoringVariableRefactoring subclass:#RenameInstanceVariableRefactoring
	instanceVariableNames:'newName'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RenameInstanceVariableRefactoring class methodsFor:'instance creation'!

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

!RenameInstanceVariableRefactoring methodsFor:'initialize-release'!

rename: aVarName to: aName in: aClass
	self variable: aVarName class: aClass.
	newName := aName
! !

!RenameInstanceVariableRefactoring methodsFor:'performing'!

newVariableName
	^newName
! !

!RenameInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isValidInstanceVariableName: newName for: class) 
                & (RBCondition definesInstanceVariable: variableName in: class) 
                        & (RBCondition hierarchyOf: class definesVariable: newName) not 
                        & (RBCondition isGlobal: newName in: self model) not
! !

!RenameInstanceVariableRefactoring methodsFor:'printing'!

changeString
    ^ 'Rename %1 to %2 in %3' bindWith:variableName allBold with:newName with:class.
!

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

!RenameInstanceVariableRefactoring methodsFor:'transforming'!

renameReferences
        | replClass replacer |

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
        self 
                convertClasses: class withAllSubclasses
                select: [:aClass | aClass whichSelectorsReferToInstanceVariable: variableName]
                using: replacer
!

transform
	class 
		renameInstanceVariable: variableName
		to: newName
		around: [self renameReferences]
! !

!RenameInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RenameInstanceVariableRefactoring.st,v 1.18 2004-06-18 08:15:10 ca Exp $'
! !

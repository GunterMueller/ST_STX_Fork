"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RenameInstanceVariableRefactoring subclass:#RenameToInstanceVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!

!RenameToInstanceVariableRefactoring class methodsFor:'documentation'!

documentation     
"
    this is a new one: it renames a previously unknown or invalid variable
    to an instvar (the original RenameInstanceVariable Refactoring was onnly
    able to rename an existsing instVar into another existing one).
    This does not check the original for being a valid instVar.
    Can be used as an operation to auto-add missing variables.

    Author:
        cg
"
! !

!RenameToInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isValidInstanceVariableName: newName for: class) 
! !

!RenameToInstanceVariableRefactoring methodsFor:'transforming'!

transform
    self renameReferences
! !

!RenameToInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RenameToInstanceVariableRefactoring.st,v 1.1 2008-06-20 09:43:29 cg Exp $'
! !

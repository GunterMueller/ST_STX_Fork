"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#AddClassVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AddClassVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isMetaclass: class) not 
                & (RBCondition isValidClassVarName: variableName for: class) 
                        & (RBCondition hierarchyOf: class definesVariable: variableName asString) 
                                        not 
                        & (RBCondition isGlobal: variableName in: self model) not
! !

!AddClassVariableRefactoring methodsFor:'transforming'!

transform
	class addClassVariable: variableName
! !

!AddClassVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AddClassVariableRefactoring.st,v 1.10 2004-06-18 08:15:06 ca Exp $'
! !

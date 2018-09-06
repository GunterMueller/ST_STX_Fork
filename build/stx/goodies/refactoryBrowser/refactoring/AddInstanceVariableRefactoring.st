"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#AddInstanceVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!AddInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isValidInstanceVariableName: variableName for: class) 
                & (RBCondition hierarchyOf: class definesVariable: variableName) not 
                        & (RBCondition isGlobal: variableName in: self model) not
! !

!AddInstanceVariableRefactoring methodsFor:'transforming'!

transform
	class addInstanceVariable: variableName
! !

!AddInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AddInstanceVariableRefactoring.st,v 1.11 2004-06-18 08:14:34 ca Exp $'
! !

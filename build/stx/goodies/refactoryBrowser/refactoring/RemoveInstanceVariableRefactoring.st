"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#RemoveInstanceVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RemoveInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        | references |
        references := RBCondition hierarchyOf: class
                                referencesInstanceVariable: variableName.
        class realClass isNil 
                ifTrue: 
                        [references 
                                errorMacro: ('<1s> is referenced.' expandMacrosWith: variableName)]
                ifFalse: 
                        [references
                                errorMacro: ('<1s> is referenced.<n>Browse references?' 
                                                        expandMacrosWith: variableName);
                                errorBlock: 
                                                [self openBrowserOn: (BrowserEnvironment new instVarRefsTo: variableName
                                                                        in: class realClass)]].
        ^(RBCondition definesInstanceVariable: variableName asString in: class) 
                & references not
! !

!RemoveInstanceVariableRefactoring methodsFor:'transforming'!

transform
	class removeInstanceVariable: variableName
! !

!RemoveInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RemoveInstanceVariableRefactoring.st,v 1.11 2004-06-18 08:14:37 ca Exp $'
! !

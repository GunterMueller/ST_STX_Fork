"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RestoringVariableRefactoring subclass:#PushDownInstanceVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!PushDownInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        | references |
        references := RBCondition referencesInstanceVariable: variableName
                                in: class.
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
        ^(RBCondition definesInstanceVariable: variableName in: class) 
                & references not
! !

!PushDownInstanceVariableRefactoring methodsFor:'transforming'!

transform
	class removeInstanceVariable: variableName.
	class subclasses do: 
			[:each | 
			(each withAllSubclasses detect: 
					[:aClass | 
					(aClass whichSelectorsReferToInstanceVariable: variableName) isEmpty not]
				ifNone: [nil]) notNil 
				ifTrue: [each addInstanceVariable: variableName]]
! !

!PushDownInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/PushDownInstanceVariableRefactoring.st,v 1.11 2004-06-18 08:15:14 ca Exp $'
! !

"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

VariableRefactoring subclass:#RemoveClassVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!RemoveClassVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition isMetaclass: class) not 
                & (RBCondition definesClassVariable: variableName in: class) 
                        & (RBCondition withBlock: 
                                                [| block |
                                                block := 
                                                                [:each | 
                                                                (each whichSelectorsReferToClassVariable: variableName) isEmpty 
                                                                        ifFalse: 
                                                                                [class realClass isNil 
                                                                                        ifTrue: 
                                                                                                [self 
                                                                                                        refactoringError: ('<1s> is referenced.' expandMacrosWith: variableName)]
                                                                                        ifFalse: 
                                                                                                [self refactoringError: ('<1s> is referenced.<n>Browse references?' 
                                                                                                                        expandMacrosWith: variableName)
                                                                                                        with: 
                                                                                                                [((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX])
                                                                                                                 ifTrue:[
                                                                                                                     SystemBrowser browseClassRefsTo:variableName under:class realClass modificationsOnly:false
                                                                                                                 ] ifFalse:[
                                                                                                                     self 
                                                                                                                        openBrowserOn: (VariableEnvironment referencesToClassVariable: variableName
                                                                                                                                        in: class realClass)]]]]].
                                                class withAllSubclasses do: block.
                                                class metaclass withAllSubclasses do: block.
                                                true])
! !

!RemoveClassVariableRefactoring methodsFor:'transforming'!

transform
	class removeClassVariable: variableName
! !

!RemoveClassVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RemoveClassVariableRefactoring.st,v 1.10 2003-09-23 10:40:47 cg Exp $'
! !

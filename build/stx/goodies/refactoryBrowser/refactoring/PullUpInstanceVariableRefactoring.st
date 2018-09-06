"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

RestoringVariableRefactoring subclass:#PullUpInstanceVariableRefactoring
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!PullUpInstanceVariableRefactoring methodsFor:'preconditions'!

preconditions
        ^RBCondition withBlock: 
                        [(class hierarchyDefinesInstanceVariable: variableName) 
                                ifFalse: [self refactoringError: 'No subclass defines ' , variableName].
                        (class subclasses 
                                detect: [:each | (each directlyDefinesInstanceVariable: variableName) not]
                                ifNone: [nil]) notNil 
                                ifTrue: 
                                        [self 
                                                refactoringWarning: 'Not all subclasses have an instance variable named ''' 
                                                                , variableName , '''.'].
                        true]
! !

!PullUpInstanceVariableRefactoring methodsFor:'queries'!

shouldBeConfirmed
    "Return true, if the refactoring change should be confirmed
     before applying. Used to suppress confirming *trivial* changes
     but only iff `UserPreferences current confirmRefactorings` is true.

     CAUTION: If UserPreferences current confirmRefactorings is false,
              refactorings are *never* confirmed
    "
    ^false

    "Created: / 31-08-2015 / 11:01:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PullUpInstanceVariableRefactoring methodsFor:'transforming'!

transform
	class allSubclasses do: 
			[:each | 
			(each directlyDefinesInstanceVariable: variableName) 
				ifTrue: [each removeInstanceVariable: variableName]].
	class addInstanceVariable: variableName
! !

!PullUpInstanceVariableRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/PullUpInstanceVariableRefactoring.st,v 1.11 2003-09-23 10:40:27 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


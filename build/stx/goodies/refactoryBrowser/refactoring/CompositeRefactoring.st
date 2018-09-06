"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Refactoring subclass:#CompositeRefactoring
	instanceVariableNames:'refactorings'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!


!CompositeRefactoring methodsFor:'initialization'!

initialize
    super initialize.
    refactorings := OrderedCollection new.
!

refactorings:aCollection 
    |oldName|

    oldName := self printString.
    refactorings := aCollection.
    (model notNil and:[ model description = oldName ]) ifTrue:[
        model description:self printString
    ]
! !

!CompositeRefactoring methodsFor:'preconditions'!

preconditions
    "Preconditions are checked on the component refactorings."

    ^ RBCondition empty
! !

!CompositeRefactoring methodsFor:'printing'!

printOn:aStream 
    refactorings isEmpty ifTrue:[
        ^ super printOn:aStream
    ].
    refactorings first printOn:aStream
! !

!CompositeRefactoring methodsFor:'transforming'!

transform
    refactorings do:[:each | 
        self performComponentRefactoring:each
    ]
! !

!CompositeRefactoring class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/CompositeRefactoring.st,v 1.3 2009-12-08 10:28:54 cg Exp $'
! !

"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaTransition subclass:#PEGFsaEpsilonTransition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaEpsilonTransition methodsFor:'gt'!

gtName
    | gtName |
    gtName := '<eps>'.
    priority < 0 ifTrue: [ gtName := gtName, ',', priority asString ].
    ^ gtName
! !

!PEGFsaEpsilonTransition methodsFor:'modifications'!

decreasePriorityBy: value
    "
        My value has special semantics, when I have negative priority, all the reachable states and transitions should
        be decreased by that value.
        
        In case I am preceded by another epsilon with negative priority, I do not decrease my value, that would multiply
        the the negative priority effect....
    "
    ^ self
! !

!PEGFsaEpsilonTransition methodsFor:'set operations'!

intersection: anotherState
    ^ anotherState
! !

!PEGFsaEpsilonTransition methodsFor:'testing'!

isEpsilon
    ^ true
!

isEpsilonTransition
    ^ true
! !


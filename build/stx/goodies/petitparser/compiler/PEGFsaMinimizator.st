"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaMinimizator
	instanceVariableNames:'fsa joinDictionary'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaMinimizator methodsFor:'comparison'!

info: info equals: anotherInfo
    (info == anotherInfo) ifTrue: [ ^ true ].
    (info class == anotherInfo class) ifFalse: [ ^ false ].

    "	
        I suppose I don't if someone does not have the priority set.
        Please note that equals is used for minimization, so I try to
        be as liberal as possible to get as small automaton as possible.
    "
    (info hasPriority and: [anotherInfo hasPriority]) ifTrue: [ 	
        (info priority == anotherInfo priority) ifFalse: [ ^ false ].
    ].

    (info isFinal == anotherInfo isFinal) ifFalse: [ ^ false ].
    (info isFsaFailure == anotherInfo isFsaFailure) ifFalse: [ ^ false ].

    ^ true
!

state: state equals: anotherState
    (state == anotherState) ifTrue: [ ^ true ].
    (state class == anotherState class) ifFalse: [ ^ false ].
    
    (state isFinal = anotherState isFinal) ifFalse: [ ^ false ].

    (state stateInfos size == anotherState stateInfos size) ifFalse: [ ^ false ].
    state retvals do: [:retval |
        (self info: (state infoFor: retval) equals: (anotherState infoFor: retval ifAbsent: [ ^ false ])) ifFalse: [ ^ false ]
    ].


    (state transitions size == anotherState transitions size) ifFalse: [ ^ false ].
    anotherState transitions do: [ :anotherStateT | 
        (state transitions contains: [ :stateT | 
            (anotherStateT equals: stateT) or: [
                "this is condition for self reference" 
                (anotherStateT destination == anotherState) and: [ stateT destination == state ]	
            ] ] ) ifFalse: [ ^ false ]
    ].
    
    ^ true
! !

!PEGFsaMinimizator methodsFor:'joining'!

joinInfo: state with: anotherState
    self assert: state stateInfos size == anotherState stateInfos size.

    state stateInfos do: [ :si1 | 
        self assert: (anotherState stateInfos contains: [ :si2 | 
            si1 isFinal == si2 isFinal and: [ si1 isFsaFailure == si2 isFsaFailure  ]
        ])
    ]
!

joinName: state with: anotherState
    state name: state name asString, '+', anotherState name asString.
!

joinState: state with: anotherState
    self assert: state hasZeroPriorityOnly.
    self assert: anotherState hasZeroPriorityOnly.

    self joinName: state with: anotherState.
    self joinInfo: state with: anotherState.
    
! !

!PEGFsaMinimizator methodsFor:'minimization'!

minimize
    | pair |
    pair := fsa statePairs detect:  [ :p | self state: p first equals: p second ] ifNone: [ nil ].

    [ pair isNil not ] whileTrue: [ 
        "Join priorities, because equivalency of priorities does not follow from the `equals:` of states"
        self joinState: pair first with: pair second.
        fsa replace: pair second with: pair first.
        fsa mergeTransitions.

        pair := fsa statePairs detect: [ :p | self state: p first equals: p second ] ifNone: [ nil ].
 	].
!

minimize: anFsa
    fsa := anFsa.

    self minimize.
    fsa checkSanity.
    ^ fsa
! !


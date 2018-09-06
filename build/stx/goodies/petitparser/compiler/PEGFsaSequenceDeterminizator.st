"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaAbstractDeterminizator subclass:#PEGFsaSequenceDeterminizator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaSequenceDeterminizator methodsFor:'determinization'!

determinize
    super determinize.

    self markFailures.
    fsa removePriorities.
!

markFailures
    fsa finalStates do: [ :fs |
        | priority |
        priority := fs priority.
        fs reachableStates do: [ :rs |
            (rs hasPriority and: [ (rs priority > fs priority) and: [ rs isFinal not ] ]) ifTrue: [ 
                rs failure: true.
                rs final: true.
            ]
        ]
    ]
! !

!PEGFsaSequenceDeterminizator methodsFor:'joining'!

joinInfo: info with: anotherInfo into: newInfo
    (info hasEqualPriorityTo: anotherInfo) ifTrue: [ 
        newInfo final: (info isFinal or: [ anotherInfo isFinal ]).
        newInfo priority: info priority.	
        ^ self
    ].
    
    (info hasHigherPriorityThan: anotherInfo) ifTrue: [ 
 		newInfo priority: info priority.	
        newInfo failure: info isFsaFailure.
        newInfo final: info isFinal.
        ^ self
    ].

    newInfo priority: anotherInfo priority.
    newInfo failure: anotherInfo isFsaFailure.
    newInfo final: anotherInfo isFinal.
!

joinRetval: state with: anotherState into: newState
    "Different retvals cannot merge their info"
    self assert: (state hasDifferentRetvalThan: anotherState) not. 
    self assert: state retval == anotherState retval.
    
    newState retval: state retval.
!

joinState: state with: anotherState
    self assert: state isMultivalue not.
    self assert: anotherState isMultivalue not.
    
    ^ super joinState: state with: anotherState
!

joinTransitions: state with: anotherState into: newState
    self assert: newState isMultivalue not.
    
    newState hasPriority ifFalse: [ 
        newState transitions addAll: (state transitions collect: #copy).
        newState transitions addAll: (anotherState transitions collect: #copy).
        ^ self
    ].
    
    self assert: newState hasPriority.
    "This is a part when low priority branches are cut-out"
    (state priority == newState priority) ifTrue: [ 
        newState transitions addAll: (state transitions collect: #copy).
    ] ifFalse: [
        newState transitions addAll: (state transitions select: [ :t | t priority > newState priority ] thenCollect: #copy)
    ].

    (anotherState priority == newState priority) ifTrue: [ 
        newState transitions addAll: (anotherState transitions collect: #copy).
    ] ifFalse: [
        newState transitions addAll: (anotherState transitions select: [ :t | t priority > newState priority ] thenCollect: #copy)
    ].

    newState mergeTransitions.
! !


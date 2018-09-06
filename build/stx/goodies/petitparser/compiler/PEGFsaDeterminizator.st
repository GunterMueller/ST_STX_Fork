"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaAbstractDeterminizator subclass:#PEGFsaDeterminizator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaDeterminizator methodsFor:'checking'!

checkPriorities
    self assert: ((fsa states select: [ :s | s hasPriority  ]) allSatisfy: [ :s | s priority == 0 ]).
    self assert: (fsa allTransitions allSatisfy: [ :s | s priority == 0 ]).
! !

!PEGFsaDeterminizator methodsFor:'determinization'!

determinize
    self checkPriorities.
    super determinize.	
! !

!PEGFsaDeterminizator methodsFor:'joining'!

joinInfo: info with: anotherInfo into: newInfo
    "nothing to do"
!

joinRetval: state with: anotherState into: newState
    "Different retvals cannot merge their info"

    state retvalsAndInfosDo: [:retval :info |
        retval isNil ifFalse: [ 
            newState addInfo: info for: retval.
        ]
    ].

    anotherState retvalsAndInfosDo: [:retval :info |
        retval isNil ifFalse: [ 
            self assert: (newState retvals includes: retval) not.
            newState addInfo: info for: retval.
        ]
    ].
!

joinState: state with: anotherState
    self assert: state hasZeroPriorityOnly.
    self assert: anotherState hasZeroPriorityOnly.
    
    ^ super joinState: state with: anotherState
!

joinTransitions: state with: anotherState into: newState
    newState transitions addAll: (state transitions collect: #copy).
    newState transitions addAll: (anotherState transitions collect: #copy).
    ^ self
! !


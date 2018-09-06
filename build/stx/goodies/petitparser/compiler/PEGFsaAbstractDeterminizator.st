"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaAbstractDeterminizator
	instanceVariableNames:'fsa joinDictionary'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaAbstractDeterminizator class methodsFor:'as yet unclassified'!

new
    ^ self basicNew initialize
! !

!PEGFsaAbstractDeterminizator methodsFor:'accessing - keys'!

joinKey: key with: anotherKey
    ^ Set new
        addAll: key;
        addAll: anotherKey;
        yourself.
!

keyFor: state
    ^ joinDictionary keyAtIdentityValue: state ifAbsent: [ Set with: state ]
!

keyFor: state and: anotherState
    | key anotherKey |
    key := self keyFor: state.
    anotherKey := self keyFor: anotherState.
    
    ^ self joinKey: key with: anotherKey
! !

!PEGFsaAbstractDeterminizator methodsFor:'determinization'!

determinize
    | states |
"	fsa checkSanity."
    fsa removeEpsilons.
    fsa removeUnreachableStates.
    fsa mergeTransitions.
    
    states := fsa topologicalOrder asOrderedCollection.
    states do: [ :state |
        self determinizeState: state
    ].

    fsa states:	fsa startState reachableStates.
    
    fsa removeUnreachableStates.
    fsa mergeTransitions.
!

determinize: anFsa
    fsa := anFsa.
    joinDictionary := Dictionary new.
    
    self determinize.
    ^ fsa
!

determinizeOverlap: t1 second: t2 state: state
    |  t1Prime t2Prime tIntersection |
    self assert: (state transitions includes: t1).
    self assert: (state transitions includes: t2).
    
    tIntersection := self joinTransition: t1 with: t2.

    t1Prime := PEGFsaCharacterTransition new
                    destination: t1 destination;
                    characterSet: (t1 complement: t2);
                    yourself.
    t2Prime := PEGFsaCharacterTransition new
                    destination: t2 destination;
                    characterSet: (t2 complement: t1);
                    yourself.					
                                    
                                
    state removeTransition: t1.
    state removeTransition: t2.
    
    tIntersection isEmpty ifFalse: [ state addTransition: tIntersection  ].
    t1Prime isEmpty ifFalse: [ state addTransition: t1Prime ].
    t2Prime isEmpty ifFalse: [ state addTransition: t2Prime ].
!

determinizeState: state
    | pairs |

    pairs := state transitionPairs asOrderedCollection.

    [pairs isEmpty] whileFalse: [ 
        | pair |
        
        (joinDictionary size > 100) ifTrue: [ self error: 'Oh man, this is really big FSA. Are you sure you want to continue?' ].
        
        pair := pairs removeFirst.
        self assert:((pair first destination = pair second destination) not 
                    or: [pair first isPredicateTransition not 
                    or: [pair second isPredicateTransition not ] ]).
                
        self assert: (pair contains: #isEpsilon) not.		
                
        (pair first overlapsWith: pair second) ifTrue: [ 
            self determinizeOverlap: pair first second: pair second state: state.
            "recompute pairs after the determinization"
            pairs := state transitionPairs asOrderedCollection.
        ]
    ].
! !

!PEGFsaAbstractDeterminizator methodsFor:'initialization'!

initialize
    super initialize.
    joinDictionary := Dictionary new
! !

!PEGFsaAbstractDeterminizator methodsFor:'joining'!

joinName: state with: anotherState into: newState
    newState name: state name asString, '_', anotherState name asString.
!

joinState: state with: anotherState
    | key newState |
    key := self keyFor: state and: anotherState.
    (joinDictionary includesKey: key) ifTrue: [ ^ joinDictionary at: key ].
    
    newState := PEGFsaState new.
    joinDictionary at: key put: newState.

    self joinRetval: state with: anotherState into: newState.
    self joinInfo: state with: anotherState into: newState.
    self joinName: state with: anotherState into: newState.
    self joinTransitions: state with: anotherState into: newState.	

    self determinizeState: newState.
    
    self assert: ((joinDictionary at: key) == newState).
    ^ newState
!

joinTransition: t1 with: t2
    | newDestination newTransition |
    self assert: t1 isCharacterTransition.
    self assert: t2 isCharacterTransition.
    
    newDestination := self joinState: t1 destination with: t2 destination.
    
    newTransition := PEGFsaCharacterTransition new.
    newTransition destination: newDestination.
    newTransition characterSet: (t1 intersection: t2).
    newTransition priority: (t1 priority max: t2 priority).
    
    ^ newTransition 
! !


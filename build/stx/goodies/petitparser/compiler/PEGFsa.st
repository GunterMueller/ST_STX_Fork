"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsa
	instanceVariableNames:'states startState name distances priorities'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsa class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PEGFsa methodsFor:'accessing'!

allTransitions
    ^ self allTransitions: IdentitySet new
!

allTransitions: collection
    self states do: [ :s | collection addAll: s transitions  ].
    ^ collection
!

forwardTransitions
    | backTransitions |
    backTransitions := self backTransitions.
    ^ self allTransitions reject: [ :t | backTransitions includes: t ]
!

minPriority
    | priority |
"	defaultPriority := self states size negated.
    self finalStates isEmpty ifTrue: [ ^ defaultPriority ].
    
    ^ (self finalStates collect: [ :e | e priorityIfNone: defaultPriority  ]) min
"
    priority := -1.
    self allTransitions do: [ :t | t isEpsilon ifTrue: [ priority := priority + t priority ] ].
    ^ priority
!

name
    ^ name 
!

name: anObject
    
    name := anObject
!

retvals
    ^ (self finalStates flatCollect: [ :e | e retvals collect: #value ]) asIdentitySet
!

startState
    self assert: (states includes: startState).
    ^ startState
!

stateNamed: stateName
    ^ states detect: [ :e | e name = stateName ]
!

states
    ^ states
!

states: whatever
    states := whatever
!

transitionFrom: from to: to
    ^ from transitions detect: [ :t | t destination = to ]
!

transitionsFor: state
    self assert: (states includes: state).
    ^ state transitions
! !

!PEGFsa methodsFor:'analysis'!

backTransitions
    |  transitionSet |
    transitionSet := IdentitySet new.
    self computeDistances.
    
    self backTransitionsFrom: startState openSet: IdentitySet new transitionSet: transitionSet.
    ^ transitionSet
!

backTransitionsFrom: state openSet: openSet transitionSet: transitionSet
    (openSet includes: state) ifTrue: [  
        ^ self
    ].
    openSet add: state.
    
    state transitions do: [ :t | 
        ((openSet includes: t destination) and: [self is: state furtherThan: t destination]) ifTrue: [  
            transitionSet add: t		
        ].
        self backTransitionsFrom: t destination openSet: openSet copy transitionSet: transitionSet
    ]
!

computeDistances
    | queue openSet |
    distances := IdentityDictionary new.
    queue := OrderedCollection with: startState.
    openSet := IdentitySet new.

    distances at: startState put: 0.
    
    [ queue isEmpty not ] whileTrue: [ 
        | state |
        state := queue removeFirst.
        openSet add: state.
        
        state transitions do: [ :t |
            (openSet includes: (t destination)) ifFalse: [ 
                distances at: (t destination ) put: ((distances at: state) + 1).
                queue addLast: (t destination)
            ]
        ]
    ].

    ^ distances
!

computePriorities
    | queue openSet |
    self flag: 'not working...'.
    priorities := IdentityDictionary new.
    queue := OrderedCollection with: startState.
    openSet := IdentitySet new.

    priorities at: startState put: (startState priorityIfNone: 0).
    
    [ queue isEmpty not ] whileTrue: [ 
        | state |
        state := queue removeFirst.
        openSet add: state.
        
        state transitions do: [ :t |
            (openSet includes: (t destination)) ifFalse: [ 
                priorities at: (t destination ) put: ((priorities at: state) + t priority).
                queue addLast: (t destination)
            ]
        ]
    ].

    ^ priorities
!

epsilonDestinationsFrom: state
    | openSet |
    openSet := IdentitySet new.
    self epsilonDestinationsFrom: state openSet: openSet.
    ^ openSet
!

epsilonDestinationsFrom: state openSet: openSet
    (openSet includes: state) ifTrue: [ 
        ^ self 
    ].

    openSet add: state.
    
    ((self transitionsFor: state) select: [ :t | t isEpsilon ]) do: [ :t |
        self epsilonDestinationsFrom: t destination openSet: openSet
    ]
    
!

finalStates
    ^ self states select: [ :s | s isFinal ]
!

hasDistinctRetvals
    | finalStates retvals |
    finalStates := self finalStates.

    (finalStates anySatisfy: [ :s | s isMultivalue  ]) ifTrue: [ ^ false ].
    retvals := finalStates collect: [:s | s retval].

        
    (finalStates size == 1) ifTrue: [ ^ true ].


    (retvals asSet size == 1) ifTrue: [ ^ true ].
    "final states leads only to final states with the same retval"
    (finalStates allSatisfy: [ :s | 
        (self statesReachableFrom: s) allSatisfy: [ :rs | rs retval value isNil or: [ rs retval value == s retval value ] ]
    ]) ifTrue: [ ^ true ].
    
    ^ false
!

hasNoRetvals
    ^ self finalStates isEmpty
!

is: state furtherThan: anotherState

    ^ (distances at: state) >= (distances at: anotherState)
!

isBackTransition: t
    ^ self backTransitions includes: t
!

isWithoutPriorities
    ^ self states allSatisfy: [ :s | 
        s hasPriority not or: [ 
            s stateInfos allSatisfy: [ :i | i priority == 0 ]
        ] 
    ].
!

joinPoints
    ^ self joinTransitions collect: [ :t | t destination ]
!

joinTransitions
    | joinTransitions transitions  size |
    joinTransitions := IdentitySet new.

    transitions := self allTransitions asOrderedCollection.
    size := transitions size.

    
    (1 to: size - 1) do: [ :index1 |
        (index1 + 1 to: size)  do: [ :index2 | 
            ((transitions at: index1) destination == (transitions at: index2) destination) ifTrue: [ 
                joinTransitions add: (transitions at: index1).
                joinTransitions add: (transitions at: index2).
            ]
        ]
    ].

    ^ joinTransitions
!

minimumPriority
!

nonFinalStates
    ^ self states reject: [ :s | s isFinal ]
!

reachableStates
    ^ self statesReachableFrom: startState
!

statePairs
    |  pairs ordered |
    pairs := OrderedCollection new.
    ordered := self states asOrderedCollection.
    1 to: (ordered size - 1) do: [ :index1 |
        (index1 + 1) to: ordered size do: [ :index2 |
            pairs add: (PEGFsaPair with: (ordered at: index1) with: (ordered at: index2))
 		]
    ].

    self assert: (pairs allSatisfy: [ :e | e class == PEGFsaPair ]).
    ^ pairs
!

statesReachableFrom: state
    | openSet |
    self assert: state isNil not.
    
    openSet := IdentitySet new.
    self statesReachableFrom: state openSet: openSet.
    ^ openSet
!

statesReachableFrom: state openSet: openSet
    (openSet contains: [:e | e == state]) ifTrue: [ 
        ^ self 
    ].

    openSet add: state.
    
    (self transitionsFor: state) do: [ :t |
        self statesReachableFrom: t destination openSet: openSet
    ]
    
!

topologicalOrder
    | collection |
    collection := OrderedCollection new.
    
    self statesReachableFrom: startState openSet: collection.
    ^ collection
! !

!PEGFsa methodsFor:'comparing'!

= anotherFsa
    "
        Please note what the compare does. IMO nothing useful for now.
        
        For comparing if two FSA's are equivalent, use isIsomorphicTo:
    "

    (self == anotherFsa)  ifTrue: [ ^ true ].
    (self class == anotherFsa class) ifFalse: [ ^ false ].
    
    (startState = anotherFsa startState) ifFalse: [ ^ false ].
    (name = anotherFsa name) ifFalse: [ ^ false ].
    
    (states size = anotherFsa states size) ifFalse: [ ^ false ].
    states do: [:s |
        (anotherFsa states contains: [ :e | e = s ]) ifFalse: [ ^ false ].
    ].
    ^ true
!

hash
    ^ states hash bitXor: (startState hash bitXor: name hash)
!

isIsomorphicTo: anotherFsa
    | topologicalOrder anotherTopologicalOrder  |
    
    "
        Please not that this version of comparison is sensitive to the order
        in which the transitions in state are ordered.
    "
    
    topologicalOrder := self topologicalOrder.
    anotherTopologicalOrder := anotherFsa topologicalOrder.
    
    topologicalOrder size == anotherTopologicalOrder size ifFalse: [ ^ false ].
    
    topologicalOrder with: anotherTopologicalOrder do: [ :s1 :s2 |
        (s1 canBeIsomorphicTo: s2) ifFalse: [ ^ false ]
    ].
    
    ^ true
"	
    transitions := topologicalOrder flatCollect: [ :s | s transitions ].
    anotherTransitions := anotherTopologicalOrder flatCollect: [ :s | s transitions ].
"	
! !

!PEGFsa methodsFor:'copying'!

postCopy
    | map |
    super postCopy.
    
    map := IdentityDictionary new.
    states do: [ :s |
        map at: s put: s copy.
    ].
    
    states := map values asIdentitySet.
    startState isNil ifFalse: [ 
        startState := map at: startState.
    ].
    
    states do: [ :s |
        s transitions do: [:t |
            t destination: (map at: t destination)
        ]
    ]
! !

!PEGFsa methodsFor:'ids'!

defaultName
    ^ #fsa
!

hasName
    ^ name isNil not
!

prefix
    ^ 'scan'
!

suffix
    ^ nil
! !

!PEGFsa methodsFor:'initialization'!

initialize
    states := IdentitySet new.
! !

!PEGFsa methodsFor:'modifications'!

addState: state
    self assert: (states includes: state) not.
    states add: state
!

addTransitionFrom: fromState to: toState 
    | transition |
    self assert: (states includes: fromState).
    self assert: (states includes: toState).
    
    transition := PEGFsaEpsilonTransition new 
        destination: toState;
        priority: 0;
        yourself.
        
    fromState addTransition: transition.
!

addTransitionFrom: fromState to: toState on: character
    self addTransitionFrom: fromState to: toState on: character priority: 0
!

addTransitionFrom: fromState to: toState on: character priority: priority
    | transition |
    transition := PEGFsaCharacterTransition new 
        addCharacter: character;
        destination: toState;
        priority: priority;
        yourself.
        
    fromState addTransition: transition
!

addTransitionFrom: fromState to: toState onCharacterSet: characterSet
    self addTransitionFrom: fromState to: toState onCharacterSet: characterSet priority: 0
!

addTransitionFrom: fromState to: toState onCharacterSet: characterSet priority: priority
    | transition |
    transition := PEGFsaCharacterTransition new 
        characterSet: characterSet;
        destination: toState;
        priority: priority;
        yourself.

    fromState addTransition: transition
!

addTransitionFrom: fromState to: toState onPredicate: block priority: priority
    | transition |
    transition := PEGFsaPredicateTransition new 
        predicate: block;
        destination: toState;
        priority: priority;
        yourself.
        
    fromState addTransition: transition
!

addTransitionFrom: fromState to: toState priority: priority
    | transition |
    "should not use minus priority epsilons any more"
    self assert: (priority == 0).	
    self assert: (states includes: fromState).
    self assert: (states includes: toState).
    
    transition := PEGFsaEpsilonTransition new 
        destination: toState;
        priority: priority;
        yourself.
        
    fromState addTransition: transition.
!

adopt: fsa
    states addAll: fsa reachableStates.
!

decreasePriority
    ^ self decreasePriorityBy: 1
!

decreasePriorityBy: value
    self states select: [ :s | s hasPriority ] thenDo: [ :s |
        s decreasePriorityBy: value.
    ].

    self allTransitions do: [ :t |
        t decreasePriorityBy: value
    ]
!

finalState: state
    self assert: state isFinal not.
    state final: true.
    state priority: 0.
!

fixFinalStatePriorities
    self finalStates do: [ :s |
        s hasPriority ifFalse: [ s priority: 0 ]
    ]
!

minimize
    ^ PEGFsaMinimizator new minimize: self
!

removeFinals
    self finalStates do: [ :s |
        s final: false
    ]
!

removePriorities
    self states select: [ :s| s hasPriority ] thenDo: [ :s |
        s priority: 0
    ].

    self allTransitions do: [ :t |
        t priority: 0
    ]
!

removeState: state
    self assert: (states includes: state).
    states remove: state.
!

replace: state with: anotherState
    | transitions  |
    self assert: (state isKindOf: PEGFsaState).
    self assert: (anotherState isKindOf: PEGFsaState).
    
    transitions := self allTransitions.

    transitions do: [ :t |
        (t destination == state) ifTrue: [ 
            t destination: anotherState.
        ]
    ].

    state == startState ifTrue: [ startState := anotherState ].
    states remove: state.
    states add: anotherState.
!

retval: returnValue
    self finalStates do: [ :s |
        self assert: s retval isNil.
        s retval: returnValue
    ]
!

startState: state
    self assert: (states includes: state).
    
    startState := state
! !

!PEGFsa methodsFor:'modifications - determinization'!

determinize
    ^ PEGFsaSequenceDeterminizator new determinize: self.
!

determinize: joinDictionary
    self error: 'deprecated'.
    
    self removeEpsilons.
    self removeUnreachableStates.
    self removeLowPriorityTransitions.
    self mergeTransitions.
    
    
    states := self topologicalOrder asOrderedCollection.
    
    states do: [ :state |
        state determinize: joinDictionary.
    ].
    
    states	 := startState reachableStates.

    self removeUnreachableStates.
    self removeLowPriorityTransitions.
    self mergeTransitions.
    
!

determinizeChoice
    ^ PEGFsaChoiceDeterminizator new determinize: self.
!

determinizeStandard
    ^ PEGFsaDeterminizator new determinize: self.
! !

!PEGFsa methodsFor:'modifications - epsilons'!

removeEpsilonTransition: transition source: state
    ^ self removeEpsilonTransition: transition source: state openSet: IdentitySet new
!

removeEpsilonTransition: transition source: source openSet: openSet
    | destination |
    (openSet includes: transition) ifTrue: [ self error: 'loop in epsilons?!!' ].
    openSet add: transition.
    
    destination := transition destination.
    
    "First Remove Recursively"
    ((self transitionsFor: destination ) select: [ :t | t isEpsilon  ]) do: [ :t |
        self removeEpsilonTransition: t source: destination openSet: openSet
    ].

    self assert: transition isEpsilon.
    self assert: transition priority = 0.
    
    (destination transitions) do: [ :t |
        source addTransition: (t copy)
    ].

    source mergeInfo: destination into: source.

    destination isFinal ifTrue: [ 
        source final: true.
        source retval: destination retval.
    ].

    source removeTransition: transition.
!

removeEpsilons
    "First, remove the negative values from epsilons"
    self removeNegativeEpsilons.
    
    states do: [ :state |
        self removeEpsilonsFor: state
    ]
!

removeEpsilonsFor: state
    (self transitionsFor: state) copy do: [ :t |
        (t isEpsilon and: [ t destination isStub not ]) ifTrue: [ 
            self removeEpsilonTransition: t source: state
        ]
    ]
!

removeNegativeEpsilonTransition: transition source: state
    ^ self removeNegativeEpsilonTransition: transition source: state openSet: IdentitySet new
!

removeNegativeEpsilonTransition: transition source: source openSet: openSet
    | destination |
    (openSet includes: transition) ifTrue: [ self error: 'loop in epsilons?!!' ].
    openSet add: transition.
    
    destination := transition destination.
    
    "First Remove Recursively"
    ((self transitionsFor: destination ) select: [ :t | t isEpsilon  ]) do: [ :t |
        self removeNegativeEpsilonTransition: t source: destination openSet: openSet
    ].
    
    "JK: Problem alert: if two different epsilons point to the same state,
        it will decreas the state priority two times!! I don't know how to handle
        this situation properly and I make sure during FSA generation that there
        are no two paths to one state (except for loops).
    "
    (self statesReachableFrom: destination) do: [ :s |
        s decreasePriorityBy: transition priority abs.
        s transitions do: [ :t | t decreasePriorityBy: transition priority abs  ]
    ].

    transition priority: 0.
!

removeNegativeEpsilons
    "
        This will remove only negative values from epsilons, the epsilons itself will not
        be removed!!
    "
    states do: [ :state |
        self removeNegativeEpsilonsFor: state
    ]
!

removeNegativeEpsilonsFor: state
    (self transitionsFor: state) copy do: [ :t |
        t isEpsilon ifTrue: [ 
            self removeNegativeEpsilonTransition: t source: state
        ]
    ]
! !

!PEGFsa methodsFor:'printing'!

asString
    | stream  |
    stream := WriteStream on: ''.
    
    self topologicalOrder do: [ :state |
        state printOn: stream.
        stream nextPutAll: '> '.
        
        (self transitionsFor: state) do: [ :transition |
            stream nextPut: (Character codePoint: 13).
            stream nextPut: (Character codePoint: 9).
            transition printOn: stream.
        ].
        stream nextPut: (Character codePoint: 13).
    ].
    
"	stream nextPutAll: 'finals: '.
    (states select: [:s | s isFinal ]) do: [:e | e printOn: stream ].
    stream nextPut: (Character codePoint: 13).
"
    ^ stream contents.
! !

!PEGFsa methodsFor:'testing'!

canHavePPCId
    ^ true
!

checkConsistency
    self assert: (states includes: startState).
    
    states do: [ :s | s transitions do: [ :t |
        self assert: (states includes: t destination).
    ] ].
    ^ true
!

checkFinalStatesPriorities
    self assert: (self finalStates allSatisfy: #hasPriority)
!

checkSanity
    self checkConsistency.
    self checkTransitionsIdentity.
    self checkTransitionsPriority.
    self checkFinalStatesPriorities.
!

checkTransitionsIdentity
    | bag set |
    bag := IdentityBag new.
    set := IdentitySet new.
    bag := self allTransitions: bag.
    set := self allTransitions: set.	
    
    self assert: bag size == set size.
!

checkTransitionsPriority
    self finalStates do: [ :fs |
        fs isMultivalue ifFalse: [ 
            fs transitions allSatisfy: [ :t | fs priority >= t priority ]
        ]
    ]
!

isDeterministic
    self reachableStates do: [ :state |
        state transitionPairs do: [ :pair | 
            ((pair first intersection: pair second) includes: true) ifTrue: [ 					
                ^ false
            ] 
        ]
    ].
    ^ true
!

isReachableState: state
    ^ self reachableStates includes: state
!

isStartState: state
    ^ startState == state
!

isWithoutEpsilons
    self reachableStates do: [ :state | 
        state transitions do: [ :t | 
            t isEpsilon ifTrue: [ ^ false ]
        ]
    ].
    ^ true
! !

!PEGFsa methodsFor:'transformations'!

compact
    self error: 'deprecated?'
!

mergeTransitions
    |  |
    self reachableStates do: [ :state |
        state mergeTransitions.
    ]
!

removeLowPriorityTransitions
    states do: [ :state |
        self removeLowPriorityTransitionsFor: state
    ]
!

removeLowPriorityTransitionsFor: state
    | transitions |
    state hasPriority ifFalse: [ ^ self ].
    state isFinal ifFalse: [ ^ self ].
    "TODO JK: I can probably cut some transitions from multivalu as well"
    state isMultivalue ifTrue: [ ^ self ].

    transitions := state transitions copy.
    transitions do: [ :t |
        (t priority < state priority) ifTrue: [ 
            state removeTransition: t
        ]
    ]
!

removeUnreachableStates
    | reachable toRemove |
    reachable := self reachableStates.
    toRemove := OrderedCollection new.

    states do: [ :s |
        (reachable includes: s) ifFalse: [ 
            toRemove add: s		
        ]
    ].

    toRemove do: [ :s | states remove: s ]
! !


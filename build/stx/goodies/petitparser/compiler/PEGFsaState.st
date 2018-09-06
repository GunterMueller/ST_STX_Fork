"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaState
	instanceVariableNames:'name infos transitions'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaState class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PEGFsaState class methodsFor:'as yet unclassified'!

named: aName
    ^ self new
        name: aName;
        yourself
! !

!PEGFsaState methodsFor:'accessing'!

destination
    self assert: transitions size = 1.
    ^ transitions anyOne destination
!

destinations
    ^ (transitions collect: #destination) asIdentitySet
!

failure: boolean
    self info failure: boolean
!

final
    ^ self info final
!

final: boolean
    self info final: boolean
!

infoFor: retval
    ^ infos at: retval
!

infoFor: retval ifAbsent: block
    ^ infos at: retval ifAbsent: block
!

isFsaFailure
    ^ self isFinal and: [ self info isFsaFailure ]
!

name
    ^ name
!

name: anObject
    name := anObject asString
!

priority
    ^ self info priority
!

priority: anObject
    self info priority: anObject
!

priorityFor: retval
    ^ (self infoFor: retval) priority
!

priorityIfNone: value
    ^ self hasPriority ifTrue: [ self priority ] ifFalse: [ value ]
!

retval
    self assert: self isMultivalue not.
    ^ infos keys anyOne
!

retval: anObject
    | info |
    info := self info.
    infos removeAll.
    infos at: anObject put: info.
!

retvalAsCollection
    ^ infos keys
!

retvals
    ^ infos keys
!

retvalsAndInfosDo: twoArgBlock
 	infos keysAndValuesDo: twoArgBlock
!

stateInfos
    ^ infos values
!

transition
    self assert: transitions size == 1.
    ^ transitions anyOne 
!

transitions
    ^ transitions
! !

!PEGFsaState methodsFor:'analysis'!

collectNonEpsilonTransitionsOf: state to: collection
    state transitions do: [ :t | 
        t isEpsilon ifTrue: [ 
            self collectNonEpsilonTransitionsOf: t destination to: collection
        ] ifFalse: [ 
            collection add: t
        ]
    ].
    ^ collection
!

nonEpsilonTransitionPairs
    | size pairs collection |
    pairs := OrderedCollection new.
    
    collection := OrderedCollection new.
    self collectNonEpsilonTransitionsOf: self to: collection.
    size := collection size.

    1 to: (size - 1) do: [ :index1 |
        (index1 + 1 to: size) do: [ :index2 | 
            pairs add: (PEGFsaPair 
                with: (collection at: index1)
                with: (collection at: index2)).
        ]
    ].
    ^ pairs
!

reachableStates
    | openSet |
    openSet := IdentitySet new.
    self reachableStatesOpenSet: openSet.
    ^ openSet
!

reachableStatesOpenSet: openSet
    (openSet includes: self) ifTrue: [ 
        ^ self 
    ].

    openSet add: self.
    
    (self transitions) do: [ :t |
        t destination reachableStatesOpenSet: openSet
    ].
    
!

transitionPairs
    | size pairs collection |
    size := transitions size.
    pairs := OrderedCollection new.
    
    collection := transitions asOrderedCollection.

    1 to: (size - 1) do: [ :index1 |
        (index1 + 1 to: size) do: [ :index2 | 
            pairs add: (PEGFsaPair 
                with: (collection at: index1)
                with: (collection at: index2)).
        ]
    ].
    ^ pairs
! !

!PEGFsaState methodsFor:'comparing'!

= anotherState
    (self == anotherState) ifTrue: [ ^ true ].
    (self class == anotherState class) ifFalse: [ ^ false ].
    
    (name == anotherState name) ifFalse: [ ^ false ].

    (self stateInfos size == anotherState stateInfos size) ifFalse: [ ^ false ].
    self retvals do: [:retval |
        ((self infoFor: retval) = (anotherState infoFor: retval  ifAbsent: [ ^ false ])) ifFalse: [ ^ false ]
    ].

    (transitions size = anotherState transitions size) ifFalse: [ ^ false ].
    transitions do: [:t |
        (anotherState transitions contains: [:at | at = t]) ifFalse: [ ^ false ].
    ].
    
    ^ true
!

canBeIsomorphicTo: anotherState
    (name == anotherState name) ifFalse: [ ^ false ].
    (transitions size == anotherState transitions size) ifFalse: [ ^ false ].

    (self stateInfos size == anotherState stateInfos size) ifFalse: [ ^ false ].
    self retvals do: [:retval |
        ((self infoFor: retval) = (anotherState infoFor: retval ifAbsent: [ ^ false ])) ifFalse: [ ^ false ]
    ].
    
    ^ true
!

equals: anotherState
    self error: 'deprecated'.
    "
        JK: there is a bit mess between equals, isomorphic and =
        
        JK: I should clean it, but the idea behind is:
            - for minimization, I use equals 
            - for comparing, I use canBeIsomorphicTo: (because it can handle nested structures)
            - I have no idea, why I override =     O:)
    "

    (self == anotherState) ifTrue: [ ^ true ].
    (self class == anotherState class) ifFalse: [ ^ false ].
    
    (self isFinal = anotherState isFinal) ifFalse: [ ^ false ].

    (self stateInfos size == anotherState stateInfos size) ifFalse: [ ^ false ].
    self retvals do: [:retval |
        ((self infoFor: retval) equals: (anotherState infoFor: retval ifAbsent: [ ^ false ])) ifFalse: [ ^ false ]
    ].

    (transitions size == anotherState transitions size) ifFalse: [ ^ false ].
    anotherState transitions do: [ :t | 
        (transitions contains: [ :e | e equals: t]) ifFalse: [ ^ false ]
    ].
    
    ^ true
!

hash
    "JK: Size is not the best option here, but it one gets infinite loops otherwise"
    ^ infos hash bitXor: transitions size hash
!

isIsomorphicTo: anotherState resolvedSet: set
    self error: 'depracated?'.
    (self == anotherState) ifTrue: [ ^ true ].
    
"	(name == anotherState name) ifFalse: [ ^ false ].
    (priority == anotherState priority) ifFalse: [ ^ false ].
    (multivalue == anotherState isMultivalue) ifFalse: [ ^ false ].
    (retval = anotherState retval) ifFalse: [ ^ false ].
    (final = anotherState final) ifFalse: [ ^ false ].
"
    (transitions size = anotherState transitions size) ifFalse: [ ^ false ].
    transitions do: [:t |
        (anotherState transitions contains: [:at | t isIsomorphicto: at]) ifFalse: [ ^ false ].
    ].
    
    ^ true
! !

!PEGFsaState methodsFor:'copying'!

postCopy
    | newInfos |
    super postCopy.
    transitions := (transitions collect: [ :t | t copy ]).
    
    newInfos := IdentityDictionary new.
    infos keysAndValuesDo: [ :key :value | 
        newInfos at: key put: value copy
    ].

    infos := newInfos.
! !

!PEGFsaState methodsFor:'gt'!

gtName
    |  gtStream |
    gtStream := '' writeStream.
    self printNameOn: gtStream.
    
    self hasPriority ifTrue: [ 
        self retvalsAndInfosDo: [ :retval :info | 
            gtStream nextPut: (Character codePoint: 13). 
            gtStream nextPutAll: retval asString.
            gtStream nextPutAll: '->'.
            info printOn: gtStream. 
        ].
    ].

    ^ gtStream contents trim
! !

!PEGFsaState methodsFor:'ids'!

defaultName
    ^ #state
!

hasName
    ^ name isNil not
!

prefix
    ^ nil
!

suffix
    ^ nil
! !

!PEGFsaState methodsFor:'infos'!

info
    self assert: infos size = 1.
    ^ infos anyOne
! !

!PEGFsaState methodsFor:'initialization'!

initialize
    super initialize.
    
    transitions := OrderedCollection new.

    infos := IdentityDictionary new.
    infos at: nil put: PEGFsaStateInfo new.
! !

!PEGFsaState methodsFor:'modifications'!

addInfo: info for: retval
    infos removeKey: nil ifAbsent: [ "not a big deal" ].
    infos at: retval put: info
!

addTransition: t
    self assert: (transitions identityIncludes: t) not.
    transitions add: t
!

decreasePriority
    self decreasePriorityBy: 1.
!

decreasePriorityBy: value
    (self isFinal and: [ self hasPriority not ]) ifTrue: [ 
        self error: 'Final States Should have priority!!'
    ].

    self priority isNil ifFalse: [ 
        self priority: self priority - value
    ]
!

join: state
    ^ self join: state joinDictionary: Dictionary new
!

mergeInfo: state into: newState
    self info merge: state info into: newState info.
!

mergeTransitions
    | toRemove |
    toRemove := OrderedCollection new.
    self transitionPairs do:[ :pair | 
        (pair first destination = pair second destination) ifTrue: [ 
            (pair first isPredicateTransition not and: [pair second isPredicateTransition not]) ifTrue: [ 
                pair first mergeWith: pair second.
                toRemove add: pair second.
            ]
        ]
    ].

    toRemove do: [ :t |
        self removeTransition: t
    ]
!

removeTransition: t
    self assert: (transitions includes: t).
    transitions remove: t
! !

!PEGFsaState methodsFor:'modifications - determinization'!

determinize
    ^ PEGFsaAbstractDeterminizator new determinizeState: self
!

join: state joinDictionary: dictionary
    | pair newState |
    self error: 'deprecated'.
    pair := PEGFsaPair with: self with: state.
    (dictionary includesKey: pair) ifTrue: [ ^ dictionary at: pair ].
    
    newState := PEGFsaState new.
    
    dictionary at: pair put: newState.

    self joinRetval: state into: newState.
    self joinName: state into: newState.
    self joinTransitions: state into: newState.	

    newState determinize: dictionary.
    
    ^ dictionary at: pair put: newState
!

joinInfo: state into: newState
    self info join: state info into: newState info.
!

joinName: state into: newState
    newState name: self name asString, '_', state name asString.
!

joinRetval: state into: newState
    "Different retvals cannot merge their info"
    (self hasDifferentRetvalThan: state) ifTrue: [  
        newState addInfo: self info for: self retval.
        newState addInfo: state info for: state retval.
        ^ self
    ].


    (self hasHigherPriorityThan: state) ifTrue: [ 
        newState retval: self retval	
    ].

    (state hasHigherPriorityThan: self) ifTrue: [ 
        newState retval: state retval	
    ].

    (state priority == self priority) ifTrue: [ 
        self hasRetval ifTrue: [newState retval: self retval].
        state hasRetval ifTrue: [newState retval: state retval].
    ].

    self joinInfo: state into: newState.
!

joinTransitions: state into: newState
    newState isMultivalue ifTrue: [ 
        newState transitions addAll: (self transitions collect: #copy).
        newState transitions addAll: (state transitions collect: #copy).
        ^ self
    ].
    
    newState hasPriority ifFalse: [ 
        newState transitions addAll: (self transitions collect: #copy).
        newState transitions addAll: (state transitions collect: #copy).
        ^ self
    ].

    
    self assert: newState hasPriority.
    
    "This is a part when low priority branches are cut"
    (self priority == newState priority) ifTrue: [ 
        newState transitions addAll: (self transitions collect: #copy).
    ] ifFalse: [
        newState transitions addAll: (self transitions select: [ :t | t priority > newState priority ] thenCollect: #copy)
    ].

    (state priority == newState priority) ifTrue: [ 
        newState transitions addAll: (state transitions collect: #copy).
    ] ifFalse: [
        newState transitions addAll: (state transitions select: [ :t | t priority > newState priority ] thenCollect: #copy)
    ].
! !

!PEGFsaState methodsFor:'printing'!

printNameOn: aStream
    self name isNil
        ifTrue: [ aStream print: self hash ]
        ifFalse: [ aStream nextPutAll: self name ]
!

printOn: aStream
    super printOn: aStream.
    aStream nextPut: $(.
    self printNameOn: aStream.
    aStream nextPut: Character space.
    aStream nextPutAll: self identityHash asString.

    self retvalsAndInfosDo: [ :retval :info | 
        retval printOn: aStream.
        aStream nextPutAll: '->'.
        info printOn: aStream.
        aStream nextPutAll: ';'.
    ].

    aStream nextPut: $)
! !

!PEGFsaState methodsFor:'testing'!

canHavePPCId
    ^ true
!

hasDifferentRetvalThan: anotherState
    "returns true only if both hav retval and both retvals are different"
    self hasRetval ifFalse: [ ^ false ].	
    anotherState hasRetval ifFalse: [ ^ false ].

    "`retval value` is called in order to obtain retval from FsaFailure (if any)"
    ^ (self retval value == anotherState retval value) not
!

hasEqualPriorityTo: state
    ^ self info hasEqualPriorityTo: state info
!

hasHigherPriorityThan: state
    ^ self info hasHigherPriorityThan: state info
!

hasPriority
    ^ self stateInfos anySatisfy: [ :info | info hasPriority ]
!

hasRetval
    ^ self retval isNil not
!

hasZeroPriorityOnly
    ^ self stateInfos allSatisfy: [ :si | si hasPriority not or: [ si priority == 0 ] ].
!

isFailure
    self flag: 'JK, please check it and fix it'.
    "`retval` is undefined, nowehere initialized so the
     comparison is alway false. Therefore, returning 
     false unconditionally from here should suffice."
    ^ self isFinal and: [ "retval class == PEGFsaFailure"false ].
    

    "Modified: / 17-08-2015 / 12:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFinal
    ^ self stateInfos anySatisfy: [ :info | info isFinal ].
!

isMultivalue
    ^ infos size > 1
!

isStub
    ^ false
! !

!PEGFsaState methodsFor:'transformation'!

joinFinal: state newState: newState
    (self hasEqualPriorityTo: state) ifTrue: [ 
        ^ newState final: (self isFinal or: [ state isFinal ]).
    ].

    (self hasHigherPriorityThan: state) ifTrue: [  
        ^ newState final: self isFinal.
    ].
    
    newState final: state isFinal.
    
!

joinName: state newState: newState
    newState name: self name asString, '-', state name asString.
!

joinPriority: state newState: newState
    (self hasHigherPriorityThan: state) ifTrue: [ 
 		newState priority: self priority.	
        ^ self
    ].

    newState priority: state priority.
!

joinRetval: state newState: newState
    self isFinal ifFalse: [ ^ newState retval: state retval ].
    state isFinal ifFalse: [ ^ newState retval: self retval ].

    (self priority = state priority) ifTrue: [ 
        ^ newState retval: { self retval . state retval }.
    ].

    "Both are final"
    self priority isNil ifTrue: [ 
        ^ newState retval: state retval.
    ].

    state priority isNil ifTrue: [ 
        ^ newState retval: self retval.
    ].

    (self priority > state priority) ifTrue: [ 
        ^ newState retval: self retval.
    ].

    ^ newState retval: state retval.
! !


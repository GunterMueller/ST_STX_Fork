"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaStateInfo
	instanceVariableNames:'priority final failure'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!


!PEGFsaStateInfo methodsFor:'accessing'!

failure
    ^ failure
!

failure: anObject
    failure := anObject
!

final
    ^ final
!

final: anObject
    final := anObject
!

priority
    ^ priority
!

priority: anObject
    priority := anObject
! !

!PEGFsaStateInfo methodsFor:'comparing'!

= anotherInfo
    (self == anotherInfo) ifTrue: [ ^ true ].
    (self class == anotherInfo class) ifFalse: [ ^ false ].
    
    (priority == anotherInfo priority) ifFalse: [ ^ false ].

    (self isFinal == anotherInfo isFinal) ifFalse: [ ^ false ].

    ^ true
!

equals: anotherInfo
    self error: 'deprecated'.
    (self == anotherInfo) ifTrue: [ ^ true ].
    (self class == anotherInfo class) ifFalse: [ ^ false ].

    "	
        I suppose I don't if someone does not have the priority set.
        Please note that equals is used for minimization, so I try to
        be as liberal as possible to get as small automaton as possible.
    "
    (self hasPriority and: [anotherInfo hasPriority]) ifTrue: [ 	
        (priority == anotherInfo priority) ifFalse: [ ^ false ].
    ].

    (self isFinal == anotherInfo isFinal) ifFalse: [ ^ false ].

    ^ true
! !

!PEGFsaStateInfo methodsFor:'modifications - determinization'!

join: info into: newInfo
    self error: 'deprecated'.
    "
        The diff between JOIN and Merge:
        - join is used while determinizing the FSA
        - merge is used when removing epsilons
    "

    (self hasEqualPriorityTo: info) ifTrue: [ 
        newInfo final: (self isFinal or: [ info isFinal ]).
 		newInfo priority: self priority.	
        ^ self
    ].
    
    (self hasHigherPriorityThan: info) ifTrue: [ 
 		newInfo priority: self priority.	
        newInfo final: self isFinal.
        ^ self
    ].

    newInfo priority: info priority.
    newInfo final: info isFinal.
! !

!PEGFsaStateInfo methodsFor:'printing'!

printOn: aStream
    priority isNil ifFalse: [ 
        priority printOn: aStream.
        aStream nextPutAll: ', '	
    ].

    self isFinal ifTrue: [ 
        aStream nextPutAll: 'FINAL'.
        aStream nextPutAll: ', '	
    ].

    self isFsaFailure ifTrue: [ 
        aStream nextPutAll: 'FAILURE'
    ].
! !

!PEGFsaStateInfo methodsFor:'testing'!

hasEqualPriorityTo: stateInfo
    "nil - nil"
    (self hasPriority not and: [stateInfo hasPriority not]) ifTrue: [ ^ true ].
    
    "nil - priority"
    (self hasPriority) ifFalse: [ ^ false ].
    
    "priority - nil"
    stateInfo hasPriority ifFalse: [ ^ false ].
    
    "priority - priority"
    ^ self priority = stateInfo priority 
!

hasHigherPriorityThan: stateInfo
    "nil - nil"
    (self hasPriority not and: [stateInfo hasPriority not]) ifTrue: [ ^ true ].
    
    "nil - priority"
    (self hasPriority) ifFalse: [ ^ false ].
    
    "priority - nil"
    stateInfo hasPriority ifFalse: [ ^ true ].
    
    "priority - priority"
    ^ self priority > stateInfo priority 
!

hasPriority
    ^ self priority isNil not
!

isBlank
    ^ self hasPriority not and: [ self isFinal not ]
!

isFinal
    final isNil ifTrue: [ ^ false ].
    ^ final
!

isFsaFailure
    failure isNil ifTrue: [ ^ false ].
    ^ failure
! !

!PEGFsaStateInfo methodsFor:'transformation'!

merge: info into: newInfo
    "
        The diff between JOIN and Merge:
        - join is used while determinizing the FSA
        - merge is used when removing epsilons
    "

    "final - final"
    (self isFinal and: [info isFinal]) ifTrue: [ 
        newInfo final: true.
        (self hasHigherPriorityThan: info) ifTrue: [  
            newInfo priority: self priority.
        ] ifFalse: [  
            newInfo priority: info priority.
        ].
        "
            This has its reason: when moving from failure to non-failure
            using the epsilon, just keep the latter:
        "
        newInfo failure: info isFsaFailure.
        ^ self
 	].

    "final - non final"
    (self isFinal) ifTrue: [ 
        newInfo final: true.
        newInfo priority: self priority.
        newInfo failure: self isFsaFailure.
        ^ self
    ].

    "non final - final"
    (info isFinal) ifTrue: [ 
        newInfo final: true.
        newInfo priority: info priority.
        newInfo failure: info isFsaFailure.
        ^ self
    ].
    
    "non final - non final"
 	newInfo priority: self priority.	
    (self hasHigherPriorityThan: info) ifTrue: [  
        newInfo priority: self priority.
    ] ifFalse: [  
        newInfo priority: info priority.
    ].
    newInfo failure: info isFsaFailure.
! !

!PEGFsaStateInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


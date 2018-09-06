"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaAbstractDeterminizator subclass:#PEGFsaChoiceDeterminizator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaChoiceDeterminizator methodsFor:'as yet unclassified'!

determinize
    super determinize.

    fsa removeLowPriorityTransitions.
    fsa removeUnreachableStates.
    fsa removePriorities.
!

joinInfo: info with: anotherInfo into: newInfo
    "Merging into the failure"
    (info isFsaFailure and: [anotherInfo isFsaFailure not]) ifTrue: [  
        newInfo final: anotherInfo isFinal.
        newInfo priority: anotherInfo priority.
        newInfo failure: false.
        ^ self
    ].
    
    (anotherInfo isFsaFailure and: [info isFsaFailure not]) ifTrue: [  
        newInfo final: info isFinal.
        newInfo priority: (anotherInfo priority max: info priority).
        newInfo failure: false.
        ^ self
    ].
    
    (info hasEqualPriorityTo: anotherInfo) ifTrue: [ 
        newInfo final: (info isFinal or: [ anotherInfo isFinal ]).
        newInfo failure: (info isFsaFailure or: [anotherInfo isFailure]).
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

joinState: state with: anotherState
    self assert: state isMultivalue not.
    self assert: anotherState isMultivalue not.

    ^ super joinState: state with: anotherState
!

joinTransitions: state with: anotherState into: newState
    self assert: newState isMultivalue not.
    
    newState transitions addAll: (state transitions collect: #copy).
    newState transitions addAll: (anotherState transitions collect: #copy).
    newState mergeTransitions.
! !

!PEGFsaChoiceDeterminizator methodsFor:'joining'!

joinRetval: state with: anotherState into: newState
    "Different retvals cannot merge their info"
    self assert: (state hasDifferentRetvalThan: anotherState) not. 
    self assert: state retval == anotherState retval.
! !


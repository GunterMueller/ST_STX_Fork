"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaTest
	instanceVariableNames:'fsa a b c d e result newFsa'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!

!PEGFsaTest methodsFor:'as yet unclassified'!

assert: col allSatisfy: block
    self assert: (col allSatisfy: block).
!

assert: col anySatisfy: block
    self assert: (col anySatisfy: block).
!

setUp
    a := PEGFsaState new name: #a; retval: #token; yourself.
    b := PEGFsaState new name: #b; retval: #token; yourself.
    c := PEGFsaState new name: #c; retval: #token; yourself.
    d := PEGFsaState new name: #d; retval: #token; yourself.
    e := PEGFsaState new name: #e; retval: #token; yourself.

    fsa := PEGFsa new.
!

testMergeTransitions
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: b on: $b.	

    fsa mergeTransitions.
        
    self assert: a transitions size = 1.
    self assert: (a transitions anyOne accepts: $a).
    self assert: (a transitions anyOne accepts: $b).
!

testMergeTransitions2
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $b.	

    fsa mergeTransitions.
        
    self assert: a transitions size = 2.
!

testRemoveEpsilons
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: b to: c on: $c.	

    fsa removeEpsilons.
        
    self assert: a transitions size = 1.
    self assert: b transitions size = 1.
    self assert: a transitions anyOne isEpsilon not.
    self assert: (a transitions anyOne accepts: $c).
    self assert: (fsa isReachableState: c).
    self assert: (fsa isReachableState: b) not.
    self assert: fsa isWithoutEpsilons.
!

testRemoveEpsilons2
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: a to: b on: $b.
    fsa addTransitionFrom: b to: c on: $c.	
    
    fsa removeEpsilons.
        
    self assert: a transitions size = 2.
    self assert: b transitions size = 1.
    self assert: (a transitions noneSatisfy: [:t | t isEpsilon ]).
    self assert: (a transitions anySatisfy: [:t | t accepts: $c ]).
    self assert: (a transitions anySatisfy: [:t | t accepts: $b ]).	
!

testRemoveEpsilons3
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa startState: a.
    fsa finalState: d.
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: b to: c.	
    fsa addTransitionFrom: c to: d on: $d.	
    
    fsa removeEpsilons.
        
    self assert: a transitions size = 1.

    self assert: a transitions anyOne isEpsilon not.
    self assert: (a transitions anyOne accepts: $d).
    self assert: (fsa isReachableState: d).	
    self assert: (fsa isReachableState: b) not.
    self assert: (fsa isReachableState: c) not.
!

testRemoveEpsilons4
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b.
    
    fsa removeEpsilons.
        
    self assert: a isFinal.
!

testRemoveEpsilons5
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa startState: a.
    fsa finalState: d.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: a.	
        
    fsa removeEpsilons.
    
    self assert: fsa isWithoutEpsilons.
        
    self assert: a transitions size = 1.
    self assert: b transitions size = 1.
    self assert: (a transitions anyOne == b transitions anyOne) not.
!

testRemoveEpsilons6
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa startState: a.
    fsa finalState: d.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c.	
    fsa addTransitionFrom: c to: d on: $b.	
    d priority: -1.
        
    fsa removeEpsilons.
    
    self assert: fsa isWithoutEpsilons.
        
    self assert: a transitions size = 1.
    self assert: b transitions size = 1.
    self assert: a destination destination = d.
    self assert: d priority = -1.
!

testRemoveEpsilons7
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: a.
    fsa finalState: b.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: b to: c on: $a.	
    
    
    a priority: -1.
    b priority: -1.
    c priority: -1.
    
    a failure: true.
    b retval: #b.
    
    fsa removeEpsilons.
    
    self assert: fsa isWithoutEpsilons.
        
    self assert: a transitions size = 1.
    self assert: a destination = c.
    self assert: a isFinal.
    self assert: a isFsaFailure not.
    self assert: a retval = #b.
    self assert: a priority = -1.
    self assert: c priority = -1.
    
!

testRemoveLowPriorityTransitions
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: a.
    fsa finalState: b.
    fsa finalState: c.

    b priority: 0.	
    fsa addTransitionFrom: a to: b on: $a priority: 0.
    fsa addTransitionFrom: b to: c on: $b priority: -1.

    fsa removeLowPriorityTransitions.
    self assert: fsa isWithoutEpsilons.
        
    self assert: a transitions size = 1.
    self assert: b transitions size = 0.
!

testRemoveUnreachableStates
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: c.
    fsa addTransitionFrom: b to: c.
    
    fsa removeUnreachableStates.
        
    self assert: fsa states size = 2.
! !

!PEGFsaTest methodsFor:'tests - analysis'!

testBackTransitions
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $a.
    
    result := fsa backTransitions.
        
    self assert: result size = 1.
    self assert: result anyOne destination = a.
!

testBackTransitions2
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $a.
    fsa addTransitionFrom: c to: a.
    
    result := fsa backTransitions.
        
    self assert: result size = 2.
    self assert: result allSatisfy: [:t | t destination = a ].
!

testBackTransitions3
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa startState: a.
    fsa finalState: d.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.
    fsa addTransitionFrom: b to: d on: $a.
    fsa addTransitionFrom: c to: d on: $a.
    fsa addTransitionFrom: d to: b on: $a.
    fsa addTransitionFrom: d to: c on: $a.
    result := fsa backTransitions.
        
    self assert: result size = 2.

    d transitions allSatisfy: [ :t | result includes: t ].
!

testBackTransitions4
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $a.
    fsa addTransitionFrom: a to: c on: $a.
    
    result := fsa backTransitions.
        
    self assert: result size = 0.
!

testBackTransitions5
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: c on: $a.
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $a.
    
    result := fsa backTransitions.
        
    self assert: result size = 0.
!

testHasDistinctRetvals
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: d.
    
    a retval: nil.
    b retval: #b.
    c retval: nil.
    d retval: #c.

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $b.
    fsa addTransitionFrom: c to: d on: $d.
    fsa addTransitionFrom: d to: c on: $c.
    
    self assert: fsa hasDistinctRetvals.
    
!

testIsDeterministic
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $b.
    fsa addTransitionFrom: a to: c on: $c.	

    self assert: fsa isDeterministic.
!

testIsDeterministic2
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.	

    self assert: fsa isDeterministic not.
!

testIsWithoutEpsilons
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: b to: c on: $c.	

    self assert: fsa isWithoutEpsilons not.
!

testTopologicalOrder
    |  |
    fsa addState: a.
    fsa addState: b.

    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $a.
    
    result := fsa topologicalOrder.
            
    self assert: result first == a.
    self assert: result second == b.
! !

!PEGFsaTest methodsFor:'tests - copy'!

testCopy
    | newA newC |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    
    fsa finalState: c.
    fsa startState: a.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b priority: -1.
    fsa addTransitionFrom: c to: a.
    
    newFsa := fsa copy.
    
    self assert: (fsa isIsomorphicTo: newFsa).
    
    newA := newFsa states detect: [ :s | s canBeIsomorphicTo: a ].

    self assert: newFsa startState = newA.
    self assert: (a == newA) not.
    self assert: (newA transitions anyOne canBeIsomorphicTo: a transitions anyOne).
    self assert: (newA transitions anyOne == a transitions anyOne) not.
    self assert: newA destination destination destination == newA.
    
    newC := newA destination destination.
    self assert: (newC == c) not.
    self assert: newC isFinal.
    self assert: newC retval = #token.
! !


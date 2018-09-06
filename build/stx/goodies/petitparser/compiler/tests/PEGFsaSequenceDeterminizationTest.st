"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaSequenceDeterminizationTest
	instanceVariableNames:'fsa a b c result d interpreter e t1 t2 state anotherState parser
		generator'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!


!PEGFsaSequenceDeterminizationTest methodsFor:'as yet unclassified'!

assert: anFsa fail: input
    | stream |
    stream := input asPetitStream.

    result := interpreter interpret: anFsa on: stream.

    self assert: result isEmpty.
    ^ result
!

assert: anFsa parse: input
    ^ self assert: anFsa parse: input end: input size
!

assert: anFsa parse: input end: end
    | stream |
    stream := input asPetitStream.

    result := interpreter interpret: anFsa on: stream.

    self assert: result size = 1.
    self assert: ((result anyOne) = end) description: 'wrong position'.
    
    ^ result anyOne
!

determinizator
    ^ PEGFsaSequenceDeterminizator new
!

determinize: anFsa
    ^ self determinizator determinize: anFsa
!

fsaFrom: aNode
    ^ (aNode accept: generator)
        yourself
!

joinState: s1 with: s2
    ^ self determinizator joinState: s1 with: s2 
!

setUp
    a := PEGFsaState new name: #a; retval: #token; yourself.
    b := PEGFsaState new name: #b; retval: #token; yourself.
    c := PEGFsaState new name: #c; retval: #token; yourself.
    d := PEGFsaState new name: #d; retval: #token; yourself.
    e := PEGFsaState new name: #e; retval: #token; yourself.

    state := PEGFsaState new name: #state; retval: #token; yourself.
    anotherState := PEGFsaState new name: #anotherState; retval: #token; yourself.

    t1 := PEGFsaCharacterTransition new.
    t2 := PEGFsaCharacterTransition new.

    fsa := PEGFsa new.
    generator := PEGFsaGenerator new.

    interpreter := PEGFsaInterpret new
        yourself.
! !

!PEGFsaSequenceDeterminizationTest methodsFor:'tests'!

testAAplusA
    parser := 'aa' asParser plus, 'a' asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
    self determinize: fsa.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'aaaa'.

    self assert: fsa parse: 'aaa'.
    self assert: fsa parse: 'aaaaa'.
    self assert: fsa parse: 'aaaaaaa'.
!

testAB
    parser := $a asParser, $b asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
    self determinize: fsa.

    self assert: fsa states size = 3.
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa startState destination isFinal not.
    
    self assert: fsa parse: 'ab'.
    self assert: fsa parse: 'abc' end: 2.
    
    self assert: fsa fail: 'ac'.
!

testAPlusA
    parser := $a asParser plus, $a asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
    self determinize: fsa.

"	self assert: fsa states size = 2."
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self assert: fsa fail: 'a'.
    self assert: fsa fail: 'aa'.
    self assert: fsa fail: 'b'.
!

testAPlusB
    parser := $a asParser plus, $b asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
    self determinize: fsa.


    self assert: fsa states size = 3.
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self assert: fsa parse: 'ab'.
    self assert: fsa parse: 'aaaab'.
    self assert: fsa parse: 'aaaabc' end: 5.
    
    self assert: fsa fail: 'b'.
!

testApriorityOrA
    parser := $a asParser / $a asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
    self determinize: fsa.

    self assert: fsa states size = 2.
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa finalStates size = 1.
    self assert: fsa finalStates anyOne isMultivalue not.
    
    self assert: fsa parse: 'a'.
    self assert: fsa fail: 'b'.
!

testDeterminizeFsa
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.

    self determinize: fsa.
        
    self assert: fsa states size = 2.
    self assert: a transitions size = 1.	
!

testDeterminizeFsa2
    |   |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    fsa finalState: d.
    
    a priority: 0.
    b priority: 0.
    c priority: 0.
    d priority: 0.

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $a.
    fsa addTransitionFrom: c to: d on: $a.

    fsa addTransitionFrom: b to: a on: $a.
    fsa addTransitionFrom: c to: a on: $a.
    fsa addTransitionFrom: d to: a on: $a.	

    self determinize: fsa.
    self assert: fsa isDeterministic.	
!

testDeterminizeFsa3
    | merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.

    fsa startState: a.
    fsa finalState: e.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.
    fsa addTransitionFrom: b to: e on: $e.
    fsa addTransitionFrom: c to: d on: $d.
    fsa addTransitionFrom: d to: e on: $e.
    
    self determinize: fsa.
    
    merged := a transitions anyOne destination.
        
    self assert: fsa states size = 4.
    self assert: a transitions size = 1.	
    self assert: merged transitions size = 2.
    self assert: (merged transitions anySatisfy: [ :t | (t accepts: $d) and: [ t destination = d ]]).
    self assert: (merged transitions anySatisfy: [ :t | (t accepts: $e) and: [ t destination = e ]]).	
!

testDeterminizeFsa4
    | merged |
    fsa addState: a.
    fsa addState: b.

    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $a.
    
    b priority: -1.
    a priority: 0.
    
    self determinize: fsa.
    merged := a destination.
        
    self assert: fsa states size = 2.
    self assert: a transitions size = 1.	
    self assert: merged transitions size = 1.
    self assert: ((merged name = #'a_b') or: [merged name = #'b_a']).
    self assert: (merged transitions anySatisfy: [ :t | (t accepts: $a) and: [ t destination = merged ]]).
!

testDeterminizeFsa5
    | merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa startState: a.
    fsa finalState: d.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: a.	
    fsa addTransitionFrom: b to: c. 
    fsa addTransitionFrom: c to: d on: $a.
    b priority: 0.
    d priority: -1.
    
    self determinize: fsa.
    
    merged := b destination.
    
    self assert: fsa isDeterministic.	
    self assert: fsa states size = 3.
    
    
    self assert: a transitions size = 1.	
    self assert: b transitions size = 1.	
    self assert: (fsa states noneSatisfy: [ :s | s isFinal ]).
!

testDeterminizeFsa6
    |  merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    
    fsa startState: a.
    fsa finalState: c.
    

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a priority: -1.	
    
    self determinize: fsa.
    self assert: fsa isDeterministic.	
    self assert: fsa states size = 2.
    
    self assert: a transitions size = 1.	
    self assert: a isFinal not.
    
    merged := a destination.
    self assert: merged isFinal.
    self assert: merged priority = 0.
!

testDeterminizeFsa7
    |  merged |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a priority: -1.	
    
    b priority: 0.
    c priority: -1.
    
    self determinize: fsa.
    self assert: fsa isDeterministic.	
    self assert: fsa states size = 2.
    
    self assert: a transitions size = 1.	
    self assert: a isFinal not.
    
    merged := a destination.
    self assert: merged isFinal.
    self assert: merged priority = 0.
!

testDeterminizeFsa8
    |   |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    
    a priority: 0.
    b priority: 0.
    c priority: 0.
    

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.	

    fsa addTransitionFrom: b to: a on: $a.
    fsa addTransitionFrom: b to: c on: $a.	

    fsa addTransitionFrom: c to: a on: $a.
    fsa addTransitionFrom: c to: b on: $a.	

    
    self determinize: fsa.
    self assert: fsa isDeterministic.	
!

testDeterminizeFsa9
    |   |
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    fsa finalState: d.
    
    a priority: 0.
    b priority: 0.
    c priority: 0.
    d priority: 0.

    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $a.
    fsa addTransitionFrom: c to: d on: $a.

    fsa addTransitionFrom: b to: a on: $a.
    fsa addTransitionFrom: c to: a on: $a.
    fsa addTransitionFrom: d to: a on: $a.	

    self determinize: fsa.
    self assert: fsa isDeterministic.	
! !

!PEGFsaSequenceDeterminizationTest methodsFor:'tests - joining'!

testJoinState
    | newState |
    state addTransition: t1.
    anotherState addTransition: t2.
    state final: true.
    
    t1 destination: (PEGFsaState named: #t1).
    t2 destination: (PEGFsaState named: #t2).
    
    newState := self joinState: state with: anotherState.
    
    self assert: (newState transitions contains: [ :t | t = t1 ]).
    self assert: (newState transitions contains: [ :t | t = t2 ]).
    self assert: (newState isFinal).	
!

testJoinState2
    | newState |
    state addTransition: t1.
    anotherState addTransition: t2.
    state final: true.
    
    t1 destination: (PEGFsaState named: #t1).
    t2 destination: (PEGFsaState named: #t2).
    
    newState := self joinState: anotherState with: state.
    
    self assert: (newState transitions contains: [ :t | t = t1 ]).
    self assert: (newState transitions contains: [ :t | t = t2 ]).
    self assert: (newState isFinal).	
!

testJoinState3
    | newState |
    state final: true.
    state retval: #foo.
    state priority: -1.

    anotherState final: true.
    anotherState retval: #foo.
    anotherState failure: true.
    anotherState priority: 0.
    
    newState := self joinState: anotherState with: state.
    
    self assert: (newState isMultivalue not).
    self assert: (newState retval value = #foo).
    self assert: (newState isFinal).	
    self assert: (newState priority = 0).		
    self assert: (newState isFsaFailure).				
!

testJoinState5
    | newState |
    state final: true.
    state retval: #foo.
    state priority: 0.

    anotherState final: true.
    anotherState retval: #foo.
    anotherState priority: -1.

    
    newState := self joinState: anotherState with: state.
    
    self assert: (newState retval = #foo).
    self assert: (newState isFinal).	
    self assert: (newState priority = 0).		
!

testJoinState6
    | newState |
    state final: true.
    state priority: 0.

    anotherState final: true.
    anotherState priority: -1.
    anotherState failure: true.

    
    newState := self joinState: anotherState with: state.
    
    self assert: (newState isMultivalue not).
    self assert: (newState isFinal).	
    self assert: (newState priority = 0).		
    self assert: (newState isFsaFailure not).				
!

testJoinState7
    | newState |
    state final: true.
    state retval: #foo.
    state priority: -1.

    anotherState final: true.
    anotherState retval: #foo.
    anotherState failure: true.
    anotherState priority: 0.
    
    newState := self joinState: anotherState with: state.
    
    self assert: (newState isMultivalue not).
    self assert: (newState retval value = #foo).
    self assert: (newState isFinal).	
    self assert: (newState priority = 0).		
    self assert: (newState isFsaFailure).				
! !

!PEGFsaSequenceDeterminizationTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


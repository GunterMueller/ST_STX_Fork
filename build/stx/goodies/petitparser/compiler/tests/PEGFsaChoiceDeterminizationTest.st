"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaChoiceDeterminizationTest
	instanceVariableNames:'fsa a b c result d interpreter e t1 t2 state anotherState parser
		generator'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!

!PEGFsaChoiceDeterminizationTest methodsFor:'as yet unclassified'!

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
    ^ PEGFsaChoiceDeterminizator new
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
!

testAAorA
    parser := 'aa' asParser / 'a' asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
"	self assert: fsa states size = 2."
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'aa'.
    self assert: fsa fail: 'b'.
!

testAorAA
    parser := 'a' asParser / 'aa' asParser.
    fsa := self fsaFrom: parser asCompilerTree.
    
"	self assert: fsa states size = 2."
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'aa' end: 1.
    self assert: fsa fail: 'b'.
!

testDeterminizeFsa
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.
    fsa startState: a.
    fsa finalState: c.
    fsa finalState: e.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b.

    b final: true.
    b priority: 0.
    c final: true.
    c priority: 0.
    c failure: true.

    fsa addTransitionFrom: a to: d on: $a priority: -1.
    fsa addTransitionFrom: d to: e on: $a priority: -1.

    d priority: -1.
    e final: true.
    e priority: -1.
    e failure: true.


    self determinize: fsa.
        
    self assert: fsa states size = 3.
    self assert: a transitions size = 1.	
    self assert: a destination isFinal.
    self assert: a destination destination isFinal.
!

testDeterminizeFsa2
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.
    fsa startState: a.
    fsa finalState: c.
    fsa finalState: e.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b.

    b final: true.
    b priority: 0.
    c final: true.
    c priority: 0.
    c failure: true.

    fsa addTransitionFrom: a to: d on: $a priority: -1.
    fsa addTransitionFrom: d to: e on: $b priority: -1.

    d priority: -1.
    e final: true.
    e priority: -1.
    e failure: true.

    self determinize: fsa.
        
    self assert: fsa states size = 3.
    self assert: a transitions size = 1.	
    self assert: a destination isFinal.
    self assert: a destination transitions size = 1.
    self assert: a destination destination isFsaFailure.
!

testNot
    parser := ('aa' asParser, 'aa' asParser not) / ('aa' asParser, 'aa' asParser).
    fsa := self fsaFrom: parser asCompilerTree.
    

"	self assert: fsa states size = 2."
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self assert: fsa parse: 'aabc' end: 2.
    self assert: fsa parse: 'aaa' end: 2.
    self assert: fsa parse: 'aa'.

    self assert: fsa parse: 'aaaa'.
    self assert: fsa parse: 'aaaaa' end: 4.

    self assert: fsa fail: 'ab'.
! !


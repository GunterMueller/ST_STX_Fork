"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaInterpretTest
	instanceVariableNames:'fsa a b c result d interpreter e'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!

!PEGFsaInterpretTest methodsFor:'as yet unclassified'!

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
    anFsa fixFinalStatePriorities.

    result := interpreter interpret: anFsa on: stream.

    self assert: result isEmpty not.
    self assert: (result values anySatisfy: [ :pos | pos = end ]) description: 'wrong position'.
    
    ^ result
!

assert: anFsa parse: input retval: name
    ^ self assert: anFsa parse: input retval: name end: input size
!

assert: anFsa parse: input retval: name end: end
    | stream |
    stream := input asPetitStream.
    anFsa fixFinalStatePriorities.
    
    result := interpreter interpret: anFsa on: stream.

    self assert: result isEmpty not.
    self assert: ((result at: name) = end) description: 'wrong position'.
    
    ^ result
!

assert: name position: pos
    ^ self assert: ((result at: name) = pos)
!

assertFail: name
    self assert: (result includesKey: name) not
!

assertPass: name
    self assert: (result includesKey: name)
!

setUp
    a := PEGFsaState new name: #a; retval: #token; yourself.
    b := PEGFsaState new name: #b; retval: #token; yourself.
    c := PEGFsaState new name: #c; retval: #token; yourself.
    d := PEGFsaState new name: #d; retval: #token; yourself.
    e := PEGFsaState new name: #e; retval: #token; yourself.

    fsa := PEGFsa new.

    interpreter := PEGFsaInterpret new
        yourself.
! !

!PEGFsaInterpretTest methodsFor:'tests'!

testA
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b on: $a.
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'abc' end: 1.
    
    self assert: fsa fail: 'b'.
!

testAB
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b.	
    
    self assert: fsa parse: 'ab' retval: #token.
    self assert: fsa parse: 'abc' retval: #token end: 2.
    
    self assert: fsa fail: 'ac'.
!

testABPlus
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: a on: $b.	
    fsa addTransitionFrom: b to: c on: $b.	
    
    self assert: fsa parse: 'ab'.
    self assert: fsa parse: 'ababab'.
    self assert: fsa parse: 'abababc' end: 6.
    
    self assert: fsa fail: 'ac'.
!

testAOptional
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b on: $a.
    
    self assert: fsa parse: 'a'.
    self assert: fsa parse: 'ab' end: 1.
    self assert: fsa parse: 'b' end: 0.
!

testAPlusB
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $b.	
    
    self assert: fsa parse: 'ab'.
    self assert: fsa parse: 'aaaab'.
    self assert: fsa parse: 'abc' end: 2.
    
    self assert: fsa fail: 'ac'.
!

testA_Bnot
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b.	
    
    c retval: #token.
    c failure: true.
    
    self assert: fsa parse: 'ac' retval: #token end: 1.
    self assert: fsa parse: 'aaa' retval: #token end: 1.
    
    self assert: fsa fail: 'ab'.
!

testChoice
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $b.
    fsa addTransitionFrom: a to: c on: $c.	
    
    self assert: fsa parse: 'b'.
    self assert: fsa parse: 'c'.

    self assert: fsa fail: 'a'
!

testEmpty
    fsa addState: a.
    fsa startState: a.
    fsa finalState: a.
    
"	fsa addTransitionFrom: a to: b.
"	
    self assert: fsa parse: '' retval: #token.
! !

!PEGFsaInterpretTest methodsFor:'tests - multivalues'!

testEpsilonChoice
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.
    fsa startState: a.
    fsa finalState: c.
    fsa finalState: e.
    
    fsa addTransitionFrom: b to: c on: $c.
    fsa addTransitionFrom: d to: e on: $e.	
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: a to: d.

    c retval: #c.
    e retval: #e.
    
    self assert: fsa parse: 'c' retval: #c.
    self assert: fsa parse: 'e' retval: #e.

    self assert: fsa fail: 'a'
!

testEpsilonChoice2
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa addState: d.
    fsa addState: e.
    fsa startState: a.
    fsa finalState: c.
    fsa finalState: e.
    
    fsa addTransitionFrom: b to: c on: $a.
    fsa addTransitionFrom: d to: e on: $a.	
    
    fsa addTransitionFrom: a to: b.
    fsa addTransitionFrom: a to: d.

    c retval: #c.
    e retval: #e.	
    
    self assert: fsa parse: 'a'.
    self assert: #c position: 1.
    self assert: #e position: 1.

    self assert: fsa fail: 'b'
!

testMultivalueChoice
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $a.	
    
    b retval: #b.
    c retval: #c.
    
    self assert: fsa parse: 'a'.
    self assert: #b position: 1.
    self assert: #c position: 1.
    
    self assert: fsa fail: 'b'
! !


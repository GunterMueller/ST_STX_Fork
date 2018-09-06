"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaIntegrationTest
	instanceVariableNames:'result node fsa generator interpreter parser1 parser2 parser3'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!


!PEGFsaIntegrationTest methodsFor:'as yet unclassified'!

determinizator
    ^ PEGFsaDeterminizator new
!

failScan: input token: token
    | stream |
    stream := input asPetitStream.

    result := interpreter interpret: fsa on: stream.
    self assert: (result includes: token) not.

    ^ result
!

fsaFrom: aNode
    ^ (aNode accept: generator)
        determinize;
        minimize;
        yourself
!

merge
    | startState fsa1 fsa2 fsa3 |
    fsa := PEGFsa new.
    startState := PEGFsaState new.

    fsa addState: startState.	
    fsa startState: startState.

    fsa1 := self fsaFrom: parser1 asCompilerTree.
    fsa1 retval: #token1.
    fsa adopt: fsa1.
    fsa addTransitionFrom: startState to: fsa1 startState.

    fsa2 := self fsaFrom: parser2 asCompilerTree.
    fsa2 retval: #token2.
    fsa adopt: fsa2.
    fsa addTransitionFrom: startState to: fsa2 startState.

    parser3 isNil ifFalse: [ 
        fsa3 := self fsaFrom: parser3 asCompilerTree.
        fsa3 retval: #token3.
        fsa adopt: fsa3.
        fsa addTransitionFrom: startState to: fsa3 startState.
    ].
    
    self determinizator determinize: fsa.
    fsa minimize.
!

scan: input token: token
    ^ self scan: input token: token position: input size
!

scan: input token: token position: position
    | stream |
    stream := input asPetitStream.

    result := interpreter interpret: fsa on: stream.

    self assert: (result includesKey: token).
    self assert: (result at: token) = position.

    ^ result
!

setUp
    super setUp.
    generator := PEGFsaGenerator new.
    interpreter := PEGFsaInterpret new.	
!

testFooOrId
    parser1 := 'foo' asParser.
    parser2 := #letter asParser plus.
    
    self merge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals not.
    
    self failScan: 'bar' token: #token1.
    self scan: 'bar' token: #token2 position: 3.

    self scan: 'foo' token: #token1 position: 3.
    self scan: 'foo' token: #token2 position: 3.
    
    self scan: 'foobar' token: #token1 position: 3.
    self scan: 'foobar' token: #token2 position: 6.
    
!

testTrueOrId
    parser1 := 'true' asParser.
    parser2 := #letter asParser plus.
    
    self merge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals not.
    
    self failScan: 'false' token: #token1.
    self scan: 'false' token: #token2 position: 5.

    self scan: 'true' token: #token1 position: 4.
    self scan: 'true' token: #token2 position: 4.
    
    self scan: 'truecrypt' token: #token1 position: 4.
    self scan: 'truecrypt' token: #token2 position: 9.
    
!

testUnaryOrKW
    parser1 := #letter asParser plus, $: asParser not.
    parser2 := #letter asParser plus, $: asParser.
    
    self merge.
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self scan: 'foo' token: #token1.
    self failScan: 'foo' token: #token2.

    self failScan: 'foo:' token: #token1.
    self scan: 'foo:' token: #token2.
!

testUnaryOrKWorId
    parser1 := #letter asParser plus, $: asParser not.
    parser2 := #letter asParser plus, $: asParser.
    parser3 := #letter asParser plus.
    
    self merge.
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self scan: 'foo' token: #token1.
    self failScan: 'foo' token: #token2.
    self scan: 'foo' token: #token3.

    self failScan: 'foo:' token: #token1.
    self scan: 'foo:' token: #token2.
    self scan: 'foo' token: #token3.


    self failScan: '123' token: #token1.
    self failScan: '123' token: #token2.
    self failScan: '123' token: #token3.
    
! !

!PEGFsaIntegrationTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


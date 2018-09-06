"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaDeterminizationTest
	instanceVariableNames:'parser1 parser2 fsa generator'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-FSA'
!


!PEGFsaDeterminizationTest methodsFor:'as yet unclassified'!

determinizator
    ^ PEGFsaDeterminizator new
!

fsaFrom: aNode
    ^ (aNode accept: generator)
        determinize;
        yourself
!

merge
    | startState fsa1 fsa2 |
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
    
    self determinizator determinize: fsa 
!

setUp
    super setUp.
    generator := PEGFsaGenerator new.
!

testA_A
    parser1 := 'a' asParser.
    parser2 := 'a' asParser.
    
    self merge.
    
    self assert: fsa states size = 2.
    self assert: fsa finalStates size = 1.
    self assert: fsa finalStates anyOne retvals size = 2.
    self assert: (fsa finalStates anyOne retvals includes: #token1).	
    self assert: (fsa finalStates anyOne retvals includes: #token2).		
!

testA_AB
    parser1 := 'a' asParser.
    parser2 := 'ab' asParser.
    
    self merge.
    
    self assert: fsa states size = 3.
    self assert: fsa finalStates size = 2.
    self assert: fsa startState destination retvals size = 1.
    self assert: fsa startState destination retval = #token1.

    self assert: fsa startState destination destination retvals size = 1.
    self assert: fsa startState destination destination retval = #token2.
!

testID_KW
    parser1 := #word asParser plus.
    parser2 := #word asParser plus, $: asParser.
    
    self merge.
    
    self assert: fsa states size = 3.
    self assert: fsa finalStates size = 2.

    self assert: (fsa finalStates anySatisfy: [ :fs | fs retvals includes: #token1 ]).	
    self assert: (fsa finalStates anySatisfy: [ :fs | fs retvals includes: #token2 ]).	
    
!

testTrue_ID
    parser1 := 'true' asParser.
    parser2 := #word asParser plus.
    
    self merge.
    
    self assert: fsa states size = 6.
    self assert: fsa finalStates size = 5.
    "Only 1 state with both #token1 and #token2"
    self assert: ((fsa finalStates select: [:fs | fs retvals size = 2]) size = 1).	
!

testTrue_True
    parser1 := 'true' asParser.
    parser2 := 'true' asParser.
    
    self merge.
    
    self assert: fsa states size = 5.
    self assert: fsa finalStates size = 1.
    self assert: fsa finalStates anyOne retvals size = 2.
    self assert: (fsa finalStates anyOne retvals includes: #token1).	
    self assert: (fsa finalStates anyOne retvals includes: #token2).		
! !

!PEGFsaDeterminizationTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


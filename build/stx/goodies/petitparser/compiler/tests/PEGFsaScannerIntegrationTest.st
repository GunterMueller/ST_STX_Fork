"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PEGFsaScannerIntegrationTest
	instanceVariableNames:'fsa fsaGenerator parser scanner result compiled parser1 parser2'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Scanner'
!

!PEGFsaScannerIntegrationTest methodsFor:'as yet unclassified'!

testAAA_Aplusnot
    parser := 'aaa' asParser not, $a asParser plus.
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	

    self scan: 'a' token: #token.
    self scan: 'aa' token: #token.

    self failScan: ''.
    self failScan: 'aaa'.
    self failScan: 'aaaa'.
    self failScan: 'aaaaa'.
! !

!PEGFsaScannerIntegrationTest methodsFor:'distinct'!

testAAAnot_Aplus
    parser := 'aaa' asParser not, $a asParser plus.
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals.

    self scan: 'a' token: #token.
    self scan: 'aa' token: #token.

    self failScan: ''.
    self failScan: 'aaa'.
    self failScan: 'aaaa'.
    self failScan: 'aaaaa'.
!

testAAAstar_AA
    parser := 'aaa' asParser star, 'aa' asParser.
    
    self scan: 'aa' token: #token.
    self scan: 'aaaaa' token: #token.
    self scan: 'aaaaaaaa' token: #token.


    self failScan: 'a'.
    self failScan: 'aaa'.
    self failScan: 'aaaa'.
    self failScan: 'aaaaaaa'.
!

testAAplus_A
    parser := 'aa' asParser plus, $a asParser.
    
    self scan: 'aaa' token: #token.
    self scan: 'aaaaa' token: #token.

    self failScan: 'a'.
    self failScan: 'aa'.
    self failScan: 'aaaa'.
!

testAAplus_B
    parser := 'aa' asParser plus, $b asParser.
    
    self scan: 'aab' token: #token.
    self scan: 'aaaab' token: #token.

    self failScan: 'ab'.
    self failScan: 'aaab'.
    self failScan: 'aac'.
!

testAAstar_A
    parser := 'aa' asParser star, $a asParser.
    
    self scan: 'a' token: #token.
    self scan: 'aaa' token: #token.
    self scan: 'aaaaa' token: #token.
    self scan: 'aaaaaaa' token: #token.


    self failScan: 'aa'.
    self failScan: 'aaaa'.
!

testAAstar_B
    parser := 'aa' asParser star, $b asParser.
    
    self scan: 'b' token: #token.
    self scan: 'aab' token: #token.
    self scan: 'aaaab' token: #token.
    self scan: 'aaaaaab' token: #token.


    self failScan: 'ab'.
    self failScan: 'aaa'.
!

testAB
    parser := 'ab' asParser.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: 'b'.

    self scan: 'ab' token: #token position: 2.
    self scan: 'aba' token: #token position: 2.
!

testAXorAXXstar_X
    parser := ('ax' asParser / 'axx' asParser) plus, 'x' asParser.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: 'x'.
    self failScan: ''.

    self scan: 'axx' token: #token position: 3.
!

testAXorA_X
    parser := ('ax' asParser / 'a' asParser), $x asParser.
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self scan: 'axx' token: #token.

    self failScan: 'ax'.
    self failScan: 'ab'.
    self failScan: 'x'.
    self failScan: ''.		
!

testA_BCorCD_D
    parser := $a asParser, ('bc' asParser / 'cd' asParser), $d asParser.
    
    self scan: 'abcd' token: #token.
    self scan: 'acdd' token: #token.

    self failScan: 'abdd'.
    self failScan: 'ad'.
    self failScan: 'aacd'.
!

testA_BCorCDplus_D
    parser := $a asParser, ('bc' asParser / 'cd' asParser) plus, $d asParser.
    
    self scan: 'abcd' token: #token.
    self scan: 'acdd' token: #token.
    self scan: 'abcbccdd' token: #token.
    self scan: 'acdcdbcbcd' token: #token.

    self failScan: 'abdd'.
    self failScan: 'ad'.
    self failScan: 'abcccd'.
!

testA_BCorCDstar_D
    parser := $a asParser, ('bc' asParser / 'cd' asParser) star, $d asParser.
    
    self scan: 'ad' token: #token.
    self scan: 'abcd' token: #token.
    self scan: 'acdd' token: #token.
    self scan: 'abcbccdd' token: #token.
    self scan: 'acdcdbcbcd' token: #token.

    self failScan: 'abdd'.
    self failScan: 'abcccd'.
!

testA_Bnot
    parser := 'a' asParser, $b asParser not.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals.

    self failScan: 'ab'.
    self failScan: 'bb'.

    self scan: 'a' token: #token position: 1.
    self scan: 'ac' token: #token position: 1.
!

testA_Boptional
    parser := $a asParser, $b asParser optional.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: 'b'.

    self scan: 'ab' token: #token position: 2.
    self scan: 'ac' token: #token position: 1.
    self scan: 'a' token: #token position: 1.
!

testA_BorC_D
    parser := $a asParser, ($b asParser / $c asParser), $d asParser.
    
    self scan: 'abd' token: #token.
    self scan: 'acd' token: #token.

    self failScan: 'a'.
    self failScan: 'abc'.
    self failScan: 'add'.
!

testA_BorCplus_D
    parser := $a asParser, ($b asParser / $c asParser) plus, $d asParser.
    
    self scan: 'abd' token: #token.
    self scan: 'acd' token: #token.
    self scan: 'abcbcd' token: #token.
    self scan: 'acbcbcd' token: #token.

    self failScan: 'a'.
    self failScan: 'ad'.
    self failScan: 'abc'.
    self failScan: 'aad'.
!

testA_BorCstar_D
    parser := $a asParser, ($b asParser / $c asParser) star, $d asParser.
    
    self scan: 'ad' token: #token.
    self scan: 'abd' token: #token.
    self scan: 'acd' token: #token.
    self scan: 'abcbcd' token: #token.
    self scan: 'acbcbcd' token: #token.

    self failScan: 'a'.
    self failScan: 'abc'.
    self failScan: 'aad'.
!

testAorAA
    parser := 'a' asParser / 'aa' asParser.
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: 'b'.

    self scan: 'aa' token: #token position: 1.
    self scan: 'a' token: #token position: 1.
!

testAorAX_X
    parser := ('a' asParser / 'ax' asParser), $x asParser.
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self scan: 'ax' token: #token position: 2.
    self scan: 'axx' token: #token position: 2.	

    self failScan: 'a'.
    self failScan: 'x'.
    self failScan: ''.		
!

testAorB
    parser := $a asParser / $b asParser.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: 'c'.

    self scan: 'aa' token: #token position: 1.
    self scan: 'bb' token: #token position: 1.
!

testAorEOF
    parser := $a asParser / #eof asParser.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	

    self scan: 'a' token: #token position: 1.
    self scan: '' token: #token position: 0.
    
    self failScan: 'b'.
!

testAplus_B
    parser := $a asParser plus, $b asParser.
    
    self scan: 'ab' token: #token.
    self scan: 'aab' token: #token.
    self scan: 'aaab' token: #token.

    self failScan: 'b'.
    self failScan: 'ac'.
!

testAstar_A
    parser := $a asParser star, $a asParser.
    
    self failScan: 'a'.
    self failScan: 'aa'.
    self failScan: 'ac'.
!

testAstar_B
    parser := $a asParser star, $b asParser.
    
    self scan: 'b' token: #token.
    self scan: 'ab' token: #token.
    self scan: 'aab' token: #token.

    self failScan: ''.
    self failScan: 'ac'.
!

testAstar_Bnot
    parser := 'a' asParser star, $b asParser not.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals.

    self failScan: 'b'.
    self failScan: 'ab'.
    self failScan: 'aaab'.

    self scan: '' token: #token.
    self scan: 'a' token: #token.
    self scan: 'aaa' token: #token.
    self scan: 'c' token: #token position: 0.
    self scan: 'ac' token: #token position: 1.
    self scan: 'aaac' token: #token position: 3.
!

testFoo
    parser := 'foo' asParser.
    
    self scan: 'foo' token: #token.
    self scan: 'foobar' token: #token position: 3.

    self failScan: 'bar'.
    self failScan: 'fo'.
!

testNumber
    parser := #digit asParser plus.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: 'b'.

    self scan: '12' token: #token position: 2.
    self scan: '2312' token: #token position: 4.
!

testRecursive
    parser := PPDelegateParser new.
    
    parser setParser: ($a asParser, parser) / $b asParser.
    
    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: 'c'.

    self scan: 'b' token: #token.
    self scan: 'ab' token: #token.
    self scan: 'aaaaab' token: #token.
!

testSmalltalkIdentifier
    parser := #letter asParser, #word asParser star, $: asParser not.
    self compile.
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	

    self scan: 'a' token: #token.
    self scan: 'hithere' token: #token.
    self scan: 'hi123' token: #token.

    self failScan: ''.
    self failScan: 'aaa:'.
    self failScan: '123'.	
! !

!PEGFsaScannerIntegrationTest methodsFor:'multivalues'!

testA
    parser1 := 'a' asParser.
    parser2 := 'a' asParser.
    
    self compileMerge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals not.
    
    self failScan: ''.
    self failScan: 'b'.

    self scan: 'a' token: #token1 position: 1.
    self scan: 'a' token: #token2 position: 1.
    self scan: 'aaa' token: #token1 position: 1.
    self scan: 'aaa' token: #token2 position: 1.
!

testAplus_BOrAplus_Bnot
    parser1 := $a asParser plus, $b asParser.
    parser2 := $a asParser plus, $b asParser not.

    self compileMerge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
            
    self failScan: 'aaa' token: #token1.
    self scan: 'aaa' token: #token2 position: 3.

    self scan: 'aaab' token: #token1 position: 4.
    self failScan: 'aaab' token: #token2.
!

testAuorAplus
    parser1 := 'a' asParser.
    parser2 := 'a' asParser plus.
    
    self compileMerge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals not.
    
    self failScan: 'b' token: #token1.
    self failScan: 'b' token: #token2.

    self failScan: '' token: #token1.
    self failScan: '' token: #token2.
    
    self scan: 'a' token: #token1 position: 1.
    self scan: 'a' token: #token2 position: 1.

    self scan: 'aaa' token: #token1 position: 1.
    self scan: 'aaa' token: #token2 position: 3.
!

testKeywordOrUnary
    parser1 := #letter asParser plus, $: asParser.
    parser2 := #letter asParser plus, $: asParser not.
    
    self compileMerge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
            
    self failScan: 'false' token: #token1.
    self scan: 'false' token: #token2 position: 5.

    self scan: 'false:' token: #token1 position: 6.
    self failScan: 'false:' token: #token2.
!

testTrueOrId
    parser1 := 'true' asParser.
    parser2 := #letter asParser plus.
    
    self compileMerge.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    self assert: fsa hasDistinctRetvals not.
    
    self failScan: 'false' token: #token1.
    self scan: 'false' token: #token2 position: 5.

    self scan: 'true' token: #token1 position: 4.
    self scan: 'true' token: #token2 position: 4.
    
    self scan: 'truecrypt' token: #token1 position: 4.
    self scan: 'truecrypt' token: #token2 position: 9.
    
! !

!PEGFsaScannerIntegrationTest methodsFor:'smalltalk'!

testStIdentifier
    parser := (PPPredicateObjectParser
                on: [ :each | each isLetter or: [ each = $_ ] ]
                message: 'letter expected') ,
            (PPPredicateObjectParser
                on: [ :each | each isAlphaNumeric or: [ each = $_ ] ]
                message: 'letter or digit expected') star.

    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: '23ab'.

    self scan: 'fooBar' token: #token.
    self scan: 'foo_bar' token: #token.
!

testStKeyword
    | identifier |
    identifier := (PPPredicateObjectParser
                on: [ :each | each isLetter or: [ each = $_ ] ]
                message: 'letter expected') ,
            (PPPredicateObjectParser
                on: [ :each | each isAlphaNumeric or: [ each = $_ ] ]
                message: 'letter or digit expected') star.
    parser := identifier, $: asParser.

    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: 'fooBar'.

    
    self scan: 'fooBar:' token: #token.
    self scan: 'foo_bar:' token: #token.
!

testStString
    parser := $' asParser , ('''''' asParser / $' asParser negate) star , $' asParser.

    self compile.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.	
    
    self failScan: ''.
    self failScan: 'b'.

    self scan: '''hi there''' token: #token.
! !

!PEGFsaScannerIntegrationTest methodsFor:'support'!

compile
    | ppcTree |
    compiled ifTrue: [ ^ self ].

    ppcTree := parser asCompilerTree.
    fsa := ppcTree asFsa.
    fsa retval: #token.
    fsa determinize.
    
    self generate
!

compileMerge
    | ppcTree1 ppcTree2 fsa1 fsa2 |
    compiled ifTrue: [ ^ self ].

    ppcTree1 := parser1 asCompilerTree.
    ppcTree2 := parser2 asCompilerTree.
    
    fsa1 := ppcTree1 asFsa.
    fsa1 retval: #token1.
    fsa2 := ppcTree2 asFsa.
    fsa2 retval: #token2.
    
    fsa := self mergeFsa: fsa1 and: fsa2.
    
    self generate.
!

failScan: stream
    self compile.

    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner scan_nextToken.
    
    result := scanner polyResult.
    
        
    self assert: result isEmpty
!

failScan: stream token: token
    self compile.

    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner scan_nextToken.
    
    result := scanner polyResult.
    
        
    self assert: ((result includesKey: token) not)
!

generate
    | codeGenerator |
    fsa name: #nextToken.
    
    codeGenerator := PPCScannerCodeGenerator new.
    codeGenerator context options scannerSuperclass: PPCScanner.
    
    scanner := codeGenerator
        generateAndCompile: fsa.

    compiled := true

    "Modified: / 03-09-2015 / 22:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeFsa: fsa1 and: fsa2
    | startState |
    fsa := PEGFsa new.
    startState := PEGFsaState new.
    
    fsa addState: startState.
    fsa startState: startState.

    fsa adopt: fsa1.
    fsa addTransitionFrom: startState to: fsa1 startState.

    fsa adopt: fsa2.
    fsa addTransitionFrom: startState to: fsa2 startState.
    
    fsa determinizeStandard.
    ^ fsa
!

scan: stream token: token
    self scan: stream token: token position: stream size.
!

scan: stream token: token position: position
    self compile.

    scanner stream: stream asPetitStream. 
    scanner scan_nextToken.

    result := scanner polyResult.
        
    self assert: result isCollection description: 'no collection returned as a result!!'.
    self assert: (result isEmpty not) description: 'no token found'.
    self assert: (result at: token) = position.
!

setUp
    compiled := false.
    fsaGenerator := PEGFsaGenerator new.
! !


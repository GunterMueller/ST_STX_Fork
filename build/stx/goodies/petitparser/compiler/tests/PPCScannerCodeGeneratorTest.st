"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCScannerCodeGeneratorTest
	instanceVariableNames:'fsa a b c d e codeGenerator scanner result'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Scanner'
!

!PPCScannerCodeGeneratorTest methodsFor:'as yet unclassified'!

fail: stream rule: rule 
    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner perform: ('scan_', rule) asSymbol.
    
    result := scanner polyResult.
        
    self assert: result isEmpty
!

parse: stream token: token rule: rule
    self parse: stream token: token rule: rule position: stream size.
!

parse: stream token: token rule: rule position: position
    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner perform: ('scan_', rule) asSymbol.
    result := scanner polyResult.
        
    self assert: (result at: token) = position.
!

setUp
    a := PEGFsaState new name: #a; retval: #a; yourself.
    b := PEGFsaState new name: #b; retval: #b; yourself.
    c := PEGFsaState new name: #c; retval: #c; yourself.
    d := PEGFsaState new name: #d; retval: #d; yourself.
    e := PEGFsaState new name: #e; retval: #e; yourself.

    fsa := PEGFsa new.
    
    codeGenerator := PPCScannerCodeGenerator new.
! !

!PPCScannerCodeGeneratorTest methodsFor:'caching'!

testDuplicities
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $b.	

    fsa name: #nextTokenAstarB.
    b retval: #AstarB.

    codeGenerator generate: fsa.
    codeGenerator generate: fsa copy.
    scanner := codeGenerator compile.
    
    self assert: scanner class methodDictionary size = 1.
    
    self parse: 'ab' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'b' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'aaab' token: #AstarB rule: #nextTokenAstarB.

    self fail: 'c' rule: #nextTokenAstarB.	
!

testDuplicities2
    | copy |
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $b.	

    b retval: nil.
    
    copy := fsa copy.
    copy name: #nextTokenFooBar.
    copy retval: #FooBar.

    fsa name: #nextTokenAstarB.
    fsa retval: #AstarB.


    codeGenerator generate: fsa.
    codeGenerator generate: copy.
    scanner := codeGenerator compile.
    
    self assert: scanner class methodDictionary size = 2.
    
    self parse: 'ab' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'b' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'aaab' token: #AstarB rule: #nextTokenAstarB.

    self fail: 'c' rule: #nextTokenAstarB.	
    
    self parse: 'ab' token: #FooBar rule: #nextTokenFooBar.
    self parse: 'b' token: #FooBar rule: #nextTokenFooBar.
    self parse: 'aaab' token: #FooBar rule: #nextTokenFooBar.

    self fail: 'c' rule: #nextTokenFooBar.	
! !

!PPCScannerCodeGeneratorTest methodsFor:'tests'!

testA
    fsa addState: a.
    fsa addState: b.
    
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa name: #nextTokenA.
    b retval: #a.
    
    scanner := (codeGenerator generateAndCompile: fsa).
    
    self parse: 'aaa' token: #a rule: #nextTokenA position: 1.
    self fail: 'b' rule: #nextTokenA.	
!

testAAstarA
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $a.	
    fsa addTransitionFrom: c to: b on: $a.	

    fsa name: #nextTokenAAstarA.
    b retval: #AAstarA.
    c retval: #AAstarA.
    c final: true.
    c failure: true.

    scanner := (codeGenerator generateAndCompile: fsa).

    self parse: 'a' token: #AAstarA rule: #nextTokenAAstarA.
    self parse: 'aaa' token: #AAstarA rule: #nextTokenAAstarA.
    self parse: 'aaaaa' token: #AAstarA rule: #nextTokenAAstarA.

    self fail: '' rule: #nextTokenAAstarA.
    self fail: 'aa' rule: #nextTokenAAstarA.
    self fail: 'aaaa' rule: #nextTokenAAstarA.
!

testAB
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b.	
    
    fsa name: #nextTokenAB.
    c retval: #ab.
    
    scanner := (codeGenerator generateAndCompile: fsa).
    
    self parse: 'ab' token: #ab rule: #nextTokenAB position: 2.
!

testABorBC
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

    fsa addTransitionFrom: a to: d on: $b.
    fsa addTransitionFrom: d to: e on: $c.	

    fsa name: #nextTokenABorBC.
    c retval: #ab.
    e retval: #bc.

    scanner := (codeGenerator generateAndCompile: fsa).

    self parse: 'ab' token: #ab rule: #nextTokenABorBC position: 2.
    self parse: 'abbc' token: #ab rule: #nextTokenABorBC position: 2.
    self parse: 'bc' token: #bc rule: #nextTokenABorBC position: 2.
    
    self fail: 'ac' rule: #nextTokenABorBC.
!

testABstarA
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: c on: $b.	
    fsa addTransitionFrom: c to: b on: $a.	

    fsa name: #nextTokenABstarA.
    b retval: #ABstarA.

    scanner := (codeGenerator generateAndCompile: fsa).

    self parse: 'a' token: #ABstarA rule: #nextTokenABstarA position: 1.
    self parse: 'aa' token: #ABstarA rule: #nextTokenABstarA position: 1.
    self parse: 'aba' token: #ABstarA rule: #nextTokenABstarA position: 3.
    self parse: 'abaa' token: #ABstarA rule: #nextTokenABstarA position: 3.
    self parse: 'ababa' token: #ABstarA rule: #nextTokenABstarA position: 5.



    self fail: '' rule: #nextTokenABstarA.
!

testAStar
    fsa addState: a.
    fsa addState: b.
    
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.

    fsa name: #nextTokenA.
    a retval: #a.
    a final: true.
    a priority: 0.
    
    scanner := (codeGenerator generateAndCompile: fsa).
    
    self assert: scanner class methodDictionary size == 1.
    
    self parse: '' token: #a rule: #nextTokenA.
    self parse: 'a' token: #a rule: #nextTokenA.
    self parse: 'aa' token: #a rule: #nextTokenA.
    self parse: 'ab' token: #a rule: #nextTokenA position: 1.
    self parse: 'aaa' token: #a rule: #nextTokenA.
    self parse: 'b' token: #a rule: #nextTokenA position: 0.
!

testA_Bstar_A
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: c.
    
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: b to: b on: $b.	
    fsa addTransitionFrom: b to: c on: $a.	

    fsa name: #nextTokenA_Bstar_A.
    c retval: #A_Bstar_A.

    scanner := (codeGenerator generateAndCompile: fsa).

    self parse: 'aa' token: #A_Bstar_A rule: #nextTokenA_Bstar_A.
    self parse: 'aba' token: #A_Bstar_A rule: #nextTokenA_Bstar_A.

    self fail: '' rule: #nextTokenA_Bstar_A.
!

testAorB
    fsa addState: a.
    fsa addState: b.
    fsa addState: c.
    fsa startState: a.
    fsa finalState: b.
    fsa finalState: c.
    
        
    fsa addTransitionFrom: a to: b on: $a.
    fsa addTransitionFrom: a to: c on: $b.	

    fsa name: #nextTokenAorB.
    b retval: #a.
    c retval: #b.

    scanner := (codeGenerator generateAndCompile: fsa).

    self parse: 'a' token: #a rule: #nextTokenAorB.
    self parse: 'b' token: #b rule: #nextTokenAorB.	

    self fail: 'c' rule: #nextTokenAorB.	
    self fail: 'c' rule: #nextTokenAorB.		
!

testAstarA
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $a.	

    fsa name: #nextTokenAstarA.
    b retval: #AstarA.

    self should: [codeGenerator generateAndCompile: fsa ] raise: Exception.
!

testAstarB
    fsa addState: a.
    fsa addState: b.
    fsa startState: a.
    fsa finalState: b.
    
    fsa addTransitionFrom: a to: a on: $a.
    fsa addTransitionFrom: a to: b on: $b.	

    fsa name: #nextTokenAstarB.
    b retval: #AstarB.

    scanner := (codeGenerator generateAndCompile: fsa).
    
    self parse: 'ab' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'b' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'aaab' token: #AstarB rule: #nextTokenAstarB.

    self fail: 'c' rule: #nextTokenAstarB.	
! !


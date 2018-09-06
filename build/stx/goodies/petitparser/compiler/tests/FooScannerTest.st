"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#FooScannerTest
	instanceVariableNames:'scanner result'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Tests-Scanner'
!


!FooScannerTest methodsFor:'as yet unclassified'!

fail: stream rule: rule 
    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner perform: rule.
    result := scanner polyResult.
        
    self assert: result isEmpty
!

fail: stream token: token rule: rule
    self fail: stream token: token rule: rule position: stream size
!

fail: stream token: token rule: rule position: position
    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner perform: rule.
    
    result := scanner polyResult.	
    self assert: (result at: token ifAbsent: [nil]) isNil.
!

parse: stream token: token rule: rule
    self parse: stream token: token rule: rule position: stream size.
!

parse: stream token: token rule: rule position: position
    scanner initialize.
    scanner stream: stream asPetitStream. 
    scanner perform: rule.
    result := scanner polyResult.
    
    self assert: (result includesKey: token).	
    self assert: (result at: token) = position.
!

setUp
    scanner := FooScanner new.
!

testA
    self parse: 'aaa' token: #a rule: #nextTokenA position: 1.
!

testAAorA
    self fail: 	'a' token: #aa rule: #nextTokenAAorA.
    self parse: 	'aa' token: #aa rule: #nextTokenAAorA.
    self parse: 	'aaa' token: #aa rule: #nextTokenAAorA position: 2.

    self parse: 	'a' token: #a rule: #nextTokenAAorA.
    self fail: 	'aa' token: #a rule: #nextTokenAAorA.
    self fail: 	'aaa' token: #a rule: #nextTokenAAorA.

    self fail: 'b' rule: #nextTokenAAorA.		
!

testAAplusA
    self parse: 'aaa' token: #AAplusA rule: #nextTokenAAplusA.
    self parse: 'aaaaa' token: #AAplusA rule: #nextTokenAAplusA.

    self fail: '' rule: #nextTokenAAplusA.
    self fail: 'a' rule: #nextTokenAAplusA.
    self fail: 'aa' rule: #nextTokenAAplusA.
    self fail: 'aaaa' rule: #nextTokenAAplusA.	
!

testAAstarA
    self parse: 'a' token: #AAstarA rule: #nextTokenAAstarA.
    self parse: 'aaa' token: #AAstarA rule: #nextTokenAAstarA.
    self parse: 'aaaaa' token: #AAstarA rule: #nextTokenAAstarA.

    self fail: '' rule: #nextTokenAAstarA.
    self fail: 'aa' rule: #nextTokenAAstarA.
    self fail: 'aaaa' rule: #nextTokenAAstarA.
!

testAB
    self parse: 'ab' token: #B rule: #nextTokenAB position: 2.
!

testABorBC
    self parse: 'ab' token: #ab rule: #nextTokenABorBC position: 2.
    self parse: 'bc' token: #bc rule: #nextTokenABorBC position: 2.
    
    self fail: 'ac' rule: #nextTokenABorBC.
!

testABstarA
    self parse: 'a' token: #ABstarA rule: #nextTokenABstarA position: 1.
    self parse: 'aa' token: #ABstarA rule: #nextTokenABstarA position: 1.
    self parse: 'aba' token: #ABstarA rule: #nextTokenABstarA position: 3.
    self parse: 'abaa' token: #ABstarA rule: #nextTokenABstarA position: 3.
    self parse: 'ababa' token: #ABstarA rule: #nextTokenABstarA position: 5.

    self fail: 'ab' rule: #nextTokenABstarA.
    self fail: 'abab' rule: #nextTokenABstarA.

    self fail: '' rule: #nextTokenABstarA.

!

testA_Bstar_A
    self parse: 'aa' token: #A_Bstar_A rule: #nextTokenA_Bstar_A.
    self parse: 'aba' token: #A_Bstar_A rule: #nextTokenA_Bstar_A.

    self fail: '' rule: #nextTokenABstarA.	
    self fail: 'ab' rule: #nextTokenABstarA.
!

testAorAA
    self fail: 	'a' token: #aa rule: #nextTokenAorAA.
    self fail: 	'aa' token: #aa rule: #nextTokenAorAA.
    self fail: 	'aaa' token: #aa rule: #nextTokenAorAA.

    self parse: 	'a' token: #a rule: #nextTokenAorAA position: 1.
    self parse: 	'aa' token: #a rule: #nextTokenAorAA position: 1.
    self parse: 	'aaa' token: #a rule: #nextTokenAorAA position: 1.

    self fail: 'b' rule: #nextTokenAAorA.		
!

testAorB
    self parse: 'a' token: #a rule: #nextTokenAorB.
    self parse: 'b' token: #b rule: #nextTokenAorB.	

    self parse: 'ab' token: #a rule: #nextTokenAorB position: 1.	
    self fail: 'c' rule: #nextTokenAorB.	
    self fail: 'c' rule: #nextTokenAorB.		
!

testAstarA
    self fail: '' rule: #nextTokenAstarA.
    self fail: 'a' rule: #nextTokenAstarA.
    self fail: 'aa' rule: #nextTokenAstarA.
    self fail: 'aaa' rule: #nextTokenAstarA.
!

testAstarB
    self parse: 'ab' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'b' token: #AstarB rule: #nextTokenAstarB.
    self parse: 'aaab' token: #AstarB rule: #nextTokenAstarB.

    self fail: 'c' rule: #nextTokenAstarB.	
! !

!FooScannerTest methodsFor:'multivalues'!

testAuorA
    self parse: 'a' token: #A1 rule: #nextTokenAuorA.
    self parse: 'a' token: #A2 rule: #nextTokenAuorA.

    self fail: 'b' rule: #nextTokenAuorA.	
!

testMultiA
    self parse: 'a' token: #A1 rule: #nextMultiTokenA position: 1.	
    self parse: 'a' token: #A2 rule: #nextMultiTokenA position: 1.
    
    self fail: 'b' rule: #nextMultiTokenA.
! !

!FooScannerTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


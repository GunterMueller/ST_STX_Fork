"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXFullTestRunner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Extras'
!


!DBXFullTestRunner class methodsFor:'as yet unclassified'!

backendsToTest
	| backends |
	backends := Set new.
	backends 
		add: DBXSqliteFacility;
		add: DBXMySQLFacility;
		add: DBXOracleFacility;	
		add: DBXPostgreFacility.
	^backends
!

testsToRun
	 ^DBXBaseTest allSubclasses
! !

!DBXFullTestRunner methodsFor:'tests'!

test: aBackend times: aNumber
	| result resultTest testsCount |
	testsCount := 0.
	aNumber timesRepeat:[ 
		Transcript show: aBackend name ; cr.
		
	 	[result := aBackend suite run.]
			on: Error do:[ 'nothing' ].
		
		(result hasFailures or: [result hasErrors] ) ifTrue: [self fail].
		testsCount := testsCount + result passedCount.
		
		self class testsToRun do:[ :eachTest | [resultTest := eachTest suite run] on: Error do:['nothing'].
			
		(resultTest hasFailures or: [result hasErrors] ) ifTrue: [self fail].	
		testsCount := testsCount + resultTest passedCount.
			 ].
		].
	
		Transcript open.
		Transcript show: ('Total tests: ' , testsCount asString); cr.
		Transcript show: 'Tested backend: '; cr.
		Transcript show: (aBackend name); cr.
!

testAllBackendsWithAllTests
	| resultTest testsCount |
	testsCount := 0.
	self class backendsToTest do:[ :each |

		Transcript show: each name ; cr.
	
		DBXBaseTest facility: each facilityForTest.
		
		self class testsToRun do:[ :eachTest | [resultTest := eachTest suite run] on: Error do:['nothing'].
			
		(resultTest hasFailures) ifTrue: [self fail].	
		testsCount := testsCount + resultTest passedCount.
			 ].
		].
	
		Transcript open.
		Transcript show: ('Total tests: ' , testsCount asString); cr.
		Transcript show: 'Tested backends: '; cr.
		self class backendsToTest do:[ :each | Transcript show: (each name); cr. ].
		Transcript show: ('Total tests per backend: ' , (testsCount / self class backendsToTest size) asString ); cr.
! !

!DBXFullTestRunner class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXFullTestRunner.st,v 1.2 2013-04-15 13:18:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXFullTestRunner.st,v 1.2 2013-04-15 13:18:18 cg Exp $'
! !


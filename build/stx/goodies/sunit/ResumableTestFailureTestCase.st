"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#ResumableTestFailureTestCase
	instanceVariableNames:'duplicateFailureLog'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!ResumableTestFailureTestCase methodsFor:'Not categorized'!

resumableTestFailureTest
	self
		assert: false description: 'You should see more than me' resumable: true;
		assert: false description: 'You should see more than me' resumable: true;
		assert: false description: 'You should see me last' resumable: false;
		assert: false description: 'You should not see me' resumable: true
! !

!ResumableTestFailureTestCase methodsFor:'logging'!

logFailure: aString
	duplicateFailureLog add: aString.
	super logFailure: aString.
! !

!ResumableTestFailureTestCase methodsFor:'running'!

setUp
	duplicateFailureLog := OrderedCollection with: 'In set up'.
!

tearDown
	self deny: 'You should not see me' = duplicateFailureLog last
			description: 'We saw the ''You should not see me'' failure'.
	self deny: 'You should see more than me' = duplicateFailureLog last
			description: 'We did not see more than a ''You should see more than me'' failure'.
!

testResumable
	| result suite |
	suite := TestSuite new.
	suite addTest: (self class selector: #errorTest).
	suite addTest: (self class selector: #regularTestFailureTest).
	suite addTest: (self class selector: #resumableTestFailureTest).
	suite addTest: (self class selector: #okTest).
	result := suite run.
	self assert: result failures size = 2;
		assert: result errors size = 1
! !

!ResumableTestFailureTestCase methodsFor:'test data'!

errorTest
	1 zork
!

failureTest
	self
		assert: false description: 'You should see me' resumable: true;
		assert: false description: 'You should see me too' resumable: true;
		assert: false description: 'You should see me last' resumable: false;
		assert: false description: 'You should not see me' resumable: true
!

okTest
	self assert: true
!

regularTestFailureTest
	self assert: false description: 'You should see me'
! !

!ResumableTestFailureTestCase class methodsFor:'documentation'!

version_SVN
    ^ '§Id: ResumableTestFailureTestCase.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !


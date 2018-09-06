"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#SimpleTestResourceTestCase
	instanceVariableNames:'resource'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!SimpleTestResourceTestCase class methodsFor:'accessing'!

resources
	^Array with: SimpleTestResource
! !

!SimpleTestResourceTestCase methodsFor:'Not categorized'!

testRan
	| case |

	case := self class selector: #setRun.
	case run.
	self assert: resource hasSetup.
	self assert: resource hasRun

!

testResourceInitRelease
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	suite addTest: (self class selector: #dummy).
	result := suite run.
	self assert: resource hasSetup

! !

!SimpleTestResourceTestCase methodsFor:'private'!

dummy
	self assert: resource hasSetup
		description: 'This test uses a resource but it was not set up'.
	self setRun.
	self assert: resource hasRun
		description: 'This test uses a resource but we could not interact with it'.
!

error
	'foo' odd
!

fail
	self assert: false
!

setRun
	resource setRun
! !

!SimpleTestResourceTestCase methodsFor:'running'!

setUp
	"Ensure that we error, not just fail, if resource is nil so that #should:raise: checks cannot mistake such an error for what they are trapping."

	resource := SimpleTestResource rawCurrentForTest.
	self deny: resource isNil
		description: 'SimpleTestResource has no current value in test'.
	self assert: resource class == SimpleTestResource
		description: 'SimpleTestResource current is not an instance of itself'.
	self assert: resource hasSetup
		description: 'This test uses a resource but it was not set up'.
!

testDebugTestWithResource
	"The debug will raise an error if the resource is not set up properly."

	self clearOuterResourceStateDuring:
		[(self class selector: #setRun) debug].
!

testResourceCollection
	self assert: self class buildSuiteFromSelectors resources size = self resources size
		description: 'The suite should have the same number of resources as its test'.
	self class buildSuiteFromSelectors resources do:
		[:each |
		self assert: (self resources includes: each)
			description: each name, ':  I have this resource but my suite does not'].
!

testRunSuiteWithResource
	| suite |
	suite := TestSuite new.
	suite addTest: (SimpleTestResourceTestCase selector: #error).
	suite addTest: (SimpleTestResourceTestCase selector: #fail).
	suite addTest: (self class selector: #dummy).
	self clearOuterResourceStateDuring:
		[self assert: suite run printString = '3 run, 1 passed, 1 failed, 1 error'
			description: 'A suite of tests needing SimpleTestResource did not run as expected'].
!

testRunTestWithResource
	self clearOuterResourceStateDuring:
		[self assert: (self class selector: #dummy) run printString
					= '1 run, 1 passed, 0 failed, 0 errors'
			description: 'A dummy test that needed a resource did not pass'].
! !

!SimpleTestResourceTestCase methodsFor:'utility'!

clearOuterResourceStateDuring: aBlock
	"This self-testing test must clear the outer state of its resources before starting and after finishing, so that it can construct test cases and suites of itself and test them."

	self assert: SimpleTestResource isAlreadyAvailable
		description: 'The resource was not set up for the test'.
	SimpleTestResource reset.
	self deny: SimpleTestResource isAlreadyAvailable
		description: 'The resource was still set up before we began the run'.
	^aBlock sunitEnsure:
		[self deny: SimpleTestResource isAlreadyAvailable
			description: 'The resource was still set up after we finished the run'.
		SimpleTestResource isAvailable.
		self assert: SimpleTestResource isAlreadyAvailable
			description: 'The resource was not set up again after the test'].
! !

!SimpleTestResourceTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/SimpleTestResourceTestCase.st,v 1.2 2011-06-29 19:15:49 cg Exp $'
!

version_SVN
    ^ '§Id: SimpleTestResourceTestCase.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !


"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#SUnitTest
	instanceVariableNames:'hasRun hasSetup hasRanOnce'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!

SUnitTest comment:'This is both an example of writing tests and a self test for the SUnit. The tests
here are pretty strange, since you want to make sure things blow up. You should
not generally have to write tests this complicated in structure, although they
will be far more complicated in terms of your own objects- more assertions, more
complicated setup. Kent says: "Never forget, however, that if the tests are hard
to write, something is probably wrong with the design".'
!


!SUnitTest methodsFor:'accessing'!

hasRun
	^hasRun
!

hasSetup
	^hasSetup
! !

!SUnitTest methodsFor:'private'!

assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount
    self assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount skipped: 0

    "Modified: / 03-09-2016 / 08:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount skipped: skippedCount

        self
                assert: aResult runCount = aRunCount;
                assert: aResult passedCount = aPassedCount;
                assert: aResult failureCount = aFailureCount;
                assert: aResult errorCount = anErrorCount;
                assert: aResult skippedCount = skippedCount

    "Created: / 03-09-2016 / 08:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error
	3 zork
!

fail
	self assert: false
!

failAndError
	self assert: false.
	self assert: false. " second failure "
	self error.
!

noop
!

setRun
	hasRun := true
!

skipped
        self skipIf: true description: 'Skipped'

    "Created: / 03-09-2016 / 08:55:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SUnitTest methodsFor:'running'!

setUp
	hasSetup := true
! !

!SUnitTest methodsFor:'testing'!

errorShouldntRaise
	self
		shouldnt: [self someMessageThatIsntUnderstood]
		raise: SUnitNameResolver notificationObject
!

testAssert
	self assert: true.
	self deny: false
!

testDefects
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	result := suite run.
	self assert: result defects asArray = (Array with: error with: failure).
	self
		assertForTestResult: result
		runCount: 2
		passed: 0
		failed: 1
		errors: 1
!

testDialectLocalizedException

	self
		should: [TestResult signalFailureWith: 'Foo']
		raise: TestResult failure.
	self
		should: [TestResult signalErrorWith: 'Foo']
		raise: TestResult error.
!

testError

	| case result |

	case := self class selector: #error.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1.

	case := self class selector: #errorShouldntRaise.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1
!

testException

	self
		should: [self error: 'foo']
		raise: TestResult error
!

testFail

	| case result |

	case := self class selector: #fail.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 1
		errors: 0
!

testIsNotRerunOnDebug

	| case |

	case := self class selector: #testRanOnlyOnce.
	case run.
	case debug
!

testRan

	| case |

	case := self class selector: #setRun.
	case run.
	self assert: case hasSetup.
	self assert: case hasRun
!

testRanOnlyOnce

	self assert: hasRanOnce ~= true.
	hasRanOnce := true
!

testResult

	| case result |

	case := self class selector: #noop.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0
!

testRunning

	(SUnitDelay forSeconds: 2) wait
!

testShould

	self
		should: [true];
		shouldnt: [false]
!

testSkip

        | case result |

        case := self class selector: #skipped.
        result := case run.

        self
                assertForTestResult: result
                runCount: 1
                passed: 0
                failed: 0
                errors: 0
                skipped: 1

    "Created: / 03-09-2016 / 08:53:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSuite

	| suite result |

	suite := TestSuite new.
	suite
		addTest: (self class selector: #noop);
		addTest: (self class selector: #fail);
		addTest: (self class selector: #error).

	result := suite run.

	self
		assertForTestResult: result
		runCount: 3
		passed: 1
		failed: 1
		errors: 1
! !

!SUnitTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/SUnitTest.st,v 1.11 2011-06-29 19:15:49 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: SUnitTest.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !


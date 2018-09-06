"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SimpleTestResourceTestCase subclass:#FailingTestResourceTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!FailingTestResourceTestCase methodsFor:'utility'!

clearOuterResourceStateDuring: aBlock
	"Make the resource impossible to make available, then ensure that every test raises a failure but not an error (which its setUp would do if it reached it and the resource were nil)."

	^super clearOuterResourceStateDuring:
		[SimpleTestResource preventAvailabilityDuring:
			[self should: aBlock raise: TestResult failure]]
! !

!FailingTestResourceTestCase class methodsFor:'documentation'!

version_SVN
    ^ '§Id: FailingTestResourceTestCase.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !


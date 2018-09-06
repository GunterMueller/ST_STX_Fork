"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

ManyTestResourceTestCase subclass:#CircularTestResourceTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!CircularTestResourceTestCase class methodsFor:'accessing'!

resources
	^super resources, (Array with: SimpleTestResourceCircular)
! !

!CircularTestResourceTestCase methodsFor:'running'!

testTearDownOrder
	SimpleTestResourceCircular preventAvailabilityDuring:
		[self should: [SimpleTestResourceCircular reset; isAvailable] raise: TestResult failure.
		self assert: SimpleTestResourceCircular rawCurrentForTest == false
			description: 'Circular resource not in failed setUp state'.
		self assert: SimpleTestResourceCircular1 rawCurrentForTest == false
			description: 'Circular resource not in failed setUp state'.
		super testTearDownOrder.
		self assert: SimpleTestResourceCircular1 rawCurrentForTest == nil
			description: 'Circular resource not in failed setUp state'.
		self assert: SimpleTestResourceCircular rawCurrentForTest == nil
			description: 'Circular resource not reset after pre-tearDown iteration'].
! !

!CircularTestResourceTestCase methodsFor:'utility'!

clearOuterResourceStateDuring: aBlock
	"To let the test run at all, we only make it circular when the preventAvailability instvar is set."

	^super clearOuterResourceStateDuring:
		[SimpleTestResourceCircular reset.
		self deny: SimpleTestResourceCircular1 isAlreadyAvailable
			description: 'SimpleTestResourceCircular1 should never be available'.
		SimpleTestResourceCircular preventAvailabilityDuring:
			[self should: aBlock raise: TestResult failure].
		self deny: SimpleTestResourceCircular isAlreadyAvailable
			description: 'SimpleTestResourceCircular was set up despite having circularity set'].
! !

!CircularTestResourceTestCase class methodsFor:'documentation'!

version_SVN
    ^ '§Id: CircularTestResourceTestCase.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !


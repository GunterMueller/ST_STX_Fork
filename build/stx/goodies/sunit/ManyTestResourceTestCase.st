"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

SimpleTestResourceTestCase subclass:#ManyTestResourceTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!ManyTestResourceTestCase class methodsFor:'accessing'!

resources
	^super resources, (Array with: SimpleTestResourceA with: SimpleTestResourceB)
! !

!ManyTestResourceTestCase class methodsFor:'testing'!

shouldInheritSelectors
	^true
! !

!ManyTestResourceTestCase methodsFor:'running'!

testTearDownOrder
	| myResourceSetUpOrder myResourceReverseTearDownOrder |
	myResourceReverseTearDownOrder := OrderedCollection new: 7.
	myResourceSetUpOrder := (OrderedCollection new: 7)
		add: SimpleTestResource;
		add: SimpleTestResourceA1;
		add: SimpleTestResourceA2;
		add: SimpleTestResourceA;
		add: SimpleTestResourceB1;
		add: SimpleTestResourceB;
		yourself.
	self assert: (myResourceSetUpOrder allSatisfy: [:each | each isAvailable])
		description: 'At test start, not all my resources were set up'.
	self class resources do:
		[:each | each resetOrAddResourcesTo: myResourceReverseTearDownOrder].
	self assert: myResourceReverseTearDownOrder = myResourceSetUpOrder
		description: 'Wrong order for tearDown'.
	self assert: (myResourceSetUpOrder allSatisfy: [:each | each isAvailable])
		description: 'At test start, not all my resources were set up'.
! !

!ManyTestResourceTestCase methodsFor:'utility'!

clearOuterResourceStateDuring: aBlock
	"This self-testing test must clear the outer state of its resources before starting and after finishing, so that it can construct test cases and suites of itself and test them."

	self assert: SimpleTestResourceA1 isAlreadyAvailable
		description: 'The resource was not set up for the test'.
	SimpleTestResourceA reset.
	SimpleTestResourceB reset.
	SimpleTestResourceA1 reset.
	self deny: SimpleTestResourceA1 isAlreadyAvailable
		description: 'The resource was still set up before we began the run'.
	^[super clearOuterResourceStateDuring: aBlock] sunitEnsure:
		[self deny: SimpleTestResourceA1 isAlreadyAvailable
			description: 'The resource was still set up after we finished the run'.
		self deny: SimpleTestResourceB1 isAlreadyAvailable
			description: 'The resource was still set up after we finished the run'.
		SimpleTestResourceA isAvailable.
		self assert: SimpleTestResourceA1 isAlreadyAvailable
			description: 'The resource was not set up again after the test'.
		SimpleTestResourceB isAvailable.
		self assert: SimpleTestResourceB1 isAlreadyAvailable
			description: 'The resource was not set up again after the test'.].

    "Modified: / 11-09-2010 / 16:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ManyTestResourceTestCase class methodsFor:'documentation'!

version_SVN
    ^ '§Id: ManyTestResourceTestCase.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !


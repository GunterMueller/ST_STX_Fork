"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestAsserter subclass:#TestResource
	instanceVariableNames:'name description'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!

TestResource class instanceVariableNames:'current'

"
 No other class instance variables are inherited by this class.
"
!

!TestResource class methodsFor:'documentation'!

documentation
"
Normally a test will set up all the objects it needs and tear them down again after it has run.  
This self-containedness makes a test more robust.  
Use TestResources only for objects that are needed by several tests and that are too 'expensive' 
(in time or otherwise) to recreate and destroy for each test.  

A viable approach is to develop the code in MyTestCase's #setUp and #tearDown methods, 
then at some point refactor the code into the #setUp and #tearDown of a TestResource 
whose class is added to MyTestCase class>>resource method.

TestResource uses the singleton pattern.  
A TestResource class will set up a single instance of itself when first requested and tear it down again 
at the end of TestSuite>>run (or TestCase>>run, >>debug and >>debugAsFailure).  
Normally, a TestResource, once setUp, remains active during the running of all remaining tests 
and is #reset after all tests have run.  

For an exception, see subclass CompetingResource in SUnitResourcePatterns.  
Users can choose to #reset a resource in the #tearDown of a test that alters it, 
sacrificing the performance gain of having a single #setUp of the resource for the certainty 
that other tests using it will not see the alterations.  

Generally however, this should be the exception:  
if you need to reset the resource for every test that uses it, 
its code should just be part of your test's #setUp and #tearDown code.

To use, create a subclass of TestResource and override the following:
        - TestCase class>>resources, to return a collection including the TestResource class, 
          for all test case classes that need it
                * a TestCase' resources are set up in the order returned and torn down in the reverse order
        - TestResource class>>resources, if the resource itself always needs some other resource 
          to be present before it can set up
                * a TestResource's resource are set up before it and torn down after it, and are set up in the order returned and torn down in the reverse order
        - TestResource>>setUp and tearDown, to define initial and final behaviour (just like a test)
        - TestResource>>isAvailable, to return true if it is and false if it isn't 
          (the framework calls this after setUp);  ideally, this call should not change the resource' state 
           - that should be done in setUp

TestResource implements the singleton pattern in its class-side #isAvailable and #reset methods.  
Do not override these when creating specific resources;  unless you are developing a whole new pattern of use, 
it will always be correct to override instance-side #setUp, #tearDown and #isAvailable, 
and dangerous to override class>>isAvailable, class>>isAlreadyAvailable and class>>reset.

Generally, users do not code interactions with a test's resources during the running of a test.  
Code that reads a resource' values while leaving its state strictly alone is safe enough.  
A test must leave a resource in a clean state:  always use #reset if a test must protect 
later-running tests from unsafe changes (and review whether in such a case a resource 
is the right thing to use in the first place).

See my superclass' comment for assertion and logging information.
"
! !

!TestResource class methodsFor:'instance creation'!

new
	"Use #current to get the valid current instance.  Use of #new to get an instance (that should never be the current one) could be done in bizarre circumstances, so is not blocked, but will usually be inappropriate."

	^super new initialize
!

reset
	[self isAlreadyAvailable ifTrue: [current tearDown]]
		sunitEnsure: [current := nil].
! !

!TestResource class methodsFor:'accessing'!

current
	"This is a lazy accessor:  the assert of self isAvailable does no work unless current isNil.  However this method should normally be sent only to a resource that should already have been made available, e.g. in a test whose test case class has the resource class in its #resources, so should never be able to fail the assert.
	If the intent is indeed to access a possibly-unprepared or reset-in-earlier-test resource lazily, then preface the call of 'MyResource current' with 'MyResource availableFor: self'."

	self assert: self isAvailable
		description: 'Sent #current to unavailable resource ', self name, '.  Add it to test case'' class-side #resources (recommended) or send #availableFor: beforehand'.
	^current
!

resources
	^#()
! !

!TestResource class methodsFor:'creation'!

signalInitializationError
	^TestResult signalErrorWith: 'Resource ' , self name , ' could not be initialized'

! !

!TestResource class methodsFor:'private'!

makeAvailable
    "This method must be the _only_ way to set a notNil value for the unique instance (current).  First, obtain a candidate instance and set current to a notNil placeholder (any notNil object not an instance of me would do;  this version uses false).  Next, check any subordinate resources needed by this resource.  Lastly, setUp the candidate and put it in current if it is available, ensuring that it is torn down otherwise."
    
    |candidate didSetup|

    current := false.
    candidate := self new.
    self resources do:[:each | 
        each availableFor:candidate
    ].
    [
        didSetup := false.
        candidate setUp.
        didSetup := true.
        candidate isAvailable ifTrue:[
            current := candidate
        ]
    ] sunitEnsure:[
        didSetup ifTrue:[
            current == candidate ifFalse:[
                candidate safeTearDown
            ]
        ]
    ].

    "Modified: / 04-06-2014 / 12:39:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resetOrAddResourcesTo: aCollection
	"Add correctly set-up resources to the collection unless already there. Reset any imperfectly-set-up resources, so current isNil will return true if they are re-encountered via an indirectly self-prerequing resource;  circular references cannot be set up so will never reply true to isAlreadyAvailable, but may have correctly-set-up prereqs to add and/or imperfectly-set-up ones to reset, so do not abort the loop first time round."

	current isNil ifTrue: [^self].
	self isAlreadyAvailable
		ifFalse:
			[self reset.
			self resources do: [:each | each resetOrAddResourcesTo: aCollection]]
		ifTrue:
			[(aCollection includes: self) ifFalse:
				[self resources do: [:each | each resetOrAddResourcesTo: aCollection].
				aCollection add: self]].

"The cloned 'self resources do: ...' line in both blocks is, I think, the best way to write this method so that its logic is clear.  The first loop resets this resource immediately, before traversing its resources;  the second traverses before adding"
! !

!TestResource class methodsFor:'queries'!

isAbstract
	"Override to true if a TestResource subclass is Abstract and should not have
	TestCase instances built from it"

	^ self == TestResource
! !

!TestResource class methodsFor:'running'!

availableFor: aTestAsserter
	aTestAsserter
		assert: self isAvailable
		description: 'Unavailable resource ' , self name , ' requested by ', aTestAsserter printString.
!

resetResources: topLevelResources
	"Reset all imperfectly-set-up resources while gathering the rest for ordered resetting."

	| availableResources |
	availableResources := OrderedCollection new: topLevelResources size.
	topLevelResources do: [:each | each resetOrAddResourcesTo: availableResources].
	availableResources reverseDo: [:each | each reset].
! !

!TestResource class methodsFor:'testing'!

isAlreadyAvailable
	^current class == self
!

isAvailable
	"This is (and must be) a lazy method.  If my current has a value, an attempt to make me available has already been made:  trust its result.  If not, try to make me available."

	current isNil ifTrue: [self makeAvailable].
	^self isAlreadyAvailable
!

isUnavailable

	^self isAvailable not

! !

!TestResource methodsFor:'accessing'!

description

	description isNil
		ifTrue: [^''].

	^description
!

description: aString

	description := aString
!

name

	name isNil
		ifTrue: [^self printString].

	^name
!

name: aString

	name := aString
!

resources
	^self class resources
! !

!TestResource methodsFor:'initialize-release'!

initialize
	"This method used to call setUp but now does nothing;  setUp is called by the framework at the appropriate point.  Subclasses may override to set the object to its default state."
! !

!TestResource methodsFor:'printing'!

printOn: aStream

	aStream nextPutAll: self class printString
! !

!TestResource methodsFor:'private'!

safeTearDown
    "Have to handle Abort. When tearDown is called as inside an ensure block after
     an abort in the debugger of an errornous test case and raises an error with a debugger
     itself."

    AbortOperationRequest handle:[:ex| ] do:[self tearDown].
! !

!TestResource methodsFor:'running'!

setUp
	"Does nothing. Subclasses should override this to initialize their resource"
!

signalInitializationError
	^self class signalInitializationError

!

tearDown
	"Does nothing. Subclasses should override this to tear down their resource"
! !

!TestResource methodsFor:'testing'!

isAvailable
	"Override to provide information on the readiness of the resource.  Put state-changing behaviour in setUp and keep this a state-preserving check as far as possible.  Where setUp is guaranteed to provide a valid resource if it completes, there is no need to override this."

	^true
!

isUnavailable
	"override to provide information on the
	readiness of the resource"

	^self isAvailable not

! !

!TestResource class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


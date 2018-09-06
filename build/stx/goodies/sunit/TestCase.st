"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestAsserter subclass:#TestCase
	instanceVariableNames:'testSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!

TestCase class instanceVariableNames:'lastOutcomes'

"
 No other class instance variables are inherited by this class.
"
!


!TestCase class methodsFor:'initialization'!

flushAll

    "Flush all remembered outcomes in all testcases"

    self withAllSubclassesDo:[:cls|
	cls flushRememberedOutcomes
    ]

    "Created: / 17-11-2011 / 19:18:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushRememberedOutcomes

    "Flushes all remembered outcomes for the receiver"

    | outcomes |

    lastOutcomes isNil ifTrue:[^self].
    outcomes := lastOutcomes.
    lastOutcomes := nil.
    outcomes do:[:outcome|
	self lastTestRunResultChanged: outcome selector.
    ]

    "Created: / 17-11-2011 / 19:17:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    ResumableTestFailure autoload

    "
     self initialize
    "
!

postAutoload
    |pd|

    (pd := self projectDefinitionClass) notNil ifTrue:[
	pd loadExtensions
    ]

    "Modified: / 02-11-2011 / 15:44:58 / sr"
! !

!TestCase class methodsFor:'instance creation'!

asTestCase
    ^ self

    "Created: / 02-08-2011 / 09:12:13 / cg"
!

debug: aSymbol

	^(self selector: aSymbol) debug
!

run: aSymbol

	^(self selector: aSymbol) run
!

selector: aSymbol

	^self new setTestSelector: aSymbol
!

suite

	^self buildSuite
! !

!TestCase class methodsFor:'accessing'!

allTestSelectors
    | answer pivotClass lookupRoot |

    answer := Set withAll: self testSelectors.
    self shouldInheritSelectors ifTrue:[
        pivotClass := self superclass.
        lookupRoot := self lookupHierarchyRoot.
        [pivotClass == lookupRoot] whileFalse:[
            answer addAll: pivotClass testSelectors.
            pivotClass := pivotClass superclass.
        ]
    ].
    answer := answer asOrderedCollection.
    answer sort.
    ^ answer 

    "Modified: / 21-08-2011 / 15:06:11 / cg"
!

forgetLastTestRunResult

    Smalltalk changed:#lastTestRunResult with:(Array with:self with:nil).
    self changed:#lastTestRunResult.

    "Modified: / 06-08-2006 / 11:40:07 / cg"
    "Modified: / 20-08-2011 / 15:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTestSelector:aSelector

    ^aSelector notNil and:[aSelector startsWith:'test']

    "Created: / 06-08-2006 / 11:46:17 / cg"
    "Modified: / 05-12-2009 / 18:50:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 17:46:51 / cg"
!

lastTestRunResultOrNil
    "Returns a state (TestResult stateXXX), depending
     on the state of the tests:
	statePass if all tests passed,
	stateError if any error,
	stateFail if any fail,
     or nil if never run
    "

    |anyFail|

    lastOutcomes isNil ifTrue:[^nil].
    lastOutcomes size ~= self testSelectors size ifTrue:[^nil].
    anyFail := false.

    lastOutcomes do:[:outcome|
	outcome result == (TestResult stateError) ifTrue:[
	    ^ TestResult stateError
	].
	outcome result == (TestResult stateFail) ifTrue:[
	    anyFail := true
	].
    ].
    anyFail ifTrue:[ ^ TestResult stateFail ].
    ^ TestResult statePass

    "Modified: / 20-08-2011 / 14:59:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupHierarchyRoot
	^TestCase
!

rememberOutcome: thisOutcome
    |thisTestCase someOtherOutcome someOtherTestCase    
     thisTestCaseSelector thisTestCaseClassName|

    thisTestCase := thisOutcome testCase.
    thisTestCaseSelector := thisTestCase selector.
    thisTestCaseClassName := thisTestCase class name.
    
    lastOutcomes isNil ifTrue:[
        lastOutcomes := OrderedCollection new.
    ].

    "Not a nice code, but portable (what: doWithIndex: is not portable?)"
    1 to: lastOutcomes size do:[:i|
        someOtherOutcome := lastOutcomes at: i.
        someOtherTestCase := someOtherOutcome testCase.
        "/ compare by classes name - in case it got redefined
        (someOtherTestCase selector == thisTestCaseSelector
        and: [someOtherTestCase class name = thisTestCaseClassName]) ifTrue:[
            "remember; for the timestamp and other info"
            lastOutcomes at: i put: thisOutcome.
            someOtherOutcome result ~= thisOutcome result ifTrue:[
                "but only send out change notification to browser if state has changed"
                self lastTestRunResultChanged: thisOutcome selector.
            ].
            ^self.
        ].
    ].
    lastOutcomes add: thisOutcome.
    self lastTestRunResultChanged: thisOutcome selector.
    ^self

    "Created: / 20-08-2011 / 12:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 16:19:07 / cg"
!

rememberedOutcomeFor: selector

    lastOutcomes isNil ifTrue:[^nil].
    ^lastOutcomes
	detect: [:outcome| outcome testCase selector == selector]
	ifNone:[nil].

    "Created: / 20-08-2011 / 14:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resources

	^#()
!

shouldFork

    ^false

    "Created: / 13-06-2011 / 16:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sunitVersion
	^'4.0'
!

testSelector:selector result: result
    "return true, if the last run of this test had the outcome result"

    lastOutcomes isNil ifTrue:[^false].
    ^ lastOutcomes
        contains:[:any|
            |tc|

            (tc := any testCase) class name = self name
            and:[tc selector == selector
            and:[any result == result]]
        ]

    "Created: / 20-08-2011 / 16:15:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 16:12:17 / cg"
!

testSelectorError:selector
    "return true, if the last run of this test failed"

    ^self testSelector: selector result: (TestResult stateError)

    "Created: / 15-03-2010 / 19:44:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectorFailed:selector
    "return true, if the last run of this test failed"

    ^self testSelector: selector result: (TestResult stateFail)

    "Modified: / 20-08-2011 / 16:16:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectorPassed:selector
    "return true, if the last run of this test passed"

   ^self testSelector: selector result: (TestResult statePass)

    "Created: / 15-03-2010 / 17:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectorSkipped:selector
    "return true, if the last run of this test was skipped"

   ^self testSelector: selector result: (TestResult stateSkip)

    "Created: / 15-03-2010 / 17:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectorsWithLastOutcomes
    lastOutcomes isNil ifTrue:[^#()].
    ^lastOutcomes collect:[:outcome| outcome testCase selector] as:Set
! !

!TestCase class methodsFor:'building suites'!

buildSuite
	| suite |
	self isAbstract
		ifTrue:
			[suite := self suiteClass named: self name asString.
			self allSubclasses
				do: [:each | each isAbstract ifFalse: [suite addTest: each buildSuiteFromSelectors]].
			^ suite]
		ifFalse: [^ self buildSuiteFromSelectors]
!

buildSuiteFromMethods: testMethods

	^testMethods
		inject: (self suiteClass named: self name asString)
		into: [:suite :selector |
			suite
				addTest: (self selector: selector);
				yourself]
!

buildSuiteFromSelectors
	^self buildSuiteFromMethods: self allTestSelectors
!

suiteClass
	^TestSuite
! !

!TestCase class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    |lastResult|

    self theNonMetaclass isAbstract ifTrue:[^ super iconInBrowserSymbol].

    lastResult := self lastTestRunResultOrNil.
    lastResult notNil ifTrue:[
        lastResult == TestResult statePass ifTrue:[
            ^ #testCasePassedIcon
        ].
        lastResult == TestResult stateFail ifTrue:[
            ^ #testCaseFailedIcon
        ].
        lastResult == TestResult stateError ifTrue:[
            ^ #testCaseErrorIcon
        ].
    ].
    ^ #testCaseClassIcon
! !

!TestCase class methodsFor:'private'!

addSelector: selector to: collection

    "Adds given selector from collection. Answers
     true iff selector was really added"

    (collection includes: selector)
	ifTrue:[^ false]
	ifFalse:[collection add: selector. ^ true]

    "Created: / 15-03-2010 / 18:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-04-2010 / 23:19:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lastTestRunResultChanged: selector

    Smalltalk changed:#lastTestRunResult with:(Array with:self with:selector).
    self changed:#lastTestRunResult with:selector.

    "Created: / 15-03-2010 / 19:15:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSelectors
    "The API method is allTestSelectors which now includes #shouldInheritSelectors and so handles all cases.  Unlike that method, this does not guarantee to return a sorted ordered collection."

    |selectors|
    
    selectors := self sunitSelectors 
                    select: [:each | 'test*' sunitMatch: each].
    selectors := selectors asOrderedCollection.
    selectors sort.
    ^ selectors
! !

!TestCase class methodsFor:'queries'!

coveredClassNames
    "should be redefined to return a collection of classes which are tested by
     this suite/case. 
     If not redefined, coveredPackageNames should be.

     These classes can be instrumented for coverage analysis,
     before running the suite to provide coverage analysis/report"

    ^ #()

    "Created: / 06-07-2011 / 21:27:03 / cg"
!

coveredClasses
    "return a collection of classes which are tested by this suite/case.
     Do not redefine this; redefine either coveredClassNames or
     coveredPackageNames 
     (these return names, to avoid creating
     a package dependecy due to the class references)

     These classes can be instrumented for coverage analysis,
     before running the suite to provide coverage analysis/report"

    |names|
    
    (names := self coveredPackageNames) notEmptyOrNil ifTrue:[
        ^ names 
            collectAll:[:eachPackageOrPattern |
                eachPackageOrPattern includesMatchCharacters ifTrue:[
                    Smalltalk allClassesForWhich:[:cls | (cls package ?'') matches:eachPackageOrPattern].
                ] ifFalse:[    
                    Smalltalk allClassesInPackage:eachPackageOrPattern
                ]
        ].
    ].
    ^ self coveredClassNames collect:[:each | Smalltalk classNamed:each]
!

coveredPackageNames
    "redefine this in a concrete testCase class to return non-nil,
     to return a collection of packages which are tested by this suite/case.
     If not redefined, coveredClassNames should be redefined.
     The package names may be glob patterns.
     These classes can be instrumented for coverage analysis,
     before running the suite to provide coverage analysis/report"

    ^ nil
!

isAbstract
        "Override to true if a TestCase subclass is Abstract and should not have
        TestCase instances built from it"

        ^self == TestCase
! !

!TestCase class methodsFor:'quick testing'!

assert: aBoolean
    ^ self new assert: aBoolean

    "
     TestCase assert: true
    "
!

should: aBlock raise: anError
    ^ self new should: aBlock raise: anError

    "
     TestCase should:[ self error ] raise: Error
     TestCase should:[ 22 ] raise: Error
    "
! !

!TestCase class methodsFor:'running'!

run
    self suite run

    "
     SOAP::XeXMLTests run
    "
! !

!TestCase class methodsFor:'testing'!

isTestCaseLike

    ^true

    "Created: / 06-03-2011 / 00:16:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberResult:result

    result outcomesDo:[:outcome|self rememberOutcome: outcome].

    "Created: / 05-08-2006 / 12:33:08 / cg"
    "Modified: / 20-08-2011 / 14:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runTests

    ^self suite run

    "Modified: / 30-07-2011 / 09:26:11 / cg"
    "Modified: / 20-08-2011 / 16:14:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldInheritSelectors
	"I should inherit from an Abstract superclass but not from a concrete one by default, unless I have no testSelectors in which case I must be expecting to inherit them from my superclass.  If a test case with selectors wants to inherit selectors from a concrete superclass, override this to true in that subclass."

	^self ~~ self lookupHierarchyRoot
		and: [self superclass isAbstract
			or: [self testSelectors isEmpty]]
! !

!TestCase methodsFor:'accessing'!

resources
	"We give TestCase this instance-side method so that methods polymorphic with TestSuite can be code-identical.  Having this instance-side method also helps when writing tests of resource behaviour. Except for such tests, it is rare to override this method and should not be done without thought.  If there were a good reason why a single test case needed to share tests requiring different resources, it might be legitimate."

	^self class resources
!

selector
	^testSelector
!

shouldFork

    ^self class shouldFork

    "Created: / 13-06-2011 / 16:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldSkip
    "Returns true, if this testcase should be skipped when a testsuite is run.
     This only a hint, a test runner is not obliged to respect return value.
     To skip a test, mark the method with a <skip> annotation
     Currently, the only user is stx/goodies/builder/reports"

    | method |
    
    method := self class lookupMethodFor: testSelector.
    method annotationsAt:#ignore orAt: #skip do:[:annotation|
         ^true
    ].
    ^false

    "Created: / 28-11-2012 / 18:03:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCount

    ^1

    "Created: / 04-08-2011 / 13:03:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCase methodsFor:'accessing & queries'!

unfinished

	"indicates an unfinished test"
! !

!TestCase methodsFor:'assertions'!

assert:aBlock completesInSeconds:aNumber
    "fail, if aBlock does not finish its work in aNumber seconds"

    <resource: #skipInDebuggersWalkBack>

    |done process semaphore|

    done := false.
    semaphore := Semaphore new.
    process := [
	aBlock value.
	done := true.
	semaphore signal
    ] fork.
    semaphore waitWithTimeout: aNumber.
    process terminate.
    self assert: done

    "
     self new assert:[Delay waitForSeconds:2] completesInSeconds:1
    "
    "
     self new assert:[Delay waitForSeconds:1] completesInSeconds:2
    "
!

assert: aBoolean message:messageIfFailing
     <resource: #skipInDebuggersWalkBack>

    ^self assert: aBoolean description: messageIfFailing

    "Modified: / 15-12-2012 / 17:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assertFalse:aBoolean
    <resource: #skipInDebuggersWalkBack>

    ^ self assert:aBoolean not
!

assertFalse:aBoolean named:testName
    <resource: #skipInDebuggersWalkBack>

    ^ self assert:aBoolean not
!

assertTrue:aBoolean
    <resource: #skipInDebuggersWalkBack>

    ^ self assert:aBoolean
!

assertTrue:aBoolean named:testName
    <resource: #skipInDebuggersWalkBack>

    ^ self assert:aBoolean
! !

!TestCase methodsFor:'dependencies'!

addDependentToHierachy: anObject
	"an empty method. for Composite compability with TestSuite"
!

removeDependentFromHierachy: anObject
	"an empty method. for Composite compability with TestSuite"
! !

!TestCase methodsFor:'deprecated'!

should: aBlock
	self assert: aBlock value
!

should: aBlock description: aString
	self assert: aBlock value description: aString
!

shouldnt: aBlock
	self deny: aBlock value
!

shouldnt: aBlock description: aString
	self deny: aBlock value description: aString
!

signalFailure: aString
	TestResult failure sunitSignalWith: aString.
! !

!TestCase methodsFor:'printing'!

getTestName

    ^testSelector.

    "Modified: / 05-12-2009 / 17:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
	^ self class name.
!

printOn: aStream
	self class printOn:aStream.
	aStream nextPutAll: '>>#'.
	testSelector printOn:aStream.
! !

!TestCase methodsFor:'private'!

executeShould: aBlock inScopeOf: anExceptionalEvent
"/        ^[aBlock value.
"/        false] sunitOn: anExceptionalEvent
"/                do: [:ex | ex sunitExitWith: true]

"/        [[aBlock value]
"/                on: anExceptionalEvent
"/                do: [:ex | ^true]]
"/                        on: TestResult exError
"/                        do: [:ex | ^false].
	[aBlock value]
		on: anExceptionalEvent
		do: [:ex | ^true].

	^false.
!

performTest
    self perform: testSelector sunitAsSymbol
!

safeTearDown
    "Have to handle Abort. When tearDown is called as inside an ensure block after
     an abort in the debugger of an errornous test case and raises an error with a debugger
     itself."

    AbortOperationRequest handle:[:ex| ] do:[self tearDown].
!

setTestSelector: aSymbol
	testSelector := aSymbol
!

signalFailure:aString resumable:isResumable
    "/        TestResult failure sunitSignalWith: aString

    <resource: #skipInDebuggersWalkBack>

    isResumable ifTrue:[
	TestResult resumableFailure
	    raiseRequestWith:nil
	    errorString:aString
	    in:thisContext sender sender
    ] ifFalse:[
	TestResult failure
	    raiseErrorString:aString
	    in:thisContext sender sender
    ].

    "Modified: / 06-08-2006 / 22:55:55 / cg"
!

signalUnavailableResources

    self resources do:[:res |
	res isAvailable ifFalse:[
	    ^ res signalInitializationError
	]
    ].
! !

!TestCase methodsFor:'queries'!

isTestCase
    ^ true
!

isTestCaseLike
    ^ true

    "Created: / 29-06-2011 / 20:37:57 / cg"
!

isTestSuite
    ^ false
! !

!TestCase methodsFor:'running'!

debug

    | testCase outcome result wasProceeded|

    [
	result := TestResult stateError.
	wasProceeded := false.

	[
	    (testCase := self class selector: testSelector) runCase.
	    wasProceeded ifFalse:[
		result := TestResult statePass.
	    ]
	] sunitOn:(TestResult failure) do: [:ex |
	    ex creator == TestSkipped ifTrue:[
		result := TestResult stateSkip.
	    ] ifFalse:[
		result := TestResult stateFail.
	    ].
	    "I want a debugger to open here..."
	    "the only really portable dialect query..."
	    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
		"/ debug
		Debugger
		    enter:ex raiseContext
		    withMessage:(ex description)
		    mayProceed:true.
		wasProceeded := true.
		ex proceed.
	    ] ifFalse:[
		"is there a portable way to open a debugger?"
		self halt:(ex description).
		wasProceeded := true.
	    ].
	].

    ] sunitEnsure: [
	" if proceeded in the debugger, we arrive here; "
	" but still, this is not always a pass !! "
	outcome := TestCaseOutcome new.
	outcome testCase: testCase.
	outcome result: result.
	outcome remember.
	TestResource resetResources: self resources
    ].

    "Modified: / 07-07-2011 / 11:10:50 / jv"
    "Modified: / 07-07-2011 / 11:34:08 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Modified: / 20-08-2011 / 14:15:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debugAsFailure
	| semaphore |
	semaphore := Semaphore new.
	[semaphore wait. TestResource resetResources: self resources] fork.
	(self class selector: testSelector) runCaseAsFailure: semaphore.
!

debugUsing:aSymbol
    self signalUnavailableResources.
    [
	"/ used to be:
	"/  (self class selector:testSelector) perform:aSymbol
	"/ which is bad for subclasses which need more arguments.
	"/ why not use:
	"/  self copy perform:aSymbol
	"/ or even
	"/  self perform:aSymbol
	self perform:aSymbol
    ] ensure:[
	self resources do:[:each |
	    each reset
	]
    ]
!

failureLog
	^SUnitNameResolver class >> #defaultLogDevice
!

isLogging
	"By default, we're not logging failures. If you override this in
	a subclass, make sure that you override #failureLog"
	^false

!

logFailure: aString
	self isLogging ifTrue: [
		self failureLog
			cr;
			nextPutAll: aString;
			flush]

!

logSkipped: aString
	self isLogging ifTrue: [
		self failureLog
			cr;
			nextPutAll: aString;
			flush]
!

openDebuggerOnFailingTestMethod
	"SUnit has halted one step in front of the failing test method. Step over the 'self halt' and
	 send into 'self perform: testSelector' to see the failure from the beginning"

	self
		"/halt;
		performTest

    "Modified: / 05-12-2009 / 18:40:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run

    ^self run: TestResult defaultResultClass new

    "Modified: / 29-07-2011 / 12:07:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: aResult

    ^self run: aResult beforeEachDo: [:test :result|] afterEachDo: [:test :result|]

    "Modified: / 29-07-2011 / 12:07:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: aResult afterEachDo:block2

    ^self run: aResult beforeEachDo: [:test :result|] afterEachDo:block2

    "Modified: / 29-07-2011 / 12:07:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: aResult beforeEachDo:block1 afterEachDo:block2

    ^self run: aResult beforeEachDo:block1 afterEachDo:block2 resetResources: true

    "Modified: / 29-07-2011 / 12:06:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: result beforeEachDo: before afterEachDo: after resetResources: reset
    ^ self
	run: result
	beforeEachDo: before
	afterEachDo: after
	resetResources: reset
	debug: false

    "Created: / 29-07-2011 / 12:04:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 17:45:17 / cg"
!

run: result beforeEachDo: before afterEachDo: after resetResources: reset debug:doDebug

    "Workhorse for running a testcase. If reset is true, then
     the resources are reset, otherwise not"

    "1. Execute before block"
    "This code is ugly in Smalltalk/X but it is so because
     it is more portable - numArgs in ANSI (?)"
    before numArgs == 2 ifTrue:[
	before value: self value: result
    ] ifFalse:[
	before numArgs == 1 ifTrue:[
	    before value: self
	] ifFalse:[
	    before value.
	]
    ].

    "2. Run the testcase"
    reset ifTrue:[
	[
	    result runCase: self debugged:doDebug
	] sunitEnsure: [
	    TestResource resetResources: self resources
	].
    ] ifFalse:[
	result runCase: self debugged:doDebug
    ].

    "3. Execute after block"
    "This code is ugly in Smalltalk/X but it is so because
     it is more portable - numArgs in ANSI (?)"
    after numArgs == 2 ifTrue:[
	after value: self value: result
    ] ifFalse:[
	after numArgs == 1 ifTrue:[
	    after value: self
	] ifFalse:[
	    after value.
	]
    ].
    ^result

    "Created: / 29-07-2011 / 12:04:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 21-08-2011 / 17:44:56 / cg"
!

run: aResult beforeEachTestCaseDo:block1 afterEachTestCaseDo:block2

    <resource: #obsolete>
    self obsoleteMethodWarning: 'Use #run:beforeEachDo:afterEachDo: instead'.

    ^self run: aResult beforeEachDo:block1 afterEachDo:block2

    "Modified: / 29-07-2011 / 12:06:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCase
    |didSetup|

    self resources do: [:each | each availableFor: self].

    [
	didSetup := false.
	self setUp.
	didSetup := true.
	self performTest.
    ] sunitEnsure: [
	didSetup ifTrue:[ self safeTearDown ]
    ]

    "Modified (comment): / 18-08-2011 / 20:35:20 / cg"
!

runCaseAsFailure
    self setUp.
    [
	[self openDebuggerOnFailingTestMethod] ensure: [self safeTearDown]
    ] fork

    "Modified: / 21.6.2000 / 10:04:33 / Sames"
!

runCaseAsFailure: aSemaphore
    [
	|didSetup|

	didSetup := false.
	self resources do: [:each | each availableFor: self].
	[
	    self setUp.
	    didSetup := true.
	    self openDebuggerOnFailingTestMethod
	] sunitEnsure: [
	    didSetup ifTrue:[ self tearDown ]
	]
    ] sunitEnsure: [aSemaphore signal].
!

setUp
    "can be redefined in a concrete test"
!

tearDown
    "can be redefined in a concrete test"
! !

!TestCase class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


TestCase initialize!

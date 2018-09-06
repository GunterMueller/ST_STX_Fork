"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TestResult
	instanceVariableNames:'name timestamp failures errors passed skipped outcome'
	classVariableNames:'DefaultClass'
	poolDictionaries:''
	category:'SUnit-Base'
!

TestResult comment:''
!

!TestResult class methodsFor:'documentation'!

documentation
"
    runInfoPerTest:
        will keep additional info for a testCase run:
            startTime, endTime, backtrace (if fail or error) and collectedStdout
"
! !

!TestResult class methodsFor:'instance creation'!

new
    self == TestResult ifTrue:[
        ^ self defaultResultClass basicNew initialize.
    ] ifFalse:[
        ^ self basicNew initialize
    ].

    "
        TestResult new.
        TestResultForRunWithDebug new.
    "

    "Modified (comment): / 20-08-2011 / 17:34:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResult class methodsFor:'accessing'!

defaultResultClass
    DefaultClass notNil ifTrue:[^DefaultClass].

    ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        DefaultClass := TestResultStX.
        ^DefaultClass
    ].
    "Add more dialects here, if you want..."

    "Default"
    DefaultClass := self.

    "Created: / 16-08-2011 / 15:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResult class methodsFor:'constants'!

stateError
    ^ #error
!

stateFail
    "this symbol used to freak around everywhere in the code;
     and I was never sure if #fail or #failed is to be used."

    ^ #fail
!

statePass
    "this symbol used to freak around everywhere in the code;
     and I was never sure if #pass or #passed is to be used."

    ^ #pass
!

stateSkip
    ^ #skip
! !

!TestResult class methodsFor:'exceptions'!

error
	^self exError
!

exError
	^SUnitNameResolver errorObject
!

failure
	^TestFailure
!

resumableFailure
	^ResumableTestFailure
!

signalErrorWith: aString
	self error sunitSignalWith: aString
!

signalFailureWith: aString
	self failure sunitSignalWith: aString
!

skipped
        ^ TestSkipped
! !

!TestResult class methodsFor:'utilities'!

sourceFilenameOfClass:aClass
    ^ nil

    " use something like... "
    " ^ aClass classFilename asFilename pathName. "
! !

!TestResult methodsFor:'accessing'!

defects
	^OrderedCollection new
		addAll: self errors;
		addAll: self failures; yourself
!

endTime:aTimestamp
    "sets the overall (suite) end time"

    "/ ignored, for now (Neil should add it)
    "/ endTime := aTimestamp.
!

errorCount

        ^self errorOutcomes size

    "Modified: / 16-08-2011 / 15:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorOutcomes

    errors isNil ifTrue: [errors := OrderedCollection new].
    ^errors

    "Created: / 16-08-2011 / 15:55:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errors

    errors isNil ifTrue: [^OrderedCollection new].
    ^errors collect:[:each|each testCase]

    "Modified (format): / 02-08-2012 / 15:40:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptions

    "Returns a set of exceptions to be handled. By default,
     failure and generic error is handled. This method may
     be overriden by custom TestResult subclasses to add more.
     For example, a 'self halt' is not handled by default
     exceptions set"

    ^self class failure , self class skipped , self class error

    "Created: / 03-08-2011 / 14:11:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executionTime
    "return the execution time (in seconds). 
     If unknown, or asked before or during a run, return nil"

    ^ nil
!

failureCount

        ^self failureOutcomes size

    "Modified: / 16-08-2011 / 15:58:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failureOutcomes

    failures isNil ifTrue: [failures := Set new].
    ^failures

    "Created: / 16-08-2011 / 15:56:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

failures
    "We use a Set, not an OrderedCollection as #errors and #passed do, 
     because a resumable test failure in a loop can raise many failures against the same test.  
     In current Sunit UIs, this could result in bizarre test count reporting (-27 tests run, and suchlike).  
     This will be reviewed."

    failures isNil ifTrue: [^OrderedCollection new].
    ^failures collect:[:each|each testCase]

    "Modified (format): / 02-08-2012 / 14:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

name:aString
    name := aString.
!

outcomes
    |all|

    all := OrderedCollection new.
    self outcomesDo:[:each | all add:each].
    ^ all.
!

outcomesDo: aBlock

    skipped notNil ifTrue:[skipped do: aBlock].
    failures notNil ifTrue:[failures do: aBlock].
    errors notNil ifTrue:[errors do: aBlock].
    passed notNil ifTrue:[passed do: aBlock].

    "Created: / 20-08-2011 / 14:01:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

passed
        passed isNil ifTrue: [
            "/ cg: exposed and added to (see TestRunnerEmbedded>>debug)
            passed := OrderedCollection new.
            ^ passed.
        ].
        ^passed collect:[:each|each testCase]

    "Modified: / 16-08-2011 / 15:54:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2011 / 11:19:57 / cg"
    "Modified (format): / 02-08-2012 / 14:55:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

passedCount

        ^self passedOutcomes size

    "Modified: / 16-08-2011 / 15:58:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

passedOutcomes

    passed isNil ifTrue: [passed := OrderedCollection new].
    ^passed

    "Created: / 16-08-2011 / 15:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCount

        ^self passedCount + self failureCount + self errorCount + self skippedCount

    "Modified: / 03-09-2016 / 09:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipped
        skipped isNil ifTrue: [
            "/ cg: exposed and added to (see TestRunnerEmbedded>>debug)
            skipped := OrderedCollection new.
            ^ skipped.
        ].
        ^skipped collect:[:each|each testCase]
!

skippedCount

        ^self skippedOutcomes size
!

skippedOutcomes

    skipped isNil ifTrue: [skipped := OrderedCollection new].
    ^skipped
!

testOutcomes

        ^(OrderedCollection new: self runCount)
                addAll: self passedOutcomes;
                addAll: self skippedOutcomes;
                addAll: self errorOutcomes;
                addAll: self failureOutcomes;
                yourself

    "Created: / 16-08-2011 / 16:42:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tests

        ^(OrderedCollection new: self runCount)
                addAll: self passed;
                addAll: self skipped;
                addAll: self errors;
                addAll: self failures;
                yourself
!

timestamp
    ^ timestamp
!

timestamp:aTimestamp
    timestamp := aTimestamp.
! !

!TestResult methodsFor:'adding / removing'!

addError:testcase detail:detail 
    "Called when a test outcome is error. testCase 
     is the errorneous testcase, detail is platform
     specific object describing the error. Actually,
     on all platforms exept GemStone, detail is an instance
     of an exception that caused the error"
    "JV2011-08-03: TODO: Validate the comment above with GS,
     possibly change name to 'exception'"


    outcome result: (TestResult stateError).
    outcome remember.
    ^ self errorOutcomes add:outcome.

    "Created: / 03-08-2011 / 13:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-08-2011 / 09:46:41 / cg"
    "Modified: / 20-08-2011 / 12:46:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addFailure:testcase detail:detail 
    "Called when a test fails. testCase is the failed 
     testcase, detail is platform specific object describing
     the failure. Actually, on all platforms exept GemStone,
     detail is an instance of an exception that caused the failure"
    "JV2011-08-03: TODO: Validate the comment above with GS,
     possibly change name to 'exception'"

     "Special handling here, because failures can be resumable"
    self failureOutcomes do:[:outcome | 
        outcome testCase = testcase ifTrue:[
            ^ self
        ].
    ].
    outcome result: (TestResult stateFail).
    outcome remember.
    ^ self failureOutcomes add: outcome

    "Created: / 03-08-2011 / 13:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-08-2011 / 09:55:17 / cg"
    "Modified: / 20-08-2011 / 12:46:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addPass:testCase 

    outcome result: (TestResult statePass).
    outcome remember.
    ^ self passedOutcomes add: outcome

    "Modified: / 20-08-2011 / 12:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSkipped:testCase 

    outcome result: (TestResult stateSkip).
    outcome remember.
    ^ self skippedOutcomes add: outcome
!

remove: aTestCase
    "Removes an outcome for given testcase, if any.
    Use with care."

    | remover |

    remover := [:outcomes|
        | o |

        outcomes notNil ifTrue:[
            o := outcomes detect:[:each|each testCase == aTestCase] ifNone: [nil].
            o notNil ifTrue:[outcomes remove: o. ^self].
        ].
    ].

    remover value: skipped.
    remover value: errors.
    remover value: failures.
    remover value: passed.

    "Created: / 16-01-2012 / 20:36:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResult methodsFor:'deprecated'!

correctCount
	"deprecated - use #passedCount"

	^self passedCount
! !

!TestResult methodsFor:'initialize-release'!

initialize
! !

!TestResult methodsFor:'outcome'!

createOutcome

    ^TestCaseOutcome new.

    "Created: / 16-08-2011 / 17:14:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberEndTime
    "remembers the endTime of the current test (in outcome)"

    ^nil

    "Created: / 16-08-2011 / 17:31:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberException:detail

    "Created: / 16-08-2011 / 17:35:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rememberStartTime
    "remembers the startTime of the current test (in outcome)"

    ^nil

    "Created: / 16-08-2011 / 17:31:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResult methodsFor:'printing'!

printOn: aStream

        aStream
                nextPutAll: self runCount printString;
                nextPutAll: ' run, ';
                nextPutAll: self passedCount printString;
                nextPutAll: ' passed, ';
                nextPutAll: self skippedCount printString;
                nextPutAll: ' skipped, ';
                nextPutAll: self failureCount printString;
                nextPutAll: ' failed, ';
                nextPutAll: self errorCount printString;
                nextPutAll: ' error'.

        self errorCount ~= 1
                ifTrue: [aStream nextPut: $s]
! !

!TestResult methodsFor:'running'!

performCase:aTestCase 
    "Actually performs the case. The TestCase>>runCase itself calls
     a setUp/tearDown methods. The possible error/failure is handled
     in TestResult>>runCase:. This method is meant to be overriden by
     custom TestResult subclasses."

    aTestCase runCase.

    "Modified: / 02-08-2011 / 18:10:09 / cg"
    "Created: / 03-08-2011 / 14:02:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-09-2016 / 09:02:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCase:aTestCase 
    "run a testcase, catching exceptions"

    self runCase:aTestCase debugged:false

    "Modified: / 16-08-2011 / 17:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 17:48:28 / cg"
!

runCase:aTestCase debugged:debugged
    "run a testcase, debugging exceptions"


    [
        [ 
            outcome := self createOutcome.
            outcome testCase: aTestCase.
            self rememberStartTime.
            self performCase:aTestCase.
            self rememberEndTime.
            self addPass:aTestCase.
            outcome := nil.
        ] sunitOn:self exceptions do: [:ex |
            self rememberEndTime.
            self rememberException: ex.
            (AbortSignal accepts: ex creator) ifTrue:[ex reject].
            (TerminateProcessRequest accepts: ex creator) ifTrue:[ex reject].
            debugged ifFalse:[
                ex sunitAnnounce:aTestCase toResult:self.
                "/ not reached, because sunitAnnouce returns from ex!!
            ].
            (TestSkipped accepts: ex creator) ifFalse:[
                self addFailure: aTestCase detail: ex.
            ].    
            self breakPoint:#cg.
            ex reject.
        ].
    ] sunitOn: self exceptions do:[:ex|
        (TestSkipped accepts: ex creator) ifTrue:[ex return].
        (AbortSignal accepts: ex creator) ifTrue:[ex reject].
        (TerminateProcessRequest accepts: ex creator) ifTrue:[ex reject].
        "/ the stuff below is rubbish - it clears out the info as collected above!!
        "/ self remove: aTestCase.
        debugged ifTrue:[ ex reject ].
    ]

    "Created: / 21-08-2011 / 17:48:19 / cg"
    "Modified: / 04-06-2012 / 18:50:15 / cg"
    "Modified: / 14-01-2013 / 13:28:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResult methodsFor:'testing'!

hasErrors

        ^self errors notEmptyOrNil
!

hasFailures

        ^self failures notEmptyOrNil
!

hasFailuresOrErrors
    ^ self hasFailures or:[self hasErrors]

    "Created: / 04-06-2012 / 19:06:52 / cg"
!

hasPassed

	^self hasErrors not and: [self hasFailures not]
!

hasSkipped

        ^self skipped notEmptyOrNil
!

isError: aTestCase

	^self errors includes: aTestCase
!

isFailure: aTestCase
	^self failures includes: aTestCase
!

isPassed: aTestCase

	^self passed includes: aTestCase
! !

!TestResult class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


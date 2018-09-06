"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

VMSpawningTestCase subclass:#VMCrashTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Abstract'
!

!VMCrashTestCase class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    A specialized abstract test case class for writing
    VM crash tests. The test is run in separate process
    if it eventually crashes the VM, it won't take whole test
    suite with it.

    Each test case *must* be annotated by one <spawn:> annotation,
    argument must be either `true` of `false`. If `true` then the
    test is run in a freshly started VM. If `false`, test is run
    in the same VM.

    As this is meant as a base class for regression tests that used to
    kill the VM, normally you should annotate tests with <spawn: true>

    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!VMCrashTestCase class methodsFor:'testing'!

isAbstract
    ^ self == RegressionTests::VMCrashTestCase
! !

!VMCrashTestCase methodsFor:'accessing'!

timeout
    "Returns a default timeout (sec) for the test.
     If nil is returned, no timeout enforced.

    Note that the timeout is set only when running under
    report runner, interactive tools does not use it"

    | method |
    method := self class lookupMethodFor: testSelector.
    method annotationsAt:#timeout: do:[:annotation|
	 ^annotation arguments first
    ].
    ^60"sec - default timeout"

    "Created: / 08-09-2014 / 13:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTestCase methodsFor:'running'!

runCase
    "Perform the testcase.

     If testcase is annotated by <spawn: false> the test is run in the
     very same VM. If <spawn: true>, a new VM is started and the testcase
     in run in that new VM"

    | spawn |

    spawn := (self class lookupMethodFor: testSelector) annotationAt: #spawn:.
    spawn isNil ifTrue:[
        self error: 'No <spawn:> annotation'.
    ].
    (spawn argumentAt: 1) == false ifTrue:[
        ^ super runCase.
    ] ifFalse:[
        (spawn argumentAt: 1) ~~ true ifTrue:[
            self error: 'Argument to <spawn:> must be either `true` or `false`'.
        ]
    ].
    self spawnSelector:#runCaseInternal  

    "
    VMCrashTestCase run:#test_infrastructure
    "

    "Created: / 04-09-2014 / 18:13:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2016 / 07:56:21 / jv"
    "Modified: / 06-01-2017 / 21:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runCaseInternal
    super runCase

    "Created: / 04-09-2014 / 17:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2016 / 07:53:15 / jv"
    "Modified: / 05-01-2017 / 23:18:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VMCrashTestCase methodsFor:'tests - infrastructure'!

test_infrastructure
    "
    VMCrashTestCase run:#test_infrastructure
    "
    <spawn: false>

    | result |

    result := self class run: #tst_pass.
    self assert: result passedCount = 1.
    self assert: result failureCount = 0.
    self assert: result errorCount = 0.
    self assert: result skippedCount = 0.

    result := self class run: #tst_fail.
    self assert: result passedCount = 0.
    self assert: result failureCount = 1.
    self assert: result errorCount = 0.
    self assert: result skippedCount = 0.

    result := self class run: #tst_error.
    self assert: result passedCount = 0.
    self assert: result failureCount = 0.
    self assert: result errorCount = 1.
    self assert: result skippedCount = 0.

    result := self class run: #tst_skip.
    self assert: result passedCount = 0.
    self assert: result failureCount = 0.
    self assert: result errorCount = 0.
    self assert: result skippedCount = 1.     

    "
    VMCrashTestCase run: #tst_crash.
    "
    result := self class run: #tst_crash.
    self assert: result passedCount = 0.
    self assert: result failureCount = 0.
    self assert: result errorCount = 1.
    self assert: result skippedCount = 0.

    "Created: / 05-09-2014 / 18:22:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2014 / 12:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-09-2016 / 07:44:57 / jv"
!

tst_crash

    <spawn: true>

    | bytes |

    Stdout nextPutLine: 'Going to crash now!!'.

    bytes := ExternalBytes address: 16r10 size: 100.
    bytes byteAt: 1 put: 10.

    "Created: / 05-09-2014 / 18:24:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2014 / 20:30:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tst_error
    <spawn: true>
    self error:'Error'

    "Created: / 05-09-2014 / 18:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2014 / 12:26:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tst_fail
    <spawn: true>
    self assert: false.

    "Created: / 05-09-2014 / 18:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2014 / 12:26:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tst_pass
    <spawn: true>

    "Created: / 05-09-2014 / 18:20:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2014 / 12:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tst_skip
    <spawn: true>
    self skipIf: true description: 'Skip the test to test skipping'

    "Created: / 03-09-2016 / 07:42:55 / jv"
! !

!VMCrashTestCase class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


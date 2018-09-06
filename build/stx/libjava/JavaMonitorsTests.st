"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#JavaMonitorsTests
	instanceVariableNames:'result reason thisProcess assertionAccess thisProcessAccess'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaMonitorsTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaMonitorsTests class methodsFor:'accessing'!

resources

  ^ Array 
        with: JavaInitializedResource 
        with: JavaLibrariesResource
        with: JavaTestsResource

    "Created: / 30-03-2012 / 13:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitorsTests methodsFor:'accessing'!

timeout
    ^60 * 5 "/5 min"

    "Created: / 03-12-2012 / 19:35:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitorsTests methodsFor:'mh exploratory tests'!

_testAssertInAnotherThreadShouldFail
    | t |
    "i thought so"
    t := [
        self assert: false message: 'I just want it to fail'.
        self waitForAndResumeThisProcess
    ] newProcess.
    t resume.
    self stop.
    self validateResult.

    "Created: / 26-08-2012 / 19:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testIssSemaphoreSignalledAutomaticallyOnStop
    | t1  t2  mon |
    mon := JavaMonitor for: self.
    t1 := [
                mon acquire.
                self assert: (mon owningProcess == t1) message: 'mon was not owned by t1 in t1'.
                t1 stop.
                mon release
            ] newProcess.
    t2 := [
                [ t1 isStopped ] whileFalse: [ Delay waitForMilliseconds: 100 ].
                self assert: (mon owningProcess == t1)
                    message: 'mon was not owned by t1 after t1 isStopped'.
                t1 resume.
                [ t1 isDead ] whileFalse: [ Delay waitForMilliseconds: 100. ].
                self waitForAndResumeThisProcess.
            ] newProcess.
    t1 resume.
    t2 resume.
    self stop.
    self validateResult.

    "Created: / 20-11-2011 / 17:28:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:17:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testNotifyDoesNotMeanAcquireWithoutChecking
    "aparently it does"
    
    "| t1  t2  mon |
    mon := JavaMonitor new.
    t1 := [
                mon enter.
                t1 stop.
                self assert: (mon isOwnedBy: t1)
                    message: 'monitor was not owned by t1 after resume'.
                mon exit
            ] newProcess.
    t2 := [
                self waitForStoppingThread: t1.
                self assert: (mon isOwnedBy: t1)
                    message: 'monitor was not owned by t1 after waiting for it to stop'.
                mon enter.
                self assert: (mon isOwnedBy: t2)
                    message: 'monitor was not owned by t2 after enter'.
                mon exit.
            ] newProcess.
    t1 resume.
    t2 resume.
    self waitForWaitingThread: t2.
    mon notify.
    t1 resume.
    self waitForDyingThread: t2.
    self validateResult."

    "Created: / 20-11-2011 / 20:50:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMonitorsTests methodsFor:'multithreading testing support'!

assert: aBoolean message: message 
    assertionAccess critical: [
    result ifTrue: [
        result := aBoolean.
        reason := message.
    ].].

    "Created: / 20-11-2011 / 18:54:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

setUp
    result := true.
    reason := 'Everything went just fine'.
    thisProcess := Processor activeProcess.
    assertionAccess := Semaphore forMutualExclusion.
    thisProcessAccess := Semaphore forMutualExclusion.

    "Created: / 20-11-2011 / 18:55:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

stop
    thisProcess stop.

    "Created: / 20-11-2011 / 19:07:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

validateResult  
    super assert: result message: reason.

    "Created: / 20-11-2011 / 18:55:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

waitForAndResumeThisProcess
    thisProcessAccess critical: [self waitForStoppingThread: thisProcess.
    thisProcess resume.]

    "Created: / 20-11-2011 / 19:17:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

waitForDyingThread: aThread 
  
[ aThread isDead ] whileFalse: [ Delay waitForMilliseconds: 100 ].

    "Created: / 20-11-2011 / 19:27:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

waitForStoppingThread: aThread
    [ aThread isStopped ] whileFalse: [ Delay waitForMilliseconds: 100 ].

    "Created: / 20-11-2011 / 19:17:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

waitForWaitingThread: aThread 
    [ aThread isWaiting ] whileFalse: [ Delay waitForMilliseconds: 100 ].

    "Created: / 20-11-2011 / 20:55:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMonitorsTests methodsFor:'tests'!

testBruteForceEnter
    | mon  threads  cleanupThread |
    mon := JavaMonitor for:self.
    threads := OrderedCollection new.
    20 timesRepeat: [
        | t |
        t := [
                    200 timesRepeat: [
                        mon acquire.
                        self assert: (mon owningProcess ==  t)
                            message: 'monitor was not owned by t after enter'.
                        Delay waitForMilliseconds: 2.
                        mon release.
                        self assert: (mon owningProcess ~~ t)
                            message: 'monitor was still owned by t after exit'.
                    ]
                ] newProcess.
        threads add: t
    ].
    cleanupThread := [
                threads do: [:each | self waitForDyingThread: each ].
                self waitForAndResumeThisProcess.
            ] newProcess.
    threads do: [:each | each resume ].
    cleanupThread resume.
    self stop.
    self validateResult.

    "Created: / 20-11-2011 / 19:37:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOneThread
    | mon  thread |
    mon := JavaMonitor for:self.
    thread := [
                self assert: mon owningProcess isNil
                    message: 'monitor was acquired at the beginning'.
                mon acquire.
                self assert: mon owningProcess notNil
                    message: 'monitor was not acquired after monitor enter'.
                self assert: (mon owningProcess == Processor activeProcess)
                    message: 'somebody else owned monitor after monitor enter'.
                mon release.
                self assert: mon owningProcess isNil
                    message: 'monitor was still acquired after monitor release'.
                "/ JV@2017-06-03: No longer valid as JavaMonitor no longer maintains
                "/ list of 'entered' processed. Seems useless except of testing.
                "/ self assert: (mon processesEntered includes: Processor activeProcess)
                "/    message: 'thread was not in the processesEntered after release'.
                mon acquire.
                self assert: mon owningProcess notNil
                    message: 'monitor was not acquired after monitor acquire'.
                mon release.
                self assert: mon owningProcess isNil
                    message: 'monitor stayed acquired after monitor exit'.
                self assert: (mon processesEntered includes: Processor activeProcess) not
                    message: 'process was still in the processesEntered after monitorExit'.
                self waitForAndResumeThisProcess.
            ] newProcess.
    thread resume.
    self stop.
    self validateResult.

    "Created: / 20-11-2011 / 13:20:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:17:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOneThreadMultipleTimes
    | mon  t  count |
    mon := JavaMonitor for:self.
    count := 5.
    t := [
                count timesRepeat: [ mon acquire ].
                count timesRepeat: [
                    self assert: (mon owningProcess == t) message: 'mon was not owned by t1'.
                    mon release
                ].
                self waitForAndResumeThisProcess
            ] newProcess.
    t resume.
    self stop.
    self validateResult.

    "Created: / 22-11-2011 / 11:02:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTwoThreadMultipleTimes
    | mon  t1  t2 |
    mon := JavaMonitor for:self.
    t1 := [
                mon acquire.
                mon acquire.
                self assert: (mon owningProcess == t1)
                    message: 'mon was not owned by t1 after multiple enter'.
                mon release.
                t1 stop.
                self assert: (mon owningProcess == t1)
                    message: 'mon was not owned by t1 after single exit'.
                mon release.
                self waitForDyingThread: t2.
                self waitForAndResumeThisProcess
            ] newProcess.
    t2 := [
                self waitForStoppingThread: t1.
                self assert: (mon owningProcess == t1)
                    message: 'mon was not owned by t1 after stop'.
                t1 resume.
            ] newProcess.
    t1 resume.
    t2 resume.
    self stop.
    self assert: mon processesEntered isEmpty.
    self validateResult.

    "Created: / 22-11-2011 / 11:12:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTwoThreads
    "this took me a while :)"
    
    | mon  t1  t2 |
    mon := JavaMonitor for:self.
    t1 := [
                t1 stop.
                mon acquire.
                t2 resume.
                t1 stop.
                self assert: (mon processesEntered includes: t2)
                    message: 't2 was not in processesEntered after entering monitor'.
                mon release.
                t1 stop.
                mon acquire.
                self assert: (mon owningProcess == t1)
                    message: 'monitor was not owned by t1 after t2 exitted it'.
                mon release.
            ] newProcess.
    t2 := [
                self waitForStoppingThread: t1.
                t1 resume.
                t2 stop.
                self assert: mon owningProcess notNil
                    message: 'monitor was not acquired after t1 entered it'.
                self assert: (mon isOwnedBy: t1)
                    message: 'monitor was not owned by t1 after it entered it'.
                t1 resume.
                mon acquire.
                self assert: (mon owningProcess == t2)
                    message: 'monitor was not owned by t2 after waiting on enter'.
                mon release.
                t1 resume.
                self waitForDyingThread: t1.
                self waitForAndResumeThisProcess
            ] newProcess.
    t1 resume.
    t2 resume.
    self stop.
    self validateResult.

    "Created: / 20-11-2011 / 14:51:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitorsTests methodsFor:'tests-java'!

test_releasing_01
    "This tests call Java code in following setup:
        - a java method with handler that calls
        - a java method with finally that calls
        - a __synchronized java method with that calls
        - a java method throwing RuntimeException

     When first Java method returns, all monitors should be released"
    
    | javaTests |
    javaTests := JAVA stx libjava tests lang MonitorTests new.
    self assert: (javaTests instVarNamed: #'_lockWord_') = 0.
    javaTests test_releasing_01.
    self assert: (javaTests instVarNamed: #token) == 1101101.
    self assert: (javaTests instVarNamed: #'_lockWord_') = 0.

    "Created: / 07-04-2012 / 08:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-04-2012 / 15:11:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2017 / 22:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_releasing_02
    "This tests call Java code in following setup:
        - a smalltalk method (this one) with handler for RuntimeException
        - a java method with finally that calls
        - a __synchronized java method with that calls
        - a java method throwing RuntimeException

     When first Java method returns, all monitors should be released        
    "
    | javaTests caught |


    javaTests := JAVA stx libjava tests lang MonitorTests new.
    self assert: (javaTests instVarNamed: #'_lockWord_') = 0.
    caught := false.
    [
        javaTests instVarNamed: #token put: 3.
        javaTests test_releasing_01_finally.
    ] on: JAVA java lang RuntimeException do:[:ex|
        caught := true
    ].
    self assert: caught.
    self assert: (javaTests instVarNamed: #token) == 1003.
    self assert: (javaTests instVarNamed: #'_lockWord_') = 0.

    "Created: / 07-04-2012 / 08:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:45:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitorsTests methodsFor:'wait notify tests'!

testManyThreadsWaitNotifyAll
    | mon  threads |
    mon := JavaMonitor for:self.
    threads := OrderedCollection new.
    2 timesRepeat: [
        | t |
        t := [
                    mon acquire.
                    self assert: (mon owningProcess ==  t)
                        message: 'thread was not owned by t after enter'.
                    self waitForAndResumeThisProcess.
                    'resumed thisProcess' infoPrintCR.
                    mon waitForMilliseconds: nil.
                    'notified and alive' infoPrintCR.
                    self assert: (mon owningProcess == t)
                        message: 'thread was not owned by t after wait'.
                    mon release.
                    'dying' infoPrintCR.
                ] newProcess.
        threads add: t.
    ].
    threads do: [
        :each | 
        'resuming t' infoPrintCR.
        each resume
    ].
    threads do: [
        :each | 
        'stopping' infoPrintCR.
        self stop
    ].
    threads do: [
        :each | 
        'waiting for waiting' infoPrintCR.
        self waitForWaitingThread: each
    ].
    'sync barrier reached' infoPrintCR.
    mon acquire.
    mon notify: true.
    'threads has been notified' infoPrintCR.
    mon release.
    'monitor exitted' infoPrintCR.
    threads do: [
        :each | 
        'waiting for them to die' infoPrintCR.
        self waitForDyingThread: each
    ].
    self validateResult.

    "Created: / 22-11-2011 / 12:27:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:22:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOneThreadWaitMultipleEnters
    | mon  t |
    mon := JavaMonitor for:self.
    t := [
                mon acquire.
                mon acquire.
                mon acquire.
                self waitForAndResumeThisProcess.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after enter'.
                mon waitForMilliseconds: nil.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after wait'.
                mon release.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after wait'.
                mon release.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after wait'.
                mon release.
            ] newProcess.
    t resume.
    self stop.
    mon acquire.
    mon notify: false.
    mon release.
    self waitForDyingThread: t.
    self validateResult.

    "Created: / 22-11-2011 / 12:55:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:22:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOneThreadWaitNotify
    | mon  t |
    mon := JavaMonitor for:self.
    t := nil.
    t := [
                mon acquire.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after enter'.
                self waitForAndResumeThisProcess.
                mon waitForMilliseconds: nil.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after wait'.
                self waitForAndResumeThisProcess
            ] newProcess.
    t resume.
    self stop.
    mon acquire.
    mon notify: false.
    mon release.
    self stop.
    self validateResult.

    "Created: / 22-11-2011 / 11:51:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:22:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOneThreadWaitTimeout
    | mon  t |
    mon := JavaMonitor for:self.
    t := [
                mon acquire.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after enter'.
                
                "/notify will never come
                
                mon waitForMilliseconds: 500.
                self assert: (mon owningProcess == t)
                    message: 'thread was not owned by t after wait'.
            ] newProcess.
    t resume.
    self waitForDyingThread: t.
    self validateResult.

    "Created: / 22-11-2011 / 12:51:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:15:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitorsTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMonitorsTests.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


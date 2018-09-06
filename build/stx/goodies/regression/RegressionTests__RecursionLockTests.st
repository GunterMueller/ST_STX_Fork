"
 COPYRIGHT (c) 2017 Jan Vrany
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

ProcessSpawningTestCase subclass:#RecursionLockTests
	instanceVariableNames:'lock'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!RecursionLockTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!RecursionLockTests methodsFor:'running'!

setUp
    super setUp.
    lock := RecursionLock new name: self printString

    "Created: / 28-08-2017 / 21:49:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLockTests methodsFor:'tests'!

test_critical_01

    [
        | active |

        active := Processor activeProcess.

        self assert: lock owner isNil.
        self assert: lock count == 0.
        lock critical:[ 
            self assert: lock owner == active.
            self assert: lock count == 1.            
        ].
        self assert: lock owner isNil.
        self assert: lock count == 0.
    ] fork.

    "Created: / 28-08-2017 / 21:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_02

    [
        | active |

        active := Processor activeProcess.

        self assert: lock owner isNil.
        self assert: lock count == 0.
        lock critical:[ 
            lock critical:[ 
                lock critical:[
                    self assert: lock owner == active.
                    self assert: lock count == 3.            
                ].
                self assert: lock owner == active.
                self assert: lock count == 2. 
            ].
            self assert: lock owner == active.
            self assert: lock count == 1. 
        ].
        self assert: lock owner isNil.
        self assert: lock count == 0.
    ] fork.

    "Created: / 28-08-2017 / 21:54:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_03

    [
        | active |

        active := Processor activeProcess.

        self assert: lock owner isNil.
        self assert: lock count == 0.
        [
            lock critical:[ 
                self assert: lock owner == active.
                self assert: lock count == 1.            
                self error: 'Get out of here!!'.
            ].
            self assert: false.
        ] on: Error do:[:ex | 
            self assert: true.
        ].
            
        self assert: lock owner isNil.
        self assert: lock count == 0.
    ] fork.

    "Created: / 28-08-2017 / 21:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_04a
    | p |
    p := [
        | active |

        active := Processor activeProcess.
        lock critical:[ 
            active terminate.
        ].
    ] newProcess.
    p resume.
    [ p isDead ] whileFalse:[ Delay waitForMilliseconds:100 ].

    self assert: lock owner isNil.
    self assert: lock count == 0.

    "Created: / 28-08-2017 / 23:08:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_04b
    | p |
    p := [
        | active |

        active := Processor activeProcess.
        lock critical:[ 
            Processor yield.
            Delay waitForSeconds: 10.
        ].
    ] newProcess.
    p resume.
    self assert: p isDead not.
    p terminate.
    [ p isDead ] whileFalse:[ Delay waitForMilliseconds:100 ].

    self assert: lock owner isNil.
    self assert: lock count == 0.

    "Created: / 28-08-2017 / 23:09:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_05

    | resource blocker |

    blocker := Semaphore new: (10 - 1) negated.
    resource := 0.
    10 timesRepeat:[  
        [
            | active |

            active := Processor activeProcess.
            10000 timesRepeat:[
                lock critical:[ 
                    resource := resource + 1.
                    self assert: lock owner == active.
                    self assert: lock count == 1.
                    Processor yield.
                ]            
            ].
            blocker signal.
        ] fork.
    ].
    blocker wait.
    self assert: resource == ( 10000 * 10)

    "Created: / 28-08-2017 / 23:10:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_06a
    "
    This test makes sure that two threads cannot enter
    critical section of the lock at the same time.
    "

    | threadAstop threadAentered threadBstop threadBentered |

    threadAstop := false.
    threadBstop := false.

    threadAentered := false.
    threadBentered := false.

    "Thread A"
    [
       Stdout nextPutLine:'Thread A id: ', Processor activeProcess id printString.
       lock critical:[
            threadAentered := true.
            [ threadAstop ] whileFalse:[ Delay waitForMilliseconds: 100].
       ]
    ] fork.

    Delay waitForMilliseconds: 300.
    self assert: threadAentered.

    "Thread B"
    [
       Stdout nextPutLine:'Thread B id: ', Processor activeProcess id printString.
       lock critical:[
            threadBentered := true.
            [ threadBstop ] whileFalse:[ Delay waitForMilliseconds: 100].
       ]
    ] fork.

    Delay waitForMilliseconds: 300.
    self assert: threadBentered not.

    Delay waitForMilliseconds: 300.
    threadAstop := true.
    Delay waitForMilliseconds: 300.
    self assert: threadBentered.
    threadBstop := true.

    "Created: / 04-10-2017 / 08:14:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_06b
    "
    Like #test_critical_06b, but with nesting.
    "

    | threadAstop1 threadAstop2 threadAentered threadBstop threadBentered |

    threadAstop1 := threadAstop2 := false.
    threadBstop := false.

    threadAentered := false.
    threadBentered := false.

    "Thread A"
    [
       Stdout nextPutLine:'Thread A id: ', Processor activeProcess id printString.
       lock critical:[
            lock critical:[
                threadAentered := true.
                [ threadAstop1 ] whileFalse:[ Delay waitForMilliseconds: 100].
            ].
            [ threadAstop2 ] whileFalse:[ Delay waitForMilliseconds: 100].
       ]
    ] fork.

    Delay waitForMilliseconds: 300.
    self assert: threadAentered.

    "Thread B"
    [
       Stdout nextPutLine:'Thread B id: ', Processor activeProcess id printString.
       lock critical:[lock critical:[
            threadBentered := true.
            [ threadBstop ] whileFalse:[ Delay waitForMilliseconds: 100].
       ]]
    ] fork.

    Delay waitForMilliseconds: 300.
    self assert: threadBentered not.

    Delay waitForMilliseconds: 300.
    threadAstop1 := true.
    Delay waitForMilliseconds: 300.
    self assert: threadBentered not.

    Delay waitForMilliseconds: 300.
    threadAstop2 := true.
    Delay waitForMilliseconds: 300.
    self assert: threadBentered.
    threadBstop := true.

    "Created: / 04-10-2017 / 08:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_07

    [
        | active |

        active := Processor activeProcess.

        self assert: lock owner isNil.
        self assert: lock count == 0.
        [
            lock critical:[ 
                self assert: lock owner == active.
                self assert: lock count == 1.     
                Error raise.
            ].
            self assert: false.
        ] on: Error do:[:each | 
            self assert: true.
        ].
        self assert: lock owner isNil.
        self assert: lock count == 0.
    ] fork.

    "Created: / 11-12-2017 / 10:14:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_08

    | p1 p2 |

    p1 := [
        lock critical:[ 
            Delay waitForMilliseconds: 1000.  
        ].
    ] newProcess.

    p2 := [ 
        [ 
            Delay waitForMilliseconds: 100. "/ Give p1 chance to lock the thread.
            self assert: lock owner == p1.
            self assert: lock count == 1.         
            lock critical:[ 
                Delay waitForMilliseconds: 10. "/ Some tiny work
            ].
            self assert: false.
        ] valueWithWatchDog: [
            self assert: lock owner == p1.
            self assert: lock count == 1.         
        ] afterMilliseconds: 500.
    ] newProcess.

    p1 resume.
    p2 resume.

    "Created: / 11-12-2017 / 10:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_09a

    | p1 p2 |

    p1 := [
        lock critical:[ 
            Delay waitForMilliseconds: 1000.  
        ].
    ] newProcess.

    p2 := [ 
        | timeouted |

        timeouted := false.
        Delay waitForMilliseconds: 100. "/ Give p1 chance to lock the thread.
        self assert: lock owner == p1.
        self assert: lock count == 1.         
        lock critical: [ Delay waitForMilliseconds: 10 ] "/ Some tiny work.
            timeoutMs: 500
           ifBlocking: [ timeouted := true ].
        self assert: timeouted.
    ] newProcess.

    p1 resume.
    p2 resume.

    "Created: / 11-12-2017 / 14:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_09b

    | p1 p2 |

    p1 := [
        lock critical:[ 
            Delay waitForMilliseconds: 500.  
        ].
    ] newProcess.

    p2 := [ 
        | timedout |

        timedout := false.
        Delay waitForMilliseconds: 100. "/ Give p1 chance to lock the thread.
        self assert: lock owner == p1.
        self assert: lock count == 1.         
        lock critical: [ Delay waitForMilliseconds: 10 ] "/ Some tiny work.
            timeoutMs: 1000
           ifBlocking: [ timedout := true ].
        self assert: timedout not.
    ] newProcess.

    p1 resume.
    p2 resume.

    "Created: / 11-12-2017 / 14:09:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_10a

    | timedout |

    timedout := false.
    lock inflate.
    lock critical: [ ]
        timeoutMs: 100
       ifBlocking: [ timedout := true ].
    self assert: timedout not.

    "Created: / 11-12-2017 / 20:34:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_critical_10b

    | p1 p2 |

    p1 := [
        lock critical:[ 
            Delay waitForMilliseconds: 250.  
        ].
    ] newProcess.

    p2 := [ 
        | timedout |

        timedout := false.
        "/ Give p1 chance to lock the thread then try to lock
        "/ to force a contention.
        Delay waitForMilliseconds: 100. 
        self assert: lock owner == p1.
        self assert: lock count == 1.         
        lock critical: [ Delay waitForMilliseconds: 10 ]. 
        "/ Now try to lock again with timeout and make sure
        "/ we do not timeout
        lock critical: [ Delay waitForMilliseconds: 10 ]
            timeoutMs: 100
           ifBlocking: [ timedout := true ].
        self assert: timedout not.    
    ] newProcess.

    p1 resume.
    p2 resume.

    "Created: / 12-12-2017 / 08:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLockTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


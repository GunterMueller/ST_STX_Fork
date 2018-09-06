"
 COPYRIGHT (c) 1995 by Stefan Vogel / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

IdentitySet subclass:#SemaphoreSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!SemaphoreSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Stefan Vogel / Claus Gittinger
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
    SemaphoreSets allow waiting until one of several semaphores becomes available.
    They provide a waiting protocol which is compatible to Semaphore, 
    i.e. #wait and #waitWithTimeOut.

    [see also:]
        Semaphore
        Process ProcessorScheduler

    [author:]
        Stefan Vogel
"
!

examples
"
 the following example forks a process which waits on any
 of sema1, sema2 to be signalled. The main thread signals those.
                                                                        [exBegin]
    |sema1 sema2 semaSet proc|

    sema1 := Semaphore new.
    sema2 := Semaphore new.
    semaSet := SemaphoreSet with:sema1 with:sema2.

    proc := [
        [
            |ret name|

            ret := semaSet wait.
            ret == sema1 ifTrue:[
                name := 'sema1'
            ] ifFalse:[ 
                ret == sema2 ifTrue:[
                    name := 'sema2'
                ]
            ].
            Transcript showCR: name, ' raised'.
            ret == sema2 ifTrue:[
                proc terminate
            ]
        ] loop
    ] fork.

    (Delay forSeconds:3) wait.
    sema1 signal.
    (Delay forSeconds:3) wait.
    sema2 signal.
                                                                        [exEnd]


 the following example forks a process which waits on any
 of sema1, sema2 to be signalled, or a timeout to occur.
                                                                        [exBegin]
    |sema1 sema2 semaSet proc|

    sema1 := Semaphore new.
    sema2 := Semaphore new.
    semaSet := SemaphoreSet with:sema1 with:sema2.

    proc := [
        [
            |ret name|

            ret := semaSet waitWithTimeout:5.
            ret == sema1 ifTrue:[
                name := 'sema1'
            ] ifFalse:[ 
                ret == sema2 ifTrue:[
                    name := 'sema2'
                ] ifFalse:[
                    name := ret printString
                ]
            ].
            Transcript showCR: name, ' raised'.
            ret isNil ifTrue:[
                proc terminate
            ]
        ] loop
    ] fork.

    (Delay forSeconds:3) wait.
    sema1 signal.
    (Delay forSeconds:3) wait.
    sema2 signal.
                                                                        [exEnd]



 the following example forks a process which waits on input
 to arrive on any of 2 sharedQueues (with timeout)
 The main thread writes data into those queues.
                                                                        [exBegin]
    |q1 q2 semaSet proc|

    q1 := SharedQueue new.
    q2 := SharedQueue new.
    semaSet := SemaphoreSet with:(q1 readSemaphore) with:(q2 readSemaphore).

    proc := [
        [
            |ret whatHappened|

            ret := semaSet waitWithTimeout:5.
            ret == q1 readSemaphore ifTrue:[
                Transcript show:'q1 has data: '; show:q1 next; cr.
            ] ifFalse:[ 
                ret == q2 readSemaphore ifTrue:[
                    Transcript show:'q2 has data: '; show:q2 next; cr.
                ] ifFalse:[
                    Transcript showCR:'timeout'
                ]
            ].
        ] loop
    ] fork.

    (Delay forSeconds:3) wait.
    q1 nextPut:'one'.
    (Delay forSeconds:2) wait.
    q1 nextPut:'two'.
    (Delay forSeconds:2) wait.
    q1 nextPut:'three'.
    (Delay forSeconds:6) wait.
    proc terminate.
                                                                        [exEnd]
"
! !

!SemaphoreSet methodsFor:'waiting'!

wait
    "wait for any of the semaphores in the set to be signalled.
     Return the (first) semaphore which is triggered."

    |currentProcess gotSema wasBlocked mustUnregisterAllSemas|

    currentProcess := Processor activeProcess.
    mustUnregisterAllSemas := false.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        gotSema := self detect:[:eachSema|
            eachSema checkAndAddWaitingProcess:currentProcess
        ] ifNone:[].

        gotSema isNil ifTrue:[
            mustUnregisterAllSemas := true.
            [
                currentProcess suspendWithState:#wait.
            ] ifCurtailed:[
                OperatingSystem blockInterrupts.
                self do:[:eachSema |
                    eachSema removeWaitingProcess:currentProcess.
                ].
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].
        ].

        gotSema isNil
    ] whileTrue.

    "
      we finally got at least one of our semaphores.
      Now unregister from any semaphore, we are registered on.
    "
    self do:[:eachSema|
        (eachSema == gotSema and:[mustUnregisterAllSemas not]) ifTrue:[
            "done with registered semaphores"
            wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ^ gotSema
        ].
        eachSema removeWaitingProcess:currentProcess.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ gotSema

    "Modified: 15.12.1995 / 23:10:07 / stefan"
    "Modified: 20.8.1997 / 18:33:09 / cg"
!

waitWithTimeout:seconds
    "wait for any of the semaphore, but abort the wait after some time (seconds).
     Return the (first) triggered semaphore if any, nil if we return due to a timeout."

    |millis|

    seconds notNil ifTrue:[
        millis := seconds * 1000 
    ].
    ^ self waitWithTimeoutMs:millis.

    "Modified: 15.12.1995 / 23:10:54 / stefan"
    "Modified: 20.8.1997 / 18:33:23 / cg"
!

waitWithTimeoutMs:milliSeconds
    "wait for any of the semaphore, but abort the wait after some time.
     Return the (first) triggered semaphore if any, nil if we return due to a timeout."

    |currentProcess gotSema wasBlocked timeoutBlock timeoutOccurred mustUnregisterAllSemas|

    currentProcess := Processor activeProcess.
    timeoutOccurred := false.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        gotSema := self detect:[:eachSema|
            eachSema checkAndAddWaitingProcess:currentProcess
        ] ifNone:[].

        gotSema isNil ifTrue:[
            mustUnregisterAllSemas := true.
            (milliSeconds notNil and:[timeoutBlock isNil]) ifTrue:[
                |now endTime|

                milliSeconds == 0 ifTrue:[
                    "with zero-timeout, this is a poll"
                    self do:[:eachSema |
                        eachSema removeWaitingProcess:currentProcess.
                    ].
                    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
                    ^ nil
                ].
                "calculate the end-time"
                now := OperatingSystem getMillisecondTime.
                endTime := OperatingSystem millisecondTimeAdd:now and:milliSeconds.

                timeoutBlock := [
                        timeoutOccurred := true.
                        timeoutBlock := nil.
                        Processor resume:currentProcess.
                    ].
                Processor addTimedBlock:timeoutBlock for:currentProcess atMilliseconds:endTime.
            ].
            [
                currentProcess suspendWithState:#wait.
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                timeoutBlock notNil ifTrue:[
                    Processor removeTimedBlock:timeoutBlock.
                    timeoutBlock := nil.
                ].
                self do:[:eachSema |
                    eachSema removeWaitingProcess:currentProcess.
                ].
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].
        ].

        gotSema isNil and:[timeoutOccurred not]
    ] whileTrue.

    timeoutBlock notNil ifTrue:[
        Processor removeTimedBlock:timeoutBlock.
        timeoutBlock := nil.
    ].

    "we finally got a timeout or at least one of our semaphores.
     Unregister from any semaphore, we are registered with"

    self do:[:eachSema|
        (eachSema == gotSema and:[mustUnregisterAllSemas not]) ifTrue:[
            "done with registered semaphores"
            wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ^ gotSema
        ].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ gotSema

    "Modified: 15.12.1995 / 23:10:54 / stefan"
    "Modified: 20.8.1997 / 18:33:23 / cg"
! !

!SemaphoreSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


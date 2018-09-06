"
 COPYRIGHT (c) 2012 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#BoltLock
	instanceVariableNames:'state numReaders waitingProcesses name'
	classVariableNames:'StateFree StateLocked StateBusy StateWantLock'
	poolDictionaries:''
	category:'Kernel-Processes'
!

!BoltLock class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by Claus Gittinger
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
    A BoltLock (aka BoltVariable) is a 3-state semaphore, 
    useful to protect a resource against single writers, while allowing multiple
    readers to access the resource simultaneously.

    The lock is in one of 3 states:
        A; free - can be changed by a writer into the locked state, or by a reader
                  into the busy state.

        B; busy - can only be entered by another reader. left into free by last reader.

        C; locked  - a single writer has the lock; no other reader or writer is allowed
                     to acquire it

    [notice:]
        the original BoltLock was unfair in that new incoming readers could lock up a waiting writer.
        This has been fixed by adding a fourth state (wantToLock), which is set by a write-waiter to prevent
        new readers from getting the lock.

    [instance variables:]
        state                   <Symbol>

        numReaders              <Integer>               number of readers holding onto the lock

        waitingProcesses        <OrderedCollection>     waiting processes - will be served first
                                                        come first served when signalled.

        name                    <String>                a debugging aid: an optional userFriendly
                                                        name; helps to identify a semaphore easier.

    [see also:]
        Semaphore SemaphoreSet RecursionLock Monitor
        SharedQueue Delay 
        Process ProcessorScheduler

    [author:]
        Claus Gittinger
"
!

examples
"
    many processes synchronizing on a boltLock:
                                                        [exBegin]
        |lock readers readWriters currentWriter processes|

        lock := BoltLock new.

        readWriters := (1 to:10) collect:[:tNo |
                        [
                            10 timesRepeat:[
                                (Random nextIntegerBetween:1 and:6) == 1 ifTrue:[
                                    Transcript showCR:('thread %1: want to write...' bindWith:tNo).
                                    lock waitForWrite.
                                    currentWriter notNil ifTrue:[Transcript showCR:('ouch %1: writer is %2' bindWith:tNo with:currentWriter).self halt].
                                    currentWriter := tNo.
                                    Transcript showCR:('thread %1: **** write' bindWith:tNo).
                                    Delay waitForSeconds:(Random nextIntegerBetween:1 and:4).
                                    Transcript showCR:('thread %1: done writing.' bindWith:tNo).
                                    currentWriter := nil.
                                    lock release.
                                    Delay waitForSeconds:(Random nextIntegerBetween:1 and:4).
                                ] ifFalse:[
                                    Transcript showCR:('thread %1: want to read...' bindWith:tNo).
                                    lock waitForRead.
                                    currentWriter notNil ifTrue:[Transcript showCR:('ouch %1: writer is %2' bindWith:tNo with:currentWriter).self halt].
                                    Transcript showCR:('thread %1: ---- read' bindWith:tNo).
                                    Delay waitForSeconds:(Random nextIntegerBetween:1 and:4).
                                    Transcript showCR:('thread %1: done reading.' bindWith:tNo).
                                    lock release.
                                    Delay waitForSeconds:(Random nextIntegerBetween:1 and:4).
                                ].
                            ].
                            Transcript showCR:('thread %1: finished.').
                       ] newProcess name:('rw%1' bindWith:tNo).
                    ].

        readers := (11 to:20) collect:[:tNo |
                        [
                            10 timesRepeat:[
                                Transcript showCR:('thread %1: want to read...' bindWith:tNo).
                                lock waitForRead.
                                currentWriter notNil ifTrue:[Transcript showCR:('ouch %1: writer is %2' bindWith:tNo with:currentWriter).self halt].
                                Transcript showCR:('thread %1: ---- read' bindWith:tNo).
                                Delay waitForSeconds:(Random nextIntegerBetween:1 and:4).
                                Transcript showCR:('thread %1: done.' bindWith:tNo).
                                lock release.
                                Delay waitForSeconds:(Random nextIntegerBetween:1 and:4).
                            ].
                            Transcript showCR:('thread %1: finished.').
                       ] newProcess name:('r%1' bindWith:tNo).
                    ].

        processes := readWriters , readers.
        readWriters do:[:t | t resume].
        readers do:[:t | t resume].
                                                        [exEnd]
"
! !

!BoltLock class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!BoltLock class methodsFor:'class initialization'!

initialize
    StateFree := #free.
    StateBusy := #busy.
    StateLocked := #locked.
    StateWantLock := #wantLock.

    "Created: / 06-08-2012 / 15:49:44 / cg"
! !

!BoltLock methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    state := StateFree.
    numReaders := 0.
    waitingProcesses := OrderedCollection new.

    "Modified: / 06-08-2012 / 16:03:06 / cg"
! !

!BoltLock methodsFor:'private'!

addWaitingProcess:aProcess
    "add aProcess to the list of waiting processes.
     all processes are ordered first-come-first-serve.

     NOTE: must be called with blocked interrupts"

    "for now"
    waitingProcesses isNil ifTrue:[
        waitingProcesses := Array with:aProcess
    ] ifFalse:[
        waitingProcesses isArray ifTrue:[
            waitingProcesses := OrderedCollection withAll:waitingProcesses.
        ].
        waitingProcesses add:aProcess.
    ].

    "Created: / 06-08-2012 / 16:05:38 / cg"
!

removeWaitingProcess:aProcess
    "remove aProcess from the list of waiting processes
     NO action if it is not in the list.

     NOTE: must be called with blocked interrupts"

    |nWaiting|

    nWaiting := waitingProcesses size.
    nWaiting == 0 ifTrue:[^ self].

    nWaiting == 1 ifTrue:[
        (waitingProcesses at:1) == aProcess ifTrue:[
            waitingProcesses := nil.
        ].
        ^ self.
    ].
    waitingProcesses removeIdentical:aProcess ifAbsent:[].

    "Created: / 06-08-2012 / 16:06:00 / cg"
!

wakeupWaiters
    "remove all waiting processes from the list of waiting processes
     and resume them. 
     NOTE: Must be called when known that waitingProcesses is nonNil and
           also with blocked interrupts"

    |processes|

    processes := waitingProcesses.
    "/ do not set to nil - a waiting process may be suspended and will not be resumed...
    "/    waitingProcesses := nil.

    "/ todo: resume by priority; higher first.
    processes do:[:eachProcess | 
        "/ Transcript showCR:('   wakeup thread %1' bindWith:eachProcess name).
        Processor resume:eachProcess
    ].

    "Created: / 06-08-2012 / 16:05:01 / cg"
! !

!BoltLock methodsFor:'waiting'!

release
    "release the lock"

    |activeProcess wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    "/ Transcript showCR:'  release in state ',state.
    activeProcess := Processor activeProcess.
    state == StateLocked ifTrue:[
        "I am the writer"
        state := StateFree.
    ] ifFalse:[
        "I am a reader"
        numReaders := numReaders - 1.
        numReaders == 0 ifTrue:[
            state := StateFree.
        ]
    ].
    state == StateFree ifTrue:[
        waitingProcesses notEmptyOrNil ifTrue:[
            self wakeupWaiters.
        ].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Created: / 06-08-2012 / 16:00:04 / cg"
!

waitForRead
    "wait for the lock in order to read"

    |activeProcess wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    "/ Transcript showCR:'  waitForRead in state ',state.
    (state == StateFree or:[state == StateBusy]) ifFalse:[
        "being written; wait until released"
        activeProcess := Processor activeProcess.
        [
            self addWaitingProcess:activeProcess.
            [
                activeProcess suspendWithState:#waitForRead
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                self removeWaitingProcess:activeProcess.
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].
            self removeWaitingProcess:activeProcess.
        ] doUntil:[ state == StateFree or:[state == StateBusy] ].
    ].

    numReaders := numReaders + 1.
    state := StateBusy.

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Created: / 06-08-2012 / 15:49:08 / cg"
!

waitForWrite
    "wait for the lock in order to read"

    |activeProcess wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    "/ Transcript showCR:'  waitForWrite in state ',state.
    state ~~ StateFree ifTrue:[
        "being read or written"
        state == StateBusy ifTrue:[
            "/ no new readers
            state := StateWantLock
        ].

        activeProcess := Processor activeProcess.
        [
            self addWaitingProcess:activeProcess.
            [
                activeProcess suspendWithState:#waitForWrite
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                self removeWaitingProcess:activeProcess.
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].
            self removeWaitingProcess:activeProcess.
        ] doUntil:[ state == StateFree].
    ].

    state := StateLocked.

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Created: / 06-08-2012 / 15:54:05 / cg"
! !

!BoltLock class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


BoltLock initialize!

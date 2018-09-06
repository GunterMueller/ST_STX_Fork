"
 COPYRIGHT (c) 2016 by eXept Sofware AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.  This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Semaphore subclass:#EventSemaphore
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!EventSemaphore class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Sofware AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.  This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Processes wait for an EventSemaphores until it is signaled.
    The EventSemaphore is not consumed and remains signaled until manually reset.

    [author:]
        Stefan Vogel

    [see also:]
        Semaphore
"
!

example
"
    Create an event and signal it.
    After being signaled waiter on the event return immediately.

                                [exBegin]
    |event|

    event := EventSemaphore new.
    [ event wait. Transcript showCR:'Process 1 continued' ] forkAt:9.
    [ event wait. Transcript showCR:'Process 2 continued' ] forkAt:9.
    event signal.
    event wait.
    event wait.
                                [exEnd]
"
! !

!EventSemaphore class methodsFor:'signaling'!

new:n
    "count must be 0 or 1"

    (n == 0 or:[n == 1]) ifTrue:[
        self new:n.
    ].
    ^ self error:'invalid count'.
! !

!EventSemaphore methodsFor:'blocked'!

signalForAll
    "blocked, since it would only set the event if there was anyone waiting"

    ^ self shouldNotImplement.
!

signalIf
    "blocked, since it would only set the event if there was anyone waiting"

    ^ self shouldNotImplement.
!

waitWithTimeoutMs:milliSeconds state:waitStateSymbol
    "blocked, since we had to re-implement it here"

   ^ self shouldNotImplement
! !

!EventSemaphore methodsFor:'misc'!

reset
    "reset the event to the non-signaled state"

    count := 0
! !

!EventSemaphore methodsFor:'semaphoreSet interface'!

checkAndAddWaitingProcess:process
    "interface for SemaphoreSet.
     If the semaphore is available, return true.
     Otherwise register our process to be wakened up once the semaphore is available
     and return false.
     ATTENTION: this must be invoked with OperatingSystem-interrupts-blocked.
    "

    count > 0 ifTrue:[
        ^ true
    ].
    (waitingProcesses notNil and:[(waitingProcesses includesIdentical:process)]) ifFalse:[
        self addWaitingProcess:process.
    ].
    ^ false

    "Modified: / 14-12-1995 / 10:32:17 / stefan"
    "Modified: / 11-08-2011 / 14:36:20 / cg"
! !

!EventSemaphore methodsFor:'signaling'!

signal
    "redefined to limit count to 1"

    self signalOnce.
! !

!EventSemaphore methodsFor:'waiting'!

wait
    "once signaled, do not decrement the count"

    self waitUncounted
!

waitWithTimeoutMs:milliSeconds
    "wait for the semaphore, but abort the wait after some time.
     return the receiver if the semaphore triggered normal, nil if we return
     due to a timeout.
     With zero timeout, this can be used to poll a semaphore (returning
     the receiver if the semaphore is available, nil if not).
     However, polling is not the intended use of semaphores, though.
     If milliSeconds is nil, wait without timeout.

     Redefined: once signaled, do not decrement the count"

    ^ self waitUncountedWithTimeoutMs:milliSeconds.
! !

!EventSemaphore class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

Object subclass:#Monitor
	instanceVariableNames:'owningProcess sema count'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Monitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Monitors (as used in Java) provide a functionality much like RecursionLocks, 
    but are not block based.
    Therefore, monitors are not unwind-save (i.e. a return or unwind while a
    monitor is locked, will lead to a deadlock situation).
    You have to care for unwind protection yourself.

    Notice:
        This is an unused demo class - there is no WARRANTY.
        It is not used by the system itself.
        Smalltalkers should use Semaphores and RecursionLocks, which
        are unwind-save.

    [see also:]
        RecursionLock Semaphore Delay SharedQueue
        Block

    [author:]
        Claus Gittinger
"
!

examples
"
						[exBegin]
	|mon p1 p2 p3|

	mon := Monitor new.

	p1 := [
	     10 timesRepeat:[
		 Delay waitForSeconds:0.3.
		 mon enter.
		 'p1 got it' printNL.
		 Delay waitForSeconds:0.3.
		 'p1 leaves' printNL.
		 mon exit
	     ]
	] fork.

	p2 := [
	     20 timesRepeat:[
		 Delay waitForSeconds:0.2.
		 mon enter.
		 'p2 got it' printNL.
		 Delay waitForSeconds:0.2.
		 'p2 leaves' printNL.
		 mon exit
	     ]
	] fork.

	p3 := [
	     30 timesRepeat:[
		 Delay waitForSeconds:0.1.
		 mon enter.
		 'p3 got it' printNL.
		 Delay waitForSeconds:0.1.
		 'p3 leaves' printNL.
		 mon exit
	     ]
	] fork.
						[exEnd]
"
! !

!Monitor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Monitor methodsFor:'enter & leave'!

critical: aBlock
    "a critical section. Executes a block as a critical section, secured by the receiver."

    ^ [
        self enter.
        aBlock value
    ] ensure:[
        self exit
    ]
!

enter
    "enter the monitor"

    |thisProcess wasBlocked|

    thisProcess := Processor activeProcess.

    "
     this works only since interrupts are only serviced at 
     message send and method-return time ....
     If you add a message send into the ifTrue:-block, things will
     go mad ... (especially be careful when adding a debugPrint-here)
    "
    owningProcess isNil ifTrue:[
        count := 1.
        owningProcess := thisProcess.
        ^ self
    ].

    owningProcess == thisProcess ifTrue:[
        count := count + 1.
        ^ self
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    [
        owningProcess isDead ifTrue:[
            'Monitor [warning]: entering monitor owned by dead process' errorPrintCR.
            "/ self halt.
        ] ifFalse:[
            [owningProcess notNil] whileTrue:[
                thisProcess state:#monWait.
                (sema waitWithTimeout:10) isNil ifTrue:[
                    (owningProcess notNil and:[owningProcess isDead]) ifTrue:[
                        'Monitor [warning]: acquire monitor from dead process' errorPrintCR.
                        owningProcess := nil.
                    ]
                ]
            ].
        ].
        count := 1.
        owningProcess := thisProcess.
    ] ensure:[
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts]
    ]

    "Modified: / 8.1.1999 / 13:56:28 / cg"
!

exit
    "exit the monitor"

    |thisProcess|

    count == 0 ifTrue:[
	'MONITOR [info]: already left' errorPrintCR.
	^ self
    ].

    thisProcess := Processor activeProcess.

    "
     this works only since interrupts are only serviced at 
     message send and method-return time ....
     If you add a message send into the ifTrue:-block, things will
     go mad ... (especially be careful when adding a debugPrint-here)
    "
    owningProcess ~~ thisProcess ifTrue:[
	self halt:'invalid exit'
    ].

    count := count - 1.
    count ~~ 0 ifTrue:[ ^ self].

    owningProcess := nil.
    sema signal.

    "Modified: 21.8.1997 / 16:44:17 / cg"
!

fakeEnter:aProcess count:additionalCount
    "(fake-)enter the monitor, without blocking.
     Raises an error, if the monitor is not free and owned by another process"

    |wasBlocked|

    "
     this works only since interrupts are only serviced at 
     message send and method-return time ....
     If you add a message send into the ifTrue:-block, things will
     go mad ... (especially be careful when adding a debugPrint-here)
    "
    owningProcess isNil ifTrue:[
        count := additionalCount.
        owningProcess := aProcess.
        ^ self
    ].

    wasBlocked := OperatingSystem blockInterrupts.

    owningProcess == aProcess ifTrue:[
        count := count + additionalCount.
        wasBlocked ifFalse:[ OperatingSystem unblockInterrupts].
        ^ self
    ].

    owningProcess isDead ifTrue:[
        'Monitor [warning]: (fake)entering monitor owned by dead process' errorPrintCR.
        "/ self halt.
        owningProcess := aProcess.
        count := additionalCount.
        wasBlocked ifFalse:[ OperatingSystem unblockInterrupts].
        ^ self
    ].

    wasBlocked ifFalse:[ OperatingSystem unblockInterrupts].
    self error:'Cannot fakeEnter monitor owned by another process'.

    "Created: / 8.1.1999 / 13:54:44 / cg"
    "Modified: / 8.1.1999 / 13:57:42 / cg"
! !

!Monitor methodsFor:'initialization'!

initialize
    sema := Semaphore new name:'monitorSema'.
    count := 0.

    "Created: 3.5.1996 / 17:24:59 / cg"
! !

!Monitor methodsFor:'queries'!

count
    owningProcess isNil ifTrue:[^ 0].
    ^ count

    "Created: / 8.1.1999 / 13:59:30 / cg"
    "Modified: / 8.1.1999 / 14:00:01 / cg"
!

isFree
    "return true, if the monitor is free
     (i.e. noone waits and count is zero)"

    |wasBlocked ret|

    owningProcess isNil ifTrue:[^ true].
    count == 0 ifTrue:[^ true].

    ret := true.

    wasBlocked := OperatingSystem blockInterrupts.
    owningProcess notNil ifTrue:[
        ret := false
    ] ifFalse:[
        sema numberOfWaitingProcesses ~~ 0 ifTrue:[ret := false].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ ret.

    "Created: / 3.5.1996 / 18:08:38 / cg"
    "Modified: / 8.1.1999 / 13:59:53 / cg"
!

owningProcess
    "return the monitors owner; or nil, if its free"

    ^ owningProcess

    "Created: / 11.12.1998 / 13:43:39 / cg"
! !

!Monitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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

Object subclass:#Semaphore
	instanceVariableNames:'count waitingProcesses lastOwnerId name owner'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Semaphore class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    Semaphores are used to synchronize processes providing a nonBusy wait
    mechanism. A process can wait for the availability of some resource by
    performing a Semaphore>>wait, which will suspend the process until the
    resource becomes available. Signalling is done by (another process performing)
    Semaphore>>signal.
    If the resource has been already available before the wait, no suspending is
    done, but the resource immediately allocated.
    The resource internally keeps a count, the number of times the resource can be
    allocated. If the semaphore is created with a count greater than 1, the sema
    can be waited-upon that many times without blocking.
    On the other hand, if initialized with a negative count, the semaphore
    must be signalled that many times more often in order for a wait to not block.
    In other words: whenever the semaphore has a count greater than zero,
    the wait operation will proceed. Otherwise, it will block until the count has
    been incremented by signal operations to be greater than zero.

    There are also semaphores for mutual access to a critical region
    (Semaphore>>forMutualExclusion and Semaphore>>critical:).

    Additional protocol is provided for oneShot semaphores,
    (#signalOnce) and for conditional signalling (#signalIf).

    You can also attach semaphores to external events (such as I/O arrival or
    timer events).
    This is done by telling the Processor to signal the semaphore
    under some condition.
    See 'Processor>>signal:afterSeconds:', 'Processor>>signal:onInput:' etc.

    See examples in doc/coding (found in the CodingExamples-nameSpace).

    Warning/Note/Hint:
	a Semaphore-forMutualExclusion does NEVER allow for the critical
	region to be entered twice - NOT EVEN by the same process.
	That means, that a recursive attempt to enter that section leads
	to a deadlock.
	Use a RecursionLock instead, to avoid this.

    NOTE:
    You're encouraged to use `RecursionLock` for guarding a critical section.
    `RecursionLock` is not only reentrant but also much faster.

    Hint:
	now (Jul2002), Semaphores now allow for a negative count; this allows for
	a sync-point to be implemented easily (i.e. to wait for multiple other processes
	to arrive at a sync-point).
	See examples.


    [instance variables:]
	count                   <SmallInteger>          the number of waits, that will go through
							without blocking.
							Incremented on #signal; decremented on #wait.

	waitingProcesses        <OrderedCollection>     waiting processes - will be served first
							come first served when signalled.

	lastOwnerId             <SmallInteger>          a debugging aid: set when count drops
							to zero to the current processes id.
							Helps in finding deadlocks.

	name                    <String>                a debugging aid: an optional userFriendly
							name; helps to identify a semaphore easier.

    [see also:]
	SemaphoreSet RecursionLock Monitor
	SharedQueue Delay
	Process ProcessorScheduler

    [author:]
	Claus Gittinger
"
!

examples
"
    two processes synchronizing on a sema:
                                                        [exBegin]
        |sema thread1 thread2|

        sema := Semaphore new.

        thread1 := [
                        Transcript showCR:'here is thread 1; now waiting ...'.
                        sema wait.
                        Transcript showCR:'here is thread 1 again.'.
                   ] newProcess.

        thread2 := [
                        Transcript showCR:'here is thread 2; delaying a bit ...'.
                        Delay waitForSeconds:5.
                        Transcript showCR:'here is thread 2 again; now signalling the sema'.
                        sema signal.
                        Transcript showCR:'here is thread 2 after the signalling.'.
                  ] newProcess.

        thread1 priority:7.
        thread2 priority:6.

        thread1 resume.
        thread2 resume.
                                                        [exEnd]

    semaphore for critical regions:
                                                        [exBegin]
        |accessLock|

        accessLock := Semaphore forMutualExclusion.

        [
            5 timesRepeat:[
                Delay waitForSeconds:2.
                accessLock critical:[
                    Transcript showCR:'thread1 in critical region'.
                    Delay waitForSeconds:1.
                    Transcript showCR:'thread1 leaving critical region'.
                ].
            ]
        ] forkAt:5.

        [
            5 timesRepeat:[
                Delay waitForSeconds:1.
                accessLock critical:[
                    Transcript showCR:'thread2 in critical region'.
                    Delay waitForSeconds:2.
                    Transcript showCR:'thread2 leaving critical region'.
                ].
            ]
        ] forkAt:4.
                                                        [exEnd]

    a deadlock due to recursive enter of a critical region:
                                                        [exBegin]
        |accessLock block|

        accessLock := Semaphore forMutualExclusion.

        block := [:arg |
                    Transcript showCR:'about to enter'.
                    accessLock critical:[
                        Transcript showCR:'entered - doing action'.
                        arg value
                    ].
                    Transcript showCR:'left region'.
                 ].

        block value:[].                 'this works'.
        block value:[block value:[] ].  'this deadlocks'.
                                                        [exEnd]

    Avoid the deadlock by using a RecursionLock instead:
                                                        [exBegin]
        |accessLock block|

        accessLock := RecursionLock new.

        block := [:arg |
                    Transcript showCR:'about to enter'.
                    accessLock critical:[
                        Transcript showCR:'entered - doing action'.
                        arg value
                    ].
                    Transcript showCR:'left region'.
                 ].

        block value:[].                 'this works'.
        block value:[block value:[] ].  'this deadlocks'.
                                                        [exEnd]


   Wait for multiple processes to arrive at a sync-point:
                                                        [exBegin]
        |syncSema proceedSema thread1 thread2 thread3|

        syncSema := Semaphore new.
        syncSema setCount:(1-3).
        proceedSema := Semaphore new.

        thread1 := [
                        Transcript showCR:'here is thread 1; now busy ...'.
                        Delay waitForSeconds:(2 + (Random nextIntegerBetween:2 and:4)).
                        Transcript showCR:'here is thread 1 again - now syncing.'.
                        syncSema signal.
                        Transcript showCR:'thread 1 is waiting for all others...'.
                        proceedSema wait.
                        Transcript showCR:'thread 1 done.'.
                   ] newProcess.

        thread2 := [
                        Transcript showCR:'here is thread 2; now busy ...'.
                        Delay waitForSeconds:(3 + (Random nextIntegerBetween:2 and:4)).
                        Transcript showCR:'here is thread 2 again - now syncing.'.
                        syncSema signal.
                        Transcript showCR:'thread 2 is waiting for all others...'.
                        proceedSema wait.
                        Transcript showCR:'thread 2 done.'.
                  ] newProcess.

        thread3 := [
                        Transcript showCR:'here is thread 3; now busy ...'.
                        Delay waitForSeconds:(4 + (Random nextIntegerBetween:2 and:4)).
                        Transcript showCR:'here is thread 3 again - now syncing.'.
                        syncSema signal.
                        Transcript showCR:'thread 3 is waiting for all others...'.
                        proceedSema wait.
                        Transcript showCR:'thread 3 done.'.
                  ] newProcess.

        thread1 priority:7.
        thread2 priority:6.
        thread3 priority:9.

        thread1 resume.
        thread2 resume.
        thread3 resume.

        Transcript showCR:'main thread: now waiting for other threads...'.
        syncSema wait.
        Transcript showCR:'main thread: all other threads at syncPoint.'.
        Delay waitForSeconds:2.
        Transcript showCR:'main thread: now let them proceed...'.
        proceedSema signalForAll.
        Transcript showCR:'main thread: done.'.
                                                        [exEnd]

   waitWithTimeout:0 can also be used to conditionally acquire the semaphore
   i.e. only acquire it if it is available.
     |s|

     s := Semaphore new.
     [
          (s waitWithTimeout:0) notNil ifTrue:[
                Transcript showCR:'process1 got the sema'.
                Delay waitForSeconds:1.
                Transcript showCR:'process1 signals sema'.
                s signal.
          ] ifFalse:[
                Transcript showCR:'process1 has NOT got the sema'.
          ].
     ] fork.
     [
          (s waitWithTimeout:0) notNil ifTrue:[
                Transcript showCR:'process2 got the sema'.
                Delay waitForSeconds:1.
                Transcript showCR:'process2 signals sema'.
                s signal.
          ] ifFalse:[
                Transcript showCR:'process2 has NOT got the sema'.
          ]
     ] fork.
     s signal.
     Delay waitForSeconds:0.5.
     Transcript showCR:'master waits for sema'.
     s wait.
     Transcript showCR:'master got the sema'.
"
! !

!Semaphore class methodsFor:'instance creation'!

cleanup
    "an emergency helper: manually signal all semaphores which were held by a now dead process.
     Can only (;-?) happen, if a semaphore-holding process was hard terminated
     (i.e. no ensure handling happened), and semas remain in a bad state."

    self allInstancesDo:[:sema |
        |lastOwner|

        (sema count == 0
         and:[(lastOwner := sema lastOwner) notNil
         and:[lastOwner isDead]]) ifTrue:[
            sema signal
        ]
    ]
!

forMutualExclusion
    "create & return a new semaphore which allows exactly one process to
     wait on it without blocking. This type of semaphore is used
     for mutual exclusion from critical regions (see #critical:).
     Also see RecursionLock, to avoid deadlock in case of recursive entered
     critical regions."

    ^ super new setCount:1; name:'criticalRegionSema'

    "Modified: / 17.6.1998 / 16:23:09 / cg"
!

new
    "create & return a new semaphore which blocks until a signal is sent"

    ^ super new setCount:0
!

new:n
    "create & return a new semaphore which allows n waits before
     blocking"

    ^ super new setCount:n
! !

!Semaphore methodsFor:'Compatibility-Squeak'!

isSignaled
    ^ self wouldBlock not
!

waitTimeoutMSecs:milliSeconds
    ^ self waitWithTimeoutMs:milliSeconds
!

waitTimeoutSeconds:seconds
    ^ self waitWithTimeout:seconds
! !

!Semaphore methodsFor:'accessing'!

owner
    "an optional reference to someone who owns this semaphore,
     typically a shared queue or a windowgroup or similar.
     This has no semantic meaning and is only used to support debugging"

    ^ owner
!

owner:something
    "an optional reference to someone who owns this semaphore,
     typically a shared queue or a windowgroup or similar.
     This has no semantic meaning and is only used to support debugging"

    owner := something.
! !

!Semaphore methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a string to display the receiver - include the
     count for your convenience"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
	^ super displayOn:aGCOrStream
    ].
    aGCOrStream
	nextPutAll:self class name;
	nextPut:$(.
    count printOn:aGCOrStream.
    aGCOrStream nextPutAll:' name: '.
    (name ? 'unnamed') printOn:aGCOrStream.
    aGCOrStream nextPut:$).


    "Modified: 28.6.1997 / 16:21:09 / cg"
!

name
    "return the semaphores userFriendly name"

    ^ name
!

name:aString
    "set the semaphores userFriendly name"

    name := aString
! !

!Semaphore methodsFor:'private'!

addWaitingProcess:aProcess
    "add aProcess to the list of waiting processes.
     all processes are ordered first-come-first-serve.

     NOTE: must be called with blocked interrupts"

    waitingProcesses isNil ifTrue:[
        "for now - assume that there is probably only one waiter"
        waitingProcesses := Array with:aProcess
    ] ifFalse:[
        waitingProcesses isArray ifTrue:[
            "add 2 to reserve space for additional waiters"
            waitingProcesses := (OrderedCollection new:waitingProcesses size + 2)
                                    addAll:waitingProcesses;
                                    yourself.
        ].
        waitingProcesses add:aProcess.
    ].

"/    "Sort, so that higher priority process are resumed first.
"/    Processes having the same priority are ordered first-come-first-serve."
"/
"/    |priority insertIndex|
"/
"/    (waitingProcesses size == 0
"/     or:[(priority := aProcess priority) <= waitingProcesses last priority]) ifTrue:[
"/        waitingProcesses add:aProcess.
"/        ^ self.
"/    ].
"/
"/    insertIndex := waitingProcesses findFirst:[:process| process priority < priority].
"/    waitingProcesses add:aProcess beforeIndex:insertIndex.
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
!

wakeupWaiters
    "remove all waiting processes from the list of waiting processes
     and resume them.
     NOTE: Must be called when known that waitingProcesses is nonNil and
	   also with blocked interrupts"

    |processes anyDead needsReschedule|

    processes := waitingProcesses.
"/ do not set to nil - a waiting process may be suspended and will not be resumed by #makeRunnable: ...
"/    waitingProcesses := nil.

    needsReschedule := false.
    anyDead := false.
    processes do:[:eachProcess |
	(Processor makeRunnable:eachProcess) ifTrue:[
	    needsReschedule := true.
	] ifFalse:[
	    "if process is nil or dead (or for other reasons) makeRunnable returns false.
	     So check here."
	    (eachProcess isNil or:[eachProcess isDead]) ifTrue:[
		"printing to Transcript might not be a good idea while interrupts are blocked"
		'Semaphore>>wakeupWaiters: removing a dead process: ' infoPrint. eachProcess infoPrintCR.
		anyDead := true.
	    ].
	].
    ].
    anyDead ifTrue:[
	"interrupts are already blocked by sender"
	waitingProcesses := processes reject:[:p | p isNil or:[p isDead]]
    ].

    ^ needsReschedule.
! !

!Semaphore methodsFor:'private-accessing'!

clear
    "clear the semaphores count"

    count := 0
!

initSignals
    "set the count of the semaphore to zero.
     provided for ST-80 compatibility."

    count := 0

    "Created: 17.2.1997 / 11:31:19 / cg"
!

setCount:n
    "set the count of the semaphore;
     that's the number of possible waits, without blocking"

    waitingProcesses := nil.
    count := n

    "Modified: 17.2.1997 / 11:36:40 / cg"
! !

!Semaphore methodsFor:'queries'!

count
    "return the number of 'already-counted' trigger events.
     That's the number of waits which will succeed without blocking"

    ^ count

    "Created: 23.1.1997 / 02:55:58 / cg"
!

lastOwner
    "return the last owning process or nil
     (the one which counted to zero).
     May be very useful in debugging deadLock situations"

    ^ Processor processWithId:lastOwnerId.

    "Created: / 11-08-2011 / 14:35:36 / cg"
!

lastOwnerId
    "return the processId of the last owning process
     (the one which counted to zero).
     May be very useful in debugging deadLock situations"

    ^ lastOwnerId

    "Created: / 24-01-1997 / 23:09:33 / cg"
!

numberOfWaitingProcesses
    "return the number of processes waiting on the receiver"

    ^ waitingProcesses size

    "Created: 3.5.1996 / 18:06:27 / cg"
!

waitingProcesses
    "return the processes waiting on the receiver"

    ^ waitingProcesses ? #()

    "Created: 18.7.1996 / 20:53:33 / cg"
! !

!Semaphore methodsFor:'semaphoreSet interface'!

checkAndAddWaitingProcess:process
    "interface for SemaphoreSet.
     If the semaphore is available, decrement it and return true.
     Otherwise register our process to be wakened up once the semaphore is available
     and return false.
     ATTENTION: this must be invoked with OperatingSystem-interrupts-blocked.
    "

    count > 0 ifTrue:[
	count := count - 1.
	count == 0 ifTrue:[
	    lastOwnerId := Processor activeProcessId.
	].
	^ true
    ].
    (waitingProcesses notNil and:[(waitingProcesses includesIdentical:process)]) ifFalse:[
	self addWaitingProcess:process.
    ].
    ^ false

    "Modified: / 14-12-1995 / 10:32:17 / stefan"
    "Modified: / 11-08-2011 / 14:36:20 / cg"
! !

!Semaphore methodsFor:'signaling'!

signal
    "waking up (the first) waiter.
     Q: should this be the highest prio waiter ?"

    |wasBlocked needsReschedule|

    needsReschedule := false.
    wasBlocked := OperatingSystem blockInterrupts.
    [
	count := count + 1.
	waitingProcesses size ~~ 0 ifTrue:[
	    needsReschedule := self wakeupWaiters.
	].
    ] ensure:[
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    needsReschedule ifTrue:[
	"now, schedule the highest priority process"
	Processor reschedule.
    ].

    "Modified: / 4.2.1998 / 21:01:07 / cg"
!

signalForAll
    "signal the semaphore for all waiters.
     This can be used for process synchronization, if multiple processes are
     waiting for a common event."

    |wasBlocked needsReschedule|

    waitingProcesses size ~~ 0 ifTrue:[
	needsReschedule := false.
	wasBlocked := OperatingSystem blockInterrupts.
	[
	    "first, make them all runnable, but do not schedule
	     (in case one has higher prio and goes into a wait immediately again.)"
	    waitingProcesses size ~~ 0 ifTrue:[
		needsReschedule := self wakeupWaiters.
		"wakeupWaites may have removed dead processes from waitingProcesses!!"
		count := count + waitingProcesses size.
	    ].
	] ensure:[
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	].
	needsReschedule ifTrue:[
	    "now, schedule the highest priority process"
	    Processor reschedule.
	].
    ]

    "Modified: / 5.2.1998 / 10:40:26 / cg"
!

signalIf
    "signal the semaphore, but only if being waited upon.
     This can be used for one-shot semaphores (i.e. not remembering
     previous signals)"

    |wasBlocked|

    waitingProcesses notNil ifTrue:[
	wasBlocked := OperatingSystem blockInterrupts.
	[
	    waitingProcesses size ~~ 0 ifTrue:[
		self signal
	    ].
	] ensure:[
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	]
    ]

    "Modified: 28.2.1996 / 21:23:57 / cg"
!

signalOnce
    "wakeup waiters - but only once.
     I.e. if the semaphore has already been signaled, this is ignored."

    |wasBlocked needsReschedule|

    count <= 0 ifTrue:[
	needsReschedule := false.
	wasBlocked := OperatingSystem blockInterrupts.
	"/ check again - now interrupts are blocked.
	[
	    count <= 0 ifTrue:[
		count := count + 1.
		count == 1 ifTrue:[
		    waitingProcesses size ~~ 0 ifTrue:[
			needsReschedule := self wakeupWaiters.
		    ].
		].
	    ].
	] ensure:[
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	].
	needsReschedule ifTrue:[
	    "now, schedule the highest priority process"
	    Processor reschedule.
	].
    ].

    "Modified: 28.2.1996 / 21:24:08 / cg"
! !

!Semaphore methodsFor:'testing'!

isEmpty
    "ST80 compatibility - return true if there are no waiters"

    ^ waitingProcesses size == 0

    "Created: / 3.5.1996 / 18:06:27 / cg"
    "Modified: / 18.6.1998 / 16:07:38 / cg"
!

wouldBlock
    "return true, if the receiver would block the activeProcess
     if a wait was performed. False otherwise.
     Attention: if asked without some global lock (blockedInterrupts),
     the returned value may be outdated right away."

    ^ count <= 0
! !

!Semaphore methodsFor:'waiting'!

consume
    "consume the resource without waiting.
     This works even if the count is 0 (count may become negative).
     Answer the new count afterwards"

    ^ self consume:1
!

consume:n
    "consume the resource n times without waiting.
     This works even if the count is 0 (count may become negative).
     Answer the new count afterwards"

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    count := count - n.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    ^ count
!

critical:aBlock
    "evaluate aBlock as a critical region; the receiver must be
     created using Semaphore>>forMutualExclusion"

    |retVal gotSema wasBlocked needsReschedule|

    "/ inlined common case - ugly kludge but helpful
    wasBlocked := OperatingSystem blockInterrupts.
    count > 0 ifTrue:[
	count := count - 1.
	count == 0 ifTrue:[
	    lastOwnerId := Processor activeProcessId.
	].
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

	retVal := aBlock ifCurtailed:[ self signal ].

	OperatingSystem blockInterrupts.
	needsReschedule := false.
	[
	    count := count + 1.
	    waitingProcesses size ~~ 0 ifTrue:[
		needsReschedule := self wakeupWaiters.
	    ].
	] ensure:[
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	].
	needsReschedule ifTrue:[
	    "now, schedule the highest priority process"
	    Processor reschedule.
	].
	^ retVal.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    [
	gotSema := self wait.
	retVal := aBlock value.
    ] ifCurtailed:[
	"/ be careful - the unwind may occur both while waiting
	"/ AND while evaluating the block.
	gotSema notNil ifTrue:[self signal].
    ].
    self signal.
    ^ retVal

    "
      the example below is stupid (it should use a SharedQueue,
      or at least a Queue with critical regions).
      Anyhow, it demonstrates how two processes lock each other
      from accessing coll at the same time

     |sema coll|

     sema := Semaphore forMutualExclusion.
     coll := OrderedCollection new:10.

     [
	1 to:1000 do:[:i |
	    sema critical:[
		coll addLast:i.
		(Delay forSeconds:0.1) wait.
	    ]
	]
     ] forkAt:4.

     [
	1 to:1000 do:[:i |
	    sema critical:[
		coll removeFirst.
		(Delay forSeconds:0.1) wait.
	    ]
	]
     ] forkAt:4.
    "

    "Modified: / 16-04-1996 / 10:00:46 / stefan"
    "Modified: / 11-08-2011 / 14:36:30 / cg"
!

wait
    "wait for the semaphore"

    |activeProcess wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    count <= 0 ifTrue:[
        activeProcess := Processor activeProcess.
        "
         need a while-loop here, since more than one process may
         wait for it and another one may also wake up.
         Thus, the count is not always non-zero after returning from
         suspend.
        "
        [
            self addWaitingProcess:activeProcess.
            "
             for some more descriptive info in processMonitor ...
             ... set the state to #wait (instead of #suspend)
            "
            [
                activeProcess suspendWithState:#wait
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                self removeWaitingProcess:activeProcess.
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].
            self removeWaitingProcess:activeProcess.

            count <= 0
        ] whileTrue.
    ].

    count := count - 1.
    count == 0 ifTrue:[
        lastOwnerId := Processor activeProcessId.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: / 13-12-1995 / 13:26:33 / stefan"
    "Modified: / 11-08-2011 / 14:36:43 / cg"
!

waitUncounted
    "wait for the semaphore; do not consume the resource
     (i.e. do not count down)"

    |activeProcess wasBlocked|

    count > 0 ifTrue:[
	^ self
    ].
    activeProcess := Processor activeProcess.

    wasBlocked := OperatingSystem blockInterrupts.
    "
     need a while-loop here, since more than one process may
     wait for it and another one may also wake up.
     Thus, the count is not always non-zero after returning from
     suspend.
    "
    [count <= 0] whileTrue:[
	self addWaitingProcess:activeProcess.
	"
	 for some more descriptive info in processMonitor ...
	 ... set the state to #wait (instead of #suspend)
	"
	[
	    activeProcess suspendWithState:#wait
	] ifCurtailed:[
	    "interrupts are not blocked when entered through Processor>>#interruptActive"
	    OperatingSystem blockInterrupts.
	    self removeWaitingProcess:activeProcess.
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	].
	self removeWaitingProcess:activeProcess.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 13.12.1995 / 13:26:49 / stefan"
    "Modified: 1.2.1997 / 12:11:41 / cg"
!

waitUncountedWithTimeoutMs:milliSeconds
    "wait for the semaphore; do not consume the resource
     (i.e. do not count down).
     Abort the wait after some time.
     return the receiver if the semaphore triggered normal, nil if we return
     due to a timeout.
     With zero timeout, this can be used to poll a semaphore (returning
     the receiver if the semaphore is available, nil if not).
     However, polling is not the intended use of semaphores, though.
     If milliSeconds is nil, wait without timeout."

    |activeProcess timeoutOccurred wasBlocked timeoutBlock now endTime|

    count > 0 ifTrue:[
        ^ self
    ].

    wasBlocked := OperatingSystem blockInterrupts.

    count <= 0 ifTrue:[
        "with zero-timeout, this is a poll"
        milliSeconds == 0 ifTrue:[
            wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ^ nil
        ].

        activeProcess := Processor activeProcess.
        timeoutOccurred := false.

        milliSeconds notNil ifTrue:[
            "Wait with timeout: calculate the end-time"
            now := OperatingSystem getMillisecondTime.
            endTime := OperatingSystem millisecondTimeAdd:now and:milliSeconds.

            timeoutBlock := [
                    timeoutOccurred := true.
                    timeoutBlock:= nil.
                    Processor resume:activeProcess.
                ].
            Processor addTimedBlock:timeoutBlock for:activeProcess atMilliseconds:endTime.
        ].

        "
         need a while-loop here, since more than one process may
         wait for it and another one may also wake up.
         Thus, the count is not always non-zero after returning from
         suspend.
        "
        [
            self addWaitingProcess:activeProcess.

            "
             for some more descriptive info in processMonitor ...
             ... set the state to #wait (instead of #suspend)
            "
            [
                "sleep until resumed..."
                activeProcess suspendWithState:#wait.
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                timeoutBlock notNil ifTrue:[
                    Processor removeTimedBlock:timeoutBlock.
                    timeoutBlock := nil.
                ].
                self removeWaitingProcess:activeProcess.
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].

            self removeWaitingProcess:activeProcess.
            timeoutOccurred ifTrue:[
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
                ^ nil
            ].

            count <= 0
        ] whileTrue.

        timeoutBlock notNil ifTrue:[
            Processor removeTimedBlock:timeoutBlock.
            timeoutBlock := nil.
        ].
    ].

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ self

    "Modified: / 13-12-1995 / 13:27:24 / stefan"
    "Modified: / 11-08-2011 / 14:37:00 / cg"
!

waitWithTimeout:secondsOrNilOrTimeDuration
    "wait for the semaphore, but abort the wait after some time (seconds).
     return the receiver if the semaphore triggered normal, nil if we return
     due to a timeout.
     The seconds-argument may be a float (i.e. use 0.1 for a 100ms timeout).
     With zero timeout, this can be used to poll a semaphore (returning
     the receiver if the semaphore is available, nil if not).
     However, polling is not the intended use of semaphores, though.
     If seconds is nil, wait without timeout."

    |millis|

    secondsOrNilOrTimeDuration notNil ifTrue:[
        "asFloat converts a TimeDuration to a Float"
        millis := (secondsOrNilOrTimeDuration asFloat * 1000) asInteger
    ].
    ^ self waitWithTimeoutMs:millis.
!

waitWithTimeoutMs:milliSeconds
    "wait for the semaphore, but abort the wait after some time.
     return the receiver if the semaphore triggered normal, nil if we return
     due to a timeout.
     With zero timeout, this can be used to poll a semaphore (returning
     the receiver if the semaphore is available, nil if not).
     However, polling is not the intended use of semaphores, though.
     If milliSeconds is nil, wait without timeout."

    |activeProcess timeoutOccurred wasBlocked timeoutBlock now endTime|

    wasBlocked := OperatingSystem blockInterrupts.

    count <= 0 ifTrue:[
        "with zero-timeout, this is a poll"
        milliSeconds == 0 ifTrue:[
            wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ^ nil
        ].

        activeProcess := Processor activeProcess.
        timeoutOccurred := false.

        milliSeconds notNil ifTrue:[
            "Wait with timeout: calculate the end-time"
            now := OperatingSystem getMillisecondTime.
            endTime := OperatingSystem millisecondTimeAdd:now and:milliSeconds.

            timeoutBlock := [
                    timeoutOccurred := true.
                    timeoutBlock:= nil.
                    Processor resume:activeProcess.
                ].
            Processor addTimedBlock:timeoutBlock for:activeProcess atMilliseconds:endTime.
        ].

        "
         need a while-loop here, since more than one process may
         wait for it and another one may also wake up.
         Thus, the count is not always non-zero after returning from
         suspend.
        "
        [
            self addWaitingProcess:activeProcess.

            "
             for some more descriptive info in processMonitor ...
             ... set the state to #wait (instead of #suspend)
            "
            [
                "sleep until resumed..."
                activeProcess suspendWithState:#wait.
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                timeoutBlock notNil ifTrue:[
                    Processor removeTimedBlock:timeoutBlock.
                    timeoutBlock := nil.
                ].
                self removeWaitingProcess:activeProcess.
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].

            self removeWaitingProcess:activeProcess.
            timeoutOccurred ifTrue:[
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
                ^ nil
            ].

            count <= 0
        ] whileTrue.

        timeoutBlock notNil ifTrue:[
            Processor removeTimedBlock:timeoutBlock.
            timeoutBlock := nil.
        ].
    ].

    "if we come here, we have acquired the semaphore"
    count := count - 1.
    count == 0 ifTrue:[
        lastOwnerId := Processor activeProcessId.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ self

    "Modified: / 13-12-1995 / 13:27:24 / stefan"
    "Modified: / 11-08-2011 / 14:37:00 / cg"
!

waitWithTimeoutMs:milliSeconds state:waitStateSymbol
    "wait for the semaphore, but abort the wait after some time.
     return the receiver if the semaphore triggered normal, nil if we return
     due to a timeout.
     With zero timeout, this can be used to poll a semaphore (returning
     the receiver if the semaphore is available, nil if not).
     However, polling is not the intended use of semaphores, though.
     If milliSeconds is nil, wait without timeout.

     waitStateSymbol is the state the process is set to while waiting - normally #wait."

    |activeProcess timeoutOccurred wasBlocked timeoutBlock now endTime|

    wasBlocked := OperatingSystem blockInterrupts.

    count <= 0 ifTrue:[
        "with zero-timeout, this is a poll"
        milliSeconds == 0 ifTrue:[
            wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ^ nil
        ].

        activeProcess := Processor activeProcess.
        timeoutOccurred := false.

        milliSeconds notNil ifTrue:[
            "Wait with timeout: calculate the end-time"
            now := OperatingSystem getMillisecondTime.
            endTime := OperatingSystem millisecondTimeAdd:now and:milliSeconds.

            timeoutBlock := [
                    timeoutOccurred := true.
                    timeoutBlock:= nil.
                    Processor resume:activeProcess.
                ].
            Processor addTimedBlock:timeoutBlock for:activeProcess atMilliseconds:endTime.
        ].

        "
         need a while-loop here, since more than one process may
         wait for it and another one may also wake up.
         Thus, the count is not always non-zero after returning from
         suspend.
        "
        [
            self addWaitingProcess:activeProcess.

            "
             for some more descriptive info in processMonitor ...
             ... set the state to #wait (instead of #suspend)
            "
            [
                "sleep until resumed..."
                activeProcess suspendWithState:waitStateSymbol.
            ] ifCurtailed:[
                "interrupts are not blocked when entered through Processor>>#interruptActive"
                OperatingSystem blockInterrupts.
                timeoutBlock notNil ifTrue:[
                    Processor removeTimedBlock:timeoutBlock.
                    timeoutBlock := nil.
                ].
                self removeWaitingProcess:activeProcess.
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            ].

            self removeWaitingProcess:activeProcess.
            timeoutOccurred ifTrue:[
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
                ^ nil
            ].

            count <= 0
        ] whileTrue.

        timeoutBlock notNil ifTrue:[
            Processor removeTimedBlock:timeoutBlock.
            timeoutBlock := nil.
        ].
    ].

    "if we come here, we have acquired the semaphore"
    count := count - 1.
    count == 0 ifTrue:[
        lastOwnerId := Processor activeProcessId.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ self
! !

!Semaphore class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


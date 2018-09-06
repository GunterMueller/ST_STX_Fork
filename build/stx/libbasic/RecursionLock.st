"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

AbstractLock subclass:#RecursionLock
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!RecursionLock primitiveDefinitions!
%{
#define THINLOCKING
#ifdef THINLOCKING
# include <thinlocks.h>
static inline unsigned INT* stxGetLockwordPtr(OBJ o) {
    return (unsigned INT*)(&__OINST(o, process));
}

#endif
%}
! !

!RecursionLock class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Like a Semaphore for mutual exclusion, but avoids the deadlock
    if a critical region is reentered by the same process again.
    I.e. allows reentering the critical region IFF the current process
    is the one which did the original locking.

    NOTE:
    The recursion lock is not only reentrant (same process may enter the
    critical section multiple times) but also much faster than using
    semaphore (`lock := Semaphore forMutualExclusion. lock critical:[...]`)

    Therefore you're encouraged to use `RecursonLock` rather than
    `Semaphore forMutualExclusion` whenever possible.

    WARNING:
	For now, recursionLocks are not unlocked when an image is
	restarted. You may have to recreate them to avoid a deadLock.
	(this may change in the future, but recreating a recursionLock in
	 the #earlyRestart handling does not hurt)

    Thinlocks

    RecursionLocks uses `thinlocks`[1] to optimize locking in the common
    case - this makes it much faster.
    The `lockword` is stored in `process` instvar - when a `process` instvar
    contains a small integer, recursion lock is `thin`, value of `count` instvas
    is invalid (out of sync).

    [1]: David F. Bacon, Ravi Konuru, Chet Murthy, Mauricio Serrano:
        Thin locks: featherweight synchronization for Java, ACM SIGPLAN 1998



    [author:]
	   Claus Gittinger
        Jan Vrany (thinlock suppot)

    [see also:]
	   Semaphore
	   Process ProcessorScheduler
        AbstractLock
        thinlocks.h
"
!

examples
"
  example (good):
									[exBegin]
    |lock|

    lock := RecursionLock new.
    lock critical:[
	Transcript showCR:'in lock ...'.
	lock critical:[
	    Transcript showCR:'again ...'
	]
    ]
									[exEnd]

  in contrast to (wrong example - deadlocks):
									[exBegin]
    |lock|

    lock := Semaphore forMutualExclusion.
    lock critical:[
	Transcript showCR:'in lock ...'.
	lock critical:[
	    '*** never reached - deadlock because sema is already locked ***'.
	    '    (press CTRL-c and abort in the debugger)'.
	    Transcript showCR:'again ...'
	]
    ]
									[exEnd]
"
! !

!RecursionLock class methodsFor:'instance creation'!

forMutualExclusion
    "same as new, for easy exchangability with regular mutual-exclusion Semaphores."

    ^ self new
! !

!RecursionLock methodsFor:'accessing'!

count
    ^ self processAndCount at: 2.

!

owner
    ^ self processAndCount at: 1.

! !

!RecursionLock methodsFor:'acquire & release'!

acquireWithTimeoutMs: timeout
    "
    Acquire the lock:

       * If the lock is not owned by any process, lock it and return immediately.
       * If the lock is already owned by the calling process, return immediately.
       * Otherwise, wait until owning process release it (by means of #release)
         at most `timeout` milliseconds. If `timeout` is nil, wait forever.

    Return `true` if the lock has been acquired or `false` if bot (e.g. wait
    timed out)
    "
%{  /* NOCONTEXT */
#ifdef THINLOCKING
    if ( stxThinLock( stxGetLockwordPtr(self) ) == StxThinlockSuccess ) {
        return (true);
    }
#endif
%}.
    "/ Inflate the lock if it's not yet inflated.
    "/
    "/ Note that #inflate method checks again if it's inflated or not,
    "/ it may haopen some other thread inflated the lock in between the check
    "/ here and code in #inflate.
    "/
    "/ Note that `someobject class == SmallInteger` is handled as a special
    "/ case in stc and compiled as `__isSmallInteger(someobject)` and thus
    "/ very fast - just bitwise and + non-zero test. Don't change.
    process class == SmallInteger ifTrue:[ self inflate ].
    ^ super acquireWithTimeoutMs: timeout
!

release
    "
    Release the lock. Return true of lock has been released, `false` if
    not (because calling process does not own it).
    "
%{  /* NOCONTEXT */
#ifdef THINLOCKING
    if ( stxThinUnlock( stxGetLockwordPtr(self) ) == StxThinlockSuccess ) {
        return (true);
    }
#endif
%}.
    "/ Inflate the lock if it's not yet inflated.
    "/
    "/ Note that #inflate method checks again if it's inflated or not,
    "/ it may haopen some other thread inflated the lock in between the check
    "/ here and code in #inflate
    "/
    "/ Note that `someobject class == SmallInteger` is handled as a special
    "/ case in stc and compiled as `__isSmallInteger(someobject)` and thus
    "/ very fast - just bitwise and + non-zero test. Don't change.
    process class == SmallInteger ifTrue:[ self inflate ].
    super release ifFalse:[
        self error: ('Calling process does not own the lock (caller: %1, owner: %2)' bindWith: Processor activeProcess id with: (process isNil ifTrue:['<no owner>'] ifFalse:[process id])).
    ].
! !

!RecursionLock methodsFor:'initialization'!

initialize
    super initialize.
    process := 0.

    "Modified: / 25-01-1997 / 00:19:15 / cg"
    "Modified: / 29-08-2017 / 09:53:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLock methodsFor:'printing & storing'!

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
    sema count printOn:aGCOrStream.
    aGCOrStream nextPutAll:' name: '.
    (self name ? 'unnamed') printOn:aGCOrStream.
    aGCOrStream nextPut:$).
! !

!RecursionLock methodsFor:'private'!

inflate
    "Inflates (thin) lock (into fat lock). If the lock is already a fat lock,
     #inflate is no-op.

    Called by:

       * #acquire* in case of contention or if maximum nesting count
         is exceeded (unlikely)
       * #release in case of contention


    "

    | processAndCount wasBlocked |


    processAndCount := Array new: 2.
    wasBlocked := OperatingSystem blockInterrupts.
    "/ Note that `someobject class == SmallInteger` is handled as a special
    "/ case in stc and compiled as `__isSmallInteger(someobject)` and thus
    "/ very fast - just bitwise and + non-zero test. Don't change
    process class == SmallInteger ifTrue:[
        self processAndCountInto: processAndCount.
        process := processAndCount at: 1.
        count   := processAndCount at: 2.
        process notNil ifTrue:[
            sema setCount: 0.
        ].
    ].
    wasBlocked ifFalse:[ OperatingSystem unblockInterrupts ].

    "Modified: / 11-12-2017 / 21:40:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processAndCount
    | processAndCount |

    processAndCount := Array new: 2.
    self processAndCountInto: processAndCount.
    ^ processAndCount

!

processAndCountInto: anArray
    "Fills in `anArray` with owning process and nesting count.

     Note that by the time this method returns, the data in given array may
     be already obsolete.
    "
    | pid cnt proc |

    "/ Note that `someobject class == SmallInteger` is handled as a special
    "/ case in stc and compiled as `__isSmallInteger(someobject)` and thus
    "/ very fast - just bitwise and + non-zero test. Don't change!
    process class == SmallInteger ifTrue:[
        %{
#ifdef THINLOCKING
        unsigned INT _pid = stxLockwordGetPid( *stxGetLockwordPtr(self) );
        unsigned INT _cnt = stxLockwordGetCnt( *stxGetLockwordPtr(self) );

        if (_pid == INV_PROCESS_ID) {
            pid = nil;
            cnt = __MKINT(0);
        } else {
            pid = __MKINT(_pid);
            cnt = __MKINT(_cnt);
        }
#endif
        %}.
        pid notNil ifTrue:[
            proc := ObjectMemory processesKnownInVM detect:[:p|p id == pid] ifNone:[nil].
        ].
    ] ifFalse:[
        proc := process.
        cnt := count.
    ].
    anArray at: 1 put: proc.
    anArray at: 2 put: cnt.

! !

!RecursionLock methodsFor:'queries'!

numberOfWaitingProcesses
    "return the number of waiting processes"

    ^ sema numberOfWaitingProcesses

    "Created: 18.4.1996 / 17:18:08 / cg"
!

wouldBlock
    "Check if the resource represented by the receiver is
     already in use by another process.
     Attention: if asked without some global lock (blockedInterrupts),
     the returned value may be outdated right away."

    |p|

    ^ (p := self owner) notNil and:[Processor activeProcess ~~ p and:[p isDead not]]
! !

!RecursionLock methodsFor:'signaling'!

signal
    self breakPoint: #jv.
    self release ifFalse:[
        self error: 'Attempt to release a (recursion) lock by process the does not own it!!'
    ]

    "Modified: / 25-08-2017 / 08:41:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLock methodsFor:'synchronized evaluation'!

critical:aBlock
    "Evaluate aBlock as a critical region. Same process may
     enter critical region again, i.e., nesting allowed.

     Returns the (return) value of `aBlock`
    "

    <exception: #unwind>

    | retval |

    self acquireWithTimeoutMs: nil.
    retval := aBlock value.
    thisContext unmarkForUnwind.
    self release.
    ^ retval

    "Created: / 31-08-2017 / 10:12:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLock methodsFor:'unwinding'!

unwindHandlerInContext:aContext
    aContext selector == #critical: ifTrue:[
        ^ [
            "/ When unwiding a #critical: frame, there are two (only two?)
            "/ cases:
            "/
            "/ 1. the critical section is executing aand being unwound
            "/ 2. the process calling #critical: is waiting inside #acquire...
            "/    for some other process to release it.
            "/
            "/ In the first case we have to call #release, in the second
            "/ we MUST NOT since other process owns the lock.
            "/ To distinguish, we check whether we own the lock or not
            "/ by `self owner == Processor activeProcess`.
            self owner == Processor activeProcess ifTrue:[ self release ].
          ]
    ].
    self shouldNeverBeReached.

    "Created: / 31-08-2017 / 10:11:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 11-12-2017 / 11:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLock methodsFor:'waiting'!

wait
    self breakPoint: #jv.
    self acquire.

    "Modified: / 25-08-2017 / 08:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RecursionLock class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


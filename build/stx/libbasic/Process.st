"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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

Link subclass:#Process
	instanceVariableNames:'id lookupActivations lookupDisabled prio state startBlock name
		restartable interruptActions exitActions suspendSemaphore
		singleStepping emergencySignalHandler suspendActions creatorId
		processGroupId interruptsDisabled priorityRange
		exceptionHandlerSet processType environment startTimestamp'
	classVariableNames:'TerminateSignal RestartSignal CaughtSignals SysProcessId'
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Process class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    WARNING:
        the offsets of the instance variables lookupActivations and lookupDisabled are known in the VM
        do not remove them, and do not insert/remove instance variables before them

    Instances of Process represent lightweight smalltalk processes
    (i.e. threads). These all run in a shared smalltalk/X address space,
    and can thus access and communicate via any objects.
    Do not confuse these with (heavy-weight) unix processes, which are
    created differently, and do NOT run in the same address space.
    Also notice, that heavy-weight process creation takes much longer.
    (see OperatingSystemclass>>fork).

    Smalltalk processes do not nescessarily need to be implemented as native
    threads - it may, but the actual implementation depends on the underlying
    OS'S features. However, even if implemented as native thread, the ST/X
    kernel makes certain, that only one thread executes at a time (with certain,
    well-defined exceptions). The reason is that the required locking in the
    runtime system would make things slower in most cases.

    Processes are typically created by sending #fork or #forkAt: to a block;
    the block creates a new process, defines itself as its startBlock,
    and (optionally) tells the Processor about the new process.

    Scheduling is done by Processor, which is the sole instance of ProcessorScheduler.
    In ST/X, the scheduling algorithms are fully implemented (and visible) on the
    smalltalk level - beside the threadSwitch primitive, there is virtually no VM
    support (i.e. it can be easily changed).


    Processes can be terminated either soft or via a hardTerminate.

    A soft terminate (see Process>>terminate) will raise a TerminationSignal
    in the process, which can be handled by the process.
    If no other handler was specified, the processes own handler
    (see Process>>start) will catch the signal and terminate the process.
    During this signal processing, normal unwind processing takes place,
    this means that with a soft terminate, all valueOnUnwind:/valueNowOrOnUnwind:
    cleanup blocks are evaluated.
    (so a process which has set up those blocks correctly does not have to
     care especially about cleanup in case of termination).
    Other than that, the TerminateSignal can be caught for special cleanup or
    even to make the process continue execution.
    If the process is suspended at termination time, it will be resumed
    in order to perform its cleanup actions (i.e. the cleanup is always
    done in the context of the terminating process itself).

    A hard terminate (Process>>terminateNoSignal) will NOT do all of the above,
    but quickly (and without any cleanup) terminate the process.
    The debugger offers a quickTerminate option on its popupMenu for
    situations, when soft termination fails. (for example, if some error was
    coded into a handler or unwind block).

    Leaving the processes startBlock has the same effect as a soft-terminate
    (i.e. there is no need to send an explicit terminate).

    Notice:
        in Smalltalk/X, processes are gone, when an image is restarted;
        this means, that you have to take care of process re-creation yourself.
        Usually, this is done by depending on ObjectMemory, recreating the
        process(es) when the #returnFromSnapshot-change notifiction arrives.

        All views (actually windowGroups) recreate their window process
        on image-restart. You have to do so manually for your own processes.

    A later version will allow specification of automatic restart, but
    that's not yet implemented. However, even when implemented, restartable processes
    will be recreated to restart from the beginning. It will not be possible to
    automatically continue a processes execution where it left off.
    This is a consequence of the portable implementation of ST/X, since in order to
    implement process continuation, the machines stack had to be preserved and
    recreated.  Although this is possible to do (and actually not too complicated),
    this has not been implemented, since the machines stack layout is highly machine/compiler
    dependent, thus leading to much bigger porting effort of ST/X (which conflicts
    with ST/X's design goal of being highly portable).

    Process synchronization:
        Synchronization with cooperating processes is supported as usual,
        via Semaphores (see Semaphore, Delay, SharedQueue etc.)

        With uncooperative processes, only synchronization on suspend
        and termination is possible:
          any other process can wait for a process to suspend or terminate.
          This waiting is implemented by using suspendSemaphore and exitBlocks
          (where an exitSemaphore is signalled).
          See waitUntilSuspended / waitUntilTerminated.

    Implementation note:
        for historic and compatibility reasons, Process is a subclass of Link,
        which means, that instances are directly usable as nodes in a linkedList.
        However, this also means, that processes can only be elements of a single LinkedList.
        This is somewhat dangerous, as unknowledgable programmers may unwillingly break the
        scheduler, by placing a process onto another linked list.
        Therefore, we plan to change this in the future.
        
    Process states:
        #dead           process has (been) terminated;
                        the process instance has no underlting
                        thread.

        #run            the process is willing to run,
                        but not active (i.e. another higher prio
                        process is currently executing)

        #active         the process is the current process
                        (there is only one)

        #ioWait         waiting on some io-related semaphore
                        (typically in #readWait / #writeWait)

        #eventWait      waiting on some GUI event

        #timeWait       waiting on a timer-related semaphore

        #wait           waiting on some (other) semaphore

        #suspended      stopped from execution; however, an interrupt
                        will return it into the run state.

        #stopped        stopped from execution; an interrupt will
                        NOT return it into the run state (for debugging)

        #debug          debugger sitting on top of the processes
                        stack.

    Win32 only:

        #osWait         waiting on an OS-API call to finish.
                        can be interrupted, terminated and aborted
                        (i.e. the usual context actions are is possible).

        #halted         thread was caught while in a blocking API call
                        or primitive endless loop and has been halted by
                        the scheduler.
                        Can only be resumed or hard-terminated - abort
                        or soft terminate or unwind actions are not possible.
                        (due to win32 limitations)


    [Instance variables:]

        id                     <SmallInteger>   a unique process-id

        creatorId              <SmallInteger>   the id of the process that
                                                created me (useful for debugging
                                                or monitoring).

        processGroupId                          usually the id of the creator,
                                                unless the process detached from
                                                the group and became a groupLeader.
                                                Groups can be easily terminated
                                                as a whole.
                                                Group leaders have a groupId of nil.
                                                A groupId of 0 (zero) marks a system
                                                process; these do not prevent a standAlone
                                                app from exiting.

        prio                   <SmallInteger>   the processes priority

        priorityRange          <Interval>       the processes dynamic priority range
                                                (or nil)

        state                  <Symbol>         the processes state
                                                (for process-monitor)

        startBlock             <Block>          the startup-block (the one that forked)

        name                   <String-or-nil>  the processes name (if any)
                                                (for process-monitor)

        suspendSemaphore       <Semaphore>      triggered when suspend (if nonNil)

        restartable            <Boolean>        is restartable; if true, the process
                                                will be restarted when an image is
                                                restarted. Otherwise, it remains dead.
                                                Running processes cannot be continued
                                                at the point where leftOff after an
                                                image-restart.

        interruptActions       <Collection>     interrupt actions as defined by interruptWith:,
                                                performed at interrupt time

        exitActions            <Collection of Block>
                                                additional cleanup actions to perform
                                                on termination (if nonEmpty)

        emergencySignalHandler <Block>          can be used for per-process
                                                emergency signal handling

        interruptsDisabled     <Boolean>        flag if interrupts (as installed
                                                via #interruptWith:) are currently
                                                disabled. (i.e. on-hold).
                                                Interrupts will be delivered when
                                                reenabled.

        exceptionHandlerSet    <ExceptionhandlerSet>
                                                Handled by any process; allows for
                                                exceptionHandlers and query-answerers to
                                                be added/removed dynamically.

    [Class variables:]

        TerminateSignal         <Signal>        signal used to terminate processes
                                                (should not be caught - or at least
                                                 rejected in handlers).
                                                If caught and proceeded, a process
                                                cannot be terminated via #terminate.
                                                For hardTermination (in case of emergency),
                                                send it a #erminateNoSignal message.

        RestartSignal           <Signal>        signal used to restart a process.
                                                Can be caught in additional handler(s),
                                                to perform all kind of re-initialization.
                                                However, these handlers should reject,
                                                for the restart to be really performed.

    [see also:]
        ProcessorScheduler
        Block
        Sempahore SemaphoreSet Delay SharedQueue
        WindowGroup
        (``Working with processes'': programming/processes.html)

    [author:]
        Claus Gittinger

"
!

examples
"
    start a background process, computing 1000 factorial 100 times;
    the processes priority is set to not disturb any interactive process.
    Since its prio is higher than the 3D animation demos prio, you will notice,
    that those are suspended while the computation runs. But Interactive views
    (like browsers) will continue to react normal.
									[exBegin]
    [
       'starting' printNL.
       100 timesRepeat:[1000 factorial].
       'done with factorial' printNL.
    ] forkAt:(Processor userBackgroundPriority).
									[exEnd]


    start a background process, computing 1000 factorial 100 times;
    the processes priority is set to not disturb any process.
    The prio is set to 1 (which is the lowest possible) notice that now,
    the 3D animation demos also continue to run.
									[exBegin]
    [
       'starting' printNL.
       100 timesRepeat:[1000 factorial].
       'done with factorial' printNL.
    ] forkAt:1.
									[exEnd]


    start a background process, reading a pipe without blocking other
    processes;
									[exBegin]
    [
       |p|

       'starting' printNL.
       p := PipeStream readingFrom:'ls -lR .'.
       [p atEnd] whileFalse:[
	   p readWait.
	   p nextLine printNL.
       ].
       p close.
       'done with pipe' printNL.
    ] forkAt:1.
									[exEnd]

    see more examples in doc/coding
    (or search in the browser for senders of fork*)
"
! !

!Process class methodsFor:'initialization'!

initialize
    TerminateSignal isNil ifTrue:[
	TerminateSignal := TerminateProcessRequest.
	TerminateSignal notifierString:'unhandled process termination'.

	RestartSignal := RestartProcessRequest.
	RestartSignal notifierString:'unhandled process restart'.

	CaughtSignals := SignalSet
			    with:AbortAllOperationRequest
			    with:TerminateProcessRequest
			    with:RestartProcessRequest.
    ].
    self initializeVMProcessIdConstants.

    "Modified: / 17.11.2001 / 11:07:29 / cg"

!

initializeVMProcessIdConstants

%{
#ifndef __SCHTEAM__
    @global(Process:SysProcessId) = __MKSMALLINT(SYS_PROCESS_ID);
    RETURN (self);
#endif /* not SCHTEAM */
%}.
    self primitiveFailed
! !

!Process class methodsFor:'instance creation'!

for:aBlock priority:aPrio
    "create a new (unscheduled) process which will execute aBlock at
     a given priority, once scheduled. The process will start execution once
     it gets a #resume-message."

    ^ self basicNew for:aBlock priority:aPrio

    "Modified: 25.1.1997 / 01:23:12 / cg"
!

new
    "create a new (unscheduled) process which will execute the start
     method, when scheduled. The process will start execution once
     it gets a #resume-message."

    ^ self basicNew for:nil priority:(Processor activePriority).

    "Created: 25.1.1997 / 01:31:05 / cg"
! !

!Process class methodsFor:'Signal constants'!

restartSignal
    "return the signal used for process restart"

    ^ RestartSignal

    "Created: 28.10.1996 / 20:26:50 / cg"
!

terminateSignal
    "return the signal used for process termination"

    ^ TerminateSignal
! !

!Process class methodsFor:'defaults'!

defaultMaximumStackSize
    "return the default max stack size. All new processes get
     this limit initially.
     It may be changed for individual processes with:
	aProcess setMaximumStackSize:limit"

%{  /* NOCONTEXT */
    extern INT __defaultThreadMaxStackSize();

    RETURN ( __mkSmallInteger( __defaultThreadMaxStackSize() ));
%}

    "
     Process defaultMaximumStackSize
    "

    "Modified: 8.5.1996 / 10:22:24 / cg"
!

defaultMaximumStackSize:numberOfBytes
    "set the default max stack size, return the previous value.
     All new processes get this stack limit initially.
     It may be changed for individual processes with:
	aProcess setMaximumStackSize:limit
     Notice:
	There is seldom any need to change the default setting,
	except for highly recursive programs."

%{  /* NOCONTEXT */
    extern INT __threadSetDefaultMaxStackSize();

    if (__isSmallInteger(numberOfBytes)) {
	RETURN ( __mkSmallInteger(__threadSetDefaultMaxStackSize(__intVal(numberOfBytes)) ));
    }
%}

    "
     Process defaultMaximumStackSize:500*1024
    "

    "Modified: 8.5.1996 / 10:23:26 / cg"
!

wrapStackSize
    "return the wrap stack size.
     Under windows, blocking API calls are executed on a separate stack with this size.
     If you ever encounter that a call to n external library function requires more stack than
     this, you may change this size in your startup (or programmatically) during early startup.
     Returns nil on non-windows machines."

%{  /* NOCONTEXT */
    INT sz = 0;

#ifdef __win32__
    extern INT __getWrapStackSize();

    sz = __getWrapStackSize();
#endif
    RETURN (__MKINT(sz));
%}
!

wrapStackSize:newSize
    "set the wrap stack size.
     Under windows, blocking API calls are executed on a separate stack with this size.
     If you ever encounter that a call to n external library function requires more stack than
     this, you may change this size in your startup (or programmatically) during early startup.
     An argument of 0 changes the size back to the default.
     Returns the previous size."

%{  /* NOCONTEXT */
    INT __oldSize = 0;

    if (__isSmallInteger(newSize)) {
	INT __newSize = __intVal(newSize);

	if (__newSize >= 0) {
#ifdef __win32__
	    extern INT __setWrapStackSize(INT);

	    __oldSize = __setWrapStackSize(__newSize);
#endif
	}
    }
    RETURN (__MKINT(__oldSize));
%}
! !

!Process class methodsFor:'instance retrieval'!

findProcessWithId:id
    <resource: #obsolete>
    "return a process with a particular id.
     This is only a debugging helper, to allow
     easy access of a process by name in the MiniDebugger.
     Do not use - ask Processor instead!!"


    ^ self allSubInstances detect:[:aProcess | aProcess id = id] ifNone:nil.

    "
     Process findProcessWithId:1
    "

    "Modified: / 26.8.1998 / 15:39:55 / cg"
!

findProcessWithName:name
    <resource: #obsolete>
    "return a process with a particular name.
     This is only a debugging helper, to allow
     easy access of a process by name in the MiniDebugger
     Do not use - ask Processor instead!!"

    ^ self allSubInstances detect:[:aProcess | aProcess name = name] ifNone:nil.

    "
     Process findProcessWithName:'scheduler'
    "

    "Modified: / 26.8.1998 / 15:40:54 / cg"
!

findProcessesWithGroupId:aGroupId
    <resource: #obsolete>
    "return a collection of processes with the particular group id.
     Do not use - ask Processor instead!!"

    ^ self allSubInstances select:[:aProcess | aProcess processGroupId = aGroupId ].

    "
     Process findProcessesWithGroupId: 0
    "

    "Modified: / 26.8.1998 / 15:40:54 / cg"
! !

!Process methodsFor:'Compatibility-Squeak'!

isTerminated
    "return true, if the receiver is a dead process"

    ^ self isDead
! !



!Process methodsFor:'accessing'!

beGUIProcess
    "mark the receiver as a gui process.
     This is currently not used, but allows end-user applications
     to terminate all subprocesses which are GUI related, and leave
     other background processes in the same process group untouched."

    processType := #gui
!

beGroupLeader
    "make the receiver a processGroupLeader.
     This detaches the process from its creator, so that it will not
     be terminated when it terminates via #terminateGroup.
     Also, processes forked from a groupLeader belong to that group
     and can be terminated via #terminateGroup - unless they become
     group leaders themself.
     (windowgroup processes do this)."

    processGroupId := id

    "Created: / 08-07-1996 / 14:08:44 / cg"
    "Modified: / 17-10-2007 / 10:49:09 / cg"
!

beSystemProcess
    "make the receiver a system process.
     These processes have a groupId of 0.
     When executed as standAlone application, smalltalk exits when
     no more user processes are running.
     (i.e. when there are only systemProcesses left)
     To prevent any daemon processes from preventing this exit,
     you should make them systemProcesses"

    processGroupId := SysProcessId

    "Created: 17.1.1997 / 21:42:46 / cg"
!

changePriority:aNumber
    "same as priority:, but returns the old priority.
     (cannot do this in #priority: for ST-80 compatibility)"

    |oldPrio|

    oldPrio := prio.
    Processor changePriority:aNumber for:self.
    ^ oldPrio

    "Modified: 23.12.1995 / 18:38:53 / cg"
!

creatorId
    "return the processcreators id.
     This has no semantic meaning, but is useful to identify processes
     when debugging."

    ^ creatorId
!

exceptionHandlerSet
    "retrieve the exceptionHandlerSet, which includes the set of
     exceptionHandlers which are caught by the process.
     Initially being empty, this allows for default handlers to be
     dynamically added/removed from the set of handled exceptions/queries."

    exceptionHandlerSet isNil ifTrue:[
	exceptionHandlerSet := ExceptionHandlerSet new.
    ].
    ^ exceptionHandlerSet
!

id
    "return the processes id"

    ^ id
!

name
    "return the processes name"

    ^ name
!

name:aString
    "set the processes name"

    name := aString
!

priority
    "return the receiver's priority"

    ^ prio
!

priority:aNumber
    "set my priority"

    Processor changePriority:aNumber for:self.
!

priorityRange
    "return my dynamic priority range"

    ^ priorityRange

    "Modified: / 3.8.1998 / 22:55:53 / cg"
!

priorityRange:anInterval
    "change my dynamic priority range"

    |lowPri hiPri newPrio|

    priorityRange := anInterval.
    anInterval notNil ifTrue:[
	lowPri := priorityRange start.
	hiPri := priorityRange stop.
	(newPrio := prio) isNil ifTrue:[
	    newPrio := lowPri
	] ifFalse:[
	    prio < lowPri ifTrue:[
		newPrio := lowPri
	    ] ifFalse:[
		prio > hiPri ifTrue:[
		    newPrio := hiPri
		].
	    ].
	].
	newPrio ~~ prio ifTrue:[
	    self priority:newPrio
	]
    ].

    "Modified: / 3.8.1998 / 22:56:05 / cg"
!

processGroupId
    "return the processes processGroup id.
     Normally, when created, a processes creator id is taken and used
     as the processGroup id.
     When #terminateGroup is sent to a process, the process and all of its
     group members are terminated together.

     Processes can detach themself from the process group to prevent being
     killed when the parent terminates (windowgroup processes do this)."

    ^ processGroupId

    "Created: 8.7.1996 / 13:47:47 / cg"
!

processGroupId:aGroupLeadersProcessID
    "set the processes processGroup id.
     Normally, when created, a processes creator id is taken and used
     as the processGroup id.
     When #terminateGroup is sent to a process, the process and all of its
     group members are terminated together.

     Processes can detach themself from the process group to prevent being
     killed when the parent terminates (windowgroup processes do this)."

    processGroupId := aGroupLeadersProcessID

    "Created: 8.7.1996 / 13:47:53 / cg"
!

restartable:aBoolean
    "set/clear, the restartable flag.
     Restartable processes will automatically be restarted by the
     ProcessorScheduler upon image restart.
     Others have to be restarted manually."

    startBlock isNil ifTrue:[
	self error:'cannot be made restartable when already started' mayProceed:true.
	^ self
    ].
    restartable := aBoolean

    "Modified: 23.12.1995 / 18:38:32 / cg"
!

singleStep:aBoolean
    singleStepping := aBoolean
!

startBlock
    "return the processes startup-block"

    ^ startBlock
!

startTimestamp
    "return the processes' start time"

    startTimestamp notNil ifTrue:[
        ^ startTimestamp
    ].
    "/ the very first system process has no starttime set
    startTimestamp := Smalltalk imageStartTime.
    ^ startTimestamp
!

state
    "return a symbol describing the processes state"

    ^ state
!

state:aSymbol
    "set the state - only to be used from scheduler"

    state := aSymbol
!

suspendedContext
    "return the processes suspended context
     - this is the context from which a process switch into the scheduler
     or another process occurred.
     For the active process, a dead process, or one which
     had no chance to run yet, nil is returned.
     Typically, only the debugger is interested in this one."

%{  /* NOCONTEXT */
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
        RETURN (__threadContext(__intVal(i)));
    }
%}.
    ^ nil
! !

!Process methodsFor:'accessing-change notifications'!

addExitAction:aBlock
    "add aBlock to the processes exit actions.
     This block will be evaluated right before the process dies,
     and can be used to trigger actions somewhere else (i.e. synchronization)."

    exitActions isNil ifTrue:[
	exitActions := OrderedCollection new
    ].
    exitActions add:aBlock

    "Created: 12.1.1997 / 00:34:51 / cg"
!

addSuspendAction:aBlock
    "add aBlock to the processes suspend actions.
     This block will be evaluated when a process gets suspended.
     You may ask what that is useful for - it is useful to flush
     buffered graphic commands of a GUI process (i.e. to force xlib
     to send buffered commands to the display)."

    suspendActions isNil ifTrue:[
	suspendActions := OrderedCollection new
    ].
    suspendActions add:aBlock

    "Modified: 13.12.1995 / 13:44:31 / stefan"
    "Created: 12.1.1997 / 00:35:11 / cg"
!

emergencySignalHandler
    "return the emergencySignalHandler block.
     See Signal>>documentation for more info."

    ^ emergencySignalHandler
!

emergencySignalHandler:aOneArgBlock
    "set the emergencySignalHandler block.
     See Signal>>documentation for more info."

    emergencySignalHandler := aOneArgBlock
!

removeAllExitActions
    "remove all exit actions."

    exitActions := nil.

    "Created: 12.1.1997 / 00:36:02 / cg"
!

removeAllSuspendActions
    "remove all suspend actions."

    suspendActions := nil.

    "Created: 12.1.1997 / 00:36:16 / cg"
!

removeExitAction:anExitAction ifAbsent:exceptionBlock
    "remove the identical exitAction; if found, remove and return it;
    if not, return the value from evaluating exceptionBlock"

    exitActions notNil ifTrue:[
	^ exitActions removeIdentical:anExitAction ifAbsent:exceptionBlock.
    ].
    ^ exceptionBlock value.
! !

!Process methodsFor:'accessing-stack'!

maximumStackSize
    "returns the processes stack limit - i.e. the process will be
     interrupted with a recursionSignal-raise, if it ever
     needs more stack (in bytes) than this number"

%{  /* NOCONTEXT */
    extern INT __threadMaxStackSize();
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	RETURN( __MKINT(__threadMaxStackSize(__intVal(i))) );
    }
%}.
    ^ nil
!

setMaximumStackSize:limit
    "sets the processes stack limit - i.e. the process will be
     interrupted with a recursionSignal-raise, if it ever
     needs more stack (in bytes) than this number.
     Returns the old value."

%{  /* NOCONTEXT */
    extern INT __threadSetMaxStackSize(int, unsigned INT);
    OBJ i;

    if (__isSmallInteger(i = __INST(id))
     && __isSmallInteger(limit) ) {
	RETURN ( __MKINT(__threadSetMaxStackSize(__intVal(i), __intVal(limit))) );
    }
%}.
    ^ nil
!

setStackInitialSize:initial increment:increment safe:safe
    "hook for fine-tuning. Sets the processes initialStackSize- and
     and stackIncrement-parameters. Not for normal use."

%{  /* NOCONTEXT */
    extern INT __threadSetJunkSizes(int, unsigned INT, unsigned INT, unsigned INT);

    OBJ i;

    if (__isSmallInteger(i = __INST(id))
     && __isSmallInteger(initial)
     && __isSmallInteger(increment)
     && __isSmallInteger(safe)) {
	RETURN ( __threadSetJunkSizes(__intVal(i), __intVal(initial), __intVal(increment), __intVal(safe)) ? true : false );
    }
%}.
    ^ false
! !

!Process methodsFor:'interrupts'!

addInterruptAction:aBlock
    "make the receiver evaluate aBlock when resumed/interrupted.
     The name is somewhat misleading (actually, its historic):
     the block is also evaluated on resume."

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    interruptActions isNil ifTrue:[
	interruptActions := OrderedCollection with:aBlock.
    ] ifFalse:[
	interruptActions addFirst:aBlock.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

blockInterrupts
    "disable interrupt processing for the receiver process
     - if disabled, incoming interrupts will be registered and handled as
     soon as interrupts are reenabled via unblockInterrupts.
     Returns the previous blocking status i.e. true if interrupts
     where already blocked. You need this information for proper
     unblocking, in case of nested block/unblock calls.
     This is similar to OperatingSystem>>blockInterrupts, but only
     affects interrupts for the receiver process
     (i.e. those which are installed via #interruptWith:)"

    |disabledBefore|

    disabledBefore := interruptsDisabled.
    interruptsDisabled := true.
    ^ disabledBefore ? false

    "
     |p1|

     p1 := [
	     Transcript showCR:'disabled ...'.
	     Transcript showCR:Processor activeProcess blockInterrupts.
	     Transcript showCR:'busy ...'.
	     Delay waitForSeconds:10.
	     Transcript showCR:'enabled ...'.
	     Processor activeProcess unblockInterrupts.
	   ] forkAt:9.

     p1 interruptWith:[Transcript showCR:'interrupted'].
    "
!

evaluateInterruptActionsWithContext:aContext
    "evaluate my interrupt-actions."

    |action wasBlocked|

    [interruptActions size ~~ 0] whileTrue:[
	wasBlocked := OperatingSystem blockInterrupts.
	action := interruptActions removeFirst.
	interruptActions size == 0 ifTrue:[ interruptActions := nil ].
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

	action valueWithOptionalArgument:aContext
    ].
!

forceInterruptOnReturnOf:aContext
    "helper entry for debugger. Force a stepInterrupt whenever aContext
     returns either directly or via an unwind."

    aContext markForInterruptOnUnwind.
%{
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	__threadContextStepInterrupt(__intVal(i), 1);
    }
%}

!

hasInterruptActions
    "return true, if there are any interrupt actions to evaluate
     (i.e. if the receiver has been interrupted)."

    ^ interruptActions size ~~ 0
!

interrupt
    "evaluate my interrupt-actions.
     The process will go back to where it got interrupted
     after doing this.

     This is also sent by the VM."

    interruptActions size ~~ 0 ifTrue:[
        self evaluateInterruptActionsWithContext:thisContext sender.
    ].
!

interruptWith:aBlock
    "interrupt the receiver and make it evaluate aBlock.
     If the receiver is currently suspended it is resumed.
     Notice, that the process will only perform the block immediately,
     IFF its priority is higher than the current processes priority.
     Otherwise, it will remain suspended, until its time comes."

    Processor activeProcess == self ifTrue:[
	aBlock value
    ] ifFalse:[
	self addInterruptAction:aBlock.
	Processor scheduleForInterrupt:self.
    ]

    "Modified: 12.1.1997 / 00:52:05 / cg"
!

interruptedIn:aContext
    "evaluate my interrupt-actions.
     This is indirectly called by the VM, when some #interruptWith: action
     was scheduled for the process, and the process is resumed.
     The process will go back to where it got interrupted after doing this."

    "/ the returned value here has a subtle effect:
    "/ if false, the interrupt is assumed to be not taken,
    "/ and will be redelivered.

    interruptsDisabled == true ifTrue:[
        "/ no, I don't want interrupts right now;
        "/ try again later.
        ^ false
    ].

    "/ I tend to disable interrupts, while processing interrupt actions;
    "/ however, this leads to a blocking Debugger sometimes (scroll).
"/    [
"/        interruptsDisabled := true.
        self evaluateInterruptActionsWithContext:aContext.
"/    ] ensure:[
"/        interruptsDisabled := false.
"/    ].
    ^ true

    "Created: 18.10.1996 / 20:43:39 / cg"
    "Modified: 18.10.1996 / 20:47:20 / cg"
!

onResumeDo:aBlock
    "prepare for the receiver to evaluate aBlock when resumed.
     This is like #interruptWith:, but does not resume the receiver
     (i.e. it continues its sleep).
     This is useful to place a breakpoint on a sleeping process, to be fired
     when it awakes."

    self addInterruptAction:aBlock.
    Processor scheduleInterruptActionsOf:self.

    "Created: 5.3.1996 / 17:28:04 / cg"
    "Modified: 8.3.1996 / 13:01:21 / cg"
!

stepInterruptHandler:anObject
    "set the handler for stepInterrupts occurring in the receiver process.
     This is an interface for the debugger and allows it to monitor a threads
     stepInterrupts. Returns the previous handler.
     Not for general use."

%{  /* NOCONTEXT */
    extern OBJ __threadStepInterruptHandler();

    RETURN( __threadStepInterruptHandler(anObject) );
%}
!

unblockInterrupts
    "enable interrupt processing for the receiver process
     - if any interrupts are pending, these will be handled immediately.
     When unblocking interrupts, take care of nested block/unblock
     calls - you should only unblock after a blockcall if they where
     really not blocked before.
     This is similar to OperatingSystem>>unblockInterrupts, but only
     affects interrupts for the receiver process
     (i.e. those which are installed via #interruptWith:)"

    interruptsDisabled := false.
    (interruptActions size ~~ 0 and:[Processor activeProcess == self]) ifTrue:[
        self interrupt.
    ]
! !

!Process methodsFor:'monitoring'!

numberOfStackBoundaryHits
    "internal monitoring only - will vanish"

%{  /* NOCONTEXT */
    extern INT __threadNumberOfStackBoundaryHits();
    INT n;
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	n = __threadNumberOfStackBoundaryHits(__intVal(i));
	n &= _MAX_INT;
	RETURN( __mkSmallInteger(n) );
    }
%}.
    ^ nil
!

numberOfStackSegments
    "return the processes number of stack segments currently used.
     This method is for monitoring purposes only - it may vanish."

%{  /* NOCONTEXT */
    extern int __threadStackSegments();
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	RETURN( __mkSmallInteger((INT)__threadStackSegments(__intVal(i))) );
    }
%}.
    ^ nil
!

totalStackSize
    "return the processes maximum used stack size.
     This method is for monitoring purposes only - it may vanish."

%{  /* NOCONTEXT */
    extern INT __threadTotalStackSize();
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	RETURN( __MKINT(__threadTotalStackSize(__intVal(i))) );
    }
%}.
    ^ nil
!

usedStackSize
    "Return the processes current stack size.
     This method is for monitoring purposes only - it may vanish."

%{  /* NOCONTEXT */
    extern unsigned INT __threadUsedStackSize();
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	RETURN( __MKINT(__threadUsedStackSize(__intVal(i))) );
    }
%}.
    ^ nil
!

vmTrace:aBoolean
    "turn on/off VM message tracing for the receiver.
     This is meant for ST/X debugging, and may vanish.
     Expect lots of output, once this is turned on."

%{  /* NOCONTEXT */
    OBJ i;

    if (__isSmallInteger(i = __INST(id))) {
	__threadTracing(__intVal(i), aBoolean);
    }
%}.
! !

!Process methodsFor:'obsolete'!

exitAction:aBlock
    "Obsoleted by addExitAction: / removeAllExitActions.

     Add aBlock to the processes exit actions.
     This block will be evaluated right before the process dies.
     An argument of nil removes all exitActions."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use addExitAction: / removeAllExitActions'.

    aBlock isNil ifTrue:[
	^ self removeAllExitActions.
    ].

    ^ self addExitAction:aBlock

    "Modified: 13.12.1995 / 13:44:03 / stefan"
    "Modified: 12.1.1997 / 00:39:59 / cg"
!

suspendAction:aBlock
    "Obsoleted by addSuspendAction: / removeAllSuspendActions.

     Add aBlock to the processes suspend actions.
     This block will be evaluated when a process gets suspended.
     A nil argument removes all suspendActions."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use addSuspendAction: / removeAllSuspendActions'.

    aBlock isNil ifTrue:[
	^ self removeAllSuspendActions.
    ].

    ^ self addSuspendAction:aBlock

    "Modified: 12.1.1997 / 00:38:22 / cg"
!

terminateAllSubprocesses
    <resource:#obsolete>
    self obsoleteMethodWarning:'use #terminateAllSubprocessesInGroup'.
    self terminateAllSubprocessesInGroup.
!

terminateWithAllSubprocesses
    <resource:#obsolete>
    self obsoleteMethodWarning:'use #terminateWithAllSubprocessesInGroup'.
    self terminateWithAllSubprocessesInGroup.
! !

!Process methodsFor:'printing & storing'!

printOn:aStream
    "a little more info in my printed representation"

    aStream nextPutAll:state article;
	    space;
	    nextPutAll:state;
	    nextPutAll:' Process (';
	    nextPutAll:self nameOrId.
    name notNil ifTrue:[
	aStream
	    nextPutAll:', id=';
	    nextPutAll:id printString.
    ].
    aStream
	    nextPutAll:')'
! !

!Process methodsFor:'private'!

for:aBlock priority:aPrio
    "setup the new process - the receiver is not scheduled for
     execution, to get it running, send it #resume"

    |nm active|

    prio := aPrio.
    startBlock := aBlock.
    restartable := false.

    Processor newProcessFor:self.

    "
     give me a user-friendly name
    "
    active := Processor activeProcess.
    (nm := active name) notNil ifTrue:[
	"
	 avoid name inflation
	"
	(nm endsWith:' sub') ifFalse:[
	    nm := nm , ' [' ,  active id printString , '] sub'
	].
	name := nm
    ].
    creatorId := active id.
    processGroupId := active processGroupId.
    (processGroupId isNil or:[processGroupId == SysProcessId]) ifTrue:[
	processGroupId := creatorId.
    ].

    "/ since groupId is used to detect a systemProcess (SysProcessId),
    "/ do not allow a 0 here; need an explicit beSystemProcess.
    processGroupId == SysProcessId ifTrue:[processGroupId := nil].

    "Modified: 25.1.1997 / 01:28:54 / cg"
! !

!Process methodsFor:'private-scheduler access'!

setId:idNumber state:stateSymbol
    "set id and state - not for public use"

    id := idNumber.
    creatorId := SysProcessId.
    processGroupId := nil.
    state := stateSymbol.
    singleStepping isNil ifTrue:[
	singleStepping := false
    ].
    restartable isNil ifTrue:[
	restartable := false
    ].
    interruptsDisabled isNil ifTrue:[
	interruptsDisabled := false
    ].

    "Modified: 30.10.1996 / 00:35:29 / cg"
!

setPriority:aNumber
    "set priority without telling processor - not for public use"

    prio := aNumber
!

setStartBlock:aBlock
    "set the receiver's startup block"

    startBlock := aBlock
!

setStateTo:newState if:oldState
    state == oldState ifTrue:[state := newState]
!

setStateTo:newState if:oldState1 or:oldState2
    (state == oldState1 or:[state == oldState2]) ifTrue:[state := newState]
! !

!Process methodsFor:'queries'!

isActive
    "return true if I am the active process"

    ^ Processor activeProcess == self
!

isDead
    "return true, if the receiver is a dead process"

    ^ (id isNil or:[state isNil or:[state == #dead]])

    "Modified: 23.12.1995 / 18:35:29 / cg"
!

isDebugged
    "return true, iff the receiver process is currently being debugged
     (i.e. is stopped and a debugger sits on top of it)"

    ^ (state == #debug)

    "Created: / 26-09-2012 / 14:56:36 / cg"
!

isGUIProcess
    "return true, if this is a GUI process.
     I.e. a windowGroup process.
     This is currently not used, but allows end-user applications
     to terminate all subprocesses which are GUI related, and leave
     other background processes in the same process group untouched."

    ^ processType == #gui
!

isRestartable
    "return true, iff the receiver is restartable"

    ^ restartable
!

isSingleStepping
    ^ singleStepping
!

isStopped
    "return true, iff the receiver is stopped"

    ^ (state == #stopped)

    "Modified: 23.12.1995 / 18:35:29 / cg"
!

isSystemProcess
    "return true if aProcess is a system process,
     which should not be suspended/terminated etc.."

    ^ (Processor isPureEventDriven
       or:[id == SysProcessId
       or:[processGroupId == SysProcessId
       or:[(Display notNil and:[Display dispatchProcess == self])
       ]]])

    "
     Processor activeProcessIsSystemProcess
    "

    "Created: 17.4.1997 / 12:57:37 / stefan"
!

isUserProcess
    "return true if aProcess is a user process."

    ^ processGroupId ~~ SysProcessId and:[id ~~ SysProcessId]
!

nameOrId
    "return a string to identify the process - either name or id"

    name notNil ifTrue:[^ name].
    ^ id printString
!

parentProcess
    "answer my parent.
     Notice: we do only keep the id here, to prevent the parentProcess from being
     referenced (and therefore not garbage collected if it terminates)"

    ProcessorScheduler knownProcessesDo:[:p|
	p id = creatorId ifTrue:[^ p].
    ].
    ^ nil.

    "
      Processor activeProcess parentProcess
    "

    "Modified: / 26-10-2012 / 13:15:55 / cg"
!

processGroupLeader
    "answer the parent of this process group"

    |processes leader next creatorId|

    processes := ProcessorScheduler knownProcesses.
    leader := processes detect:[:p| p id = processGroupId] ifNone:nil.
    leader isNil ifTrue:[
	leader := self.
	[
	    creatorId := leader creatorId.
	    next := processes detect:[:p| p id = creatorId
					  and:[p processGroupId = processGroupId]]
			      ifNone:nil.
	] doWhile:[next notNil and:[leader := next. true]].
    ].

    ^ leader.

    "
      Processor activeProcess processGroupLeader
    "
! !

!Process methodsFor:'special'!

externalLookupPopIfEqual: lookupObject
    "Called by method lookup MOP when an lookup context is to be unwound
     to cleanup lookup stack"
    lookupActivations first == lookupObject ifTrue:[
	lookupActivations := lookupActivations second.
    ].

    "Created: / 04-10-2013 / 10:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-10-2013 / 12:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

millisecondDelay:millis
    "suspend the current process for some time.
     Attention:
	If the receiver is a system process (i.e. scheduler or event dispatcher)
	this blocks the whole Smalltalk for the time delta;
	if it's a normal thread, only that thread is suspended."

    (self isSystemProcess) ifTrue:[
	OperatingSystem millisecondDelay:millis
    ] ifFalse:[
	Delay waitForMilliseconds:millis
    ]

    "Created: 16.12.1995 / 13:10:53 / cg"
    "Modified: 17.4.1997 / 13:02:25 / stefan"
!

trapRestrictedMethods:trap
    "Allow/deny the execution of restricted methods.
     Process specific method restriction is not implemented yet, so this call is
     redirected to ObjectMemory and causes a system wide restriction.

     Notice: method restriction is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ObjectMemory trapRestrictedMethods:trap

    "
	Processor activeProcess trapRestrictedMethods:true
	Processor activeProcess trapRestrictedMethods:false
    "

    "Created: 8.11.1995 / 19:45:04 / stefan"
!

uninterruptablyDo:aBlock
    "execute aBlock with interrupts blocked.
     This does not prevent preemption by a higher priority processes
     if any becomes runnable due to the evaluation of aBlock
     (i.e. if a semaphore is signalled there)."

    "we must keep track of blocking-state if this is called nested"
    (OperatingSystem blockInterrupts) ifTrue:[
	"/ already blocked
	^ aBlock value
    ].

    ^ aBlock ensure:[OperatingSystem unblockInterrupts]
!

waitUntilSuspended
    "wait until the receiver is suspended."

    self isDead ifFalse:[
	[
	    "/ must check again - interrupt could have happened
	    "/ and process already terminated.
	    self isDead ifFalse:[
		suspendSemaphore isNil ifTrue:[
		    suspendSemaphore := Semaphore new name:'process suspend'
		].
		suspendSemaphore wait
	    ]
	] valueUninterruptably
    ]

    "Modified: 8.11.1996 / 23:05:24 / cg"
!

waitUntilTerminated
    "wait until the receiver is terminated.
     This method allows another process to wait till the receiver finishes."

    self waitUntilTerminatedWithTimeout:nil

    "
     |p|

     p := [100 timesRepeat:[1000 factorial]] forkAt:4.

     Transcript showCR:'now waiting ...'.
     p waitUntilTerminated.
     Transcript showCR:'done.'
    "

    "Modified: 12.1.1997 / 00:40:59 / cg"
!

waitUntilTerminatedWithTimeout:secondsOrNil
    "wait until the receiver is terminated or (if non-nil) until
     the time period exired.
     Returns true if a timeout occurred.
     This method allows another process to wait until the receiver finishes
     (optionally) within some time."

    |sema didTimeout|

    didTimeout := false.

    self isDead ifFalse:[
	[
	    "/ must check again - interrupt could have happened
	    "/ and process already terminated.
	    self isDead ifFalse:[
		sema := Semaphore new name:'process termination'.
		self addExitAction:[sema signal].
		didTimeout := (sema waitWithTimeout:secondsOrNil) isNil
	    ]
	] valueUninterruptably.
    ].
    ^ didTimeout

    "
     |p|

     p := [10 timesRepeat:[10000 factorial]] forkAt:4.

     Transcript showCR:'now waiting ...'.
     (p waitUntilTerminatedWithTimeout:2) ifTrue:[
	 Transcript showCR:'timeout occurred.'
     ]
    "

    "Modified: / 13-01-2011 / 13:45:08 / cg"
!

withHigherPriorityDo:aBlock
    "execute aBlock at a higher priority."

    ^ self withPriority:(prio + 1) do:aBlock

    "
     Processor activeProcess withHigherPriorityDo:[3000 factorial]
    "
!

withLowerPriorityDo:aBlock
    "execute aBlock at a lower priority. This can be used to perform
     time-consuming operations at a more user-friendly priority."

    ^ self withPriority:(prio - 1) do:aBlock

    "
     Processor activeProcess withLowerPriorityDo:[3000 factorial]
    "
!

withPriority:aPrio do:aBlock
    "execute aBlock at another priority. This can be used to perform
     time-consuming operations at a more user-friendly priority,
     or some critical action at a higher priority. Do not use too high
     of a priority to avoid locking up the system (event processing takes place
     at 24)"

    |oldprio|

    oldprio := prio.
    self priority:aPrio.

    ^ aBlock ensure:[
	self priority:oldprio
    ]

    "
     Processor activeProcess withPriority:7 do:[3000 factorial]
    "
    "be careful - even ^C wont work until done:
     Processor activeProcess withPriority:25 do:[3000 factorial]
    "
!

withPriority:lowPrio to:highPrio do:aBlock
    "execute aBlock at a priority range. This can be used to perform
     time-consuming operations at a more user-friendly priority,
     or some critical action at a higher priority. Do not use too high
     of a priority to avoid locking up the system (event processing takes place
     at 24)"

    |oldprio oldRange|

    oldprio := prio.
    oldRange := priorityRange.
    self priorityRange:(lowPrio to:highPrio).

    ^ aBlock ensure:[
	self priorityRange:oldRange.
	self priority:oldprio.
    ]

    "
     Processor activeProcess withPriority:7 to:8 do:[3000 factorial]
    "
!

withSystemBackgroundPriorityDo:aBlock
    "execute aBlock at system background priority.
     This can be used to perform
     background operations at a more user-friendly priority."

    ^ self withPriority:(Processor systemBackgroundPriority) do:aBlock

    "
     Processor activeProcess withSystemBackgroundPriorityDo:[3000 factorial]
    "

    "Created: 7.8.1997 / 12:56:23 / cg"
!

withUserBackgroundPriorityDo:aBlock
    "execute aBlock at background priority. This can be used to perform
     time-consuming operations at a more user-friendly priority."

    ^ self withPriority:(Processor userBackgroundPriority) do:aBlock

    "
     Processor activeProcess withUserBackgroundPriorityDo:[3000 factorial]
    "

    "Created: 6.8.1997 / 15:40:02 / cg"
! !

!Process methodsFor:'startup'!

imageRestart
    "restart the process from the beginning.
     This is sent by the ProcessorScheduler at image restart time,
     to all restartable processes."

    |savedGroupId|

"/  ('restart process ' , id printString) errorPrintNL.

    savedGroupId := processGroupId.

    (Processor newProcessFor:self withId:id) ifFalse:[
	"for some reason, the Processor was unable to create
	 a VM process for me ...."

	('Process [warning]: process ' , id printString , ' failed to restart.') errorPrintCR.
	^ nil
    ].
    processGroupId := savedGroupId.
    self resume

    "Created: 28.10.1996 / 20:32:34 / cg"
    "Modified: 10.1.1997 / 18:01:13 / cg"
!

restart
    "restart the process from the beginning.
     This is only possible, if its restartable."

    restartable ifFalse:[
	^ self error:'process is not restartable' mayProceed:true
    ].

    self interruptWith:[RestartSignal raise]

    "Modified: 12.1.1997 / 00:54:32 / cg"
!

start
    "start the process - this is sent by the VM to the process to get
     the process up and running.
     Sending #start to the process (instead of directly executing the startBlock)
     allows more flexible handling of processes, since anything that responds
     to #start can be handled transparently by the VM then ..."

    |block|

    startBlock isNil ifTrue:[
        "is this artificial restriction useful ?"
        self error:'a process cannot be started twice' mayProceed:true.
        ^ self.
    ].

    "/
    "/ just for your convenience ...
    "/
    startTimestamp := Timestamp now.
    name isNil ifTrue:[
        name := '(' , startBlock displayString , ')'
    ].

    "save block for possible restart"
    block := startBlock.
    restartable ~~ true ifTrue:[
        startBlock := nil
    ].

    [
        "/
        "/ block is the one which received the fork/newProcess some time ago...
        "/
        self exceptionHandlerSet handleDo:block
    ] on:CaughtSignals do:[:ex |
        "/
        "/ CaughtSignals: handle Process-Termination, Process-Restart and Abort
        "/       
        ex creator == RestartProcessRequest ifTrue:[
             ex restart
        ].
        ex return
    ] ensure:[
        self terminateNoSignal
    ].

    "Modified: / 17-11-2001 / 16:45:32 / cg"
    "Modified: / 31-01-2017 / 16:41:05 / stefan"
! !

!Process methodsFor:'suspend & resume'!

abort
    "raise an AbortOperationRequest in the receiver process.
     Most processes willing to handle this will return to some save state
     (typically, some kind of event loop).
     If not handled, this will result in termination of the process."

    Processor activeProcess == self ifTrue:[
	AbortOperationRequest raiseRequest
    ] ifFalse:[
	self interruptWith:[
	    AbortOperationRequest raiseRequest
	].
    ]

    "Modified: / 16.11.2001 / 17:39:18 / cg"
!

resume
    "resume the receiver process"

    state == #stopped ifTrue:[
	state := #run.
    ].
    Processor resume:self
!

resumeForSingleSend
    "resume the receiver process, but only let it execute a single send."

    Processor resumeForSingleSend:self
!

stop
    "suspend the receiver process - will continue to run when a resume is sent.
     A stopped process will not be resumed for interrupt processing."

    self suspendWithState:#stopped.

    "Modified: / 13.12.1995 / 13:22:58 / stefan"
    "Modified: / 27.7.1998 / 23:37:15 / cg"
!

suspend
    "suspend the receiver process - it will continue to run when a resume is sent.
     Notice, that an interrupt will also resume the receiver,
     so any waiting code should be prepared for premature return from
     a suspend (see wait code in Semaphore).
     Use #stop for a hard-suspend, which is not affected by interrupts."

    self suspendWithState:#suspended

    "Modified: 17.6.1996 / 14:41:34 / cg"
!

suspendWithState:aStateSymbol
    "like suspend, this suspends the receiver process until a resume is sent.
     This sets the state to the argument, aStateSymbol, which is shown
     in the ProcessMonitor (instead of #suspended).
     (i.e. no new functionality, but a bit more debuggability)
     Notice, that an interrupt will also resume the receiver,
     so any waiting code should be prepared for premature return from
     a suspend (see wait code in Semaphore).
     Use #stop for a hard-suspend, which is not affected by interrupts.
     Should be called with interrupts disabled."

    suspendSemaphore notNil ifTrue:[suspendSemaphore signalForAll].
    suspendActions notNil ifTrue:[
	|savedState|

	savedState := state.
	state := #aboutToSuspend.
	suspendActions do:[:action | action value].
	state ~~ #aboutToSuspend ifTrue:[
	    "/ mhmh - one of the suspendActions lead to making me active again;
	    "/ bail out.
	    "/ This fixes the Semaphore was signalled, but process did not run error,
	    "/ which can happen when a process with a suspend action goes into a readWait,
	    "/ and the suspend action does a thread switch, and the readWait semaphore gets
	    "/ signalled before we come back here. Then the semaphore wakeup will have already
	    "/ place me back into the run state, so I should not go into a suspend below.
	    ^ self.
	].
	state := savedState.
    ].

    "
     this is a bit of a kludge: allow someone else to
     set the state to something like #ioWait etc.
     In this case, do not set the receiver's state to #suspend.
     (All of this to enhance the output of the process monitor ...)
    "
    (state == #active
    or:[state == #run
    or:[aStateSymbol == #stopped]]) ifTrue:[
	state := aStateSymbol.
    ].
    Processor suspend:self
!

terminate
    "terminate the receiver process.
     Termination is done by raising the terminateSignal in the receiver process,
     which can be caught.
     All unwind actions and the exit-actions (if any)
     will be performed before the process is really terminated.
     Notice, that the terminate actions are performed by the receiver,
     at its current priority. Therefore, in case higher prio processes are
     running, it may take any arbitrary time until the termination is eventually
     done."

    |wasBlocked|

    Processor activeProcess == self ifTrue:[
        "suicide: terminating myself"
        NoHandlerError handle:[:ex |
            "unhandled TerminateProcessRequest is not an error"
            ex exception creator ~~ TerminateProcessRequest ifTrue:[
                ex reject.
            ].
        ] do:[
            TerminateProcessRequest raise.
        ].
        self terminateNoSignal.
        "not reached"
        ^ self.
    ].

    "the receiver is terminated from another process"
    wasBlocked := OperatingSystem blockInterrupts.
    [
        (state isNil or:[state == #dead]) ifTrue:[
            ^ self.
        ].
        state == #osWait ifTrue:[
            "osWait processes cannot be interrupted"
            self terminateNoSignal.
            ^ self.
        ].

        self suspendedContext isNil ifTrue:[
            "if the receiver had no chance to execute yet,
             it can be shot down without a signal"
            self terminateNoSignal.
            ^ self
        ]
    ] ensure:[
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts]
    ].

    "register an interrupt action, so that I am terminating myself"
    self interruptWith:[
        self terminate.
    ].
    "maybe I am stopped - resume so that I can die"
    self resume.

    "Modified: / 24-08-1998 / 18:29:46 / cg"
    "Modified (comment): / 27-01-2017 / 18:08:46 / stefan"
!

terminateAllGUISubprocesses
    "terminate all the receiver's gui subprocesses and their children as well
     (i.e. all processes which are offsprings of the receiver, except for
      the receiver itself)."

    id isNil ifTrue:[
        "/ problem:
        "/ if receiver is already dead, its id is nil.
        "/ children are found by looking for processes with a parentID identical to
        "/ mine - ifNil, system processes are found, which is probably not what you
        "/ want ...
        "/ FIX: remember the id (or don't nil it when terminating)
        "/ requires VM changes.
        ProcessorScheduler invalidProcessSignal
            raiseRequestWith:self
            errorString:'process is already dead - cannot determine child processes'.
        ^ self
    ].
    ProcessorScheduler knownProcesses do:[:aProcess |
        (aProcess ~~ self and:[aProcess creatorId == id and:[aProcess isGUIProcess]]) ifTrue:[
            aProcess terminateWithAllGUISubprocesses
        ].
    ].

    "Created: / 28-10-1996 / 20:43:32 / cg"
    "Modified: / 26-10-2012 / 13:16:35 / cg"
    "Modified: / 24-01-2017 / 17:38:10 / stefan"
!

terminateAllSubprocessesInGroup
    "terminate all subprocesses which have the receiver process as groupID,
     and their group-children as well.
     (i.e. all processes in the receiver's process group, except for the receiver itself,
      and recursively oll of their group processes.)."

    id isNil ifTrue:[
        "/ problem:
        "/ if receiver is already dead, its id is nil.
        "/ children are found by looking for processes with a parentID identical to
        "/ mine - ifNil, system processes are found, which is probably not what you
        "/ want ...
        "/ FIX: remember the id (or don't nil it when terminating)
        "/ requires VM changes.
        ProcessorScheduler invalidProcessSignal
            raiseRequestWith:self
            errorString:'process is already dead - cannot determine child processes'.
        ^ self
    ].
    self terminateAllSubprocessesInGroup:id
!

terminateAllSubprocessesInGroup:aGroup
    "terminate all subprocesses which have aGroup as groupID,
     and their group-children as well.
     (i.e. all processes in the receiver's process group, except for the receiver itself,
      and recursively oll of their group processes.)."

    ProcessorScheduler knownProcesses do:[:aProcess |
        (aProcess ~~ self and:[aProcess processGroupId == aGroup]) ifTrue:[
            aProcess terminateWithAllSubprocessesInGroup
        ].
    ].

    "Created: / 28-10-1996 / 20:43:32 / cg"
    "Modified: / 03-11-1997 / 00:28:06 / cg"
    "Modified: / 24-01-2017 / 17:42:33 / stefan"
!

terminateGroup
    "terminate the receiver with all of its created subprocesses
     that are in the receiver's process group."

    id isNil ifTrue:[
        "/ problem:
        "/ if receiver is already dead, its id is nil.
        "/ children are found by looking for processes with a parentID identical to
        "/ mine - ifNil, system processes are found, which is probably not what you
        "/ want ...
        "/ FIX: remember the id (or don't nil it when terminating)
        "/ requires VM changes.
        ProcessorScheduler invalidProcessSignal
            raiseRequestWith:self
            errorString:'process is already dead - cannot determine child processes'.
        ^ self
    ].
    ProcessorScheduler knownProcesses do:[:aProcess |
        (aProcess ~~ self and:[aProcess processGroupId == id]) ifTrue:[
            aProcess terminate
        ].
    ].
    self terminate

    "Modified: / 24-01-2017 / 17:41:12 / stefan"
!

terminateNoSignal
    "hard-terminate the receiver process without sending a terminateSignal
     or performing any unwind-handling.
     However, exit-actions are performed.
     This is useful in case of emergency, when a buggy terminationHandler
     prevents you from getting a process to terminate."

    |block|

    "/ this is treated like the final suspend
    suspendActions notNil ifTrue:[
	[suspendActions isEmpty] whileFalse:[
	    block := suspendActions removeFirst.
	    block value.
	]
    ].
    exitActions notNil ifTrue:[
	[exitActions isEmpty] whileFalse:[
	    block := exitActions removeFirst.
	    block value.
	]
    ].
    suspendSemaphore notNil ifTrue:[suspendSemaphore signalForAll].
    Processor terminateNoSignal:self

    "Modified: 13.12.1995 / 13:40:14 / stefan"
    "Modified: 12.2.1997 / 12:41:38 / cg"
!

terminateSubprocesses
    "terminate all the receiver's subprocesses
     (i.e. all processes in the receiver's process group, except for
      the receiver itself)."

    id isNil ifTrue:[
        "/ problem:
        "/ if receiver is already dead, its id is nil.
        "/ children are found by looking for processes with a parentID identical to
        "/ mine - ifNil, system processes are found, which is probably not what you
        "/ want ...
        "/ FIX: remember the id (or don't nil it when terminating)
        "/ requires VM changes.
        ProcessorScheduler invalidProcessSignal
            raiseRequestWith:self
            errorString:'process is already dead - cannot determine child processes'.
        ^ self
    ].
    processGroupId == SysProcessId ifTrue:[
        ProcessorScheduler invalidProcessSignal
            raiseWith:self errorString:'trying to terminate the system process group'.
    ].
    ProcessorScheduler knownProcesses do:[:eachProcess |
        eachProcess ~~ self ifTrue:[
            |eachProcessGroupId|

            eachProcessGroupId := eachProcess processGroupId.
            (eachProcessGroupId == processGroupId or:[eachProcessGroupId == id]) ifTrue:[
                eachProcess terminate
            ].
        ].
    ].

    "Created: / 28-10-1996 / 20:41:49 / cg"
    "Modified: / 26-08-1997 / 03:09:57 / cg"
    "Modified: / 24-01-2017 / 17:35:25 / stefan"
!

terminateWithAllGUISubprocesses
    "terminate the receiver with all of its created gui subprocesses and their gui children."

    self terminateAllGUISubprocesses.
    self terminate

    "Modified: 28.10.1996 / 20:42:00 / cg"
    "Created: 28.10.1996 / 20:44:07 / cg"
!

terminateWithAllSubprocessesInGroup
    "terminate the receiver with
     all subprocesses which have the receiver's process ID as groupID,
     and their group-children as well.
     (i.e. the receiver plus all processes in the receiver's process group,
      and recursively all of their group processes)."

    self terminateAllSubprocessesInGroup.
    self terminate

    "Modified: 28.10.1996 / 20:42:00 / cg"
    "Created: 28.10.1996 / 20:44:07 / cg"
! !


!Process methodsFor:'thread local storage'!

environment
    "return the dictionary holding thread local variables, or nil if there are none"

    ^ environment
!

environment:aDictionary
    "set the dictionary holding thread local variables, or nil if there are to be none"

    environment := aDictionary
!

environmentAt:aKey
    "return the value of a thread local variable, or raise an error, if no such variable exists"

    ^ self
	environmentAt:aKey
	ifAbsent:[
	    self errorKeyNotFound:aKey.
	]
!

environmentAt:aKey ifAbsent:defaultValue
    "return the value of a thread local variable, or the value of defaultValue if no such variable exists"

    |val|

    environment isNil ifTrue:[^ defaultValue value].
    val := environment at:aKey ifAbsent:[^ defaultValue value].
    ^ val value.
!

environmentAt:aKey put:aValue
    "set the value of a thread local variable. Returns aValue"

    |var|

    environment isNil ifTrue:[
        environment := IdentityDictionary new
    ].
    var := environment at:aKey ifAbsentPut:[ValueHolder new].
    var value:aValue.
    ^ aValue
!

environmentIncludesKey:aKey
    "true if there is a thread local variable, false if no such variable exists"

    ^ environment notNil and:[environment includesKey:aKey]
!

stderr
    "the processes stderr.
     By default, this is Stderr, but it can be overwritten
     (for example to redirect a thread's error output to some other place"

    ^ self environmentAt:#Stderr ifAbsent:Stderr

    "
     Processor activeProcess stdout
    "

    "
     |out sema|

     out := WriteStream on:''.
     sema := Semaphore new.
     [
	Processor activeProcess environmentAt:#Stdout put:out.
	'hello world' printCR.
	sema signal.
     ] fork.
     sema wait.
     Transcript showCR:('output was: ''',out contents,'''').
    "
!

stdin
    "the processes stdin.
     By default, this is Stdin, but it can be overwritten
     (for example to redirect a thread's input from some other place"

    ^ self environmentAt:#Stdin ifAbsent:Stdin
!

stdout
    "the processes stdout.
     By default, this is Stdout, but it can be overwritten
     (for example to redirect a thread's output to some other place"

    ^ self environmentAt:#Stdout ifAbsent:Stdout
!

threadVariableValueOf:aKey
    "return the value of a thread local variable, 
     or nil if no such variable exists"

    ^ self environmentAt:aKey ifAbsent:nil

    "
     see example in withThreadVariable:boundTo:do:
    "
!

transcript
    "the processes transcript.
     By default, this is Transcript, but it can be overwritten
     (for example to redirect a thread's output to some other place"

    ^ self environmentAt:#Transcript ifAbsent:[Transcript]
!

withThreadLocalVariables:aDictionary do:aBlock
    "evaluate a block with threadLocalVariables from aDictionary;
     restore the old bindings afterwards."

    |oldEnv result|

    oldEnv := environment.

    [
	environment := aDictionary.
	result := aBlock value.
    ] ensure:[
	environment := oldEnv.
    ].
    ^ result
!

withThreadVariable:variableNameSymbol boundTo:aValue do:aBlock
    "evaluate a block with the threadLocalVariable being bound to aValue;
     undo the variable binding afterwards."

    |var oldValue result|

    environment isNil ifTrue:[
        environment := IdentityDictionary new
    ].
    var := environment at:variableNameSymbol ifAbsent:nil.
    var isNil ifTrue:[
        var := ValueHolder new.
        environment at:variableNameSymbol put:var.
    ].

    oldValue := var value.
    [
        var value:aValue.
        result := aBlock value.
    ] ensure:[
        oldValue isNil
            ifTrue:[ environment removeKey:variableNameSymbol]
            ifFalse:[ var value:oldValue ]
    ].
    ^ result

    "
     |printIt|

     printIt := [ 
                    Transcript 
                        showCR:'foo is now ',
                        (Processor activeProcess threadVariableValueOf:#foo) printString 
                ].

     Processor activeProcess
         withThreadVariable:#foo
         boundTo:1234
         do:[
            printIt value.
            Processor activeProcess
                withThreadVariable:#foo
                boundTo:2345
                do:[
                    printIt value
                ].
            ]
    "
! !

!Process class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: Process.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !


Process initialize!

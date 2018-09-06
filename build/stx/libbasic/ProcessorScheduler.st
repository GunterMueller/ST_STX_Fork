"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
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

Object subclass:#ProcessorScheduler
	instanceVariableNames:'quiescentProcessLists scheduler zombie activeProcess
		activeProcessId currentPriority readFdArray readSemaphoreArray
		readCheckArray writeFdArray writeSemaphoreArray writeCheckArray
		timeoutArray timeoutActionArray timeoutProcessArray
		timeoutSemaphoreArray idleActions anyTimeouts dispatching
		interruptedProcess useIOInterrupts gotIOInterrupt
		osChildExitActions gotChildSignalInterrupt
		exitWhenNoMoreUserProcesses suspendScheduler timeSliceProcess
		supportDynamicPriorities timeSliceNeededSemaphore
		scheduledProcesses preWaitActions timeoutHandlerProcess
		readableResultFdArray writableResultFdArray exceptFdArray
		exceptResultFdArray exceptSemaphoreArray interruptCounter
		timedActionCounter'
	classVariableNames:'KnownProcesses KnownProcessIds PureEventDriven
		UserSchedulingPriority UserInterruptPriority TimingPriority
		HighestPriority SchedulingPriority MaxNumberOfProcesses
		InvalidProcessSignal TimeSlicingPriorityLimit TimeSliceInterval
		EventPollingInterval MinProcessId MaxProcessId SysProcessId'
	poolDictionaries:''
	category:'Kernel-Processes'
!

!ProcessorScheduler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    This class has only one instance, which is bound to the global
    'Processor' (well, on future multiprocessor systems, things may look
    different ... ;-). It is responsible for scheduling among the smalltalk
    processes (threads; not to confuse with heavy weight unix processes).

    Scheduling is fully done in smalltalk (the always runnable scheduler-
    process, running at highest priority does this).
    See the 'scheduling' documentation.

    The main VM primitive to support this is found in threadSwitch, which passes
    control to another process (usually selected by the scheduler).
    Thus it is possible to modify the schedulers policy and implementation
    at the smalltalk level.

    Notice: Smalltalk/X can (still) be compiled & configured without
    process support. This non-process mode is called 'pureEventDriven' mode
    and is useful to quickly port ST/X to systems, where these facilities
    are either not needed (server applications), or are difficult to
    implement (threads require some assembler support functions).
    To allow pureEvent mode, kludges are built into some places in the
    system, where either a process is forked, or a timeout is used instead
    (for examples, see ProcessMonitor or MemoryMonitor).

    This pure-event mode may not be supported in the future
    (actually, it is no longer maintained, so don't run the system without Processes).

    [instance variables:]
        quiescentProcessLists           - list of waiting processes
        scheduler                       - the scheduler process itself
        zombie                          - internal temporary (recently died process)
        activeProcess                   - the current process
        activeProcessId                 - the current processes id
        currentPriority                 - the current processes priority
        readFdArray                     - fd-sema-checkBlock triple-association
        readSemaphoreArray                (stupid historic 3-separate arrays for hi-speed-optimization reasons)
        readCheckArray
        writeFdArray                    - fd-sema-checkBlock triple-association
        writeSemaphoreArray               (stupid historic 3-separate arrays for hi-speed-optimization reasons)
        writeCheckArray
        timeoutArray                    - time-action-process-sema quadruple-association
        timeoutActionArray                (stupid historic 3-separate arrays for hi-speed-optimization reasons)
        timeoutProcessArray
        timeoutSemaphoreArray
        idleActions                     - actions to be executed when idle
        preWaitActions                  - actions to be executed BEFORE going into an OS-wait
        anyTimeouts                     - flag if any timeouts are pending
        dispatching                     - flag if dispatch process is running (i.e. NOT initializing)
        interruptedProcess              - the currently interrupted process.
        useIOInterrupts                 - flag if the OS supports I/O interrupts and if they are used (to get me out of an OS wait)
        gotIOInterrupt                  - flag if I came out of a wait due to an I/O interrupt
        osChildExitActions              - OS chid process actions
        gotChildSignalInterrupt         - flag if I came out of a wait due to an OS child interrupt
        exitWhenNoMoreUserProcesses     - flag which controls if ST/X should exit when the last process dies (for standalone apps)
        suspendScheduler                - internal use
        timeSliceProcess                - the timeSlicer process
        supportDynamicPriorities        - flag if dynamic priorities should be supported by the timeSlicer
        scheduledProcesses              - list of scheduled processes for the timeSlicers dynamic prio handling

    [class variables:]

        KnownProcesses          <WeakArray>     all known processes
        KnownProcessIds         <Collection>    and their IDs

        PureEventDriven         <Boolean>       true, if no process support
                                                is available

        UserSchedulingPriority  <Integer>       the priority at which normal
                                                user interfaces run

        UserInterruptPriority                   the priority at which user-
                                                interrupts (Cntl-C) processing
                                                takes place. Processes with
                                                a greater or equal priority are
                                                not interruptable.

        TimingPriority                          the priority used for timing.
                                                Processes with a greater or
                                                equal priority are not interrupted
                                                by timers.

        HighestPriority                         The highest allowed prio for processes

        SchedulingPriority                      The priority of the scheduler (must
                                                me higher than any other).

        MaxNumberOfProcesses                    if non-nil, no more than this
                                                number of processes are allowed
                                                (for debugging)

        TimeSliceInterval                       for preemptive priority scheduling only:
                                                the time interval in millis, at which processes
                                                are timesliced

        TimeSlicingPriorityLimit                for preemptive priority scheduling only:
                                                processes are only timesliced, if running
                                                at or below this priority.

        EventPollingInterval                    for systems which do not support select on
                                                a fileDescriptor: the polling interval in millis.

    most interesting methods:

        Processor>>suspend:                  (see also Process>>suspend)
        Processor>>resume:                   (see also Process>>resume)
        Processor>>terminate:                (see also Process>>terminate)
        Processor>>yield
        Processor>>changePriority:for:       (see also Process>>priority:

        Processor>>signal:afterSeconds:      (see also Delay>>forSeconds:)
        Processor>>signal:afterMilliseconds: (see also Delay>>forMilliseconds:)
        Processor>>signal:onInput:           (see also ExternalStream>>readWait)
        Processor>>signal:onOutput:          (see also ExternalStream>>writeWait)
        Processor>>disableSemaphore:


    [see also:]
        Process
        Delay Semaphore SemaphoreSet SharedQueue
        WindowGroup
        (``Working with processes'': programming/processes.html)

    [author:]
        Claus Gittinger
"
!

scheduling
"
    By default, the scheduler does 'non preemptive priority scheduling';

    this means, that the highest priority runnable process
    is choosen and allowed to run, until it either gives back the CPU (via #yield),
    or suspends (i.e. waiting for I/O, the time or a semaphore),
    or a higher priority process becomes runnable..
    A higher prio process may become runnable either by a programmatic action
    (i.e. signalling a semaphore), by a timer or by IO availability.

    If another process is runnable at the same priority, it will not
    be given CPU-time, unless one of the above happens.

    The consequence is, that a user process running at (say) priority 8,
    may block other user processes at the same priority, if it does heavy
    processing, or loops.
    (the event handling which is responsible to care for userInterrupts,
     is running at a much higher priority,
     so that interrupting the process should always be possible).


    The scheduler also supports 'timesliced priority scheduling', which is enabled
    via the #startTimeSlicing message (and disabled by #stopTimeSlicing).
    In this mode, the highest priority running process is suspended in regular intervals
    (the TimeSliceInterval) IFF there is another runnable process with the same priority.
    I.e. the top highest priority processes are timeshared.
    In this mode, the other processes will also get a chance to make some progress - however,
    lower priority process will only run, IFF all higher prio processes are waiting for an
    event.
    Timeslicing will not be done for processes running above TimeSlicingPriorityLimit, which
    allows for critical processes to run unaffected to completion.

    WARNING:
	timesliced priority scheduling is an experimental feature. There is no warranty,
	(at the moment), that the system runs reliable in this mode.
	The problem is, that shared collections may now be easily modified by other
	processes, running at the same time.
	The class library has being investigated for such possible trouble spots
	(we have eliminated many weak spots, and added critical regions at many places,
	 but cannot guarantee that all of them have been found so far ...)
	We found that many existing public domain programs are not prepared for
	being interrupted by a same-prio process and therefore may corrupt their
	data. If in doubt, disable this fefature.

    We think, that the timeSlicer is a useful add-on and that the system is fit enough
    for it to be evaluated, therefore, its included.
    However, use it at your own risk.

    To demonstrate the effect of timeSlicing, do the following:

	- disable timeSlicing (in the launchers misc-settings menu)
	- open a workSpace
	- in the workspace, evaluate:
		[true] whileTrue:[1000 factorial]

    now, (since the workSpace runs at the same prio as other window-processes),
    other views do no longer react - all CPU is used up by the workSpace.
    However, CTRL-C in the workspace is still possible to stop the endless loop,
    since that is handled by the (higher prio) event dispatcher process.

    Now, stop the factorial-loop, enable timeSlicing, and try again.
    You will notice, that other windows react - although possibly a bit slower,
    since the CPU is now divided equally among the runnable processes (timeSliced).
"
! !

!ProcessorScheduler class methodsFor:'initialization'!

initialize
    "class setup: create the one-and-only instance of myself and
     setup some priority values."

    TimeSliceInterval := 50.
    EventPollingInterval := 20.

    UserSchedulingPriority := 8.
    UserInterruptPriority := 24.
    TimingPriority := 16.
    TimeSlicingPriorityLimit := 26.
    HighestPriority := 30.
    SchedulingPriority := 31.

    self initializeVMProcessIdConstants.

    InvalidProcessSignal isNil ifTrue:[
	InvalidProcessSignal := Error newSignalMayProceed:true.
	InvalidProcessSignal nameClass:self message:#invalidProcessSignal.
	InvalidProcessSignal notifierString:'invalid process'.
    ].

    Processor isNil ifTrue:[
	"create the one and only processor"

	Smalltalk at:#Processor put:(self basicNew initialize).
    ].

    "
     allow configurations without processes
     (but such configurations are no longer distributed)
    "
    PureEventDriven := self threadsAvailable not.
    PureEventDriven ifTrue:[
	'Processor [error]: no process support - running event driven' errorPrintCR
    ].
    

    "Modified: / 23-09-1996 / 14:24:50 / stefan"
    "Modified: / 10-01-1997 / 18:03:03 / cg"
    "Modified: / 19-09-2014 / 12:47:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeVMProcessIdConstants

    "/ for java locks, the VM may reserve some bits
    "/ and reduce the maximum processID to be able to
    "/ encode the id in an object's header field.
%{
#ifndef __SCHTEAM__
    @global(ProcessorScheduler:MinProcessId) = __MKSMALLINT(MIN_PROCESS_ID);
    @global(ProcessorScheduler:MaxProcessId) = __MKSMALLINT(MAX_PROCESS_ID);
    @global(ProcessorScheduler:SysProcessId) = __MKSMALLINT(SYS_PROCESS_ID);
    RETURN (self);
#endif /* not SCHTEAM */
%}.
    self primitiveFailed
! !

!ProcessorScheduler class methodsFor:'instance creation'!

new
    "there is (currently) only one processor ..."

    self error:'only one processor is allowed in the system'
! !

!ProcessorScheduler class methodsFor:'Signal constants'!

invalidProcessSignal
    ^ InvalidProcessSignal

    "Created: 23.9.1996 / 13:44:57 / stefan"
! !

!ProcessorScheduler class methodsFor:'instance release'!

update:something with:aParameter from:changedObject
    "some Process has been garbage collected
     - terminate the underlying thread.
     Usually this does not happen; instead, the process terminates itself
     by sending #terminate."

    |id sz "{ Class: SmallInteger }"|

    something == #ElementExpired ifTrue:[
	sz := KnownProcessIds size.
	1 to:sz do:[:index |
	    "/ (KnownProcesses at:index) isNil ifTrue:[
	    (KnownProcesses at:index) class == SmallInteger ifTrue:[
		id := KnownProcessIds at:index.
		id notNil ifTrue:[
		    'Processor [warning]: terminating thread ' errorPrint.
		    id errorPrint.
		    ' (no longer refd)' errorPrintCR.

		    self threadDestroy:id.
		    KnownProcessIds at:index put:nil.
		].
		KnownProcesses at:index put:nil.
	    ]
	]
    ]

    "Created: 7.1.1997 / 16:45:42 / stefan"
    "Modified: 10.1.1997 / 19:10:48 / cg"
! !

!ProcessorScheduler class methodsFor:'primitive process primitives'!

threadCreate:aProcess withId:id
    "physical creation of a process.
     (warning: low level entry, no administration done).
     This may raise an exception, if a VM process could not be created."

    MaxNumberOfProcesses notNil ifTrue:[
        KnownProcessIds size >= MaxNumberOfProcesses ifTrue:[
            (KnownProcessIds count:[:el | el notNil]) >= MaxNumberOfProcesses ifTrue:[
                "
                 the number of processes has reached the (soft) limit.
                 This limit prevents runaway programs from creating too many
                 processes. If you continue in the debugger, the process will be
                 created as usual. If you don't want this, abort or terminate.
                "
                self error:'too many processes'.
            ]
        ]
    ].

%{
    int tid;
    extern int __threadCreate();

    tid = __threadCreate(aProcess,
                         0   /* stackSize: no longer needed */,
                         __isSmallInteger(id) ? __intVal(id)     /* assign id */
                                              : -1              /* let VM assign one */  );
    if (tid) {
        RETURN ( __mkSmallInteger(tid));
    }
%}
.
    "
     arrive here, if creation of process in VM failed.
     This may happen, if the VM does not support more processes,
     or if it ran out of memory, when allocating internal data
     structures.
    "
    ^ AllocationFailure raise.
!

threadDestroy:id
    "physical destroy other process ...
     (warning: low level entry, no administration done)"

%{  /* NOCONTEXT */

    if (__isSmallInteger(id)) {
	__threadDestroy(__intVal(id));
    }
%}
!

threadInterrupt:id
    "make the process evaluate an interrupt. This sets a flag in the VMs
     threadSwitcher, to let the process perform a #interrupt when its set to
     run the next time. The process itself can decide how to react on this
     interrupt (currently, it looks for interruptBlocks to evaluate)."

%{  /* NOCONTEXT */

    if (__isSmallInteger(id)) {
	__threadInterrupt(__intVal(id));
    }
%}
!

threadsAvailable
    "return true, if the runtime system supports threads (i.e. processes);
     false otherwise."

%{  /* NOCONTEXT */
    RETURN (__threadsAvailable());
%}.
    ^ true
! !

!ProcessorScheduler class methodsFor:'queries'!

isPureEventDriven
    "this is temporary - (maybe not :-).
     you can run ST/X either with or without processes.
     Without, there is conceptionally a single process handling all
     outside events and timeouts. This has some negative implications
     (Debugger is ugly), but allows a fully portable ST/X without any
     assembler support - i.e. quick portability.
     The PureEvent flag will automatically be set if the runtime system
     does not support threads - otherwise, it can be set manually
     (from rc-file).
    "

    ^ PureEventDriven
!

knownProcesses
    "return a collection of all (living) processes in the system"

    ^ KnownProcesses select:[:p | p notNil and:[p class ~~ SmallInteger]]
!

knownProcessesDo:aBlock
    "evaluate aBlock for each (living) processes in the system"

    KnownProcesses do:[:p |
	(p notNil and:[p class ~~ SmallInteger]) ifTrue:[aBlock value:p]
    ]

    "Created: / 26-10-2012 / 13:02:33 / cg"
!

maxNumberOfProcesses
    "return the limit on the number of processes;
     the default is nil (i.e. unlimited)."

    ^ MaxNumberOfProcesses
!

maxNumberOfProcesses:aNumber
    "set the limit on the number of processes.
     This helps if you have a program which (by error) creates countless
     subprocesses. Without this limit, you may have a hard time to find
     this error (and repairing it). If nil (the default), the number of
     processes is unlimited."

    MaxNumberOfProcesses := aNumber
!

maxProcessId
    "Return a maximum allowed value of a Process id. "

    ^ MaxProcessId

    "Created: / 19-09-2014 / 12:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processDriven
    "turn on process driven mode"

    PureEventDriven := false
!

pureEventDriven
    "turn on pure-event driven mode - no processes, single dispatch loop"

    PureEventDriven := true
! !

!ProcessorScheduler methodsFor:'I/O event actions'!

enableIOAction:aBlock onInput:aFileDescriptor
    "obsolete event support: arrange for aBlock to be
     evaluated when input on aFileDescriptor arrives.
     This is a leftover support for pure-event systems and may vanish."

    |idx "{Class: SmallInteger }"
     wasBlocked|

    aFileDescriptor < 0 ifTrue:[
	'Processor [warning]: ignored invalid fd for IO action.' errorPrintCR.
	thisContext fullPrintAll.
	^ self
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    (readFdArray identityIndexOf:aFileDescriptor startingAt:1) == 0 ifTrue:[
	idx := readFdArray identityIndexOf:nil startingAt:1.
	idx ~~ 0 ifTrue:[
	    readFdArray at:idx put:aFileDescriptor.
	    readCheckArray at:idx put:aBlock.
	    readSemaphoreArray at:idx put:nil
	] ifFalse:[
	    readFdArray := readFdArray copyWith:aFileDescriptor.
	    readCheckArray := readCheckArray copyWith:aBlock.
	    readSemaphoreArray := readSemaphoreArray copyWith:nil.
	].
	useIOInterrupts ifTrue:[
	    OperatingSystem enableIOInterruptsOn:aFileDescriptor
	].

    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 4.8.1997 / 15:17:28 / cg"
! !

!ProcessorScheduler methodsFor:'accessing'!

activePriority
    "return the priority of the currently running process.
     GNU-ST & ST-80 compatibility; this is the same as currentPriority"

    ^ currentPriority
!

activeProcess
    "return the currently running process"

    ^ activeProcess

    "Processor activeProcess"
!

activeProcessId
    "return the currently running process's ID.
     The same as returned by 'Processor activeProcess id';
     added for to avoid another send in semaphores debugging support."

    ^ activeProcessId
!

currentPriority
    "return the priority of the currently running process"

    ^ currentPriority

    "Processor currentPriority"
!

exitWhenNoMoreUserProcesses:aBoolean
    "set/clear the flag, which controls if the scheduler should exit and return
     when the last user process finishes (and therefore exit the smalltalk system).
     A userProcess is defined as a process with a non-zero processGroup.
     This flag is typically set for standAlone operation, to terminate the (Unix-)
     process, when the last thread terminates."

    exitWhenNoMoreUserProcesses := aBoolean
!

interruptCounter
    "for statistics: counts the overall number of interrupts"

    ^ interruptCounter

    "
     Processor interruptCounter
    "
!

interruptedProcess
    "returns the process which was interrupted by the active one"

    ^ interruptedProcess
!

maxProcessId
    ^ self class maxProcessId

    "Created: / 19-09-2014 / 12:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scheduler
    "return the scheduling process"

    ^ scheduler
!

timedActionCounter
    "for statistics: counts the overall number of timer actions"

    ^ timedActionCounter

    "
     Processor timedActionCounter
    "
! !

!ProcessorScheduler methodsFor:'background processing'!

addIdleBlock:aBlock
    "add the argument, aBlock to the list of idle-actions.
     Idle blocks are evaluated whenever no other process is runnable,
     and no events are pending.
     Use of idle blocks is not recommended, use a low priority processes
     instead, which has the same effect. Idle blocks are still included
     to support background actions in pure-event systems, where no processes
     are available.
     ATTENTION: Support for idle-blocks may vanish."

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    idleActions isNil ifTrue:[
	idleActions := OrderedCollection new
    ].
    idleActions add:aBlock.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

removeIdleBlock:aBlock
    "remove the argument, aBlock from the list of idle-blocks.
     ATTENTION: Support for idle-blocks may vanish - use low prio processes instead."

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    idleActions notNil ifTrue:[
       idleActions removeIdentical:aBlock ifAbsent:nil
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 1.2.1997 / 12:09:46 / cg"
! !

!ProcessorScheduler methodsFor:'dispatching'!

dispatch
     "It handles timeouts and switches to the highest prio runnable process"

    |millis pri p nActions "{ Class: SmallInteger }"
     checkBlock sema wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    "
     handle all timeout actions
    "
    anyTimeouts ifTrue:[
        self evaluateTimeouts
    ].

    "first do a quick check for semaphores using checkActions - this is needed for
     devices like the X-connection, where some events might be in the event
     queue but the sockets input queue is empty.
     Without these checks, a select might block even though there is work to do.
     Also, this is needed for poor MSDOS, where WaitForObject does not work with
     sockets and pipes (sigh)
    "
    nActions := readCheckArray size.
    1 to:nActions do:[:index |
        checkBlock := readCheckArray at:index.
        (checkBlock notNil and:[checkBlock value]) ifTrue:[
            sema := readSemaphoreArray at:index.
            sema notNil ifTrue:[
                sema signalOnce.
            ].
        ]
    ].
    nActions := writeCheckArray size.
    1 to:nActions do:[:index |
        checkBlock := writeCheckArray at:index.
        (checkBlock notNil and:[checkBlock value]) ifTrue:[
            sema := writeSemaphoreArray at:index.
            sema notNil ifTrue:[
                sema signalOnce.
            ].
        ]
    ].

    "now, someone might be runnable ..."

    p := self highestPriorityRunnableProcess.
    p isNil ifTrue:[
        "/ no one runnable, hard wait for event or timeout
        "/ Trace ifTrue:['w' printCR.].
        self waitForEventOrTimeout.

        "/ check for OS process termination
        gotChildSignalInterrupt ifTrue:[
            gotChildSignalInterrupt := false.
            self handleChildSignalInterrupt
        ].
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
        ^ self
    ].

    pri := p priority.

    "
     want to give control to the process p.
     If the switched-to processes priority is lower than the
     userSchedulingPriority, we have to make certain, that the
     next input or timer will bring us back for a reschedule.
     This is done by enabling ioInterrupts for all file descriptors.
     If ioInterrupts are not available (OS does not support them),
     we schedule a timer interrupt to interrupt us after 1/20s of a second
     - effectively polling the filedescriptors 20 times a second.
     (which is bad, since low prio processes will be hurt in performance)
     Therefore, don't let benchmarks run with low prio ...

     Higher prio processes must be suspended,
     same prio ones must yield or suspend to get back control
    "

"
 uncommenting this will make timeouts interrupt the current process
 (i.e. as if the interrupt runs at TimingPrio);
 if left commented, they are handled at UserSchedulingPrio.
 this will all change, when timeouts are removed and all is process driven
 (a future version will have a process running to handle a timeout queue)
"

"
    pri < TimingPriority ifTrue:[
        anyTimeouts ifTrue:[
            millis := self timeToNextTimeout.
            millis == 0 ifTrue:[
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
                ^ self
            ]
        ]
    ].
"

    "
     if the process to run has a lower than UserInterruptPriority,
     arrange for an interrupt to occur on I/O.
     This is done by enabling IO-signals (if the OS supports them)
     or by installing a poll-interrupt after 50ms (if the OS does not).
    "
    pri < UserInterruptPriority ifTrue:[

"comment out this if above is uncommented"
        anyTimeouts ifTrue:[
            millis := self timeToNextTimeout.
            millis == 0 ifTrue:[
                wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
                ^ self
            ].
        ].
"---"

        useIOInterrupts ifTrue:[
"/            readFdArray do:[:fd |
"/                (fd notNil and:[fd >= 0]) ifTrue:[
"/                    OperatingSystem enableIOInterruptsOn:fd
"/                ].
"/            ].
        ] ifFalse:[
            millis notNil ifTrue:[
                millis := millis min:EventPollingInterval
            ] ifFalse:[
                millis := EventPollingInterval
            ]
        ]
    ].

    millis notNil ifTrue:[
        "/ Trace ifTrue:['C' print. millis printCR.].
        "schedule a clock interrupt after millis milliseconds"
        OperatingSystem enableTimer:millis rounded.
    ].

    scheduledProcesses notNil ifTrue:[
        scheduledProcesses add:p
    ].

    "
     now let the process run - will come back here by reschedule
     from ioInterrupt, scheduler or timerInterrupt ... (running at max+1)
    "
    "/ Trace ifTrue:['->' print. p printCR.].
    self threadSwitch:p.
    "/ Trace ifTrue:['<-' printCR.].

    "... when we arrive here, we are back on stage.
         Either by an ALARM or IO signal, or by a suspend of another process
    "

    millis notNil ifTrue:[
        OperatingSystem disableTimer.
    ].

    "/ check for OS process termination
    gotChildSignalInterrupt ifTrue:[
        gotChildSignalInterrupt := false.
        self handleChildSignalInterrupt
    ].

    "/ check for new input

    OperatingSystem unblockInterrupts.

    (gotIOInterrupt or:[useIOInterrupts not]) ifTrue:[
        gotIOInterrupt := false.
        self checkForIOWithTimeout:0.
    ].

    wasBlocked ifTrue:[OperatingSystem blockInterrupts].

    "Modified: / 12.4.1996 / 10:14:18 / stefan"
    "Modified: / 3.8.1998 / 21:54:01 / cg"
!

dispatchLoop
    "central dispatch loop; the scheduler process is always staying in
     this method, looping forever."

    |dispatchAction handlerAction ignoredSignals|

    "avoid confusion if entered twice"

    dispatching == true ifTrue:[
        'Processor [info]: already in dispatch' infoPrintCR.
        ^ self
    ].
    dispatching := true.

    "/ create the relevant blocks & signalSet outside of the
    "/ while-loop
    "/ (thanks to stefans objectAllocation monitor,
    "/  this safes a bit of memory allocation in the scheduler)

    dispatchAction := 
        [ 
            [dispatching] whileTrue:[ 
                self dispatch 
            ] 
        ].

    handlerAction := 
        [:ex |
            (HaltInterrupt accepts:ex creator) ifTrue:[
                "/ in a standalone application, we do not want those
                (Smalltalk isStandAloneApp and:[Smalltalk isStandAloneDebug not]) ifTrue:[
                    ('Processor [info]: ignored (', ex creator printString, ')') infoPrintCR.
                    ex proceed.
                ].
                "/ MiniDebugger enter. -- should this be done when some --debug/--verbose was given?
                ex proceed.
            ].

            ('Processor [info]: caught (and ignored) signal (', ex creator printString, ')') infoPrintCR.
            ex return
         ].

    ignoredSignals := SignalSet
                        with:HaltInterrupt
                        with:TerminateProcessRequest
                        with:RecursionError
                        with:AbortAllOperationRequest.

    "/
    "/ I made this an extra call to dispatch; this allows recompilation
    "/  of the dispatch-handling code in the running system.
    "/
    [dispatching] whileTrue:[
        ignoredSignals 
            handle:handlerAction 
            do:dispatchAction
    ].

    "/ we arrive here in standalone Apps,
    "/ when the last process at or above UserSchedulingPriority process died.
    "/ regular ST/X stays in above loop forever

    'Processor [info]: finish dispatch (no more processes)' infoPrintCR.

    "Modified: / 23-09-1996 / 14:19:56 / stefan"
    "Modified: / 20-07-2012 / 18:34:48 / cg"
! !

!ProcessorScheduler methodsFor:'initialization'!

initialize
    "initialize the one-and-only ProcessorScheduler"

    |nPrios "{ Class: SmallInteger }"
     p l|

    KnownProcesses isNil ifTrue:[
	KnownProcesses := WeakArray new:30.
	KnownProcesses addDependent:self class.
	KnownProcessIds := OrderedCollection new:30.
    ].

    "
     create a collection with process lists; accessed using the priority as key
    "
    nPrios := SchedulingPriority.
    quiescentProcessLists := Array new:nPrios.

    readFdArray := Array new:5.
    readCheckArray := Array new:5.
    readSemaphoreArray := Array new:5.
    writeFdArray := Array new:3.
    writeCheckArray := Array new:3.
    writeSemaphoreArray := Array new:3.
    exceptFdArray := Array new:3.
    exceptSemaphoreArray := Array new:3.

    timeoutArray := Array new:5.
    timeoutSemaphoreArray := Array new:5.
    timeoutActionArray := Array new:5.
    timeoutProcessArray := Array new:5.

    anyTimeouts := false.
    dispatching := false.
    useIOInterrupts := OperatingSystem supportsIOInterrupts.
    gotIOInterrupt := false.
    osChildExitActions := Dictionary new.
    gotChildSignalInterrupt := false.
    interruptCounter := timedActionCounter := 0.

    supportDynamicPriorities := false.
    exitWhenNoMoreUserProcesses isNil ifTrue:[
	exitWhenNoMoreUserProcesses := false. "/ mhmh - how about true ?
    ].

    "
     handcraft the first (dispatcher-) process - this one will never
     block, but go into a select if there is nothing to do.
     Also, it has a prio of max+1 - thus, it comes first when looking
     for a runnable process.
    "
    currentPriority := SchedulingPriority.
    p := Process basicNew.
    p
	setId:SysProcessId state:#run;
	setPriority:currentPriority;
	name:'scheduler';
	beSystemProcess.	

    scheduler := activeProcess := p.
    activeProcessId := SysProcessId.    

    quiescentProcessLists at:currentPriority put:(l := LinkedList new).
    l add:p.

    "
     let me handle IO and timer interrupts
    "
    useIOInterrupts ifTrue:[ObjectMemory ioInterruptHandler:self].
    ObjectMemory
	timerInterruptHandler:self;
	childSignalInterruptHandler:self.

    "Modified: / 7.1.1997 / 16:48:26 / stefan"
    "Modified: / 4.2.1999 / 13:08:39 / cg"
!

reinitialize
    "all previous processes (except those marked as restartable) are made dead
     - each object should reinstall its process(s) upon restart;
     especially, windowgroups have to.
     In contrast to ST-80, restartable processes are restarted at the beginning
     NOT continued where left. This is a consequence of the portable implementation
     of ST/X, since in order to continue a process, we needed to know the
     internals of the machines (and C-compilers) stack layout.
     This was not done, favouring portability for process continuation.
     In praxis, this is not much of a problem, since in almost every case,
     the computation state can be saved in some object, and processing be
     restarted from scratch, reinitializing things from this saved state."

    |processesToRestart|

    "
     lay all processes to rest, collect restartable ones
    "
    processesToRestart := OrderedCollection new.
    KnownProcesses do:[:p |
	(p notNil and:[p class ~~ SmallInteger]) ifTrue:[
	    "how, exactly should this be done ?"

	    p isRestartable == true ifTrue:[
		p nextLink:nil.
		processesToRestart add:p
	    ] ifFalse:[
		p setId:nil state:#dead
	    ]
	].
    ].
    scheduler setId:nil state:#dead.

    "
     now, start from scratch
    "
    KnownProcesses := nil.
    self initialize.

    processesToRestart do:[:p |
	p imageRestart
    ]

    "Modified: / 7.6.1998 / 02:23:56 / cg"
! !

!ProcessorScheduler methodsFor:'native thread support'!

vmResumeInterrupt:id
    "signal from VM to resume a thread after finish of an osWait or wrapCall-wait.
     MUST be invoked with interrupts blocked.
     This is only used with native threads."

    <context: #return>

    |index pri aProcess l|

    OperatingSystem interruptsBlocked ifFalse:[
	MiniDebugger
	    enterWithMessage:'vmResumeInterrupt with no interruptsBlocked'
	    mayProceed:true.
    ].

    index := KnownProcessIds identityIndexOf:id.
    index ~~ 0 ifTrue:[
	aProcess := KnownProcesses at:index.
	pri := aProcess priority.
	l := quiescentProcessLists at:pri.
	l notNil ifTrue:[
	    (l includesIdentical:aProcess) ifTrue:[
		"/ aProcess is on a run queue.
		"/ CG: this situation may happen, if the wrapCall
		"/ finishes before the process was layed to sleep
		"/ (i.e. schedulerIRQ arrives before the threadSwitch was finished).
		"/ In that case, simply resume it and everything is OK.
		"/ If the process is state running, ignore.

		|state|

		state := aProcess state.
		(state == #wrapWait or:[(state == #osWait) or:[state == #stopped]]) ifTrue:[
		    aProcess state:#run.
		].
		'ProcSched [info]: resumeIRQ ignored for process: ' infoPrint.
		aProcess id infoPrint. ' in state: ' infoPrint. state infoPrintCR.
		^ self
	    ]
	] ifFalse:[
	    l := LinkedList new.
	    quiescentProcessLists at:pri put:l.
	].
	l addLast:aProcess.
	aProcess state:#run.
    ] ifFalse:[
	'ProcSched [info]: resumeIRQ for unknown process: ' infoPrint.
	id infoPrintCR.
    ]

    "Modified: / 28.9.1998 / 11:36:53 / cg"
!

vmSuspendInterrupt:whyCode
    "signal from VM to suspend a thread into a certain state.
     Invoked before the VM switches to the scheduler process.
     MUST be invoked with interrupts blocked.
     This is only used with native threads."

    <context: #return>

    |pri l newState|

    OperatingSystem interruptsBlocked ifFalse:[
	MiniDebugger
	    enterWithMessage:'immediateInterrupt with no interruptsBlocked'
	    mayProceed:true.
    ].

    (whyCode == 2) ifTrue:[
	 newState := #wrapWait.
    ] ifFalse:[
	(whyCode == 3) ifTrue:[
	    newState := #osWait.
	] ifFalse:[
	    newState := #stopped.
	].
    ].
    activeProcess setStateTo:newState if:#active.

    pri := activeProcess priority.
    l := quiescentProcessLists at:pri.

    "notice: this is slightly faster than putting the if-code into
     the ifAbsent block, because [] is a shared cheap block, created at compile time
    "
    (l isNil or:[(l removeIdentical:activeProcess ifAbsent:nil) isNil]) ifTrue:[
	"/ 'Processor [warning]: bad vmSuspendInterrupt: not on run list' errorPrintCR.
	MiniDebugger enterWithMessage:'bad vmSuspendInterrupt: not on run list' mayProceed:true.
	^ self
    ].
! !

!ProcessorScheduler methodsFor:'os process handling'!

childSignalInterrupt
    "{ Pragma: +returnable }"

    "child changed state - switch to scheduler process which will decide
     what to do now."

    gotChildSignalInterrupt := true.
    interruptCounter := interruptCounter + 1 bitAnd:SmallInteger maxVal.
    activeProcess ~~ scheduler ifTrue:[
	interruptCounter := interruptCounter + 1 bitAnd:SmallInteger maxVal.
	interruptedProcess := activeProcess.
	self threadSwitch:scheduler
    ]

    "Modified: 12.4.1996 / 10:12:18 / stefan"
!

handleChildSignalInterrupt
    "child changed state - execute child termination blocks.
     If child is no longer alive, remove action block."

    |osProcessStatus blocking wasBlocked|

    blocking := OperatingSystem isChildProcessWaitBlocking.

    "/ no interrupt processing, to avoid races with monitorPid
    wasBlocked := OperatingSystem blockInterrupts.
    [
	[
	    osProcessStatus := OperatingSystem childProcessWait:blocking pid:nil.
	    osProcessStatus notNil ifTrue:[
		|pid action|

		pid := osProcessStatus pid.
		osProcessStatus stillAlive ifTrue:[
		    action := osChildExitActions at:pid ifAbsent:nil.
		] ifFalse:[
		    action := osChildExitActions removeKey:pid ifAbsent:nil.
		].
		action notNil ifTrue:[
		    action value:osProcessStatus
		].
	    ].

	    "/ if pollChildProcesses does block, poll only one status change.
	    "/ we will get another SIGCHLD for other status changes.

	    osProcessStatus notNil and:[blocking not]
	] whileTrue.

	"/ if there are no more waiters, disable SIGCHILD handler.
	"/ this helps us with synchronous waiters (e.g. pclose),
	"/ But they should block SIGCHLD anyway.

	osChildExitActions isEmpty ifTrue:[
	    OperatingSystem disableChildSignalInterrupts.
	].
    ] ensure:[
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ]

    "Modified: 5.1.1996 / 16:56:11 / stefan"
    "Modified: 28.2.1996 / 21:36:31 / cg"
    "Created: 12.4.1996 / 10:08:21 / stefan"
!

monitor:aBlockReturningPid action:actionBlock
    "Helper for executing and waiting for OS processes.
     aBlockReturningPid is evaluated and supposed to return
     the process-id of an OS-process or nil.
     To avoid race conditions, the OS-process must be started
     within the block.
     ActionBlock will be called with an OSProcessStatus as arg if the
     status of the OS process changes (e.g. the process terminates).
     The method returns the value from aBlockReturningPid (i.e. a pid or nil)."

    |pid wasBlocked|

    "/ aBlock will be evaluated:
    "/   on unix: as soon as a SIGCHLD interrupt for pid has been received.
    "/   on win:  as soon as a select for the pid handle returns

    OperatingSystem enableChildSignalInterrupts.        "/ no-op in windows
    wasBlocked := OperatingSystem blockInterrupts.
    "/ start the OS-Process
    pid := aBlockReturningPid value.
    pid notNil ifTrue:[
	osChildExitActions at:pid put:actionBlock.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ pid

    "Created: / 25.3.1997 / 10:54:56 / stefan"
    "Modified: / 25.3.1997 / 11:21:05 / stefan"
    "Modified: / 15.4.1997 / 11:55:57 / David"
    "Modified: / 27.4.1999 / 20:09:38 / cg"
!

unmonitorPid:pid
    "remove a monitor for a child process"

    osChildExitActions removeKey:pid ifAbsent:nil.

    "Created: 12.4.1996 / 19:01:59 / cg"
! !

!ProcessorScheduler methodsFor:'primitive process primitives'!

scheduleForInterrupt:aProcess
    "make aProcess evaluate its pushed interrupt block(s)"

    self scheduleInterruptActionsOf:aProcess.
    aProcess state ~~ #stopped ifTrue:[
	"
	 make the process runnable
	"
	self resume:aProcess
    ]

    "Modified: / 24.8.1998 / 18:31:32 / cg"
!

scheduleInterruptActionsOf:aProcess
    "make aProcess evaluate its pushed interrupt block(s)
     when resumed."

    |id|

    aProcess isNil ifTrue:[^ self].
    aProcess == activeProcess ifTrue:[^ self].

    id := aProcess id.
    self class threadInterrupt:id.

    "Created: 5.3.1996 / 17:25:55 / cg"
!

threadSwitch:aProcess
    "continue execution in aProcess.
     WARNING: this is a low level entry, no process administration is done here"

    |id pri ok oldProcess oldPri oldId p nm singleStep wasBlocked|

    (aProcess isNil or:[aProcess == activeProcess]) ifTrue:[^ self].

    wasBlocked := OperatingSystem blockInterrupts.

    oldProcess := activeProcess.
    oldId := activeProcessId.
    oldPri := currentPriority.

    id := aProcess id.
    pri := aProcess priority.
    singleStep := aProcess isSingleStepping.
    aProcess state:#active.
    oldProcess setStateTo:#run if:#active.

    currentPriority := pri.
    activeProcess := aProcess.
    activeProcessId := id.

    "
     no interrupts now - activeProcess has already been changed
     (don't add any message sends here)
    "
"/    ok := self threadSwitchFrom:oldProcess to:aProcess id:id singleStep:singleStep.
%{
    extern OBJ ___threadSwitch();

    if (__isSmallInteger(id)) {
        ok = ___threadSwitch(__context, __intVal(id), (singleStep == true) ? 1 : 0, 0);
    } else {
        ok = false;
    }
%}.

    "time passes spent in some other process ...
     ... here again"

    p := activeProcess.
    activeProcess := oldProcess.
    activeProcessId := oldId.
    currentPriority := oldProcess priority.

    ok ~~ true ifTrue:[
        "
         switch failed for some reason -
         destroy (hard-terminate) the bad process.
         This happens when:
         - the stack went above the absolute limit
           (VM switches back to scheduler)
         - a halted process cannot execute its interrupt
           actions (win32 only)
        "
        id := p id.
        (id ~~ SysProcessId and:[id notNil]) ifTrue:[
            'Processor [warning]: problem with process ' errorPrint.
            id errorPrint.
            (nm := p name) notNil ifTrue:[
                ' (' errorPrint. nm errorPrint. ')' errorPrint.
            ].

            ok == #halted ifTrue:[
                "/ that process was halted (win32 only)
                p state:#halted.
               '; stopped it.' errorPrintCR.
               self suspend:p.
            ] ifFalse:[
               '; hard-terminate it.' errorPrintCR.
               'Processor [info]: cleanup may take a while if stack is huge' infoPrintCR.
               p state:#cleanup.
               self terminateNoSignal:p.
            ]
        ]
    ].
    zombie notNil ifTrue:[
        "delayed processing of terminated process (see #terminateNoSignal)"
        self class threadDestroy:zombie.
        zombie := nil
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: / 23-07-2010 / 10:32:11 / cg"
    "Modified (format): / 24-01-2017 / 17:50:12 / stefan"
! !

!ProcessorScheduler methodsFor:'priority constants'!

highIOPriority
    "not currently used - for ST80 compatibility only"

    ^ 16 "claus: is this ok ?"

    "Created: 15.11.1996 / 11:42:39 / cg"
!

highestPriority
    "return the highest priority value (normal) processes can have."

    "must be below schedulingPriority -
     otherwise scheduler could be blocked ...
    "
    ^ HighestPriority
!

lowIOPriority
    "not currently used - for ST80 compatibility only"

    ^ 2 "claus: is this ok ?"
!

lowestPriority
    "return the lowest priority value"

    ^ 1   "do not change this - its not variable"
!

schedulingPriority
    "return the priority at which the scheduler runs."

    "must be above highestPriority -
     otherwise scheduler could be blocked ...
    "
    ^ SchedulingPriority
!

systemBackgroundPriority
    "return the priority, at which background system processing
     should take place."

    ^ 4

    "
     Processor systemBackgroundPriority
    "
!

timeSlicingPriorityLimit
    "return the priority, above which no timeslicing takes place
     (i.e. processes running at a higher priority are not preempted).
     This is only effective, if preemption is enabled."

    ^ TimeSlicingPriorityLimit
!

timingPriority
    "return the priority, at which all timing takes place (messageTally,
     delay etc.)"

    ^ TimingPriority
!

userBackgroundPriority
    "return the priority, at which background user (non-interactive) processing
     should take place."

    ^ 6

    "
     Processor userBackgroundPriority
    "
!

userInterruptPriority
    "return the priority, at which the event scheduler runs - i.e.
     all processes running at a lower priority are interruptable by Cntl-C
     or the timer. Processes running at higher prio will not be interrupted."

    ^ UserInterruptPriority
!

userSchedulingPriority
    "return the priority, at which all normal user (interactive) processing
     takes place"

    ^ UserSchedulingPriority
! !

!ProcessorScheduler methodsFor:'private'!

remember:aProcess
    "remember aProcess for later disposal (where the underlying
     system resources have to be freed)."

    |newShadow oldId wasBlocked
     oldSize "{ Class: SmallInteger }"
     index   "{ Class: SmallInteger }"
     sz      "{ Class: SmallInteger }" |

    wasBlocked := OperatingSystem blockInterrupts.
    index := 1.
    sz := KnownProcessIds size.
    [index <= sz] whileTrue:[
	(KnownProcesses at:index) isNil ifTrue:[
	    oldId := KnownProcessIds at:index.
	    oldId notNil ifTrue:[
		self class threadDestroy:oldId.
	    ].
	    KnownProcesses at:index put:aProcess.
	    KnownProcessIds at:index put:aProcess id.
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	    ^ self
	].
	index := index + 1
    ].

    KnownProcessIds grow:index.
    KnownProcessIds at:index put:aProcess id.

    oldSize := KnownProcesses size.
    (index > oldSize) ifTrue:[
	newShadow := WeakArray new:(oldSize * 2).
	newShadow addDependent:self class.
	newShadow replaceFrom:1 with:KnownProcesses.
	KnownProcesses := newShadow
    ].
    KnownProcesses at:index put:aProcess.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 7.1.1997 / 16:48:39 / stefan"
!

unRemember:aProcess
    "forget aProcess - dispose processing will not consider this one"

    |index wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    index := KnownProcesses identityIndexOf:aProcess.
    index ~~ 0 ifTrue:[
	KnownProcessIds at:index put:nil.
	KnownProcesses at:index put:nil.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
! !

!ProcessorScheduler methodsFor:'process creation'!

newProcessFor:aProcess
    "create a physical (VM-) process for aProcess.
     Return true if ok, false if something went wrong.
     The process is not scheduled; to start it running,
     it needs a Process>>resume. Once resumed, the process will later
     get control in its #start method."

    |id|

    id := self class threadCreate:aProcess withId:nil.
    aProcess setId:id state:#light.   "meaning: has no stack yet"
    self remember:aProcess.
!

newProcessFor:aProcess withId:idWant
    "private entry for Process restart - do not use in your program"

    idWant isNil ifTrue:[
	self newProcessFor:aProcess.
	^ true.
    ].

    (self class threadCreate:aProcess withId:idWant) ~~ idWant ifTrue:[
	^ false
    ].

    aProcess state:#light.   "meaning: has no stack yet"
    self remember:aProcess.
    ^ true

    "Modified: 28.10.1996 / 19:14:28 / cg"
! !

!ProcessorScheduler methodsFor:'queries'!

activeProcessIsSystemProcess
    "return true if the active process is a system process,
     which should not be suspended."

    ^ activeProcess isSystemProcess

    "
     Processor activeProcessIsSystemProcess
    "

    "Modified: 17.4.1997 / 12:59:33 / stefan"
!

anyScheduledWindowGroupAtAll
    "return true, if there is any window group with active topviews.
     This is used to determine if we should stop scheduling
     in standAlone applications."

    Screen notNil ifTrue:[
        Screen allScreens notEmptyOrNil ifTrue:[
            WindowGroup scheduledWindowGroups notEmptyOrNil ifTrue:[^ true]. 
        ].
    ].
    ^ false

    "
     Processor anyScheduledWindowGroupAtAll
    "
!

anyUserProcessAtAll
    "return true, if there is any user process still running,
     or waiting on a semaphore.
     This is used to determine if we should stop scheduling
     in standAlone applications.
     A user process has a non-zero processGroup.
     Should be called with interrupts blocked."

    |listArray l prio "{ Class: SmallInteger }"|

    prio := HighestPriority.

    listArray := quiescentProcessLists.

    [prio >= 1] whileTrue:[
        l := listArray at:prio.
        l notNil ifTrue:[
            l linksDo:[:aProcess |
                aProcess isUserProcess ifTrue:[
                    "/ 'anyUserProcess: found quiescent ' _errorPrint. aProcess asString _errorPrintCR.
                    ^ true.
                ]
            ]
        ].
        prio := prio - 1
    ].

    (scheduledProcesses notNil 
    and:[scheduledProcesses contains:[:p | p notNil and:[p isUserProcess and:[p state ~~ #dead]] ]]) ifTrue:[
       "/ 'anyUserProcess: found scheduled ' _errorPrint. 
       "/ (scheduledProcesses detect:[:p | p notNil and:[p isUserProcess and:[p state ~~ #dead]] ]) asString _errorPrintCR.
        ^ true.
    ].    
        
    "/ any user process waiting on a sema?
    (readSemaphoreArray contains:[:sema |
        sema notNil and:[sema waitingProcesses contains:[:p | p notNil and:[p isUserProcess and:[p state ~~ #dead]] ]]]
    ) ifTrue:[
       "/ 'anyUserProcess: found on read sema' _errorPrintCR.
        ^ true.
    ].
    (writeSemaphoreArray contains:[:sema |
        sema notNil and:[sema waitingProcesses contains:[:p | p notNil and:[p isUserProcess and:[p state ~~ #dead]] ]]]
    ) ifTrue:[
       "/ 'anyUserProcess: found on write sema' _errorPrintCR.
        ^ true.
    ].
    (timeoutSemaphoreArray contains:[:sema |
        sema notNil and:[sema waitingProcesses contains:[:p | p notNil and:[p isUserProcess and:[p state ~~ #dead]] ]]]
    ) ifTrue:[
       "/ 'anyUserProcess: found on timeout sema' _errorPrintCR.
        ^ true.
    ].
    (timeoutProcessArray contains:[:p | p notNil and:[p isUserProcess] ]
    ) ifTrue:[
        ^ true.
    ].

    ^ false

    "
     Processor anyUserProcessAtAll
    "

    "Modified: 29.7.1996 / 11:49:17 / cg"
!

highestPriorityRunnableProcess
    "return the highest prio runnable process"

    |listArray l p prio "{ Class: SmallInteger }"
     wasBlocked|

    prio := HighestPriority.
    wasBlocked := OperatingSystem blockInterrupts.

    listArray := quiescentProcessLists.
    [prio >= 1] whileTrue:[
	l := listArray at:prio.
	l notNil ifTrue:[
	    l notEmpty ifTrue:[
		p := l firstLink.
		"
		 if it got corrupted somehow ...
		"
		p isDead ifTrue:[
		    'Processor [warning]: dead process removed' errorPrintCR.
		    l removeFirst.
		    p := nil.
		].
		wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
		^ p
	    ]
	].
	prio := prio - 1
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ nil

    "Modified: 12.2.1997 / 12:41:49 / cg"
!

isDispatching
    ^ dispatching
!

isPureEventDriven
    "this is temporary - (maybe not :-).
     you can run ST/X either with or without processes.
     Without, there is conceptionally a single process handling all
     outside events and timeouts. This has some negative implications
     (Debugger is ugly), but allows a fully portable ST/X without any
     assembler support - i.e. quick portability.
     The PureEvent flag will automatically be set if the runtime system
     does not support threads - otherwise, it can be set manually
     (from rc-file).
    "

    ^ PureEventDriven

    "Created: 13.4.1996 / 20:31:31 / cg"
!

isTimeSlicing
    "return true, if in timeslicing mode"

    ^ timeSliceProcess notNil

    "
     Processor isTimeSlicing
    "

    "Modified: 17.1.1997 / 17:48:41 / cg"
!

processWithId:anInteger
    "answer the process with id anInteger, or nil if there is none"

    |wasBlocked slot process|

    wasBlocked := OperatingSystem blockInterrupts.

    slot := KnownProcessIds indexOf:anInteger.
    slot ~~ 0 ifTrue:[
	process := KnownProcesses at:slot ifAbsent:[].
    ].

    wasBlocked ifFalse:[
	OperatingSystem unblockInterrupts.
    ].

    "Take care, the process may already have been collected"
    process == 0 ifTrue:[
	^ nil.
    ].
    ^ process.

    "
	Processor processWithId:4
	Processor processWithId:4711
    "
!

processesWithGroupId:anInteger
    "answer a collection of processes with processGroupId, anInteger"

    |wasBlocked coll|

    coll := OrderedCollection new.

    wasBlocked := OperatingSystem blockInterrupts.
    KnownProcesses validElementsDo:[:eachProcess| 
        eachProcess processGroupId = anInteger ifTrue:[
            coll add:eachProcess.
        ].
    ].

    wasBlocked ifFalse:[
        OperatingSystem unblockInterrupts.
    ].

    ^ coll.

    "
        Processor processesWithGroupId:0
        Processor processesWithGroupId:4711
    "
! !

!ProcessorScheduler methodsFor:'scheduling'!

changePriority:prio for:aProcess
    "change the priority of aProcess"

    |oldList newList oldPrio newPrio wasBlocked|

    oldPrio := aProcess priority.
    oldPrio == prio ifTrue:[^ self].
    aProcess == scheduler ifTrue:[^ self].

    "
     check for valid argument
    "
    newPrio := prio.
    newPrio < 1 ifTrue:[
	newPrio := 1.
    ] ifFalse:[
	newPrio > HighestPriority ifTrue:[
	    newPrio := HighestPriority
	]
    ].

    [
	wasBlocked := OperatingSystem blockInterrupts.

	aProcess setPriority:newPrio.

	oldList := quiescentProcessLists at:oldPrio.
	oldList notNil ifTrue:[
	    (oldList removeIdentical:aProcess ifAbsent:nil) notNil ifTrue:[
		newList := quiescentProcessLists at:newPrio.
		newList isNil ifTrue:[
		    quiescentProcessLists at:newPrio put:(newList := LinkedList new).
		].
		newList addLast:aProcess.

		"if its the current process lowering its prio
		 or another one raising, we have to reschedule"

		aProcess == activeProcess ifTrue:[
		    currentPriority := newPrio.
		    newPrio < oldPrio ifTrue:[
			self threadSwitch:scheduler.
		    ]
		] ifFalse:[
		    newPrio > currentPriority ifTrue:[
			self threadSwitch:aProcess.
		    ]
		].
		timeSliceNeededSemaphore notNil ifTrue:[
		    "/ tell timeslicer, that some work might be needed...
		    timeSliceNeededSemaphore signalIf.
		]
	    ]
	]
    ] ensure:[
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ]

    "Modified: / 4.8.1998 / 00:08:54 / cg"
!

interruptActive
    "interrupt the current process
     - this message is sent by the VM, when a process is about to be switched to,
     and that process has the interrupted flag bit set.
     Pass the interrupt to the process, which may do whatever it likes with it."

    <context: #return>

    |s|

    "/ hide those intermediate scheduler contexts;
    "/ the interrupt block should think it was called right
    "/ from the originally interrupted context

    s := thisContext sender.
    s selector == #threadSwitchFrom:to:id:singleStep: ifTrue:[
	s := s sender.
	s selector == #threadSwitch: ifTrue:[
	    s := s sender.
	    s selector == #timerInterrupt ifTrue:[
		s := s sender
	    ]
	]
    ].

    "/ the returned value here has a subtle effect:
    "/ if false, the interrupt is assumed to be not taken,
    "/ and will be redelivered.
    ^ activeProcess interruptedIn:s

    "Modified: 20.10.1996 / 17:06:48 / cg"
!

makeRunnable:aProcess
    "set aProcess runnable - but do not reschedule.
     Answer true, if a reschedule is required, false if not."

    |l s pri wasBlocked|

    "ignore, if process is already dead"
    (aProcess isNil or:[aProcess isDead]) ifTrue:[^ false].

    s := aProcess state.
    s == #osWait ifTrue:[
	'Processor [warning]: bad resume: #osWait' errorPrintCR.
	"/ MiniDebugger enterWithMessage:'bad resume: state osWait'.
	^ false.
    ].
    s == #stopped ifTrue:[
	"by definition, stopped processes cannot be resumed"
	^ false.
    ].

    aProcess == activeProcess ifTrue:[
	"special handling for waiting schedulers"
	aProcess == scheduler ifTrue:[
	    suspendScheduler := false.
	].
	^ false
    ].

    wasBlocked := OperatingSystem blockInterrupts.

    pri := aProcess priority.

    l := quiescentProcessLists at:pri.
    "if already running, ignore"
    l notNil ifTrue:[
	(l identityIndexOf:aProcess) ~~ 0 ifTrue:[
	    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	    ^ false
	]
    ] ifFalse:[
	l := LinkedList new.
	quiescentProcessLists at:pri put:l.
    ].
    l addLast:aProcess.
    aProcess state:#run.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    pri > currentPriority ifTrue:[
	"must reschedule"
	^ true.
    ].

    timeSliceNeededSemaphore notNil ifTrue:[
	"/ tell timeslicer, that some work might be needed...
	timeSliceNeededSemaphore signalIf.
    ].
    ^ false.

    "Modified: / 29.7.1996 / 12:07:37 / cg"
    "Created: / 4.2.1998 / 20:58:28 / cg"
!

processTermination
    "sent by VM if the current process finished its startup block
     without proper process termination. Lay him to rest now.
     This can only happen, if something went wrong in Block>>newProcess,
     since the block defined there always terminates itself."

    self terminateNoSignal:activeProcess.
    self threadSwitch:scheduler
!

reschedule
    "switch to the highest prio runnable process.
     The scheduler itself is always runnable, so we can do an unconditional switch
     to that one. This method is provided as a hook for primitive C code,
     to allow giving up the CPU."

    ^ self threadSwitch:scheduler
!

resume:aProcess
    "set aProcess runnable -
     if its prio is higher than the currently running prio, switch to it."

    (self makeRunnable:aProcess) ifTrue:[
	"aProcess prio is higher; immediately transfer control to it"
	self threadSwitch:aProcess.
    ].
!

resumeForSingleSend:aProcess
    "like resume, but let the process execute a single send only.
     This will be used by the debugger for single stepping."

    (aProcess isNil or:[aProcess == activeProcess]) ifTrue:[^ self].
    aProcess singleStep:true.
    self resume:aProcess

    "Modified: / 3.2.1998 / 01:08:08 / stefan"
!

suspend:aProcess
    "remove the argument, aProcess from the list of runnable processes.
     If the process is the current one, reschedule.

     Notice:
         This method should only be called by Process>>suspend or
         Process>>suspendWithState:"

    |pri l p wasBlocked|

    "
     some debugging stuff
    "
    aProcess isNil ifTrue:[
        InvalidProcessSignal raiseRequestWith:aProcess errorString:'nil suspend'.
        ^ self
    ].
    aProcess isDead ifTrue:[
        InvalidProcessSignal raiseRequestWith:aProcess errorString:'bad suspend: already dead'.
        self threadSwitch:scheduler.
        ^ self
    ].
    aProcess == scheduler ifTrue:[
        "only the scheduler may suspend itself"
        activeProcess == scheduler ifTrue:[
            suspendScheduler := true.
            [suspendScheduler] whileTrue:[
                self dispatch.
            ].
            ^ self
        ].

        InvalidProcessSignal raiseRequestWith:aProcess errorString:'attempt to suspend scheduler'.
        ^ self
    ].

    (aProcess == activeProcess) ifTrue:[
        "this is a no-op if the process has no interrupt actions"
        aProcess interrupt.
    ].

    wasBlocked := OperatingSystem blockInterrupts.

    pri := aProcess priority.
    l := quiescentProcessLists at:pri.

    "notice: this is slightly faster than putting the if-code into
     the ifAbsent block, because [] is a shared cheap block, created at compile time
    "
    (l isNil or:[(l removeIdentical:aProcess ifAbsent:nil) isNil]) ifTrue:[
        "/ 'Processor [warning]: bad suspend: process is not running' errorPrintCR.
        "/ MiniDebugger enterWithMessage:'bad suspend: process is not running'.
        aProcess == activeProcess ifTrue:[
            self threadSwitch:scheduler.
        ].
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
        ^ self
    ].

    (aProcess == activeProcess) ifTrue:[
        "we can immediately switch sometimes"
        l isEmpty ifTrue:[
            p := scheduler
        ] ifFalse:[
            p := l firstLink
        ].
        self threadSwitch:p
    ].

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: / 23.9.1996 / 13:49:24 / stefan"
    "Modified: / 27.7.1998 / 23:34:59 / cg"
!

terminate:aProcess
    "terminate aProcess. This is done by sending aProcess the terminateSignal,
     which will evaluate any unwind blocks and finally do a hard terminate."

    aProcess terminate
!

terminateActive
    "terminate the current process (i.e. the running process kills itself).
     The active process is sent the terminateSignal so it will evaluate any
     unwind blocks and finally do a hard terminate.
     This is sent for regular termination and by the VM, if the hard-stack limit
     is reached. (i.e. a process did not repair things in a recursionInterrupt and
     continued to grow its stack)"

    activeProcess terminate
!

terminateActiveNoSignal
    "hard terminate the active process, without sending any
     terminate signal thus no unwind blocks are evaluated."

    self terminateNoSignal:activeProcess
!

terminateNoSignal:aProcess
    "hard terminate aProcess without sending the terminate signal, thus
     no unwind blocks or exitAction are performed in the process..
     If it's not the current process, it is simply removed from its list
     and physically destroyed. Otherwise (since we can't take away the chair
     we are sitting on), a switch is forced and the process
     will be physically destroyed by the next running process.
     (see zombie handling)"

    |pri id l wasBlocked|

    aProcess isNil ifTrue:[^ self].

    aProcess == scheduler ifTrue:[
        InvalidProcessSignal raiseWith:aProcess errorString:'attempt to terminate scheduler'.
        ^ self
    ].

    wasBlocked := OperatingSystem blockInterrupts.

    id := aProcess id.
    id isNil ifTrue:[   "already dead"
        self checkForEndOfDispatch.
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
        ^ self
    ].

    aProcess setId:nil state:#dead.

    "remove the process from the runnable list"

    pri := aProcess priority.
    l := quiescentProcessLists at:pri.
    l notNil ifTrue:[
        (l removeIdentical:aProcess ifAbsent:nil) "notNil ifTrue:[
            l isEmpty ifTrue:[
                quiescentProcessLists at:pri put:nil
            ]
        ]."
    ].

    aProcess == activeProcess ifTrue:[
        "
         hard case - it's the currently running process
         we must have the next active process destroy this one
         (we cannot destroy the chair we are sitting on ... :-)
        "
        zombie notNil ifTrue:[
            self error:'active process is zombie' mayProceed:true.
            self class threadDestroy:zombie.
        ].

        self unRemember:aProcess.
        zombie := id.

        self checkForEndOfDispatch.
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
        self threadSwitch:scheduler.
        "not reached"
        ^ self
    ].

    self unRemember:aProcess.
    self class threadDestroy:id.

    self checkForEndOfDispatch.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: / 23-09-1996 / 13:50:24 / stefan"
    "Modified: / 20-03-1997 / 16:03:39 / cg"
    "Modified (comment): / 10-08-2011 / 19:57:08 / cg"
!

yield
    "move the currently running process to the end of the current list
     and reschedule to the first in the list, thus switching to the
     next same-prio-process."

    |l sz wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    activeProcess == scheduler ifTrue:[
	'Processor [warning]: scheduler tries to yield' errorPrintCR.
	^ self
    ].

    "
     debugging consistency check - will be removed later
    "
    activeProcess priority ~~ currentPriority ifTrue:[
	'Processor [warning]: process changed its priority' errorPrintCR.
	currentPriority := activeProcess priority.
    ].

    l := quiescentProcessLists at:currentPriority.
    sz := l size.

    "
     debugging consistency checks - will be removed later
    "
    sz == 0 ifTrue:[
	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	'Processor [warning]: empty runnable list' errorPrintCR.
	^ self
    ].

    "
     check if the running process is not the only one
    "
    sz ~~ 1 ifTrue:[
	"
	 bring running process to the end
	"
	l removeFirst.
	l addLast:activeProcess.

	"
	 and switch to first in the list
	"
	self threadSwitch:(l firstLink).
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: / 02-08-2010 / 13:36:25 / cg"
! !

!ProcessorScheduler methodsFor:'scheduling-preemptive'!

recomputeDynamicPriorities
    "recompute dynamic priorities."

    |processesToDecrease processesToIncrease|

    scheduledProcesses notNil ifTrue:[
	"/ this is written a bit cryptic - to avoid creation
	"/ of garbage objects (Id'sets) if possible.
	"/ since this runs 50 times a second and most of the
	"/ time, no rescheduling is req'd

	scheduledProcesses do:[:aProcess |
	    |range|

	    "/ decrease priority of processes that did run
	    (range := aProcess priorityRange) notNil ifTrue:[
		aProcess priority > range start ifTrue:[
		    processesToDecrease isNil ifTrue:[
			processesToDecrease := IdentitySet new.
		    ].
		    processesToDecrease add:aProcess.
		]
	    ]
	].

	processesToDecrease notNil ifTrue:[
	    processesToDecrease do:[:aProcess |
		|newPri|

		"/ newPri := aProcess priority - 1.
		newPri := aProcess priorityRange start.
		self changePriority:newPri for:aProcess.
	    ].
	].

	"/ and increase all prios of those that did not run, but are runnable

	TimeSlicingPriorityLimit to:1 by:-1 do:[:i |
	    |list|

	    (list := quiescentProcessLists at:i) size > 0 ifTrue:[
		list linksDo:[:aProcess |
		    |range prio|

		    (range := aProcess priorityRange) notNil ifTrue:[
			(processesToDecrease isNil
			or:[(processesToDecrease includes:aProcess) not]) ifTrue:[
			    aProcess priority < range stop ifTrue:[
				processesToIncrease isNil ifTrue:[
				    processesToIncrease := OrderedCollection new.
				].
				processesToIncrease add:aProcess
			    ]
			]
		    ]
		]
	    ]
	].
	processesToIncrease notNil ifTrue:[
	    processesToIncrease do:[:aProcess |
		self changePriority:(aProcess priority + 1) for:aProcess.
	    ].
	].
    ].

    "Modified: / 30-07-2013 / 19:33:14 / cg"
!

scheduledProcesses
    "return a collection of recently scheduled processes.
     This is  only non-empty, if the dynamic priority
     scheduler is running"

    ^ scheduledProcesses ? #()

    "Created: / 27.8.1998 / 09:23:21 / cg"
    "Modified: / 27.8.1998 / 12:56:35 / cg"
!

slice
    "Give other Processes at the current priority a chance to run."

    |i "{ Class: SmallInteger }"
     list wasBlocked anyShuffle|

    anyShuffle := false.
    wasBlocked := OperatingSystem blockInterrupts.

    i := TimeSlicingPriorityLimit.
    [(i > 0) and:[(list := quiescentProcessLists at:i) size <= 1]] whileTrue: [i := i - 1].
    i ~~ 0 ifTrue: [
	"/ shuffle that list
	list addLast:(list removeFirst).
	anyShuffle := true.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    anyShuffle ifFalse:[
	"/ wait for the scheduler to make some process runnable...
	timeSliceNeededSemaphore wait.
    ].

    "Modified: / 4.8.1998 / 00:13:32 / cg"
!

startTimeSlicing
    "start preemptive scheduling (timeSlicing)"

    timeSliceProcess notNil ifTrue: [^ self].

    timeSliceNeededSemaphore := Semaphore new name:'timeSlice needed'.

    timeSliceProcess := [
	[
	    self timeSlicingLoop.
	] ifCurtailed:[
	    timeSliceProcess := nil.
	    'Processor [info]: timeslicer finished' infoPrintCR.
	]
    ] newProcess.
    timeSliceProcess
	priority:HighestPriority;
	name:'time slicer';
	restartable:true;
	beSystemProcess;
	resume.

    "
     Processor stopTimeSlicing.
     Processor startTimeSlicing.
    "

    "Created: / 17-01-1997 / 16:42:02 / cg"
    "Modified: / 03-11-2011 / 21:21:10 / cg"
!

stopTimeSlicing
    "stop preemptive scheduling (timeSlicing)"

    timeSliceProcess notNil ifTrue: [
	timeSliceProcess terminate.
	timeSliceProcess := nil.
	scheduledProcesses := nil.
	timeSliceNeededSemaphore := nil.
    ]

    "
     Processor stopTimeSlicing
    "

    "Created: / 17.1.1997 / 16:43:03 / cg"
    "Modified: / 27.8.1998 / 13:00:37 / cg"
!

supportDynamicPriorities
    "return true, if dynamic priorities are enabled"

    ^ supportDynamicPriorities

    "Created: / 3.8.1998 / 22:05:15 / cg"
    "Modified: / 3.8.1998 / 22:55:08 / cg"
!

supportDynamicPriorities:aBoolean
    "enable/disable dynamic priorities"

    supportDynamicPriorities := aBoolean.

    "
     Processor supportDynamicPriorities:true
     Processor supportDynamicPriorities:false
    "

    "Modified: / 3.8.1998 / 22:54:52 / cg"
!

timeSlicingLoop
    |myDelay t flipFlop|

    myDelay := Delay forMilliseconds:(t := TimeSliceInterval).
    flipFlop := true.

    Smalltalk verbose ifTrue:[ 'Processor [info]: timeslicer started' infoPrintCR ].
    [
        t ~~ TimeSliceInterval ifTrue:[
            "/ interval changed -> need a new delay
            myDelay delay:(t := TimeSliceInterval).
        ].
        myDelay wait.
        self slice.

        "/ every other tick, recompute priorities.
        flipFlop := flipFlop not.
        flipFlop ifTrue:[
            scheduledProcesses notNil ifTrue:[
                supportDynamicPriorities ifTrue:[
                    self recomputeDynamicPriorities.
                ].
                scheduledProcesses clearContents.
            ] ifFalse:[
                scheduledProcesses := IdentitySet new.
            ].
        ].
    ] loop.
! !

!ProcessorScheduler methodsFor:'semaphore signalling'!

disableFd:aFileDescriptor doSignal:doSignal
    "disable triggering of a semaphore for aFileDescriptor..
     If doSignal is true, the associated semaphore is signaled.
     Answer a collection of semaphores that haven't been signaled."

    |idx "{ Class: SmallInteger }"
     wasBlocked sema semaCollection|

    wasBlocked := OperatingSystem blockInterrupts.
    useIOInterrupts ifTrue:[
	OperatingSystem disableIOInterruptsOn:aFileDescriptor.
    ].

    idx := readFdArray indexOf:aFileDescriptor startingAt:1.
    [idx ~~ 0] whileTrue:[
	readFdArray at:idx put:nil.
	readCheckArray at:idx put:nil.
	(sema := readSemaphoreArray at:idx) notNil ifTrue:[
	    readSemaphoreArray at:idx put:nil.
	    semaCollection isNil ifTrue:[semaCollection := Set new].
	    semaCollection add:sema.
	].
	idx := readFdArray indexOf:aFileDescriptor startingAt:idx+1.
    ].
    idx := writeFdArray indexOf:aFileDescriptor startingAt:1.
    [idx ~~ 0] whileTrue:[
	writeFdArray at:idx put:nil.
	writeCheckArray at:idx put:nil.
	(sema := writeSemaphoreArray at:idx) notNil ifTrue:[
	    writeSemaphoreArray at:idx put:nil.
	    semaCollection isNil ifTrue:[semaCollection := Set new].
	    semaCollection add:sema.
	].
	idx := writeFdArray indexOf:aFileDescriptor startingAt:idx+1.
    ].
    idx := exceptFdArray indexOf:aFileDescriptor startingAt:1.
    [idx ~~ 0] whileTrue:[
	exceptFdArray at:idx put:nil.
	(sema := exceptSemaphoreArray at:idx) notNil ifTrue:[
	    exceptSemaphoreArray at:idx put:nil.
	    semaCollection isNil ifTrue:[semaCollection := Set new].
	    semaCollection add:sema.
	].
	idx := exceptFdArray indexOf:aFileDescriptor startingAt:idx+1.
    ].

    semaCollection isNil ifTrue:[
	semaCollection := #().
    ] ifFalse:[
	doSignal ifTrue:[
	    semaCollection do:[:eachSema|
		eachSema signalForAll.
		semaCollection := #().
	    ].
	].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ semaCollection
!

disableSemaphore:aSemaphore
    "disable triggering of a semaphore"

    |idx "{ Class: SmallInteger }"
     wasBlocked fd|

    wasBlocked := OperatingSystem blockInterrupts.
    idx := 0.
    [idx := readSemaphoreArray identityIndexOf:aSemaphore startingAt:idx+1.
     idx ~~ 0] whileTrue:[
	useIOInterrupts ifTrue:[
	    fd := readFdArray at:idx.
	    fd notNil ifTrue:[
		OperatingSystem disableIOInterruptsOn:fd
	    ].
	].
	readFdArray at:idx put:nil.
	readSemaphoreArray at:idx put:nil.
	readCheckArray at:idx put:nil.
    ].
    idx := 0.
    [idx := writeSemaphoreArray identityIndexOf:aSemaphore startingAt:idx+1.
     idx ~~ 0] whileTrue:[
	useIOInterrupts ifTrue:[
	    fd := writeFdArray at:idx.
	    fd notNil ifTrue:[
		OperatingSystem disableIOInterruptsOn:fd
	    ].
	].
	writeFdArray at:idx put:nil.
	writeSemaphoreArray at:idx put:nil.
	writeCheckArray at:idx put:nil.
    ].
    idx := 0.
    [idx := exceptSemaphoreArray identityIndexOf:aSemaphore startingAt:idx+1.
     idx ~~ 0] whileTrue:[
	exceptFdArray at:idx put:nil.
	exceptSemaphoreArray at:idx put:nil.
    ].
    self removeTimeoutForSemaphore:aSemaphore.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 4.8.1997 / 15:19:33 / cg"
!

signal:aSemaphore
    "arrange for a semaphore to be triggered as soon as possible.
     The actual signalling is performed slightly delayed, when the dispatcher
     looks for a process to resume the next time. I.e. here, the current
     process continues to execute, even if the semaphore signalling would
     make a higher prio process runnable.
     This is provided as entry for primitive-code (external functions)
     which want to signal a semaphore AND make certain that they do not get
     suspended (i.e. it is called by __STX_SignalSemaphore()).
     Normal smalltalk code should always send an appropriate message directly
     to the semaphore (i.e. aSemaphore signal)."

    self signal:aSemaphore atMilliseconds:OperatingSystem getMillisecondTime.

    "Modified: / 9.11.1998 / 20:39:06 / cg"
!

signal:aSemaphore after:aTimeDuration
    "arrange for a semaphore to be triggered after aTimeDuration"

    self signal:aSemaphore afterMilliseconds:aTimeDuration getMilliseconds
!

signal:aSemaphore afterMilliseconds:millis
    "arrange for a semaphore to be triggered after some milliseconds"

    |now then|

    now := OperatingSystem getMillisecondTime.
    then := OperatingSystem millisecondTimeAdd:now and:millis rounded.
    self signal:aSemaphore atMilliseconds:then.

    "Modified: / 9.11.1998 / 20:39:27 / cg"
!

signal:aSemaphore afterSeconds:seconds
    "arrange for a semaphore to be triggered after some seconds"

    self signal:aSemaphore afterMilliseconds:(seconds * 1000)
!

signal:aSemaphore atMilliseconds:aMillisecondTime
    "arrange for a semaphore to be triggered at a specific millisecond time.
     If there is already a pending trigger time installed for that semaphore,
     the time of the pending trigger is changed."

    |index "{ Class: SmallInteger }"
     wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    index := timeoutSemaphoreArray identityIndexOf:aSemaphore startingAt:1.
    index ~~ 0 ifTrue:[
	timeoutArray at:index put:aMillisecondTime
    ] ifFalse:[
	index := timeoutArray identityIndexOf:nil startingAt:1.
	index ~~ 0 ifTrue:[
	    timeoutSemaphoreArray at:index put:aSemaphore.
	    timeoutArray at:index put:aMillisecondTime.
	    timeoutActionArray at:index put:nil.
	    timeoutProcessArray at:index put:nil
	] ifFalse:[
	    timeoutSemaphoreArray := timeoutSemaphoreArray copyWith:aSemaphore.
	    timeoutArray := timeoutArray copyWith:aMillisecondTime.
	    timeoutActionArray := timeoutActionArray copyWith:nil.
	    timeoutProcessArray := timeoutProcessArray copyWith:nil
	].
    ].

    anyTimeouts := true.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

signal:aSemaphore onException:aFileDescriptor
    "arrange for a semaphore to be triggered when output on aFileDescriptor
     is possible (i.e. can be written without blocking) or aBlock returns true.
     The checkBlock will be evaluated by the scheduler from time to time
     (i.e. every few milliseconds).
     This checkBlock is required for poor windows, where a WaitForObject does
     not know about sockets.
     If aBlock is nil, the semaphore is removed from the set of semaphores, after being signaled."

    |idx "{ Class: SmallInteger }"
     wasBlocked slot|

    wasBlocked := OperatingSystem blockInterrupts.

    "Here we assume, that for every triple (aSemaphore, aFileDescriptor, aBlock)
     aSemphore is never nil, but one of aFileDescriptor, aBlock may be nil"

    aFileDescriptor isNil ifTrue:[
	idx := exceptSemaphoreArray identityIndexOf:aSemaphore or:nil.
	idx == 0 ifTrue:[
	    "aSemaphore is not registered yet, have to create a new slot"
	    exceptFdArray := exceptFdArray copyWith:nil.
	    exceptSemaphoreArray := exceptSemaphoreArray copyWith:aSemaphore.
	] ifFalse:[
	    slot := exceptSemaphoreArray at:idx.
	    slot isNil ifTrue:[
		exceptSemaphoreArray at:idx put:aSemaphore.
	    ]
	]
    ] ifFalse:[
	idx := exceptFdArray identityIndexOf:aFileDescriptor or:nil.
	idx == 0 ifTrue:[
	    "aFileDescriptor is not registered yet, have to create a new slot"
	    exceptFdArray := exceptFdArray copyWith:aFileDescriptor.
	    exceptSemaphoreArray := exceptSemaphoreArray copyWith:aSemaphore.
	] ifFalse:[
	    slot := exceptFdArray at:idx.
	    slot isNil ifTrue:[
		exceptFdArray at:idx put:aFileDescriptor.
		exceptSemaphoreArray at:idx put:aSemaphore.
	    ].
	].
"/        (useIOInterrupts and:[slot isNil]) ifTrue:[
"/            OperatingSystem enableIOInterruptsOn:aFileDescriptor
"/        ].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 4.8.1997 / 15:21:49 / cg"
!

signal:aSemaphore onInput:aFileDescriptor
    "arrange for a semaphore to be triggered when input on aFileDescriptor
     arrives. This will only happen, if the OS supports selecting on fileDescriptors.
     The semaphore is removed from the set of semaphores, after being signaled."

    self signal:aSemaphore onInput:aFileDescriptor orCheck:nil
!

signal:aSemaphore onInput:aFileDescriptor orCheck:aBlock
    "arrange for a semaphore to be triggered when input on aFileDescriptor
     arrives OR checkblock evaluates to true.
     The checkBlock will be evaluated by the scheduler from time to time
     (i.e. every few milliseconds).
     (This is req'd for buffered input, where a select may not detect
      data which has already been read into a buffer - as in Xlib.
      Or on systems, where we cannot select on a displays eventQ, such as windows).
     If aBlock is nil, the semaphore is removed from the set of semaphores, after being signaled."

    |idx "{ Class: SmallInteger }"
     wasBlocked slot|

    wasBlocked := OperatingSystem blockInterrupts.

    "Here we assume, that for every triple (aSemaphore, aFileDescriptor, aBlock)
     aSemphore is never nil, but one of aFileDescriptor, aBlock may be nil"

    aFileDescriptor isNil ifTrue:[
	idx := readSemaphoreArray identityIndexOf:aSemaphore or:nil.
	idx == 0 ifTrue:[
	    "aSemaphore is not registered yet, have to create a new slot"
	    readFdArray := readFdArray copyWith:nil.
	    readSemaphoreArray := readSemaphoreArray copyWith:aSemaphore.
	    readCheckArray := readCheckArray copyWith:aBlock.
	] ifFalse:[
	    slot := readSemaphoreArray at:idx.
	    slot isNil ifTrue:[
		readSemaphoreArray at:idx put:aSemaphore.
		readCheckArray at:idx put:aBlock
	    ] ifFalse:[
		"/ someone has already registered aSemaphore.
		"/ Check if it is the block changes...
		(readCheckArray at:idx) notNil ifTrue:[
		    (readCheckArray at:idx) ~~ aBlock ifTrue:[
			'Processor [info]: checkblock changed for read-check' infoPrintCR.
			readCheckArray at:idx put:aBlock.
		    ].
		].
	    ].
	]
    ] ifFalse:[
	idx := readFdArray identityIndexOf:aFileDescriptor or:nil.
	idx == 0 ifTrue:[
	    "aFileDescriptor is not registered yet, have to create a new slot"
	    readFdArray := readFdArray copyWith:aFileDescriptor.
	    readSemaphoreArray := readSemaphoreArray copyWith:aSemaphore.
	    readCheckArray := readCheckArray copyWith:aBlock.
	] ifFalse:[
	    slot := readFdArray at:idx.
	    slot isNil ifTrue:[
		readFdArray at:idx put:aFileDescriptor.
		readSemaphoreArray at:idx put:aSemaphore.
		readCheckArray at:idx put:aBlock
	    ] ifFalse:[
		"/ someone has already registered aFileDescriptor.
		"/ Check if it is the semaphore or block changes...
		(readSemaphoreArray at:idx) ~~ aSemaphore ifTrue:[
		    'Processor [info]: sema changed for read-check' infoPrintCR.
		    readSemaphoreArray at:idx put:aSemaphore.
		].
		(readCheckArray at:idx) ~~ aBlock ifTrue:[
		    'Processor [info]: checkblock changed for read-check' infoPrintCR.
		    readCheckArray at:idx put:aBlock.
		].
	    ].
	].
	(useIOInterrupts and:[slot isNil]) ifTrue:[
	    OperatingSystem enableIOInterruptsOn:aFileDescriptor
	].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 4.8.1997 / 15:20:45 / cg"
!

signal:aSemaphore onInputStream:aStream
    "arrange for a semaphore to be triggered when input on aStream arrives.
     This will do a select, if the OS supports selecting on that filedescriptor,
     otherwise, it will be polled every few milliseconds (MSDOS)."

    aStream canBeSelected ifTrue:[
        "/ can this stream be selected on ?
        self signal:aSemaphore onInput:aStream fileHandle orCheck:nil
    ] ifFalse:[
        "/ nope - must poll ...
        self signal:aSemaphore onInput:nil orCheck:[aStream canReadWithoutBlocking]
    ]

    "Modified: / 14.12.1999 / 23:58:50 / cg"
!

signal:aSemaphore onOutput:aFileDescriptor
    "arrange for a semaphore to be triggered when output on aFileDescriptor
     is possible without blocking.
     The semaphore is removed from the set of semaphores, after being signaled."

    self signal:aSemaphore onOutput:aFileDescriptor orCheck:nil

    "Created: / 14.12.1999 / 19:54:12 / cg"
!

signal:aSemaphore onOutput:aFileDescriptor orCheck:aBlock
    "arrange for a semaphore to be triggered when output on aFileDescriptor
     is possible (i.e. can be written without blocking) or aBlock returns true.
     The checkBlock will be evaluated by the scheduler from time to time
     (i.e. every few milliseconds).
     This checkBlock is required for poor windows, where a WaitForObject does
     not know about sockets.
     If aBlock is nil, the semaphore is removed from the set of semaphores, after being signaled."

    |idx "{ Class: SmallInteger }"
     wasBlocked slot|

    wasBlocked := OperatingSystem blockInterrupts.

    "Here we assume, that for every triple (aSemaphore, aFileDescriptor, aBlock)
     aSemphore is never nil, but one of aFileDescriptor, aBlock may be nil"

    aFileDescriptor isNil ifTrue:[
	idx := writeSemaphoreArray identityIndexOf:aSemaphore or:nil.
	idx == 0 ifTrue:[
	    "aSemaphore is not registered yet, have to create a new slot"
	    writeFdArray := writeFdArray copyWith:nil.
	    writeSemaphoreArray := writeSemaphoreArray copyWith:aSemaphore.
	    writeCheckArray := writeCheckArray copyWith:aBlock.
	] ifFalse:[
	    slot := writeSemaphoreArray at:idx.
	    slot isNil ifTrue:[
		writeSemaphoreArray at:idx put:aSemaphore.
		writeCheckArray at:idx put:aBlock
	    ] ifFalse:[
		"/ someone has already registered aSemaphore.
		"/ Check if it is the block changes...
		(writeCheckArray at:idx) notNil ifTrue:[
		    (writeCheckArray at:idx) ~~ aBlock ifTrue:[
			'Processor [info]: checkblock changed for write-check' infoPrintCR.
			writeCheckArray at:idx put:aBlock.
		    ].
		].
	    ].
	]
    ] ifFalse:[
	idx := writeFdArray identityIndexOf:aFileDescriptor or:nil.
	idx == 0 ifTrue:[
	    "aFileDescriptor is not registered yet, have to create a new slot"
	    writeFdArray := writeFdArray copyWith:aFileDescriptor.
	    writeSemaphoreArray := writeSemaphoreArray copyWith:aSemaphore.
	    writeCheckArray := writeCheckArray copyWith:aBlock.
	] ifFalse:[
	    slot := writeFdArray at:idx.
	    slot isNil ifTrue:[
		writeFdArray at:idx put:aFileDescriptor.
		writeSemaphoreArray at:idx put:aSemaphore.
		writeCheckArray at:idx put:aBlock
	    ] ifFalse:[
		"/ someone has already registered aFileDescriptor.
		"/ Check if it is the semaphore or block changes...
		(writeSemaphoreArray at:idx) ~~ aSemaphore ifTrue:[
		    'Processor [info]: sema changed for write-check' infoPrintCR.
		    writeSemaphoreArray at:idx put:aSemaphore.
		].
		(writeCheckArray at:idx) ~~ aBlock ifTrue:[
		    'Processor [info]: checkblock changed for write-check' infoPrintCR.
		    writeCheckArray at:idx put:aBlock.
		].
	    ].
	].
	(useIOInterrupts and:[slot isNil]) ifTrue:[
	    OperatingSystem enableIOInterruptsOn:aFileDescriptor
	].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "Modified: 4.8.1997 / 15:21:49 / cg"
!

signal:aSemaphore onOutputStream:aStream
    "arrange for a semaphore to be triggered when output on aStream is possible.
     This will do a select, if the OS supports selecting on that filedescriptor,
     otherwise, it will be polled every few milliseconds (MSDOS)."

    aStream canBeSelected ifTrue:[
        "/ can this stream be selected on ?
        self signal:aSemaphore onOutput:aStream fileHandle orCheck:nil
    ] ifFalse:[
        "/ nope - must poll ...
        self signal:aSemaphore onOutput:nil orCheck:[aStream canWriteWithoutBlocking]
    ]

    "Modified: / 14.12.1999 / 23:59:19 / cg"
! !

!ProcessorScheduler methodsFor:'special configuration'!

useIOInterrupts:aBoolean
    "enable/disable the use of IO-interrupts.
     If disabled, communication channels (socket, X-server connection etc.)
     are polled in regular intervals.
     If enabled, arrangements are made for data-availability to trigger an
     interrupt.
     Using IO interrupts reduces the idle CPU usage of ST/X by some percent
     (typically 2-7%).
     Notice:
	some systems do not support IO-interrupts (or have a broken stdio-lib),
	and this feature is always disabled;
     Also notice:
	we found that in some Xlib-implementations, interrupted reads are not
	handled correctly (especially in multi-headed applications), and this
	feature should be disabled to avoid a blocking XPending.

     If this method is used to disable IO interrupts in multi-headed apps,
     it should be invoked BEFORE the display event dispatcher processes are started."

    OperatingSystem supportsIOInterrupts ifTrue:[
	useIOInterrupts := aBoolean
    ].

    "Created: / 15.7.1998 / 13:32:29 / cg"
! !

!ProcessorScheduler methodsFor:'timeout handling'!

addTimedBlock:aBlock after:timeDuration
    "add the argument, aBlock to the list of time-scheduled-blocks; to be
     evaluated after timeDuration. The process which installs this timed
     block will be interrupted for execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    ^ self addTimedBlock:aBlock for:activeProcess afterMilliseconds:timeDuration getMilliseconds
!

addTimedBlock:aBlock afterMilliseconds:delta
    "add the argument, aBlock to the list of time-scheduled-blocks; to be
     evaluated after delta milliseconds. The process which installs this timed
     block will be interrupted for execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    ^ self addTimedBlock:aBlock for:activeProcess afterMilliseconds:delta

    "Modified: 23.9.1996 / 14:33:59 / cg"
!

addTimedBlock:aBlock afterSeconds:delta
    "add the argument, aBlock to the list of time-scheduled-blocks.
     to be evaluated after delta seconds. The process which installs this timed
     block will be interrupted for execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    ^ self addTimedBlock:aBlock for:activeProcess afterMilliseconds:(delta * 1000) rounded

    "Modified: 23.9.1996 / 14:34:04 / cg"
!

addTimedBlock:aBlock atMilliseconds:aMillisecondTime
    "add the argument, aBlock to the list of time-scheduled-blocks; to be
     evaluated when the millisecondClock value passes aMillisecondTime.
     The process which installs this timed block will be interrupted for
     execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    ^ self addTimedBlock:aBlock for:activeProcess atMilliseconds:aMillisecondTime

    "Modified: 23.9.1996 / 14:34:09 / cg"
!

addTimedBlock:aBlock for:aProcess after:timeDuration
    "add the argument, aBlock to the list of time-scheduled-blocks.
     to be evaluated after timeDuration. aProcess will be interrupted for
     execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     If aProcess is nil, the block will be evaluated by the scheduler itself
     (which is dangerous - the block should not raise any error conditions).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    ^ self addTimedBlock:aBlock for:aProcess afterMilliseconds:timeDuration getMilliseconds

    "Modified: 23.9.1996 / 14:34:18 / cg"
!

addTimedBlock:aBlock for:aProcess afterMilliseconds:delta
    "add the argument, aBlock to the list of time-scheduled-blocks; to be
     evaluated after delta milliseconds. The process specified by the argument,
     aProcess will be interrupted for execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     If aProcess is nil, the block will be evaluated by the scheduler itself
     (which is dangerous - the block should not raise any error conditions).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    |now then wasBlocked id|

    wasBlocked := OperatingSystem blockInterrupts.
    now := OperatingSystem getMillisecondTime.
    then := OperatingSystem millisecondTimeAdd:now and:delta.
    id := self addTimedBlock:aBlock for:aProcess atMilliseconds:then.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ id

    "Modified: 23.9.1996 / 14:34:13 / cg"
!

addTimedBlock:aBlock for:aProcess afterSeconds:delta
    "add the argument, aBlock to the list of time-scheduled-blocks.
     to be evaluated after delta seconds. aProcess will be interrupted for
     execution of the block.
     (if it is running, the interrupt will occur in whatever method it is
      executing; if it is suspended, it will be resumed).
     If aProcess is nil, the block will be evaluated by the scheduler itself
     (which is dangerous - the block should not raise any error conditions).
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    ^ self addTimedBlock:aBlock for:aProcess afterMilliseconds:(delta * 1000) rounded

    "Modified: 23.9.1996 / 14:34:18 / cg"
!

addTimedBlock:aBlock for:aProcess atMilliseconds:aMillisecondTime
    "add the argument, aBlock to the list of time-scheduled-blocks; 
     to be evaluated by aProcess when the millisecondClock value passes
     aMillisecondTime.
     If that block is already in the timeout list, its trigger-time is changed.
     The process specified by the argument, aProcess 
     will be interrupted for execution of the block.
     If aProcess is nil, the block will be evaluated by the scheduler itself
     (which is dangerous: the block should not raise any error conditions).
     If the process is active at trigger time, the interrupt will occur in
     whatever method it is executing; 
     if suspended at trigger time, it will be resumed.
     The block will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    |index "{ Class: SmallInteger }"
     wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    index := timeoutActionArray identityIndexOf:aBlock startingAt:1.
    index ~~ 0 ifTrue:[
        timeoutArray at:index put:aMillisecondTime
    ] ifFalse:[
        index := timeoutArray indexOf:nil.
        index ~~ 0 ifTrue:[
            timeoutArray at:index put:aMillisecondTime.
            timeoutActionArray at:index put:aBlock.
            timeoutSemaphoreArray at:index put:nil.
            timeoutProcessArray at:index put:aProcess
        ] ifFalse:[
            timeoutArray := timeoutArray copyWith:aMillisecondTime.
            timeoutActionArray := timeoutActionArray copyWith:aBlock.
            timeoutSemaphoreArray := timeoutSemaphoreArray copyWith:nil.
            timeoutProcessArray := timeoutProcessArray copyWith:aProcess.
            index := timeoutArray size.
        ].
    ].

    anyTimeouts := true.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ index

    "Modified: 23.9.1996 / 14:34:23 / cg"
!

addTimeoutFunctionCall:anExternalFunction for:aProcess afterMilliseconds:delta with:argument
    "prepare for an external function to be called with a single argument
     after some millisecond-Delay.
     If aProcess is nil, the block will be evaluated by the scheduler itself,
     otherwise, that process will be interrupted and the function is performed
     in this processes context.
     The callBack will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    |now then wasBlocked id|

    wasBlocked := OperatingSystem blockInterrupts.
    now := OperatingSystem getMillisecondTime.
    then := OperatingSystem millisecondTimeAdd:now and:delta.

    id := self
	addTimeoutFunctionCall:anExternalFunction
	for:aProcess
	atMilliseconds:then
	with:argument.

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ^ id

    "Created: 23.9.1996 / 14:28:27 / cg"
    "Modified: 23.9.1996 / 14:34:42 / cg"
!

addTimeoutFunctionCall:anExternalFunction for:aProcess atMilliseconds:milliTime with:argument
    "prepare for an external function to be called with a single argument
     at some millisecond-time.
     If aProcess is nil, the block will be evaluated by the scheduler itself,
     otherwise, that process will be interrupted and the function is performed
     in this processes context.
     The callBack will be removed from the timed-block list after evaluation
     (i.e. it will trigger only once).
     Returns an ID, which can be used in #removeTimeoutWidthID:"

    |action|

    action := [anExternalFunction callWith:argument].
    ^ self
	addTimedBlock:action
	for:aProcess
	atMilliseconds:milliTime.

    "Created: 23.9.1996 / 14:29:30 / cg"
    "Modified: 23.9.1996 / 14:34:57 / cg"
!

evaluateTimeouts
    "walk through timeouts and evaluate blocks or signal semas that need to be .."

    |sema now aTime block blocksAndProcessesToEvaluate
     firstBlockToEvaluate firstProcess
     n "{ Class: SmallInteger }"
     indexOfLastTimeout "{ Class: SmallInteger }"
     halfSize "{ Class: SmallInteger }"
     wasBlocked p|

    anyTimeouts ifFalse:[ ^ self].
    anyTimeouts := false.
    indexOfLastTimeout := 0.

    "have to collect the blocks first, then evaluate them.
     This avoids problems due to newly inserted blocks."

    "/ notice: the code looks uglier than seems to be required;
    "/ the observation is that in almost all cases, only a single block (or no block at all)
    "/ is found in the loops below.
    "/ To avoid idle memory allocation, we avoid the allocation of the OrderedCollection in this case,
    "/ by remembering the first block+process in a variable until another block is found.
    "/ Thus firstBlockToEvaluate+firstProcess effectively cache the first slot of the lazy allocated collection.
    "/ looks ugly, but as this is called very often, reduces idle allocation by a lot.

    now := OperatingSystem getMillisecondTime.
    n := timeoutArray size.
    1 to:n do:[:index |
        aTime := timeoutArray at:index.
        aTime notNil ifTrue:[
            (OperatingSystem millisecondTime:now isAfter:aTime) ifTrue:[
                "this one should be triggered"

                sema := timeoutSemaphoreArray at:index.
                sema notNil ifTrue:[
                    timeoutSemaphoreArray at:index put:nil.
                    timedActionCounter := (timedActionCounter + 1 bitAnd:SmallInteger maxVal).
                    sema signalOnce.
                ] ifFalse:[
                    "to support pure-events"
                    block := timeoutActionArray at:index.
                    block notNil ifTrue:[
                        "/ usually (>99%), there is only one single timeout action to call;
                        "/ avoid creation of an OrderedCollection
                        firstBlockToEvaluate isNil ifTrue:[
                            firstBlockToEvaluate := block.
                            firstProcess := timeoutProcessArray at:index.
                        ] ifFalse:[
                            blocksAndProcessesToEvaluate isNil ifTrue:[
                                blocksAndProcessesToEvaluate := OrderedCollection
                                                                    with:firstBlockToEvaluate
                                                                    with:firstProcess.
                            ].
                            blocksAndProcessesToEvaluate add:block.
                            blocksAndProcessesToEvaluate add:(timeoutProcessArray at:index).
                        ].
                        timeoutActionArray at:index put:nil.
                        timeoutProcessArray at:index put:nil.
                    ]
                ].
                timeoutArray at:index put:nil.
            ] ifFalse:[
                "there are still pending timeouts"
                anyTimeouts := true.
                indexOfLastTimeout := index.
            ]
        ]
    ].

    "shrink the arrays, if they are 50% free"
    n > 20 ifTrue:[
        halfSize := n // 2.
        (indexOfLastTimeout ~~ 0 and:[indexOfLastTimeout < halfSize]) ifTrue:[
            wasBlocked := OperatingSystem blockInterrupts.
            (timeoutArray at:indexOfLastTimeout+1) isNil ifTrue:[   "/ no new timeouts arrived
                timeoutArray := timeoutArray copyTo:halfSize.
                timeoutSemaphoreArray := timeoutSemaphoreArray copyTo:halfSize.
                timeoutActionArray := timeoutActionArray copyTo:halfSize.
                timeoutProcessArray := timeoutProcessArray copyTo:halfSize.
            ].
            wasBlocked ifFalse:[ OperatingSystem unblockInterrupts ].
        ].
    ].

    "/ usually (>99%), there is only one single timeout action to call;
    "/ above code avoided the creation of an OrderedCollection
    blocksAndProcessesToEvaluate isNil ifTrue:[
        firstBlockToEvaluate notNil ifTrue:[
            timedActionCounter := (timedActionCounter + 1 bitAnd:SmallInteger maxVal).
            (firstProcess isNil or:[firstProcess == scheduler or:[PureEventDriven]]) ifTrue:[
                firstBlockToEvaluate value
            ] ifFalse:[
                firstProcess isDead ifTrue:[
                    "/ a timedBlock for a process which has already terminated
                    "/ issue a warning and do not execute it.
                    "/ (executing here may be dangerous, since it would run at scheduler priority here,
                    "/  and thereby could block the whole smalltalk system.
                    "/  For this reason is it IGNORED here.)

                    "/ Could handle it in timeoutProcess, but we don't,
                    "/ because otherwise timeouts might be reissued forever...
                    "/      (timeoutHandlerProcess notNil and:[timeoutHandlerProcess isDead not]) ifTrue:[
                    "/          timeoutHandlerProcess interruptWith:block.
                    "/      ] ifFalse:[
                        ('ProcessorScheduler [warning]: cannot evaluate timedBlock (', firstBlockToEvaluate displayString, ') for dead process: ''' , firstProcess name , '''') errorPrintCR.
                    "/      ].
                ] ifFalse:[
                    firstProcess interruptWith:firstBlockToEvaluate
                ]
            ]
        ].
    ] ifFalse:[
        n := blocksAndProcessesToEvaluate size.
        1 to:n by:2 do:[:index |
            block := blocksAndProcessesToEvaluate at:index.
            p := blocksAndProcessesToEvaluate at:index+1.
            (p isNil or:[p == scheduler or:[PureEventDriven]]) ifTrue:[
                block value.
                timedActionCounter := (timedActionCounter + 1 bitAnd:SmallInteger maxVal).
            ] ifFalse:[
                p isDead ifTrue:[
                    "/ a timedBlock for a process which has already terminated
                    "/ issue a warning and do not execute it.
                    "/ (executing here may be dangerous, since it would run at scheduler priority here,
                    "/  and thereby could block the whole smalltalk system.
                    "/  For this reason is it IGNORED here.)

                    "/ Could handle it in timeoutProcess, but we don't,
                    "/ because otherwise timeouts might be reissued forever...
                    "/      (timeoutHandlerProcess notNil and:[timeoutHandlerProcess isDead not]) ifTrue:[
                    "/          timeoutHandlerProcess interruptWith:block.
                    "/      ] ifFalse:[
                        ('ProcessorScheduler [warning]: cannot evaluate timedBlock (', block displayString, ') for dead process: ''' , p name , '''') errorPrintCR.
                    "/      ].
                ] ifFalse:[
                    timedActionCounter := (timedActionCounter + 1 bitAnd:SmallInteger maxVal).
                    p interruptWith:block
                ]
            ]
        ]
    ].

    "Modified: / 30-07-2013 / 19:33:24 / cg"
!

removeTimedBlock:aBlock
    "remove the argument, aBlock from the list of time-sceduled-blocks."

    |index "{ Class: SmallInteger }"
     wasBlocked|

    aBlock isNil ifTrue:[^ self].

    wasBlocked := OperatingSystem blockInterrupts.
    index := timeoutActionArray identityIndexOf:aBlock startingAt:1.
    (index ~~ 0) ifTrue:[
	timeoutArray at:index put:nil.
	timeoutActionArray at:index put:nil.
	timeoutSemaphoreArray at:index put:nil.
	timeoutProcessArray at:index put:nil.
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

removeTimeoutForSemaphore:aSemaphore
    "remove the timeOut that signals aSemaphore
     from the list of time-scheduled-blocks."

    |index "{ Class: SmallInteger }"
     wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.

    index := 0.
    [
        index := timeoutSemaphoreArray identityIndexOf:aSemaphore startingAt:index+1.
        index ~~ 0
    ] whileTrue:[
        timeoutArray at:index put:nil.
        timeoutSemaphoreArray at:index put:nil.
        timeoutActionArray at:index put:nil.
        timeoutProcessArray at:index put:nil.
    ].

    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

removeTimeoutWithID:anID
    "remove the timeOut with anID (as returned by #addTimedBlock)
     from the list of time-scheduled-blocks."

    |index "{ Class: SmallInteger }"
     wasBlocked|

    index := anID.
    (index > 0) ifTrue:[
	wasBlocked := OperatingSystem blockInterrupts.

	timeoutArray at:index put:nil.
	timeoutActionArray at:index put:nil.
	timeoutSemaphoreArray at:index put:nil.
	timeoutProcessArray at:index put:nil.

	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ]

    "Created: 23.9.1996 / 14:32:33 / cg"
    "Modified: 23.9.1996 / 14:35:09 / cg"
!

removeTimeoutWithID:anID object:aBlockOrSemaphore
    "remove the timeOut with anID (as returned by #addTimedBlock)
     from the list of time-scheduled-blocks.
     If aBlockOrSempahore is not nil, check if the id is really for the block
     or for the semphore."

    |index "{ Class: SmallInteger }"
     wasBlocked|

    index := anID.
    (anID notNil and:[index > 0]) ifTrue:[
	wasBlocked := OperatingSystem blockInterrupts.

	(aBlockOrSemaphore notNil
	  and:[(timeoutActionArray at:index ifAbsent:[]) ~~ aBlockOrSemaphore
	  and:[(timeoutSemaphoreArray at:index ifAbsent:[]) ~~ aBlockOrSemaphore]]) ifTrue:[
	    'Processor: trying to remove stale timeout id - ignored' errorPrintCR.
	] ifFalse:[
	    timeoutArray at:index put:nil.
	    timeoutActionArray at:index put:nil.
	    timeoutSemaphoreArray at:index put:nil.
	    timeoutProcessArray at:index put:nil.
	].

	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ]
!

timeoutHandlerProcess
    (timeoutHandlerProcess isNil or:[timeoutHandlerProcess isDead]) ifTrue:[
	timeoutHandlerProcess :=
		[
		    [
			self timeoutHandlerProcessLoop.
		    ] ensure:[
			timeoutHandlerProcess := nil
		    ].
		] newProcess.

	timeoutHandlerProcess
	    priority:TimingPriority;
	    name:'timeout handler';
	    beSystemProcess;
	    resume.
    ].
    ^ timeoutHandlerProcess.

    "Modified: / 20-07-2006 / 09:52:27 / cg"
!

timeoutHandlerProcessLoop
    "The timeoutHandlerProcess does nothing but wait.
     It exists only, so that timeout blocks may be executed in its context
     (i.e. it will always just wait forever, and perform timeout actions
     in its interrupt handler)."

    |mySema|

    mySema := Semaphore new name:'timeoutHandler'.
    [
        [
            mySema wait.
        ] on:Exception do:[:ex|
            "/ an error occurred in one of the timeout actions.
            
            "ignore errors, but tell the user"
            InfoPrinting == true ifTrue:[
                ('ProcessorScheduler [warning]: error while handling timeouts in TimeoutHandlerProcess: ''' , ex description , '''') infoPrintCR.
                thisContext fullPrintAll.
            ].
        ].
    ] loop.
! !

!ProcessorScheduler methodsFor:'wait hooks'!

addPreWaitAction:aBlock
    "add the argument, aBlock to the list of preWait-actions.
     These blocks are evaluated right before the CPU is given up for the OS-wait.
     (i.e. the OS-wait for next event or timeout).
     Systems with buffered output (i.e. Xlib) can install a flush-block here,
     to force unflushed output to be sent out in regular intervals)"

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    preWaitActions isNil ifTrue:[
	preWaitActions := OrderedCollection new
    ].
    preWaitActions add:aBlock.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
!

removePreWaitAction:aBlock
    "remove the argument, aBlock from the list of preWait-actions."

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    preWaitActions notNil ifTrue:[
       preWaitActions removeIdentical:aBlock ifAbsent:nil
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
! !

!ProcessorScheduler methodsFor:'waiting'!

checkForEndOfDispatch
    |wasBlocked|
    
    exitWhenNoMoreUserProcesses ifTrue:[
        "/ check if there are any processes at all
        "/ stop dispatching if there is none
        "/ (and anyTimeouts is false, which means that no timeout blocks are present)
        "/ and no readSemaphores are present (which means that noone is waiting for input)
        "/ and no writeSemaphores are present
        wasBlocked := OperatingSystem blockInterrupts.

        "/ 'scheduled: ' _errorPrint. self anyScheduledWindowGroupAtAll asString _errorPrintCR.
        "/ 'anyUserProcess: ' _errorPrint. self anyUserProcessAtAll asString _errorPrintCR.
        
        self anyScheduledWindowGroupAtAll ifFalse:[
            self anyUserProcessAtAll ifFalse:[
                Smalltalk verbose ifTrue:[
                    'Processor [info]: end of dispatch' infoPrintCR.
                ].
                dispatching := false.
                "/ false ifTrue:[
                "/     MiniInspector basicNew printInstVarsOf:self.
                "/     MiniDebugger enter:thisContext withMessage:'about to exit' mayProceed:true.
                "/ ].
            ].
        ].
        
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
!

checkForIOWithTimeout:millis
    "this is called, when there is absolutely nothing to do;
     hard wait for either input to arrive, or output to be possible
     or a timeout to occur."

    |nReady index sema action wasBlocked err fd readyIndex
     newProcessMaybeReady fdOrPid exceptArray|

    "/ must enable interrupts, to be able to get out of a
    "/ long wait (especially, to handle sigChild in the meantime)

    wasBlocked := OperatingSystem unblockInterrupts.

    newProcessMaybeReady := false.
    readableResultFdArray size < readFdArray size ifTrue:[
        readableResultFdArray := Array new:(40 max:readFdArray size).
    ].
    writableResultFdArray size < writeFdArray size ifTrue:[
        writableResultFdArray := Array new:(40 max:writeFdArray size).
    ].

    exceptArray := exceptFdArray.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        "/
        "/ win32 does a WaitForMultipleObjects in select...
        "/ unix waits for SIGCHLD
        "/
        |hasPids|

        hasPids := false.
        osChildExitActions keysDo:[:eachPid|
            eachPid address = 0 ifTrue:[
                Logger warning:'Processor: remove 0-handle pid: %1' with:eachPid.
                osChildExitActions safeRemoveKey:eachPid.
            ] ifFalse:[
                hasPids := true.
            ].
        ].
        hasPids ifTrue:[
            exceptArray := (exceptArray upTo:nil), osChildExitActions keys asArray.
"/'exceptArray: ' print. exceptArray printCR.
        ].
    ].

    exceptResultFdArray size < exceptArray size ifTrue:[
        exceptResultFdArray := Array new:(40 max:exceptArray size).
    ].

    nReady := OperatingSystem
                selectOnAnyReadable:readFdArray
                writable:writeFdArray
                exception:exceptArray
                readableInto:readableResultFdArray
                writableInto:writableResultFdArray
                exceptionInto:exceptResultFdArray
                withTimeOut:millis.

    wasBlocked ifTrue:[
        OperatingSystem blockInterrupts.
    ].

    nReady <= 0 ifTrue:[
        "/ either still nothing to do,
        "/ or error (which should not happen)

        (nReady < 0 and:[(err := OperatingSystem lastErrorSymbol) notNil]) ifTrue:[
            err == #EBADF ifTrue:[
                "/ mhmh - one of the fd's given to me is corrupt.
                "/ find out which one .... and remove it
                self removeCorruptedFds
            ] ifFalse:[
                err == #ENOENT ifTrue:[
                    'Processor [warning]: ENOENT in select; rd=' infoPrint.
                    readFdArray infoPrint. ' wr=' infoPrint. writeFdArray infoPrintCR.
                ] ifFalse:[
                    'Processor [warning]: error in select: ' infoPrint. err infoPrintCR.
                ]
            ].
        ]
    ] ifFalse:[
        readyIndex := 1.
        [nReady > 0
             and:[ readyIndex <= readableResultFdArray size
             and:[ (fd := readableResultFdArray at:readyIndex) notNil ]]
        ] whileTrue:[
            index := readFdArray identityIndexOf:fd.
            index ~~ 0 ifTrue:[
                action := readCheckArray at:index.
                sema := readSemaphoreArray at:index.
                sema notNil ifTrue:[
                    sema signalOnce.
                    newProcessMaybeReady := true.
                    action isNil ifTrue:[
                        "before May 2014 we disabled the sema in the caller after wakeup.
                         This caused ST/X to consume 100% cpu, when the caller didn't read
                         the data (e.g. because his process was stopped)."
                        "disable possible write side and timeouts as well"
                        self disableSemaphore:sema.
                    ].
                ].
                (action notNil and:[action value]) ifTrue:[
                    newProcessMaybeReady := true.
                ].
            ].
            nReady := nReady - 1.
            readyIndex := readyIndex + 1.
        ].

        readyIndex := 1.
        [nReady > 0
             and:[ readyIndex <= writableResultFdArray size
             and:[ (fd := writableResultFdArray at:readyIndex) notNil ]]
        ] whileTrue:[
            index := writeFdArray identityIndexOf:fd.
            index ~~ 0 ifTrue:[
                action := writeCheckArray at:index.
                sema := writeSemaphoreArray at:index.
                sema notNil ifTrue:[
                    sema signalOnce.
                    newProcessMaybeReady := true.
                    action isNil ifTrue:[
                        "now this is a one shot operation - see the input above"
                        "disable possible read side and timeouts as well"
                        self disableSemaphore:sema.
                    ].
                ].
                (action notNil and:[action value]) ifTrue:[
                    newProcessMaybeReady := true.
                ].
            ].
            nReady := nReady - 1.
            readyIndex := readyIndex + 1.
        ].

"/'except result got: ' print. exceptArray printCR. exceptResultFdArray printCR.
        readyIndex := 1.
        [nReady > 0
             and:[ readyIndex <= exceptResultFdArray size
             and:[ (fdOrPid := exceptResultFdArray at:readyIndex) notNil ]]
        ] whileTrue:[
"/'except got: ' print. fdOrPid printCR.
            index := exceptFdArray identityIndexOf:fdOrPid.
            index ~~ 0 ifTrue:[
                sema := exceptSemaphoreArray at:index.
                sema notNil ifTrue:[
                    sema signalOnce.
                    newProcessMaybeReady := true.
                    "disable possible read/write side and timeouts as well"
                    self disableSemaphore:sema.
                ].
            ] ifFalse:[ "may be a PID?"
                |osProcessStatus actionBlock|

                actionBlock := osChildExitActions removeKey:fdOrPid ifAbsent:nil.
"/'pid signaled: ' print. fdOrPid printCR.
                actionBlock notNil ifTrue:[
                    osProcessStatus := OperatingSystem childProcessWait:false pid:fdOrPid.
                    (osProcessStatus notNil and:[osProcessStatus pid = fdOrPid]) ifTrue:[
                        actionBlock value:osProcessStatus.
                        newProcessMaybeReady := true.
                    ].
                ].
            ].
            nReady := nReady - 1.
            readyIndex := readyIndex + 1.
        ].
    ].
    ^ newProcessMaybeReady

    "Modified: / 12-04-1996 / 09:31:22 / stefan"
    "Modified: / 07-12-2006 / 19:48:17 / cg"
!

ioInterrupt
    "{ Pragma: +returnable }"

    "data arrived while waiting - switch to scheduler process which will decide
     what to do now.
     This method is called by the VM' interrupt handling mechanism.
     Notice, that at the time of the message, we are still in the context
     of whichever process is currently running."

    gotIOInterrupt := true.
    activeProcess ~~ scheduler ifTrue:[
	interruptCounter := interruptCounter + 1 bitAnd:SmallInteger maxVal.
	interruptedProcess := activeProcess.
	self threadSwitch:scheduler
    ]

    "Modified: 21.12.1995 / 16:17:40 / stefan"
    "Modified: 4.8.1997 / 14:23:08 / cg"
!

removeCorruptedFds
    "this is sent when select returns an error due to some invalid
     fileDescriptor. May happen, if someone does a readWait/writeWait on a
     socket connection, which somehow got corrupted
     (shutdown by partner, or closed by another thread, while being in a read/write-wait).
     Without special care, all following selects would immediately return with
     an #EBADF error, leading to high-frequency polling and a locked up system.
     (you could still fix things by interrupting on the console and fixing the
      readFdArray/writeFdArray in the debugger)"

    readFdArray keysAndValuesDo:[:idx :fd |
	|result sema|

	fd notNil ifTrue:[
	    result := OperatingSystem
			selectOnAnyReadable:(Array with:fd) writable:nil exception:nil
			   readableInto:nil writableInto:nil exceptionInto:nil
			   withTimeOut:0.

	    result < 0 ifTrue:[
		'Processor [info]: removing invalid read-select fileDescriptor: ' infoPrint. fd infoPrint. ' idx: 'infoPrint. idx infoPrintCR.
		readFdArray at:idx put:nil.
		readCheckArray at:idx put:nil.
		(sema := readSemaphoreArray at:idx) notNil ifTrue:[
		    readSemaphoreArray at:idx put:nil.
		    self removeTimeoutForSemaphore:sema.
		    sema signalForAll.
		].
	    ]
	].
    ].

    writeFdArray keysAndValuesDo:[:idx :fd |
	|result sema|

	fd notNil ifTrue:[
	    result := OperatingSystem
			selectOnAnyReadable:nil writable:(Array with:fd) exception:nil
			   readableInto:nil writableInto:nil exceptionInto:nil
			   withTimeOut:0.

	    result < 0 ifTrue:[
		'Processor [info]: removing invalid write-select fileDescriptor: ' infoPrint. fd infoPrint. ' idx: 'infoPrint. idx infoPrintCR.
		writeFdArray at:idx put:nil.
		writeCheckArray at:idx put:nil.
		(sema := writeSemaphoreArray at:idx) notNil ifTrue:[
		    writeSemaphoreArray at:idx put:nil.
		    self removeTimeoutForSemaphore:sema.
		    sema signalForAll.
		].
	    ]
	]
    ].

    exceptFdArray keysAndValuesDo:[:idx :fd |
	|result sema|

	fd notNil ifTrue:[
	    result := OperatingSystem
			selectOnAnyReadable:nil writable:nil exception:(Array with:fd)
			   readableInto:nil writableInto:nil exceptionInto:nil
			   withTimeOut:0.

	    result < 0 ifTrue:[
		'Processor [info]: removing invalid exception-select fileDescriptor: ' infoPrint. fd infoPrint. ' idx: 'infoPrint. idx infoPrintCR.
		exceptFdArray at:idx put:nil.
		(sema := exceptSemaphoreArray at:idx) notNil ifTrue:[
		    exceptSemaphoreArray at:idx put:nil.
		    self removeTimeoutForSemaphore:sema.
		    sema signalForAll.
		].
	    ]
	]
    ].


    OperatingSystem isMSWINDOWSlike ifTrue:[
	"/
	"/ win32 does a WaitForMultipleObjects in select...
	"/ unix waits for SIGCHLD
	"/
	osChildExitActions keysDo:[:eachPid |
	    |result sema|

	    eachPid notNil ifTrue:[
		result := OperatingSystem
			    selectOnAnyReadable:nil writable:nil exception:(Array with:eachPid)
			       readableInto:nil writableInto:nil exceptionInto:nil
			       withTimeOut:0.

		result < 0 ifTrue:[
		    'Processor [info]: removing invalid exception-select pid: ' infoPrint. eachPid infoPrintCR.
		    osChildExitActions safeRemoveKey:eachPid.
		]
	    ]
	].
    ].

    "Modified: 12.4.1996 / 09:32:58 / stefan"
    "Modified: 27.1.1997 / 20:09:27 / cg"
!

schedulerInterrupt
    "forced reschedule - switch to scheduler process which will decide
     what to do now."

    activeProcess ~~ scheduler ifTrue:[
	interruptCounter := interruptCounter + 1 bitAnd:SmallInteger maxVal.
	interruptedProcess := activeProcess.
	self threadSwitch:scheduler
    ]
!

timeToNextTimeout
    "return the delta-T (in millis) to next timeout, or nil if
     there is none"

    |aTime now delta minDelta n "{ Class: SmallInteger }"|

    "find next timeout. since there are usually not many, just search.
     If there were many, the list should be kept sorted ... keeping deltas
     to next (as in Unix kernel)"

    n := timeoutArray size.
    1 to:n do:[:index |
	aTime := timeoutArray at:index.
	aTime notNil ifTrue:[
	    now isNil ifTrue:[
		now := OperatingSystem getMillisecondTime.
	    ].
	    delta := OperatingSystem millisecondTimeDeltaBetween:aTime and:now.
	    delta <= 0 ifTrue:[
		^ 0.
	    ].
	    minDelta isNil ifTrue:[
		minDelta := delta
	    ] ifFalse:[
		minDelta := minDelta min:delta
	    ]
	]
    ].
    minDelta isNil ifTrue:[
	"this is safe, since always called with interruptsBlocked"
	anyTimeouts := false.
    ].

    ^ minDelta
!

timerInterrupt
    "{ Pragma: +returnable }"

    "timer expired while waiting - switch to scheduler process which will decide
     what to do now.
     This method is called by the VM' interrupt handling mechanism.
     Notice, that at the time of the message, we are still in the context
     of whichever process is currently running."

    activeProcess ~~ scheduler ifTrue:[
	interruptCounter := interruptCounter + 1 bitAnd:SmallInteger maxVal.
	interruptedProcess := activeProcess.
	self threadSwitch:scheduler
    ]

    "Modified: 18.10.1996 / 20:35:54 / cg"
!

waitForEventOrTimeout
    "entered when no process is runnable - wait for either input on
     any file descriptors to arrive or a timeout to happen.
     If it makes sense, do some background garbage collection.
     The idle actions are a leftover from previous ST/X releases and will
     vanish (installing a low-prio process has the same effect)."

    |millis doingGC dT|

    doingGC := true.
    [doingGC] whileTrue:[
        anyTimeouts ifTrue:[
            millis := self timeToNextTimeout.
            (millis notNil and:[millis <= 0]) ifTrue:[
                ^ self    "oops - hurry up checking"
            ].
        ].

        "
         if its worth doing, collect a bit of garbage;
         but not, if a backgroundCollector is active
        "
        ObjectMemory backgroundCollectorRunning ifTrue:[
            doingGC := false
        ] ifFalse:[
            doingGC := ObjectMemory gcStepIfUseful.
        ].

        "then do idle actions"
        (idleActions notNil and:[idleActions size ~~ 0]) ifTrue:[
            idleActions do:[:aBlock |
                aBlock value.
            ].
            ^ self   "go back checking"
        ].

        doingGC ifTrue:[
            (self checkForIOWithTimeout:0) ifTrue:[
                ^ self  "go back checking"
            ]
        ]
    ].

    exitWhenNoMoreUserProcesses ifTrue:[
        "/ check if there are any processes at all
        "/ stop dispatching if there is none
        "/ (and anyTimeouts is false, which means that no timeout blocks are present)
        "/ and no readSemaphores are present (which means that noone is waiting for input)
        "/ and no writeSemaphores are present
        
        "/ cg: changed to only check when a process terminated
        "/ self checkForEndOfDispatch.
        dispatching ifFalse:[
            ^ self
        ].
    ].

    preWaitActions notNil ifTrue:[
        preWaitActions do:[:action | action value].
    ].

    "/
    "/ absolutely nothing to do - simply wait
    "/
    OperatingSystem supportsSelect ifFalse:[
        "SCO instant ShitStation has a bug here,
         waiting always 1 sec in the select - therefore we delay a bit and
         return - effectively polling in 50ms cycles
        "
        (self checkForIOWithTimeout:0) ifTrue:[
            ^ self  "go back checking"
        ].
        OperatingSystem millisecondDelay:EventPollingInterval.
        ^ self
    ].

    useIOInterrupts ifTrue:[
        dT := 999999
    ] ifFalse:[
        dT := EventPollingInterval
    ].

    millis isNil ifTrue:[
        millis := dT.
    ] ifFalse:[
        millis := millis rounded min:dT.
    ].

    self checkForIOWithTimeout:millis

    "Modified: 14.12.1995 / 13:37:46 / stefan"
    "Modified: 18.7.1996 / 20:42:17 / cg"
! !

!ProcessorScheduler class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ProcessorScheduler initialize!

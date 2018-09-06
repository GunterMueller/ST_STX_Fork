"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2010-2011 Jan Vrany
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

Object subclass:#ObjectMemory
	instanceVariableNames:''
	classVariableNames:'InternalErrorHandler UserInterruptHandler TimerInterruptHandler
		SpyInterruptHandler StepInterruptHandler
		ExceptionInterruptHandler ErrorInterruptHandler
		MemoryInterruptHandler SignalInterruptHandler
		ChildSignalInterruptHandler DisposeInterruptHandler
		RecursionInterruptHandler IOInterruptHandler
		CustomInterruptHandler RegisteredErrorInterruptHandlers
		InterruptLatencyMonitor AllocationFailureSignal
		MallocFailureSignal LowSpaceSemaphore IncrementalGCLimit
		FreeSpaceGCLimit FreeSpaceGCAmount BackgroundCollectProcess
		BackgroundFinalizationProcess FinalizationSemaphore Dependents
		ImageName ImageSaveTime ChangeFileName MaxInterruptLatency
		InterruptLatencyGoal VMSelectors DynamicCodeGCTrigger
		DynamicCodeLimit JustInTimeCompilationEnabled
		JavaJustInTimeCompilationEnabled JavaNativeCodeOptimization
		BackgroundCollectMaximumInterval SavedGarbageCollectorSettings
		FinalizerAccessLock'
	poolDictionaries:''
	category:'System-Support'
!

Object subclass:#BinaryModuleDescriptor
	instanceVariableNames:'name type id dynamic classNames handle pathName libraryName
		timeStamp'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ObjectMemory
!

!ObjectMemory primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#ifdef __linux__
// for mallinfo() etc.
# include <malloc.h>
#endif
%}
! !

!ObjectMemory class methodsFor:'documentation'!

caching
"
    The system uses various caches to speed up method-lookup.
    Currently, there is a three-level cache hierarchy:

	inline-cache            keeps the target of the last send at the caller-
				side (i.e. every send goes through its private
				1-slot inline-cache, where the address of the last
				called function at this call location is kept.)

	polymorph-inline-cache  keeps a limited list of all targets ever reached
				at this call location. The list is automatically
				flushed if it grows too large, or the overall number
				of poly-chache entries exceeds a limit.

	method-lookup-cache     a global cache. Hashes on class-selector pairs,
				returning the target method.

    Whenever methods are added or removed from the system, or the inheritance
    hierarchy changes, some or all caches have to be flushed.
    The flushXXX methods perform the task of flushing various caches.
    All standard methods in Behavior call for cache flushing, when things change;
    however, if you use the low level access methods in Behavior
    (for example: #setSuperclass:) special care has to be taken.

    In some situations, not all caches need flushing, for example a change
    in an interpreted method (currently) needs no flushing of the inline caches.
    Also, flushing can be limited to entries for a specific class for most changes.

    To be 'on the brigth side of live', use ObjectMemory>>flushCaches (which
    flushes all of them), when in doubt of which caches should be flushed.
    It is better flush too much - otherwise you may end up in a wrong method after
    a send (you wont really see a difference in speed after the flush, anyway).
"
!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2010-2011 Jan Vrany
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
    This class contains access methods to the system memory and the VM.

    In previous ST/X versions, this stuff used to be in the Smalltalk class.
    It has been separated for better overall class structure and modularisation.
    There are no instances of ObjectMemory - all is done in class methods.
    (this is a functional interface).

    Many methods here are for debuging purposes, for developers
    or experimental, and therefore not standard.
    Do not depend on them being there - some may vanish ...
    (especially those, that depend on a specific GC implementation)
    Most of the stuff found here is not available, or different or called
    different in other smalltalk implementations. Be aware, that using these
    interfaces (especially: depending on them) may make your application
    non portable.

    See more documentation in -> caching
			      -> interrupts
			      -> garbageCollection

    [Class variables:]

	InternalErrorHandler            gets informed (by VM), when some runtime
					error occurs (usually fatal)

	UserInterruptHandler            gets informed (by VM) when CNTL-C is pressed
	TimerInterruptHandler           gets alarm timer interrupts (from VM)
	SpyInterruptHandler             another alarm timer (from VM)
	StepInterruptHandler            gets single step interrupts (from VM)
	ExceptionInterruptHandler       gets floating point exceptions (from VM)
	ErrorInterruptHandler           gets primitive errors (from VM)
	MemoryInterruptHandler          gets soon-out-of-memory conditions (from VM)
	SignalInterruptHandler          gets unix signals (from VM)
	ChildSignalInterruptHandler     gets child death signals (from VM)
	DisposeInterruptHandler         gets informed, when an object is disposed from
					a shadowArray (from VM)
	RecursionInterruptHandler       gets recursion limit violations (from VM)
	IOInterruptHandler              gets SIGIO unix signals (from VM)
	CustomInterruptHandler          gets custom interrupts (from VM)

	InterruptLatencyMonitor         if nonNil, that one will be notified (by the VM)
					with an interruptLatency:millis message for every
					interrupt and gets the delay time
					(between the time when the signal arrived and
					 when it was really delivered) as argument.
					This can be used to create a statistic for
					realtime systems.

	RegisteredErrorInterruptHandlers
					associates errorID (as passed from primitive
					to the __errorInterruptWithID() function)
					with handlers.

	IncrementalGCLimit              number of bytes, that must be allocated since
					last full garbage collect to turn the incremental
					collector on (at idle time).

	FreeSpaceGCLimit                low limit on freeSpace, at which incremental
					gc starts to run at idle time.

	FreeSpaceGCAmount               amount to allocate, once freeSpace drops
					below FreeSpaceGCLimit

	DynamicCodeGCTrigger            amount of generated dynamically compiled code
					to trigger the incremental garbage collector
					nil means: no trigger

	DynamicCodeLimit                max. amount of space allocated for dynamically compiled code
					nil means: unlimited.

	JustInTimeCompilationEnabled    boolean - enables/disables JIT-compilation of
					bytecode to machine code.
					(this has nothing to do with stc-compilation)

	Dependents                      keep my dependents locally (its faster) for
					all those registries

	LowSpaceSemaphore               a semaphore signalled whenever the system is
					running in low memory (i.e. the memory manager
					ran into memory shortage and feels that it
					may soon no longer be able to grant allocation requests).
					You can have a process waiting on this semaphore
					which starts to remove (i.e. nil-out) objects
					or preform other cleanup actions.

	AllocationFailureSignal         signal raised when a new fails (see Behavior)
					When this signal is raised, the memory manager
					is really in trouble (i.e. above low-mem feelings
					were correct)

	MallocFailureSignal             signal raised when a malloc fails
					mallocs are used internally in the VM and/or
					by some classes (ExternalBytes)

	BackgroundCollectProcess        created by startBackgroundCollectorAt:

	BackgroundFinalizationProcess   created by startBackgroundFinalizationAt:

	BackgroundCollectMaximumInterval
					number of seconds after which an incremental background
					collection is started - regardless of the allocation
					rate or freeSpace situation. If nil, IGC is only done
					when the space situation makes it feasable.
					Can be set to (say) 3600, to have the memory cleaned
					at least once an hour.

	FinalizationSemaphore           triggered by the VM, when any weak pointer is
					lost. Been waited upon by the backgroundFinalizer.

	ImageName                       name of the current image (or nil)

	ImageSaveTime   <Timestamp>  timestamp when this image was saved


    Warning:
      The InterruptHandler variables are known by the runtime system -
      they are the objects that get an interrupt message when the event
      occurs. You may not remove any of them.

    [author:]
	Claus Gittinger
"
!

garbageCollection
"
    Currently, Smalltalk/X uses a two-level memory hierachy (actually, there
    are more memory regions used for stack, permanent objects, symbols etc.
    but for the following discussion, these are not of interest).

  newSpace:

    Objects are created in a so-called newSpace, which is relatively small.
    This newSpace is cleaned by a so called ``scavenge''-operation, whenever
    becoming full. Scavenging means, that all still-live objects (i.e. referenced
    by some other) are copied over to another memory area, leaving all unreachable
    objects as garbage behind. Thus, the newSpace actually consists of two semispaces,
    of whih only one is active - the other being used only while objects are
    copied.
    After this copying, these two semispaces exchange their roles - i.e. reachable
    objects are copied ping-pong like between these semispaces.
    Once an object survives enough of these copying operations, the next scavenge
    will move it into the so called oldSpace, which is much larger, and not
    processed by the scavenger.
    This movement of an object from newSpace to oldSpace is called ``tenure''.
    (this avoids objects being copied around forever).
    Once tenured, an object is no longer contained in the newSpace, and
    thus ceases to create any scavenging overhead after that.

    Scavenging occurs automatically, and is usually done fast enough to go
    unnoticed (typically, it takes some 5 to 40ms to perform a scavenge,
    depending on how many live objects are in the newspace).

    Interestingly, the scavenger performs better, if many garbage objects
    are to be reclaimed, since less object-copying has to be done. Therefore,
    the best-case scavenge time is almost zero, if there is only garbage in
    the newSpace.
    In contrast, the worst-case is when all newSpace objects are still living.
    Thus, garbage reclamation of young objects is basically free -
    the more garbage is in newspace, the faster is the collector, asymptotically approaching
    zero time, when all new objects are garbage!!

    From the newSpace collector's viewPoint, it makes sense to get
    objects out of the way as fast as possible. However the oldSpace is
    collected much less frequently and the cost to reclaim an oldspace object
    is much higher (actually, the cost to reclaim a newspace object is zero -
    it's the *survival* of objects which we have to pay for).
    Therefore, from an oldSpace collector's point of view, it's preferable to
    keep objects in the newSpace as long as possible.

    To honor this conflicting situation, the system uses an adaptive tenure-count,
    which adjusts the number of scavenges required for tenure (the so called
    'tenureAge') according to the fill-grade of the newSpace.
    If the newSpace is relatively empty, it tries to keep objects longer there.
    The controlling parameters of the tenure age can be changed dynamically,
    detailed information is available upon request.

    The exact speed of the scavenger depends mostly on the speed of your memory
    interface (and, since most of todays memories have access times in the order
    of 10-40ns, the raw CPU speed does not correlate linear with the GC speed).
    Measurements (1992!!) give roughly 40ms for a full 400k newSpace
    (i.e. all objects survive) on a 486/50 - this only drops to some 20-30ms on a P5.
    Big caches help - i.e. a 1Mb cache machine performs better than a 256k cache machine.
    Also, a good memory interface (small number of wait cycles and burst modes)
    help a lot.

    The upper bounds of the scavenge blocking time can be controlled by changing
    the size of the newSpace - either via a command line argument, or even dynamically
    by Objectmemory>>newSpaceSize:. Smaller sizes lead to shorter blocking periods,
    but greater absolute GC overhead. The default (400k) seems to be a good compromise.
    (if you are not happy with it, try playing around with the settings)

  oldSpace:

    To reclaim oldspace, the system uses three algorithms: mark&sweep, a copying
    (and compressing) baker-type collector and an incremental mark&sweep&compress.

    The blocking mark&sweep runs whenever the oldspace becomes full and the oldSpace
    limit has been reached (i.e. it prefers to map more pages to the oldSpace up to an
    adjustable limit). It puts dead objects onto a free list.
    If a memory request cannot be served from this freelist,
    and the total size of objects on the freelist exceeds a threshold (actually: the fragmentation does so),
    the system will compress the oldspace to make the free-space into one big area.
    This compress is either done by a 1-pass semispace copy algorithm, or
    a 2pass inplace compress - depending on the setting of the compress limit
    (if lots of virtual address space is available, a 1-pass algorithm is chosen).

    The 1pass algorithm copies all live objects into a newly allocated
    area, and frees the previous memory afterwards (a baker style copying collector).
    The 2pass algorithm moves objects inPlace, and adjusts the pointers in
    a second pass.
    The 1pass algorithm requires twice the amount of memory (virtually) and is
    slightly faster, if enough real memory is available.
    In memory limited systems, the 2pass algorithm generally performs better,
    since it is less affected by paging.
    To honor this situation, the compressLimit should be set to enforce the
    2-pass algorithm if the oldSpace size exceeds a certain threshold.

    We recommend setting the compressLimit to roughly 1/4th of the physical
    memory size of the machine, if other programs are to run beside ST/X
    (i.e. an XServer, some xterms etc.).
    If ST/X is running almost alone (i.e. using an XTerminal), the compressLimit
    can be set to 1/3rd of the physical memory.
    This is only a rough estimate - you may want to play around with this
    parameter, to find a value which avoids paging due to a 1pass compress.

    Since a compressing oldspace collect leads to a noticable pause of the system,
    the memory manager tries hard to avoid oldspace compression.
    (well, if enough real memory is available to hold both spaces in physical
     memory, the compress algorithms are actually pretty fast).

    The incremental mark&sweep runs in the background, whenever the system is idle
    (see ProcessorSceduler>>waitForEventOrTimeout), or alternatively as a low or high
    priority background process (see ObjectMemory>>startBackgroundCollector).
    Like the normal mark&sweep, this incremental collector follows object references
    and marks reachable objects on its way.
    However, this is done 'a few objects-at-a-time', to not disrupt the system noticably.
    Currently, there are some (theoretical) and in practice never occurring situations,
    in which the incremental GC still creates noticable delays.
    A current project is involved with this and a future version of ST/X (ST/X-RT)
    will be available which shows deterministic worst case behavior in its GC pauses
    (this will be provided as an additional add-on option - certainly not for free ;-).

    Currently (1995), incremental GC blockings are in the order of 10-70ms.
    There is one catch with low priority background IGC: if there is never any idle
    time available (i.e. all processes run all the time), it would never get a chance
    to do any collection work.
    To handle this case, a background IGC can either be started as a high priority
    process, which gives up the cpu (by delaying on the time) after every IGC step,
    or it can be gicen a dynamic priority, where the max-prio is above UserSchedulingPriority.
    A high priority background collector will always make progress and eventually finish
    a GC cycle. However, it may have more of an influence on the other processes.
    The default setup to date is to give it a dynamic priority, so it is ensured to make some
    progress - although sometimes only slowly.
    So, its up to you, to decide ...

    Incremental garbage collection is controlled by the variables
    'IncrementalGCLimit', 'FreeSpaceGCLimit' and 'FreeSpaceGCAmount':

      the ProcessorScheduler will perform incremental GC steps at idle time,
      if the total space allocated since the last full collect exceeds
      'IncrementalGCLimit',
      or if there are less than 'FreeSpaceGCLimit' bytes available in free store.
      If after the incrementalGC, less than 'FreeSpaceGCLimi't bytes are available,
      'FreeSpaceGCAmount' more bytes are requested from the memory manager.

    The defaults are set in ObjectMemory>>initialize and can be changed in your
    startup 'smalltalk.rc'-file. Setting them to nil turns incremental GC off.


    For example, setting 'IncrementalGCLimit' to 500000 will start the background collector
    whenever 500k bytes have been allocated - usually very seldom. Setting it to some
    small number (say 10000) will have it run very often.

    Setting 'FreeSpaceGCAmount' to (say) 1meg lets the system try to always keep
    1meg of freeSpace. If less memory is available, more oldSpace will be allocated.
    Keeping some memory in the pocket may prevent the system from running into a blocking
    GC if memory is allocated in peaks (but only, if the incremental GC can keep up with
    allocation rate). The trigger level 'FreeSpaceGCLimit' should be below that amount;
    to avoid excessive incremental GC activity (say 1/4 if the amount).

    Having the background GC running often should not hurt the performance of your
    smalltalk processes, since the IGC only runs at times when no ST processes are runnable.
    (there are some short delays in event processing, since the IGC's steps may take
    some XX ms.)
    However, if you are not alone on your machine (i.e. a timesharing system) or
    you have other Unix processes to run, you should not run the IGC too often,
    since it may hurt OTHER users/unix processes.

    Since this collector only runs at idle times, even a low priority background
    process will prevent it from doing its work. You may want to start a somewhat
    higher priority background collect (say at prio 4), which also preempts these
    background processes. (see ObjectMemory>>startBackgroundCollectorAt:).

    Beginning with 2.10.4, a third space, called symSpace has been added.
    Objects in this space are never moved or garbage collected.
    This space is (currently) used for symbols only.

    Beginning with 2.10.5, a fourth space, called fixSpace has been added.
    Objects in this space are never moved or garbage collected.
    This space is used for constant objects (true, false, some basic classes etc.).

    A plan for 2.11 is to offer an arbitrary number of spaces, which can be
    attached and detached at runtime. This will allow easy share of object
    with remote systems and separating objects into a per application/package
    space. (be prepared for changes in the future and make your application
    independ of the VM internals)

  default setup:

    The following table lists some default settings and means for changing them;
    Notice, that the defaults below are those of the VM and or ObjectMemory class.
    These may already be changed by a smalltalk.rc or private.rc startup file.

	    what        default     change by
				    command line arg    dynamically
    -----------------------------------------------------------------------
	newSpace size     400k      -Mnew nnn           newSpaceSize:nnn

	oldSpace size    3000k      -Mold nnn           moreOldSpace:
							announceSpaceNeed:
							collectGarbage

	max tenure age     29                           lockTenure:
							avoidTenure:
							(sets it to infinity)

	adaptive tenure     -       -                   tenureParameters

	2pass oldSpace
	compressor      enabled     -Msingle            -

	limit for 1pass
	old-compress     8000k      -                   oldSpaceCompressLimit:

	chunk size
	to increase
	oldSpace          256k      -                   oldSpaceIncrement:

	prefer moreOld
	to doing GC      false      -                   fastMoreOldSpaceAllocation:

	limit for
	above                -      -                   fastMoreOldSpaceLimit:

	keep size for        -      -                   freeSpaceGCAmount:
	IGC

	low water
	trigger for IGC      -      -                   freeSpaceGCLimit:

	allocated
	trigger for IGC   500k      -                   incrementalGCLimit

	maximum time
	interval between
	IGC's                -      -                   BackgroundCollectMaximumInterval

	JIT codeCache
	size            unlimited   -                   dynamicCodeLimit:

	new JIT code
	trigger for IGC   none      -                   dynamicCodeGCTrigger:


    By default, no incremental GC is started by the system; however,
    the standard startup script starts a low prio background incremental GC process.
    You have to edit your startup files to change this.
    A suggested configuration (used by the author and the default) is:

	' keep 1meg in the pocket '

	ObjectMemory freeSpaceGCAmount:1000000.

	' start incrementalGC when freespace drops below 250k '
	' or 500k of oldSpace has been allocated              '

	ObjectMemory freeSpaceGCLimit:250000.                 '
	ObjectMemory incrementalGCLimit:500000.               '

	' collect as a background process (the default is: at idle times)
	' this means that running cubes or other demo processes are suspended
	' for the collect; change the prio to below 4 if you want them to continue

	ObjectMemory startBackgroundCollectorAt:5.            '
	ObjectMemory startBackgroundFinalizationAt:5.         '

	' quickly allocate more space (i.e. avoid blocking collects)
	' up to 8meg - then start to collect if more memory is needed.

	ObjectMemory fastMoreOldSpaceLimit:8*1024*1024.       '
	ObjectMemory fastMoreOldSpaceAllocation:true.         '

  hints & tricks:

    normally, there is no need to call for an explicit garbage collection, or
    modify the default parameters.
    The memory system should adapt reasonable and provide good performance
    for a wide range of allocation patterns (see Example3 below for an exception).

    However, there may be situations, in which hints and/or explicit
    control over allocation can speedup your programs; but please:

      - if you think you have to play around with the memory policies,
	first check your program - you may find useless allocations
	or bad uses of collections. A typical error that is made is to
	create large collections using the #, (comma) concatenation method,
	which shows square behavior, since it allocates many, many temporary
	collections. Also, watch out for #copyWith:, #add: etc.
	All of these create a new collection. Remember, that most collections
	offer methods to preallocate some space; for example, 'Set new:' creates
	an empty set, but preallocates space to avoid resizing over and over.

	An especially bad performace dog is to use #add: on fix-size collection
	objects (such as Strings or Arrays), since in addition to allocating
	lots of garbage, a #become: operation is required for EACH element
	added. NEVER use Arrays for growing/shrinking data - use OrderedCollection
	instead. (if you really need an array, use asArray afterwards)

      - if you are going to allocate huge data structures, think about
	optimizing space. For example, if you allocate a million instances of
	some object, each added instance variable makes up 4Mb of additional
	memory need.
	Also, for Byte-valued, Integer-valued and Float like objects, special
	collections are provided, which store their values directly inside (instead
	of a reference to the object). A FloatArray consisting of 1 million floats
	requires about 4mb of memory, while an Array of Floats requires 4mb for the
	references to the floats, PLUS 20Mb for the floats themself.

      - check if you really need fast access to all of these objects; you may
	try to only keep some subset in memory, and use binary storage or
	(if this is too slow) optimized store/retrieve methods and keep the bigger
	part in a file.
	(How about a DiskArray class, which does this transparently ?
	 See the FileText class for some ideas and something to start with ...)


    Hint / Example 1:
      you are about to allocate a huge data structure, which is known to
      survive long. In this case, it is better to have these objects move into the
      oldspace sooner, to avoid the copying overhead during scavenges.

      To do this, you can call ObjectMemory>>tenure after allocation, which
      forces all new-objects immediately into the oldspace.
      Make certain, that not to many (ideally no) short-living objects are in the
      newspace when doing this.

      Another alternative is to tell the system that all allocation should be
      done directly in the oldspace. This completely avoids the scavenging overhead
      for these objects. To do so, use ObjectMemory>>turnGarbageCollectorOff
      before the allocation, and ObjectMemory>>turnGarbageCollectorOn afterwards.
      Keep in mind, that do-loops may allocate block-objects and other temporaries,
      so there is a danger of making things worse due to having all those temporaries
      in the oldspace afterwards. (which is not a fatal situation, but will
      force the system to do an oldspace collect earlier, which may not be your
      intention).


   Hint / Example 2:
      you know in advance, that a certain (big) amount of memory will be needed.
      For example, the fileBrowser wants to show a huge file in its text-view.
      In this case, it is better to tell the memory system in advance, how much
      memory will be needed, since otherwise many compresses and reallocations will
      occur (the memory system will allocate additional memory in chunks of smaller
      256k pieces, if a compress failes. Thus, if you are going to allocate (say) 1Mb of
      strings, it will perform 5 compressing GC's).

      This is done using ObjectMemory>>moreOldSpace: or ObjectMemory announceSpaceNeed:.
      In the above example, you would do 'ObjectMemory announceSpaceNeed:500000', which
      avoids those annoying 5 compressing GC's.
      BTW: if you have other smalltalk processes (threads) running which should not be
      paused if possible, it is better to use #announceSpaceNeed. This tries to avoid
      pausing in other processes and sometimes succeeds, while moreOldSpace will always
      block the whole system for a while. However, there is no 'no-pause' guarantee.

      The amount of automatic increase (in case the oldSpace becomes full) is 256k by
      default. This number can be changed with ObjectMemory>>oldSpaceIncrement:.


    Hint / Example3:
      There are rare cases, when an explicit GC makes a difference: since
      object finalization is done at GC time, objects which keep operatingSystem
      resources may be finalized late. This is normally no problem, except if
      the system is running out of resources. For example, allocating new colors
      may fail if many colors have already been allocated in the past - even
      though these colors are actually free. The Depth8Image calls for an
      explicit GC, whenever it fails to allocate a color for a bitmap, to force
      finalization of free, but not yet finalized colors.
      The same is true for things like file descriptors, if fileStreams are not closed
      correctly.

    Hint 4:
      If you run in too small of physical memory, the incremental GC may have a
      bad effect on your working set: since it touches pages (which may otherwise
      not be needed at the moment, the operating system is forced to steal other
      (possibly more useful) pages from your set of incore pages.
      Although ST/X would be willing to fix this behavior (by telling the OS about
      its page requirements, many OS's do not listen. The SGI-Iris, For example ignores
      the madvice system calls - other systems do not implement it.
      The trouble is that the standard LRU paging strategy is exactly the worst for
      a program which sequentially scans its memory once in a single direction ...
      You may get better performance, if you turn off the incremental GC while
      processing a big data structure.


    Warning: many of the methods found here are not standard and may not even be available in
    future versions of ST/X. Use them only in very special situations or experiments.

    Let me know about additional special features you think are useful, and about
    special features you are using - this provides the feedback required to decide
    which methods are to be removed, kept or enhanced in future versions.
"
!

interrupts
"
    Handling of interrupts (i.e. unix-signals) is done via handler objects, which
    get a #XXXInterrupt-message sent. This is more flexible than (say) signalling
    a semaphore, since the handler-object may do anything to react on the signal
    (of course, it can also signal a semaphore to emulate the above behavior).

    Another reason for having handler objects is that they allow interrupt handling
    without any context switch, for high speed interrupt response.
    However, if you do this, special care is needed, since it is not defined,
    which (smalltalk-)process gets the interrupt and will do the processing
    (therefore, the default setup installs handlers which simply signal a semaphore
     and continue the current process).

    Typically, the handlers are set during early initialization of the system
    by sending 'ObjectMemory XXXInterruptHandler:aHandler' and not changed later.
    (see Smalltalk>>initialize or ProcessorScheduler>>initialize).
    To setup your own handler, create some object which responds to #xxxInterrupt,
    and make it the handler using the above method.

    Interrupt messages sent to handlers are:
	internalError:<someString>      - internal interpreter/GC errors
	userInterrupt                   - ^C interrupt
	customInterrupt                 - custom interrupt
	ioInterrupt                     - SIGIO interrupt
	timerInterrupt                  - alarm timer (SIGALRM)
	errorInterrupt:<id>             - errors from other primitives/subsystems
					  (DisplayError)
	spyInterrupt                    - spy timer interrupt (SIGVTALARM)
	stepInterrupt                   - single step interrupt
	disposeInterrupt                - finalization required
	recursionInterrupt              - recursion (stack) overflow
	memoryInterrupt                 - soon running out of memory
	fpExceptionInterrupt            - floating point exception (SIGFPE)
	childSignalInterrupt            - death of a child process (SIGCHILD)
	signalInterrupt:<number>        - unix signal (if other than above signals)

    To avoid frustration in case of badly set handlers, these messages
    are also implemented in the Object class - thus anything can be defined
    as interrupt handler. However, the VM will not send any
    interrupt message, if the corresonding handler object is nil
    (which means that nil is a bad choice, if you are interested in the event).

    Interrupt processing is not done immediately after the event arrives:
    there are certain ``save-places'' at which this handling is performed
    (message send, method return and loop-heads).
    If not explicitely enabled, primitive code is never interrupted.
    However, if you do enable interrupts in your primitive (see ExternalStream as example),
    be prepared for your objects to move around ... therefore, these have to
    be coded very carefully.

    Interrupts may be disabled completely (OperatingSystem blockInterrupts) and
    reenabled (unblockInterrupts) to allow for critical data to be manipulated.
    The above are low-level primitive entries - you better use #valueUninterruptably,
    which cares for unwinds, long returns and restores the blocking state.

    Every process has its own interrupt-enable state which is switched
    when processes switch control (i.e. you cannot block interrupts across
    a suspend, delay etc.).
    However, the state will be restored after a resume.
"
! !

!ObjectMemory class methodsFor:'initialization'!

initialize
    "initialize the class"

    "/ protect against double initialization
    AllocationFailureSignal isNil ifTrue:[
        AllocationFailureSignal := AllocationFailure.
        AllocationFailureSignal notifierString:'allocation failure'.

        MallocFailureSignal := MallocFailure.
        MallocFailureSignal notifierString:'(malloc) allocation failure'.

        LowSpaceSemaphore := Semaphore new name:'LowSpaceSemaphore'.
        FinalizerAccessLock := Semaphore forMutualExclusion.
        
        DisposeInterruptHandler := self.

        "/ BackgroundCollectMaximumInterval := 3600.     "/ run it at least once an hour
        BackgroundCollectMaximumInterval := nil.      "/ only run when space situation makes it feasable
        IncrementalGCLimit := 500000.                 "/ run it whenever 500k have been allocated
        FreeSpaceGCLimit := FreeSpaceGCAmount := nil. "/ no minumum-freeSpace trigger.
        MemoryInterruptHandler := self.
        ExceptionInterruptHandler := self.

        VMSelectors := #( #noByteCode #invalidCodeObject #invalidByteCode #invalidInstruction
                          #tooManyArguments #badLiteralTable #receiverNotBoolean: #typeCheckError
                          #integerCheckError #wrongNumberOfArguments: #privateMethodCalled
                          #doesNotUnderstand: #invalidReturn: #invalidReturnOrRestart:
                          #userInterrupt #internalError: #spyInterrupt #timerInterrupt #stepInterrupt
                          #errorInterrupt:with: #disposeInterrupt #recursionInterrupt
                          #memoryInterrupt #fpExceptionInterrupt #signalInterrupt: #childSignalInterrupt
                          #ioInterrupt #customInterrupt #schedulerInterrupt #contextInterrupt
                          #interruptLatency:receiver:class:selector:vmActivity:id:).
    ]

    "Modified: / 5.8.1998 / 15:30:12 / cg"
! !

!ObjectMemory class methodsFor:'Compatibility-ST80'!

availableFreeBytes
    "return the amount of free memory
     (both in the compact free area and in the free lists)"

    ^ self freeSpace + self freeListSpace

    "
     ObjectMemory availableFreeBytes
    "

    "Modified: 29.1.1997 / 23:43:05 / cg"
!

bytesPerOOP
    "return the number of bytes an object reference (for example: an instvar)
     takes"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(8);    // not really true
#else
    RETURN(__mkSmallInteger(sizeof(OBJ)));
#endif
%}

    "
     ObjectMemory bytesPerOOP
    "
!

bytesPerOTE
    "return the number of overhead bytes of an object.
     i.e. the number of bytes in every objects header."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);    // not really true
#else
    RETURN(__mkSmallInteger(OHDR_SIZE));
#endif
%}

    "
     ObjectMemory bytesPerOTE
    "
!

collectGarbage
    self garbageCollect

    "
     ObjectMemory garbageCollect
    "

    "Created: / 19-07-2006 / 09:11:37 / cg"
!

compactingGC
    "perform a compacting garbage collect"

    self garbageCollect

    "Modified: 29.1.1997 / 23:43:25 / cg"
!

current
    "the 'current' ObjectMemory - that's myself"

    ^ self

    "Modified: 29.1.1997 / 23:43:39 / cg"
!

globalCompactingGC
    "perform a compacting garbage collect"

    self reclaimSymbols.
    self garbageCollect

    "Modified: / 18.6.1998 / 15:00:52 / cg"
!

globalGarbageCollect
    "perform a compacting garbage collect"

    self reclaimSymbols.

    "Created: / 18.6.1998 / 15:00:05 / cg"
    "Modified: / 18.6.1998 / 15:00:47 / cg"
!

growMemoryBy:numberOfBytes
    "allocate more memory"

    ^ self moreOldSpace:numberOfBytes

    "Modified: 29.1.1997 / 23:44:01 / cg"
!

numOopsNumBytes
    "return an array filled with the number of objects
     and the number of used bytes."

    ^ Array with:(self numberOfObjects)
	    with:(self bytesUsed)

    "
     ObjectMemory numOopsNumBytes
    "

    "Modified: 29.1.1997 / 23:44:24 / cg"
!

verboseCompactingGC
    "ST80 compatibility; same as verboseGarbageCollect"

    self verboseGarbageCollect
!

verboseGlobalCompactingGC
    "ST80 compatibility; same as verboseGarbageCollect"

    self verboseGarbageCollect
!

versionId
    "return this systems version.
     For ST80 compatibility."

    ^ Smalltalk versionString

    "Created: / 27.10.1997 / 13:51:59 / cg"
    "Modified: / 28.10.1997 / 20:06:14 / cg"
! !

!ObjectMemory class methodsFor:'Signal constants'!

allocationFailureSignal
    "return the signal raised when an object allocation failed"

    ^ AllocationFailureSignal
!

mallocFailureSignal
    "return the signal raised when malloc memory allocation failed.
     (usually, this kind of memory is used with I/O buffers or other temporary
      non-Object storage)"

    ^ MallocFailureSignal
! !

!ObjectMemory class methodsFor:'VM messages'!

debugPrinting
    "return true, if various debug printouts in the VM
     are turned on, false of off."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( STMain.DebugPrinting ? STObject.True : STObject.False);
#else
    extern int __getDebugPrinting();

    RETURN (__getDebugPrinting() ? true : false);
#endif
%}.
    "
     ObjectMemory debugPrinting
    "
!

debugPrinting:aBoolean
    "turn on/off various debug printouts in the VM
     in case of an error. For example, a double-notUnderstood
     leads to a VM context dump if debugPrinting is on.
     If off, those messages are suppressed.
     The default is on, since these messages are only printed for severe errors.
     Returns the previous setting."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	boolean prev = STMain.DebugPrinting;

	STMain.DebugPrinting = (aBoolean == STObject.True);
	return __c__._RETURN( prev ? STObject.True : STObject.False);
    }
    /* NOTREACHED */
#else
    extern int __setDebugPrinting();

    RETURN ( __setDebugPrinting( (aBoolean == true) ) ? true : false);
#endif
%}
!

infoPrinting
    "return true, if various informational printouts in the VM
     are turned on, false of off."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( STMain.InfoPrinting ? STObject.True : STObject.False);
#else
    extern int __getInfoPrinting();

    RETURN (__getInfoPrinting() ? true : false);
#endif
%}
    "
     ObjectMemory infoPrinting
    "
!

infoPrinting:aBoolean
    "turn on/off various informational printouts in the VM.
     For example, the GC activity messages are controlled by
     this flags setting.
     The default is true, since (currently) those messages are useful for ST/X developers.
     Returns the previous setting."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	boolean prev = STMain.InfoPrinting;

	STMain.InfoPrinting = (aBoolean == STObject.True);
	return __c__._RETURN( prev ? STObject.True : STObject.False);
    }
    /* NOTREACHED */
#else
    extern int __setInfoPrinting();

    RETURN ( __setInfoPrinting( (aBoolean == true) ) ? true : false);
#endif
%}
!

initTrace:aBoolean
    "turn on/off various init-trace printouts in the VM.
     The default is false.
     Returns the previous setting."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    extern int __setInitTrace();

    RETURN ( __setInitTrace( (aBoolean == true) ) ? true : false);
#endif
%}
! !

!ObjectMemory class methodsFor:'VM unwind protect support'!

lookupMethodForSelectorUnwindHandlerFor: lookup

    "
    An unwind handler for external method lookup
    (MOP). This method effectively called only
    from handler block returned by
    ObjectMemory>>unwindHandlerInContext:.

    The VM also create an artifical context with
    ObjectMemory as receiver and selector if this
    method as selector and marks it for unwind.

    See: ObjectMemory>>unwindHandlerInContext:
    "

    Processor activeProcess externalLookupPopIfEqual: lookup.

    "Created: / 06-10-2011 / 16:31:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unwindHandlerInContext:aContext

    "
    Return an unwind handler block for given context.
    Selector of that context denotes which unwind handler
    to use.

    Occasionally, the VM needs to unwind-protect some C code.
    If so, it creates and artificial context on the stack and
    marks it for unwind, so stack unwinding logic finds it
    and handles it.

    Now, only #lookupMethodForSelectorUnwindProtect is supported
    (ensures the lookup is popped out from the lookupActications)
    "
    aContext selector == #lookupMethodForSelectorUnwindHandlerFor: ifTrue:[
	^[self lookupMethodForSelectorUnwindHandlerFor: (aContext argAt: 1)]
    ].

    self internalError:'Unknown VM unwind protect action'

    "Created: / 01-10-2011 / 19:15:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ObjectMemory class methodsFor:'access debugging'!

debugPrivacyChecks:aBoolean
    "turn on/off checks for private methods being called.
     By default, this is on in the ST/X IDE, but off for standAlone (packaged) endUser
     applications. Method privacy is an experimental feature, which may be removed in later
     versions, if it turns out to be not useful."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    extern int __setPrivacyChecks__();

    RETURN ( __setPrivacyChecks__( (aBoolean == true) ) ? true : false);
#endif
%}
!

setTrapOnAccessFor:anObject
    "install an access trap for anObject;
     An accessSignal will be raised, whenever any instvar of anObject is either read or written.
     This is not supported on all architectures, therefore the return value
     (true of trap was installed ok, false if failed) should be checked."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    RETURN (__addTrapOnAccess(anObject, 2) ? true : false);
#endif
%}
!

setTrapOnReadFor:anObject
    "install a read trap for anObject;
     An accessSignal will be raised, whenever any access into anObject occurs.
     This is not supported on all architectures, therefore the return value
     (true of trap was installed ok, false if failed) should be checked."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    RETURN (__addTrapOnAccess(anObject, 0) ? true : false);
#endif
%}
!

setTrapOnWriteFor:anObject
    "install a write trap for anObject;
     An accessSignal will be raised, whenever any instvar of anObject is written to.
     This is not supported on all architectures, therefore the return value
     (true of trap was installed ok, false if failed) should be checked."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    RETURN (__addTrapOnAccess(anObject, 1) ? true : false);
#endif
%}
!

unsetAllTraps
    "remove all access traps"

%{  /* NOCONTEXT */
    __removeAllAccessTraps();
%}
!

unsetTrapFor:anObject
    "remove any access trap for anObject."

%{  /* NOCONTEXT */
    __removeTrapOnAccess(anObject);
%}
! !

!ObjectMemory class methodsFor:'cache management'!

debugBreakPoint

%{
    extern void __debugBreakPoint__();
    __debugBreakPoint__();
%}.
    ^ 0
!

debugBreakPoint3

%{
#ifndef __win32__
    /*extern void __debugBreakPoint3__();*/
    __debugBreakPoint3__();
#endif
%}.
    ^ 0
!

flushCaches
    "flush method and inline caches for all classes"

%{  /* NOCONTEXT */
    __flushMethodCache();
    __flushAllInlineCaches();
%}
!

flushCachesFor:aClass
    "flush method and inline caches for aClass"

%{  /* NOCONTEXT */
    __flushMethodCacheFor(aClass);
    __flushInlineCachesFor(aClass);
%}
!

flushCachesForSelector:aSelector
    "flush method and inline caches for aSelector"

    self flushMethodCacheForSelector:aSelector.

    "/ self flushInlineCachesForSelector:aSelector.
    self flushInlineCachesWithArgs:(aSelector numArgs).
!

flushCachesForSelector:aSelector numArgs:numArgs
    "flush method and inline caches for aSelector"

    self flushMethodCacheForSelector:aSelector.

    "/ self flushInlineCachesForSelector:aSelector.
    self flushInlineCachesWithArgs:numArgs.
!

flushInlineCaches
    "flush all inlinecaches"

%{  /* NOCONTEXT */
    __flushAllInlineCaches();
%}
!

flushInlineCachesFor:aClass withArgs:nargs
    "flush inlinecaches for calls to aClass with nargs arguments"

%{  /* NOCONTEXT */
    __flushInlineCachesForAndNargs(aClass, __intVal(nargs));
%}
!

flushInlineCachesForClass:aClass
    "flush inlinecaches for calls to aClass."

%{  /* NOCONTEXT */
    __flushInlineCachesFor(aClass);
%}
!

flushInlineCachesForSelector:aSelector
    "flush inlinecaches for sends of aSelector"

%{  /* NOCONTEXT */
    __flushInlineCachesForSelector(aSelector);
%}
!

flushInlineCachesWithArgs:nargs
    "flush inlinecaches for calls with nargs arguments"

%{  /* NOCONTEXT */
    __flushInlineCaches(__intVal(nargs));
%}
!

flushMethodCache
    "flush the method cache"

%{  /* NOCONTEXT */
    __flushMethodCache();
%}
!

flushMethodCacheFor:aClass
    "flush the method cache for sends to aClass"

%{  /* NOCONTEXT */
    __flushMethodCacheFor(aClass);
%}
!

flushMethodCacheForSelector:aSelector
    "flush the method cache for sends of aSelector"

%{  /* NOCONTEXT */
    __flushMethodCacheForSelector(aSelector);
%}
!

ilcMisses: newValue
    newValue class == SmallInteger ifFalse:[
	^ self error:'Not an integer value'
    ].

%{  /* NOCONTEXT */
    /*extern int __ilcMisses(int);*/
#ifdef ILC_PROFILING
    RETURN ( __MKSMALLINT ( __ilcMisses ( __intVal ( newValue ) ) ) );
#endif
%}.
    ^ -1

!

ilcMissesTrace: bool

%{
    /*extern int __ilcMissesTrace(int);*/
#ifdef ILC_PROFILING
    RETURN ( __ilcMissesTrace ( bool == true ) ? true : false );
#endif
%}.
    ^ 0

!

incrementSnapshotID
    "obsolete - do not use"

%{  /* NOCONTEXT */
    __bumpSnapshotID();
%}
!

snapshotID
    "return the internal snapshotID number.
     This is incremented when an image is restarted, and
     stored with the image.
     Not for normal users, this is used by the VM to invalidate
     caches which are stored with the image"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);
#else
    RETURN ( __mkSmallInteger( __snapshotID() ));
#endif
%}
    "
     ObjectMemory snapshotID
    "
!

trapRestrictedMethods:trap
    "Allow/Deny execution of restricted Methods (see Method>>>restricted:)

     Notice: method restriction is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    |oldTrap|

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    if (__setTrapRestrictedMethods(trap == true))
	oldTrap = true;
    else
	oldTrap = false;
#endif
%}.
    (trap and:[oldTrap not]) ifTrue:[
	self flushCaches
    ].
    ^ oldTrap

    "
	ObjectMemory trapRestrictedMethods:true
	ObjectMemory trapRestrictedMethods:false
    "
! !

!ObjectMemory class methodsFor:'debug queries'!

addressOf:anObject
    "return the core address of anObject as an integer
     - since objects may move around, the returned value is invalid after the
     next scavenge/collect.
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);
#else
    if (anObject != nil) {
	if (! __isNonNilObject(anObject)) {
	    RETURN ( nil );
	}
    }
    if ((unsigned INT)anObject <= _MAX_INT) {
	RETURN ( __mkSmallInteger((INT)anObject) );
    }
    RETURN ( __MKUINT((INT)anObject) );
#endif
%}
    "
    |p|
    p := Point new.
    ((ObjectMemory addressOf:p) printStringRadix:16) printCR.
    ObjectMemory scavenge.
    ((ObjectMemory addressOf:p) printStringRadix:16) printCR.
    "
!

ageOf:anObject
    "return the number of scavenges, an object has survived
     in new space.
     For old objects and living contexts, the returned number is invalid.
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);
#else
    if (! __isNonNilObject(anObject)) {
	RETURN ( 0 );
    }
    RETURN ( __mkSmallInteger( __GET_AGE(anObject) ) );
#endif
%}
    "
    |p|
    p := Point new.
    (ObjectMemory ageOf:p) printCR.
    ObjectMemory tenuringScavenge.
    (ObjectMemory spaceOf:p) printCR.
    ObjectMemory tenuringScavenge.
    (ObjectMemory spaceOf:p) printCR.
    ObjectMemory tenuringScavenge.
    (ObjectMemory spaceOf:p) printCR.
    ObjectMemory tenuringScavenge.
    (ObjectMemory spaceOf:p) printCR.
    "
!

displayRefChainTo:anObject
    self displayRefChainToAny:(Array with:anObject).

     "
      self displayRefChainTo:Point new
     "
     "
      Smalltalk at:#foo put:Point new.
      self displayRefChainTo:(Smalltalk at:#foo)
     "
     "
      |p|
      p := Point new.
      Smalltalk at:#foo put:(#x -> p).
      self displayRefChainTo:p
     "
     "
      |a|
      a := Array new:1. a at:1 put:a.
      Smalltalk at:#foo put:(#x -> a).
      self displayRefChainTo:a
     "
     "
      |a|
      a := Array new:1. a at:1 put:a.
      Smalltalk at:#foo put:(#x -> (Array with:a)).
      self displayRefChainTo:a
     "
     "
      |a|
      a := Array new:1. a at:1 put:a.
      Smalltalk at:#foo put:(#x -> (Array with:a with:(#y -> a))).
      self displayRefChainTo:a
     "
     "
      |p|
      p := Point new.
      Smalltalk at:#foo put:(WeakArray with:(#x -> (#y -> p))).
      self displayRefChainTo:p
     "
     "
      self displayRefChainTo:Transcript topView
     "

    "Created: / 2.2.1998 / 19:23:55 / cg"
    "Modified: / 3.2.1998 / 00:30:14 / cg"
!

displayRefChainToAny:aCollection
    self displayRefChainToAny:aCollection limitNumberOfSearchedReferences:nil
!

displayRefChainToAny:aCollection limitNumberOfSearchedReferences:limitOrNil
    |levels objects done showMore stop userStop chain
     top progress lbl h nDone nAll panel listV
     moreButton owners objectArray numObjects numObjectsDone
     found moreChainsOnThisLevel temporaryRemoved chains
     anyShown anyShownInAnyLevel list tLevels firstRound|

    top := StandardSystemView new.
    top extent:350@250.
    top label:'Object reference finder'.

    lbl := Label label:'compressing garbage ...' in:top.
    lbl adjust:#left.
    lbl origin:(0.0@0.0) corner:(1.0@0.0).
    h := lbl preferredHeight.
    lbl
	topInset:5;
	bottomInset:(h+5) negated;
	leftInset:5;
	rightInset:5.

    progress := ProgressIndicator in:top.
    progress origin:(0.0@45) corner:(1.0@45).
    progress level:-1.
    h := progress preferredHeight.
    progress
	topInset:(h // 2) negated;
	bottomInset:(h // 2) negated;
	leftInset:5;
	rightInset:5.
    progress beInvisible.

    listV := HVScrollableView for:SelectionInListView in:top.
    listV origin:(0.0@55) corner:(1.0@1.0).
    listV
	topInset:(h // 2);
	bottomInset:40;
	leftInset:5;
	rightInset:5.
    listV beInvisible.

    panel := HorizontalPanelView in:top.
    panel origin:(0.0@1.0) corner:(1.0@1.0).
    panel topInset:-40.
    panel horizontalLayout:#left.

    panel add:(Button label:'stop' action:[stop := userStop := true]).
    panel add:(moreButton := Button label:'more' action:[showMore := true]).
    panel ignoreInvisibleComponents:false.
    moreButton beInvisible.

    top openWithPriority:(Processor activePriority + 1).
    top waitUntilVisible.

    lbl label:'compressing garbage ...'.
    self compressingGarbageCollect.

    progress beVisible.

    levels := OrderedCollection new.
    objects := WeakIdentitySet withAll:aCollection.

    done := (objects includesIdentical:Smalltalk).
    stop := userStop := false.
    anyShown := anyShownInAnyLevel := false.

    "/ consider this a kludge:
    "/ the processes are not held in any global; they are (currently)
    "/ only known to the VM.
    "/ In order to find a global ref, temporarily create one here.
    "/ These are released later.

    Smalltalk at:#'__VMProcesses__' put:(self processesKnownInVM).

    firstRound := true.

    [done] whileFalse:[
	anyShown := false.

	progress percentage:0.
	firstRound ifTrue:[
	    firstRound := false.
	] ifFalse:[
	    lbl label:'compressing garbage ...'.
	    self garbageCollect.
	].

	lbl label:('searching level '
		   , levels size printString
		   , ' (' , objects size printString , ' refs) ...').
	nAll := objects size.
	nDone := 0.

	objectArray := objects asArray.

	owners := "Weak"IdentitySet new.

	numObjectsDone := 0.
	found := false.

	AbortOperationRequest catch:[
	    self allObjectsIncludingContextsDo:[:o |
		|inPrevLevel isOwner|

		stop ifTrue:[AbortOperationRequest raise].
		stop ifFalse:[
		    isOwner := false.
		    (o referencesAny:objectArray) ifTrue:[
			o isBehavior ifTrue:[
			    o == Smalltalk ifTrue:[
				found := true.
			    ] ifFalse:[
				"/ only add it if it has classInstVars
				o instSize ~~ Class instSize ifTrue:[
				    isOwner := true.
				]
			    ]
			] ifFalse:[
			    o class ~~ WeakArray ifTrue:[
				isOwner := true.
			    ]
			].
		    ].

		    isOwner ifTrue:[
			(objects includesIdentical:o) ifFalse:[
			    inPrevLevel := false.
			    levels do:[:lColl |
				lColl == o ifTrue:[
				    inPrevLevel := true
				] ifFalse:[
				    (lColl includesIdentical:o) ifTrue:[inPrevLevel := true].
				]
			    ].
			    inPrevLevel ifFalse:[
				owners add:o.
				(limitOrNil notNil and:[owners size >= limitOrNil]) ifTrue:[
				    AbortOperationRequest raise
				].
			    ]
			]
		    ].

		    numObjectsDone := numObjectsDone + 1.
		    numObjects notNil ifTrue:[
			numObjectsDone \\ 1000 == 0 ifTrue:[
			    progress percentage:(numObjectsDone / numObjects * 100).
			    Processor yield.
			]
		    ]
		]
	    ].
	].
	progress percentage:100.

	numObjects isNil ifTrue:[
	    numObjects := numObjectsDone.
	].

	owners remove:aCollection ifAbsent:nil.
	owners remove:thisContext ifAbsent:nil.
	owners remove:objectArray ifAbsent:nil.
	owners remove:objects keyArray ifAbsent:nil.
	owners remove:owners keyArray ifAbsent:nil.

"/ 'done with level: ' print. levels size print. ' found ' print. owners size print. ' refs' printCR.

	owners isEmpty ifTrue:[
	    found ifFalse:[
		stop := true.
	    ]
	].

	stop ifFalse:[
	    done := found or:[(owners includesIdentical:Smalltalk)].
	    done ifTrue:[
		moreChainsOnThisLevel := true.
		temporaryRemoved := IdentitySet new.

		levels size > 0 ifTrue:[
		    "/ show what we found so far.
		    levels last add:Smalltalk.
		    levels reverse.
		].

		chains := OrderedCollection new.

		tLevels := levels collect:[:lColl | lColl copy].

		lbl label:('building refchains ...').

		nAll := aCollection size.
		nDone := 0.
		aCollection do:[:anObject | |theseChains|
		    stop ifFalse:[
			theseChains := self
				refChainsFrom:Smalltalk
				to:anObject
				inRefSets:tLevels
				startingAt:1.

			theseChains size > 0 ifTrue:[
			    chains addAll:theseChains
			].
			nDone := nDone + 1.
			progress percentage:(nDone / nAll * 100).
		    ]
		].

		tLevels := nil.

		levels size > 0 ifTrue:[
		    levels reverse.
		    levels last remove:Smalltalk.
		].

		[stop not
		 and:[chains size > 0]] whileTrue:[
		    chain := chains first.
		    chains removeFirst.

		    lbl label:('found a reference chain.').
		    progress beInvisible.

		    chain addFirst:Smalltalk.
		    list := OrderedCollection newWithSize:chain size.
		    1 to:chain size-1 do:[:i |
			list
			    at:i
			    put:(self refNameFor:(chain at:i+1) in:(chain at:i))
		    ].
		    list at:list size put:(chain last classNameWithArticle).

		    "/ hide the VMProcesses stuff from the user ...
		    (list at:1) string = 'Smalltalk:__VMProcesses__' ifTrue:[
			list at:1 put:'__VMProcesses__ (a hidden VM reference)'.
			list removeIndex:2.
			chain at:1 put:nil.
			chain removeIndex:2.
		    ].

		    listV list:list.

		    listV beVisible.
		    listV doubleClickAction:[:idx | |o|
						(o := chain at:idx) notNil ifTrue:[
						    o inspect.
						]
					    ].
		    moreButton beVisible.
		    anyShown := anyShownInAnyLevel := true.
		    showMore := false.

		    "/ kludge - wait for some user action

		    [showMore or:[stop or:[top realized not]]] whileFalse:[
			Delay waitForSeconds:0.1
		    ].

		    chain := nil.

		    top realized ifFalse:[
			stop := true
		    ] ifTrue:[
			listV doubleClickAction:nil.
			showMore ifFalse:[
			    stop := true.
			].
		    ].
		    done := false.

		    stop ifFalse:[
			progress beVisible.
			listV beInvisible.
			moreButton beInvisible.

			chain := nil.
		    ]
		].
		levels size > 0 ifTrue:[
		    levels last addAll:temporaryRemoved.
		]
	    ].
	].

	owners remove:Smalltalk ifAbsent:nil.
	owners remove:(owners keyArray) ifAbsent:nil.
	owners remove:objectArray ifAbsent:nil.
	levels do:[:lColl |
	    owners remove:lColl ifAbsent:nil
	].

	levels add:owners.

	objects := owners.

	objects size == 0 ifTrue:[
	    stop := true
	].

	stop ifTrue:[
	    Smalltalk at:#'__VMProcesses__' put:nil.
	    top destroy.
	    anyShown ifFalse:[
		userStop ifFalse:[
		    self information:(anyShownInAnyLevel ifTrue:['no more references'] ifFalse:['no references']).
		]
	    ].
	   ^ self.
	].

    ].

    anyShown ifTrue:[
	userStop ifFalse:[
	    self information:'no more references'.
	]
    ].
    Smalltalk at:#'__VMProcesses__' put:nil.
    ^ self

     "
      self displayRefChainTo:Point new
     "
     "
      Smalltalk at:#foo put:Point new.
      self displayRefChainTo:(Smalltalk at:#foo)
     "
     "
      |p|
      p := Point new.
      Smalltalk at:#foo put:(#x -> p).
      self displayRefChainTo:p
     "
     "
      |a|
      a := Array new:1. a at:1 put:a.
      Smalltalk at:#foo put:(#x -> a).
      Smalltalk at:#bar put:(Array with:(#y -> a)).
      self displayRefChainTo:a
     "
     "
      |a|
      a := Array new:1. a at:1 put:a.
      Smalltalk at:#foo put:(#x -> (Array with:a)).
      self displayRefChainTo:a
     "
     "
      |a|
      a := Array new:1. a at:1 put:a.
      Smalltalk at:#foo put:(#x -> (Array with:a with:(#y -> a))).
      self displayRefChainTo:a
     "
     "
      |p|
      p := Point new.
      Smalltalk at:#foo put:(WeakArray with:(#x -> (#y -> p))).
      self displayRefChainTo:p
     "
     "
      self displayRefChainTo:Transcript topView
     "

    "Created: / 2.2.1998 / 23:58:04 / cg"
    "Modified: / 10.7.1998 / 17:22:06 / cg"
!

dumpObject:someObject
    "low level dump an object.
     WARNING: this method is for ST/X debugging only
	      it may be removed (or replaced by a noop) without notice"

%{
#ifdef __SCHTEAM__
    someObject.dumpObject();
#else
    __dumpObject__(someObject, __LINE__);
#endif
%}
    "
     ObjectMemory dumpObject:true
     ObjectMemory dumpObject:(Array new:10)
     ObjectMemory dumpObject:(10@20 corner:30@40)
    "
!

dumpSender
    "dump my senders context"

%{
#ifdef __SCHTEAM__
    __c__.currentContinuation.dumpObject();
#else
    __PATCHUPCONTEXT(__thisContext);
    __dumpContext__(__ContextInstPtr(__thisContext)->c_sender);
#endif
%}
    "
     ObjectMemory dumpSender
    "
!

flagsOf:anObject
    "For debugging only.
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);
#else
    if (! __isNonNilObject(anObject)) {
	RETURN ( nil );
    }
    RETURN ( __mkSmallInteger( anObject->o_flags ) );
#endif
%}
    "
F_ISREMEMBERED  1       /* a new-space thing being refd by some oldSpace thing */
F_ISFORWARDED   2       /* a forwarded object (you will never see this here) */
F_DEREFERENCED  4       /* a collection after grow (not currently used) */
F_ISONLIFOLIST  8       /* a non-lifo-context-referencing-obj already on list */
F_MARK          16      /* mark bit for background collector */
    "

    "
     |arr|

     arr := Array new.
     arr at:1 put:([thisContext] value).
     (ObjectMemory flagsOf:anObject) printCR
    "
!

objectAt:anAddress
    "return whatever anAddress points to as object.
     BIG BIG DANGER ALERT:
	this method is only to be used for debugging ST/X itself
	- you can easily (and badly) crash the system.
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice"

%{  /* NOCONTEXT */
    INT addr = __longIntVal(anAddress);

    if (addr) {
	RETURN ((OBJ)(addr));
    }
%}.
    ^ nil
!

printReferences:anObject
    "for debugging: print referents to anObject.
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice
	use ObjectMemory>>whoReferences: or anObject>>allOwners."

%{
    __printRefChain((OBJ)__context, anObject);
%}
!

refChainFrom:start to:anObject inRefSets:levels startingAt:index
     |chain|

     index > levels size ifTrue:[
	(start referencesObject:anObject) ifTrue:[
	    ^ OrderedCollection with:anObject. "/ (self refNameFor:anObject in:start)
	].
	^ nil.
     ].

     (levels at:index) do:[:el |
el ~~ start ifTrue:[
	(start referencesObject:el) ifTrue:[
	    chain := self
			refChainFrom:el
			to:anObject
			inRefSets:levels
			startingAt:(index+1).

	    chain notNil ifTrue:[
		(levels at:index) safeRemove:el.
		chain addFirst:el. "/ (self refNameFor:el in:start).
		^ chain.
	    ]
	].
].
     ].
     ^ nil


     "
      |o a1 a2|

      o := Object new.
      a1 := Array with:o with:nil with:nil.
      a2 := Array with:a1 with:nil with:nil.
      a2 referencesObject:a1
     "

     "
      |o a1 a2 a3 a4 levels|

      o := Object new.
      a1 := Array with:o.
      a2 := Array with:a1.
      a3 := Array with:a2.
      a4 := Array with:a3.
      levels := Array with:(Array with:a3)
		      with:(Array with:a2)
		      with:(Array with:a1).

      self refChainFrom:a4 to:o inRefSets:levels startingAt:1.
     "

    "Modified: / 3.2.1998 / 02:38:27 / cg"
!

refChainsFrom:start to:anObject inRefSets:levels startingAt:index
     |chains chain c|

     chains := OrderedCollection new.

     index > levels size ifTrue:[
	(start referencesObject:anObject) ifTrue:[
	    chains add:(OrderedCollection with:anObject "(self refNameFor:anObject in:start)").
	].
	^ chains
     ].

     (levels at:index) do:[:el |
el ~~ start ifTrue:[
	(start referencesObject:el) ifTrue:[
	    chain := self
			refChainFrom:el
			to:anObject
			inRefSets:levels
			startingAt:(index+1).

	    chain size > 0 ifTrue:[
		(levels at:index) safeRemove:el.

		c := chain copy.
		c addFirst:el "(self refNameFor:el in:start)".
		chains add:c.
	    ]
].
	].
     ].
     ^ chains

    "Created: / 2.2.1998 / 19:09:22 / cg"
    "Modified: / 3.2.1998 / 02:38:17 / cg"
!

refNameFor:anObject in:referent
    |names oClass|

    referent == Smalltalk ifTrue:[
        referent keysAndValuesDo:[:key :val |
            |idx|

            (anObject == val) ifTrue:[
                "/ for our convenience - if its a nameSpace, cut off Smalltalk.
                idx := key string indexOf:$:.
                (idx ~~ 0
                and:[idx < key string size
                and:[(key string at:(idx+1)) == $:]]) ifTrue:[
                    ^ key allBold "/ (key copyFrom:(idx+2)) allBold
                ].
                ^ 'Smalltalk:' , (key allBold).
            ]
        ].
    ] ifFalse:[
        names := referent class allInstVarNames.
        oClass := referent class.
        oClass == anObject ifTrue:[
            ^ oClass name.
        ].
        1 to:oClass instSize do:[:i |
            ((referent instVarAt:i) == anObject) ifTrue:[
                ^ '%1 [%2]' bindWith:referent class nameWithArticle with:(names at:i) allBold.
            ].
        ].
        oClass isVariable ifTrue:[
            oClass isPointers ifTrue:[
                1 to:referent basicSize do:[:i |
                    ((referent basicAt:i) == anObject) ifTrue:[
                        ^ '%1 [%2] (sz=%2)' bindWith:referent class nameWithArticle with:i printString allBold with:referent basicSize printString
                    ]
                ]
            ]
        ].
    ].
    self error:'no reference' mayProceed:true.
    ^ nil.

    "Created: / 2.2.1998 / 23:46:12 / cg"
    "Modified: / 4.2.1998 / 22:03:36 / cg"
!

sizeOf:anObject
    "return the size of anObject in bytes.
     (this is not the same as 'anObject size').
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);
#else
    RETURN ( __isNonNilObject(anObject) ? __mkSmallInteger(__qSize(anObject)) : __mkSmallInteger(0) )
#endif
%}
    "
     |hist big nw|

     hist := Array new:100 withAll:0.
     big := 0.
     ObjectMemory allObjectsDo:[:o |
	 nw := (ObjectMemory sizeOf:o) // 4 + 1.
	 nw > 100 ifTrue:[
	    big := big + 1
	 ] ifFalse:[
	    hist at:nw put:(hist at:nw) + 1
	 ].
     ].
     hist printCR.
     big printCR
    "
!

spaceOf:anObject
    "return the memory space, in which anObject is.
     - since objects may move between spaces,
       the returned value may be invalid after the next scavenge/collect.
     WARNING: this method is for ST/X debugging only
	      it will be removed without notice"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN(0);
#else
    if (! __isNonNilObject(anObject)) {
	RETURN ( nil );
    }
    RETURN ( __mkSmallInteger( __qSpace(anObject) ) );
#endif
%}
! !

!ObjectMemory class methodsFor:'debugging ST/X'!

checkConsistency
    "call the object memory consistency checker.
     Useful to check if all obejct references are still valid,
     especially when primitive (inline-C) code is developed.
     If called before and after a primitive, missing STORE checks or
     overwritten object headers etc. might be detected.
     (there is no real guarantee, that all such errors are detected, though)"

%{
    __checkConsistency("user call");
%}

    "
     ObjectMemory checkConsistency
    "

    "Created: / 18-01-2012 / 12:10:37 / cg"
!

printPolyCaches
    "{ Pragma: +optSpace }"

    "dump poly caches.
     WARNING: this method is for debugging only
	      it will be removed without notice"
%{
    __dumpILCCaches();
%}

    "
     ObjectMemory printPolyCaches
    "
!

printStackBacktrace
    "{ Pragma: +optSpace }"

    "print a stack backtrace - then continue.
     (You may turn off the stack print with debugPrinting:false)
     WARNING: this method is for debugging only
	      it will be removed without notice"

%{
#ifdef __SCHTEAM__
    __c__.printWalkback( STObject.StandardErrorStream );
#else
    __printStack((OBJ)__context);
#endif
%}

    "
     ObjectMemory printStackBacktrace
    "


!

printStackBacktraceFrom:aContext
    "{ Pragma: +optSpace }"

    "print a stack backtrace - then continue.
     (You may turn off the stack print with debugPrinting:false)
     WARNING: this method is for debugging only
	      it will be removed without notice"

%{
    __printStack(aContext);
%}

    "
     ObjectMemory printStackBacktraceFrom:thisContext sender sender
    "


!

printSymbols
    "{ Pragma: +optSpace }"

    "dump the internal symbol table.
     WARNING: this method is for debugging only
	      it will be removed without notice"
%{
#ifdef DEBUG
    __dumpSymbols();
#endif
%}

    "
     ObjectMemory printSymbols
    "
!

sendTraceOff
    "{ Pragma: +optSpace }"

    "turns tracing of message sends off.
     WARNING: this method is for debugging only
	      it may be removed without notice"

%{  /* NOCONTEXT */
    __setMessageTrace__(0);
%}

    "
     ObjectMemory sendTraceOff
    "
!

sendTraceOn
    "{ Pragma: +optSpace }"

    "turns tracing of message sends on.
     WARNING: this method is for debugging only
	      it may be removed without notice"

%{  /* NOCONTEXT */
    __setMessageTrace__(1);
%}

    "
     ObjectMemory sendTraceOn
    "
! !

!ObjectMemory class methodsFor:'dependents access'!

dependents
    "return the collection of my dependents"

    ^ Dependents ? #()

    "Modified: / 26.1.1998 / 11:17:59 / cg"
!

dependents:aCollection
    "set the dependents collection"

    Dependents := aCollection
!

dependentsDo:aBlock
    "evaluate aBlock for all of my dependents.
     Since this is performed at startup time (under the scheduler),
     this is redefined here to catch abort signals.
     Thus, if any error occurs in a #returnFromSnapshot,
     the user can press abort to continue."

    |deps|

    deps := Dependents.
    deps notNil ifTrue:[
	deps do:[:each |
	    AbortOperationRequest handle:[:ex |
		ex return
	    ] do:[
		aBlock value:each
	    ]
	]
    ]
! !

!ObjectMemory class methodsFor:'enumerating'!

allInstancesOf:aClass do:aBlock
    "evaluate the argument, aBlock for all instances of aClass in the system.
     There is one caveat: if a compressing oldSpace collect
     occurs while looping over the objects, the loop cannot be
     continued (for some internal reasons). In this case, false
     is returned."

    |work|

%{  /* NOREGISTER - work may not be placed into a register here */
    __nonTenuringScavenge(__context);
    /*
     * allInstancesDo needs a temporary to hold newSpace objects
     */
    if (__allInstancesOfDo(&aClass, &aBlock, &work) < 0) {
	RETURN (false);
    }
%}.
    ^ true
!

allObjectsDo:aBlock
    "evaluate the argument, aBlock for all objects in the system.
     There is one caveat: if a compressing oldSpace collect
     occurs while looping over the objects, the loop cannot be
     continued (for some internal reasons). In this case, false
     is returned."

    |work|

%{  /* NOREGISTER - work may not be placed into a register here */
    __nonTenuringScavenge(__context);
    /*
     * allObjectsDo needs a temporary to hold newSpace objects
     */
    if (__allInstancesOfDo((OBJ *)0, &aBlock, &work) < 0) {
	RETURN (false);
    }
%}.
    ^ true
!

allObjectsIncludingContextsDo:aBlock
    "like allObjectsDo, but also walks over all contexts
     of living processes"

    self allObjectsDo:aBlock.
    ProcessorScheduler knownProcesses do:[:p |
	|con|

	con := p suspendedContext.
	[con notNil] whileTrue:[
	    aBlock value:con.
	    con := con sender.
	].
    ].

    "Created: / 3.2.1998 / 11:32:08 / cg"
!

allOldObjectsDo:aBlock
    "evaluate the argument, aBlock for all old objects in the system.
     For debugging and tests only - do not use"
%{
    if (__allInstancesOfDo((OBJ *)0, &aBlock, (OBJ *)0) < 0) {
	RETURN (false);
    }
%}.
    ^ true
!

processesKnownInVM
    "debug query: return a collection of processObjects as known
     in the VM. For ST/X internal use only."

%{
    extern OBJ __processesKnownInVM();

    RETURN (__processesKnownInVM());
%}.
    ^ #()

    "
     ObjectMemory processesKnownInVM
    "
! !

!ObjectMemory class methodsFor:'garbage collection'!

backgroundCollectProcess
    "return the backgroundCollectProcess (or nil, if noone is running)"

    ^ BackgroundCollectProcess

    "Created: / 4.8.1998 / 01:54:16 / cg"
!

backgroundCollectorRunning
    "return true, if a backgroundCollector is running"

    ^ BackgroundCollectProcess notNil

    "
     ObjectMemory backgroundCollectorRunning
    "
!

compressOldSpace
    "COMPRESS the oldSpace memory area.
     This uses an inplace 2-pass compress algorithm, which may
     be slightly slower than the semispace compress if lots of real memory
     is available.
     In memory limited systems, this inplace compress is usually preferable.
     Inplace compression can be enforced by setting the compress-limit to a
     small number.

     This can take a long time."
%{
    __compressOldSpace(__context);
%}

    "
     ObjectMemory compressOldSpace
    "
    "
     Transcript showCR:(Time millisecondsToRun:[
	 ObjectMemory markAndSweep.
	 ObjectMemory compressOldSpace.
     ]).
    "
    "
     Transcript showCR:(Time millisecondsToRun:[
	 ObjectMemory compressingGarbageCollect.
     ]).
    "

!

compressingGarbageCollect
    "search for and free garbage in the oldSpace (newSpace is cleaned automatically)
     performing a COMPRESSING garbage collect.
     This uses a 1-pass copying semispace algorithm, which may
     be slightly faster than the 2-pass in-place compress if enough real memory
     is available. In memory limited systems, an inplace compress is
     preferable, which is enforced by setting the compress-limit to a
     small number.

     This can take a long time - especially, if paging is involved
     (when no paging is involved, its faster than I thought :-).
     If no memory is available for the compress, or the system has been started with
     the -Msingle option, this does a non-COMPRESSING collect."
%{
    if (! __garbageCollect((OBJ)__context)) {
	__markAndSweep();
	RETURN (false);
    }
%}.
    ^ true

    "
     ObjectMemory compressingGarbageCollect
    "
!

garbageCollect
    "search for and free garbage in the oldSpace.
     This can take a long time - especially, if paging is involved."

    "/ used to be
    "/    self compressingGarbageCollect
    "/ here; changed to default to markAndSweep

    self markAndSweep

    "
     ObjectMemory garbageCollect
    "
!

gcStep
    "one incremental garbage collect step.
     Mark or sweep some small number of objects. This
     method will return after a reasonable (short) time.
     This is used by the ProcessorScheduler at idle times.
     Returns true, if an incremental GC cycle has finished."
%{
    extern int __incrGCstep();

    RETURN (__incrGCstep() ? true : false);
%}
!

gcStepIfUseful
    "If either the IncrementalGCLimit or the FreeSpaceGCLimits have been
     reached, perform one incremental garbage collect step.
     Return true, if more gcSteps are required to finish the cycle,
     false if done with a gc round.
     If no limit has been reached yet, do nothing and return false.
     This is called by the ProcessorScheduler at idle times or by the
     backgroundCollector."

    |done limit|

    self isSchteamEngine ifTrue:[^ false ].

    AbortOperationRequest handle:[:ex |
	"/ in case of abort (from the debugger),
	"/ disable gcSteps.
	done := true.
	IncrementalGCLimit := FreeSpaceGCLimit := nil.
	'ObjectMemory [error]: IGC aborted; turning off incremental GC' errorPrintCR
    ] do:[
	limit := IncrementalGCLimit.
	(limit notNil and:[self oldSpaceAllocatedSinceLastGC > limit]) ifTrue:[
"/            'IGC [info]: start since allocatedSinceLastGC > IncrementalGCLimit' infoPrintCR.
	    done := ObjectMemory gcStep
	] ifFalse:[
	    limit := FreeSpaceGCLimit.
	    (limit notNil and:[(self freeSpace + self freeListSpace) < limit]) ifTrue:[
"/            'IGC [info]: start since freeSpace < FreeSpaceGCLimit' infoPrintCR.
		done := ObjectMemory gcStep.
		done ifTrue:[
		    self moreOldSpaceIfUseful
		].
	    ] ifFalse:[
		limit := DynamicCodeGCTrigger.
		(limit notNil and:[self compiledCodeCounter > limit]) ifTrue:[
"/                    'IGC [info]: start since compiledCodeCounter > DynamicCodeGCTrigger' infoPrintCR.
		    done := ObjectMemory gcStep.
		] ifFalse:[
		    limit := DynamicCodeLimit.
		    (limit notNil and:[self compiledCodeSpaceUsed > limit]) ifTrue:[
"/                    'IGC [info]: start since compiledCodeSpaceUsed > DynamicCodeLimit' infoPrintCR.
			done := ObjectMemory gcStep.
		    ] ifFalse:[
			done := true
		    ]
		]
	    ]
	].
    ].
    ^ done not

    "Modified: / 14.8.1998 / 13:08:15 / cg"
!

incrementalGC
    "perform one round of incremental GC steps.
     The overall effect of this method is (almost) the same as calling
     markAndSweep. However, #incrementalGC is interruptable while #markAndSweep
     is atomic and blocks for a while. The code here performs incremental
     GC steps, until one complete gc-cycle is completed. If running at a higher
     than userBackground priority, it will give up the CPU after every such
     step for a while.
     Thus this method can be called either from a low prio (background) process
     or from a high prio process.
     (however, if you have nothing else to do, its better to call for markAndSweep,
      since it is faster)
     For example, someone allocating huge amounts of memory could
     ask for the possibility of a quick allocation using
     #checkForFastNew: and try a #incrementalGC if not. In many
     cases, this can avoid a pause (in the higher prio processes) due to
     a blocking GC."

    |delay|

    self isSchteamEngine ifTrue:[^ self].

    Processor activeProcess priority > Processor userBackgroundPriority ifTrue:[
	delay := Delay forMilliseconds:1
    ].

    ((self incrementalGCPhaseSymbolic ~~ #idle)
    or:[self gcStepIfUseful]) ifTrue:[
	[self gcStep] whileFalse:[
	    delay notNil ifTrue:[delay wait]
	]
    ].
    self moreOldSpaceIfUseful

    "
     ObjectMemory incrementalGC
     [ObjectMemory incrementalGC] forkAt:3
     [ObjectMemory incrementalGC] forkAt:9
    "

    "Modified: / 10.8.1998 / 15:03:07 / cg"
!

markAndSweep
    "mark/sweep garbage collector.
     perform a full mark&sweep collect.
     Warning: this may take some time and it is NOT interruptable.
     If you want to do a collect from a background process, or have
     other things to do, better use #incrementalGC which is interruptable."
%{
    __markAndSweep();
%}

    "
     ObjectMemory markAndSweep
    "
!

nonVerboseGarbageCollect
    "perform a compressing garbage collect or fallback to non-compressing collect,
     if required."

    "/ try 1pass baker collect first.
    "/ this will fail if oldSpace size is above compressLimit
    (self compressingGarbageCollect) ifFalse:[
	"/ fallBack - use 2pass inplace compress
	self compressOldSpace
    ].

    "
     ObjectMemory nonVerboseGarbageCollect
    "
!

reclaimSymbols
    "reclaim unused symbols;
     Unused symbols are (currently) not reclaimed automatically,
     but only upon request with this method.
     It takes some time to do this ... and it is NOT interruptable.
     Future versions may do this automatically, while garbage collecting."
%{
    __reclaimSymbols();
%}
    "
     ObjectMemory reclaimSymbols
    "
!

resumeBackgroundCollector
    "resume the background collector process"

    BackgroundCollectProcess notNil ifTrue:[
	BackgroundCollectProcess resume.
    ]

    "
     ObjectMemory resumeBackgroundCollector
    "

    "Created: / 03-08-2004 / 18:12:30 / stefan"
    "Modified: / 17-10-2007 / 13:14:46 / cg"
!

scavenge
    "collect young objects, without aging (i.e. no tenure).
     Can be used to quickly get rid of shortly before allocated
     stuff. This is relatively fast (compared to oldspace collect).

     An example where a non-tenuring scavenge makes sense is when
     allocating some OperatingSystem resource (a Color, File or View)
     and the OS runs out of resources. In this case, the scavenge may
     free some ST-objects and therefore (by signalling the WeakArrays
     or Registries) free the OS resources too.
     Of course, only recently allocated resources will be freed this
     way. If none was freed, a full collect will be needed."
%{
    __nonTenuringScavenge();
%}

    "
     ObjectMemory scavenge
    "
!

startBackgroundCollectorAt:aPriority
    "start a process doing incremental GC in the background.
     Use this, if you have suspendable background processes which
     run all the time, and therefore would prevent the idle-collector
     from running. See documentation in this class for more details."

    |p|

    self isSchteamEngine ifTrue:[^ self].

    "/
    "/ its not useful, to run it more than once
    "/
    BackgroundCollectProcess notNil ifTrue:[
	BackgroundCollectProcess priority:aPriority.
	^ self
    ].

    p :=
	[
	    [
		|myDelay timeOfLastGC doGC|

		myDelay := Delay forSeconds:5.
		timeOfLastGC := Timestamp now.

		[true] whileTrue:[
		    doGC := self gcStepIfUseful.
		    doGC ifFalse:[
			(BackgroundCollectMaximumInterval notNil
			and:[(Timestamp now secondDeltaFrom: timeOfLastGC) > BackgroundCollectMaximumInterval])
			ifTrue:[
"/                            'ObjectMemory [info]: start time-triggered background collect.' infoPrintCR.
			    doGC := true.
			]
		    ].

		    doGC ifTrue:[
			"/
			"/ perform a full cycle (finish cycle)
			"/
			[self gcStep] whileFalse:[].
			"/
			"/ increase oldSpace, if freeSpace is below limits.
			"/
			self moreOldSpaceIfUseful.
			timeOfLastGC := Timestamp now.
		    ].
		    "/
		    "/ wait a bit
		    "/
		    myDelay wait.
		]
	    ] ifCurtailed:[
		BackgroundCollectProcess := nil
	    ]
	] newProcess.
    p name:'background collector'.
    p priority:aPriority.
    p restartable:true.
    p beSystemProcess.
    p resume.
    BackgroundCollectProcess := p

    "
     the following lets the backgroundCollector run at prio 5
     whenever 100000 bytes have been allocated, OR freeSpace drops
     below 1meg. Having the system keep 1meg as reserve for peak allocation.

     Doing this may reduce pauses due to inevitable collects when running
     out of freeSpace, if the collector can keep up with allocation rate.
    "

    "
     ObjectMemory stopBackgroundCollector.

     ObjectMemory incrementalGCLimit:100000.
     ObjectMemory freeSpaceGCLimit:1000000.
     ObjectMemory startBackgroundCollectorAt:5.
    "

    "Modified: / 14.8.1998 / 13:09:19 / cg"
!

stopBackgroundCollector
    "stop the background collector"

    BackgroundCollectProcess notNil ifTrue:[
	BackgroundCollectProcess terminate.
	BackgroundCollectProcess := nil
    ]

    "
     ObjectMemory stopBackgroundCollector
    "
!

suspendBackgroundCollector
    "suspend the background collector process.
     Answer true, if the background collector was running before"

    |backgroundCollectorWasRunning|

    backgroundCollectorWasRunning := false.

    BackgroundCollectProcess notNil ifTrue:[
	"suspend doesn't work due to interrupt processing"
	backgroundCollectorWasRunning := BackgroundCollectProcess isStopped not.
	BackgroundCollectProcess stop.
    ].

    ^ backgroundCollectorWasRunning


    "
     ObjectMemory suspendBackgroundCollector.
     ObjectMemory resumeBackgroundCollector
    "

    "Created: / 03-08-2004 / 18:11:41 / stefan"
    "Modified: / 17-10-2007 / 13:15:01 / cg"
!

tenure
    "force all living new stuff into old-space - effectively making
     all living young objects become old objects immediately.
     This is relatively fast (compared to oldspace collect).

     This method should only be used in very special situations:
     for example, when building up some long-living data structure
     in a time critical application.
     To do so, you have to do a scavenge followed by a tenure after the
     objects are created. Be careful, to not reference any other chunk-
     data when calling for a tenure (this will lead to lots of garbage in
     the oldspace).
     In normal situations, explicit tenures are not needed."
%{
    __tenure();
%}

    "
     ObjectMemory tenure
    "
    "
     ... build up long living objects ...
     ObjectMemory scavenge.
     ObjectMemory tenure
     ... continue - objects created above are now in oldSpace ...
    "
!

tenuringScavenge
    "collect newspace stuff, with aging (i.e. objects old enough
     will be moved into the oldSpace).
     Use this for debugging and testing only - the system performs
     this automatically when the newspace fills up.
     This is relatively fast (compared to oldspace collect)"
%{
    __scavenge();
%}

    "
     ObjectMemory tenuringScavenge
    "
!

verboseGarbageCollect
    "perform a compressing garbage collect and show some informational
     output on the Transcript"

    |nBytesBefore nReclaimed value unit|

    nBytesBefore := self oldSpaceUsed.

    self nonVerboseGarbageCollect.

    "/ show what we reclaimed
    nReclaimed := nBytesBefore - self oldSpaceUsed.
    nReclaimed > 0 ifTrue:[
	nReclaimed > 1024 ifTrue:[
	    nReclaimed > (1024 * 1024) ifTrue:[
		value := nReclaimed * 10 // (1024 * 1024) / 10.0.
		unit := ' Mb.'
	    ] ifFalse:[
		value := nReclaimed // 1024.
		unit := ' Kb.'
	    ]
	] ifFalse:[
	    value := nReclaimed.
	    unit := ' bytes.'
	].
	Transcript show:'reclaimed '; show:value.
	Transcript showCR:unit
    ]

    "
     ObjectMemory verboseGarbageCollect
    "

    "Modified: / 15.7.1998 / 13:28:05 / cg"
! !

!ObjectMemory class methodsFor:'garbage collector control'!

allowTenureOf:anObject
    "set the age of anObject back to 0 so it may eventually tenure
     into old space.
     This should only be used in very special situations.
     One such situation may be to ensure that an object is finalized early by the next
     scavenge, and not by a (possibly late) old space collect.
     To undo this setup (i.e. to allow the object to tenure again), set its age back to
     any value with the seatAgeOf:to: message.
     If the object is already old, this call has no effect.
     WARNING: this method is for ST/X experts only
	      it is dangerous, should be used with care
	      and it may be removed without notice"


    self setAgeOf:anObject to:0

    "
    |p|
    p := Point new.
    Transcript showCR:(ObjectMemory preventTenureOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    ObjectMemory tenure.
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory setAgeOf:p to:30.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    "
!

announceOldSpaceNeed:howMuch
    "announce to the memory system, that howMuch bytes of memory will be needed
     soon, which is going to live longer (whatever that means).
     It first checks if the memory can be allocated without forcing a compressing
     GC. If not, the oldSpace is increased. This may also lead to a slow compressing
     collect. However, many smaller increases are avoided afterwards. Calling this
     method before allocating huge chunks of data may provide better overall performance.
     Notice: this is a nonstandard interface - use only in special situations."

    (self checkForFastNew:howMuch) ifFalse:[
	self incrementalGC.
	(self checkForFastNew:howMuch) ifFalse:[
	    self moreOldSpace:howMuch
	]
    ]

    "
     ObjectMemory announceOldSpaceNeed:1000000
    "
!

announceSpaceNeed:howMuch
    "announce to the memory system, that howMuch bytes of memory will be needed
     soon. The VM tries to prepare itself for this allocation to be performed
     with less overhead. For example, it could preallocate some memory in one
     big chunk (instead of doing many smaller reallocations later).
     Notice: this is a nonstandard interface - use only in special situations.
     Also, this does a background collect before the big chunk of memory is
     allocated, not locking other processes while doing so."

    (howMuch < (self newSpaceSize // 2)) ifTrue:[
	self scavenge.
    ].
    (self checkForFastNew:howMuch) ifFalse:[
	(howMuch > (self newSpaceSize // 2)) ifFalse:[
	    self scavenge.
	].
	self incrementalGC.
	(self checkForFastNew:howMuch) ifFalse:[
	    self moreOldSpace:howMuch
	]
    ]

    "
     ObjectMemory announceSpaceNeed:100000
    "
!

avoidTenure:flag
    "set/clear the avoidTenure flag. If set, aging of newSpace is turned off
     as long as the newSpace fill-grade stays below some magic high-water mark.
     If off (the default), aging is done as usual.
     If the flag is turned on, scavenge may be a bit slower, due to more
     objects being copied around. However, chances are high that in an idle
     or (almost idle) system, less objects are moved into oldSpace.
     Therefore, this helps to avoid oldSpace collects, in systems which go into
     some standby mode and are reactivated by some external event.
     (the avoid-flag should be turned off there, and set again once the idle loop
     is reentered).

    This is an EXPERIMENTAL interface."

%{  /* NOCONTEXT */
    __avoidTenure(flag == true ? 1 : 0, 0);
%}.

    self saveGarbageCollectorSetting:#avoidTenure: value:flag.
!

avoidTenure:flag fraction:edenFraction
    "set/clear the avoidTenure flag and set the fraction of eden to be kept.
     If set, aging of newSpace is turned off
     as long as the newSpace fill-grade stays below a 1/edenFraction high-water mark.
     If off (the default), aging is done as usual.
     If the flag is turned on, scavenge may be a bit slower, due to more
     objects being copied around. However, chances are high that in an idle
     or (almost idle) system, less objects are moved into oldSpace.
     Therefore, this helps to avoid oldSpace collects, in systems which go into
     some standby mode and are reactivated by some external event.
     (the avoid-flag should be turned off there, and set again once the idle loop
     is reentered).

    This is an EXPERIMENTAL interface."

%{  /* NOCONTEXT */
    __avoidTenure(flag == true ? 1 : 0, __intVal(edenFraction));
%}.

    self saveGarbageCollectorSetting:#avoidTenure: value:flag.
!

checkForFastNew:amount
    "this method returns true, if amount bytes could be allocated
     quickly (i.e. without forcing a full GC or compress).
     This can be used for smart background processes, which want to
     allocate big chunks of data without disturbing foreground processes
     too much. Such a process would check for fast-allocation, and perform
     incremental GC-steps if required. Thus, avoiding the long blocking pause
     due to a forced (non-incremental) GC.
     Especially: doing so will not block higher priority foreground processes.
     See an example use in Behavior>>niceBasicNew:.
     This is experimental and not guaranteed to be in future versions."

%{  /* NOCONTEXT */
    extern int __checkForFastNew();

    if (__isSmallInteger(amount)) {
	if (! __checkForFastNew(__intVal(amount))) {
	    RETURN (false);
	}
    }

%}.
    ^ true
!

dynamicCodeGCTrigger
    "return the dynamic code trigger limit for incremental GC activation.
     The system will start doing incremental background GC, whenever this amount
     of code was dynamically generated.
     The default is nil; which disables this trigger"

    ^ DynamicCodeGCTrigger

    "
     ObjectMemory dynamicCodeGCTrigger
    "

    "Created: 16.10.1996 / 17:42:01 / cg"
!

dynamicCodeGCTrigger:numberOfBytesOrNil
    "set the dynamic code trigger limit for incremental GC activation.
     The system will start doing incremental background GC, whenever this amount
     of code was dynamically generated.
     The default is nil; which disables this trigger"

    (numberOfBytesOrNil notNil and:[numberOfBytesOrNil > 0]) ifTrue:[
	DynamicCodeGCTrigger := numberOfBytesOrNil.
    ] ifFalse:[
	DynamicCodeGCTrigger := nil
    ]

    "
     ObjectMemory dynamicCodeGCTrigger:50000
    "

    "Created: 16.10.1996 / 17:42:29 / cg"
!

dynamicCodeLimit
    "return the dynamic code limit.
     The system will start doing incremental background GC, whenever this amount
     of code has been generated (overall), and start to flush the code cache,
     if (after the GC), more code is still allocated.
     The default is nil; which disables this trigger"

    DynamicCodeLimit := self getCompiledCodeLimit.
    ^ DynamicCodeLimit

    "
     ObjectMemory dynamicCodeLimit
    "

    "Created: 16.10.1996 / 17:43:37 / cg"
!

dynamicCodeLimit:nBytesOrNil
    "set the dynamic code limit.
     The system will start doing incremental background GC, whenever this amount
     of code has been generated (overall), and start to flush the code cache,
     if (after the GC), more code is still allocated.
     The default is nil; which disables this trigger"

    self setCompiledCodeLimit:nBytesOrNil.
    DynamicCodeLimit := self getCompiledCodeLimit.

    "
     ObjectMemory dynamicCodeLimit:100000
    "

    "Created: 16.10.1996 / 17:43:58 / cg"
    "Modified: 16.10.1996 / 19:30:46 / cg"
!

fastMoreOldSpaceAllocation:aBoolean
    "this method turns on/off fastMoreOldSpace allocation.
     By default, this is turned off (false), which means that in case of
     a filled-up oldSpace, a GC is tried first before more oldSpace is allocated.
     This strategy is ok for the normal operation of the system,
     but behaves badly, if the program allocates huge data structures (say a
     game tree of 30Mb in size) which survives and therefore will not be reclaimed
     by a GC.
     Of course while building this tree, and the memory becomes full, the system
     would not know in advance, that the GC will not reclaim anything.

     Setting fastMoreOldSpaceAllocation to true will avoid this, by forcing the
     memory system to allocate more memory right away, without doing a GC first.

     WARNING: make certain that this flag is turned off, after your huge data
     is allocated, since otherwise the system may continue to increase its
     virtual memory without ever checking for garbage.
     This method returns the previous value of the flag; typically this return
     value should be used to switch back."

    |result|

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
     extern int __fastMoreOldSpaceAllocation();

     result = __fastMoreOldSpaceAllocation(aBoolean == true ? 1 : 0) ? true : false;
#endif
%}.
    self saveGarbageCollectorSetting:#fastMoreOldSpaceAllocation: value:aBoolean.

     ^ result

    "
     |previousSetting|

     previousSetting := ObjectMemory fastMoreOldSpaceAllocation:true.
     [
	...
	allocate your huge data
	...
     ] ensure:[
	ObjectMemory fastMoreOldSpaceAllocation:previousSetting
     ]
    "

    "
     |prev this|

     prev := ObjectMemory fastMoreOldSpaceAllocation:true.
     ObjectMemory fastMoreOldSpaceAllocation:prev.
     ^ prev
    "

    "Modified: / 03-08-2004 / 18:05:31 / stefan"
!

fastMoreOldSpaceLimit:aNumber
    "this method sets and returns the fastMoreOldSpace limit.
     If fastMoreOldSpaceAllocation is true, and the current oldSpace size is
     below this limit, the memory manager will NOT do a GC when running out of
     oldSpace, but instead quickly go ahead increasing the size of the oldSpace.
     Setting the limit to 0 turns off any limit (i.e. it will continue to
     increase the oldSpace forwever - actually, until the OS refuses to give us
     more memory). The returned value is the previous setting of the limit."

    |result|

%{
     extern unsigned int __fastMoreOldSpaceLimit();

     if (__isInteger(aNumber)) {
	 result = __MKUINT( __fastMoreOldSpaceLimit(__unsignedLongIntVal(aNumber)));
     }
%}.
    result isNil ifTrue:[
	^ 0.
    ].
    self saveGarbageCollectorSetting:#fastMoreOldSpaceLimit: value:aNumber.
    ^ result.

    "
     |prev this|

     prev := ObjectMemory fastMoreOldSpaceLimit:10*1024*1024.
     ObjectMemory fastMoreOldSpaceLimit:prev.
     ^ prev
    "
!

freeSpaceGCAmount
    "return the amount to be allocated if, after an incrementalGC,
     not at least FreeSpaceGCLimit bytes are available for allocation.
     The default is nil, which lets the system compute an abbpropriate value"

    ^ FreeSpaceGCAmount

    "
     ObjectMemory freeSpaceGCAmount
    "
!

freeSpaceGCAmount:aNumber
    "set the amount to be allocated if, after an incrementalGC,
     not at least FreeSpaceGCLimit bytes are available for allocation.
     The amount should be greater than the limit, otherwise the incremental
     GC may try over and over to get the memory (actually waisting time)."

    FreeSpaceGCAmount := aNumber

    "
     the following will try to always keep at least 1meg of free space
     (in the background) and start to do so, whenever the freeSpace drops
     below 250k.
    "
    "
     ObjectMemory freeSpaceGCLimit:250000.
     ObjectMemory freeSpaceGCAmount:1000000.
    "

    "
     turn it off (i.e. let the system compute an appropriate amount ...)
    "
    "
     ObjectMemory freeSpaceGCAmount:nil.
    "
!

freeSpaceGCLimit
    "return the freeSpace limit for incremental GC activation.
     The system will start doing incremental background GC, once less than this number
     of bytes are available in the compact free space.
     The default is 100000; setting it to nil will turn this trigger off."

    ^ FreeSpaceGCLimit

    "
     ObjectMemory freeSpaceGCLimit
    "
!

freeSpaceGCLimit:aNumber
    "set the freeSpace limit for incremental GC activation.
     The system will start doing incremental background GC, once less than this number
     of bytes are available for allocation.
     The default is nil; setting it to nil will turn this trigger off."

    FreeSpaceGCLimit := aNumber

    "
     the following will start the incrementalGC (in the background)
     whenever the freeSpace drops below 1meg of free space
    "
    "
     ObjectMemory freeSpaceGCLimit:1000000.
    "

    "
     turn it off (i.e. let the system hit the wall ...)
    "
    "
     ObjectMemory freeSpaceGCLimit:nil.
    "
!

incrementalGCLimit
    "return the allocatedSinceLastGC limit for incremental GC activation.
     The system will start doing incremental background GC, once more than this number
     of bytes have been allocated since the last GC.
     The default is 500000; setting it to nil will turn this trigger off."

    ^ IncrementalGCLimit

    "
     ObjectMemory incrementalGCLimit
    "
!

incrementalGCLimit:aNumber
    "set the allocatedSinceLastGC limit for incremental GC activation.
     The system will start doing incremental background GC, once more than this number
     of bytes have been allocated since the last GC.
     The default is 500000; setting it to nil will turn this trigger off."

    IncrementalGCLimit := aNumber

    "
     ObjectMemory incrementalGCLimit:500000.  'do incr. GC very seldom'
     ObjectMemory incrementalGCLimit:100000.  'medium'
     ObjectMemory incrementalGCLimit:10000.   'do incr. GC very often'
     ObjectMemory incrementalGCLimit:nil.     'never'
    "
!

incrementalSweep:aBoolean
    "ineable/disable incremental sweeps during background GC.
     This entry is provided as a test interface and should not be
     used by applications - it may vanish without notice"

    |result|

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
     result = __incrementalSweep((aBoolean == true) ? 1 : 0) ? true : false;
#endif
%}.
    self saveGarbageCollectorSetting:#incrementalSweep: value:aBoolean.

    ^ result.

    "
     ObjectMemory incrementalSweep:false.
     ObjectMemory incrementalSweep:true
    "
!

lockTenure:flag
    "set/clear the tenureLock. If the lock is set, the system
     completely turns off tenuring, and objects remain in newSpace (forever).
     Once this lock is set, the system operates only in the newSpace and no memory
     allocations from oldSpace are allowed (except for explicit tenure calls).
     If any allocation request cannot be resoved, the VM raises a memory interrupt,
     clears the lockTenure-flag and returns nil. Thus, it automatically falls back into
     the normal mode of operation, to avoid big trouble
     (fail to allocate memory when handling the exception).

     This interface can be used in applications, which are guaranteed to have their
     working set completely in the newSpace AND want to limit the worst case
     pause times to the worst case scavenge time
     (which itself is limitd by the size of the newSpace).
     I.e. systems which go into some event loop after initial startup,
     may turn on the tenureLock to make certain that no oldSpace memory is
     allocated in the future; thereby limiting any GC activity to newSpace scavenges only.

     This is an EXPERIMENTAL interface.
    "

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    if (flag == true) {
	__tenure(__context);
    }
    __lockTenure(flag == true ? 1 : 0);
#endif
%}.

    self saveGarbageCollectorSetting:#lockTenure: value:flag.
!

makeOld:anObject
    "move anObject into oldSpace.
     This method is for internal & debugging purposes only -
     it may vanish. Don't use it, unless you know what you are doing."

    ^ self makeOld:anObject now:false
!

makeOld:anObject now:aBoolean
    "move anObject into oldSpace.
     If aBoolean is true, this is done immediately, but takes some processing time.
     Otherwise, it will be done on-the-fly in the near future, without any cost.
     If multiple objects are to be aged this way, pass a false as argument.
     This method is for internal & debugging purposes only -
     it may vanish. Don't use it, unless you know what you are doing."
%{
    if (__moveToOldSpace(anObject, (OBJ)__context, aBoolean==true) < 0) {
	RETURN (false);
    }
%}.
    ^ true
!

maxOldSpace
    "return the maxOldSpace value. If non-zero, that's the limit for which the
     VM will try hard to not allocate more oldSpace memory. (its not a hard limit)
     If zero, it will allocate forever (until the OS wont hand out more).
     The default is zero."

%{  /* NOCONTEXT */
    extern unsigned INT __maxOldSpace();

    RETURN (__MKUINT( __maxOldSpace((unsigned INT)-1) ));
%}.
    ^ 0
    "
     ObjectMemory maxOldSpace
    "
!

maxOldSpace:amount
    "set the maxOldSpace value. If non-zero, that's the limit for which the
     VM will try hard to not allocate more oldSpace memory. (its not a hard limit)
     If zero, it will allocate forever (until the OS wont hand out more).
     The default is zero.
     WARNING:
        an oldSpace limit may lead to trashing due to exorbitant GC activity;
        its usually better to let it allocate more and page in/page out.
        Usually, the background GC will catch up sooner or later and reclaim
        the memory without blocking the system"

    |result|
%{
    extern unsigned INT __maxOldSpace();

    if (__isInteger(amount)) {
        result = __MKUINT( __maxOldSpace(__unsignedLongIntVal(amount)));
    }
%}.
    result notNil ifTrue:[
        self saveGarbageCollectorSetting:#maxOldSpace: value:amount.
        ^ result.
    ].
    ^ 0

    "
     to change maximum to 1GByte:

        ObjectMemory maxOldSpace:1024*1024*1024
    "
!

moreOldSpace:howMuch
    "allocate howMuch bytes more for old objects; return true if this worked,
     false if that failed.
     This is done automatically, when running out of space, but makes
     sense, if its known in advance that a lot of memory is needed to
     avoid multiple reallocations and compresses.
     On systems which do not support the mmap (or equivalent) system call,
     this (currently) implies a compressing garbage collect - so its slow.
     Notice: this is a nonstandard interface - use only in special situations."

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_true();
#else
    if (__isSmallInteger(howMuch)) {
	RETURN( __moreOldSpace((OBJ)__context, __intVal(howMuch)) ? true : false );
    }
    RETURN (false);
#endif
%}
    "
     ObjectMemory moreOldSpace:1000000
    "
!

moreOldSpaceIfUseful
    "to be called after an incremental GC cycle;
     if freeSpace is still below limit, allocate more oldSpace"

    |limit free amount|

    limit := FreeSpaceGCLimit.
    limit notNil ifTrue:[
	"/ if reclaimed space is below limit, we have to allocate more
	"/ oldSpace, to avoid excessive gcSteps (due to freeSpaceLimit
	"/ still not reached)
	"/
	free := self freeSpace + self freeListSpace.
	free < (limit * 3 // 2) ifTrue:[
	    amount := FreeSpaceGCAmount.
	    amount isNil ifTrue:[
		amount := limit * 3 // 2.
	    ].
	    "/ 'ObjectMemory [info]: moreOldSpace to satisfy free-limit' infoPrintCR.
	    (self moreOldSpace:(amount - free + (64*1024))) ifFalse:[
		"/
		"/ could not increase oldspace; reset FreeSpaceGCLimit to avoid
		"/ useless retries
		'ObjectMemory [warning]: could not increase oldSpace - reset limit' errorPrintCR.
		FreeSpaceGCLimit := nil
	    ]
	].
    ].

    "Modified: 10.1.1997 / 17:59:48 / cg"
!

newSpaceSize:newSize
    "
    Change the size of the newSpace. Returns true if newspace 
    has been resized, false otherwise. 

    NOTE: 
    Making newspace smaller forces objects in newspace to tenure. 
    The tenuring may fail for various reasons, most notably: 

      (i)  there's not enough old space to tenure objects to or
      (ii) there are so many non-tenurable objects. 
         
    The former being most likely. Therefore, if shrinking newspace
    fails, you may want to allocate more oldspace (#moreOldSpace:)
    and try again, like:

        (ObjectMemory newSpaceSize: desiredSize) ifFalse:[
            (ObjectMemory moreOldSpace: ObjectMemory newSpaceSize) ifTrue:[
                ObjectMemory newSpaceSize: desiredSize
            ]
        ].

    WARNING
	be careful too big of a size may lead to longer scavenge pauses.
	Too small of a newSpace may lead to more CPU overhead, due to
	excessive scavenges. You have been warned."

   |result|

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    extern int __setNewSpaceSize();

    if (__isSmallInteger(newSize)) {
	result = __setNewSpaceSize(__intVal(newSize)) ? true : false;
    }
#endif
%}.
    result isNil ifTrue:[
	self primitiveFailed.
    ].
    result ifTrue:[
	self saveGarbageCollectorSetting:#newSpaceSize: value:newSize.
    ].
    ^ result.

    " less absolute CPU overhead (but longer pauses):

     ObjectMemory newSpaceSize:1600*1024
    "

    " smaller pauses, but more overall CPU overhead:

     ObjectMemory newSpaceSize:200*1024
    "

    " the default:

     ObjectMemory newSpaceSize:800*1024
    "
!

oldSpaceCompressLimit
    "return the limit for oldSpace compression. If more memory than this
     limit is in use, the system will not perform compresses on the oldspace,
     but instead do a mark&sweep GC followed by an oldSpace increase if not enough
     could be reclaimed. The default is currently some 8Mb, which is ok for workstations
     with 16..32Mb of physical memory. If your system has much more physical RAM,
     you may want to increase this limit."

%{  /* NOCONTEXT */
    extern unsigned INT __compressingGCLimit();

    RETURN (__MKUINT( __compressingGCLimit((unsigned INT)-1) ));
%}.
    ^ 0
    "
     ObjectMemory oldSpaceCompressLimit
    "
!

oldSpaceCompressLimit:amount
    "set the limit for oldSpace compression. If more memory than this
     limit is in use, the system will not perform compresses on the oldspace,
     but instead do a mark&sweep GC followed by an oldSpace increase if not enough
     could be reclaimed. The default is currently some 8Mb, which is ok for workstations
     with 16..32Mb of physical memory. If your system has much more physical RAM,
     you may want to increase this limit.
     This method returns the previous increment value."

    |result|

%{
    extern unsigned INT __compressingGCLimit();

    if (__isInteger(amount)) {
	result = __MKUINT( __compressingGCLimit((unsigned INT)__unsignedLongIntVal(amount)) );
    }
%}.
    result isNil ifTrue:[
	^ 0.
    ].
    self saveGarbageCollectorSetting:#oldSpaceCompressLimit: value:amount.
    ^ result.

    "to change the limit to 12Mb:"
    "
     ObjectMemory oldSpaceCompressLimit:12*1024*1024
    "
!

oldSpaceIncrement
    "return the oldSpaceIncrement value. That's the amount by which
     more memory is allocated in case the oldSpace gets filled up.
     In normal situations, the default value used in the VM is fine
     and there is no need to change it."

%{  /* NOCONTEXT */
    extern unsigned INT __oldSpaceIncrement();

    RETURN (__MKUINT( __oldSpaceIncrement((unsigned INT)-1) ));
%}.
    ^ 0
    "
     ObjectMemory oldSpaceIncrement
    "
!

oldSpaceIncrement:amount
    "set the oldSpaceIncrement value. That's the amount by which
     more memory is allocated in case the oldSpace gets filled up.
     In normal situations, the default value used in the VM is fine
     and there is no need to change it. This method returns the
     previous increment value."

    |result|

%{
    extern unsigned INT __oldSpaceIncrement();

    if (__isInteger(amount)) {
        result = __MKUINT( __oldSpaceIncrement((unsigned INT)__unsignedLongIntVal(amount)) );
    }
%}.
    result isNil ifTrue:[
        ^ 0.
    ].
    self saveGarbageCollectorSetting:#oldSpaceIncrement: value:amount.
    ^ result.

    "to change increment to 1Meg:"
    "
     ObjectMemory oldSpaceIncrement:1024*1024
    "
!

preventTenureOf:anObject
    "set the age of anObject to the never-tenure special age.
     This prevents the object from ever going out of the new space,
     and if used without care may lead to a filling of the newspace to a point,
     where the system becomes inoperable.
     Therefore it should only be used in very special situations.
     One such situation may be to ensure that an object is finalized early by the next
     scavenge, and not by a (possibly late) old space collect.
     To undo this setup (i.e. to allow the object to tenure again), set its age back to
     any value with the setAgeOf:to: message.
     If the object is already old, this call has no effect.
     WARNING: this method is for ST/X experts only
	      it is dangerous, should be used with care
	      and it may be removed without notice"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    if (__isNonNilObject(anObject)) {
	__SET_AGE(anObject, NO_TENURE_AGE);
    }
#endif
%}
    "
    |p|
    p := Point new.
    Transcript showCR:(ObjectMemory preventTenureOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    ObjectMemory tenure.
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory setAgeOf:p to:30.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenure.
    Transcript showCR:(ObjectMemory ageOf:p).
    "
!

setAgeOf:anObject to:newAge
    "change the age of anObject.
     This counts the number of scavenges that an object has survived in new space.
     If it is set to 0, this makes GC think, that the object is just created, and it will
     remain in eden for a longer time.
     If it is set to a big number (say > 32), GC will think that it is old, and tenure it
     with the next collect into old space. This later operation will get the object out of the way,
     if it is well-known, that it will survive for a very long time.
     For old space objects, this is a no-op.

     WARNING: this method is for ST/X debugging only
	      it may be removed without notice"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    if (__isNonNilObject(anObject) && __isSmallInteger(newAge)) {
	int age = __intVal(newAge);

	if (age < 0) age = 0;
	else if (age > AGE_MAX) age = AGE_MAX;
	__SET_AGE(anObject, age);
    }
#endif
%}
    "
    |p|
    p := Point new.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory setAgeOf:p to:0.
    Transcript showCR:(ObjectMemory ageOf:p).
    ObjectMemory tenuringScavenge.
    Transcript showCR:(ObjectMemory ageOf:p).
    "
!

tenureParameters:magic
    "this is pure magic and not for public eyes ...
     This method allows fine tuning the scavenger internals,
     in cooperation to some statistic & test programs.
     It is undocumented, secret and may vanish.
     If you play around here, the system may behave very strange."

%{  /* NOCONTEXT */
    __tenureParams(magic);
%}.
    self saveGarbageCollectorSetting:#tenureParameters: value:magic.
!

turnGarbageCollectorOff
    "turn off the generational garbage collector by forcing new objects to be
     allocated directly in oldSpace (instead of newSpace)
     WARNING:
     This is somewhat dangerous: if collector is turned off,
     and too many objects are created, the system may run into trouble
     (i.e. oldSpace becomes full) and be forced to perform a full mark&sweep
     or even a compressing collect - making the overall realtime behavior worse.
     Use this only for special purposes or when realtime behavior
     is required for a limited time period.

     OBSOLETE: this is no longer supported
	       - it may be a no-operation by the time you read this."

%{  /* NOCONTEXT */
    __allocForceSpace(OLDSPACE);
%}
!

turnGarbageCollectorOn
    "turn garbage collector on again (see ObjectMemory>>turnGarbageCollectorOff)"

%{  /* NOCONTEXT */
    __allocForceSpace(9999);
%}
!

watchTenure:flag
    "set/clear the tenureWatch. If set, an internalError exception will be raised,
     whenever objects are tenured from newSpace into oldSpace
     (except for an explicit tenure request).
     This can be used to validate that no oldSpace objects are created
     (i.e. the system operates fully in newSpace).
     Be careful, if the avoidTenure flag is not set,
     there will almost always be a tenure sooner or later.

    EXPERIMENTAL - no warranty"

%{  /* NOCONTEXT */
    __watchTenure(flag == true ? 1 : 0);
%}
! !

!ObjectMemory class methodsFor:'garbage collector settings'!

restoreGarbageCollectorSettings
   "restore the saved garbage collector settings"

   SavedGarbageCollectorSettings isEmptyOrNil ifTrue:[
	^ self.
   ].
   SavedGarbageCollectorSettings keysAndValuesDo:[:eachKey :eachValue|
	eachKey numArgs == 1 ifTrue:[
	    self perform:eachKey with:eachValue.
	] ifFalse:[
	    self perform:eachKey.
	].
   ].
!

saveGarbageCollectorSetting:aSymbol value:something
   "save some garbage collector setting, which is stored only in the VM,
    to be restored on snapshot return"

   SavedGarbageCollectorSettings isNil ifTrue:[
	SavedGarbageCollectorSettings := IdentityDictionary new.
   ].
   SavedGarbageCollectorSettings at:aSymbol put:something.
! !

!ObjectMemory class methodsFor:'interrupt handler access'!

childSignalInterruptHandler
    "return the handler for UNIX-death-of-a-childprocess-signal interrupts"

    ^ ChildSignalInterruptHandler
!

childSignalInterruptHandler:aHandler
    "set the handler for UNIX-death-of-a-childprocess-signal interrupts"

    ChildSignalInterruptHandler := aHandler

    "Created: 22.12.1995 / 14:14:52 / stefan"
    "Modified: 22.12.1995 / 14:15:16 / stefan"
!

customInterruptHandler
    "return the handler for custom interrupts"

    ^ CustomInterruptHandler
!

customInterruptHandler:aHandler
    "set the handler for custom interrupts"

    CustomInterruptHandler := aHandler
!

disposeInterruptHandler
    "return the handler for object disposal interrupts"

    ^ DisposeInterruptHandler
!

disposeInterruptHandler:aHandler
    "set the handler for object disposal interrupts"

    DisposeInterruptHandler := aHandler
!

errorInterruptHandler
    "return the handler for display error interrupts"

    ^ ErrorInterruptHandler
!

errorInterruptHandler:aHandler
    "set the handler for display error interrupts"

    ErrorInterruptHandler := aHandler
!

exceptionInterruptHandler
    "return the handler for floating point exception interrupts"

    ^ ExceptionInterruptHandler
!

internalErrorHandler
    "return the handler for ST/X internal errors.
     An internal error is reported for example when a methods
     bytecode is not a ByteArray, the selector table is not an Array
     etc.
     Those should not occur in normal circumstances."

    ^ InternalErrorHandler
!

ioInterruptHandler
    "return the handler for I/O available signal interrupts (SIGIO/SIGPOLL)"

    ^ IOInterruptHandler
!

ioInterruptHandler:aHandler
    "set the handler for I/O available signal interrupts (SIGIO/SIGPOLL)"

    IOInterruptHandler := aHandler
!

recursionInterruptHandler
    "return the handler for recursion/stack overflow interrupts"

    ^ RecursionInterruptHandler
!

recursionInterruptHandler:aHandler
    "set the handler for recursion/stack overflow interrupts"

    RecursionInterruptHandler := aHandler
!

registerErrorInterruptHandler:aHandler forID:errorIDSymbol
    "register a handler"

    RegisteredErrorInterruptHandlers isNil ifTrue:[
	RegisteredErrorInterruptHandlers := IdentityDictionary new
    ].
    RegisteredErrorInterruptHandlers at:errorIDSymbol put:aHandler
!

registeredErrorInterruptHandlers
    "return registered handlers"

    ^ RegisteredErrorInterruptHandlers
!

signalInterruptHandler
    "return the handler for UNIX-signal interrupts"

    ^ SignalInterruptHandler
!

signalInterruptHandler:aHandler
    "set the handler for UNIX-signal interrupts"

    SignalInterruptHandler := aHandler
!

spyInterruptHandler
    "return the handler for spy-timer interrupts"

    ^ SpyInterruptHandler
!

spyInterruptHandler:aHandler
    "set the handler for spy-timer interrupts"

    SpyInterruptHandler := aHandler
!

stepInterruptHandler
    "return the handler for single step interrupts"

    ^ StepInterruptHandler
!

stepInterruptHandler:aHandler
    "set the handler for single step interrupts"

    StepInterruptHandler := aHandler
!

timerInterruptHandler
    "return the handler for timer interrupts"

    ^ TimerInterruptHandler
!

timerInterruptHandler:aHandler
    "set the handler for timer interrupts"

    TimerInterruptHandler := aHandler
!

userInterruptHandler
    "return the handler for CNTL-C interrupt handling"

    ^ UserInterruptHandler
!

userInterruptHandler:aHandler
    "set the handler for CNTL-C interrupt handling"

    UserInterruptHandler := aHandler
! !

!ObjectMemory class methodsFor:'interrupt statistics'!

interruptLatency:ms receiver:rec class:cls selector:sel vmActivity:vmActivity id:pid
    "example implementation of latencyTime monitoring:
     This method simply measures the max-latency time.
     You may want to use some other handler (see #interruptLatencyMonitor:)
     and extract more information (blocking context).
     DEMO Example."

    ms > MaxInterruptLatency ifTrue:[
	MaxInterruptLatency := ms.
	'IRQ-LATENCY: ' infoPrint. cls infoPrint. ' ' infoPrint. sel infoPrint. '(' infoPrint. vmActivity infoPrint . ') ---> ' infoPrint. ms infoPrintCR.
    ].
    (InterruptLatencyGoal notNil and:[ms > InterruptLatencyGoal]) ifTrue:[
	'*** IRQ REALTIME-DEADLINE MISSED: ' errorPrint.
	cls errorPrint.
	' ' errorPrint. sel errorPrint. '(' errorPrint. vmActivity errorPrint . ') ---> ' errorPrint.
	ms errorPrintCR.
    ].

    "to enable the demo handler:

     ObjectMemory resetMaxInterruptLatency.
     ObjectMemory interruptLatencyMonitor:ObjectMemory.
    "
    "to disable timing statistics:

     ObjectMemory interruptLatencyMonitor:nil.
     ObjectMemory maxInterruptLatency printCR.
    "

    "Created: 7.11.1995 / 21:05:50 / cg"
    "Modified: 18.6.1996 / 14:15:52 / stefan"
    "Modified: 10.1.1997 / 19:09:53 / cg"
!

interruptLatencyGoal:millis
    "setup to report an error message, whenever a realtime goal could not be
     met due to blocked interrupts or long primitives or GC activity.
     An argument of nil clears the check.
     DEMO Example."

    InterruptLatencyGoal := millis.
    millis isNil ifTrue:[
	InterruptLatencyMonitor := nil.
    ] ifFalse:[
	MaxInterruptLatency := 0.
	InterruptLatencyMonitor := self.
    ]

    "
     ObjectMemory interruptLatencyGoal:50
    "
!

interruptLatencyMonitor
    "return the interrupt-latency-monitor if any.
     See comment in #interruptLatencyMonitor:.
     This is a non-standard debugging/realtime instrumentation entry."

    ^ InterruptLatencyMonitor
!

interruptLatencyMonitor:aHandler
    "set the interrupt latency monitor. If non-nil, this one will be sent
     an interruptLatency: message with the millisecond delay between
     the interrupt and its handling.
     This is a non-standard debugging/realtime instrumentation entry."

    InterruptLatencyMonitor := aHandler
!

maxInterruptLatency
    "return the maximum accumulated interrupt latency in millis.
     DEMO Example."

    ^ MaxInterruptLatency
!

resetMaxInterruptLatency
    "reset the maximum accumulated interrupt latency probe time.
     DEMO Example."

    MaxInterruptLatency := 0
! !

!ObjectMemory class methodsFor:'just in time compilation'!

byteCodeSizeLimitForDynamicCompilation:aNumber
    "set a limit on a methods number of byteCodes.
     Compilation of a method into machine code is aborted,
     if its bytecode size is larger than the given number.
     This is only useful, if large methods have a smaller
     chance of being evaluated often (which may not be true).
     The predefined limit is some 4k (which seems to be ok)."

%{  /* NOCONTEXT */
    extern int __byteCodeSizeLimitForDynamicCompilation();
    int prev;

    prev = __byteCodeSizeLimitForDynamicCompilation(
				    __isSmallInteger(aNumber)
				    ? __intVal(aNumber)
				    : -1);
    RETURN (__mkSmallInteger(prev));
%}.
    ^ 0

    "
     ObjectMemory byteCodeSizeLimitForDynamicCompilation:nil
     ObjectMemory byteCodeSizeLimitForDynamicCompilation:8000
    "
!

codeForCPU:aCPUSymbol
    "instruct the just in time compiler that some specific CPU
     is present (forcing it to generate code for that).
     The default is set correct for the architecture, and the
     runTime system tries to figure out the cpu - but who knows ...
     The valid symbols depend on the architecture:
	i386:   #i486 / #i586           (affects code ordering)
	sparc:  #sparcV8 / #sparcV8     (affects instruction set)
	mips:   #rs2000 / #rs4000       (affects delay slot generation)
     This method returns the current setting; a nil arg will not change
     the setting (but only return the current).

     This is a nonstandard entry and may be removed without notice -
     not for the general user."

%{  /* NOCONTEXT */
    extern OBJ __codeForCPU();

    RETURN (__codeForCPU(aCPUSymbol));
%}.
    ^ nil

    "
     ObjectMemory codeForCPU:nil
     ObjectMemory codeForCPU:#i486
     ObjectMemory codeForCPU:#i586
    "
!

codeSizeLimitForDynamicCompilation:aNumber
    "set a limit on the resulting dynamic generates code
     size. Compilation of a method into machine code is aborted,
     if the resulting code is larger than the given number of
     bytes. This is only useful, if large methods have a smaller
     chance of being evaluated often (which may not be true).
     The predefined limit is some 4k (which seems to be ok)."

%{  /* NOCONTEXT */
    extern int __codeSizeLimitForDynamicCompilation();
    int prev;

    prev = __codeSizeLimitForDynamicCompilation( __isSmallInteger(aNumber)
				    ? __intVal(aNumber)
				    : -1);
    RETURN (__mkSmallInteger(prev));
%}.
    ^ 0

    "
     ObjectMemory codeSizeLimitForDynamicCompilation:nil
     ObjectMemory codeSizeLimitForDynamicCompilation:8000
    "
!

compiledCodeCounter
    "return the number of additional code-bytes which
     were generated since the counter was last reset"

%{  /* NOCONTEXT */

    extern __compiledCodeCounter();
    int nBytes;

    nBytes = __compiledCodeCounter();
    RETURN (__mkSmallInteger(nBytes));
%}.
    ^ 0

    "
     ObjectMemory compiledCodeCounter
    "
!

compiledCodeSpaceUsed
    "return the actual number of bytes used for compiled code"

%{  /* NOCONTEXT */

    extern __compiledCodeSpaceUsed();
    int nBytes;

    nBytes = __compiledCodeSpaceUsed();
    RETURN (__mkSmallInteger(nBytes));
%}.
    ^ 0

    "
     ObjectMemory compiledCodeSpaceUsed
    "
!

fullSingleStepSupport
    "return the setting of the full single step support flag"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    extern int __fullSingleStep();

    RETURN (__fullSingleStep(-1) ? true : false);
#endif
%}
    "
     ObjectMemory fullSingleStepSupport
    "

!

fullSingleStepSupport:aBoolean
    "enable/disable full single step support for the just-in-time-compiled code.
     If off, things like simple increment/decrement, additions and variable-
     stores are not steppable, but treated like atomar invisible operations.
     If on, single step halts at those operations.
     Execution is a bit slower if enabled."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_false();
#else
    extern int __fullSingleStep();
    int prev;

    prev = __fullSingleStep(aBoolean == true
				   ? 1
				   : (aBoolean == false)
					? 0
					: -1);
    RETURN (prev ? true : false);
#endif
%}
    "
     ObjectMemory fullSingleStepSupport:true
     ObjectMemory fullSingleStepSupport:false
    "

!

getCompiledCodeLimit
    "get the codeLimit from the VM"

%{  /* NOCONTEXT */
    extern int __dynamicCodeLimit();
    int limit;

    limit = __dynamicCodeLimit();
    if (limit) {
	RETURN (__mkSmallInteger(limit));
    }
%}.
    ^ nil
!

insnSizeLimitForDynamicCompilation:aNumber
    "set a limit on a methods number of internal insns.
     Compilation of a method into machine code is aborted,
     if during compilation, more than the given number of
     internal insns are generated.
     The limit controls the amount of dynamic memory allocated
     during compilation and may be changed for small-memory
     systems.
     The predefined limit is some 4k (which seems to be ok)."

%{  /* NOCONTEXT */
    extern int __insnSizeLimitForDynamicCompilation();
    int prev;

    prev = __insnSizeLimitForDynamicCompilation( __isSmallInteger(aNumber)
				    ? __intVal(aNumber)
				    : -1);
    RETURN (__mkSmallInteger(prev));
%}.
    ^ 0

    "
     ObjectMemory insnSizeLimitForDynamicCompilation:nil
     ObjectMemory insnSizeLimitForDynamicCompilation:8000
    "
!

javaJustInTimeCompilation
    "return the value of the java-just-in-time-compilation flag"

%{  /* NOCONTEXT */
    extern int __javaJustInTimeCompilation();

    RETURN (__javaJustInTimeCompilation(-1) ? true : false);
%}.
    ^ false

    "
     ObjectMemory javaJustInTimeCompilation
    "

!

javaJustInTimeCompilation:aBoolean
    "enable/disable java just-in-time-compilation."

    aBoolean notNil ifTrue:[
	JavaJustInTimeCompilationEnabled := aBoolean.
    ].

%{  /* NOCONTEXT */
    extern int __javaJustInTimeCompilation();
    int prev;

    prev = __javaJustInTimeCompilation(aBoolean == true
				   ? 1
				   : (aBoolean == false)
					? 0
					: -1);
    RETURN (prev ? true : false);
%}.
    "
     ObjectMemory javaJustInTimeCompilation:true
     ObjectMemory javaJustInTimeCompilation:false
    "
!

javaNativeCodeOptimization
    "return the value of the java-native-code-optimization flag"

%{  /* NOCONTEXT */
    extern int __javaNativeCodeOptimization();

    RETURN (__javaNativeCodeOptimization(-1) ? true : false);
%}
    "
     ObjectMemory javaNativeCodeOptimization
    "

!

javaNativeCodeOptimization:aBoolean
    "enable/disable java native code-optimization."

    aBoolean notNil ifTrue:[
	JavaNativeCodeOptimization := aBoolean.
    ].

%{  /* NOCONTEXT */
    extern int __javaNativeCodeOptimization();
    int prev;

    prev = __javaNativeCodeOptimization(aBoolean == true
				   ? 1
				   : (aBoolean == false)
					? 0
					: -1);
    RETURN (prev ? true : false);
%}.
    "
     ObjectMemory javaNativeCodeOptimization:true
     ObjectMemory javaNativeCodeOptimization:false
    "
!

justInTimeCompilation
    "return the value of the just-in-time-compilation flag"

%{  /* NOCONTEXT */
    extern int __justInTimeCompilation();

    RETURN (__justInTimeCompilation(-1) ? true : false);
%}
    "
     ObjectMemory justInTimeCompilation
    "

!

justInTimeCompilation:aBoolean
    "enable/disable just-in-time-compilation."

    aBoolean notNil ifTrue:[
	JustInTimeCompilationEnabled := aBoolean.
    ].

%{  /* NOCONTEXT */
    extern int __justInTimeCompilation();
    int prev;

    prev = __justInTimeCompilation(aBoolean == true
				   ? 1
				   : (aBoolean == false)
					? 0
					: -1);
    RETURN (prev ? true : false);
%}.
    ^ false

    "
     ObjectMemory justInTimeCompilation:true
     ObjectMemory justInTimeCompilation:false
    "
!

optimizeContexts
    "return the setting of the optimize contexts flag"

%{  /* NOCONTEXT */
    extern int __optimizeContexts();

    RETURN (__optimizeContexts(-1) ? true : false);
%}.
    ^ false

    "
     ObjectMemory optimizeContexts
    "
!

optimizeContexts:aBoolean
    "enable/disable restartable contexts for the just-in-time-compiled code.
     If off, contexts that does not contain blocks are not restartable.
     Execution is a bit slower if enabled."

%{  /* NOCONTEXT */
    extern int __optimizeContexts();
    int prev;

    prev = __optimizeContexts(aBoolean == true
				   ? 1
				   : (aBoolean == false)
					? 0
					: -1);
    RETURN (prev ? true : false);
%}.
    ^ false

    "
     ObjectMemory optimizeContexts:true
     ObjectMemory optimizeContexts:false
    "
!

reEnableJustInTimeCompilation
    "to be called after a snapshot restart; if justInTimeCompiler
     was enabled before, do it again.
     For now, this is not done automatically, to allow restarting
     a system with the dynamic compiler turned off (its still experimental).
     Therefore, this reenabling is done in the smalltalk_r.rc file."

    JustInTimeCompilationEnabled == true ifTrue:[
	self justInTimeCompilation:true
    ].
    JavaJustInTimeCompilationEnabled == true ifTrue:[
	self javaJustInTimeCompilation:true
    ].
    JavaNativeCodeOptimization == true ifTrue:[
	self javaNativeCodeOptimization:true
    ].

    "Modified: / 5.11.1998 / 15:00:00 / cg"
!

resetCompiledCodeCounter
    "reset the counter of additional code-bytes"

%{  /* NOCONTEXT */

    extern void __resetDynamicCodeGeneratedCounter();

    __resetDynamicCodeGeneratedCounter();
%}
    "
     ObjectMemory resetCompiledCodeCounter
    "

!

setCompiledCodeLimit:newLimit
    "set the VM's limit"

%{  /* NOCONTEXT */
    extern __setDynamicCodeLimit();

    if (__isSmallInteger(newLimit)) {
	__setDynamicCodeLimit(__intVal(newLimit));
    } else if (newLimit == nil) {
	__setDynamicCodeLimit(0);
    }
%}
!

supportsJustInTimeCompilation
    "return true, if this system supports just-in-time-compilation of
     bytecode to machine code. Don't confuse this with stc-compilation."

%{  /* NOCONTEXT */
    extern int __canDoJustInTimeCompilation();

    RETURN (__canDoJustInTimeCompilation() ? true : false);
%}.
    ^ false

    "
     ObjectMemory supportsJustInTimeCompilation
    "
! !

!ObjectMemory class methodsFor:'low memory handling'!

allocationFailed
    "memory allocation has failed in the VM
     This is triggered by the runtime system (or possibly by
     a user primitive)"

    ^ AllocationFailure raiseRequest
!

memoryInterrupt
    "when a low-memory condition arises, ask all classes to
     remove possibly cached data. You may help the system a bit,
     in providing a lowSpaceCleanup method in your classes which have
     lots of data kept somewhere (usually, cached data).
     - this may or may not help."

    self changed:#memoryLow.
    self performLowSpaceCleanup.
"/    self error:'almost out of memory'
    'ObjectMemory [warning]: almost out of memory' errorPrintCR.

    LowSpaceSemaphore signalIf.

    "Modified: 10.1.1997 / 17:59:31 / cg"
!

performLowSpaceCleanup
    "ask all classes to remove possibly cached data.
     You may help the system a bit, in providing a lowSpaceCleanup method
     in your classes which have lots of data kept somewhere (usually, cached data).
     Notice: it may never hurt to call lowSpaceCleanup (i.e. the data must always be
     reconstructable)"

    "avoid to allocate memory here - so don't send Smalltalk>>allClassesDo:,
     which allocates an IdentitySet"

    Smalltalk do:[:eachGlobal|
	eachGlobal isBehavior ifTrue:[
	    eachGlobal lowSpaceCleanup
	].
    ].

    "
     ObjectMemory performLowSpaceCleanup
    "

    "Created: / 12-04-1996 / 14:57:28 / cg"
! !

!ObjectMemory class methodsFor:'object finalization'!

allChangedShadowObjectsDo:aBlock
    "evaluate the argument, aBlock for all known shadow objects which have
     lost a pointer recently."
%{
    __allChangedShadowObjectsDo(&aBlock);
%}
!

backgroundFinalizationProcess
    "return the backgroundFinalizationProcess (or nil, if noone is running)"

    ^ BackgroundFinalizationProcess

    "Created: / 4.8.1998 / 02:00:13 / cg"
!

disposeInterrupt
    "this is triggered by the garbage collector,
     whenever any shadowArray looses a pointer."

    FinalizationSemaphore notNil ifTrue:[
	"/
	"/ background finalizer is waiting ...
	"/
	FinalizationSemaphore signalOnce
    ] ifFalse:[
	"/
	"/ do it right here
	"/
	self finalize
    ]

    "Modified: 13.1.1997 / 17:26:16 / cg"
!

finalize
    "tell all weak objects that something happened."

    FinalizerAccessLock critical:[
        self allChangedShadowObjectsDo:[:aShadowArray |
            Error handle:[:ex |
                'ObjectMemory [warning]: caught error in weakArray processing: ' errorPrint.
                ex description errorPrintCR.
                ex suspendedContext fullPrintAllLevels:10.
                "Restart the do block to clean up the rest of the shadow array.
                 This is safe here, because the old executor that triggered the error
                 has already been removed from the Registry"
                ex restart.
            ] do:[
                aShadowArray lostPointer.
            ].
        ].
    ].
    
    "/ we should change the setup,
    "/ to make the Dependencies collection a dependent
    "/ of all the WeakArrays and WeakIDSets there,
    "/ and send a changed message when any of them looses
    "/ a pointer.
    "/ This would automize the send below.
    "/
    "/ WARNING:
    "/   this can only be done, if the WeakIDSet holds its
    "/   dependends itself (like a WeakArray),
    "/   otherwise we might get trouble.
    "/   Therefore, things are as they are now ;-)

    Dependencies removeEmptyDependencyValues

    "Modified: / 19.10.1998 / 22:03:12 / cg"
    "Modified: / 3.9.1999 / 14:03:05 / ps"
!

startBackgroundFinalizationAt:aPriority
    "start a process doing finalization work in the background.
     Can be used to reduce the pauses created by finalization.
     Normally, these pauses are not noticed; however if you have (say)
     ten thousands of weak objects, these could become long enough to
     make background finalization usefull.
     WARNING: background finalization may lead to much delayed freeing of
     system resources. Especially, you may temporarily run out of free
     color table entries or fileDescriptors etc. Use at your own risk (if at all)"

    |p|

    "/
    "/ its not useful, to run it more than once
    "/
    BackgroundFinalizationProcess notNil ifTrue:[
	BackgroundFinalizationProcess priority:aPriority.
	^ self
    ].

    FinalizationSemaphore := Semaphore new name:'FinalizationSemaphore'.

    p :=
	[
	    [
		[true] whileTrue:[
		    "
		     wait till something to do ...
		    "
		    FinalizationSemaphore wait.
		    "
		     ... and do it
		    "
		    self finalize
		]
	    ] ifCurtailed:[
		BackgroundFinalizationProcess := nil.
		FinalizationSemaphore := nil
	    ]
	] newProcess.
    p name:'background finalizer'.
    p priority:aPriority.
    p restartable:true.
    p beSystemProcess.
    p resume.
    BackgroundFinalizationProcess := p

    "
     ObjectMemory stopBackgroundFinalization.
     ObjectMemory startBackgroundFinalizationAt:5
    "

    "Modified: / 5.8.1998 / 14:53:27 / cg"
!

stopBackgroundFinalization
    "stop the background finalizer"

    BackgroundFinalizationProcess notNil ifTrue:[
	BackgroundFinalizationProcess terminate.
	BackgroundFinalizationProcess := nil
    ].

    "
     ObjectMemory stopBackgroundFinalization
    "
! !

!ObjectMemory class methodsFor:'physical memory access'!

collectedOldSpacePagesDo:aBlock
    "evaluates aBlock for all pages in the prev. oldSpace, passing
     the pages address as argument.
     For internal & debugging use only."

    <resource: #obsolete>

    ^ self error: 'Not supported since Smalltalk/X 8.0.0'.
!

newSpacePagesDo:aBlock
    "evaluates aBlock for all pages in the newSpace, passing
     the pages address as argument.
     For internal & debugging use only."
%{
    if (__newSpacePagesDo(&aBlock) < 0) {
	RETURN (false);
    }
%}.
    ^ true
!

oldSpacePagesDo:aBlock
    "evaluates aBlock for all pages in the oldSpace, passing
     the pages address as argument.
     For internal & debugging use only."
%{
    if (__oldSpacePagesDo(&aBlock) < 0) {
	RETURN (false);
    }
%}.
    ^ true
!

pageIsInCore:aPageNumber
    "return true, if the page (as enumerated via oldSpacePagesDo:)
     is in memory; false, if currently paged out. For internal
     use / monitors only; may vanish.
     NOTICE: not all systems provide this information; on those that
     do not, true is returned for all pages."
%{
#ifdef HAS_MINCORE
    int pageSize = getpagesize();
    char result[10];
    INT addr;

    if (__isSmallInteger(aPageNumber)) {
	addr = __intVal(aPageNumber) & ~(pageSize - 1);
    } else {
	addr = ((INT)aPageNumber) & ~(pageSize - 1);
    }
    if (mincore(addr, pageSize-1, result) < 0) {
	RETURN (true);
    }
    RETURN ((result[0] & 1) ? true : false);
#endif
%}.
    "OS does not supply this info - assume yes"
    ^ true
! !

!ObjectMemory class methodsFor:'queries'!

bytesUsed
    "return the number of bytes allocated for objects -
     this number is not exact, since some objects may already be dead
     (i.e. not yet reclaimed by the garbage collector).
     If you need the exact number, you have to loop over all
     objects and ask for the bytesize using ObjectMemory>>sizeOf:."

%{  /* NOCONTEXT */
    extern unsigned INT __oldSpaceUsed(), __freeListSpace();
    extern unsigned int __newSpaceUsed();

    RETURN ( __MKUINT(__oldSpaceUsed() + (INT)__newSpaceUsed() - __freeListSpace()) );
%}.
    ^ 0

    "
     ObjectMemory bytesUsed
    "
!

collectObjectsWhich:aBlock
    "helper for the whoReferences queries. Returns a collection
     of objects for which aBlock returns true."

    |aCollection|

    aCollection := OrderedCollection new.
    self allObjectsIncludingContextsDo:[:o |
	(aBlock value:o) ifTrue:[
	    aCollection add:o
	]
    ].
    (aCollection size == 0) ifTrue:[
	"actually this cannot happen - there is always one"
	^ nil
    ].
    ^ aCollection
!

collectedOldSpaceAddress
%{
#ifdef COLLECTEDOLD_ADDRESS
    RETURN(__MKUINT(COLLECTEDOLD_ADDRESS));
#else
    RETURN(__mkSmallInteger(0));
#endif
%}.
    ^ 0

    "
	self collectedOldSpaceAddress
    "
!

fixSpaceSize
    "return the total size of the fix space."

%{  /* NOCONTEXT */
    extern unsigned __fixSpaceSize();

    RETURN ( __MKUINT(__fixSpaceSize()) );
%}.
    ^ 0

    "
     ObjectMemory fixSpaceSize
    "
!

fixSpaceUsed
    "return the number of bytes allocated for old objects in fix space."

%{  /* NOCONTEXT */
    extern unsigned __fixSpaceUsed();

    RETURN ( __MKUINT(__fixSpaceUsed()) );
%}.
    ^ 0

    "
     ObjectMemory fixSpaceUsed
    "
!

freeListSpace
    "return the number of bytes in the free lists.
     (which is included in oldSpaceUsed)"

%{  /* NOCONTEXT */
    extern unsigned INT __freeListSpace();

    RETURN ( __MKUINT(__freeListSpace()) );
%}.
    ^ 0

    "
     ObjectMemory freeListSpace
    "
!

freeSpace
    "return the number of bytes in the compact free area.
     (oldSpaceUsed + freeSpaceSize = oldSpaceSize)"

%{  /* NOCONTEXT */
    extern unsigned INT __oldSpaceSize(), __oldSpaceUsed();

    RETURN ( __MKUINT(__oldSpaceSize() - __oldSpaceUsed()) );
%}.
    ^ 0

    "
     ObjectMemory freeSpace
    "
!

garbageCollectCount
    "return the number of compressing collects that occurred since startup"

%{  /* NOCONTEXT */
    extern int __garbageCollectCount();

    RETURN (__mkSmallInteger(__garbageCollectCount()));
%}.
    ^ 0

    "
     ObjectMemory garbageCollectCount
    "
!

incrementalGCCount
    "return the number of incremental collects that occurred since startup"

%{  /* NOCONTEXT */
    extern int __incrementalGCCount();

    RETURN (__mkSmallInteger(__incrementalGCCount()));
%}.
    ^ 0

    "
     ObjectMemory incrementalGCCount
    "
!

incrementalGCPhase
    "returns the internal state of the incremental GC.
     The meaning of those numbers is a secret :-).
     (for the curious: (currently)
      2 is idle, 3..11 are various mark phases,
      12 is the sweep phase. 0 and 1 are cleanup phases when the
      incr. GC gets interrupted by a full GC).
     Do not depend on the values - there may be additional phases in
     future versions (incremental compact ;-).
     This is for debugging and monitoring only - and may change or vanish"

%{  /* NOCONTEXT */
    extern int __incrGCphase();

    RETURN (__mkSmallInteger(__incrGCphase()));
%}.
    ^ 2
!

incrementalGCPhaseSymbolic
    "returns the internal state of the incremental GC
     in a symbolic form.
     (for the curious: (currently)
      2 is idle, 3..11 are various mark phases,
      12 is the sweep phase. 0 and 1 are cleanup phases when the
      incr. GC gets interrupted by a full GC).
     Do not depend on the values - there may be additional phases in
     future versions (incremental compact ;-).
     This is for debugging and monitoring only - and may change or vanish"

    |phase|

    phase := self incrementalGCPhase.
    phase < 2 ifTrue:[^ #cleanup].
    phase == 2 ifTrue:[^ #idle].
    phase < 12 ifTrue:[^ #marking].
    ^ #sweeping

    "Created: / 10.8.1998 / 15:02:52 / cg"
!

isSchteamEngine
    "is this Smalltalk/X system running under the new Schteam engine?"
%{
#ifdef __SCHTEAM__
    return __c__._RETURN_true();
#endif
%}.
    ^ false
!

lastScavengeReclamation
    "returns the number of bytes replacimed by the last scavenge.
     For statistic only - this may vanish."

%{  /* NOCONTEXT */
    extern int __newSpaceReclaimed();

    RETURN ( __mkSmallInteger(__newSpaceReclaimed()) );
%}.
    ^ 0

    "percentage of reclaimed objects is returned by:

     ((ObjectMemory lastScavengeReclamation)
      / (ObjectMemory newSpaceSize)) * 100.0
    "
!

lifoRememberedSet
    "return the lifoRemSet.
     This is pure VM debugging and will vanish without notice."

%{  /* NOCONTEXT */
    extern OBJ __lifoRememberedSet();

    RETURN ( __lifoRememberedSet() );
%}.
    ^ nil

    "
     ObjectMemory lifoRememberedSet
    "
!

lifoRememberedSetSize
    "return the size of the lifoRemSet.
     This is a VM debugging interface and may vanish without notice."

%{  /* NOCONTEXT */
    extern int __lifoRememberedSetSize();

    RETURN (__mkSmallInteger(__lifoRememberedSetSize()));
%}.
    ^ 0

    "
     ObjectMemory lifoRememberedSetSize
    "
!

mallocAllocated
    "return the number of bytes allocated (and used) by malloc."

%{  /* NOCONTEXT */
#if defined(__linux__)
    struct mallinfo minfo;

    minfo = mallinfo();
    RETURN ( __MKUINT(minfo.uordblks));
#endif
%}.
    ^ 0

    "
     ObjectMemory mallocAllocated
    "
!

mallocTotal
    "return the number of bytes reserved by malloc (may not have been used yet)."

%{  /* NOCONTEXT */
#if defined(__linux__)
    struct mallinfo minfo;

    minfo = mallinfo();
    RETURN ( __MKUINT(minfo.usmblks));
#endif
%}.
    ^ 0

    "
     ObjectMemory mallocTotal
    "
!

markAndSweepCount
    "return the number of mark&sweep collects that occurred since startup"

%{  /* NOCONTEXT */
    extern int __markAndSweepCount();

    RETURN (__mkSmallInteger(__markAndSweepCount()));
%}.
    ^ 0

    "
     ObjectMemory markAndSweepCount
    "
!

maximumIdentityHashValue
    "for ST-80 compatibility: return the maximum value
     a hashKey as returned by identityHash can get.
     Since ST/X uses direct pointers, a field in the objectHeader
     is used, which is currently 11 bits in size."

%{  /* NOCONTEXT */
    RETURN ( __mkSmallInteger( __MAX_HASH__ << __HASH_SHIFT__) );
%}.
    ^ 8191

    "
     ObjectMemory maximumIdentityHashValue
    "
!

minScavengeReclamation
    "returns the number of bytes replaimed by the least effective scavenge.
     For statistic only - this may vanish."

%{  /* NOCONTEXT */
    extern int __newSpaceReclaimedMin();

    RETURN ( __mkSmallInteger(__newSpaceReclaimedMin()) );
%}.
    ^ 0

    "
     ObjectMemory minScavengeReclamation
    "
!

newSpaceSize
    "return the total size of the new space - this is usually fix"

%{  /* NOCONTEXT */
    extern unsigned __newSpaceSize();

    RETURN ( __MKUINT(__newSpaceSize()) );
%}.
    ^ 0

    "
     ObjectMemory newSpaceSize
    "
!

newSpaceUsed
    "return the number of bytes allocated for new objects.
     The returned value is usually obsolete as soon as you do
     something with it ..."

%{  /* NOCONTEXT */
    extern unsigned int __newSpaceUsed();

    RETURN ( __MKUINT(__newSpaceUsed()) );
%}.
    ^ 0

    "
     ObjectMemory newSpaceUsed
    "
!

numberOfObjects
    "return the number of objects in the system."

    |tally "{ Class: SmallInteger }"|

    tally := 0.
    self allObjectsDo:[:obj | tally := tally + 1].
    ^ tally

    "
     ObjectMemory numberOfObjects
    "
!

numberOfWeakObjects
    "return the number of weak objects in the system"

%{  /* NOCONTEXT */
    extern int __weakListSize();

    RETURN ( __mkSmallInteger(__weakListSize()) );
%}.
    ^ 0

    "
     ObjectMemory numberOfWeakObjects
    "
!

oldSpaceAddress
%{
#ifdef OLDSPACE_ADDRESS
    RETURN(__MKUINT(OLDSPACE_ADDRESS));
#else
    RETURN(__mkSmallInteger(0));
#endif
%}.
    ^ 0

    "
	self oldSpaceAddress
    "
!

oldSpaceAllocatedSinceLastGC
    "return the number of bytes allocated for old objects since the
     last oldspace garbage collect occurred. This information is used
     by ProcessorScheduler to decide when to start the incremental
     background GC."

%{  /* NOCONTEXT */
    extern unsigned INT __oldSpaceAllocatedSinceLastGC();

    RETURN ( __MKUINT(__oldSpaceAllocatedSinceLastGC()) );
%}.
    ^ 0

    "
     ObjectMemory oldSpaceAllocatedSinceLastGC
    "
!

oldSpaceSize
    "return the total size of the old space. - may grow slowly"

%{  /* NOCONTEXT */
    extern unsigned INT __oldSpaceSize();

    RETURN ( __MKUINT(__oldSpaceSize()) );
%}.
    ^ 0

    "
     ObjectMemory oldSpaceSize
    "
!

oldSpaceUsed
    "return the number of bytes allocated for old objects.
     (This includes the free lists)"

%{  /* NOCONTEXT */
    extern unsigned INT __oldSpaceUsed();

    RETURN ( __MKUINT(__oldSpaceUsed()) );
%}.
    ^ 0

    "
     ObjectMemory oldSpaceUsed
    "
!

rememberedSetSize
    "return the number of old objects referencing new ones.
     This is a VM debugging interface and may vanish without notice."

%{  /* NOCONTEXT */
    extern unsigned int __rememberedSetSize();

    RETURN (__mkSmallInteger(__rememberedSetSize()));
%}.
    ^ 0

    "
     ObjectMemory rememberedSetSize
    "
!

resetMinScavengeReclamation
    "resets the number of bytes replacimed by the least effective scavenge.
     For statistic only - this may vanish."

%{  /* NOCONTEXT */
    extern void __resetNewSpaceReclaimedMin();

    __resetNewSpaceReclaimedMin();
%}.
    ^ self

    "
     ObjectMemory resetMinScavengeReclamation.
     ObjectMemory minScavengeReclamation
    "
!

runsSingleOldSpace
    "return true, if the system runs in a single oldSpace or
     false if not.
     The memory system will always drop the second semispace when
     running out of virtual memory, or the baker-limit is reached.
     OBSOLETE:
	 the system may now decide at any time to switch between
	 single and double-space algorithms, depending on the overall memory
	 size. You will now almost always get true as result, since the
	 second semispace is only allocated when needed, and released
	 immediately afterwards.
    "

%{  /* NOCONTEXT */
    extern int __runsSingleOldSpace();

    RETURN ( (__runsSingleOldSpace() ? true : false) );
%}.
    ^ true

    "
     ObjectMemory runsSingleOldSpace
    "
!

scavengeCount
    "return the number of scavenges that occurred since startup"

%{  /* NOCONTEXT */
    extern int __scavengeCount();

    RETURN (__mkSmallInteger(__scavengeCount()));
%}.
    ^ 0

    "
     ObjectMemory scavengeCount
    "
!

symSpaceSize
    "return the total size of the sym space."

%{  /* NOCONTEXT */
    extern unsigned __symSpaceSize();

    RETURN ( __mkSmallInteger(__symSpaceSize()) );
%}.
    ^ 0

    "
     ObjectMemory symSpaceSize
    "
!

symSpaceUsed
    "return the number of bytes allocated for old objects in sym space."

%{  /* NOCONTEXT */
    extern unsigned __symSpaceUsed();

    RETURN ( __mkSmallInteger(__symSpaceUsed()) );
%}.
    ^ 0

    "
     ObjectMemory symSpaceUsed
    "
!

tenureAge
    "return the current tenure age - that's the number of times
     an object has to survive scavenges to be moved into oldSpace.
     For statistic/debugging only - this method may vanish"

%{  /* NOCONTEXT */
    extern unsigned __tenureAge();

    RETURN ( __mkSmallInteger(__tenureAge()) );
%}.
    ^ 0
!

vmSymbols
    "return a collection of symbols used by the VM"

    "/ DO NOT REMOVE THIS METHOD.
    "/ It is required to force the compiler to create those symbols
    "/ in fixed (non-moving) memory.

    ^ #(
      "/ interpreter stuff

      "/ JavaVM stuff

      nativeMethodInvokation
      newCleared
      monitorEnter:
      monitorExit:
      classInit
      javaClass
      resolve
      resolveStatic
    )
!

whoReferences:anObject
    "return a collection of objects referencing the argument, anObject"

    ^ self collectObjectsWhich:[:o | o referencesObject:anObject]

    "
     (ObjectMemory whoReferences:Transcript) printCR
    "
!

whoReferencesAny:aCollection
    "return a collection of objects referencing any object from
     the argument, aCollection"

    ^ self collectObjectsWhich:[:o | o referencesAny:aCollection]

    "
     ObjectMemory whoReferencesAny:(Array with:Transcript with:Smalltalk)
    "

    "Modified: / 2.2.1998 / 16:08:18 / cg"
!

whoReferencesDerivedInstancesOf:aClass
    "return a collection of objects refering to instances
     of the argument, aClass or a subclass of it."

    ^ self collectObjectsWhich:[:o | o referencesDerivedInstanceOf:aClass]

    "
     (ObjectMemory whoReferencesDerivedInstancesOf:View) printCR
    "
!

whoReferencesInstancesOf:aClass
    "return a collection of objects refering to instances
     of the argument, aClass"

    ^ self collectObjectsWhich:[:o | o referencesInstanceOf:aClass]

    "
     (ObjectMemory whoReferencesInstancesOf:SystemBrowser) printCR
    "
! !

!ObjectMemory class methodsFor:'semaphore access'!

lowSpaceSemaphore
    "return the semaphore that is signalled when the system detects a
     low space condition. Usually, some time after this, an allocationFailure
     will happen. You can have a cleanup process sitting in that semaphore and
     start to release object."

    ^ LowSpaceSemaphore
! !

!ObjectMemory class methodsFor:'statistics'!

ageStatistic
    "for ST/X developers only:
     dump contents of newSpace with objects age information.
     This method may be removed without notice"

%{   /* NOCONTEXT */

    __ageStatistics();
%}
    "
     ObjectMemory ageStatistic
    "
!

codeCacheInfo
    "for ST/X developers only:
     dump contents of dynamic code cache LRU lists.
     This method may be removed without notice"

%{   /* NOCONTEXT */
    OBJ __codeCacheInfo();

    RETURN (__codeCacheInfo());
%}
    "
     ObjectMemory codeCacheInfo do:[:item |
	|n nMethods nBytes|

	n := item at:1.
	nMethods := item at:2.
	nBytes := item at:3.

	n isNil ifTrue:[
	    '>>' print
	] ifFalse:[
	    (n printStringLeftPaddedTo:2) print.
	].
	' ' print.
	(nMethods printStringLeftPaddedTo:4) print.
	' ' print.
	(nBytes printStringLeftPaddedTo:6) printCR.
     ]
    "

!

mallocStatistics
    "for ST/X developers only:
     dump statistics on malloc memory allocation (used, for example for ExternalBytes) on
     the standard output. Dummy on some architectures, where the standard malloc is used (win32, for example).
     This method may be removed without notice"

%{   /* NOCONTEXT */
#if defined(__linux__)
    malloc_info(0, stderr);
#endif
%}
    "
     ObjectMemory mallocStatistics
    "
! !

!ObjectMemory class methodsFor:'system configuration queries'!

allBinaryModulesDo:aBlock
    "internal private method - walk over all known binary
     modules and evaluate aBlock for each entry.
     Do not depend on the information returned for each - this may
     change without notice."

%{
    __REGISTRATION_DO_BLOCK5__(&aBlock COMMA_SND);
%}
!

binaryModuleInfo
    "return a collection of moduleInfo entries.
     This returns a dictionary (keys are internal moduleIDs)
     with one entry for each binary package (module)."

    |modules|

    modules := IdentityDictionary new.
    self allBinaryModulesDo:[:idArg :nameArg :flagsArg :libName :timeStamp |
	|type subModuleName module dynamic infoRec handle pathName
	 typeName name nameString|

	nameArg isString ifFalse:[
	    'Error in binaryModuleInfo - skip entry' errorPrintCR.
	] ifTrue:[
	    name := nameArg.
	    subModuleName := name asSymbol.

	    idArg > 0 ifTrue:[
		dynamic := true.
		typeName := 'dynamic '.
		handle := ObjectFileLoader handleFromID:idArg.
		(handle isNil or:[(pathName := handle pathName) isNil]) ifTrue:[
		    name := '?'
		] ifFalse:[
		    name := pathName asFilename baseName
		]
	    ] ifFalse:[
		dynamic := false.
		typeName := 'builtIn '.
		pathName := nil.
		libName isNil ifTrue:[
		    name := subModuleName
		] ifFalse:[
		    name := libName
		].
	    ].
	    nameString := typeName.
	    libName isNil ifTrue:[
		nameString := nameString, 'module '
	    ] ifFalse:[
		nameString := nameString, 'classLib '
	    ].
	    nameString := nameString , name.

	    libName isNil ifTrue:[
		type := #classObject
	    ] ifFalse:[
		type := #classLibrary
	    ].

	    infoRec := modules at:idArg ifAbsent:nil.
	    infoRec notNil ifTrue:[
		infoRec classNames add:subModuleName.
	    ] ifFalse:[
		infoRec := BinaryModuleDescriptor
				name:nameString
				type:type
				id:idArg
				dynamic:dynamic
				classNames:( (OrderedSet ? Set) with:subModuleName)
				handle:handle
				pathName:pathName
				libraryName:libName
				timeStamp:nil.

		modules at:idArg put:infoRec.
	    ].
	].
    ].
    ^ modules

    "
     ObjectMemory binaryModuleInfo
    "

    "Modified: 17.9.1995 / 16:33:02 / claus"
    "Modified: 22.4.1997 / 23:42:59 / cg"
!

getVMIdentificationStrings
    "return a collection of release strings giving information
     about the running VM. This is for configuration management only.
     Do not depend on the information returned - this may
     change or vanish without notice."

%{
    extern OBJ __getVMReleaseStrings();

    RETURN (__getVMReleaseStrings());
%}.
    ^ #()

    "
     ObjectMemory getVMIdentificationStrings
    "
! !

!ObjectMemory class methodsFor:'system management'!

directoryForImageAndChangeFile
    |dir exeDir|

    dir := Filename currentDirectory.

    "/ the current directory is not a good idea, if stx is started via a desktop manager
    "/ or in osx, by clicking on stx.app.
    dir isRootDirectory ifTrue:[
	exeDir := OperatingSystem nameOfSTXExecutable asFilename directory.
	dir ~= exeDir ifTrue:[
	    "/ Change it to ~/.smalltalk or is executable directory better?

	    "/ use executable dir, as otherwise I'd have to change the VM to include an image path...
	    "/ dir := Filename usersPrivateSmalltalkDirectory.
	    dir := exeDir.
	].
    ].
    ^ dir

    "
     self directoryForImageAndChangeFile
    "
!

imageBaseName
    "return a reasonable filename to use as baseName (i.e. without extension).
     This is the filename of the current image (without '.img') or,
     if not running from an image, the default name 'st'"

    |nm filename suffix|

    nm := ImageName.
    (nm isEmptyOrNil or:[nm isBlank]) ifTrue:[
	^ 'st'
    ].

    filename := nm asFilename.
    suffix := filename suffix.
    (suffix = 'sav' or:[suffix = self suffixForSnapshot]) ifTrue:[
	^ filename nameWithoutSuffix.
    ].

    ^ nm

    "
     ObjectMemory imageBaseName
    "
!

imageName
    "return the filename of the current image, or nil
     if not running from an image."

    ^ ImageName

    "
     ObjectMemory imageName
    "
!

imageSaveTime
    "return a timestamp for when the running image was saved.
     Return nil if not running from an image."

    ^ ImageSaveTime
!

initChangeFilename
    "/ make the changeFilePath an absolute one,
    "/ in case some stupid windows fileDialog changes the current directory...
    self
	nameForChanges:(self directoryForImageAndChangeFile / ObjectMemory nameForChangesLocal)
			    asAbsoluteFilename pathName

    "
     self initChangeFilename
    "
!

nameForChanges
    "return a reasonable filename string to store the changes into.
     By default, this is the basename of the current image with '.img' replaced
     by '.chg', or, if not running from an image, the default name 'st.chg'.
     However, it can be overwritten via the nameForChanges: setter.
     For now, this returns a string (for backward compatibility);
     senders should be prepared to get a filename in the future."

    |userPrefs localName nm wd|

    localName := self nameForChangesLocal.
    userPrefs := UserPreferences current.

    "/ if the prefs provide a full, explicit name
    (nm := userPrefs changeFileName) isNil ifTrue:[

	"/ if there is a workspace, create it there
	((wd := userPrefs workspaceDirectory) notNil and:[wd exists]) ifTrue:[
	    nm := wd / (localName asFilename baseName)
	] ifFalse:[
	    "/ if it was set by a startup file
	    (nm := ChangeFileName) isNil ifTrue:[
		"/ finally, fall back to a default.
		nm := localName
	    ]
	]
    ].
    ^ nm asFilename pathName.

    "
     ObjectMemory nameForChanges
    "

    "Modified: / 09-02-2011 / 20:44:37 / cg"
!

nameForChanges:aFilename
    "set the name of the file where changes are stored into."

    ChangeFileName := aFilename

    "
     ObjectMemory nameForChanges:'myChanges'
    "
!

nameForChangesLocal
    "return a reasonable filename to store the changes into."

    ^ self imageBaseName , '.chg'

    "
     ObjectMemory nameForChanges
    "

    "Created: / 09-02-2011 / 20:44:31 / cg"
!

nameForCrashImage
    ^ 'crash', '.', self suffixForSnapshot

    "
     ObjectMemory nameForCrashImage
    "

    "Created: / 29-09-2006 / 13:16:52 / cg"
!

nameForSnapshot
    "return a reasonable filename to store the snapshot image into.
     This is the filename of the current image or,
     if not running from an image, the default name 'st.img'"

    |localName wd|

    localName := self nameForSnapshotLocal.

    "/ if there is a workspace, create it there
    ((wd := UserPreferences current workspaceDirectory) notNil and:[wd exists]) ifTrue:[
	^ wd / (localName asFilename baseName)
    ].
    ^ localName

    "
     ObjectMemory nameForSnapshot
    "
!

nameForSnapshotLocal
    "return a reasonable filename to store the snapshot image into.
     This is the filename of the current image or,
     if not running from an image, the default name 'st.img'"

    ^ self imageBaseName , '.', self suffixForSnapshot

    "
     ObjectMemory nameForSnapshot
    "
!

nameForSources
    "return a reasonable filename to store the sources into.
     This is the basename of the current image with '.img' replaced
     by '.src', or, if not running from an image, the default name 'st.src'"

    ^ self imageBaseName , '.src'

    "
     ObjectMemory nameForSources
    "
!

primSnapShotOn:aFilename
    "create a snapshot in the given file.
     Low level entry. Does not notify classes or write an entry to
     the changes file. Also, no image backup is created.
     Returns true if the snapshot worked, false if it failed for some reason.
     This method should not be used in normal cases."

    |ok oldImageName oldImageTime filenameString|

    "
     save the name and time with it ...
    "

    filenameString := aFilename asString.
    oldImageName := ImageName.
    oldImageTime := ImageSaveTime.

    ImageName := filenameString.
    ImageSaveTime := Timestamp now.
    ok := false.

%{  /* CALLSSTACK:32000 */

    OBJ __snapShotOn();
    OBJ funny = @symbol(funnySnapshotSymbol);

    if (__isStringLike(filenameString)) {
	__BLOCKINTERRUPTS();
	ok = __snapShotOn(__context, __stringVal(filenameString), funny);
	__UNBLOCKINTERRUPTS();
    }
%}.

    ImageName := oldImageName.
    ImageSaveTime := oldImageTime.

    ^ ok
!

refreshChangesFrom: oldChangesName
    "The snapshot image name has changed (snapshot saved),
     the changes file must be copied to the new name.
     No copy when the changes name is given explicitly."

    ChangeFileName notNil ifTrue: [
	ChangeFileName ~= self nameForChangesLocal ifTrue:[
	    ^ self
	]
    ].
    oldChangesName asFilename copyTo:self nameForChanges

    "Created: / 15.5.2004 / 20:29:03 / masca"
!

snapShot
    "create a snapshot file containing all of the current state."

    self snapShotOn:(self nameForSnapshot) setImageName:true

    "
     ObjectMemory snapShot
    "
!

snapShotOn:aFileName
    "create a snapshot file containing all of the current state."

    ^ self snapShotOn:aFileName setImageName:true.

    "
     ObjectMemory snapShotOn:'myimage.img'
    "
!

snapShotOn:aFileName setImageName:setImageName
    "create a snapshot in the given file.
     If the file exists, save it for backup.
     Return true if the snapshot worked, false if it failed for some reason.
     Notify dependents before and after the snapshot operation.

     If setImageName is true, the name of the current image is set and
     a copy of the change file is created."

    |ok snapshotFilename tempFilename oldChangeFile|

    "
     give others a chance to fix things
    "
    self changed:#save.             "/ will vanish ...
    self changed:#aboutToSnapshot.  "/ ... for ST-80 compatibility

    "
     ST-80 compatibility; send #preSnapshot to all classes
    "
    Smalltalk allClassesDo:[:aClass |
        aClass preSnapshot
    ].

    "
     save in a temp file and rename - just in case something
     bad happens while writing the image.
     (could be ST/X error or file-system errors etc.)
    "
    snapshotFilename := aFileName asFilename.
    snapshotFilename isAbsolute ifFalse:[
        snapshotFilename := self directoryForImageAndChangeFile
                            / snapshotFilename name.
    ].

    tempFilename := (FileStream newTemporaryIn:snapshotFilename directory)
                        close;
                        fileName.
    ok := self primSnapShotOn:tempFilename.

    ok ifTrue:[
        "keep history of one snapshot file"
        snapshotFilename exists ifTrue:[
            tempFilename symbolicAccessRights:snapshotFilename symbolicAccessRights.
            snapshotFilename renameTo:(snapshotFilename withSuffix:'sav').
        ] ifFalse:[
            "image file has stx as interpreter and can be executed"
            tempFilename makeExecutable.
        ].
        tempFilename renameTo:snapshotFilename.

        Class addChangeRecordForSnapshot:aFileName.

        setImageName ifTrue:[
            oldChangeFile := self nameForChanges.
            ImageName := snapshotFilename asAbsoluteFilename asString.
            self refreshChangesFrom:oldChangeFile.
        ].
    ] ifFalse:[
        tempFilename remove.
    ].

    "
     ST-80 compatibility; send #postSnapshot to all classes
    "
    Smalltalk allClassesDo:[:aClass |
        aClass postSnapshot
    ].
    self changed:#finishedSnapshot.  "/ ST-80 compatibility

    ok ifFalse:[
        SnapshotError raise.
        "not reached"
    ].

    Transcript
        show:'Snapshot '; show:snapshotFilename baseName allBold;
        show:' saved '; show:Timestamp now;
        show:' in '; show:snapshotFilename asAbsoluteFilename directoryName;
        showCR:'.'.

    ^ ok

    "
     ObjectMemory snapShotOn:'myimage.img' setImageName:false
     ObjectMemory snapShotOn:'myimage.img' setImageName:true
    "

    "Modified: / 04-08-2006 / 18:14:45 / cg"
!

suffixForSnapshot
    "return the suffix used for snapshot files'"

    ^ 'img'.
!

writeCrashImage
    "create a 'crash.img' snapshot file containing all of the current state.
     Keep the current image name."

    self snapShotOn:self nameForCrashImage setImageName:false

    "
     ObjectMemory writeCrashImage
    "

    "Created: / 29-09-2006 / 12:22:54 / cg"
! !

!ObjectMemory::BinaryModuleDescriptor class methodsFor:'instance creation'!

name:n type:t id:i dynamic:d classNames:c handle:h pathName:p libraryName:l timeStamp:ts
    ^ (self basicNew) name:n type:t id:i dynamic:d classNames:c handle:h pathName:p libraryName:l timeStamp:ts
! !

!ObjectMemory::BinaryModuleDescriptor methodsFor:'accessing'!

classNames
    "return the names of the classes contained in that module"

    ^ classNames
!

dynamic
    "return true, if this module was loaded dynamically
     (as opposed to a module which was linked into the system right from the start.
      Do not confuse this with shared libraries - these may be dynamic or not)."

    ^ dynamic
!

handle
    ^ handle
!

handle:something
    handle := something.
!

id
    "return the modules internal id; this is (currently) a small number,
     with positive values for dynamically added modules.
     Modules which were present at startup (both statically linked or shared libraries)
     have a negative id (Do not depend on this - use #dynamic instead)."

    ^ id
!

isSingleMethod
    ^ type == #classObject and:[ libraryName isNil ]
!

libraryName
    "return the name of this library. Typically, this is the libraries
     filename without a suffix (such as 'libbasic')"

    ^ libraryName
!

name
    "return the modules name - usually, some descriptive text plus the modules
     libraryName."

    ^ name
!

package
    "retrieve the modules packageId.
     For now, this is constructed, but will be kept in the VM in later
     versions."

    "/ must fetch from my classes ...
    classNames do:[:className |
	|class|

	(class := Smalltalk at:className) isBehavior ifTrue:[
	    ^ class package
	]
    ].
    ^ nil
!

pathName
    "return the modules pathName"

    ^ pathName
!

timeStamp
    "return the modules timeStamp"

    ^ timeStamp
!

type
    "return the modules type. This is a symbol, such as #classLibrary."

    ^ type
! !

!ObjectMemory::BinaryModuleDescriptor methodsFor:'backward compatibility'!

at:key
    "backward compatibility access: in previous releases, IdentityDictionaries
     were used to hold my information. Allow access via key messages.
     This method will vanish - use the proper access protocol."

    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self perform:key
! !

!ObjectMemory::BinaryModuleDescriptor methodsFor:'printing & storing'!

printOn:aStream
    aStream
	nextPutAll:self class name;
	nextPut:$(.

    name printOn:aStream.
    aStream nextPut:$).
! !

!ObjectMemory::BinaryModuleDescriptor methodsFor:'private-accessing'!

name:n type:t id:i dynamic:d classNames:c handle:h pathName:p libraryName:l timeStamp:ts
    name := n.
    type := t.
    id := i.
    dynamic := d.
    classNames := c.
    libraryName := l.
    timeStamp := ts.
    handle := h.
    pathName := p.
! !

!ObjectMemory class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: ObjectMemory.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !


ObjectMemory initialize!

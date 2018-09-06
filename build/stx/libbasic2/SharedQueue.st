"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

Queue subclass:#SharedQueue
	instanceVariableNames:'dataAvailable spaceAvailable accessLock'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!SharedQueue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    SharedQueues provide a safe mechanism for processes to communicate.
    They are basically Queues, with added secure access to the internals,
    allowing use from multiple processes (i.e. the access methods use
    critical regions to protect against confusion due to a process
    switch within a modification).

    Also, sharedQueues can be used for synchronization, since a reading
    process will be blocked when attempting to read an empty queue, while
    a writer will be blocked when attempting to write into a full queue.
    For nonBlocking read, use #isEmpty; for nonBlocking write, use #isFull.

    Be warned:
        if the reader process wants to add elements to the sharedqueue in its
        read-loop, the reader may block, if the queue is full.
        The reason is that the sharedQueues size is fixed, and any writer is blocked
        if the queue is full.
        For this situations, please use an UnlimitedSharedQueue, which grows in this
        particular situation.
        
    See samples in doc/coding.

    [author:]
        Claus Gittinger

    [see also:]
        SharedCollection
        UnlimitedSharedQueue
        Queue
        Semaphore
        Process
        CodingExamples::SharedQueueExamples
"
!

examples
"
    |queues readers writers seqNumber accessLock accessLock2
     numbersStillToReceive|

    seqNumber := 1.
    accessLock := Semaphore forMutualExclusion.
    accessLock2 := Semaphore forMutualExclusion.

    numbersStillToReceive := BooleanArray new:100000 withAll:true.

    queues := (1 to:10) collect:[:i | SharedQueue new].
    readers := (1 to:10) collect:[:i |
                                    [   |num|
                                        10000 timesRepeat:[
                                            num := (queues at:i) next.
                                            accessLock2 critical:[
                                                (numbersStillToReceive at:num) ifFalse:[
                                                    self halt:(num printString , ' received twice')
                                                ] ifTrue:[
                                                    numbersStillToReceive at:num put:false.
                                                ].
                                            ].
                                            'num printCR.'.
                                        ].
                                    ] fork
                                 ].
    writers := (1 to:10) collect:[:i |
                                    [   |num|

                                        10000 timesRepeat:[
                                            accessLock critical:[
                                                num := seqNumber.
                                                seqNumber := seqNumber + 1.
                                            ].
                                            (queues at:i) nextPut:num.
                                        ]
                                    ] fork
                                 ].

    readers do:[:aReader | aReader waitUntilTerminated].

    ' any left ? '.
    (numbersStillToReceive includes:true) ifTrue:[
        self halt:'oops - not all numbers received'
    ]
"
! !

!SharedQueue methodsFor:'accessing'!

removeAll
    "remove all elements in the queue; do not wait, but
     synchronize access to the queue.
     If the queue was full before, signal space-availability to writers.
     This can be used to flush queues in multi-process applications,
     when cleanup is required."

    |count|

    accessLock critical:[
        [
            count := dataAvailable count.
            dataAvailable clear.
        ] valueUninterruptably.
        super removeAll.
    ].
    count timesRepeat:[spaceAvailable signal]. 
!

removeIdentical:anElement ifAbsent:exceptionalValue
    |retVal noSuchElement|

    noSuchElement := false.
    accessLock critical:[
        retVal := super removeIdentical:anElement ifAbsent:[noSuchElement := true]
    ].
    noSuchElement ifTrue:[
        ^ exceptionalValue value.
    ].
    spaceAvailable signal.
    ^ retVal.
!

removeLast
    "return the last value in the queue; if it its empty, wait until
     something is put into the receiver.
     When the datum has been removed, signal space-availability to
     writers"

    |retVal|

    dataAvailable wait.
    accessLock critical:[
        retVal := super removeLast.
    ].
    spaceAvailable signal.

    ^ retVal.
! !

!SharedQueue methodsFor:'accessing-internals'!

accessLock
    "return the critical access-semaphore which is used internally to syncronize access"

    ^ accessLock
!

readSemaphore
    "return the semaphore which is signalled when data is available
     for reading."

    ^ dataAvailable

    "Modified: 16.12.1995 / 13:47:11 / cg"
!

readWaitWithTimeoutMs:ms
    "Return true if a timeout occurred (i.e. false, if data is available)."

    ^ (dataAvailable waitUncountedWithTimeoutMs:ms) isNil.
!

superNextPut:anObject
    "private; to allow subclasses to call the basic nextPut (w.o. synchronization)"

    ^ super nextPut:anObject.
!

superNextPutFirst:anObject
    "private; to allow subclasses to call the basic nextPutFirst (w.o. synchronization)"

    ^ super nextPutFirst:anObject.
!

withAccessLockedDo:aBlock
    "evaluate aBlock while access via next/nextPut are blocked."

    accessLock critical:aBlock
!

writeSemaphore
    "return the semaphore which is signalled when the queue has space
     for writing."

    ^ spaceAvailable

    "Modified: 16.12.1995 / 13:47:07 / cg"
! !

!SharedQueue methodsFor:'accessing-reading'!

next
    "return the next value in the queue; if it its empty, wait 'til
     something is put into the receiver.
     When the datum has been removed, signal space-availability to
     writers"

    |retVal|

    dataAvailable wait.
    accessLock critical:[
        retVal := super nextOrNil.
    ].
    spaceAvailable signal.

    ^ retVal.
!

nextIfEmpty:exceptionValue
    "return the next value in the queue; if it its empty do not wait, but return
     the value of exceptionValue.
     When a datum has been removed, signal space-availability to writers"

    |retVal anyRemoved|

    accessLock critical:[
        self isEmpty ifTrue:[
            retVal := exceptionValue value
        ] ifFalse:[
            retVal := super nextOrNil.
            anyRemoved := true.
        ].
    ].
    anyRemoved == true ifTrue:[spaceAvailable signal].

    ^ retVal.
!

nextOrNil
    ^ self nextIfEmpty:nil

    "Created: / 31-05-2007 / 15:09:33 / cg"
!

nextWithTimeout:seconds
    "return the next value in the queue; if it its empty, wait until
     something is put into the receiver.
     When the datum has been removed, signal space-availability to
     writers.
     Timeout after secondsIn seconds - answer nil if a timeout occurs."

    |retVal|

    (dataAvailable waitWithTimeout:seconds) isNil ifTrue:[
        ^ nil
    ].
    accessLock critical:[
        retVal := super nextOrNil.
    ].
    spaceAvailable signal.

    ^ retVal.
!

peek
    self isEmpty ifTrue:[
        dataAvailable waitUncounted.
    ].
    ^ super peek
! !

!SharedQueue methodsFor:'adding'!

nextPut:anObject
    "enter anObject to the end of the queue; 
     do NOT wait for available space, if the queue is full; instead resize as required. 
     After the put, signal availablity of a datum to readers."

    self commonWriteWith:[self superNextPut:anObject].
    ^ self.
!

nextPutFirst:anObject
    "insert anObject at the beginning of the queue; 
     do NOT wait for available space, if the queue is full, instead resize as required. 
     After the put, signal availablity of a datum to readers.
     Insertion at the beginning may be useful to add hi-prio elements (for example, in a job-scheduler)"

    self commonWriteWith:[self superNextPutFirst:anObject].
    ^ self
! !

!SharedQueue methodsFor:'enumerating'!

do:anObject
    "evaluate the argument, aBlock for each element in the queue"

    |retVal|

    accessLock critical:[
        retVal := super do:anObject.
    ].
    ^ retVal.
! !

!SharedQueue methodsFor:'initialization'!

init:size
    "initialize the receiver for size entries"

    super init:size.
    dataAvailable := Semaphore new name:'shared q-read'.
    dataAvailable owner:self.
    spaceAvailable := (Semaphore new:size) name:'shared q-write'.
    spaceAvailable owner:self.
    accessLock := RecursionLock new.

    "Modified: 25.1.1997 / 00:19:45 / cg"
! !

!SharedQueue methodsFor:'private'!

commonWriteWith:aBlock
    "common code for nextPut / nextPutFirst; 
     do NOT wait for available space, if the queue is full; instead resize as required. 
     After the put, signal availablity of a datum to readers."

    spaceAvailable wait.
    accessLock critical:[
        aBlock value.
        dataAvailable signal.
    ].
! !

!SharedQueue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


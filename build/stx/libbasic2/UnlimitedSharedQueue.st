"
 COPYRIGHT (c) 2016 by eXept Software AG
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

SharedQueue subclass:#UnlimitedSharedQueue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!UnlimitedSharedQueue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    Like the superclass, SharedQueues, this provide a safe mechanism for processes to communicate.
    They are basically Queues, with added secure access to the internals,
    allowing use from multiple processes (i.e. the access methods use
    critical regions to protect against confusion due to a process
    switch within a modification).

    In contrast to SharedQueues, which block the writer when the queue is full,
    instances of me grow the underlying container, so the writer will never block
    (of course, the reader will still block in #next, if the queue is empty).
    
    This kind of queue is needed if the reader process itself possibly wants to
    add more to the queue. For this, a limited sharedQueue may block the reader,
    if this reader process cannot add a new element.

    [author:]
        Claus Gittinger

    [see also:]
        SharedQueue
        SharedCollection
        OrderedCollection
        Queue
        Semaphore
        Process
        CodingExamples::SharedQueueExamples
"
!

examples
"
  ATTENTION:
  Using a regular SharedQueue will lead to a deadlock when the reader writes itself. 
  (you'll have to terminate the two processes in the process monitor):

                                                        [exBegin]
    |reader writer q|
    
    q := SharedQueue new:10.
    
    reader :=
        [
            [
                |element|
                
                element := q next.
                element == true ifTrue:[
                    q nextPut:#xx.
                    q nextPut:#xx.
                    q nextPut:#xx.
                ].
                Transcript showCR:element.
            ] loop.    
        ] fork.

    writer :=
        [
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            q nextPut:true.
            q nextPut:true.
            q nextPut:true.
            q nextPut:true.
            q nextPut:true.
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            Transcript showCR:'writer finished'.
        ] fork.
                                                        [exEnd]


  this will not lead to a deadlock 
  (you'll have to terminate the two processes in the process monitor):
                                                        [exBegin]
    |reader writer q|

    q := UnlimitedSharedQueue new:10.

    reader :=
        [
            [
                |element|

                element := q next.
                element == true ifTrue:[
                    q nextPut:#xx.
                    q nextPut:#xx.
                    q nextPut:#xx.
                ].
                Transcript showCR:element.
            ] loop.    
        ] fork.

    writer :=
        [
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            q nextPut:true.
            q nextPut:true.
            q nextPut:true.
            q nextPut:true.
            q nextPut:true.
            q nextPut:false.
            q nextPut:false.
            q nextPut:false.
            Transcript showCR:'writer finished'.
        ] fork.
                                                        [exEnd]
"
! !

!UnlimitedSharedQueue methodsFor:'private'!

commonWriteWith:aBlock
    "common code for nextPut / nextPutFirst; 
     do NOT wait for available space, if the queue is full; instead resize as required. 
     After the put, signal availablity of a datum to readers."

    |myCapacity|

    accessLock critical:[
        myCapacity := self capacity.
        self size == myCapacity ifTrue:[
            self capacity:(myCapacity * 1.5 // 1).
        ].
        aBlock value.
        dataAvailable signal.
    ].
    ^ self.
! !

!UnlimitedSharedQueue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


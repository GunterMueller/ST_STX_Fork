"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Object subclass:#OperationQueue
	instanceVariableNames:'queue queueLock consumerProcess consumerProcessPriority'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

Object subclass:#OperationInQueue
	instanceVariableNames:'operation operationPerformedSema operationResult exception'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OperationQueue
!

!OperationQueue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    An operationQueue allows operations (i.e. actions) to be evaluated in
    a first-come-first-serve queue like fashion. A single consumer process
    waits for orders to be enqueued and evaluates them (as they come).
    Producer processes which want to have some operation performed may
    enqueue these. Producers are suspended, until the operation is finished.
    If multiple orders which compare equal are enqueued by multiple producers,
    the operation is only evaluated once, and both producers will wake up when
    the operation has finished.

    [author:]
        Martin Walser
        Claus Gittinger

    [see also:]
        SharedQueue
        Queue
"
!

examples
"
    two orders; done sequentially:
                                                                                        [exBegin]
        |opQ|

        opQ := OperationQueue new.
        opQ scheduleOperation:[ Transcript showCR:'hello world-1'].
        opQ scheduleOperation:[ Transcript showCR:'hello world-2'].
                                                                                        [exBegin]

    only 10 outputs (same operation entered by multiple producers):
                                                                                        [exBegin]
        |p1 p2 p3 opQ order|

        opQ := OperationQueue new.
        order := [ Transcript showCR:'hello world '].
        p1 := [
                1 to:10 do:[:i |
                    opQ scheduleOperation:order.
                ]
              ] fork.
        p2 := [
                1 to:10 do:[:i |
                    opQ scheduleOperation:order.
                ]
              ] fork.
        p3 := [
                1 to:10 do:[:i |
                    opQ scheduleOperation:order.
                ]
              ] fork.
                                                                                        [exBegin]

"
! !

!OperationQueue class methodsFor:'instance creation'!

new
    ^ super new initializeLock
!

new:n
    ^ (super new:n) initializeLock
! !

!OperationQueue methodsFor:'accessing'!

consumerProcess
    "return the value of the instance variable 'consumerProcess' (automatically generated)"

    ^ consumerProcess
!

consumerProcessPriority
    "return the value of the instance variable 'consumerProcessPriority' (automatically generated)"

    ^ consumerProcessPriority
!

consumerProcessPriority:something
    "set the value of the instance variable 'consumerProcessPriority' (automatically generated)"

    consumerProcessPriority := something.
! !

!OperationQueue methodsFor:'consumer'!

fetchNextOperationAndExecute
    "dequeue the next order, evaluate it and wake up waiters"

    |opInQ theOperation rslt|

    opInQ := queue next.

    theOperation := opInQ operation.
    AbortOperationRequest handle:[:ex |
        Transcript showCR:'operation aborted'.
        opInQ operationResult:nil.
    ] do:[
        Error handle:[:ex |
            |ex2|

            Transcript showCR:'operation error: ', ex errorString.

            ex2 := ex shallowCopy.
            ex2 suspendedContext:(self copyContextChain:ex suspendedContext).
            opInQ exception:ex2.
            opInQ operationResult:nil.
        ] do:[
            rslt := theOperation value.
        ].
    ].
    opInQ operationResult:rslt.

    opInQ operationPerformedSema signalForAll.

    [
        queue isEmpty ifTrue:[
            self stopConsumerProcess
        ]
    ] valueUninterruptably
!

startConsumerProcess
    [
        consumerProcess isNil ifTrue:[
            consumerProcessPriority := consumerProcessPriority ? (Processor userSchedulingPriority).
            consumerProcess := [
                [true] whileTrue:[
                    self fetchNextOperationAndExecute.
                ].
            ] newProcess.
            consumerProcess priority:consumerProcessPriority.
            consumerProcess name:'Op-Q consumer'.
            consumerProcess resume.
        ].
    ] valueUninterruptably
!

stopConsumerProcess
    [
        |p|

        (p := consumerProcess) notNil ifTrue:[
            consumerProcess := nil.
            p terminate
        ].
    ] valueUninterruptably
! !

!OperationQueue methodsFor:'debugging support'!

copyContextChain:aContext
    "dequeue the next order, evaluate it and wake up waiters"

    |copy|

    copy := aContext shallowCopy.
    aContext sender notNil ifTrue:[
        copy setSender:(self copyContextChain:aContext sender)
    ].
    ^ copy
!

linkContextChain:aConsumerChain
    "for debugging - concatenate aConsumerChain to my own context chain (to make debugging easier)"

    |c|

    c := aConsumerChain.
    [c sender notNil and:[c methodSelector ~~ #fetchNextOperationAndExecute]] whileTrue:[
        c := c sender.
    ].
    c setSender:(thisContext sender).
! !

!OperationQueue methodsFor:'initialization'!

initializeLock
    queue := SharedQueue new.
    queueLock := Semaphore forMutualExclusion.
! !

!OperationQueue methodsFor:'producer'!

scheduleOperation:anotherOperation
    "enqueue an order (something that understands #value) to the op-queue;
     wait until the operation has performed (#value been sent),
     return the result of the #value send.
     If a similar order is already in the queue, wait for that one to finish."

    ^ self scheduleOperation:anotherOperation asynchronous:false
!

scheduleOperation:anotherOperation asynchronous:asynchronous
    "enqueue an order (something that understands #value) to the op-queue;
     if asynchronous is false, wait until the operation has performed (#value been sent),
     return the result of the #value send.
     If a similar order is already in the queue, wait for that one to finish.
     If asynchronous is true, do not wait (but also: do not return a return value)"

    |myOpInQ ex|

    queueLock critical:[
        "/ operation already in queue ?
        queue withAccessLockedDo:[
            myOpInQ := nil.
            queue do:[:eachOpInQ |
               anotherOperation = eachOpInQ operation ifTrue:[
                    myOpInQ := eachOpInQ
               ]
            ].
            "/ if not, create a new one and enqueue
            myOpInQ isNil ifTrue:[
                myOpInQ := OperationInQueue new.
                myOpInQ operationPerformedSema:(Semaphore new).
                myOpInQ operation:anotherOperation.
                [
                    queue nextPut:myOpInQ.
                    consumerProcess isNil ifTrue:[
                        self startConsumerProcess
                    ].
                ] valueUninterruptably.
            ].
        ].
    ]. 

    asynchronous ifTrue:[
        ^ nil
    ].

    "/ wait for the operation to finish
    myOpInQ operationPerformedSema wait.
    (ex := myOpInQ exception) notNil ifTrue:[
        "/ trick: makes calling chain look as if the error happended here
        "/ (in reality, it happended in the consumer-process).
        self linkContextChain:ex suspendedContext.

        ^ ex creator raiseErrorString:('asyncronous operation error:' , ex errorString) in:ex suspendedContext
    ].
    "/ now, the operation has been performed - return its result
    ^ myOpInQ operationResult
! !

!OperationQueue methodsFor:'queries'!

size
    "return the number of operations in the queue"

    ^ queue size
! !

!OperationQueue::OperationInQueue methodsFor:'accessing'!

exception
    "return the value of the instance variable 'exception' (automatically generated)"

    ^ exception
!

exception:something
    "set the value of the instance variable 'exception' (automatically generated)"

    exception := something.
!

operation
    "return the value of the instance variable 'operation' (automatically generated)"

    ^ operation
!

operation:something
    "set the value of the instance variable 'operation' (automatically generated)"

    operation := something.
!

operationPerformedSema
    "return the value of the instance variable 'operationPerformedSema' (automatically generated)"

    ^ operationPerformedSema
!

operationPerformedSema:something
    "set the value of the instance variable 'operationPerformedSema' (automatically generated)"

    operationPerformedSema := something.
!

operationResult
    "return the value of the instance variable 'operationResult' (automatically generated)"

    ^ operationResult
!

operationResult:something
    "set the value of the instance variable 'operationResult' (automatically generated)"

    operationResult := something.
! !

!OperationQueue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/OperationQueue.st,v 1.9 2013-04-27 12:45:52 cg Exp $'
! !


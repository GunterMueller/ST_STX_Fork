"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Object subclass:#ActiveObject
	instanceVariableNames:'process messageQueue'
	classVariableNames:'AccessLock'
	poolDictionaries:''
	category:'Kernel-Processes'
!

Message subclass:#MessageAndResponse
	instanceVariableNames:'action ok result exception ready'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ActiveObject
!

Lookup subclass:#RedirectingLookup
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	privateIn:ActiveObject
!

!ActiveObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
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
    an active object executes incoming messages in a serialized, synchronous manner,
    enqueuing incoming messages, executing them one after the other, and returning results to the caller.
    Messages are synchronous: the caller is blocked while I perform my duty.
    Exceptions during execution are sent back to the caller.
    This is an abstract framework class, to be subclassed for real workers.

    The following is a not-yet-working experiment, using lookup objects to redirect automatcally into a synchronizing
    method. This does not work yet.

    Notice the use of the lookup object here: all incoming messages from a process other than my worker-process
    itself are forwarded to the #doesNotUnderstand: method. There is no need to inherit from nil, and subclasses can use
    any messages they like locally, without them being enqueued.

    For now, define methods which have to be synchronized by defining them as:
        methodX
            self synchronized:[
                ...
                do something
                ...
            ]

    [Author:]
        Claus Gittinger
"
!

examples
"
  normally, one would subclass ActiveObject and put protocol into it;
  here, for the example, an anon Printer is defined. It is slow printing to the Transcript for a demo.
  The interesting thing is the error handling which is demonstrated in printWithError:
  Any exception inside the worker object is returned back and raised in the active-object's client,
  not in the worker (take a look at the call-chain, when running the example below).


    |workerClass worker|

    workerClass := ActiveObject 
                        subclass:#Printer
                        instanceVariableNames:''
                        classVariableNames:''
                        poolDictionaries:''
                        category:nil
                        inEnvironment:nil.

    workerClass compile:'
print:aLine
    self synchronized:[.
        aLine do:[:ch |
            Transcript show:ch.
            Delay waitForSeconds:0.2.
        ].
        Transcript cr.
    ]
'.

    workerClass compile:'
printWithError:aLine
    self synchronized:[.
        aLine do:[:ch |
            Transcript show:ch.
            ch == $l ifTrue:[ self foo ].
            Delay waitForSeconds:0.2.
        ].
        Transcript cr.
    ]
'.

    worker := workerClass new.
    'now ready for printing'.
    worker printWithError:'abcdef'.
    worker printWithError:'hello world'.
"
! !

!ActiveObject class methodsFor:'initialization'!

initialize
    AccessLock := Semaphore forMutualExclusion.
    "/ self lookupObject: RedirectingLookup new
    self lookupObject: nil
! !

!ActiveObject class methodsFor:'instance creation'!

new
    |newObject|


    newObject := self basicNew initialize.
    ^  newObject.
! !

!ActiveObject methodsFor:'accessing'!

process
    ^ process
! !

!ActiveObject methodsFor:'message handling'!

messageHandlingLoop
    |here|

    [ true ] whileTrue:[
        |paket|

        "/ Transcript showCR:'A: await message...'.
        (messageQueue readWaitWithTimeoutMs:30000) ifTrue:[
            "/ inactive for 30 seconds - exit
            AccessLock critical:[
                messageQueue isEmpty ifTrue:[
                    "/ Transcript showCR:'A: inactive - stop worker'.
                    process := nil.
                    messageQueue := nil.
                ].
                "exit the worker process loop"
                ^ self
            ].
        ].
        
        paket := messageQueue next.
        "/ Transcript showCR:'A: got message: ', paket selector.
        Exception handle:[:ex |
             |ex2 c c2|

             "create a copy of the sender chain, up to this frame here
              (cannot pass the original exception chain, because that one will be unwound, 
               thereby clearing the senders)"

             ex2 := ex shallowCopy.
             c := ex2 suspendedContext.
             c2 := c shallowCopy.
             ex2 suspendedContext: c2.
             [ c sender ~~ here ] whileTrue:[
                c2 setSender:(c sender shallowCopy).
                c2 := c2 sender.
                c := c sender
             ].
             paket ok: false.
             paket exception: ex2.
        ] do:[
            |rslt|

            here := thisContext.    
            rslt := paket action value. "<- here, an exception may occur"
            paket ok: true.
            paket result:rslt.
        ].
        "/ Transcript showCR:'send reply.'.
        paket ready signal
    ].
!

sendAction: aBlock
    |paket sema k|

    process isNil ifTrue:[
        AccessLock critical:[
            process isNil ifTrue:[
                "/ Transcript showCR:'starting worker thread'.
                messageQueue := SharedQueue new.
                process := [
                                [
                                    self messageHandlingLoop
                                ] ensure:[
                                    process := nil
                                ]
                           ] fork.
            ]
        ]
    ].

    paket := MessageAndResponse new.
    paket action: aBlock.
    paket ready: (sema := Semaphore new).

    messageQueue nextPut: paket.
    sema wait.

    "arrive here, when done with message"
    paket ok ifTrue:[
        ^ paket result
    ].
    "/ exception

    "/ patch the sender chain by tacking my calling chain to the end of the exception chain (from the worker), 
    "/ so the debugger shows a picture as if the error happened here
    k := paket exception suspendedContext.
    [ k sender notNil ] whileTrue:[ k := k sender ].
    k setSender: thisContext sender sender.  "/ hide sendAction and synchronized frames
    paket exception doRaise. "/ reraise, now in my context
!

sendSelector: selector arguments: arguments
    |paket sema|

    process isNil ifTrue:[
        AccessLock critical:[
            process isNil ifTrue:[
                "/ Transcript showCR:'starting worker thread'.
                messageQueue := SharedQueue new.
                process := [
                                [
                                    self messageHandlingLoop
                                ] ensure:[
                                    process := nil
                                ]
                           ] fork.
            ]
        ]
    ].

    paket := MessageAndResponse new.
    paket selector: selector.
    paket arguments: arguments.
    paket ready: (sema := Semaphore new).
    "/ Transcript showCR:'send message...'.
    messageQueue nextPut: paket.
    sema wait.
    "/ Transcript showCR:'got reply...'.
    "arrive here, when done with message"
    paket ok ifTrue:[
        ^ paket result
    ].
    "/ exception
    paket exception raiseSignal. "/ reraise, now in my context
!

synchronized:aBlock
    Processor activeProcess == process ifTrue:[
        ^ aBlock value
    ].

    ^ self sendAction:aBlock.
!

synchronizedMethod
    "marks calling methods as being handled via the queue"

    |retVal|

    Processor activeProcess == process ifTrue:[
        ^ self
    ].

    retVal := self sendSelector:(thisContext sender selector) arguments:(thisContext sender args).
    thisContext sender return:retVal.
! !

!ActiveObject::MessageAndResponse methodsFor:'accessing'!

action
    ^ action
!

action:something
    action := something.
!

exception
    ^ exception
!

exception:something
    exception := something.
!

ok
    ^ ok
!

ok:something
    ok := something.
!

ready
    ^ ready
!

ready:something
    ready := something.
!

result
    ^ result
!

result:something
    result := something.
! !

!ActiveObject::RedirectingLookup class methodsFor:'instance creation'!

new
    Instance isNil ifTrue: [Instance := self basicNew].
    ^ Instance
! !

!ActiveObject::RedirectingLookup methodsFor:'lookup'!

lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext
    "redircet everything into the receiver's doesNotUnderstand method"

Transcript show:'l '; showCR:aReceiver class name.
    (aReceiver isNil "fake call from lookupMethodFor: - sigh"
    or:[
        "insider messages are handled as usual"
        "to avoid recursive lookup error..."
        ((ActiveObject compiledMethodAt:#process) valueWithReceiver: aReceiver arguments:#()) == Processor activeProcess]
    ) ifTrue:[
        ^  super lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext
    ].
    "messages from the outside are forwarded to #doesNotUnderstand:"
    ^ aReceiver compiledMethodAt:#doesNotUnderstand.
! !

!ActiveObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/ActiveObject.st,v 1.1 2013-01-24 01:17:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/ActiveObject.st,v 1.1 2013-01-24 01:17:14 cg Exp $'
! !


ActiveObject initialize!

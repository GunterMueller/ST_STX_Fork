"{ Package: 'stx:libbasic2' }"

Object subclass:#SynchronizedObject
	instanceVariableNames:'lock'
	classVariableNames:'AccessLock'
	poolDictionaries:''
	category:'Kernel-Processes'
!

!SynchronizedObject class methodsFor:'documentation'!

documentation
"
    synchronized objects execute incoming messages in a serialized, synchronous manner,
    locking out other messages while executing any synchronized method.
    Synchronized methods are marked with a synchronized pragma; i.e. with '<synchronized>'.
    Non-synchronized methods behave as usual.

    Normally, I am subclassed, but see the example for an anonymous class example.


    [Author:]
        Claus Gittinger
"
!

examples
"
  normally, one would subclass SynchronizedObject and put protocol into it;
  here, for the example, an anon Printer is defined. It is slow printing to the Transcript for a demo.
  The interesting thing is the error handling which is demonstrated in printWithError:
  Any exception inside the worker object is returned back and raised in the active-object's client,
  not in the worker (take a look at the call-chain, when running the example below).


    |workerClass worker|

    workerClass := SynchronizedObject 
                        subclass:#Printer
                        instanceVariableNames:''
                        classVariableNames:''
                        poolDictionaries:''
                        category:nil
                        inEnvironment:nil.

    workerClass compile:'print:aLine
    <synchronized>

    aLine do:[:ch |
        Transcript show:ch.
        Delay waitForSeconds:0.2.
    ].
    Transcript cr.
'.

    workerClass compile:'printWithError:aLine
    <synchronized>

    aLine do:[:ch |
        Transcript show:ch.
        ch == $l ifTrue:[ self foo ].
        Delay waitForSeconds:0.2.
    ].
    Transcript cr.
'.

    worker := workerClass new.
    'now ready for printing'.
    worker printWithError:'abcdef'.
    worker printWithError:'hello world'.
"
! !

!SynchronizedObject class methodsFor:'initialization'!

initialize
    AccessLock := Semaphore forMutualExclusion.
! !

!SynchronizedObject class methodsFor:'instance creation'!

new
    ^ self basicNew initializeLock initialize.
! !

!SynchronizedObject class methodsFor:'utilities'!

addSelector: selector withMethod: aMethod
    (aMethod hasAnnotation: #synchronized) ifTrue:[
        ^ super addSelector: selector withMethod: (self makeSynchronizedMethod: aMethod selector: selector)
    ].
    ^ super addSelector: selector withMethod: aMethod
!

makeSynchronizedMethod: originalMethod selector:selector
    |realMethod i|

    realMethod := Compiler 
                    compile: ('%1 |args|  args := thisContext args. lock critical:[ #placeHolder valueWithReceiver:self arguments:args selector:#''%2'' search: nil sender: nil ]. ^  self' 
                                bindWith:(Compiler methodSpecificationForSelector: selector)
                                with: selector)
                    forClass: self
                    install: false.
    realMethod category:(originalMethod category).
    realMethod source:(originalMethod source).
    i := realMethod literals indexOf: #placeHolder.
    realMethod literalAt:i put: originalMethod.
    ^ realMethod
! !

!SynchronizedObject methodsFor:'initialization'!

initializeLock
    lock := RecursionLock new.
! !

!SynchronizedObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/SynchronizedObject.st,v 1.1 2013-01-24 15:52:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/SynchronizedObject.st,v 1.1 2013-01-24 15:52:14 cg Exp $'
! !


SynchronizedObject initialize!

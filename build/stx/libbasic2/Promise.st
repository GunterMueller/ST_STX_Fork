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

Object subclass:#Promise
	instanceVariableNames:'value valueAvailable exception'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Promise class methodsFor:'documentation'!

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
    When created, a promise will start to evaluate its block in the background,
    and promise to deliver the value of this computation, when asked
    for it via #value. Promises can be used for background computations,
    which automatically block the user of the result when that result is needed,
    unless the computation finished in the meanwhile.

    See also Block>>promise and Lazy/Future in libbasic2.
"
!

examples
"
     |p|

     p := [10000 factorial] promise.
     Transcript showCR:'doing something else'.
     p value   
"
! !

!Promise class methodsFor:'instance creation'!

new
    ^ self basicNew initialize 
!

value:aBlock
    "create and return a Promise to evaluate aBlock at the current priority"

    ^ self new value:aBlock priority:Processor activePriority 
!

value:aBlock priority:aPrio
    "create and return a Promise to evaluate aBlock at some priority"

    ^ self new value:aBlock priority:aPrio
! !

!Promise methodsFor:'accessing'!

value
    "return the value of the promise. 
     If the evaluation process has not yet finished, wait for it.
     Otherwise return the value immediately.
     Any exception which occurred during the evaluation is forwarded to the
     requestor of the value here."

    valueAvailable waitUncounted.
    exception notNil ifTrue:[
        "/
        "/ an exception occurred while evaluating the promise.
        "/ This exception is remembered and raised here, when the
        "/ value is asked for.
        "/
        exception raise
    ].
    ^ value
!

value:anObject
    "fake value arrived"

    value := anObject.
    valueAvailable signal.
    valueAvailable signalForAll.
! !

!Promise methodsFor:'initialization'!

initialize
    "setup"

    valueAvailable := (Semaphore new:0) name:'valueAvailable'.
!

value:aBlock priority:aPrio
    "setup and start the evaluation process."

    valueAvailable := (Semaphore new:0) name:'valueAvailable'.

    [
	ErrorSignal handle:[:ex |
	    exception := ex.
	    ex return.
	] do:[
	    value := aBlock value.
	].
	valueAvailable signal.
	valueAvailable signalForAll.
    ] forkAt:aPrio

    "
     Promise value:[100 timesRepeat:[1000 factorial]] priority:7
    "
    "
     Promise value:[10 timesRepeat:[1000 factorial]. [self halt] value.] priority:7
    "
! !

!Promise methodsFor:'queries'!

hasValue
    "return true, if the promise has a value avaliable.
     (i.e. if sending #value to it would NOT block)"

    ^ valueAvailable wouldBlock not
! !

!Promise class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


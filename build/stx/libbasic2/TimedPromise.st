"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Promise subclass:#TimedPromise
	instanceVariableNames:'delay ms'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!TimedPromise class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    A TimedPromise is a Promise with a timeout.
    An attempt to read the value of a TimedPromise will wait until the process has finished computing it 
    or the specified timeout expires.  
    If the process terminates with an exception, an attempt to read the value of the TimedPromise will raise the same exception. 
    In case of a timeout the OsNeedRetryError will be raised.
"
!

examples
"
                                                                    [exBegin]
     |p|

     p := TimedPromise forMilliseconds:1000.
     p value:[10000 factorial] priority:Processor activePriority.

     Transcript showCR:'doing something else'.
     p value   
                                                                    [exEnd]


                                                                    [exBegin]
     |p|

     p := TimedPromise forMilliseconds:1000.
     p value:[1000 factorial] priority:Processor activePriority.

     Transcript showCR:'doing something else'.
     p value   
                                                                    [exEnd]


                                                                    [exBegin]
     |p|

     p := TimedPromise forMilliseconds:1000.
     p value:[1000 factorial. ZeroDivide raise] priority:Processor activePriority.

     Transcript showCR:'doing something else'.
     p value   
                                                                    [exEnd]
"
! !

!TimedPromise class methodsFor:'instance creation'!

forMilliseconds: ms
        ^super new ms: ms.
! !

!TimedPromise methodsFor:'accessing'!

ms: msec
	ms := msec
! !

!TimedPromise methodsFor:'accessing-parent'!

value
        | whichSemaSignalled delaySemaphore |

        " Note -- only good for one waiter "
        delay notNil ifTrue:[
            self error:'Only one waiter allowed'.
        ].

        self startup.
        delay isNil ifTrue: [ ^ super value ].

        delaySemaphore := delay delaySemaphore.
        whichSemaSignalled := (SemaphoreSet with:valueAvailable with:delaySemaphore) wait.
        delay disable.
        delay := nil.

        exception == nil
                ifTrue: [
                        whichSemaSignalled == delaySemaphore
                                ifTrue: [OSErrorHolder needRetrySignal raise]
                                ifFalse: [^value]]
                ifFalse: [exception raise "(exception copyForReraise) searchFrom: thisContext; raise"]
! !

!TimedPromise methodsFor:'private'!

startup
    "Wait for data arrival or alarm expiry."

    ms notNil ifTrue:[delay := Delay waitForMilliseconds: ms]
! !

!TimedPromise class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/TimedPromise.st,v 1.3 2014-02-28 13:14:59 mb Exp $'
! !


"
   Copyright (c) 2017 Jan Vrany

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   'Software'), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#AbstractLock
	instanceVariableNames:'process sema count'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!AbstractLock class methodsFor:'documentation'!

copyright
"
   Copyright (c) 2017 Jan Vrany

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   'Software'), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"

!

documentation
"
    A base superclass for owned reentrant locks. It provides generic and somewhat
    slow implementation of:

      * `#acquire` and `#acquireWithTimeoutMs:`
      * `#release`
      * `#critical:` and `#critical:timeoutMs:ifBlocking:`

    Subclasses may (an should) override (some) of these with optimized versions
    and eventually fall back to implementation defined here. See subclasses.


    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        process <Process | ni>      a process that currently owns the
                                    lock or nil (if no process owns it)
        count <SmallInteger>        nesting depth
        sema <Semaphore>            a semaphore to signal waiter in case
                                    of contention

    [class variables:]

    [see also:]
        RecursionLock
        JavaMonitor

"
! !

!AbstractLock class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

! !

!AbstractLock class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == AbstractLock.
! !

!AbstractLock methodsFor:'accessing'!

count
    ^ count

    "Created: / 28-08-2017 / 21:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ sema name

    "Created: / 28-08-2017 / 21:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aString
    sema name:aString

    "Created: / 28-08-2017 / 21:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

owner
    ^ process

    "Created: / 28-08-2017 / 21:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractLock methodsFor:'acquire & release'!

acquire
    "
    Acquire the lock:

       * If the lock is not owned by any process, lock it and return immediately.
       * If the lock is already owned by the calling process, return immediately.
       * Otherwise, wait until owning process release it (by means of #release).

    Return `true` (always)
    "
    ^self acquireWithTimeoutMs: nil


    "Created: / 25-08-2017 / 08:34:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acquireWithTimeoutMs: timeout
    "
    Acquire the lock:

       * If the lock is not owned by any process, lock it and return immediately.
       * If the lock is already owned by the calling process, return immediately.
       * Otherwise, wait until owning process release it (by means of #release)
         at most `timeout` milliseconds. If `timeout` is nil, wait forever.

    Return `true` if the lock has been acquired or `false` if bot (e.g. wait
    timed out)
    "

    | active wasBlocked acquired |
    acquired := nil.
    active := Processor activeProcess.
    process == active ifTrue:[
        "/ Process already ackquired the monitor, increase the
        "/ count and continue...
        count := count + 1.
        ^true.
    ].
    wasBlocked := OperatingSystem blockInterrupts.
    [
        (process notNil and:[ process isDead ]) ifTrue:[
            "/ Process that acquired the monitor died without releasing it.
            "/ This should not happen.
            wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
            self assert: false description: 'Process that acquired the lock died without releasing it'.
            process := nil.
            count := 0.
        ].
        "/ We need to know that we already waited on and got semaphore
        "/ in case the Semaphore >> #wait is prematurely terminated.
        "/ Q: Can this actually happen? If so, how?
        acquired := sema waitWithTimeoutMs: timeout.
        acquired notNil ifTrue:[
            process := active.
            count := 1.
        ].
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ] ifCurtailed:[
        acquired notNil ifTrue:[
            OperatingSystem blockInterrupts.
            count := 0.
            process := nil.
            sema signal.
        ].
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    ^acquired notNil.

    "Created: / 25-08-2017 / 22:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-12-2017 / 14:11:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    "
    Release the lock. Return true of lock has been released, `false` if
    not (because calling process does not own it).
    "
    | active wasBlocked |

    active := Processor activeProcess.
    process == active ifFalse:[
        "/ Oops,  calling thread does not own the monitor. return false
        "/ immediately.
        ^ false.
    ].
    wasBlocked := OperatingSystem blockInterrupts.
    count == 1 ifTrue:[
        process := nil.
        count := 0.
        sema signal.
    ] ifFalse:[
        count := count - 1.
    ].
    wasBlocked ifFalse:[ OperatingSystem unblockInterrupts ].
    ^ true


    "Created: / 25-08-2017 / 08:38:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractLock methodsFor:'initialization'!

initialize
    process := nil.
    sema := Semaphore new: 1.
    sema name:'Lock@' , self identityHash printString.
    count := 0.

    "Modified: / 29-08-2017 / 09:53:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractLock methodsFor:'synchronized evaluation'!

critical:aBlock
    "Evaluate aBlock as a critical region. Same process may
     enter critical region again, i.e., nesting allowed.

     Returns the (return) value of `aBlock`
    "
    ^self critical: aBlock timeoutMs: nil ifBlocking: nil

    "Modified (comment): / 25-08-2017 / 09:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

critical:aBlock ifBlocking:blockingBlock
    "Like #critical:, but do not block if the lock cannot be acquired.
     Instead, return the value of the second argument, `blockingBlock`."

    ^ self critical:aBlock timeoutMs:0 ifBlocking:blockingBlock.
!

critical:aBlock timeoutMs:timeoutMs ifBlocking:blockingBlock
    "Like #critical:, but do not block if the lock cannot be acquired
     within `timeoutMs` milliseconds. Instead, return the value of `blockingBlock.`"

    | acquired retval |

    [
        acquired := self acquireWithTimeoutMs: timeoutMs.
        acquired ifTrue:[
            retval := aBlock value
        ] ifFalse:[
            retval := blockingBlock value.
        ]
    ] ensure:[
        acquired ifTrue:[
            self release.
        ]
    ].
    ^retval
! !

!AbstractLock class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


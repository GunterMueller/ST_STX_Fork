"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

AbstractLock subclass:#JavaMonitor
	instanceVariableNames:'waitingSema waitEnabled ownerPrintString'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaMonitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaMonitor class methodsFor:'instance creation'!

for: owningObject
    ^ self basicNew initializeFor: owningObject.

    "Created: / 30-11-2011 / 20:39:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

for: owningObject thread: threadOrNil nestedLockCount: count
    ^ self basicNew initializeFor: owningObject thread: threadOrNil nestedLockCount: count

    "Created: / 26-08-2012 / 17:01:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitor methodsFor:'accessing'!

count
    ^ count
!

owningProcess
    "Return the process that has acquired (entered) the receiver or
     nil if no process currently has the monitor."

    ^ process

    "Created: / 12-08-2017 / 23:11:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processesEntered
    "Return a alist of processes that entered the monitor. For testing / debugging purposes only!!"

    ^ process isNil
        ifTrue:[ #() ]
        ifFalse:[ (Array with: process) , sema waitingProcesses ]

    "Created: / 20-11-2011 / 13:22:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 03-06-2017 / 23:10:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitor methodsFor:'atomic'!

disableWait
    JavaVM monitorTrace ifTrue:[
        Logger log: ('Waiting is disabled on monitor for %1' bindWith: ownerPrintString) severity:Logger severityDEBUG facility:#JVM.
    ].
    "/ critical region not needed here
    "/ self instVarAccessCritical: [ waitEnabled := false ].
    waitEnabled := false.

    "Created: / 30-11-2011 / 20:34:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:06:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enableWait
    "/ critical region not needed here
    "/ self instVarAccessCritical: [waitEnabled := true].
    waitEnabled := true

    "Created: / 30-11-2011 / 20:34:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 11-10-2013 / 11:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

waitEnabled
    "/ critical region not needed here
    "/ self instVarAccessCritical: [ ^ waitEnabled].
    ^ waitEnabled.

    "Created: / 30-11-2011 / 20:34:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMonitor methodsFor:'initialization'!

initializeFor: owningObject
    self initializeFor: owningObject thread: 0 nestedLockCount: 0.

    "Created: / 30-11-2011 / 20:39:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 26-08-2012 / 17:25:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFor:owningObject thread:threadId nestedLockCount:cnt

"/    self assert: (owningObject isJavaObject or:[owningObject isJavaClass]).

    waitEnabled := true.
    waitingSema := Semaphore new:0.
    ownerPrintString := owningObject class name , '@' , owningObject identityHash printString.

    "/Not locked...
    threadId == 0 ifTrue:[
        sema := Semaphore new:1.
        count := 0.
        ^self.
    ] ifFalse: [
        "threadId is not zero (zero is threadId of scheduler process, which will never try to acquire the monitor)"
        "so it means it is possible that the thin lock is already locked for other thread, we must be careful "

        process := ObjectMemory processesKnownInVM detect:[:p|p id == threadId] ifNone:[nil].
        self assert: process notNil.
        cnt timesRepeat:[
"/            JavaVM enteredMonitorsOf:  owningProcess add: owningObject.
"/            JavaVM acquiredMonitorsOf: owningProcess add: owningObject.
        ].
        sema := Semaphore new: 0.
        count := cnt.
    ].

    "Created: / 26-08-2012 / 17:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2017 / 23:10:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitor methodsFor:'public'!

enter
    <resource: #obsolete>
    self obsoleteMethodWarning: 'Use #acquire instead'.
    ^ self acquire.

    "Created: / 20-11-2011 / 13:21:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2017 / 10:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exit
    <resource: #obsolete>
    self obsoleteMethodWarning: 'Use #release instead'.
    ^ self release.

    "Created: / 20-11-2011 / 13:21:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2017 / 10:20:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notify
    <resource: #obsolete>
    self obsoleteMethodWarning: 'Use `notify: false` instead'.
    ^ self notify: false.

    "Created: / 22-11-2011 / 12:14:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2017 / 10:19:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notify: all
    "
    An implementation of java.lang.Object#notify() and #notifyAll(). If `all` is
    `true` then all waiting threads are notified (see #norifyAll()) otherwise only
    one thread is notified (see #notify()). Returns `true` after when threads have
    been notified or `false` if calling thread does not own the monitor.

    See Java API documentation for java.lang.Object#notify() and #notifyAll().
        https://docs.oracle.com/javase/7/docs/api/java/lang/Object.html#notify()
        https://docs.oracle.com/javase/7/docs/api/java/lang/Object.html#notifyAll()
    "

    | active |
    active := Processor activeProcess.
    process == active ifFalse:[
        "/ Oops,  calling thread does not own the monitor. return false
        "/ immediately. The caller is responsible for throwing
        "/ IllegalMonitorStateException...
        ^ false.
    ].
    JavaVM monitorTrace ifTrue:[
        Logger
            log: ('%1: notifying %1%2 processes' bindWith: active printString
                    with: (all ifTrue:[ 'all ' ] ifFalse:[ '' ])
                    with: waitingSema waitingProcesses size)
            severity: Logger severityDEBUG
            facility: #JVM.
    ].
    all ifTrue:[ waitingSema signalForAll ] ifFalse:[ waitingSema signal ].
    Processor yield.
    ^ true

    "Created: / 14-08-2017 / 10:17:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notifyAll
    <resource: #obsolete>
    self obsoleteMethodWarning: 'Use `notify: true` instead'.
    ^ self notify: true.

    "Created: / 22-11-2011 / 12:14:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2017 / 10:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wait
    <resource: #obsolete>
    self obsoleteFeatureWarning: 'Use `waitForMilliseconds: nil` insteead'.
    ^ self waitForMilliseconds: nil.

    "Created: / 22-11-2011 / 11:57:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-08-2017 / 09:37:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

waitForMilliseconds: timeOut
    "
    An implementation of java.lang.Object#wait(long). Returns `true`
    after waiting or `false` immediately (i.e., won't block) if calling
    thread does not own the monitor.

    See Java API documentation for java.lang.Object#wait(long):
        https://docs.oracle.com/javase/7/docs/api/java/lang/Object.html#wait(long)
    "

    | active countBeforeWait |
    active := Processor activeProcess.
    process == active ifFalse:[
        "/ Oops,  calling thread does not own the monitor. return false
        "/ immediately. The caller is responsible for throwing
        "/ IllegalMonitorStateException...
        ^ false.
    ].
    self waitEnabled ifFalse: [
        JavaVM monitorTrace ifTrue:[
            Logger
                log: ('%1 wanted to go to sleep, but it cant, this monitor is for %2 which is already dead'
                        bindWith: active printString
                        with: ownerPrintString)
                severity: Logger severityDEBUG
                facility: #JVM.
        ].
        ^ true.
    ].
    JavaVM monitorTrace ifTrue:[
        Logger
            log: ('%1 is going to wait on %3 for timeout: %2'
                    bindWith: active printString
                    with: timeOut
                    with: ownerPrintString printString)
            severity: #debug
            facility: #JVM.
    ].
    countBeforeWait := count.
    "/ Release the monitor so other thread can acquire it
    "/ and call #notify or #notifyAll
    count := 1. "/ note that at this point we still own the monitor
    self release.

    "/ Monitor released, wait...
     "JV@2011-11-25: zero timeout means wait without timeout!!!!!!"
    timeOut == 0 ifTrue: [ waitingSema wait ] ifFalse: [
        waitingSema waitWithTimeoutMs: timeOut
    ].
    JavaVM monitorTrace ifTrue:[
        Logger
            log: ('%1 has been notified and is trying to acquire monitor for %2 which is owned by %3'
                    bindWith: active printString with: ownerPrintString printString with: process printString)
            severity: #debug
            facility: #JVM.
    ].
    "/ We have been notified, re-acquire the monitor
    self acquire.
    count := countBeforeWait. "/ note that at this point we already own the monitor.
    ^ true.

    "Created: / 22-11-2011 / 12:52:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-12-2011 / 10:57:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 14-08-2017 / 09:52:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitor methodsFor:'queries'!

isOwnedBy: aProcess
    ^ process == aProcess.

    "Created: / 20-11-2011 / 13:23:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-08-2017 / 21:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMonitor class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Delay
	instanceVariableNames:'millisecondDelta resumptionTime delaySemaphore isInterrupted'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!Delay class methodsFor:'documentation'!

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
    Instances of Delay are used to suspend the execution of a process
    (i.e. thread) for some time interval.
    Delays can be created either for some time-interval (seconds or milliseconds),
    or for delaying until a specific time has reached.
    Once created, a delay is waited upon with Delay>>wait.

    Notice: due to delays (both within Unix AND within Smalltalk itself,
    the resumption time will ALWAYS be after the actual delay time.
    (i.e. a Delay for n-millis will actually suspend for more than n milliseconds)

    Warning:
        currently, the implementation does not support delays longer than
        a system specific maximum - future versions may remove this limitation.
        For now, do not use delays longer than the value returned by
        OperatingSystem maximumMillisecondTimeDelta

    Also notice: the clock resolution of the operating system is usually limited
    (1/100, 1/60, 1/50, or even 1/20 of a second). Thus very small delays will
    delay for at least this minimum time interval. See examples.

    [see also:]
        Semaphore Process ProcessorScheduler
        Time Timestamp OperatingSystem
        (Using delay in ``Working with time, delays and interrupts'': programming/timing.html#DELAY)

    [author:]
        Claus Gittinger
"
!

examples
"
    Check your systems resolution with:
    (make certain, that no other timed processes are running in the background when doing this)
                                                                        [exBegin]
        |d t1 t2 res|

        Processor activeProcess priority:24.
        t1 := Time millisecondClockValue.
        d := Delay forMilliseconds:1.
        100 timesRepeat:[d wait].
        t2 := Time millisecondClockValue.
        res := (OperatingSystem millisecondTimeDeltaBetween:t2 and:t1) // 100.
        Transcript show:'minimum delta is about '; show:res; showCR:' milliseconds'.
        Processor activeProcess priority:8.
                                                                        [exEnd]


    examples:

    delaying for some time-delta:
    (notice: you cannot use this without time-errors in a loop,
     since the errors will accumulate; after 10 runs through the loop,
     more than 5 seconds have passed)

            |d|
            d := Delay forMilliseconds:500.
            10 timesRepeat:[d wait]

    prove:
                                                                    [exBegin]
            |d t1 t2 deltaT|
            d := Delay forMilliseconds:500.
            t1 := Time millisecondClockValue.
            20 timesRepeat:[
                d wait
            ].
            t2 := Time millisecondClockValue.
            deltaT := OperatingSystem millisecondTimeDeltaBetween:t2 and:t1.
            Transcript show:'average delay: '; show:deltaT // 20; showCR:' milliseconds'
                                                                    [exEnd]

    delaying until a specific time is reached:
    (this can be used to fix the above problem)
                                                                    [exBegin]
            |now then t1 t2 deltaT|

            t1 := Time millisecondClockValue.
            now := Time millisecondClockValue.
            20 timesRepeat:[
                then := OperatingSystem millisecondTimeAdd:now and:500.
                (Delay untilMilliseconds:then) wait.
                now := then
            ].
            t2 := Time millisecondClockValue.
            deltaT := OperatingSystem millisecondTimeDeltaBetween:t2 and:t1.
            Transcript show:'average delay: '; show:deltaT // 20; showCR:' milliseconds'
                                                                    [exEnd]

    instead of recreating new delays all over, 
    you can also reuse it (but that does not make a big difference ;-):
                                                                    [exBegin]
            |d now then t1 t2 deltaT|

            t1 := Time millisecondClockValue.
            now := Time millisecondClockValue.
            d := Delay new.
            10 timesRepeat:[
                then := OperatingSystem millisecondTimeAdd:now and:1000.
                d resumptionTime:then.
                d wait.
                now := then
            ].
            t2 := Time millisecondClockValue.
            deltaT := OperatingSystem millisecondTimeDeltaBetween:t2 and:t1.
            Transcript show:'average delay: '; show:deltaT // 10; showCR:' milliseconds'
                                                                    [exEnd]
"
! !

!Delay class methodsFor:'instance creation'!

for:aTimeDuration
    "return a new Delay object for delaying aTimeDuration"

    ^ self new delay:aTimeDuration getMilliseconds

    "
      Delay for:10 seconds
    "
!

forMilliseconds:aNumber
    "return a new Delay object for delaying aNumber milliseconds"

    ^ self new delay:aNumber
!

forSeconds:aNumber
    "return a new Delay object for delaying aNumber seconds"

    ^ self new delay:(aNumber * 1000) rounded
!

until:aTimeStamp
    "return a new Delay object, that will delay the active process
     until the system has reached the time represented by the argument."

    ^ self new delay:(aTimeStamp millisecondDeltaFrom:Timestamp now)

    "
        (self until:(Timestamp now + 1 seconds)) wait
        (self until:(Timestamp now - 30 seconds)) wait
    "
!

untilMilliseconds:aMillisecondTime
    "return a new Delay object, that will delay the active process
     until the systems millisecond time has reached aMillisecondTime."

    ^ self new resumptionTime:aMillisecondTime

    "Modified: 18.4.1997 / 11:57:53 / stefan"
! !

!Delay class methodsFor:'queries'!

millisecondClockValue
    "for ST-80 compatibility"

    ^ Time millisecondClockValue
! !

!Delay class methodsFor:'waiting'!

waitFor:aTimeDuration
    "wait for the given timeDuration.
     This is a combined instance creation & wait."

    ^ (self forMilliseconds:aTimeDuration getMilliseconds) wait


    "
     Delay waitFor:(TimeDuration seconds:5).
    "
!

waitForMilliseconds:aNumber
    "wait for the given number of milliseconds.
     This is a combined instance creation & wait."

    ^ (self forMilliseconds:aNumber) wait


    "
        |start end|

        start := OperatingSystem getMicrosecondTime.
        Delay waitForMilliseconds:1.
        end := OperatingSystem getMicrosecondTime.

        end - start
    "
!

waitForSeconds:aNumber
    "wait for the given number of seconds.
     This is a combined instance creation & wait."

    ^ (self forSeconds:aNumber) wait
!

waitUntil:aTimestamp
    "wait until a given time is reached.
     This is a combined instance creation & wait."

    ^ (self until:aTimestamp) wait

    "Created: / 29-07-2010 / 13:51:41 / cg"
! !

!Delay methodsFor:'accessing'!

delay:numberOfMillis
    "set the millisecond delta and create a new semaphore internally to wait upon"

    self assert:(numberOfMillis notNil).
    numberOfMillis < 0 ifTrue:[
        millisecondDelta := 0.
    ] ifFalse:[
        millisecondDelta := numberOfMillis.
    ].

    delaySemaphore := Semaphore new name:'delaySema'.

    "Modified: / 22-12-2010 / 14:18:00 / cg"
!

delaySemaphore
    "return the semaphore used to resume the waiting process"

    ^ delaySemaphore
!

resumptionTime:aMillisecondTime
    "set the resumption time and create a new semaphore internally to wait upon"

    resumptionTime := aMillisecondTime.
    delaySemaphore := Semaphore new name:'delaySema'.

    "Created: 18.4.1997 / 11:56:14 / stefan"
!

setDelayDuration:numberOfMillis
    "set the millisecond delta"

    self assert:(numberOfMillis notNil).
    numberOfMillis < 0 ifTrue:[
        millisecondDelta := 0.
    ] ifFalse:[
        millisecondDelta := numberOfMillis.
    ].
    resumptionTime := nil.
!

setResumptionTime:aMillisecondTime
    "set the resumption time"

    resumptionTime := aMillisecondTime.
    millisecondDelta := nil.
! !

!Delay methodsFor:'delaying'!

wait
    "suspend the current process until either the relative time delta
     has passed (if millisecondDelta is non-nil), or the absolute millisecondTime
     has been reached (if resumptionTime non-nil)."

    |wasBlocked currentDelta dueTime now then|

    isInterrupted := false.

    millisecondDelta notNil ifTrue:[
        currentDelta := millisecondDelta rounded.
        currentDelta <= 0 ifTrue:[
            ^ self.
        ].
        now := OperatingSystem getMillisecondTime.
        currentDelta > 16r0fffffff ifTrue:[
            "NOTE: the microsecondTime is increasing monotonically,
                   while millisecondTime is wrapping at 16r1fffffff.
                   So use the microsecondTime to check when we are finished"
            dueTime := OperatingSystem getMicrosecondTime + (currentDelta * 1000).
            currentDelta := 16r0fffffff.
        ].
        then := OperatingSystem millisecondTimeAdd:now and:currentDelta .
    ] ifFalse:[
        then := resumptionTime.
    ].

    wasBlocked := OperatingSystem blockInterrupts.
    [
        [
            Processor signal:delaySemaphore atMilliseconds:then.
            Processor activeProcess setStateTo:#timeWait if:#active.
            delaySemaphore wait.

            dueTime notNil
              and:[isInterrupted not
              and:[(currentDelta := dueTime - OperatingSystem getMicrosecondTime) > 0
              and:[
                currentDelta := (currentDelta // 1000) min:16r0fffffff.
                now := OperatingSystem getMillisecondTime.
                then := OperatingSystem millisecondTimeAdd:now and:currentDelta.
                true.]]]
        ] whileTrue.
    ] ensure:[
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ]

    "
     Transcript showCR:'1'.
     (Delay forSeconds:10) wait.
     Transcript showCR:'2'.
    "

    "Modified: 26.2.1997 / 15:21:35 / cg"
    "Modified: 18.4.1997 / 11:56:46 / stefan"
! !

!Delay methodsFor:'early signalling'!

resume
    "resume the waiter, even if the delay-time has not yet passed."

    [
        isInterrupted := true.
        self disable.
        delaySemaphore signalOnce.
    ] valueUninterruptably

    "Modified: / 9.11.1998 / 20:56:43 / cg"
! !

!Delay methodsFor:'private'!

disable
    "tell the ProcessorScheduler to forget about signaling my semaphore."

    Processor disableSemaphore:delaySemaphore
! !

!Delay class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


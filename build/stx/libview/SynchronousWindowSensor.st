"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

WindowSensor subclass:#SynchronousWindowSensor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!SynchronousWindowSensor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    These sensors are not used with regular views.

    In contrast to a regular windowSensor, instances of SynchronousWindowSensor
    do NOT put events into a queue and do NOT wakeup any windowGroup process.
    Instead, the underlying view is notified synchronously (via a message send)
    immediately about the event.

    SynchronousWindowSensor are used for only one single situation:
        when a super-modal debugger is open
    (i.e. one that is debugging the scheduler or event-dispatcher).

    This debugger's windowGroup is augmented with a synchronous Sensor, in order
    to prevent the event handling code from suspending any process
    (you cannot suspend the scheduler; you should not suspend the event dispatcher).

    This is pretty tricky and magic - and you don't have to understand this.
    (consider this system internal code)

    [author:]
        Claus Gittinger
"
! !

!SynchronousWindowSensor methodsFor:'dummy event flushing'!

compressKeyPressEventsWithKey:aKey
    ^ 0
!

flushEventsFor:aViewOrNil inQueue:anEventQueue where:aCondition
    ^ nil
! !

!SynchronousWindowSensor methodsFor:'event processing'!

addDamage:aRectangle view:aView wakeup:doWakeup
    "forward as an expose for some view"

    aView
        dispatchEvent:#exposeX:y:width:height:
        arguments:(Array with:aRectangle left
                         with:aRectangle top
                         with:aRectangle width
                         with:aRectangle height)
!

exposeX:x y:y width:w height:h view:aView
    "forward an expose for some view"

    ignoreExposeEvents ~~ true ifTrue:[
        aView
            dispatchEvent:#exposeX:y:width:height:
            arguments:(Array with:x with:y with:w with:h)
    ]
!

graphicsExposeX:x y:y width:w height:h final:final view:aView
    "forward a graphic expose for some view"

    "/ this is a possible response to a scroll operation
    "/ (if an expose is pending)

    final ifTrue:[
        (catchExpose includes:aView) ifTrue:[
            gotExpose add:aView.
        ]
    ].

    aView
        dispatchEvent:#graphicsExposeX:y:width:height:final:
        arguments:(Array with:x with:y with:w with:h with:final)

    "Created: / 24.11.1995 / 19:16:38 / cg"
    "Modified: / 20.5.1998 / 22:57:32 / cg"
!

noExposeView:aView
    "forward a noExpose event for some view"

    catchExpose isNil ifTrue:[
        Logger info:'noExpose but not catching: %1' with:aView.
    ].

    (catchExpose includes:aView) ifTrue:[
        gotExpose add:aView.
        catchExpose remove:aView.
    ].
    aView noExpose.

    "Created: 24.11.1995 / 19:18:10 / cg"
    "Modified: 29.1.1997 / 20:46:47 / cg"
!

saveAndTerminateView:aView
    "forward a saveAndTerminate event for some view"

    aView saveAndTerminate

    "Created: 24.11.1995 / 19:18:38 / cg"
!

terminateView:aView
    "forward a terminate event for some view"

    aView terminate

    "Created: 24.11.1995 / 19:18:48 / cg"
! !

!SynchronousWindowSensor methodsFor:'event processing-private'!

basicPushEvent:anEvent
    "disptach the event immediately"

    anEvent timeStamp isNil ifTrue:[
        anEvent timeStamp:(Timestamp now).
    ].
    WindowGroup lastEventQuerySignal answer:anEvent do:[
        anEvent view dispatchEvent:anEvent
    ].
!

pushDamageEvent:anEvent
    "disptach the event immediately"

    self basicPushEvent:anEvent
!

pushUserEvent:selector for:anyObject withArguments:argList
    "disptach the event immediately"

    ^ anyObject perform:selector withArguments:argList.
! !

!SynchronousWindowSensor methodsFor:'event simulation'!

enqueueMessage:selector for:someone arguments:argList
    "do it synchronously"
    someone perform:selector withArguments:argList
! !

!SynchronousWindowSensor methodsFor:'initialization'!

initialize
    "initialize the event queues to empty"

    super initialize.

    gotExpose := IdentitySet new.
    catchExpose := IdentitySet new.
    gotOtherEvent := IdentitySet new.

    compressMotionEvents := false.
    translateKeyboardEvents := true.
    ignoreUserInput := false.
    shiftDown := ctrlDown := altDown := metaDown := false.
    leftButtonDown := middleButtonDown := rightButtonDown := false.
! !

!SynchronousWindowSensor methodsFor:'specials'!

catchExposeFor:aView
    "start catching noExpose events (must be done BEFORE a bitblt)."

    catchExpose notEmpty ifTrue:[
        Logger warning:'already catching in catchExpose: %1' with:aView.
    ].

    gotOtherEvent remove:aView ifAbsent:nil.
    gotExpose remove:aView ifAbsent:nil.
    catchExpose add:aView.

    "Modified: 29.1.1997 / 20:43:44 / cg"
!

waitForExposeFor:aView
    "wait until a graphicsExpose or a noExpose arrives (after a bitblt)."

    |viewsDevice windowId stopPoll endPollTime|

    viewsDevice := aView graphicsDevice.

    "/ this is only needed for X ...
    viewsDevice scrollsAsynchronous ifTrue:[
        windowId := aView id.

        "/
        "/ cannot suspend, I am a synchronous-modal sensor
        "/ must poll for the event
        "/
        endPollTime := Timestamp now addSeconds:2.
        stopPoll := false.

        [stopPoll or:[gotExpose includes:aView]] whileFalse:[
            (viewsDevice exposeEventPendingFor:windowId withSync:true) ifTrue:[
                viewsDevice dispatchExposeEventFor:windowId.
            ].
            stopPoll := Timestamp now > endPollTime.
            Processor yield.
        ].
    ].
    stopPoll ifTrue:[
        Logger warning:'lost expose event: %1' with:aView.
    ].

    catchExpose remove:aView ifAbsent:nil.
    gotExpose remove:aView ifAbsent:nil.

    "Modified: 19.8.1997 / 17:25:09 / cg"
! !

!SynchronousWindowSensor class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


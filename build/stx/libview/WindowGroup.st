"{ Encoding: utf8 }"

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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WindowGroup
	instanceVariableNames:'graphicsDevice views topViews myProcess mySensor isModal
		previousGroup focusView focusSequence preEventHook postEventHook
		pointerView isForModalSubview focusByTab groupHasFocus busyHook
		busyHookTimeout inModalLoop isDebugged preEventHooks
		postEventHooks creatingProcess traceEvents processPriority
		inWithCursorDoBlock doNotCloseOnAbortSignal previousFocusView
		modalGroup'
	classVariableNames:'LastActiveGroup LastActiveProcess LeaveSignal
		WindowGroupQuerySignal LastEventQuerySignal BusyHookTime'
	poolDictionaries:''
	category:'Interface-Support-UI'
!

Query subclass:#LastEventQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowGroup
!

Query subclass:#WindowGroupQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:WindowGroup
!

!WindowGroup class methodsFor:'documentation'!

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
    In Smalltalk/X, the known (ST-80) concept of a controller has been
    extended (split) into a WindowGroup which handles process related stuff, 
    and the Controller, which only handles events for a view and defines the user interaction.
    The controller functionality might be (actually: often is) included in the view components.
    All interaction is via event queues - there is no polling in controllers (not even conceptionally).

    WindowGroups are responsible to wait for and forward events for a group of 
    windows. All views in a windowGroup share a single windowSensor which holds the
    event queue (therefore subviews all share the same input event queue).
    Actually, there are two separate event queues - one for damage and view-visibility-related events,
    another one for user interaction (such as mouse, keyboard etc.)

    The event queues are filled with incoming events as arriving from the physical display.
    This is done by a separate process (so called event-dispatcher) which runs at a higher
    priority. The event dispatcher determines the queue into which an event has to be placed,
    by asking the view for which the event is destined (via the view's sensor).
    There may be multiple event dispatchers running (to support multiple displays simultaneously),
    there may also be multiple input device readers running 
    (to suppert tablet/pen input, or other input devices).
    See the documentation/examples in DeviceWorkstation/XWorkstation on how this is done.

    Except for modal boxes, a separate process is created for each windowGroup 
    which waits for events to arrive and processes them, by sending corresponding
    event messages to the view's controller or the view (*). 
    The controller is determined by asking the view (for which the event is destined);
    if the returned controller is nil, the event is sent directly to the view.
    This allows for simple views to work without a controller.
    (all of this is actually done in a WindowEvent method)

    Therefore, multiple applications run pseudo parallel.
    Even if some window performs a long time computation, events are still received
    and entered into the corresponding event queues (because the event dispatcher process
    runs at a higher priority). However, the actual processing of the event is only
    possibly if no other process is busy at the same or a higher priority (unless timeslicing is enabled).
    If timeslicing is off, it is possible to change a windowProcesses priority in order to give 
    other windows a chance to execute (some views do this while performing longtime actions).

    Modal boxes create an extra window group for the components of the modal
    box, but execute the event-processing loop for this new group in the original process - 
    therefore, the original windowgroup is blocked for the duration of the modal 
    interaction.
    However, the modal-event processing loop peeks into the original groups event queue
    from time to time, and handles expose events. Thus, even while blocked for user input,
    the original group continues to get update/redraw events.

    Normally, one windowgroup is associated to each topview (StandardSystemView)
    and all of its subviews. However, this is not strictly required; 
    it is possible to create extra windowgroups for subviews, which will let them
    run in parallel 
        (for example, the FileBrowsers kill-Button is created that 
         way, to allow a kill of an executing unix command, while the browser 
         itself reads the pipeStream for incoming text.
         Even if the fileBrowser is busy reading the pipe, the killButton is still
         working and allows terminating the pipe-read action).

    On the other hand, multiple topviews can be placed into the same windowGroup;
    which allows for multiview applications, of which only one communicates with
    the user at a time (for example: the GUI painters canvas and gallery are in the same group).
    Multiple topviews within a windowGropup can be configured to behave like one 
    unit with respect to iconification, deiconification and termination.
    This is done by creating multiple topViews in one group, and setting up a master/slave
    or partner relation among them (see TopView>>beSlave and TopView>>bePartner).

    WindowGroups also support a focus window: this is the one that gets the
    keyboard input - even if the cursor is located in another subview.
    The sequence is defined by the topView or its model (typically an applicationModel).
    It should return an orderedCollection of subviews when asked via #focusSequence.

    For debugging or special event manipulations, windowGroups allow for hooks to be installed 
    around the processing of events - preEventHook is sent a #procesEvent: message before an event is processed,
    postEventHook is informed after the event has been processed.
    The preEventHook should return a boolean - if it returns true, the event is considered
    being already processed by the hook and ignored.
    This allows for event-tracing, timing or even filtering (if preEventHook returns true).
    (notice: there is also an eventHook facility available in the sensor class.)

    Finally, windowgroups are the perfect place for things like defining a
    cursor for all associated views, flushing all input, waiting for expose events etc.

    Late News:
      a busyHook and busyHookTimeout has been added; this hook-(block) gets invoked, whenever
      the process was busy handling an event for some time. This can be used to automatically install
      a busy cursor (hour-glass) in an application, if some processing takes some time
      (without a need for #withCursorDo: all over the place in the application)

    Don't get confused:
        You don't have to care for all those details in the normal case;
        a windowgroup is created for you automatically, when a view is opened.
        All of the internals are not required to be known for most applications.


    [instance variables:]

        views                   collection of views of this group

        topViews                collection of topviews of this group

        myProcess               the process executing the events

        mySensor                my input sensor

        isModal                 true if this is for a modal box; i.e. running a separate
                                modal event loop on top of another window group.
                                Those modal groups execute in the same process as the underlying group

        inModalLoop             true if this group's event processing is currently suspended
                                because I have opened a modal window (with its own 'isModal'
                                group) which handles events for a while.

        modalGroup              non-nil windowGroup which is my modal windowGroup, if I am
                                in a modal loop. I.e. the group which has been started by me and
                                which has taken control.

        previousGroup           if modal, the group that started this one (might be another modal one)

        isDebugged              true if a debugger sits on top of me

        focusView               the one that has the keyboard focus (or nil)

        focusByTab              if focus came via tabbing 
                                (as opposed to an implicit focus change)
                                
        focusSequence           defines the focus sequence

        preEventHook            if non-nil, that one gets notified of incoming
                                events BEFORE an event is dispatched.
                                May eat events (i.e. suppress dispatch)
                                (hook for event filters or recorders)

        postEventHook           if non-nil, that one gets notified
                                AFTER an event was dispatched.

        isForModalSubView

        groupHasFocus           true, if this windowGroup has the focus


    [class variables:]
        LeaveSignal             if raised, a modal box leaves (closes)

        WindowGroupQuerySignal  to ask for the current windowGroup,
                                anywhere in the program, simply raise this
                                signal. The raise returns nil, for processes,
                                which are not under control of a windowGroup.
                                (i.e. wg := WindowGroup windowGroupQuerySignal raise)

        LastEventQuerySignal    to ask for the event which was responsible
                                for being where you are (whereever that is).
                                The raise returns nil, if you did not arrive
                                there due to an event.
                                (i.e. ev := WindowGroup lastEventQuerySignal raise)
                                The event can be asked for the view, the type
                                of event, x/y position etc.


    (*) 
        due to historic reasons, many views have the controller functionality
        integrated, and handle events themself. The windowSensor takes care
        of this, by checking if a view has a controller, and, if so, forwarding 
        the events to it. Otherwise, events are sent directly to the view.

        In the future, all views will be rewritten to actually use a controller.
        Currently (being in the middle of this migration), only some views
        (buttons, toggles and subclasses) do so.

    For more information, read 'introduction to view programming' in the
    doc/online directory.

    [author:]
        Claus Gittinger

    [see also:]
        WindowSensor WindowEvent EventListener KeyboardForwarder
        DeviceWorkstation
        View StandardSystemView
        ApplicationModel
        Process ProcessorScheduler
        (``Working with processes (programmers manual)'': programming/processes.html#VIEWSNPROCS)
"
! !

!WindowGroup class methodsFor:'initialization'!

initialize
    LeaveSignal isNil ifTrue:[
        LeaveSignal := (Signal new) mayProceed:true.
        LeaveSignal nameClass:self message:#leaveSignal.
        LeaveSignal notifierString:'unhandled leave signal'.

        WindowGroupQuerySignal := WindowGroupQuery.
        LastEventQuerySignal := LastEventQuery.

"/        WindowGroupQuerySignal := QuerySignal new.
"/        WindowGroupQuerySignal nameClass:self message:#windowGroupQuerySignal.
"/        WindowGroupQuerySignal notifierString:'query for windowgroup'.
"/
"/        LastEventQuerySignal := QuerySignal new.
"/        LastEventQuerySignal nameClass:self message:#lastEventQuerySignal.
"/        LastEventQuerySignal notifierString:'query for last event'.
    ].

    "WindowGroup initialize"

    "Modified: / 27-01-2011 / 18:14:34 / cg"
! !

!WindowGroup class methodsFor:'instance creation'!

new
    "create and return a new WindowGroup object"

    ^ self basicNew initialize
! !

!WindowGroup class methodsFor:'Signal constants'!

lastEventQuerySignal
    "return the signal which is used to query for the last event"

    ^ LastEventQuerySignal

    "Created: 17.7.1996 / 20:36:04 / cg"
!

leaveSignal
    "return the signal which is used to exit a modal loop.
     This private signal, is always caught while a modalbox is active.
     Raising it will exit the modal loop and return from the view's #openModal
     method."

    ^ LeaveSignal
!

windowGroupQuerySignal
    "return the signal which is used to query for the windowGroup"

    ^ WindowGroupQuerySignal

    "Created: 17.7.1996 / 20:36:04 / cg"
! !

!WindowGroup class methodsFor:'accessing'!

activeApplication
    "return the currently active application.
     Notice: this may be a modal dialogs application - i.e. it is not
     always the main application."

    |activeGroup|

    (activeGroup := self activeGroup) notNil ifTrue:[
        ^ activeGroup application
    ].
    ^ nil

    "
     WindowGroup activeApplication 
    "
!

activeGroup
    "return the currently active windowGroup.
     The returned value may not be fully correct, in case the current process
     handles multiple windowGroups simultaneously. In this case, 
     (usually) the first group is returned (prefering a modal if there is one). 
     (maybe we should return a collection of windowGroups here).

     This method is required to simulate the historic ST-80 single display
     behavior for Cursor>>show / Cursor>>showWhile and some others (raising the
     activeGroups topView when modalBoxes appear) on multiple display screens. 
     These methods should change the cursor for the currently 
     active windowGroup ONLY, instead of globally affecting the display or
     all views
     (since, depending on the priority, other views could be unaffacted by this 
      and an overall cursor change does not make sense.)"

    |activeProcess groups wg|

    Processor isNil ifTrue:[^ nil]. "/ only during very early init phase

    activeProcess := Processor activeProcess.
    " caching the last value ..."
    activeProcess == LastActiveProcess ifTrue:[
        (LastActiveGroup notNil 
        and:[LastActiveGroup process == LastActiveProcess
        and:[LastActiveGroup views notEmptyOrNil ]]) ifTrue:[
            ^ LastActiveGroup
        ]
    ].

    WindowGroupQuerySignal isNil ifTrue:[^ nil]. "/ only during very early init phase
    wg := WindowGroupQuerySignal query.

    wg isNil ifTrue:[
        "/ mhmh - noone willing to answer that question ...
        "/ (how can this happen ?)
        groups := self scheduledWindowGroups 
                    select:[:wg | wg process == activeProcess].
        groups notEmpty ifTrue:[
            wg := groups detect:[:wg | wg isModal] ifNone:nil.
            wg isNil ifTrue:[
                wg := groups anElement
            ]
        ].
    ].

    wg notNil ifTrue:[
        LastActiveProcess := activeProcess.
        LastActiveGroup := wg.
    ].
    ^ wg

    "
     WindowGroup activeGroup 
    "

    "Modified: / 3.9.1995 / 14:49:53 / claus"
    "Modified: / 17.4.1998 / 11:49:28 / cg"
    "Modified: / 18.3.1999 / 18:30:33 / stefan"
!

activeMainApplication
    "return the currently active main application.
     Notice: 
        if invoked by a modal application, this returns the main (non-modal)
        application."

    |activeGroup mainView|

    (activeGroup := self activeGroup) notNil ifTrue:[
        (mainView := activeGroup mainGroup mainView) notNil ifTrue:[
            ^ mainView application
        ]
    ].
    ^ nil

    "
     WindowGroup activeMainApplication 
    "

!

flushCachedActiveGroup
    self setActiveGroup:nil
!

scheduledWindowGroups
    "return a collection of all windowGroups (possibly for different
     display devices) which are scheduled 
     (i.e. which have a process running, handling events)."

    |set screens coll|

    screens := Screen allScreens.
    screens size == 0 ifTrue:[^ #()].

    set := IdentitySet new.
    coll := OrderedCollection new.

    screens do:[:aDevice |
        aDevice allViewsDo:[:aView |
            |wg|

            (wg := aView windowGroup) notNil ifTrue:[
                (wg process notNil and:[wg process isDead not]) ifTrue:[
                    (set includes:wg) ifFalse:[
                        set add:wg.
                        coll add:wg.
                    ].
                ]
            ].
        ].
    ].
    ^ coll asArray

    "
     WindowGroup scheduledWindowGroups   
    "

    "Modified: 1.9.1995 / 13:43:09 / claus"
    "Modified: 18.8.1997 / 18:44:29 / cg"
!

setActiveGroup:aGroup
    "set the currently active windowGroup.
     Temporary; do not use this interface, it will vanish."

    aGroup isNil ifTrue:[
        LastActiveProcess := LastActiveGroup := nil.
    ] ifFalse:[
        LastActiveProcess := Processor activeProcess.
        LastActiveGroup := aGroup
    ].

    "Modified: / 29-08-2013 / 14:49:11 / cg"
! !

!WindowGroup class methodsFor:'focus control support'!

takeFocusFromDevice:aDevice
    |prevFocusView prevFocusGroup prevFocusCameViaTab|

    "/
    "/ take the focus from whichEver view had it previously
    "/
    prevFocusView := aDevice focusView.
    prevFocusView notNil ifTrue:[
        aDevice focusView:nil.
        (prevFocusGroup := prevFocusView windowGroup) notNil ifTrue:[
            prevFocusCameViaTab := prevFocusGroup focusCameByTab.

            prevFocusView showNoFocus:prevFocusCameViaTab. "/ true is bad - see pullDownMenu.
            self sendKeyboardFocusEventTo:prevFocusView withArgument:false.
        ].
    ].

    "Modified: / 08-11-2006 / 12:05:22 / cg"
! !

!WindowGroup class methodsFor:'others'!

sendKeyboardFocusEventTo:aView withArgument:arg
    |sensor ev|

    aView isNil ifTrue:[^ self].

    (sensor := aView sensor) notNil ifTrue:[
        ev := WindowEvent keyboardFocus:arg view:aView.   
        sensor notifyEventListenersAbout:ev.
        sensor pushEvent:ev.
    ] ifFalse:[
        aView hasKeyboardFocus:arg
    ].
! !

!WindowGroup methodsFor:'accessing'!

creatingProcess
    "return the process which created this group or nil.
     Only returns non-nil for modal groups."

    ^ creatingProcess

    "Modified: / 17.8.1998 / 10:21:29 / cg"
!

device
    "return the device, we receive our events from"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #graphicsDevice'.
    ^ self graphicsDevice

    "Modified: 5.7.1996 / 17:53:58 / cg"
!

doNotCloseOnAbortSignal:something
    "normally, an abortSignal closes a modal dialog, which is different from a non-modal
     one, where only the current action (event handling) is aborted.

     This can be disabled, if you want to avoid closing a modal application,
     but instead have the same non-modal behavior for modal app vies"

    doNotCloseOnAbortSignal := something.
!

graphicsDevice
    "return the device, we receive our events from"

    |dev|

    graphicsDevice notNil ifTrue:[^ graphicsDevice].

    topViews notNil ifTrue:[
	topViews do:[:v |
	    |app|

	    v notNil ifTrue:[
		(app := v application) notNil ifTrue:[
		    "/
		    "/ ok, it has an application;
		    "/ ask it for preferences.
		    "/
		    (dev := app graphicsDevice) notNil ifTrue:[
			^ (graphicsDevice := dev)
		    ]
		].
		(dev := v graphicsDevice) notNil ifTrue:[
		    ^ (graphicsDevice := dev)
		]
	    ]
	]
    ].
    views notNil ifTrue:[
	views do:[:v |
	    v notNil ifTrue:[
		(dev := v graphicsDevice) notNil ifTrue:[
		    ^ (graphicsDevice := dev)
		]
	    ]
	]
    ].
    "/ ask the previousGroup; I could be a popUp-views group,
    "/ which has already closed its views (and is performing its action)
    previousGroup notNil ifTrue:[
	^ previousGroup graphicsDevice
    ].
    ^ nil

    "Modified: / 9.7.1998 / 18:18:08 / cg"
!

isDebugged
    "return true, if the receiver has a debugger sitting on top of me,
     so I do not have control"

    ^ isDebugged ? false

    "Created: / 28-08-2013 / 21:51:33 / cg"
!

isDebugged:aBoolean
    "only set by the debugger to mark the currently active group as being debugged"

    isDebugged := aBoolean

    "Created: / 28-08-2013 / 21:52:35 / cg"
!

isInModalLoop
    "return true, if the receiver has given up control to some other modal windowGroup
     (i.e. if it has popped up a modal dialog or a popUpMenu)"

    "/ ^ modalGroup notNil.
    ^ inModalLoop ? false

    "Modified: / 13-11-2016 / 22:59:29 / cg"
!

isModal
    "return true, if the receiver is for a modal view
     (i.e. it is for a modal box, dialog or popUpMenu). 
     The suspended windowgroup would return true to the isInModalLoop query if this is the case."

    ^ isModal

    "Modified: 7.3.1996 / 14:29:46 / cg"
!

mainGroup
    "return the main windowgroup (for modal groups only) 
     that is the top one, which is not modal.
     NonModal groups return themSelf.

     There is one exception to this: the debugger (which is sort of modal)
     returns itself as mainGroup (not its debuggee)."

    |g prev|

    g := self.
    [(g isModal or:[g isPopUp])
     and:[(prev := g previousGroup) notNil]] whileTrue:[
        g == prev ifTrue:[^ g]. 
        g := prev
    ].
    ^ g

    "Modified: 3.9.1995 / 14:57:20 / claus"
    "Modified: 7.3.1996 / 14:29:28 / cg"
!

mainGroup:aWindowGroup
    "set the main windowgroup (for modal/autonomous groups only) 
     Exposeevents for that windowGroup will be handled by this group
     as well."

    self assert:(aWindowGroup ~~ self).
    previousGroup := aWindowGroup

    "Created: 20.8.1997 / 17:57:35 / cg"
!

modalGroup
    "if the receiver has given up control to some other modal windowGroup
     (i.e. if it has popped up a modal dialog or a popUpMenu), this is the modelGroup"

    ^ modalGroup

    "Modified (comment): / 15-11-2016 / 00:13:47 / cg"
!

previousGroup
    "return the windowgroup that started this group. (for modal groups only).
     This may be another modalGroup (for boxes opened by boxes).
     NonModal groups return nil."

    ^ previousGroup

    "Modified: 7.3.1996 / 14:28:46 / cg"
!

process 
    "return the windowGroups process"

    myProcess isNil ifTrue:[
	previousGroup notNil ifTrue:[
	    ^ previousGroup process
	]
    ].
    ^ myProcess

    "Modified: / 17.8.1998 / 10:21:29 / cg"
!

processPriority
    ^ processPriority
!

processPriority:anInteger
    processPriority := anInteger.
    myProcess notNil ifTrue:[
        myProcess priority:anInteger.
    ].
!

sensor
    "return the windowGroup's sensor.
     All events for any of the group's views is handled by that sensor."

    ^ mySensor

    "Modified: / 07-03-1996 / 14:30:21 / cg"
    "Modified (comment): / 27-04-2012 / 13:55:53 / cg"
!

sensor:aSensor
    <resource: #obsolete>
    "set the windowGroups sensor"

self obsoleteMethodWarning.
    mySensor := aSensor
! !

!WindowGroup methodsFor:'accessing-hooks'!

addPostEventHook:anEventProcessor
    "add another postEventHook"

    postEventHooks isNil ifTrue:[
        postEventHooks := OrderedCollection new.
    ].
    (postEventHooks includesIdentical:anEventProcessor) ifFalse:[
        postEventHooks add:anEventProcessor
    ].
!

addPreEventHook:anEventProcessor
    "add another preEventHook"

    preEventHooks isNil ifTrue:[
        preEventHooks := OrderedCollection new.
    ].
    (preEventHooks includesIdentical:anEventProcessor) ifFalse:[
        preEventHooks add:anEventProcessor
    ].
!

busyHook 
    "return the busyHook if any"

    ^ busyHook
!

busyHook:anObject 
    "set the busyHook - this one will be invoked when the event-handling action
     takes some time."

    busyHook := anObject
!

busyHookTimeout
    "return the busyHooks timeout if any"

    ^ busyHookTimeout
!

busyHookTimeout:anObject 
    "set the busyHooks timeout - the busyHook will be invoked when the event-handling action
     takes longer than this time."

    busyHookTimeout := anObject
!

postEventHook 
    "return the postEventHook if any.
     That is a backwardCompatibility leftOver - no multiple hooks are supported."

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #postEventHooks'.
    ^ postEventHook

    "Created: 7.3.1996 / 14:42:46 / cg"
!

postEventHook:anObject 
    "set the postEventHook - this one will get all events
     passed after being processed here (via #processEvent:).
     That is a backwardCompatibility leftOver - no multiple hooks are supported."

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #addPostEventHook:/removePostEventHook:'.
    postEventHook := anObject
!

postEventHooks 
    "return the postEventHooks if any"

    ^ postEventHooks
!

preEventHook 
    "return the preEventHook if any.
     That is a backwardCompatibility leftOver - no multiple hooks are supported."

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #preEventHooks'.
    ^ preEventHook

    "Created: 7.3.1996 / 14:42:42 / cg"
!

preEventHook:anObject 
    "set the preEventHook - this one will get all events
     passed before being processed here (via #processEvent:).
     If this returns true, the event is supposed to be already
     processed and ignored here.
     Otherwise, it is processed as usual.
     That is a backwardCompatibility leftOver - no multiple hooks are supported."

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #addPreEventHook:/removePreEventHook:'.
    preEventHook := anObject
!

preEventHooks 
    "return the preEventHooks if any"

    ^ preEventHooks

    "Created: 7.3.1996 / 14:42:42 / cg"
!

removePostEventHook:anEventProcessor
    "remove a postEventHook"

    postEventHooks notNil ifTrue:[
        postEventHooks removeIdentical:anEventProcessor ifAbsent:nil.
        postEventHooks := postEventHooks asNilIfEmpty.
    ].
!

removePreEventHook:anEventProcessor
    "remove a preEventHook"

    preEventHooks notNil ifTrue:[
        preEventHooks removeIdentical:anEventProcessor ifAbsent:nil.
        preEventHooks := preEventHooks asNilIfEmpty. 
    ].
!

showWaitCursorWhenBusyForMillis:millis
    "setup a busyHook, which automatically shows a waitCursor, 
     whenever some action takes longer than millis"

    self busyHookTimeout:millis.
    self 
        busyHook:[:isBusy | 
            isBusy ifTrue:[
                self showCursor:(Cursor wait).
            ] ifFalse:[    
                self restoreCursors
            ]
        ].
! !

!WindowGroup methodsFor:'accessing-views'!

addTopView:aView
    "add a topview to the group"

    topViews isNil ifTrue:[
	topViews := OrderedCollection with:aView.
    ] ifFalse:[
	(topViews includesIdentical:aView) ifFalse:[
	    topViews add:aView
	]
    ]

    "Modified: 6.3.1996 / 15:35:15 / cg"
!

addView:aView
    "add aView to the windowGroup"

    views isNil ifTrue:[
        views := OrderedCollection with:aView.
    ] ifFalse:[
        (views includesIdentical:aView) ifFalse:[
            views add:aView
        ]
    ]
!

application
    |mainView|

    (mainView := self mainView) notNil ifTrue:[
        ^ mainView application
    ].
    ^ nil
!

mainView
    "return the mainview. That's the first topView by default"

    |nonModalViews|

    topViews size == 0 ifTrue:[ ^ nil].
    nonModalViews := topViews reject:[:t | t isModal].
    nonModalViews notEmpty ifTrue:[ 
        ^ nonModalViews first
    ].
    "/ mhmh - a modal application
    ^ topViews first
!

removeView:aView
    "remove aView from the windowGroup;
     if this was the last view in this group, 
     also shut down the corresponding process 
     (actually, only wake it up here - it will terminate itself 
      when finding out that all views are gone)"

    |sema|

    focusView == aView ifTrue:[
        self setFocusView:nil
    ].

    views notNil ifTrue:[
        views removeIdentical:aView ifAbsent:nil.
        views := views asNilIfEmpty. 
    ].
    topViews notNil ifTrue:[
        topViews removeIdentical:aView ifAbsent:nil.
        topViews := topViews asNilIfEmpty. 
    ].
    "
     wakeup my process to look if last view has been
     removed (modalBoxes terminate their modalLoop if so)
    "
    mySensor notNil ifTrue:[
        (sema := mySensor eventSemaphore) notNil ifTrue:[
            sema signal
        ]
    ]

    "Modified: 1.2.1997 / 12:13:26 / cg"
!

topViews
    "return the topviews associated to this windowGroup"

    ^ topViews
!

views
    "return the views associated to this windowGroup"

    ^ views
! !

!WindowGroup methodsFor:'activation & deactivation'!

closeDownViews
    "destroy all views associated to this window group"

    topViews notNil ifTrue:[
        topViews copy do:[:aTopView | 
            aTopView notNil ifTrue:[
                aTopView destroy
            ]
        ]
    ].
    views := nil.
    topViews := nil.

    "/ keep the sensor in case there are pending incoming events;
    "/ otherwise there is a chance that we end up in a debugger in the
    "/ device's event handling (wGroup nonNil, but sensor isNil) for
    "/ the unmappedView and focusOUT events.
    mySensor flushAllEvents.
    "/ mySensor := nil.

    "Modified: / 6.5.1999 / 09:47:18 / cg"
!

hideTopViews
    "unmap all topViews associated to this windowGroup."

    topViews notNil ifTrue:[
        topViews do:[:aView |
            aView hide.
        ].
    ].
!

modalDialogFinished
    "invoked, when a modal dialog is closed"

    inModalLoop := false.
    modalGroup := nil.

    "Modified: / 13-11-2016 / 22:59:11 / cg"
!

modalDialogStarts:aModalGroup
    "invoked, when a modal dialog is opened"

    self processEvents. "/ process any bufferd message send events
    inModalLoop := true.
    modalGroup := aModalGroup.

    "Created: / 13-11-2016 / 17:18:31 / cg"
    "Modified: / 13-11-2016 / 22:58:57 / cg"
!

realizeTopViews
    "realize all topViews associated to this windowGroup."

    topViews notNil ifTrue:[
	topViews do:[:aView |
	    aView realize.
	].
    ].

    "Created: 24.7.1997 / 12:56:09 / cg"
!

restart
    "restart after a snapin.
     This re-creates the windowGroup process and informs
     my views."

    topViews notNil ifTrue:[
	"
	 need a new semaphore, since obsolete processes 
	 (from our previous live) may still sit on the current semaphore
	"
	mySensor eventSemaphore:(Semaphore new name:'WGroup eventSema').
	isModal ifFalse:[
	    self startupWith:[self restartTopViews].
	]
    ]

    "Modified: / 6.5.1999 / 09:46:08 / cg"
!

restartTopViews
    "inform all topViews associated to this windowGroup.
     about the restart."

    topViews notNil ifTrue:[
	topViews do:[:aView |
	    aView isPopUpView ifFalse:[
"/                aView realize.
		aView restarted
	    ].
	].
    ].

    "Modified: / 6.5.1999 / 09:42:37 / cg"
    "Created: / 6.5.1999 / 09:46:33 / cg"
!

shutDown
    "shutdown the window group; close all views and
     terminate the process"

    self closeDownViews.
    self shutDownProcess.
!

shutDownProcess
    "shutdown the window group process"

    |p|

    myProcess notNil ifTrue:[
        p := myProcess.
        myProcess := nil.
        p terminate.
    ]
!

startupModal:checkBlock
    "startup the window-group in a modal loop 
     (i.e. under the currently running process);
     checkBlock is evaluated and the modal loop is left, 
     whenever false is returned."

    ^ self startupModal:checkBlock forGroup:(self class activeGroup).

    "Created: / 10-12-1995 / 14:15:11 / cg"
    "Modified: / 20-08-1997 / 17:54:33 / cg"
    "Modified: / 31-01-2017 / 20:43:37 / stefan"
!

startupModal:checkBlock forGroup:mainGroup
    "startup the window-group in a modal loop 
     (i.e. under the currently running process - NOT creating a new process);
     checkBlock is evaluated and loop is left, when false is returned.
     The mainGroup info is required to allow peeking into its
     event queue in order for its expose/redraws to be handled."

    |prevActiveKeyboardGrab prevActivePointerGrab prevFocus device tops prevGroup
     oldFocusScheme returnFocus|

    "/ experimental (but seem to work fine...)
    returnFocus := false.
    oldFocusScheme := false.

    "set previousGroup to the main (non-modal) group"

    previousGroup isNil ifTrue:[
        (mainGroup ~~ self) ifTrue:[
            previousGroup := mainGroup
        ].
    ].
    prevGroup := previousGroup.
    prevGroup notNil ifTrue:[
        "/ remember current grab, in case I am opened by
        "/ a popup (such as an extendedComboBox) ...
        device := prevGroup graphicsDevice.
        prevActiveKeyboardGrab := device activeKeyboardGrab.
        prevActivePointerGrab := device activePointerGrab.
    ].
    isModal := true.

    myProcess isNil ifTrue:[
        creatingProcess := Processor activeProcess
    ].

    oldFocusScheme ifTrue:[
        previousGroup notNil ifTrue:[
            prevFocus := previousGroup focusView.
        ].
    ].

    mainGroup notNil ifTrue:[
        "/ tell the other group, that some modal dialog has started.
        mainGroup modalDialogStarts:self.
    ].
    [
        self realizeTopViews.
        self eventLoopWhile:checkBlock onLeave:[]
    ] ensure:[
        mainGroup notNil ifTrue:[
            "/ tell the other group, that some modal dialog has closed down.
            mainGroup modalDialogFinished
        ]
    ].

    returnFocus ifTrue:[
        "/ restore current grab, in case was opened by
        "/ a popup (such as an extendedComboBox) ...
        mainGroup notNil ifTrue:[
            (prevGroup isModal or:[prevGroup isPopUp]) ifTrue:[
                "
                 return the input focus to the previously active group's top.
                "
                tops := prevGroup topViews.
                tops notEmptyOrNil ifTrue:[
                    tops first getKeyboardFocus.
                ].
            ].
        ].
    ].

    oldFocusScheme ifFalse:[
        previousGroup notNil ifTrue:[ 
            prevFocus := previousGroup focusView.
        ].
    ].

    prevFocus notNil ifTrue:[ 
        previousGroup focusView requestFocus 
    ].

    prevActivePointerGrab notNil ifTrue:[ device grabPointerInView:prevActivePointerGrab ].
    prevActiveKeyboardGrab notNil ifTrue:[ device grabKeyboardInView:prevActiveKeyboardGrab ].

    "Created: / 10-12-1995 / 14:14:26 / cg"
    "Modified: / 13-11-2016 / 17:19:16 / cg"
    "Modified (format): / 14-11-2016 / 10:24:03 / cg"
!

startupWith:startupAction
    "startup the window-group;
     this creates a new window group process, which does the event processing.
     The startupAction arg is evaluated by the windowGroup process,
     before the eventLoop is entered, and is used to realize any views.
     [this is done to have the new process realize its views, instead of
      the caller - which may make a difference in case of errors and/or
      blocking operations ...]"

    |dev invokingApp|

    previousGroup := nil.

    myProcess isNil ifTrue:[
        isModal := false.

        "/
        "/ this is the windowGroup process;
        "/ realize all views, then handle events forever
        "/ (well, not really forever ... ;-)

        myProcess := [
                [
                    startupAction value.
                    self showWaitCursorWhenBusyForMillis:400.
                    self eventLoopWhile:[true] onLeave:[]
                ] ensure:[
                    |dev w app|

                    (w := self mainView) notNil ifTrue:[
                        (app := w application) notNil ifTrue:[
                            app release
                        ]
                    ].
                    dev := self graphicsDevice.
                    (dev notNil and:[views notNil]) ifTrue:[
                        dev deviceIOErrorSignal catch:[
                            "/ just in case the view did not yet have a chance to 
                            "/ shutDown properly (process killed in processMonitor)
                            self closeDownViews
                        ]
                    ]
                ]
            ] newProcess.

        self setProcessNameWithRedirectIndicator:''.
        myProcess priority:processPriority;
                  beGroupLeader;
                  beGUIProcess.

        "/
        "/ when the process gets suspended, 
        "/ there maybe still buffered draw requests.
        "/ Arrange for them to be flushed then.
        "/ (otherwise, you would not see the output of a process,
        "/  which suspends and waits - or we had to add buffer flushes
        "/  all over the place)
        "/
        myProcess 
            addSuspendAction:[ 
                |dev|

                dev := self graphicsDevice.
                dev notNil ifTrue:[dev flush].
            ].

        "/ allow for the currently active application,
        "/ to hook on new-application process creation.
        (invokingApp := self class activeMainApplication) notNil ifTrue:[
            invokingApp postApplicationProcessCreate:myProcess windowGroup:self.
        ].
        dev := invokingApp:= nil.  "/ to avoid dangling references via blocks home context.

        myProcess resume.
    ]

    "Created: / 24-07-1997 / 12:52:04 / cg"
    "Modified: / 17-09-2007 / 10:59:34 / cg"
    "Modified: / 31-01-2017 / 21:45:42 / stefan"
!

unhideTopViews
    "map all topViews associated to this windowGroup."

    |first|

    topViews notNil ifTrue:[
        first := true.
        topViews do:[:aView |
            aView map.
            first ifTrue:[
                aView activate.
                first := false.
            ].
        ].
    ].
! !

!WindowGroup methodsFor:'enumerating'!

allNonTopViewsDo:aBlock
    "evaluate aBlock for all nonTopviews (i.e. subviews) in this group.
     This enumerates a copy of the view collection, to allow for
     destroy and other collection changing operations to be performed in the loop."

    views notNil ifTrue:[
	views copy nonNilElementsDo:aBlock
    ]

    "Modified: 12.2.1997 / 12:20:25 / cg"
!

allTopViewsDo:aBlock
    "evaluate aBlock for all topviews in this group.
     This enumerates a copy of the view collection, to allow for
     destroy and other collection changing operations to be performed in the loop."

    topViews notNil ifTrue:[
	topViews copy nonNilElementsDo:aBlock
    ]

    "Modified: 12.2.1997 / 12:20:30 / cg"
!

allTopViewsExcept:aView do:aBlock
    "evaluate aBlock for all topviews except aView in this group.
     This enumerates a copy of the view collection, to allow for
     destroy and other collection changing operations to be performed in the loop."

    self allTopViewsDo:[:v |
	v ~~ aView ifTrue:[aBlock value:v]
    ].

    "Modified: 12.2.1997 / 12:22:10 / cg"
!

allViewsDo:aBlock
    "evaluate aBlock for all views & topviews in this group.
     This enumerates a copy of the view collection, to allow for
     destroy and other collection changing operations to be performed in the loop."

    self allTopViewsDo:aBlock.
    self allNonTopViewsDo:aBlock.

    "Modified: 12.2.1997 / 12:20:20 / cg"
!

partnersDo:aBlock
    "evaluate aBlock for all partnerViews.
     This enumerates a copy of the view collection, to allow for
     destroy and other collection changing operations to be performed in the loop."

    self allTopViewsDo:[:v |
        v isPartner ifTrue:[aBlock value:v].
    ].

    "Modified: 12.2.1997 / 12:21:41 / cg"
!

slavesDo:aBlock
    "evaluate aBlock for all slaveViews.
     This enumerates a copy of the view collection, to allow for
     destroy and other collection changing operations to be performed in the loop."

    self allTopViewsDo:[:v |
        v isSlave ifTrue:[aBlock value:v].
    ].

    "Modified: 12.2.1997 / 12:21:46 / cg"
! !

!WindowGroup methodsFor:'event debugging'!

traceEvents
    "return the event tracing flag"

    ^ traceEvents
!

traceEvents:trueOrFalse
    "turn event tracing on/off"

    traceEvents := trueOrFalse
! !

!WindowGroup methodsFor:'event handling'!

eventLoop
    "loop executed by windowGroup process;
     wait-for and process events forever"

   self eventLoopWhile:[true] onLeave:[]
!

eventLoopWhile:aBlock onLeave:cleanupActions
    "wait-for and process events.
     Stay in this loop while there are still any views to dispatch for,
     and aBlock evaluates to true.

     Some signals are caught & handled: 
        LeaveSignal forces an exit from the eventLoop;
        AbortOperationRequest brings us back into the loop, processing the next event;
        ActivityNotifications send a #showActivity: if nonModal, 
        otherwise they are ignored."

    |signalsToHandle|

    signalsToHandle := SignalSet
                with:LeaveSignal 
                with:ActivityNotification.

    (isModal not or:[AbortAllOperationRequest isHandled not]) ifTrue:[
        signalsToHandle add:AbortAllOperationRequest
    ].
    doNotCloseOnAbortSignal ifTrue:[
        signalsToHandle add:AbortOperationRequest
    ].

    WindowGroupQuerySignal answer:self do:[
        [
            |g s mainGroup mySema waitSema mainSema groupForSema|

            waitSema := mySema := mySensor eventSemaphore.

            isModal ifTrue:[
                mainGroup := self mainGroup.
                mainGroup == self ifTrue:[
                    mainGroup := nil
                ].
            ] ifFalse:[
                mainGroup := previousGroup
            ].

            "/ if this is an event loop for a modal loop (popup or dialog),
            "/ also make sure that we react on events coming for the mainGroup
            "/ to allow for redraw of those views.
            mainGroup notNil ifTrue:[
                mainSema := mainGroup sensor eventSemaphore.
                waitSema := SemaphoreSet with:mySema with:mainSema.

                "/ must also care for all other groups in between
                "/ (in case its a modal dialog opened from a modal dialog)
                g := previousGroup.
                g ~~ mainGroup ifTrue:[
                    groupForSema := IdentityDictionary new.
                    [g ~~ mainGroup] whileTrue:[
                        g sensor notNil ifTrue:[
                            s := g sensor eventSemaphore.
                            waitSema add:s.
                            groupForSema at:s put:g.
                        ].
                        g := g previousGroup.
                    ]
                ].
            ].

            [aBlock value] whileTrue:[ 
                (views isNil and:[topViews isNil]) ifTrue:[
                    myProcess notNil ifTrue:[
                        self shutDownProcess.
                        "not reached - there is no life after death"
                    ].
                    "
                     this is the end of a modal loop
                     (not having a private process ...)
                    "
                    ^ self
                ].

                (graphicsDevice notNil and:[graphicsDevice isOpen not]) ifTrue:[
                    self closeDownViews.
                    ^ self.
                ].

                signalsToHandle handle:[:ex |
                    |theSig|

                    theSig := ex creator.
                    (AbortAllOperationRequest accepts:theSig) ifTrue:[
                        "on AbortAllOperationRequest or AbortOperationRequest, 
                         stay in loop"
                        ex return
                    ].
                    theSig == LeaveSignal ifTrue:[
                        "/
                        "/ on leave, exit the event loop
                        "/
                        self closeDownViews.    
                        ^ self
                    ].

                    "/ ActivityNotification
                    "/
                    "/ if I am a modal-group, let it be handled
                    "/ by the outer main-groups handler (but only if there is one)
                    "/ otherwise show the activityMessage and continue.
                    "/
                    isModal ifTrue:[
                        (theSig isHandledIn:ex handlerContext sender) ifTrue:[
                            ex reject.
                            "never reached"
                        ].
                    ] ifFalse:[
                        self showActivity:ex messageText.
                    ].
                    ex proceedWith:nil.
                ] do:[
                    |gotSema mainView|

                    (mainGroup notNil or:[mySensor hasEvents not]) ifTrue:[
                        waitSema isNil ifTrue:[
                            "/ oops - how can this happen ....
                            ^ self.
                        ].
                        "/ Flush device output before going to sleep. 
                        "/ This may produce more events to arrive.
                        "/ Q: is this still needed (see suspendAction) ?
                        Error 
                            handle:[:ex |
                                (graphicsDevice notNil and:[graphicsDevice isOpen not]) ifTrue:[
                                    'WindowGroup [warning]: Error in flush - closing views' errorPrintCR.
                                    self closeDownViews.
                                    ^ self.
                                ].
                                ex reject.
                            ] 
                            do:[
                                self graphicsDevice flush.
                            ].

                        Processor activeProcess setStateTo:(self isModal ifTrue:[#modalEventWait] ifFalse:[#eventWait]) if:#active.

                        "/ now, wait for an event to arrive
                        gotSema := waitSema wait.
                    ] ifFalse:[
                        gotSema := mySema
                    ].

                    "/ some bad guy ;-) could have closed all down
                    "/ in the meanwhile ...
                    mySensor notNil ifTrue:[
                        gotSema == mySema ifTrue:[
                            "/
                            "/ an event for me 
                            "/
                            self processEventsWithModalGroup:nil
                        ] ifFalse:[
                            "/
                            "/ modal and an event for my mainGroup or one of the groups in-between
                            "/ (we arrive here after we woke up on maingroup sensor eventSemaphore)
                            "/
                            groupForSema notNil ifTrue:[
                                g := groupForSema at:gotSema ifAbsent:nil.
                                g := g ? mainGroup.
                            ] ifFalse:[
                                g := mainGroup
                            ].

                            g topViews notNil ifTrue:[
                                mainView := g topViews first
                            ].
                            mainView notNil ifTrue:[
                                "/ if anything happened to the mainGroup
                                "/ bring my own topView back to the front
                                "/ This keeps modalBoxes visible
                                "/ (not needed with X, where the windowManager does it for us)
                                (g sensor hasConfigureEventFor:mainView) ifTrue:[
                                    (topViews size ~~ 0 and:[topViews first shown]) ifTrue:[
                                        topViews first raiseDeiconified
                                    ].
                                ].
                            ].
                            g processEventsWithModalGroup:self.
                        ]
                    ]
                ].
            ].
        ] ensure:cleanupActions
    ]

    "Modified: / 06-07-2010 / 11:47:27 / cg"
    "Modified (format): / 31-01-2017 / 20:43:00 / stefan"
!

executePostEventHooksFor:anEvent
    postEventHook notNil ifTrue:[
        postEventHook processEvent:anEvent
    ].
    postEventHooks notNil ifTrue:[
        postEventHooks do:[:eachHook |
            eachHook isBlock ifTrue:[
                eachHook value:anEvent
            ] ifFalse:[
                eachHook processEvent:anEvent
            ]
        ]
    ].
!

executePreEventHooksFor:anEvent
    "return true, if the event was eaten"

    traceEvents == true ifTrue:[
        anEvent displayString infoPrintCR.
    ].

    preEventHook notNil ifTrue:[
        (preEventHook processEvent:anEvent) ifTrue:[ ^ true ].
    ].
    preEventHooks notNil ifTrue:[
        preEventHooks do:[:eachHook |
            "/ can only be nil if changed, while enumerating...
            eachHook notNil ifTrue:[
                eachHook isBlock ifTrue:[
                    (eachHook value:anEvent) ifTrue:[ ^ true ].
                ] ifFalse:[
                    (eachHook processEvent:anEvent) ifTrue:[ ^ true ].
                ]
            ]
        ]
    ].
    ^ false

    "Modified: / 28-07-2010 / 03:34:33 / cg"
!

lastEvent
    ^ LastEventQuerySignal query
!

leaveEventLoop
    "immediately leave the event loop, returning way back.
     This can be used to leave (and closedown) a modal group.
     (for normal views, this does not make sense)"

    ^ LeaveSignal raise
!

leaveModalLoop
    "if the receiver has a modal window open (i.e. is in a modalLoop),
     force him to leave it and proceed as usual.
     Be warned: this is not a regular (i.e. OK/ESCAPE) the modal box closing."

    self isInModalLoop ifTrue:[
        LeaveSignal isHandled ifTrue:[
            self process interruptWith:[LeaveSignal raise]
        ]
    ].
!

processEvents
    "process all pending events from either the damage- or user input queues.
     Abort is assumed to be handled elsewhere."

    self processEventsWithModalGroup:nil

    "Modified: 5.3.1997 / 11:33:51 / cg"
!

processEventsWithModalGroup:modalGroup
    "process all pending events from either the damage- or user input queues.
     Abort is assumed to be handled elsewhere.
     If modalGroup is non-nil, this is actually called from a modal-groups eventloop,
     in order for the underlying mainGroup (me) to handle its redraw events.
     In this case, ignore any user input events."

    <resource: #keyboard (#Escape )>

    |event ignore focus firstTop evView
     modalTops modalTop modalDelegate keyboardProcessor
     busyHookBlock busyHookCalled top evReceiver|

    self processExposeEvents.

    [
        [mySensor notNil
         and:[(event := mySensor nextEvent) notNil]] whileTrue:[
            ignore := false.
            focus := focusView.
            modalDelegate := false.
            modalTop := nil.

            modalGroup notNil ifTrue:[
                "/ an incoming event for a masterView, 
                "/ while being blocked by some other modalView.

                modalTops := modalGroup topViews.
                modalTops notEmptyOrNil ifTrue:[
                    modalTop := modalTops first.
                ].

                event isKeyEvent ifTrue:[
                    "/ forward keyboard events to my modal
                    "/ groups first topView ...
                    modalTop notNil ifTrue:[
                        focus := modalTop.
                        modalDelegate := true.
                    ].
                    modalGroup focusView notNil ifTrue:[
                        focus := modalGroup focusView
                    ].
                ] ifFalse:[
                    event isFocusEvent ifTrue:[
                        event isFocusInEvent ifTrue:[
                            "/ move focus over to modalBox
                            modalTop notNil ifTrue:[
                                modalTop getKeyboardFocus.
                                "/ focusIn is forwarded to the modalGroup
                                "/ (since keyboard is forwarded)
                                event view:modalTop.
                                focus := modalTop.
                            ]
                        ] ifFalse:[
                            "/ focusOut goes to both the modal and
                            "/ the blocked main-group
                            "/ (actually, only the very first focusOut
                            "/  is needed in the mainGroup (to turn off the cursor)
                            "/  all others are only needed in the modalGroup)

"/                            syntheticEvent := event copy.
"/                            syntheticEvent view:modalTop.
"/                            LastEventQuerySignal handle:[:ex |
"/                                ex proceedWith:syntheticEvent
"/                            ] do:[
"/                                syntheticEvent sendEventWithFocusOn:nil.
"/                            ].

                            "/ event view:modalTop.
                        ].
                        modalDelegate := true.
                    ] ifFalse:[
                        event isPointerLeaveEvent ifTrue:[
                        ] ifFalse:[
                            event isUserEvent ifTrue:[
                                ignore := true.

                                event isButtonPressEvent ifTrue:[
                                    "/ raise the modalTop and beep 
                                    event view device beep.
                                    modalTop notNil ifTrue:[ modalTop raise ].
                                ]
                            ]
                        ]
                    ]
                ].
                "/ also update the slave-sensor's modifier state from the master-sensor's
                "/ state. This is needed for a popUpView to see the correct shift-, ctrl- and alt states
                "/ in its own sensor.

                "/ cg: disabled 15-jun-2014
                "/ mhmh - something seems to have changed on a lower level,
                "/ so now the modal sensor already has the correct sensor state
                "/ (as opposed to previous versions, where this was not true).
                "/ Now, enabling the following line leads to a confirmation dialog to NOT
                "/ behave correctly w.r.t. Shift-CursorRight.
                "/ I wonder, what is responsible for that fixing side effect... (sigh)
                "/ modalGroup sensor updateModifierStatesFrom:mySensor
            ].

            ignore ifFalse:[
                (views notNil or:[topViews notNil]) ifTrue:[
                    "/ give eventRecorders, catchers etc. 
                    "/ a chance to eat or modify that event
                    modalGroup notNil ifTrue:[
                        ignore := modalGroup executePreEventHooksFor:event.
                    ] ifFalse:[
                        ignore := false
                    ].
                    ignore ifFalse:[
                        ignore := self executePreEventHooksFor:event.
                        ignore ifFalse:[
                            evView := event view.

                            (event isKeyEvent 
                            and:[(keyboardProcessor := (modalTop ? evView topView) keyboardProcessor) notNil]) ifTrue:[
                                ignore := keyboardProcessor processEvent:event forModalView:modalTop
                            ].

                            ignore ifFalse:[
                                "/ event handling below will vanish ...
                                "/ (keyboardProcessor will do it eventually)

                                event isKeyPressEvent ifTrue:[
                                    event key == #Escape ifTrue:[
                                        modalDelegate ifTrue:[
                                            top := modalTop.
                                        ] ifFalse:[
                                            (isModal and:[topViews notEmptyOrNil]) ifTrue:[
                                                top := topViews first.
                                            ]
                                        ].
                                        top notNil ifTrue:[
                                            "/ a popUpView does it himself (only closing one submenu)
                                            (top isPopUpView not
                                             or:[UserPreferences current closePopUpMenuChainOnEscape]) ifTrue:[
                                                top escapeIsCancel ifTrue:[
                                                    top closeCancel.
                                                    "/ top hideRequest. 
                                                    top realized ifFalse:[ ignore := true ].
                                                ]
                                            ]
                                        ].
                                    ]
                                ] ifFalse:[
                                    "/
                                    "/ keep track of which view has the pointer
                                    "/
                                    event isPointerEnterEvent ifTrue:[
                                        pointerView := evView
                                    ] ifFalse:[event isPointerLeaveEvent ifTrue:[
                                        pointerView := nil
                                    ]].
                                ].
                            ].
                        ].
                    ].

                    ignore ifFalse:[
                        "/
                        "/ buttonPress events turn off explicit focus, and reverts
                        "/ to implicit focus control
                        "/ This used to be done for every click -
                        "/ but behaved ugly if clicking in a scrollbar ...

                        "/ XXX: move to dispatchEvent
                        event isButtonPressEvent ifTrue:[
                            (evView wantsFocusWithButtonPress) ifTrue:[
                                "/ cannot use 'evView requestFocus' here,
                                "/ since we want to enforce it without giving the
                                "/ view a chance to circumvent this.

                                "/ evView requestFocus.
                                self focusView:evView.
                            ].
                        ].

                        (busyHook notNil and:[busyHookBlock isNil]) ifTrue:[
                            (event isKeyEvent or:[event isButtonPressEvent]) ifTrue:[
                                "/ start a timeout action - to invoke the busyHook after some time
                                busyHookCalled := false.
                                busyHookBlock := [ 
                                                    (inModalLoop ~~ true and:[busyHookCalled not]) ifTrue:[ 
                                                        busyHook value:true. 
                                                        busyHookCalled := true 
                                                    ] 
                                                 ].
                                Processor 
                                    addTimedBlock:busyHookBlock 
                                    for:Processor timeoutHandlerProcess
                                    afterMilliseconds:(busyHookTimeout ? BusyHookTime ? 150).
                            ].
                        ].
                        event isMessageSendEvent ifTrue:[
                            "/ a synthetic event (delayed message)
"/ cg: seems to not be a good idea (see modalLoopStarts):
"/ if in a modal-loop, do not process now, but repush onto the queue
"/                                modalGroup notNil ifTrue:[
"/                                    mySensor pushEvent:event
"/                                ] ifFalse:[
                                event value 
"/                                ]
                        ] ifFalse:[
                            "
                             if there is no view information in the event,
                             it must have been sent directly to the sensor.
                             Send it to the first topView.
                            "
                            (evReceiver := evView) isNil ifTrue:[
                                (firstTop := topViews first) notNil ifTrue:[
                                    event isApplicationEvent ifTrue:[
                                        evReceiver := firstTop application ? firstTop
                                    ] ifFalse:[
                                        evReceiver := firstTop.
                                    ]. 
                                ]
                            ].
                            evReceiver isNil ifTrue:[
                                ('WindowGroup [warning]: no receiver to dispatch ' , event type asString , '-event to. Ignored.') infoPrintCR.
                            ] ifFalse:[
                                evReceiver dispatchEvent:event withFocusOn:focus delegate:true
                            ].
                        ].
                    ].

                    "/ give eventRecorders, postProcessors 
                    "/ a chance to see that event
                    self executePostEventHooksFor:event
                ]
            ].
        ] "end while".
    ] on:LastEventQuerySignal do:[:ex |
        ex proceedWith:event
    ] ensure:[
        busyHookBlock notNil ifTrue:[
            Processor removeTimedBlock:busyHookBlock.
            busyHookBlock := nil.
            busyHookCalled ifTrue:[
                busyHook value:false.
                busyHookCalled := false.
            ]
        ].
    ].

    "Created: / 05-03-1997 / 11:33:11 / cg"
    "Modified: / 04-08-1998 / 18:18:55 / cg"
    "Modified: / 31-01-2017 / 16:48:45 / stefan"
!

processExposeEvents
    "process only pending expose events from the damage queue.
     This also handles resize, mapped and unmap events."

    self processExposeEventsFor:nil

    "Modified: / 3.12.1998 / 14:01:57 / cg"
!

processExposeEventsFor:aViewOrNil
    "process only pending expose events from the damage queue.
     This also handles resize, mapped and unmap events."

    |event view sensor|

    (sensor := mySensor) isNil ifTrue:[^ self].
    (sensor damageCount ~~ 0) ifTrue:[
        WindowGroupQuerySignal answer:self do:[
            [(event := sensor nextDamageEventFor:aViewOrNil) notNil] whileTrue:[
                (views notNil or:[topViews notNil]) ifTrue:[
                    view := event view.
                    (aViewOrNil isNil or:[aViewOrNil == view]) ifTrue:[
                        LastEventQuerySignal handle:[:ex |
                            ex proceedWith:event
                        ] do:[
                            (self executePreEventHooksFor:event) ifFalse:[
                                "/
                                "/ if the view is no longer shown (iconified or closed),
                                "/ this is a leftover event and ignored.
                                "/
                                "/ could this ever be a non-damage ?
                                "/
                                view notNil ifTrue:[
                                    (view shown or:[event isDamage not]) ifTrue:[
                                        view dispatchEvent:event withFocusOn:nil delegate:true. 
                                    ].
                                ].
                            ].
                            self executePostEventHooksFor:event.
                        ].
                    ]
                ]
            ]
        ]
    ]

    "Created: / 3.12.1998 / 14:01:39 / cg"
    "Modified: / 5.2.1999 / 22:26:44 / cg"
!

processRealExposeEvents
    "process only pending expose events from the damage queue
     (for any of my views).
     This only handles true expose events - leaving map, unmap etc. in the queue.
     This is required after a scroll operation,
     to wait for either a noExpose or a real expose."

    self processRealExposeEventsFor:nil
!

processRealExposeEventsFor:someViewOrNil
    "process only pending expose events from the damage queue
     (for any of my views if the arg is nil).
     This only handles true expose events - leaving map, unmap etc. in the queue.
     This is required after a scroll operation,
     to wait for either a noExpose or a real expose."

    |sensor|

    (sensor := mySensor) isNil ifTrue:[^ self].
    sensor damageCount == 0 ifTrue:[^ self].

    WindowGroupQuerySignal answer:self do:[
        |event view|

        [
            "/ event := aView nextDamage.
            event := sensor nextExposeEventFor:someViewOrNil.
            event isNil ifTrue:[^ self].

            (views notNil or:[topViews notNil]) ifTrue:[
                LastEventQuerySignal handle:[:ex |
                    ex proceedWith:event
                ] do:[
                    (self executePreEventHooksFor:event) ifFalse:[
                        view := event view.
                        "/
                        "/ if the view is no longer shown (iconified or closed),
                        "/ this is a leftover event and ignored.
                        "/
                        view shown ifTrue:[
                            view dispatchEvent:event withFocusOn:nil delegate:true. 
                        ]
                    ].
                    self executePostEventHooksFor:event.
                ]
            ]
        ] loop.
    ].

    "Created: / 02-07-1997 / 14:32:19 / cg"
    "Modified: / 05-04-1998 / 11:35:43 / cg"
    "Modified (format): / 31-01-2017 / 21:53:29 / stefan"
!

repairDamage
    "repair all damaged areas for any of my views right now."

    self processExposeEvents

!

waitForExposeFor:aView
    "wait for an expose or noExpose event for aView, then process all exposes.
     To be used after a scroll.
     This is very X-specific and not needed with other systems
     (i.e. a synthetic noExpose may be generated there)."

    mySensor waitForExposeFor:aView.
    AbortOperationRequest catch:[
        self processRealExposeEventsFor:aView
    ]

    "Modified: 6.8.1997 / 19:50:24 / cg"
! !

!WindowGroup methodsFor:'focus control'!

defaultKeyboardConsumer
    |view keyboardProcessor|

    view := self mainView.
    view notNil ifTrue:[
        keyboardProcessor := view keyboardProcessor.
        keyboardProcessor notNil ifTrue:[
            ^ keyboardProcessor componentWithInitialFocus.
        ]
    ].
    ^ nil
!

explicitFocusView
    "return the view which currently has the explicit (i.e. tabbed) focus"

    focusByTab == true ifFalse:[^ nil].
    ^ focusView
!

focusBackToPreviousFocusView
    "give focus to the view who had it before"

    previousFocusView notNil ifTrue:[
        previousFocusView isVisible ifTrue:[
            "/ self focusToView:previousFocusView
            self focusView:previousFocusView
        ]
    ]
!

focusCameByTab
    ^ focusByTab ? false
!

focusMomentaryRelease
    "release and reacquire focus.
     Use this to allow inputs fields with accept on lost focus
     to accept when a button or menu item is pressed"

    |oldFocusView|

    "/ the problem was that the #focusToView: asked for canTab
    "/ what should not be done during restore (might anser false).

    oldFocusView := self focusView.
    oldFocusView isNil ifTrue:[^ self].
    
    self focusView:nil.

    self focusView == oldFocusView ifTrue:[^ self].
    (oldFocusView shown and:[oldFocusView enabled]) ifTrue:[
        self focusView:oldFocusView.
    ].
"/    self focusToView:nil.
"/    self focusToView:oldFocusView
!

focusNext
    "give focus to next view in the focusSequence from focusView or topView
    "
    |curView oldView nxtView myTopViews|

    (myTopViews := topViews) isEmptyOrNil ifTrue:[
        self setFocusView:nil.
        ^ self
    ].

    (curView := focusView) isNil ifTrue:[
        myTopViews do:[:aView|
            (aView shown and:[(nxtView := aView focusNext) notNil]) ifTrue:[
                ^ self focusView:nxtView byTab:true
            ].
        ].
        ^ self
    ].
    (nxtView := curView focusNext) notNil ifTrue:[
        self focusView:nxtView byTab:true.
        ^ self
    ].
    self setFocusView:nil.

    [   oldView := curView.
        (curView := curView superView) notNil
    ] whileTrue:[
        curView shown ifTrue:[
            nxtView := curView focusNextChildAfter:oldView.
            nxtView notNil ifTrue:[
                ^ self focusView:nxtView byTab:true
            ].
        ].
    ].
    "/ ? should tab through the windowGroup ?
    focusView isNil ifTrue:[
        self focusNext
    ].
!

focusNextFrom:aView
    "give focus to the view after aView in the focusSequence"

    self setFocusView:aView.
    self focusNext

    "Created: / 4.8.1998 / 02:43:17 / cg"
!

focusPrevious
    "give focus to previous view in the focusSequence from focusView or topView
    "
    |curView oldView nxtView subViews done|

    (curView := focusView) isNil ifTrue:[
        topViews notNil ifTrue:[
            curView := topViews detect:[:aView|aView shown] ifNone:nil.
        ]
    ].
    curView isNil ifTrue:[^ self].

    focusView isNil ifTrue:[
        subViews := curView subviewsInFocusOrder.

        subViews size ~~ 0 ifTrue:[
            curView := subViews detectLast:[:v|v shown] ifNone:nil
        ].
        curView isNil ifTrue:[
            ^ self focusToView:nil
        ].
        done := false.

        [done not and:[(subViews := curView subviewsInFocusOrder) size ~~ 0]] whileTrue:[
            nxtView := subViews detectLast:[:v|v shown] ifNone:nil.

            nxtView notNil ifTrue:[curView := nxtView]
                          ifFalse:[done    := true].
        ].

        (curView canTab and:[curView enabled]) ifTrue:[
            ^ self focusView:curView byTab:true
        ].
        self setFocusView:curView.
    ] ifFalse:[
        nxtView := focusView.
        "/ check whether all superView's are shown

        [(nxtView := nxtView superView) notNil] whileTrue:[
            nxtView shown ifFalse:[
                curView := nxtView superView
            ]
        ].
        curView ~~ focusView ifTrue:[
            curView isNil ifTrue:[
                self setFocusView:nil.
                self focusPrevious.
            ] ifFalse:[
                self focusView:curView byTab:true
            ].
            ^ self
        ].
        self setFocusView:nil.
    ].

    [true] whileTrue:[
        oldView := curView.
        curView := curView superView.

        curView isNil ifTrue:[
            focusView notNil ifTrue:[
                ^ self
            ].
            ^ self focusPrevious
        ].

        curView shown ifTrue:[
            nxtView := curView focusPreviousChildBefore:oldView.
            nxtView notNil ifTrue:[
                ^ self focusView:nxtView byTab:true
            ].
        ].
    ].
!

focusPreviousFrom:aView
    "give focus to the view before aView in the focusSequence"

    self setFocusView:aView.
    self focusPrevious

    "Created: / 4.8.1998 / 02:43:08 / cg"
!

focusRequestFrom:aView
    "aView requests focus. I will grant it, if I have no explicit
     focusView (i.e. not tabbed)"

    |prevFocusView myDisplay|

"/    'focusRequest:' print. aView print. 

    myDisplay := self graphicsDevice.
    (myDisplay notNil and:[myDisplay activateOnClick:nil]) ifTrue:[
        prevFocusView := myDisplay focusView.
        (prevFocusView notNil 
         and:[prevFocusView windowGroup ~~ aView windowGroup]) ifTrue:[
            "/ a view from another windowGroup requests the focus.
            "/ Do not grant this, if in windows-activateOnClick mode.

"/            ' not granted' printCR.
                
            "/ check this - must be commented for windows
"/            prevFocusView getKeyboardFocus.
            ^ false
        ].
    ].

"/    ' granted' printCR.

    (focusView isNil or:[focusByTab not]) ifTrue:[
        (aView isNil or:[aView ~~ focusView]) ifTrue:[
            self focusView:aView byTab:false. "/ do not change to true - focus followsMouse will no longer work then
        ].
        ^ true
    ].
    ^ false

    "Modified: / 20.5.1999 / 18:30:31 / cg"
!

focusSequence:aSequenceableCollection
    "define the focus sequence for focusNext/focusPrevious.
     Focus is stepped in the order in which subviews occur in
     the sequence."
!

focusToView:aViewOrNil
    "give focus to aViewOrNil"

    focusView == aViewOrNil ifFalse:[
        (aViewOrNil isNil
         or:[(aViewOrNil canTab and:[aViewOrNil enabled])]
        ) ifTrue:[
            self focusView:aViewOrNil
        ]
    ].
!

focusView
    "return the view which currently has the focus"

    ^ focusView
!

focusView:aViewOrNil
    "give focus to aViewOrNil"

    self focusView:aViewOrNil byTab:false

    "
     |top v1 v2|

     top := StandardSystemView new.
     v1 := EditTextView origin:0.0@0.0 corner:1.0@0.5 in:top.
     v2 := EditTextView origin:0.0@0.5 corner:1.0@1.0 in:top.
     top open.
     top windowGroup focusView:v1.
    "

    "Modified: 31.5.1996 / 21:13:25 / cg"
!

focusView:aViewOrNil byTab:focusCameViaTabOrNil
    "give focus to aViewOrNil.
     The focusCameViaTabOrNil argument specifies if the focus came via
     tabbing or by pointer-movement/automatic or (if nil) by reassigning the topView focus
     to the windowGroup which had it before.
     If it came via tabbing, the view is notified differently, to allow
     for special highlighting (i.e. drawing a focus-border around itself).
     Also, if tabbed in, the focusFollowsMouse behavior is disabled (as we assume,
     that the user has explicitely tabbed into the view to force focus to it)"

    |prevFocusView myDisplay|
"/(aViewOrNil notNil and:[aViewOrNil shown not]) ifTrue:[
"/aViewOrNil topView shown ifTrue:[self halt].
"/].

    "/'focusToView:' print. aViewOrNil print. 
    "/' (prev: ' print.  focusView print. ')' printCR.

    myDisplay := self graphicsDevice.
    myDisplay notNil ifTrue:[
        "/
        "/ take the focus from whichEver view had it previously
        "/
        prevFocusView := myDisplay focusView.
        prevFocusView ~~ aViewOrNil ifTrue:[
            "/'take focus from ' print. prevFocusView printCR. 
            self class takeFocusFromDevice:myDisplay.
        ].
    ].

    myDisplay focusView:aViewOrNil.

    focusView == aViewOrNil ifTrue:[
        focusView notNil ifTrue:[
            "/ this is the case when the mouse-pointer reenters
            "/ into a topView which had a focusView
            "/ cg: disabled 5.jun.08
            focusCameViaTabOrNil notNil ifTrue:[
                focusByTab := focusCameViaTabOrNil "or:[focusByTab]".
            ].
            true ifTrue:[
                focusView showFocus:focusByTab.
            ].
            true ifTrue:[
                "/ 'give focus to ' print. aViewOrNil printCR. 
                self class sendKeyboardFocusEventTo:aViewOrNil withArgument:true.
            ].
        ].
        ^ self
    ].

    focusView notNil ifTrue:[
        "/ lost explicit focus
        focusView == aViewOrNil ifTrue:[
            "/'give focus to ' print. aViewOrNil printCR. 
            aViewOrNil showFocus:(focusCameViaTabOrNil ? true).
            self class sendKeyboardFocusEventTo:aViewOrNil withArgument:true.
            ^ self
        ].
    ].

    self setFocusView:aViewOrNil.
    focusView notNil ifTrue:[
        "/ got explicit focus
        aViewOrNil showFocus:(focusCameViaTabOrNil ? true).
        "/'give focus to ' print. aViewOrNil printCR. 
        self class sendKeyboardFocusEventTo:aViewOrNil withArgument:true.
        focusCameViaTabOrNil notNil ifTrue:[
            focusByTab := focusCameViaTabOrNil.
        ]
    ].

    "
     |top v1 v2|

     top := StandardSystemView new.
     v1 := EditTextView origin:0.0@0.0 corner:1.0@0.5 in:top.
     v2 := EditTextView origin:0.0@0.5 corner:1.0@1.0 in:top.
     top open.
     top windowGroup focusView:v1.
    "

    "Modified: / 20-01-2011 / 22:39:57 / cg"
!

focusViewUnmapped
    "the view which currently had the focus was unmapped"

    self focusView:nil
!

pointerView
    "return the view which currently has the pointer"

    ^ pointerView
!

setFocusView:aViewOrNil
    focusView notNil ifTrue:[
        self class sendKeyboardFocusEventTo:focusView withArgument:false
    ].
    previousFocusView := focusView.
    focusView := aViewOrNil.
    focusView notNil ifTrue:[
        self class sendKeyboardFocusEventTo:focusView withArgument:true
    ].
! !

!WindowGroup methodsFor:'initialization'!

beSynchronous
    mySensor := SynchronousWindowSensor new.
!

initialize
    "setup the windowgroup, by creating a new sensor
     and an event semaphore"

    mySensor := WindowSensor new.
    mySensor eventSemaphore:(Semaphore new name:'WGroup eventSema').
    processPriority := Processor userSchedulingPriority.
    isModal := false.
    isForModalSubview := false.
    doNotCloseOnAbortSignal := false.

    "Modified: 25.1.1997 / 00:20:19 / cg"
!

reinitialize
    "reinitialize the windowgroup after an image restart"

    "throw away old (zombie) process"
    myProcess notNil ifTrue:[
        "/ careful: the old processes exit-actions must be cleared.
        "/ otherwise, it might do destroy or other actions when it
        "/ gets finalized ...

"/        myProcess removeAllExitActions.
        myProcess removeAllSuspendActions.
        processPriority := myProcess priority. "save old priority"
        myProcess := nil.
    ].

    inWithCursorDoBlock := false.

    "throw away old events"
    mySensor notNil ifTrue:[mySensor reinitialize]

    "Modified: 13.12.1995 / 13:45:35 / stefan"
    "Modified: 12.1.1997 / 00:45:01 / cg"
!

setProcessNameWithRedirectIndicator:redirectString
    "give the windowGroup process a user friendly name.
     This name shows up in the ProcessMonitor.
     redirectString is nonEmpty, for remote display views"

    |top nm dev devNm defaultDisplay|

    "ask my topView for the processName, and
     optionally append the displayName (if its not the default)"

    topViews size ~~ 0 ifTrue:[
        top := topViews first.
        nm := top processName.

        dev := top graphicsDevice.
        defaultDisplay := Screen default.
        (dev notNil and:[dev ~~ defaultDisplay]) ifTrue:[
            devNm := dev displayName.
            (devNm notNil and:[defaultDisplay isNil or:[devNm ~= defaultDisplay displayName]]) ifTrue:[
                nm := nm , ' (' , redirectString , devNm , ')'
            ]
        ]
    ] ifFalse:[
        nm := 'window handler'.
    ].
    myProcess notNil ifTrue:[
        myProcess name:nm.
    ].
! !

!WindowGroup methodsFor:'keyboard control'!

processMnemonic:aKeyEvent
    "a  mnemonicKey event as forwarded from the keyboardProcessor - if there
     is the mnemonic-key defined for a subView, true is returned and the view
     becomes the focusView. Otherwise return false.
    "
    |topView mnemonicView|

    focusView notNil ifTrue:[
        "/ start from current focusView
        mnemonicView := focusView mnemonicViewNext:aKeyEvent.

        (mnemonicView notNil and:[true "mnemonicView canTab" and:[mnemonicView enabled]]) ifTrue:[
            self focusView:mnemonicView byTab:false.
            ^ true
        ]
    ].

    "/ start from any topview
    topViews notNil ifTrue:[
        topView := topViews detect:[:aView| aView shown ] ifNone:nil.

        topView notNil ifTrue:[
            mnemonicView := topView mnemonicViewNext:aKeyEvent.

            (mnemonicView notNil and:[true "mnemonicView canTab" and:[mnemonicView enabled]]) ifTrue:[
                self focusView:mnemonicView byTab:false.
                ^ true
            ]
        ]
    ].
    ^ false
!

processShortcut:aKeyEvent
    "a shortcut key event as forwarded from the keyboardProcessor - if there is the
     shortcut key defined, process the shortcut and return true - otherwise false."

    |topView|

    "/ start from current focusView
    (focusView notNil and:[focusView processShortcut:aKeyEvent]) ifTrue:[
        ^ true
    ].

    "/ start from any topview
    topViews notNil ifTrue:[
        topView := topViews detect:[:v| v ~~ focusView and:[v shown]] ifNone:nil.
        ^ topView notNil and:[topView processShortcut:aKeyEvent]
    ].
    ^ false
! !

!WindowGroup methodsFor:'printing & storing'!

printOn:aStream
    "return a printed representation;
     just for more user friendlyness: add name of process."

    myProcess isNil ifTrue:[
	(previousGroup notNil and:[previousGroup process notNil]) ifTrue:[
	    aStream nextPutAll:('WindowGroup(modal in ' , previousGroup process nameOrId , ')').
	    ^ self.
	].
	^ super printOn:aStream
    ].
    isModal ifTrue:[
	aStream nextPutAll:('WindowGroup(modal for ' , myProcess nameOrId , ')').
	^ self.
    ].
    aStream nextPutAll:('WindowGroup(' , myProcess nameOrId , ')')
! !

!WindowGroup methodsFor:'queries'!

anyViewHasFocus
    |focusVw|

    ^ graphicsDevice notNil
    and:[ (focusVw := graphicsDevice focusView) notNil
    and:[ focusVw windowGroup == self ]]
!

isPopUp
    "return true, if the receiver is for a popUp view"

    isModal ifFalse:[^ false].
    topViews isNil ifTrue:[^ true]. "/ a closed popup ...
    ^ topViews first isPopUpView

    "Created: / 9.7.1998 / 01:13:01 / cg"
    "Modified: / 9.7.1998 / 01:17:11 / cg"
! !

!WindowGroup methodsFor:'special'!

migrateTo:anotherDisplay
    "migrate all of my views to some other display device"

    |myDevice previouslyRealized|

    self isModal ifTrue:[
        "/ cannot migrate a modal box away from its owner ...
        "/ (need a separate process and views may not be owned)
        Transcript showCR:'Modal windogroup cannot be migrated.'.
        "/ self error:'Modal windogroup cannot be migrated.'.
        ^ self
    ].

    previouslyRealized := IdentitySet new.

    myDevice := self graphicsDevice.
    DeviceWorkstation flushCachedLastScreen.

    graphicsDevice := nil.

    "/ enumerate views - flush their device info ...
    self allTopViewsDo:[:eachTopView |
        eachTopView realized ifTrue:[
            previouslyRealized add:eachTopView
        ].
        eachTopView unmap.
    ].

    "/ destroy them - but without notifying application/views
    self allViewsDo:[:eachView |
        eachView releaseDeviceResources.
        eachView setDevice:anotherDisplay id:nil gcId:nil.
    ].

    "/ recreate them ...
    self allViewsDo:[:eachView |
        eachView recreate.
        eachView fetchDeviceResources
    ].

    "/ realize them ...
    (topViews ? previouslyRealized) do:[:eachTopView |
        (previouslyRealized includes:eachTopView) ifTrue:[
            eachTopView realize
        ].
    ].

    graphicsDevice := anotherDisplay.

    anotherDisplay sync.
    myDevice sync.


    "change the name of my process"
    self setProcessNameWithRedirectIndicator:'->'.


    "
     |anotherDisplay v host|

     v := StandardSystemView new.
     v extent:100@100.
     v addSubView:(Button label:'foo').
     v openAndWait.

     host := Dialog request:'display:' initialAnswer:'dawn:0'.
     host isNil ifTrue:[^ self].

     anotherDisplay := XWorkstation newDispatchingFor:host.
     anotherDisplay isNil ifTrue:[
         self warn:'Could not connect to remote display'.
         ^ self
     ].
     Smalltalk at:#Display2 put:anotherDisplay.

     v windowGroup migrateTo:anotherDisplay
    "

    "
     |anotherDisplay app host|

     app := NewSystemBrowser open.
     app window waitUntilVisible.

     host := Dialog request:'display:' initialAnswer:'dawn:0'.
     host isNil ifTrue:[^ self].

     anotherDisplay := XWorkstation newDispatchingFor:host.
     anotherDisplay isNil ifTrue:[
         self warn:'Could not connect to remote display'.
         ^ self
     ].
     Smalltalk at:#Display2 put:anotherDisplay.

     app windowGroup migrateTo:anotherDisplay
    "

    "
     |host anotherDisplay|

     host := Dialog request:'display:' initialAnswer:'dawn:0'.
     host isNil ifTrue:[^ self].

     anotherDisplay := XWorkstation newDispatchingFor:host.
     anotherDisplay isNil ifTrue:[
         self warn:'Could not connect to remote display'.
         ^ self
     ].
     Smalltalk at:#Display2 put:anotherDisplay.

     Transcript topView windowGroup migrateTo:anotherDisplay
    "

    "
     Transcript topView windowGroup migrateTo:Display
    "
! !

!WindowGroup methodsFor:'special-accessing'!

isForModalSubview 
    "special for windowgroup with modal subviews.
     These must be flagged specially to avoid the views being reassigned
     to the maingroup.
     This is a private interface to the SimpleView class"

    ^ isForModalSubview

    "Modified (comment): / 13-11-2016 / 17:09:18 / cg"
!

isForModalSubview:aBoolean
    "special for windowgroups with modal subviews.
     These must be flagged specially to avoid the views being reassigned
     to the maingroup.
     This is a private interface to the SimpleView class"

    isForModalSubview := aBoolean

    "Modified (comment): / 13-11-2016 / 17:09:22 / cg"
!

setModal:aBoolean
    "special entry for debugger: set the modal flag.
     Not for public use"

    isModal := aBoolean

    "Modified: 3.9.1995 / 14:51:04 / claus"
!

setPreviousGroup:aGroup
    "special entry for debugger:
     set the windowgroup that started this group (for modal groups only).
     This is not a public interface."

    self assert:(aGroup ~~ self).
    previousGroup := aGroup

    "Modified: 3.9.1995 / 14:55:40 / claus"
!

setProcess:aProcess 
    "special entry for debugger: set the windowGroups process.
     Not for public use."

    myProcess := aProcess

    "Modified: 3.9.1995 / 14:25:38 / claus"
! !

!WindowGroup methodsFor:'special-user interaction'!

restoreCursors
    "restore the original cursors in all of my views"

    |myDevice|

    myDevice := self graphicsDevice.

    self allViewsDo:[:aView |  
        |c dev id cid|

        dev := aView graphicsDevice.
        dev notNil ifTrue:[
            (id := aView id) notNil ifTrue:[
                c := aView cursor.
                c notNil ifTrue:[
                    c := c onDevice:dev.
                    (c notNil and:[(cid := c id) notNil]) ifTrue:[
                        dev setCursor:cid in:id.
                        dev ~~ myDevice ifTrue:[
                            dev flush
                        ]
                    ].
                ]
            ]
        ]
    ].
    myDevice flush

    "Modified: / 22.4.1998 / 14:28:22 / cg"
!

showActivity:someMessage
    "some activityNotification shalt be communicated to
     the user; 
     forward it to my first topView if there is one
     (that one should know how to deal with it)"

    topViews notNil ifTrue:[
	topViews first showActivity:someMessage
    ]

    "Created: 16.12.1995 / 18:39:40 / cg"
    "Modified: 23.4.1996 / 21:36:54 / cg"
!

showCursor:aCursor
    "change the cursor to aCursor in all of my views
     (This sets the cursor directly, without changing the state of the cursor instance variable;
      the reason is to allow for #restoreCursors to be able to undo this)."

    |myDevice c|

    aCursor isNil ifTrue:[^ self].

    c := aCursor.
    myDevice := self graphicsDevice.
    self allViewsDo:[:aView |  
        |cId vId dev|

        dev := aView graphicsDevice.
        (dev notNil and:[dev isOpen]) ifTrue:[
            c := c onDevice:dev.
            (cId := c id) notNil ifTrue:[
               (vId := aView id) notNil ifTrue:[
                    dev setCursor:cId in:vId.
                    dev ~~ myDevice ifTrue:[
                        dev flush
                    ]
                ]
            ].
        ].
    ].
    myDevice flush
!

withCursor:aCursor do:aBlock
    "evaluate aBlock while showing aCursor in all
     my views (used to show wait-cursor while doing something).
     Return the result as returned by aBlock."

    |oldCursors dev deviceCursor retVal|

    dev := self graphicsDevice.   
    (dev isNil or:[aCursor isNil or:[inWithCursorDoBlock == true]]) ifTrue:[
        ^ aBlock value
    ].

    deviceCursor := aCursor onDevice:dev.

    "
     get mapping of view->cursor for all of my subviews
    "
    oldCursors := IdentityDictionary new.
    [
        inWithCursorDoBlock := true.

        self allViewsDo:[:eachView |
            |old|

            old := eachView cursor.
            old ~~ deviceCursor ifTrue:[
                oldCursors at:eachView put:old.
                eachView cursor:deviceCursor now:false
            ]
        ].

        retVal := aBlock value. 

        "used to do a sync here to make the cursor visible,
         but everything is so fast nowaday, that it doesn't make a difference"
        dev flush.
    ] ensure:[
        "
         restore cursors from the mapping
        "
        oldCursors keysAndValuesDo:[:eachView :eachCursor |
            eachView cursor:eachCursor now:false.
        ].
        dev flush.
        inWithCursorDoBlock := false.
    ].
    ^ retVal

    "Modified: / 22.4.1998 / 14:36:47 / cg"
!

withExecuteCursorDo:aBlock
    "evaluate aBlock while showing a busyCursor in all
     my views (used to show busy-cursor while doing something time consuming).
     Return the result as returned by aBlock."

    ^ self withCursor:(Cursor execute) do:aBlock

    "Created: / 31.7.1998 / 20:11:52 / cg"
!

withReadCursorDo:aBlock
    "evaluate aBlock while showing a readCursor in all
     my views (used to show read-cursor while reading a file).
     Return the result as returned by aBlock."

    ^ self withCursor:(Cursor read) do:aBlock

    "Created: / 27-07-2012 / 09:43:47 / cg"
!

withWaitCursorDo:aBlock
    "evaluate aBlock while showing a waitCursor in all
     my views (used to show wait-cursor while doing something time consuming).
     Return the result as returned by aBlock."

    ^ self withCursor:(Cursor wait) do:aBlock

    "Created: 6.2.1996 / 19:51:53 / cg"
!

withWriteCursorDo:aBlock
    "evaluate aBlock while showing a writeCursor in all
     my views (used to show read-cursor while writing a file).
     Return the result as returned by aBlock."

    ^ self withCursor:(Cursor write) do:aBlock

    "Created: / 27-07-2012 / 09:44:00 / cg"
! !

!WindowGroup::WindowGroupQuery class methodsFor:'redefined answering'!

answer:something do:action
    ^ [
        WindowGroup flushCachedActiveGroup.
        super answer:something do:action
    ] ensure:[
        WindowGroup flushCachedActiveGroup
    ].

    "Modified: / 31-01-2017 / 20:28:14 / stefan"
! !

!WindowGroup class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


WindowGroup initialize!

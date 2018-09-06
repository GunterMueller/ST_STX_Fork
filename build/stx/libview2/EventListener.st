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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#EventListener
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!EventListener class methodsFor:'documentation'!

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
    abstract class for event listeners. EventListeners can be used to intercept
    incoming events (keyboard & mouse) directly from a sensor, or even
    for a complete display device.
    A concrete application is the bubble help, which tracks entering/leaving
    views, and pops up some help message. 
    See concrete code in ActiveHelp.

    For each intercepted event, a corresponding method is called for in instances
    of myself - these MUST return true, if the event is to be ignored (i.e.
    assumed to be processed and consumed by the reader, 
    and MUST return false, if the normal event procedure should be performed. 
    Since this is an abstract class,
    all of my intercept methods return false. 
    They are meant to be redefined in concrete subclasses.

    [see also:]
	WindowSensor WindowEvent WindowGroup

    [author:]
	Claus Gittinger
"
! !

!EventListener methodsFor:'event handling'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:57:54 / cg"
!

buttonMultiPress:button x:x y:y view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:57:58 / cg"
!

buttonPress:button x:x y:y view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:58:01 / cg"
!

buttonRelease:button x:x y:y view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:58:03 / cg"
!

focusInView:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false
!

focusOutView:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false
!

hasKeyboardFocus:aBoolean view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false
!

hotkeyWithId:aHotKeyId rawKey:theRawKey view: aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:57:54 / cg"
!

keyPress:key x:x y:y view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:58:08 / cg"
!

keyRelease:key x:x y:y view:aView
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:58:11 / cg"
!

mouseWheelMotion:state x:x y:y amount:amount deltaTime:dTime view:aView
    "not handled here - can be redefined in a concrete subclass"

    ^ false

    "Modified: / 23.4.1996 / 21:57:54 / cg"
    "Created: / 21.5.1999 / 13:07:13 / cg"
!

pointerEnter:state x:x y:y view:view
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:58:14 / cg"
!

pointerLeave:state view:view
    "not handled here - should be redefined in a concrete subclass"

    ^ false

    "Modified: 23.4.1996 / 21:58:17 / cg"
! !

!EventListener methodsFor:'event handling-basic'!

processEvent:ev
    "process an event; if true is returned, the event is considered to be
     'eaten' by the listener, and not passed to the view.
     If false is returned, the event is processed as usual.
     Here, the event is dispatched into one of the button*/key* etc. methods"

    "/ subclasses may do:
    "/    |eventHasBeenProcessed|
    "/
    "/    eventHasBeenProcessed := false.
    "/    Error handle:[:ex |
    "/        ('Listener [info]: error while processing event: ' , ex description) infoPrintCR.
    "/    ] do:[
    "/        eventHasBeenProcessed := ev dispatchWithViewArgumentTo:self
    "/    ].
    "/    ^ eventHasBeenProcessed

    ^ false

    "Modified: / 29-06-2011 / 19:13:18 / cg"
! !

!EventListener methodsFor:'events-window creation'!

postCreateView:aView
    "a synthetic event:
     some view was created"

    ^ self

    "Modified: / 29-06-2011 / 18:55:53 / cg"
!

preCreateView:aView
    "a synthetic event:
     some view is about to be created;
     gives me a chance to intercept and change size, origin, color, etc."

    ^ self

    "Modified: / 29-06-2011 / 18:54:19 / cg"
!

preCreateView:aView origin:org
    "Obsolete now - the system will now send a preCreateView: event (without origin arg).
     not really an event:
     invoked right before a view is about to be physically created.
     May return a new origin."

    ^ org

    "Modified: / 29-06-2011 / 18:55:23 / cg"
! !

!EventListener methodsFor:'listen'!

listen
    "install myself as listener"

    WindowSensor addEventListener:self

    "
     |listener|

     listener := EventListener new.
     listener listen.
     (Delay forSeconds:20) wait.
     listener unlisten
    "
!

unlisten
    "uninstall myself as listener"

    WindowSensor removeEventListener:self 
! !

!EventListener class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !


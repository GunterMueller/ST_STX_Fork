"
 COPYRIGHT (c) 1990 by Claus Gittinger
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

SimpleView subclass:#InputView
	instanceVariableNames:'eventReceiver'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Special'
!

!InputView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    a view for input only - forwarding all events to another object.
    This kind of view can be used to be laid on top of another view to catch all
    input. (Interface builder)
    NOTICE: the event forwarding is a leftover from times when not delegation mechanism
            existed - it will vanish - use delegates for new code.

    [author:]
        Claus Gittinger
"
! !

!InputView methodsFor:'accessing'!

eventReceiver:aView
    "set the view to which input events are forwarded"

    eventReceiver := aView
!

isInputOnly
    "return true, since this is a transparent input-only view"

    ^ true

    "Created: 1.6.1996 / 13:22:31 / cg"
! !

!InputView methodsFor:'drag & drop'!

canDrop:aDropContext 
    "return true, if aCollectionOfDropObjects can be dropped here.
     Delegated to my eventReceiving view"

    ^ eventReceiver notNil
      and:[ eventReceiver canDrop:aDropContext ]

    "Created: / 13-10-2006 / 12:35:07 / cg"
    "Modified: / 13-10-2006 / 16:02:45 / cg"
!

canDrop:aDropContext at:aPoint
    "return true, if aCollectionOfDropObjects can be dropped here.
     Delegated to my eventReceiving view"

    ^ eventReceiver notNil
      and:[ eventReceiver canDrop:aDropContext at:aPoint ]

    "Created: / 13-10-2006 / 12:35:07 / cg"
    "Modified: / 13-10-2006 / 16:02:37 / cg"
!

canDropObjects:aCollectionOfDropObjects
    "return true, if aCollectionOfDropObjects can be dropped here.
     Delegated to my eventReceiving view"

    ^ eventReceiver notNil 
      and:[ eventReceiver canDropObjects:aCollectionOfDropObjects ]

    "Created: / 13-10-2006 / 16:01:58 / cg"
!

canDropObjects:aCollectionOfDropObjects at:aPoint
    "return true, if aCollectionOfDropObjects can be dropped here.
     Delegated to my eventReceiving view"

    ^ eventReceiver notNil 
      and:[ eventReceiver canDropObjects:aCollectionOfDropObjects at:aPoint]

    "Created: / 13-10-2006 / 16:02:13 / cg"
!

drop:aDropContext
    "drop aCollectionOfDropObjects here.
     Delegated to my eventReceiving view"

    eventReceiver drop:aDropContext

    "Modified: / 13-10-2006 / 16:03:32 / cg"
!

drop:aDropContext at:aPoint
    "drop aCollectionOfDropObjects here.
     Delegated to my eventReceiving view"

    eventReceiver drop:aDropContext at:aPoint

    "Modified: / 13-10-2006 / 16:03:27 / cg"
!

dropObjects:aCollectionOfDropObjects
    "drop aCollectionOfDropObjects here.
     Delegated to my eventReceiving view"

    eventReceiver dropObjects:aCollectionOfDropObjects

    "Created: / 13-10-2006 / 16:03:05 / cg"
!

dropObjects:aCollectionOfDropObjects at:aPoint
    "drop aCollectionOfDropObjects here.
     Delegated to my eventReceiving view"

    eventReceiver dropObjects:aCollectionOfDropObjects at:aPoint

    "Created: / 13-10-2006 / 16:03:12 / cg"
! !

!InputView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver buttonMotion:state x:x y:y
    ] ifFalse:[
        super buttonMotion:state x:x y:y
    ]
!

buttonPress:button x:x y:y
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver buttonPress:button x:x y:y
    ] ifFalse:[
        super buttonPress:button x:x y:y
    ]
!

buttonRelease:button x:x y:y
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver buttonRelease:button x:x y:y
    ] ifFalse:[
        super buttonRelease:button x:x y:y
    ]
!

exposeX:x y:y width:w height:h
    "dummy - will never be received"

    ^ self
!

focusIn
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver focusIn
    ]
!

focusOut
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver focusOut
    ]
!

keyPress:key x:x y:y
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver keyPress:key x:x y:y
    ] ifFalse:[
        super keyPress:key x:x y:y
    ]
!

keyRelease:key x:x y:y
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver keyRelease:key x:x y:y
    ] ifFalse:[
        super keyRelease:key x:x y:y
    ]
!

pointerEnter:state x:x y:y
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver pointerEnter:state x:x y:y
    ]
!

pointerLeave:state
    "redefined to forward the event to my eventReceiver"

    eventReceiver notNil ifTrue:[
        eventReceiver pointerLeave:state
    ]
! !

!InputView methodsFor:'initialization'!

initialize
    super initialize.
    self borderWidth:0
! !

!InputView methodsFor:'redefined dummy'!

setViewBackground
    "dummy - inputviews have no background"

    ^ self
! !

!InputView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


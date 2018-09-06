"
 COPYRIGHT (c) 1998 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

Object subclass:#DropTarget
	instanceVariableNames:'receiver enterSelector leaveSelector overSelector dropSelector
		canDropSelector argument oldDropAPI'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DropTarget class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG / Claus Gittinger
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
    this class keeps the current target of the drop operation; the object respoonsible
    for the widget under the current mouse position.

    receiver        <Object>        receiver to which the requests are sent. 
                                    The widget or an application.

    argument        <Object>        user defined argument

    enterSelector   <Symbol>        send the first time to the drop target when entering
                                    the widget.

    leaveSelector   <Symbol>        send the last time to the drop target when leaving
                                    the widget.

    overSelector    <Symbol>        send all the time to the drop target when moveing the
                                    mouse over the widget.

    dropSelector    <Symbol>        send to the drop target to drop the collection of
                                    objects.

    canDropSelector <Symbol>        send to the drop target to ask if the context could
                                    be dropped.

    [see also:]
        DragAndDropManager
        DropSource
        DropContext

    [author:]
        Claus Atzkern
"
! !

!DropTarget class methodsFor:'instance creation'!

receiver:aReceiver
    ^ self new receiver:aReceiver
!

receiver:aReceiver argument:anArgument 
    ^ self new receiver:aReceiver argument:anArgument.

    "Modified: / 13-10-2006 / 18:19:53 / cg"
!

receiver:aReceiver argument:anArgument dropSelector:aSelector 
    ^ self new 
        receiver:aReceiver
        argument:anArgument
        dropSelector:aSelector
        canDropSelector:nil

    "Modified: / 13-10-2006 / 17:50:12 / cg"
!

receiver:aReceiver argument:anArgument dropSelector:s1 canDropSelector:s2 
    ^ self new 
        receiver:aReceiver
        argument:anArgument
        dropSelector:s1
        canDropSelector:s2

    "Modified: / 13-10-2006 / 18:19:58 / cg"
! !

!DropTarget methodsFor:'accessing'!

argument
    "returns the user defined argument; this argument is used for a drop action
     with two arguments, the context and the argument"

    ^ argument
!

argument:something
    "set the user defined argument; this argument is used for a drop action
     with two arguments, the context and the argument"

    argument := something.
!

canDropSelector
    "selector called to get a feedback if context is droppable.
     the arguments to the selector are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"
    
    ^ canDropSelector
!

canDropSelector:something 
    "selector called to get a feedback if context is droppable.
     the arguments to the selector are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"
    
    canDropSelector := something.
!

dropSelector
    "return the selector of the message which is sent to the drop target 
     when the objects are to be dropped (i.e. when the mouse button is released).

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"

    ^ dropSelector
!

dropSelector:something
    "specify the selector of the message which is sent to the drop target 
     when the objects are to be dropped (i.e. when the mouse button is released).

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"

    dropSelector := something.
!

enterSelector
    "return the selector of the message which is sent to the drop target 
     when entering the widget for the first time.

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument
    "
    ^ enterSelector
!

enterSelector:something
    "specify the selector of the message which is sent to the drop target 
     when entering the widget for the first time.

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"

    enterSelector := something.
!

leaveSelector
    "return the selector of the message which is sent to the drop target 
     when leaving the widget.

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"

    ^ leaveSelector
!

leaveSelector:something
    "specify the selector of the message which is sent to the drop target 
     when leaving the widget.

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"

    leaveSelector := something.
!

oldDropAPI:something
    oldDropAPI := something.
!

overSelector
    "send all the time to the drop target when moveing the mouse over the widget

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"
    
    ^ overSelector
!

overSelector:something
    "specify the selector of the message which is sent to the drop target 
     when the mouse is moved over the widget.

     Depending on the number of arguments of the selector,
     the arguments of the message are:
        0       nothing
        1       aDropContext
        2       aDropContext and the argument"

    overSelector := something.
!

receiver
    "returns the receiver to which the requests are sent: a widget or an application."

    ^ receiver
!

receiver:something
    "define the receiver to which the requests are sent. 
     The argument is a widget or an application."

    receiver := something.
! !

!DropTarget methodsFor:'actions'!

drop:aDropContext
    "sent, when the mouse button is released within the current widget."

    oldDropAPI == true ifTrue:[
        receiver perform:dropSelector with:(aDropContext dropObjects) with:(aDropContext targetPoint)
    ] ifFalse:[
        receiver perform:dropSelector withOptionalArgument:aDropContext and:argument
    ]

    "Modified: / 13-10-2006 / 18:21:26 / cg"
!

enter:aContext
    "sent, when entering a widget."

    enterSelector notNil ifTrue:[
        receiver perform:enterSelector withOptionalArgument:aContext and:argument
    ]

    "Modified: / 13-10-2006 / 18:14:33 / cg"
!

leave:aContext
    "sent, when leaving a widget."

    leaveSelector notNil ifTrue:[
        receiver perform:leaveSelector withOptionalArgument:aContext and:argument
    ]

    "Modified: / 13-10-2006 / 18:14:43 / cg"
!

over:aContext
    "sent, whenever the mouse is moved over the widget."

    overSelector notNil ifTrue:[
        receiver perform:overSelector withOptionalArgument:aContext and:argument
    ]

    "Modified: / 13-10-2006 / 18:14:53 / cg"
! !

!DropTarget methodsFor:'instance creation'!

receiver:aReceiver argument:anArgument
    "set the receiver and a user defined argument"

    receiver := aReceiver.
    argument := anArgument.
!

receiver:aReceiver argument:anArgument dropSelector:s1 canDropSelector:s2
    "set the receiver and a user defined argument"

    receiver        := aReceiver.
    argument        := anArgument.
    dropSelector    := s1.
    canDropSelector := s2.
! !

!DropTarget methodsFor:'private'!

receiverPerform:aSelector withContext:aContext
    "let the receiver perform the selector"

    aSelector notNil ifTrue:[
        ^ receiver perform:aSelector withOptionalArgument:aContext and:argument
    ]
! !

!DropTarget methodsFor:'queries'!

canDrop:aDropContext
    "send to the receiver to ask if the context is droppable"

    canDropSelector notNil ifTrue:[
        ^ receiver perform:canDropSelector withOptionalArgument:aDropContext and:argument
    ].
    ^ true

    "Modified: / 13-10-2006 / 18:13:34 / cg"
! !

!DropTarget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DropTarget.st,v 1.8 2007-07-03 13:18:40 sr Exp $'
! !

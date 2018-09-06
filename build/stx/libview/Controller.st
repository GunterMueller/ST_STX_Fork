"
 COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

Object subclass:#Controller
	instanceVariableNames:'model view'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!Controller class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Controllers can be used to controll the user-interactions
    to a model which is shown in a view.

    For very simple views (and due to the evolution of Smalltalk/X),
    many view-classes have the controller function integrated.

    To allow both controller and non-controller operation, events are
    sent directly to the view, if the view has no controller
    (i.e. if its controller instance variable is nil).
    Otherwise, the controller gets the event message.

    For now (vsn 2.10.4) there are only a few view classes using controllers;
    however, over time, more will be converted, since separating the controller
    offers much more flexibility
    (although view initialization becomes a bit more complex).

    Over time, expect the buttonPress/Release/Motion and keyPress/Release
    methods to vanish from the view classes and corresponding controllers to
    be appearing.
    This migration should be backward compatible.

    Device coordinates vs. Logical coordinates:
	if the view has a non-identity transformation (for example: drawing
	in millimeters or inches), the application/controller may or may not
	be interested in device coordinates in button/key events.
	Most are not, these will receive logical coordinates transparently
	in theyr button/key-Press/Release/Motion methods.
	Those which are interested should redefine the corresponding
	device-Key/Button-Press/Release/Motion methods.
	Of course, it is always possible to map between device and logical
	coordinates, using `view transformation applyTo/applyInverseTo:',
	if both coordinates are required (which is unlikely).

    [Instance variables:]
	view        <View>               the view I control

	model       <Model>              the model which is to be worked on


    [author:]
	Claus Gittinger

    [see also:]
	View Model WindowGroup
	WindowEvent DeviceWorkstation
"
! !

!Controller class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Controller methodsFor:'Compatibility-ST80'!

blueButtonActivity
    "actually, this should be called 'rightButtonActivity'.
     But for ST-80 compatibility ...."

    ^ self
!

controlInitialize
    ^ self
!

open
    "open my view"

    view open
!

poll
    "ST-80 compatibility - ignored here"

    "Created: 6.3.1997 / 15:29:45 / cg"
!

redButtonActivity
    "actually, this should be called 'leftButtonActivity'.
     But for ST-80 compatibility ...."

    ^ self
!

yellowButtonActivity
    "actually, this should be called 'middleButtonActivity'.
     But for ST-80 compatibility ...."

    |menu actionSelector menuPerformer prevReceiver|

    "
     ST/X style static menus - going to be obsoleted ...
    "
    (menu := view middleButtonMenu) notNil ifTrue:[
	menu showAtPointer.
	^ self
    ].

    menu := self yellowButtonMenu.
    menu notNil ifTrue:[
	menuPerformer := self menuPerformer.

	"
	 a temporary kludge:
	     pass myself as receiver, the menuPerformer as performer;
	     the menu will send its messages to either the
	     menuPerformer or me (its receiver).
	     This allows for the ST-80 behavior, where some messages
	     go to the model, others to the view
	     (copy/cut/paste).
	"
	(prevReceiver := menu receiver) isNil ifTrue:[
"/                menu receiver:menuPerformer.
	    menu menuPerformer:menuPerformer.
	    menu receiver:self.
	].

	"
	 Launch the menu. It is supposed
	 to return an actionSelector.
	"
	actionSelector := view startUpMenu:menu.

	actionSelector notNil notNil ifTrue:[
	    actionSelector isSymbol ifTrue:[
		menuPerformer perform:actionSelector
	    ] ifFalse:[
		(actionSelector isArray
		and:[actionSelector size == 2
		and:[(actionSelector at:1) isSymbol]]) ifTrue:[
		    menuPerformer
			perform:(actionSelector at:1)
			with:(actionSelector at:2)
		]
	    ]
	].

	menu receiver:prevReceiver.

	^ self
    ].

    "Modified: 21.1.1997 / 15:45:48 / cg"
! !

!Controller methodsFor:'accessing'!

menuHolder
    "by default, the model has to provide the menu"

    model isNil ifTrue:[
	^ view menuHolder
    ].
    ^ model

    "Modified: 22.8.1996 / 09:11:43 / cg"
!

menuPerformer
    "by default, the model is performing menu actions"

    model isNil ifTrue:[^ view].
    ^ model
!

model
    "return my model"

    ^ model
!

model:aModel
    "set my model"

    model := aModel.

    "Modified: 28.2.1997 / 19:52:50 / cg"
!

sensor
    "return my views sensor"

    ^ view sensor
!

view
    "return my view"

    ^ view
!

view:aView
    "set my view"

    view := aView.

    "Modified: 6.3.1997 / 15:31:48 / cg"
! !

!Controller methodsFor:'event handling'!

buttonMotion:buttonMask x:x y:y
    "mouse was moved with button pressed in my view; nothing done here"

    ^ self
!

buttonMultiPress:button x:x y:y
    "a mouse button was pressed again shortly after in my view"

    ^ self buttonPress:button x:x y:y
!

buttonPress:button x:x y:y
    "a mouse button was pressed in my view.
     Translate buttonPress events into similar ST-80 type
     event messages. This method and/or these ST-80 methods
     can be redefined in subclasses"

    (button == 1) ifTrue:[
        self redButtonActivity    "/ select button
    ].
    (button == 2) ifTrue:[
        self yellowButtonActivity "/ menu button
    ].
    (button == 3) ifTrue:[
        self blueButtonActivity   "/ window frame button
    ]
!

buttonRelease:button x:x y:y
    "a mouse button was released in my view; nothing done here"

    ^ self
!

deviceButtonMotion:state x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonMotion with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonMotion:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self buttonMotion:state x:lx y:ly

    "Modified: 13.5.1996 / 11:24:11 / cg"
    "Modified: 14.10.1996 / 22:23:56 / stefan"
!

deviceButtonMultiPress:button x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonMultiPress with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonMultiPress:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self buttonMultiPress:button x:lx y:ly

    "Modified: 13.5.1996 / 11:23:54 / cg"
    "Modified: 14.10.1996 / 22:24:06 / stefan"
!

deviceButtonPress:button x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonPress with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonPress:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self buttonPress:button x:lx y:ly

    "Modified: 13.5.1996 / 11:24:23 / cg"
    "Modified: 14.10.1996 / 22:24:17 / stefan"
!

deviceButtonRelease:button x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a buttonRelease with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #buttonRelease:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self buttonRelease:button x:lx y:ly

    "Modified: 13.5.1996 / 11:24:33 / cg"
    "Modified: 14.10.1996 / 22:24:28 / stefan"
!

deviceKeyPress:key x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a keyPress with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #keyPress:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self keyPress:key x:lx y:ly

    "Modified: 13.5.1996 / 11:24:43 / cg"
    "Modified: 14.10.1996 / 22:24:36 / stefan"
!

deviceKeyRelease:key x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a keyRelease with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #keyRelease:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self keyRelease:key x:lx y:ly

    "Modified: 13.5.1996 / 11:24:51 / cg"
    "Modified: 14.10.1996 / 22:24:46 / stefan"
!

devicePointerEnter:state x:x y:y
    "this is the low-level (untransformed) event as received
     from the device (i.e. coordinates are in device coordinates).
     If there is a transformation, apply the inverse
     and send a pointerEnter with the logical coordinates.

     Controllers which are interested in deviceCoordinates should
     redefine this method -
     those which are interested in logical coordinates
     should redefine #pointerEnter:x:y:"

    |lx ly trans|

    lx := x.
    ly := y.
    (trans := view transformation) notNil ifTrue:[
	lx := trans applyInverseToX:lx.
	ly := trans applyInverseToY:ly.
    ].
    self pointerEnter:state x:lx y:ly

    "Modified: 13.5.1996 / 11:24:59 / cg"
    "Modified: 14.10.1996 / 22:24:54 / stefan"
!

focusIn
    "my view got the keyboard focus; nothing done here"

    ^ self
!

focusOut
    "my view lost keyboard focus; nothing done here"

    ^ self
!

keyPress:key x:x y:y
    "key was pressed in my view; nothing done here,
     except for Tab keys."

    <resource: #keyboard (#Tab #FocusNext #FocusPrevious)>

    |windowGroup action|

    windowGroup := view windowGroup.
    windowGroup notNil ifTrue:[
	action := key.
	key == #Tab ifTrue:[
	    (view tabRequiresControl not
	    or:[ view sensor ctrlDown ]) ifTrue:[
		view graphicsDevice shiftDown ifTrue:[
		    action := #FocusPrevious.
		] ifFalse:[
		    action := #FocusNext.
		]
	    ]
	].
	action == #FocusNext ifTrue:[
	    windowGroup focusNext.
	].
	action == #FocusPrevious ifTrue:[
	    windowGroup focusPrevious.
	].
    ].
    ^ self

    "Modified: 28.5.1996 / 20:21:41 / cg"
!

keyRelease:key x:x y:y
    "key was released in my view; nothing done here"

    ^ self
!

mouseWheelMotion:event x:x y:y amount:amount deltaTime:deltaTime
    "a mouse wheel was turned - nothing done here"

    ^ self.
!

pointerEnter:state x:x y:y
    "mouse pointer entered my view; nothing done here"

    ^ self
!

pointerLeave:state
    "mouse pointer left my view; nothing done here"

    ^ self
! !

!Controller methodsFor:'initialization & release'!

initialize
    "initialize the controller; subclasses should redefine
     this and include a super initialize for proper initialization."

    ^ self
!

release
    "close down the controller; this is sent when the view is destroyed.
     Can be redefined in subclasses to do some cleanup action. However,
     these redefined methods should do a super release."

    view notNil ifTrue:[view controller:nil].
    view := nil.
    model := nil.
    super release.

    "Modified: 11.6.1997 / 13:18:09 / cg"
!

startUp
    "startup the controller; this is sent when the view realizes,
     right before it becomes visible.
     Can be redefined in subclasses to do some startup action."

    self controlInitialize.
! !

!Controller methodsFor:'menus'!

yellowButtonMenu
    "actually, this should be called 'middleButtonMenu'.
     But for ST-80 compatibility ...."

    |sym menuHolder m|

    menuHolder := self menuHolder.

    "
     try ST-80 style menus first:
     if there is a model, and a menuMessage is defined,
     ask model for the menu and launch that if non-nil.
    "
    (menuHolder notNil
    and:[(sym := view menuMessage) notNil
    and:[sym isSymbol]]) ifTrue:[
	"
	 ask menuHolder (model) for the menu
	"
	(menuHolder respondsTo:sym) ifTrue:[
	    ^ menuHolder perform:sym.
	]
    ].
    ^ nil

    "Modified: 14.9.1996 / 13:19:34 / cg"
! !

!Controller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/Controller.st,v 1.57 2009-09-15 19:01:57 cg Exp $'
! !

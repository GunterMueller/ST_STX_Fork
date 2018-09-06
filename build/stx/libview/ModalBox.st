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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

StandardSystemView subclass:#ModalBox
	instanceVariableNames:'shadowView exclusiveKeyboard escapeIsCancel'
	classVariableNames:'UseTransientViews DefaultExtent'
	poolDictionaries:''
	category:'Views-Basic'
!

!ModalBox class methodsFor:'documentation'!

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
    this class implements modal boxes; ModalBoxes are different from
    others, in that they take control over the current topview, until
    all processing is done (i.e. the currently active topview and all of
    its subviews will not handle user events while the box is active).

    ModalBoxes are either implemented as transient windows
    (if UseTransientViews := true) or as override redirect views.
    Some window managers have problems with either; so you may want to
    change the default setting from your display.rc file.

    [see also:]
	StandardSystemView
	DialogBox
	( introduction to view programming :html: programming/viewintro.html )

    [author:]
	Claus Gittinger
"
! !

!ModalBox class methodsFor:'initialization'!

initialize
    UseTransientViews := true.

    "
     UseTransientViews := false
    "

    "Modified: 24.7.1997 / 15:18:59 / cg"
! !

!ModalBox class methodsFor:'defaults'!

defaultExtent
    "this defines the defaultExtent for instances of me;
     the value returned here is usually not correct for concrete subclasses,
     so you better redefine this method.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    DefaultExtent notNil ifTrue:[
	^ DefaultExtent
    ].
    ^ (Screen current pixelPerMillimeter * (60 @ 20)) rounded

    "Modified: / 27.7.1998 / 20:15:15 / cg"
!

defaultLabel
    "return the boxes default window title."

    ^ 'PopUp'

    "Created: 23.4.1996 / 17:14:21 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'modalBox.defaultExtent')>

    DefaultExtent := StyleSheet at:'modalBox.defaultExtent' default:nil.

    "
     self updateStyleCache
    "

    "Modified: 31.8.1995 / 03:01:14 / claus"
    "Created: 15.8.1997 / 01:40:53 / cg"
    "Modified: 20.10.1997 / 15:07:37 / cg"
!

useTransientViews:aBoolean
    "change the way modalBoxes are created on the Display.
     If the argument is true, transient views are used;
     otherwise override redirect views are used.
     Depending on your windowmanager, either one may have problems.
     You may want to change the setting
     from your display.rc or d_xxx.rc file.
     This is now obsolete - transient views work and are always used."

    UseTransientViews := aBoolean.

    "
     ModalBox useTransientViews:false
     ModalBox useTransientViews:true
    "

    "Modified: 28.2.1997 / 22:27:46 / cg"
! !

!ModalBox methodsFor:'accessing'!

escapeIsCancel
    "return the escapeIsCancel setting - defaults to true for modalMox here."

    ^ escapeIsCancel
!

exclusiveKeyboard:aBoolean
    "set/clear exclusive locking of the keyboard;
     If set, the box will take total control over the
     keyboard, not allowing input to other views/boxes
     while active.
     DANGER:
	only use this for very very urgent boxes, since
	no interaction with ANY view on the screen is possible then."

    exclusiveKeyboard := aBoolean

    "Modified: 12.5.1996 / 21:55:09 / cg"
! !

!ModalBox methodsFor:'event handling'!

coveredBy:aView
    "the receiver has been covered by another view.
     If the other view is a non-modal one, raise"

    |mainGroup topViews|

    "
     if the other view is not a modal- (or shadow-, or popup-) -view,
     bring myself to the front again.
    "
    aView isPopUpView ifFalse:[
	"
	 if I have a mainGroup,
	 only raise if its one of my maingroup-views
	"
	windowGroup notNil ifTrue:[
	    mainGroup := windowGroup mainGroup.
	    mainGroup notNil ifTrue:[
		topViews := mainGroup topViews.
		topViews notNil ifTrue:[
		    topViews do:[:eachTopView |
			aView == eachTopView ifTrue:[
			    self raise.
			    ^ self
			]
		    ]
		].
		^ self
	    ]
	].
	self raise
    ]
!

terminate
    "this is the close from a windowmanager
     (only if UseTransientViews == true)"

    "
     if I am a dialog, make the receiver invisible and leave control.
     But, do not destroy the underlying view resources, to allow for
     another open/show to occur later.
     if I have been opened modeLess, perform the normal destroy operation.
    "
    (windowGroup isNil or:[windowGroup isModal]) ifTrue:[
	self hide
    ] ifFalse:[
	super terminate
    ]
!

visibilityChange:how
    "raise when covered - this should not be needed, since we
     have been created as override-redirect window (which should
     stay on top - but some window managers (fvwm) seem to ignore
     this ..."

    "the code below is not good, since it will lead to
     oscillating raises when two modalBoxes are going to cover
     each other - see coveredBy:-handling ..."

"/    how ~~ #fullyVisible ifTrue:[
"/        self raise
"/    ]

     super visibilityChange:how.
!

xxxpointerEnter:state x:x y:y
    "mhmh: this seems to be a special X kludge;
     without the following, we will not regain input focus after
     pointer is reentered."

"/
"/ experimental: disabled; bad behavior with some windowManagers,
"/ if enter/leave events are processed late.
"/
    self getKeyboardFocus.
    super pointerEnter:state x:x y:y

    "Created: / 8.12.1997 / 19:18:45 / cg"
    "Modified: / 8.12.1997 / 19:19:39 / cg"
! !

!ModalBox methodsFor:'initialization & release'!

addToCurrentProject
    "ignored here"

    ^ self
!

create
    super create.
    shadowView notNil ifTrue:[
	self saveUnder:true
    ]
!

destroy
    "destroy the view.
     redefined to also destroy my shadow, if there is one,
     and to release the global keyboard grab (if there is one)"

    shadowView notNil ifTrue:[
	shadowView destroy.
	shadowView := nil
    ].
    exclusiveKeyboard ifTrue:[
	self forceUngrabKeyboard
    ].
    super destroy.

    "Modified: 12.5.1996 / 21:56:10 / cg"
!

initEvents
    "initialize event handling; redefined to enable visibility changes"

    super initEvents.
    self enableEvent:#visibilityChange.
    escapeIsCancel := true.

    "Modified: 12.5.1996 / 21:56:31 / cg"
!

initStyle
    "setup viewStyle specifics"

    |style|

    super initStyle.
    style := styleSheet name.
    ((style ~~ #normal) and:[style ~~ #mswindows]) ifTrue:[
	self borderWidth:0.
	UseTransientViews ifFalse:[
	    self level:2
	]
    ]

    "Modified: 22.1.1997 / 11:57:35 / cg"
!

initialize
    |form resizeButton moveButton|

    super initialize.

    "/ self beDialogView.
    self beToolDialog.

    exclusiveKeyboard := false.
"/    label := ' '.

"/    label := 'Popup'.

    UseTransientViews ifFalse:[
        (PopUpView shadowsOnDevice:device) ifTrue:[
            shadowView := (ShadowView onDevice:device) for:self
        ].

        form := Form width:8 height:8
                     fromArray:#[2r00000000
                                 2r00000000
                                 2r00000000
                                 2r00000001
                                 2r00000011
                                 2r00000111
                                 2r00001111
                                 2r00011111
                                ]
                     onDevice:device.
        resizeButton := Button label:form in:self.
        resizeButton origin:1.0 @ 1.0 corner:1.0@1.0.
        resizeButton activeForegroundColor:(resizeButton foregroundColor).
        resizeButton activeBackgroundColor:(resizeButton backgroundColor).
        resizeButton enteredBackgroundColor:(resizeButton backgroundColor).
        resizeButton leftInset:-8; topInset:-8.
        resizeButton releaseAction:[].
        resizeButton pressAction:[resizeButton turnOff; redraw. self doResize].
        resizeButton borderWidth:0.
        resizeButton activeLevel:0; passiveLevel:0.
        resizeButton cursor:(Cursor corner).

        form := Form width:8 height:8
                     fromArray:#[2r11111000
                                 2r11110000
                                 2r11100000
                                 2r11000000
                                 2r10000000
                                 2r00000000
                                 2r00000000
                                 2r00000000
                                ]
                     onDevice:device.
        moveButton := Button label:form in:self.
        moveButton origin:0.0 @ 0.0 corner:0.0@0.0.
        moveButton activeForegroundColor:(moveButton foregroundColor).
        moveButton activeBackgroundColor:(moveButton backgroundColor).
        moveButton enteredBackgroundColor:(moveButton backgroundColor).
        moveButton rightInset:-8; bottomInset:-8.
        moveButton releaseAction:[].
        moveButton pressAction:[moveButton turnOff; redraw. self doMove].
        moveButton borderWidth:0.
        moveButton activeLevel:0; passiveLevel:0.
        moveButton cursor:(Cursor origin)
    ].

    "Modified: 24.7.1997 / 16:08:11 / cg"
!

isPopUpView
    "return true, if I want to come up without decoration
     and popUp to top immediately."

    ^ UseTransientViews not

    "Modified: 24.7.1997 / 15:20:14 / cg"
!

realize
    super realize.
    self assignInitialKeyboardFocus.

    "Modified: / 3.5.1996 / 23:48:04 / stefan"
    "Modified: / 20.5.1999 / 18:17:34 / cg"
!

reinitialize
    "if I have already been reinited - return"
    self drawableId notNil ifTrue:[
        ^ self
    ].
    "physically create the view & subviews"
    self recreate.

"/   super reinitialize.
"/   self unmap.

    "Modified: / 3.5.1996 / 23:48:04 / stefan"
    "Modified: / 6.5.1999 / 09:38:06 / cg"
!

resize
    "resize myself to make everything visible"

    |newExtent maxExtent|

    newExtent := self preferredExtent.
    newExtent := newExtent min:(device extent).

    maxExtent := self maxExtent.
    maxExtent notNil ifTrue:[
        newExtent := newExtent min:maxExtent.
    ].
    newExtent ~= self extent ifTrue:[
        (shown and:[shadowView notNil]) ifTrue:[
            shadowView unmap.
            self extent:newExtent.
            shadowView realize.
            self raise
        ] ifFalse:[
            self extent:newExtent.
        ].
    ].

    "Modified: / 21-01-2011 / 13:50:11 / cg"
!

resizeUnderPointer
    "resize myself to make everything visible, AND possibly change the origin
     to have the mouse pointer stay within my bounds.
     This is used for self-resizing enterBoxes, to avoid moving
     the box away from the cursor."

    |newExtent newLeft delta screenWidth|

    newExtent := self preferredExtent.
    newExtent = self extent ifTrue:[^ self].

    shown ifTrue:[
        delta := width - newExtent x.
        newLeft := left + delta.
        (((newLeft @ top) extent:newExtent) containsPoint:device pointerPosition
        ) ifFalse:[
            newLeft := left
        ].
        newLeft < 0 ifTrue:[newLeft := 0].
        screenWidth := device usableWidth.
        newLeft + newExtent x > screenWidth ifTrue:[
            newLeft := screenWidth - newExtent x
        ].
        shadowView notNil ifTrue:[
            shadowView unmap.
        ].
        self origin:(newLeft @ top) extent:newExtent.
        shadowView notNil ifTrue:[
            shadowView realize.
            self raise.
        ].
    ] ifFalse:[
        self extent:newExtent.
    ].

    "Modified: 6.9.1995 / 15:31:21 / claus"
    "Modified: 3.5.1996 / 23:48:17 / stefan"
! !

!ModalBox methodsFor:'move & resize'!

doMove
    "the move button was pressed.
     This method is only used with non-transient views
     (UseTransientViews == false)."

    |r|

    r := device rectangleFromUser:(self origin corner:self corner) keepExtent:true.
    shadowView notNil ifTrue:[
        shadowView unmap
    ].
    self origin:r origin extent:(self extent).
    shadowView notNil ifTrue:[
        shadowView realize.
        self raise.
    ].

    "Modified: 3.5.1996 / 23:47:38 / stefan"
    "Modified: 24.7.1997 / 16:07:18 / cg"
!

doResize
    "the resize button was pressed.
     This method is only used with non-transient views
     (UseTransientViews == false)."

    |r|

    r := device rectangleFromUser:(self origin corner:self corner).
    shadowView notNil ifTrue:[
        shadowView unmap
    ].
    self origin:r origin extent:(r extent max:(100@100)).
    shadowView notNil ifTrue:[
        shadowView realize.
        self raise
    ].

    "Modified: 3.5.1996 / 23:47:47 / stefan"
    "Modified: 24.7.1997 / 15:18:46 / cg"
! !

!ModalBox methodsFor:'queries-internal'!

windowLabelFor:labelString
    "dialogs do not include the hostname in the window label"

    ^ labelString

    "Created: 22.9.1997 / 10:14:02 / cg"
!

windowStyle
    "return a symbol describing my style (one of: #dialog, #popUp or #normal)
     (may be used internally by the device as a decoration hint)"

    UseTransientViews ifFalse:[
	^ #popUp
    ].
    ^ super windowStyle

    "Created: 2.5.1997 / 14:34:17 / cg"
    "Modified: 24.7.1997 / 15:22:39 / cg"
! !

!ModalBox methodsFor:'show & hide'!

autoHideAfter:seconds with:anAction
    "install a background process, which hides the box
     after some time. Also, if non-nil, anAction will be
     evaluated then. The action will not be evaluated if
     the box is closed by the user pressing a button."

    "the implementation is simple: just fork of a process
     to hide me."
    [
	Delay waitForSeconds:seconds.
	self shown ifTrue:[
	    self hide.
	    anAction value
	]
    ] forkAt:4.

    "
     |b|

     b := InfoBox title:'hello there'.
     b autoHideAfter:5 with:[].
     b showAtCenter.
    "
!

fixSize
    "this is sent right before the modalBox is made visible;
     If the size is not fixed, adjust my size."

    sizeFixed ifFalse:[
        self resize.
    ].
    super fixSize.

    "Modified: / 27-10-2012 / 12:16:58 / cg"
!

hide
    "make the receiver invisible and leave control"

    |masterGroup|

    realized ifFalse:[^ self].

    shadowView notNil ifTrue:[shadowView unmap].
    windowGroup notNil ifTrue:[
        windowGroup focusView:nil.
        masterGroup := windowGroup previousGroup.
    ].

    exclusiveKeyboard ifTrue:[
        self forceUngrabKeyboard
    ].

    self unmap.

    masterGroup notNil ifTrue:[
        "
         this is a kludge for IRIS and others which do not provide backingstore:
         when we hide a modalbox (such as a searchbox) which covered
         a scrollbar, the scrollbars bitblt-method will copy from the
         not-yet redrawn area - effectively clearing the scroller.
         We need a short delay here, since at this time, the expose event has
         not yet arrived.
        "
        device sync.     "/ that's a round trip, to ensure that all expose events are present..."
        Delay waitForSeconds:0.05.
        masterGroup processExposeEvents
    ].

    "Modified: 3.5.1996 / 23:47:57 / stefan"
    "Modified: 8.2.1997 / 17:41:16 / cg"
!

hideRequest
    "hide request from windowGroup (i.e. via Escape key).
     Can be redefined in subclasses which don't like this"

    self hide
!

mapped
    "wait till visible for grabbing"

    super mapped.

"/    "take it away from any popup menu possibly still active"
"/
"/    self forceUngrabKeyboard.
"/    self forceUngrabPointer.
"/
    "
     if I am a super-modal box, take the keyboard
    "
    exclusiveKeyboard ifTrue:[
	self forceUngrabKeyboard.
	self grabKeyboard.
    ].
"/
"/"/    UseTransientViews ifFalse:[
"/        "
"/         get the focus
"/        "
"/        self getKeyboardFocus.
"/        self enableEnterLeaveEvents
"/"/    ]
!

open
    "default for modalboxes is to come up modal at the pointer position"

    ForceModalBoxesToOpenAtCenter == true ifTrue:[
	^ self showAtCenter
    ].
    ^ self showAtPointer
!

openAt:aPoint
    "default for modalboxes is to come up modal at the pointer position"

    ^ self openModalAt:aPoint

    "Created: 17.7.1996 / 14:50:44 / cg"
!

openAtCenter
    "default for modalboxes is to come up modal at the pointer position"

    ^ self openModalAtCenter

    "Created: 17.7.1996 / 14:50:35 / cg"
!

openModal:aBlock
    "open the box modal;
     In addition to the basic (inherited) modalloop, change
     the current active windowgroups cursors to the busy-stop cursor, show
     a shadow, and raise the box."

    shadowView notNil ifTrue:[shadowView realize].
    super openModal:aBlock.

    "Created: 10.12.1995 / 14:07:01 / cg"
    "Modified: 28.2.1997 / 22:32:49 / cg"
!

show
    "make myself visible (at the last or default position) and take control.
     If that position is out of the screen area, moves the receiver to make
     it fully visible."

    self fixSize.
    self makeFullyVisible.
    self openModal

    "
     |b|

     b := InfoBox title:'hello'.
     b show.
    "

    "Modified: 7.3.1996 / 17:57:49 / cg"
!

showAt:aPoint
    "make myself visible at aPoint.
     Fix position to make box fully visible"

    self fixSize.
    self fixPosition:aPoint.
    self openModal

    "
     |b|

     b := InfoBox title:'hello'.
     b showAt:(0 @ 0).
     b showAt:(400 @ 400).
    "
!

showAt:aPoint center:center
    "make myself visible at aPoint. center specifies
     if the view should show up centered around aPoint."

    self showAt:aPoint centerX:center centerY:center

    "
     |b|

     b := InfoBox title:'hello'.
     b showAt:(100 @ 100) center:true.
     b showAt:(100 @ 100) center:false.
    "
!

showAt:aPoint centerX:centerX centerY:centerY
    "make myself visible at aPoint. centerX/centerY specify
     if the view should show up centered around aPoint.
     Fix position to make box fully visible"

    |dx dy|

    self fixSize.
    centerX ifTrue:[
        dx := self width // 2.
    ] ifFalse:[
        dx := 0
    ].
    centerY ifTrue:[
        dy := self height // 2.
    ] ifFalse:[
        dy := 0
    ].
    self origin:(aPoint - (dx @ dy)).
    self makeFullyVisible.
    self openModal

    "
     |b|

     b := InfoBox title:'hello'.
     b showAt:(100 @ 100).
     b showAt:(100 @ 100) centerX:true centerY:false.
    "

    "Modified: / 21-01-2011 / 13:58:29 / cg"
!

showAtCenter
    "make myself visible at the screen center."

    self showAt:(device centerOfMonitorHavingPointer) center:true

    "
     |b|

     b := InfoBox title:'hello'.
     b showAtCenter.
    "
!

showAtPointer
    "make myself visible at mouse pointer shifted to have
     convenient button under cursor. self positionOffset should
     return that offset (usually redefined, since we don't know here,
     which button should be under cursor)."

    |first pointerPosition positionOffset pos monitorBounds alignedPos|

    "/ ****** MULTI SCREEN
    pointerPosition := device pointerPosition.

    self fixSize.
    positionOffset := self positionOffset.
    pos := alignedPos := pointerPosition - positionOffset.

    UserPreferences current forceWindowsIntoMonitorBounds ifTrue:[
        monitorBounds := device monitorBoundsAt:pointerPosition.
        alignedPos := (pos x max:monitorBounds left) @ (pos y max:monitorBounds top).
    ].

    positionOffset := pointerPosition - alignedPos.

    self fixPosition:alignedPos.
    pos := self origin.

    "We have got a problem here:
        X11 adds some window decoration. The size of the decoration is only known
        after the view is visible!!

        So there is a (hopefully) small offset from the pointer to the requested
        position. The only way to resolve this, is to move the pointer to
        the requested position after the view is visible"

    first := true.
    self openModal:[
        (first and:[shown]) ifTrue:[
            first := false.
            "in Linux - SuSe Tumbleweed 2016-01 the Delay is required, otherwise the pointer
             is shown relative to the root window. No idea why this is needed. Maybe the
             window manager (kwin) does something."
            Delay waitForMilliseconds:10.
            self setPointerPosition:positionOffset.
        ].
        true
    ].

    "/ cannot use:
    "/    self showAt:(device pointerPosition - self positionOffset).
    "/ because the resizing must be done before the
    "/ positionOffset is grabbed (it may change due to the resize)

    "
     |b|

     b := InfoBox title:'hello'.
     b showAtPointer.
    "

    "Modified: / 22-10-2010 / 11:20:05 / cg"
!

showAtPointerNotCovering:aView
    "make myself visible at mouse pointer shifted to have
     convenient button under cursor.
     Fix position to make the box fully visible AND to make sure that
     aView is not covered."

    |pos newX|

    pos := device pointerPosition - self positionOffset.

    ((Rectangle origin:pos extent:self extent)
        intersects: (aView origin corner: aView corner))
    ifTrue:[
        "
         try to the right of the untouchable view
        "
        newX := (aView origin x + aView width).
        newX + width > device usableWidth ifTrue:[
            newX := device usableWidth - width
        ].
        pos x:newX.


        ((Rectangle origin:pos extent:self extent)
            intersects: (aView origin corner: aView corner))
        ifTrue:[
            "
             try to the left of the untouchable view
            "
            newX := aView origin x - width.
            "
             should look for vertical possibilities too ...
            "
            pos x:newX.
        ]

    ].
    self showAt:pos

    "Modified: 7.3.1996 / 17:58:10 / cg"
!

showCenteredIn:aView
    "make myself visible at the center if aView."

    |top|

    top := aView topView.
    top raise.
    self showAt:(top center + (aView originRelativeTo:top)) center:true

    "
     |b|

     b := InfoBox title:'hello'.
     b showCenteredIn:Transcript.
    "

    "Modified: 7.3.1996 / 17:58:53 / cg"
!

unmapped
    "mhmh - unmapped by the windowManager - if realized (i.e. not closing),
     keep the realized flag true (to avoid exiting the modal event loop).
     Consider this a kludge."

    |r|

    r := realized.
    super unmapped.
    realized := r.
! !

!ModalBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ModalBox initialize!

"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

TopView subclass:#PopUpView
	instanceVariableNames:'shadowView haveControl exclusivePointer mapTime
		previousPointerGrab previousKeyboardGrab'
	classVariableNames:'DefaultShadow DefaultLevel DefaultBorderWidth DefaultBorderColor'
	poolDictionaries:''
	category:'Views-Basic'
!

!PopUpView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    this class implements an abstract superclass for all views which bypass the 
    window manager and pop up on top of the screen. A typical example is
    a PopUpMenu. PopUpView itself is abstract, providing basic mechanisms.
    They are not decorated by window managers.

    [styleSheet parameters:]

        popupShadow         <Boolean>           if true, popupViews show a shadow below
        popupLevel          <nil | Integer>     3D level
        popupBorderWidth    <nil | Integer>     borderWidth

    [author:]
        Claus Gittinger
"
! !

!PopUpView class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    |display|

    display := Screen current.
    ^ (display monitorBoundsAt:display pointerPosition) extent // 3.

    "Modified: 5.7.1996 / 13:55:08 / cg"
!

shadows
    "return the shadows-flag. False means: turned off.
     Notice, that even when set to true, a particular device might
     want to suppress this feature."

    ^ DefaultShadow
!

shadows:aBoolean
    "turn on/off shadows under popUpViews. 
     Notice, that even when set to true, a particular device might
     want to suppress this feature.
     On slow displays, turning them off makes menus appear a bit snappier.
     The default is set via the styleSheet and changes when the viewStyle
     is changed."

    DefaultShadow := aBoolean
!

shadowsOnDevice:aDevice
    "return true, if shadows should be shown on aDevice"

    ^ DefaultShadow and:[aDevice suppressShadowViews not]
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'popup.shadow' #'popup.level'
                       #'popup.borderWidth'
                       #'popup.borderColor')>

    ShadowView isNil ifTrue:[
        DefaultShadow := false
    ] ifFalse:[
        "/ notice, that even when true, a particular device might
        "/ want to suppress this feature.
        DefaultShadow := StyleSheet at:'popup.shadow' default:false.
    ].
    DefaultLevel := StyleSheet at:'popup.level'.
    DefaultBorderWidth := StyleSheet at:'popup.borderWidth'.
    DefaultBorderColor := StyleSheet colorAt:'popup.borderColor' default:Color black.

    "Modified: 20.10.1997 / 15:10:07 / cg"
! !

!PopUpView methodsFor:'accessing'!

exclusivePointer:aBoolean
    "set/clear the exclusive pointer flag;
     DANGER: if set, no interaction with other views is possible,
     while the popUp is active"

    exclusivePointer := aBoolean

    "Modified: 12.5.1996 / 22:02:52 / cg"
!

haveControl:aBoolean
    "set the flag which decides whether the pointers canbe grab
     during mapped.
    "
    haveControl := aBoolean.
!

noShadow
    "turn off the shadow"

    shadowView := nil
! !

!PopUpView methodsFor:'activation & deactivation'!

open
    "default for popUpViews is to come up modal"

    self openModal
!

show
    "realize the view at its last position"

    self fixSize.
    self open
!

showAt:aPoint
    "realize the view at aPoint"

    self showAt:aPoint resizing:true 
!

showAt:aPoint resizing:aBoolean
    "realize the view at aPoint"

    aBoolean ifTrue:[
        self fixSize.
    ].
    self origin:aPoint.
    self makeFullyVisible.
    self open 
!

showAtPointer
    "realize the view at the current pointer position"

    self showAt:(device pointerPosition) resizing:true
!

showCenteredIn:aView
    "make myself visible at the screen center."

    |top|

    top := aView topView.
    top raise.
    self showAt:(top origin 
		 + (aView originRelativeTo:top) 
		 + (aView extent // 2)
		 - (self extent // 2))
! !

!PopUpView methodsFor:'defaults'!

defaultShadow
    "obsoleted by PopUpView defaultShadowOn:aDevice"

    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ DefaultShadow

    "Created: / 4.12.1998 / 15:11:20 / cg"
! !

!PopUpView methodsFor:'grabbing'!

grabKeyboard
    previousKeyboardGrab := device activeKeyboardGrab.
"/ Transcript show:'k-ggg by '; show:self; show:'[',self identityHash printString,']'; showCR:' - previous is ' , previousKeyboardGrab printString.
    ^ super grabKeyboard
!

grabPointerWithCursor:aCursorOrNil
    previousPointerGrab := device activePointerGrab.
"/ Transcript show:'ggg by '; show:self; show:'[',self identityHash printString,']'; showCR:' - previous is ' , previousPointerGrab printString.
    ^ super grabPointerWithCursor:aCursorOrNil
!

ungrabKeyboard
"/ Transcript show:'k-uuu by '; show:self; show:'[',self identityHash printString,']'; showCR:' - previous is ' , previousKeyboardGrab printString.
    super ungrabKeyboard.
    previousKeyboardGrab notNil ifTrue:[
        device grabKeyboardInView:previousKeyboardGrab
    ].
!

ungrabPointer
"/ Transcript show:'uuu by '; show:self; show:'[',self identityHash printString,']'; showCR:' - previous is ' , previousPointerGrab printString.
    super ungrabPointer.
    previousPointerGrab notNil ifTrue:[
        device grabPointerInView:previousPointerGrab
    ].
! !

!PopUpView methodsFor:'initialization & release'!

create
    super create.

    shadowView isNil ifTrue:[
        self saveUnder:true
    ]
!

destroy
    haveControl := false.
    super destroy.
    shadowView notNil ifTrue:[shadowView destroy. shadowView := nil]
!

initStyle
    "setup viewStyle specifics"

    |l bw|

    super initStyle.

    DefaultBorderColor notNil ifTrue:[
        self borderColor:(DefaultBorderColor onDevice:device).
    ].
    (bw := DefaultBorderWidth) isNil ifTrue:[
        bw := (styleSheet is3D ifTrue:[0] ifFalse:[1]).
    ].
    self borderWidth:bw.

    DefaultLevel isNil ifTrue:[
        l := styleSheet is3D ifTrue:[1] ifFalse:[0].
    ] ifFalse:[
        l := DefaultLevel.
    ].
    self level:l.

    (self class shadowsOnDevice:device) ifTrue:[
        shadowView := (ShadowView onDevice:device) for:self.
    ].

    "Modified: / 4.12.1998 / 15:11:28 / cg"
!

initialize
    super initialize.
    exclusivePointer := true.
    haveControl := false.
    self bePopUpView
!

releaseDeviceResources
    shadowView notNil ifTrue:[shadowView destroy. shadowView := nil].
    super releaseDeviceResources
!

releasePointer 
    "release the mouse pointer"

    device activePointerGrab == self ifTrue:[
        device ungrabPointer.
    ].

    "Modified: 12.5.1996 / 22:04:09 / cg"
!

releasePointerAndKeyboard 
    "release the pointer and keyboard"

    self ungrabPointer.
    self ungrabKeyboard.
! !

!PopUpView methodsFor:'private'!

regainControl
    "get exclusive access to pointer and keyboard"

    shown ifTrue:[
        self grabPointer.
        self grabKeyboard.
        self sensor flushMotionEventsFor:nil; flushKeyboardFor:nil.
    ].

    "Modified: 6.5.1996 / 22:33:39 / stefan"
    "Modified: 12.5.1996 / 22:04:42 / cg"
! !

!PopUpView methodsFor:'queries'!

grabWhenMapped
    "return true, if I should perform a grab when mapped. 
     Redefinable for subclasses."

    ^ true

    "Modified: 12.5.1996 / 21:57:51 / cg"
!

isPopUpView
    "return true, since I want to come up without decoration 
     and popUp to top immediately."

    ^ true

    "Modified: 12.5.1996 / 21:57:51 / cg"
! !

!PopUpView methodsFor:'realize & unrealize'!

hide
    "hide the view, leave its modal event loop"

    |masterGroup|

    windowGroup notNil ifTrue:[
        masterGroup := windowGroup previousGroup.
        windowGroup removeView:self.
        windowGroup := nil.
    ].
    self unmap.

    "/ allow for redraw events to arrive
    "/ (actually, only req'd for win32 systems,
    "/  but that short delay does not hurt on others)

"/    Delay waitForSeconds:0.05.
    masterGroup notNil ifTrue:[
        "
         this is a kludge for IRIS and others which do not provide backingstore:
         when we hide a modalbox (such as a searchbox) which covered
         a scrollbar, the scrollbars bitblt-method will copy from the
         not-yet redrawn area - effectively clearing the scroller.
         We need a short delay here, since at this time, the expose event has
         not yet arrived.
        "
        Delay waitForSeconds:0.05.
        masterGroup processExposeEvents   
    ].

    "Modified: / 3.5.1996 / 23:48:22 / stefan"
    "Modified: / 12.9.1998 / 14:58:33 / cg"
!

mapped
    "grab the pointer here, when visible (but not control is already lost). 
     If the grab fails, try again and unmap myself if that fails too."

    |count grabbed|

    mapTime := Time millisecondClockValue.

    super mapped.

    (haveControl 
    and:[true "/ exclusivePointer
    and:[realized
    and:[self grabWhenMapped]]]) ifTrue:[
        (self grabPointer) ifFalse:[
            count := 0.
            [
                "wait a little bit and try again"
                Delay waitForSeconds:0.1.
                count := count + 1.
            ] doUntil:[ (grabbed := self grabPointer) or:[count > 4]].
            grabbed ifFalse:[
                "give up"
                'PopUpView [warning]: could not grab pointer' errorPrintCR.
                self unmap
            ]
        ].
        exclusivePointer ifFalse:[
            self releasePointer
        ].
        self grabKeyboard.
        self getKeyboardFocus
    ]

    "Modified: 3.5.1996 / 23:48:37 / stefan"
    "Modified: 10.1.1997 / 18:00:31 / cg"
!

realize
    shadowView notNil ifTrue:[shadowView realize].
    self raise.
    haveControl := true.

"/    device zoom:(device pointerPosition extent:1@1)to:(self bounds) duration:10.
    super realize.
!

unmap
    haveControl := false.

    self releasePointerAndKeyboard.
    super unmap.
    shadowView notNil ifTrue:[shadowView unmap].

    "Modified: 3.5.1996 / 23:46:06 / stefan"
! !

!PopUpView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 COPYRIGHT (c) 1999 by eXept Software AG
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

TopView subclass:#ExternalTopView
	instanceVariableNames:'windowClosedPollProcess'
	classVariableNames:'ErrorPrinting'
	poolDictionaries:''
	category:'Views-Basic'
!

!ExternalTopView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Represents a view as created by some other application.
    This is a support-class to allow ST/X views to be created
    inside other applications.

    A simple demoApplication is found in goodies/stxInExternalWindow
    (which uses Demos::PlayInAlienWindow as a startup anchor)

    [author:]
        Claus Gittinger (cg@exept.de)

    [see also:]

    [instance variables:]
        none added here

    [class variables:]
        none added here
"
! !

!ExternalTopView class methodsFor:'instance creation'!

newWithID:anAlienWindowID
    "create and return a new externalTopView - the windowID
     as passed in must be from an alien programs view"

    ^ self new setWindowID:anAlienWindowID
! !

!ExternalTopView class methodsFor:'accessing'!

errorPrinting:something
    "controls errorprinting while checking for alive connection"

    ErrorPrinting := something.
! !

!ExternalTopView methodsFor:'private'!

alienViewHasBeenDestroyed
    'alienViewHasBeenDestroyed' infoPrintCR.
    self sensor notNil ifTrue:[
        self sensor destroyedView:self
    ] ifFalse:[
        self destroyed
    ]
!

checkWindowStillAlive
    "check for a destroyed topView 
     (must poll, since we do not get any events from X for the alien topView)"

    |stillAlive prevErrorPrintingFlag graphicsDevice|

    graphicsDevice := device.
    prevErrorPrintingFlag := graphicsDevice class errorPrinting.
    graphicsDevice class errorPrinting:(ErrorPrinting ? true).

    self drawableId notNil ifTrue:[
        stillAlive := graphicsDevice isValidWindowId:self drawableId.
    ] ifFalse:[
        stillAlive := false
    ].
    graphicsDevice flush.

    graphicsDevice class errorPrinting:prevErrorPrintingFlag.

    ^ stillAlive.
!

checkWindowStillAliveLoop
    [self checkWindowStillAlive] whileTrue:[
        Delay waitForSeconds:0.5.
    ].

    self alienViewHasBeenDestroyed
!

startWindowClosedPollProcess
    windowClosedPollProcess isNil ifTrue:[
        windowClosedPollProcess := 
            [ 
                [
                    self checkWindowStillAliveLoop 
                ] ensure:[
                    windowClosedPollProcess := nil.
                ]
            ] fork.
    ].
!

stopWindowClosedPollProcess
    windowClosedPollProcess notNil ifTrue:[
        windowClosedPollProcess terminate.
        windowClosedPollProcess waitUntilTerminated
    ].
! !

!ExternalTopView methodsFor:'private accessing'!

setWindowID:aWindowID
    self setId:aWindowID.
    realized := shown := true.
! !

!ExternalTopView methodsFor:'queries'!

isExternalTopView
    "return true, if this is an external topView - always true here"

    ^ true
! !

!ExternalTopView methodsFor:'redefined'!

destroyView
    "never destroyed by ST/X - instead, the view is under
     control of the host application ..."

    self stopWindowClosedPollProcess.
    realized := false.
    self setId:nil.
!

open
    "redefined to start a watch timeout for closed windows;
     this is required, since we wont get any closeRequest event for
     external windows (as all of its events are handled by the alien
     application)"

    super open.
    "/ self checkWindowStillAlive
    self startWindowClosedPollProcess.
!

unmap
    "redefined as a noop;
     ExternalTopViews are never unmapped by ST/X - instead, the view is under
     control of the host application ..."


! !

!ExternalTopView methodsFor:'special'!

becomeParentOf:anSTXWindow
    "add myself to the windowGroup of anSTXWindow ...
     and reparent anSTXWindow to be the (only) child of myself"

    self old_becomeParentOf:anSTXWindow
!

new_becomeParentOf:anSTXWindow
    "add myself to the windowGroup of anSTXWindow ...
     and reparent anSTXWindow to be the (only) child of myself"

    |wg oldTopView retryCount deviceErrorOccurred|

    anSTXWindow borderWidth:0. anSTXWindow forceBorderWidth.
    self borderWidth:0.        "/ self forceBorderWidth.
    self borderColor:Color red.

    anSTXWindow createWithAllSubViews.
    oldTopView := anSTXWindow topView.

    wg := anSTXWindow windowGroup.
    wg notNil ifTrue:[
        windowGroup notNil ifTrue:[
            windowGroup removeView:self.
        ].
        wg addTopView:self.
        windowGroup := wg.
    ].

    oldTopView == anSTXWindow ifTrue:[
        oldTopView container:self.
    ].

    self open. "/ not really an open; however it starts its event handler
    wg isNil ifTrue:[
        oldTopView windowGroup:self windowGroup.
    ] ifFalse:[
        windowGroup ~~ anSTXWindow windowGroup ifTrue:[
            self halt:'possible inconsistency ?'
        ].
    ].

"/'childID: ' print. anSTXWindow id displayString printCR.
"/'parentID: ' print. self id displayString printCR.
    self addSubView:anSTXWindow.

 self checkWindowStillAlive ifFalse:[ Transcript showCR:'x1'. ^ true].


    anSTXWindow device 
        reparentWindow:anSTXWindow id
        to:self id.
    anSTXWindow device unBuffered.
    retryCount := 0.
    deviceErrorOccurred := false.
    [

        GLXWorkstation deviceErrorSignal handle:[:ex|
          'DeviceErrorSignal raised in becomeParentOf: ' infoPrintCR.
           deviceErrorOccurred := true.
"/          (Delay waitForSeconds: 1).
"/          retryCount := retryCount + 1.
"/          retryCount > 5 ifTrue:[
"/              ex proceed
"/          ].
          ex proceed
        ] do:[
            deviceErrorOccurred := false.
            anSTXWindow enableEvent:#structureNotify.
        ].
    ] ensure:[
        anSTXWindow device buffered.
    ].
    deviceErrorOccurred ifTrue:[^false].


 self checkWindowStillAlive ifFalse:[ Transcript showCR:'x2'. ^ true].

    anSTXWindow realize.
    anSTXWindow map.
    ^true

"/    wg notNil ifTrue:[
"/        wg removeView:oldTopView.
"/        wg addView:oldTopView.
"/    ].

"/    anSTXWindow origin:0.0 @ 0.0 corner:1.0 @ 1.0.
!

old_becomeParentOf:anSTXWindow
    "add myself to the windowGroup of anSTXWindow ...
     and reparent anSTXWindow to be the (only) child of myself"

    |wg oldTopView|

    anSTXWindow createWithAllSubViews.

    oldTopView := anSTXWindow topView.

    wg := anSTXWindow windowGroup.
    wg notNil ifTrue:[
        wg addTopView:self.
    ].

    oldTopView == anSTXWindow ifTrue:[
        oldTopView setContainer:self.
    ].

    self open. "/ not really an open; however it starts its event handler

    wg isNil ifTrue:[
        oldTopView windowGroup:self windowGroup.
    ].

    anSTXWindow device 
        reparentWindow:anSTXWindow id
        to:self id.

    self addSubView:anSTXWindow.
    anSTXWindow enableEvent:#structureNotify.

    anSTXWindow realize.
    anSTXWindow map.
    wg notNil ifTrue:[
        wg removeView:oldTopView.
        wg addView:oldTopView.
    ].

    anSTXWindow origin:0.0 @ 0.0 corner:1.0 @ 1.0.
! !

!ExternalTopView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


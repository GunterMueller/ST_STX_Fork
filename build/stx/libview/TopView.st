"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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

View subclass:#TopView
	instanceVariableNames:'type iconified keyboardProcessor'
	classVariableNames:'TakeFocusWhenMapped ForceModalBoxesToOpenAtCenter
		ForceModalBoxesToOpenAtPointer MasterSlaveMask WindowTypeMask
		TypeMaster TypeSlave TypePartner TypeDialog TypePopUp
		TypeUndecorated TypeToolWindow TypeToolDialog MDIClientMask
		MDIClient TypeScreenDialog CurrentWindowMoveStart
		CurrentWindowMoveState CurrentWindowBeingMoved
		TypeUndecoratedResizable TypePopUpNonModal'
	poolDictionaries:''
	category:'Views-Basic'
!

!TopView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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
    I am an abstract superclass of StandardSystemView and PopUpView;
    i.e. views which have no superview.

    Do not get confused by the name TopView - your applications
    topViews are typically instances of StandardSystemView.

    [instance variables:]
	type            <Integer>       encodes master/slave relationship:
					    #normal, #master, #slave or #partner
					for modeless views
					(the #master-, #slave- or #partner-type links multiple views
					 into a windowManagers windowGroup -> for de-iconification)

					encodes window type:
					    #normal, #dialog, #popup, #undecorated

    [see also:]
	StandardSystemView PopUpView DialogBox
	( introduction to view programming :html: programming/viewintro.html )

    [author:]
	Claus Gittinger
"
!

examples
"
  Notice, the following examples only demonstrate the windos style (not its modal behavior).
  the style is controlled by the systems windowManager, and might even be ignored by some.
  (for example, the dialog- and normal styles often look the same).

  The bahavior is controlled by ST/X, and controlled by the open vs. openModeless vs. openModal message.

  Modeless:
    regular style:
							    [exBegin]
	|v|

	v := TopView new.
	v extent:200@200.
	v open
							    [exEnd]

    dialog:
							    [exBegin]
	|v|

	v := TopView new.
	v beDialogView.
	v extent:200@200.
	v open
	Delay waitForSeconds:10. v destroy.
							    [exEnd]

    popUp (always on top):
							    [exBegin]
	|v|

	v := TopView new.
	v bePopUpView.
	v extent:200@200.
	v open.
	Delay waitForSeconds:10. v destroy.
							    [exEnd]

    undecorated (looks loke popUp, but is not always on top):
							    [exBegin]
	|v|

	v := TopView new.
	v beUndecorated.
	v extent:200@200.
	v open.
	Delay waitForSeconds:10. v destroy.
							    [exEnd]

    toolwindow (looks loke normal, but has smaller windowTitle-area on win32):
							    [exBegin]
	|v|

	v := TopView new.
	v beToolWindow.
	v extent:200@200.
	v open.
	Delay waitForSeconds:10. v destroy.
							    [exEnd]

    toolwindow dialog (looks loke normal, but has smaller windowTitle-area on win32):
							    [exBegin]
	|v|

	v := TopView new.
	v beToolDialog.
	v extent:200@200.
	v open.
	Delay waitForSeconds:10. v destroy.
							    [exEnd]

  Modal:
    regular style:
							    [exBegin]
	|v|

	v := TopView new.
	v extent:200@200.
	v openModal
							    [exEnd]

    dialog:
							    [exBegin]
	|v|

	v := TopView new.
	v beDialogView.
	v extent:200@200.
	v openModal
							    [exEnd]

    popUp (always on top):
							    [exBegin]
	|v|

	v := TopView new.
	v bePopUpView.
	v extent:200@200.
	v openModal
							    [exEnd]

    undecorated (looks loke popUp, but is not always on top):
							    [exBegin]
	|v|

	v := TopView new.
	v beUndecorated.
	v extent:200@200.
	v openModal
							    [exEnd]

"
! !

!TopView class methodsFor:'accessing'!

currentWindowBeingMoved
    "the current window move operation
     (only used with modeless popup windows; i.e. windows without decoration,
      which want to be moved by click-motion on the background)"

    ^ CurrentWindowBeingMoved

    "Created: / 03-03-2011 / 19:20:34 / cg"
! !

!TopView class methodsFor:'class initialization'!

initialize
    MasterSlaveMask := 16r0F.
     TypeMaster      := 16r01.
     TypeSlave       := 16r02.
     TypePartner     := 16r03.

    WindowTypeMask  := 16rF0.
     TypeDialog      := 16r10.
     TypePopUp       := 16r20.
     TypeUndecorated := 16r30.
     TypeToolWindow  := 16r40.
     TypeToolDialog  := 16r50.
     TypeScreenDialog:= 16r60.
     TypeUndecoratedResizable := 16r70.
     TypePopUpNonModal        := 16r80.

    MDIClientMask   := 16r100.
     MDIClient       := 16r100.

    "
     self initialize
    "
! !

!TopView class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     Topviews extents is 2/3 of screen by default"

    |display|

    display := Screen current.
    display isNil ifTrue:[
	^ 600 @ 400
    ].
    ^ display defaultExtentForTopViews
!

forceModalBoxesToOpenAtCenter
    "return the flag which forces all modal views to be opened
     at the screens center"

    ^ ForceModalBoxesToOpenAtCenter ? false
!

forceModalBoxesToOpenAtCenter:aBoolean
    "set/clear a flag which forces all modal views to be opened
     at the screens center"

    ForceModalBoxesToOpenAtCenter := aBoolean

    "
     TopView forceModalBoxesToOpenAtCenter:true
     TopView forceModalBoxesToOpenAtCenter:false
    "
!

forceModalBoxesToOpenAtPointer
    "return the flag which forces all modal views to be opened
     at the current pointer position"

    ^ ForceModalBoxesToOpenAtPointer ? false
!

forceModalBoxesToOpenAtPointer:aBoolean
    "set/clear the flag which forces all modal views to be opened
     at the current pointer position"

    ForceModalBoxesToOpenAtPointer := aBoolean
!

takeFocusWhenMapped:aBoolean
    "if turned on, topViews will grab the keyboard when mapped.
     This is useful on systems like openView or Win32, where a view needs a click
     otherwise"

    TakeFocusWhenMapped := aBoolean

    "
     StandardSystemView takeFocusWhenMapped:true
    "
! !

!TopView methodsFor:'Compatibility-ST80'!

displayBox
    ^ self bounds

    "Created: 3.3.1997 / 16:31:33 / cg"
!

displayBox:aRectangle
    self origin:aRectangle origin corner:aRectangle corner

    "Created: 3.3.1997 / 16:34:38 / cg"
! !

!TopView methodsFor:'accessing'!

keyboardProcessor
    "return my keyboard processor"

    ^ keyboardProcessor

    "Created: / 18.6.1998 / 18:52:42 / cg"
    "Modified: / 18.6.1998 / 20:00:18 / cg"
!

keyboardProcessor:something
    "set my keyboard processor"

    keyboardProcessor := something.

    "Created: / 18.6.1998 / 18:52:42 / cg"
    "Modified: / 18.6.1998 / 20:00:30 / cg"
!

label:labelString iconLabel:iconLabelString
    "/ ignored here - for compat. with StdSysViews
! !

!TopView methodsFor:'accessing-behavior'!

beDialogView
    "make me a Dialog Window; that is one which raises above all other ST/X views"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := (type bitClear:WindowTypeMask) bitOr:TypeDialog.
	^ self.
    ].
    type := #dialog
!

beIndependent
    "make this an independent view; i.e. remove any master/slave or partner
     attribute (this is the default).
     However, the view remains in the current windowGroup"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := type bitClear:MasterSlaveMask.
	^ self.
    ].
    type := nil
!

beMDIClientView
    type := (type bitClear:MDIClientMask) bitOr:MDIClient.
!

beMaster
    "make this a master-view.
     All slave views within the same windowGroup will be closed if any master is closed
     and also de/iconify together with their master(s).
     (i.e. they follow their master(s))."

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := (type bitClear:MasterSlaveMask) bitOr:TypeMaster.
	^ self.
    ].
    type := #master

    "
     see example in TopView>>beSlave
    "

    "Created: 10.12.1995 / 13:30:50 / cg"
!

bePartner
    "make this a partner-view. Each partner-view will automatically
     close other partner views (within the same windowGroup) when closed."

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := (type bitClear:MasterSlaveMask) bitOr:TypePartner.
	^ self.
    ].
    type := #partner

    "
     create two topViews within the same group:
     if any of them is iconified/deiconified/closed, the other one is also

     |top1 top2|

     top1 := StandardSystemView new label:'partner'; extent:300@300.
     top2 := StandardSystemView new label:'partner'; extent:200@200.
     top1 bePartner.
     top2 bePartner.

     top1 open.
     top2 openInGroup:(top1 windowGroup)
    "

    "Created: 10.12.1995 / 13:29:59 / cg"
    "Modified: 25.5.1996 / 11:44:48 / cg"
!

bePopUpView
    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := (type bitClear:WindowTypeMask) bitOr:TypePopUp.
	^ self.
    ].
    type := #popup
!

bePopUpViewNotModal
    "experimental/unfinished - do not use"

    "/ the nonInteger handling code is for backward compatibility only.

    type isInteger ifTrue:[
        type := (type bitClear:WindowTypeMask) bitOr:TypePopUpNonModal.
        ^ self.
    ].
    type := #popUpNotModal
!

beScreenDialog
    "make me a Screen-Dialog Window; that is one which raises above ALL other windows
     (not only st/x ones)"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := (type bitClear:WindowTypeMask) bitOr:TypeScreenDialog.
	^ self.
    ].
    type := #dialog
!

beSlave
    "make this a slave-view. It will be closed automatically,
     whenever any master of the windowgroup is closed.
     See also: #bePartner"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
	type := (type bitClear:MasterSlaveMask) bitOr:TypeSlave.
	^ self.
    ].
    type := #slave

    "
     create two topViews within the same group:
     the slave is allowed to be iconified/close independ of the master;
     but if the master is iconified, the slave is also.

     |top1 top2|

     top1 := StandardSystemView new label:'master'; extent:300@300.
     top2 := StandardSystemView new label:'slave'; extent:200@200.
     top1 beMaster.
     top2 beSlave.

     top1 open.
     top2 openInGroup:(top1 windowGroup)
    "

    "Created: 10.12.1995 / 13:29:10 / cg"
    "Modified: 25.5.1996 / 11:45:30 / cg"
!

beToolDialog
    "make me a tool dialog Window with a smaller title area.
     Warning: not all window systems support that. Will be normal decorated on some systems (macosx)"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
        type := (type bitClear:WindowTypeMask) bitOr:TypeToolDialog.
        ^ self.
    ].
    type := #dialog
!

beToolWindow
    "make me a tool Window with a smaller title area.
     Warning: not all window systems support that. Will be normal decorated on some systems (macosx)"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
        type := (type bitClear:WindowTypeMask) bitOr:TypeToolWindow.
        ^ self.
    ].
    type := nil
!

beUndecorated
    "make me an undecorated Window.
     Warning: not all window systems support that. Will be decorated on some systems (macosx)"

    "/ the nonInteger handling code is for backward compatibility only.
    type isInteger ifTrue:[
        type := (type bitClear:WindowTypeMask) bitOr:TypeUndecorated.
        ^ self.
    ].
    type := nil

    "
     TopView new open
     TopView new windowType:#dialog2; open
     TopView new windowType:#notitle; open
     TopView new beDialogView; open
     TopView new bePopUpView; open
     TopView new beToolDialog; open
     TopView new beUndecorated; open
    "
!

beUndecoratedResizable
    "make me an undecorated but resizable Window"
    "experimental/unfinished - do not use
     Warning: not all window systems support that. Will be decorated on some systems (macosx)"

    type isInteger ifTrue:[
        type := (type bitClear:WindowTypeMask) bitOr:TypeUndecoratedResizable.
        ^ self.
    ].
    type := #undecoratedResizable

    "Created: / 03-03-2011 / 20:22:14 / cg"
!

focusSequence:aCollectionOfSubcomponents
    "define the sequence for stepping through my components."

    windowGroup isNil ifTrue:[
	windowGroup := self windowGroupClass new.
    ].
    windowGroup focusSequence:aCollectionOfSubcomponents.

    "Created: 6.3.1996 / 15:37:11 / cg"
    "Modified: 30.4.1996 / 15:41:40 / cg"
!

windowType:aTypeSymbol
    "experimental - do not use"

    type := aTypeSymbol

    "Created: / 03-03-2011 / 20:12:40 / cg"
! !

!TopView methodsFor:'accessing-look'!

addTrayIcon:anImageOrForm toolTipMessage:toolTipMessage
    "WIN32 only: add a tray icon for myself;
     may then receive tray*-events in the future."

    device
         addTrayIconFor:self
         icon:anImageOrForm iconMask:nil
         toolTipMessage:toolTipMessage

    "
     |v icon|

     v := StandardSystemView new.
     v openAndWait.

     icon := Icon stxIcon.
     v addTrayIcon:icon toolTipMessage:'Hi There'
    "

    "Modified: / 05-11-2007 / 12:10:48 / cg"
! !

!TopView methodsFor:'event handling'!

keyPress:key x:x y:y
    "notice: this ought to be moved into the upcoming
     StandardSystemViewController."

    <resource: #keyboard ( #Tab
			   #FocusNext #FocusPrevious
			   #CursorDown #CursorUp ) >

    windowGroup notNil ifTrue:[
	key == #Tab ifTrue:[
	    self sensor shiftDown ifTrue:[
		windowGroup focusPrevious
	    ] ifFalse:[
		windowGroup focusNext
	    ].
	    ^ self.
	].
	(key == #FocusNext or:[key == #CursorDown]) ifTrue:[
	    windowGroup focusNext.
	    ^ self.
	].
	(key == #FocusPrevious or:[key == #CursorUp])  ifTrue:[
	    windowGroup focusPrevious.
	    ^ self.
	].
    ].

    super keyPress:key x:x y:y

    "Created: / 01-02-1996 / 22:08:30 / cg"
    "Modified: / 31-10-2007 / 01:48:50 / cg"
!

showActivity:someMessage
    "some activityNotification shalt be communicated to the user.
     Default for activity notifications here: ignore them"

    ^ self

    "Created: / 16-12-1995 / 18:40:13 / cg"
    "Modified: / 31-10-2007 / 01:48:33 / cg"
!

trayButtonDoubleClick:buttonNr
    "WIN32 only: double-click in the tray.
     Nothing done here - must be redefined in a subclass"

    ^ self

    "Created: / 31-10-2007 / 01:46:27 / cg"
    "Modified: / 05-11-2007 / 12:11:24 / cg"
!

trayButtonPress:buttonNr
    "WIN32 only: button-press in the tray.
     Nothing done here - must be redefined in a subclass"

    ^ self

    "Created: / 31-10-2007 / 01:25:52 / cg"
    "Modified: / 05-11-2007 / 12:11:21 / cg"
!

trayButtonRelease:buttonNr
    "WIN32 only: button-release in the tray.
     Nothing done here - must be redefined in a subclass"

    ^ self

    "Created: / 31-10-2007 / 01:25:55 / cg"
    "Modified: / 05-11-2007 / 12:11:19 / cg"
!

trayMouseMotion
    "WIN32 only: mouse-motion in the tray.
     Nothing done here - must be redefined in a subclass"

    ^ self

    "Created: / 31-10-2007 / 01:25:33 / cg"
    "Modified: / 05-11-2007 / 12:11:17 / cg"
! !

!TopView methodsFor:'event handling-window move'!

doWindowMove
    "a window move operation
     (only used with modeless popup windows; i.e. windows without decoration,
      which want to be moved by click-motion on the background)"

    |delta|

    CurrentWindowBeingMoved == self ifTrue:[
        delta := device pointerPosition - CurrentWindowMoveStart.
        (CurrentWindowMoveState notNil
        or:[ delta r > 5 ]) ifTrue:[
            CurrentWindowMoveState := #inMove.
            CurrentWindowMoveStart := device pointerPosition.
            self origin:(self origin + delta).
        ].
    ].

    "Created: / 03-03-2011 / 19:13:08 / cg"
!

endWindowMove
    "a window move operation
     (only used with modeless popup windows; i.e. windows without decoration,
      which want to be moved by click-motion on the background)"

    CurrentWindowBeingMoved := nil.

    "Created: / 03-03-2011 / 19:17:24 / cg"
!

startWindowMove
    "a window move operation
     (only used with modeless popup windows; i.e. windows without decoration,
      which want to be moved by click-motion on the background)"

    CurrentWindowBeingMoved := self.
    CurrentWindowMoveStart := device pointerPosition.
    CurrentWindowMoveState := nil.

    "Created: / 03-03-2011 / 19:09:39 / cg"
!

startWindowMoveOnButtonPress
    "this allows undecorated windows (i.e. modeless popups) to be moved by
     drag-moving in their window area
     (similar to how mac windows and realplayer are moved).
     Return true here, if a window move should be initiated"

    ^ self isModal not and:[self topView isPopUpView]

    "Created: / 03-03-2011 / 19:30:59 / cg"
! !

!TopView methodsFor:'help'!

flyByHelpDependsOnPositionIn:aView
    "subclasses where the help-text depends upon the pointer position might
     want to redefine this. 
     If true is returned, the tooltip-process will monitor mouse movements and
     ask for the help text again. 
     If false is returned (the default here), it will only look at
     mouse-enter/leave time."

    ^ false
!

flyByHelpSpec
    ^ nil

    "FlyByHelp >> #helpTextFromView:at: calls this method:
        aView topView flyByHelpSpec notNil"
! !

!TopView methodsFor:'help stubs'!

flyByHelpTextFor:aSubView
    "this will vanish - it's temporarily here to allow for stdSysViews to be
     used as a masterApp for dialogs"

    ^ nil
!

helpTextFor:aSubView
    "this will vanish - it's temporarily here to allow for stdSysViews to be
     used as a masterApp for dialogs"

    ^ nil
!

showHelp:aHelpText for:aView
    "dummy - added in case a regular topView is installed
     as a dialog's masterApplication.
     Concrete application subclasses may redefine this to
     display a help text in one of its message areas"
! !

!TopView methodsFor:'initialization & release'!

addToCurrentProject
    "for compatibility with views which can"
!

assignInitialKeyboardFocus
    "assign the initial keyboard focus to a 'useful' component."

    |componentWithInitialFocus|

"/    |keyboardProcessor componentWithInitialFocus|
"/
"/    keyboardProcessor := self keyboardProcessor.
"/    keyboardProcessor notNil ifTrue:[
"/        componentWithInitialFocus := keyboardProcessor componentWithInitialFocus.
"/        componentWithInitialFocus notNil ifTrue:[
"/            self windowGroup focusView:componentWithInitialFocus byTab:true.
"/            "/ componentWithInitialFocus requestFocus.
"/            ^ self.
"/        ]
"/    ].

    (windowGroup notNil
    and:[(componentWithInitialFocus := windowGroup defaultKeyboardConsumer) notNil]) ifTrue:[
        windowGroup focusView:componentWithInitialFocus byTab:true "false".
    ] ifFalse:[
        self assignKeyboardFocusToFirstKeyboardConsumer.
    ].
!

destroy
    "the receiver is to be destroyed - look for partners and slaves"

    |wg dev|

    wg := windowGroup.                  "/ have to fetch windowGroup before;
    dev := device.                      "/ and device ...
    super destroy.                      "/ ... since destroy nils em

"/    dev notNil ifTrue:[
"/        dev flush
"/    ].

    "/
    "/ destroy slaves and partners
    "/
    self masterSlaveMessage:#destroy inGroup:wg

    "Modified: 20.3.1997 / 22:14:16 / cg"
!

initialize
    "initialize the topViews position for the screens center"

    |screenCenter|

    super initialize.
    device initializeTopViewHookFor:self.

    "/ MULTI SCREEN
    screenCenter := device centerOfMonitorHavingPointer.

    left := screenCenter x - (width // 2).
    top := screenCenter y - (height // 2).
    type := 0

    "Modified: / 22-10-2010 / 11:03:00 / cg"
!

postRealize
    super postRealize.

    keyboardProcessor isNil ifTrue:[
        keyboardProcessor := KeyboardProcessor new.
    ].

    device realizedTopViewHookFor:self
!

realize
    self isMarkedAsUnmappedModalBox ifTrue:[
	"/ must clear this flag
	"/ - otherwise realize thinks it is already realized.
	realized := false.
	self unmarkAsUnmappedModalBox.
    ].
    super realize.
!

release
    keyboardProcessor notNil ifTrue:[
	keyboardProcessor release.
	keyboardProcessor := nil.
    ].
    super release
! !

!TopView methodsFor:'misc'!

raiseDeiconified
    "deiconify & bring to front"

    self isCollapsed ifTrue:[
"/        self unmap.
	self realize.
    ].
    self raise

    "
     Transcript topView raiseDeiconified
    "

    "Modified: 3.5.1996 / 23:49:36 / stefan"
!

waitUntilClosed
    "wait until the receiver has been closed.
     Can be used to synchronize multiple-window applications,
     and (especially) to wait until an application session is finished
     when invoking commands with the rDoit mechanism"

    [self drawableId isNil] whileFalse:[
	Delay waitForSeconds:0.1.
    ].

    "asynchronous:

     EditTextView open
    "

    "synchronous:

     EditTextView open topView waitUntilClosed
    "

    "Modified: / 20.5.1998 / 18:03:37 / cg"
!

withCursor:aCursor do:aBlock
    "evaluate aBlock while showing aCursor in all my views.
     Return the value as returned by aBlock."

    windowGroup notNil ifTrue:[
	^ windowGroup withCursor:aCursor do:aBlock
    ].
    ^ super withCursor:aCursor do:aBlock
! !

!TopView methodsFor:'queries'!

beepWhenOpening
    "can be redefined by error and warnBoxes"

    ^ false

    "Modified: / 21-10-2010 / 17:05:08 / cg"
!

heightIncludingBorder
    "return the view's overall-height"

    ^ height
!

isCollapsed
    "ST80 compatibility: return true if the view is not shown (i.e. iconified)"

    "/ ^ device windowIsIconified:drawableId
    ^ shown not

    "Modified: 4.4.1997 / 14:44:39 / cg"
!

isDialogView
    "return true if this is a dialog view"

    type isInteger ifTrue:[
	^ (type bitAnd:WindowTypeMask) == TypeDialog
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ type == #dialog
!

isMDIClientView
    type isInteger ifFalse:[^ false].

    ^ (type bitAnd:MDIClientMask) == MDIClient.

    "Modified: / 03-03-2011 / 20:14:09 / cg"
!

isMaster
    "return true, if this is a masterView"

    type isInteger ifTrue:[
	^ (type bitAnd:MasterSlaveMask) == TypeMaster
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ type == #master
!

isModal
    "return true, if the receiver has been opened modal"

    windowGroup isNil ifTrue:[^ false].
    ^ windowGroup isModal
!

isPartner
    "return true, if this is a partnerView"

    type isInteger ifTrue:[
	^ (type bitAnd:MasterSlaveMask) == TypePartner
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ type == #partner
!

isPopUpView
    "return true if I am a popup view.
     (i.e. I want to come up without any decoration and popUp to top immediately)"

    type isInteger ifTrue:[
	^ (type bitAnd:WindowTypeMask) == TypePopUp
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ type == #popup

    "Created: / 28-02-1997 / 22:12:30 / cg"
    "Modified: / 03-03-2011 / 15:00:35 / cg"
!

isScreenDialog
    "return true if I am a screen dialog view.
     (i.e. I want to come up above all other windows)"

    type isInteger ifTrue:[
	^ (type bitAnd:WindowTypeMask) == TypeScreenDialog
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ false

    "Modified: / 01-12-2010 / 12:15:59 / cg"
!

isSlave
    "return true, if this is a slaveView"

    type isInteger ifTrue:[
	^ (type bitAnd:MasterSlaveMask) == TypeSlave
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ type == #slave
!

isToolDialog
    "return true if I am a toolWindow dialog view.
     (i.e. I want to come up with a smaller window-title area, without minimize and maximize buttons)"

    type isInteger ifTrue:[
	^ (type bitAnd:WindowTypeMask) == TypeToolDialog
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ false

    "Modified: / 03-03-2011 / 14:59:42 / cg"
!

isToolWindow
    "return true if I am a toolWindow view.
     (i.e. I want to come up with a smaller window-title area, without minimize and maximize buttons)"

    type isInteger ifTrue:[
	^ (type bitAnd:WindowTypeMask) == TypeToolWindow
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ false

    "Modified: / 03-03-2011 / 14:59:38 / cg"
!

isTopView
    "return true, since I am a topView"

    ^ true

    "Created: 22.3.1997 / 14:45:55 / cg"
!

isUndecoratedView
    "return true if I am an undecorated view (no minimize, maximize and close buttons)."

    type isInteger ifTrue:[
	^ (type bitAnd:WindowTypeMask) == TypeUndecorated
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ false

    "Modified: / 03-03-2011 / 15:00:22 / cg"
!

preferredExtent
    "return my preferred extent - this is the minimum size I would like to have.
     The default here is the classes default extent,
     however many subclasses redefine this to compute the actual value
     depending on the sizes of the contents or subcomponents."

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
	^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
	^ preferredExtent
    ].
    ^ self class defaultExtent

    "Modified: 19.7.1996 / 20:45:41 / cg"
!

widthIncludingBorder
    "return the view's overall-width"

    ^ width
!

windowStyle
    "return a symbol describing my style which should be one of
     #dialog, #popUp, #undecorated, #normal or #toolWindow.
     This is used by the device as a decoration hint."

    |t|

    type isInteger ifTrue:[
        t := type bitAnd:WindowTypeMask.
        t == TypeUndecorated ifTrue:[^ #undecorated].
        t == TypeDialog ifTrue:[^ #dialog].
        t == TypePopUp ifTrue:[^ #popUp].
        t == TypeToolWindow ifTrue:[^ #toolWindow].
        t == TypeToolDialog ifTrue:[^ #toolDialog].
        t == TypeUndecoratedResizable ifTrue:[^ #dialog].
        t == TypePopUpNonModal ifTrue:[^ #undecorated ].
        ^ #normal
    ].
    "/ the nonInteger handling code is for backward compatibility only.
    ^ super windowStyle
! !

!TopView methodsFor:'realization'!

openModal
    "added bell to wake up user"

    (self beepWhenOpening) ifTrue:[
	self beep.
    ].
    super openModal

    "
     self warn:'hello'
     self information:'hello'
     ModalBox new openModal
     WarningBox new openModal
     InfoBox new openModal
    "

    "Modified: 28.5.1996 / 16:59:01 / cg"
! !

!TopView methodsFor:'show & hide'!

activate
    "added for MS-windows - much like raise.
     Raise/Activate seem to work only within my own (ST/X)-windows;
     they do not raise one of my views above another (for example: command.com)-window.
     Can anyone tell me what the difference between raise, activate and setForeground
     really is (I mean really - not what is written in the crappy documentation)"

    |id|

    (id := self drawableId) isNil ifTrue:[
        self create.
        id := self drawableId
    ].
    device 
        activateWindow:id;
        focusView:self

    "
     Transcript topView activate
    "
!

fixPosition:aPoint
    "set origin to aPoint, but make sure, that the box is fully visible
     by shifting it into the visible screen area if nescessary.
     This prevents invisible modalBoxes (which you could never close)."

    self origin:aPoint.
    self makeFullyVisible

    "Created: 28.2.1997 / 16:39:31 / cg"
!

hide
    |masterGroup myApplication|

    realized ifFalse:[^ self].

    "/ if I am a modal-opened application's view
    "/ (for example, an UIPainter) give it a chance
    "/ to intercept the hide.
    "/ Q: shouln't this be done in the windowGroup,
    "/ by sending a closerequest always and letting popUps
    "/ respond by hiding ???

    (windowGroup notNil
    and:[ windowGroup isModal ]) ifTrue:[
	masterGroup := windowGroup previousGroup.
	myApplication := self application.

	(myApplication notNil
	and:[ masterGroup isNil or:[myApplication ~= masterGroup application]]) ifTrue:[
	    AbortOperationRequest handle:[:ex |
		"/ in case the close is caught by the application
		^ self.
	    ] do:[
		myApplication closeRequest.

		"/ if myApp called closeDownViews, it wants me to hide.
		"/ otherwise, it has redefined closeRequest to return without closeDownViews.
		realized ifTrue:[
		    "/ closeDownViews was not called - app wants me to remain open
		    ^ self
		].
	    ].
	].
    ].
    super hide.
!

map
    "make the view visible on the screen.
     For topViews, the windowManager will choose (or ask for) the
     views position on the screen.
     Notice:
	Actually, this method is only valid for topViews;
	however, it is defined here to allow things like 'Button new realize'"

    self mapAt:(self origin) iconified:false
!

mapIconified
    "make the view visible but iconified.
     In contrast to map, which does it non-iconified"

    realized ifFalse:[
        "
         now, make the view visible
        "
        realized := true.
        device
            mapView:self id:self drawableId iconified:true
            atX:left y:top width:width height:height
            minExtent:(self minExtent) maxExtent:(self maxExtent)
    ]

    "Modified: 25.2.1997 / 22:44:33 / cg"
    "Created: 24.7.1997 / 12:48:21 / cg"
!

positionOffset
    "return the delta, by which the box should be
     displaced from the mouse pointer.
     Here, the boxes center is returned as a default.
     Usually redefined in subclasses to have the most convenient
     ok-button appear under the pointer."

    ^ self extent // 2

    "Created: 28.2.1997 / 22:56:34 / cg"
!

setForegroundWindow
    "make a window the foreground window (so raise and activate it).
     Under Win 98/Me/XP/2000 the window is not raised/activated, if a window from
     a different process is currently active - in this case the title bar/icon is flashed.
     this also raises the priority of the sending thread slightly.

     Mark a TopView as #beScreenDialog, to send this on open."

    self drawableId isNil ifTrue:[self create].
    device setForegroundWindow:self drawableId

    "
     Transcript topView raise
     Transcript topView setForegroundWindow
    "
! !

!TopView methodsFor:'startup'!

openAt:aPosition transientFor:anotherView
    "force the view to be opened at some position on the screen
     AND tell the windowManager to NOT let the user choose a position
     (i.e. suppress any ghostframe).
     The view is marked as being a transient (i.e. pop-up) view for
     anotherView - it will deiconify with it and (on some windowManagers)
     have no iconify button of its own.
     Notice, that its up to the windowManager to care for any borders -
     it seems not deterministic, where the view actually ends up being positioned.
     Not all windowManagers (olwm) honor this - some insist on it ..."

    <resource: #obsolete>

    |otherId|

    self obsoleteMethodWarning.

    self drawableId isNil ifTrue:[self create].
    anotherView isNil ifTrue:[
        otherId := self drawableId.
    ] ifFalse:[
        anotherView create.
        otherId := anotherView id.
    ].
    device setTransient:self drawableId for:otherId.
    self origin:aPosition.
    self open

    "
     |v1 v2|

     v1 := StandardSystemView extent:300@300.
     v2 := StandardSystemView extent:300@300.
     v1 open.
     v2 openAt:0@0 transientFor:v1.
    "

    "
     |v1|

     v1 := StandardSystemView extent:300@300.
     v1 openAt:0@0 transientFor:v1.
    "

    "Created: 28.6.1996 / 10:51:55 / cg"
    "Modified: 28.7.1997 / 18:53:16 / cg"
!

openDisplayAt:aPoint
    "ST-80 compatibility: open the view centered around aPoint"

    ^ self openModelessAt:(aPoint - (self extent//2))

    "
     (TopView new extent:200@200) openDisplayAt:300@300
    "
!

openIconified
    "open the view in iconified state"

    self openModelessAt:nil iconified:true

    "
     FileBrowser new openIconified
     ChangesBrowser new openIconified
    "

    "Modified: 24.7.1997 / 14:54:58 / cg"
!

openIn:aBoundaryRectangle
    "set origin & extent and open.
     The given extent overrides the receiver's preferredExtent.
     Added for ST-80 compatibility"

    self
        origin:aBoundaryRectangle origin;
        extent:aBoundaryRectangle extent;
        sizeFixed:true.
    self open

    "Modified: 12.2.1997 / 11:58:21 / cg"
!

openTransientAt:aPosition
    "force the view to be opened at soem position on the screen
     AND tell the windowManager to NOT let the user choose a position
     (i.e. suppress any ghostframe).
     Notice, that its up to the windowManager to care for any borders -
     it seems not deterministic, where the view actually ends up being positioned.
     Not all windowManagers (olwm) honor this - some insist on it ..."

    <resource: #obsolete>
    self obsoleteMethodWarning.
    self openAt:aPosition transientFor:nil

    "normal open:

     |v|

     v := StandardSystemView extent:300@300.
     v open
    "

    "open at position:

     |v|

     v := StandardSystemView extent:300@300.
     v openTransientAt:10@10
    "

    "Created: 28.6.1996 / 10:52:30 / cg"
    "Modified: 28.6.1996 / 10:55:15 / cg"
!

openWithExtent:anExtent
    "set extent and open. The given extent overrides the
     receiver's preferredExtent.
     Added for ST-80 compatibility"

    self extent:anExtent; sizeFixed:true.
    self open
!

openWithPriority:aPriority
    "open the view, run the windowgroup process at
     other than UserScehdulingPriority."

    self open.
    windowGroup process priority:aPriority.

    "Created: 30.4.1996 / 15:34:44 / cg"
! !

!TopView methodsFor:'window events'!

mapped
    "the receiver was mapped (i.e. deiconified);
     look for partners and slaves."

    realized := true.
    super mapped.

    "/
    "/ map slaves and partners
    "/
    self masterSlaveMessage:#remap inGroup:windowGroup.

    self isModal ifTrue:[
        "take it away from any popup menu possibly still active"

        self forceUngrabKeyboard.
        self forceUngrabPointer.
        "
         get the focus
        "
        self getKeyboardFocus.
        self enableEnterLeaveEvents
    ] ifFalse:[
        "
         ask for the focus - this avoids having to click on the
         view with WM's which need an explicit click.
         Q: is this a good idea ?
        "
        TakeFocusWhenMapped == true ifTrue:[
            self getKeyboardFocus.
        ]
    ].
    device isWindowsPlatform ifTrue:[
        self raise
    ].
    false "self isScreenDialog" ifTrue:[
        self setForegroundWindow.
        self activate.
    ].
    subViews notNil ifTrue:[
        subViews do:[:eachSubView | eachSubView topViewWasMapped ].
    ]

    "Modified: / 09-12-2010 / 18:13:20 / cg"
!

masterSlaveMessage:aSelector inGroup:aWindowGroup
    "send aSelector to partners and/or slaves.
     This is a private helper for destroy / mapped / unmapped"

    aWindowGroup notNil ifTrue:[
	"/
	"/ if I am a master or partner, send to all slaves
	"/
	(self isMaster or:[self isPartner]) ifTrue:[
	    aWindowGroup slavesDo:[:v | v perform:aSelector].
	].
	"/
	"/ if I am a partner, send to all partners
	"/
	self isPartner ifTrue:[
	    aWindowGroup partnersDo:[:v | v ~~ self ifTrue:[v perform:aSelector]].
	].
    ].
!

unmapped
    "the receiver was unmapped (i.e. iconified);
     look for partners and slaves."

    |r|

    (windowGroup notNil and:[windowGroup isModal]) ifTrue:[
        "keep the realized flag true (to avoid exiting the modal event loop).
         Consider this a kludge."
        self markAsUnmappedModalBox.
        r := realized.
    ] ifFalse:[
        self unmarkAsUnmappedModalBox.
        r := realized := false.
    ].
    super unmapped.
    realized := r.

    "/
    "/ unmap slaves and partners
    "/
    self masterSlaveMessage:#unmap inGroup:windowGroup

    "Modified: 30.5.1996 / 09:37:22 / cg"
! !

!TopView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


TopView initialize!

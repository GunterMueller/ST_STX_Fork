"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

DisplaySurface subclass:#DisplayRootView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Special'
!

!DisplayRootView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    this class describes the rootWindow (which is the background window or
    desktop and can be used for drawing outside of Views
    i.e. for dragging between Views).

    For historic and compatibility reasons, there is a global variable
    called 'RootView', which is bound to the default displays ('Display')
    rootview. We recommend, not to access this variable, instead, get a
    displays rootView via the #rootView message (sent to the device).
    Otherwise, your application will not work in a multiScreen environment.

    Instances of myself (i.e. these rootViews) are light-weight views;
    they do not support events, models etc.
    They are pure drawing canvases and should be only used for special
    applications (i.e. dragging).
    There may be display systems in which rootViews are not
    supported/allowed implemented. So be VERY careful when using them.

    Be aware, that the rootView is not always visible - some
    windowManagers install another (pseudoRoot), into which icons and
    windowManager menus are drawn. If that is the case, your paining
    into the rootView may not be visible, unless you set the #noClipByChildren
    option (see below).
    Also, it is not guaranteed, that all devices support drawing in the
    root window - especially if the device is a simulated one, such as
    a remote webBrowser ...
    In general, you should never use the rootView for normal applications.

    To draw in the (Displays) root window:

        |rootView|

        rootView := Screen current rootView.
        rootView paint:(Color red).
        rootView fillRectangleX:10 y:10 width:100 height:100.

    of course, all stuff from View and its superclasses can be used:

        |rootView|

        rootView := Screen current rootView.
        rootView paint:(Color red).
        rootView noClipByChildren.
        rootView fillRectangleX:10 y:10 width:100 height:100.


    [author:]
        Claus Gittinger
"
!

!DisplayRootView class methodsFor:'instance creation'!

onDevice:aDisplay
    "since there is only one RootView - catch new and return
     the one and only rootView."

    aDisplay == Display ifTrue:[
        RootView notNil ifTrue:[
            RootView device == aDisplay ifTrue:[
                ^ RootView
            ]
        ].
        RootView := super onDevice:aDisplay.
        ^ RootView
    ].
    ^ super onDevice:aDisplay

    "Created: 18.1.1997 / 18:23:22 / cg"
! !

!DisplayRootView methodsFor:'accessing'!

application
    ^ nil
!

model
    ^ nil
!

name
    "return my name - always 'RootWindow'"

    ^ 'RootWindow'
!

subViews
    "return the collection of subviews - none here"

    ^ #()


!

uuid
    "return my uuid - always the same here.
     TODO: think what happens with multiple screens..."

    ^ UUID readFrom:'31be9300-41fc-11dd-b99f-001558137da0'  "/ do not change - ask cg if you don't know why
! !

!DisplayRootView methodsFor:'destroying'!

destroy
    "catch destroy - some windowmanagers get confused if
     we destroy the rootWindow if its a virtual root window"

    ^ self
! !

!DisplayRootView methodsFor:'dummy'!

keyboardZoom:larger
    "/ MUST be ignored here
!

redrawX:x y:y width:width height:height
    "ignored"
! !

!DisplayRootView methodsFor:'hotkeys'!

addHotKeyHandler:handler forKey:aKey modifierMask:optionalModifierMaskOrNil
    "install a handler (which should implement keyPress:x:y:view:
     and keyRelease:x:y:view: on aKey.
     aKey should be a symbolic key (like #F2).
     modifierMask may constraint the key to be only handled when a certain
     modifier is pressed (use a bitOr combination of device ctrlModifierMask,
     altModifierMask etc.) or nil, so the key is always treated as a hotkey"

    self sensor addEventListener:handler.
    self device
        grabKey:aKey
        modifier:optionalModifierMaskOrNil
        window:self.

    "
     Display rootView sensor removeAllEventListeners.

     Display rootView
        addHotKeyHandler:[:ev |
Transcript showCR:ev.
            ev key = 'F3' ifTrue:[
                Dialog information:'YES!!'.
            ].
            false.
        ]
        forKey:'F3'
        modifierMask:nil
    "
!

removeHotKeyHandler:handler forKey:aKey modifierMask:optionalModifierMaskOrNil
    "install a handler (which should implement keyPress:x:y:view:
     and keyRelease:x:y:view: on aKey.
     aKey should be a symbolic key (like #F2).
     modifierMask may constraint the key to be only handled when a certain
     modifier is pressed (use a bitOr combination of device ctrlModifierMask,
     altModifierMask etc.) or nil, so the key is always treated as a hotkey"

    self sensor removeEventListener:handler.
    self device
        ungrabKey:aKey
        modifier:optionalModifierMaskOrNil
        window:self.

    "
    "
! !

!DisplayRootView methodsFor:'initialization & release'!

initialize
    |dev|

    super initialize.

    dev := self device.
    width := dev width.
    height := dev height.
    self createRootWindow.
    realized := true.
!

reinitialize
    "reinit after snapin"

    self recreate.
    self createRootWindow.
    width := device width.
    height := device height.
    realized := true.
! !

!DisplayRootView methodsFor:'queries'!

canDropObjects:aCollectionOfDropObjects
    "return true, if aCollectionOfDropObjects can be
     dropped in the receiver.
     False is returned here, since nothing can be dropped on the desktop.
     (for now - actually some systems do allow dropping things on the desktop
      and this query should be forwarded to my display device)"

    ^ false

    "Created: / 13-10-2006 / 15:55:54 / cg"
!

isActive
    "for protocol compatibility with regular views"

    ^ false.
!

isComponentOf: aView
    ^ false
!

isRootView
    "return true, since yes, I am a rootview"

    ^ true

    "Created: 5.7.1996 / 13:48:24 / cg"
    "Modified: 5.7.1996 / 14:57:44 / cg"
!

isSameOrComponentOf:aView
    "return true, if I am aView or a (direct or indirect) component of aView"

    ^ self == aView
!

isWindowManagerRunning
    "answer true, if a window manager is currently running.
     This is done by performing an action (enabling button events of
     root window), which will fail if a window manager is running."

    device isWindowsPlatform ifTrue:[^ true].
    device class deviceErrorSignal handle:[:ex |
        ^ false.
    ] do:[
        self enableButtonEvents.
        self flush.
    ].
    ^ true

    "
     DisplayRootView new
     RootView isWindowManagerRunning
    "
! !

!DisplayRootView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


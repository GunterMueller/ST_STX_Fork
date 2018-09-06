"
COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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

GraphicsDevice subclass:#HostGraphicsDevice
	instanceVariableNames:'graphicsContexts deviceColors deviceFonts deviceCursors'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Graphics'
!

!HostGraphicsDevice class methodsFor:'documentation'!

copyright
"
COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    this abstract class was inserted to provide a home for ST-80 classes
    (previously, DeviceWorkstation was directly under Object).
    We will (over time) move common functionality from there into this class.

    In ST/X, this is mostly dummy.

    [see also:]
	DeviceWorkstation XWorkstation

    [author:]
	Claus Gittinger
"


! !

!HostGraphicsDevice methodsFor:'Compatibility-Squeak'!

deferUpdates: aBoolean
    "Set the deferUpdates flag in the virtual machine. 
     When this flag is true, BitBlt operations on the Display are not 
     automatically propagated to the screen. 
     If this underlying platform does not support deferred updates, 
     this primitive will fail. 
     Answer the receiver if the primitive succeeds, nil if it fails."

"/    <primitive: 126>
    ^ nil  "answer nil if primitive fails"

!

forceDisplayUpdate
    "On platforms that buffer screen updates, 
     force the screen to be updated immediately. 
     On other platforms, or if the primitive is not implemented, do nothing."

"/     <primitive: 231>
    "do nothing if primitive fails"
! !

!HostGraphicsDevice methodsFor:'accessing'!

deviceColors
    "return the registry keeping track of colors which were allocated
     on this device."

    ^ deviceColors ? #()

    "Created: / 24-02-1997 / 18:01:41 / cg"
!

deviceCursors
    "return the registry keeping track of cursors which were allocated
     on this device."

    ^ deviceCursors

    "Created: 24.2.1997 / 18:01:41 / cg"
!

deviceFonts
    "return the registry keeping track of fonts which were allocated
     on this device."

    ^ deviceFonts ? #()

    "Modified: / 28-07-2006 / 19:48:23 / fm"
!

graphicsContexts
    "return the registry keeping track of graphics contexts which were allocated
     on this device."

    ^ graphicsContexts
! !

!HostGraphicsDevice methodsFor:'accessing & queries'!

defaultExtentForTopViews
    |w h|

    w := self width.
    h := self height.

    self isPDA ifTrue:[
        ^ (w - 16) @ (h - 20)
    ].
    ^ (w // 3 * 2) @ (h // 3 * 2)
! !

!HostGraphicsDevice methodsFor:'initialization & release'!

initializeDeviceResourceTables
    graphicsContexts := Registry new.
    deviceColors := Registry new.
    deviceCursors := Registry new.
    deviceFonts := CachingRegistry new:50.

    "Created: 24.2.1997 / 18:29:53 / cg"
!

releaseDeviceColors
    deviceColors notNil ifTrue:[
        deviceColors do:[:aColor |
            aColor releaseFromDevice
        ].
        deviceColors := Registry new.

        "TrueColors are not registered.
         Release them the hard way"
        Color flushDeviceColorsFor:self.
    ].

    "Created: 24.2.1997 / 18:07:49 / cg"
!

releaseDeviceCursors
    deviceCursors notNil ifTrue:[
        deviceCursors do:[:aCursor |
            aCursor releaseFromDevice
        ].
        deviceCursors := Registry new.
    ]

    "Created: 24.2.1997 / 18:07:49 / cg"
!

releaseDeviceFonts
    deviceFonts notNil ifTrue:[
        deviceFonts do:[:aFont |
            aFont releaseFromDevice.
        ].
        deviceFonts := CachingRegistry new:20.
    ].
!

releaseGraphicsContexts
    graphicsContexts notNil ifTrue:[
        graphicsContexts unregisterAllForWhichHandle:[:eachHandle |
            eachHandle finalize. 
            true
        ].
    ]
! !

!HostGraphicsDevice methodsFor:'misc'!

recolorCursorsToFgColor:fgColor defaultBgColor:bgColor
    "change the colors of all existing cursors"

    "/ recolor existing cursors
    deviceCursors do:[:eachCursor | eachCursor foreground:fgColor background:bgColor].

    "
     Display recolorCursorsToFgColor:(Color red) defaultBgColor:(Color white)

     Display recolorCursorsToFgColor:(Color blue) defaultBgColor:(Color white)
     Display recolorCursorsToFgColor:(Color blue) defaultBgColor:(Color black)
     Display recolorCursorsToFgColor:(Color white) defaultBgColor:(Color black)
     Display recolorCursorsToFgColor:(Color white) defaultBgColor:(Color red)
    "
! !

!HostGraphicsDevice methodsFor:'registration'!

cleanupLobbyForChildrenOfViewWithId:anId
    "recursively clean all the subcomponents of the handle with id anId.
     This must be done on finalization, because descendent handles
     are destroyed implicitly when a parent handle is destroyed."

    |parents newChildren|

    parents := Array with:anId address.

    [
        newChildren := Set new.
        graphicsContexts unregisterAllForWhichHandle:[:handle |
            |parentId|

            handle notNil
                and:[(parentId := handle parentId) notNil
                and:[(parents includes:parentId)
                and:[newChildren add:handle id. true]]].
        ].
        parents := newChildren.
    ] doWhile:[parents notEmpty].
!

registerColor:aColor
    deviceColors register:aColor.

    "Created: 24.2.1997 / 18:29:10 / cg"
!

registerCursor:aCursor
    deviceCursors register:aCursor.

    "Created: 24.2.1997 / 18:29:10 / cg"
!

registerFont:aFont
    deviceFonts register:aFont.

    "Created: 24.2.1997 / 18:29:10 / cg"
!

registerGraphicsContext:aGC 
    graphicsContexts register:aGC
!

unregisterColor:aColor
    deviceColors unregister:aColor.

    "Created: 24.2.1997 / 18:29:14 / cg"
!

unregisterCursor:aCursor
    deviceCursors unregister:aCursor.

    "Created: 24.2.1997 / 18:29:14 / cg"
!

unregisterFont:aFont
    deviceFonts unregister:aFont.

    "Created: 24.2.1997 / 18:29:14 / cg"
!

unregisterGraphicsContext:aGC
    graphicsContexts unregister:aGC
! !

!HostGraphicsDevice class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


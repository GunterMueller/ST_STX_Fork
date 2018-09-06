"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

DisplayObject subclass:#VisualComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!VisualComponent class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    abstract superclass for all kinds of visual components.
    This class and its subclasses (currently) exist mostly for
    ST-80 compatibility - to provide a home for ported PD classes,
    which depend on the VisualComponent hierarchy.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.
        This is still being constructed - not yet finished.

    [author:]
        Claus Gittinger

    [see also:]
        GeometricWrapper
"

! !

!VisualComponent class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!VisualComponent class methodsFor:'queries'!

defaultFont
    ^ SimpleView defaultFont

    "Created: / 18.6.1998 / 16:14:22 / cg"
!

defaultViewBackgroundColor
    ^ SimpleView defaultViewBackgroundColor

    "Created: / 18.6.1998 / 16:15:17 / cg"
! !

!VisualComponent methodsFor:'accessing'!

backgroundColor
    ^ Color white

    "Created: / 18.6.1998 / 16:01:00 / cg"
!

backgroundColor:aColor
    "ignored here"

    "Created: / 18.6.1998 / 16:15:28 / cg"
!

container:someContainer
    "ignored here"

    "Created: 9.5.1996 / 00:48:54 / cg"
!

defaultFont
    ^ SimpleView defaultFont

    "Created: / 18.6.1998 / 16:13:56 / cg"
!

font:aFont
    "ignored here"

    "Created: / 18.6.1998 / 16:14:39 / cg"
!

foregroundColor
    ^ Color black

    "Created: / 18.6.1998 / 16:01:07 / cg"
!

foregroundColor:aColor
    "ignored here"

    "Created: / 18.6.1998 / 16:14:53 / cg"
!

geometryLayout
    "ignored here"

    ^ nil
!

geometryLayout:aLayout
    "ignored here"

    "Created: / 18.6.1998 / 16:15:39 / cg"
!

hiddenOnRealize:aBoolean
    "ignored here"

    "Created: / 18.6.1998 / 16:13:19 / cg"
!

id
    "ignored here"

    ^ nil

    "Created: / 18.6.1998 / 16:13:34 / cg"
!

setParentViewIn:aView
    "ignored here - for now"

    "Created: 9.5.1996 / 00:19:39 / cg"
!

superView
    ^ self container

    "Created: / 18.6.1998 / 16:16:07 / cg"
! !

!VisualComponent methodsFor:'accessing-STX-attributes'!

application
    ^ self container application

    "Created: / 19.11.1999 / 17:44:38 / cg"
!

borderWidth
    ^ 0

    "Modified: / 6.7.1998 / 13:47:28 / cg"
!

borderWidth:aNumber
    ^ 0

    "Modified: / 6.7.1998 / 13:47:28 / cg"
!

canTab:aBoolean

    "Modified: / 6.7.1998 / 13:46:17 / cg"
    "Created: / 6.7.1998 / 13:48:35 / cg"
!

layout
    ^ self geometryLayout
!

layout:newLayout
    self geometryLayout:newLayout
!

level
    ^ 0

    "Modified: / 6.7.1998 / 13:46:17 / cg"
    "Created: / 6.7.1998 / 13:46:50 / cg"
!

level:newLevel

    "Modified: / 6.7.1998 / 13:46:17 / cg"
    "Created: / 6.7.1998 / 13:47:43 / cg"
!

name
    ^ self printString
!

realized
    "return true, if the receiver is realized.
     Realized means that it has been mapped (i.e. made visible) on
     the display (as opposed to being only created and possibly invisible)"

    ^ true
!

viewBackground
    ^ self backgroundColor
! !

!VisualComponent methodsFor:'accessing-dimensions'!

bottom
    "return my bottom y coordinate"

    ^ self bounds bottom

    "Modified: 9.5.1996 / 00:13:12 / cg"
    "Created: 26.5.1996 / 12:56:12 / cg"
!

bounds
    "return my bounds"

    frame isNil ifTrue:[
        self computeBoundingBox.
    ].
    ^ frame
!

bounds:aRectangle
    "set my bounds"

    self assert:aRectangle notNil.
    frame := aRectangle
!

defaultExtent
    ^ 50@50
!

extent:anExtent
    "set my extent"

    frame := self frame copy extent:anExtent
!

left
    "return my left x coordinate"

    ^ self bounds left

    "Created: 8.5.1996 / 23:36:07 / cg"
    "Modified: 26.5.1996 / 12:56:22 / cg"
!

origin:newOrigin
    "move my origin"

    |oldFrame|

    oldFrame := self frame.
    oldFrame isNil ifTrue:[
        oldFrame := 0@0 extent:(self defaultExtent).
    ].

    frame := newOrigin copy extent:(oldFrame extent).

    "Created: 8.5.1996 / 23:36:07 / cg"
    "Modified: 9.5.1996 / 00:13:12 / cg"
!

preferredBounds
    "return my preferredBounds"

    ^ 0@0 extent:100@100

    "Created: 8.5.1996 / 23:36:29 / cg"
    "Modified: 19.7.1996 / 20:06:28 / cg"
!

preferredExtent
    ^ self preferredBounds extent

    "Modified: 9.5.1996 / 00:13:22 / cg"
    "Created: 19.7.1996 / 20:06:19 / cg"
!

right
    "return my right x coordinate"

    ^ self bounds right

    "Modified: 9.5.1996 / 00:13:12 / cg"
    "Created: 26.5.1996 / 12:56:25 / cg"
!

top
    "return my top y coordinate"

    ^ self bounds top

    "Modified: 9.5.1996 / 00:13:12 / cg"
    "Created: 26.5.1996 / 12:56:15 / cg"
!

viewRectangle
    ^ self bounds

    "Created: 19.7.1996 / 17:24:58 / cg"
! !

!VisualComponent methodsFor:'accessing-mvc'!

model
    "return nil - generic components have no model"

    ^ nil

    "Created: 5.6.1996 / 14:18:16 / cg"
! !

!VisualComponent methodsFor:'change & update'!

changedPreferredBounds: oldPreferredBoundsOrNil
    "The receiver is notifying any dependents that its preferredBounds has changed."

    self changed: #preferredBounds with: oldPreferredBoundsOrNil
! !

!VisualComponent methodsFor:'displaying'!

displayOn:aGCOrStream
    "display the receiver on some graphicsContext. 
     The sender is repsonsible for restoring the GC's state
     (i.e. it may be left in any undefined state)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        self printOn:aGCOrStream.
        ^ self
    ].
    self subclassResponsibility

    "Modified: / 10-02-1997 / 13:53:03 / cg"
    "Modified: / 11-09-2006 / 15:01:06 / User"
!

displayOn:aGC at:aPoint
    "display the receiver translated by some amount on some graphicsContext"

    |oldTranslation|

    oldTranslation := aGC translation.
    aGC translateBy:aPoint.
    self displayOn:aGC.
    aGC translation:oldTranslation

    "Created: 10.2.1997 / 13:47:18 / cg"
    "Modified: 10.2.1997 / 13:52:53 / cg"
!

displayOn:aGC x:x y:y
    "display the receiver translated by some amount on some graphicsContext"

    ^ self displayOn:aGC at:(x @ y).

    "Modified: 10.2.1997 / 13:52:57 / cg"
! !

!VisualComponent methodsFor:'event handling'!

buttonPress:button x:x y:y
    "button was pressed over me - ignored here"

    "Modified: 9.5.1996 / 00:14:08 / cg"
!

buttonRelease:button x:x y:y
    "button was released over me - ignored here"

    "Created: 8.5.1996 / 23:38:30 / cg"
    "Modified: 9.5.1996 / 00:14:04 / cg"
!

containerChangedSize

    "Created: 19.7.1996 / 17:32:19 / cg"
!

containerMapped

    "Created: 19.7.1996 / 17:39:27 / cg"
!

containerUnmapped

    "Created: 19.7.1996 / 17:44:52 / cg"
!

destroy

    "Created: 19.7.1996 / 17:25:46 / cg"
!

hasKeyboardFocus:aBoolean
    "notification from the windowGroup that I got the keyboardFocus."

    ^ self

    "Created: / 6.7.1998 / 13:49:12 / cg"
!

keyPress:key x:x y:y
    "key was pressed over me - ignored here"

    "Created: 8.5.1996 / 23:46:03 / cg"
    "Modified: 9.5.1996 / 00:14:14 / cg"
!

keyRelease:key x:x y:y
    "key was released over me - ignored here"

    "Created: 8.5.1996 / 23:46:07 / cg"
    "Modified: 9.5.1996 / 00:14:19 / cg"
!

mapped

    "Created: / 6.7.1998 / 13:48:46 / cg"
!

showFocus:explicit

    "Created: / 6.7.1998 / 13:49:05 / cg"
!

showNoFocus:explicit

    "Created: / 6.7.1998 / 13:49:12 / cg"
! !

!VisualComponent methodsFor:'initialization'!

initialize

    "Modified: 10.2.1997 / 19:28:11 / cg"
!

resize
    self extent:(self preferredExtent)

    "Created: / 25-07-2011 / 17:24:08 / cg"
! !

!VisualComponent methodsFor:'queries'!

delegate
    ^ nil

    "Created: / 6.7.1998 / 13:50:10 / cg"
!

heightOn:aGC
    "return my height, if displayed on aGC;
     I assume that my height is independent of the device, and return
     the bounds height"

    ^ self bounds height

    "Modified: 13.5.1996 / 10:15:13 / cg"
!

isBorderedWrapper
     ^ false

    "Created: 5.6.1996 / 14:11:18 / cg"
!

isCursorKeyConsumer
    "return true, if the receiver can be controlled by cursor keys;
     i.e. it can handle some keyboard input,
     isCursorKeyConsumer are potential candidates for getting the keyboard
     focus initially within dialogBoxes, or when the focus-follows-pointer
     mode is off."

     ^ false
!

isExternalTopView
    ^ false

    "Created: / 6.7.1998 / 13:50:01 / cg"
!

isInputField
     ^ false

    "Created: 19.7.1996 / 17:50:59 / cg"
!

isKeyboardConsumer
     ^ false

    "Created: 19.7.1996 / 17:50:59 / cg"
!

isLayoutWrapper
     ^ false

    "Created: 19.7.1996 / 17:50:59 / cg"
!

isRootView
    ^ false

    "Created: / 6.7.1998 / 13:50:01 / cg"
!

isTransparentBox
     ^ false

    "Created: 19.7.1996 / 17:50:59 / cg"
!

isWrapper
     ^ false

    "Created: 5.6.1996 / 01:04:40 / cg"
!

widthOn:aGC
    "return my width, if displayed on aGC;
     I assume that my width is independent of the device, and return
     the bounds width"

    ^ self bounds width

    "Created: 13.5.1996 / 10:14:44 / cg"
    "Modified: 13.5.1996 / 10:15:17 / cg"
! !

!VisualComponent methodsFor:'testing'!

containsPoint:aPoint
    "return true, if the receiver contains aPoint"

    ^ self bounds containsPoint:aPoint

    "Created: 9.5.1996 / 00:21:44 / cg"
    "Modified: 9.5.1996 / 00:22:00 / cg"
!

hasBorder
    "return true, if the receiver shows a border"

    ^ false

    "Modified: 9.5.1996 / 00:21:29 / cg"
!

intersects:aRectangle
    "return true, if the receiver's bounds intersects aRectangle"

    ^ self bounds intersects:aRectangle

    "Created: 9.5.1996 / 00:21:18 / cg"
    "Modified: 9.5.1996 / 00:22:04 / cg"
! !

!VisualComponent class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


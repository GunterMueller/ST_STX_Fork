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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DisplayObject
	instanceVariableNames:'frame'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!DisplayObject class methodsFor:'documentation'!

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
    generic superclass for Display Objects held in ObjectViews
    see DrawObject/LogicObject/DeskTopObject and subclasses for example uses.

    [author:]
        Claus Gittinger
"
! !

!DisplayObject class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!DisplayObject class methodsFor:'behavior'!

dragDashedOutline
    "if true, outline dragging is done by drawing the line dashed.
     if false, the outline is drawn solid.
     Can be redefined in subclasses (for solid outline)."

    ^ true

    "Created: 28.3.1997 / 16:21:56 / cg"
    "Modified: 28.3.1997 / 16:40:54 / cg"
!

dragOutline
    "if true, dragging is done by drawing outline only;
     if false, dragging is done by full draw (fast servers only).
     Can be redefined in subclasses (for full dragging)"

    ^ true

    "Modified: 28.3.1997 / 16:40:44 / cg"
! !

!DisplayObject methodsFor:'ST-80 drawing'!

displayOn:aDisplayMedium at:aPoint 
    "for ST-80 compatibility; not used in ST/X"

    self displayOn:aDisplayMedium 
                at:aPoint 
       clippingBox:nil 
              rule:#copy
              mask:nil

    "Modified: 12.5.1996 / 20:19:15 / cg"
!

displayOn:aDisplayMedium at:aPoint clippingBox:clipRectangle
    "for ST-80 compatibility; not used in ST/X"

    ^ self displayOn:aDisplayMedium 
                  at:aPoint 
         clippingBox:clipRectangle 
                rule:#copy
                mask:nil

    "Modified: 12.5.1996 / 20:19:17 / cg"
!

displayOn:aDisplayMedium at:aPoint clippingBox:clip rule:rule mask: aForm
    "for ST-80 compatibility; not used in ST/X.
     in ST-80 programs, this is redefined"

    aDisplayMedium function:rule.
    ^ self drawIn:aDisplayMedium at:(aPoint + self origin)

    "Modified: 12.5.1996 / 20:19:27 / cg"
!

displayOn:aDisplayMedium x:x y:y 
    self 
        displayOn:aDisplayMedium
        at:(x @ y)
        clippingBox:nil
        rule:#copy
        mask:nil

    "Modified: 12.5.1996 / 20:19:15 / cg"
    "Created: 12.5.1996 / 20:20:09 / cg"
! !

!DisplayObject methodsFor:'accessing'!

bottom
    ^ self frame bottom
!

bottomCenter
    ^ self frame bottomCenter
!

bottomLeft
    ^ self frame bottomLeft
!

bottomRight
    ^ self frame bottomRight
!

bounds
    "ST80 component compatibility"

    ^ self frame.
!

corner
    "return the frame corner"

    frame isNil ifTrue:[
        self computeBoundingBox
    ].
    ^ frame corner
!

extent
    "return the extent of the frame"

    frame isNil ifTrue:[
        self computeBoundingBox
    ].
    ^ frame extent
!

frame
    "object must return a frame boundary rectangle"

    frame isNil ifTrue:[
        self computeBoundingBox
    ].
    ^ frame
!

height
    "return the height of the frame"

    frame isNil ifTrue:[
        self computeBoundingBox
    ].
    ^ frame height
!

heightOn:aGC
    "return the height of the frame if drawon on aCG"

    ^ self height

    "Created: 12.5.1996 / 20:20:54 / cg"
!

left
    ^ self frame left

    "Created: / 26-10-2006 / 18:08:42 / cg"
!

leftCenter
    ^ self frame leftCenter
!

origin
    "return the frame origin"

    frame isNil ifTrue:[
        self computeBoundingBox
    ].
    ^ frame origin
!

origin:origin
    "object must calculate its dimension from outline"

    ^ self subclassResponsibility
!

origin:origin corner:corner
    "object must calculate its dimension from outline"

    ^ self subclassResponsibility
!

right
    ^ self frame right
!

rightCenter
    ^ self frame rightCenter
!

top
    ^ self frame top
!

topCenter
    ^ self frame topCenter
!

topLeft
    ^ self frame topLeft
!

topRight
    ^ self frame topRight
!

width
    "return the width of the frame"

    frame isNil ifTrue:[
        self computeBoundingBox
    ].
    ^ frame width
!

widthFrom:startIndex to:endIndex on:aGC
    "return the width of part of myself if drawn on aCG"

    ^ self subclassResponsibility
!

widthOn:aGC
    "return the width of the frame if drawn on aCG"

    ^ self width

    "Created: 12.5.1996 / 20:20:45 / cg"
! !

!DisplayObject methodsFor:'component protocol'!

container:aComponent
    "ignored here - added to allow images to be used like
     VisualComponents (later, Image should inherit from it)"
!

containerChangedSize
    "ignored here - added to allow images to be used like
     VisualComponents (later, Image should inherit from it)"
!

destroy
    "SimpleView>>destroySubviews wants to destroy us (if we are a view's component).
     Do nothing here"

    ^ self
!

realize
    "ignored here - added to allow images to be used like
     VisualComponents (later, Image should inherit from it)"
! !

!DisplayObject methodsFor:'converting'!

asDisplayObject
    ^ self
! !

!DisplayObject methodsFor:'drawing'!

drawDashedOutlineIn:aGC offset:anOffset
    "draw the receiver's outline at its origin offset by anOffset, aPoint"

    |prevStyle|

    prevStyle := aGC lineStyle.
    aGC lineStyle:#dashed.
    [
        self drawOutlineIn:aGC offset:anOffset.
    ] ensure:[
        aGC lineStyle:prevStyle.
    ]

    "Created: 28.3.1997 / 16:23:25 / cg"
    "Modified: 28.3.1997 / 16:29:24 / cg"
!

drawDragIn:aView
    "draw the receiver for dragging at its origin"

    self drawDragIn:aView offset:0@0

    "Modified: 28.3.1997 / 16:27:32 / cg"
!

drawDragIn:aView at:drawOrigin
    "draw the receiver for dragging at some point"

    |offs|

    offs := drawOrigin - (self origin).
    self drawDragIn:aView offset:offs

    "Modified: 28.3.1997 / 16:20:17 / cg"
!

drawDragIn:aView offset:drawOrigin
    "draw the receiver for dragging offset by some amount"

    self class dragOutline ifTrue:[
        self class dragDashedOutline ifTrue:[
            self drawDashedOutlineIn:aView offset:drawOrigin
        ] ifFalse:[
            self drawOutlineIn:aView offset:drawOrigin
        ]
    ] ifFalse: [
        self drawIn:aView offset:drawOrigin
    ]

    "Modified: 28.3.1997 / 16:22:31 / cg"
!

drawIn:aView
    "draw the receiver at its origin"

    self drawIn:aView offset:0@0

    "Modified: 28.3.1997 / 16:27:46 / cg"
!

drawIn:aView at:drawOrigin
    "draw the receiver at drawOrigin, aPoint"

    self drawIn:aView offset:(drawOrigin - (self origin))
!

drawIn:aView offset:anOffset
    "draw the receiver at its origin offset by anOffset, aPoint"

    ^ self subclassResponsibility
!

drawOutlineIn:aView
    "draw the receiver's outline at its origin"

    self drawOutlineIn:aView offset:0@0

    "Modified: 28.3.1997 / 16:27:50 / cg"
!

drawOutlineIn:aView at:drawOrigin
    "draw the receiver's outline at drawOrigin, aPoint"

    self drawOutlineIn:aView offset:(drawOrigin - self origin)
!

drawOutlineIn:aView offset:anOffset
    "draw the receiver's outline at its origin offset by anOffset, aPoint"

    |org x y w h|

    org := self origin + anOffset.
    x := org x.
    y := org y.
    w := frame width.
    h := frame height.

    aView displayRectangleX:x y:y width:w height:h

    "Modified: 28.3.1997 / 16:32:34 / cg"
!

drawSelectedIn:aView
    "draw the receiver highlighted at its position"

    self drawSelectedIn:aView offset:0@0

    "Modified: 28.3.1997 / 16:27:56 / cg"
!

drawSelectedIn:aView offset:anOffset
    "draw the receiver highlighted - this is usually redefined"

    self drawIn:aView offset:anOffset.
    self drawOutlineIn:aView offset:anOffset
! !

!DisplayObject methodsFor:'dummy event handling'!

buttonMotion:buttNr x:x y:y
!

buttonPress:buttNr x:x y:y
!

buttonRelease:buttNr x:x y:y
!

keyPress:key x:x y:y
!

keyRelease:key x:x y:y
! !

!DisplayObject methodsFor:'initialization'!

computeBoundingBox
    "compute my boundingBox into the local variable 'frame'.
     The box should be computed for Display."

    ^ self subclassResponsibility
!

computeBoundingBoxFor:aDevice
    "compute my boundingBox into the local variable 'frame'.
     The box is to be computed for aDevice."

    "/ for backward compatibility, fall back to Display box computation

    self computeBoundingBox
!

initialize
    ^ self
! !

!DisplayObject methodsFor:'queries'!

canBeMoved
    "return true, if the receiver can be moved around (in an ObjectView)"

    ^ true

    "Modified: / 4.7.1999 / 18:49:26 / cg"
!

canBeSelected
    "return true, if the receiver can be selected (in an ObjectView)"

    ^ true

    "Created: / 4.7.1999 / 18:49:20 / cg"
!

containsPoint: aPoint
    ^ frame containsPoint: aPoint
!

frameIsHitBy:aPoint withDelta:delta
    "return true, if my frame is hit by aPoint"

    |org left right top bott px py d2|

    frame isNil ifTrue:[
        self computeBoundingBox.
        frame isNil ifTrue:[^ false ].
    ].
    (delta == 0) ifTrue:[
        ^ frame containsPoint:aPoint
    ].

    "
     its quicker to not create a new rectangle for the test
     (which is not obvious for simple lines, but complex polygons 
      or grouped objects may call this for many of its components)
    "
    org := frame origin.
    left := org x - delta.

    px := aPoint x.
    (px < left) ifTrue:[^ false].   "aPoint is to the left of my left edge"

    d2 := delta * 2.
    right := left + frame width + d2.
    (px > right) ifTrue:[^ false].  "aPoint is to the right of my right edge"

    top := org y - delta.
    py := aPoint y.
    (py < top) ifTrue:[^ false].    "aPoint is above my top edge"

    bott := top + frame height + d2.
    (py > bott) ifTrue:[^ false].   "aPoint is below my bottom edge"

    ^ true

    "Created: 5.6.1996 / 15:26:51 / cg"
!

handlesKeyboardInput
    "return true, if the receiver handles keyboard input"

    ^ false
!

hasFixedSize
    "return true, if the receiver has fixed size i.e. cannot be
     resized
     - by default, we do not allow resizing"

    ^ true
!

intersects:aRectangle
    "object must decide, if its intersecting a rectangle"

    ^ frame intersects:aRectangle
!

isContainedIn:aRectangle
    "object must decide, if its within a rectangle"

    ^ aRectangle contains:frame
!

isHitBy:aPoint
    "object must decide, if hit by a click at aPoint"

    ^ self isHitBy:aPoint withDelta:0
!

isHitBy:aPoint withDelta:delta
    "object must decide, if hit by a click at aPoint;
     usually this method is redefined in subclasses for a more complete
     check (i.e. if objects boundary is not rectangular)"

    ^ self frameIsHitBy:aPoint withDelta:delta

    "Modified: 5.6.1996 / 15:27:06 / cg"
!

isOpaque
    "return true, if the object fully covers its frame (i.e. is rectangular
     and has no 'holes'. Since we don't know, return false here"

    ^ false
! !

!DisplayObject methodsFor:'user actions'!

keyInput:akey
    ^ self
! !

!DisplayObject methodsFor:'user actions-move'!

moveBy:delta
    "move the receiver - extent is unchanged"

    self moveTo:(self origin + delta)
!

moveTo:aPoint
    "object must move to new origin
     - default is to stay; ought to be redefined in subclass"

    ^ self
! !

!DisplayObject class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


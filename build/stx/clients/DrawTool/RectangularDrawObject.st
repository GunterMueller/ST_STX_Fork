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

"{ Package: 'stx:clients/DrawTool' }"

DrawObject subclass:#RectangularDrawObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool'
!

!RectangularDrawObject class methodsFor:'documentation'!

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
    abstract superclass for all drawObjects, which have a rectangular boundary
    (actually all drawObjects)
"
! !

!RectangularDrawObject methodsFor:'drawing'!

drawOutlineIn:aGC offset:anOffset
    aGC displayRectangle:(Rectangle
			    origin:(origin + anOffset)
			    corner:(corner + anOffset))
! !

!RectangularDrawObject methodsFor:'handles'!

handlesDo:aBlock
    "evaluate the argument, aBlock for every handle"

    |h w halfHeight halfWidth top left right bottom|

    top := origin y.
    left := origin x.
    bottom := corner y.
    right := corner x.
    h := bottom - top.
    w := right - left.

    aBlock value:origin.                "top-left"
    aBlock value:corner.                "bottom-right"
    aBlock value:(left @ bottom).       "bottom-left"
    aBlock value:(right @ top).         "top-right"
    halfHeight := h // 2.
    aBlock value:(left @ (top + halfHeight)).   "center left"
    aBlock value:(right @ (top + halfHeight)).  "center right"
    halfWidth := w // 2.
    aBlock value:((left + halfWidth) @ top).    "top-center"
    aBlock value:((left + halfWidth) @ bottom)  "bottom-center"
!

selectorForHandle:aHandle
    |h w halfWidth halfHeight top left bottom right|

    top := origin y.
    left := origin x.
    bottom := corner y.
    right := corner x.
    h := bottom - top.
    w := right - left.

    aHandle = origin ifTrue:[^ #origin:].
    aHandle = corner ifTrue:[^ #corner:].
    aHandle = (left @ bottom) ifTrue:[^ #bottomLeft:].
    aHandle = (right @ top) ifTrue:[^ #topRight:].
    halfHeight := h // 2.
    aHandle = (left @ (top + halfHeight)) ifTrue:[^ #left:].
    aHandle = (right @ (top + halfHeight)) ifTrue:[^ #right:].
    halfWidth := w // 2.
    aHandle = ((left + halfWidth) @ top) ifTrue:[^ #top:].
    aHandle = ((left + halfWidth) @ bottom) ifTrue:[^ #bottom:].
    ^ nil
! !

!RectangularDrawObject methodsFor:'inside check'!

computeBoundingBox
    "recompute the frame - 
     must be done after every size change"

    |lw lwP|

    lw := (lineWidth // 2) + 1.
    lwP := lw @ lw.
    frame := Rectangle origin:(origin - lwP) corner:(corner + lwP)
! !

!RectangularDrawObject methodsFor:'moving/resizing'!

bottom:aPoint
    self origin:origin
	 corner:(corner x) @ (aPoint y)
!

bottomLeft:aPoint
    self origin:(aPoint x) @ (origin y)
	 corner:(corner x) @ (aPoint y)
!

corner:aPoint
    self origin:origin
	 corner:aPoint
!

flipHorizontal
    "flip horizontal"

    self origin:(origin x @ corner y)
	 corner:(corner x @ origin y)
!

flipVertical
    "flip horizontal"

    self origin:(corner x @ origin y)
	 corner:(origin x @ corner y)
!

left:aPoint
    self origin:(aPoint x) @ (origin y)
	 corner:corner
!

moveTo:newOrigin
    |dx dy|
    dx := corner x - origin x.
    dy := corner y - origin y.
    self origin:newOrigin
	 corner:(origin x + dx) @ (origin y + dy)
!

origin:aPoint
    self origin:aPoint
	 corner:corner
!

origin:newOrigin corner:newCorner
    "set new origin/corner"

    origin := newOrigin.
    corner := newCorner.
    self computeBoundingBox
!

right:aPoint
    self origin:origin
	 corner:(aPoint x) @ (corner y)
!

top:aPoint
    self origin:(origin x) @ (aPoint y)
	 corner:corner
!

topRight:aPoint
    self origin:(origin x) @ (aPoint y)
	 corner:(aPoint x) @ (corner y)
! !

!RectangularDrawObject methodsFor:'storing'!

storeInstvarsOn:aStream
    super storeInstvarsOn:aStream.
    aStream nextPutAll:'; origin:'. origin storeOn:aStream.
    aStream nextPutAll:'; corner:'. corner storeOn:aStream
! !

!RectangularDrawObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/RectangularDrawObject.st,v 1.7 2003-06-02 09:27:33 stefan Exp $'
! !

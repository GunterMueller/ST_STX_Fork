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

DrawObject subclass:#DrawLine
	instanceVariableNames:'p1 p2 capStyle'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawLine class methodsFor:'documentation'!

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
    this class represents line segments
"
! !

!DrawLine class methodsFor:'DrawView interface'!

userFriendlyName
    ^ 'line'

    "Created: 23.4.1997 / 12:02:04 / cg"
! !

!DrawLine methodsFor:'accessing'!

capStyle
    ^ capStyle
!

capStyle:something
    capStyle := something.
!

endPoint
    ^ p2 
!

endPoint:aPoint
    self secondPoint:aPoint
!

firstPoint:aPoint
    p1 := aPoint.
    self computeBoundingBox
!

flipHorizontal
    |np1 np2|

    np1 := p2 x @ p1 y.
    np2 := p1 x @ p2 y.
    p1 := np1.
    p2 := np2.
    self computeBoundingBox

    "Modified: 4.6.1996 / 20:39:01 / cg"
!

flipVertical
    |np1 np2|

    np1 := p1 x @ p2 y.
    np2 := p2 x @ p1 y.
    p1 := np1.
    p2 := np2.
    self computeBoundingBox
!

mmP1:newP1 mmP2:newP2
    "set new start/endPoint; arguments given in millimeter"

    |mmH mmV|

    mmH := Screen current horizontalPixelPerMillimeter.
    mmV := Screen current verticalPixelPerMillimeter.

    p1 := (newP1 x * mmH) rounded asInteger
          @
          (newP1 y * mmV) rounded asInteger.
    p2 := (newP2 x * mmH)  rounded asInteger
          @
          (newP2 y * mmV) rounded asInteger.
    self computeBoundingBox
!

moveTo:newOrigin
    p1 := p1 + (newOrigin - origin).
    p2 := p2 + (newOrigin - origin).
    self computeBoundingBox
!

origin:org corner:corn
    p1 := org.
    p2 := corn.
    self computeBoundingBox
!

secondPoint:aPoint
    p2 := aPoint.
    self computeBoundingBox
!

startPoint
    ^ p1 
!

startPoint:aPoint
    self firstPoint:aPoint
!

startPoint:point1 endPoint:point2
    p1 := point1.
    p2 := point2.
    self computeBoundingBox.
! !

!DrawLine methodsFor:'converting'!

asDrawPolygon
    "return a polygon, representing me"

    ^ DrawPolygon new fromDrawLine:self.
!

asDrawSpline
    "return a spline, representing me"

    ^ DrawSpline new fromDrawLine:self.
!

canBeConvertedToPolygon
    ^ true
! !

!DrawLine methodsFor:'drawing'!

arrowFor:anOffset in:aGCorNil
    |a|

    a := Arrow from:p1 + anOffset to:p2 + anOffset.
    a arrowHeadAngle:135.
    a arrowHeadLength:10.
    ^ a
!

drawArrowIn:aGC offset:anOffset
    |org oldStyle a|

    aGC lineWidth:lineWidth.

    oldStyle := aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].

    org := p1 + anOffset.
    aGC maskOrigin:org.
    aGC paint:foreground on:background.

    a := self arrowFor:anOffset in:aGC.

    linePattern notNil ifTrue:[
        linePattern == 1 ifTrue:[
            a displayFilledOn:aGC
        ] ifFalse:[
            aGC withPattern:linePattern do:[
                a displayFilledOn:aGC
            ]
        ]
    ].
    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].

    "Modified: 4.6.1996 / 19:13:39 / cg"
!

drawArrowOutlineIn:aGC offset:anOffset
    |org a|

    aGC lineWidth:0.
    "/aGC lineWidth:lineWidth.

    org := p1 + anOffset.

    a := self arrowFor:anOffset in:aGC.

    a displayStrokedOn:aGC.

    "leave gc in some known state"
"/    lineWidth > 0 ifTrue:[
"/        aGC lineWidth:0.
"/    ].

    "Created: 4.6.1996 / 18:20:07 / cg"
    "Modified: 4.6.1996 / 18:22:54 / cg"
!

drawIn:aGC offset:anOffset
    |org oldStyle oldCapStyle translatedP1 translatedP2 oldPaint oldBGPaint|

"/    (lineWidth == 1) ifTrue:[
"/        aGC lineWidth:0
"/    ] ifFalse:[
        aGC lineWidth:lineWidth.
"/    ].

    oldStyle := aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].
    oldCapStyle := aGC capStyle.
    (capStyle notNil and:[capStyle ~~ oldCapStyle]) ifTrue:[
        aGC capStyle:capStyle
    ].
    oldPaint := aGC paint.
    oldBGPaint := aGC backgroundPaint.

    org := origin + anOffset.
    aGC maskOrigin:org.
    aGC paint:foreground on:background.

    linePattern notNil ifTrue:[
        translatedP1 := p1 + anOffset.
        translatedP2 := p2 + anOffset.
        linePattern == 1 ifTrue:[
            aGC displayLineFrom:translatedP1 to:translatedP2
        ] ifFalse:[
            aGC withPattern:linePattern do:[
                aGC displayLineFrom:translatedP1 to:translatedP2
            ]
        ]
    ].
    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].
    capStyle ~~ oldCapStyle ifTrue:[
        aGC capStyle:oldCapStyle
    ].
    aGC paint:oldPaint on:oldBGPaint.

    "Modified: 4.6.1996 / 15:36:19 / cg"
!

drawOutlineIn:aGC offset:anOffset
"
    aGC paint:Color black.
"
"/    aGC lineWidth:lineWidth.
    aGC lineWidth:0.
    aGC displayLineFrom:(p1 + anOffset) to:(p2 + anOffset).
"/    aGC lineWidth:0.

    "Modified: 4.6.1996 / 15:36:05 / cg"
! !

!DrawLine methodsFor:'frame computation'!

computeBoundingBox
    |minx miny maxx maxy lw|

    p1 isNil ifTrue:[^ self].

    minx := p1 x.
    maxx := p2 x.
    (maxx < minx) ifTrue:[
        minx := p2 x.
        maxx := p1 x
    ].
    miny := p1 y.
    maxy := p2 y.
    maxy < miny ifTrue:[
        miny := p2 y.
        maxy := p1 y
    ].

    origin := minx @ miny.
    corner := maxx @ maxy.

    lw := (lineWidth // 2) + 1.
    minx := minx - lw.
    maxx := maxx + lw.
    miny := miny - lw.
    maxy := maxy + lw.
    frame := Rectangle left:minx right:maxx top:miny bottom:maxy.
! !

!DrawLine methodsFor:'frame computations'!

computeArrowBoundingBox
    |a p minx miny maxx maxy|

    super computeBoundingBox.
    a := self arrowFor:0@0 in:nil.
    p := a arrowPointsFor:origin and:corner.
    "/ p := a arrowPoints.

    minx := p inject:frame left  into:[:minSoFar :p | minSoFar min:(p x)].
    miny := p inject:frame top  into:[:minSoFar :p | minSoFar min:(p y)].
    maxx := p inject:frame right  into:[:maxSoFar :p | maxSoFar max:(p x)].
    maxy := p inject:frame bottom  into:[:maxSoFar :p | maxSoFar max:(p y)].

    frame := Rectangle left:(minx truncated)
                        top:(miny truncated)
                      right:(maxx truncated + 1)
                     bottom:(maxy truncated + 1)

    "Modified: / 22.5.1999 / 01:22:33 / cg"
! !

!DrawLine methodsFor:'handles'!

handlesDo:aBlock
    aBlock value:p1.
    aBlock value:p2
!

selectorForHandle:aHandle
    aHandle = p1 ifTrue:[^ #firstPoint:].
    aHandle = p2 ifTrue:[^ #secondPoint:].
    ^ nil
! !

!DrawLine methodsFor:'storing'!

storeInstvarsOn:aStream
    |pixelPerMmH pixelPerMmV mmPoint|

    super storeInstvarsOn:aStream.
    pixelPerMmH := Display horizontalPixelPerMillimeter.
    pixelPerMmV := Display verticalPixelPerMillimeter.
    mmPoint := (p1 x / pixelPerMmH) @ (p1 y / pixelPerMmV).
    aStream nextPutAll:'; mmP1:'. mmPoint storeOn:aStream.
    mmPoint := (p2 x / pixelPerMmH) @ (p2 y / pixelPerMmV).
    aStream nextPutAll:' mmP2:'. mmPoint storeOn:aStream.
! !

!DrawLine methodsFor:'testing'!

distanceFromPoint:aPoint
    |pX pY startX startY endX endY dx dy m y2 mN x0 y0 xNext yNext pNear dist|

    pX := aPoint x.
    pY := aPoint y.
    startX := p1 x asFloat.
    startY := p1 y asFloat.
    endX := p2 x asFloat.
    endY := p2 y asFloat.

    dx := endX - startX.
    dx = 0 ifTrue:[
        "a vertical line"
        (pY between:(startY min:endY) and:(startY max:endY)) ifTrue:[
            ^ (pX - startX) abs
        ].
        ^ (p1 dist:aPoint) min:(p2 dist:aPoint)
    ].

    dy := endY - startY.
    dy = 0 ifTrue:[
        "a horizontal line"
        (pX between:(startX min:endX) and:(startX max:endX)) ifTrue:[
            ^ (pY - startY) abs
        ].
        ^ (p1 dist:aPoint) min:(p2 dist:aPoint)
    ].

    m := dy/dx.  
    "/ line: y(x) = y0 + m*(x-x0)
    y2 := startY + (m * (endX-startX)).
    y0 := startY.
    x0 := startX.
    mN := -1 / m.
    "/ normal: yN(x) = yH + mN*(x-xH)
    "/ hitPoint is on normal...
    "/ y(x) = yN(x)
    "/ y0 + m*(x-x0) = yH + mN*(x-xH)
    "/ solve for x, to get x of next point on line.
    xNext := (y0 - pY - (m*x0) + (mN*pX))/(mN-m).
    "/ get y of next point on line.
    yNext := y0 + (m*(xNext-x0)).
    pNear := xNext@yNext.
"/OV notNil ifTrue:[
"/  OV paint:Color green.
"/  OV displayLineFrom:p1 to:p2.
"/  OV paint:Color red.
"/  OV displayLineFrom:hitPoint "(hitPoint-(2@(mN*2)))" to:pNear. "/(hitPoint+(2@(mN*2))).
"/  OV paint:Color black.
"/].
    dist := pNear dist:aPoint.

    ^ ((p1 dist:aPoint) min:(p2 dist:aPoint)) min:dist

    "
     self assert:((DrawLine new startPoint:10@10 endPoint:10@30) distanceFromPoint:(10@20)) = 0
     self assert:((DrawLine new startPoint:10@10 endPoint:30@10) distanceFromPoint:(20@10)) = 0 
     self assert:((DrawLine new startPoint:10@10 endPoint:10@30) distanceFromPoint:(10@40)) = 10 
     self assert:((DrawLine new startPoint:10@10 endPoint:30@10) distanceFromPoint:(40@10)) = 10  

     self assert:((DrawLine new startPoint:10@10 endPoint:30@10) distanceFromPoint:(20@20)) = 10  
     self assert:((DrawLine new startPoint:10@10 endPoint:30@10) distanceFromPoint:(40@20)) = (10*2 sqrt)  
    "
!

isHitBy:hitPoint withDelta:hitDelta
    "answer true, if line is hit by point"

    |lw delta|

    "quick boundary check"

    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[
        ^ false
    ].

    lw := (lineWidth // 2) + 1.
    lw := (lineWidth / 2).
    lw := (lineWidth max:1) / 2.
    delta := hitDelta + lw.
    ^ (self distanceFromPoint:hitPoint) <= delta
! !

!DrawLine class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawLine.st,v 1.20 2009-02-12 15:55:04 cg Exp $'
! !

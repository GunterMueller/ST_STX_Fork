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

DrawObject subclass:#DrawPolygon
	instanceVariableNames:'originalPoints scaledPoints originalOrigin originalCorner
		helperBitmap'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawPolygon class methodsFor:'documentation'!

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
    this class represents polygons
"
! !

!DrawPolygon class methodsFor:'interface to DrawView'!

needsMultiPointCreate
    ^ true
!

userFriendlyName
    ^ 'polygon'

    "Created: 23.4.1997 / 12:02:14 / cg"
! !

!DrawPolygon methodsFor:'accessing'!

fillPattern:aPattern
    "redefined, since this may change my bounds"

    super fillPattern:aPattern.
    aPattern isNil ifTrue:[
        helperBitmap := nil
    ].

    "Modified: 5.6.1996 / 15:25:23 / cg"
    "Created: 5.6.1996 / 15:29:50 / cg"
!

flipHorizontal
    |minX maxX cx|

    minX := maxX := originalPoints first x.

    originalPoints do:[:p |
        minX := minX min:(p x).
        maxX := maxX max:(p x).
    ].    
    cx := minX + (maxX - minX / 2).

    originalPoints := originalPoints collect:[:p | (cx - (p x - cx)) @ p y].

    minX := maxX := scaledPoints first x.

    scaledPoints do:[:p |
        minX := minX min:(p x).
        maxX := maxX max:(p x).
    ].    
    cx := minX + (maxX - minX / 2).

    scaledPoints := scaledPoints collect:[:p | (cx - (p x - cx)) @ p y].

    helperBitmap := nil.
    frame := nil.
    self computeBounds.

    "Created: 4.6.1996 / 20:49:47 / cg"
    "Modified: 5.6.1996 / 16:11:00 / cg"
!

flipVertical
    |minY maxY cy|

    minY := maxY := originalPoints first y.

    originalPoints do:[:p |
        minY := minY min:(p y).
        maxY := maxY max:(p y).
    ].    
    cy := minY + (maxY - minY / 2).

    originalPoints := originalPoints collect:[:p | p x @ (cy - (p y - cy))].

    minY := maxY := scaledPoints first y.

    scaledPoints do:[:p |
        minY := minY min:(p y).
        maxY := maxY max:(p y).
    ].    
    cy := minY + (maxY - minY / 2).

    scaledPoints := scaledPoints collect:[:p | p x @ (cy - (p y - cy))].

    helperBitmap := nil.
    frame := nil.
    self computeBounds.

    "Created: 4.6.1996 / 20:49:47 / cg"
    "Modified: 5.6.1996 / 16:11:08 / cg"
! !

!DrawPolygon methodsFor:'converting'!

asClosedDrawPolygon
    ^ (self class new fromDrawPolygon:self) makeClosedPolygon
!

asDrawRectangle
    "return a rectangle, representing my bounds"

    |minX minY maxX maxY|

    minX := scaledPoints 
                inject:(scaledPoints first x) into:[:minSoFar :thisPoint | minSoFar min:thisPoint x].
    minY := scaledPoints 
                inject:(scaledPoints first y) into:[:minSoFar :thisPoint | minSoFar min:thisPoint y].
    maxX := scaledPoints 
                inject:(scaledPoints first x) into:[:maxSoFar :thisPoint | maxSoFar max:thisPoint x].
    maxY := scaledPoints 
                inject:(scaledPoints first y) into:[:maxSoFar :thisPoint | maxSoFar max:thisPoint y].

    ^ DrawRectangle new origin:(minX@minY) corner:(maxX@maxY).
!

asDrawSpline
    "return a spline, representing me"

    ^ DrawSpline new fromDrawPolygon:self.


!

asOpenDrawPolygon
    ^ (self class new fromDrawPolygon:self) makeOpenPolygon
!

canBeConvertedToClosedPolygon
    ^ originalPoints size >= 2 and:[originalPoints first ~= originalPoints last]
!

canBeConvertedToOpenPolygon
    ^ originalPoints size > 2 and:[originalPoints first = originalPoints last]
!

canBeConvertedToRectangle
    |p1 minX minY maxX maxY topLeft topRight botLeft botRight seq rect|

    originalPoints size < 4 ifTrue:[^ false].
    originalPoints size > 5 ifTrue:[^ false].

    originalPoints size == 5 ifTrue:[
        (originalPoints at:5) = (originalPoints at:1) ifFalse:[^ false].    
    ].

    p1 := originalPoints at:1.
    minX := originalPoints inject:p1 x into:[:min :p | min min:p x].
    minY := originalPoints inject:p1 y into:[:min :p | min min:p y].
    maxX := originalPoints inject:p1 x into:[:max :p | max max:p x].
    maxY := originalPoints inject:p1 y into:[:max :p | max max:p y].

    topLeft := minX @ minY.
    topRight := maxX @ minY.
    botLeft := minX @ maxY.
    botRight := maxX @ maxY.
    rect := Array with:topLeft with:topRight with:botRight with:botLeft.

    seq := originalPoints copyTo:4.

    4 timesRepeat:[
        seq = rect ifTrue:[^ true].
        seq := (seq copyFrom:2) copyWith:seq first
    ].

    seq := Array 
                with:(originalPoints at:2)
                with:(originalPoints at:1)
                with:(originalPoints at:4)
                with:(originalPoints at:3).
    4 timesRepeat:[
        seq = rect ifTrue:[^ true].
        seq := (seq copyFrom:2) copyWith:seq first
    ].

    ^ false
!

canBeConvertedToSpline
    ^ true
!

fromDrawLine:aDrawLine
    "setup my state from a drawLine"

    self firstPoint:(aDrawLine startPoint).
    self addPoint:(aDrawLine endPoint).
    self finishCreate.
    helperBitmap := nil.
    super fromDrawObject:aDrawLine.

!

fromDrawPolygon:aPolygon
    "setup my state from a aDrawPolygin"

    ^ self fromDrawPolygonOrSpline:aPolygon
!

fromDrawPolygonOrSpline:aDrawPolygonOrSpline
    "setup my state from a aDrawSpline"

    |points|

    points := aDrawPolygonOrSpline scaledPoints.
    self firstPoint:(points first).
    points from:2 to:points size do:[:aPoint |
        self addPoint:aPoint
    ].
    self finishCreate.
    helperBitmap := nil.
    super fromDrawObject:aDrawPolygonOrSpline.
    self computeBoundingBox.
!

fromDrawRectangle:aDrawRectangle
    "setup my state from a drawRectangle"

    |r|

    r := aDrawRectangle origin corner:aDrawRectangle corner.

    self firstPoint:(r topLeft).
    self addPoint:(r topRight).
    self addPoint:(r bottomRight).
    self addPoint:(r bottomLeft).
"/    self addPoint:(r topLeft).        -- no; do not close it.
    self finishCreate.
    helperBitmap := nil.
    super fromDrawObject:aDrawRectangle.

!

fromDrawSpline:aDrawSpline
    "setup my state from a aDrawSpline"

    ^ self fromDrawPolygonOrSpline:aDrawSpline

!

makeClosedPolygon
    originalPoints last ~= originalPoints first ifTrue:[
        originalPoints := originalPoints copyWith:originalPoints first.
        self finishCreate.
        helperBitmap := nil.
        self computeBoundingBox.
    ]
!

makeOpenPolygon
    originalPoints last = originalPoints first ifTrue:[
        originalPoints := originalPoints copyButLast:1.
        self finishCreate.
        helperBitmap := nil.
        self computeBoundingBox.
    ]
! !

!DrawPolygon methodsFor:'creation from DrawView'!

addPoint:aPoint
    "try to compress if slope has not changed"

    |index pLast pPrev dxLast dyLast dx dy|

    index := originalPoints size.
    (index > 2) ifTrue:[
	pLast := originalPoints at:index.
	pPrev := originalPoints at:(index - 1).
	dx := aPoint x - pLast x.
	dy := aPoint y - pLast y.
	dxLast := pLast x - pPrev x.
	dyLast := pLast y - pPrev y.
	((dy == 0) or:[dyLast == 0]) ifTrue:[
	    (dy == dyLast) ifTrue:[
		originalPoints at:index put:aPoint.
		^ self
	    ]
	] ifFalse:[
	    (dx / dy) = (dxLast / dyLast) ifTrue:[
		originalPoints at:index put:aPoint.
		^ self
	    ]
	]
    ].
    originalPoints add:aPoint
!

finalPoint:aPoint
    self lastPointAt:aPoint.
    self finishCreate

    "Modified: 23.4.1997 / 11:13:02 / cg"
!

finishCreate
    "creation finished - minimize the polygon"

    |point pts|

    pts := originalPoints.
    originalPoints := Array new:(pts size).
    1 to:(pts size) do:[:i |
        originalPoints at:i put:(pts at:i).
        pts at:1 put:nil
    ].
    helperBitmap := nil.
    scaledPoints := Array new:(originalPoints size).
    originalOrigin := originalCorner := originalPoints at:1.
    1 to:(originalPoints size) do:[:index |
        point := originalPoints at:index.
        originalOrigin := originalOrigin min:point.
        originalCorner := originalCorner max:point.
        scaledPoints at:index put:point
    ].
    origin := originalOrigin x @ originalOrigin y.
    corner := originalCorner x @ originalCorner y

    "Created: 23.4.1997 / 11:13:32 / cg"
!

firstPoint:aPoint
    originalPoints := OrderedCollection new.
    originalPoints add:aPoint
!

lastPointAt:aPoint
    originalPoints at:(originalPoints size) put:aPoint
! !

!DrawPolygon methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |drawPoly org oldStyle|

    drawPoly := self pointsRelocatedBy:anOffset.

"/    (lineWidth == 1) ifTrue:[
"/        aGC lineWidth:0
"/    ] ifFalse:[
        aGC lineWidth:lineWidth.
"/    ].
    oldStyle :=  aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].

    org := origin + anOffset.
    aGC maskOrigin:org.

    fillPattern notNil ifTrue:[
        self withFillPatternAsPaintIn:aGC 
            do:[ 
                aGC fillPolygon:drawPoly 
            ].
        linePattern notNil ifTrue:[
            "/ a closed polygon.    
            drawPoly := drawPoly copyWith:(drawPoly at:1).
            self lineGC:aGC with:[aGC displayPolygon:drawPoly]
        ]
    ] ifFalse:[
        linePattern notNil ifTrue:[
            "/ an open polygon.    
            self lineGC:aGC with:[aGC displayPolygon:drawPoly]
        ]
    ].
    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].

    "Modified: 5.6.1996 / 12:18:39 / cg"
!

drawOutlineIn:aGC offset:anOffset
    |org r drawPoly|

"
    aGC paint:Color black.
"

    aGC lineWidth:0.

    "if there are too many points, some servers become very
     slow - the number is arbitrary"

    (originalPoints size > 1000) ifTrue:[
        origin notNil ifTrue:[
            org := origin + anOffset.
            r := Rectangle origin:org corner:(corner + anOffset).
            aGC displayRectangle:r.
            ^ self
        ].
    ].

    drawPoly := self pointsRelocatedBy:anOffset.
    fillPattern notNil ifTrue:[
        "closed polygon as outline looks better :-)"
        drawPoly := drawPoly copyWith:(drawPoly at:1)
    ].
    aGC displayPolygon:drawPoly

    "Modified: 5.6.1996 / 12:18:58 / cg"
! !

!DrawPolygon methodsFor:'handles'!

edgeHandlesDo:aBlock
    "evaluate the argument, aBlock for every edge handle."

    scaledPoints from:1 to:scaledPoints size-1 do:[:aPoint |
        aBlock value:aPoint.
    ].
    originalPoints first ~= originalPoints last ifTrue:[
        aBlock value:scaledPoints last
    ].
!

selectorForEdgeHandle:aHandle
    "return a selector-index pair for edge-handle manipulation"

    1 to:scaledPoints size do:[:idx |
        |edgePoint|

        edgePoint := scaledPoints at:idx.
        aHandle = edgePoint ifTrue:[
            ^ Array with:#setEdge:to: with:idx.
        ]
    ].
    ^ nil
!

selectorForHandle:aHandle
    "return a selector-index pair for edge-handle manipulation"

    ^ super selectorForHandle:aHandle
! !

!DrawPolygon methodsFor:'inside check'!

computeBoundingBox
    "funny: mitered lines can move away from endpoints -
     redefined to be save on X"

    |sixLineWidths|

    origin isNil ifTrue:[
        self finishCreate
    ].

    (lineWidth == 0) ifTrue:[
        super computeBoundingBox.
        ^ self.
    ].

    "/ BUG: should really compute the bounds of a sharp edge here
    sixLineWidths := lineWidth * 6.

    frame := Rectangle left:(origin x - sixLineWidths)
                      right:(corner x + sixLineWidths)
                        top:(origin y - sixLineWidths)
                     bottom:(corner y + sixLineWidths)
!

isHitBy:hitPoint withDelta:hitDelta
    "answer true, if polygon is hit by point"

    |hw hh index line newPoly pForm|

    "quick boundary check"
    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[^ false].

    "if helper bitmap already exists, check it first - its faster"

    pForm := hitPoint - origin.
    helperBitmap notNil ifTrue:[
        pForm x < 0 ifTrue:[^ false].
        pForm y < 0 ifTrue:[^ false].
        pForm x >= helperBitmap width ifTrue:[^ false].
        pForm y >= helperBitmap height ifTrue:[^ false].
        ((helperBitmap at:pForm) == 1) ifTrue:[^ true]
    ].

    "first, we walk the outlines and check them by using DrawLine's algorithm"
    index := 1.
    [index < (scaledPoints size)] whileTrue:[
        line := DrawLine new 
                        origin:(scaledPoints at:index)
                        corner:(scaledPoints at:(index + 1)).
        line lineWidth:lineWidth.
        (line isHitBy:hitPoint withDelta:hitDelta) ifTrue:[^ true].
        index := index + 1
    ].
    fillPattern isNil ifTrue:[^ false].

    helperBitmap notNil ifTrue:[
        "/ already checked inside
        ^ false
    ].
    pForm x < 0 ifTrue:[^ false].
    pForm y < 0 ifTrue:[^ false].

    "hard part, must check interior of polygon"
    "since I'm lazy, I (mis)-use the view stuff to compute this:
     fill the polygon into a temp-bitmap and check, if the pixel
     at hitPoint is on ..."

    helperBitmap isNil ifTrue:[
        newPoly := Array new:(scaledPoints size).
        1 to:(newPoly size) do:[:index |
            newPoly at:index put:((scaledPoints at:index) - origin)
        ].

        hw := corner x - origin x.
        hh := corner y - origin y.
        helperBitmap := Form width:(hw truncated + 1) height:(hh truncated + 1) depth:1.
        helperBitmap fill:(Color colorId:0).
        helperBitmap paint:(Color colorId:1).
        helperBitmap fillPolygon:newPoly
    ].
    pForm x >= helperBitmap width ifTrue:[^ false].
    pForm y >= helperBitmap height ifTrue:[^ false].
    ((helperBitmap at:pForm) == 1) ifTrue:[^ true].

    ^ false

    "Modified: 5.6.1996 / 16:04:49 / cg"
! !

!DrawPolygon methodsFor:'moving and resizing'!

moveTo:newOrigin
    |delta|

    delta := newOrigin - origin.
    scaledPoints := scaledPoints collect:[:oldPoint | oldPoint + delta].
    super moveTo:newOrigin
!

origin:newOrigin corner:newCorner

    |newSize oldSize scaleX scaleY nx ny p|

    scaledPoints notNil ifTrue:[
        helperBitmap := nil.

        scaleX := 1.
        newSize := (newCorner x) - (newOrigin x).
        newSize <= 0 ifTrue:[
            scaleX := 0
        ] ifFalse:[
            oldSize := (originalCorner x) - (originalOrigin x).
            (oldSize ~= newSize) ifTrue:[
                scaleX := newSize / oldSize
            ].
        ].

        scaleY := 1.
        newSize := (newCorner y) - (newOrigin y).
        newSize <= 0 ifTrue:[
            scaleY := 0
        ] ifFalse:[
            oldSize := (originalCorner y) - (originalOrigin y).
            (oldSize ~= newSize) ifTrue:[
                scaleY := newSize / oldSize
            ].
        ].

        (scaleX ~~ 1 or:[scaleY ~~ 1]) ifTrue:[
            1 to:(originalPoints size) do:[:index |
                p := originalPoints at:index.
                nx := p x.
                ny := p y.

                "move to 0@0 - origin"
                nx := nx - originalOrigin x.
                ny := ny - originalOrigin y.

                "scale to new size"
                nx := (nx * scaleX) asInteger.
                ny := (ny * scaleY) asInteger.

                "move to new - origin"
                nx := nx + newOrigin x.
                ny := ny + newOrigin y.

                scaledPoints at:index put:(nx @ ny)
            ]
        ]
    ].

    super origin:newOrigin corner:newCorner

    "Modified: 5.6.1996 / 16:07:22 / cg"
!

setEdge:idx to:newPoint
    |originalWidth scale scaledDelta delta newOrigin newCorner|

    originalWidth := originalCorner x - originalOrigin x.
    scale := frame width / originalWidth.
    scaledDelta := newPoint - (scaledPoints at:idx).
    delta := scaledDelta / scale.
    originalPoints at:idx put:(originalPoints at:idx) + delta.

    scaledPoints at:idx put:newPoint.

    helperBitmap := nil.
    self computeBounds.

    newOrigin := origin copy.
    newCorner := corner copy.
    newPoint x > newCorner x ifTrue:[
        newCorner x:newPoint x
    ].
    newPoint y > newCorner y ifTrue:[
        newCorner y:newPoint y
    ].
    newPoint x < newOrigin x ifTrue:[
        newOrigin x:newPoint x
    ].
    newPoint y < newOrigin y ifTrue:[
        newOrigin y:newPoint y
    ].

    super origin:newOrigin corner:newCorner.
! !

!DrawPolygon methodsFor:'private'!

computeBounds
!

pointsRelocatedBy:anOffset
    |srcPoly drawPoly|

    srcPoly := scaledPoints.
    srcPoly isNil ifTrue:[
        srcPoly := originalPoints
    ].
    ((anOffset x = 0) and:[anOffset y = 0]) ifTrue:[
        drawPoly := srcPoly
    ] ifFalse:[
        drawPoly := Array new:(srcPoly size).
        1 to:(srcPoly size) do:[:index |
            drawPoly at:index put:((srcPoly at:index) + anOffset)
        ]
    ].
    ^ drawPoly

    "Modified: 5.6.1996 / 12:18:19 / cg"
!

scaledPoints
    ^ scaledPoints
! !

!DrawPolygon methodsFor:'storing'!

storeInstvarsOn:aStream
    super storeInstvarsOn:aStream.
    aStream nextPutAll:'; firstPoint:'.
    (scaledPoints at:1) storeOn:aStream.
    2 to:(scaledPoints size) do:[:i |
        aStream nextPutAll:'; addPoint:'.
        (scaledPoints at:i) storeOn:aStream
    ].
    aStream nextPutAll:'; finishCreate'.
! !

!DrawPolygon class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawPolygon.st,v 1.32 2013-04-26 08:22:44 stefan Exp $'
! !


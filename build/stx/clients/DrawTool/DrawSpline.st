"{ Package: 'stx:clients/DrawTool' }"

DrawPolygon subclass:#DrawSpline
	instanceVariableNames:'insetTopLeft insetBottomRight'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawSpline class methodsFor:'documentation'!

documentation
"
    this class represents splines
"

! !

!DrawSpline class methodsFor:'DrawView interface'!

userFriendlyName
    ^ 'spline'

    "Created: 23.4.1997 / 12:02:50 / cg"
! !

!DrawSpline methodsFor:'accessing'!

fillPattern:aPattern
    "redefined, since this may change my bounds"

    super fillPattern:aPattern.
    "/ adjust for splines shoot-over
    super origin:origin+insetTopLeft corner:corner-insetBottomRight.
    self recomputeBounds

    "Created: 5.6.1996 / 15:22:34 / cg"
    "Modified: 5.6.1996 / 15:57:25 / cg"
! !

!DrawSpline methodsFor:'converting'!

asDrawPolygon
    "return a polygon, representing me"

    ^ DrawPolygon new fromDrawSpline:self.


!

canBeConvertedToPolygon
    ^ true
! !

!DrawSpline methodsFor:'creation from DrawView'!

finishCreate
    super finishCreate.
    self computeBounds

    "Created: 5.6.1996 / 12:23:23 / cg"
    "Modified: 23.4.1997 / 11:13:37 / cg"
! !

!DrawSpline methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |drawPoly org oldStyle spline|

    drawPoly := self pointsRelocatedBy:anOffset.
    spline := Spline controlPoints:drawPoly.

    aGC lineWidth:lineWidth.

    oldStyle :=  aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].

    org := origin + anOffset.
    aGC maskOrigin:org.

    fillPattern notNil ifTrue:[
        "/ close it
        drawPoly := drawPoly copyWith:(drawPoly at:1).
        spline := Spline controlPoints:drawPoly.

        self withFillPatternAsPaintIn:aGC 
            do:[ 
                spline displayFilledOn:aGC
            ].
    ].
    linePattern notNil ifTrue:[
        self lineGC:aGC with:[
            spline displayStrokedOn:aGC
        ]
    ].

    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].

    "Created: 5.6.1996 / 12:10:53 / cg"
    "Modified: 5.6.1996 / 15:11:11 / cg"
!

drawOutlineIn:aGC offset:anOffset
    |org r drawPoly spline|

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
    spline := Spline controlPoints:drawPoly.
    spline displayStrokedOn:aGC

    "Created: 5.6.1996 / 12:08:27 / cg"
    "Modified: 5.6.1996 / 12:19:32 / cg"
! !

!DrawSpline methodsFor:'inside check'!

isHitBy:hitPoint withDelta:hitDelta
    "answer true, if the spline is hit by point"

    |hw hh index line newPoly spline points lines|

    "quick boundary check"
    (super frameIsHitBy:hitPoint withDelta:hitDelta) ifFalse:[^ false].

    "if helper bitmap already exists, check it first - its faster"

    helperBitmap notNil ifTrue:[
        ((helperBitmap at:(hitPoint - origin)) == 1) ifTrue:[^ true]
    ].

    points := scaledPoints.
    fillPattern notNil ifTrue:[
        points := points copyWith:(points at:1).
    ].

    spline := Spline controlPoints:points.
    lines := spline computeLineSegments.

    "first, we walk the outlines and check them by using DrawLine's algorithm"
    index := 1.
    [index < (lines size)] whileTrue:[
        line := DrawLine new 
                        origin:(lines at:index)
                        corner:(lines at:(index + 1)).
        line lineWidth:lineWidth.
        (line isHitBy:hitPoint withDelta:hitDelta) ifTrue:[^ true].
        index := index + 1
    ].
    fillPattern isNil ifTrue:[^ false].

    "hard part, must check interior of polygon"
    "since I'm lazy, I (mis)-use the view stuff to compute this:
     fill the polygon into a temp-bitmap and check, if the pixel
     at hitPoint is on ..."

    helperBitmap isNil ifTrue:[
        newPoly := Array new:(scaledPoints size).
        1 to:(newPoly size) do:[:index |
            newPoly at:index put:((scaledPoints at:index) - origin)
        ].
        newPoly := newPoly copyWith:(newPoly at:1).
        spline := Spline controlPoints:newPoly.

        hw := corner x - origin x.
        hh := corner y - origin y.
        helperBitmap := Form width:hw height:hh depth:1.
        helperBitmap fill:(Color colorId:0).
        helperBitmap paint:(Color colorId:1).
        spline displayFilledOn:helperBitmap.
    ].

    ((helperBitmap at:(hitPoint - origin)) == 1) ifTrue:[^ true].

    ^ false

    "Created: 5.6.1996 / 15:19:23 / cg"
    "Modified: 5.6.1996 / 15:32:46 / cg"
! !

!DrawSpline methodsFor:'moving and resizing'!

computeBounds
    self recomputeBounds.
    originalOrigin := origin.
    originalCorner := corner.

    "Modified: 5.6.1996 / 15:49:56 / cg"
!

origin:newOrigin corner:newCorner
    "adjust for the shoot-over (after handle-move. origin/corner may
     not be what was expected ...)"

    super origin:newOrigin+insetTopLeft corner:newCorner-insetBottomRight.
    self recomputeBounds

    "Modified: 5.6.1996 / 16:07:30 / cg"
!

recomputeBounds
    |drawPoly spline bounds|

    drawPoly := self pointsRelocatedBy:0@0.
    fillPattern notNil ifTrue:[
        drawPoly := drawPoly copyWith:(drawPoly at:1)
    ].
    spline := Spline controlPoints:drawPoly.

    bounds := spline bounds.

    "/ remember the shoot-over 
    "/ (real origin/corner may not be what was expected ...)

    insetTopLeft := origin - bounds origin.
    insetBottomRight := bounds corner - corner.

    origin := bounds origin.
    corner := bounds corner.

    self computeBoundingBox

    "Created: 5.6.1996 / 15:24:31 / cg"
    "Modified: 5.6.1996 / 15:52:30 / cg"
! !

!DrawSpline class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawSpline.st,v 1.9 2008-09-26 10:56:39 stefan Exp $'
! !

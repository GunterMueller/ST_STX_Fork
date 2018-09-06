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
"{ Package: 'stx:libbasic2' }"

Geometric subclass:#Curve
	instanceVariableNames:'startPoint middlePoint endPoint'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Curve class methodsFor:'documentation'!

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
    A Curve is a conic section determined by three points
    that interpolates the first and the third and is tangent to the angle formed
    by the three points at the first and third points.

    [author:]
        Claus Gittinger

    [see also:]
        Rectangle Polygon EllipticalArc Circle Spline Point LineSegment
        ArrowedSpline Arrow
        GraphicsContext
        StrokingWrapper FillingWrapper
"
!

examples
"
  filled & unfilled:
                                                                        [exBegin]
    |v c|

    v := (View extent:100@100) openAndWait.

    c := Curve start:(20@20) middle:(80@80) end:(20@80).

    v paint:Color blue.
    c displayFilledOn:v.

    v paint:Color red.
    c displayStrokedOn:v.
                                                                        [exEnd]

  with a grid (for demonstration):
                                                                        [exBegin]
    |v c|

    v := (View extent:200@100) openAndWait.

    v lineStyle:#dashed.
    v displayLineFrom:(20@0) to:(20@200).
    v displayLineFrom:(180@0) to:(180@200).

    v displayLineFrom:(0@20) to:(200@20).
    v displayLineFrom:(0@80) to:(200@80).

    v lineStyle:#solid.
    c := Curve start:(20@20) middle:(180@80) end:(20@80).

    v paint:Color blue.
    c displayFilledOn:v.

    v paint:Color red.
    c displayStrokedOn:v.

    v paint:(Color black).
    v displayLineFrom:(20@20) to:(180@80).
    v displayLineFrom:(20@80) to:(180@80).

                                                                        [exEnd]
"
! !

!Curve class methodsFor:'instance creation'!

from:startPoint to:endPoint through:middlePoint
    "return a new curve, passing through the three given points"

    ^ self new start:startPoint middle:middlePoint end:endPoint

    "Created: 8.5.1996 / 21:16:39 / cg"
!

start:startPoint middle:middlePoint end:endPoint
    "return a new curve, passing through the three given points"

    ^ self new start:startPoint middle:middlePoint end:endPoint

    "Created: 8.5.1996 / 21:19:30 / cg"
!

with:startPoint with:middlePoint with:endPoint
    "return a new curve, passing through the three given points"

    ^ self new start:startPoint middle:middlePoint end:endPoint

    "Created: 17.5.1996 / 10:22:47 / cg"
! !

!Curve methodsFor:'accessing'!

end
    "return the endPoint"

    ^ endPoint

    "Created: 8.5.1996 / 21:08:35 / cg"
!

start
    "return the startPoint"

    ^ startPoint

    "Created: 8.5.1996 / 21:08:44 / cg"
!

start:p1 middle:p2 end:p3
    "set the startPoint, middlePoint and the endPoint"

    startPoint := p1.
    middlePoint := p2.
    endPoint := p3.

    "Created: 8.5.1996 / 21:09:40 / cg"
! !

!Curve methodsFor:'converting'!

asPointArray
    "return an array containing my points."

    ^ Array with:startPoint with:middlePoint with:endPoint

    "Created: 9.5.1996 / 01:07:07 / cg"
!

asPolygon
    "return a polygon, approximating the spline"

    ^ Polygon vertices:(self computeLineSegments)

    "Created: 9.5.1996 / 01:08:12 / cg"
! !

!Curve methodsFor:'displaying'!

displayFilledOn:aGC
    "draw the receiver as a filled curve in a graphicsContext, aGC"

    aGC fillPolygon:self computeLineSegments

    "Created: 8.5.1996 / 21:24:15 / cg"
    "Modified: 9.5.1996 / 01:08:34 / cg"
!

displayStrokedOn:aGC
    "draw the receiver as a unfilled curve in a graphicsContext, aGC"

    aGC displayPolygon:self computeLineSegments

    "Modified: 9.5.1996 / 01:08:36 / cg"
! !

!Curve methodsFor:'helpers'!

computeLineSegments
    "compute the lines which approxiamte this curve"

    |lines pa pb 
     numberOfSegments "{ Class: SmallInteger }"|

    lines := OrderedCollection new.

    "/ Compute the number of line segments used to approximate the curve.
    pa := middlePoint - startPoint.
    pb := endPoint - middlePoint.
    numberOfSegments := 5 max:pa x abs + pa y abs + pb x abs + pb y abs // 20.

    "/ Add all of the points necessary for the path.
    lines add:startPoint.
    1 to:numberOfSegments do:[:seg | 
        lines add:
                ((pa * seg // numberOfSegments + startPoint) * (numberOfSegments - seg)
                + ((pb * (seg - 1) // numberOfSegments + middlePoint) * (seg - 1)))
                // (numberOfSegments - 1)
    ].
    lines add:endPoint.

    ^ lines

    "Created: 9.5.1996 / 01:08:21 / cg"
! !

!Curve methodsFor:'queries'!

bounds
    "return the smallest enclosing rectangle"

    |min max|

    min := (startPoint min: endPoint) min: middlePoint.
    max := (startPoint max: endPoint) max: middlePoint.
    ^ min corner:max

    "
     (Curve from:10@10 to:50@100 through:50@50) bounds   
     (Curve from:10@10 to:50@100 through:100@50) bounds 
    "

    "Modified: 8.5.1996 / 21:18:50 / cg"
! !

!Curve methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here."

    ^ true

! !

!Curve class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Curve.st,v 1.8 2009-06-06 10:12:21 cg Exp $'
! !

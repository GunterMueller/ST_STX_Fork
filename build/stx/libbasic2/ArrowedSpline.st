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

Spline subclass:#ArrowedSpline
	instanceVariableNames:'arrowHeadPositions arrowHeadLength arrowHeadAngle'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!ArrowedSpline class methodsFor:'documentation'!

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
    ArrowedSplines are like infilled splines, with arrowHeads.

    [see also:]
        Polygon LineSegment Circle EllipticalArc 
        Rectangle Curve Arrow Spline
        GraphicsContext
        StrokingWrapper FillingWrapper

    [author:]
        Claus Gittinger
"
!

examples
"
  arrowedspline:
                                                                        [exBegin]
    |v a|

    v := View extent:100@100.

    a := ArrowedSpline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@80)).

    v addComponent:((StrokingWrapper on:a) foregroundColor:Color red).
    v open.
                                                                        [exEnd]

  filled arrow:
                                                                        [exBegin]
    |v a|

    v := View extent:100@100.

    a := ArrowedSpline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@50)
                       with:(90@10)).

    v addComponent:((FillingWrapper on:a) foregroundColor:Color red).
    v open.
                                                                        [exEnd]

  more arrowHeads:
                                                                        [exBegin]
    |v a|

    v := View extent:100@100.

    a := ArrowedSpline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@50)
                       with:(90@10)).
    a arrowHeadPositions:#(1 4).
    v addComponent:((FillingWrapper on:a) foregroundColor:Color red).
    v open.
                                                                        [exEnd]
  interactive:
                                                                        [exBegin]
    |v points eventCatcher|

    v := StandardSystemView extent:(450 @ 450).
    v label:'ArrowedSpline Example - (click left/middle)'.

    points := OrderedCollection new.
    v openAndWait.

    eventCatcher := Plug new.
    eventCatcher respondTo:#handlesButtonPress:inView:
                      with:[:butt :view | true].
    eventCatcher respondTo:#buttonPress:x:y:view:
                      with:[:butt :x :y :view | 
                            v paint:(Color white).
                            v fillCircle:(x @ y) radius:3.
                            points add:(x @ y).

                            (butt == 1 or:[butt == #select]) ifFalse:[
                                v paint:(Color white).
                                v fillCircle:(x @ y) radius:3.

                                ((ArrowedSpline controlPoints:points)
                                        arrowHeadPositions:(1 to:points size);
                                        arrowHeadLength:15)
                                        displayStrokedOn:v.

                                points := OrderedCollection new.
                            ]
                           ].

    v delegate:(eventCatcher)
                                                                        [exEnd]
"
! !

!ArrowedSpline methodsFor:'accessing'!

arrowHeadAngle
    "return the arrowHeads angle, in degrees.
     The default is defined in Arrow (150 degrees)"

    arrowHeadAngle isNil ifTrue:[^ Arrow defaultAngle].
    ^ arrowHeadAngle

    "Created: 12.5.1996 / 23:13:27 / cg"
    "Modified: 12.5.1996 / 23:14:15 / cg"
!

arrowHeadAngle:angleInDegrees
    "set the arrowHeads angle, in degrees.
     The default is defined in Arrow (150 degrees)"

    arrowHeadAngle := angleInDegrees

    "Created: 12.5.1996 / 23:13:34 / cg"
    "Modified: 12.5.1996 / 23:14:24 / cg"
!

arrowHeadLength
    "return the arrowHeads length, in pixels.
     The default is define in Arrow (8 pixels)"

    arrowHeadLength isNil ifTrue:[^ Arrow defaultLength].
    ^ arrowHeadLength

    "Modified: 13.5.1996 / 00:44:30 / cg"
!

arrowHeadLength:pixels
    "set the arrowHeads length, in pixels.
     The default is defined in Arrow (8 pixels)"

    arrowHeadLength := pixels

    "Created: 12.5.1996 / 23:15:34 / cg"
!

arrowHeadPositions:collectionOfPositions
    "set the arrowHeads positions. Each collections element gives
     theindex of a controlPoint, on which an arrowHead is drawn.
     The default is #(<controlPoints size>) i.e. a single arrowHead
     on the last controlPoint.
     To have arrowHeads on all controlPoints, define arrowHeadPositions
     as (1 to:controlPoints size)"

    arrowHeadPositions := collectionOfPositions

    "Modified: 12.5.1996 / 23:14:24 / cg"
    "Created: 13.5.1996 / 00:47:23 / cg"
! !

!ArrowedSpline methodsFor:'displaying'!

arrowPoints
    "helper: return a collection of arrow-points"

    |arrowHeadPoint len pos positions angle point grad xDis yDis
     savedLineStyle atn x1 x2 y1 y2 p1 p2 points i|

    firstDerivative isNil ifTrue:[
        self computeLineSegments
    ].

    positions := arrowHeadPositions.
    positions isNil ifTrue:[
        positions := Array with:(controlPoints size).
    ].

    len := arrowHeadLength.
    len isNil ifTrue:[
        len := Arrow defaultLength
    ].

    angle := arrowHeadAngle.
    angle isNil ifTrue:[
        angle := Arrow defaultAngle
    ].
    angle := angle degreesToRadians.

    points := Array new:(positions size * 3).
    i := 1.
    positions do:[:index |
        | p deriv|

        p := controlPoints at:index.
        deriv := (firstDerivative at:index).
        deriv isNil ifTrue:[
            deriv := (controlPoints at:index) - (controlPoints at:index-1).
        ].

        deriv x = 0
                    ifTrue: [grad := 9999999]
                    ifFalse: [grad := deriv y / deriv x].

        atn := grad arcTan.

        x1 := len * (angle - atn) cos.
        y1 := len * (angle - atn) sin.

        x2 := len * (angle + atn) cos.
        y2 := len * (angle + atn) sin.

        deriv x = 0 ifTrue: [
            deriv y > 0 ifTrue: [
                p1 := x1 @ (0 - y1).
                p2 := x2 @ (y2).
            ] ifFalse: [
                p1 := 0 - x1 @ (y1).
                p2 := 0 - x2 @ (0 - y2).
            ]
        ] ifFalse: [
            deriv x > 0 ifTrue:[
                p1 := x1 @ (0 - y1).
                p2 := x2 @ (y2).
            ] ifFalse: [
                p1 := 0 - x1 @ (y1).
                p2 := 0 - x2 @ (0 - y2)
            ]
        ].

        points at:i   put:p+p1.
        points at:i+1 put:p.
        points at:i+2 put:p+p2.
        i := i + 3
    ].

    ^ points

    "Created: 13.5.1996 / 00:50:49 / cg"
    "Modified: 5.6.1996 / 20:29:17 / cg"
!

displayArrowsOn:aGC filled:filled
    "display the receiver in the graphicsContext, aGC"

    |arrowPoints savedLineStyle nP "{Class: SmallInteger }"
     p1 p p2|

    savedLineStyle := aGC lineStyle.
    aGC lineStyle:#solid.

    arrowPoints := self arrowPoints.
    nP := arrowPoints size.
    1 to:nP by:3 do:[:i |
        p1 := arrowPoints at:i.
        p := arrowPoints at:i+1.
        p2 := arrowPoints at:i+2.

        filled ifTrue:[
            aGC fillPolygon:(Array with:p1 with:p with:p2).
        ] ifFalse:[
            aGC displayLineFrom:p to:p1.
            aGC displayLineFrom:p to:p2.
        ].
    ].

    aGC lineStyle:savedLineStyle.

    "Created: 13.5.1996 / 00:50:49 / cg"
    "Modified: 13.5.1996 / 00:52:17 / cg"
!

displayFilledOn:aGC
    "display the receiver in the graphicsContext, aGC"

    super displayStrokedOn:aGC.
    self displayArrowsOn:aGC filled:true

    "Created: 13.5.1996 / 00:51:14 / cg"
!

displayStrokedOn:aGC
    "display the receiver in the graphicsContext, aGC"

    super displayStrokedOn:aGC.
    self displayArrowsOn:aGC filled:false

    "Created: 13.5.1996 / 00:51:14 / cg"
    "Modified: 13.5.1996 / 00:52:34 / cg"
! !

!ArrowedSpline methodsFor:'queries'!

computeBounds
    "return the smallest enclosing rectangle"

    |minX maxX minY maxY|

    minX := maxX := 0.
    minY := maxY := 0.

    self arrowPoints do:[:p |
        |x y|

        x := p x.
        y := p y.
        minX := minX min:x.
        maxX := maxX max:x.
        minY := minY min:y.
        maxY := maxY max:y.
    ].    
    ^ Rectangle left:minX right:maxX top:minY bottom:maxY

    "Modified: 26.5.1996 / 13:08:48 / cg"
    "Created: 12.2.1997 / 11:42:41 / cg"
! !

!ArrowedSpline methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here. Notice, that only the arrowHeads are filled."

    ^ true

! !

!ArrowedSpline class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/ArrowedSpline.st,v 1.10 2009-06-06 10:12:15 cg Exp $'
! !

"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Geometric subclass:#Circle
	instanceVariableNames:'center radius'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Circle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
     This class implements a circles which are defined by a radius and
     a centerpoint.

    [author:]
        Claus Gittinger

    [see also:]
        EllipticalArc Spline Curve Polygon Rectangle LineSegment
        Arrow ArrowedSpline
        GraphicsContext
        StrokingWrapper FillingWrapper
"
!

examples
"
  circle; filled and unfilled:
                                                                        [exBegin]
    |v c|

    v := (View extent:200@100) openAndWait.

    c := Circle boundingBox:(10@10 corner:90@90). 

    v paint:Color blue.
    c displayFilledOn:v.

    c center:150@50.
    v paint:Color red.
    c displayStrokedOn:v.

                                                                        [exEnd]
  circle & rectangle; both filled:
                                                                        [exBegin]
    |v c|

    v := (View extent:100@100) openAndWait.

    c := Circle center:50@50 radius:40. 

    v paint:Color red.
    c asRectangle displayFilledOn:v.

    v paint:Color blue.
    c displayFilledOn:v.

                                                                        [exEnd]
  circles; filled & unfilled:
                                                                        [exBegin]
    |v c|

    v := View new openAndWait.

    c := Circle center:50@50 radius:40.

    v paint:Color red.
    c displayFilledOn:v.
    50 to:1 by:-1 do:[:r |
        c radius:r.
        v paint:(Color grey:(r * 2)).
        c displayStrokedOn:v.
    ].
    1 to:50 do:[:r |
        c radius:r.
        v paint:(Color grey:100-(r * 2)).
        c displayStrokedOn:v.
    ]

                                                                        [exEnd]
  more arcs; filled:
                                                                        [exBegin]
    |v ell|

    v := View new openAndWait.

    ell := EllipticalArc
                boundingBox:(10@10 corner:90@90) 
                startAngle:0
                sweepAngle:0.

    #(45 90 135 180 225 270 315 360) 
    keysAndValuesReverseDo:[:index :angle |
        index odd ifTrue:[
            v paint:Color white
        ] ifFalse:[
            v paint:Color black
        ].
        ell sweepAngle:angle.
        ell displayFilledOn:v.
        Delay waitForSeconds:0.1.
    ].

                                                                        [exEnd]
  more arcs; filled:
                                                                        [exBegin]
    |v ell|

    v := View new openAndWait.

    ell := EllipticalArc
                boundingBox:(10@10 corner:90@90) 
                startAngle:0
                sweepAngle:45.

    #(45 90 135 180 225 270 315 360) 
    with:#( 0.125 0.25 0.375 0.5 0.625 0.75 0.875 1)
    do:[:angle :grey |
        ell startAngle:angle-45.
        v paint:(ColorValue red:grey green:0 blue:0).
        ell displayFilledOn:v.
    ].

                                                                        [exEnd]
"
! !

!Circle class methodsFor:'instance creation'!

boundingBox:aRectangle
    "Return a new Circle centered in aRectangle."

    ^ self
        center:(aRectangle center)
        radius:(aRectangle width min:aRectangle height) / 2
!

center:centerPoint radius:radius
    "Return a new Circle."

    ^ self new center:centerPoint radius:radius

    "Modified: 8.5.1996 / 20:39:30 / cg"
! !

!Circle methodsFor:'accessing'!

center 
    "return the center."

    ^ center
!

center:aPoint 
    "set the center point."

    center := aPoint
!

center:centerPoint radius:radiusNumber
    "set the center and radius"

    center := centerPoint.
    radius := radiusNumber
!

radius 
    "return the radius."

    ^ radius
!

radius:aNumber 
    "set the radius."

    radius := aNumber
! !

!Circle methodsFor:'converting'!

asEllipticalArc
    "convert the receiver into an ellipticalArc"

    ^ EllipticalArc center:center radius:radius 
! !

!Circle methodsFor:'displaying'!

displayFilledOn:aGC
    "draw the receiver as a filled circle in a graphicsContext, aGC"

    aGC fillCircle:center radius:radius
!

displayStrokedOn:aGC
    "draw the receiver as a unfilled circle in a graphicsContext, aGC"

    aGC displayCircle:center radius:radius

! !

!Circle methodsFor:'queries'!

area
    "return the area of the receiver."

    ^ radius * radius * (Float pi)
!

bounds
    "return the smallest enclosing rectangle"

    ^ Rectangle origin:(center - radius) corner:(center + radius)

    "
     (Circle center:100@100 radius:50) bounds 
    "
!

diameter
    "return the diameter of the receiver."

    ^ radius * 2
!

startAngle
    "return the startAngle.
     Provided for protocol compatibility with arcs and ellipese;
     for circles, this is an arbitrary angle."

    ^ 0
!

sweepAngle
    "return the sweepAngle.
     Provided for protocol compatibility with arcs and ellipese;
     for circles, this is always 360 degrees."

    ^ 360
! !

!Circle methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn filled; always true here"

    ^ true
! !

!Circle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Circle.st,v 1.13 2009-06-06 10:12:18 cg Exp $'
! !

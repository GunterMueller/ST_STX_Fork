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

"{ NameSpace: Smalltalk }"

Geometric subclass:#EllipticalArc
	instanceVariableNames:'boundingBox startAngle sweepAngle'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!EllipticalArc class methodsFor:'documentation'!

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
     This class implements an ellipse which is aligned to x and y axes
     given a boundingBox, a startAngle and a sweepAngle.
     Positive angles are taken clockwise, negative angles are counterclockwise.

    [author:]
        Claus Gittinger

    [see also:]
        Circle Spline Curve LineSegment Polygon Rectangle Arrow
        ArrowedSpline
        GraphicsContext
        StrokingWrapper FillingWrapper
"
!

examples
"
  ellipses; filled & unfilled:
                                                                        [exBegin]
    |v e|

    v := (View extent:200@100) openAndWait.

    e := EllipticalArc 
            boundingBox:(10@10 corner:190@90)
            startAngle:0
            endAngle:360. 

    v paint:Color blue.
    e displayFilledOn:v.

    v paint:Color red.
    e displayStrokedOn:v.

                                                                        [exEnd]
  elliptical arcs; filled & unfilled:
                                                                        [exBegin]
    |v e|

    v := (View extent:200@100) openAndWait.

    e := EllipticalArc 
            boundingBox:(10@10 corner:190@90)
            startAngle:0
            endAngle:270. 

    v paint:Color blue.
    e displayFilledOn:v.

    v paint:Color red.
    e displayStrokedOn:v.

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

!EllipticalArc class methodsFor:'instance creation'!

boundingBox:aRectangle
    "Return a new EllipticalArc."

    ^ self new boundingBox:aRectangle
!

boundingBox:aRectangle startAngle:startAngle endAngle:endAngle
    "Return a new EllipticalArc."

    ^ self boundingBox:aRectangle startAngle:startAngle sweepAngle:(endAngle - startAngle)
!

boundingBox:aRectangle startAngle:startAngle sweepAngle:sweepAngle
    "Return a new EllipticalArc."

    ^ self new boundingBox:aRectangle startAngle:startAngle sweepAngle:sweepAngle
!

center:centerPoint radius:radius
    "Return a new Circle."

    ^ self new center:centerPoint radius:radius
!

center:centerPoint radius:radius startAngle:startAngle endAngle:endAngle
    "Return a new (circular) Arc."

    ^ (self new center:centerPoint radius:radius)
        startAngle:startAngle; sweepAngle:(endAngle - startAngle)

    "Created: 17.5.1996 / 09:58:36 / cg"
    "Modified: 17.5.1996 / 09:59:16 / cg"
!

center:centerPoint radius:radius startAngle:startAngle sweepAngle:sweepAngle
    "Return a new (circular) Arc."

    ^ (self new center:centerPoint radius:radius)
        startAngle:startAngle; sweepAngle:sweepAngle

    "Created: 17.5.1996 / 09:59:08 / cg"
! !

!EllipticalArc methodsFor:'accessing'!

boundingBox:aRectangle
    "setup the arc, given a bounding rectangle"

    boundingBox := aRectangle.
    startAngle := 0.
    sweepAngle := 360

    "Modified: 17.5.1996 / 10:05:06 / cg"
!

boundingBox:aRectangle startAngle:start sweepAngle:sweep
    "setup the arc, given a bounding rectangle, start and endAngle"

    boundingBox := aRectangle.
    startAngle := start.
    sweepAngle := sweep

    "Modified: 17.5.1996 / 10:05:27 / cg"
!

center:centerPoint radius:radius
    "setup for a circular arc, given center and radius"

    boundingBox := Rectangle
                        left:(centerPoint x - radius)
                        top:(centerPoint y - radius)
                        width:(radius * 2)
                        height:(radius * 2).
    startAngle := 0.
    sweepAngle := 360.

    "Created: 17.5.1996 / 10:07:35 / cg"
!

endAngle
    "return the endAngle."

    ^ startAngle + sweepAngle
!

startAngle
    "return the startAngle."

    ^ startAngle
!

startAngle:angle
    "set the startAngle."

    startAngle := angle
!

sweepAngle
    "return the sweepAngle."

    ^ sweepAngle
!

sweepAngle:angle
    "set the sweepAngle."

    sweepAngle := angle
! !

!EllipticalArc methodsFor:'converting'!

asEllipticalArc
    "convert the receiver into an ellipticalArc - that's the receiver itself"

    ^ self 
! !

!EllipticalArc methodsFor:'displaying'!

displayFilledOn:aGC
    "draw the receiver as a filled arc in a graphicsContext, aGC"

    aGC fillArcX:boundingBox left
               y:boundingBox top
           width:boundingBox width
          height:boundingBox height
            from:startAngle
              to:(startAngle+sweepAngle)
!

displayStrokedOn:aGC
    "draw the receiver as a unfilled arc in a graphicsContext, aGC"

    aGC displayArcX:boundingBox left
                  y:boundingBox top
              width:boundingBox width
             height:boundingBox height
               from:startAngle
              angle:sweepAngle
! !

!EllipticalArc methodsFor:'queries'!

center
    "return the center"

    ^ boundingBox center
!

computeBounds
    "return the smallest enclosing rectangle"

    ^ boundingBox

    "Created: 12.2.1997 / 11:43:00 / cg"
! !

!EllipticalArc methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here."

    ^ true
! !

!EllipticalArc class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


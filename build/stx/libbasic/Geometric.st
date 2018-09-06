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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Geometric
	instanceVariableNames:''
	classVariableNames:'Scale InverseScale'
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Geometric class methodsFor:'documentation'!

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
    Abstract superclass for geometric figures.
    Concrete classes are (currently) Rectangle, Polygon and the classes
    found in goodies/shape.

    These are not graphical objects, but pure mathematical ones.
    I.e. instances do not carry graphics attributes such as color, lineWidth etc.
    However, they ``know'' how to display themself as stroked or possibly
    filled picture on a graphicsContext (although, the GC's current
    paint and lineStyles are used).

    Use instances of (subclasses) of DisplayObject or 
    of the GeometricWrapper classes for objects which keep the color 
    and lineStyle information with them.

    Notice: 
        ST/X does not use Geometric instances for drawing (yet).
        Except for Rectangle, Geometry and its subclasses exists mainly 
        for ST-80 compatibility and to provide a home when other (PD) 
        geometry classes are to be filed in.

    [author:]
        Claus Gittinger

    [see also:]
        Rectangle Polygon EllipticalArc Circle Spline Point
        LineSegment Curve Arrow ArrowedSpline
        GraphicsContext
        StrokingWrapper FillingWrapper
"
!

examples
"
  line segment:
                                                                        [exBegin]
    |v l|

    v := (View extent:100@100) openAndWait.

    l := LineSegment from:10@10 to:90@90. 

    v paint:Color red.
    l displayStrokedOn:v.

    l start:90@10 end:10@90.
    v paint:Color blue.
    l displayStrokedOn:v.
                                                                        [exEnd]

  rectangle, unfilled:
                                                                        [exBegin]
    |v r|

    v := (View extent:100@100) openAndWait.

    r := Rectangle origin:10@10 corner:90@90. 

    v paint:Color red.
    r displayStrokedOn:v.
                                                                        [exEnd]

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
  polygon; filled & unfilled:
                                                                        [exBegin]
    |v p|

    v := (View extent:100@100) openAndWait.

    p := Polygon vertices:
                (Array with:(10@10)
                       with:(90@90)
                       with:(10@90)).

    v paint:Color blue.
    p displayFilledOn:v.

    v paint:Color red.
    p displayStrokedOn:v.
                                                                        [exEnd]

  circles; filled & unfilled:
                                                                        [exBegin]
    |v c|

    v := View new openAndWait.

    c := Circle center:50@50 radius:40.

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
  arcs; filled:
                                                                        [exBegin]
    |v ell|

    v := View new openAndWait.

    ell := EllipticalArc
                boundingBox:(10@10 corner:90@90) 
                startAngle:0
                sweepAngle:0.

    #(45 90 135 180 225 270 315 360) keysAndValuesDo:[:index :angle |
        index odd ifTrue:[
            v paint:Color white
        ] ifFalse:[
            v paint:Color black
        ].
        ell sweepAngle:angle.
        ell displayFilledOn:v.
        Delay waitForSeconds:0.5.
    ].

                                                                        [exEnd]
  arcs; filled:
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
  spline; filled & unfilled:
                                                                        [exBegin]
    |v p|

    v := (View extent:100@100) openAndWait.

    p := Spline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@80)).

    v paint:Color blue.
    p displayFilledOn:v.

    v paint:Color red.
    p displayStrokedOn:v.
                                                                        [exEnd]

  closed spline; filled & unfilled:
                                                                        [exBegin]
    |v p|

    v := (View extent:100@100) openAndWait.

    p := Spline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@80)
                       with:(20@20)).

    v paint:Color blue.
    p displayFilledOn:v.

    v paint:Color red.
    p displayStrokedOn:v.
                                                                        [exEnd]
"
! !

!Geometric class methodsFor:'initialization'!

initialize
    "setup class constants"

    "/ these are note used in ST/X;
    "/ (acc. to a testers note, ST-80 internally uses
    "/  integer valued coordinates, scaling coordinates by
    "/  the Scale constant. ST/X does not do this. However,
    "/  user supplied subclasses may depend on those values being
    "/  present ...)

    Scale := 4096.
    InverseScale := 1.0 / Scale

    "
     Geometric initialize
    "

    "Modified: 12.2.1997 / 14:11:49 / cg"
! !

!Geometric class methodsFor:'helper functions'!

boundingRectangleForPoints:aSequencableCollectionOfPoints
    "given a bunch of point, compute the boundingRectangle
     (i.e. the smallest rectangle which encloses all of those points)"

    |p minX minY maxX maxY n "{ Class: SmallInteger }"
     x y |

    p := aSequencableCollectionOfPoints first.
    minX := maxX := p x.
    minY := maxY := p y.

    n := aSequencableCollectionOfPoints size.
    1 to:n do:[:idx | 
        p := aSequencableCollectionOfPoints at:idx.
        x := p x.
        y := p y.
        x < minX ifTrue:[
            minX := x
        ] ifFalse:[
            x > maxX ifTrue:[
                maxX := x
            ]
        ].
        y < minY ifTrue:[
            minY := y
        ] ifFalse:[
            y > maxY ifTrue:[
                maxY := y
            ]
        ].
    ].

    ^ Rectangle left:minX top:minY right:maxX bottom:maxY

    "Modified: 12.2.1997 / 12:10:12 / cg"
! !

!Geometric methodsFor:'converting'!

asFiller
    "return a wrapper which displays the receiver in its filled form"

    self canBeFilled ifTrue:[
        ^ FillingWrapper on:self
    ].
    ^ self shouldNotImplement

    "
     |v r|

     v := View new.
     v extent:200@200.
     v openAndWait.
     r := Rectangle origin:10@10 corner:100@100.
     r asFiller displayOn:v.
    "

    "Modified: 12.2.1997 / 11:47:22 / cg"
!

asRectangle
    "return the enclosing rectangle; same as #bounds"

    ^ self bounds

    "Created: 8.5.1996 / 14:36:35 / cg"
!

asStroker
    "return a wrapper which displays the receiver as stroked outline"

    ^ StrokingWrapper on:self

    "Created: 8.5.1996 / 14:38:09 / cg"
    "Modified: 8.5.1996 / 18:23:00 / cg"
!

asVisualComponent
    "return a wrapper on the receiver, which responds to VisualComponent messages."

    ^ self asStroker

    "Created: 10.2.1997 / 12:04:27 / cg"
! !

!Geometric methodsFor:'displaying'!

ascentOn:aGC
    "displayOn: does not draw above baseline"

    ^ 0
!

displayFilledOn:aGC
    "display myself filled on a graphicsContext; the current graphics
     attributes are used. Since we do not know how to do it, nothing is
     drawn here."

    ^ self subclassResponsibility

    "
     |v r|

     v := View new.
     v extent:200@200.
     v openAndWait.
     r := Rectangle origin:10@10 corner:100@100.
     r displayFilledOn:v.
    "

    "Modified: 8.5.1996 / 09:07:02 / cg"
!

displayOn:aGCOrStream
    "display myself on a graphicsContext; the current graphics
     attributes are used. The default here is to display the outline."

    "/ what a kludge - Dolphin and Squeak mean: printOn:;
    "/ ST/X (and some old ST80's) mean: draw-yourself on.
    (aGCOrStream isStream) ifTrue:[
        ^ super displayOn:aGCOrStream
    ].
    ^ self displayStrokedOn:aGCOrStream

    "
     |v r|

     v := View new.
     v extent:200@200.
     v openAndWait.
     r := Rectangle origin:10@10 corner:100@100.
     r displayOn:v.
    "
!

displayStrokedOn:aGC
    "display my outline on a graphicsContext; the current graphics
     attributes are used. Since we do not know how to do it, nothing is
     drawn here."

    ^ self subclassResponsibility

    "Modified: 8.5.1996 / 21:20:19 / cg"
! !

!Geometric methodsFor:'queries'!

bounds
    "return the smallest enclosing rectangle.
     This resends computeBounds, to allow caching of bounds in
     case this computation is expensive."

    ^ self computeBounds

    "Created: 8.5.1996 / 13:56:08 / cg"
    "Modified: 12.2.1997 / 11:41:38 / cg"
!

computeBounds
    "return the smallest enclosing rectangle."

    ^ self subclassResponsibility

    "Created: 12.2.1997 / 11:41:58 / cg"
!

outlineIntersects:aRectangle
    "return true, if the receiver's image intersects
     aRectangle, when drawn as an outline.
     Here, all we can do is to ask the boundary rectangle;
     subclasses should reimplement better checks."

    ^ self bounds intersects:aRectangle

    "Modified: 10.2.1997 / 13:40:36 / cg"
!

regionIntersects:aRectangle
    "return true, if the receiver's image intersects
     aRectangle, when drawn as a filled version.
     Here, all we can do is to ask the boundary rectangle;
     subclasses should reimplement better checks."

    ^ self bounds intersects:aRectangle

    "Modified: 10.2.1997 / 13:40:00 / cg"
! !

!Geometric methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Return false here, since we don't know."

    ^ false

    "Created: 1.6.1996 / 11:28:58 / cg"
!

isBezier2Segment
    "return true, if the receiver is a quadratic bezier segment"

    ^ false
!

isLineSegment
    "return true, if the receiver is a line segment"

    ^ false
! !

!Geometric methodsFor:'transformations'!

align:offset with:someCoordinate
    self subclassResponsibility
!

alignBottomLeftWith:someCoordinate
    "return a copy of myself where its bottomLeft is aligned with someCoordinate"

    ^ self align:(self bounds bottomLeft) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignBottomLeftWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

alignBottomRightWith:someCoordinate
    "return a copy of myself where its bottomRight is aligned with someCoordinate.
     Same as alignCorner"

    ^ self align:(self bounds corner) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignBottomRightWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

alignCenterWith:someCoordinate
    "return a copy of myself where its center is aligned with someCoordinate.
     Same as alignOrigin"

    ^ self align:(self bounds center) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignCenterWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

alignCornerWith:someCoordinate
    "return a copy of myself where its corner is aligned with someCoordinate"

    ^ self align:(self bounds corner) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignCornerWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

alignOriginWith:someCoordinate
    "return a copy of myself where its origin is aligned with someCoordinate"

    ^ self align:(self bounds origin) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignOriginWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

alignTopLeftWith:someCoordinate
    "return a copy of myself where its topLeft is aligned with someCoordinate.
     Same as alignOrigin"

    ^ self align:(self bounds origin) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignTopLeftWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

alignTopRightWith:someCoordinate
    "return a copy of myself where its topRight is aligned with someCoordinate.
     Same as alignOrigin"

    ^ self align:(self bounds topRight) with:someCoordinate

    "
     |r1 r2 r3 v|

     r1 := 0@0 corner:10@10.
     r2 := 100@100 corner:200@200.
     r3 := r1 copy alignTopRightWith:r2 corner.
     v := (View extent:300@300) openAndWait.
     r2 displayOn:v.   
     r3 displayOn:v.   
    "
!

scaledBy:scaleAmount 
    "return a copy of the receiver, which is scaled by the argument,
     a point or number"

    ^ self subclassResponsibility

    "Created: 10.2.1997 / 12:05:45 / cg"
!

translatedBy:scaleAmount 
    "return a copy of the receiver, which is translated by the argument,
     a point or number"

    ^ self subclassResponsibility

    "Created: 10.2.1997 / 12:05:56 / cg"
! !

!Geometric class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


Geometric initialize!

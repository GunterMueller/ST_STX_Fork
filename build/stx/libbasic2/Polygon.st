"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

Geometric subclass:#Polygon
	instanceVariableNames:'vertices'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Polygon class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    Polygon - an array of points

    Adds simple boundary checking methods to Array.
    (needs much more - such as inside check, area computation etc.)

    [author:]
        Claus Gittinger

    [see also:]
        Rectangle EllipticalArc Spline Circle Point LineSegment Curve
        Arrow ArroedSpline
        GraphicsContext StrokingWrapper FillingWrapper
"
!

examples
"
  simple polygon; filled & unfilled:
                                                                        [exBegin]
    |v p|

    v := (View extent:200@200) openAndWait.

    p := Polygon vertices:
                (Array with:(10@10)
                       with:(90@90)
                       with:(10@90)).

    v scale:2.
    v paint:Color blue.
    p displayFilledOn:v.

    v paint:Color red.
    p displayStrokedOn:v.

    v scale:1; translation:100@0.
    v paint:Color green.
    p displayFilledOn:v.

    v paint:Color black.
    p displayStrokedOn:v.
                                                                        [exEnd]

  arbitrary polygon; filled & unfilled:
                                                                        [exBegin]
    |v p|

    v := (View extent:200@200) openAndWait.
    v scale:2.

    p := Polygon vertices:
                (Array with:(10@10)
                       with:(90@90)
                       with:(50@90)
                       with:(90@10)
                       with:(10@90)
                                   ).

    v paint:Color blue.
    p displayFilledOn:v.

    v paint:Color red.
    p displayStrokedOn:v.
                                                                        [exEnd]
"
! !

!Polygon class methodsFor:'instance creation'!

fromRectangle:aRectangle
    "return a new polygon, taking the rectangles vertices"

    ^ self new vertices:(aRectangle asPointArray)

    "
     Polygon fromRectangle:(50@50 corner:100@100)
    "

    "Modified: 8.5.1996 / 20:15:18 / cg"
!

vertices:anArrayOfPoints
    "return a new polygon, given a collection of vertices"

    ^ self new vertices:anArrayOfPoints

    "
     Polygon vertices:(Array with:10@10
                             with:20@20
                             with:30@30)

     Polygon vertices:(#(10 10  100 0  50 50) pairWiseCollect:[:x :y | x @ y]).
    "

    "
     |p v|

     v := View new openAndWait.
     p := Polygon 
            vertices:(Array with:10@10
                            with:20@10
                            with:20@30).
     p displayOn:v
    "

    "Modified: 8.5.1996 / 20:11:31 / cg"
! !

!Polygon methodsFor:'accessing'!

add:aPoint
    vertices isNil ifTrue:[
        vertices := OrderedCollection new
    ].
    vertices add:aPoint
!

vertices
    "return the array containing my points"

    ^ vertices
!

vertices:anArrayOfPoints
    "set the array containing my points"

    vertices := anArrayOfPoints
! !

!Polygon methodsFor:'converting'!

asPointArray
    "return an array containing my vertex points.
     Notice, that no copy of my vertices is created - you should not
     modify the returned collections points (unless you want to affect
     the polygon ...)."

    ^ vertices

    "Modified: 8.5.1996 / 20:43:39 / cg"
! !

!Polygon methodsFor:'displaying'!

displayFilledOn:aGC
    "display a filled polygin as represented by the receiver in 
     the graphicsContext, aGC"

    aGC fillPolygon:vertices 

    "
     |v|
     v := View new openAndWait.

     (Polygon vertices:(
          Array
            with:10@10
            with:60@10
            with:35@60)) displayFilledOn:v

     |v|
     v := View new openAndWait.

     (Polygon vertices:(
        Array
            with:10@10
            with:60@10
            with:35@60
            with:10@10)) displayStrokedOn:v
    "

    "Modified: 8.5.1996 / 14:41:47 / cg"
!

displayStrokedOn:aGC
    "display an unfilled polygin as represented by the receiver in 
     the graphicsContext, aGC"

    aGC displayPolygon:vertices 

    "
     |v|

     v := View new open.
     [v shown] whileFalse:[Processor yield].

     (Polygon vertices:(
        Array
            with:10@10
            with:60@10
            with:35@60)) displayStrokedOn:v

     |v|

     v := View new open.
     [v shown] whileFalse:[Processor yield].

     (Polygon vertices:(
        Array
            with:10@10
            with:60@10
            with:35@60
            with:10@10)) displayStrokedOn:v
    "

    "Modified: 27.4.1996 / 14:52:29 / cg"
! !

!Polygon methodsFor:'enumerating'!

edgesDo:aTwoArgBlock
    "evaluate aTwoArgBlock for each pair of vertices"

    1 to:vertices size-1 do:[:i |
	aTwoArgBlock value:(vertices at:i) value:(vertices at:i+1)
    ].

    "
     |v p|

     v := View new open.
     [v shown] whileFalse:[Processor yield].

     p := Polygon vertices:(Array with:5@5 
				  with:50@5 
				  with:30@30
				  with:5@5).

     p displayOn:v.
     (Delay forSeconds:3) wait.

     p edgesDo:[:p1 :p2 | v lineWidth:3. v displayLineFrom:p1 to:p2] 
    "
!

verticesDo:aBlock
    "evaluate aBlock for each point"

    vertices do:aBlock

    "
     |v p|

     v := View new open.
     [v shown] whileFalse:[Processor yield].

     p := Polygon vertices:(Array with:5@5 
				  with:50@5 
				  with:30@30
				  with:5@5).

     p displayOn:v.
     (Delay forSeconds:3) wait.

     p verticesDo:[:p | v displayRectangleX:p x -3  y:p y -3  width:6 height:6] 
    "
! !

!Polygon methodsFor:'queries'!

bottom
    "return the bottom boundary of the polygon,
     that is the maximum y coordinate of all its points"

    (vertices size == 0) ifTrue: [^ nil].
    ^ vertices inject:(vertices at:1) y into:[:maxSoFar :p | maxSoFar max:(p y)]

    "
     (Polygon vertices:(
	Array
	    with:10@10
	    with:60@10
	    with:35@60)) bottom 
    "
!

computeBounds
    "return the smallest enclosing rectangle"

    |minX maxX minY maxY t n "{ Class: SmallInteger }" |

    n := vertices size.
    n == 0 ifTrue:[
        ^ nil    "/ mhmh - should we return an empty rectangle here ?
    ].
    t := vertices at:1.
    minX := maxX := t x.
    minY := maxY := t y.
    2 to:n do:[:i |
        |x y|

        t := vertices at:i.
        x := t x.
        y := t y.
        x < minX ifTrue:[
            minX := x.
        ] ifFalse:[
            x > maxX ifTrue:[
                maxX := x.
            ]
        ].
        y < minY ifTrue:[
            minY := y.
        ] ifFalse:[
            y > maxY ifTrue:[
                maxY := y.
            ]
        ].
    ].
    ^ Rectangle left:minX top:minY right:maxX bottom:maxY.

    "
     |p|

     p := (Polygon vertices:(
            Array
                with:10@10
                with:60@10
                with:35@60)).
     p bounds 
    "

    "Modified: 8.5.1996 / 20:51:42 / cg"
    "Created: 12.2.1997 / 11:44:11 / cg"
!

containsPoint:aPoint
    "return true, if the argument, aPoint is contained in the receiver"

    |angle pPrev p1 p2 angle2D|

    angle2D := [:p1 :p2 |
        "/   Return the angle between two vectors on a plane
        "/   The angle is from vector 1 to vector 2, positive anticlockwise
        "/   The result is between -pi -> pi
        |theta theta1 theta2|

        theta1 := p1 x arcTan2:p1 y.
        theta2 := p2 x arcTan2:p2 y.
        theta := theta2 - theta1.
        [theta > Float pi] whileTrue:[
            theta := theta - (Float pi * 2)
        ].
        [ theta < (Float pi negated) ] whileTrue:[
            theta := theta + (Float pi * 2)
        ].
        theta
    ].

    angle := 0.

    pPrev := vertices last.
    vertices do:[:pI |
        p1 := pPrev - aPoint.
        p2 := pI - aPoint.
        angle := angle + (angle2D value:p1 value:p2).
        pPrev := pI.
    ].

    ^ angle abs >= Float pi

    "
     |p|

     p := Polygon vertices:(Array 
                             with:10@10
                             with:30@10
                             with:20@20).
     TestCase assert:(p containsPoint:14@11).     
     TestCase assert:(p containsPoint:15@15).     
     TestCase assert:(p containsPoint:5@15) not.
     TestCase assert:(p containsPoint:15@5) not.
     TestCase assert:(p containsPoint:30@15) not. 
     TestCase assert:(p containsPoint:20@15).       
    "
!

left
    "return the left boundary of the polygon,
     that is the minimum x coordinate of all its points"

    (vertices size == 0) ifTrue: [^ nil].
    ^ vertices inject:(vertices at:1) x into:[:minSoFar :p | minSoFar min:(p x)]

    "
     (Polygon vertices:(
	Array
	    with:10@10
	    with:60@10
	    with:35@60)) left  
    "

!

right
    "return the right boundary of the polygon,
     that is the maximum x coordinate of all its points"

    (vertices size == 0) ifTrue: [^ nil].
    ^ vertices inject:(vertices at:1) x into:[:maxSoFar :p | maxSoFar max:(p x)]

    "
     (Polygon vertices:(
	Array
	    with:10@10
	    with:60@10
	    with:35@60)) right  
    "

!

top
    "return the top boundary of the polygon,
     that is the minimum y coordinate of all its points"

    (vertices size == 0) ifTrue: [^ nil].
    ^ vertices inject:(vertices at:1) y into:[:minSoFar :p | minSoFar min:(p y)]

    "
     (Polygon vertices:(
	Array
	    with:10@10
	    with:60@10
	    with:35@60)) top  
    "

! !

!Polygon methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here."

    ^ true

    "Created: 8.5.1996 / 08:16:53 / cg"
! !

!Polygon class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


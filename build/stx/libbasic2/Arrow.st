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

"{ NameSpace: Smalltalk }"

LineSegment subclass:#Arrow
	instanceVariableNames:'arrowHeadPosition arrowHeadLength arrowHeadAngle arrowHeadClosed'
	classVariableNames:'DefaultLength DefaultAngle'
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Arrow class methodsFor:'documentation'!

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
    Arrows are just what the name says - a directed LineSegment, which
    draws itself with an arrowHead. The position of the arrowhead can
    be set to be anywhere along the lineSegment (default is at the end).

    Arrows can be drawn stroked or filled - when filled, only the arrowHead
    is filled.

    [author:]
        Claus Gittinger

    [see also:]
        Rectangle Polygon EllipticalArc Circle Spline Curve Point 
        LineSegment ArrowedSpline 
        GraphicsContext
        StrokingWrapper FillingWrapper
"
!

examples
"
  low level use:
                                                                        [exBegin]
    |v a|

    v := (View extent:100@100) openAndWait.

    a := Arrow from:10@10 to:90@90. 

    v paint:Color red.
    a displayStrokedOn:v.

    a start:90@10 end:10@90.
    v paint:Color blue.
    a displayStrokedOn:v.
                                                                        [exEnd]

  with closed arrowHead:
                                                                        [exBegin]
    |v a|

    v := (View extent:100@100) openAndWait.

    a := Arrow from:10@10 to:90@90. 
    a arrowHeadClosed:true.
    v paint:Color red.
    a displayStrokedOn:v.

    a start:90@10 end:10@90.
    v paint:Color blue.
    a displayStrokedOn:v.
                                                                        [exEnd]

  with longer closed arrowHead:
                                                                        [exBegin]
    |v a|

    v := (View extent:100@100) openAndWait.

    a := Arrow from:10@10 to:90@90. 
    a arrowHeadClosed:true.
    a arrowHeadLength:16.
    v paint:Color red.
    a displayStrokedOn:v.

    a start:90@10 end:10@90.
    v paint:Color blue.
    a displayStrokedOn:v.
                                                                        [exEnd]

  as component (automatic redraw):
                                                                        [exBegin]
    |v a|

    v := View extent:100@100.

    a := Arrow from:50@50 to:10@10. 
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:50@50 to:90@10. 
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:50@50 to:10@90. 
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:50@50 to:90@90. 
    v addComponent:(StrokingWrapper on:a).

    v open
                                                                        [exEnd]

  as component filled vs. stroked:
                                                                        [exBegin]
    |v a|

    v := View extent:100@100.

    a := Arrow from:10@10 to:90@10. 
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:90@20 to:10@20. 
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:10@50 to:90@50. 
    v addComponent:(FillingWrapper on:a).

    a := Arrow from:90@60 to:10@60. 
    v addComponent:(FillingWrapper on:a).

    v open
                                                                        [exEnd]

  as component (varying lineStyles):
                                                                        [exBegin]
    |v a|

    v := View extent:100@100.

    a := Arrow from:10@10 to:90@90. 
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:10@10 to:90@10.
    a arrowHeadPosition:0.5.
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:90@10 to:10@90. 
    v addComponent:((StrokingWrapper on:a) foregroundColor:(Color red)).

    a := Arrow from:10@50 to:90@50. 
    a arrowHeadLength:20; arrowHeadAngle:130.

    v addComponent:((StrokingWrapper on:a) 
                        lineWidth:5;
                        foregroundColor:(Color red)).

    a := Arrow from:50@90 to:50@10. 
    a arrowHeadLength:10; arrowHeadAngle:170.

    v addComponent:((StrokingWrapper on:a) 
                        lineWidth:2;
                        lineStyle:#dashed;
                        foregroundColor:(Color red);
                        backgroundColor:(Color yellow)).

    v open.
                                                                        [exEnd]
  varying the position:
                                                                        [exBegin]
    |v a|

    v := View extent:200@100.

    a := Arrow from:10@10 to:90@10. 
    a arrowHeadPosition:0.
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:10@30 to:90@30. 
    a arrowHeadPosition:(1/3).
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:10@40 to:90@40. 
    a arrowHeadPosition:0.5.
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:10@50 to:90@50. 
    a arrowHeadPosition:(2/3).
    v addComponent:(StrokingWrapper on:a).

    a := Arrow from:10@70 to:90@70. 
    v addComponent:(StrokingWrapper on:a).


    a := Arrow from:100@10 to:150@90.
    a arrowHeadPosition:(1/3).
    v addComponent:(FillingWrapper on:a).

    a := Arrow from:110@10 to:160@90.
    a arrowHeadPosition:(2/3).
    v addComponent:(FillingWrapper on:a).

    a := Arrow from:120@10 to:170@90.
    v addComponent:(FillingWrapper on:a).

    v open.
                                                                        [exEnd]
"
! !

!Arrow class methodsFor:'initialization'!

initialize
    DefaultAngle := 150.
    DefaultLength := 8

    "
     Arrow initialize
    "
! !

!Arrow class methodsFor:'accessing-defaults'!

defaultAngle
    ^ DefaultAngle
!

defaultLength
    ^ DefaultLength
! !

!Arrow class methodsFor:'displaying'!

arrowPointsFor:sP and:eP position:arrowHeadPosition length:arrowHeadLength angle:arrowHeadAngle
    "return the arrowPoints for an arrow from sP to eP in a collection"

    ^ self
        arrowPointsFor:sP and:eP 
        position:arrowHeadPosition offset:nil
        length:arrowHeadLength angle:arrowHeadAngle

    "Modified: / 14-03-2011 / 10:57:13 / cg"
!

arrowPointsFor:sP and:eP position:arrowHeadPosition offset:arrowHeadOffset length:arrowHeadLength angle:arrowHeadAngle
    "return the arrowPoints for an arrow from sP to eP as a collection of points (for a polygon-fill)"

    |arrowHeadPoint len pos angle grad x1 y1 x2 y2
     atn p1 p2 deriv dX dY|

    arrowHeadPosition isNil ifTrue:[
        pos := 1
    ] ifFalse:[
        pos := arrowHeadPosition max:0.0001.
    ].

    arrowHeadPoint := sP + ((eP - sP) * pos).
    arrowHeadOffset notNil ifTrue:[
        (eP x = sP x) ifTrue:[
            "/ vertical
            (eP y > sP y) ifTrue:[
                arrowHeadPoint := arrowHeadPoint + (0 @ arrowHeadOffset)
            ] ifFalse:[
                arrowHeadPoint := arrowHeadPoint - (0 @ arrowHeadOffset)
            ].
        ] ifFalse:[
            (eP y = sP y) ifTrue:[
                "/ horizontal
                (eP x > sP x) ifTrue:[
                    arrowHeadPoint := arrowHeadPoint + (arrowHeadOffset @ 0)
                ] ifFalse:[
                    arrowHeadPoint := arrowHeadPoint - (arrowHeadOffset @ 0)
                ].
            ].
        ].
    ].

    len := arrowHeadLength.
    len isNil ifTrue:[
        len := DefaultLength
    ].

    angle := arrowHeadAngle.
    angle isNil ifTrue:[
        angle := DefaultAngle
    ].
    angle := angle degreesToRadians.

    deriv := arrowHeadPoint - sP.
    dX := deriv x.
    dY := deriv y.

    dX = 0 ifTrue: [
        grad := 99999999.9
    ] ifFalse: [
        grad := dY / dX
    ].

    atn := grad arcTan.
    x1 := len * (angle - atn) cos.
    y1 := len * (angle - atn) sin.

    x2 := len * (angle + atn) cos.
    y2 := len * (angle + atn) sin.

    dX = 0 ifTrue:[
        dY > 0 ifTrue:[
            p1 := (dX + x1) @ (dY - y1).
            p2 := (dX + x2) @ (dY + y2).
        ] ifFalse:[
            p1 := (dX - x1) @ (dY + y1).
            p2 := (dX - x2) @ (dY - y2).
        ]
    ] ifFalse:[
        dX > 0 ifTrue:[
            p1 := (dX + x1) @ (dY - y1).
            p2 := (dX + x2) @ (dY + y2).
        ] ifFalse:[
            p1 := (dX - x1) @ (dY + y1).
            p2 := (dX - x2) @ (dY - y2).
        ]
    ].

    p1 := sP + p1.
    p2 := sP + p2.

    ^ Array with:p1 with:arrowHeadPoint with:p2.

    "Created: / 14-03-2011 / 10:55:22 / cg"
! !

!Arrow methodsFor:'accessing'!

arrowHeadAngle
    "return the arrowHeads angle, in degrees.
     The default is 150 degrees"

    arrowHeadAngle isNil ifTrue:[^ DefaultAngle].
    ^ arrowHeadAngle

    "Modified: 12.5.1996 / 22:48:29 / cg"
    "Created: 12.5.1996 / 22:56:36 / cg"
!

arrowHeadAngle:angleInDegrees
    "set the arrowHeads angle, in degrees.
     The default is 150 degrees"

    arrowHeadAngle := angleInDegrees

    "Modified: 12.5.1996 / 22:48:29 / cg"
    "Created: 12.5.1996 / 22:57:47 / cg"
!

arrowHeadClosed
    "return the arrowHeadClosed flag; if true, the arrowHead is drawn
     as a closed polygon; if false (the default), the arrowHead is drawn open.
     This only affects non-filled drawing."

    ^ arrowHeadClosed ? false
!

arrowHeadClosed:aBoolean
    "set the arrowHeadClosed flag; if true, the arrowHead is drawn
     as a closed polygon; if false (the default), the arrowHead is drawn open.
     This only affects non-filled drawing."


    arrowHeadClosed := aBoolean.
!

arrowHeadLength
    "return the arrowHeads length, in pixels.
     The default is 8 pixels"

    arrowHeadPosition isNil ifTrue:[^ DefaultLength].
    ^ arrowHeadLength

    "Created: 12.5.1996 / 22:47:32 / cg"
    "Modified: 12.5.1996 / 22:57:27 / cg"
!

arrowHeadLength:pixels
    "set the arrowHeads length, in pixels.
     The default is 8 pixels"

    arrowHeadLength := pixels

    "Created: 12.5.1996 / 22:47:48 / cg"
    "Modified: 12.5.1996 / 23:01:20 / cg"
!

arrowHeadPosition
    "return the arrowHeads position, as a fraction of the overall length;
     0 is at the beginning, 1 is at the end, 0.5 is in the center."

    arrowHeadPosition isNil ifTrue:[^ 1].
    ^ arrowHeadPosition

    "Created: 12.5.1996 / 22:46:21 / cg"
    "Modified: 12.5.1996 / 22:57:55 / cg"
!

arrowHeadPosition:aFractionOfTheLinesLength
    "set the arrowHeads position, as a fraction of the overall length;
     0 is at the beginning, 1 is at the end, 0.5 is in the center."

    arrowHeadPosition := aFractionOfTheLinesLength

    "Created: 12.5.1996 / 22:46:54 / cg"
    "Modified: 12.5.1996 / 23:01:09 / cg"
! !

!Arrow methodsFor:'displaying'!

arrowPointsFor:sP and:eP
    ^ self class 
        arrowPointsFor:sP and:eP 
        position:arrowHeadPosition offset:nil
        length:arrowHeadLength angle:arrowHeadAngle

    "Modified: / 14-03-2011 / 10:56:17 / cg"
!

displayFilledOn:aGC
    "display the receiver in the graphicsContext, aGC"

    self displayOn:aGC filled:true

    "
     |v|

     v := View new openAndWait.

     (Arrow from:10@10 to:50@50) displayFilledOn:v
    "

    "Created: 12.5.1996 / 23:58:42 / cg"
    "Modified: 4.6.1996 / 18:25:11 / cg"
!

displayOn:aGC filled:filled
    "display the receiver's arrow in the graphicsContext, aGC"

    |arrowHeadPoint savedLineStyle p1 p2 arrowPoints middle oldCap|

    savedLineStyle := aGC lineStyle.
    aGC lineStyle:#solid.

    arrowPoints := self arrowPointsFor:startPoint and:endPoint.

    p1 := arrowPoints at:1.
    arrowHeadPoint := arrowPoints at:2.
    p2 := arrowPoints at:3.

    filled ifFalse:[
        arrowHeadClosed == true ifTrue:[
            middle := ((p1 + p2) / 2).
            aGC displayLineFrom:startPoint to:middle.
            aGC displayLineFrom:arrowHeadPoint to:p1.
            aGC displayLineFrom:arrowHeadPoint to:p2.
            aGC displayLineFrom:p1 to:p2.
        ] ifFalse:[
            aGC displayLineFrom:startPoint to:endPoint.
            aGC displayLineFrom:arrowHeadPoint to:p1.
            aGC displayLineFrom:arrowHeadPoint to:p2.
        ]
    ] ifTrue:[
        middle := ((p1 + p2) / 2).
        oldCap := aGC capStyle.
        aGC capStyle:#notLast.
        aGC displayLineFrom:startPoint to:middle.
        aGC fillPolygon:(Array with:p1 with:arrowHeadPoint with:p2).
        aGC capStyle:oldCap.
    ].

    aGC lineStyle:savedLineStyle.

    "
     |v|

     v := View new openAndWait.

     (Arrow from:10@10 to:50@50) displayStrokedOn:v
    "

    "Modified: 4.6.1996 / 18:24:53 / cg"
    "Created: 4.6.1996 / 18:25:15 / cg"
!

displayStrokedOn:aGC
    "display the receiver in the graphicsContext, aGC"

    self displayOn:aGC filled:false

    "
     |v|

     v := View new openAndWait.

     (Arrow from:10@10 to:50@50) displayStrokedOn:v
    "

    "Modified: 4.6.1996 / 18:25:07 / cg"
! !

!Arrow methodsFor:'queries'!

computeBounds
    "return the smallest enclosing rectangle"

    |x y minX maxX minY maxY|

    minX := maxX := startPoint x.
    x := endPoint x.
    minX := minX min:x.
    maxX := maxX max:x.

    minY := maxY := startPoint y.
    y := endPoint y.
    minY := minY min:y.
    maxY := maxY max:y.

    (self arrowPointsFor:startPoint and:endPoint) do:[:p |
        |x y|

        x := p x.
        y := p y.
        minX := minX min:x.
        maxX := maxX max:x.
        minY := minY min:y.
        maxY := maxY max:y.
    ].    
    ^ Rectangle left:minX right:maxX top:minY bottom:maxY

    "
     (Arrow from:(10@10) to:(90@90)) bounds 
     (Arrow from:(10@10) to:(10@90)) bounds  
    "

    "Modified: 26.5.1996 / 16:31:39 / cg"
    "Created: 12.2.1997 / 11:42:22 / cg"
! !

!Arrow methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here. Notice, that Arrows only fill the arrowHeads."

    ^ true

! !

!Arrow class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Arrow initialize!

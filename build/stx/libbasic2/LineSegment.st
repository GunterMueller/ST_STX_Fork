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

Geometric subclass:#LineSegment
	instanceVariableNames:'startPoint endPoint'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!LineSegment class methodsFor:'documentation'!

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
    LineSegments represent a line consisting of start and endPoint
    (actually, its a vector, since the direction makes a difference when
     instances are compared using #=).

    [author:]
        Claus Gittinger

    [see also:]
        Rectangle Polygon EllipticalArc Circle Spline Curve 
        Point Arrow ArrowedSpline
        GraphicsContext
        StrokingWrapper
"

!

examples
"
  low leel use:
                                                                        [exBegin]
    |v l|

    v := (View extent:100@100) openAndWait.

    l := LineSegment from:10@10 to:90@90. 

    v paint:Color red.
    l displayStrokedOn:v.

    l setStart:90@10 end:10@90.
    v paint:Color blue.
    l displayStrokedOn:v.
                                                                        [exEnd]
  as component (automatic redraw):
                                                                        [exBegin]
    |v l|

    v := View extent:100@100.

    l := LineSegment from:10@10 to:90@90. 
    v addComponent:(StrokingWrapper on:l).

    l := LineSegment from:90@10 to:10@90. 
    v addComponent:((StrokingWrapper on:l) foregroundColor:(Color red)).

    v open.
                                                                        [exEnd]
"
! !

!LineSegment class methodsFor:'instance creation'!

from:start to:end
    "return a new lineSegment."

    ^ self new setStart:start end:end

    "Created: 8.5.1996 / 20:40:13 / cg"
!

with:p1 with:p2
    "return a new lineSegment; the smaller point is taken as startPoint."

    |l|

    l := self new.
    p1 < p2 ifTrue:[
        l setStart:p1 end:p2
    ] ifFalse:[
        l setStart:p2 end:p1
    ].
    ^ l.

    "Created: 8.5.1996 / 20:41:03 / cg"
! !

!LineSegment methodsFor:'accessing'!

end
    "return the endPoint"

    ^ endPoint

    "Created: 8.5.1996 / 20:41:43 / cg"
!

end:aPoint
    "set the endPoint"

    endPoint := aPoint

    "Created: 8.5.1996 / 20:41:54 / cg"
!

setStart:p1 end:p2
    "set both the startPoint and the endPoint"

    startPoint := p1.
    endPoint := p2.
!

start
    "return the startPoint"

    ^ startPoint

    "Created: 8.5.1996 / 20:41:35 / cg"
!

start:aPoint
    "set the startPoint"

    startPoint := aPoint

    "Created: 8.5.1996 / 20:42:07 / cg"
!

start:p1 end:p2
    <resource: #obsolete>
    "set both the startPoint and the endPoint.
     Obsolete - use setStart:end: for VW compatibility."

    self obsoleteMethodWarning:'use #setStart:end: for VW compatibility'.
    self setStart:p1 end:p2.
! !

!LineSegment methodsFor:'comparing'!

= aLineSegment
    "return true, if the receiver represents the same lineSegment
     as the argument, aLineSegment"

    aLineSegment species ~~ self species ifTrue:[^ false].
    ^ (startPoint = aLineSegment start
      and:[endPoint = aLineSegment end])

    "Created: 8.5.1996 / 22:13:02 / cg"
    "Modified: 8.5.1996 / 22:14:34 / cg"
!

hash
    "return a number useul for hashing.
     Redefined, since #= is redefined."

    ^ (startPoint hash bitShift:12) bitOr:(endPoint hash)

    "Modified: 8.5.1996 / 22:14:12 / cg"
! !

!LineSegment methodsFor:'converting'!

asPointArray
    "return an array containing my points."

    ^ Array with:startPoint with:endPoint

    "Created: 8.5.1996 / 20:46:08 / cg"
! !

!LineSegment methodsFor:'displaying'!

displayFilledOn:aGC
    "raise an error - a lineSegment cannot be drawn filled"

    self shouldNotImplement

    "Created: 8.5.1996 / 21:04:27 / cg"
!

displayStrokedOn:aGC
    "display the receiver in the graphicsContext, aGC"

    aGC displayLineFrom:startPoint to:endPoint

    "
     |v|

     v := View new openAndWait.

     (LineSegment from:10@10 to:50@50) displayStrokedOn:v
    "

    "Modified: 8.5.1996 / 14:40:53 / cg"
    "Created: 8.5.1996 / 21:05:16 / cg"
! !

!LineSegment methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'LineSegment from:'.
    startPoint printOn:aStream.
    aStream nextPutAll:' to:'.
    endPoint printOn:aStream.
! !

!LineSegment methodsFor:'queries'!

angle
    "return the receiver's angle (in degrees) in a polar coordinate system.
     The angle is counted counter-clock-wise, starting with 0 for a horizontal
     line (i.e. 0@0 -> 100@0 has an angle of 0 and 0@0 -> 0@100 has an angle of 90)"

    ^ (endPoint - startPoint) degrees

    "
     (LineSegment from:0@0 to:100@0) angle
     (LineSegment from:0@0 to:100@100) angle   
     (LineSegment from:0@0 to:0@100) angle      
     (LineSegment from:0@0 to:-100@100) angle
     (LineSegment from:0@0 to:-100@0) angle
     (LineSegment from:0@0 to:-100@-100) angle
     (LineSegment from:0@0 to:0@-100) angle
    "
!

center
    ^ (startPoint + endPoint) / 2

    "
     (LineSegment from:(10@10) to:(20@10)) center  
     (LineSegment from:(10@10) to:(20@20)) center  
    "
!

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

    ^ Rectangle left:minX right:maxX top:minY bottom:maxY

    "
     (LineSegment from:(10@10) to:(90@90)) bounds 
    "

    "Modified: 26.5.1996 / 13:06:55 / cg"
    "Created: 12.2.1997 / 11:43:50 / cg"
!

dist:aPoint
    "the distance of aPoint to this segment"

    |u v px py ax ay bx by|

    ax := startPoint x.
    ay := startPoint y.
    bx := endPoint x.
    by := endPoint y.
    px := aPoint x.
    py := aPoint y.

    u := aPoint - startPoint.
    v := endPoint - startPoint.
    ((u x * v x) + (u y * v y)) < 0 ifTrue:[
        ^ "(startPoint dist:aPoint)" (( px - ax) squared + (py - ay) squared) sqrt
    ].

    u := aPoint - endPoint.
    v := v negated.
    ((u x * v x) + (u y * v y)) < 0 ifTrue:[
        ^ "(endPoint dist:aPoint)" (( px - bx) squared + (py - by) squared) sqrt
    ].

    ^( (( px * ( ay - by )) + (py * ( bx - ax )) + ( (ax * by) - (bx * ay) ) ) 
     / ( ( bx - ax )squared + ( by - ay )squared ) sqrt ) abs

    "
     (LineSegment from:(0@0) to:(10@10)) dist:0@0      
     (LineSegment from:(0@0) to:(10@10)) dist:10@10    
     (LineSegment from:(0@0) to:(10@10)) dist:11@10    
     (LineSegment from:(0@0) to:(10@10)) dist:-1@-1    
     (LineSegment from:(0@0) to:(10@10)) dist:5@5      
     (LineSegment from:(0@0) to:(10@10)) dist:6@4      
     (LineSegment from:(0@0) to:(10@10)) dist:5@0      
    "
!

isHorizontal
    "return true, if I am a horizontal line"

    ^ startPoint y = endPoint y
!

isVertical
    "return true, if I am a vertical line"

    ^ startPoint x = endPoint x
!

length
    "return the length of the vector"

    ^ startPoint dist:endPoint
! !

!LineSegment methodsFor:'testing'!

isLineSegment
    "return true, if the receiver is a line segment"

    ^ true


! !

!LineSegment methodsFor:'transforming'!

scaledBy:amount
    ^ self species 
        from:(startPoint scaledBy:amount)
        to:(endPoint scaledBy:amount)
!

translatedBy:amount
    ^ self species 
        from:(startPoint translatedBy:amount)
        to:(endPoint translatedBy:amount)
! !

!LineSegment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/LineSegment.st,v 1.21 2009-06-06 10:07:44 cg Exp $'
! !

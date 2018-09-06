"{ Package: 'stx:libbasic2' }"

LineSegment subclass:#Bezier2Segment
	instanceVariableNames:'via'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Bezier2Segment class methodsFor:'documentation'!

documentation
"
    borrowed from Squeak2.4

    This class represents a quadratic bezier segment between two points

    Instance variables:
        via             <Point> The additional control point (OFF the curve)
"
! !

!Bezier2Segment class methodsFor:'instance creation'!

from:startPoint via:viaPoint to:endPoint 
    ^ self new from:startPoint to:endPoint via:viaPoint

! !

!Bezier2Segment methodsFor:'accessing'!

via
    "Return the control point"
    ^ via

! !

!Bezier2Segment methodsFor:'initialization'!

from:start to:end
    "Initialize the receiver as straight line"

    startPoint := start.
    endPoint := end.
    via := (start + end) // 2.

!

from:start to:end via:viaPoint
    "Initialize the receiver"

    startPoint := start.
    endPoint := end.
    via := viaPoint.
! !

!Bezier2Segment methodsFor:'testing'!

isBezier2Segment
    "return true, if the receiver is a quadratic bezier segment"

    ^ true


! !

!Bezier2Segment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Bezier2Segment.st,v 1.3 2003-08-29 17:32:22 cg Exp $'
! !

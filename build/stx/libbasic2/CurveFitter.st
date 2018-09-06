"{ Package: 'stx:libbasic2' }"

Geometric subclass:#CurveFitter
	instanceVariableNames:'points'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!CurveFitter class methodsFor:'documentation'!

documentation
"
    I represent a conic section determined by three points p1, p2 and p3. 
    I interpolate p1 and p3 and am tangent to line p1, p2 at p1 and line p3, p2 at p3.

    [see also:]
        Polygon LineSegment Circle EllipticalArc 
        Rectangle Curve Arrow Spline ArrowedSpline

    [author:]
        ?
        adapted to ST/X by Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    |v s|

    v := (View extent:100@100) openAndWait.

    v displayLineFrom:(0@20) to:(100@20).
    v displayLineFrom:(0@80) to:(100@80).
    v displayLineFrom:(0@60) to:(100@60).
    v displayLineFrom:(20@0) to:(20@100).
    v displayLineFrom:(80@0) to:(80@100).

    s := CurveFitter new points:
                (Array with:(20@20)
                       with:(80@60)
                       with:(20@80)).

'
    v paint:Color blue.
    s displayFilledOn:v.
'.

    v paint:Color red.
    s displayStrokedOn:v.
                                                                        [exEnd]

"
! !

!CurveFitter methodsFor:'accessing'!

points
    "the collection of points which are used to approximate the curve"

    ^ points 
!

points:aCollectionOfPoints
    "set the collection of points which are used to approximate the curve"

    points := aCollectionOfPoints.
! !

!CurveFitter methodsFor:'displaying'!

displayStrokedOn:aDisplayMedium 
    | pa pb k s p1 p2 p3 |

    points size < 3 ifTrue: [ self error: 'Curve must have three points' ].

    p1 := points at:1.
    p2 := points at:2.
    p3 := points at:3.

    s := Polygon new.
    s add: p1.
    pa := p2 - p1.
    pb := p3 - p2.
    k := 5 max: pa x abs + pa y abs + pb x abs + pb y abs // 20.

    "k is a guess as to how many line segments to use to approximate the curve."
    1 to: k do:[:i | 
        s add: pa * i // k + p1 * (k - i) + (pb * (i - 1) // k + p2 * (i - 1)) // (k - 1)
    ].
    s add: p3.
    s displayOn:aDisplayMedium
! !

!CurveFitter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/CurveFitter.st,v 1.1 2009-10-26 21:14:55 cg Exp $'
! !

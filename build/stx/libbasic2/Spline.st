"
 This class is based on a file from the Manchester Goodie library.
 It is not covered by the ST/X copyright and may be copied and used
 according the rules as stated by the athor and the manchester archive.

 The original readme was:


 The above file is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
        * You must ensure that every copy includes this notice, and that
          source and author(s) of the material are acknowledged.
        * These conditions must be imposed on anyone who receives a copy.
        * The material shall not be used for commercial gain without the prior
          written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
        To: goodies-lib@cs.man.ac.uk
        Subject: help 
"
"{ Package: 'stx:libbasic2' }"

Geometric subclass:#Spline
	instanceVariableNames:'controlPoints lines function firstDerivative secondDerivative
		thirdDerivative'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Spline class methodsFor:'documentation'!

copyright
"
 This class is based on a file from the Manchester Goodie library.
 It is not covered by the ST/X copyright and may be copied and used
 according the rules as stated by the athor and the manchester archive.

 The original readme was:


 The above file is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
        * You must ensure that every copy includes this notice, and that
          source and author(s) of the material are acknowledged.
        * These conditions must be imposed on anyone who receives a copy.
        * The material shall not be used for commercial gain without the prior
          written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
        To: goodies-lib@cs.man.ac.uk
        Subject: help 
"


!

documentation
"
    Spline defines a path that includes an arbitrary collection of points 
    connected by a third order curve. The curve passes through all controlPoints.
    Both open and closed curves are possible.

    [see also:]
        Polygon LineSegment Circle EllipticalArc 
        Rectangle Curve Arrow ArrowedSpline
        GraphicsContext StrokingWrapper FillingWrapper

    [author:]
        scaletti@uxc.cso.uiuc.edu (Kurt J. Hebel)
        adapted to ST/X & minor fixes by Claus Gittinger
"
!

examples
"
  open spline; filled & unfilled:
                                                                        [exBegin]
    |v s|

    v := (View extent:100@100) openAndWait.

    s := Spline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@80)).

    v paint:Color blue.
    s displayFilledOn:v.

    v paint:Color red.
    s displayStrokedOn:v.
                                                                        [exEnd]

  closed spline; filled & unfilled:
                                                                        [exBegin]
    |v s|

    v := (View extent:100@100) openAndWait.

    s := Spline controlPoints:
                (Array with:(20@20)
                       with:(80@80)
                       with:(20@80)
                       with:(20@20)).

    v paint:Color blue.
    s displayFilledOn:v.

    v paint:Color red.
    s displayStrokedOn:v.
                                                                        [exEnd]

  spiral:
                                                                        [exBegin]
    |v points s|

    v := View extent:(200 @ 200).

    v openAndWait.

    points := OrderedCollection new.
    90 to:10 by:-10 do:[:r |
        0 to:330 by:30 do:[:angle |
            |d|

            d := (angle / 360) * 10.
            points add:(Point r:r-d angle:angle) + (100@100)
        ].
    ].
    s := Spline controlPoints:points.

    v paint:Color red.
    s displayStrokedOn:v.
                                                                        [exEnd]
  interactive example:
  click-left for first-points; right for last.
                                                                        [exBegin]
    |v points eventCatcher|

    v := StandardSystemView extent:(450 @ 450).
    v label:'Spline Example - (click left/middle)'.

    points := OrderedCollection new.
    v viewBackground:Color black.
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

                                (Spline controlPoints:points) displayStrokedOn:v.

                                points := OrderedCollection new.
                            ]
                           ].

    v delegate:(eventCatcher)
                                                                        [exEnd]
"
! !

!Spline class methodsFor:'instance creation'!

controlPoints:aSequentialCollectionOfPoints
    "return a new spline, which passes through aSequentialCollectionOfPoints"

    ^ self new controlPoints:aSequentialCollectionOfPoints
! !

!Spline methodsFor:'accessing'!

controlPoints
    "return the collection of points through which the spline is to pass"

    ^ controlPoints

    "Created: 8.5.1996 / 18:46:35 / cg"
!

controlPoints:aCollectionOfPoints
    "set the collection of points through which the spline is to pass"

    controlPoints := aCollectionOfPoints.
    lines := nil

    "Created: 8.5.1996 / 18:50:24 / cg"
    "Modified: 8.5.1996 / 19:32:57 / cg"
! !

!Spline methodsFor:'converting'!

asPointArray
    "return an array containing my approximated vertex points."

    ^ self computeLineSegments

    "Created: 8.5.1996 / 20:44:09 / cg"
!

asPolygon
    "return a polygon, approximating the spline"

    ^ Polygon vertices:(self computeLineSegments)

    "Created: 8.5.1996 / 20:15:37 / cg"
!

asPolyline
    "same as #asPolygon - for ST-80 compatibility"

    ^ self asPolygon

    "Created: 8.5.1996 / 18:49:42 / cg"
    "Modified: 8.5.1996 / 20:15:59 / cg"
! !

!Spline methodsFor:'displaying'!

displayFilledOn:aGC 
    "Display this Spline as a filled polygon from approximated lines."

    lines isNil ifTrue:[
        lines := self computeLineSegments.
    ].

    aGC fillPolygon:lines

    "Modified: 8.5.1996 / 18:45:49 / cg"
    "Created: 8.5.1996 / 18:54:12 / cg"
!

displayStrokedOn:aGC 
    "Display this Spline as a series of approximating lines."

    lines isNil ifTrue:[
        lines := self computeLineSegments.
    ].

    "/ Plot the lines
    aGC displayPolygon:lines

    "Created: 8.5.1996 / 18:44:17 / cg"
    "Modified: 13.5.1996 / 11:19:14 / cg"
! !

!Spline methodsFor:'private'!

computeCurve
    "Compute an array for the derivatives at each knot."

    |size values cyclic second third secondFromLast thirdFromLast
     addedExtra|

    "/ Get the number of points, 
    "/ and make an OrderedColleciton of all of the points."

    size := controlPoints size.
    function := OrderedCollection new:size.
    controlPoints do:[:point | function addLast:point].

    "/ stop if the spline has not enough points for the derivation(s).
    size < 3 ifTrue: [^ self].

    "/ Flag whether curve is cyclic or not.
    cyclic := size > 3 and: [function first = function last].

    "/ Set up the values collection.  The derivatives are computed from this.
    values := function copy.

    "/ Process cyclic curves differently.  
    "/ Add the last two points to the beginning,
    "/ and the first two points to the end, so that the derivative calculation 
    "/ can look at a cycle."
    cyclic ifTrue: [
        second := values at: 2.
        third := values at: 3.
        thirdFromLast := values at: size - 2.
        secondFromLast := values at: size - 1.

        values addFirst: secondFromLast.
        values addFirst: thirdFromLast.
        values addLast: second.
        values addLast: third
    ] ifFalse:[
        size == 3 ifTrue:[
            addedExtra := true.
            values addLast:(values last).
        ] ifFalse:[
            addedExtra := false
        ]
    ].

    "/ Compute the derivatives of the values collection.
    self computeDerivatives:values.

    "/ Remove any extra points which were added if the Spline is cyclic.
    cyclic ifTrue:  [
        firstDerivative removeFirst.
        firstDerivative removeFirst.
        firstDerivative removeLast.
        firstDerivative removeLast.
        secondDerivative removeFirst.
        secondDerivative removeFirst.
        secondDerivative removeLast.
        secondDerivative removeLast.
        thirdDerivative removeFirst.
        thirdDerivative removeFirst.
        thirdDerivative removeLast.
        thirdDerivative removeLast
    ] ifFalse:[
        addedExtra ifTrue:[
            firstDerivative removeLast.
            secondDerivative removeLast.
            thirdDerivative removeLast.
        ]
    ]

    "Created: 8.5.1996 / 18:34:43 / cg"
    "Modified: 8.5.1996 / 19:43:51 / cg"
!

computeDerivatives: values
    "Computes the first, second and third derivatives at each point 
     in the collection values."

    |size "{Class: SmallInteger }"
     v b 
     lastV lastB nextV nextB 
     valuesI valuesI1 valuesI2 
     twoDerivI twoDerivI1|

    "/ Set up the derivative arrays.
    size := values size.
    size < 3 ifTrue: [
        'SPLINE: not enough controlPoints' errorPrintCR. 
        ^ self
    ].

    firstDerivative := Array new:size.
    secondDerivative := Array new:size.
    thirdDerivative := Array new:size.

    "/ Compute the second derivative of the values.
    size > 3 ifTrue: [
        lastV := 4.0.
        lastB := 6.0 * (values first - ((values at:2) * 2.0) + (values at:3)).
        v := Array new:size.
        b := Array new:size.
        v at: 1 put:lastV.
        b at: 1 put:lastB.
        valuesI := values at:2.
        valuesI1 := values at:3.
        size > 3 ifTrue: [valuesI2 := values at:4].

        2 to:size-2 do: [:i |
            nextV := 4.0 - (1.0 / lastV).
            nextB := 6.0 * (valuesI - (valuesI1 * 2.0) + valuesI2) - (lastB / lastV).
            v at:i put:nextV.
            b at:i put:nextB.

            size-2 == i ifFalse: [
                lastV := nextV.
                lastB := nextB.
                valuesI := valuesI1.
                valuesI1 := valuesI2.
                valuesI2 := values at:i+3
            ]
        ].

        secondDerivative at:size-1 put:nextB/nextV.

        size-2 to:2 by:-1 do: [:i | 
            secondDerivative at:i 
                            put:(b at:i-1) 
                                 - (secondDerivative at:i+1) / (v at:i-1)
        ]
    ].

    secondDerivative at:1 put:0.0 asPoint.
    secondDerivative at:size put:0.0 asPoint.

    "/ Compute the values of the first and third derivative 
    "/ from the second derivative and the values.

    valuesI := values at:1.
    valuesI1 := values at:2.
    twoDerivI := secondDerivative at:1.
    twoDerivI1 := secondDerivative at:2.
    1 to:size-1 do:[:i |
        firstDerivative at:i put:valuesI1 - valuesI - (twoDerivI * 2.0 + twoDerivI1 / 6.0).
        thirdDerivative at:i put:twoDerivI1 - twoDerivI.

        size-1 == i ifFalse:[
            twoDerivI := twoDerivI1.
            twoDerivI1 := secondDerivative at:i+2.
            valuesI := valuesI1.
            valuesI1 := values at:i+2
        ]
    ].

    "/ The derivative collections should be OrderedCollections.

    firstDerivative := firstDerivative asOrderedCollection.
    secondDerivative := secondDerivative asOrderedCollection.
    thirdDerivative := thirdDerivative asOrderedCollection.

    "Created: 8.5.1996 / 18:39:31 / cg"
    "Modified: 8.5.1996 / 19:44:36 / cg"
!

computeLineSegments
    "compute a series of approximating lines."

    |lines 
     n " {Class: SmallInteger }"
     nSteps " {Class: SmallInteger }"
     steps
     a b c d t|

    lines notNil ifTrue:[ ^ lines].
    controlPoints size < 3 ifTrue:[^ controlPoints].

    "/ Make sure that the function and its derivatives are up to date.
    self validateDerivatives.

    "/ Create a polygon for plotting.
    lines := OrderedCollection new.
    lines add:function first.

    "/ Approximate each spline knot.

    n := function size - 1.

    1 to:n do: [:k | 
        "/ Compute the Taylor series coefficients.
        d := function at:k.
        c := firstDerivative at:k.
        b := (secondDerivative at:k) / 2.0.
        a := (thirdDerivative at:k) / 6.0.

        "/ Compute the number of approximating segments.
        steps := (secondDerivative at:k) abs + (secondDerivative at:k + 1) abs.
        steps := 5 max:(steps x + steps y) // 100.

        "/ Add each of the approximating line segments.
        nSteps := steps.
        1 to:nSteps do:[:j | 
            t := j asFloat / steps.
            lines add: a * t + b * t + c * t + d
        ].

        "/ Add the last line to the real spline endpoint.
        lines add: (function at: k + 1)
    ].

    ^ lines

    "Created: 8.5.1996 / 18:44:54 / cg"
    "Modified: 8.5.1996 / 20:45:10 / cg"
!

validateDerivatives
    "Make sure that the function and derivative arrays are still valid.  
     If they are not, recompute them."

    |index "{ Class: SmallInteger }"|

    "/
    "/ Compute the derivatives if the cached function has not been computed.
    "/
    function isNil ifTrue:[
        ^ self computeCurve
    ].

    "/ Compute the derivatives if the cached function 
    "/ and the collection of points do not agree."

    index := 1.
    controlPoints do:[:point |
        point ~~ (function at:index) ifTrue:[
            ^ self computeCurve
        ].
        index := index + 1
    ]

    "Created: 8.5.1996 / 18:31:46 / cg"
    "Modified: 8.5.1996 / 18:32:39 / cg"
! !

!Spline methodsFor:'queries'!

computeBounds
    "return the smallest enclosing rectangle"

    |l minX maxX minY maxY|

    lines isNil ifTrue:[
        lines := self computeLineSegments.
    ].
    l := lines.

    minX := maxX := l first x rounded.
    minY := maxY := l first y rounded.
    l do:[:p |
        |x y|

        (x := p x rounded) < minX ifTrue:[
            minX := x
        ] ifFalse:[
            x > maxX ifTrue:[
                maxX := x
            ]
        ].
        (y := p y rounded) < minY ifTrue:[
            minY := y
        ] ifFalse:[
            y > maxY ifTrue:[
                maxY := y
            ]
        ].
    ].

    ^ Rectangle left:minX right:maxX top:minY bottom:maxY

    "Modified: 13.5.1996 / 11:02:29 / cg"
    "Created: 12.2.1997 / 11:45:02 / cg"
!

isCyclic
    "return true, if this spline represents a closed curve"

    ^ controlPoints size > 3 and: [controlPoints first = controlPoints last].

    "Created: 8.5.1996 / 18:47:50 / cg"
! !

!Spline methodsFor:'testing'!

canBeFilled
    "return true, if the receiver can be drawn as a filled geometric.
     Always true here."

    ^ true

! !

!Spline class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Spline.st,v 1.19 2013-02-08 20:45:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/Spline.st,v 1.19 2013-02-08 20:45:16 cg Exp $'
! !


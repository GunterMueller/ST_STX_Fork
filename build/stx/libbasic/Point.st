"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

ArithmeticValue subclass:#Point
	instanceVariableNames:'x y'
	classVariableNames:'PointZero PointOne'
	poolDictionaries:''
	category:'Graphics-Geometry'
!

!Point class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    I represent a point in 2D space. Or I can be used to represent
    an extent (of a rectangle, for example), in which case my x-coordinate
    represents the width, and y-coordinate the height of something.

    The x and y coordinates are usually numbers.

    [Instance variables:]

	x              <Number>        the x-coordinate of myself
	y              <Number>        the y-coordinate of myself

    [author:]
	Claus Gittinger

    [see also:]
	Rectangle Polygon
	LayoutOrigin LayoutFrame AlignmentOrigin Layout
	View GraphicsContext
"
! !

!Point class methodsFor:'initialization'!

initialize
    PointZero isNil ifTrue:[
	PointZero := 0 @ 0.
	PointOne  := 1 @ 1
    ]
! !

!Point class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray.
     Redefined for faster creation."

    ^ self x:(anArray at:2) y:(anArray at:3)

    "
     Point
	decodeFromLiteralArray:#(Point 10 10)
    "

    "Created: / 28.1.1998 / 17:44:08 / cg"
!

r:distance angle:angle
    "create and return a new point given polar coordinates.
     The angle is given in degrees.

     OBSOLETE STX interface, use #r:theta:"

    <resource:#obsolete>

    ^ self r:distance theta:angle degreesToRadians

    "
     Point r:100 angle:0
     Point r:100 angle:90
     Point r:100 angle:45
     Point r:100 angle:180
    "

    "Modified: 8.5.1996 / 20:01:50 / cg"
!

r:distance degrees:angle
    "create and return a new point given polar coordinates.
     The angle is given in degrees.
     Added for Squeak compatibility"

    ^ self r:distance theta:angle degreesToRadians

    "
     Point r:100 degrees:90
    "

    "Modified: 8.5.1996 / 20:01:50 / cg"
!

r:distance theta:angleInRadians
    "create and return a new point given polar coordinates.
     The angle is given in radians"

    |x y|

    x := distance * angleInRadians cos.
    y := distance * angleInRadians sin.
    ^ x @ y

    "
     Point r:100 theta:0
     Point r:100 theta:Float pi/2
    "

    "Modified: 2.4.1997 / 00:01:40 / cg"
!

readFrom:aStringOrStream onError:exceptionBlock
    "return the next Point from the (character-)stream aStream;
     skipping all whitespace first; return the value of exceptionBlock,
     if no point can be read."

    ^ [
	|str newX newY hasParen|

	str := aStringOrStream readStream.
	str skipSeparators.
	(hasParen := str peek) == $( ifTrue:[
	    str next.
	].
	newX := Number readFrom:str onError:nil.
	newX notNil ifTrue:[
	    (str skipSeparators == $@) ifTrue:[
		str  next.
		newY := Number readFrom:str onError:nil.
		newY notNil ifTrue:[
		    hasParen ifTrue:[
			str skipSeparators.
			str peek == $) ifTrue:[
			    str next.
			]
		    ].

		    ^ self x:newX y:newY
		]
	    ]
	].
	^ exceptionBlock value
    ] on:Error do:exceptionBlock.

    "
     Point readFrom:'1.234 @ 5.678'
     Point readFrom:'1'
     Point readFrom:'1' onError:[1@1]
     Point readFrom:'fooBar' onError:[0@0]
    "

    "Modified: 8.10.1996 / 19:31:39 / cg"
!

x:newX y:newY
    "create and return a new point with coordinates newX and newY"

%{  /* NOCONTEXT */

    /*
     * claus: I am no longer certain, if this primitive is worth the effort
     */
    if (__CanDoQuickNew(sizeof(struct __Point))) {      /* OBJECT ALLOCATION */
	if (self == @global(Point)) {
	    OBJ newPoint;
	    int spc;

	    __qCheckedNew(newPoint, sizeof(struct __Point));
	    __InstPtr(newPoint)->o_class = self; __qSTORE(newPoint, self);
	    __PointInstPtr(newPoint)->p_x = newX;
	    __PointInstPtr(newPoint)->p_y = newY;
	    if (! __bothSmallInteger(newX, newY)) {
		spc = __qSpace(newPoint);
		__STORE_SPC(newPoint, newX, spc);
		__STORE_SPC(newPoint, newY, spc);
	    }
	    RETURN ( newPoint );
	}
    }
%}.
    ^ (self basicNew) x:newX y:newY
! !

!Point class methodsFor:'constants'!

unity
    "return the neutral element for multiplication"

    ^ PointOne
!

zero
    "return the neutral element for addition"

    ^ PointZero
! !

!Point class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Point

    "Modified: 23.4.1996 / 16:00:18 / cg"
! !

!Point methodsFor:'Compatibility-Squeak'!

adhereTo: aRectangle
    "If the receiver lies outside aRectangle, return the nearest point on the boundary of the rectangle, otherwise return self."

    (aRectangle containsPoint: self) ifTrue: [^ self].
    ^ ((x max: aRectangle left) min: aRectangle right)
      @
      ((y max: aRectangle top) min: aRectangle bottom)
!

area
    ^ x * y

    "Created: / 29-05-2007 / 09:57:57 / cg"
!

asFloatPoint
    "Squeak mimicri return the receiver as Point - this is the receiver"

    ^ self
!

asLargerPowerOfTwo
    ^ x asLargerPowerOfTwo @ y asLargerPowerOfTwo
!

asSmallerPowerOfTwo
    ^ x asSmallerPowerOfTwo @ y asSmallerPowerOfTwo
!

maxDimension
    "Answer the larger of the two dimensions."

    ^ x max: y.
! !

!Point methodsFor:'accessing'!

x
    "return the x coordinate"

    ^ x
!

x:newX
    "set the x coordinate to be the argument, aNumber.
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver."

    x := newX
!

x:newX y:newY
    "set both the x and y coordinates.
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver."

    x := newX.
    y := newY
!

y
    "return the y coordinate"

    ^ y
!

y:newY
    "set the y coordinate to be the argument, aNumber.
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver."

    y := newY
! !

!Point methodsFor:'coercing & converting'!

coerce:anObject
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ anObject asPoint
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 120
! !

!Point methodsFor:'comparing'!

< aPoint
    "return true if the receiver is above and to the left
     of the argument, aPoint"

    |p|

    p := aPoint asPoint.
    x < (p x) ifTrue:[
	y < (p y) ifTrue:[^ true].
    ].
    ^ false

    "notice the funny result if one coordinate has the same value ...

     (3@4) < (4@4)
     (3@4) <= (4@4)
     (3@4) > (4@4)
     (4@4) >= (3@4)
     (4@4) > (3@4)
    "

    "Modified: 7.5.1996 / 12:14:25 / cg"
!

= aPoint
    "return true if the receiver represents the same point as
     the argument, aPoint"

    |p|

    (aPoint isMemberOf:Point) ifTrue:[     "this is a hint to STC"
	x ~= (aPoint x) ifTrue:[^ false].
	y ~= (aPoint y) ifTrue:[^ false].
	^ true
    ].
    aPoint respondsToArithmetic ifFalse:[ ^ false].
    p := aPoint asPoint.
    x ~= (p x) ifTrue:[^ false].
    y ~= (p y) ifTrue:[^ false].
    ^ true
!

> aPoint
    "return true if  the receiver is below and to the right
     of the argument, aPoint"

    |p|

    p := aPoint asPoint.
    (p x) < x ifTrue:[
	(p y) < y ifTrue:[^ true].
    ].
    ^ false

    "Modified: 7.5.1996 / 12:11:15 / cg"
!

hash
    "return a number for hashing"

    x = y ifTrue:[^ x hash].
"
 used to be:
    ^ (x hash) bitXor:(y hash)
 the following handles 1@x vs. x@1 better:
"
    ^ (x hash) bitXor:(y hash bitShift:16)





!

isLeftOrAbove:aPoint
    "return true if the receiver is above or to the left
     of the argument, aPoint.
     When sorting this enumerates points from left to right and top to bottom"

    |p|

    p := aPoint asPoint.
    ^ (y < p y) or:[(y = p y) and:[x < p x]]
!

max:aPoint
    "return the lower right corner of the rectangle uniquely defined by
     the receiver and the argument, aPoint"

    |p maxX maxY|

    p := aPoint asPoint.
    maxX := x max:(p x).
    maxY := y max:(p y).
    ^ maxX @ maxY
!

min:aPoint
    "return the upper left corner of the rectangle uniquely defined by
     the receiver and the argument, aPoint"

    |p minX minY|

    p := aPoint asPoint.
    minX := x min:(p x).
    minY := y min:(p y).
    ^ minX @ minY
! !

!Point methodsFor:'converting'!

asComplex
    "Return a complex number whose real and imaginary components are the x and y
     coordinates of the receiver."

    ^ Complex real:x imaginary:y

    "Modified: / 9.7.1998 / 10:21:10 / cg"
!

asFractionalLayout
    "return a LayoutOrigin from the receiver,
     treating the receiver coordinates as fractional parts
     (i.e. relative to superview).
     Notice: in 10.5.x LayoutOrigin is not yet officially released."

    ^ LayoutOrigin fractionalFromPoint:self

    "
     (0@0.5) asFractionalLayout
     (0@0.5) asLayout
     (0@10) asLayout
     (0@10) asOffsetLayout
    "

!

asIntegerPoint
    (x isInteger and:[y isInteger]) ifTrue:[ ^ self].
    ^ x asInteger @ y asInteger
!

asLayout
    "return a LayoutOrigin from the receiver.
     If the receiver coordinates are between 0 and 1, take
     them as fractional parts (relative to superview).
     Otherwise, treat them as absolute offsets.
     Notice: in 10.5.x LayoutOrigin is not yet released."

    ^ LayoutOrigin fromPoint:self

    "
     (0@0.5) asFractionalLayout
     (0@0.5) asLayout
     (0@10) asLayout
     (0@10) asOffsetLayout
    "

!

asOffsetLayout
    "return a LayoutOrigin from the receiver,
     treating the receiver coordinates as absolute offsets.
     Notice: in 10.5.x LayoutOrigin is not yet released."

    ^ LayoutOrigin offsetFromPoint:self

    "
     (0@0.5) asFractionalLayout
     (0@0.5) asLayout
     (0@10) asLayout
     (0@10) asOffsetLayout
    "

!

asPoint
    "return the receiver as Point - this is the receiver"

    ^ self
!

asRectangle
    "return a zero-width rectangle consisting of origin
     and corner being the receiver"

    ^ self corner:self

    "
     (0@10) asRectangle
    "
!

corner:aPoint
    "return a rectangle whose origin is self and corner is aPoint"

    ^ Rectangle origin:self corner:aPoint
!

extent:aPoint
    "return a rectangle whose origin is self and extent is aPoint"

    ^ Rectangle origin:self extent:aPoint
!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be of the form: (Point xValue yValue)"

    x := encoding at:2.
    y := encoding at:3.

    "
     Point new fromLiteralArrayEncoding:#(Point 10 20)
    "
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is: (Point xValue yValue)"

    ^ Array
	with:#Point
	with:x
	with:y


    "
     Point new fromLiteralArrayEncoding:#(Point 10 20)
     (10@20) literalArrayEncoding
    "

    "Modified: 1.9.1995 / 02:18:29 / claus"
    "Modified: 22.4.1996 / 13:00:32 / cg"
!

rectangleRelativeTo:aRectangle preferred:prefRectHolder
    "compute a displayRectangle, treating the receiver like a
     layoutorigin. This allows point to be used interchangable with
     LayoutOrigins."

    ^ (self asLayout) rectangleRelativeTo:aRectangle preferred:prefRectHolder

    "
     consider the case, where a view has a preferred extent of 50@50
     and is to be positioned in its superview which has size 100@100.
     For absolute origin:
	 (10@20) rectangleRelativeTo:(0@0 corner:100@100) preferred:(0@0 corner:50@50)

     for relative origin:
	 (0.5@0.5) rectangleRelativeTo:(0@0 corner:100@100) preferred:(0@0 corner:50@50)
    "

    "Modified: / 27.5.1998 / 10:20:13 / cg"
! !

!Point methodsFor:'destructive transformations'!

scaleBy:aScale
    "scale the receiver, by replacing coordinates by the product
     of the receiver's coordinates and the scale (a Point or Number).
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver."

    |scalePoint|

    (aScale isMemberOf:Point) ifTrue:[  "type hint to stc"
	x := x * aScale x.
	y := y * aScale y.
	^ self
    ].
    aScale isNumber ifTrue:[
	x := x * aScale.
	y := y * aScale.
	^ self
    ].

    "this is the general (& clean) code ..."

    scalePoint := aScale asPoint.
    x := x * scalePoint x.
    y := y * scalePoint y
!

translateBy:anOffset
    "translate the receiver, by replacing coordinates by the sum
     of the receiver's coordinated and the scale (a Point or Number).
     This is destructive (modifies the receiver, not a copy) and
     should only be used if you know, that you are the exclusive owner
     of the receiver."

    |offsetPoint|

    (anOffset isMemberOf:Point) ifTrue:[ "type hint to stc"
	x := x + anOffset x.
	y := y + anOffset y.
	^ self
    ].
    anOffset isNumber ifTrue:[
	x := x + anOffset.
	y := y + anOffset.
	^ self
    ].

    "this is the general (& clean) code ..."

    offsetPoint := anOffset asPoint.
    x := x + anOffset x.
    y := y + anOffset y
! !


!Point methodsFor:'interpolating'!

interpolateTo: end at: amountDone
    "Interpolate between the instance and end after the specified amount has been done (0 - 1)."

    ^ self + ((end - self) * amountDone).

    "
     (10@10) interpolateTo:(20@20) at:0.5
     (10@10) interpolateTo:(20@20) at:0.3
     (0@0) interpolateTo:(0@20) at:0.5
    "
! !

!Point methodsFor:'misc'!

abs
    "return a new point with my coordinates taken from the absolute values."

    ^ self class x:(x abs) y:(y abs)
!

ceiling
    "return a new point with my coordinates truncated towards positive infinity.
     Return the receiver if its coordinates are already integral."

    (x isInteger and:[y isInteger]) ifTrue: [
	^ self
    ].

    ^ self class x:x ceiling y:y ceiling.
!

floor
    "return a new point with my coordinates truncated towards negative infinity.
     Return the receiver if its coordinates are already integral."

    (x isInteger and:[y isInteger]) ifTrue: [
	^ self
    ].

    ^ self class x:(x floor) y:(y floor)
!

quadrant
    "return the number of the quadrant containing the receiver.
     quadrants are named as follows:

	   ^    2  |  3
	   Y    ------
		1  |  0

		X >

     Q: what is to be returned if any coordinate is 0 ?
    "

    ^ 0@0 quadrantContaining:self

    "
     (1@1) quadrant
     (-1@1) quadrant
     (-1@-1) quadrant
     (1@-1) quadrant
     (0@0) quadrant
    "
!

quadrantContaining:aPoint
    "return the number of the quadrant containing aPoint placing
     the receiver at the origin, where the quadrants are numbered as
     follows:
	   ^    2  |  3
	   Y    ------
		1  |  0

		X >
     This can be used for polygon operations (see Foley for examples).
    "

     aPoint x > x ifTrue:[
	 aPoint y >= y ifTrue:[^ 3].
	 ^ 0
     ].
     aPoint y >= y ifTrue: [^ 2].
     ^ 1

     "
      (10 @ 10) quadrantContaining:(15 @ 15)
      (10 @ 10) quadrantContaining:(5 @ 5)
      (10 @ 10) quadrantContaining:(5 @ 15)
      (10 @ 10) quadrantContaining:(15 @ 5)
     "
!

rounded
    "return a new point with my coordinates rounded to the next integer.
     Return the receiver if its coordinates are already integral."

    (x isInteger and:[y isInteger]) ifTrue: [
	^ self
    ].
    ^ self class x:(x rounded) y:(y rounded)

    "
     (1.5 @ 2.6) rounded
     (1 @ 2) rounded
    "
!

truncateTo:aNumber
    "return a new point with my coordinates truncated towards zero to the next
     multiple of aNumber."

    ^ (self quo:aNumber) rounded * aNumber
!

truncated
    "return a new point with my coordinates truncated as integer.
     Return the receiver if its coordinates are already integral."

    (x isInteger and:[y isInteger]) ifTrue: [
	^ self
    ].

    ^ self class x:(x truncated) y:(y truncated)
! !

!Point methodsFor:'point functions'!

crossProduct: aPoint
    "Return a number that is the cross product of the receiver and the
     argument, aPoint."

    ^ (x * aPoint y) - (y * aPoint x)


!

dist:aPoint
    "return the distance between aPoint and the receiver."

    ^ (aPoint - self) r
!

dotProduct:aPoint
    "return a number that is the dot product of the receiver and
     the argument, aPoint.  That is, the two points are
     multiplied and the coordinates of the result summed."

    ^ (x * aPoint x) + (y * aPoint y)
!

fourNeighbors
    ^ Array
	with: self + (1@0)
	with: self + (0@1)
	with: self + (-1@0)
	with: self + (0@-1)
!

grid:gridPoint
    "return a new point with coordinates grided (i.e. rounded to the
     nearest point on the grid)"

    |newX newY gridX gridY|

    gridX := gridPoint x.
    (gridX <= 1) ifTrue:[
	newX := x asInteger
    ] ifFalse:[
	newX := ((x + (gridX // 2)) // gridX) * gridX
    ].
    gridY := gridPoint y.
    (gridY <= 1) ifTrue:[
	newY := y asInteger
    ] ifFalse:[
	newY := ((y + (gridY // 2)) // gridY) * gridY
    ].
    ^ newX @ newY
!

nearestIntegerPointOnLineFrom: point1 to: point2
    "return the closest integer point to the receiver on the line
     determined by (point1, point2)--much faster than the more
     accurate version if the receiver and arguments are integer points.
     This method was found in the Manchester goody library."

    | dX dY newX newY dX2 dY2 intersect scale coeff |

    dX := point2 x - point1 x.
    dY := point2 y - point1 y.
    (dX = 0)ifTrue: [
	(dY = 0) ifTrue: [
	    intersect := point1
	] ifFalse: [
	    newX := point1 x.
	    scale := (y - point1 y) / dY.
	    scale > 1 ifTrue:[
		newY := point2 y
	    ] ifFalse: [
		scale < 0 ifTrue: [
		    newY := point1 y
		] ifFalse: [
		    newY := y
		]
	    ].

	    ^ (newX @ newY) rounded
	]
    ] ifFalse: [
	(dY = 0) ifTrue: [
	    intersect := x @ point1 y
	] ifFalse:[
	    dX2 := dX * dX.
	    dY2 := dY * dY.
	    coeff := ((dX * (y - point1 y)) -
		     ((x - point1 x) * dY)) / (dX2 + dY2).
	    newX := x + (dY * coeff).
	    newY := y - (dX * coeff).
	    intersect := newX @ newY
	]
    ].

    scale := (intersect x - point1 x) / dX.

    ^ (scale > 1 ifTrue: [point2] ifFalse: [
      scale < 0 ifTrue: [point1] ifFalse: [intersect]]) rounded

    "
     120@40 nearestIntegerPointOnLineFrom: 30@120 to: 100@120
     0@0 nearestIntegerPointOnLineFrom: 10@10 to: 100@100
    "
!

normalized
    "interpreting myself as the endPoint of a 0@0 based vector,
     return the endPoint of the corresponding normalized vector.
     (that is the endPoint of a vector with the same direction but length 1)"

    ^ self / self r

    "
     (10 @ 10) normalized
     (1 @ 1) normalized
     (10 @ 0) normalized
     (0 @ 10) normalized
     (-10 @ 0) normalized
     (0 @ -10) normalized
     (0 @ 0) normalized
    "
!

transposed
    "return a new point with x and y coordinates exchanged"

    ^ y@x
! !

!Point methodsFor:'polar coordinates'!

angle
    "return the receiver's angle (in degrees) in a polar coordinate system.
     (i.e. the angle of a vector from 0@0 to the receiver).
    OBSOLETE ST/X interface; use theta for ST-80 compatibility."

    <resource:#obsolete>

    ^ self theta radiansToDegrees

    "
     (1@1) angle
     (1@0) angle
     (2@1) angle
    "

    "Modified: 2.4.1997 / 00:02:17 / cg"
!

degrees
    "return the receiver's angle (in degrees) in a polar coordinate system.
     (i.e. the angle of a vector from 0@0 to the receiver).
     The angle is counted counter-clock-wise, starting with 0 for a horizontal
     line (i.e. 0@0 -> 100@0 has an angle of 0 and 0@0 -> 0@100 has an angle of 90).
     Added for Squeak compatibility."

    ^ self theta radiansToDegrees

    "
     (1@1) degrees
     (2@1) degrees
    "
!

r
    "return the receiver's radius in a polar coordinate system.
     (i.e. the length of a vector from 0@0 to the receiver)"

    ^ ((x*x) + (y*y)) sqrt

    "
     (1@1) r
     (2@1) r
     (2@0) r
     (0@2) r
     (-2@-2) r
     (2@2) r
    "
!

theta
    "return the receiver's angle (in radians) in a polar coordinate system.
     (i.e. the angle of a vector from 0@0 to the receiver)"

    |theta t|

    x = 0 ifTrue:[
	y >= 0 ifTrue:[
	    ^ Float pi * 0.5
	].
	^ Float pi * 1.5.
    ].

    t := y asFloat / x asFloat.
    theta := t arcTan.
    x < 0 ifTrue:[
	^ theta + Float pi
    ].
    theta < 0 ifTrue:[
	^ theta + (Float pi * 2.0)
    ].
    ^ theta.
    "
     (1@1) theta
     (2@1) theta
     (-2@1) theta
     (-2@-1) theta
     (0@-1) theta
    "

    "Modified: 2.4.1997 / 00:15:12 / cg"
! !

!Point methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    x printOn:aStream.
    aStream nextPut:$@.
    y printOn:aStream
!

storeOn:aStream
    "append my storeString to aStream"

    aStream nextPut:$(.
    x storeOn:aStream.
    aStream nextPut:$@.
    y storeOn:aStream.
    aStream nextPut:$)
! !

!Point methodsFor:'queries'!

isPoint
    "return true, if the receiver is some kind of point"

    ^ true
! !

!Point methodsFor:'testing'!

isFinite
	^x isFinite and: [y isFinite]
!

isInfinite
	^x isInfinite or: [y isInfinite]
! !

!Point methodsFor:'transformations'!

* scale
    "Return a new Point that is the product of the
     receiver and scale (which is a Point or Number)."

    |scalePoint|

    "speedup for common cases ..."

    (scale isMemberOf:Point) ifTrue:[
	^ self class x:(x * scale x) y:(y * scale y)
    ].
    (scale isMemberOf:SmallInteger) ifTrue:[
	^ self class x:(x * scale) y:(y * scale)
    ].
    scale isNumber ifTrue:[
	^ self class x:(x * scale) y:(y * scale)
    ].

    "this is the general (& clean) code ..."

    scalePoint := scale asPoint.
    ^ self class x:(x * scalePoint x) y:(y * scalePoint y)

    "Modified: 25.1.1997 / 17:28:11 / cg"
!

+ translation
    "Return a new Point that is the sum of the
     receiver and translation (which is a Point or Number)."

    |translationPoint|

    "speedup for common cases ..."

    (translation isMemberOf:Point) ifTrue:[
	^ self class x:(x + translation x) y:(y + translation y)
    ].
    (translation isMemberOf:SmallInteger) ifTrue:[
	"/ same as below, but stc can do better here
	^ self class x:(x + translation) y:(y + translation)
    ].
    translation isNumber ifTrue:[
	^ self class x:(x + translation) y:(y + translation)
    ].

    "this is the general (& clean) code ..."

    translationPoint := translation asPoint.
    ^ self class x:(x + translationPoint x) y:(y + translationPoint y).

    "Modified: 25.1.1997 / 17:27:46 / cg"
!

- translation
    "Return a new Point that is the difference of the
     receiver and translation (which is a Point or Number)."

    |translationPoint|

    "speedup for common cases ..."

    (translation isMemberOf:Point) ifTrue:[
	^ self class x:(x - translation x) y:(y - translation y)
    ].
    (translation isMemberOf:SmallInteger) ifTrue:[
	"/ same as below, but stc can do better here
	^ self class x:(x - translation) y:(y - translation)
    ].
    translation isNumber ifTrue:[
	^ self class x:(x - translation) y:(y - translation)
    ].

    "this is the general (& clean) code ..."

    translationPoint := translation asPoint.
    ^ self class x:(x - translationPoint x) y:(y - translationPoint y).

    "Modified: 25.1.1997 / 17:27:46 / cg"
!

/ scale
    "Return a new Point that is the integer quotient of the
     receiver and scale (which is a Point or Number)."

    |scalePoint|

    "speedup for common cases ..."

    (scale isMemberOf:Point) ifTrue:[
	self class x:(x / scale x) y:(y / scale y)
    ].
    scale isNumber ifTrue:[
	^ self class x:(x / scale) y:(y / scale)
    ].

    "this is the general (& clean) code ..."

    scalePoint := scale asPoint.
    ^ self class x:(x / scalePoint x) y:(y / scalePoint y)
!

// scale
    "Return a new Point that is the quotient of the
     receiver and scale (which is a Point or Number)."

    |scalePoint|

    scalePoint := scale asPoint.
    ^ self class x:(x // scalePoint x) y:(y // scalePoint y)
!

negated
    "return a new point with my coordinates negated
     i.e. the receiver mirrored at the origin"

    ^ self class x:x negated y:y negated

    "
	(1 @ 1) negated
    "
!

reciprocal
    "return a new point where the coordinates are
     the reciproce of mine"

    ^ self class x:(1 / x) y:(1 / y)
!

rotateBy:angle about:center
    "Return a new point, generated by rotating the receiver
     counterClockWise by some angle in radians around the given center point.
     Even though Point.theta is measured CW,
     this rotates with the more conventional CCW interpretateion of angle."

    |p r theta|

    p := self - center.
    r := p r.
    theta := angle asFloat - p theta.
    ^ self class x:(center x asFloat + (r * theta cos))
		 y:(center y asFloat - (r * theta sin))

    "
     (10@10) rotateBy:Float pi about:0@0
     (10@0) rotateBy:Float pi about:0@0
    "
!

scaledBy:aScale
    "return a new Point that is the product of the
     receiver and scale (which is a Point or Number)."

    ^ self * aScale
!

translatedBy:anOffset
    "return a new Point that is the sum of the
     receiver and scale (which is a Point or Number)."

    ^ self + anOffset
! !

!Point class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: Point.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


Point initialize!




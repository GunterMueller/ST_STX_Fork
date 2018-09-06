"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

DisplayTransform variableFloatSubclass:#MatrixTransform2x3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Transformations'
!

!MatrixTransform2x3 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    This class represents a transformation for points, that is a combination of scale, offset, and rotation. 
    It is implemented as a 2x3 matrix containing the transformation from the local coordinate system in the global coordinate system. 
    Thus, transforming points from local to global coordinates is fast and cheap,
    whereas transformations from global to local coordinate systems are relatively expensive.

    Implementation Note: It is assumed that the transformation deals with Integer points. 
    All transformations will return Integer coordinates (even though float points may be passed in here).
"
!

examples
"
    example :
                                                                        [exBegin]
     |v|

     v := View new openAndWait.
     v transformation:(MatrixTransform2x3 withAngle:5).
     v displayLineFrom:50@50 to:100@100 
                                                                        [exEnd]

                                                                        [exBegin]
     |v|

     v := View new openAndWait.
     v transformation:(MatrixTransform2x3 withAngle:45).
     v fillRectangleX:10 y:10 width:100 height:100.
                                                                        [exEnd]
"
! !

!MatrixTransform2x3 class methodsFor:'instance creation'!

identity
    ^self new setScale: 1.0
!

new
	^self new: 6
!

transformFromLocal: localBounds toGlobal: globalBounds
	^((self withOffset: (globalBounds center)) composedWithLocal:
		(self withScale: (globalBounds extent / localBounds extent) asFloatPoint))
			composedWithLocal: (self withOffset: localBounds center negated)
"
	^(self identity)
		setScale: (globalBounds extent / localBounds extent) asFloatPoint;
		setOffset: localBounds center negated asFloatPoint;
		composedWithGlobal:(self withOffset: globalBounds center asFloatPoint)
"
!

withAngle: angle
        "return a new transformation which rotates by angle (in degrees)"

        ^self new setAngle: angle
!

withOffset: aPoint
    "return a new transformation which translates by aPoint"

    ^self identity setOffset: aPoint
!

withRotation: angle
    "return a new transformation which rotates by angle (in degrees)"

    ^self new setAngle: angle
!

withScale: aPoint
    "return a new transformation which scales by aPoint's x/y values in x/y directions"

    ^self new setScale: aPoint
! !

!MatrixTransform2x3 methodsFor:'accessing'!

at: index
"/        <primitive: 'primitiveFloatArrayAt'>
"/        ^Float fromIEEE32Bit: (self basicAt: index)
          ^ self basicAt: index
!

at: index put: value
"/        <primitive: 'primitiveFloatArrayAtPut'>
"/        value isFloat 
"/                ifTrue:[self basicAt: index put: value asIEEE32BitWord]
"/                ifFalse:[self at: index put: value asFloat].
"/        ^value
        ^ self basicAt: index put:value
!

inverseTransformation
	"Return the inverse transformation of the receiver.
	The inverse transformation is computed by first calculating
	the inverse offset and then computing transformations
	for the two identity vectors (1@0) and (0@1)"
	| r1 r2 r3 m |
	r3 _ self invertPoint: 0@0.
	r1 _ (self invertPoint: 1@0) - r3.
	r2 _ (self invertPoint: 0@1) - r3.
	m _ self species new.
	m
		a11: r1 x; a12: r2 x; a13: r3 x;
		a21: r1 y; a22: r2 y; a23: r3 y.
	^m
!

offset
	^self a13 @ self a23
!

offset: aPoint
	self a13: aPoint x asFloat.
	self a23: aPoint y asFloat.
! !

!MatrixTransform2x3 methodsFor:'comparing'!

= MatrixTransform2x3
        | length |
"/        <primitive:'primitiveFloatArrayEqual'>
        self class = MatrixTransform2x3 class ifFalse:[^false].
        length _ self size.
        (length = MatrixTransform2x3 size) ifFalse:[^false].
        1 to: self size do:[:i| (self at: i) = (MatrixTransform2x3 at: i) ifFalse:[^false]].
        ^true
!

hash
        | result |
"/        <primitive:'primitiveFloatArrayHash'>
"/        result _ 0.
"/        1 to: self size do:[:i| result _ result + (self basicAt: i) ].
"/        ^result bitAnd: 16r1FFFFFFF
        result _ 0.
        1 to: self size do:[:i| result _ result + (self basicAt: i) hash ].
        ^result bitAnd: 16r1FFFFFFF
! !

!MatrixTransform2x3 methodsFor:'composing'!

composedWithLocal: aTransformation
	"Return the composition of the receiver and the local transformation passed in"
	aTransformation isMatrixTransform2x3 ifFalse:[^super composedWith: aTransformation].
	^self composedWithLocal: aTransformation asMatrixTransform2x3 into: self class new
!

composedWithLocal: aTransformation into: result
        "Return the composition of the receiver and the local transformation passed in.
        Store the composed matrix into result."
        | a11 a12 a13 a21 a22 a23 b11 b12 b13 b21 b22 b23 matrix |
"/        <primitive: 'm23PrimitiveComposeMatrix'>
        matrix _ aTransformation asMatrixTransform2x3.
        a11 _ self a11.                 b11 _ matrix a11.
        a12 _ self a12.                 b12 _ matrix a12.
        a13 _ self a13.                 b13 _ matrix a13.
        a21 _ self a21.                 b21 _ matrix a21.
        a22 _ self a22.                 b22 _ matrix a22.
        a23 _ self a23.                 b23 _ matrix a23.
        result a11: (a11 * b11) + (a12 * b21).
        result a12: (a11 * b12) + (a12 * b22).
        result a13: a13 + (a11 * b13) + (a12 * b23).
        result a21: (a21 * b11) + (a22 * b21).
        result a22: (a21 * b12) + (a22 * b22).
        result a23: a23 + (a21 * b13) + (a22 * b23).
        ^result
! !

!MatrixTransform2x3 methodsFor:'converting'!

asMatrixTransform2x3
	^self
! !

!MatrixTransform2x3 methodsFor:'element access'!

a11
	^self at: 1
!

a11: value
	 self at: 1 put: value
!

a12
	^self at: 2
!

a12: value
	 self at: 2 put: value
!

a13
	^self at: 3
!

a13: value
	 self at: 3 put: value
!

a21
	 ^self at: 4
!

a21: value
	 self at: 4 put: value
!

a22
	 ^self at: 5
!

a22: value
	 self at: 5 put: value
!

a23
	 ^self at: 6
!

a23: value
	 self at: 6 put: value
! !

!MatrixTransform2x3 methodsFor:'initialize'!

setIdentiy
	"Initialize the receiver to the identity transformation (e.g., not affecting points)"
	self
		a11: 1.0; a12: 0.0; a13: 0.0;
		a21: 0.0; a22: 1.0; a23: 0.0.
! !

!MatrixTransform2x3 methodsFor:'printing'!

printOn: aStream
	aStream 
		nextPutAll: self class name;
		nextPut: $(;
		cr; print: self a11; tab; print: self a12; tab; print: self a13;
		cr; print: self a21; tab; print: self a22; tab; print: self a23;
		cr; nextPut:$).
! !

!MatrixTransform2x3 methodsFor:'private'!

setAngle: angle
        "Set the raw rotation angle (in degrees) in the receiver"

        | rad s c |
        rad := angle degreesToRadians.
        s := rad sin.
        c := rad cos.
        self a11: c.
        self a12: s negated.
        self a21: s.
        self a22: c.
!

setOffset: aPoint
        "Set the raw offset in the receiver"
        | pt |
        pt := aPoint asPoint.
        self a13: pt x asFloat.
        self a23: pt y asFloat.
!

setScale: aPoint
        "Set the raw scale in the receiver"
        | pt |
        pt := aPoint asPoint.
        self a11: pt x asFloat.
        self a22: pt y asFloat.
! !

!MatrixTransform2x3 methodsFor:'testing'!

isIdentity
        "Return true if the receiver is the identity transform; that is, if applying to a point returns the point itself."
"/        <primitive: 'm23PrimitiveIsIdentity'>
        ^self isPureTranslation and:[self a13 = 0.0 and:[self a23 = 0.0]]
!

isMatrixTransform2x3
	"Return true if the receiver is 2x3 matrix transformation"
	^true
!

isNoScale
    "Return true if the receiver has an identity scale; i.e. the scale factor is 1.
     Return false otherwise."

    ^ self a11 = 1 and:[ self a22 = 1 ]
!

isPureTranslation
        "Return true if the receiver specifies no rotation or scaling."
"/        <primitive: 'm23PrimitiveIsPureTranslation'>
        ^self a11 = 1.0 and:[self a12 = 0.0 and:[self a22 = 0.0 and:[self a21 = 1.0]]]
! !

!MatrixTransform2x3 methodsFor:'transforming points'!

globalPointToLocal: aPoint
        "Transform aPoint from global coordinates into local coordinates"
"/        <primitive: 'm23PrimitiveInvertPoint'>
        ^(self invertPoint: aPoint) rounded
!

invertPoint: aPoint
	"Transform aPoint from global coordinates into local coordinates"
	| x y det a11 a12 a21 a22 detX detY |
	x _ aPoint x asFloat - (self a13).
	y _ aPoint y asFloat - (self a23).
	a11 _ self a11.	a12 _ self a12.
	a21 _ self a21.	a22 _ self a22.
	det _ (a11 * a22) - (a12 * a21).
	det = 0.0 ifTrue:[^0@0]. "So we have at least a valid result"
	det _ 1.0 / det.
	detX _ (x * a22) - (a12 * y).
	detY _ (a11 * y) - (x * a21).
	^(detX * det) @ (detY * det)
!

localPointToGlobal: aPoint
        "Transform aPoint from local coordinates into global coordinates"
"/        <primitive: 'm23PrimitiveTransformPoint'>
        ^(self transformPoint: aPoint) rounded
!

transformDirection: aPoint
        "Transform aPoint from local coordinates into global coordinates;
         Ignores the offset."
        | x y |
        x := (aPoint x * self a11) + (aPoint y * self a12).
        y := (aPoint x * self a21) + (aPoint y * self a22).
        ^x @ y
!

transformPoint: aPoint
        "Transform aPoint from local coordinates into global coordinates"
        | x y |
        x := (aPoint x * self a11) + (aPoint y * self a12) + self a13.
        y := (aPoint x * self a21) + (aPoint y * self a22) + self a23.
        ^x @ y
! !

!MatrixTransform2x3 methodsFor:'transforming rects'!

globalBounds: srcRect toLocal: dstRect
        "Transform aRectangle from global coordinates into local coordinates"
"/        <primitive:'m23PrimitiveInvertRectInto'>
        ^super globalBoundsToLocal: srcRect
!

globalBoundsToLocal: aRectangle
	"Transform aRectangle from global coordinates into local coordinates"
	^self globalBounds: aRectangle toLocal: Rectangle new
!

localBounds: srcRect toGlobal: dstRect
        "Transform aRectangle from local coordinates into global coordinates"
"/        <primitive:'m23PrimitiveTransformRectInto'>
        ^super localBoundsToGlobal: srcRect
!

localBoundsToGlobal: aRectangle
	"Transform aRectangle from local coordinates into global coordinates"
	^self localBounds: aRectangle toGlobal: Rectangle new
! !

!MatrixTransform2x3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/MatrixTransform2x3.st,v 1.6 2014-12-21 23:26:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/MatrixTransform2x3.st,v 1.6 2014-12-21 23:26:37 cg Exp $'
! !


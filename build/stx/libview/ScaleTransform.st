"{ Encoding: utf8 }"

"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

DisplayTransform variableFloatSubclass:#ScaleTransform
	instanceVariableNames:'scale'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Transformations'
!

!ScaleTransform class methodsFor:'documentation'!

documentation
"
    instances of ScaleTransform can be used to scale other objects in 2D space.
    This one is used, if only a scale is applied, but no translation.
 
    All 2-D objects are supposed to be able to be transformed using instances of me.  
    Multiple instances of me can also be combined to form a single composite transformation.

    [Instance variables:]
        scale           <Number> or <Point> representing a linear scaling factor.
                        nil is interpreted as 1@1

    [author:]
        Claus Gittinger
"
!

examples
"
    example :
                                                                        [exBegin]
     |v|

     v := View new extent:200@200; openAndWait.
     v paint:Color green.
     v fillRectangle:(10@10 corner:40@40).
     v displayLineFrom:50@50 to:75@100. 

     v transformation:(ScaleTransform withScale:2).
     v paint:Color red.
     v fillRectangle:(10@10 corner:40@40).
     v displayLineFrom:50@50 to:75@100. 
                                                                        [exEnd]

"
! !

!ScaleTransform class methodsFor:'instance creation'!

scale:scaleFactor
    ^ self new scale:scaleFactor
!

withScale:scaleFactor
    ^ self new scale:scaleFactor
! !

!ScaleTransform methodsFor:'accessing'!

inverseTransformation
    "Return the inverse transformation of the receiver"

    ^ ScaleTransform withScale:(1 / scale)
!

scale
    "return a copy of the Point that represents the
     current scale of the receiver."

    scale isNil ifTrue:[^ Point x:1 y:1 ].
    ^ scale copy
!

scale:aScale
    "Set the receiver's scale to aScale, a Point or Number."

    aScale isNil ifTrue:[
        scale := aScale
    ] ifFalse:[
        aScale = 1 ifTrue:[
            scale := nil
        ] ifFalse:[
            scale := aScale asPoint.
            (scale x = 1 and:[scale y = 1]) ifTrue:[
                scale := nil
            ].
        ]
    ].

    "Modified: / 13.6.1998 / 14:04:51 / cg"
!

scaleOfOne
    "Set the scale of the receiver to the identity scale"

    scale := nil
!

scaleX
    "return the current x-scale of the receiver."

    scale isNil ifTrue:[^ 1].
    ^ scale x

    "Created: 21.5.1996 / 21:13:49 / cg"
!

scaleY
    "return the current x-scale of the receiver."

    scale isNil ifTrue:[^ 1].
    ^ scale y

    "Created: 21.5.1996 / 21:13:59 / cg"
!

translation
    "return a copy of the receiver's translation."

    ^ Point x:0 y:0
!

translationX
    "return the x part of the receiver's translation."

    ^ 0 
!

translationY
    "return the y part of the receiver's translation."

    ^ 0 
! !

!ScaleTransform methodsFor:'applying transform'!

applyInverseScaleX:aNumber
    "apply the scale only (if widths are to be transformed)"

    scale isNil ifTrue:[^ aNumber].
    ^ aNumber / scale x
!

applyInverseScaleY:aNumber
    "apply the scale only (if heights are to be transformed)"

    scale isNil ifTrue:[^ aNumber].
    ^ aNumber / scale y
!

applyInverseTo:anObject 
    "Apply the inverse of the receiver to anObject
     and return the result. This can be used to map back from logical
     to physical coordinates, for example."

    scale isNil ifTrue:[
        ^ anObject
    ].
    ^ anObject scaledBy:self inverseScale 
!

applyInverseToX:aNumber
    "Apply the receiver to a number representing an x-coordinate
     and return the result."

    |s|

    scale isNil ifTrue:[s := 1] ifFalse:[s := scale x].
    ^ aNumber / s
!

applyInverseToY:aNumber
    "Apply the receiver to a number representing an y-coordinate
     and return the result."

    |s|

    scale isNil ifTrue:[s := 1] ifFalse:[s := scale y].
    ^ aNumber / s
!

applyScaleX:aNumber
    "apply the scale only (if widths are to be transformed)"

    scale isNil ifTrue:[^ aNumber].
    ^ aNumber * scale x
!

applyScaleY:aNumber
    "apply the scale only (if heights are to be transformed)"

    scale isNil ifTrue:[^ aNumber].
    ^ aNumber * scale y
!

transformPoint:p 
    "Apply the receiver to a point, returning a new point."

    scale isNil ifTrue:[
        ^ p
    ].
    ^ p * scale
!

transformRectangle:aRectangle 
    "Apply the receiver to a rectangle, returning a new rectangle."

    scale isNil ifTrue:[
        ^ aRectangle.
    ].
    ^ aRectangle scaledBy:scale.
! !

!ScaleTransform methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream nextPutAll:self class name.
    aStream nextPutAll:' scale: '.
    scale printOn:aStream.
! !

!ScaleTransform methodsFor:'private'!

checkScale:aScale
    "Converts aScale to the internal format of a floating-point Point."

    |checkedScale|

    checkedScale := aScale asPoint.
    ^ (checkedScale x asFloat) @ (checkedScale y asFloat)

    "Modified: / 22-01-2015 / 14:21:11 / az"
!

inverseScale
    "return with a Point representing the inverse of my
     scale."

    |newScale|

    newScale := self checkScale:scale.
    ^ (1.0 / newScale x) @ (1.0 / newScale y)
! !

!ScaleTransform methodsFor:'testing'!

isIdentityTransformation
    "return true if this is an identity transformation;
     return false, otherwise."

    ^ scale isNil or:[scale x = 1 and:[scale y = 1]]
!

isNoScale
    "return true if the identity scale is in effect (i.e. saleFactor is 1);
     return false, otherwise."

    scale isNil ifTrue:[^ true].
    ^ scale x = 1 and:[scale y = 1]
! !

!ScaleTransform methodsFor:'transformations'!

scaleBy:aScale 
    "scale the receiver.
     This is a destructive operation, modifying the transformation
     represented by the receiver"

    |newScale|

    aScale isNil ifTrue:[^ self].

    scale isNil ifTrue:[
        newScale := aScale asPoint
    ] ifFalse:[
        newScale := scale * aScale
    ].
    self scale:newScale.
!

scaledBy:aScale 
    "return a new WindowingTransformation with the scale and translation of 
     the receiver both scaled by aScale."

    |checkedScale newScale|

    aScale isNil ifTrue:[
        newScale := scale.
    ] ifFalse:[
        checkedScale := self checkScale:aScale.
        scale isNil ifTrue:[
            newScale := checkedScale
        ] ifFalse:[
            newScale := scale * checkedScale
        ].
    ].
    ^ (self class) withScale:newScale
!

translateBy:aTranslation 
    "translate the receiver.
     This is a destructive operation, modifying the transformation
     represented by the receiver"

    self error:'not allowed'
!

translatedBy:aPoint 
    "return a new WindowingTransformation with the same scale and 
     rotations as the receiver and with a translation of the current 
     translation plus aPoint."

    ^ WindowingTransformation
          scale:scale
          translation:aPoint
! !

!ScaleTransform class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

ScaleTransform variableFloatSubclass:#WindowingTransformation
	instanceVariableNames:'translation'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Transformations'
!

!WindowingTransformation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    instances of WindowingTransformation can be used to scale, translate or
    generally transform other objects in 2D space. 
    They can also be set as the translation in a graphic context, 
    which will then apply this to all of its drawing operations 
    (see GraphicContext>>transformation:).

    All 2-D objects are supposed to be able to be transformed using
    instances of me.  Multiple instances of me can also be combined to form a
    single composite transformation.

    [Instance variables:]
        scale           <Number> or <Point> representing a linear scaling factor.
                        nil is interpreted as 1@1

        translation     <Number> or <Point> representing a translation in 2-D.
                        nil is interpreted as 0@0


    [author:]
        Claus Gittinger
"

    "Modified: 25.4.1996 / 16:53:07 / cg"
!

examples
"
    example (drawing in inches):
                                                                        [exBegin]
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation unit:#inch on:Display).
     'now, we can think of drawing in inches ...'.
     v displayLineFrom:0.5@0.5 to:1@1 
                                                                        [exEnd]


    example (drawing in millimeters):
                                                                        [exBegin]
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation unit:#mm on:Display).
     'now, we can think of drawing in millimeters ...'.
     v displayLineFrom:5@5 to:20@5 
                                                                        [exEnd]


    example (drawing magnified):
                                                                        [exBegin]
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation scale:2 translation:0).
     'now, everything is magnfied by 2'.
     v displayLineFrom:10@10 to:30@30 
                                                                        [exEnd]

    example (drawing shrunk):
                                                                        [exBegin]
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation scale:0.5 translation:0).
     'now, everything is shrunk by 2'.
     v displayLineFrom:10@10 to:30@30 
                                                                        [exEnd]
"

    "Modified: 27.4.1996 / 19:45:43 / cg"
! !

!WindowingTransformation class methodsFor:'instance creation'!

identity
    "returns a windowing transformation with no scaling (1@1) 
     and no translation (0@0)."

    ^ self basicNew "/ scale:nil translation:nil 

    "
     WindowingTransformation identity
    "

    "Modified: 30.12.1996 / 16:59:27 / cg"
!

scale:aScale 
    "returns a windowing transformation with a scale factor of  aScale and no translation"

    ^ self basicNew scale:aScale translation:0

    "
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation scale:2 translation:0).
     'now, everything is magnfied by 2'.
     v displayLineFrom:10@10 to:30@30 
    "
    "
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation scale:0.5 translation:0).
     'now, everything is shrunk by 2'.
     v displayLineFrom:10@10 to:30@30 
    "
!

scale:aScale translation:aTranslation 
    "returns a windowing transformation with a scale factor of  
     aScale and a translation offset of aTranslation."

    ^ self basicNew scale:aScale translation:aTranslation

    "
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation scale:2 translation:0).
     'now, everything is magnfied by 2'.
     v displayLineFrom:10@10 to:30@30 
    "
    "
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation scale:0.5 translation:0).
     'now, everything is shrunk by 2'.
     v displayLineFrom:10@10 to:30@30 
    "
!

translation:aTranslation 
    "returns a windowing transformation with no scaling and a translation offset of aTranslation."

    ^ self basicNew scale:nil translation:aTranslation

    "
     |v|

     v := View new openAndWait.
     v displayLineFrom:10@10 to:30@30. 
     v transformation:(WindowingTransformation scale:2 translation:0).
     'now, everything is magnfied by 2'.
     v displayLineFrom:10@10 to:30@30. 
    "
    "
     |v|

     v := View new openAndWait.
     v displayLineFrom:10@10 to:30@30. 
     v transformation:(WindowingTransformation translation:50).
     'now, everything is offset by 50 pixels'.
     v displayLineFrom:10@10 to:30@30. 
    "
!

unit:unitSymbol on:device 
    "returns a windowing transformation with scaling 
     for unitSymbol and no translation (0@0).
     With such a transformation, you can draw in your preferred 
     units.
     UnitSymbol may be #mm, #cm, #inch, #point, #twip or #pixel (default).
     Twip is 1/20th of a point, point is 1/72th of an inch
     (i.e. the print-unit which is also used for font sizes etc.) 
     - not to confuse with device pixels."

    |ppmm ppi scale|

    ppmm := device pixelPerMillimeter.
    ppi := device pixelPerInch.

    unitSymbol == #mm ifTrue:[
        scale := ppmm.
    ] ifFalse:[
        unitSymbol == #cm ifTrue:[
            scale := ppmm * 10.
        ] ifFalse:[
            unitSymbol == #twip ifTrue:[
                scale := ppi / 1440.
            ] ifFalse:[
                unitSymbol == #point ifTrue:[
                    scale := ppi / 72.
                ] ifFalse:[
                    unitSymbol == #inch ifTrue:[
                        scale := ppi.
                    ] ifFalse:[
                        "sorry: unknown unit is taken as pixel"
                        ^ self new scale:nil translation:nil
                    ]
                ]
            ]
        ]
    ].
    ^ self basicNew scale:scale translation:nil

    "
     |v|

     v := View new openAndWait.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation unit:#inch on:Display).
     'now, we can think of drawing in inches ...'.
     v displayLineFrom:0.5@0.5 to:1@1 
    "
    "
     |v|

     v := View new openAndWait.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation unit:#mm on:Display).
     'now, we can think of drawing in millimeters ...'.
     v displayLineFrom:2@2 to:10@10 
    "

    "Modified: 30.12.1996 / 16:57:59 / cg"
!

window:sourceRectangle viewport:destinationRectangle 
    "returns a windowing transformation with a scale and
     translation computed from sourceRectangle and destinationRectangle.
     The scale and transformation are computed such that sourceRectangle
     is transformed to destinationRectangle. Typically sourceRectangle
     represents the logical coordinateSpace while destinationRectangle 
     represents the device coordinateSpace."

    |sX sY tX tY newScale newTranslation|

    sX := destinationRectangle width / sourceRectangle width.
    sY := destinationRectangle height / sourceRectangle height.
    tX := destinationRectangle left - sourceRectangle left.
    tY := destinationRectangle top - sourceRectangle top.
    ((tX = 1.0) and:[tY = 1.0]) ifTrue:[
	newTranslation := nil
    ] ifFalse:[
	newTranslation := tX @ tY
    ].
    ((sX = 1.0) and:[sY = 1.0]) ifTrue:[
	newScale := nil
    ] ifFalse:[
	newScale := sX @ sY
    ].
    ^ self basicNew scale:newScale translation:newTranslation

    "
     |v|

     v := View new realize.
     (Delay forSeconds:3) wait.
     v transformation:(WindowingTransformation 
				window:(0@0 corner:1@1)
				viewport:(0@0 corner:100@100)).
     'now, we can think of drawing in 0..1/0..1 coordinates'.
     v displayLineFrom:0.1@0.1 to:0.9@0.9 
    "
!

withAngle:angle
    ^ MatrixTransform2x3 withAngle:angle
! !

!WindowingTransformation methodsFor:'accessing'!

scale:aScale translation:aTranslation
    "sets the scale to aScale and the translation to aTranslation."

    aScale isNil ifTrue:[
        scale := aScale
    ] ifFalse:[
        aScale = 1 ifTrue:[
            scale := nil
        ] ifFalse:[
            scale := aScale asPoint.
        ]
    ].
    aTranslation isNil ifTrue:[
        translation := aTranslation
    ] ifFalse:[
        aTranslation = 0 ifTrue:[
            translation := nil
        ] ifFalse:[
            translation := aTranslation asPoint
        ]
    ]

    "Modified: / 13.6.1998 / 14:04:42 / cg"
!

translation
    "return a copy of the receiver's translation."

    translation isNil ifTrue:[^ Point x:0 y:0 ].
    ^ translation copy
!

translation:aTranslation
    "Set the receiver's translation to aTranslation, a Point or Number."

    aTranslation isNil ifTrue:[
        translation := aTranslation
    ] ifFalse:[
        aTranslation = 0 ifTrue:[
            translation := nil
        ] ifFalse:[
            translation := aTranslation asPoint
        ]
    ]

    "Modified: / 13.6.1998 / 14:04:15 / cg"
!

translationX
    "return the receiver's x-translation."

    translation isNil ifTrue:[^ 0].
    ^ translation x

    "Created: 21.5.1996 / 21:13:10 / cg"
!

translationY
    "return the receiver's x-translation."

    translation isNil ifTrue:[^ 0].
    ^ translation y

    "Created: 21.5.1996 / 21:13:21 / cg"
! !

!WindowingTransformation methodsFor:'applying transform'!

applyInverseTo:anObject 
    "Apply the inverse of the receiver to anObject
     and return the result. This can be used to map back from logical
     to physical coordinates, for example."

    |transformedObject|

    translation isNil ifTrue:[
	scale isNil ifTrue:[
	    ^ anObject
	].
	^ anObject scaledBy:self inverseScale 
    ].
    transformedObject := anObject translatedBy:(self inverseTranslation).
    scale notNil ifTrue:[
	transformedObject scaleBy:(self inverseScale).
    ].
    ^ transformedObject
!

applyInverseToX:aNumber
    "Apply the receiver to a number representing an x-coordinate
     and return the result."

    |t s|

    scale isNil ifTrue:[s := 1] ifFalse:[s := scale x].
    translation isNil ifTrue:[t := 0] ifFalse:[t := translation x].
    ^ (aNumber - t) / s
!

applyInverseToY:aNumber
    "Apply the receiver to a number representing an y-coordinate
     and return the result."

    |t s|

    scale isNil ifTrue:[s := 1] ifFalse:[s := scale y].
    translation isNil ifTrue:[t := 0] ifFalse:[t := translation y].
    ^ (aNumber - t) / s
!

applyTo:anObject 
    "Apply the receiver to anObject and return the result."

    |transformedObject|

    scale isNil ifTrue:[
	translation isNil ifTrue:[
	    ^ anObject
	].
	^ anObject translatedBy:translation 
    ].
    transformedObject := anObject scaledBy:scale.
    translation notNil ifTrue:[
	transformedObject translateBy:translation.
    ].
    ^ transformedObject
!

applyToX:aNumber
    "Apply the receiver to a number representing an x-coordinate
     and return the result."

    |t s|

    scale isNil ifTrue:[s := 1] ifFalse:[s := scale x].
    translation isNil ifTrue:[t := 0] ifFalse:[t := translation x].
    ^ aNumber * s + t
!

applyToY:aNumber
    "Apply the receiver to a number representing an y-coordinate
     and return the result."

    |t s|

    scale isNil ifTrue:[s := 1] ifFalse:[s := scale y].
    translation isNil ifTrue:[t := 0] ifFalse:[t := translation y].
    ^ aNumber * s + t
!

compose:aTransformation 
    "return a new WindowingTransformation that is the
     composition of the receiver and aTransformation.
     The effect of applying the resulting WindowingTransformation
     to an object is the same as that of first applying
     aTransformation to the object and then applying the 
     receiver to its result."

    |aTransformationScale newScale newTranslation|

    aTransformationScale := aTransformation scale.
    scale isNil ifTrue:[
        aTransformation isNoScale ifTrue:[
            newScale := nil
        ] ifFalse:[
            newScale := aTransformationScale
        ].
        newTranslation := (translation ? 0) + aTransformation translation
    ] ifFalse:[
        aTransformation isNoScale ifTrue:[
            newScale := scale
        ] ifFalse:[
            newScale := scale * aTransformationScale
        ].
        newTranslation := (translation ? 0)
                          + (scale * aTransformation translation)
    ].
    ^ (self class) 
          scale:newScale
          translation:newTranslation
!

composedWithLocal: aTransformation
    ^ self compose:aTransformation
!

transformPoint:p 
    "Apply the receiver to a point, returning a new point."

    scale isNil ifTrue:[
        translation isNil ifTrue:[
            ^ p
        ].
        ^ p + translation
    ].
    translation isNil ifTrue:[
        ^ p * scale
    ].
    ^ (p * scale + translation)
!

transformRectangle:aRectangle 
    "Apply the receiver to a rectangle, returning a new rectangle."

    ^ aRectangle scaledBy:scale translatedBy:translation.
! !

!WindowingTransformation methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream nextPutAll:self class name.
    aStream nextPutAll:' scale: '.
    scale printOn:aStream.
    aStream nextPutAll:' translation: '.
    translation printOn:aStream
! !

!WindowingTransformation methodsFor:'private'!

inverseTranslation
    "return with a Point or Number representing the inverse of my
     translation."

    translation isNil ifTrue:[
        ^ nil.
    ].
    ^ translation negated.
! !

!WindowingTransformation methodsFor:'testing'!

isIdentityTransformation
    "return true if this is an identity transformation;
     return false, otherwise."

    ^ (scale isNil or:[scale x = 1 and:[scale y = 1]])
        and:[translation isNil or:[translation x = 0 and:[translation y = 0]]]
! !

!WindowingTransformation methodsFor:'transformations'!

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
    translation notNil ifTrue:[
	translation := translation * aScale.
    ].
    scale := newScale.
!

scaledBy:aScale 
    "return a new WindowingTransformation with the scale and translation of 
     the receiver both scaled by aScale."

    |checkedScale newScale newTranslation|

    aScale isNil ifTrue:[
	newScale := scale.
	newTranslation := translation
    ] ifFalse:[
	checkedScale := self checkScale:aScale.
	scale isNil ifTrue:[
	    newScale := checkedScale
	] ifFalse:[
	    newScale := scale * checkedScale
	].
	translation notNil ifTrue:[
	    newTranslation := checkedScale * translation
	]
    ].
    ^ (self class) 
	  scale:newScale
	  translation:newTranslation
!

translateBy:aTranslation 
    "translate the receiver.
     This is a destructive operation, modifying the transformation
     represented by the receiver"

    aTranslation isNil ifTrue:[^ self].

    translation isNil ifTrue:[
	translation := 0@0
    ].
    scale isNil ifTrue:[
	translation := translation + aTranslation asPoint
    ] ifFalse:[
	translation := translation + (scale * aTranslation)
    ].
!

translatedBy:aPoint 
    "return a new WindowingTransformation with the same scale and 
     rotations as the receiver and with a translation of the current 
     translation plus aPoint."

    ^ (self class) 
	  scale:scale
	  translation:(translation + aPoint)
! !

!WindowingTransformation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


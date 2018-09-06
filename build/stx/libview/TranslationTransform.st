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

DisplayTransform variableFloatSubclass:#TranslationTransform
	instanceVariableNames:'translation'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Transformations'
!

!TranslationTransform class methodsFor:'documentation'!

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

!TranslationTransform class methodsFor:'instance creation'!

identity
    "returns a windowing transformation with no scaling (1@1) 
     and no translation (0@0)."

    ^ self basicNew "/ scale:nil translation:nil 

    "
     WindowingTransformation identity
    "

    "Modified: 30.12.1996 / 16:59:27 / cg"
!

translation:aTranslation 
    "returns a windowing transformation with no scaling and a translation offset of aTranslation."

    ^ self basicNew translation:aTranslation

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
! !

!TranslationTransform methodsFor:'accessing'!

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

!TranslationTransform methodsFor:'applying transform'!

applyInverseTo:anObject 
    "Apply the inverse of the receiver to anObject
     and return the result. This can be used to map back from logical
     to physical coordinates, for example."

    translation isNil ifTrue:[
        ^ anObject
    ].
    ^ anObject translatedBy:(self inverseTranslation).
!

applyInverseToX:aNumber
    "Apply the receiver to a number representing an x-coordinate
     and return the result."

    |t|

    translation isNil ifTrue:[t := 0] ifFalse:[t := translation x].
    ^ (aNumber - t)
!

applyInverseToY:aNumber
    "Apply the receiver to a number representing an y-coordinate
     and return the result."

    |t|

    translation isNil ifTrue:[t := 0] ifFalse:[t := translation y].
    ^ (aNumber - t)
!

applyTo:anObject 
    "Apply the receiver to anObject and return the result."

    translation isNil ifTrue:[
        ^ anObject
    ].
    ^ anObject translatedBy:translation 
!

applyToX:aNumber
    "Apply the receiver to a number representing an x-coordinate
     and return the result."

    |t|

    translation isNil ifTrue:[t := 0] ifFalse:[t := translation x].
    ^ aNumber + t
!

applyToY:aNumber
    "Apply the receiver to a number representing an y-coordinate
     and return the result."

    |t|

    translation isNil ifTrue:[t := 0] ifFalse:[t := translation y].
    ^ aNumber + t
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
    aTransformation isNoScale ifTrue:[
        newScale := nil
    ] ifFalse:[
        newScale := aTransformationScale
    ].
    newTranslation := (translation ? 0) + aTransformation translation.

    ^ (self class) 
          scale:newScale
          translation:newTranslation
!

composedWithLocal: aTransformation
    ^ self compose:aTransformation
!

transformPoint:p 
    "Apply the receiver to a point, returning a new point."

    translation isNil ifTrue:[
        ^ p
    ].
    ^ p + translation
!

transformRectangle:aRectangle 
    "Apply the receiver to a rectangle, returning a new rectangle."

    translation isNil ifTrue:[
        ^ aRectangle.
    ].
    ^ aRectangle translatedBy:translation.
! !

!TranslationTransform methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream nextPutAll:self class name.
    aStream nextPutAll:' translation: '.
    translation printOn:aStream
! !

!TranslationTransform methodsFor:'private'!

inverseTranslation
    "return with a Point or Number representing the inverse of my translation."

    translation isNil ifTrue:[
        ^ nil.
    ].
    ^ translation negated.
! !

!TranslationTransform methodsFor:'testing'!

isIdentityTransformation
    "return true if this is an identity transformation;
     return false, otherwise."

    ^ translation isNil or:[translation x = 0 and:[translation y = 0]]
!

isNoScale
    "return true if the identity scale is in effect (i.e. saleFactor is 1);
     return false, otherwise."

    ^ true
! !

!TranslationTransform methodsFor:'transformations'!

scaleBy:aScale 
    "scale the receiver.
     This is a destructive operation, modifying the transformation
     represented by the receiver"

    self error:'not allowed'
!

scaledBy:aScale 
    "return a new WindowingTransformation with the scale and translation of 
     the receiver both scaled by aScale."

    ^ WindowingTransformation 
          scale:aScale
          translation:translation
!

translateBy:aTranslation 
    "translate the receiver.
     This is a destructive operation, modifying the transformation
     represented by the receiver"

    aTranslation isNil ifTrue:[^ self].

    translation isNil ifTrue:[
        translation := 0@0
    ].
    translation := translation + aTranslation asPoint
!

translatedBy:aPoint 
    "return a new WindowingTransformation with the same scale and 
     rotations as the receiver and with a translation of the current 
     translation plus aPoint."

    ^ (self class) 
          translation:(translation + aPoint)
! !

!TranslationTransform class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


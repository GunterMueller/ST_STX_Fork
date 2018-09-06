"{ Package: 'stx:libview3' }"

Morph subclass:#SketchMorph
	instanceVariableNames:'image imageHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Display Objects'
!


!SketchMorph methodsFor:'accessing'!

image
    ^ image 
!

image:something
    image ~= something ifTrue:[
        image := something.
        self invalidate.
    ].
!

imageHolder
    ^ imageHolder
!

imageHolder:something
    imageHolder removeDependent:self.
    imageHolder := something.
    imageHolder notNil ifTrue:[ imageHolder addDependent:self].
! !

!SketchMorph methodsFor:'drawing'!

displayInsideOn:aGC
    "/ intentionally left blank

    |img|

    img := imageHolder value ? image.
    img notNil ifTrue:[
        image displayOn:aGC at:self origin
    ] ifFalse:[
        frame isNil ifTrue:[ frame := 0@0 extent:self defaultExtent ].
        UISelectionPanel sketchImageIcon displayOn:aGC at:self origin
        "/ 'image' displayOn:aGC at:self origin + (0 @ aGC font height)
    ].
!

displayOutsideOn:aGC
    "/ intentionally left blank
! !

!SketchMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/SketchMorph.st,v 1.3 2009-06-10 20:39:30 cg Exp $'
! !

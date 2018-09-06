"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

LabelAndIcon subclass:#LabelAndTwoIcons
	instanceVariableNames:'image2'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!LabelAndTwoIcons class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    like a LabelAndIcon, but adds another image to the right of the string.

    Notice:
        This is different from ST-80's LabelAndIcon class, which
        inherits from Label. Therefore, things may change in the future.

    [author:]
        Claus Gittinger

    [see also:]
        ListEntry Text String Icon
        ListView SelectionInListView
"
!

examples
"
  in a button/label:
                                                                        [exBegin]
    |top l image|

    image := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/brazil.xpm'.
    l := (LabelAndTwoIcons icon:image string:'brazil').
    l image2:image.

    top := Button label:l.
    top open.
                                                                        [exEnd]
  two images in a button/label:
                                                                        [exBegin]
    |top l image1 image2|

    image1 := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/brazil.xpm'.
    image2 := Image fromFile:'../../goodies/bitmaps/xpmBitmaps/countries/germany.xpm'.
    l := (LabelAndIcon form:image1 image:image2 string:'directory').

    top := Button label:l.
    top open.
                                                                        [exEnd]
"
! !

!LabelAndTwoIcons methodsFor:'accessing'!

image2
    "return my second image (right of string)"

    ^ image2
!

image2:anImage
    "set the image2 (right of string)"

    image2 := anImage
! !

!LabelAndTwoIcons methodsFor:'displaying'!

displayOn:aGC x:x y:y opaque:opaque
    "display the receiver on a GC"

    |y1 x1 image2Value image2Height maxHeight asc|

    super displayOn:aGC x:x y:y opaque:opaque.

    image2Value := image2 value.
    image2Value notNil ifTrue:[
        asc  := aGC deviceFont ascent.
        image2Height  := image2Value notNil ifTrue:[image2Value height]  ifFalse:[0].
        maxHeight := self heightOn:aGC.
        x1 := x  + gap + (super widthOn:aGC).

        image2Value notNil ifTrue:[
            y1 := y - asc + (maxHeight - image2Height + 1 // 2).
            image2 := image2Value onDevice:aGC device.

            (opaque and:[image2Value mask isNil]) ifTrue:[aGC displayOpaqueForm:image2Value x:x1 y:y1]
                                                 ifFalse:[aGC displayForm:image2Value x:x1 y:y1].

        ].
    ]
! !

!LabelAndTwoIcons methodsFor:'queries'!

heightOn:aGC
    "return the height of the receiver, if it is to be displayed on aGC"

    |image2Height oneMillimeter|

    image2 notNil ifTrue:[
        oneMillimeter := aGC device isNil ifTrue:[2] ifFalse:[aGC verticalIntegerPixelPerMillimeter].
        image2Height := image2 value height + oneMillimeter
    ] ifFalse:[
        image2Height := 0   
    ].
    ^ (super heightOn:aGC) max: image2Height
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC"

    |width|

    width := super widthOn:aGC.
    image2 notNil ifTrue:[
        width := width + gap + image2 value width
    ].
    ^ width
! !

!LabelAndTwoIcons class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !


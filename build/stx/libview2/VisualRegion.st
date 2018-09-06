"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by Claus Gittinger
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

SimpleView subclass:#VisualRegion
	instanceVariableNames:'isElliptical isOpaque'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Special'
!

!VisualRegion class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
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
    VisualRegion is a passive visual component which provides a rectangular or elliptical
    shape. It can take an arbitrary border line thicknesses and can be defined as opaque
    with a background color or non opaque.

    Notice:
      This is an ST-80 compatibility class, provided to aid porting
      of ST-80 or VisualWorks code;
      it may be incomplete or incompatible to the corresponding ST-80 class. 
      If you encounter any incompatibilities, please forward a note 
      describing the incompatibility verbal (i.e. no code) to the ST/X team.
"
!

examples
"
    some regions; the blue one has its own cursor,
    the light-grey and red ones havea popupMenu,
    however, the red one is almost completely covered by an invisible inputView
    which provides its own menu (only the far left edge of the red region
    shows the red-menu)
                                                                                [exBegin]
        |top s1 s2 s3 s4 v1 rd i vh|

        top := StandardSystemView new extent:250@250.

        rd := true.

        v1 := View origin:25@25 extent:50@50 in:top.
        v1 viewBackground:(Color blue).
        v1 cursor:(Cursor thumbsUp).
        vh := ValueHolder new.
        vh onChangeSend:#value to:[ v1 viewBackground:vh value. v1 clear ].
        vh inspect.

        s1 := VisualRegion origin:10@10 extent:30@30 in:top.
        s1 lineWidth:0.
        s1 viewBackground:(Color gray:90).
        s1 isElliptical:rd.
        s1 middleButtonMenu:(PopUpMenu labels:#('foo' 'bar')).

        s2 := VisualRegion origin:60@10 extent:30@30 in:top.
        s2 viewBackground:(Color green).
        s2 lineWidth:1.
        s2 isElliptical:rd.

        s3 := VisualRegion origin:10@60 extent:100@30 in:top.
        s3 viewBackground:(Color gray:70).
        s3 lineWidth:0.
        s3 isOpaque:false.
        s3 isElliptical:rd.

        s4 := VisualRegion origin:60@60 extent:60@30 in:top.
        s4 viewBackground:(Color red).
        s4 lineWidth:3.
        s4 isOpaque:false.
        s4 isElliptical:rd.
        s4 middleButtonMenu:(PopUpMenu labels:#('foo1' 'bar1')).

        i := InputView origin:70@60 extent:60@30 in:top.
        i middleButtonMenu:(PopUpMenu labels:#('foo2' 'bar2')).

        top open
                                                                                [exEnd]
"
! !

!VisualRegion methodsFor:'accessing'!

isElliptical
    "get the outline of the region; elliptical or rectangle
    "
  ^ isElliptical

!

isElliptical:aBoolean
    "set the outline of the region; elliptical or rectangle
    "
    (isElliptical ~~ aBoolean) ifTrue:[
        isElliptical := aBoolean.
        self layoutChanged
    ].
!

isOpaque
    "return true, if the object fully covers its frame (i.e. is rectangular
     and has no 'holes'.
     Here, get the opaque mode concerning the inner background of the region"

    ^ isOpaque
!

isOpaque:aBoolean
    "set opaque mode concerning the inner background of the region
    "
    (isOpaque ~~ aBoolean) ifTrue:[
        isOpaque := aBoolean.
        self layoutChanged
    ].


!

lineWidth:aNumber
    "set the border drawing width in pixels"

    gc lineWidth ~~ aNumber ifTrue:[
        super lineWidth:aNumber.
        self layoutChanged
    ]
!

setLineWidth:aNumber
    "set the line drawing width in pixels without recomputation of the shape
    "
    super lineWidth:aNumber

! !

!VisualRegion methodsFor:'change & update'!

sizeChanged:how
    "must compute a new shape, when size is changed
    "
    self computeShape.
    super sizeChanged:how


! !

!VisualRegion methodsFor:'initialization'!

initialize
    "setup default configuration
    "
    super initialize.
    isElliptical := false.
    isOpaque     := true.
    self computeShape


! !

!VisualRegion methodsFor:'private'!

layoutChanged
    "recompute shape and change to invalidate
    "
    self computeShape.
    self invalidate 

    "Modified: / 6.6.1998 / 19:52:41 / cg"
! !

!VisualRegion methodsFor:'queries'!

specClass
    ^ RegionSpec


! !

!VisualRegion methodsFor:'shape computation'!

computeShape
    "computes 2 forms, one for the border, the other for the inside area. The border
     form is borderwidth*2 pixels larger. Each form gets filled with an ellipse of
     1-pixels, to define the shapes (take a look at the XShape spec, for more info)
    "
    isElliptical ifTrue:[
        self makeRoundViewShapeWithBorder:gc lineWidth opaque:isOpaque.
    ] ifFalse:[
        isOpaque ifFalse:[
            self makeTransparentRectangularViewShapeWithBorder:gc lineWidth
        ] ifTrue:[
            self borderShape:nil.
            self viewShape:nil.
            self borderWidth:gc lineWidth.
        ]
    ].

"/    |border shape extent form|
"/
"/    extent := self extent.
"/    border := Form extent:extent.
"/    shape  := Form extent:extent.
"/
"/    isElliptical ifTrue:[
"/        border fillArcX:0 y:0 
"/                  width:(border width)
"/                 height:(border height)
"/                   from:0
"/                  angle:360.
"/    ] ifFalse:[
"/        border fillRectangleX:0 y:0
"/                        width:(border width)
"/                       height:(border height)
"/    ].
"/
"/    isOpaque ifFalse:[
"/        form := border.
"/        border foreground:(Color colorId:0).
"/    ] ifTrue:[
"/        form := shape.
"/        shape foreground:(Color colorId:1).
"/    ].
"/
"/    isElliptical ifTrue:[
"/        form fillArcX:lineWidth y:lineWidth 
"/                width:(border  width) - (lineWidth * 2)
"/               height:(border height) - (lineWidth * 2)
"/                 from:0
"/                angle:360.
"/    ] ifFalse:[
"/        form fillRectangleX:lineWidth y:lineWidth
"/                      width:(border  width) - (lineWidth * 2)
"/                     height:(border height) - (lineWidth * 2).
"/    ].
"/    self borderShape:border.
"/    self viewShape:shape.

    "Modified: / 5.6.1999 / 21:28:54 / cg"
! !

!VisualRegion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/VisualRegion.st,v 1.11 2015-05-05 11:14:10 cg Exp $'
! !


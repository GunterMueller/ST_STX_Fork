"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

"{ NameSpace: Smalltalk }"

DrawRectangle subclass:#DrawImage
	instanceVariableNames:'originalImage scaledImage'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawImage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
   I represent images. I keep both the original image and a scaled version.
   I can rotate myself (in 90 degree steps) and reflect both horizontal and
   vertical; these operations are performed on the original image, and the
   scaled image (if any) is reconstructed after these operations. This avoids
   loss of information (i.e. after a shrink, a grow uses the full information
   avaliable). Also, dithering (if any) is redone each time, thus the image may
   look better after the next redraw, if more colors became available in the
   meantime.
   Deep images are alwaus drawn opaque in their original colors.
   Monochrome bitmaps are drawn foreground-on-background, or foreground only,
   if the fillpattern is nil. The pattern- and line-mask forms themselfes are
   ignored.
"
! !

!DrawImage class methodsFor:'instance creation'!

new
    |i|

    i := super new.
    i setOrigin:0@0.
    ^ i
! !

!DrawImage class methodsFor:'interface to DrawView'!

icon
    ^ Image fromFile:'DrawImage.xbm' resolution:100
!

userFriendlyName
    ^ 'image'

    "Created: 23.4.1997 / 12:01:55 / cg"
! !

!DrawImage methodsFor:'accessing'!

fillPattern
    "answer the fill pattern form, which is not really
     used, but needed to tell DrawView that images are filled
     objects"

    ^ Color black
!

foreground:aColor
    scaledImage := nil.
    super foreground:aColor
!

image:anImage
    |oldOrigin oldCorner map|

    oldOrigin := origin.
    oldCorner := corner.

    origin := 0@0.
    corner := anImage width @ anImage height.
    frame := origin corner:corner.
    originalImage := scaledImage := anImage.

    (oldOrigin notNil and:[oldCorner notNil]) ifTrue:[
	self origin:oldOrigin corner:oldCorner
    ].

    anImage depth == 1 ifTrue:[
	map := anImage colorMap.
	map notNil ifTrue:[
	    foreground := map at:2.
	    background := map at:1
	] ifFalse:[
	    foreground := Color black.
	    background := Color white.
	].
	fillPattern := Form black.
    ]
!

origin:newOrigin corner:newCorner
    "set new origin/corner; arguments given in pixels.
     This method is called both for moving and scaling,
     we have to check for a scale operation here."

    super origin:newOrigin corner:newCorner.
    scaledImage notNil ifTrue:[
        frame isNil ifTrue:[self computeBoundingBox].
        ((frame width ~= scaledImage width)
        or:[frame height ~= scaledImage height]) ifTrue:[
            scaledImage := nil
        ]
    ]

    "Modified: 4.6.1996 / 21:10:32 / cg"
!

setImage:anImage
   origin := 0@0.
   corner := anImage width @ anImage height.
   frame := origin corner:corner.
   originalImage := scaledImage := anImage
!

setOrigin:org
    origin := org
! !

!DrawImage methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |org|

    org := origin + anOffset.

    scaledImage isNil ifTrue:[
        originalImage isNil ifTrue:[
            aGC displayRectangle:self frame.
            ^ self
        ].
        aGC isView ifTrue:[
            aGC topView withWaitCursorDo:[
                self scaleImage.
            ]
        ] ifFalse:[
            self scaleImage
        ]
    ].

    "
     no need to get a device image, if transformation is
     in effect (because the scaledImage will not be used then)
    "
    aGC transformation isNil ifTrue:[
        scaledImage device ~~ aGC device ifTrue:[
            aGC isView ifTrue:[
                aGC topView withWaitCursorDo:[
                    scaledImage := scaledImage onDevice:aGC device.
                ]
            ] ifFalse:[
                scaledImage := scaledImage onDevice:aGC device.
            ]
        ]
    ].
    aGC paint:foreground on:background.
    aGC function:#copy.
    fillPattern isNil ifTrue:[
        aGC displayForm:scaledImage x:org x y:org y
    ] ifFalse:[
        aGC displayOpaqueForm:scaledImage x:(org x) y:(org y).
    ]
! !

!DrawImage methodsFor:'object manipulations'!

flipHorizontal
    originalImage flipHorizontal.
    scaledImage := nil
!

flipVertical
    originalImage flipVertical.
    scaledImage := nil
!

rotate:degrees
    |newImage oldOrigin "oldCorner" oldExtent|

    newImage := originalImage rotated:degrees.
    newImage notNil ifTrue:[
        oldOrigin := origin.
        oldExtent := corner - origin.
        self setImage:newImage.
        self origin:oldOrigin corner:(oldOrigin + (oldExtent y @ oldExtent x)).
        scaledImage := nil
    ]
! !

!DrawImage methodsFor:'private'!

scaleImage
    |"r" w h iw ih|

    w := frame width.
    h := frame height.
    iw := originalImage width.
    ih := originalImage height.
    ((w ~= iw) or:[h ~= ih]) ifTrue:[
        originalImage release.
        scaledImage := originalImage magnifiedBy:(w / iw) @ (h / ih)
    ] ifFalse:[
        scaledImage := originalImage
    ]
! !

!DrawImage methodsFor:'queries'!

isHitBy:aPoint withDelta:delta

    |org left right top bott px py d2|

    (delta == 0) ifTrue:[
	^ frame containsPoint:aPoint
    ].

    "its quicker to not create a new rectangle for the test"
    org := frame origin.
    left := org x - delta.

    px := aPoint x.
    (px < left) ifTrue:[^ false].

    d2 := delta * 2.
    right := left + frame width + d2.
    (px > right) ifTrue:[^ false].

    top := org y - delta.
    py := aPoint y.
    (py < top) ifTrue:[^ false].

    bott := top + frame height + d2.
    (py > bott) ifTrue:[^ false].

    ^ true
! !

!DrawImage methodsFor:'release'!

release
    scaledImage := nil.
    originalImage release
! !

!DrawImage methodsFor:'storing'!

storeInstvarsOn:aStream
    super storeInstvarsOn:aStream.
    aStream nextPutAll:'; image:('. originalImage storeOn:aStream.
    aStream nextPutAll:')'
!

storePatternsOn:aStream
    originalImage notNil ifTrue:[
        originalImage depth == 1 ifTrue:[
            super storePatternsOn:aStream
        ]
    ]

    "Created: 30.5.1996 / 16:23:29 / ca"
    "Modified: 30.5.1996 / 16:24:19 / ca"
! !

!DrawImage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawImage.st,v 1.17 2018-01-19 22:24:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawImage.st,v 1.17 2018-01-19 22:24:59 cg Exp $'
! !


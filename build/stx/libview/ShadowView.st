"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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

SimpleView subclass:#ShadowView
	instanceVariableNames:'myView shadowLength shadowClr imageUnderShadow'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Special'
!

!ShadowView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    ShadowView exists just to give PopUps and ModalBoxes a shadow. 

    If shadowClr is nil, the shadowView reads the screen-contents under 
    itself before realization, and uses a greyed version of these pixels
    for its background. If shadowClr is non-nil, that color is used
    as shadow (can be used for solid-black shadows).

    The instance variable myView is the view, for which the shadow is for.

    [author:]
        Claus Gittinger
"
! !

!ShadowView methodsFor:'accessing'!

for:aView
    "set the view I am a shadow for"

    myView := aView

    "Modified: 12.5.1996 / 21:59:17 / cg"
!

isPopUpView
    "return true, since I want to come up without decoration"

    ^ true

    "Modified: 12.5.1996 / 21:57:23 / cg"
!

shadowColor:aColor
    "set the shadow color"

    shadowClr := aColor

    "Modified: 12.5.1996 / 21:59:25 / cg"
! !

!ShadowView methodsFor:'event handling'!

redraw
    "if I have a shadowColor, fill all of myself with it;
     otherwise, draw the saved image under myself."

    |ws hs|

    ws := shadowLength x.
    hs := shadowLength y.
    shadowClr isNil ifTrue:[
        imageUnderShadow isNil ifTrue:[^ self].

        self copyFrom:imageUnderShadow x:(width - ws) y:0 
                                     toX:(width - ws) y:0 
                                   width:ws height:height.
        self copyFrom:imageUnderShadow x:0 y:(height - hs) 
                                     toX:0 y:(height - hs) 
                                   width:width height:hs.

    ] ifFalse:[
        gc paint:shadowClr.
        gc fillRectangleX:(width - ws) y:0 width:ws height:height
    ]

    "Modified: 12.5.1996 / 22:00:05 / cg"
! !

!ShadowView methodsFor:'initialization'!

create
    "enable saveUnder of the covered view(s).
     This may not be supported by all devices - these have to redraw then"

    super create.
    self backingStore:false.
    self saveUnder:true

    "Modified: 12.5.1996 / 22:00:47 / cg"
!

initialize
    super initialize.
    self borderWidth:0.

    shadowClr := StyleSheet at:#popUpShadowColor.

    "the length of the shadow from myView"
    shadowLength := device pixelPerMillimeter.
    "/ shadowLength := (device pixelPerMillimeter * 2.0) rounded.
!

realize
    "realize the shadowView some distance away from myView,
     get the pixels under the shadow from the screen"

    |root shW shH right bot kludge clr1 clr0 org blackIs0 img
     rS gS bS rM gM bM rSN gSN bSN pix r g b graphicsDevice|

    myView notNil ifTrue:[
        graphicsDevice := device.

        self origin:(myView origin + (myView borderWidth * 2) + shadowLength) 
             extent:(myView extent).

        shadowClr isNil ifTrue:[
            "
             get the pixels under the shadow 
             (copy from root-view into the 'imageUnderShadow'-form)
            "
            imageUnderShadow := Form width:width height:height depth:graphicsDevice depth onDevice:graphicsDevice.
            imageUnderShadow clippedByChildren:false.

            shW := shadowLength x.
            shH := shadowLength y.
            right := width - shW.
            bot := height - shH.

            root := graphicsDevice rootView.

            clr0 := Color colorId:0.
            clr1 := Color colorId:1.

            kludge := graphicsDevice depth == 1.
            blackIs0 := (graphicsDevice blackpixel == 0).
            (kludge and:[blackIs0]) ifTrue:[
                imageUnderShadow foreground:clr0 background:clr1.
            ].

            org := self origin.

            imageUnderShadow copyFrom:root x:(org x + right) y:org y 
                                         toX:right y:0 width:shW height:height.

            imageUnderShadow copyFrom:root x:org x y:(org y + bot) 
                                         toX:0 y:bot width:width height:shH.

            false "graphicsDevice visualType == #TrueColor" ifTrue:[
                "
                 grey out the image (by darkening the pixels)
                 (that's expensive ...)
                "
                
                img := Image fromForm:imageUnderShadow.

                rS := img redShiftForPixelValue.
                gS := img greenShiftForPixelValue.
                bS := img blueShiftForPixelValue.
                rSN := rS negated.
                gSN := gS negated.
                bSN := bS negated.
                rM := img redMaskForPixelValue.
                gM := img greenMaskForPixelValue.
                bM := img blueMaskForPixelValue.

                right to:right+shW-1 do:[:x |
                    0 to:height-1-shH do:[:y |
                        pix := img pixelAtX:x y:y.
                        r := (pix bitShift:rS) bitAnd:rM.       "/ img redBitsOf:pix.
                        g := (pix bitShift:gS) bitAnd:gM.       "/ img greenBitsOf:pix.
                        b := (pix bitShift:bS) bitAnd:bM.       "/ img blueBitsOf:pix.
                        r := (r * 0.7) rounded.
                        g := (g * 0.7) rounded.
                        b := (b * 0.7) rounded.
                        pix := ((r bitShift:rSN)         "/ pix := img valueFromRedBits:r greenBits:g blueBits:b.
                               bitOr:(g bitShift:gSN))
                               bitOr:(b bitShift:bSN).

                        img pixelAtX:x y:y put:pix.
                    ].
                ].
                bot to:bot+shH-1 do:[:y |
                    0 to:width-1 do:[:x |
                        pix := img pixelAtX:x y:y.
                        r := (pix bitShift:rS) bitAnd:rM.       "/ img redBitsOf:pix.
                        g := (pix bitShift:gS) bitAnd:gM.       "/ img greenBitsOf:pix.
                        b := (pix bitShift:bS) bitAnd:bM.       "/ img blueBitsOf:pix.
                        r := (r * 0.7) rounded.
                        g := (g * 0.7) rounded.
                        b := (b * 0.7) rounded.
                        pix := ((r bitShift:rSN)         "/ pix := img valueFromRedBits:r greenBits:g blueBits:b.
                               bitOr:(g bitShift:gSN))
                               bitOr:(b bitShift:bSN).
                        img pixelAtX:x y:y put:pix.
                    ].
                ].
                imageUnderShadow := img asFormOn:graphicsDevice.
            ] ifFalse:[
                "
                 grey out the image (by oring-in a grey pattern)
                 (sometimes we are lucky, and can do it with one raster-op)
                "

                (kludge and:[blackIs0]) ifFalse:[
                    imageUnderShadow foreground:clr0 background:(Color colorId:-1).
                    imageUnderShadow mask:(Form mediumGreyFormOn:graphicsDevice).
                    imageUnderShadow function:#and.
                    imageUnderShadow fillRectangleX:right y:0 width:shW height:height.
                    imageUnderShadow fillRectangleX:0 y:bot width:width height:shH.

                    blackIs0 ifFalse:[
                        imageUnderShadow foreground:self blackColor background:clr0.
                        imageUnderShadow function:#or.
                        imageUnderShadow fillRectangleX:right y:0 width:shW height:height.
                        imageUnderShadow fillRectangleX:0 y:bot width:width height:shH.
                    ]
                ] ifTrue:[
                    imageUnderShadow foreground:clr1 background:clr0.
                    imageUnderShadow mask:(Form mediumGreyFormOn:graphicsDevice).
                    imageUnderShadow function:#or.
                    imageUnderShadow fillRectangleX:right y:0 width:shW height:height.
                    imageUnderShadow fillRectangleX:0 y:bot width:width height:shH.
                ].
            ].
        ].
        super realize.
        self raise
    ]

    "Modified: 12.5.1997 / 21:38:04 / cg"
!

recreate
    "sent after a snapin or a migration, reinit for new device"

    shadowClr notNil ifTrue:[
        shadowClr := shadowClr onDevice:device
    ].

    "the length of the shadow from myView"
    shadowLength := device pixelPerMillimeter.

    super recreate.
    self backingStore:false.
    self saveUnder:true
!

unmap
    "unmap the view - the view stays created (but invisible), and can be remapped again later.
     relase the saved image of the covered view"

    imageUnderShadow := nil.
    super unmap.

    "Modified: 3.5.1996 / 23:45:23 / stefan"
    "Modified: 12.5.1996 / 22:01:17 / cg"
! !

!ShadowView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


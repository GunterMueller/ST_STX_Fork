HorizontalSlider subclass:#ColorSlider
	instanceVariableNames:'bgPattern colors labelString baseColor nColors inverse
		ditherImage'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!


!ColorSlider methodsFor:'accessing'!

baseColor
    ^ baseColor
!

color:aColor
    "set bg pattern based on aColor, smoothing from 0 to 100"

    baseColor ~= aColor ifTrue:[
        baseColor := aColor.
        aColor notNil ifTrue:[
            self getColors
        ].
        shown ifTrue:[
            self setBgPattern.
            self invalidate
        ]
    ].

    "Modified: 15.6.1996 / 10:22:43 / cg"
!

colors
    ^ colors
!

inverseColor:aColor
    "set bg pattern based on aColor, smoothing from 100 to 0"

    inverse := true.
    baseColor ~= aColor ifTrue:[
        baseColor := aColor.
        aColor notNil ifTrue:[
            self getColors
        ].
        shown ifTrue:[
            self setBgPattern.
            self invalidate
        ]
    ]

    "Modified: 15.6.1996 / 10:22:39 / cg"
!

label:aString
    labelString := aString.
    shown ifTrue:[
        self invalidate
    ]

    "Modified: 15.6.1996 / 10:22:33 / cg"
! !

!ColorSlider methodsFor:'drawing'!

drawThumbBackgroundInX:x y:y width:w height:h
    "draw part of the thumbs background; defined as a separate
     method, to allow drawing of arbitrary patterns under thumb."

    self clippingRectangle:(x@y extent:w@h).

    bgPattern isNil ifTrue:[
        self paint:Color black.
        self fillRectangleX:x y:y width:w height:h.
    ] ifFalse:[
        bgPattern depth == 1 ifTrue:[
            self paint:(bgPattern colorMap at:2) on:(bgPattern colorMap at:1).
            self displayOpaqueForm:bgPattern x:0 y:0.
        ] ifFalse:[
            self copyFrom:bgPattern
                        x:x y:y 
                      toX:x y:y
                    width:w height:h
        ]
    ].

    labelString notNil ifTrue:[
        inverse ifTrue:[
            self paint:Color white
        ] ifFalse:[
            self paint:Color black
        ].

        self displayString:labelString 
                         x:10 
                         y:(height // 2 + font ascent - (font height // 2)).
    ].

    self clippingRectangle:nil.

    "Modified: 15.6.1996 / 13:39:44 / cg"
! !

!ColorSlider methodsFor:'initialization'!

initialize
    super initialize.

    inset := 3.

    device visualType == #TrueColor ifTrue:[
        "/ can easily allocate lots of colors ...
        nColors := 256
    ] ifFalse:[
        nColors := 40.
    ].
    inverse := false.
    self is3D ifTrue:[
        level := -1
    ].
!

recreate
    super recreate.
    bgPattern := nil
!

sizeChanged:how
    |newColors|

    super sizeChanged:how.

    device visualType == #TrueColor ifTrue:[
        "/ can easily allocate lots of colors ...
        newColors := width min:100.
    ] ifFalse:[
        newColors := width // 10.
    ].
    newColors ~~ nColors ifTrue:[
        nColors := newColors.
        self getColors.
    ].
    bgPattern := ditherImage := nil.
    self setBgPattern

    "Modified: 15.6.1996 / 09:46:38 / cg"
! !

!ColorSlider methodsFor:'private'!

getColors
    |fr fg fb clr visual|

    ((visual := device visualType) ~~ #TrueColor
    and:[visual ~~ #StaticGray]) ifTrue:[
        colors := nil.
        ^ self
    ].

    colors := Array new:nColors.

    baseColor isNil ifTrue:[
        clr := Color white
    ] ifFalse:[
        clr := baseColor
    ].

    fr := clr red / (nColors - 1).
    fg := clr green / (nColors - 1).
    fb := clr blue / (nColors - 1).
    1 to:nColors do:[:i |
        |c|

        c := Color red:(fr * (i - 1))
                 green:(fg * (i - 1))
                  blue:(fb * (i - 1)).

        inverse ifTrue:[
            colors at:(nColors - i + 1) put:c
        ] ifFalse:[
            colors at:i put:c
        ]
    ].

    "Modified: 15.6.1996 / 09:04:04 / cg"
!

getDitherColors
    |clr0 clr ditherColors|

    clr0 := baseColor.
    clr0 isNil ifTrue:[
        clr0 := Color white
    ].

    ditherColors := Array new:4.
    (clr := clr0 exactOn:device) notNil ifTrue:[
        ditherColors at:4 put:clr.
        (clr := (Color red:(clr0 red * 0.67)
                     green:(clr0 green * 0.67)
                      blue:(clr0 blue * 0.67)) exactOn:device) notNil ifTrue:[
            ditherColors at:3 put:clr.
            (clr := (Color red:(clr0 red * 0.33)
                         green:(clr0 green * 0.33)
                          blue:(clr0 blue * 0.33)) exactOn:device) notNil ifTrue:[
                ditherColors at:2 put:clr.
                ditherColors at:1 put:Color black.
                ^ ditherColors
            ]
        ].
        ditherColors := nil.
    ].

    ^ Array with:Color black with:baseColor

    "Created: 15.6.1996 / 09:50:59 / cg"
    "Modified: 15.6.1996 / 10:20:50 / cg"
!

setBgPattern
    |n "{ Class: SmallInteger }"
     fract wFract
     x1 x2 visual img clr dImage ditherColors bits|

    "/ on palette systems, use a different algorithm, to avoid
    "/ using up too many colors ...

    ((visual := device visualType) ~~ #TrueColor
    and:[visual ~~ #StaticGray]) ifTrue:[
        n := nColors.

        ditherColors := self getDitherColors.
        (dImage := ditherImage) notNil ifTrue:[
            ditherColors size ~~ (1 bitShift:ditherImage depth) ifTrue:[
                ditherImage := nil
            ]
        ].

        ditherImage isNil ifTrue:[
            img := Image width:width height:height depth:24.
            img bits:(ByteArray new:width * height * 3).
            img photometric:#rgb; bitsPerSample:#(8 8 8); samplesPerPixel:3.

            "/ dither a full-color version picture 
            "/ of a black-to-white range into the D24 image.

            fract := 100.0 / (n-1).
            wFract := width asFloat / n.

            n to:1 by:-1 do:[:i |
                i == 1 ifTrue:[
                    x1 := 0.
                ] ifFalse:[
                    x1 := (wFract * (i - 1)) rounded.
                ].
                i == n ifTrue:[
                    x2 := width-1
                ] ifFalse:[
                    x2 := (wFract * i) rounded.
                ].

                clr := Color gray:(fract * (i-1)) rounded.
                img fillRectangleX:x1
                                 y:0
                             width:(x2 - x1 + 1)
                            height:height
                              with:clr.
            ].
            dImage := nil.
        ].

        "/ construct a small-depth image from it.

        ditherColors size == 4 ifTrue:[
            "/ do it with 4-color shades
            "/ i.e. get 33%, 67% and 100% colors,
            "/ create a dithered 2-plane image from it and use
            "/ that as bg-pattern

            dImage isNil ifTrue:[
                bits := img orderedDitheredBitsDepth:2.
                dImage := Depth2Image width:width
                                  height:height
                                  fromArray:bits.
                dImage photometric:#palette.
            ].
            dImage colorMap:ditherColors.
            bgPattern := dImage asFormOn:device.
            ditherImage := dImage.
            ^ self.
        ].

        "/ do it monochrome.
        "/ dither a monochrome version from it ...

        (dImage notNil and:[dImage depth ~~ 1]) ifTrue:[
            dImage := nil
        ].

        dImage isNil ifTrue:[
             dImage := img asOrderedDitheredMonochromeImage.
"/            dImage := img asFloydSteinbergDitheredMonochromeImage.
"/            dImage := img asBurkesDitheredMonochromeImage.
"/            dImage := img asStevensonArceDitheredMonochromeImage.
        ] ifFalse:[
            bgPattern notNil ifTrue:[
                bgPattern colorMap:ditherColors.
                ^ self
            ]
        ].

        dImage colorMap:(Array with:Color black with:Color white).
        dImage photometric:#palette.
        ditherImage := dImage.
        bgPattern := dImage asFormOn:device.
        bgPattern colorMap:ditherColors.
        ^ self.
    ].

    self setTrueBgPattern

    "Modified: 15.6.1996 / 13:43:00 / cg"
!

setTrueBgPattern
    |n x1 x2|

    n := colors size.
    n == 0 ifTrue:[
        "no colors - at least clear bgPattern"
        bgPattern := nil.
        ^ self
    ].

    bgPattern := Form width:width height:height depth:device depth.
    n to:1 by:-1 do:[:i |
        i == 1 ifTrue:[
            x1 := 0.
        ] ifFalse:[
            x1 := (width / n * (i - 1)) rounded.
        ].
        i == n ifTrue:[
            x2 := width
        ] ifFalse:[
            x2 := (width / n * i) rounded.
        ].
        bgPattern paint:(colors at:i).
        bgPattern fillRectangleX:x1
                               y:0
                           width:(x2 - x1 + 1)
                          height:height
    ].

    "Modified: 15.6.1996 / 10:18:09 / cg"
    "Created: 15.6.1996 / 12:18:23 / cg"
! !

!ColorSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/ColorSlider.st,v 1.7 1996-06-15 11:48:34 cg Exp $'
! !

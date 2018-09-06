"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

SequenceableCollection subclass:#Colormap
	instanceVariableNames:'redVector greenVector blueVector'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Support'
!

!Colormap class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Colormaps are used with images (and Forms) to keep the byte-to-color mapping.
    Externally, either colors or pixel values can be accessed.
    Internally, the values are stored as 3 separate byte-arrays
    (i.e. individual components can be 0..255).
    This was done to avoid overhead due to allocation of many color instances.

    Notice: Colormap is going to be obsoleted, and the functionality will
    move to subclasses (MappedPalette etc.)

    [author:]
        Claus Gittinger

    [see also:]
        Color Image Form
"
! !

!Colormap class methodsFor:'instance creation'!

fromColors:aColorArray
    "given a sequenceable collection of colors, return a new instance of myself.
     Obsolete: use #withColors: for VW compatibility."

    <resource: #obsolete>
    self obsoleteMethodWarning:'use #withColors:'.
    ^ self withColors:aColorArray

    "
     Colormap 
        fromColors:(Array with:Color black
                          with:Color red
                          with:Color white)
    "

    "Modified: 25.2.1997 / 19:00:31 / cg"
!

new:numColors
    "/ ^ self withColors:(Array new:numColors withAll:Color black)

    self == Colormap ifTrue:[
        "/ Colormap will be abstract in the near future
        self obsoleteFeatureWarning:'please change your code to use a concrete subclass of ColorPalette'.
    ].

    ^ self
        redVector:(ByteArray new:numColors withAll:0)
        greenVector:(ByteArray new:numColors withAll:0)
        blueVector:(ByteArray new:numColors withAll:0)

    "
     MappedPalette new:100
    "
!

redVector:rV greenVector:gV blueVector:bV
    "given vectors of red/green/and blue pixelValues,
     return a new instance of myself.
     The values must be in the range 0..255."

    self == Colormap ifTrue:[
        "/ Colormap will be abstract in the near future
        self obsoleteFeatureWarning:'please change your code to use a concrete subclass of ColorPalette'.
    ].
    ^ self new 
        redVector:rV 
        greenVector:gV 
        blueVector:bV

    "
     MappedPalette
        redVector:#[0 127 255]
        greenVector:#[0 127 255]
        blueVector:#[0 127 255]
    "

    "Modified: 23.4.1996 / 22:16:00 / cg"
!

rgbBytesVector:rgbVector
    "given a single vector containing r-g-b byte values,
     return a new instance of myself.
     The values must be in the range 0..255."

    |rV gV bV srcIndex nColors|

    nColors := rgbVector size // 3.
    rV := ByteArray new:nColors.
    gV := ByteArray new:nColors.
    bV := ByteArray new:nColors.

    srcIndex := 1.
    1 to:nColors do:[:dstIndex |
        |r g b|

        r := rgbVector at:srcIndex.
        g := rgbVector at:srcIndex+1.
        b := rgbVector at:srcIndex+2.

        rV at:dstIndex put:r.
        gV at:dstIndex put:g.
        bV at:dstIndex put:b.
        srcIndex := srcIndex + 3.
    ].

    ^ self 
        redVector:rV 
        greenVector:gV 
        blueVector:bV

    "
     |map|

     map := Colormap rgbBytesVector:#[0 0 0 127 127 127 255 0 0 255 255 255].
     map atPixelValue:2    
    "
!

rgbValueVector:rgbValueVector
    "given a single vector containing r-g-b pixel-values,
     return a new instance of myself.
     The values must be of the rgb-form i.e. 16rRRGGBB"

    |rV gV bV nColors|

    nColors := rgbValueVector size.
    rV := ByteArray new:nColors.
    gV := ByteArray new:nColors.
    bV := ByteArray new:nColors.

    1 to:nColors do:[:index |
        |rgb r g b|

        rgb := rgbValueVector at:index.
        r := (rgb bitShift:-16) bitAnd:16rFF.
        g := (rgb bitShift:-8) bitAnd:16rFF.
        b := rgb bitAnd:16rFF.

        rV at:index put:r.
        gV at:index put:g.
        bV at:index put:b.
    ].

    ^ self 
        redVector:rV 
        greenVector:gV 
        blueVector:bV

    "
     |map|

     map := Colormap rgbValueVector:#(16r000000 16r7F7F7F 16r800000 16rFFFFFF).
     map atPixelValue:2    
    "
!

withColors:aColorArray
    "given a sequenceable collection of colors, return a new instance
     of myself. Renamed from #fromColors: for ST-80 compatibility."

    self == Colormap ifTrue:[
        "/ Colormap will be abstract in the near future
        self obsoleteFeatureWarning:'please change your code to use a concrete subclass of ColorPalette'.
    ].
    ^ self new colors:aColorArray

    "
     MappedPalette
        withColors:(Array with:Color black
                          with:Color red
                          with:Color white)
    "

    "Created: 25.2.1997 / 18:59:09 / cg"
    "Modified: 25.2.1997 / 19:03:08 / cg"
! !

!Colormap methodsFor:'accessing'!

at:index 
    "return the color for a index. 
     Notice that the index range is 1...nColors"

    |r g b idx "{ Class: SmallInteger }" |

    idx := index.
    r := self redByteAt:idx.
    g := self greenByteAt:idx.
    b := self blueByteAt:idx.

    ^ Color redByte:r greenByte:g blueByte:b

    "Created: 2.5.1996 / 12:21:40 / cg"
    "Modified: 8.6.1996 / 14:25:30 / cg"
!

at:index put:aColor
    "set the color for a index. Return aColor (sigh).
     Notice that the index range is 1..."

    |r g b idx "{ Class: SmallInteger }" |

    r := (aColor red * 255 / 100) rounded.
    g := (aColor green * 255 / 100) rounded.
    b := (aColor blue * 255 / 100) rounded.

    idx := index.
    self redByteAt:idx put:(r max:0).
    self greenByteAt:idx put:(g max:0).
    self blueByteAt:idx put:(b max:0).
    ^ aColor

    "Modified: / 22-07-2007 / 15:28:32 / cg"
!

at:index putRGB:rgbValue
    "set the color for an index, given rrggbb as an integer (8bits each, red in high bits).
     Notice that the index range is 1..."

    |r g b idx "{ Class: SmallInteger }" |

    r := (rgbValue bitShift:-16) bitAnd:16rFF.
    g := (rgbValue bitShift:-8) bitAnd:16rFF.
    b := rgbValue bitAnd:16rFF.

    idx := index.
    self redByteAt:idx put:r.
    self greenByteAt:idx put:g.
    self blueByteAt:idx put:b.
!

at:index putRGBTriple:aTriple
    "set the color for an index from an rgb triple.
     The components are r,g,b; each 0..1.
     Notice that the index range is 1..."

    |r g b idx "{ Class: SmallInteger }" |

    r := ((aTriple at:1) * 255) rounded.
    g := ((aTriple at:2) * 255) rounded.
    b := ((aTriple at:3) * 255) rounded.

    idx := index.
    self redByteAt:idx put:(r max:0).
    self greenByteAt:idx put:(g max:0).
    self blueByteAt:idx put:(b max:0).
!

atPixelValue:pixelValue 
    "return the color for a pixelValue. 
     Notice that pixelValue range is 0...nColors-1"

    ^ self at:(pixelValue + 1)
!

blueAt:index
    "return the blue component for some index.
     The returned value is scaled from the internal 0.. 255 to
     a percentage value 0..100.
     Notice that index range is 1..."

    ^ (self blueByteAt:index) * 100 / 255

    "Modified: 2.5.1996 / 17:29:17 / cg"
!

colors
    "ST-80 compatibility: return a collection containing the colors I hold"

    ^ self asArray
!

colors:aCollectionOfColors
    "setup the receiver from colors given in a sequenceable collection of colors"

    |sz "{Class: SmallInteger }"|

    sz := aCollectionOfColors size.
    redVector := ByteArray new:sz.
    greenVector := ByteArray new:sz.
    blueVector := ByteArray new:sz.

    1 to:sz do:[:i |
        |clr|

        clr := aCollectionOfColors at:i.
        clr notNil ifTrue:[
            redVector at:i put:(clr redByte).
            greenVector at:i put:(clr greenByte).
            blueVector at:i put:(clr blueByte).
        ]
    ].

    "Modified: 25.2.1997 / 19:02:47 / cg"
!

greenAt:index
    "return the green component for some index.
     The returned value is scaled from the internal 0.. 255 to
     a percentage value 0..100.
     Notice that index range is 1..."

    ^ (self greenByteAt:index) * 100 / 255

    "Modified: 2.5.1996 / 17:29:36 / cg"
!

redAt:index
    "return the red component for some index.
     The returned value is scaled from the internal 0.. 255 to
     a percentage value 0..100.
     Notice that index range is 1..."

    ^ (self redByteAt:index) * 100 / 255

    "Modified: 2.5.1996 / 17:29:44 / cg"
! !

!Colormap methodsFor:'accessing-internals'!

blueByteAt:index
    "return the blueByte component for some index.
     The returned value is from the internal 0.. 255"

    ^ (blueVector at:index)
!

blueByteAt:index put:anInteger
    "change the internal blueByte component for some index.
     The argument, anInteger should be from the internal 0.. 255.
     Notice that index range is 1..."

    ^ blueVector at:index put:anInteger
!

blueVector
    "return the blueVector"

    ^ blueVector

    "Modified: 2.5.1996 / 12:44:17 / cg"
!

blueVector:something
    "set blueVector"

    blueVector := something.
!

greenByteAt:index
    "return the greenByte component for some index.
     The returned value is from the internal 0.. 255"

    ^ (greenVector at:index)
!

greenByteAt:index put:anInteger
    "change the internal greenByte component for some index.
     The argument, anInteger should be from the internal 0.. 255.
     Notice that index range is 1..."

    ^ greenVector at:index put:anInteger
!

greenVector
    "return greenVector"

    ^ greenVector
!

greenVector:something
    "set greenVector"

    greenVector := something.
!

redByteAt:index
    "return the redByte component for some index.
     The returned value is from the internal 0.. 255"

    ^ (redVector at:index)
!

redByteAt:index put:anInteger
    "change the internal redByte component for some index.
     The argument, anInteger should be from the internal 0.. 255.
     Notice that index range is 1..."

    ^ redVector at:index put:anInteger
!

redVector
    "return redVector"

    ^ redVector
!

redVector:something
    "set redVector"

    redVector := something.
!

redVector:r greenVector:g blueVector:b
    "set the red, green and blueVectors"

    redVector := r.
    greenVector := g.
    blueVector := b.

    "Modified: 23.4.1996 / 22:13:31 / cg"
! !

!Colormap methodsFor:'converting'!

asArray
    "return the receiver as an array containing my colors"

    |r g b n "{ Class: SmallInteger }" 
     scale array|

    n := self size.
    array := Array new:n.
    scale := Color scalingValue / 255.0.

    1 to:n do:[:idx |
        r := self redByteAt:idx.
        g := self greenByteAt:idx.
        b := self blueByteAt:idx.

        array at:idx put:(Color
                            scaledRed:(r * scale) rounded
                            scaledGreen:(g * scale) rounded
                            scaledBlue:(b * scale) rounded)
    ].
    ^ array

    "Created: 11.7.1996 / 20:19:45 / cg"
    "Modified: 11.7.1996 / 21:34:16 / cg"
! !

!Colormap methodsFor:'copying'!

copyFrom:start to:stop
    ^ self class 
        redVector:(redVector copyFrom:start to:stop)
        greenVector:(greenVector copyFrom:start to:stop)
        blueVector:(blueVector copyFrom:start to:stop)
!

postCopy
    redVector := redVector copy.
    greenVector := greenVector copy.
    blueVector := blueVector copy.

    "Created: 5.7.1996 / 14:52:15 / cg"
! !

!Colormap methodsFor:'misc'!

grow:howBig
    "change the receiver's size"

    |t|

    howBig == self size ifTrue:[^ self].
    redVector isNil ifTrue:[
        redVector := ByteArray new:howBig.
        greenVector := ByteArray new:howBig.
        blueVector := ByteArray new:howBig.
        ^ self
    ].
    t := redVector. redVector := ByteArray new:howBig. redVector replaceFrom:1 to:t size with:t startingAt:1.
    t := greenVector. greenVector := ByteArray new:howBig. greenVector replaceFrom:1 to:t size with:t startingAt:1.
    t := blueVector. blueVector := ByteArray new:howBig. blueVector replaceFrom:1 to:t size with:t startingAt:1.
    ^ self
!

scaleValuesBy:scaleFactor
    "multiply all values by scaleFactor; finally round to integer.
     This can be used to brighten/darken an images colormap"

    |sz "{ Class: SmallInteger }" |

    sz := redVector size.
    1 to:sz do:[:index |
        redVector at:index put:((redVector at:index) * scaleFactor) rounded.
        greenVector at:index put:((greenVector at:index) * scaleFactor) rounded.
        blueVector at:index put:((blueVector at:index) * scaleFactor) rounded.
    ]

    "Modified: 2.5.1996 / 12:46:07 / cg"
! !

!Colormap methodsFor:'printing & storing'!

storeOn:aStream
    "append a representation to aStream, from which the receiver
     can be reconstructed"

    aStream nextPutAll:'(' , self class name ,' redVector:'.
    redVector storeOn:aStream.
    aStream nextPutAll:' greenVector:'.
    greenVector storeOn:aStream.
    aStream nextPutAll:' blueVector:'.
    blueVector storeOn:aStream.
    aStream nextPutAll:')'

    "Created: 30.5.1996 / 16:28:27 / ca"
    "Modified: 30.5.1996 / 16:32:44 / ca"
! !

!Colormap methodsFor:'queries'!

colorNearestTo:aColor
    "a very questionable algorithm;
     basing the distance on rgb values is very bad - better
     do a distance in a cie color cone"

    |minDelta nearest|

    nearest := self at:1.
    minDelta := aColor deltaFrom:nearest.
    2 to:self size do:[:idx |
        |delta clr|

        clr := self at:idx.
        delta := aColor deltaFrom:clr.
        delta < minDelta ifTrue:[
            minDelta := delta.
            nearest := clr
        ]
    ].
    ^ nearest.
!

indexOfColor: aColor
    1 to:self size do:[:idx |
        (self at:idx) = aColor ifTrue:[^ idx].
    ].
    ^ 0

    "Created: / 05-11-2013 / 12:23:28 / cg"
!

indexOfPaintNearest: color
    |minDistance minIndex dist
     sz "{ Class: SmallInteger }"|

    minDistance := (self at:1) deltaFrom:color.
    minIndex := 1.
    sz := self size.
    2 to:sz do:[:idx |
        dist := (self at:idx) deltaFrom:color.
        dist < minDistance ifTrue:[
            minDistance := dist.
            minIndex := idx.
        ]
    ].
    ^ minIndex

    "Created: 6.3.1997 / 15:45:39 / cg"
!

isFixedPalette
    ^ false
!

isGreyscaleColormap
    "return true, if the receiver is actually a greymap.
     Could be used to convert images as read from imageFiles
     (for example, GIF-files) automatically to greyScale (which is not yet done)."

    |sz "{ Class: SmallInteger }"
     redVal|

    sz := self size.

    1 to:sz do:[:i |
        redVal := self redByteAt:i.
        redVal ~~ (self greenByteAt:i) ifTrue:[^ false].
        redVal ~~ (self blueByteAt:i) ifTrue:[^ false].
    ].
    ^ true
!

size
    "return the number of colors in the receiver"

    ^ redVector size

    "Modified: 23.4.1996 / 22:13:43 / cg"
! !

!Colormap methodsFor:'testing'!

isColormap
    ^ true
! !

!Colormap class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


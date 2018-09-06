"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2018 Patrik Svestka
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

Image subclass:#Depth8Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth8Image class methodsFor:'documentation'!

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
    this class represents 256-color (8 bit / pixel) images (palette, greyscale ...).
    It mainly consists of methods already implemented in Image,
    reimplemented here for more performance.

    [author:]
	Claus Gittinger

    [see also:]
	Depth1Image Depth2Image Depth4Image Depth16Image Depth24Image
	ImageReader
"
! !

!Depth8Image class methodsFor:'queries'!

defaultPhotometric
    "return the default photometric pixel interpretation.
     This may be a somewhat old leftover from times, when tiff was the first image file type to be read.
     Much better would be to always have some (possibly fake and virtual) colormap around, and ask that one.
     However, in the meantime, many other classes depend on that, so that it should be kept as an API 
     - even when the internal representation will be replaced by something better in the future."

    ^ #palette
!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 8"

    ^ 8

    "Modified: 20.4.1996 / 23:40:22 / cg"
! !

!Depth8Image methodsFor:'accessing-pixels'!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixelValue.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |index "{ Class: SmallInteger }"|

%{  /* NOCONTEXT */

    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__isByteArrayLike(b)
     && __bothSmallInteger(x, y)
     && __isSmallInteger(w)
     && (__INST(pixelFunction)==nil) ) {
        int _idx, _pix;

        _idx = (__intVal(w) * __intVal(y)) + __intVal(x);
        if ((unsigned)_idx < __byteArraySize(b)) {
            _pix = __ByteArrayInstPtr(b)->ba_element[_idx];
            RETURN( __MKSMALLINT(_pix) );
        }
    }
%}.
    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    "/ the code below is only evaluated if the bytes-collection is
    "/ not a ByteArray, or the arguments are not integers

    index := (width * y) + 1 + x.
    ^ bytes at:index.
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |index "{ Class: SmallInteger }"|

%{  /* NOCONTEXT */

    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__isByteArrayLike(b)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(w, aPixelValue) ) {
        int _idx;

        _idx = (__intVal(w) * __intVal(y)) + __intVal(x);
        if ((unsigned)_idx < __byteArraySize(b)) {
            __ByteArrayInstPtr(b)->ba_element[_idx] = __intVal(aPixelValue);
            RETURN( self );
        }
    }
%}.
    "fall back code for nonByteArray or nonInteger arguments"

    index := (width * y) + 1 + x.
    bytes at:index put:aPixelValue.
!

rowAt:y into:aPixelBuffer startingAt:startIndex
    "fill aPixelBuffer with pixel values from a single row.
     Notice: row/column coordinates start at 0."

    |srcIdx endIndex n|

    bytes notNil ifTrue:[
        srcIdx := (y * width) + 1.
        n := width.

        endIndex := srcIdx+width-1.
        endIndex > bytes size ifTrue:[
            self assert:(bytes size >= endIndex).
            endIndex := bytes size.
            n := endIndex - srcIdx + 1.
        ].

        aPixelBuffer replaceFrom:startIndex to:startIndex+n-1 with:bytes startingAt:srcIdx.
        ^ self.
    ].
    ^ super rowAt:y into:aPixelBuffer startingAt:startIndex

    "Modified: / 16-02-2012 / 15:58:01 / cg"
!

rowAt:y putAll:pixelArray startingAt:startIndex
    "store a single row's bits from bits in the pixelArray argument;
     Notice: row/column coordinates start at 0."

    |dstIdx|

    dstIdx := (y * width) + 1.
    self bits replaceFrom:dstIdx to:dstIdx+width-1 with:pixelArray startingAt:startIndex.
    ^ pixelArray

    "Created: 24.4.1997 / 15:49:42 / cg"
! !

!Depth8Image methodsFor:'converting'!

fromImage:anImage
    "setup the receiver from another image.
     The code here is tuned for depth 1, 2 and 4 source images;
     other conversions are done in the superclasses fallBack method."

    |srcBytesPerRow "{ Class: SmallInteger }"
     srcIdx "{ Class: SmallInteger }"
     dstIdx "{ Class: SmallInteger }"
     w      "{ Class: SmallInteger }"
     h      "{ Class: SmallInteger }"
     srcBuffer dstBuffer srcBytes
     srcDepth map bytes|

    srcDepth := anImage depth.
    (#[1 2 4] includes:srcDepth) ifFalse:[
        ^ super fromImage:anImage
    ].

    width := w := anImage width.
    height := h := anImage height.
    bytes := ByteArray uninitializedNew:(w * h).
    bitsPerSample := self bitsPerSample.
    samplesPerPixel := self samplesPerPixel.
    self colormapFromImage:anImage.

    colorMap isNil ifTrue:[
        "/ if source has no colorMap, more work is needed ...
        map := #(
                #[0 16rFF]
                #[0 16r55 16rAA 16rFF]
                nil
                #[16r00 16r11 16r22 16r33 16r44 16r55 16r66 16r77
                  16r88 16r99 16rAA 16rBB 16rCC 16rDD 16rEE 16rFF]
               ) at:srcDepth.
    ].

    self mask:anImage mask.

    "/ only expand & translate pixels

    srcBytes := anImage bits.
    srcBytesPerRow := anImage bytesPerRow.
    srcBuffer := ByteArray new:srcBytesPerRow.

    dstBuffer := ByteArray new:w.
    srcIdx := 1.
    dstIdx := 1.
    bytes := self bits.
    bytes isNil ifTrue:[
        self bits:(bytes := ByteArray new:(self bytesPerRow * self height)).
    ].
    1 to:h do:[:hi |
        srcBuffer replaceFrom:1 to:srcBytesPerRow with:srcBytes startingAt:srcIdx.
        srcBuffer expandPixels:srcDepth width:w height:1 into:dstBuffer mapping:map.
        bytes replaceFrom:dstIdx to:dstIdx+w-1 with:dstBuffer startingAt:1.
        dstIdx := dstIdx + w.
        srcIdx := srcIdx + srcBytesPerRow.
    ]

    "
     |i1 i2 i4 i8 i16 i24|

     i1 := Image fromFile:'bitmaps/SBrowser.xbm'.
     i2 := Depth2Image fromImage:i1.
     i4 := Depth4Image fromImage:i1.

     i8 := Depth8Image fromImage:i1.
     i8 inspect.
     i8 := Depth8Image fromImage:i2.
     i8 inspect.
     i8 := Depth8Image fromImage:i4.
     i8 inspect.
    "

    "Modified: / 24-04-1997 / 14:01:14 / cg"
    "Modified: / 30-01-2017 / 19:33:25 / stefan"
! !

!Depth8Image methodsFor:'converting images'!

anyImageAsPseudoFormOn:aDevice
    "return a pseudoForm from the palette picture.
     The main work is in color reduction, when not all colors can be acquired.
     This method works for any photometric."

    |bytes pseudoBits f gcRound has8BitImage deviceDepth
     imgMap newImage pixelRow dColors
     usedColors usageCounts maxIndex map
     fit scale lastOK error
     div
     bitsPerRGB "{Class: SmallInteger }"
     shift      "{Class: SmallInteger }"
     m          "{Class: SmallInteger }"
     mapSize    "{Class: SmallInteger }"
     cube nR nG nB ditherColors clr|

    (cube := aDevice fixColors) notNil ifTrue:[
        nR := aDevice numFixRed.
        nG := aDevice numFixGreen.
        nB := aDevice numFixBlue.

        DitherAlgorithm == #floydSteinberg ifTrue:[
            f := self
                   asFloydSteinbergDitheredDepth8FormOn:aDevice
                   colors:cube
                   nRed:nR
                   nGreen:nG
                   nBlue:nB.
        ] ifFalse:[
            f := self
                   asNearestPaintDepth8FormOn:aDevice
                   colors:cube
                   nRed:nR
                   nGreen:nG
                   nBlue:nB.
        ].
        f notNil ifTrue:[^ f].
    ].

    "find used colors"
    bytes := self bits.
    usedColors := bytes usedValues.    "gets us an array filled with used values"
                                       "(could use bytes asBag)"
    maxIndex := usedColors max + 1.

    usedColors size > 20 ifTrue:[
        ('Depth8Image [info]: allocating ' , usedColors size printString , ' colors ...') infoPrintCR.
    ].

    "sort by usage"
    usageCounts := bytes usageCounts.
    usageCounts := (usedColors collect:[:clr | usageCounts at:(clr + 1)]) asArray.
    usageCounts sort:[:a :b | a > b] with:usedColors.

    "allocate the colors (in order of usage count)"

    imgMap := Array new:maxIndex.

    "
     first, try to get the exact colors ...
    "
    bitsPerRGB := aDevice bitsPerRGB.
    shift := (8 - bitsPerRGB) negated.
    m := (1 bitShift:bitsPerRGB) - 1.
    div := m asFloat.

    fit := true.
    scale := 100.0 / div.       "to scale 0..255 into 0.0 .. 100.0"
    lastOK := 0.
    gcRound := 0.

    usedColors do:[:aColorIndex |
        |devColor color
         mapIndex "{Class: SmallInteger }"|

        fit ifTrue:[
            mapIndex := aColorIndex + 1.
            "/ color := colorMap at:mapIndex.

            color := self colorFromValue:aColorIndex.
            (color isOnDevice:aDevice) ifTrue:[
                "wow - an immediate hit"
                devColor := color
            ] ifFalse:[
                devColor := color exactOn:aDevice.
                devColor isNil ifTrue:[
                    "
                     could not allocate color - on the first round, do a GC to flush
                     unused colors - this may help if some colors where locked by
                     already free images.
                    "
                    gcRound == 0 ifTrue:[
                        ObjectMemory scavenge; finalize.
                        devColor := color exactOn:aDevice.
                        gcRound := 1
                    ].
                    devColor isNil ifTrue:[
                        gcRound == 1 ifTrue:[
                            CollectGarbageWhenRunningOutOfColors ifTrue:[
                                'Depth8Image [info]: force GC for possible color reclamation.' infoPrintCR.
                                ObjectMemory incrementalGC; finalize.
                                devColor := color exactOn:aDevice.
                            ].
                            gcRound := 2
                        ]
                    ]
                ].
            ].
            (devColor notNil and:[devColor colorId notNil]) ifTrue:[
                imgMap at:mapIndex put:devColor.
                lastOK := lastOK + 1.
            ] ifFalse:[
                fit := false
            ]
        ]
    ].

    fit ifFalse:[
        ('Depth8Image [info]: got %1 exact colors (out of %2)' bindWith:lastOK with:usedColors size) infoPrintCR.

        DitherAlgorithm == #floydSteinberg ifTrue:[
            dColors := imgMap collect:[:clr | clr isNil ifTrue:[clr]
                                                        ifFalse:[clr nearestOn:aDevice]].
            dColors := dColors select:[:clr | clr notNil] thenCollect:[:clr | clr exactOn:aDevice].
            dColors := dColors asSet.
            dColors addAll:(aDevice colorMap collect:[:c|c onDevice:aDevice] thenSelect:[:c | c colorId notNil]).
            ditherColors := aDevice availableDitherColors.
            ditherColors notNil ifTrue:[
                dColors addAll:ditherColors.
            ].
            dColors := dColors asArray.
            dColors size > 256 ifTrue:[
                dColors := dColors copyTo:256
            ].
            ^ self asFloydSteinbergDitheredPseudoFormUsing:dColors on:aDevice
        ].

        "
         again, this time allow wrong colors (loop while increasing allowed error)
        "
        error := 1.
        [fit] whileFalse:[
            fit := true.
            usedColors from:(lastOK+1) to:(usedColors size) do:[:aColorIndex |
                |devColor color
                 r        "{Class: SmallInteger }"
                 g        "{Class: SmallInteger }"
                 b        "{Class: SmallInteger }"
                 mapIndex "{Class: SmallInteger }"
                 rMask    "{Class: SmallInteger }"
                 gMask    "{Class: SmallInteger }"
                 bMask    "{Class: SmallInteger }"|

                fit ifTrue:[
                    gMask := bMask := rMask := m.

                    mapIndex := aColorIndex + 1.
                    "/ color := colorMap at:mapIndex.
                    color := self colorFromValue:aColorIndex.
                    r := (color red * 255 / 100.0) rounded.
                    g := (color green * 255 / 100.0) rounded.
                    b := (color blue * 255 / 100.0) rounded.

                    color := Color red:((r bitShift:shift) bitAnd:rMask) * scale
                                 green:((g bitShift:shift) bitAnd:gMask) * scale
                                  blue:((b bitShift:shift) bitAnd:bMask) * scale.

                    (color isOnDevice:aDevice) ifTrue:[
                        "wow - an immediate hit"
                        devColor := color.
                    ] ifFalse:[
                        devColor := color nearestOn:aDevice.
                        (devColor notNil and:[(devColor deltaFrom:color) > error]) ifTrue:[
                            devColor := nil
                        ].
                        devColor isNil ifTrue:[
                            "
                             no free color - on the first round, do a GC to flush unused
                             colors - this may help if some colors where locked by already
                             free images.
                            "
                            gcRound == 0 ifTrue:[
                                ObjectMemory scavenge; finalize.
                                devColor := color nearestOn:aDevice.
                                (devColor notNil and:[(devColor deltaFrom:color) > error]) ifTrue:[
                                    devColor := nil
                                ].
                                gcRound := 1
                            ].
                            devColor isNil ifTrue:[
                                gcRound == 1 ifTrue:[
                                    CollectGarbageWhenRunningOutOfColors ifTrue:[
                                        'Depth8Image [info]: force GC for possible color reclamation.' infoPrintCR.
                                        ObjectMemory incrementalGC; finalize.
                                        devColor := color nearestOn:aDevice.
                                        (devColor notNil and:[(devColor deltaFrom:color) > error]) ifTrue:[
                                            devColor := nil
                                        ].
                                    ].
                                    gcRound := 2
                                ]
                            ]
                        ].
                    ].
                    (devColor notNil and:[devColor colorId notNil]) ifTrue:[
                        imgMap at:mapIndex put:devColor.
                        lastOK := lastOK + 1.
                    ] ifFalse:[
                        fit := false
                    ]
                ].
            ].

            fit ifTrue:[
                ('Depth8Image [info]: remaining colors with error <= %1' bindWith:error) infoPrintCR.
            ].

            error := error * 2.
            error > 100 ifTrue:[
                "
                 break out, if the error becomes too big.
                "
                'Depth8Image [info]: hard color allocation problem - revert to b&w for remaining colors' infoPrintCR.
                "
                 map to b&w as a last fallback.
                 (should really do a dither here)
                "
                usedColors from:(lastOK+1) to:(usedColors size) do:[:aColorIndex |
                    |color
                     mapIndex "{ Class: SmallInteger }"|

                    mapIndex := aColorIndex + 1.
                    "/ color := colorMap at:mapIndex.
                    color := self colorFromValue:aColorIndex.
                    color brightness > 0.4 ifTrue:[
                        color := aDevice whiteColor.
                    ] ifFalse:[
                        color := aDevice blackColor.
                    ].
                    imgMap at:mapIndex put:(color onDevice:aDevice).
                ].
                fit := true.
            ]
        ].

        error > 10 ifTrue:[
            'Depth8Image [info]: not enough colors for a reasonable image' infoPrintCR
        ] ifFalse:[
            'Depth8Image [info]: not enough colors for exact picture' infoPrintCR.
        ]
    ].

    "
     create translation map (from image colors to allocated colorIds)
    "
    mapSize := imgMap size.
    map := ByteArray new:256.
    1 to:mapSize do:[:i |
        (clr := imgMap at:i) notNil ifTrue:[
            map at:i put:clr colorId
        ]
    ].

    "
     does the device support 8-bit images ?
    "
    deviceDepth := aDevice depth.
    has8BitImage := (deviceDepth == 8)
                    or:[ (aDevice supportedImageFormatForDepth:8) notNil ].

    "
     finally, create a form on the device and copy (& translate)
     the pixel values
    "
    has8BitImage ifTrue:[
        pseudoBits := ByteArray uninitializedNew:(width * height).

        bytes
            expandPixels:8         "xlate only"
            width:width height:height
            into:pseudoBits
            mapping:map.

        map := nil.

        f := Form imageForm width:width height:height depth:deviceDepth onDevice:aDevice.
        f isNil ifTrue:[^ nil].
        f colorMap:imgMap.
        aDevice
            drawBits:pseudoBits
            bitsPerPixel:8
            depth:deviceDepth
            padding:8
            width:width height:height
            x:0 y:0
            into:(f id) x:0 y:0
            width:width height:height
            with:(f initGC).
        ^ f
    ].

    "
     slow fall back: convert into appropriate depth image,
     by looping over each pixel individually
    "
    newImage := (Image implementorForDepth:deviceDepth) new.
    newImage width:width.
    newImage height:height.
    newImage bits:(ByteArray uninitializedNew:(height * newImage bytesPerRow)).

    0 to:height-1 do:[:row |
        pixelRow := self rowAt:row.
        pixelRow
            expandPixels:8         "xlate only"
            width:width
            height:1
            into:pixelRow
            mapping:map.
        newImage rowAt:row putAll:pixelRow
    ].

    f := Form width:width height:height depth:deviceDepth onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f colorMap:imgMap.

    aDevice
        drawBits:(newImage bits)
        depth:deviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id) x:0 y:0
        width:width height:height
        with:(f initGC).

    ^ f

    "Modified: / 15-10-1997 / 01:48:20 / cg"
    "Created: / 19-10-1997 / 04:57:05 / cg"
    "Modified (comment): / 30-01-2017 / 21:00:08 / stefan"
!

anyImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |depth
     colorValues
     form imageBits bestFormat usedDeviceDepth usedDeviceBitsPerPixel
     usedDevicePadding usedDeviceBytesPerRow padd|

    depth := aDevice depth.

    "/ gather r/g/b values for all colors in the map ...

    colorValues := self rgbColormapFor:aDevice.

    bestFormat := self bestSupportedImageFormatFor:aDevice.
    usedDeviceDepth := bestFormat at:#depth.
    usedDeviceDepth == 1 ifTrue:[
        ^ self asMonochromeFormOn:aDevice
    ].
    usedDeviceBitsPerPixel := bestFormat at:#bitsPerPixel.
    usedDevicePadding := bestFormat at:#padding.

    usedDeviceBytesPerRow := self class bytesPerRowForWidth:width depth:usedDeviceBitsPerPixel padding:usedDevicePadding.
    padd := usedDeviceBytesPerRow -( self class bytesPerRowForWidth:width depth:usedDeviceBitsPerPixel padding:8).
    imageBits := ByteArray uninitializedNew:(usedDeviceBytesPerRow * height).

    "/ for now, only support some depths

    usedDeviceBitsPerPixel == 16 ifTrue:[
        "/ 16 bits/pixel

        "/ now, walk over the image and replace
        "/ colorMap indices by color values in the bits array

%{
        unsigned char *srcPtr = 0;
        unsigned char *dstPtr = 0;
        OBJ _bytes = __INST(bytes);

        if (__isByteArrayLike(_bytes)) {
            srcPtr = __ByteArrayInstPtr(_bytes)->ba_element;
        } else {
            if (__isExternalBytesLike(_bytes)) {
                srcPtr = __externalBytesAddress(_bytes);
            }
        }
        if (__isByteArray(imageBits)) {
            dstPtr = __ByteArrayInstPtr(imageBits)->ba_element;
        } else {
            if (__isExternalBytesLike(imageBits)) {
                dstPtr = __externalBytesAddress(imageBits);
            }
        }

        if (__bothSmallInteger(__INST(height), __INST(width))
         && __isArrayLike(colorValues)
         && srcPtr
         && dstPtr) {
            int r,p;
            int x, y, w, h, nPix;
            unsigned short pixels[256];

            OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

            nPix = __arraySize(colorValues);
            for (p=0; p<nPix; p++) {
                pixels[p] = __intVal(ap[p]);
            }

            w = __intVal(__INST(width));
            h = __intVal(__INST(height));
            r = w;
            p = __intVal(padd);
            nPix = w * h;

            while (nPix > 0) {
                unsigned idx, v;

                if (((unsigned INT)srcPtr & 3) == 0) {
                    unsigned INT idx4;

                    while (r > 4) {
#ifdef __MSBFIRST
                        idx4 = ((unsigned int *)srcPtr)[0];
                        v = pixels[(idx4 >> 24) & 0xFF];
                        ((short *)dstPtr)[0] = v;
                        v = pixels[(idx4 >> 16) & 0xFF];
                        ((short *)dstPtr)[1] = v;
                        v = pixels[(idx4 >> 8) & 0xFF];
                        ((short *)dstPtr)[2] = v;
                        v = pixels[idx4 & 0xFF];
                        ((short *)dstPtr)[3] = v;
#else
# ifdef __LSBFIRST
                        idx4 = ((unsigned int *)srcPtr)[0];
                        v = pixels[idx4 & 0xFF];
                        dstPtr[0] = (v>>8) & 0xFF;
                        dstPtr[1] = (v) & 0xFF;

                        v = pixels[(idx4 >> 8) & 0xFF];
                        dstPtr[2] = (v>>8) & 0xFF;
                        dstPtr[3] = (v) & 0xFF;

                        v = pixels[(idx4 >> 16) & 0xFF];
                        dstPtr[4] = (v>>8) & 0xFF;
                        dstPtr[5] = (v) & 0xFF;

                        v = pixels[(idx4 >> 24) & 0xFF];
                        dstPtr[6] = (v>>8) & 0xFF;
                        dstPtr[7] = (v) & 0xFF;
# else /* unknown/unspecified - code below works on any machine */
                        idx = srcPtr[0];
                        v = pixels[idx];
                        dstPtr[0] = (v>>8) & 0xFF;
                        dstPtr[1] = (v) & 0xFF;

                        idx = srcPtr[1];
                        v = pixels[idx];
                        dstPtr[2] = (v>>8) & 0xFF;
                        dstPtr[3] = (v) & 0xFF;

                        idx = srcPtr[2];
                        v = pixels[idx];
                        dstPtr[4] = (v>>8) & 0xFF;
                        dstPtr[5] = (v) & 0xFF;

                        idx = srcPtr[3];
                        v = pixels[idx];
                        dstPtr[6] = (v>>8) & 0xFF;
                        dstPtr[7] = (v) & 0xFF;
# endif
#endif
                        r -= 4;
                        dstPtr += 8;
                        nPix -= 4;
                        srcPtr +=4;
                    }
                }

                nPix--;

                idx = *srcPtr++;
                v = pixels[idx];
#ifdef __MSBFIRST
                ((short *)dstPtr)[0] = v;
#else
                dstPtr[0] = (v>>8) & 0xFF;
                dstPtr[1] = (v) & 0xFF;
#endif
                dstPtr += 2;

                if (--r == 0) {
                    dstPtr += p;
                    r = w;
                }
            }
        }
%}.
    ] ifFalse:[
        usedDeviceBitsPerPixel == 32 ifTrue:[
            "/ 32 bits/pixel

            "/ now, walk over the image and replace
            "/ colorMap indices by color values in the bits array

%{
            unsigned char *srcPtr = 0;
            unsigned char *dstPtr = 0;
            OBJ _bytes = __INST(bytes);

            if (__isByteArrayLike(_bytes)) {
                srcPtr = __ByteArrayInstPtr(_bytes)->ba_element;
            } else {
                if (__isExternalBytesLike(_bytes)) {
                    srcPtr = __externalBytesAddress(_bytes);
                }
            }
            if (__isByteArray(imageBits)) {
                dstPtr = __ByteArrayInstPtr(imageBits)->ba_element;
            } else {
                if (__isExternalBytesLike(imageBits)) {
                    dstPtr = __externalBytesAddress(imageBits);
                }
            }

            if (__bothSmallInteger(__INST(height), __INST(width))
             && __isArrayLike(colorValues)
             && srcPtr
             && dstPtr) {
                int x, y, w, h, nPix;

                OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                w = __intVal(__INST(width));
                h = __intVal(__INST(height));
                nPix = w * h;
                while (nPix > 0) {
                    unsigned idx, v;
                    OBJ clr;

                    idx = *srcPtr;
                    clr = ap[idx];
                    v = __intVal(clr);
#ifdef __MSBFIRST
                    ((long *)dstPtr)[0] = v;
#else
                    dstPtr[0] = (v>>24) & 0xFF;
                    dstPtr[1] = (v>>16) & 0xFF;
                    dstPtr[2] = (v>>8) & 0xFF;
                    dstPtr[3] = (v) & 0xFF;
#endif
                    dstPtr += 4;
                    srcPtr += 1;
                    nPix--;
                }
            }
%}.
        ] ifFalse:[
            usedDeviceBitsPerPixel == 8 ifTrue:[
                "/ 8 bits/pixel

                "/ now, walk over the image and replace
                "/ colorMap indices by color values in the bits array

%{
                unsigned char *srcPtr = 0;
                unsigned char *dstPtr = 0;
                OBJ _bytes = __INST(bytes);

                if (__isByteArrayLike(_bytes)) {
                    srcPtr = __ByteArrayInstPtr(_bytes)->ba_element;
                } else {
                    if (__isExternalBytesLike(_bytes)) {
                        srcPtr = __externalBytesAddress(_bytes);
                    }
                }
                if (__isByteArray(imageBits)) {
                    dstPtr = __ByteArrayInstPtr(imageBits)->ba_element;
                } else {
                    if (__isExternalBytesLike(imageBits)) {
                        dstPtr = __externalBytesAddress(imageBits);
                    }
                }

                if (__bothSmallInteger(__INST(height), __INST(width))
                 && __isArrayLike(colorValues)
                 && srcPtr
                 && dstPtr) {
                    int x, y, w, h, nPix;
                    int r,p;

                    OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                    w = __intVal(__INST(width));
                    h = __intVal(__INST(height));
                    r = w;
                    p = __intVal(padd);

                    nPix = w * h;
                    while (nPix > 0) {
                        unsigned idx, v;
                        OBJ clr;

                        idx = *srcPtr;
                        clr = ap[idx];
                        v = __intVal(clr);

                        dstPtr[0] = v;

                        dstPtr += 1;
                        srcPtr += 1;
                        nPix--;

                        if (--r == 0) {
                          dstPtr += p;
                          r = w;
                        }

                    }
                }
%}.
            ] ifFalse:[
                usedDeviceBitsPerPixel == 24 ifTrue:[
                    "/ 24 bits/pixel

                    "/ now, walk over the image and replace
                    "/ colorMap indices by color values in the bits array

%{
                    unsigned char *srcPtr = 0;
                    unsigned char *dstPtr = 0;
                    OBJ _bytes = __INST(bytes);

                    if (__isByteArrayLike(_bytes)) {
                        srcPtr = __ByteArrayInstPtr(_bytes)->ba_element;
                    } else {
                        if (__isExternalBytesLike(_bytes)) {
                            srcPtr = __externalBytesAddress(_bytes);
                        }
                    }
                    if (__isByteArray(imageBits)) {
                        dstPtr = __ByteArrayInstPtr(imageBits)->ba_element;
                    } else {
                        if (__isExternalBytesLike(imageBits)) {
                            dstPtr = __externalBytesAddress(imageBits);
                        }
                    }

                    if (__bothSmallInteger(__INST(height), __INST(width))
                     && __isArrayLike(colorValues)
                     && srcPtr
                     && dstPtr) {
                        int x, y, w, h, nPix;
                        int r,p;

                        OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                        w = __intVal(__INST(width));
                        h = __intVal(__INST(height));
                        r = w;
                        p = __intVal(padd);

                        nPix = w * h;
                        while (nPix > 0) {
                            unsigned idx, v;
                            OBJ clr;

                            idx = *srcPtr;
                            clr = ap[idx];
                            v = __intVal(clr);

                            dstPtr[0] = (v>>16) & 0xFF;
                            dstPtr[1] = (v>>8) & 0xFF;
                            dstPtr[2] = (v) & 0xFF;

                            dstPtr += 3;
                            srcPtr += 1;
                            nPix--;
                            if (--r == 0) {
                              dstPtr += p;
                              r = w;
                            }
                        }
                    }
%}.
                ]
            ]
        ]
    ].

    imageBits isNil ifTrue:[
        'Image [warning]: unimplemented trueColor depth in paletteImageAsTrueColorFormOn: ' errorPrint. usedDeviceBitsPerPixel errorPrintCR.
        ^ self asMonochromeFormOn:aDevice
    ].

    form := Form imageForm width:width height:height depth:usedDeviceDepth onDevice:aDevice.
    form isNil ifTrue:[^ nil].
    form initGC.

    form
        copyBitsFrom:imageBits
        bitsPerPixel:usedDeviceBitsPerPixel
        depth:usedDeviceDepth
        padding:usedDevicePadding
        width:width height:height
        x:0 y:0
        toX:0 y:0.

    ^ form

    "Created: / 20-10-1995 / 22:05:10 / cg"
    "Modified: / 29-05-2007 / 19:22:06 / cg"
!

asGray8FormOn:aDevice
    "return an 8-bit greyForm from the 8-bit receiver image.
     Redefined, since only a translation has to be done here."

    |greyBits map|

    greyBits := ByteArray uninitializedNew:(width * height).

    map := ByteArray uninitializedNew:256.

    1 to:256 do:[:i |
	map at:i put:((self colorFromValue:(i-1)) brightness * 255) rounded
    ].

    self bits
	expandPixels:8         "xlate only"
	width:width
	height:height
	into:greyBits
	mapping:map.

    ^ self makeDeviceGrayPixmapOn:aDevice depth:8 fromArray:greyBits

    "Modified: 10.6.1996 / 20:10:14 / cg"
    "Created: 14.6.1996 / 15:23:09 / cg"
!

asGrayFormOn:aDevice
    "get a gray device form.
     Redefined, since we can do it with simple translate,
     if the depth matches my depth."

    (aDevice visualType == #StaticGray) ifTrue:[
	(aDevice depth == 8) ifTrue:[
	    ^ self asGray8FormOn:aDevice
	].
    ].
    ^ super asGrayFormOn:aDevice

    "Created: 10.6.1996 / 18:51:19 / cg"
    "Modified: 10.6.1996 / 18:54:36 / cg"
!

greyImageAsPseudoFormOn:aDevice
    "return a pseudoForm from the gray picture. The main work is
     in color reduction, when not all colors can be acquired."

    ^ self anyImageAsPseudoFormOn:aDevice

    "Modified: 19.10.1997 / 04:57:39 / cg"
    "Created: 19.10.1997 / 04:58:41 / cg"
!

greyImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the grey-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super greyImageAsTrueColorFormOn:aDevice

    "Created: / 29.7.1998 / 00:19:46 / cg"
!

paletteImageAsPseudoFormOn:aDevice
    "return a pseudoForm from the palette picture. The main work is
     in color reduction, when not all colors can be acquired."

    ^ self anyImageAsPseudoFormOn:aDevice

    "Modified: 19.10.1997 / 04:57:39 / cg"
!

paletteImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the palette-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super paletteImageAsTrueColorFormOn:aDevice

    "Created: / 24.7.1998 / 01:20:46 / cg"
    "Modified: / 29.7.1998 / 00:19:27 / cg"
!

rgbImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the rgb-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super rgbImageAsTrueColorFormOn:aDevice

    "Created: / 29.7.1998 / 00:21:25 / cg"
! !

!Depth8Image methodsFor:'dither helpers'!

floydSteinbergDitheredDepth8BitsColors:colors map:aMapOrNil
    "return a floyd-steinberg dithered bitmap from the receiver picture,
     which must be a depth-8 image.
     This method expects an array of colors to be used for dithering
     (which need not be a colorCubes colors)."

    |pseudoBits
     rgbBytes
     ditherRGBBytes ditherColors
     w       "{Class: SmallInteger }"
     h       "{Class: SmallInteger }"
     index   "{Class: SmallInteger }"
     lookupPos "{Class: SmallInteger }"
     ditherIds failed lastColor qScramble
     clrLookup error clr|

    "/
    "/ collect color components as integer values (for integer arithmetic)
    "/
    rgbBytes := ByteArray uninitializedNew:256 * 3.

    photometric == #palette ifTrue:[
        lastColor := colorMap size - 1
    ] ifFalse:[
        lastColor := 255.
    ].
    index := 1.
    0 to:lastColor do:[:pix |
        clr := self colorFromValue:pix.
        rgbBytes at:index put:(clr redByte).
        rgbBytes at:index+1 put:(clr greenByte).
        rgbBytes at:index+2 put:(clr blueByte).

        index := index + 3.
    ].

    "/ collect valid ditherColors ...
    aMapOrNil isNil ifTrue:[
        ditherColors := colors select:[:clr | clr notNil].
    ] ifFalse:[
        ditherColors := colors
    ].

    "/ ... and sort by manhatten distance from black

    qScramble := #(
                "/  2rX00X00X00X00

                    2r000000000000    "/ 0
                    2r000000000100    "/ 1
                    2r000000100000    "/ 2
                    2r000000100100    "/ 3
                    2r000100000000    "/ 4
                    2r000100000100    "/ 5
                    2r000100100000    "/ 6
                    2r000100100100    "/ 7
                    2r100000000000    "/ 8
                    2r100000000100    "/ 9
                    2r100000100000    "/ a
                    2r100000100100    "/ b
                    2r100100000000    "/ c
                    2r100100000100    "/ d
                    2r100100100000    "/ e
                    2r100100100100    "/ f
                  ).

    ditherColors := ditherColors sort:[:a :b |
                                |cr "{Class: SmallInteger }"
                                 cg "{Class: SmallInteger }"
                                 cb "{Class: SmallInteger }"
                                 i1 "{Class: SmallInteger }"
                                 i2 "{Class: SmallInteger }"|

                                cr := a redByte.
                                cg := a greenByte.
                                cb := a blueByte.
                                i1 := qScramble at:((cr bitShift:-4) bitAnd:16r0F) + 1.
                                i1 := i1 + ((qScramble at:((cg bitShift:-4) bitAnd:16r0F) + 1) bitShift:-1).
                                i1 := i1 + ((qScramble at:((cb bitShift:-4) bitAnd:16r0F) + 1) bitShift:-2).

                                cr := b redByte.
                                cg := b greenByte.
                                cb := b blueByte.
                                i2 := qScramble at:((cr bitShift:-4) bitAnd:16r0F) + 1.
                                i2 := i2 + ((qScramble at:((cg bitShift:-4) bitAnd:16r0F) + 1) bitShift:-1).
                                i2 := i2 + ((qScramble at:((cb bitShift:-4) bitAnd:16r0F) + 1) bitShift:-2).

                                i1 < i2
                    ].
    aMapOrNil isNil ifTrue:[
        ditherIds := (ditherColors asArray collect:[:clr | clr colorId]) asByteArray.
    ] ifFalse:[
        ditherIds := aMapOrNil asByteArray
    ].

    "/ build an index table, for fast lookup from manhatten-r-g-b distance
    "/ to the position in the colorList

    clrLookup := ByteArray new:(4096).
    index := 0.
    ditherColors keysAndValuesDo:[:clrPosition :clr |
        |r g b i|

        r := clr redByte.
        g := clr greenByte.
        b := clr blueByte.
        i := qScramble at:((r bitShift:-4) bitAnd:16r0F) + 1.
        i := i + ((qScramble at:((g bitShift:-4) bitAnd:16r0F) + 1) bitShift:-1).
        i := i + ((qScramble at:((b bitShift:-4) bitAnd:16r0F) + 1) bitShift:-2).
        lookupPos := i.

        index+1 to:lookupPos do:[:idx|
            clrLookup at:idx put:(clrPosition-1-1).
        ].
        index := lookupPos.
    ].
    clrLookup from:index+1 to:4096 put:(ditherColors size - 1).

"/    [index <= (4095)] whileTrue:[
"/        clrLookup at:(index+1) put:(ditherColors size - 1).
"/        index := index + 1.
"/    ].

    "/ collect ditherColor components

    lastColor := ditherColors size.
    ditherIds := ByteArray uninitializedNew:lastColor.
    ditherRGBBytes := ByteArray uninitializedNew:(lastColor * 3).
    index := 1.
    1 to:lastColor do:[:pix |
        clr := ditherColors at:pix.
        ditherRGBBytes at:index put:(clr redByte).
        ditherRGBBytes at:index+1 put:(clr greenByte).
        ditherRGBBytes at:index+2 put:(clr blueByte).
        aMapOrNil isNil ifTrue:[
            ditherIds at:pix put:clr colorId.
        ] ifFalse:[
            ditherIds at:pix put:(aMapOrNil at:pix).
        ].
        index := index + 3.
    ].

    pseudoBits := ByteArray uninitializedNew:(width * height).

    w := width + 2.
    error := ByteArray uninitializedNew:w*(3*2).

    w := width.
    h := height.

    failed := true.

%{
    int __x, __y;
    int __eR, __eG, __eB;
    unsigned char *srcP, *dstP;
    unsigned char *rgbP;
    unsigned char *idP;
    unsigned char *dp;
    unsigned char *__clrLookup;
    short *errP, *eP;
    int __fR, __fG, __fB;
    int iR, iG, iB;
    int idx;
    int __w = __intVal(w);
    int __h = __intVal(h);
    int __nColors = __intVal(lastColor);
    int __wR = -1, __wG, __wB;
    static int __qScramble[16] = {
                    0x000 /* 2r000000000000    0 */,
                    0x004 /* 2r000000000100    1 */,
                    0x020 /* 2r000000100000    2 */,
                    0x024 /* 2r000000100100    3 */,
                    0x100 /* 2r000100000000    4 */,
                    0x104 /* 2r000100000100    5 */,
                    0x120 /* 2r000100100000    6 */,
                    0x124 /* 2r000100100100    7 */,
                    0x800 /* 2r100000000000    8 */,
                    0x804 /* 2r100000000100    9 */,
                    0x820 /* 2r100000100000    a */,
                    0x824 /* 2r100000100100    b */,
                    0x900 /* 2r100100000000    c */,
                    0x904 /* 2r100100000100    d */,
                    0x920 /* 2r100100100000    e */,
                    0x924 /* 2r100100100100    f */,
                  };

    if (__isByteArrayLike(__INST(bytes))
     && __isByteArray(pseudoBits)
     && __isByteArray(rgbBytes)
     && __isByteArray(ditherRGBBytes)
     && __isByteArray(ditherIds)
     && __isByteArray(clrLookup)
     && __isByteArray(error)) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        rgbP = __ByteArrayInstPtr(rgbBytes)->ba_element;
        idP = __ByteArrayInstPtr(ditherIds)->ba_element;
        __clrLookup = __ByteArrayInstPtr(clrLookup)->ba_element;
        errP = (short *) __ByteArrayInstPtr(error)->ba_element;

        /*
         * clear error accumulator
         */
        eP = errP;
        bzero(eP, (__w+2) * 2 * 3);

        for (__y=__h; __y>0; __y--) {
            __eR = __eG = __eB = 0;

            eP = &(errP[3]);
            __eR = eP[0];
            __eG = eP[1];
            __eB = eP[2];

            for (__x=__w; __x>0; __x--) {
                int __want;
                int pix;
                int __wantR, __wantG, __wantB;
                int idx;
                int tR, tG, tB;
                int nR, nG, nB;
                int dR, dG, dB;
                int minDelta, bestIdx;
                int cnt;

                pix = *srcP++;

                /*
                 * wR, wG and wB is the wanted r/g/b value;
                 */
                idx = pix+pix+pix;  /* pix * 3 */

                __wantR = rgbP[idx] + __eR;
                __wantG = rgbP[idx+1] + __eG;
                __wantB = rgbP[idx+2] + __eB;

#define RED_SCALE 30
#define GREEN_SCALE 59
#define BLUE_SCALE 11
#define GOOD_DELTA 30

#define xRED_SCALE 1
#define xGREEN_SCALE 1
#define xBLUE_SCALE 1
#define xGOOD_DELTA 3

#define FAST_LOOKUP
/* #define ONE_SHOT */
#define NPROBE 8

#ifndef FAST_LOOKUP
                if ((__wantR == __wR)
                 && (__wantG == __wG)
                 && (__wantB == __wB)) {
                    /*
                     * same color again - reuse last bestMatch
                     */
                } else
#endif
                {
                    __wR = __wantR;
                    __wG = __wantG;
                    __wB = __wantB;

#ifdef FAST_LOOKUP
                    if(__wR > 255) __wR = 255;
                    else if (__wR < 0) __wR = 0;
                    if(__wG > 255) __wG = 255;
                    else if (__wG < 0) __wG = 0;
                    if(__wB > 255) __wB = 255;
                    else if (__wB < 0) __wB = 0;

                    {
                        int lookupIndex;
                        int idx, idx0;
                        int d, delta;
                        unsigned char *dp0;

                        dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                        lookupIndex =    __qScramble[((__wR & 0xF0)>>4)];
                        lookupIndex |=   __qScramble[((__wG & 0xF0)>>4)] >> 1;
                        lookupIndex |=   __qScramble[((__wB & 0xF0)>>4)] >> 2;
                        idx = bestIdx =__clrLookup[lookupIndex];
                        dp += (idx+idx+idx);

                        /* try color at lookupIndex */

                        d = dp[0];
                        delta = (__wR - d) * RED_SCALE;
                        if (delta < 0) delta = -delta;

                        d = dp[1];
                        if (__wG > d)
                            delta += (__wG - d) * GREEN_SCALE;
                        else
                            delta += (d - __wG) * GREEN_SCALE;
                        d = dp[2];
                        if (__wB > d)
                            delta += (__wB - d) * BLUE_SCALE;
                        else
                            delta += (d - __wB) * BLUE_SCALE;

                        if (delta <= GOOD_DELTA) {
                            goto foundBest;
                        }
                        minDelta = delta;
# ifndef ONE_SHOT
                        idx0 = idx; dp0 = dp;
                        cnt = 0;
                        while ((++cnt <= NPROBE) && (idx > 0)) {
                            /* try previous color(s) */

                            idx--; dp -= 3;
                            d = dp[0];
                            delta = (__wR - d) * RED_SCALE;
                            if (delta < 0) delta = -delta;
                            d = dp[1];
                            if (__wG > d)
                                delta += (__wG - d) * GREEN_SCALE;
                            else
                                delta += (d - __wG) * GREEN_SCALE;
                            d = dp[2];
                            if (__wB > d)
                                delta += (__wB - d) * BLUE_SCALE;
                            else
                                delta += (d - __wB) * BLUE_SCALE;

                            if (delta < minDelta) {
                                bestIdx = idx;
                                if (delta <= GOOD_DELTA) {
                                    goto foundBest;
                                }
                                minDelta = delta;
                            }
                        }

                        idx = idx0; dp = dp0;
                        cnt = 0;
                        while ((++cnt <= NPROBE) && (++idx < __nColors)) {
                            /* try next color */

                            dp += 3;
                            d = dp[0];
                            delta = (__wR - d) * RED_SCALE;
                            if (delta < 0) delta = -delta;
                            d = dp[1];
                            if (__wG > d)
                                delta += (__wG - d) * GREEN_SCALE;
                            else
                                delta += (d - __wG) * GREEN_SCALE;
                            d = dp[2];
                            if (__wB > d)
                                delta += (__wB - d) * BLUE_SCALE;
                            else
                                delta += (d - __wB) * BLUE_SCALE;

                            if (delta < minDelta) {
                                bestIdx = idx;
                                if (delta <= GOOD_DELTA) {
                                    goto foundBest;
                                }
                                minDelta = delta;
                            }
                        }
# endif
                    }
        foundBest: ;
#else
/*
                    if(__wR > 255) __wR = 255;
                    else if (__wR < 0) __wR = 0;
                    if(__wG > 255) __wG = 255;
                    else if (__wG < 0) __wG = 0;
                    if(__wB > 255) __wB = 255;
                    else if (__wB < 0) __wB = 0;
*/

                    /* find the best matching color */

                    minDelta = 99999;
                    bestIdx = -1;
                    dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                    for (idx = 0; idx<__nColors; idx++) {
                        int d, delta;

                        d = dp[0];
                        delta = (__wR - d) * RED_SCALE;
                        if (delta < 0) delta = -delta;
                        if (delta < minDelta) {
                            d = dp[1];
                            if (__wG > d)
                                delta += (__wG - d) * GREEN_SCALE;
                            else
                                delta += (d - __wG) * GREEN_SCALE;
                            if (delta < minDelta) {
                                d = dp[2];
                                if (__wB > d)
                                    delta += (__wB - d) * BLUE_SCALE;
                                else
                                    delta += (d - __wB) * BLUE_SCALE;

                                if (delta < minDelta) {
                                    bestIdx = idx;
                                    if (delta <= GOOD_DELTA) {
                                        break;
                                    }
                                    minDelta = delta;
                                }
                            }
                        }
                        dp += 3;
                    }
#endif
                }
                dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                dp += bestIdx * 3;
                dR = dp[0];
                dG = dp[1];
                dB = dp[2];

/*
console_fprintf(stderr, "want: %d/%d/%d (%d/%d/%d) got: %d/%d/%d\n",
                __wantR, __wantG, __wantB,
                __wR, __wG, __wB,
                dR, dG, dB);
*/
                /*
                 * store the corresponding dither colors colorId
                 */
                *dstP++ = idP[bestIdx];

                /*
                 * the new error & distribute the error
                 */
                __eR = __wantR - dR;
                if (__eR) {
                    tR = __eR >> 4;  /* 16th of error */
                    nR = eP[3] + (tR * 7);/* from accu: error for (x+1 / y) */
                    eP[0] = tR*5;         /* 5/16th for (x / y+1) */
                    eP[-3] = tR*3;        /* 3/16th for (x-1 / y+1) */
                    eP[3] = __eR - (tR*15);  /* 1/16th for (x+1 / y+1) */
                    __eR = nR;
                } else {
                    __eR = eP[3];
                    eP[0] = eP[-3] = eP[3] = 0;
                }

                __eG = __wantG - dG;
                if (__eG) {
                    tG = __eG >> 4;
                    nG = eP[4] + (tG * 7);/* plus 7/16'th of this error */
                    eP[1] = tG*5;
                    eP[-2] = tG*3;
                    eP[4] = __eG - (tG*15);
                    __eG = nG;
                } else {
                    __eG = eP[4];
                    eP[1] = eP[-2] = eP[4] = 0;
                }

                __eB = __wantB - dB;
                if (__eB) {
                    tB = __eB >> 4;
                    nB = eP[5] + (tB * 7);
                    eP[2] = tB*5;
                    eP[-1] = tB*3;
                    eP[5] = __eB - (tB*15);
                    __eB = nB;
                } else {
                    __eB = eP[5];
                    eP[2] = eP[-1] = eP[5] = 0;
                }

                eP += 3;
            }
        }
    }
%}.
    failed ifTrue:[
        self primitiveFailed.
        ^ nil
    ].

    ^ pseudoBits
!

orderedDitheredGrayBitsWithDitherMatrix:ditherMatrix ditherWidth:dW depth:depth
    "return the bitmap for a dithered depth-bitmap from the image;
     with a constant ditherMatrix, this can be used for thresholding.
     Redefined to make use of knowing that pixels are 8-bit values."

    |dH nDither bytes
     greyLevels greyMap1 greyMap2
     bytesPerRow  "{Class: SmallInteger }"
     bytesPerOutRow  "{Class: SmallInteger }"
     pixelsPerByte   "{Class: SmallInteger }"
     outBits
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }" |

    nDither := ditherMatrix size.
    dH := nDither / dW.

    w := width.
    h := height.
    bytes := self bits.

    greyLevels := 1 bitShift:depth.
    pixelsPerByte := 8 / depth.

    bytesPerRow := self bytesPerRow.

    bytesPerOutRow := (w * depth + 7) // 8.
    outBits := ByteArray uninitializedNew:(bytesPerOutRow * h).
    (outBits isNil or:[bytes isNil]) ifTrue:[
	^ nil
    ].

    greyMap1 := self greyMapForRange:(greyLevels-1).                    "/ the pixels
    greyMap1 := (greyMap1 collect:[:b | b isNil ifTrue:[
					    0
					] ifFalse:[
					    b truncated
					]
				  ]) asByteArray.

    greyMap2 := self greyMapForRange:(greyLevels-1).
    greyMap2 := (greyMap2 collect:[:el |
					el isNil ifTrue:[
					    0
					] ifFalse:[
					    ((el - el truncated)  "/ the error (0..1)
					    * nDither) rounded
					]]) asByteArray.

%{
    int __dW = __intVal(dW);
    int __dH = __intVal(dH);
    int __byte;
    int __dT, __dO;
    int __depth = __intVal(depth);
    int __dstIdx = 0;
    int __srcIdx = 0;
    int __bitCnt;
    int __grey, __pixel;
    int __w = __intVal(w);
    int __h = __intVal(h);
    int __x;
    int __y;
    int __oX, __oY, __dY;
    int __nextDst;
    int __nextSrc;
    int __bytesPerRow = __intVal(bytesPerRow);
    int __bytesPerOutRow = __intVal(bytesPerOutRow);

    unsigned char *__outBits = __ByteArrayInstPtr(outBits)->ba_element;
    unsigned char *__ditherMatrix = __ByteArrayInstPtr(ditherMatrix)->ba_element;
    unsigned char *__bytes = __ByteArrayInstPtr(bytes)->ba_element;
    unsigned char *__greyMap1 = __ByteArrayInstPtr(greyMap1)->ba_element;
    unsigned char *__greyMap2 = __ByteArrayInstPtr(greyMap2)->ba_element;

    __oY = __dY = 0;
    for (__y=0; __y<__h; __y++) {
	__nextDst = __dstIdx + __bytesPerOutRow;
	__nextSrc = __srcIdx + __bytesPerRow;

	__byte = 0;
	__bitCnt = 8;

	__oX = 0;

	for (__x=0; __x<__w; __x++) {
	    __grey = __bytes[__srcIdx++];            /* 0..255 */

	    __pixel = __greyMap1[__grey];            /* 0..(greyLevels-1) */
	    __dO    = __greyMap2[__grey];            /* 0.. nDither-1) */
	    __dT = __ditherMatrix[__dY + __oX];

	    if (__dO > __dT)                         /* dither says: next pixel */
		__pixel++;

	    __oX++;
	    if (__oX == __dW) __oX = 0;

	    __byte = (__byte << __depth) | __pixel;

	    __bitCnt = __bitCnt - __depth;
	    if (__bitCnt == 0) {
		__outBits[__dstIdx] = __byte;
		__dstIdx++;
		__byte = 0;
		__bitCnt = 8;
	    }
	}

	if (__bitCnt != 8) {
	    __byte = __byte << __bitCnt;
	    __outBits[__dstIdx] = __byte;
	}

	__oY++; __dY += __dW;
	if (__oY == __dH) {
	    __oY = 0;
	    __dY = 0;
	}

	__srcIdx = __nextSrc;
	__dstIdx = __nextDst;
    }
%}.
    ^ outBits
!

orderedDitheredMonochromeBitsWithDitherMatrix:ditherMatrix ditherWidth:dW
    "return the dithered monochrome bits for the receiver image;
     with a constant ditherMatrix, this can be used for thresholding.
     Redefined to make use of knowing that pixels are 8-bit values."

    |dH nDither bytes
     greyMap monoBits
     bytesPerMonoRow "{Class: SmallInteger }"
     bytesPerRow     "{Class: SmallInteger }"
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"|

    nDither := ditherMatrix size.
    dH := nDither / dW.

    w := width.
    h := height.
    bytes := self bits.

    bytesPerRow := self bytesPerRow.

    bytesPerMonoRow := w + 7 // 8.
    monoBits := ByteArray uninitializedNew:(bytesPerMonoRow * h).
    (monoBits isNil or:[bytes isNil]) ifTrue:[
	^ nil
    ].

    greyMap := self greyByteMapForRange:nDither.

%{
    int __dW = __intVal(dW);
    int __dH = __intVal(dH);
    int __byte;
    int __dT;
    int __dstIdx = 0;
    int __srcIdx = 0;
    int __bitCnt;
    int __grey;
    int __w = __intVal(w);
    int __h = __intVal(h);
    int __x;
    int __y;
    int __oX, __oY, __dY;
    int __nextDst;
    int __nextSrc;
    int __bytesPerRow = __intVal(bytesPerRow);
    int __bytesPerMonoRow = __intVal(bytesPerMonoRow);

    unsigned char *__monoBits = __ByteArrayInstPtr(monoBits)->ba_element;
    unsigned char *__ditherMatrix = __ByteArrayInstPtr(ditherMatrix)->ba_element;
    unsigned char *__bytes = __ByteArrayInstPtr(bytes)->ba_element;
    unsigned char *__greyMap = __ByteArrayInstPtr(greyMap)->ba_element;

    __oY = __dY = 0;
    for (__y=0; __y<__h; __y++) {
	__nextDst = __dstIdx + __bytesPerMonoRow;
	__nextSrc = __srcIdx + __bytesPerRow;

	__byte = 0;
	__bitCnt = 8;

	__oX = 0;

	for (__x=__w; __x>0; __x--) {
	    __grey = __bytes[__srcIdx];   /* 0..255 */
	    __srcIdx++;

	    __grey = __greyMap[__grey];
	    __dT = __ditherMatrix[__dY + __oX];

	    __oX++;
	    if (__oX == __dW) __oX = 0;

	    __byte = __byte << 1;
	    if (__grey > __dT) {
		__byte = __byte | 1;           /* white */
	    }

	    __bitCnt--;
	    if (__bitCnt == 0) {
		__monoBits[__dstIdx] = __byte;
		__dstIdx++;
		__byte = 0;
		__bitCnt = 8;
	    }
	}

	if (__bitCnt != 8) {
	    __byte = __byte << __bitCnt;
	    __monoBits[__dstIdx] = __byte;
	}

	__oY++; __dY += __dW;
	if (__oY == __dH) {
	    __oY = 0;
	    __dY = 0;
	}

	__srcIdx = __nextSrc;
	__dstIdx = __nextDst;
    }
%}.

    ^ monoBits

    "
     |i f|

     i := Image fromFile:'bitmaps/gifImages/claus.gif'.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := Image fromFile:'bitmaps/gifImages/garfield.gif'.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := (Image fromFile:'bitmaps/PasteButton.tiff') magnifiedBy:10.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := (Image fromFile:'bitmaps/blue-ball.gif') magnifiedBy:1.
     f := i asOrderedDitheredMonochromeFormOn:Display.
    "

    "Created: 7.6.1996 / 10:48:06 / cg"
    "Modified: 7.6.1996 / 11:08:50 / cg"
! !

!Depth8Image methodsFor:'enumerating'!

colorsAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixel from x1 to x2 in row y.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using atX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     value    "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     color cachedColorArray pixelBytes lastValue lastColor|

    pixelBytes := self bits.

    x1 := xLow.
    x2 := xHigh.
    srcIndex := (width * y) + 1 + x1.

    cachedColorArray := Array new:256.

    x1 to:x2 do:[:x |
        value := pixelBytes at:srcIndex.
        srcIndex := srcIndex + 1.
        
        value == lastValue ifTrue:[
            color := lastColor
        ] ifFalse:[    
            color := cachedColorArray at:value+1.
            color isNil ifTrue:[
                color := self colorFromValue:value.
                cachedColorArray at:value+1 put:color
            ].
            lastValue := value. lastColor := color.
        ].
        aBlock value:x value:color
    ]

    "Created: 7.6.1996 / 19:12:35 / cg"
    "Modified: 11.7.1996 / 20:22:32 / cg"
!

colorsFromX:xStart y:yStart toX:xEnd y:yEnd do:aBlock
    "perform aBlock for each pixel in the rectangle
     yStart..yEnd / xStart..xEnd.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using individual atX:y: accesses,
     both since some processing can be avoided when going from pixel to pixel,
     and since the color composition is done outside of the pixel loop.
     However, for real high performance image processing, specialized methods
     should be written which know how to deal with specific photometric interpretations."

    |srcIndex    "{ Class: SmallInteger }"
     srcNext     "{ Class: SmallInteger }"
     bytesPerRow "{ Class: SmallInteger }"
     value    "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     y1       "{ Class: SmallInteger }"
     y2       "{ Class: SmallInteger }"
     colorArray
     maxColor pixelBytes lastPixel lastColor|

    pixelBytes := self bits.

    x1 := xStart.
    x2 := xEnd.
    y1 := yStart.
    y2 := yEnd.

    srcIndex := (width * y1) + x1 + 1 .
    bytesPerRow := self bytesPerRow.

    colorArray := self realColorMap.
    maxColor := colorArray size.

    y1 to:y2 do:[:y |
        srcNext := srcIndex + bytesPerRow.
        x1 to:x2 do:[:x |
            value := pixelBytes at:srcIndex ifAbsent:0.
            srcIndex := srcIndex + 1.

            value ~~ lastPixel ifTrue:[
                lastPixel := value.
                value >= maxColor ifTrue:[
                    value := 0.
                ].
                lastColor := colorArray at:value+1.
            ].
            aBlock value:x value:y value:lastColor
        ].
        srcIndex := srcNext.
    ].

    "Created: / 7.6.1996 / 19:12:35 / cg"
    "Modified: / 17.8.1998 / 10:17:45 / cg"
!

valuesAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixelValue from x1 to x2 in row y.
     The block is passed the pixelValue at each pixel.
     This method allows slighly faster processing of an
     image than using valueAtX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex   "{ Class: SmallInteger }"
     pixelValue "{ Class: SmallInteger }"
     x1         "{ Class: SmallInteger }"
     x2         "{ Class: SmallInteger }"
     bytes|

    x1 := xLow.
    x2 := xHigh.
    srcIndex := (width * y) + 1.
    bytes := self bits.

    x1 to:x2 do:[:x |
        pixelValue := bytes at:srcIndex+x.
        aBlock value:x value:pixelValue
    ]

    "Created: / 07-06-1996 / 19:09:47 / cg"
    "Modified: / 30-01-2017 / 18:54:15 / stefan"
!

valuesFromX:xStart y:yStart toX:xEnd y:yEnd do:aBlock
    "perform aBlock for each pixel in the rectangle
     yStart..yEnd / xStart..xEnd.
     The block is passed the pixelValue at each pixel.
     This method allows slighly faster processing of an
     image than using individual valueAtX:y: accesses,
     since some processing can be avoided when going from pixel to pixel..
     However, for real high performance image processing, specialized methods
     should be written which know how to deal with specific photometric interpretations."

    |srcIndex    "{ Class: SmallInteger }" 
     bytesPerRow "{ Class: SmallInteger }"
     value    "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     y1       "{ Class: SmallInteger }"
     y2       "{ Class: SmallInteger }"
     bytes|

    x1 := xStart.
    x2 := xEnd.
    y1 := yStart.
    y2 := yEnd.

    srcIndex := (width * y1) + 1 .
    bytesPerRow := self bytesPerRow.
    bytes := self bits.

    y1 to:y2 do:[:y |
        x1 to:x2 do:[:x |
            value := bytes at:srcIndex+x.
            aBlock value:x value:y value:value
        ].
        srcIndex := srcIndex + bytesPerRow.
    ].

    "Created: / 11-07-1996 / 20:08:11 / cg"
    "Modified: / 30-01-2017 / 19:04:05 / stefan"
    "Modified (format): / 31-01-2017 / 12:44:04 / stefan"
! !

!Depth8Image methodsFor:'image manipulations'!

easyRotateBitsInto:destinationImage angle:degrees
    "tuned helper for rotation - does the actual pixel shuffling, by degrees clockwise. 
     Here, only 90, 180 and 270 degrees are implemented. 
     Hard angles are done in #hardRotate:.
     The code here a tuned version of the inherited for more performance"

    |srcBytesPerRow dstBytesPerRow
     srcWidth srcHeight
     dstWidth dstHeight
     srcBytes dstBytes|

    srcBytesPerRow := self bytesPerRow.
    srcBytes := self bits.
    srcWidth := width.
    srcHeight := height.

    dstBytesPerRow := destinationImage bytesPerRow.
    dstBytes := destinationImage bits.
    dstWidth := destinationImage width.
    dstHeight := destinationImage height.
%{
    if (__bothSmallInteger(srcWidth, srcHeight)
     && __bothSmallInteger(dstWidth, dstHeight)
     && __bothSmallInteger(dstBytesPerRow, srcBytesPerRow)
     && __isByteArrayLike(srcBytes)
     && __isByteArrayLike(dstBytes)
    ) {
        int c_srcW = __intVal(srcWidth);
        int c_srcH = __intVal(srcHeight);
        int c_dstW = __intVal(dstWidth);
        int c_dstH = __intVal(dstHeight);
        int c_srcBytesPerRow = __intVal(srcBytesPerRow);
        int c_dstBytesPerRow = __intVal(dstBytesPerRow);
        int c_srcW4 = c_srcW-4;
        
        {
            unsigned char *c_srcBytes = (unsigned char*)__ByteArrayInstPtr(srcBytes)->ba_element;
            unsigned char *c_dstBytes = (unsigned char*)__ByteArrayInstPtr(dstBytes)->ba_element;

            int c_dstNextRowOffset;
            int c_dstNextColOffset;

            if (degrees == __mkSmallInteger(90)) {
                // destinationImage pixelAtX:(h-row) y:col put:pixel
                c_dstNextRowOffset = -1;                                // going to previous column
                c_dstNextColOffset = c_dstBytesPerRow;                  // going to next row
                c_dstBytes += (c_dstW-1);                               // start in the upper-right of dest
            } else if (degrees == __mkSmallInteger(180)) {
                // destinationImage pixelAtX:(w-col) y:(h-row) put:pixel
                c_dstNextRowOffset = -c_dstBytesPerRow;                 // going to previous row
                c_dstNextColOffset = -1;                                // going to prev col
                c_dstBytes += (c_dstH-1)*c_dstBytesPerRow+(c_dstW-1);   // start in the lower-right of dest
            } else {
                // destinationImage pixelAtX:row y:(w-col) put:pixel
                c_dstNextRowOffset = 1;                                 // going to next col
                c_dstNextColOffset = -c_dstBytesPerRow;                 // going to prev row
                c_dstBytes += (c_dstH-1)*c_dstBytesPerRow;              // start in the lower-left of dest
            }

            if ((c_srcBytesPerRow * c_srcH) <= __byteArraySize(srcBytes)) {
                int c_y;

                for (c_y=0; c_y<c_srcH; c_y++) {
                    unsigned char *c_srcNext = c_srcBytes + c_srcBytesPerRow;
                    unsigned char *c_dstNext = c_dstBytes + c_dstNextRowOffset;
                    int c_x;

                    c_x = 0;    
#if 1
                    if (sizeof(int) == 4) {
                        for (c_x = 0; c_x < c_srcW4; c_x += 4) {
                            int c_value;

                            c_value = ((int *)c_srcBytes)[0];

                            c_dstBytes[0] = (c_value) & 0xFF;
                            c_dstBytes += c_dstNextColOffset;

                            c_dstBytes[0] = (c_value>>8) & 0xFF;
                            c_dstBytes += c_dstNextColOffset;

                            c_dstBytes[0] = (c_value>>16) & 0xFF;
                            c_dstBytes += c_dstNextColOffset;

                            c_dstBytes[0] = (c_value>>24) & 0xFF;
                            c_dstBytes += c_dstNextColOffset;

                            c_srcBytes += 4;
                        }
                    }
#endif
                    for (; c_x < c_srcW; c_x++) {
                        int c_value;

                        c_value = c_srcBytes[0];
                        c_dstBytes[0] = c_value;

                        c_srcBytes++;
                        c_dstBytes += c_dstNextColOffset;
                    }
                    c_srcBytes = c_srcNext;
                    c_dstBytes = c_dstNext;
                }
                RETURN(self);
            }
        }
    }
%}.
    self breakPoint:#cg.
    super easyRotateBitsInto:destinationImage angle:degrees

    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     (i rotated:45) inspect.
     (i rotated:90) inspect.
     (i rotated:180) inspect.
     (i rotated:270) inspect.
    "
    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     Time millisecondsToRun:[
        1000 timesRepeat:[ (i rotated:90) ].
     ]
    "
!

hardMagnifiedBy:scalePoint
    "return a new image magnified by scalePoint, aPoint.
     This is the general magnification method, handling non-integral values"

    |mX mY
     newWidth  "{ Class: SmallInteger }"
     newHeight "{ Class: SmallInteger }"
     w         "{ Class: SmallInteger }"
     h         "{ Class: SmallInteger }"
     newImage newBytes
     value     "{ Class: SmallInteger }"
     srcRowIdx "{ Class: SmallInteger }"
     srcIndex  "{ Class: SmallInteger }"
     dstIndex  "{ Class: SmallInteger }"
     newMask|

    mX := scalePoint x.
    mY := scalePoint y.
    ((mX < 0) or:[mY < 0]) ifTrue:[^ nil].
    ((mX = 1) and:[mY = 1]) ifTrue:[^ self].

    newWidth := (width * mX) truncated.
    newHeight := (height * mY) truncated.

    newBytes := ByteArray uninitializedNew:(newWidth * newHeight).

    mask notNil ifTrue:[
        newMask := (mask magnifiedBy:scalePoint)
    ].

    newImage := self species new.
    newImage
        width:newWidth
        height:newHeight
        photometric:photometric
        samplesPerPixel:samplesPerPixel
        bitsPerSample:#[8]
        colorMap:colorMap copy
        bits:newBytes
        mask:newMask.

    "walk over destination image fetching pixels from source image"

    mY := mY asFloat.
    mX := mX asFloat.
%{
    unsigned char *__dstP = __ByteArrayInstPtr(newBytes)->ba_element;
    unsigned char *__srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
    unsigned char *__srcRowP;
    int __width = __intVal(__INST(width));
    int __w = __intVal(newWidth) - 1;
    int __h = __intVal(newHeight) - 1;
    int __row, __col;
    double __mX = __floatVal(mX);
    double __mY = __floatVal(mY);

    for (__row = 0; __row <= __h; __row++) {
        __srcRowP = __srcP + (__width * (int)((double)__row / __mY));
        for (__col = 0; __col <= __w; __col++) {
            *__dstP++ = __srcRowP[(int)((double)__col / __mX)];
        }
    }
%}
.
"/   the above C-code is equivalent to:
"/
"/    dstIndex := 1.
"/    w := newWidth - 1.
"/    h := newHeight - 1.
"/    0 to:h do:[:row |
"/        srcRowIdx := (width * (row // mY)) + 1.
"/        0 to:w do:[:col |
"/            srcIndex := srcRowIdx + (col // mX).
"/            value := bytes at:srcIndex.
"/            newBytes at:dstIndex put:value.
"/            dstIndex := dstIndex + 1
"/        ]
"/    ].
"/

    ^ newImage
!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors.
     Specially tuned for factors 2,3 and 4."

%{
    REGISTER unsigned char *srcP, *dstP;
    REGISTER unsigned char _byte;
    unsigned _word;
    int _mag;
    REGISTER int i;
    int _pixels;
    OBJ w = __INST(width);

    if (__bothSmallInteger(srcStart, dstStart)
     && __bothSmallInteger(w, mX)
     && __isByteArrayLike(srcBytes) && __isByteArray(dstBytes)) {
	_mag = __intVal(mX);
	srcP = __ByteArrayInstPtr(srcBytes)->ba_element - 1 + __intVal(srcStart);
	dstP = __ByteArrayInstPtr(dstBytes)->ba_element - 1 + __intVal(dstStart);
	_pixels = __intVal(w);

	switch (_mag) {
	    case 1:
		break;

	    case 2:
		/* special code for common case */
		if (((INT)dstP & 1) == 0) {
		    while (_pixels--) {
			_byte = *srcP++;
			_word = (_byte<<8) | _byte;
			((short *)dstP)[0] = _word;
			dstP += 2;
		    }
		} else {
		    while (_pixels--) {
			_byte = *srcP++;
			*dstP++ = _byte;
			*dstP++ = _byte;
		    }
		}
		break;

	    case 3:
		/* special code for common case */
		while (_pixels--) {
		    _byte = *srcP++;
		    *dstP++ = _byte;
		    *dstP++ = _byte;
		    *dstP++ = _byte;
		}
		break;

	    case 4:
		/* special code for common case */
		if (((INT)dstP & 3) == 0) {
		    while (_pixels--) {
			_byte = *srcP++;
			_word = (_byte<<8) | _byte;
			_word = (_word<<16) | _word;
			((int *)dstP)[0] = _word;
			dstP += 4;
		    }
		} else {
		    while (_pixels--) {
			_byte = *srcP++;
			*dstP++ = _byte;
			*dstP++ = _byte;
			*dstP++ = _byte;
			*dstP++ = _byte;
		    }
		}
		break;

	    default:
		if ((((INT)dstP & 1) == 0)
		 && ((_mag & 1) == 0)) {
		    while (_pixels--) {
			_byte = *srcP++;
			_word = (_byte<<8) | _byte;
			for (i=_mag; i>0; i-=2) {
			    ((short *)dstP)[0] = _word;
			    dstP += 2;
			}
		    }
		} else {
		    while (_pixels--) {
			_byte = *srcP++;
			for (i=_mag; i>0; i--)
			    *dstP++ = _byte;
		    }
		}
		break;
	}
	RETURN (self);
    }
%}.
    super
	magnifyRowFrom:srcBytes offset:srcStart
	into:dstBytes offset:dstStart factor:mX
! !

!Depth8Image methodsFor:'private'!

dither1PlaneUsingMap:map on:aDevice
    "a helper for dithering palette and greyscale images"

    |f
     patterns formBytes
     pixel0bytes pixel1bytes
     clr ditherPattern
     nColors       "{Class: SmallInteger }"
     w             "{Class: SmallInteger }"
     h             "{Class: SmallInteger }"|

    nColors := map size.
    w := width.
    h := height.

    formBytes := ByteArray uninitializedNew:(w + 7 // 8) * h.
    patterns := Array new:nColors.
    pixel0bytes := ByteArray uninitializedNew:nColors.
    pixel1bytes := ByteArray uninitializedNew:nColors.

    "
     extract dither patterns and values to use for 1/0 bits
     in those from the dithercolors
    "
    1 to:nColors do:[:i |
	clr := (map at:i) onDevice:aDevice.
	ditherPattern := clr ditherForm.

	ditherPattern isNil ifTrue:[
	    patterns at:i put:#[2r11111111
				2r11111111
				2r11111111
				2r11111111
				2r11111111
				2r11111111
				2r11111111
				2r11111111].
	    pixel0bytes at:i put:clr colorId.
	    pixel1bytes at:i put:clr colorId
	] ifFalse:[
	    patterns at:i put:(ditherPattern bits).
	    pixel0bytes at:i put:(ditherPattern colorMap at:1) colorId.
	    pixel1bytes at:i put:(ditherPattern colorMap at:2) colorId.
	].
    ].

%{
    unsigned char *_srcP, *_dstP;
    OBJ _patternBytes;
    unsigned char __mask = 0x80;
    unsigned char _outBits = 0;
    unsigned char _last, _v, _patternBits, _p0, _p1;
    int _h, _w;
    int _patternOffset = 0;

    _srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
    _dstP = __ByteArrayInstPtr(formBytes)->ba_element;
    for (_h = __intVal(h); _h; _h--) {
	_last = -1;
	for (_w = __intVal(w); _w; _w--) {
	    _v = *_srcP++;
	    if (_v != _last) {
		_patternBytes = __ArrayInstPtr(patterns)->a_element[_v];
		if (__isByteArray(_patternBytes)) {
		    _patternBits = __ByteArrayInstPtr(_patternBytes)->ba_element[_patternOffset];
		} else if (__isArrayLike(_patternBytes)) {
		    _patternBits = __intVal(__ArrayInstPtr(_patternBytes)->a_element[_patternOffset]);
		}
		_p0 = __ByteArrayInstPtr(pixel0bytes)->ba_element[_v];
		_p1 = __ByteArrayInstPtr(pixel1bytes)->ba_element[_v];
		_last = _v;
	    }
	    _outBits <<= 1;
	    if (_patternBits & __mask)
		_outBits |= _p1;
	    else
		_outBits |= _p0;
	    __mask >>= 1;
	    if (__mask == 0) {
		__mask = 0x80;
		*_dstP++ = _outBits;
		_outBits = 0;
	    }
	}
	if (__mask != 0x80) {
	    while (__mask != 0) {
		_outBits <<= 1;
		__mask >>= 1;
	    }
	    *_dstP++ = _outBits;
	    __mask = 0x80;
	    _outBits = 0;
	}
	_patternOffset++;
	if (_patternOffset == 8)
	    _patternOffset = 0;
    }
%}
.
    f := Form width:w height:h fromArray:formBytes.
    ^ f
!

dither2PlaneUsingMap:map on:aDevice
    "a helper for dithering palette and greyscale images"

    |f
     patterns formBytes
     pixel0bytes pixel1bytes
     clr ditherPattern
     nColors       "{Class: SmallInteger }"
     w             "{Class: SmallInteger }"
     h             "{Class: SmallInteger }"|

    nColors := map size.
    w := width.
    h := height.

    formBytes := ByteArray uninitializedNew:(w * 2 + 7 // 8) * h.
    patterns := Array new:nColors.
    pixel0bytes := ByteArray uninitializedNew:nColors.
    pixel1bytes := ByteArray uninitializedNew:nColors.

    "extract dither patterns and values to use for 1/0 bits
     in those from the dithercolors"

    1 to:nColors do:[:i |
        clr := (map at:i) onDevice:aDevice.
        ditherPattern := clr ditherForm.

        ditherPattern isNil ifTrue:[
            patterns at:i put:#[2r11111111
                                2r11111111
                                2r11111111
                                2r11111111
                                2r11111111
                                2r11111111
                                2r11111111
                                2r11111111].
            pixel0bytes at:i put:clr colorId.
            pixel1bytes at:i put:clr colorId
        ] ifFalse:[
            patterns at:i put:(ditherPattern bits).
            pixel0bytes at:i put:(ditherPattern colorMap at:1) colorId.
            pixel1bytes at:i put:(ditherPattern colorMap at:2) colorId.
        ].
    ].

%{
    unsigned char *_srcP, *_dstP;
    OBJ _patternBytes;
    unsigned char __mask = 0x80;
    unsigned char _outBits = 0;
    unsigned char _last, _v, _patternBits, _p0, _p1;
    int _h, _w;
    int _patternOffset = 0;
    int _outCount;

    _srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
    _dstP = __ByteArrayInstPtr(formBytes)->ba_element;
    for (_h = __intVal(h); _h; _h--) {
        _last = -1;
        _outCount = 0;
        for (_w = __intVal(w); _w; _w--) {
            _v = *_srcP++;
            if (_v != _last) {
                _patternBytes = __ArrayInstPtr(patterns)->a_element[_v];
                if (__isByteArray(_patternBytes)) {
                    _patternBits = __ByteArrayInstPtr(_patternBytes)->ba_element[_patternOffset];
                } else if (__isArrayLike(_patternBytes)) {
                    _patternBits = __intVal(__ArrayInstPtr(_patternBytes)->a_element[_patternOffset]);
                }
                _p0 = __ByteArrayInstPtr(pixel0bytes)->ba_element[_v];
                _p1 = __ByteArrayInstPtr(pixel1bytes)->ba_element[_v];
                _last = _v;
            }
            _outBits <<= 2;
            if (_patternBits & __mask)
                _outBits |= _p1;
            else
                _outBits |= _p0;
            __mask >>= 1;
            _outCount++;
            if (_outCount == 4) {
                *_dstP++ = _outBits;
                _outCount = 0;
                if (__mask == 0) {
                    __mask = 0x80;
                }
            }
        }
        if (_outCount) {
            do {
                _outBits <<= 2;
            } while (++_outCount != 4);
            *_dstP++ = _outBits;
        }
        __mask = 0x80;
        _outBits = 0;
        _patternOffset++;
        if (_patternOffset == 8)
            _patternOffset = 0;
    }
%}
.
    f := Form width:w height:h depth:2 onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f graphicsDevice
        drawBits:formBytes
        depth:2
        padding:8
        width:w height:h
        x:0 y:0
        into:f id
        x:0 y:0
        width:w height:h
        with:f initGC.
    ^ f
! !

!Depth8Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 8
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 8
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    ^ width
!

colorFromValue:pixelValue
    "given a pixel value, return the corresponding color.
     Pixel values start with 0."

    photometric == #whiteIs0 ifTrue:[
	^ Color gray:100 - (100 / 255 * pixelValue)
    ].
    photometric == #blackIs0 ifTrue:[
	^ Color gray:(100 / 255 * pixelValue)
    ].
    photometric == #palette ifTrue:[
	pixelValue < colorMap size ifTrue:[
	    ^ colorMap at:(pixelValue + 1)
	]
    ].
    ^ super colorFromValue:pixelValue
!

isDepth8Image
    "return true if the image is instance of Depth8Image"
   (self bitsPerPixel == 8) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 17:01:10 / svestkap"
!

nColorsUsed
    ^ colorMap size
!

realUsedValues
    "return a collection of color values used in the receiver."

    ^ self bits usedValues
!

usedValues
    "return a collection of color values used in the receiver."

    ^ self bits usedValues
! !

!Depth8Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2018 Patrik Svestka
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

Image subclass:#Depth32Image
	instanceVariableNames:''
	classVariableNames:'RGBA_R_OFFSET_NET RGBA_G_OFFSET_NET RGBA_B_OFFSET_NET
		RGBA_A_OFFSET_NET'
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth32Image class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    this class represents 32 bit images.
    Only the minimum protocol is implemented here; much more is
    needed for higher performance operations on depth32 images.
    (however, 32bit images are very seldom used, so falling back into the
    slow general methods from Image should not hurt too much ..)

    [author:]
	Claus Gittinger

    [see also:]
	Depth1Image Depth2Image Depth4Image Depth8Image Depth16Image Depth24Image
	ImageReader
"
! !

!Depth32Image class methodsFor:'initialization'!

initialize
    RGBA_A_OFFSET_NET := 4.
    RGBA_B_OFFSET_NET := 3.
    RGBA_G_OFFSET_NET := 2.
    RGBA_R_OFFSET_NET := 1.

    "Created: / 28-02-2016 / 11:29:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2016 / 14:36:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Depth32Image class methodsFor:'queries'!

defaultPhotometric
    "return the default photometric pixel interpretation"

    ^ #rgb

    "Created: / 27-05-2007 / 14:03:59 / cg"
    "Modified: / 06-06-2007 / 11:12:13 / cg"
!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 32"

    ^ 32

    "Modified: 20.4.1996 / 23:40:01 / cg"
    "Created: 24.4.1997 / 19:00:28 / cg"
! !

!Depth32Image methodsFor:'accessing'!

bitsARGB32Into: buffer startingAt: first stride: stride
    "Store each pixel is a 32-bit quantity, with alpha in the upper 
     8 bits, then red, then green, then blue. The 32-bit quantities are 
     stored native-endian. Pre-multiplied alpha is used. (That is, 50% 
     transparent red is 0x80800000, not 0x80ff0000.)

     IMPORTANT: The following code assumes that the data (`bytes` instvar)
     are stored in network byte order with NON-premultiplied alpha. This is
     true for PNG data.

     NOTE: This is a good candidate for C-level optimization.
    "

    | base pixelIndex bufferIndex  a r g b |

    pixelFunction isNil ifTrue:[ 
        photometric == #rgba ifTrue:[
            bitsPerSample = #(8 8 8 8) ifTrue:[ 
                1 to: height do:[:y |  
                    base := ((y - 1) * stride) + first - 1.
                    1 to: width do:[:x |  
                        pixelIndex := ((((y - 1) * width) + (x - 1)) * 4).
                        "/ Extract components...
                        a := bytes at: pixelIndex + RGBA_A_OFFSET_NET.
                        r := bytes at: pixelIndex + RGBA_R_OFFSET_NET.
                        g := bytes at: pixelIndex + RGBA_G_OFFSET_NET.
                        b := bytes at: pixelIndex + RGBA_B_OFFSET_NET.
                        "/ Pre-multiply
                        r := (r * a) // 255.
                        g := (g * a) // 255.
                        b := (b * a) // 255.
                        "/ Assemble pixel
                        bufferIndex := base + ((x - 1) * 4).
                        buffer at: bufferIndex + ARGB_A_OFFSET_MACHINE put: a.
                        buffer at: bufferIndex + ARGB_R_OFFSET_MACHINE put: r.
                        buffer at: bufferIndex + ARGB_G_OFFSET_MACHINE put: g.
                        buffer at: bufferIndex + ARGB_B_OFFSET_MACHINE put: b.
                    ]
                ].
                ^ self.
            ].
        ].
        photometric == #argb ifTrue:[ 
            self notYetImplemented.
            ^ self.
        ].
    ].
    ^ super bitsARGB32Into: buffer startingAt: first stride: stride

    "Created: / 28-02-2016 / 06:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-02-2016 / 14:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Depth32Image methodsFor:'accessing-pixels'!

colorAtX:x y:y
    "retrieve a pixel at x/y; return a color.
     Pixels start at x=0 , y=0 for upper left pixel, 
     end at x = width-1, y=height-1 for lower right pixel"

    |index "{ Class: SmallInteger }"
     rVal gVal bVal aVal|

    index := 1 + (((width * y) + x) * 4).
    photometric == #rgb ifTrue:[
        rVal := bytes at:(index).
        gVal := bytes at:(index + 1).
        bVal := bytes at:(index + 2).
        ^ Color redByte:rVal greenByte:gVal blueByte:bVal
    ].
    photometric == #rgba ifTrue:[
        rVal := bytes at:(index).
        gVal := bytes at:(index + 1).
        bVal := bytes at:(index + 2).
        aVal := bytes at:(index + 3).
        ^ Color redByte:rVal greenByte:gVal blueByte:bVal alphaByte:aVal
    ].
    photometric == #argb ifTrue:[
        aVal := bytes at:(index).
        rVal := bytes at:(index + 1).
        gVal := bytes at:(index + 2).
        bVal := bytes at:(index + 3).
        ^ Color redByte:rVal greenByte:gVal blueByte:bVal alphaByte:aVal
    ].

    "/ the inherited method should handle all cases.
    ^ super colorAtX:x y:y. 
!

colorAtX:x y:y put:aColor
    "set the pixel at x/y to aColor.
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel."

    |index "{ Class: SmallInteger }"|

    ((photometric == #rgba) or:[photometric == #rgb]) ifTrue:[
        index := 1 + (((width * y) + x) * 4).
        bytes at:(index) put:(aColor redByte).
        bytes at:(index + 1) put:(aColor greenByte).
        bytes at:(index + 2) put:(aColor blueByte).
        bytes at:(index + 3) put:255.               "alpha channel"
        ^ self
    ].
    (photometric == #argb) ifTrue:[
        index := 1 + (((width * y) + x) * 4).
        bytes at:(index) put:255.                   "alpha channel"
        bytes at:(index + 1) put:(aColor redByte).
        bytes at:(index + 2) put:(aColor greenByte).
        bytes at:(index + 3) put:(aColor blueByte).             
        ^ self
    ].

    super colorAtX:x y:y put:aColor. 
!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixelValue.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel.
     The pixel value contains r/g/b/a in msb order (i.e. r at high, a at low bits)"

    |pixelIndex "{ Class: SmallInteger }"|

%{  /* NOCONTEXT */
    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__isByteArrayLike(b)
     && __bothSmallInteger(x, y)
     && __isSmallInteger(w)
     && (__INST(pixelFunction)==nil) ) {
        int _idx;

        _idx = ((__intVal(w) * __intVal(y)) + __intVal(x))*4;
        if (((unsigned)(_idx+3)) < __byteArraySize(b)) {
            unsigned char *pPix = &(__ByteArrayInstPtr(b)->ba_element[_idx]);
            unsigned int _pix;
            _pix = (((((pPix[0]<<8)+pPix[1])<<8)+pPix[2])<<8)+pPix[3];
#if __POINTER_SIZE__ == 8
            RETURN( __MKSMALLINT(_pix) );
#else
            RETURN( __MKUINT(_pix) );
#endif
        }
    }
%}.
    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    pixelIndex := 1 + (((width * y) + x) * 4).

    "left pixel in high bits"
    ^ bytes unsignedInt32At:pixelIndex MSB:true.

    "Created: 24.4.1997 / 19:00:28 / cg"
    "Modified: 24.4.1997 / 23:11:05 / cg"
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |pixelIndex "{ Class: SmallInteger }"|

    pixelIndex := 1 + (((width * y) + x) * 4).
    bytes isNil ifTrue:[
        self createPixelStore
    ].
    bytes unsignedInt32At:pixelIndex put:aPixelValue MSB:true

    "Created: / 24-04-1997 / 19:00:28 / cg"
    "Modified: / 06-06-2007 / 12:20:57 / cg"
!

rowAt:y putAll:pixelArray startingAt:startIndex
    "store a single rows bits from bits in the pixelArray argument;
     Return the pixelArray.
     Notice: row coordinate starts at 0."

    |bytes dstIdx pixel 
     w "{ Class: SmallInteger }"|

    bytes := self bits.
    dstIdx := (y * self bytesPerRow) + 1.
    w := width - 1.

    0 to:w do:[:col |
        pixel := pixelArray at:(startIndex + col).
        bytes unsignedInt32At:dstIdx put:pixel MSB:true.
        dstIdx := dstIdx + 4.
    ].
    ^ pixelArray
! !

!Depth32Image methodsFor:'converting rgb images'!

computeAlphaValuesFromMask:aMaskImage
    "convert a mask into alpha values;
     masked pixels get an alpha value of 0,
     unmasked of 255"

    |alphaMask|

    alphaMask := self alphaMaskForPixelValue.
    self valuesFromX:0 y:0
                 toX:width-1 y:height-1
                  do:[:x :y :pixelValue |
        (aMaskImage pixelAtX:x y:y) ~~ 0 ifTrue:[
            self pixelAtX:x y:y put:(pixelValue bitOr:alphaMask).
        ] ifFalse:[
            self pixelAtX:x y:y put:(pixelValue bitClear:alphaMask).
        ].
    ].
    photometric := #rgba
!

rgbImageAsTrueColorFormOn:aDevice
    "return a truecolor form from the rgba or argb-picture."

    |bytes bestFormat usedDeviceDepth usedDeviceBitsPerPixel usedDevicePadding
     myDepth form imageBits padd
     rightShiftR rightShiftG rightShiftB shiftRed shiftGreen shiftBlue|

    bytes := self bits.

    bestFormat := self bestSupportedImageFormatFor:aDevice.

    usedDeviceDepth := bestFormat at:#depth.
    usedDeviceBitsPerPixel := bestFormat at:#bitsPerPixel.
    usedDevicePadding := bestFormat at:#padding.

    rightShiftR := (8 - aDevice bitsRed).
    rightShiftG := (8 - aDevice bitsGreen).
    rightShiftB := (8 - aDevice bitsBlue).

    shiftRed := aDevice shiftRed.
    shiftGreen := aDevice shiftGreen.
    shiftBlue := aDevice shiftBlue.

    "/
    "/ for now, only a few formats are supported
    "/
    myDepth := self bitsPerPixel.
    usedDeviceBitsPerPixel == 24 ifTrue:[
        "/
        "/ 24 bit/pixel
        "/
        imageBits := ByteArray uninitializedNew:(width * height * 3).
        usedDevicePadding := 8.

        "/ now, walk over the image and compose 24bit values from the r/g/b/a triples
%{
        unsigned char *srcPtr = 0;
        unsigned char *dstPtr = 0;
        int redOffs = 0;
        int greenOffs = 1;  
        int blueOffs = 2;
        int alphaOffs = 3;

        if (__INST(photometric) == @symbol(argb)) {
            redOffs = 1; greenOffs = 2; blueOffs = 3; alphaOffs = 0;
        }

        if (__isByteArrayLike(bytes)) {
            srcPtr = __ByteArrayInstPtr(bytes)->ba_element;
        } else {
            if (__isExternalBytesLike(bytes)) {
                srcPtr = __externalBytesAddress(bytes);
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
         && __bothSmallInteger(rightShiftR, shiftRed)
         && __bothSmallInteger(rightShiftG, shiftGreen)
         && __bothSmallInteger(rightShiftB, shiftBlue)
         && srcPtr
         && dstPtr) {
            int rShRed = __intVal(rightShiftR),
                rShGreen = __intVal(rightShiftG),
                rShBlue = __intVal(rightShiftB),
                lShRed = __intVal(shiftRed),
                lShGreen = __intVal(shiftGreen),
                lShBlue = __intVal(shiftBlue);
            int x, y, w;

            w = __intVal(__INST(width));
            if ((rShRed == 0) && (rShGreen == 0) && (rShBlue == 0)) {
                if ((lShRed == 0) && (lShGreen == 8) && (lShBlue == 16)) {
                    for (y=__intVal(__INST(height)); y > 0; y--) {
                        for (x=w; x > 0; x--) {                        
# ifdef __MSBFIRST
                            dstPtr[0] = srcPtr[redOffs];
                            dstPtr[1] = srcPtr[greenOffs];
                            dstPtr[2] = srcPtr[blueOffs];
# else /* not MSB */
                            dstPtr[0] = srcPtr[blueOffs];
                            dstPtr[1] = srcPtr[greenOffs];
                            dstPtr[2] = srcPtr[redOffs];
# endif /* not MSB */
                            dstPtr += 3;
                            srcPtr += 4;
                        }
                    }
                } else {
                    for (y=__intVal(__INST(height)); y > 0; y--) {
                        for (x=w; x > 0; x--) {
                            unsigned v;

                            v = srcPtr[redOffs] << lShRed;
                            v |= (srcPtr[greenOffs] << lShGreen);
                            v |= (srcPtr[blueOffs] << lShBlue);
# ifdef __MSBFIRST
                            dstPtr[0] = (v) & 0xFF;
                            dstPtr[1] = (v>>8) & 0xFF;
                            dstPtr[2] = (v>>16) & 0xFF;
# else /* not MSB */
                            dstPtr[0] = (v>>16) & 0xFF;
                            dstPtr[1] = (v>>8) & 0xFF;
                            dstPtr[2] = (v) & 0xFF;
# endif /* not MSB */
                            dstPtr += 3;
                            srcPtr += 4;
                        }
                    }
                }
            } else {
                for (y=__intVal(__INST(height)); y > 0; y--) {
                    for (x=w; x > 0; x--) {
                        unsigned r, g, b, v;

                        r = srcPtr[redOffs] >> rShRed;
                        g = srcPtr[greenOffs] >> rShGreen;
                        b = srcPtr[blueOffs] >> rShBlue;
                        v = r << lShRed;
                        v |= (g << lShGreen);
                        v |= (b << lShBlue);
# ifdef __MSBFIRST
                        dstPtr[0] = (v) & 0xFF;
                        dstPtr[1] = (v>>8) & 0xFF;
                        dstPtr[2] = (v>>16) & 0xFF;
# else /* not MSB */
                        dstPtr[0] = (v>>16) & 0xFF;
                        dstPtr[1] = (v>>8) & 0xFF;
                        dstPtr[2] = (v) & 0xFF;
# endif /* not MSB */
                        dstPtr += 3;
                        srcPtr += 4;
                    }
                }
            }
        }
%}.
    ] ifFalse:[
        "/
        "/ 8, 16 or 32 bit/pixel ...
        "/
        (usedDeviceBitsPerPixel == 16) ifTrue:[
            padd := width \\ (usedDevicePadding // 16).
            imageBits := ByteArray uninitializedNew:((width + padd) * height * 2).

            "/ now, walk over the image and compose 16bit values from the r/g/b triples

%{
            unsigned char *srcPtr = 0;
            unsigned char *dstPtr = 0;
            int redOffs = 0;
            int greenOffs = 1;  
            int blueOffs = 2;
            int alphaOffs = 3;

            if (__INST(photometric) == @symbol(argb)) {
                redOffs = 1; greenOffs = 2; blueOffs = 3; alphaOffs = 0;
            }

            if (__isByteArrayLike(bytes)) {
                srcPtr = __ByteArrayInstPtr(bytes)->ba_element;
            } else {
                if (__isExternalBytesLike(bytes)) {
                    srcPtr = __externalBytesAddress(bytes);
                }
            }
            if (__isByteArray(imageBits)) {
                dstPtr = __ByteArrayInstPtr(imageBits)->ba_element;
            } else {
                if (__isExternalBytesLike(imageBits)) {
                    dstPtr = __externalBytesAddress(imageBits);
                }
            }

            if (__bothSmallInteger(__INST(height),__INST(width))
             && __bothSmallInteger(rightShiftR, shiftRed)
             && __bothSmallInteger(rightShiftG, shiftGreen)
             && __bothSmallInteger(rightShiftB, shiftBlue)
             && srcPtr
             && dstPtr) {
                int rShRed = __intVal(rightShiftR),
                    rShGreen = __intVal(rightShiftG),
                    rShBlue = __intVal(rightShiftB),
                    lShRed = __intVal(shiftRed),
                    lShGreen = __intVal(shiftGreen),
                    lShBlue = __intVal(shiftBlue);
                int x, y, w;
                int p;

                w = __intVal(__INST(width));
                p = __intVal(padd) * 2;

                if ((rShRed == 0) && (rShGreen == 0) && (rShBlue == 0)) {
                    for (y=__intVal(__INST(height)); y > 0; y--) {
                        for (x=w; x > 0; x--) {
                            unsigned v;

                            v = srcPtr[redOffs] << lShRed;
                            v |= (srcPtr[greenOffs] << lShGreen);
                            v |= (srcPtr[blueOffs] << lShBlue);
# ifdef __MSBFIRST
                            ((short *)dstPtr)[0] = v;
# else /* not MSB */
                            dstPtr[0] = (v>>8) & 0xFF;
                            dstPtr[1] = (v) & 0xFF;
# endif /* not MSB */
                            dstPtr += 2;
                            srcPtr += 4;
                        }
                        dstPtr += p;
                    }
                } else {
                    if (p == 0) {
                        int n = __intVal(__INST(height)) * w;

                        while (n >= 2) {
                            unsigned w, r, g, b, v;

                            n -= 2;

                            r = srcPtr[redOffs];
                            g = srcPtr[greenOffs];
                            b = srcPtr[blueOffs];
                            v = (r >> rShRed) << lShRed;
                            v |= ((g >> rShGreen) << lShGreen);
                            v |= ((b >> rShBlue) << lShBlue);
# ifdef __MSBFIRST
                            ((short *)dstPtr)[0] = v;
# else
                            dstPtr[0] = (v>>8) & 0xFF;
                            dstPtr[1] = (v) & 0xFF;
# endif /* not MSB */

                            r = srcPtr[3+redOffs];
                            g = srcPtr[3+greenOffs];
                            b = srcPtr[3+blueOffs];
                            v = (r >> rShRed) << lShRed;
                            v |= ((g >> rShGreen) << lShGreen);
                            v |= ((b >> rShBlue) << lShBlue);
# ifdef __MSBFIRST
                            ((short *)dstPtr)[1] = v;
# else
                            dstPtr[2] = (v>>8) & 0xFF;
                            dstPtr[3] = (v) & 0xFF;
# endif /* not MSB */
                            dstPtr += 4;
                            srcPtr += 8;
                        }

                        while (n--) {
                            unsigned r, g, b, v;

                            r = srcPtr[redOffs] >> rShRed;
                            g = srcPtr[greenOffs] >> rShGreen;
                            b = srcPtr[blueOffs] >> rShBlue;
                            v = r << lShRed;
                            v |= (g << lShGreen);
                            v |= (b << lShBlue);
# ifdef __MSBFIRST
                            ((short *)dstPtr)[0] = v;
# else /* not MSB */
                            dstPtr[0] = (v>>8) & 0xFF;
                            dstPtr[1] = (v) & 0xFF;
# endif /* not MSB */
                            dstPtr += 2;
                            srcPtr += 4;
                        }
                    } else {
                        for (y=__intVal(__INST(height)); y > 0; y--) {
                            for (x=w; x > 0; x--) {
                                unsigned r, g, b, v;

                                r = srcPtr[redOffs] >> rShRed;
                                g = srcPtr[greenOffs] >> rShGreen;
                                b = srcPtr[blueOffs] >> rShBlue;
                                v = r << lShRed;
                                v |= (g << lShGreen);
                                v |= (b << lShBlue);
# ifdef __MSBFIRST
                                ((short *)dstPtr)[0] = v;
# else /* not MSB */
                                dstPtr[0] = (v>>8) & 0xFF;
                                dstPtr[1] = (v) & 0xFF;
# endif /* not MSB */
                                dstPtr += 2;
                                srcPtr += 4;
                            }
                            dstPtr += p;
                        }
                    }
                }
            }
%}.
        ] ifFalse:[
            "/
            "/ 32 or 8 bits/pixel ...
            "/
            (usedDeviceBitsPerPixel == 32) ifTrue:[
                usedDevicePadding := 8.
                imageBits := ByteArray uninitializedNew:(width * height * 4).

                "/ now, walk over the image and compose 32bit values from the r/g/b triples

%{
                unsigned char *srcPtr = 0;
                unsigned char *dstPtr = 0;
                int redOffs = 0;
                int greenOffs = 1;  
                int blueOffs = 2;
                int alphaOffs = 3;

                if (__INST(photometric) == @symbol(argb)) {
                    redOffs = 1; greenOffs = 2; blueOffs = 3; alphaOffs = 0;
                }

                if (__isByteArrayLike(bytes)) {
                    srcPtr = __ByteArrayInstPtr(bytes)->ba_element;
                } else {
                    if (__isExternalBytesLike(bytes)) {
                        srcPtr = __externalBytesAddress(bytes);
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
                 && __bothSmallInteger(rightShiftR, shiftRed)
                 && __bothSmallInteger(rightShiftG, shiftGreen)
                 && __bothSmallInteger(rightShiftB, shiftBlue)
                 && srcPtr
                 && dstPtr) {
                    int rShRed = __intVal(rightShiftR),
                        rShGreen = __intVal(rightShiftG),
                        rShBlue = __intVal(rightShiftB),
                        lShRed = __intVal(shiftRed),
                        lShGreen = __intVal(shiftGreen),
                        lShBlue = __intVal(shiftBlue);
                    int x, y, w;
                    
                    w = __intVal(__INST(width));
                    if ((rShRed == 0) && (rShGreen == 0) && (rShBlue == 0)) {
                        for (y=__intVal(__INST(height)); y > 0; y--) {
                            for (x=w; x > 0; x--) {
                                unsigned v;
                                
                                v = srcPtr[redOffs] << lShRed;
                                v |= (srcPtr[greenOffs] << lShGreen);
                                v |= (srcPtr[blueOffs] << lShBlue);
# ifdef __MSBFIRST
                                ((int *)dstPtr)[0] = v;
# else /* not MSB */
                                dstPtr[0] = (v>>24) & 0xFF;
                                dstPtr[1] = (v>>16) & 0xFF;
                                dstPtr[2] = (v>>8) & 0xFF;
                                dstPtr[3] = (v) & 0xFF;
# endif /* not MSB */
                                dstPtr += 4;
                                srcPtr += 4;
                            }
                        }
                    } else {
                        for (y=__intVal(__INST(height)); y > 0; y--) {
                            for (x=w; x > 0; x--) {
                                unsigned r, g, b, v;

                                r = srcPtr[redOffs] >> rShRed;
                                g = srcPtr[greenOffs] >> rShGreen;
                                b = srcPtr[blueOffs] >> rShBlue;
                                v = r << lShRed;
                                v |= (g << lShGreen);
                                v |= (b << lShBlue);
# ifdef __MSBFIRST
                                ((int *)dstPtr)[0] = v;
# else /* not MSB */
                                dstPtr[0] = (v>>24) & 0xFF;
                                dstPtr[1] = (v>>16) & 0xFF;
                                dstPtr[2] = (v>>8) & 0xFF;
                                dstPtr[3] = (v) & 0xFF;
# endif /* not MSB */
                                dstPtr += 4;
                                srcPtr += 4;
                            }
                        }
                    }
                }
%}.
            ] ifFalse:[
                "/
                "/ 8 bits/pixel ...
                "/
                (usedDeviceBitsPerPixel == 8) ifTrue:[
                    usedDevicePadding := 8.
                    imageBits := ByteArray uninitializedNew:(width * height).

                    "/ now, walk over the image and compose 8bit values from the r/g/b triples

%{
                    unsigned char *srcPtr = 0;
                    unsigned char *dstPtr = 0;
                    int redOffs = 0;
                    int greenOffs = 1;  
                    int blueOffs = 2;
                    int alphaOffs = 3;

                    if (__INST(photometric) == @symbol(argb)) {
                        redOffs = 1; greenOffs = 2; blueOffs = 3; alphaOffs = 0;
                    }

                    if (__isByteArrayLike(bytes)) {
                        srcPtr = __ByteArrayInstPtr(bytes)->ba_element;
                    } else {
                        if (__isExternalBytesLike(bytes)) {
                            srcPtr = __externalBytesAddress(bytes);
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
                     && __bothSmallInteger(rightShiftR, shiftRed)
                     && __bothSmallInteger(rightShiftG, shiftGreen)
                     && __bothSmallInteger(rightShiftB, shiftBlue)
                     && srcPtr
                     && dstPtr) {
                        int rShRed = __intVal(rightShiftR),
                            rShGreen = __intVal(rightShiftG),
                            rShBlue = __intVal(rightShiftB),
                            lShRed = __intVal(shiftRed),
                            lShGreen = __intVal(shiftGreen),
                            lShBlue = __intVal(shiftBlue);
                        int x, y, w;

                        w = __intVal(__INST(width));
                        if ((rShRed == 0) && (rShGreen == 0) && (rShBlue == 0)) {
                            for (y=__intVal(__INST(height)); y > 0; y--) {
                                for (x=w; x > 0; x--) {
                                    unsigned v;

                                    v = srcPtr[redOffs] << lShRed;
                                    v |= (srcPtr[greenOffs] << lShGreen);
                                    v |= (srcPtr[blueOffs] << lShBlue);
                                    dstPtr[0] = v;

                                    dstPtr += 1;
                                    srcPtr += 4;
                                }
                            }
                        } else {
                            for (y=__intVal(__INST(height)); y > 0; y--) {
                                for (x=w; x > 0; x--) {
                                    unsigned r, g, b, v;

                                    r = srcPtr[redOffs] >> rShRed;
                                    g = srcPtr[greenOffs] >> rShGreen;
                                    b = srcPtr[blueOffs] >> rShBlue;
                                    v = r << lShRed;
                                    v |= (g << lShGreen);
                                    v |= (b << lShBlue);

                                    dstPtr[0] = v;

                                    dstPtr += 1;
                                    srcPtr += 4;
                                }
                            }
                        }
                    }
%}.
                ]
            ].
        ]
    ].

    imageBits isNil ifTrue:[
        'IMAGE: unimplemented trueColor depth in #rgbImageAsTrueColorFormOn: ' errorPrint.
        usedDeviceBitsPerPixel errorPrintCR.
        ^ self asMonochromeFormOn:aDevice
    ].

    form := Form imageForm width:width height:height depth:usedDeviceDepth onDevice:aDevice.
    form isNil ifTrue:[
        'Depth32Image [warning]: display bitmap creation failed' errorPrintCR.
        ^ nil
    ].
    form initGC.

    form
        copyBitsFrom:imageBits
        bitsPerPixel:usedDeviceBitsPerPixel
        depth:usedDeviceDepth
        padding:usedDevicePadding
        width:width height:height
        x:0 y:0 toX:0 y:0.

    ^ form

    "Created: / 27-05-2007 / 16:54:19 / cg"
    "Modified: / 29-05-2007 / 12:19:04 / cg"
! !

!Depth32Image methodsFor:'image manipulations'!

negative
    |bytes index newImage newBytes nBytes r g b|

    photometric ~~ #rgb ifTrue:[
        ^ super negative.
    ].
    bytes := self bits.

    newImage := self copy.
    nBytes := bytes size.
    newImage bits:(newBytes := ByteArray new:nBytes).
    index := 1.
    [index < nBytes] whileTrue:[
        r := bytes at:index.
        newBytes at:index put:(255-r).
        index := index + 1.
        g := bytes at:index.
        newBytes at:index put:(255-g).
        index := index + 1.
        b := bytes at:index.
        newBytes at:index put:(255-b).
        index := index + 1.
        b := bytes at:index.
        newBytes at:index put:b.
        index := index + 1.
    ].
    ^ newImage
! !

!Depth32Image methodsFor:'initialization'!

initialize
    super initialize.
    samplesPerPixel := 4.
    bitsPerSample := #[8 8 8 8].

    "Created: / 27-05-2007 / 14:09:16 / cg"
    "Modified: / 30-01-2017 / 19:32:13 / stefan"
! !

!Depth32Image methodsFor:'magnification'!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors"

%{
    unsigned char *srcP, *dstP;
    int _mag;
    REGISTER int i;
    REGISTER unsigned char byte1, byte2, byte3, byte4;
    int _pixels;
    OBJ w = __INST(width);

    if (__bothSmallInteger(srcStart, dstStart)
     && __bothSmallInteger(w, mX)
     && __isByteArrayLike(srcBytes) && __isByteArray(dstBytes)) {
	_mag = __intVal(mX);
	srcP = __ByteArrayInstPtr(srcBytes)->ba_element - 1 + __intVal(srcStart);
	dstP = __ByteArrayInstPtr(dstBytes)->ba_element - 1 + __intVal(dstStart);
	_pixels = __intVal(w);

	while (_pixels--) {
	    byte1 = *srcP;
	    byte2 = *(srcP+1);
	    byte3 = *(srcP+2);
	    byte4 = *(srcP+3);
	    srcP += 4;
	    for (i=_mag; i>0; i--) {
		*dstP = byte1;
		*(dstP+1) = byte2;
		*(dstP+2) = byte3;
		*(dstP+3) = byte4;
		dstP += 4;
	    }
	}
	RETURN (self);
    }
%}.
    super
	magnifyRowFrom:srcBytes offset:srcStart
	into:dstBytes offset:dstStart factor:mX

    "Created: / 28-05-2007 / 15:20:52 / cg"
! !

!Depth32Image methodsFor:'queries'!

alphaBitsOf:pixel
    "given a pixel-value, return the alpha component as byteValue (0..255)"

    photometric == #rgba ifTrue:[
        "r,g,b,a"
        ^ pixel bitAnd:16rFF.
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ (pixel bitShift:-24) bitAnd:16rFF.
    ].
    photometric == #rgb ifTrue:[
        ^ 0
    ].
    self error:'unsupported photometric'
!

alphaComponentOf:pixel
    "given a pixel-value, return the alpha component in percent (0..100)"

    ^ (self alphaBitsOf:pixel) * (100.0 / 255.0)
!

alphaMaskForPixelValue
    "return the mask used with translation from pixelValues to alphaBits"

    ^ 16rFF
!

alphaShiftForPixelValue
    "return the shift amount used with translation from pixelValues to alphaBits"

    photometric == #rgba ifTrue:[
        "r,g,b,a"
        ^ 0
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ -24.
    ].
    self error:'unsupported photometric'
!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 32

    "Created: 24.4.1997 / 19:00:28 / cg"
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 32

    "Created: 24.4.1997 / 19:00:28 / cg"
!

bitsPerSample
    "return the number of bits per sample.
     The return value is an array of bits-per-plane."

    bitsPerSample notNil ifTrue:[^ bitsPerSample].
    ^ #[8 8 8 8]

    "Modified: / 30-01-2017 / 19:23:31 / stefan"
!

blueBitsOf:pixel
    "given a pixel-value, return the blue component as byteValue (0..255)"

    ((photometric == #rgba) or:[photometric == #rgb]) ifTrue:[
        "r,g,b,a"
        ^ (pixel bitShift:-8) bitAnd:16rFF.
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ pixel bitAnd:16rFF.
    ].
    self error:'unsupported photometric'
!

blueComponentOf:pixel
    "given a pixel-value, return the blue component in percent (0..100)"

    ^ (self blueBitsOf:pixel) * (100.0 / 255.0)
!

blueMaskForPixelValue
    "return the mask used with translation from pixelValues to blueBits"

    ^ 16rFF
!

blueShiftForPixelValue
    "return the shift amount used with translation from pixelValues to blueBits"

    photometric == #rgba ifTrue:[
        "r,g,b,a"
        ^ -8
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ 0.
    ].
    self error:'unsupported photometric'
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    ^ width * 4.

    "Created: 24.4.1997 / 19:00:28 / cg"
!

greenBitsOf:pixel
    "given a pixel-value, return the green component as byteValue (0..255)"

    ((photometric == #rgba) or:[photometric == #rgb]) ifTrue:[
        "r,g,b,a"
        ^ (pixel bitShift:-16) bitAnd:16rFF.
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ (pixel bitShift:-8) bitAnd:16rFF.
    ].
    self error:'unsupported photometric'
!

greenComponentOf:pixel
    "given a pixel-value, return the green component in percent (0..100)"

    ^ (self greenBitsOf:pixel) * (100.0 / 255.0)
!

greenMaskForPixelValue
    "return the mask used with translation from pixelValues to redBits"

    ^ 16rFF
!

greenShiftForPixelValue
    "return the shift amount used with translation from pixelValues to greenBits"

    photometric == #rgba ifTrue:[
        "r,g,b,a"
        ^ -16
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ -8.
    ].
    self error:'unsupported photometric'
!

hasAlphaChannel
    ^ true
!

isDepth32Image
    "return true if the image is instance of Depth32Image"
   (self bitsPerPixel == 32) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 17:00:39 / svestkap"
!

redBitsOf:pixel
    "given a pixel-value, return the red component as byteValue (0..255)"

    ((photometric == #rgba) or:[photometric == #rgb]) ifTrue:[
        "r,g,b,a"
        ^ (pixel bitShift:-24) bitAnd:16rFF.
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ (pixel bitShift:-16) bitAnd:16rFF.
    ].
    self error:'unsupported photometric'
!

redComponentOf:pixel
    "given a pixel-value, return the red component in percent (0..100)"

    ^ (self redBitsOf:pixel) * (100.0 / 255.0)
!

redMaskForPixelValue
    "return the mask used with translation from pixelValues to redBits"

    ^ 16rFF
!

redShiftForPixelValue
    "return the shift amount used with translation from pixelValues to redBits"

    photometric == #rgba ifTrue:[
        "r,g,b,a"
        ^ -24
    ].
    photometric == #argb ifTrue:[
        "a,r,g,b"
        ^ -16.
    ].
    self error:'unsupported photometric'
!

rgbFromValue:pixelValue
    "given a pixel value, return the corresponding 24bit rgbValue (rrggbb, red is MSB)."

    ^ pixelValue rightShift:8     "lsb is alpha channel"
!

samplesPerPixel
    "return the number of samples per pixel in the image."

    samplesPerPixel notNil ifTrue:[^ samplesPerPixel].
    ^ 4
!

valueFromRedBits:redBits greenBits:greenBits blueBits:blueBits
    ^ (((((redBits bitShift:8) bitOr:greenBits) bitShift:8) bitOr:blueBits) bitShift:8) bitOr:255
! !

!Depth32Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Depth32Image initialize!

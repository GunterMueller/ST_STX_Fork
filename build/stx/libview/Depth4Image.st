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

Image subclass:#Depth4Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth4Image class methodsFor:'documentation'!

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
    this class represents 16-color (4 bit / pixel) images.
    Most images coming from the windows world are represented as Depth4Images.
    It mainly consists of methods already implemented in Image,
    reimplemented here for more performance.
    Pixels for even x coordinates are stored in the left (high) nibble.
    Odd x pixels are in the right (low) nibble.
    
    [author:]
        Claus Gittinger

    [see also:]
        Depth1Image Depth2Image Depth8Image Depth16Image Depth24Image
        ImageReader
"
! !

!Depth4Image class methodsFor:'queries'!

defaultPhotometric
    "return the default photometric pixel interpretation"

    ^ #blackIs0 "/ #palette

    "Created: / 27-05-2007 / 14:04:27 / cg"
!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 4"

    ^ 4

    "Modified: 20.4.1996 / 23:40:18 / cg"
! !

!Depth4Image methodsFor:'accessing-pixels'!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixelValue.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |lineIndex "{ Class: SmallInteger }"
     byteIndex "{ Class: SmallInteger }"
     byte      "{ Class: SmallInteger }" |

    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    lineIndex := (self bytesPerRow * y) + 1.
    byteIndex := lineIndex + (x // 2).

    "left pixel in high bits"
    byteIndex > bytes size ifTrue:[
        ^ 0
    ].
    byte := bytes at:byteIndex.
    x even ifTrue:[
        ^ (byte bitShift:-4) bitAnd:16rF.
    ].
    ^ byte bitAnd:16rF.

    "Created: 24.4.1997 / 16:06:43 / cg"
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |lineIndex "{ Class: SmallInteger }"
     index     "{ Class: SmallInteger }"
     byte      "{ Class: SmallInteger }" |

    lineIndex := (self bytesPerRow * y) + 1.

    "left pixel is in high bits"
    index := lineIndex + (x // 2).
    byte := bytes at:index.
    x even ifTrue:[
        byte := (byte bitAnd:16rF) bitOr:(aPixelValue bitShift:4)
    ] ifFalse:[
        byte := (byte bitAnd:16rF0) bitOr:aPixelValue
    ].
    bytes at:index put:byte

    "Created: 24.4.1997 / 17:06:39 / cg"
!

rowAt:y into:aPixelBuffer
    "fill aBuffer with pixel values retrieved from a single row.
     Notice: row coordinate starts with 0."

    |lineIndex "{ Class: SmallInteger }"
     byte      "{ Class: SmallInteger }"
     w         "{ Class: SmallInteger }"
     pixel bytes|

    bytes := self bits.
    w := width - 1.
    lineIndex := self bytesPerRow * y.
    0 to:w do:[:x |
        x even ifTrue:[
            lineIndex := lineIndex + 1.
            byte := bytes at:lineIndex.
            pixel := (byte bitShift:-4) bitAnd:16rF.
        ] ifFalse:[
            pixel := byte bitAnd:16rF.
        ].
        aPixelBuffer at:x+1 put:pixel.
    ].

    "Created: / 21-07-1997 / 18:04:00 / cg"
    "Modified: / 30-01-2017 / 18:51:24 / stefan"
! !

!Depth4Image methodsFor:'converting images'!

anyImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for receiver.
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
            int byte;

            OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

            w = __intVal(__INST(width));
            h = __intVal(__INST(height));
            r = 0;
            p = __intVal(padd);
            nPix = w * h;
            while (nPix-- > 0) {
                unsigned idx, v;
                OBJ clr;

                if (r & 1) {
                    idx = byte & 0xF;
                } else {
                    byte = *srcPtr++;
                    idx = (byte>>4) & 0xF;
                }
                clr = ap[idx];
                v = __intVal(clr);
#ifdef __MSBFIRST
                ((short *)dstPtr)[0] = v;
#else
# ifdef xxSWAP_BYTES
                SWAP_BYTES(v);
                ((short *)dstPtr)[0] = v;
# else
                dstPtr[0] = (v>>8) & 0xFF;
                dstPtr[1] = (v) & 0xFF;
# endif
#endif
                dstPtr += 2;

                if (++r == w) {
                    dstPtr += p;
                    r = 0;
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
                int r,p;
                int byte;

                OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                w = __intVal(__INST(width));
                h = __intVal(__INST(height));
                r = 0;
                p = __intVal(padd);
                nPix = w * h;
                while (nPix > 0) {
                    unsigned idx, v;
                    OBJ clr;

                    if (r & 1) {
                        idx = byte & 0xF;
                    } else {
                        byte = *srcPtr++;
                        idx = (byte>>4) & 0xF;
                    }
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
                    nPix--;

                    if (++r == w) {
                        dstPtr += p;
                        r = 0;
                    }
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
                    int r,p, byte;

                    OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                    w = __intVal(__INST(width));
                    h = __intVal(__INST(height));
                    r = 0;
                    p = __intVal(padd);

                    nPix = w * h;
                    while (nPix > 0) {
                        unsigned idx, v;
                        OBJ clr;

                        if (r & 1) {
                            idx = byte & 0xF;
                        } else {
                            byte = *srcPtr++;
                            idx = (byte>>4) & 0xF;
                        }
                        clr = ap[idx];
                        v = __intVal(clr);

                        dstPtr[0] = v;

                        dstPtr += 1;
                        nPix--;

                        if (++r == w) {
                            dstPtr += p;
                            r = 0;
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
                        int r, p, byte;

                        OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                        w = __intVal(__INST(width));
                        h = __intVal(__INST(height));
                        r = 0;
                        p = __intVal(padd);

                        nPix = w * h;
                        while (nPix > 0) {
                            unsigned idx, v;
                            OBJ clr;

                            if (r & 1) {
                                idx = byte & 0xF;
                            } else {
                                byte = *srcPtr++;
                                idx = (byte>>4) & 0xF;
                            }
                            clr = ap[idx];
                            v = __intVal(clr);

                            dstPtr[0] = (v>>16) & 0xFF;
                            dstPtr[1] = (v>>8) & 0xFF;
                            dstPtr[2] = (v) & 0xFF;

                            dstPtr += 3;
                            nPix--;

                            if (++r == w) {
                                dstPtr += p;
                                r = 0;
                            }
                        }
                    }
%}.
                ] ifFalse:[
                    'Image [warning]: unimplemented trueColor depth in anyImageAsTrueColorFormOn: ' errorPrint. usedDeviceBitsPerPixel errorPrintCR.
                    ^ nil
                ]
            ]
        ]
    ].

    imageBits isNil ifTrue:[
        ^ nil
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
    "Modified: / 29-05-2007 / 19:22:19 / cg"
!

greyImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the grey-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super greyImageAsTrueColorFormOn:aDevice

    "Created: / 24.7.1998 / 01:21:28 / cg"
!

paletteImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the palette-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super paletteImageAsTrueColorFormOn:aDevice

    "Created: / 24.7.1998 / 01:20:46 / cg"
!

rgbImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the rgb-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super rgbImageAsTrueColorFormOn:aDevice

    "Created: / 24.7.1998 / 01:21:57 / cg"
! !

!Depth4Image methodsFor:'dither helpers'!

orderedDitheredGrayBitsWithDitherMatrix:ditherMatrix ditherWidth:dW depth:depth
    "return the bitmap for a dithered depth-bitmap from the image;
     with a constant ditherMatrix, this can be used for thresholding.
     Redefined to make use of knowing that pixels are 4-bit values."

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

    bytes := self bits.
    w := width.
    h := height.

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
    int __inByte;
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
	    if (__x & 1) {
		/* odd */
		__grey = __inByte & 0xF;
		__srcIdx++;
	    } else {
		__inByte = __bytes[__srcIdx];
		__grey = (__inByte >> 4) & 0xF;
	    }

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
     Redefined to make use of knowing that pixels are 4-bit values."

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
    int __inByte;
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

	for (__x=0; __x<__w; __x++) {
	    if (__x & 1) {
		/* odd */
		__grey = __inByte & 0xF;
		__srcIdx++;
	    } else {
		__inByte = __bytes[__srcIdx];   /* 0..255 */
		__grey = (__inByte >> 4) & 0xF;
	    }

	    __grey = __greyMap[__grey];
	    __dT = __ditherMatrix[__dY + __oX];

	    __oX++;
	    if (__oX == __dW) __oX = 0;

	    __byte = __byte << 1;
	    if (__grey > __dT) {
		__byte = __byte | 1;       /* white */
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
! !

!Depth4Image methodsFor:'enumerating'!

colorsAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixel from x1 to x2 in row y.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using atX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     byte     "{ Class: SmallInteger }"
     shift    "{ Class: SmallInteger }"
     value    "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     byteSize "{ Class: SmallInteger }"
     colorArray pixelBytes|

    pixelBytes := self bits.
    byteSize := pixelBytes size.
    colorArray := Array new:16.
    0 to:15 do:[:i | colorArray at:i+1 put:(self colorFromValue:i)].

    x1 := xLow.
    x2 := xHigh.

    srcIndex := (self bytesPerRow * y) + 1.
    srcIndex := srcIndex + (x1 // 2).
    x1 even ifTrue:[
        shift := -4
    ] ifFalse:[
        shift := 0
    ].

    byte := pixelBytes at:srcIndex.
    x1 to:x2 do:[:x |
        shift == 0 ifTrue:[
            value := byte bitAnd:16rF.
            shift := -4.
            srcIndex := srcIndex + 1.
        ] ifFalse:[
            srcIndex > byteSize ifTrue:[
                byte := 0.
            ] ifFalse:[
                byte := pixelBytes at:srcIndex.
            ].
            value := (byte bitShift:-4) bitAnd:16rF.
            shift := 0
        ].
        aBlock value:x value:(colorArray at:(value + 1)).
    ]

    "Created: / 7.6.1996 / 19:12:33 / cg"
    "Modified: / 28.7.1998 / 21:26:11 / cg"
!

valuesAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixelValue from x1 to x2 in row y.
     The block is passed the pixelValue at each pixel.
     This method allows slighly faster processing of an
     image than using valueAtX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex   "{ Class: SmallInteger }"
     shift      "{ Class: SmallInteger }"
     pixelValue "{ Class: SmallInteger }"
     x1         "{ Class: SmallInteger }"
     x2         "{ Class: SmallInteger }"
     bytes|

    bytes := self bits.

    x1 := xLow.
    x2 := xHigh.
    srcIndex := (self bytesPerRow * y) + 1.
    srcIndex := srcIndex + (x1 // 2).
    x1 even ifTrue:[
        shift := -4
    ] ifFalse:[
        shift := 0
    ].

    x1 to:x2 do:[:x |
        pixelValue := bytes at:srcIndex.
        shift == 0 ifTrue:[
            shift := -4.
            srcIndex := srcIndex + 1.
        ] ifFalse:[
            pixelValue := pixelValue bitShift:-4.
            shift := 0
        ].
        aBlock value:x value:(pixelValue bitAnd:16rF).
    ]

    "Created: / 07-06-1996 / 19:09:45 / cg"
    "Modified (format): / 30-01-2017 / 20:41:31 / stefan"
! !

!Depth4Image methodsFor:'magnification'!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors.
     Specially tuned for factor 2."

%{
    unsigned char *srcP, *dstP;
    int _mag;
    REGISTER int i;
    REGISTER unsigned char _byte;
    int _pixels;
    REGISTER int outcnt, bits, bit;
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
		_byte = *srcP++;
		while (_pixels) {
		    bit = (_byte >> 4) & 0xF;
		    bits = (bit << 4) | bit;
		    *dstP++ = bits;

		    if (--_pixels) {
			bit = _byte & 0xF;
			bits = (bit << 4) | bit;
			*dstP++ = bits;
			_byte = *srcP++;
			_pixels--;
		    }
		}
		break;

	    default:
		bits = 0, outcnt = 0;
		_byte = *srcP++;
		while (_pixels) {
		    bit = (_byte >> 4) & 0xF;

		    for (i=_mag; i>0; i--) {
			bits = (bits << 4) | bit;
			outcnt++;
			if (outcnt == 2) {
			    *dstP++ = bits;
			    bits = 0;
			    outcnt = 0;
			}
		    }

		    if (--_pixels) {
			bit = _byte & 0xF;
			for (i=_mag; i>0; i--) {
			    bits = (bits << 4) | bit;
			    outcnt++;
			    if (outcnt == 2) {
				*dstP++ = bits;
				bits = 0;
				outcnt = 0;
			    }
			}
			_byte = *srcP++;
			_pixels--;
		    }
		}
		if (outcnt) {
		    *dstP = bits << 4;
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

!Depth4Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 4
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 4
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    |nbytes|

    nbytes := width // 2.
    width odd ifTrue:[
	^ nbytes + 1
    ].
    ^ nbytes
!

colorFromValue:pixelValue
    "given a pixel value, return the corresponding color.
     Pixel values start with 0."

    photometric == #whiteIs0 ifTrue:[
	^ Color gray:100 - (100 / 15 * pixelValue)
    ].
    photometric == #blackIs0 ifTrue:[
	^ Color gray:(100 / 15 * pixelValue)
    ].
    photometric == #palette ifTrue:[
	pixelValue < colorMap size ifTrue:[
	    ^ colorMap at:(pixelValue + 1)
	]
    ].
    ^ super colorFromValue:pixelValue
!

isDepth4Image
    "return true if the image is instance of Depth4Image"
   (self bitsPerPixel == 4) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 17:01:45 / svestkap"
!

usedValues
    "return a collection of color values used in the receiver."

    |useFlags usedValues 
     h "{ Class: SmallInteger }"
     w "{ Class: SmallInteger }" |

    useFlags := Array new:16 withAll:false.
    w := width.
    h := height.

    w even ifFalse:[
        0 to:h-1 do:[:y |
            self valuesAtY:y from:0 to:w-1 do:[:x :pixel |
                useFlags at:(pixel + 1) put:true
            ]
        ].
    ] ifTrue:[
        self bits usedValues do:[:byte |
            useFlags at:(byte bitShift:-4)+1 put:true.
            useFlags at:(byte bitAnd:2r1111)+1 put:true.
        ].
    ].
    ^ (0 to:15) select:[:i | useFlags at:(i+1)].

"/    usedValues := OrderedCollection new.
"/    1 to:16 do:[:i | (useFlags at:i) ifTrue:[usedValues add:(i-1)]].
"/    ^ usedValues

    "Modified: / 24.8.1998 / 13:56:59 / cg"
! !

!Depth4Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


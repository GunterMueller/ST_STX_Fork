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

Image subclass:#Depth2Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth2Image class methodsFor:'documentation'!

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
    this class represents four-color (2 bit / pixel) images
    (as used mainly on the NeXT).
    It mainly consists of methods already implemented in Image,
    reimplemented here for more performance.

    #blackIs0 / #whiteIs0 and #palette formats are supported here.

    [author:]
	Claus Gittinger

    [see also:]
	Depth1Image Depth4Image Depth8Image Depth16Image Depth24Image
	ImageReader
"
! !

!Depth2Image class methodsFor:'queries'!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 2"

    ^ 2

    "Modified: 20.4.1996 / 23:40:12 / cg"
! !

!Depth2Image methodsFor:'accessing-pixels'!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixel value.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |lineIndex "{ Class: SmallInteger }"
     byte      "{ Class: SmallInteger }"
     shift     "{ Class: SmallInteger }" |

    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    lineIndex := (self bytesPerRow * y) + 1.

    "left pixel in high bits"
    byte := bytes at:(lineIndex + (x // 4)).
    shift := #(-6 -4 -2 0) at:((x \\ 4) + 1).
    ^ (byte bitShift:shift) bitAnd:3.

    "Created: 24.4.1997 / 16:06:39 / cg"
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |lineIndex "{ Class: SmallInteger }"
     index     "{ Class: SmallInteger }"
     byte      "{ Class: SmallInteger }"
     shift     "{ Class: SmallInteger }" |

    lineIndex := (self bytesPerRow * y) + 1.

    "left pixel is in high bits"
    index := lineIndex + (x // 4).
    byte := bytes at:index.
    shift := #[6 4 2 0] at:((x \\ 4) + 1).
    byte := (byte bitAnd:(3 bitShift:shift) bitInvert) bitOr:(aPixelValue bitShift:shift).
    bytes at:index put:byte

    "Created: / 24-04-1997 / 17:06:36 / cg"
    "Modified: / 30-01-2017 / 19:22:33 / stefan"
! !

!Depth2Image methodsFor:'converting images'!

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
            int byte, shift;

            OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

            w = __intVal(__INST(width));
            h = __intVal(__INST(height));
            r = 0;
            p = __intVal(padd);

            nPix = w * h;
            shift = -2;
            while (nPix-- > 0) {
                unsigned idx, v;
                OBJ clr;

                if (shift < 0) {
                    byte = *srcPtr++;
                    shift = 6;
                }
                idx = (byte >> shift) & 3;
                shift -= 2;

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
                    shift = -2;
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
                int byte, shift;

                OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                w = __intVal(__INST(width));
                h = __intVal(__INST(height));
                r = 0;
                p = __intVal(padd);

                nPix = w * h;
                shift = -2;
                while (nPix > 0) {
                    unsigned idx, v;
                    OBJ clr;

                    if (shift < 0) {
                        byte = *srcPtr++;
                        shift = 6;
                    }
                    idx = (byte >> shift) & 3;
                    shift -= 2;

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
                        shift = -2;
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
                    int r,p, byte, shift;

                    OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                    w = __intVal(__INST(width));
                    h = __intVal(__INST(height));
                    r = 0;
                    p = __intVal(padd);

                    nPix = w * h;
                    shift = -2;
                    while (nPix > 0) {
                        unsigned idx, v;
                        OBJ clr;

                        if (shift < 0) {
                            byte = *srcPtr++;
                            shift = 6;
                        }
                        idx = (byte >> shift) & 3;
                        shift -= 2;

                        clr = ap[idx];
                        v = __intVal(clr);

                        dstPtr[0] = v;

                        dstPtr += 1;
                        nPix--;

                        if (++r == w) {
                            dstPtr += p;
                            r = 0;
                            shift = -2;
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
                        int r, p, byte, shift;

                        OBJ *ap = __ArrayInstPtr(colorValues)->a_element;

                        w = __intVal(__INST(width));
                        h = __intVal(__INST(height));
                        r = 0;
                        p = __intVal(padd);

                        nPix = w * h;
                        shift = -2;
                        while (nPix > 0) {
                            unsigned idx, v;
                            OBJ clr;

                            if (shift < 0) {
                                byte = *srcPtr++;
                                shift = 6;
                            }
                            idx = (byte >> shift) & 3;
                            shift -= 2;

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
                                shift = -2;
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
    "Modified: / 29-05-2007 / 19:22:29 / cg"
!

greyImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the grey-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super greyImageAsTrueColorFormOn:aDevice

    "Created: / 28.7.1998 / 16:57:32 / cg"
!

paletteImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the palette-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super paletteImageAsTrueColorFormOn:aDevice

    "Created: / 28.7.1998 / 16:57:47 / cg"
!

rgbImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the rgb-image receiver.
     Supports true color devices with depths: 8, 16, 24 and 32"

    |f|

    f := self anyImageAsTrueColorFormOn:aDevice.
    f notNil ifTrue:[^ f].
    ^ super rgbImageAsTrueColorFormOn:aDevice

    "Created: / 28.7.1998 / 16:58:01 / cg"
! !

!Depth2Image methodsFor:'dither helpers'!

orderedDitheredMonochromeBitsWithDitherMatrix:ditherMatrix ditherWidth:dW
    "return the dithered monochrome bits for the receiver image;
     with a constant ditherMatrix, this can be used for thresholding.
     Redefined to make use of knowing that pixels are 2-bit values."

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
	    if ((__x & 3) == 0) {
		__inByte = __bytes[__srcIdx];   /* 0..255 */
		__srcIdx++;
	    } else {
		__inByte = __inByte << 2;
	    }
	    __grey = (__inByte >> 6) & 3;

	    __grey = __greyMap[__grey];
	    __dT = __ditherMatrix[__dY + __oX];

	    __oX++;
	    if (__oX == __dW) __oX = 0;

	    __byte = __byte << 1;
	    if (__grey > __dT) {
		__byte = __byte | 1;             /* white */
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

!Depth2Image methodsFor:'enumerating'!

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
     color0 color1 color2 color3 bytes|

    bytes := self bits.

    color0 := self colorFromValue:0.
    color1 := self colorFromValue:1.
    color2 := self colorFromValue:2.
    color3 := self colorFromValue:3.

    "left pixel in high bits"

    x1 := xLow.
    x2 := xHigh.

    srcIndex := (self bytesPerRow * y) + 1.
    srcIndex := srcIndex + (x1 // 4).
    shift := #(-6 -4 -2 0) at:((x1 \\ 4) + 1).

    byte := bytes at:srcIndex.
    x1 to:x2 do:[:x |
	|clr|

	value := (byte bitShift:shift) bitAnd:3.

	(value == 0) ifTrue:[
	    clr := color0
	] ifFalse:[
	    (value == 1) ifTrue:[
		clr := color1
	    ] ifFalse:[
		(value == 2) ifTrue:[
		    clr := color2
		] ifFalse:[
		    clr := color3
		]
	    ]
	].
	aBlock value:x value:clr.

	shift == 0 ifTrue:[
	    shift := -6.
	    srcIndex := srcIndex + 1.
	    x < x2 ifTrue:[
		byte := bytes at:srcIndex.
	    ]
	] ifFalse:[
	    shift := shift + 2.
	]
    ].

    "Created: 7.6.1996 / 19:12:31 / cg"
    "Modified: 10.6.1996 / 10:32:47 / cg"
!

valuesAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixelValue from x1 to x2 in row y.
     The block is passed the x coordinate and the pixelValue at each pixel.
     This method allows slighly faster processing of an
     image than using valueAtX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     byte     "{ Class: SmallInteger }"
     shift    "{ Class: SmallInteger }"
     value    "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     bytes|

    bytes := self bits.

    "left pixel in high bits"

    x1 := xLow.
    x2 := xHigh.

    srcIndex := (self bytesPerRow * y) + 1.
    srcIndex := srcIndex + (x1 // 4).
    shift := #(-6 -4 -2 0) at:((x1 \\ 4) + 1).

    byte := bytes at:srcIndex.
    x1 to:x2 do:[:x |
	value := (byte bitShift:shift) bitAnd:3.

	aBlock value:x value:value.

	shift == 0 ifTrue:[
	    shift := -6.
	    srcIndex := srcIndex + 1.
	    x < x2 ifTrue:[
		byte := bytes at:srcIndex.
	    ]
	] ifFalse:[
	    shift := shift + 2.
	]
    ].

    "Created: 7.6.1996 / 19:09:42 / cg"
    "Modified: 8.6.1996 / 13:36:28 / cg"
! !

!Depth2Image methodsFor:'magnification'!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors"

%{
    unsigned char *srcP, *dstP;
    int _mag;
    REGISTER int i;
    REGISTER unsigned char _byte;
    int _pixels;
    REGISTER int outcnt, bits, bit, mask, incnt;
    int shift;
    OBJ w = __INST(width);

    /* helper for two-plane magnification by 2
     * 0000 -> 0000 0000
     * 0001 -> 0000 0101
     * ...
     * 1111 -> 1111 1111
     */
    static unsigned char mag2[16] = {0x00, 0x05, 0x0a, 0x0f, 0x50, 0x55, 0x5a, 0x5f,
				     0xa0, 0xa5, 0xaa, 0xaf, 0xf0, 0xf5, 0xfa, 0xff};
    /* helper for two-plane magnification by 4 */
    static unsigned char mag4[16] = {0x00, 0x55, 0xaa, 0xff};

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
		 /* tuned for this common case */
		 while (_pixels > 2) {
		     _byte = *srcP++;
		     *dstP++ = mag2[ _byte >> 4 ];
		     *dstP++ = mag2[ _byte & 0x0F ];
		     _pixels -= 4;
		 }
		 while (_pixels > 0) {
		     _byte = *srcP++;
		     *dstP++ = mag2[ _byte >> 4 ];
		     if (_pixels > 2) {
			 *dstP++ = mag2[ _byte & 0x0F ];
		     }
		     _pixels -= 4;
		 }
		 break;

	     case3:
		 /* tuned for this common case */
		 bits = 0, incnt = 0, outcnt = 0;
		 shift = 6;
		 _byte = *srcP++;
		 while (_pixels--) {
		     bit = (_byte >> shift) & 3;
		     incnt++;
		     if (incnt == 4) {
			 incnt = 0;
			 shift = 6;
			 _byte = *srcP++;
		     } else {
			 shift -= 2;
		     }

		     switch (outcnt) {
			 case 0:
			     /* next three pixels */
			     bits = (((bit << 2) | bit) << 2) | bit;
			     outcnt = 3;
			     break;

			 case 1:
			     /* next three pixels & store */
			     bits = (((((bits << 2) | bit) << 2) | bit) << 2) | bit;
			     *dstP++ = bits;
			     outcnt = 0;
			     break;

			 case 2:
			     /* next two pixels & store */
			     bits = (((bits << 2) | bit) << 2) | bit;
			     *dstP++ = bits;
			     bits = bit;
			     outcnt = 1;
			     break;

			  case 3:
			     /* next pixel & store */
			     bits = (bits << 2) | bit;
			     *dstP++ = bits;
			     bits = (bit << 2) | bit;
			     outcnt = 2;
			     break;
		      }
		 }
		 if (outcnt) {
		     *dstP = bits << ((4-outcnt)*2);
		 }
		 break;

	     case 4:
		 /* tuned for this common case */
		 incnt = 0;
		 shift = 6;
		 _byte = *srcP++;
		 while (_pixels--) {
		     bit = (_byte >> shift) & 3;
		     incnt++;
		     if (incnt == 4) {
			 incnt = 0;
			 shift = 6;
			 _byte = *srcP++;
		     } else {
			 shift -= 2;
		     }
		     *dstP++ = mag4[bit];
		 }
		 break;

	     default:
		 bits = 0, incnt = 0, outcnt = 0;
		 shift = 6;
		 _byte = *srcP++;
		 while (_pixels--) {
		     bit = (_byte >> shift) & 3;
		     incnt++;
		     if (incnt == 4) {
			 incnt = 0;
			 shift = 6;
			 _byte = *srcP++;
		     } else {
			 shift -= 2;
		     }

		     for (i=_mag; i>0; i--) {
			 bits = (bits << 2) | bit;
			 outcnt++;
			 if (outcnt == 4) {
			     *dstP++ = bits;
			     bits = 0;
			     outcnt = 0;
			 }
		     }
		 }
		 if (outcnt) {
		     *dstP = bits << ((4-outcnt)*2);
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

!Depth2Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 2
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 2
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    |nbytes|

    nbytes := width // 4.
    ((width \\ 4) ~~ 0) ifTrue:[
	^ nbytes + 1
    ].
    ^ nbytes
!

colorFromValue:colorValue
    "given a pixel value, return the corresponding color.
     Pixel values start with 0."

    |p value|

    value := colorValue.
    p := photometric.

    p == #whiteIs0 ifTrue:[
	value := 3 - value.
	p := #blackIs0
    ].
    p == #blackIs0 ifTrue:[
	(value == 0) ifTrue:[
	    ^ Color black
	].
	(value == 3) ifTrue:[
	    ^ Color white
	].
	^ Color gray:(value == 1 ifTrue:33 ifFalse:67)
    ].

    p == #palette ifTrue:[
	value < colorMap size ifTrue:[
	    ^ colorMap at:(value+1).
	].
    ].
    ^ super colorFromValue:colorValue.
!

isDepth2Image
    "return true if the image is instance of Depth2Image"
   (self bitsPerPixel == 2) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 17:02:16 / svestkap"
!

usedColors
    "return a collection of colors used in the receiver.
     For depth2 images, we return the colorMap here, assuming all
     pixels are used ...
     ... which is not really true - not all colors need to be"

    (photometric == #whiteIs0 or:[photometric == #blackIs0]) ifTrue:[
        ^ Array with:(Color black)
                with:(Color gray:33)
                with:(Color gray:67)
                with:(Color white).
    ].
    photometric == #palette ifTrue:[
        ^ colorMap
    ].
    ^ super usedColors

    "Modified: / 24.8.1998 / 18:38:08 / cg"
!

usedValues
    "return a collection of color values used in the receiver.
     For depth2 images, we assume all pixel values are present ...
     ... which is not really true"

    "actually, this is wrong - we have to look if those are
     really used. However, assume that we don't care for
     those extra colors here ..."

    ^ #[0 1 2 3]

    "Modified: / 28-07-1998 / 22:23:15 / cg"
    "Modified: / 30-01-2017 / 19:23:07 / stefan"
! !

!Depth2Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


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

Image subclass:#Depth24Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth24Image class methodsFor:'documentation'!

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
    this class represents true-color (24 bit / pixel) images.
    It mainly consists of methods already implemented in Image,
    reimplemented here for more performance.

    Only the #rgb format is supported here.

    [author:]
	Claus Gittinger

    [see also:]
	Depth1Image Depth2Image Depth4Image Depth8Image Depth16Image
	ImageReader
"
! !

!Depth24Image class methodsFor:'queries'!

defaultPhotometric
    "return the default photometric pixel interpretation"

    ^ #rgb

    "Created: 10.6.1996 / 18:08:25 / cg"
!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 24"

    ^ 24

    "Modified: 20.4.1996 / 23:39:50 / cg"
! !

!Depth24Image methodsFor:'accessing-pixels'!

colorAtX:x y:y
    "retrieve a pixel at x/y; return a color.
     Pixels start at x=0 , y=0 for upper left pixel,
     end at x = width-1, y=height-1 for lower right pixel"

    |rgbVal|

    photometric == #rgb ifTrue:[
        rgbVal := self pixelAtX:x y:y.
        ^ Color rgbValue:rgbVal.
    ].
    "/ the inherited method should handle all cases.
    ^ super colorAtX:x y:y.
!

colorAtX:x y:y put:aColor
    "set the pixel at x/y to aColor.
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel."

    photometric ~~ #rgb ifTrue:[^ super colorAtX:x y:y put:aColor].
    self pixelAtX:x y:y put:aColor rgbValue.

    "Created: 24.4.1997 / 17:32:59 / cg"
!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixel value.
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel.
     The pixel value contains r/g/b in msb order (i.e. r at high, b at low bits)"

    |index "{ Class: SmallInteger }"
     rVal  "{ Class: SmallInteger }"
     gVal  "{ Class: SmallInteger }"
     bVal  "{ Class: SmallInteger }"|

%{  /* NOCONTEXT */
    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__isByteArrayLike(b)
     && __bothSmallInteger(x, y)
     && __isSmallInteger(w)
     && (__INST(pixelFunction)==nil) ) {
	int _idx;

	_idx = ((__intVal(w) * __intVal(y)) + __intVal(x))*3;
	if (((unsigned)(_idx+2)) < __byteArraySize(b)) {
	    unsigned char *pPix = &(__ByteArrayInstPtr(b)->ba_element[_idx]);
	    unsigned int _pix;
	    _pix = (((pPix[0]<<8)+pPix[1])<<8)+pPix[2];
	    RETURN( __MKSMALLINT(_pix) );
	}
    }
%}.
    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    index := 1 + (((width * y) + x) * 3).
    rVal := bytes at:(index).
    gVal := bytes at:(index + 1).
    bVal := bytes at:(index + 2).
    ^ (((rVal bitShift:8) bitOr:gVal) bitShift:8) bitOr:bVal

    "Created: 24.4.1997 / 16:06:34 / cg"
!

pixelAtX:x y:y put:aPixelValue
    "set a pixel at x/y to aPixelValue, which is 24 bits RGB.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |index "{ Class: SmallInteger }"
     val   "{ Class: SmallInteger }"|

%{  /* NOCONTEXT */
    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__isByteArrayLike(b)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(w, aPixelValue)
     && (__INST(pixelFunction)==nil) ) {
	int _idx;

	_idx = ((__intVal(w) * __intVal(y)) + __intVal(x))*3;
	if (((unsigned)(_idx+2)) < __byteArraySize(b)) {
	    unsigned char *pPix = &(__ByteArrayInstPtr(b)->ba_element[_idx]);
	    unsigned int _pix = __intVal(aPixelValue);
	    pPix[0] = (_pix>>16) & 0xFF;
	    pPix[1] = (_pix>>8) & 0xFF;
	    pPix[2] = (_pix) & 0xFF;
	    RETURN( self );
	}
    }
%}.
    index := 1 + (((width * y) + x) * 3).
    val := aPixelValue.
    bytes at:(index + 2) put:(val bitAnd:16rFF).
    val := val bitShift:-8.
    bytes at:(index + 1) put:(val bitAnd:16rFF).
    val := val bitShift:-8.
    bytes at:(index) put:val.
!

rgbValueAtX:x y:y
    "retrieve a pixels rgb value at x/y; return a 24bit rgbValue (rrggbb, red is MSB).
     Pixels start at 0@0 for upper left pixel, end at (width-1)@(height-1) for lower right pixel."

    ^ self pixelAtX:x y:y.
!

rowAt:y putAll:pixelArray startingAt:startIndex
    "store a single rows bits from bits in the pixelArray argument;
     Return the pixelArray.
     Notice: row coordinate starts at 0."

    |bytes dstIdx pixel|

    bytes := self bits.
    dstIdx := (y * self bytesPerRow) + 1.
    0 to:width-1 do:[:col |
	pixel := pixelArray at:(startIndex + col).
	bytes at:dstIdx put:((pixel bitShift:-16) bitAnd:16rFF).
	bytes at:dstIdx+1 put:((pixel bitShift:-8) bitAnd:16rFF).
	bytes at:dstIdx+2 put:(pixel bitAnd:16rFF).
	dstIdx := dstIdx + 3.
    ].
    ^ pixelArray

    "Created: 24.4.1997 / 15:50:27 / cg"
! !

!Depth24Image methodsFor:'converting rgb images'!

asGrayFormOn:aDevice
    "return a grey form from the receiver.
     Redefined to use special code when converting to 8-bit
     greyScale displays."

    (aDevice visualType == #StaticGray) ifTrue:[
	aDevice depth == 8 ifTrue:[
	    ^ self makeDeviceGrayPixmapOn:aDevice depth:aDevice depth fromArray:(self threshold8BitGrayBits)
	].
    ].
    ^ super asGrayFormOn:aDevice

    "Created: 10.6.1996 / 19:00:45 / cg"
    "Modified: 10.6.1996 / 20:10:19 / cg"
!

asThresholdGrayImageDepth:depth
    "return an 8-bit grey image from the rgb picture.
     Pixel values are reduced to a 0..255 grey level."

    depth == 8 ifTrue:[
	photometric == #rgb ifTrue:[
	    ^ Depth8Image
		width:width
		height:height
		fromArray:(self threshold8BitGrayBits)
	]
    ].
    ^ super asThresholdGrayImageDepth:depth

    "
     |i|

     i := Image fromFile:'bitmaps/granite.tiff'.
     (i asThresholdGrayImageDepth:8) inspect.
     (i asThresholdGrayImageDepth:4) inspect.
     (i asThresholdGrayImageDepth:2) inspect.
     (i asThresholdGrayImageDepth:1) inspect.
    "

    "
     |i|

     i := Image fromFile:'bitmaps/granite.tiff'.
     ((i asThresholdGrayImageDepth:8) asOrderedDitheredGrayImageDepth:2) inspect
    "

    "
     |i|

     i := Image fromFile:'bitmaps/granite.tiff'.
     ((i asThresholdGrayImageDepth:8) asOrderedDitheredGrayImageDepth:4) inspect
    "

    "
     |i|

     i := Image fromFile:'bitmaps/granite.tiff'.
     (i asThresholdGrayImageDepth:8) asOrderedDitheredMonochromeImage inspect
    "

    "Created: 8.6.1996 / 13:58:46 / cg"
    "Modified: 10.6.1996 / 19:11:18 / cg"
!

rgbImageAsDitheredPseudoFormOn:aDevice
    "return a dithered pseudocolor form from the rgb-picture.
     This method depends on fixColors being allocated (see Color>>getColors*)"

    |ditherColors|

    (ditherColors := aDevice fixColors) notNil ifTrue:[
	^ self
		rgbImageAsDitheredPseudoFormOn:aDevice
		colors:ditherColors
		nRed:aDevice numFixRed
		nGreen:aDevice numFixGreen
		nBlue:aDevice numFixBlue
    ].

    ditherColors := Set new.
    ditherColors addAll:(aDevice ditherColors).
    ditherColors addAll:(aDevice deviceColors).
    ditherColors := ditherColors asArray.
    ^ self
	rgbImageAsDitheredPseudoFormOn:aDevice
	colors:ditherColors.

    "Modified: 22.4.1997 / 11:59:44 / cg"
!

rgbImageAsDitheredPseudoFormOn:aDevice colors:fixColors
    "return a dithered 8-bit pseudocolor form from the rgb-picture, using
     arbitrary fix colors in fixColors."

    |pseudoBits f
     h        "{ Class: SmallInteger }"
     w        "{ Class: SmallInteger }"
     numFix   "{Class: SmallInteger }" deviceDepth
     fixIds fixRed fixGreen fixBlue failed cache idsUsed usedColors
     fixColorArray|

    numFix := fixColors size.
    numFix == 256 ifTrue:[
        "/ algorithm below only handles 255 colors.
        numFix := 255.
    ].

    fixColorArray := fixColors asArray.
    fixIds := (fixColorArray collect:[:clr | clr colorId]) asByteArray.

    fixRed := (fixColorArray collect:[:clr | clr redByte]) asByteArray.
    fixGreen := (fixColorArray collect:[:clr | clr greenByte]) asByteArray.
    fixBlue := (fixColorArray collect:[:clr | clr blueByte]) asByteArray.

    cache := ByteArray new:(1 bitShift:14).
    cache atAllPut:16rFF.

    deviceDepth := aDevice depth.
    deviceDepth == 8 ifFalse:[
        (aDevice supportedImageFormatForDepth:8) isNil ifTrue:[
            ^ nil
        ]
    ].

    idsUsed := ByteArray new:(fixIds size).

    'Depth24Image [info]: dithering ...' infoPrintCR.

    pseudoBits := ByteArray uninitializedNew:(width * height).

    h := height.
    w := width.

%{
    int __x, __y, __numFix;
    int __eR, __eG, __eB;
    unsigned char *srcP, *dstP;
    int pix;
    unsigned char *idP, *usedIdP, *redP, *greenP, *blueP, *cacheP;
    int __w = __intVal(w);

    if (__isByteArrayLike(__INST(bytes))
     && __isSmallInteger(numFix)
     && __isByteArrayLike(pseudoBits)
     && __isByteArrayLike(cache)
     && __isByteArrayLike(fixIds)
     && __isByteArrayLike(idsUsed)
     && __isByteArrayLike(fixRed)
     && __isByteArrayLike(fixGreen)
     && __isByteArrayLike(fixBlue) ) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        idP = __ByteArrayInstPtr(fixIds)->ba_element;
        usedIdP = __ByteArrayInstPtr(idsUsed)->ba_element;
        redP = __ByteArrayInstPtr(fixRed)->ba_element;
        greenP = __ByteArrayInstPtr(fixGreen)->ba_element;
        blueP = __ByteArrayInstPtr(fixBlue)->ba_element;
        cacheP = __ByteArrayInstPtr(cache)->ba_element;
        __numFix = __intVal(numFix);

        for (__y=__intVal(h); __y>0; __y--) {
            __eR = __eG = __eB = 0;
            for (__x=__w; __x>0; __x--) {
                int cacheIdx, clrIdx;
                int __wantR, __wantG, __wantB;

                __wantR = srcP[0] + __eR;
                if (__wantR > 255) __wantR = 255;
                else if (__wantR < 0) __wantR = 0;

                __wantG = srcP[1] + __eG;
                if (__wantG > 255) __wantG = 255;
                else if (__wantG < 0) __wantG = 0;

                __wantB = srcP[2] + __eB;
                if (__wantB > 255) __wantB = 255;
                else if (__wantB < 0) __wantB = 0;

                /*
                 * compute cache index
                 */
                cacheIdx = ((__wantR & 0xF8) >> 3);
                cacheIdx = (cacheIdx << 5) | ((__wantG & 0xF8) >> 3);
                cacheIdx = (cacheIdx << 4) | ((__wantB & 0xF0) >> 4);

                clrIdx = cacheP[cacheIdx];
                if (clrIdx == 0xFF) {   /* invalid slot */
                    unsigned minErr, minIdx;
                    int i;

                    /*
                     * must search ...
                     */
                    minErr = 0x7FFFFFF; minIdx = 0;
                    for (i=0; i<__numFix; i++) {
                        unsigned cR, cG, cB, e;
                        int eR, eG, eB;

                        cR = redP[i]; cG = greenP[i]; cB = blueP[i];
                        eR = cR - __wantR;
                        if (eR < 0) eR = -eR;

                        eG = cG - __wantG;
                        if (eG < 0) eG = -eG;

                        eB = cB - __wantB;
                        if (eB < 0) eB = -eB;

                        e = eR + eG + eB;
                        if (e < minErr) {
                            minErr = e;
                            minIdx = i;
                            if (e < 7) {
                                break;
                            }
                        }
                    }

                    /*
                     * minIdx is now index into fixColors
                     */
                    cacheP[cacheIdx] = clrIdx = minIdx;
/*
console_fprintf(stderr, "want %d/%d/%d best: %d [%d/%d/%d]\n", __wantR, __wantG, __wantB, clrIdx, redP[clrIdx], greenP[clrIdx], blueP[clrIdx]);
*/
                }

                /*
                 * store the corresponding dither colorId
                 */
                *dstP++ = idP[clrIdx];
                usedIdP[clrIdx] = 1;

                srcP += 3;

                /*
                 * the new error:
                 */
                __eR = __wantR - redP[clrIdx];
                __eG = __wantG - greenP[clrIdx];
                __eB = __wantB - blueP[clrIdx];
            }
        }
    }
%}.
    failed ifTrue:[
        self primitiveFailed.
        ^ nil
    ].

    "/ not all colors may be really in use ...
    usedColors := fixColors copy.
    idsUsed keysAndValuesDo:[:idx :flag |
        flag == 0 ifTrue:[
            usedColors at:idx put:nil
        ]
    ].

    f := Form imageForm width:width height:height depth:aDevice depth onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f colorMap:usedColors.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:8
        depth:aDevice depth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id)
        x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f
!

rgbImageAsDitheredPseudoFormOn:aDevice colors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue
    "return a dithered pseudocolor form from the rgb-picture,
     using colors from a colorCube for dithering."

    |pseudoBits f
     h        "{ Class: SmallInteger }"
     w        "{ Class: SmallInteger }"
"/     eR    "{Class: SmallInteger }"
"/     eG    "{Class: SmallInteger }"
"/     eB    "{Class: SmallInteger }"
"/     wantR "{Class: SmallInteger }"
"/     wantG "{Class: SmallInteger }"
"/     wantB "{Class: SmallInteger }"
     fixR  "{Class: SmallInteger }"
     fixG  "{Class: SmallInteger }"
     fixB  "{Class: SmallInteger }"
     deviceDepth
     fixIds idsUsed failed usedColors|

    fixR := nRed.
    fixR == 0 ifTrue:[ ^ nil].
    fixG := nGreen.
    fixG == 0 ifTrue:[ ^ nil].
    fixB := nBlue.
    fixB == 0 ifTrue:[ ^ nil].
    "/ simple check
    (fixR * fixG * fixB) ~~ fixColors size ifTrue:[
        self error:'invalid color array passed'.
        ^ nil
    ].
    fixIds := (fixColors asArray collect:[:clr | clr colorId]) asByteArray.
    idsUsed := ByteArray new:(fixIds size).

    deviceDepth := aDevice depth.
    deviceDepth == 8 ifFalse:[
        (aDevice supportedImageFormatForDepth:8) isNil ifTrue:[
            ^ nil
        ]
    ].

    'Depth24Image [info]: dithering ...' infoPrintCR.

    pseudoBits := ByteArray uninitializedNew:(width * height).

    h := height.
    w := width.

%{
    int __x, __y;
    int __eR, __eG, __eB;
    int __wantR, __wantG, __wantB;
    unsigned char *srcP, *dstP;
    unsigned char *redP, *greenP, *blueP;
    int pix;
    unsigned char *idP;
    unsigned char *usedIdP;
    int __fR, __fG, __fB;
    int iR, iG, iB;
    int idx;
    int __w = __intVal(w);
    int leftToRight;

    if (__isByteArrayLike(__INST(bytes))
     && __isByteArray(pseudoBits)
     && __isByteArrayLike(fixIds)
     && __isByteArrayLike(idsUsed)
     && __bothSmallInteger(fixR, fixG)
     && __isSmallInteger(fixB)) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        idP = __ByteArrayInstPtr(fixIds)->ba_element;
        usedIdP = __ByteArrayInstPtr(idsUsed)->ba_element;
        __fR = __intVal(fixR)-1;
        __fG = __intVal(fixG)-1;
        __fB = __intVal(fixB)-1;

        __eR = __eG = __eB = 0;

        leftToRight = 1;
        for (__y=__intVal(h); __y>0; __y--) {
            if (leftToRight) {
                for (__x=__w; __x>0; __x--) {
                    int __want;

                    /*
                     * wR, wG and wB is the wanted r/g/b value;
                     * compute the index into the dId table ..
                     * values: 0..255; scale to 0..fR-1, 0..fG-1, 0..fB-1
                     *
                     * bad kludge: knows how to index into FixColor table
                     */
                    __wantR = __want = srcP[0] + __eR;

                    if (__want > 255) __want = 255;
                    else if (__want < 0) __want = 0;

                    iR = __want * __fR / 128;
                    iR = (iR / 2) + (iR & 1);

                    __wantG = __want = srcP[1] + __eG;
                    if (__want > 255) __want = 255;
                    else if (__want < 0) __want = 0;

                    iG = __want * __fG / 128;
                    iG = (iG / 2) + (iG & 1);

                    __wantB = __want = srcP[2] + __eB;
                    if (__want > 255) __want = 255;
                    else if (__want < 0) __want = 0;

                    iB = __want * __fB / 128;
                    iB = (iB / 2) + (iB & 1);

                    idx = iR * (__fG+1);
                    idx = (idx + iG) * (__fB+1);
                    idx = idx + iB;

                    /*
                     * store the corresponding dither colorId
                     */
                    *dstP++ = idP[idx];
                    usedIdP[idx] = 1;

                    srcP += 3;

                    /*
                     * the new error:
                     */
                    __eR = __wantR - (iR * 256 / __fR);
                    __eG = __wantG - (iG * 256 / __fG);
                    __eB = __wantB - (iB * 256 / __fB);
                }
                leftToRight = 0;
            } else {
                srcP += (__w*3);
                dstP += __w;
                for (__x=__w; __x>0; __x--) {
                    int __want;

                    /*
                     * wR, wG and wB is the wanted r/g/b value;
                     * compute the index into the dId table ..
                     * values: 0..255; scale to 0..fR-1, 0..fG-1, 0..fB-1
                     *
                     * bad kludge: knows how to index into FixColor table
                     */
                    srcP -= 3;
                    __wantR = __want = srcP[0] + __eR;

                    if (__want > 255) __want = 255;
                    else if (__want < 0) __want = 0;

                    iR = __want * __fR / 128;
                    iR = (iR / 2) + (iR & 1);

                    __wantG = __want = srcP[1] + __eG;
                    if (__want > 255) __want = 255;
                    else if (__want < 0) __want = 0;

                    iG = __want * __fG / 128;
                    iG = (iG / 2) + (iG & 1);

                    __wantB = __want = srcP[2] + __eB;
                    if (__want > 255) __want = 255;
                    else if (__want < 0) __want = 0;

                    iB = __want * __fB / 128;
                    iB = (iB / 2) + (iB & 1);

                    idx = iR * (__fG+1);
                    idx = (idx + iG) * (__fB+1);
                    idx = idx + iB;

                    /*
                     * store the corresponding dither colorId
                     */
                    *--dstP = idP[idx];
                    usedIdP[idx] = 1;

                    /*
                     * the new error:
                     */
                    __eR = __wantR - (iR * 256 / __fR);
                    __eG = __wantG - (iG * 256 / __fG);
                    __eB = __wantB - (iB * 256 / __fB);
                }
                srcP += (__w*3);
                dstP += __w;
                leftToRight = 1;
            }
        }
    }
%}.
    failed ifTrue:[
        self primitiveFailed.
        ^ nil

"/ for non-C programmers:
"/     the above code is (roughly) equivalent to:
"/     (but it is just as ugly looking as the above ;-)
"/
"/    srcIndex := 1.
"/    dstIndex := 1.
"/    1 to:h do:[:y |
"/        eR := eG := eB := 0.
"/        1 to:w do:[:x |
"/            |pixel "{ Class: SmallInteger }"
"/             clr
"/             idx   "{ Class: SmallInteger }"
"/             iR    "{ Class: SmallInteger }"
"/             iG    "{ Class: SmallInteger }"
"/             iB    "{ Class: SmallInteger }"
"/             wR    "{ Class: SmallInteger }"
"/             wG    "{ Class: SmallInteger }"
"/             wB    "{ Class: SmallInteger }" |
"/
"/            wantR := ((bytes at:srcIndex) + eR). srcIndex := srcIndex + 1.
"/            wantG := ((bytes at:srcIndex) + eG). srcIndex := srcIndex + 1.
"/            wantB := ((bytes at:srcIndex) + eB). srcIndex := srcIndex + 1.
"/            wR := wantR.
"/            wR > 255 ifTrue:[wR := 255] ifFalse:[wR < 0 ifTrue:[wR := 0]].
"/            wG := wantG.
"/            wG > 255 ifTrue:[wG := 255] ifFalse:[wG < 0 ifTrue:[wG := 0]].
"/            wB := wantB.
"/            wB > 255 ifTrue:[wB := 255] ifFalse:[wB < 0 ifTrue:[wB := 0]].
"/
"/            iR := wR * (fixR-1) // 128.
"/            iR := (iR // 2) + (iR bitAnd:1).
"/            iG := wG * (fixG-1) // 128.
"/            iG := (iG // 2) + (iG bitAnd:1).
"/            iB := wB * (fixB-1) // 128.
"/            iB := (iB // 2) + (iB bitAnd:1).
"/            idx := (iR * fixR + iG) * fixB + iB + 1.
"/
"/            clr := fixColors at:idx.
"/
"/            eR := wantR - (clr red * 2) asInteger.
"/            eG := wantG - (clr green * 2) asInteger.
"/            eB := wantB - (clr blue * 2) asInteger.
"/
"/            pixel := clr colorId.
"/            pseudoBits at:dstIndex put:pixel.
"/
"/            dstIndex := dstIndex + 1
"/        ].
    ].

    "/ not all colors may be really in use ...
    usedColors := fixColors copy.
    idsUsed keysAndValuesDo:[:idx :flag |
        flag == 0 ifTrue:[
            usedColors at:idx put:nil
        ]
    ].

    f := Form imageForm width:width height:height depth:aDevice depth onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f colorMap:usedColors.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:8
        depth:aDevice depth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id)
        x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f
!

rgbImageAsPseudoFormOn:aDevice
    "return a pseudocolor form from the rgb-picture.
     If a colorCube is used, pass the work on to the cube-dither
     code. Otherwise, allocate as many colors as possible, then
     use those for dithering.
     Could be improved, by searching for (& allocating)
     heavily used colors and/or min-max colors first."

    |pseudoBits f
     r        "{ Class: SmallInteger }"
     g        "{ Class: SmallInteger }"
     b        "{ Class: SmallInteger }"
     srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     rMask    "{ Class: SmallInteger }"
     gMask    "{ Class: SmallInteger }"
     bMask    "{ Class: SmallInteger }"
     redArray greenArray blueArray
     dataSize "{ Class: SmallInteger }"
     nColors  "{ Class: SmallInteger }"
     fit fitMap colors color fast
     colorIndex "{ Class: SmallInteger }"
     depth nColorCells deep nColorsNeeded bytes|

    aDevice fixColors notNil ifTrue:[
        "/ no need to look for used colors - dithering anyway ...

        f := self rgbImageAsDitheredPseudoFormOn:aDevice.
        f notNil ifTrue:[^ f].
    ].

    bytes := self bits.

    "find used colors; build color-tree"

    fit := false.
    fitMap := false.
    depth := aDevice depth.
    nColorCells := aDevice ncells.

    deep := (depth > 8).

    rMask := 2r11111111.
    gMask := 2r11111111.
    bMask := 2r11111111.

    'Depth24Image [info]: allocating colors ...' infoPrintCR.

    [fit] whileFalse:[
        [fitMap] whileFalse:[
            srcIndex := 1.
            redArray := Array new:256.

            "
             find used colors, build [r][g][b] 3-dimensional array
             containing true for used colors
            "
            nColors := 0.
            srcIndex := 1.
            dataSize := bytes size.
            [(srcIndex < dataSize)
             and:[nColors <= nColorCells]] whileTrue:[
%{
                if (__isByteArrayLike(bytes)) {
                    int sI = __intVal(srcIndex);
                    unsigned char *cp = __ByteArrayInstPtr(bytes)->ba_element;

                    r = __MKSMALLINT((cp[sI - 1] & __intVal(rMask)) + 1);
                    g = __MKSMALLINT((cp[sI]     & __intVal(gMask)) + 1);
                    b = __MKSMALLINT((cp[sI + 1] & __intVal(bMask)) + 1);
                    srcIndex = __MKSMALLINT(sI + 3);
                    fast = true;
                } else {
                    fast = false;
                }
%}
.
                fast ifFalse:[
                    r := bytes at:srcIndex.
                    r := (r bitAnd:rMask) + 1.
                    srcIndex := srcIndex + 1.
                    g := bytes at:srcIndex.
                    g := (g bitAnd:gMask) + 1.
                    srcIndex := srcIndex + 1.
                    b := bytes at:srcIndex.
                    b := (b bitAnd:bMask) + 1.
                    srcIndex := srcIndex + 1
                ].

                greenArray := redArray at:r.
                greenArray isNil ifTrue:[
                    greenArray := Array new:256.
                    redArray at:r put:greenArray
                ].
                blueArray := greenArray at:g.
                blueArray isNil ifTrue:[
                    deep ifTrue:[blueArray := Array new:256]
                    ifFalse:[blueArray := ByteArray new:256].
                    greenArray at:g put:blueArray
                ].
                (blueArray at:b) == 0 ifTrue:[
                    blueArray at:b put:1.
                    nColors := nColors + 1.
                    (nColors > nColorCells) ifTrue:[
"/                        'Depth24Image [info]: more than ' infoPrint. nColorCells infoPrint. ' colors' infoPrintCR.
                        srcIndex := dataSize + 1
                    ]
                ]
            ].
            nColorsNeeded isNil ifTrue:[
                nColorsNeeded := nColors
            ].

            "again with less color bits if it does not fit colormap"

            (nColors <= nColorCells) ifTrue:[
                fitMap := true
            ] ifFalse:[
                "/ must try again - cutting off some bits
                "/ blue bits are snipped off faster.
                (bMask == 2r11111111) ifTrue:[
                    bMask := 2r11111100
                ] ifFalse:[
                    (bMask == 2r11111100) ifTrue:[
                        bMask := 2r11110000
                    ] ifFalse:[
                        (rMask == 2r11111111) ifTrue:[
                            rMask := 2r11111100.
                            gMask := 2r11111100.
                        ] ifFalse:[
                            rMask := (rMask bitShift:1) bitAnd:2r11111111.
                            gMask := (gMask bitShift:1) bitAnd:2r11111111.
                            bMask := (bMask bitShift:1) bitAnd:2r11111111
                        ]
                    ]
                ].
"/                'Depth24Image [info]: too many colors; retry with less color resolution' infoPrintCR.
"
    'masks:' print. rMask print. ' ' print. gMask print. ' ' print.
    bMask printNewline
"
            ]
        ].

"/        'Depth24Image [info]: ' infoPrint. nColors infoPrint. ' colors used' infoPrintCR.

        colors := Array new:nColors.
        colorIndex := 1.

        "
         now, we have reduced things to the number of colors
         which are theoretically supported by the devices colormap.
         allocate all used colors in walking over true entries in
         the [r][g][b] table - this may still fail,
         if we run out of device colors.
        "
        fit := true.

        r := 0.
        redArray do:[:greenArray |
            (fit and:[greenArray notNil]) ifTrue:[
                g := 0.
                greenArray do:[:blueArray |
                    (fit and:[blueArray notNil]) ifTrue:[
                        b := 0.
                        blueArray do:[:present |
                            |id|

                            (fit and:[present ~~ 0]) ifTrue:[
                                color := Color redByte:r
                                             greenByte:g
                                              blueByte:b.
                                color := color onDevice:aDevice.
                                (id := color colorId) isNil ifTrue:[
                                    fit := false
                                ] ifFalse:[
                                    colors at:colorIndex put:color.
                                    colorIndex := colorIndex + 1.
                                    blueArray at:(b + 1) put:id
                                ]
                            ].
                            b := b + 1
                        ]
                    ].
                    g := g + 1
                ]
            ].
            r := r + 1
        ].

        "again with less color bits if we did not get all colors"

        fit ifFalse:[
"/            'Depth24Image [info]: could not allocate color(s)' infoPrintCR.

            "free the allocated colors"
            colors atAllPut:nil.
            "a kludge - force immediate freeing of colors"
            ObjectMemory scavenge; finalize.

            "cut off one more color-bit - cut off blue first"
            (bMask == 2r11111111) ifTrue:[
                bMask := 2r11111100
            ] ifFalse:[
                (bMask == 2r11111100) ifTrue:[
                    bMask := 2r11110000
                ] ifFalse:[
                    (rMask == 2r11111111) ifTrue:[
                        rMask := 2r11111100.
                        gMask := 2r11111100.
                    ] ifFalse:[
                        rMask := (rMask bitShift:1) bitAnd:2r11111111.
                        gMask := (gMask bitShift:1) bitAnd:2r11111111.
                        bMask := (bMask bitShift:1) bitAnd:2r11111111
                    ]
                ]
            ].
            fitMap := false.
            redArray := nil
        ]
    ].

    (nColors ~~ nColorsNeeded) ifTrue:[
        "/ mhmh - did not get all colors ...
        "/ add existing colors and dither.

        'Depth24Image [info]: only got ' infoPrint. nColors infoPrint. ' out of ' infoPrint.
        nColorsNeeded infoPrint. ' image colors.' infoPrintCR.

        "/
        "/ dither using those we got ...
        "/
        DitherAlgorithm == #floydSteinberg ifTrue:[
            colors := colors asNewSet.
"/            ditherColors := aDevice availableDitherColors.
"/            ditherColors notNil ifTrue:[
"/                colors addAll:ditherColors.
"/            ].
"/            colors addAll:aDevice deviceColors.
            colors addAll:(aDevice colorMap collect:[:c|c onDevice:aDevice]).
            colors := (colors select:[:c | c colorId notNil]) asOrderedCollection.
            colors size > 256 ifTrue:[
                colors := colors copyTo:256
            ].
            f := self rgbImageAsDitheredPseudoFormOn:aDevice colors:colors.
            f notNil ifTrue:[^ f].
        ].
    ].

    "/ the device ought to support 8-bit images ...
    (aDevice supportedImageFormatForDepth:8) isNil ifTrue:[
        "/ cannot draw directly
        ^ nil
    ].

    "create pseudocolor bits and translate"

    pseudoBits := ByteArray uninitializedNew:(width * height).

    srcIndex := 1.
    dstIndex := 1.

    (rMask == 2r11111111
     and:[gMask == 2r11111111
     and:[bMask == 2r11111111]]) ifTrue:[
        [srcIndex < dataSize] whileTrue:[
            r := bytes at:srcIndex.
            srcIndex := srcIndex + 1.
            g := bytes at:srcIndex.
            srcIndex := srcIndex + 1.
            b := bytes at:srcIndex.
            srcIndex := srcIndex + 1.
            greenArray := redArray at:(r + 1).
            blueArray := greenArray at:(g + 1).
            pseudoBits at:dstIndex put:(blueArray at:(b + 1)).
            dstIndex := dstIndex + 1
        ]
    ] ifFalse:[
        [srcIndex < dataSize] whileTrue:[
            r := bytes at:srcIndex.
            r := r bitAnd:rMask.
            srcIndex := srcIndex + 1.
            g := bytes at:srcIndex.
            g := g bitAnd:gMask.
            srcIndex := srcIndex + 1.
            b := bytes at:srcIndex.
            b := b bitAnd:bMask.
            srcIndex := srcIndex + 1.
            greenArray := redArray at:(r + 1).
            blueArray := greenArray at:(g + 1).
            pseudoBits at:dstIndex put:(blueArray at:(b + 1)).
            dstIndex := dstIndex + 1
        ]
    ].

    f := Form imageForm width:width height:height depth:depth onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f colorMap:colors.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:8
        depth:depth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id)
        x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f
!

rgbImageAsTrueColorFormOn:aDevice
    "return a truecolor form from the rgb-picture."

    | bestFormat usedDeviceDepth usedDeviceBitsPerPixel usedDevicePadding form imageBits|

    bestFormat := self bestSupportedImageFormatFor:aDevice.
    usedDeviceDepth := bestFormat at:#depth.
    usedDeviceBitsPerPixel := bestFormat at:#bitsPerPixel.
    usedDevicePadding := bestFormat at:#padding.

    imageBits := self
		    rgbImageBitsOn:aDevice
		    bestFormat: bestFormat
		    returnUsedDevicePattingIn:[:arg | usedDevicePadding := arg].

    imageBits isNil ifTrue:[
	^ self asMonochromeFormOn:aDevice
    ].

    form := Form imageForm width:width height:height depth:usedDeviceDepth onDevice:aDevice.
    form isNil ifTrue:[
	'Depth24Image [warning]: display bitmap creation failed' errorPrintCR.
	^ nil
    ].
    form id isNil ifTrue:[
	"/ usually happens if the image is too big (out of memory)
	'Depth24Image [warning]: display bitmap creation failed' errorPrintCR.
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

    "Modified (format): / 30-12-2011 / 12:54:26 / cg"
!

rgbImageBitsOn:aDevice bestFormat: bestFormat
    "return rgb bits from the rgb-picture."

    ^ self
	rgbImageBitsOn:aDevice
	bestFormat:bestFormat
	returnUsedDevicePattingIn:[:usedPadding | ]

    "Modified: / 30-10-2007 / 20:56:45 / cg"
!

rgbImageBitsOn:aDevice bestFormat:bestFormat returnUsedDevicePattingIn:aValueHolder
    "return rgb bits from the rgb-picture.
     Sorry (sigh) - this might decide to use a different padding;
     this information is returned in aValueHolder"

    |bytes usedDeviceDepth usedDeviceBitsPerPixel usedDevicePadding
     myDepth imageBits padd
     rightShiftR rightShiftG rightShiftB shiftRed shiftGreen shiftBlue|

    bytes := self bits.

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
    myDepth == usedDeviceBitsPerPixel ifTrue:[
	"/
	"/ first, the trivial case, where the depths match
	"/ 24 bit/pixel
	"/
	imageBits := bytes.
	"/
	"/ however, the rgb-order could still be different
	"/
	((shiftBlue == 0) and:[(shiftGreen == 8) and:[shiftRed == 16]]) ifFalse:[
	    imageBits := ByteArray uninitializedNew:(width * height * 3).
	    usedDevicePadding := 8.

	    "/ now, walk over the image and compose 24bit values from the r/g/b triples
%{
	    unsigned char *srcPtr = 0;
	    unsigned char *dstPtr = 0;

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

			    v = srcPtr[0] << lShRed;
			    v |= (srcPtr[1] << lShGreen);
			    v |= (srcPtr[2] << lShBlue);
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
			    srcPtr += 3;
			}
		    }
		} else {
		    for (y=__intVal(__INST(height)); y > 0; y--) {
			for (x=w; x > 0; x--) {
			    unsigned r, g, b, v;

			    r = srcPtr[0] >> rShRed;
			    g = srcPtr[1] >> rShGreen;
			    b = srcPtr[2] >> rShBlue;
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
			    srcPtr += 3;
			}
		    }
		}
	    }
%}.
	]
    ] ifFalse:[
	"/
	"/ 16 bit/pixel ...
	"/
	(usedDeviceBitsPerPixel == 16) ifTrue:[
	    padd := width \\ (usedDevicePadding // 16).
	    imageBits := ByteArray uninitializedNew:((width + padd) * height * 2).

	    "/ now, walk over the image and compose 16bit values from the r/g/b triples

%{
	    unsigned char *srcPtr = 0;
	    unsigned char *dstPtr = 0;

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

			    v = srcPtr[0] << lShRed;
			    v |= (srcPtr[1] << lShGreen);
			    v |= (srcPtr[2] << lShBlue);
# ifdef __MSBFIRST
			    ((short *)dstPtr)[0] = v;
# else /* not MSB */
			    dstPtr[0] = (v>>8) & 0xFF;
			    dstPtr[1] = (v) & 0xFF;
# endif /* not MSB */
			    dstPtr += 2;
			    srcPtr += 3;
			}
			dstPtr += p;
		    }
		} else {
		    if (p == 0) {
			int n = __intVal(__INST(height)) * w;

			while (n >= 2) {
			    unsigned w, r, g, b, v;

			    n -= 2;

			    r = srcPtr[0];
			    g = srcPtr[1];
			    b = srcPtr[2];
			    v = (r >> rShRed) << lShRed;
			    v |= ((g >> rShGreen) << lShGreen);
			    v |= ((b >> rShBlue) << lShBlue);
# ifdef __MSBFIRST
			    ((short *)dstPtr)[0] = v;
# else
			    dstPtr[0] = (v>>8) & 0xFF;
			    dstPtr[1] = (v) & 0xFF;
# endif /* not MSB */

			    r = srcPtr[3];
			    g = srcPtr[4];
			    b = srcPtr[5];
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
			    srcPtr += 6;
			}

			while (n--) {
			    unsigned r, g, b, v;

			    r = srcPtr[0] >> rShRed;
			    g = srcPtr[1] >> rShGreen;
			    b = srcPtr[2] >> rShBlue;
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
			    srcPtr += 3;
			}
		    } else {
			for (y=__intVal(__INST(height)); y > 0; y--) {
			    for (x=w; x > 0; x--) {
				unsigned r, g, b, v;

				r = srcPtr[0] >> rShRed;
				g = srcPtr[1] >> rShGreen;
				b = srcPtr[2] >> rShBlue;
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
				srcPtr += 3;
			    }
			    dstPtr += p;
			}
		    }
		}
	    }
%}.
	] ifFalse:[
	    "/
	    "/ 32 bits/pixel ...
	    "/
	    (usedDeviceBitsPerPixel == 32) ifTrue:[
		usedDevicePadding := 8.
		imageBits := ByteArray uninitializedNew:(width * height * 4).

		"/ now, walk over the image and compose 32bit values from the r/g/b triples

%{
		unsigned char *srcPtr = 0;
		unsigned char *dstPtr = 0;

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

				v = srcPtr[0] << lShRed;
				v |= (srcPtr[1] << lShGreen);
				v |= (srcPtr[2] << lShBlue);
# ifdef __MSBFIRST
				((int *)dstPtr)[0] = v;
# else /* not MSB */
				dstPtr[0] = (v>>24) & 0xFF;
				dstPtr[1] = (v>>16) & 0xFF;
				dstPtr[2] = (v>>8) & 0xFF;
				dstPtr[3] = (v) & 0xFF;
# endif /* not MSB */
				dstPtr += 4;
				srcPtr += 3;
			    }
			}
		    } else {
			for (y=__intVal(__INST(height)); y > 0; y--) {
			    for (x=w; x > 0; x--) {
				unsigned r, g, b, v;

				r = srcPtr[0] >> rShRed;
				g = srcPtr[1] >> rShGreen;
				b = srcPtr[2] >> rShBlue;
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
				srcPtr += 3;
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

				    v = srcPtr[0] << lShRed;
				    v |= (srcPtr[1] << lShGreen);
				    v |= (srcPtr[2] << lShBlue);
				    dstPtr[0] = v;

				    dstPtr += 1;
				    srcPtr += 3;
				}
			    }
			} else {
			    for (y=__intVal(__INST(height)); y > 0; y--) {
				for (x=w; x > 0; x--) {
				    unsigned r, g, b, v;

				    r = srcPtr[0] >> rShRed;
				    g = srcPtr[1] >> rShGreen;
				    b = srcPtr[2] >> rShBlue;
				    v = r << lShRed;
				    v |= (g << lShGreen);
				    v |= (b << lShBlue);

				    dstPtr[0] = v;

				    dstPtr += 1;
				    srcPtr += 3;
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
	'IMAGE: unimplemented trueColor depth in #rgbImageBitsOn: ' errorPrint.
	usedDeviceBitsPerPixel errorPrintCR.
	^ nil
    ].
    aValueHolder value:usedDevicePadding.
    ^ imageBits

    "Created: / 30-10-2007 / 20:54:53 / cg"
! !

!Depth24Image methodsFor:'dither helpers'!

floydSteinbergDitheredDepth8BitsColors:colors map:aMapOrNil
    "return a floyd-steinberg dithered bitmap from the receiver picture,
     which must be a depth-24 image.
     This method expects an array of colors to be used for dithering
     (which need not be a colorCubes colors)."

    |pseudoBits
     ditherRGBBytes ditherColors
     w       "{Class: SmallInteger }"
     h       "{Class: SmallInteger }"
     index   "{Class: SmallInteger }"
     ditherIds failed lastColor qScramble
     clrLookup lookupPos
     error clr|

    self depth ~~ 24 ifTrue:[^ nil].

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

    error := ByteArray uninitializedNew:(width + 2) * (3*2).

    w := width.
    h := height.

    failed := true.

%{
    int __x, __y;
    unsigned char *srcP, *dstP;
    unsigned char *idP;
    unsigned char *__clrLookup;
    short *errP, *eP;
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
     && __isByteArray(ditherRGBBytes)
     && __isByteArray(ditherIds)
     && __isByteArray(clrLookup)
     && __isByteArray(error)) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        idP = __ByteArrayInstPtr(ditherIds)->ba_element;
        __clrLookup = __ByteArrayInstPtr(clrLookup)->ba_element;
        errP = (short *) __ByteArrayInstPtr(error)->ba_element;

        /*
         * clear error accumulator
         */
        eP = errP;
        bzero(eP, (__w+2) * 2 * 3);

        for (__y=__h; __y>0; __y--) {
            unsigned char *dp;
            int __eR, __eG, __eB;

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

                __wantR = srcP[0];
                __wantG = srcP[1];
                __wantB = srcP[2];
                srcP += 3;

                /*
                 * wI are the wanted r/g/b values;
                 * eI are the error values;
                 */
                __wantR = __wantR + __eR;
                __wantG = __wantG + __eG;
                __wantB = __wantB + __eB;

#define RED_SCALE 30
#define GREEN_SCALE 59
#define BLUE_SCALE 11
#define GOOD_DELTA 30

#define FAST_LOOKUP  /* */
/* #define ONE_SHOT */
#define NPROBE 16

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

floydSteinbergDitheredGrayBitsDepth:depth
    "return the bits for dithering a depth gray bitmap from the image.
     Redefined to make use of knowing that pixels are 24 bit r/g/b"

    |dstIndex        "{Class: SmallInteger }"
     nextDst         "{Class: SmallInteger }"
     bytesPerRow     "{Class: SmallInteger }"
     bytesPerOutRow  "{Class: SmallInteger }"
     outBits greyMap1 greyMap2 greyLevels
     errorArray
     errorArray1
     e t v
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }"
     grey dT
     eR eRB eB eLB bytes|

    (samplesPerPixel ~~ 3
     or:[(#[8 8 8] isSameSequenceAs:bitsPerSample) not
     or:[depth > 8]]) ifTrue:[
        ^ super floydSteinbergDitheredGrayBitsDepth:depth
    ].

    bytes := self bits.
    bytes isNil ifTrue:[ self error. ^ nil].
    w := width.
    h := height.

    bytesPerRow := self bytesPerRow.
    bytesPerOutRow := ((w * depth) + 7) // 8.
    outBits := ByteArray uninitializedNew:(bytesPerOutRow * h).

    depth ~~ 8 ifTrue:[
        greyLevels := (1 bitShift:depth) - 1.
        greyMap1 := Array new:256.
        greyMap2 := Array new:256.
        1 to:256 do:[:i |
            v := (greyLevels / 255 * (i-1)).
            greyMap1 at:i put:v.
            greyMap2 at:i put:v.
        ].
        greyMap1 := (greyMap1 collect:[:b | b truncated]) asByteArray.

        greyMap2 := (greyMap2 collect:[:el |
                                            ((el - el truncated)  "/ the error (0..1)
                                                * 255) rounded]) asByteArray.

        errorArray := ByteArray new:(w + 2) * 2.
        errorArray1 := ByteArray new:(w + 2) * 2.
    ].

%{
    int __byte;
    int __dT, __err, __e16, __eR, __eB, __eRB, __eLB;
    int __depth = __intVal(depth);
    int __dstIdx = 0;
    int __srcIdx = 0;
    int __bitCnt;
    int __grey;
    int __w = __intVal(w);
    int __h = __intVal(h);
    int __x;
    int __y;
    int __nextDst;
    int __nextSrc;
    int __bytesPerRow = __intVal(bytesPerRow);
    int __bytesPerOutRow = __intVal(bytesPerOutRow);
    int __pixel;
    int __greyLevels = __intVal(greyLevels);

    unsigned char *__outBits = __ByteArrayInstPtr(outBits)->ba_element;
    unsigned char *__bytes = __ByteArrayInstPtr(bytes)->ba_element;
    unsigned char *__greyMap1 = __ByteArrayInstPtr(greyMap1)->ba_element;
    unsigned char *__greyMap2 = __ByteArrayInstPtr(greyMap2)->ba_element;
    short *__errorArray = (short *)(__ByteArrayInstPtr(errorArray)->ba_element);
    short *__errorArray1 = (short *)(__ByteArrayInstPtr(errorArray1)->ba_element);
    short *__t;

    if (__depth == 8) {
        /*
         * special code for destination depth 8
         */
        for (__y=0; __y<__h; __y++) {
            __nextDst = __dstIdx + __bytesPerOutRow;
            __nextSrc = __srcIdx + __bytesPerRow;
            for (__x=0; __x<__w; __x++) {
                __grey = (__bytes[__srcIdx] * 3)           /* 0.3*r + 0.6*g + b -> 0..2550 */
                         + (__bytes[__srcIdx+1] * 6)
                         + __bytes[__srcIdx+2];
                __pixel = __grey / 10;                      /* 0 .. 255 */

                __srcIdx += 3;
                __outBits[__dstIdx] = __pixel;
               __dstIdx++;
            }
            __srcIdx = __nextSrc;
            __dstIdx = __nextDst;
        }
    } else {
        bzero(errorArray1, (__w+2) * 2);

        __bitCnt = 8;
        for (__y=0; __y<__h; __y++) {
            __nextDst = __dstIdx + __bytesPerOutRow;
            __nextSrc = __srcIdx + __bytesPerRow;

            __byte = 0;

            __t = __errorArray;
            __errorArray = __errorArray1;
            __errorArray1 = __t;
            bzero(errorArray1, (__w+2) * 2);

            for (__x=0; __x<__w; __x++) {
                __grey = (__bytes[__srcIdx] * 3)           /* 0.3*r + 0.6*g + b -> 0..2550 */
                         + (__bytes[__srcIdx+1] * 6)
                         + __bytes[__srcIdx+2];
                __grey = __grey / 10;                      /* 0 .. 255 */

                __pixel = __greyMap1[__grey];            /* 0..(greyLevels-1) */
                __err = __greyMap2[__grey];              /* 0.. 255 - error) */
                __err += __errorArray[__x+1];

                if (__err > 127) {                        /* dither says: next pixel */
                   if ( __pixel != __greyLevels)
                        __pixel++;
                    __err = __err - 255;
                } else {
                }
                if (__err) {
                    __e16 = __err >> 4;
                    __eR = __e16 * 7;                    /* 7/16 -> right pixel */
                    __eRB = __e16 * 1;                   /* 1/16 -> right below */
                    __eB = __e16 * 5;                    /* 5/16 -> below */
                    __eLB = __err - __eR - __eRB - __eB; /* 3/16 -> left below */

                    __errorArray [__x+1+1] += __eR;
                    __errorArray1[__x+1+1] += __eRB;
                    __errorArray1[__x+1  ] += __eB;
                    __errorArray1[__x+1-1] += __eLB;
                }

                __srcIdx += 3;

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
                __bitCnt = 8;
            }
            __srcIdx = __nextSrc;
            __dstIdx = __nextDst;
        }
    }
%}.

    ^ outBits

    "Created: / 10-06-1996 / 13:28:22 / cg"
    "Modified: / 10-06-1996 / 15:09:07 / cg"
    "Modified: / 31-01-2017 / 12:39:31 / stefan"
!

floydSteinbergDitheredMonochromeBits
    "return the bitmap for a dithered monochrome bitmap from the image.
     Redefined to make use of knowing that pixels are 24 bit r/g/b"


    ^ self floydSteinbergDitheredGrayBitsDepth:1

    "Created: 10.6.1996 / 22:55:59 / cg"
!

orderedDitheredGrayBitsWithDitherMatrix:ditherMatrix ditherWidth:dW depth:depth
    "return the bitmap for a dithered depth-bitmap from the image;
     with a constant ditherMatrix, this can be used for thresholding.
     Redefined to make use of knowing that pixels are 24-bit values."

    |dH nDither v range bytes
     greyMap1 greyMap2 greyLevels outBits
     bytesPerOutRow  "{Class: SmallInteger }"
     bytesPerRow     "{Class: SmallInteger }"
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"|

    photometric ~~ #rgb ifTrue:[
	self error:'invalid format'.
	^ nil
    ].

    nDither := ditherMatrix size.
    dH := nDither / dW.

    bytes := self bits.
    w := width.
    h := height.

    greyLevels := 1 bitShift:depth.
    bytesPerRow := self bytesPerRow.

    bytesPerOutRow := (w * depth + 7) // 8.
    outBits := ByteArray uninitializedNew:(bytesPerOutRow * h).
    (outBits isNil or:[bytes isNil]) ifTrue:[ self error. ^ nil].

    greyMap1 := Array new:256.
    greyMap2 := Array new:256.
    range := greyLevels-1.
    1 to:256 do:[:i |
	v := (range / 255 * (i-1)).
	greyMap1 at:i put:v.
	greyMap2 at:i put:v.
    ].

    greyMap1 := (greyMap1 collect:[:b | b isNil ifTrue:[
					    0
					] ifFalse:[
					    b truncated
					]
				  ]) asByteArray.

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
    int __nDither = __intVal(nDither);
    int __dT, __dO;
    int __depth = __intVal(depth);
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
    int __bytesPerOutRow = __intVal(bytesPerOutRow);
    int __pixel;

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
	    __grey = (__bytes[__srcIdx] * 3)           /* 0.3*r + 0.6*g + b -> 0..2550 */
		     + (__bytes[__srcIdx+1] * 6)
		     + __bytes[__srcIdx+2];
	    __grey = __grey / 10;                      /* 0 .. 255 */

	    __pixel = __greyMap1[__grey];            /* 0..(greyLevels-1) */
	    __dO    = __greyMap2[__grey];            /* 0.. nDither-1) */
	    __dT = __ditherMatrix[__dY + __oX];

	    if (__dO > __dT)                         /* dither says: next pixel */
		__pixel++;

	    __srcIdx += 3;

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

    "
     |i|

     i := Image fromFile:'bitmaps/granite.tiff'.
     i asOrderedDitheredMonochromeImage inspect.
     i asOrderedDitheredDepth2GrayImage inspect.
     i asOrderedDitheredDepth4GrayImage inspect.
     i asOrderedDitheredDepth8GrayImage inspect.
    "

    "Created: 7.6.1996 / 10:48:06 / cg"
    "Modified: 7.6.1996 / 11:08:50 / cg"
!

orderedDitheredMonochromeBitsWithDitherMatrix:ditherMatrix ditherWidth:dW
    "return the dithered monochrome bits for the receiver image;
     with a constant ditherMatrix, this can be used for thresholding.
     Redefined to make use of knowing that pixels are 24-bit values."

    |dH nDither bytes
     monoBits
     bytesPerMonoRow "{Class: SmallInteger }"
     bytesPerRow     "{Class: SmallInteger }"
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"|

    photometric ~~ #rgb ifTrue:[
	self error:'invalid format'.
	^ nil
    ].

    nDither := ditherMatrix size.
    dH := nDither / dW.

    bytes := self bits.
    w := width.
    h := height.

    bytesPerRow := self bytesPerRow.

    bytesPerMonoRow := w + 7 // 8.
    monoBits := ByteArray uninitializedNew:(bytesPerMonoRow * h).
    (monoBits isNil or:[bytes isNil]) ifTrue:[ self error. ^ nil].

%{
    int __dW = __intVal(dW);
    int __dH = __intVal(dH);
    int __byte;
    int __nDither = __intVal(nDither);
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

    __oY = __dY = 0;
    for (__y=0; __y<__h; __y++) {
	__nextDst = __dstIdx + __bytesPerMonoRow;
	__nextSrc = __srcIdx + __bytesPerRow;

	__byte = 0;
	__bitCnt = 8;

	__oX = 0;

	for (__x=0; __x<__w; __x++) {
	    __grey = (__bytes[__srcIdx] * 3)           /* 0.3*r + 0.6*g + b -> 0..2550 */
		     + (__bytes[__srcIdx+1] * 6)
		     + __bytes[__srcIdx+2];
	    __grey = __grey * (__nDither+1) / 2550;    /* 0 .. nDither+1 */
	    __srcIdx += 3;

	    __dT = __ditherMatrix[__dY + __oX];

	    __oX++;
	    if (__oX == __dW) __oX = 0;

	    __byte = __byte << 1;
	    if (__grey > __dT) {
		__byte = __byte | 1;                   /* white */
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

     i := Image fromFile:'bitmaps/granite.tiff'.
     f := i asOrderedDitheredMonochromeFormOn:Display.
    "

    "Created: 7.6.1996 / 10:48:06 / cg"
    "Modified: 7.6.1996 / 11:08:50 / cg"
!

threshold8BitGrayBits
    "return the bits for an 8-bit grey image from the receiver.
     Special code, since this is a common case."

    |greyBits
     srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"|

    greyBits := ByteArray uninitializedNew:(width * height).
%{
    if ((__Class(__INST(bytes)) == ByteArray)
     && (__Class(greyBits) == ByteArray)) {
	unsigned char *srcPtr, *dstPtr;
	int i;

	srcPtr = __ByteArrayInstPtr(__INST(bytes))->ba_element;
	dstPtr = __ByteArrayInstPtr(greyBits)->ba_element;

	i = __intVal(__INST(height)) * __intVal(__INST(width));

	for (; i > 0; i--) {
	    int __v;

	    __v = (srcPtr[0] * 3);     /* 3*r + 6*g + b ; 0 .. 2550 */
	    __v += (srcPtr[1] * 6);
	    __v += srcPtr[2];
	    srcPtr += 3;
	    __v /= 10;                 /* 0..255 */
	    *dstPtr++ = __v ;
	}
    }
%}.
    ^ greyBits

! !

!Depth24Image methodsFor:'enumerating'!

colorsAtX:x from:yLow to:yHigh do:aBlock
    "perform aBlock for each pixel from y1 to y2 in col x.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using atX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     y1       "{ Class: SmallInteger }"
     y2       "{ Class: SmallInteger }"
     rVal     "{ Class: SmallInteger }"
     gVal     "{ Class: SmallInteger }"
     bVal     "{ Class: SmallInteger }"
     lastR lastG lastB lastColor bytes|

    photometric ~~ #rgb ifTrue:[
	^ super colorsAtX:x from:yLow to:yHigh do:aBlock.
    ].

    bytes := self bits.

    y1 := yLow.
    y2 := yHigh.

    srcIndex := 1 + (((width * yLow) + x) * 3).

    y1 to:y2 do:[:y |
	rVal := bytes at:(srcIndex).
	gVal := bytes at:(srcIndex + 1).
	bVal := bytes at:(srcIndex + 2).
	srcIndex := srcIndex + width.

	(rVal == lastR and:[gVal == lastG and:[bVal == lastB]]) ifFalse:[
	    lastColor := Color redByte:rVal greenByte:gVal blueByte:bVal.
	    lastR := rVal.
	    lastG := gVal.
	    lastB := bVal.
	].
	aBlock value:y value:lastColor
    ]
!

colorsAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixel from x1 to x2 in row y.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using atX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     rVal     "{ Class: SmallInteger }"
     gVal     "{ Class: SmallInteger }"
     bVal     "{ Class: SmallInteger }"
     lastR lastG lastB lastColor bytes|

    photometric ~~ #rgb ifTrue:[
	^ super colorsAtY:y from:xLow to:xHigh do:aBlock.
    ].

    bytes := self bits.

    x1 := xLow.
    x2 := xHigh.

    srcIndex := 1 + (((width * y) + x1) * 3).

    x1 to:x2 do:[:x |
	rVal := bytes at:(srcIndex).
	gVal := bytes at:(srcIndex + 1).
	bVal := bytes at:(srcIndex + 2).
	srcIndex := srcIndex + 3.

	(rVal == lastR and:[gVal == lastG and:[bVal == lastB]]) ifFalse:[
	    lastColor := Color redByte:rVal greenByte:gVal blueByte:bVal.
	    lastR := rVal.
	    lastG := gVal.
	    lastB := bVal.
	].
	aBlock value:x value:lastColor
    ]

    "Created: / 7.6.1996 / 19:12:28 / cg"
    "Modified: / 27.7.1998 / 20:03:02 / cg"
!

valuesAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixelValue from x1 to x2 in row y.
     The block is passed the pixelValue at each pixel.
     This method allows slighly faster processing of an
     image than using valueAtX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written.
     Notice that the pixelValue is the r/g/b value packed into an MSB integer
     (r bitShift:16) bitOr:(g bitSHift:8) bitOr:b
     i.e. r is the first byte, but high in the passed pixel value."

    |srcIndex "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     r        "{ Class: SmallInteger }"
     g        "{ Class: SmallInteger }"
     b        "{ Class: SmallInteger }"
     bytes|

    bytes := self bits.
    x1 := xLow.
    x2 := xHigh.

    srcIndex := 1 + (((width * y) + x1) * 3).

    x1 to:x2 do:[:x |
	r := bytes at:(srcIndex).
	g := bytes at:(srcIndex + 1).
	b := bytes at:(srcIndex + 2).
	srcIndex := srcIndex + 3.
	aBlock value:x value:(((r bitShift:16) bitOr:(g bitShift:8)) bitOr:b)
    ]

    "Created: 7.6.1996 / 19:09:40 / cg"
!

valuesFromX:xStart y:yStart toX:xEnd y:yEnd do:aBlock
    "perform aBlock for each pixel in the rectangle
     yStart..yEnd / xStart..xEnd.
     The block is passed the pixelValue at each pixel.
     This method allows slighly faster processing of an
     image than using individual valueAtX:y: accesses,
     since some processing can be avoided when going from pixel to pixel..
     However, for real high performance image  processing, specialized methods
     should be written which know how to deal with specific photometric interpretations."

    |srcIndex    "{ Class: SmallInteger }"
     srcNext     "{ Class: SmallInteger }"
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

    srcIndex := (width * 3 * y1) + (x1 * 3) + 1 .
    bytesPerRow := self bytesPerRow.
    bytes := self bits.
%{
    OBJFUNC codeVal;

    if (__bothSmallInteger(x1, x2)
     && __bothSmallInteger(y1, y2)
     && __bothSmallInteger(srcIndex, bytesPerRow)
     && __isByteArrayLike(bytes)
     && __isBlockLike(aBlock)
     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(3))
     && ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
    ) {
        int c_x1 = __intVal(x1);
        int c_x2 = __intVal(x2);
        int c_y1 = __intVal(y1);
        int c_y2 = __intVal(y2);
        int c_w = __intVal(__INST(width));
        int c_h = __intVal(__INST(height));
        int c_srcIndex = __intVal(srcIndex)-1;
        int c_bytesPerRow = __intVal(bytesPerRow);
        int c_y, c_x;
        OBJ c_rHome;

        c_rHome = __BlockInstPtr(aBlock)->b_home;
        if ((c_rHome == nil) || (__qSpace(c_rHome) >= STACKSPACE)) {
            if ((((unsigned)c_y1) < c_h)
             && (((unsigned)c_y2) < c_h)
             && (((unsigned)c_x1) < c_w)
             && (((unsigned)c_x2) < c_w)) {
                unsigned char *c_bytes = (unsigned char*)__ByteArrayInstPtr(bytes)->ba_element;

                if ((c_srcIndex + (c_bytesPerRow * (c_y2-c_y1))) < __byteArraySize(bytes)) {
                    c_bytes += c_srcIndex;
                    for (c_y=c_y1; c_y<=c_y2; c_y++) {
                        unsigned char *c_next = c_bytes + c_bytesPerRow;

                        for (c_x=c_x1; c_x<=c_x2; c_x++) {
                            int c_value;

                            c_value = c_bytes[0];
                            c_value = (c_value<<8) | c_bytes[1];
                            c_value = (c_value<<8) | c_bytes[2];
                            (*(__BlockInstPtr(aBlock)->b_code))(c_rHome, __mkSmallInteger(c_x), __mkSmallInteger(c_y), __mkSmallInteger(c_value));
                            c_bytes += 3;
                        }
                        c_bytes = c_next;
                    }
                    RETURN(self);
                }
            }
        }
    }
%}.

    y1 to:y2 do:[:y |
        srcNext := srcIndex + bytesPerRow.
        x1 to:x2 do:[:x |
            value := bytes at:srcIndex.
            value := (value bitShift:8) + (bytes at:srcIndex+1).
            value := (value bitShift:8) + (bytes at:srcIndex+2).
            srcIndex := srcIndex + 3.

            aBlock value:x value:y value:value
        ].
        srcIndex := srcNext.
    ].

    "Modified: 11.7.1996 / 20:06:47 / cg"
    "Created: 11.7.1996 / 20:08:11 / cg"
! !

!Depth24Image methodsFor:'image manipulations'!

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

	// I tried three versions here;
	//   a) compute dstX/y inside the loop,
	//   b) precompute a transformation matrix and compute inside the loop w.o conditional branches
	//      (i.e. x*Mx + y*My...)
	//   c) precompute ptr-delta and use those to step to next destination pixel.

	// the funny result:
	//   all show roughly the same speed on a modern CPU.
	// So the whole thing is mostly limited by memory-bandwidth,
	// and there is not much to do, unless we move to a better memory fetch/store
	// (eg. mmx or similar vector stuff)
	// However, on slower cpus, algo c shpuld perform better, as it does not need multiplications in the loop.
	// The version below orecomputes the delta, so it should run fast on older CPUs as well.

	{
	    unsigned char *c_srcBytes = (unsigned char*)__ByteArrayInstPtr(srcBytes)->ba_element;
	    unsigned char *c_dstBytes = (unsigned char*)__ByteArrayInstPtr(dstBytes)->ba_element;

	    int c_dstNextRowOffset;
	    int c_dstNextColOffset;

	    if (degrees == __mkSmallInteger(90)) {
		// destinationImage pixelAtX:(h-row) y:col put:pixel
		c_dstNextRowOffset = -3;                                // going to previous column
		c_dstNextColOffset = c_dstBytesPerRow;                  // going to next row
		c_dstBytes += (c_dstW-1)*3;                             // start in the upper-right of dest
	    } else if (degrees == __mkSmallInteger(180)) {
		// destinationImage pixelAtX:(w-col) y:(h-row) put:pixel
		c_dstNextRowOffset = -c_dstBytesPerRow;                 // going to previous row
		c_dstNextColOffset = -3;                                // going to prev col
		c_dstBytes += (c_dstH-1)*c_dstBytesPerRow+(c_dstW-1)*3; // start in the lower-right of dest
	    } else {
		// destinationImage pixelAtX:row y:(w-col) put:pixel
		c_dstNextRowOffset = 3;                                 // going to next col
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
			    int c_value1, c_value2, c_value3;

			    c_value1 = ((int *)c_srcBytes)[0];
			    c_value2 = ((int *)c_srcBytes)[1];
			    c_value3 = ((int *)c_srcBytes)[2];

			    c_dstBytes[0] = (c_value1) & 0xFF;
			    c_dstBytes[1] = (c_value1>>8) & 0xFF;
			    c_dstBytes[2] = (c_value1>>16) &0xFF;
			    c_dstBytes += c_dstNextColOffset;

			    c_dstBytes[0] = (c_value1>>24) & 0xFF;
			    c_dstBytes[1] = (c_value2) & 0xFF;
			    c_dstBytes[2] = (c_value2>>8) &0xFF;
			    c_dstBytes += c_dstNextColOffset;

			    c_dstBytes[0] = (c_value2>>16) & 0xFF;
			    c_dstBytes[1] = (c_value2>>24) & 0xFF;
			    c_dstBytes[2] = (c_value3) &0xFF;
			    c_dstBytes += c_dstNextColOffset;

			    c_dstBytes[0] = (c_value3>>8) & 0xFF;
			    c_dstBytes[1] = (c_value3>>16) & 0xFF;
			    c_dstBytes[2] = (c_value3>>24) &0xFF;
			    c_dstBytes += c_dstNextColOffset;

			    c_srcBytes += (3*4);
			}
		    }
#endif
		    for (; c_x < c_srcW; c_x++) {
			int c_rValue, c_gValue, c_bValue;

			c_rValue = c_srcBytes[0];
			c_gValue = c_srcBytes[1];
			c_bValue = c_srcBytes[2];

			c_dstBytes[0] = c_rValue;
			c_dstBytes[1] = c_gValue;
			c_dstBytes[2] = c_bValue;

			c_srcBytes += 3;
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
     i := Depth24Image fromImage:i.
     i inspect.
     (i rotated:45) inspect.
     (i rotated:90) inspect.
     (i rotated:180) inspect.
     (i rotated:270) inspect.
    "
!

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
    ].
    ^ newImage

    "Modified: 23.6.1997 / 09:57:19 / cg"
! !

!Depth24Image methodsFor:'initialization'!

initialize
    super initialize.
    samplesPerPixel := 3.
    bitsPerSample := #[8 8 8].

    "Created: / 27-05-2007 / 14:09:34 / cg"
    "Modified: / 30-01-2017 / 18:29:01 / stefan"
! !

!Depth24Image methodsFor:'magnification'!

hardAntiAliasedMagnifiedBy:scalePoint
    "return a new image magnified by scalePoint, aPoint.
     This interpolates pixels and is therefore much slower,
     but generates nicer looking magnifications."

    |mX
     mY
     newWidth  "{ Class: SmallInteger }"
     newHeight "{ Class: SmallInteger }"
     w         "{ Class: SmallInteger }"
     h         "{ Class: SmallInteger }"
     newImage newBits bitsPerPixel newBytesPerRow newMask
     value
     srcRow pixelArray|

    mX := scalePoint x.
    mY := scalePoint y.
    ((mX < 0) or:[mY < 0]) ifTrue:[^ nil].
    ((mX = 1) and:[mY = 1]) ifTrue:[^ self].

    newWidth := (width * mX) truncated.
    newHeight := (height * mY) truncated.

    bitsPerPixel := self depth.
    newBytesPerRow := ((newWidth * bitsPerPixel) + 7) // 8.
    newBits := ByteArray new: "uninitializedNew:" (newBytesPerRow * newHeight).
    newBits isNil ifTrue:[
	'Depth24Image [warning]: failed to allocate byteArray for image bits' errorPrintCR.
	^ nil
    ].

    mask notNil ifTrue:[
	newMask := (mask magnifiedBy:scalePoint)
    ].

    newImage := self species new.
    newImage
	width:newWidth
	height:newHeight
	photometric:photometric
	samplesPerPixel:samplesPerPixel
	bitsPerSample:bitsPerSample
	colorMap:nil
	bits:newBits
	mask:newMask.

    mY := mY asFloat.
    mX := mX asFloat.

%{
    REGISTER unsigned char *_dstP = __ByteArrayInstPtr(newBits)->ba_element;
    unsigned char *_srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
    unsigned char *_srcRowP, *sP;
    int _width3 = __intVal(__INST(width)) * 3;
    int _oldW = __intVal(__INST(width)) - 1;
    int _oldH = __intVal(__INST(height)) - 1;
    int _w = __intVal(newWidth) - 1;
    int _h = __intVal(newHeight) - 1;
    int _row, _col;
    double _mX = __floatVal(mX);
    double _mY = __floatVal(mY);

    for (_row = 0; _row <= _h; _row++) {
	double _srcY;
	double _dY;
	int _sR;

	_srcY = ((double)_row / _mY);
	_sR = (int)_srcY;
	_dY = _srcY - ((double)_sR);
	_srcRowP = _srcP + (_width3 * _sR);

	for (_col = 0; _col <= _w; _col++) {
	    unsigned int rHere, gHere, bHere;
	    unsigned int rRight, gRight, bRight;
	    unsigned int rRightBelow, gRightBelow, bRightBelow;
	    unsigned int rBelow, gBelow, bBelow;
	    unsigned int _r, _g, _b;
	    double wHere, wRight, wRightBelow, wBelow, sumW;
	    double _srcX;
	    double _dX;
	    int _sC;

	    _srcX = ((double)_col / _mX);
	    _sC = (int)_srcX;
	    _dX = _srcX - ((double)_sC);
	    sP = _srcRowP + (_sC * 3);

	    rHere = sP[0];
	    gHere = sP[1];
	    bHere = sP[2];

	    if (_sC < _oldW) {
		rRight = sP[3];
		gRight = sP[4];
		bRight = sP[5];

		if (_sR < _oldH) {
		    rBelow = sP[0+_width3];
		    gBelow = sP[1+_width3];
		    bBelow = sP[2+_width3];
		    rRightBelow = sP[3+_width3];
		    gRightBelow = sP[4+_width3];
		    bRightBelow = sP[5+_width3];
		} else {
		    rRightBelow = rHere;
		    gRightBelow = gHere;
		    bRightBelow = bHere;
		    rBelow = rHere;
		    gBelow = gHere;
		    bBelow = bHere;
		}
	    } else {
		rRight = rRightBelow = rHere;
		gRight = gRightBelow = gHere;
		bRight = bRightBelow = bHere;
		if (_sR < _oldH) {
		    rBelow = sP[0+_width3];
		    gBelow = sP[1+_width3];
		    bBelow = sP[2+_width3];
		} else {
		    rBelow = rHere;
		    gBelow = gHere;
		    bBelow = bHere;
		}
	    }

	    wHere = (1.0 - _dX) * (1.0 - _dY);
	    wRight = _dX * (1.0 - _dY);
	    wBelow = _dY * (1.0 - _dX);
	    wRightBelow = _dX * _dY;
	    sumW = wHere + wRight + wBelow + wRightBelow;

	    _r = ((rHere * wHere) + (rRight * wRight) + (rBelow * wBelow) + (rRightBelow * wRightBelow)) / sumW;
	    _g = ((gHere * wHere) + (gRight * wRight) + (gBelow * wBelow) + (gRightBelow * wRightBelow)) / sumW;
	    _b = ((bHere * wHere) + (bRight * wRight) + (bBelow * wBelow) + (bRightBelow * wRightBelow)) / sumW;

	    _dstP[0] = _r;
	    _dstP[1] = _g;
	    _dstP[2] = _b;

	    _dstP += 3;
	}
    }
%}.

    ^ newImage

    "
     |i|
     i := Image fromFile:'bitmaps/gifImages/garfield.gif'.
     i hardAntiAliasedMagnifiedBy:2@2
    "
    "
     |i|
     i := Depth24Image width:3 height:3 fromArray:#[ 0 0 0  0 0 0  0 0 0
						     0 0 0  255 255 255  0 0 0
						     0 0 0  0 0 0  0 0 0].
     i hardAntiAliasedMagnifiedBy:8@8
    "

    "Modified: 2.6.1997 / 12:28:18 / cg"
    "Created: 2.6.1997 / 13:18:53 / cg"
!

hardMagnifiedBy:scalePoint
    "return a new image magnified by scalePoint, aPoint.
     This is  the general magnification method, handling non-integral values"

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
    newBytes := ByteArray uninitializedNew:(newWidth * 3 * newHeight).

    mask notNil ifTrue:[
        newMask := (mask magnifiedBy:scalePoint)
    ].

    newImage := self species new.
    newImage
        width:newWidth
        height:newHeight
        photometric:photometric
        samplesPerPixel:samplesPerPixel
        bitsPerSample:#[8 8 8]
        colorMap:nil
        bits:newBytes
        mask:newMask.

    "walk over destination image fetching pixels from source image"

    mY := mY asFloat.
    mX := mX asFloat.
%{
    REGISTER unsigned char *_dstP = __ByteArrayInstPtr(newBytes)->ba_element;
    unsigned char *_srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
    unsigned char *_srcRowP, *sP;
    int _width3 = __intVal(__INST(width)) * 3;
    int _w = __intVal(newWidth) - 1;
    int _h = __intVal(newHeight) - 1;
    int _row, _col;
    double _mX = __floatVal(mX);
    double _mY = __floatVal(mY);

    for (_row = 0; _row <= _h; _row++) {
        _srcRowP = _srcP + (_width3 * (int)((double)_row / _mY));
        for (_col = 0; _col <= _w; _col++) {
            sP = _srcRowP + (((int)((double)_col / _mX)) * 3);
            _dstP[0] = sP[0];
            _dstP[1] = sP[1];
            _dstP[2] = sP[2];
            _dstP += 3;
        }
    }
%}
.
"   the above C-code is equivalent to:

    dstIndex := 1.
    w := newWidth - 1.
    h := newHeight - 1.
    0 to:h do:[:row |
        srcRowIdx := (width * 3 * (row // mY)) + 1.
        0 to:w do:[:col |
            srcIndex := srcRowIdx + ((col // mX) * 3).
            value := bytes at:srcIndex.
            newBytes at:dstIndex put:value.
            value := bytes at:(srcIndex + 1).
            newBytes at:(dstIndex + 1) put:value.
            value := bytes at:(srcIndex + 2).
            newBytes at:(dstIndex + 2) put:value.
            dstIndex := dstIndex + 3
        ]
    ].
"
    ^ newImage
!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors"

%{
    unsigned char *srcP, *dstP;
    int _mag;
    REGISTER int i;
    REGISTER unsigned char byte1, byte2, byte3;
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
	    srcP += 3;
	    for (i=_mag; i>0; i--) {
		*dstP = byte1;
		*(dstP+1) = byte2;
		*(dstP+2) = byte3;
		dstP += 3;
	    }
	}
	RETURN (self);
    }
%}.
    super
	magnifyRowFrom:srcBytes offset:srcStart
	into:dstBytes offset:dstStart factor:mX
! !

!Depth24Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 24
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 24
!

bitsPerSample
    "return the number of bits per sample.
     The return value is an array of bits-per-plane."

    bitsPerSample notNil ifTrue:[^ bitsPerSample].
    ^ #[8 8 8]

    "Modified: / 10-06-1996 / 18:02:33 / cg"
    "Modified: / 30-01-2017 / 18:27:45 / stefan"
!

blueBitsOf:pixel
    "given a pixel-value, return the blue component as byteValue (0..255)"

    ^ pixel bitAnd:16rFF.

    "Created: 8.6.1996 / 09:56:20 / cg"
!

blueComponentOf:pixel
    "given a pixel-value, return the blue component in percent (0..100)"

    ^ (100.0 / 255.0) * (pixel bitAnd:16rFF)

    "Created: 8.6.1996 / 08:42:44 / cg"
    "Modified: 8.6.1996 / 09:57:41 / cg"
!

blueMaskForPixelValue
    "return the mask used with translation from pixelValues to blueBits"

    ^ 16rFF
!

blueShiftForPixelValue
    "return the shift amount used with translation from pixelValues to blueBits"

    ^ 0
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    ^ width * 3
!

greenBitsOf:pixel
    "given a pixel-value, return the green component as byteValue (0..255)"

    ^ (pixel bitShift:-8) bitAnd:16rFF.

    "Modified: 8.6.1996 / 08:56:28 / cg"
    "Created: 8.6.1996 / 09:56:30 / cg"
!

greenComponentOf:pixel
    "given a pixel-value, return the green component in percent (0..100)"

    ^ (100.0 / 255.0) * ((pixel bitShift:-8) bitAnd:16rFF).

    "Created: 8.6.1996 / 08:42:37 / cg"
    "Modified: 8.6.1996 / 09:57:32 / cg"
!

greenMaskForPixelValue
    "return the mask used with translation from pixelValues to redBits"

    ^ 16rFF
!

greenShiftForPixelValue
    "return the shift amount used with translation from pixelValues to greenBits"

    ^ -8
!

isDepth24Image
    "return true if the image is instance of Depth24Image"
   (self bitsPerPixel == 24) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 16:53:00 / svestkap"
!

redBitsOf:pixel
    "given a pixel-value, return the red component as byteValue (0..255)"

    ^ (pixel bitShift:-16) bitAnd:16rFF.

    "Modified: 8.6.1996 / 08:56:31 / cg"
    "Created: 8.6.1996 / 09:56:39 / cg"
!

redComponentOf:pixel
    "given a pixel-value, return the red component in percent (0..100)"

    ^ (100.0 / 255.0) * ((pixel bitShift:-16) bitAnd:16rFF).

    "Created: 8.6.1996 / 08:42:25 / cg"
    "Modified: 8.6.1996 / 09:57:23 / cg"
!

redMaskForPixelValue
    "return the mask used with translation from pixelValues to redBits"

    ^ 16rFF
!

redShiftForPixelValue
    "return the shift amount used with translation from pixelValues to redBits"

    ^ -16
!

rgbFromValue:pixelValue
    "given a pixel value, return the corresponding 24bit rgbValue (rrggbb, red is MSB)."

    ^ pixelValue
!

samplesPerPixel
    "return the number of samples per pixel in the image."

    samplesPerPixel notNil ifTrue:[^ samplesPerPixel].
    ^ 3

    "Modified: 10.6.1996 / 18:03:09 / cg"
!

valueFromRedBits:redBits greenBits:greenBits blueBits:blueBits
    ^ (((redBits bitShift:8) bitOr:greenBits) bitShift:8) bitOr:blueBits
! !

!Depth24Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


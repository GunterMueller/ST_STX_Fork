"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Image subclass:#Depth16Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth16Image class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    this class represents 16 bit images.
    Only the minimum protocol is implemented here; much more is
    needed for higher performance operations on depth16 images.
    (however, 16bit images are seldom used, so falling back into the
    slow general methods from Image should not hurt too much ..)

    [author:]
	Claus Gittinger

    [see also:]
	Depth1Image Depth2Image Depth4Image Depth8Image Depth24Image
	ImageReader
"
! !

!Depth16Image class methodsFor:'queries'!

defaultPhotometric
    "return the default photometric pixel interpretation"

    ^ #rgb

    "Created: / 27-05-2007 / 14:04:11 / cg"
!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 16"

    ^ 16

    "Modified: 20.4.1996 / 23:40:01 / cg"
! !

!Depth16Image methodsFor:'accessing-pixels'!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixelValue.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |lineIndex "{ Class: SmallInteger }"|

    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    lineIndex := (width * 2 * y) + 1.

    ^ bytes unsignedInt16At:(lineIndex + (x * 2)) MSB:true.

    "Created: 24.4.1997 / 16:06:19 / cg"
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |lineIndex "{ Class: SmallInteger }"|

    lineIndex := (width * 2 * y) + 1.

    bytes unsignedInt16At:(lineIndex + (x * 2)) put:aPixelValue MSB:true

    "Created: 24.4.1997 / 17:06:21 / cg"
!

rowAt:y putAll:pixelArray startingAt:startIndex
    "store a single rows bits from bits in the pixelArray argument;
     Return the pixelArray.
     Notice: row coordinate starts at 0."

    |dstIdx "{ Class: SmallInteger }"
     srcIdx "{ Class: SmallInteger }"
     pixel
     bytes|

    bytes := self bits.
    dstIdx := (width * 2 * y) + 1.
    srcIdx := startIndex.
    1 to:width do:[:col |
        pixel := pixelArray at:srcIdx.
        "/ msbFirst
        bytes at:dstIdx put:((pixel bitShift:-8) bitAnd:16rFF).
        bytes at:dstIdx+1 put:(pixel bitAnd:16rFF).
        dstIdx := dstIdx + 2.
        srcIdx := srcIdx + 1.
    ].
    ^ pixelArray

    "Created: 24.4.1997 / 15:50:27 / cg"
! !

!Depth16Image methodsFor:'initialization'!

initialize
    super initialize.
    samplesPerPixel := 3.
    bitsPerSample := #[5 5 5].

    "Created: / 27-05-2007 / 14:09:46 / cg"
    "Modified: / 30-01-2017 / 18:24:16 / stefan"
! !

!Depth16Image methodsFor:'magnification'!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors"

%{
    unsigned char *srcP, *dstP;
    int _mag;
    REGISTER int i;
    REGISTER unsigned char byte1, byte2;
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
	    srcP += 2;
	    for (i=_mag; i>0; i--) {
		*dstP = byte1;
		*(dstP+1) = byte2;
		dstP += 2;
	    }
	}
	RETURN (self);
    }
%}.
    super
	magnifyRowFrom:srcBytes offset:srcStart
	into:dstBytes offset:dstStart factor:mX
! !

!Depth16Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 16
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 16
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    ^ width * 2.
!

isDepth16Image
    "return true if the image is instance of Depth16Image"
   (self bitsPerPixel == 16) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 16:59:55 / svestkap"
! !

!Depth16Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


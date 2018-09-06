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

Image subclass:#Depth1Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth1Image class methodsFor:'documentation'!

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
    this class represents bilevel (1 bit / pixel) images.
    It mainly consists of methods which are already implemented in Image,
    but reimplemented here for more performance. If you plan to do heavy
    image processing on bilevel images, you may want to add more
    specialized methods here.

    #blackIs0 / #whiteIs0 and #palette formats are supported here.

    [author:]
	Claus Gittinger

    [see also:]
	Depth2Image Depth4Image Depth8Image Depth16Image Depth24Image
	ImageReader
"
! !

!Depth1Image class methodsFor:'queries'!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 1"

    ^ 1

    "Modified: 20.4.1996 / 23:40:06 / cg"
! !

!Depth1Image methodsFor:'accessing-pixels'!

pixelAtX:x y:y
    "retrieve a pixelValue at x/y; return a pixel value.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at 0@0 for upper left pixel, end at
     (width-1)@(height-1) for lower right pixel"

    |index       "{Class: SmallInteger}"
     byte        "{Class: SmallInteger}"
     mask        "{Class: SmallInteger}"|

%{  /* NOCONTEXT */

    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__bothSmallInteger(x, y) 
     && __isSmallInteger(w)
     && __isByteArrayLike(b)
     && (__INST(pixelFunction)==nil) ) {
        int _w = __intVal(w);
        int _y = __intVal(y);
        int _x = __intVal(x);
        unsigned _byte;
        int _idx;

        _idx = ((_w + 7) >> 3) * _y + (_x >> 3);
        if ((unsigned)_idx < __byteArraySize(b)) {
            _byte = __ByteArrayInstPtr(b)->ba_element[_idx];
            RETURN( (_byte & (0x80 >> (_x & 7))) ? __MKSMALLINT(1) : __MKSMALLINT(0) );
        }
    }
%}.

    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    "/ the code below is only evaluated if the bytes-collection is
    "/ not a ByteArray, or the arguments are not integers

    index := (self bytesPerRow * y) + 1 + (x // 8).

    "left pixel is in high bit"
    byte := bytes at:index.
    mask := 1 bitShift:(7 - (x \\ 8)).
    (byte bitAnd:mask) == 0 ifTrue:[^ 0].
    ^ 1
!

pixelAtX:x y:y put:aPixelValue
    "set a pixels value at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |index       "{Class: SmallInteger}"
     byte        "{Class: SmallInteger}"
     mask        "{Class: SmallInteger}"|

%{  /* NOCONTEXT */

    OBJ b = __INST(bytes);
    OBJ w = __INST(width);

    if (__isByteArray(b) && __bothSmallInteger(x, y) && __isSmallInteger(w) ) {
        int _w = __intVal(w);
        int _y = __intVal(y);
        int _x = __intVal(x);
        int _idx;

        _idx = ((_w + 7) >> 3) * _y + (_x >> 3);
        if ((unsigned)_idx < __byteArraySize(b)) {
            if (aPixelValue == __MKSMALLINT(0)) {
                __ByteArrayInstPtr(b)->ba_element[_idx] &= ~(0x80 >> (_x & 7));
            } else {
                __ByteArrayInstPtr(b)->ba_element[_idx] |= (0x80 >> (_x & 7));
            }
            RETURN( self );
        }
    }
%}.
    "fall back code for nonByteArray or nonInteger arguments"

    index := (self bytesPerRow * y) + 1 + (x // 8).

    "left pixel is in high bit"
    byte := bytes at:index.
    mask := #[16r80 16r40 16r20 16r10 16r08 16r04 16r02 16r01] at:((x \\ 8) + 1).
    aPixelValue == 0 ifTrue:[
        byte := byte bitAnd:(mask bitInvert)
    ] ifFalse:[
        byte := byte bitOr:mask
    ].
    bytes at:index put:byte
! !

!Depth1Image methodsFor:'converting'!

asFormOn:aDevice
    "convert a monochrome image to a device form"

    ^ self anyImageAsFormOn:aDevice
!

clearMaskedPixels
    colorMap isNil ifTrue:[
        "this works only for b/w images"
        super clearMaskedPixels.
    ].
!

greyImageAsFormOn:aDevice
    "convert a greyscale image to a device form"

    ^ self anyImageAsFormOn:aDevice
!

greyImageAsMonoFormOn:aDevice
    "convert to a monochrome form - that's easy"

    ^ self anyImageAsFormOn:aDevice
!

paletteImageAsMonoFormOn:aDevice
    "convert a palette image to a b&w monochrome device form"

    |f c0 c1|

    f := Form imageForm width:width height:height fromArray:self bits onDevice:aDevice.
    c0 := self colorFromValue:0.
    c1 := self colorFromValue:1.
    c0 brightness > 0.5 ifTrue:[
        c0 := f whiteColor.
    ] ifFalse:[
        c0 := f blackColor.
    ].
    c1 brightness > 0.5 ifTrue:[
        c1 := f whiteColor
    ] ifFalse:[
        c1 := f blackColor.
    ].
    f colorMap:(Array with:c0 with:c1).
    ^ f

    "Modified: 24.4.1997 / 17:51:54 / cg"
!

paletteImageAsTrueColorFormOn:aDevice
    "since all devices must support monochrome images, and
     a 2-entry colormap is implemented by ST/X's drawForm methods,
     we can do this on all color devices as a palette image."

    ^ self anyImageAsFormOn:aDevice

    "
     |i|

     i := Depth1Image
		width:4
		height:4
		fromArray:#[ 2r00000000
			     2r11110000
			     2r01010000
			     2r10100000 ].
     i photometric:#rgb.
     i samplesPerPixel:3.
     i bitsPerSample:#(1 0 0).

     i := i magnifiedBy:30.
     i inspect.
    "

    "Modified: 14.6.1996 / 15:21:37 / cg"
! !

!Depth1Image methodsFor:'enumerating'!

colorsAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixel from x1 to x2 in row y.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using atX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     byte     "{ Class: SmallInteger }"
     mask     "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     color0 color1
     bytes|

    bytes := self bits.

    x1 := xLow.
    x2 := xHigh.
    srcIndex := (self bytesPerRow * y) + 1.

    "left pixel is in high bit"

    color0 := self colorFromValue:0.
    color1 := self colorFromValue:1.

    srcIndex := srcIndex + (x1 // 8).
    mask := #[2r10000000
	      2r01000000
	      2r00100000
	      2r00010000
	      2r00001000
	      2r00000100
	      2r00000010
	      2r00000001] at:((x1 \\ 8) + 1).

    byte := bytes at:srcIndex.
    x1 to:x2 do:[:x |
	(byte bitAnd:mask) == 0 ifTrue:[
	    aBlock value:x value:color0
	] ifFalse:[
	    aBlock value:x value:color1
	].

	mask := mask bitShift:-1.
	mask == 0 ifTrue:[
	    mask := 2r10000000.
	    srcIndex := srcIndex + 1.
	    x < x2 ifTrue:[
		byte := bytes at:srcIndex.
	    ]
	]
    ]

    "Created: 7.6.1996 / 19:12:26 / cg"
    "Modified: 10.6.1996 / 10:33:06 / cg"
!

valuesAtY:y from:xLow to:xHigh do:aBlock
    "perform aBlock for each pixelValue from x1 to x2 in row y.
     The block is passed the color at each pixel.
     This method allows slighly faster processing of an
     image than using atX:y:, since some processing can be
     avoided when going from pixel to pixel. However, for
     real image processing, specialized methods should be written."

    |srcIndex "{ Class: SmallInteger }"
     byte     "{ Class: SmallInteger }"
     mask     "{ Class: SmallInteger }"
     x1       "{ Class: SmallInteger }"
     x2       "{ Class: SmallInteger }"
     bytes|

    bytes := self bits.

    "this method needs more tuning, if used heavily
     (fetch 8 bits at once, unroll the loop over these 8 pixels)"

    x1 := xLow.
    x2 := xHigh.
    srcIndex := (self bytesPerRow * y) + 1.

    "left pixel is in high bit"

    srcIndex := srcIndex + (x1 // 8).
    mask := #[2r10000000
	      2r01000000
	      2r00100000
	      2r00010000
	      2r00001000
	      2r00000100
	      2r00000010
	      2r00000001] at:((x1 \\ 8) + 1).

    byte := bytes at:srcIndex.
    x1 to:x2 do:[:x |
	(byte bitAnd:mask) == 0 ifTrue:[
	    aBlock value:x value:0
	] ifFalse:[
	    aBlock value:x value:1
	].

	mask := mask bitShift:-1.
	mask == 0 ifTrue:[
	    mask := 2r10000000.
	    srcIndex := srcIndex + 1.
	    x < x2 ifTrue:[
		byte := bytes at:srcIndex.
	    ]
	]
    ]

    "Created: 7.6.1996 / 19:09:38 / cg"
    "Modified: 8.6.1996 / 13:36:37 / cg"
! !

!Depth1Image methodsFor:'magnification'!

hardMagnifiedBy:scalePoint
    "return a new image magnified by scalePoint, aPoint.
     This is the general magnification method, handling non-integral values.
     It is slower than the integral magnification method."

    |mX
     mY
     newWidth  "{ Class: SmallInteger }"
     newHeight "{ Class: SmallInteger }"
     newImage newBits bitsPerPixel newBytesPerRow
     newMask
     bytes|

    bytes := self bits.
    bytes isNil ifTrue:[
	self error:'cannot magnify image without bits'.
	^ self
    ].

    mX := scalePoint x.
    mY := scalePoint y.

    newWidth := (width * mX) truncated.
    newHeight := (height * mY) truncated.

    bitsPerPixel := self depth.
    newBytesPerRow := ((newWidth * bitsPerPixel) + 7) // 8.
    newBits := ByteArray new:(newBytesPerRow * newHeight).

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
	colorMap:colorMap copy
	bits:newBits
	mask:newMask.

    "walk over destination image fetching pixels from source image"

    mX := mX asFloat.
    mY := mY asFloat.

%{
{
    OBJ b1 = bytes;
    int _w1 = __intVal(__INST(width));
    int _y1, _y2;
    OBJ b2 = newBits;
    int _w2 = __intVal(newWidth);
    int _h2 = __intVal(newHeight);
    int _x2, _x1;
    int _idx2;
    unsigned _byte;
    double _mY = __floatVal(mY);
    double _mX = __floatVal(mX);

    for (_y2 = 0; _y2 < _h2; _y2++) {
	_y1 = (int)( (double)_y2 / _mY);

	for (_x2 = 0; _x2 < _w2; _x2++) {
	    _x1 = (int)( (double)_x2 / _mX);

	    _byte = __ByteArrayInstPtr(b1)->ba_element[(_w1 + 7) / 8 * _y1 + (_x1 / 8)];

	    if ((_byte & (0x80 >> (_x1 % 8)))) {
		_idx2 = (_w2 + 7) / 8 * _y2 + (_x2 / 8);
		__ByteArrayInstPtr(b2)->ba_element[_idx2] |= (0x80 >> (_x2 % 8));
	    }
	}
    }
}
%}.

"/    w := newWidth - 1.
"/    h := newHeight - 1.
"/
"/    0 to:h do:[:row |
"/        dstRow := row.
"/        srcRow := (row // mY).
"/        0 to:w do:[:col |
"/
"/            dstCol := col.
"/            srcCol := col // mX.
"/            value := self valueAtX:(col // mX) y:srcRow.
"/            newImage atX:col y:row putValue:value.
"/        ]
"/    ].

    ^ newImage

    "((Image fromFile:'bitmaps/claus.gif') magnifiedBy:0.5@0.5)"

    "Created: 18.6.1996 / 16:04:26 / cg"
!

magnifyRowFrom:srcBytes offset:srcStart
	  into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors.
     This method has been specially tuned for magnification by 2 and 4."

%{
    unsigned char *srcP, *dstP;
    int _mag;
    REGISTER int i;
    REGISTER unsigned char _byte;
    int _pixels, bpr;
    REGISTER int outcnt, bits, bit, mask, incnt;
    int shift;
    unsigned char byte1, byte2, byte3, byte4;
    OBJ w = __INST(width);

    /* helper for monochrome magnification by 2 */
    static unsigned char mag1[16] = {0x00, 0x03, 0x0c, 0x0f, 0x30, 0x33, 0x3c, 0x3f,
				     0xc0, 0xc3, 0xcc, 0xcf, 0xf0, 0xf3, 0xfc, 0xff};

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
		while (_pixels > 4) {
		    _byte = *srcP++;
		    *dstP++ = mag1[ _byte >> 4 ];
		    *dstP++ = mag1[ _byte & 0x0F ];
		    _pixels -= 8;
		}
		while (_pixels > 0) {
		    _byte = *srcP++;
		    *dstP++ = mag1[ _byte >> 4 ];
		    _pixels -= 8;
		}
		break;

	    case 4:
		/* tuned for this common case */
		while (_pixels > 6) {
		    _byte = *srcP++;
		    byte1 = mag1[_byte >> 4];
		    byte2 = mag1[byte1 & 0xF];
		    byte1 = mag1[byte1 >> 4];
		    byte3 = mag1[ _byte & 0x0F ];
		    byte4 = mag1[byte3 & 0xF];
		    byte3 = mag1[byte3 >> 4];

		    *dstP++ = byte1;
		    *dstP++ = byte2;
		    *dstP++ = byte3;
		    *dstP++ = byte4;
		    _pixels -= 8;
		}
		while (_pixels > 0) {
		    _byte = *srcP++;
		    byte1 = mag1[_byte >> 4];
		    byte2 = mag1[byte1 & 0xF];
		    byte1 = mag1[byte1 >> 4];
		    byte3 = mag1[_byte & 0x0F ];
		    byte4 = mag1[byte3 & 0xF];
		    byte3 = mag1[byte3 >> 4];

		    *dstP++ = byte1;
		    if (_pixels > 2) {
			*dstP++ = byte2;
			if (_pixels > 4) {
			    *dstP++ = byte3;
			    if (_pixels > 6) {
				*dstP++ = byte4;
			    }
			}
		    }
		    _pixels -= 8;
		}
		break;

	    default:
		bits = 0, incnt = 0, outcnt = 0;
		mask = 0x80;
		_byte = *srcP++;
		while (_pixels--) {
		    if (_byte & mask)
			bit = 1;
		    else
			bit = 0;
		    incnt++;
		    if (incnt == 8) {
			incnt = 0;
			mask = 0x80;
			_byte = *srcP++;
		    } else {
			mask >>= 1;
		    }

		    for (i=_mag; i>0; i--) {
			bits = (bits << 1) | bit;
			outcnt++;
			if (outcnt == 8) {
			    *dstP++ = bits;
			    bits = 0;
			    outcnt = 0;
			}
		    }
		}
		if (outcnt) {
		    *dstP = bits << (8-outcnt);
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

!Depth1Image methodsFor:'private'!

anyImageAsFormOn:aDevice
    "convert a 1-bit (possibly monochrome) image to a device form"

    |form color0 color1|

    ((aDevice == device) and:[deviceForm notNil]) ifTrue:[^ deviceForm].

    color0 := (self colorFromValue:0) exactOn:aDevice.
    color1 := (self colorFromValue:1) exactOn:aDevice.
    (color0 isNil or:[color1 isNil]) ifTrue:[
        "could not allocate colors, do it the hard way ..."
        ^ self paletteImageAsFormOn:aDevice.
    ].

    "all colors are available, this is easy now"

    form := Form imageForm onDevice:aDevice.
    form notNil ifTrue:[
        form
            colorMap:(Array with:color0 with:color1);
            width:width height:height fromArray:self bits;
            forgetBits.

        "/ remember deviceForm
        (device isNil or:[deviceForm isNil]) ifTrue:[
            device := aDevice.
            deviceForm := form.
            maskedPixelsAre0 := nil.
        ].
    ].
    ^ form

    "Modified: / 29-05-2007 / 19:32:09 / cg"
! !

!Depth1Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 1
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    |nbytes|

    nbytes := width // 8.
    ((width \\ 8) ~~ 0) ifTrue:[
	^ nbytes + 1
    ].
    ^ nbytes
!

colorFromValue:pixelValue
    "given a pixel value, return the corresponding color.
     Pixel values start with 0."

    photometric == #blackIs0 ifTrue:[
	(pixelValue == 0) ifTrue:[
	    ^ Color black
	].
	^ Color white
    ].
    photometric == #whiteIs0 ifTrue:[
	(pixelValue == 0) ifTrue:[
	    ^ Color white
	].
	^ Color black
    ].
    photometric == #palette ifTrue:[
	pixelValue < colorMap size ifTrue:[
	    ^ colorMap at:(pixelValue+1).
	]
    ].
    ^ super colorFromValue:pixelValue.
!

isDepth1Image
    "return true if the image is instance of Depth1Image"
   (self bitsPerPixel == 1) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 17:02:34 / svestkap"
!

rgbFromValue:pixelValue
    "given a pixel value, return the corresponding 24bit rgbValue (rrggbb, red is MSB).
     Pixel values start with 0."

    photometric == #blackIs0 ifTrue:[
	(pixelValue == 0) ifTrue:[
	    ^ 0
	].
	^ 16rFFFFFF
    ].
    photometric == #whiteIs0 ifTrue:[
	(pixelValue == 0) ifTrue:[
	    ^ 16rFFFFFF
	].
	^ 0
    ].
    photometric == #palette ifTrue:[
	pixelValue < colorMap size ifTrue:[
	    ^ (colorMap at:(pixelValue+1)) rgbValue
	]
    ].
    ^ super rgbFromValue:pixelValue.
!

usedColors
    "return a collection of colors used in the receiver.
     For depth1 images, we return the colorMap here, assuming all
     pixels are used ...
     ... which is not really true - it could be all-white or all-black"

    (photometric == #whiteIs0 or:[photometric == #blackIs0]) ifTrue:[
	^ Array
	    with:(Color black)
	    with:(Color white).
    ].
    photometric == #palette ifTrue:[
	^ colorMap
    ].
    ^ super usedColors

    "
     (Image fromFile:'bitmaps/garfield.gif') usedColors
     (Image fromFile:'bitmaps/SBrowser.xbm') usedColors
    "

    "Modified: / 28.7.1998 / 22:21:29 / cg"
!

usedValues
    "return a collection of color values used in the receiver."

    |bits first|

    bits := self bits.
    bits isEmptyOrNil ifTrue:[^ #() ].

    first := bits at:1.
    ((first == 0) or:[(first == 2r11111111)]) ifFalse:[ ^ #[0 1] ].

    bits do:[:eachByte |
        (first bitXor:eachByte) ~~ 0 ifTrue:[
            ^ #[0 1]
        ].
    ].
    ^ first == 0 ifTrue:[ #[0] ] ifFalse:[ #[1] ].

    "Modified: / 30-01-2017 / 19:21:52 / stefan"
!

valueFromColor:aColor
    "given a color, return the corresponding pixel value.
     Non-representable colors return nil."

    |clr0 clr1|

    photometric == #whiteIs0 ifTrue:[
	clr0 := Color white.
	clr1 := Color black.
    ] ifFalse:[
	photometric == #blackIs0 ifTrue:[
	    clr0 := Color black.
	    clr1 := Color white.
	] ifFalse:[
	    photometric ~~ #palette ifTrue:[
		^ super valueFromColor:aColor
	    ].
	    clr0 := colorMap at:1.
	    clr1 := colorMap at:2 ifAbsent:nil.
	]
    ].
    aColor = clr0 ifTrue:[
	^ 0.
    ].
    aColor = clr1 ifTrue:[
	^ 1
    ].

    "
     the color is not in the images colormap
    "
    ^ nil
! !

!Depth1Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


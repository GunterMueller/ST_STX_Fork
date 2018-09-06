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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ImageReader subclass:#PCXReader
	instanceVariableNames:'header buffer nBuffer bufferIndex sourceBytesPerRow'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!PCXReader class methodsFor:'documentation'!

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
    this class provides methods for loading 8-plane PCX bitmap files.

    Due to not having too many examples for testing, this could fail
    to read some files. 
    (especially, I have no uncompressed files for testing).

    Only 8-bit (i.e. 256 color) PCX images are supported.
    Image writing is not supported.

    [See also:]
	Image Form Icon
	BlitImageReader FaceReader GIFReader JPEGReader PBMReader 
	ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
	XBMReader XPMReader XWDReader 
"
!

examples
"
    Image fromFile:'/usr/share/lilo/suse_640x480.pcx'
"
! !

!PCXReader class methodsFor:'initialization'!

initialize
    "tell Image-class, that a new fileReader is present
     for the '.pcx' extension."

    MIMETypes defineImageType:'image/x-pcx'  suffix:'pcx' reader:self.

    "Modified: 27.6.1997 / 18:39:23 / cg"
! !

!PCXReader class methodsFor:'testing'!

isValidImageFile:aFilename
    "return true, if aFilename contains a PCX image"

    |count header inStream|

    inStream := self streamReadingFile:aFilename.
    inStream isNil ifTrue:[^ false].
    inStream binary.

    header := ByteArray uninitializedNew:128.
    count := inStream nextBytes:128 into:header.
    inStream close.

    ((count == 128) and:[self isValidPCXHeader:header]) ifFalse:[
	^ false
    ].
    ^ true

    "Modified: 17.9.1995 / 17:32:07 / claus"
!

isValidPCXHeader:aHeader
    "return true, if aHeader looks like a PCX image header"

    "check magic number"
    ((aHeader at:1) ~~ 16r0A) ifTrue:[
	^ false
    ].

    "check version"
    (#(0 2 3 5) includes:(aHeader at:2)) ifFalse:[
	^ false
    ].

    ^ true

    "Modified: 16.4.1997 / 22:24:32 / cg"
! !

!PCXReader methodsFor:'private-reading'!

extractColorMap16
    "extract the 16-entry colormap from the header"

    |rawMap|

    rawMap := header copyFrom:17 to:(17 + (16*3) - 1).
    ^ MappedPalette rgbBytesVector:rawMap 
!

nextByteFromBufferOrStream
    |byte|

    nBuffer ~~ 0 ifTrue:[
        byte := buffer at:bufferIndex.
        bufferIndex := bufferIndex + 1. nBuffer := nBuffer - 1.
    ] ifFalse:[
        byte := inStream next
    ].
    ^ byte
!

readColorMap256
    |rawMap mapSize|

    rawMap := ByteArray uninitializedNew:(256*3).
    nBuffer ~~ 0 ifTrue:[
        mapSize := buffer size - bufferIndex + 1.
        mapSize := mapSize min:(256*3).
        rawMap replaceFrom:1 to:mapSize with:buffer startingAt:bufferIndex.
        nBuffer < (256*3) ifTrue:[
            inStream nextBytes:((256*3)-nBuffer) into:rawMap startingAt:nBuffer+1
        ]
    ] ifFalse:[
        inStream nextBytes:(256*3) into:rawMap.
    ].

    ^ MappedPalette rgbBytesVector:rawMap 
!

readCompressedData
    |bendIndex rowIndex dstIndex endIndex byte nByte value idx2
     srcIndex|

    data := ByteArray uninitializedNew:(height * sourceBytesPerRow).

    buffer := ByteArray uninitializedNew:4096.
    bufferIndex := 1.
    bendIndex := 1.

    rowIndex := 1.
    1 to:height do:[:row |
        dstIndex := rowIndex.
        endIndex := dstIndex + sourceBytesPerRow.
        [dstIndex < endIndex] whileTrue:[
            bufferIndex == bendIndex ifTrue:[
                nBuffer := inStream nextBytes:4096 into:buffer.
                bufferIndex := 1.
                bendIndex := nBuffer + 1.
            ].
            byte := buffer at:bufferIndex.
            bufferIndex := bufferIndex + 1.
            ((byte bitAnd:2r11000000) ~~ 2r11000000) ifTrue:[
                data at:dstIndex put:byte.
                dstIndex := dstIndex + 1.
            ] ifFalse:[
                nByte := byte bitAnd:2r00111111.
                bufferIndex == bendIndex ifTrue:[
                    nBuffer := inStream nextBytes:4096 into:buffer.
                    bufferIndex := 1.
                    bendIndex := nBuffer + 1.
                ].
                value := buffer at:bufferIndex.
                bufferIndex := bufferIndex + 1.
                idx2 := ((dstIndex + nByte) min:endIndex) - 1.
                data from:dstIndex to:idx2 put:value.
                dstIndex := dstIndex + nByte.
            ].
        ].
        rowIndex := endIndex.
    ].

    "/ have to compress - above code reads sourceBytesPerRow
    "/ (to keep in sync with RLE); but we want width bytesPerRow
    "/ Can compress in the data-area; leftover pixels are simply ignored
    "/ by other image processing code
    "/
    sourceBytesPerRow ~~ width ifTrue:[
        dstIndex := width + 1.
        srcIndex := sourceBytesPerRow + 1.
        2 to:height do:[:row |
            data replaceFrom:dstIndex to:dstIndex+width-1 with:data startingAt:srcIndex.
            dstIndex := dstIndex + width.
            srcIndex := srcIndex + sourceBytesPerRow
        ]
    ].
    nBuffer := endIndex - bufferIndex.
!

readRestAfterHeader
    "read an raw image in pcx format from aStream.
     The header has already been read into the header argument."

    | inDepth version compression nPlanes xmin ymin xmax ymax
      paletteType 
      byte        "{Class: SmallInteger }" 
      nMaxPad|

    "/ typedef struct {                         /*header for PCX bitmap files*/
    "/    unsigned char       signature;          /*1 PCX file identifier*/
    "/    unsigned char       version;            /*2 version compatibility level*/
    "/    unsigned char       encoding;           /*3 encoding method*/
    "/    unsigned char       bitsperpix;         /*4 bits per pixel, or depth*/
    "/    unsigned short      Xleft;              /*5 X position of left edge*/
    "/    unsigned short      Ytop;               /*7 Y position of top edge*/
    "/    unsigned short      Xright;             /*9 X position of right edge*/
    "/    unsigned short      Ybottom;            /*11 Y position of bottom edge*/
    "/    unsigned short      Xscreensize;        /*13 X screen res of source image*/
    "/    unsigned short      Yscreensize;        /*15 Y screen res of source image*/
    "/    unsigned char       PCXpalette[16][3];  /*17 PCX color map*/
    "/    unsigned char       reserved1;          /*17+48 should be 0, 1 if std res fax*/
    "/    unsigned char       planes;             /*66 bit planes in image*/
    "/    unsigned short      linesize;           /*67 byte delta between scanlines */
    "/    unsigned short      paletteinfo;            /*0 == undef
    "/                                                  1 == color
    "/                                                  2 == grayscale*/
    "/    unsigned char reserved2[58];            /*fill to struct size of 128*/
    "/ } PCX_HEADER;

    version := header at:2.
"/    'version=' print. version printNL.
    compression := header at:3.
"/    'compression=' print. compression printNL.
    (#(0 1) includes:compression) ifFalse:[
        ^ self fileFormatError:'unknown compression'.
    ].

    inDepth := header at:4.
"/    'depth=' print. inDepth printNL.
    nPlanes := header at:66.
"/    'planes=' print. nPlanes printNL.
    sourceBytesPerRow := header wordAt:67 MSB:false.
"/    'srcBytesPerRow=' print. srcBytesPerRow printNL.
    paletteType := header at:69.

    "
     although it would be easy to implement ...
     I have no test pictures for other formats.
     So its not (yet) implemented
    "
    ((inDepth ~~ 8) or:[nPlanes ~~ 1]) ifTrue:[
"/        'PCXReader: depth: ' errorPrint. inDepth errorPrint. 
"/        ' planes:' errorPrint. nPlanes errorPrintNL.
        ^ self fileFormatError:'can only handle 1-plane 256 color images'.
    ].

    xmin := header wordAt:5 MSB:false. 
    ymin := header wordAt:7 MSB:false.
    xmax := header wordAt:9 MSB:false. 
    ymax := header wordAt:11 MSB:false.

    width := (xmax - xmin + 1).
    height := (ymax - ymin + 1).
"/    'width=' print. width printNL.
"/    'height=' print. width printNL.

    self reportDimension.

    (version == 2) ifTrue:[
        colorMap := self extractColorMap16.
    ].

    compression == 1 ifTrue:[
        self readCompressedData
    ] ifFalse:[
        self readUncompressedData
    ].

    (version == 5) ifTrue:[
        "/ RLE data is padded - skip over zeros for the 0C-byte
        nMaxPad := 15.
        byte := self nextByteFromBufferOrStream.

        [(byte ~~ 16r0C) and:[nMaxPad > 0]] whileTrue:[
            byte := self nextByteFromBufferOrStream.
        ].
        (byte == 16r0C) ifFalse:[
            'PCXREADER: no valid 256-entry palette (got' errorPrint. 
            byte errorPrint. '; expected ' errorPrint. 16rC0 errorPrint. ')' errorPrintCR.
        ].

        colorMap := self readColorMap256.
    ].

    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    "
     |i f|
     i := Image fromFile:'somefile.pcx'.
     i inspect.
    "

    "Modified: / 3.2.1998 / 17:59:03 / cg"
!

readUncompressedData
    |dstIndex|

    "
     actually untested ...
    "
    data := ByteArray uninitializedNew:(height * width).
    sourceBytesPerRow ~~ width ifTrue:[
        dstIndex := 1.
        1 to:height do:[:row |
            inStream nextBytes:width into:data startingAt:dstIndex.
            dstIndex := dstIndex + width.
            inStream skip:(sourceBytesPerRow - width).
        ]
    ] ifFalse:[
        inStream nextBytes:(height * width) into:data.
    ].
    nBuffer := 0.
! !

!PCXReader methodsFor:'reading'!

readImage
    "read an image in pcx format from inStream"

    inStream binary.

    header := ByteArray uninitializedNew:128.
    (inStream nextBytes:128 into:header) == 128 ifFalse:[
        ^ self fileFormatError:'short file'.
    ].

    (self class isValidPCXHeader:header) ifFalse:[
        ^ self fileFormatError:'wrong header'.
    ].

    self readRestAfterHeader.
! !

!PCXReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PCXReader.st,v 1.33 2003-11-19 15:38:20 cg Exp $'
! !


PCXReader initialize!

"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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

ImageReader subclass:#IrisRGBReader
	instanceVariableNames:'bytesPerPixel'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!IrisRGBReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    this class provides methods for loading Iris RGB format images. 
    Only 3-byte/pixel format is supported.
    Writing is not (yet) supported.

    [author:]
        Claus Gittinger

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
! !

!IrisRGBReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.rgb' extension."

    MIMETypes defineImageType:'image/x-rgb' suffix:'rgb' reader:self.

    "Modified: 14.4.1997 / 15:49:19 / cg"
! !

!IrisRGBReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains an IRIS_RGB image"

    |inStream magic type bpp dim w h bytesPerPixel|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    inStream binary.

    magic := inStream nextShortMSB:true.
    type := inStream nextShortMSB:true.
    dim := inStream nextShortMSB:true.
    w := inStream nextShortMSB:true.
    h := inStream nextShortMSB:true.
    bytesPerPixel := inStream nextShortMSB:true.
    inStream close.

    magic ~~ 8r0732 ifTrue:[^ false].
    bpp := type bitAnd:16r00FF.
    bpp ~~ 1 ifTrue:[^ false].
    bytesPerPixel ~~ 3 ifTrue:[^ false].

    ^ true

    "
     IrisRGBReader isValidImageFile:'/home2/cg/capture.rgb'
    "

    "Modified: 14.4.1997 / 16:51:58 / cg"
! !

!IrisRGBReader methodsFor:'private-reading'!

readRLEData 
    "read RLE compressed data."

    |rleBufferLen tableLen startTable lengthTable rleData
     tblIdx dstIdx|

    rleBufferLen := width * 2 + 10.
    tableLen := height * bytesPerPixel.

    startTable := Array new:tableLen.
    lengthTable := Array new:tableLen.
    rleData := ByteArray uninitializedNew:rleBufferLen.

    "/ read rowStart & length table

    inStream position1Based:512+1.
    1 to:tableLen do:[:i |
        startTable at:i put:(inStream nextLongMSB:true).
    ].
    1 to:tableLen do:[:i |
        lengthTable at:i put:(inStream nextLongMSB:true).
    ].

    data := ByteArray uninitializedNew:(width*height*bytesPerPixel).

    dstIdx := width * (height-1) * bytesPerPixel + 1.

    0 to:(height-1) do:[:y |
        0 to:(bytesPerPixel-1) do:[:z |
            |start length|

            tblIdx := y + (z*height) + 1.

            start := startTable at:tblIdx.
            length := lengthTable at:tblIdx.

            inStream position1Based:(start + 1).
            (inStream nextBytes:length into:rleData startingAt:1) ~~ length ifTrue:[
                self halt:'short read'
            ].
            (rleData at:length) ~~ 0 ifTrue:[
                self halt:'lengthTable not 0 terminated'.
            ].

            self class
                decompressRLEFrom:rleData at:1 
                into:data at:dstIdx+z increment:bytesPerPixel.

"/            self expandRow:rleData to:dstIdx+z. "/ (3-z).
        ].
        dstIdx := dstIdx - (width * bytesPerPixel).
    ].

    "
     IrisRGBReader fromFile:'/home2/cg/capture.rgb'
    "

    "Modified: 23.4.1997 / 18:59:11 / cg"
! !

!IrisRGBReader methodsFor:'reading'!

fromStream:aStream
    | magic type dim isRLE bpp|

    inStream := aStream.
    inStream binary.

    magic := inStream nextShortMSB:true.
    magic ~~ 8r0732 ifTrue:[
        ^ self fileFormatError:'bad magic number'.
    ].

    type := inStream nextShortMSB:true.
    dim := inStream nextShortMSB:true.
    width := inStream nextShortMSB:true.
    height := inStream nextShortMSB:true.
    bytesPerPixel := inStream nextShortMSB:true.

    isRLE := (type bitAnd:16rFF00) == 16r0100.
    bpp := type bitAnd:16r00FF.
    bpp ~~ 1 ifTrue:[
        ^ self fileFormatError:'only 1byte/pixel channel supported'.
    ].
    (bytesPerPixel ~~ 3 and:[ bytesPerPixel ~~ 4 ]) ifTrue:[
        ^ self fileFormatError:'can only read 3- and 4-channel images'.
    ].

    self reportDimension.

    isRLE ifTrue:[
        self readRLEData
    ] ifFalse:[
        "/ self readVerbatimData
        ^ self fileFormatError:'currently, only RLE encoding supported'.
    ].

    photometric := #rgba.
    samplesPerPixel := 4.
    bitsPerSample := #(8 8 8 8).

    "
     IrisRGBReader fromFile:'/home2/cg/capture.rgb'
    "

    "Created: / 14.4.1997 / 15:38:51 / cg"
    "Modified: / 1.4.1998 / 14:28:51 / cg"
! !

!IrisRGBReader methodsFor:'testing '!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Currently only B&W and Depth8 images are supported."

"/    |depth|
"/
"/    anImage photometric == #rgb ifTrue:[
"/        ^ false  "/ not yet implemented
"/    ].
"/    (depth := anImage depth) == 1 ifTrue:[^ true].
"/    depth == 8 ifTrue:[^ true].
    ^ false

    "Created: 14.4.1997 / 15:38:51 / cg"
    "Modified: 14.4.1997 / 15:58:20 / cg"
! !

!IrisRGBReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/IrisRGBReader.st,v 1.14 2013-03-06 09:01:16 cg Exp $'
! !


IrisRGBReader initialize!

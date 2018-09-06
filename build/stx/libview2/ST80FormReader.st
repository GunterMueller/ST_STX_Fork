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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ImageReader subclass:#ST80FormReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!ST80FormReader class methodsFor:'documentation'!

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
    this class provides methods for loading and saving st80-bitmap-file images.

    I am not sure, if this format is still supported/used by newer ST-80
    versions; it used to be in 2.x versions 
    (from what can be deduced by some bitmaps found in the manchester goodies).

    No writing is supported by this class.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader JPEGReader GIFReader PBMReader PCXReader 
        SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
! !

!ST80FormReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.form' extension."

    MIMETypes defineImageType:nil suffix:'form' reader:self.

    "Created: 1.2.1997 / 15:09:49 / cg"
! !

!ST80FormReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Only B&Wimages are supported."

    |photometric|

    anImage depth ~~ 1 ifTrue:[^ false].
    (((photometric := anImage photometric) ~~ #blackIs0) and:[photometric ~~ #whiteIs0]) ifTrue:[^ false.].
    ^ true
!

isValidImageFile:aFileName
    "return true, if aFileName contains an st80-bitmap-file image"

    |code inStream ok w h|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    inStream binary.
    code := inStream nextUnsignedInt16MSB:true.
    ok := (code == 1).

    w := inStream nextUnsignedInt16MSB:true.
    h := inStream nextUnsignedInt16MSB:true.
    ((w == 0) or:[h == 0]) ifTrue:[
        ok := false
    ].

    inStream close.
    ^ ok

    "Modified: 21.4.1997 / 19:48:56 / cg"
! !

!ST80FormReader methodsFor:'reading'!

fromStream:aStream
    "read an image in my format from aStream"

    |nBytes code offsetX offsetY|

    inStream := aStream.
    inStream binary.

    code := inStream nextUnsignedShortMSB:true.
    code isNil ifTrue:[
        ^ nil
    ].
    code ~~ 1 ifTrue:[
        ^ self fileFormatError:'expected magic 1'.
    ].

    width := aStream nextUnsignedShortMSB:true.
    height := aStream nextUnsignedShortMSB:true.
    ((width == 0) or:[height == 0]) ifTrue:[
        ^ self fileFormatError:'zero width/height'.
    ].
    offsetX := aStream nextUnsignedShortMSB:true.
    offsetY := aStream nextUnsignedShortMSB:true.
    self reportDimension.

    nBytes := width + 15 // 16 * 2 * height.
    data := ByteArray new:nBytes.
    aStream nextBytes:nBytes into:data.

    photometric := #whiteIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1)

    "ST80FormReader fromFile:''"

    "Modified: / 4.4.1998 / 18:24:40 / cg"
! !

!ST80FormReader methodsFor:'writing'!

save:image onStream:aStream
    "save image as XBM file on aStream."

    (self class canRepresent:image) ifFalse:[
        ^ Image cannotRepresentImageSignal 
            raiseWith:image
            errorString:('ST80Form format only supports monochrome images').
    ].

    image mask notNil ifTrue:[
        Image informationLostQuerySignal
            raiseWith:image
            errorString:('ST80Form format does not support an imageMask').
    ].

    outStream := aStream.

    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.
    colorMap := image colorMap.

    outStream binary.
    outStream nextPutWord:1.
    outStream nextPutWord:width.
    outStream nextPutWord:height.
    outStream nextPutWord:0.
    outStream nextPutWord:0.
    outStream nextPutBytes:(data size) from:data.

    "
     ST80FormReader save:(Image fromFile:'bitmaps/SBrowser.xbm') onFile:'test.form'
    "

    "Modified: 27.2.1997 / 12:46:00 / cg"
! !

!ST80FormReader class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


ST80FormReader initialize!

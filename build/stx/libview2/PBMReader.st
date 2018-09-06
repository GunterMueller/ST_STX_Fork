"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

ImageReader subclass:#PBMReader
	instanceVariableNames:'maxVal'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!PBMReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this class provides methods for loading and saving Portable BitMap-file 
    images (Jef Poskanzers portable bitmap package).

    Reading is supported for 1bit (pbm), greyscale (pgm) and 24bit (ppm) formats.
    (i.e. P1, P3, P4, P5, P6 and P7 formats)

    Writing is (currently) only supported for the binary formats;
    i.e. 1-bit images as (pbm P4), 8-bit gray as (pgm P5) and 24-bit images as (pnm P6).

    Q: should we broil this one to perfection and base all others on
       pipe-readers to the various pbmplus converters ?

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
! !

!PBMReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.pbm', '.pgm' and '.pnm' extensions."

    MIMETypes defineImageType:'image/x-portable-bitmap'  suffix:'pbm' reader:self.
    MIMETypes defineImageType:'image/x-portable-graymap' suffix:'pgm' reader:self.
    MIMETypes defineImageType:'image/x-portable-anymap'  suffix:'pnm' reader:self.
    MIMETypes defineImageType:'image/x-portable-pixmap'  suffix:'ppm' reader:self.

    "Modified: / 1.2.1997 / 15:02:14 / cg"
    "Created: / 3.2.1998 / 17:19:59 / cg"
! !

!PBMReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Currently, only 1bit B&W, 8bit-grey and 24bit RGB images are supported."

    |depth photometric|

    anImage photometric == #rgb ifTrue:[
        ^ depth==24
    ].
    (depth := anImage depth) == 1 ifTrue:[^ true].
    depth == 8 ifTrue:[
        photometric := anImage photometric.
        ^ (photometric == #blackIs0) or:[photometric == #whiteIs0]
    ].
    ^ false

    "Modified: 17.10.1997 / 20:20:52 / cg"
!

isValidImageFile:aFileName
    "return true, if aFileName contains a PBM image (which I can read)"

    |inStream pnmType ok|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].
    inStream text.
    ok := inStream next == $P.
    ok ifTrue:[
        pnmType := inStream next.
        ok := #( $1 $3 $4 $5 $6 $7) includes:pnmType.
    ].
    inStream close. 
    ^ ok

    "Modified: / 7.12.1998 / 14:27:11 / cg"
! !

!PBMReader methodsFor:'private-reading'!

readMaxVal
    self skipPBMJunk.
    maxVal := Integer readFrom:inStream onError:nil.
    (maxVal isNil or:[maxVal >= 256]) ifTrue: [
        self fileFormatError:'Invalid format'.
        ^ false.
    ].
    ^ true
!

readWidthAndHeight
    self skipPBMJunk.
    width := Integer readFrom:inStream onError:0.
    width > 0 ifFalse: [
        self fileFormatError:'Invalid width'.
        ^ false
    ].

    self skipPBMJunk.
    height := Integer readFrom:inStream onError:0.
    height > 0 ifFalse: [
        self fileFormatError:'Invalid height'.
        ^ false
    ].

    self reportDimension.
    ^ true
!

readWidthAndHeightAndMaxVal
    (self readWidthAndHeight) ifFalse:[ ^ false ].
    ^ self readMaxVal
!

skipPBMJunk
    "this method removes any superfluous characters from the input stream."

    | char foundNL|

    [
        char := inStream peek.
        [char == $#] whileTrue:[
            "Start of a comment. Skip to end-of-line."
"/            foundNL := (aStream skipUpTo: Character cr) notNil.
            foundNL := (inStream skipThrough: Character cr) notNil.
            foundNL ifFalse: [
                "Must be EOF"
                ^self
            ].
            char := inStream peek
        ].
        inStream atEnd not and: [char isSeparator]
    ] whileTrue: [inStream next]

    "Created: / 3.2.1998 / 17:20:37 / cg"
    "Modified: / 7.9.1998 / 15:49:07 / cg"
! !

!PBMReader methodsFor:'private-writing'!

writeCommonHeader:format on:aStream
    "common header for P4, P5 and P5 formats"

    aStream nextPutAll:format; cr.
    aStream nextPutAll:'# From Smalltalk/X on '.
    aStream nextPutAll:(Date today printString).
    aStream nextPutAll:' at '; nextPutAll:(Time now printString).
    aStream cr.
    aStream nextPutAll:(width printString); space; nextPutAll:(height printString).

    "Created: / 14.10.1997 / 20:01:05 / cg"
    "Modified: / 1.4.1998 / 14:30:47 / cg"
! !

!PBMReader methodsFor:'reading'!

fromStream:aStream
    "read a Portable bitmap file format as of Jeff Poskanzers Portable Bitmap Package.
     supported are PBM, PGB and PNM files." 

    | pnmType |

    inStream := aStream.
    inStream text.

    inStream next == $P ifFalse:[
        ^ self fileFormatError:'not PNM format'.
    ].
    pnmType := inStream next.

    (pnmType == $1) ifTrue: [
        ^ self readDepth1AsciiPBMStream
    ].
    (pnmType == $3) ifTrue: [
        ^ self readDepth24AsciiPBMStream
    ].
    (pnmType == $4) ifTrue: [
        ^ self readDepth1PBMStream
    ].
    (pnmType == $5) ifTrue: [
        ^ self readDepth8PGMStream
    ].
    (pnmType == $6) ifTrue: [
        ^ self readDepth24PPMStream
    ].
    (pnmType == $7) ifTrue: [
        ^ self readDepth8PPMStream
    ].
    ^ self fileFormatError:'No recognized PNM file format'.

    "
     PBMReader fromFile:'bitmaps/testimg.ppm'
     PBMReader fromFile:'../../fileIn/bitmaps/keyboard.pbm'
     PBMReader fromFile:'/home2/cg/ppm2fli_b1-92/jeff.001'
    "

    "Created: / 3.2.1998 / 17:25:34 / cg"
    "Modified: / 7.9.1998 / 15:44:29 / cg"
!

readDepth1AsciiPBMStream 
    "import portable bitmap ascii (PBM, P1 format); P1 is already read"

    |n bits rowIdx dstIdx bytesPerRow char|

    (self readWidthAndHeight) ifFalse:[^ nil].
    inStream nextLine "skipThrough: Character cr".

    bytesPerRow := (width + 7) // 8.
    data := ByteArray new:bytesPerRow * height.
    rowIdx := 1.

    1 to:height do:[:row |
        dstIdx := rowIdx.
        bits := 0. n := 0.
        1 to:width do:[:col |
            char := inStream next.
            [char notNil and:[char isSeparator]] whileTrue:[
                char := inStream next
            ].
            bits := bits bitShift:1.
            char == $1 ifTrue:[
                bits := bits bitOr:1
            ].
            n := n + 1.
            n == 8 ifTrue:[
                data at:dstIdx put:bits.
                dstIdx := dstIdx + 1.
                bits := 0.
                n := 0.
            ].
        ].
        n ~~ 0 ifTrue:[
            data at:dstIdx put:bits.
        ].
        rowIdx := rowIdx + bytesPerRow
    ].

    photometric := #whiteIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1).

    "Created: / 3.2.1998 / 17:21:22 / cg"
    "Modified: / 3.2.1998 / 17:56:32 / cg"
!

readDepth1PBMStream 
    "import portable bitmap (PBM, P4 format); P4 is already read"

    |bytesPerRow|

    (self readWidthAndHeight) ifFalse:[^ nil].
    inStream nextLine "skipThrough: Character cr".

    bytesPerRow := width // 8.
    ((width \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].

    "/ the rest is the binary image data ...
    inStream binary.
    data := ByteArray uninitializedNew:(bytesPerRow*height).
    inStream nextBytes:(data size) into:data.

    photometric := #blackIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1).

    "Created: / 3.2.1998 / 17:21:37 / cg"
    "Modified: / 3.2.1998 / 17:56:59 / cg"
!

readDepth24AsciiPBMStream
    "import ascii portable pixmap (PBM, P3 format); P3 is already read"

    |nBytes "{Class: SmallInteger }" 
     v      "{Class: SmallInteger }"
     c|

    (self readWidthAndHeightAndMaxVal) ifFalse:[^ nil].
    inStream nextLine "skipThrough: Character cr".

    nBytes := width*height*3.
    data := ByteArray new:nBytes.
    1 to:nBytes do:[:i |
        inStream skipSeparators.
        v := 0.
        c := inStream next.
        [c isDigit] whileTrue:[
            v := v * 10 + (c digitValue).
            c := inStream next.
        ].
        data at:i put:v
    ].

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := #(8 8 8).

    "Created: / 3.2.1998 / 17:21:55 / cg"
    "Modified: / 3.2.1998 / 17:57:30 / cg"
!

readDepth24PPMStream
    "import portable pixmap (PPM, P6 format); P6 is already read"

    (self readWidthAndHeightAndMaxVal) ifFalse:[^ nil].
    inStream nextLine "skipThrough: Character cr".

    "/ the rest is the binary image data ...
    inStream binary.
    data := ByteArray uninitializedNew:(width*height*3).
    inStream nextBytes:(data size) into:data.

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := #(8 8 8).

    "Created: / 3.2.1998 / 17:22:18 / cg"
    "Modified: / 3.2.1998 / 17:57:26 / cg"
!

readDepth8PGMStream
    "import portable gray map (PGM, P5 format); P5 is already read"

    (self readWidthAndHeightAndMaxVal) ifFalse:[^ nil].
    inStream nextLine "skipThrough: Character cr".

    "/ the rest is the binary image data ...
    inStream binary.
    data := ByteArray uninitializedNew:(width*height).
    inStream nextBytes:(data size) into:data.

    photometric := #blackIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    "Modified: / 3.2.1998 / 17:57:21 / cg"
!

readDepth8PPMStream
    "import portable pixmap (PPM, P7 format); P7 is already read"

    | bitsRed bitsGreen bitsBlue|

    inStream skipSeparators.
    bitsRed := inStream next - $0.
    bitsGreen := inStream next - $0.
    bitsBlue := inStream next - $0.

    (self readWidthAndHeightAndMaxVal) ifFalse:[^ nil].
    inStream nextLine "skipThrough: Character cr".

    "/ the rest is the binary image data ...
    inStream binary.
    data := ByteArray uninitializedNew:(width*height*1).
    inStream nextBytes:(data size) into:data.

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := (Array with:bitsRed with:bitsGreen with:bitsBlue).

    "Created: / 7.9.1998 / 15:44:05 / cg"
    "Modified: / 7.9.1998 / 15:50:36 / cg"
! !

!PBMReader methodsFor:'writing'!

save:image onStream:aStream
    "save image as PBM/PGM/PNM file on aFileName"

    |bitsPerPixel|

    image mask notNil ifTrue:[
        Image informationLostQuerySignal
            raiseWith:image
            errorString:('PBM format does not support an imageMask').
    ].

    outStream := aStream.

    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.
    colorMap := image colorMap.
    data := image bits.
    bitsPerPixel := image bitsPerPixel.

    photometric == #rgb ifTrue:[
        ^ self writePNMFileOn:outStream
    ].
    samplesPerPixel == 1 ifTrue:[
        (bitsPerPixel == 1) ifTrue:[
            ^ self writePBMFileOn:outStream
        ].
        (bitsPerPixel == 8) ifTrue:[
            ^ self writePGMFileOn:outStream
        ].
    ].

    ^ Image cannotRepresentImageSignal 
        raiseWith:image
        errorString:('PBMReader cannot represent this image').

    "
     |img|

     img := Image fromFile:'bitmaps/SBrowser.xbm'.
     img inspect.
     PBMReader save:img onFile:'test.pbm'.
     img := Image fromFile:'test.pbm'.
     img inspect.


     |img mono|

     img := Image fromFile:'bitmaps/garfield.gif'.
     img inspect.
     mono := img asMonochromeFormOn:Display.
     img := mono asImage.
     img inspect.
     PBMReader save:img onFile:'test.pbm'.
     img := Image fromFile:'test.pbm'.
     img inspect.
    "

    "Modified: / 30.9.1998 / 23:30:43 / cg"
!

writePBMFileOn:aStream
    "Saves the receivers image on the file fileName in Portable Bitmap format."

    self writeCommonHeader:'P4' on:aStream.
    aStream cr.

    aStream binary.
    photometric == #blackIs0 ifTrue:[
        aStream nextPutAll:data.
    ] ifFalse:[
        data invert.
        aStream nextPutAll:data.
        data invert.
    ].
    aStream close.

    "
     |i i2|

     i := Image fromFile:'bitmaps/SBrowser.xbm'.
     PBMReader save:i onFile:'foo.pbm'.
     i2 := Image fromFile:'foo.pbm'.
     i2 inspect.
    "

    "Modified: 14.10.1997 / 20:06:49 / cg"
!

writePGMFileOn:aStream
    "Saves the receivers image on the file fileName in Portable Greymap format."

    self writeCommonHeader:'P5' on:aStream.
    aStream space.
    aStream nextPutAll:255 printString.
    aStream cr.

    data size ~~ (width * height) ifTrue:[
        "/ self halt:'data size mismatch'.
    ].

    aStream binary.
    photometric == #blackIs0 ifTrue:[
        aStream nextPutAll:data.
    ] ifFalse:[
        data invert.
        aStream nextPutAll:data.
        data invert.
    ].
    aStream close.

    "
     |i gI i2|

     i := Image fromFile:'bitmaps/gifImages/garfield.gif'.
     gI := i asFloydSteinbergDitheredGrayImageDepth:8.
     PBMReader save:gI onFile:'foo.pgm'.
     i2 := Image fromFile:'foo.pgm'.
     i2 inspect.
    "

    "Modified: 14.10.1997 / 20:06:58 / cg"
!

writePNMFileOn:aStream
    "Saves the receivers image on the file fileName in Portable Anymap format."

    self writeCommonHeader:'P6' on:aStream.
    aStream space.
    aStream nextPutAll:255 printString.
    aStream cr.

    data size ~~ (width * height * 3) ifTrue:[
        "/ self halt:'data size mismatch'.
    ].

    aStream binary.
    aStream nextPutAll:data.
    aStream close.

    "
     |i i2|

     i := Image fromFile:'bitmaps/granite.tiff'.
     PBMReader save:i onFile:'foo.pnm'.
     i2 := Image fromFile:'foo.pnm'.
     i2 inspect.
    "

    "Modified: 14.10.1997 / 20:07:08 / cg"
! !

!PBMReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PBMReader.st,v 1.42 2003-11-19 15:38:51 cg Exp $'
! !


PBMReader initialize!

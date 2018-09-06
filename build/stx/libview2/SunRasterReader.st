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

ImageReader subclass:#SunRasterReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!SunRasterReader class methodsFor:'documentation'!

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
    this class provides methods for loading Sun Raster and
    Sun Icon file images.

    No image writing is implemented.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader JPEGReader GIFReader PBMReader PCXReader 
        ST80FormReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
! !

!SunRasterReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.icon' and '.im8' extensions."

    MIMETypes defineImageType:nil suffix:'icon' reader:self.
    MIMETypes defineImageType:nil suffix:'im8'  reader:self.

    "Modified: 1.2.1997 / 15:08:40 / cg"
! !

!SunRasterReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains a sunraster image"

    |inStream nr|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    "try sun raster"
    inStream binary.
    (((inStream nextUnsignedInt16MSB:true) == 16r59A6) 
    and:[(inStream nextUnsignedInt16MSB:true) == 16r6A95]) ifTrue: [
        inStream close.
        ^ true
    ].

    inStream isPositionable ifFalse:[^ false].

    "try sun bitmap image format"
    inStream text.
    inStream reset.

    "must start with a comment"
    inStream skipSeparators.
    inStream next ~~ $/ ifTrue:[^ false].
    inStream next ~~ $* ifTrue:[^ false].

    (inStream skipThroughAll: 'idth') isNil ifTrue: [
        inStream close.
        ^ false
    ].
    inStream next; skipSeparators.
    nr := Integer readFrom: inStream.
    (nr isNil or:[nr <= 0]) ifTrue: [
        inStream close.
        ^ false
    ].

    (inStream skipThroughAll: 'eight') isNil ifTrue: [
        inStream close.
        ^ false
    ].
    inStream next; skipSeparators.
    nr := Integer readFrom: inStream.
    (nr isNil or:[nr <= 0]) ifTrue: [
        inStream close.
        ^ false
    ].

    inStream close.
    ^ true
! !

!SunRasterReader methodsFor:'reading'!

fromStream: aStream 
    "read an image in my format from aStream.
     Dtermine if its a raster or icon file."

    | rasterType mapType mapBytes imageWords form depth 
      rMap gMap bMap mapLen
      a b c index pos|

    inStream := aStream.

    aStream binary.

    pos := aStream position.
    ((aStream nextWord == 16r59A6) 
    and:[aStream nextWord == 16r6A95]) ifFalse: [
"/        'SUNReader: not a SunRaster file' errorPrintNL.
        aStream position:pos.
        ^ self fromSunIconStream:aStream
    ].

    width := aStream nextLong.
    height := aStream nextLong.
    self reportDimension.

    depth := aStream nextLong.
    aStream nextLong.   "Ignore the image length since I can't rely on it anyway."
    rasterType := aStream nextLong.
    mapType := aStream nextLong.  "Ignore the raster maptype."
    mapBytes := aStream nextLong.  

    depth = 8 ifTrue: [
        mapLen := (mapBytes // 3).
        rMap := aStream nextBytes:mapLen.
        gMap := aStream nextBytes:mapLen.
        bMap := aStream nextBytes:mapLen.
        colorMap := MappedPalette redVector:rMap greenVector:gMap blueVector:bMap.

        data := ByteArray uninitializedNew:(width * height).
        aStream nextBytes:(width * height) into:data.

        photometric := #palette.
        samplesPerPixel := 1.
        bitsPerSample := #(8).

        ^ self
    ].
    depth ~~ 1 ifTrue: [
        ^ self fileFormatError:'only depth 1 and 8 supported'.
    ].

    form := nil.

    aStream skip: mapBytes.  "Skip the color map."
    imageWords := (width / 16) ceiling * height.
    data := ByteArray uninitializedNew:(imageWords * 2).

    (rasterType between: 0 and: 2) ifFalse: [
        ^ self fileFormatError:'Unknown raster file rasterType'.
    ].

    (rasterType = 2)  ifFalse: [
        "no compression of bytes"
        aStream nextBytes:(imageWords * 2) into:data
    ] ifTrue: [ 
        "run length compression of bytes"

        index := 1.
        a := aStream next.
        [a notNil] whileTrue: [
            (a = 128) ifFalse: [
                data at:index put: a.
                index := index + 1
            ] ifTrue: [
                b := aStream next.
                b = 0 ifTrue: [
                    data at:index put:128 .
                    index := index + 1
                ] ifFalse: [
                    c := aStream next.
                    1 to:(b+1) do:[:i |
                        data at:index put:c.
                        index := index + 1
                    ]
                ]
            ].
            a := aStream next
        ].
    ].
    photometric := #whiteIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1).

    "
     Image fromFile:'bitmaps/founders.im8'
     Image fromFile:'bitmaps/bf.im8'
     SunRasterReader fromStream:'bitmaps/founders.im8' asFilename readStream
     SunRasterReader fromStream:'bitmaps/bf.im8' asFilename readStream
    "

    "Modified: / 3.2.1998 / 18:00:35 / cg"
!

fromSunIconStream:aStream 
    "helper: read an image in icon format from aStream"

    |index word 
     w "{ Class: SmallInteger }"
     h "{ Class: SmallInteger }"|

    inStream := aStream.
    aStream text.

    (aStream skipThroughAll:'idth') isNil ifTrue: [
        ^ self fileFormatError:'Not a Sun Raster/Icon File'.
    ].
    aStream next; skipSeparators. "skip $="
    width := Integer readFrom: aStream.
    (width isNil or:[width <= 0]) ifTrue: [
        ^ self fileFormatError:'format error (expected number)'.
    ].
    w := width.

    (aStream skipThroughAll:'eight') isNil ifTrue: [
        ^ self fileFormatError:'format error (expected height)'.
        ^ nil
    ].
    aStream next; skipSeparators. "skip $="
    height := Integer readFrom: aStream.
    (height isNil or:[height <= 0]) ifTrue: [
        ^ self fileFormatError:'format error (expected number)'.
    ].
    h := height.

    data := ByteArray uninitializedNew:((width + 7 // 8) * height).
    photometric := #whiteIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1).

    index := 0.
    1 to:h do: [:row |
        1 to: (w + 15 // 16) do: [:col |
            "rows are rounded up to next multiple of 16 bits"
            (aStream skipThroughAll:'0x') isNil ifTrue: [^ nil]. 
            word := Integer readFrom:aStream radix:16.
            word isNil ifTrue:[
                ^ self fileFormatError:'format error'.
            ].
            data at: (index := index + 1) put: (word bitShift:-8).
            data at: (index := index + 1) put: (word bitAnd:16rFF).
        ]
    ].

    "Modified: / 3.2.1998 / 18:01:15 / cg"
! !

!SunRasterReader class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


SunRasterReader initialize!

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

ImageReader subclass:#TargaReader
	instanceVariableNames:'orientation bytesPerRow bytesPerPixel'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!TargaReader class methodsFor:'documentation'!

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
    this class provides methods for loading targa-file (tga) images.

    Limitations: 
        not fully tested (I only had a few targa files to check things)
        only supports 8,24 and 32 bits/pixel formats; alpha channel is ignored
        Image saving not supported

    I had two tga files to test this code with - it may not work with
    other targa files (it certainly does not work with 1/16 bit images).

    Suggestions: adapt & use the pbmplus library here.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader
"
!

format
"
    Shorts etc. are lsb.

    offset:

        1       lenID           byte
        2       hasColorMap     byte
        3       imageType       byte
                         1   MapRGB  
                         2   RawRGB   
                         3   RawMono   
                         9   MapEnCode 
                         10  RawEnCode 
        4, 5    cmapOffset      short
        6, 7    cmapLength      short
        8       cmapEntrySize   short
        9,10    xOrg            short
        11,12   yOrg            short

        13,14   width 
        15,16   height 
        17      depth 
        18      flags
                        0000 xxxx  attribute-bits-per-pixel
                        0000 0001  greysc
                        0000 0010  colour
                        0000 0011  mapped
                        0000 0100  rleEncoded
                        0000 1000  interlaced
                        00xx 0000  origin (0 -> lower-left / 1 -> l-r / 2 -> u-l / 3 -> u-r)
                        xx00 0000  interleave (0 -> none / 1 -> odd/even / 2 ->4-fould / 3 reserved)

        19..    len             lenID-bytes
        ..      colorMap        cmapLength*3 bytes iff hasColorMap ~~ 0
"
! !

!TargaReader class methodsFor:'initialization'!

initialize
    "tell Image-class, that a new fileReader is present
     for the '.tga' extension."

    MIMETypes defineImageType:'image/x-targa' suffix:'tga' reader:self.

    "Modified: 27.6.1997 / 18:39:43 / cg"
! !

!TargaReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains a targa-file image"

    |aStream w h depth flags imageType ok|

    ok := true.

    aStream := self streamReadingFile:aFileName.
    aStream isNil ifTrue:[^ false].
    aStream binary.

    aStream next.   "lenID"
    aStream next.   "hasColorMap"
    imageType := aStream next.  
    aStream skip:2. "cmapOffset"
    aStream skip:2. "cmapLength"
    aStream next.   "cmapEntrySize"
    aStream skip:2. "xOrg"
    aStream skip:2. "yOrg"

    w := aStream nextShortMSB:false.
    h := aStream nextShortMSB:false.

    depth := aStream next.
    flags := aStream next.

    "/ MapRGB == 1
    "/ RawRGB == 2
    "/ RawMono == 3
    "/ MapEnCode == 9
    "/ RawEnCode == 10

    (#(1 2 3 9 10) includes:imageType) ifFalse:[
        "/ 'TargaReader [warning]: unsupported imageType: ' errorPrint. imageType errorPrintCR.
        ok := false
    ] ifTrue:[
        (#(8 "16" 24 32) includes:depth) ifFalse:[
            ok := false
        ].
    ].
    aStream close. 
    ^ ok

    "
     TargaReader isValidImageFile:'bitmaps/test.tga'    
     TargaReader isValidImageFile:'bitmaps/garfield.gif'  
    "

    "Modified: 21.4.1997 / 20:46:52 / cg"
! !

!TargaReader methodsFor:'private-reading'!

handleImageOrientation
    |rowIdx startIdx endIdx t|

    orientation == #topLeft ifTrue:[
        ^ self.
    ].

    orientation == #topRight ifTrue:[
        "/ flip horizontal
        rowIdx := 1.
        1 to:height do:[:row |
            startIdx := rowIdx.
            endIdx := rowIdx + bytesPerRow - bytesPerPixel.
            1 to:width//2 do:[:x |
                0 to:bytesPerPixel-1 do:[:c |
                    t := data at:startIdx+c.
                    data at:startIdx+c put:(data at:endIdx+c).
                    data at:endIdx+c put:t.
                ].
                startIdx := startIdx + bytesPerPixel.
                endIdx := endIdx - bytesPerPixel.
            ].
            rowIdx := rowIdx + width.
        ].
        ^ self.
    ].

    orientation == #bottomLeft ifTrue:[
        "/ flip vertical
        startIdx := 1.
        endIdx := 1 + ((height - 1) * bytesPerRow).
        t := ByteArray new:bytesPerRow.
        1 to:height//2 do:[:row |
            t replaceFrom:1 to:bytesPerRow with:data startingAt:startIdx.
            data replaceFrom:startIdx to:startIdx+bytesPerRow-1 with:data startingAt:endIdx.
            data replaceFrom:endIdx to:endIdx+bytesPerRow-1 with:t startingAt:1.
            startIdx := startIdx + bytesPerRow.
            endIdx := endIdx - bytesPerRow
        ].
        ^ self.
    ].

    'TargaReader [warning]: unsupported orientation: ' errorPrint. orientation errorPrintCR.
!

read24
    "read a 24 bit/pixel targa-image"

    |totalBytes|

    totalBytes := width * height * 3.
    data := ByteArray new:totalBytes.
    inStream nextBytes:totalBytes into:data.

    "
     mhmh - pixel-byte order is blue-green-red
     swap blue & red bytes
    "
    self class swap:totalBytes bytesFromRGB_to_BGR_in:data.

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := #(8 8 8).
!

read24RLE
    "read an 8 bit/pixel rle encoded targa-image"

    |total count dstIndex code n r g b|

    data := ByteArray new:((total := width * height * 3)).
    count := 0.
    dstIndex := 1.
    [count < total] whileTrue:[
        code := inStream nextByte.
        n := (code bitAnd:16r7F) + 1.
        (code bitAnd:16r80) ~~ 0 ifTrue:[
            b := inStream nextByte.
            g := inStream nextByte.
            r := inStream nextByte.
            n timesRepeat:[
                data at:dstIndex put:r.
                data at:dstIndex+1 put:g.
                data at:dstIndex+2 put:b.
                dstIndex := dstIndex + 3
            ].
        ] ifFalse:[
            n timesRepeat:[
                b := inStream nextByte.
                g := inStream nextByte.
                r := inStream nextByte.
                data at:dstIndex put:r.
                data at:dstIndex+1 put:g.
                data at:dstIndex+2 put:b.
                dstIndex := dstIndex + 3
            ]
        ].
        count := count + (n * 3).
    ].

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := #(8 8 8).

    "Modified: 21.4.1997 / 20:21:12 / cg"
    "Created: 21.4.1997 / 20:43:23 / cg"
!

read32
    "read a 32 bit/pixel targa-image; skip alpha channel (for now)"

    |totalBytes remainingBytes dstIndex a r g b|

    totalBytes := width * height * 3.
    data := ByteArray new:totalBytes.

    dstIndex := 1.
    remainingBytes := totalBytes.
    [remainingBytes > 0] whileTrue:[
        b := inStream nextByte.
        g := inStream nextByte.
        r := inStream nextByte.
        a := inStream nextByte.   "/ alpha - skipped
        data at:dstIndex   put:r.
        data at:dstIndex+1 put:g.
        data at:dstIndex+2 put:b.
        dstIndex := dstIndex + 3.
        remainingBytes := remainingBytes - 3.
    ].

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := #(8 8 8).

    "
     TargaReader fromFile:'/phys/exept//unsaved1/pd_stuff/graphic/3d_engines/crystal_space/CS/plugins/video/canvas/sdl/img/move.tga'
     TargaReader fromFile:'/phys/exept/unsaved2/smalltalk/Squeak/croquet/Croquet/Content/Cisco/2520/Textures/2520caseback.tga'
     TargaReader fromFile:'/phys/exept/unsaved2/smalltalk/Squeak/croquet/Croquet/Content/Cisco/2520/Textures/2520dimm1front.tga'
    "
!

read32RLE
    "read a 32 bit/pixel rle encoded targa-image; skip alpha channel (for now)"

    |total count dstIndex code n a r g b|

    data := ByteArray new:((total := width * height * 3)).
    count := 0.
    dstIndex := 1.
    [count < total] whileTrue:[
        code := inStream nextByte.
        n := (code bitAnd:16r7F) + 1.
        (code bitAnd:16r80) ~~ 0 ifTrue:[
            b := inStream nextByte.
            g := inStream nextByte.
            r := inStream nextByte.
            a := inStream nextByte.             "/ alpha - skipped
            n timesRepeat:[
                data at:dstIndex put:r.
                data at:dstIndex+1 put:g.
                data at:dstIndex+2 put:b.
                dstIndex := dstIndex + 3
            ].
        ] ifFalse:[
            n timesRepeat:[
                b := inStream nextByte.
                g := inStream nextByte.
                r := inStream nextByte.
                a := inStream nextByte.         "/ alpha - skipped
                data at:dstIndex put:r.
                data at:dstIndex+1 put:g.
                data at:dstIndex+2 put:b.
                dstIndex := dstIndex + 3
            ]
        ].
        count := count + (n * 3).
    ].

    photometric := #rgb.
    samplesPerPixel := 3.
    bitsPerSample := #(8 8 8).

    "Created: 21.4.1997 / 20:43:54 / cg"
    "Modified: 21.4.1997 / 20:45:49 / cg"
!

read8
    "read an 8 bit/pixel targa-image"

    data := ByteArray new:(width * height).
    inStream nextBytes:(data size) into:data.

    colorMap isNil ifTrue:[
        photometric := #blackIs0.
    ] ifFalse:[
        photometric := #palette.
    ].
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    "Created: 21.4.1997 / 20:12:35 / cg"
    "Modified: 21.4.1997 / 20:39:02 / cg"
!

read8RLE
    "read an 8 bit/pixel rle encoded targa-image"

    |total count dstIndex code n byte|

    data := ByteArray new:((total := width * height)).
    count := 0.
    dstIndex := 1.
    [count < total] whileTrue:[
        code := inStream nextByte.
        n := (code bitAnd:16r7F) + 1.
        (code bitAnd:16r80) ~~ 0 ifTrue:[
            byte := inStream nextByte.
            data from:dstIndex to:dstIndex+n-1 put:byte.
        ] ifFalse:[
            inStream nextBytes:n into:data startingAt:dstIndex.
        ].
        count := count + n.
        dstIndex := dstIndex + n.
    ].

    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    "Created: 21.4.1997 / 20:19:46 / cg"
    "Modified: 21.4.1997 / 20:21:12 / cg"
!

readColorMap:cmapLength
    colorMap := Array new:cmapLength.
    1 to:cmapLength do:[:index |
        |r g b|

        b := inStream nextByte.
        g := inStream nextByte.
        r := inStream nextByte.
        (r isNil or:[g isNil or:[b isNil]]) ifTrue:[
            ^ self fileFormatError:('short file - probably not targa format').
        ].
        colorMap at:index put:(Color redByte:r greenByte:g blueByte:b).
    ].
    ^ colorMap
! !

!TargaReader methodsFor:'reading'!

readImage
    "read a targa-image from aFileName. return the receiver (with all
     relevant instance variables set for the image) or nil on error"

    |depth flags lenID hasColorMap imageType 
     cmapOffset cmapLength cmapEntrySize xOrg yOrg rle|

    inStream binary.

    lenID := inStream next.
    hasColorMap := inStream next.
    imageType := inStream next.
    cmapOffset := inStream nextShortMSB:false.
    cmapLength := inStream nextShortMSB:false.
    cmapEntrySize := inStream next.
    xOrg := inStream nextShortMSB:false.
    yOrg := inStream nextShortMSB:false.

    width := inStream nextShortMSB:false.
    height := inStream nextShortMSB:false.
    depth := inStream next.
    (#(8 "16" 24 32) includes:depth) ifFalse:[
        ^ self fileFormatError:('unsupported depth: ', depth printString).
    ].
    depth == 32 ifTrue:[
        'TargaReader [info]: alpha channel ignored' infoPrintCR.
    ] ifFalse:[
        'TargaReader [info]: depth: ' infoPrint. depth infoPrintCR.
    ].

    "/ MapRGB == 1
    "/ RawRGB == 2
    "/ RawMono == 3
    "/ MapEnCode == 9
    "/ RawEnCode == 10

    (#(1 2 9 10) includes:imageType) ifFalse:[
        "/ 'TargaReader [warning]: unsupported imageType: ' errorPrint. imageType errorPrintCR.
        ^ self fileFormatError:('unsupported imageType: ', imageType printString).
    ].
    'TargaReader [info]: imageType: ' infoPrint. imageType infoPrintCR.

    self reportDimension.

    "/ flags:
    "/    0000 xxxx  attribute-bits-per-pixel
    "/    0000 0001  greysc
    "/    0000 0010  colour
    "/    0000 0011  mapped
    "/    0000 0100  rleEncoded
    "/    0000 1000  interlaced
    "/    00xx 0000  origin (0 -> lower-left / 1 -> l-r / 2 -> u-l / 3 -> u-r)
    "/    xx00 0000  interleave (0 -> none / 1 -> odd/even / 2 ->4-fould / 3 reserved)
    "/
    flags := inStream next.

    (flags bitAnd:2r11000000) ~~ 0 ifTrue:[
        ^ self fileFormatError:('unsupported interlace: ' , flags printString).
    ].

    rle := flags bitTest:2r000001000.
    flags := flags bitAnd:2r111110111.

    (flags bitAnd:2r00001111) ~~ 0 ifTrue:[
        ^ self fileFormatError:('unsupported flags: ' , flags printString).
    ].

    (flags bitAnd:2r00110000) == 16r20 ifTrue:[
        orientation := #topLeft
    ] ifFalse:[
        (flags bitAnd:2r00110000) == 16r30 ifTrue:[
            orientation := #topRight
        ] ifFalse:[
            (flags bitAnd:2r00110000) == 16r10 ifTrue:[
                orientation := #bottomRight
            ] ifFalse:[
                (flags bitAnd:2r00110000) == 0 ifTrue:[
                    orientation := #bottomLeft
                ]
            ]
        ]
    ].

    lenID ~~ 0 ifTrue:[
        inStream skip:lenID
    ].

    hasColorMap ~~ 0 ifTrue:[
        "/ read the colorMap
        colorMap := self readColorMap:cmapLength.
        'TargaReader [info]: has colorMap' infoPrintCR.
    ].

    depth == 32 ifTrue:[
        imageType == 2 ifTrue:[
"/            rle ifTrue:[self halt:'oops - should not happen'].
            self read32.
        ] ifFalse:[
"/            rle ifFalse:[self halt:'oops - should not happen'].
            self read32RLE.
        ].
        bytesPerRow := width*3.
        bytesPerPixel := 3.
    ].
    depth == 24 ifTrue:[
        imageType == 2 ifTrue:[
"/            rle ifTrue:[self halt:'oops - should not happen'].
            self read24.
        ] ifFalse:[
"/            rle ifFalse:[self halt:'oops - should not happen'].
            self read24RLE.
        ].
        bytesPerRow := width*3.
        bytesPerPixel := 3.
    ].
    depth == 8 ifTrue:[
        imageType == 1 ifTrue:[
"/            rle ifTrue:[self halt:'oops - should not happen'].
            self read8.
        ] ifFalse:[
"/            rle ifFalse:[self halt:'oops - should not happen'].
            self read8RLE
        ].
        bytesPerRow := width.
        bytesPerPixel := 1.
    ].

    self handleImageOrientation.

    "
     TargaReader fromFile:'bitmaps/test.tga' 
    "

    "Modified: / 7.9.1998 / 21:12:12 / cg"
    "Modified: / 13.10.1998 / 19:50:48 / ps"
! !

!TargaReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/TargaReader.st,v 1.25 2003-11-19 15:38:53 cg Exp $'
! !


TargaReader initialize!

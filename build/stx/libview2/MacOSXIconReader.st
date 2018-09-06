"
 COPYRIGHT (c) 2013 by Claus Gittinger
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

ImageReader subclass:#MacOSXIconReader
	instanceVariableNames:'image'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!MacOSXIconReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by Claus Gittinger
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
    Reader for mac osx icon files.

    These files are actually bundles of a sequence of icons (in possibly different resolutions,
    colors and sizes).
    When such a file is read, I return the first image as usual, 
    and all images as an imagesequence.

    Only a subset of the supported image formats are supported by the writer
    (i.e. JPEG and PNG based image encodings only). 
    This means, that only 10.8-and later icon files are really generated.

    caveat:
        only a subset of the possibly formats are supported when reading.

    [See also:]
        Image Form Icon
        GIFReader JPEGReader PNGReader TIFFReader WindowsIconReader
        http://en.wikipedia.org/wiki/Apple_Icon_Image_format
"
! !

!MacOSXIconReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.icns' extension."

    "/ MIMETypes defineImageType:'image/x-icns' suffix:'icns'  reader:self.
    MIMETypes defineImageType:nil          suffix:'icns' reader:self.
! !

!MacOSXIconReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Assuming that we store in PNG format, delegate that decision."

    ^ PNGReader canRepresent:anImage
!

isValidImageFile:aFileName
    "return true, if aFileName is an apple osx icon file"

    |id inStream|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    inStream text.

    id := String new:4.
    inStream nextBytes:4 into:id.
    inStream close.

    ^ (id = 'icns')
! !

!MacOSXIconReader methodsFor:'image reading'!

fromStream:aStream
    "read a stream containing an icon image (or a collection of images).
     Leave image description in instance variables."

    |sizeRemaining id img firstImage frame imageCount chunkType numChunkBytes chunkData|

    inStream := aStream.
    aStream text.

    "icon-files are always msb"
    byteOrder := #msb.

    id := aStream nextBytes:4.
    id size ~~ 4 ifTrue:[
        ^ self fileFormatError:'not an icns file (short read)'.
    ].
    id := id asString.
    sizeRemaining := aStream nextUnsignedInt32MSB:true.
    sizeRemaining := sizeRemaining - 4 - 4. "/ file magic and size are included in count

    (id ~= 'icns') ifTrue:[
        chunkData := aStream next:sizeRemaining.
        image := self readSingleIcon:chunkType from:chunkData.
        ^ self
    ].

    imageCount := 0.
    [ sizeRemaining > 0 ] whileTrue:[
        chunkType := aStream nextBytes:4.
        chunkType size ~~ 4 ifTrue:[
            ^ self fileFormatError:'not an icns file (short read on icon type)'.
        ].
        chunkType := chunkType asString.

        numChunkBytes := aStream nextUnsignedInt32MSB:true.
        numChunkBytes := numChunkBytes - 4 - 4. "/ type and size are included in count

        chunkData := aStream next:numChunkBytes.
        sizeRemaining := sizeRemaining - 4 - 4 - numChunkBytes.

        img := self readSingleIcon:chunkType from:chunkData.
        "/ unsupported images are skipped...
        img notNil ifTrue:[
            imageCount == 0 ifTrue:[
                firstImage := image := img.
            ] ifFalse:[
                imageCount == 1 ifTrue:[
                    imageSequence := ImageSequence new.
                    img imageSequence:imageSequence.

                    "/ add frame for first image.
                    frame := ImageFrame new image:firstImage.
                    imageSequence add:frame.
                ].  

                "/ add frame for this image.
                frame := ImageFrame new image:img.
                imageSequence add:frame.
            ].
            imageCount := imageCount + 1.
        ].
    ].
    self breakPoint:#cg.

    "
     Image fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

readSingleIcon:iconType from:iconBytes
    "read a single image from the inputStream."

    |img|

    Error handle:[:ex |
        self fileFormatError:'internal error / unhandled icon format: ',iconType.
    ] do:[
        img := self 
            perform:('read_',(iconType copyReplaceAny:#( $# $ ) with:$_),'_from:') asSymbol 
            with:iconBytes
            ifNotUnderstood:[
                self breakPoint:#cg.
                ('MacOSXIconReader: unsupported icon format: ',iconType) infoPrintCR.
                self fileFormatError:'unsupported icon format: ',iconType.
                nil
            ].
    ].
    ^ img.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
! !

!MacOSXIconReader methodsFor:'image writing'!

save:anImage onStream:aStream
    "save an icon to aStream."

    self saveAll:(Array with:anImage) onStream:aStream.

    "
     self 
        save:(Image fromScreen:(0@0 corner:16@16))
        onFile:'test.icns'
    "
!

saveAll:aCollectionOfImages onStream:aStream
    "save a number of images to aStream."

    |tempStream|

    (aCollectionOfImages conform:
        [:eachImage |
            (eachImage width = eachImage height)
            and:[ (#(16 32 128 256 512 1024) includes:eachImage width)]
        ]
    ) ifFalse:[
        ^ self fileFormatError:'unsupported image size (must be square and width 16, 32, 128, 512 or 1024)'.
    ].

    tempStream := ReadWriteStream on:(ByteArray new:1024).

    aCollectionOfImages do:[:eachImage |
        |typeCode s data|

        s := WriteStream on:(ByteArray new:1024).
        PNGReader save:eachImage onStream:s.
        data := s contents.
        self assert:data notEmptyOrNil.

        typeCode := #(16 32 128 256 512 1024) 
                    map: #('ipc4' 'ipc5' 'ic07' 'ic08' 'ic09' 'ic10')
                    at:eachImage width ifAbsent:[self error]. 
        tempStream
            nextPutBytes:typeCode;
            nextPutInt32:(data size + 4 + 4) MSB:true;
            nextPutAll:data.
    ].

    aStream 
        binary;
        nextPutBytes:'icns';
        nextPutInt32:(tempStream position + 4 + 4) MSB:true;
        nextPutAll:(tempStream contents).

    "
     self 
        save:(Image fromScreen:(0@0 corner:16@16))
        onFile:'test.icns'
    "
! !

!MacOSXIconReader methodsFor:'private'!

colormap4
    ^ #[
           16rFF 16rFF 16rFF
           16rFC 16rF3 16r05
           16rFF 16r64 16r02
           16rDD 16r08 16r06
           16rF2 16r08 16r84
           16r46 16r00 16rA5
           16r00 16r00 16rD4
           16r02 16rAB 16rEA
           16r1F 16rB7 16r14
           16r00 16r64 16r11
           16r56 16r2C 16r05
           16r90 16r71 16r3A
           16rC0 16rC0 16rC0
           16r80 16r80 16r80
           16r40 16r40 16r40
           16r00 16r00 16r00
    ]
!

colormap8
    ^ #[
           16rFF 16rFF 16rFF
           16rFF 16rFF 16rCC
           16rFF 16rFF 16r99
           16rFF 16rFF 16r66
           16rFF 16rFF 16r33
           16rFF 16rFF 16r00
           16rFF 16rCC 16rFF
           16rFF 16rCC 16rCC
           16rFF 16rCC 16r99
           16rFF 16rCC 16r66
           16rFF 16rCC 16r33
           16rFF 16rCC 16r00
           16rFF 16r99 16rFF
           16rFF 16r99 16rCC
           16rFF 16r99 16r99
           16rFF 16r99 16r66
           16rFF 16r99 16r33
           16rFF 16r99 16r00
           16rFF 16r66 16rFF
           16rFF 16r66 16rCC
           16rFF 16r66 16r99
           16rFF 16r66 16r66
           16rFF 16r66 16r33
           16rFF 16r66 16r00
           16rFF 16r33 16rFF
           16rFF 16r33 16rCC
           16rFF 16r33 16r99
           16rFF 16r33 16r66
           16rFF 16r33 16r33
           16rFF 16r33 16r00
           16rFF 16r00 16rFF
           16rFF 16r00 16rCC
           16rFF 16r00 16r99
           16rFF 16r00 16r66
           16rFF 16r00 16r33
           16rFF 16r00 16r00
           16rCC 16rFF 16rFF
           16rCC 16rFF 16rCC
           16rCC 16rFF 16r99
           16rCC 16rFF 16r66
           16rCC 16rFF 16r33
           16rCC 16rFF 16r00
           16rCC 16rCC 16rFF
           16rCC 16rCC 16rCC
           16rCC 16rCC 16r99
           16rCC 16rCC 16r66
           16rCC 16rCC 16r33
           16rCC 16rCC 16r00
           16rCC 16r99 16rFF
           16rCC 16r99 16rCC
           16rCC 16r99 16r99
           16rCC 16r99 16r66
           16rCC 16r99 16r33
           16rCC 16r99 16r00
           16rCC 16r66 16rFF
           16rCC 16r66 16rCC
           16rCC 16r66 16r99
           16rCC 16r66 16r66
           16rCC 16r66 16r33
           16rCC 16r66 16r00
           16rCC 16r33 16rFF
           16rCC 16r33 16rCC
           16rCC 16r33 16r99
           16rCC 16r33 16r66
           16rCC 16r33 16r33
           16rCC 16r33 16r00
           16rCC 16r00 16rFF
           16rCC 16r00 16rCC
           16rCC 16r00 16r99
           16rCC 16r00 16r66
           16rCC 16r00 16r33
           16rCC 16r00 16r00
           16r99 16rFF 16rFF
           16r99 16rFF 16rCC
           16r99 16rFF 16r99
           16r99 16rFF 16r66
           16r99 16rFF 16r33
           16r99 16rFF 16r00
           16r99 16rCC 16rFF
           16r99 16rCC 16rCC
           16r99 16rCC 16r99
           16r99 16rCC 16r66
           16r99 16rCC 16r33
           16r99 16rCC 16r00
           16r99 16r99 16rFF
           16r99 16r99 16rCC
           16r99 16r99 16r99
           16r99 16r99 16r66
           16r99 16r99 16r33
           16r99 16r99 16r00
           16r99 16r66 16rFF
           16r99 16r66 16rCC
           16r99 16r66 16r99
           16r99 16r66 16r66
           16r99 16r66 16r33
           16r99 16r66 16r00
           16r99 16r33 16rFF
           16r99 16r33 16rCC
           16r99 16r33 16r99
           16r99 16r33 16r66
           16r99 16r33 16r33
           16r99 16r33 16r00
           16r99 16r00 16rFF
           16r99 16r00 16rCC
           16r99 16r00 16r99
           16r99 16r00 16r66
           16r99 16r00 16r33
           16r99 16r00 16r00
           16r66 16rFF 16rFF
           16r66 16rFF 16rCC
           16r66 16rFF 16r99
           16r66 16rFF 16r66
           16r66 16rFF 16r33
           16r66 16rFF 16r00
           16r66 16rCC 16rFF
           16r66 16rCC 16rCC
           16r66 16rCC 16r99
           16r66 16rCC 16r66
           16r66 16rCC 16r33
           16r66 16rCC 16r00
           16r66 16r99 16rFF
           16r66 16r99 16rCC
           16r66 16r99 16r99
           16r66 16r99 16r66
           16r66 16r99 16r33
           16r66 16r99 16r00
           16r66 16r66 16rFF
           16r66 16r66 16rCC
           16r66 16r66 16r99
           16r66 16r66 16r66
           16r66 16r66 16r33
           16r66 16r66 16r00
           16r66 16r33 16rFF
           16r66 16r33 16rCC
           16r66 16r33 16r99
           16r66 16r33 16r66
           16r66 16r33 16r33
           16r66 16r33 16r00
           16r66 16r00 16rFF
           16r66 16r00 16rCC
           16r66 16r00 16r99
           16r66 16r00 16r66
           16r66 16r00 16r33
           16r66 16r00 16r00
           16r33 16rFF 16rFF
           16r33 16rFF 16rCC
           16r33 16rFF 16r99
           16r33 16rFF 16r66
           16r33 16rFF 16r33
           16r33 16rFF 16r00
           16r33 16rCC 16rFF
           16r33 16rCC 16rCC
           16r33 16rCC 16r99
           16r33 16rCC 16r66
           16r33 16rCC 16r33
           16r33 16rCC 16r00
           16r33 16r99 16rFF
           16r33 16r99 16rCC
           16r33 16r99 16r99
           16r33 16r99 16r66
           16r33 16r99 16r33
           16r33 16r99 16r00
           16r33 16r66 16rFF
           16r33 16r66 16rCC
           16r33 16r66 16r99
           16r33 16r66 16r66
           16r33 16r66 16r33
           16r33 16r66 16r00
           16r33 16r33 16rFF
           16r33 16r33 16rCC
           16r33 16r33 16r99
           16r33 16r33 16r66
           16r33 16r33 16r33
           16r33 16r33 16r00
           16r33 16r00 16rFF
           16r33 16r00 16rCC
           16r33 16r00 16r99
           16r33 16r00 16r66
           16r33 16r00 16r33
           16r33 16r00 16r00
           16r00 16rFF 16rFF
           16r00 16rFF 16rCC
           16r00 16rFF 16r99
           16r00 16rFF 16r66
           16r00 16rFF 16r33
           16r00 16rFF 16r00
           16r00 16rCC 16rFF
           16r00 16rCC 16rCC
           16r00 16rCC 16r99
           16r00 16rCC 16r66
           16r00 16rCC 16r33
           16r00 16rCC 16r00
           16r00 16r99 16rFF
           16r00 16r99 16rCC
           16r00 16r99 16r99
           16r00 16r99 16r66
           16r00 16r99 16r33
           16r00 16r99 16r00
           16r00 16r66 16rFF
           16r00 16r66 16rCC
           16r00 16r66 16r99
           16r00 16r66 16r66
           16r00 16r66 16r33
           16r00 16r66 16r00
           16r00 16r33 16rFF
           16r00 16r33 16rCC
           16r00 16r33 16r99
           16r00 16r33 16r66
           16r00 16r33 16r33
           16r00 16r33 16r00
           16r00 16r00 16rFF
           16r00 16r00 16rCC
           16r00 16r00 16r99
           16r00 16r00 16r66
           16r00 16r00 16r33
           16rEE 16r00 16r00
           16rDD 16r00 16r00
           16rBB 16r00 16r00
           16rAA 16r00 16r00
           16r88 16r00 16r00
           16r77 16r00 16r00
           16r55 16r00 16r00
           16r44 16r00 16r00
           16r22 16r00 16r00
           16r11 16r00 16r00
           16r00 16rEE 16r00
           16r00 16rDD 16r00
           16r00 16rBB 16r00
           16r00 16rAA 16r00
           16r00 16r88 16r00
           16r00 16r77 16r00
           16r00 16r55 16r00
           16r00 16r44 16r00
           16r00 16r22 16r00
           16r00 16r11 16r00
           16r00 16r00 16rEE
           16r00 16r00 16rDD
           16r00 16r00 16rBB
           16r00 16r00 16rAA
           16r00 16r00 16r88
           16r00 16r00 16r77
           16r00 16r00 16r55
           16r00 16r00 16r44
           16r00 16r00 16r22
           16r00 16r00 16r11
           16rEE 16rEE 16rEE
           16rDD 16rDD 16rDD
           16rBB 16rBB 16rBB
           16rAA 16rAA 16rAA
           16r88 16r88 16r88
           16r77 16r77 16r77
           16r55 16r55 16r55
           16r44 16r44 16r44
           16r22 16r22 16r22
           16r11 16r11 16r11
           16r00 16r00 16r00
    ]
!

makeImage
    "image is already made"

    ^ image
! !

!MacOSXIconReader methodsFor:'private reading'!

common_read_paletteImage_from:bytes size:size width:w height:h depth:d
    "read an icl8/icl4/ics4/ics8 icon"

    |pixelData img|

    pixelData := (ByteArray new:size) replaceBytesWith:bytes; yourself.
    img := (Image implementorForDepth:d) width:w height:h fromArray:pixelData.
    img photometric:#palette.
    d == 4 ifTrue:[ 
        img colorMap:(Colormap rgbBytesVector:self colormap4).
    ] ifFalse:[ 
        d == 8 ifTrue:[ 
            img colorMap:(Colormap rgbBytesVector:self colormap8).
        ] ifFalse:[ 
            self error:'unsupported depth'
        ].
    ].
    ^ img

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

readPNGOrJPEGFrom:bytes expectedSize:expectedSizeOrNil
    "read a PNG or JPEG image.
     Helper for ipc4, ipc5, ic07, ic09, ic10 formats"

    |img|

    img := PNGReader fromStream:(bytes readStream).
    img isNil ifTrue:[
        img := JPEGReader fromStream:(bytes readStream).
    ].
    expectedSizeOrNil notNil ifTrue:[
        self assert:(img width = expectedSizeOrNil).
        self assert:(img height = expectedSizeOrNil).
    ].
    ^ img
!

readPackBitsImageFrom:compressedData offset:offset width:w height:h depth:depth
    |redData greenData blueData bytesPerRow bytesPerChannel n srcStart rowStart|

    depth == 24 ifTrue:[
        "/ rgb channels separate
        bytesPerRow := w.
        bytesPerChannel := bytesPerRow * h.

        redData := ByteArray new:bytesPerChannel.
        greenData := ByteArray new:bytesPerChannel.
        blueData := ByteArray new:bytesPerChannel.
        srcStart := 1+offset.
        n := self class
            decompressPackBitsFrom:compressedData at:srcStart to:redData at:1 count:bytesPerChannel.
        srcStart := srcStart + n.
        n := self class
            decompressPackBitsFrom:compressedData at:srcStart to:greenData at:1 count:bytesPerChannel.
        srcStart := srcStart + n.
        n := self class
            decompressPackBitsFrom:compressedData at:srcStart to:blueData at:1 count:bytesPerChannel.
        photometric := #rgb.
        bitsPerSample := #(8 8 8).
        samplesPerPixel := 3.
        width := w.
        height := h.
        data := ByteArray new:(self bytesPerRow * h).

        rowStart := 1.
        1 to:height do:[:r |
            |ci|

            ci := rowStart.
            1 to:width do:[:c |
                data at:ci put:(redData at:c).
                data at:ci+1 put:(greenData at:c).
                data at:ci+2 put:(blueData at:c).
                ci := ci + 3.
            ].
            rowStart := rowStart + self bytesPerRow.
        ].
        ^ Depth24Image new
            width:width
            height:height
            photometric:photometric
            samplesPerPixel:samplesPerPixel
            bitsPerSample:bitsPerSample
            colorMap:nil
            bits:data
            mask:nil.
    ].
    depth == 8 ifTrue:[
        "/ 8bit single channel
        bytesPerRow := w.
        bytesPerChannel := bytesPerRow * h.

        compressedData size == bytesPerChannel ifTrue:[
            data := compressedData.
        ] ifFalse:[
            data := ByteArray new:bytesPerChannel.
            n := self class
                decompressPackBitsFrom:compressedData at:1+offset to:data at:1 count:bytesPerChannel.
        ].
        ^ Depth8Image new
            width:width height:height
            photometric:#blackIs0
            samplesPerPixel:1 bitsPerSample:#(8)
            colorMap:nil
            bits:data mask:nil.
    ].
self halt.
    ^ nil
!

read_ICN__from:bytes
    "read an ICN# format icon.
     ICN# is 32x32 bit mono with 1-bit mask"

    |pixelData maskData img|

    pixelData := (ByteArray new:128) replaceBytesFrom:1 to:128 with:bytes startingAt:1; yourself.
    maskData := (ByteArray new:128) replaceBytesFrom:1 to:128 with:bytes startingAt:128+1; yourself.
    img := Depth1Image width:32 height:32 fromArray:pixelData.
    img mask:(Depth1Image width:32 height:32 fromArray:maskData).
    ^ img
!

read_ICON_from:bytes
    "read an ICON format icon.
     128 bytes, 32x32x1 monochrome"

    |pixelData img|

    pixelData := (ByteArray new:128) replaceBytesFrom:1 to:128 with:bytes startingAt:1; yourself.
    img := Depth1Image width:32 height:32 fromArray:pixelData.
    img photometric:#whiteIs0.
    ^ img

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_TOC__from:bytes
    "read (actually: skip) a table of contents."

    ^ nil
!

read_h8mk_from:bytes
    "read an h8mk packbits format mask icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0 width:48 height:48 depth:8.
!

read_ic07_from:bytes
    "read an ic07 (PNG or JPEG, 128) format icon"

    ^ self readPNGOrJPEGFrom:bytes expectedSize:128.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
!

read_ic08_from:bytes
    "read an ic08 (PNG or JPEG, 256) format icon"

    ^ self readPNGOrJPEGFrom:bytes expectedSize:256.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
!

read_ic09_from:bytes
    "read an ic09 (PNG or JPEG, 512) format icon"

    ^ self readPNGOrJPEGFrom:bytes expectedSize:512.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
!

read_ic10_from:bytes
    "read an ic10 (PNG or JPEG, 1024) format icon"

    ^ self readPNGOrJPEGFrom:bytes expectedSize:1024.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
!

read_ich4_from:bytes
    "read an ich4 format icon;
     1152 bytes; 48x48x4bit"

    ^ self common_read_paletteImage_from:bytes size:1152 width:48 height:48 depth:4

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_ich8_from:bytes
    "read an ich8 format icon;
     2304 bytes; 48x48x8bit"

    ^ self common_read_paletteImage_from:bytes size:2304 width:48 height:48 depth:8

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_ich__from:bytes
    "read an ich# format icon.
     ich# is 288+288 bytes, 48x48x1 monochrome + mask"

    |pixelData maskData img|

    pixelData := (ByteArray new:288) replaceBytesFrom:1 to:288 with:bytes startingAt:1; yourself.
    maskData := (ByteArray new:288) replaceBytesFrom:1 to:288 with:bytes startingAt:288+1; yourself.
    img := Depth1Image width:48 height:48 fromArray:pixelData.
    img mask:(Depth1Image width:48 height:48 fromArray:maskData).
    ^ img
!

read_icl4_from:bytes
    "read an icl4 format icon;
     512 bytes; 32x32x4bit"

    ^ self common_read_paletteImage_from:bytes size:512 width:32 height:32 depth:4

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_icl8_from:bytes
    "read an icl8 format icon;
     1024 bytes; 32x32x8bit"

    ^ self common_read_paletteImage_from:bytes size:1024 width:32 height:32 depth:8

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_ics4_from:bytes
    "read an ics4 format icon.
     128 bytes, 16x16x4bit"

    ^ self common_read_paletteImage_from:bytes size:128 width:16 height:16 depth:4

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_ics8_from:bytes
    "read an ics8 format icon.
     256 bytes, 16x16x8bit"

    ^ self common_read_paletteImage_from:bytes size:256 width:16 height:16 depth:8

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_ics__from:bytes
    "read an ics# format icon.
     ics# is 64 bytes, 16x16x1 monochrome + mask"

    |pixelData maskData img|

    pixelData := (ByteArray new:32) replaceBytesFrom:1 to:32 with:bytes startingAt:1; yourself.
    maskData := (ByteArray new:32) replaceBytesFrom:1 to:32 with:bytes startingAt:32+1; yourself.
    img := Depth1Image width:16 height:16 fromArray:pixelData.
    img mask:(Depth1Image width:16 height:16 fromArray:maskData).
    ^ img

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_ih32_from:bytes
    "read an ih32 packbits format icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0  width:48 height:48 depth:24.
!

read_il32_from:bytes
    "read an il32 packbits format icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0  width:32 height:32 depth:24.
!

read_ipc4_from:bytes
    "read an ipc4 (PNG or JPEG, 16x16) format icon"

    ^ self readPNGOrJPEGFrom:bytes expectedSize:16.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
!

read_ipc5_from:bytes
    "read an ipc5 (PNG or JPEG, 32) format icon"

    ^ self readPNGOrJPEGFrom:bytes expectedSize:32.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
     self fromFile:'test.icns'
    "
!

read_is32_from:bytes
    "read an is32 packbits format 16x16x24 icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0 width:16 height:16 depth:24.
!

read_it32_from:bytes
    "read an it32 packbits format 128x128x24 icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:4 width:128 height:128 depth:24.

    "
     self fromFile:'/Applications/TextEdit.app/Contents/Resources/txt.icns'
    "
!

read_l8mk_from:bytes
    "read an l8mk packbits format mask icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0  width:32 height:32 depth:8.
!

read_s8mk_from:bytes
    "read an s8mk packbits format mask icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0  width:16 height:16 depth:8.
!

read_t8mk_from:bytes
    "read an t8mk packbits format mask icon"

    ^ self readPackBitsImageFrom:bytes asByteArray offset:0 width:64 height:64 depth:8.
! !

!MacOSXIconReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MacOSXIconReader initialize!

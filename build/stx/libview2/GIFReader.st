"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

ImageReader subclass:#GIFReader
	instanceVariableNames:'pass xpos ypos rowByteSize remainBitCount bufByte bufStream
		prefixTable suffixTable clearCode eoiCode freeCode codeSize
		maxCode interlace frameDelay iterationCount leftOffs topOffs'
	classVariableNames:'ImageSeparator Extension Terminator'
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!GIFReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    this class provides methods for loading and saving GIF pictures.
    It has been tested with some different GIF87a pictures, I don't
    know, if it works with other GIF versions.
    GIF extension blocks are not handled.

    legal stuff extracted from GIF87a documentation:

    CompuServe Incorporated hereby grants a limited, non-exclusive, royalty-free
    license for the use of the Graphics Interchange Format(sm) in computer
    software; computer software utilizing GIF(sm) must acknowledge ownership of the
    Graphics Interchange Format and its Service Mark by CompuServe Incorporated, in
    User and Technical Documentation.

      The Graphics Interchange Format(c) is the Copyright property of
      CompuServe Incorporated. GIF(sm) is a Service Mark property of
      CompuServe Incorporated.

    Notice:
        there has been some annoyance regarding a patent on the compression algorithm
        used in gif. This patent is now obsolete. However, there is no warranty from
        exept, regarding any legal problems, when using GIF.
        We therefore highly recommend to use newer (and especially: royalty-free) formats,
        such as PNG.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader JPEGReader PBMReader PCXReader
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader
        XBMReader XPMReader XWDReader

    [author:]
        Claus Gittinger
"
!

examples
"
    saving an animated gif sequence:

     a view showing rainfall:
										[exBegin]
    |BG CLR N1 H W v WIND drops gen newDrops draw remove move buffer|

    BG := Color black.
    CLR := Color blue lightened.
    H := 100.
    W := 100.
    N1 := 10.
    WIND := 0.
    drops := OrderedCollection new.

    gen := [:n | ((1 to:n) collect:[:i | Random nextIntegerBetween:1 and:W] as:Set) collect:[:x | x@0]].
    newDrops := [drops addAll:(gen value:N1)].
    draw := [buffer fill:BG; paint:CLR. drops do:[:d | buffer displayPoint:d]].
    remove := [drops := drops reject:[:d | d y > H]].
    move := [:wind | drops := drops collect:[:d| (d x + wind)\\W @ (d y + 1)]].
    v := View new openAndWait.
    buffer := Form extent:(v extent) depth:24 onDevice:v device.

    [
	[v shown] whileTrue:[
	    draw value.
	    v displayForm:buffer.
	    move value:WIND.
	    remove value.
	    newDrops value.
	    WIND := (WIND+(Random nextBetween:-1 and:1)) clampBetween:-5 and:5.
	    Delay waitForSeconds:0.1.
	]
    ] fork.
										[exEnd]

   saving those images:
										[exBegin]
    |seq img BG CLR N1 H W v drops gen gen1 buffer|

    BG := Color black.
    CLR := Color blue lightened.
    H := 100.
    W := 100.
    N1 := 10.
    WIND := 0.
    drops := OrderedCollection new.

    gen := [:n | ((1 to:n) collect:[:i | Random nextIntegerBetween:1 and:W] as:Set) collect:[:x | x@0]].
    newDrops := [drops addAll:(gen value:N1)].
    draw := [buffer fill:BG; paint:CLR. drops do:[:d | buffer displayPoint:d]].
    remove := [drops := drops reject:[:d | d y > H]].
    move := [:wind | drops := drops collect:[:d| (d x + wind)\\W @ (d y + 1)]].
    buffer := Form extent:W@H depth:8 onDevice:Display.

    seq := OrderedCollection new.
    500 timesRepeat:[
	move value:WIND.
	remove value.
	newDrops value.
	draw value.
	seq add:(ImageFrame new delay:100; image:(Depth8Image fromForm:buffer)).
	WIND := (WIND+(Random nextBetween:-1 and:1)) clampBetween:-5 and:5.
    ].

    img := seq first image.
    img imageSequence:(seq copyFrom:2).
    img imageSequence do:[:each | each image colorMap:img colorMap].
    GIFReader save:img onFile:'/tmp/img.gif'
										[exEnd]
"
! !

!GIFReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.gif' extensions."
    
    ImageSeparator isNil ifTrue:[
        ImageSeparator := $, codePoint.
        Extension := $!! codePoint.
        Terminator := $; codePoint.

        MIMETypes defineImageType:'image/gif' suffix:'gif' reader:self.
    ].

    "Modified: 14.10.1997 / 18:47:27 / cg"
! !

!GIFReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     GIF supports depth 8 images only."

    anImage depth == 8 ifTrue:[^ true].
    ('GIFReader [info]: image depth is not 8.') infoPrintCR.
    ^ false.

    "Created: 17.10.1997 / 20:19:20 / cg"
!

isValidImageFile:aFileName
    "return true, if aFileName contains a GIF image"

    |id inStream|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    inStream text.

    id := String new:6.
    inStream nextBytes:6 into:id.
    inStream close.

    (id = 'GIF87a') ifFalse:[
	(id startsWith:'GIF') ifFalse:[^ false].

	id ~= 'GIF89a' ifTrue:[
	    'GIFReader [info]: not a GIF87a/GIF89a file - hope that works' infoPrintCR.
	]
    ].
    ^ true

    "Modified: 10.1.1997 / 15:40:34 / cg"
! !

!GIFReader methodsFor:'image reading'!

fromStream:aStream
    "read a stream containing a GIF image (or an image sequence).
     Leave image description in instance variables."

    |byte flag fileColorMap
     colorMapSize bitsPerPixel scrWidth scrHeight
     hasColorMap interlaced id
     isGif89 atEnd
     img firstImage firstOffset firstFrameDelay frame imageCount|

    inStream := aStream.
    aStream binary.

    "GIF-files are always lsb (intel-world)"
    byteOrder := #lsb.

    id := ByteArray new:6.
    (aStream nextBytes:6 into:id startingAt:1) ~~ 6 ifTrue:[
        ^ self fileFormatError:'not a gif file (short read)'.
    ].
    id := id asString.

    "all I had for testing where GIF87a files;
     I hope later versions work too ..."

    isGif89 := false.
    (id ~= 'GIF87a') ifTrue:[
        (id startsWith:'GIF') ifFalse:[
            ^ self fileFormatError:('not a gif file (id=''' , id , ''')').
        ].
        id ~= 'GIF89a' ifTrue:[
            'GIFReader [info]: not a GIF87a/GIF89a file - hope that works' infoPrintCR.
        ]
    ].

    "get screen dimensions (not used)"
    scrWidth := aStream nextInt16MSB:false.
    scrHeight := aStream nextInt16MSB:false.

    "get flag byte"
    flag := aStream nextByte.
    hasColorMap :=      (flag bitAnd:2r10000000) ~~ 0.
    "bitsPerRGB :=     ((flag bitAnd:2r01110000) bitShift:-4) + 1. "
    "colorMapSorted := ((flag bitAnd:2r00001000) ~~ 0.             "
    bitsPerPixel :=     (flag bitAnd:2r00000111) + 1.
    colorMapSize := 1 bitShift:bitsPerPixel.

    "get background (not used)"
    aStream nextByte.

    "aspect ratio (not used)"
    aStream nextByte.

    "get colorMap"
    hasColorMap ifTrue:[
        fileColorMap := self readColorMap:colorMapSize.
    ].
    colorMap := fileColorMap.

    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    imageCount := 0.
    atEnd := false.
    [atEnd] whileFalse:[
        "gif89a extensions"

        byte := aStream nextByte.
        byte isNil ifTrue:[
            "/ atEnd-Terminator missing
            atEnd := true
        ] ifFalse:[
            byte == Extension ifTrue:[
"/ 'Ext' infoPrintCR.
                self readExtension:aStream.
            ] ifFalse:[
                (byte == Terminator) ifTrue:[
                    atEnd := true
                ] ifFalse:[
                    "must be image separator"
                    (byte ~~ ImageSeparator) ifTrue:[
                        ^ self fileFormatError:('corrupted gif file (no IMAGESEP): ' , (byte printStringRadix:16)).
                    ].
"/ 'Img' infoPrintCR.

                    fileColorMap notNil ifTrue:[
                        colorMap := fileColorMap.
                    ].
                    Object primitiveFailureSignal handle:[:ex |
                        ^ self fileFormatError:('corrupted gif file').
                    ] do:[
                        self readImage:aStream.
                    ].

                    maskPixel notNil ifTrue:[
                        "/
                        "/ ok, there is a maskValue
                        "/ build a Depth1Image for it.
                        "/
                        self buildMaskFromColor:maskPixel
                    ].

                    imageCount == 0 ifTrue:[
                        img := self makeImage.
                        "/ remember first image in case more come later.
                        firstImage := img.
                        firstFrameDelay := frameDelay.
                        firstOffset := (leftOffs @ topOffs).
                    ] ifFalse:[
                        imageCount == 1 ifTrue:[
                            imageSequence := ImageSequence new.
                            img imageSequence:imageSequence.

                            "/ add frame for first image.
                            frame := ImageFrame new image:firstImage.
                            frame delay:firstFrameDelay.
                            frame offset:firstOffset.
                            imageSequence add:frame.
                        ].
                        img := self makeImage.
                        img imageSequence:imageSequence.

                        "/ add frame for this image.
                        frame := ImageFrame new image:img.
                        frame delay:frameDelay.
                        frame offset:(leftOffs @ topOffs).
                        imageSequence add:frame.
                    ].

                    imageCount := imageCount + 1.

                    frameDelay := nil.

                    aStream atEnd ifTrue:[
                        atEnd := true.
                    ]
                ]
            ].
        ].
    ].

    imageSequence notNil ifTrue:[
        iterationCount notNil ifTrue:[
            iterationCount == 0 ifTrue:[
                imageSequence loop:true.
            ] ifFalse:[
                imageSequence loop:false.
                imageSequence iterationCount:iterationCount.
            ]
        ]
    ].

    "
     Image fromFile:'/home/cg/work/stx/goodies/bitmaps/gifImages/animated/vrml.gif'
     Image fromFile:'/home/cg/work/stx/goodies/bitmaps/gifImages/animated/arrow.gif'
    "

    "Modified: / 5.7.1996 / 17:32:01 / stefan"
    "Modified: / 21.8.1998 / 22:20:00 / cg"
! !

!GIFReader methodsFor:'private-reading'!

makeGreyscale
    "not yet implemented/needed"
!

readColorMap:colorMapSize
    "get a gif colormap consisting of colorMapSize entries"

    |rgbVector|

    rgbVector := inStream nextBytes:colorMapSize*3.
    ^ MappedPalette rgbBytesVector:rgbVector
!

readExtension:aStream
    "get gif89 extension"

    |type blockSize subBlockSize
     aspNum aspDen left top width height cWidth cHeight fg bg
     animationType animationTime animationMask
     appID appAUTH
     b ok|

    type := aStream nextByte.
    type == $R codePoint ifTrue:[
        "/
        "/ Ratio extension
        "/
        "/ 'GIFREADER [info]: ratio extension ignored' infoPrintCR.
        blockSize := aStream nextByte.
        (blockSize == 2) ifTrue:[
            aspNum := aStream nextByte.
            aspDen := aStream nextByte
        ] ifFalse:[
            aStream skip:blockSize
        ].

        "/ eat subblocks
        [(subBlockSize := aStream nextByte) > 0] whileTrue:[
            aStream skip:subBlockSize
        ].
        ^ self
    ].

    type == 16r01 ifTrue:[
        "/
        "/ plaintext extension
        "/
        "/ 'GIFREADER [info]: plaintext extension ignored' infoPrintCR.
        subBlockSize := aStream nextByte.
        left := aStream nextInt16MSB:false.
        top := aStream nextInt16MSB:false.
        width := aStream nextInt16MSB:false.
        height := aStream nextInt16MSB:false.
        cWidth := aStream nextByte.
        cHeight := aStream nextByte.
        fg := aStream nextByte.
        bg := aStream nextByte.
        aStream skip:12.
        "/ eat subblocks
        [(subBlockSize := aStream nextByte) > 0] whileTrue:[
            aStream skip:subBlockSize
        ].
        ^ self
    ].

    type == 16rF9 ifTrue:[
        "/
        "/ graphic control extension
        "/
        "/ 'GIFREADER [info]: graphic control extension' infoPrintCR.

        [(subBlockSize := aStream nextByte) ~~ 0 and:[subBlockSize notNil]] whileTrue:[
            "/ type bitAnd:1 means: animationMask is transparent pixel
            "/ to be implemented in Image ...

            animationType := aStream nextByte.
            animationTime := aStream nextInt16MSB:false.
            animationMask := aStream nextByte.

            subBlockSize := subBlockSize - 4.

           (animationType bitTest: 1) ifTrue:[
                maskPixel := animationMask.
"/                'GIFREADER [info]: mask: ' infoPrint. (maskPixel printStringRadix:16) infoPrintCR.
            ].
"/            'GIFREADER [info]: animationTime: ' infoPrint. (animationTime * (1/100)) infoPrintCR.
"/            'GIFREADER [info]: animationType: ' infoPrint. (animationType) infoPrintCR.
"/            'GIFREADER [info]: animationMask: ' infoPrint. (animationMask) infoPrintCR.

            frameDelay := (animationTime * (1/100)) * 1000.

            subBlockSize ~~ 0 ifTrue:[
                aStream skip:subBlockSize
            ].
        ].
        ^ self
    ].

    type == 16rFE ifTrue:[
        "/
        "/ comment extension
        "/
        "/ 'GIFREADER [info]: comment extension' infoPrintCR.
        [(blockSize := aStream nextByte) ~~ 0] whileTrue:[
            aStream skip:blockSize
        ].
        ^ self
    ].

    type == 16rFF ifTrue:[
        "/
        "/  application extension
        "/
        "/ 'GIFREADER [info]: application extension' infoPrintCR.
        subBlockSize := aStream nextByte.
        appID := (aStream nextBytes:8 ) asString.
        appAUTH := aStream nextBytes:3.

        subBlockSize := aStream nextByte.

        ok := false.
        appID = 'NETSCAPE' ifTrue:[
            appAUTH asString = '2.0' ifTrue:[
                subBlockSize == 3 ifTrue:[
                    b := aStream nextByte.
                    iterationCount := aStream nextInt16MSB:false.
                    subBlockSize := aStream nextByte.
                    ok := true.
"/                    ('GIFREADER [info]: NETSCAPE application extension - iterationCount = ') infoPrint.
"/                    iterationCount infoPrintCR.
                ]
            ]
        ].

        ok ifFalse:[
            ('GIFREADER [info]: application extension (' , appID , ') ignored') infoPrintCR.
        ].

        [subBlockSize > 0] whileTrue:[
            aStream skip:subBlockSize.
            subBlockSize := aStream nextByte.
        ].
        ^ self
    ].

    type == 16r2C ifTrue:[
        "/
        "/  image descriptor extension
        "/
        "/ 'GIFREADER [info]: image descriptor extension ignored' infoPrintCR.
        [(subBlockSize := aStream nextByte) > 0] whileTrue:[
            aStream skip:subBlockSize
        ].
        ^ self
    ].

    "/
    "/ unknown extension
    "/
    'GIFREADER [info]: unknown extension ignored' infoPrintCR.
    [(subBlockSize := aStream nextByte) > 0] whileTrue:[
        aStream skip:subBlockSize
    ]

    "Modified: / 02-06-2010 / 12:21:53 / cg"
!

readImage:aStream
    "read a single image from aStream."

    | flag interlaced hasLocalColorMap bitsPerPixel colorMapSize
     codeLen compressedData compressedSize index count h tmp srcOffset dstOffset
     initialBuffSize|

    "get image data"
    leftOffs := aStream nextInt16MSB:false.
    topOffs := aStream nextInt16MSB:false.
"/    'GIFReader: leftOffs ' infoPrint. leftOffs infoPrintCR.
"/    'GIFReader: topOffs ' infoPrint. topOffs infoPrintCR.
    width := aStream nextInt16MSB:false.
    height := aStream nextInt16MSB:false.

    self reportDimension.

"/
"/    'width ' print. width printNewline.
"/    'height ' print. height printNewline.
"/

    "another flag byte"
    flag := aStream nextByte.
    interlaced :=           (flag bitAnd:2r01000000) ~~ 0.
    hasLocalColorMap :=     (flag bitAnd:2r10000000) ~~ 0.
    "localColorMapSorted := (flag bitAnd:2r00100000) ~~ 0.      "

    "if image has a local colormap, this one is used"

    hasLocalColorMap ifTrue:[
        "local descr. overwrites"
        bitsPerPixel := (flag bitAnd:2r00000111) + 1.
        colorMapSize := 1 bitShift:bitsPerPixel.
        "overwrite colormap"
        colorMap := self readColorMap:colorMapSize.
    ].


    "get codelen for decompression"
    codeLen := aStream nextByte.
    (aStream respondsTo:#fileSize) ifTrue:[
        initialBuffSize := aStream fileSize.
    ] ifFalse:[
        initialBuffSize := 512.
    ].
    compressedData := ByteArray uninitializedNew:initialBuffSize.

    "get compressed data"
    index := 1.
    count := aStream nextByte.
    [count notNil and:[count ~~ 0]] whileTrue:[
        (compressedData size < (index+count)) ifTrue:[
            |t|

            t := ByteArray uninitializedNew:((index+count)*3//2).
            t replaceBytesFrom:1 to:index-1 with:compressedData startingAt:1.
            compressedData := t.
        ].

        aStream nextBytes:count into:compressedData startingAt:index blockSize:4096.
        index := index + count.
        count := aStream nextByte
    ].
    compressedSize := index - 1.

    h := height.
    data := ByteArray new:((width + 1) * (h + 1)).
"/    'GIFReader: decompressing ...' infoPrintCR.

    self class decompressGIFFrom:compressedData
                           count:compressedSize
                            into:data
                      startingAt:1
                         codeLen:(codeLen + 1).

    interlaced ifTrue:[
"/    'GIFREADER: deinterlacing ...' infoPrintCR.
        tmp := ByteArray new:(data size).

        "phase 1: 0, 8, 16, 24, ..."

        srcOffset := 1.
        0 to:(h - 1) by:8 do:[:dstRow |
            dstOffset := dstRow * width + 1.
            tmp replaceFrom:dstOffset to:(dstOffset + width - 1)
                       with:data startingAt:srcOffset.
            srcOffset := srcOffset + width.
        ].

        "phase 2: 4, 12, 20, 28, ..."

        4 to:(h - 1) by:8 do:[:dstRow |
            dstOffset := dstRow * width + 1.
            tmp replaceFrom:dstOffset to:(dstOffset + width - 1)
                       with:data startingAt:srcOffset.
            srcOffset := srcOffset + width.
        ].

        "phase 3: 2, 6, 10, 14, ..."

        2 to:(h - 1) by:4 do:[:dstRow |
            dstOffset := dstRow * width + 1.
            tmp replaceFrom:dstOffset to:(dstOffset + width - 1)
                       with:data startingAt:srcOffset.
            srcOffset := srcOffset + width.
        ].

        "phase 4: 1, 3, 5, 7, ..."

        1 to:(h - 1) by:2 do:[:dstRow |
            dstOffset := dstRow * width + 1.
            tmp replaceFrom:dstOffset to:(dstOffset + width - 1)
                       with:data startingAt:srcOffset.
            srcOffset := srcOffset + width.
        ].

        data := tmp.
        tmp := nil.
    ].

    "Created: / 13-01-1998 / 10:44:05 / cg"
    "Modified: / 12-08-1998 / 13:55:32 / cg"
    "Modified (format): / 16-11-2016 / 23:07:20 / cg"
! !

!GIFReader methodsFor:'private-writing'!

assignTransparentPixelIn:image
    "find an usused pixelValue in the colorMap (or image)."

    |cmap cmapSize imgDepth usedPixelValues unusedValues|

    cmap := image colorMap.
    cmapSize := cmap size.
    ((cmapSize > 0) and:[cmapSize < 256]) ifTrue:[
        maskPixel := cmapSize.
        ^ self
    ].
    
    image compressColorMap.
    imgDepth := image depth.
    usedPixelValues := image usedValues.
    usedPixelValues size < (1 bitShift:imgDepth) ifFalse:[
        Image informationLostQuerySignal
            raiseRequestWith:image
            errorString:('GIF writer cannot assign a transparent pixel - all pixelValues used by image').
    ].

    "/ there must be an unused pixelValue
    unusedValues := (0 to:(1 bitShift:imgDepth)-1) asSet.
    unusedValues removeAll:usedPixelValues.

    maskPixel := unusedValues first.

    "Modified: / 17-07-2012 / 12:25:24 / anwild"
!

checkCodeSize
    (freeCode > maxCode and: [codeSize < 12])
	    ifTrue:
		    [codeSize := codeSize + 1.
		    maxCode := (1 bitShift: codeSize) - 1]

    "Created: 14.10.1997 / 18:42:01 / cg"
!

flushBits
	remainBitCount = 0
		ifFalse:
			[self nextBytePut: bufByte.
			remainBitCount := 0].
	self flushBuffer

    "Modified: 14.10.1997 / 18:58:06 / cg"
!

flushBuffer
    bufStream isEmpty ifTrue: [^ self].
    outStream nextPut: bufStream size.
    outStream nextPutAll: bufStream contents.
    bufStream := WriteStream on: (ByteArray new: 256)

    "Modified: 14.10.1997 / 20:46:04 / cg"
!

flushCode
	self flushBits

    "Created: 14.10.1997 / 18:57:33 / cg"
!

nextBitsPut: anInteger
	| integer writeBitCount shiftCount |
	shiftCount := 0.
	remainBitCount = 0
		ifTrue:
			[writeBitCount := 8.
			integer := anInteger]
		ifFalse:
			[writeBitCount := remainBitCount.
			integer := bufByte + (anInteger bitShift: 8 - remainBitCount)].
	[writeBitCount < codeSize]
		whileTrue:
			[self nextBytePut: ((integer bitShift: shiftCount) bitAnd: 255).
			shiftCount := shiftCount - 8.
			writeBitCount := writeBitCount + 8].
	(remainBitCount := writeBitCount - codeSize) = 0
		ifTrue: [self nextBytePut: (integer bitShift: shiftCount)]
		ifFalse: [bufByte := integer bitShift: shiftCount].
	^anInteger

    "Modified: 15.10.1997 / 16:50:30 / cg"
!

nextBytePut: aByte
	bufStream nextPut: aByte.
	bufStream size >= 254 ifTrue: [self flushBuffer]

    "Modified: 15.10.1997 / 16:50:52 / cg"
!

readPixelFrom: bits
    | pixel |
    ypos >= height ifTrue: [^ nil].
    (maskPixel notNil
    and:[(mask pixelAtX:xpos y:ypos) == 0]) ifTrue:[
	pixel := maskPixel
    ] ifFalse:[
	pixel := bits at: ypos * rowByteSize + xpos + 1.
    ].
    self updatePixelPosition.
    ^ pixel

    "Created: 14.10.1997 / 18:43:50 / cg"
    "Modified: 15.10.1997 / 16:46:43 / cg"
!

setParameters:bitsPerPixel
    clearCode := 1 bitShift:bitsPerPixel.
    eoiCode := clearCode + 1.
    freeCode := clearCode + 2.
    codeSize := bitsPerPixel + 1.
    maxCode := (1 bitShift: codeSize) - 1

    "Modified: 14.10.1997 / 20:09:48 / cg"
!

updatePixelPosition
    (xpos := xpos + 1) >= width ifFalse: [^ self].

    xpos := 0.
    interlace == true ifFalse:[
	ypos := ypos + 1.
	^ self
    ].

    pass == 0 ifTrue:[
	(ypos := ypos + 8) >= height ifTrue:[
	    pass := pass + 1.
	    ypos := 4
	].
	^ self
    ].
    pass == 1 ifTrue:[
	(ypos := ypos + 8) >= height ifTrue:[
	    pass := pass + 1.
	    ypos := 2
	].
	^ self
    ].
    pass == 2 ifTrue:[
	(ypos := ypos + 4) >= height ifTrue:[
	    pass := pass + 1.
	    ypos := 1
	].
	^ self
    ].
    pass == 3 ifTrue:[
	ypos := ypos + 2.
	^ self
    ].
    ^ self error: 'can''t happen'

    "Modified: 14.10.1997 / 18:44:27 / cg"
!

writeBitDataFor: image
    "using modified Lempel-Ziv Welch algorithm."

    | bits bitsPerPixel t1
      maxBits maxMaxCode tSize initCodeSize ent tShift fCode 
      pixel
      index disp nomatch |

    outStream nextPut:ImageSeparator.
    self writeShort:0.       "/ leftOffs
    self writeShort:0.       "/ topOffs
    self writeShort:width.   "/ image size
    self writeShort:height.

    interlace == true ifTrue:[
        t1 := 64
    ] ifFalse:[
        t1 := 0  "/ no local colormap
    ].
    outStream nextPut:t1.       "/ another flag

    bitsPerPixel := image bitsPerPixel.
    bits := image bits.

    pass := 0.
    xpos := 0.
    ypos := 0.
    rowByteSize := image bytesPerRow. "/ width * 8 + 31 // 32 * 4.
    remainBitCount := 0.
    bufByte := 0.
    bufStream := WriteStream on: (ByteArray new: 256).

    maxBits := 12.
    maxMaxCode := 1 bitShift: maxBits.
    tSize := 5003.
    prefixTable := Array new: tSize.
    suffixTable := Array new: tSize withAll:-1.

    initCodeSize := bitsPerPixel <= 1 ifTrue: [2] ifFalse: [bitsPerPixel].
    outStream nextPut: initCodeSize.
    self setParameters: initCodeSize.

    tShift := 0.
    fCode := tSize.
    [fCode < 65536] whileTrue:[
        tShift := tShift + 1.
        fCode := fCode * 2
    ].
    tShift := 8 - tShift.
    "/ 1 to: tSize do: [:i | suffixTable at: i put: -1]. - cg changed initialization above

    self writeCodeAndCheckCodeSize: clearCode.
    ent := self readPixelFrom: bits.
    [(pixel := self readPixelFrom: bits) notNil] whileTrue:[
        fCode := (pixel bitShift: maxBits) + ent.
        index := ((pixel bitShift: tShift) bitXor: ent) + 1.
        (suffixTable at: index) = fCode
            ifTrue: [ent := prefixTable at: index]
            ifFalse:[
                nomatch := true.
                (suffixTable at: index) >= 0
                    ifTrue:[
                        disp := tSize - index + 1.
                        index = 1 ifTrue: [disp := 1].
                        "probe"
                        [(index := index - disp) < 1 ifTrue: [index := index + tSize].
                        (suffixTable at: index) = fCode
                            ifTrue:[
                                    ent := prefixTable at: index.
                                    nomatch := false.
                                    "continue whileFalse:"].
                        nomatch and: [(suffixTable at: index) > 0]]
                            whileTrue: ["probe"]].
                "nomatch"
                nomatch ifTrue:[
                    self writeCodeAndCheckCodeSize: ent.
                    ent := pixel.
                    freeCode < maxMaxCode
                        ifTrue:[
                            prefixTable at: index put: freeCode.
                            suffixTable at: index put: fCode.
                            freeCode := freeCode + 1]
                        ifFalse:[
                            self writeCodeAndCheckCodeSize: clearCode.
                            suffixTable from:1 to:tSize put:-1.
                            self setParameters: initCodeSize]]]].
    prefixTable := suffixTable := nil.
    self writeCodeAndCheckCodeSize: ent.
    self writeCodeAndCheckCodeSize: eoiCode.
    self flushCode.
    outStream nextPut: 0.        "zero-length packet"

    "Modified: / 02-06-2010 / 12:24:20 / cg"
!

writeCode: aCode
    self nextBitsPut: aCode

    "Created: 14.10.1997 / 18:38:35 / cg"
    "Modified: 15.10.1997 / 17:01:47 / cg"
!

writeCodeAndCheckCodeSize: t1
    self writeCode: t1.
    self checkCodeSize

    "Created: 14.10.1997 / 18:38:24 / cg"
    "Modified: 14.10.1997 / 18:40:56 / cg"
!

writeHeaderFor:image
    "write the gif header"

    |bitsPerPixel t1|

    bitsPerPixel := image bitsPerPixel.

    outStream nextPutAll: 'GIF89a' asByteArray.
    self writeShort:width. "/ screen size
    self writeShort:height.
    t1 := 128.
    t1 := t1 bitOr:(bitsPerPixel - 1 bitShift:5).
    t1 := t1 bitOr:(bitsPerPixel - 1).
    outStream nextPut:t1.  "/ flag
    outStream nextPut:0.   "/ background (not used)
    outStream nextPut:0.   "/ aspect ratio

    0 to:(1 bitShift:bitsPerPixel)-1 do:[:pixel |
	|clr red green blue|

	clr := image colorFromValue:pixel.
	clr isNil ifTrue:[
	    "/ unused colorMap slot
	    red := green := blue := 0.
	] ifFalse:[
	    red := (clr redByte).
	    green := (clr greenByte).
	    blue := (clr blueByte).
	].
	outStream
	    nextPut:red; nextPut:green; nextPut:blue.
    ].

    "Created: / 14.10.1997 / 17:41:28 / cg"
    "Modified: / 31.10.1997 / 16:12:13 / cg"
!

writeMaskExtensionHeaderFor:image
    "write an extension header for the transparent pixel"

    outStream nextPut:Extension.
    outStream nextPut:16rF9.       "/ graphic control extension
    outStream nextPut:4.           "/ subBlockSize

    outStream nextPut:1.                "/ animationType
    outStream nextPutInt16LSB:1.        "/ animationTime
    outStream nextPut:maskPixel.        "/ animationMask

    outStream nextPut:0.
! !

!GIFReader methodsFor:'writing to file'!

save:image onFile:aFileName
    "save image as GIF file on aFileName"

    |convertedImage|

    image depth ~~ 8 ifTrue:[
	Error handle:[:ex |
	    ^ Image cannotRepresentImageSignal
		raiseWith:image
		errorString:('GIF failed to convert image to depth8: ', ex description).
	    "/ ex return.
	] do:[
	    convertedImage := Image newForDepth:8.
	    convertedImage fromImage:image photometric:#palette.
	].
	convertedImage notNil ifTrue:[
	    ^ self save:convertedImage onFile:aFileName
	].
	^ Image cannotRepresentImageSignal
	    raiseWith:image
	    errorString:('GIF (currently) only supports depth8 images (cannot convert)').
    ].

    super save:image onFile:aFileName.

    "
     |i|

     i := Image fromFile:'bitmaps/gifImages/garfield.gif'.
     GIFReader save:i onFile:'foo.gif'.
     (Image fromFile:'./foo.gif') inspect
    "

    "Created: / 14.10.1997 / 17:40:12 / cg"
    "Modified: / 27.10.1997 / 22:42:31 / cg"
!

save:image onStream:aStream
    "save image in GIF-file-format onto aStream"

    image depth ~~ 8 ifTrue:[
        ^ Image cannotRepresentImageSignal
            raiseWith:image
            errorString:('GIF (currently) only supports depth8 images').
    ].

    outStream := aStream.
    outStream binary.

    mask := image mask.
    mask notNil ifTrue:[
        self assignTransparentPixelIn:image
    ].

    byteOrder := #lsb.
    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.
    colorMap := image colorMap.
    data := image bits.

    self writeHeaderFor:image.
    maskPixel notNil ifTrue:[
        self writeMaskExtensionHeaderFor:image.
    ].

    self writeBitDataFor:image.

    image imageSequence notEmptyOrNil ifTrue:[
        image imageSequence do:[:eachFrame |
            outStream nextPut:Extension.
            outStream nextPut:16rF9.    "/ graphic control extension
            outStream nextPut:4.        "/ sub block size
            outStream nextPut:0.        "/ animation type 0
            outStream nextPutInt16LSB:(eachFrame delay / 10) rounded asInteger.
            outStream nextPut:0.        "/ animation mask
            outStream nextPut:0.        "/ subblock size

            self writeBitDataFor:eachFrame image.

        ].
    ].

    outStream nextPut: Terminator.

    "
     |i|

     i := Image fromFile:'bitmaps/gifImages/garfield.gif'.
     GIFReader save:i onFile:'foo.gif'.
     (Image fromFile:'./foo.gif') inspect
    "

    "Created: / 14.10.1997 / 17:40:12 / cg"
    "Modified: / 27.10.1997 / 22:42:31 / cg"
! !

!GIFReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


GIFReader initialize!

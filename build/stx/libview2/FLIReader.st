"
 COPYRIGHT (c) 1997 by eXept Software AG
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

ImageReader subclass:#FLIReader
	instanceVariableNames:'nframes frameBuffer frameBufferSize imageBuffer redPalette
		greenPalette bluePalette flags frameDelay'
	classVariableNames:'FLI_FILE_MAGIC FLC_FILE_MAGIC FLI_FRAME_MAGIC FILE_HEAD_SIZE
		FRAME_HEAD_SIZE CHUNK_HEAD_SIZE FLI_256_COLOR FLI_DELTA FLI_COLOR
		FLI_LC FLI_BLACK FLI_BRUN FLI_COPY FLI_MINI MAXCOLORS'
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!FLIReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    Read frames from a FLI/FLC file.

    this is a very first attempt in reading FLI files;
    (a first experiment in reading that fileFormat)

    Its very experimental, preliminary and will certainly change.
    (will introduce a new class hierarchy based upon some MovieReader ...).

    When used like an imageReader, #fromFile: will return
    the very first frame.

    Warning: right now, the complete movie is read and huge
    amounts of memoru are allocated. The interface will be changed
    to allow stream operation ...

    [author:]
        Claus Gittinger

    [see also:]
        ImageReader
"
!

examples
"
    |reader film view tNext|

    reader := FLIReader readFile:'/usr/local/FLI/jeffmild.fli'.
    reader isNil ifTrue:[^ nil].
    film := reader images.
    view := StandardSystemView extent:(film first extent).
    view openAndWait.

    tNext := Time millisecondClockValue + (reader frameDelay).
    film do:[:frame |
        frame displayOn:view x:0 y:0.
        (Delay untilMilliseconds:tNext) wait.
        tNext := tNext + (reader frameDelay).
    ].

    |reader film view tNext|

    FLIReader fromFile:('/cdrom/video/fli/dh_hai.fli').
    reader := FLIReader readFile:'/cdrom/video/fli/dh_hai.fli'.
    reader isNil ifTrue:[^ nil].
    film := reader images.
    view := StandardSystemView extent:(film first extent).
    view openAndWait.

    tNext := Time millisecondClockValue + (reader frameDelay).
    film do:[:frame |
        frame displayOn:view x:0 y:0.
        (Delay untilMilliseconds:tNext) wait.
        tNext := tNext + (reader frameDelay).
    ].


    |reader film view tNext|

    reader := FLIReader readFile:'/cdrom/video/fli/wedding.fli'.
    reader isNil ifTrue:[^ nil].
    film := reader images.
    view := StandardSystemView extent:(film first extent).
    view openAndWait.

    tNext := Time millisecondClockValue + (reader frameDelay).
    film do:[:frame |
        frame displayOn:view x:0 y:0.
        (Delay untilMilliseconds:tNext) wait.
        tNext := tNext + (reader frameDelay).
    ].
"
! !

!FLIReader class methodsFor:'class initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.fli' and '.flc' extensions."

    MIMETypes defineImageType:'video/x-fli' suffix:'fli' reader:self.
    MIMETypes defineImageType:nil           suffix:'flc' reader:self.

    FLI_FILE_MAGIC := 16rAF11.
    FLC_FILE_MAGIC := 16rAF12.

    FLI_FRAME_MAGIC := 16rF1FA.

    FILE_HEAD_SIZE := 128.
    FRAME_HEAD_SIZE := 16.
    CHUNK_HEAD_SIZE := 6.

    FLI_256_COLOR := 4.
    FLI_DELTA := 7.
    FLI_COLOR := 11.
    FLI_LC  := 12.
    FLI_BLACK := 13.
    FLI_BRUN := 15.
    FLI_COPY := 16.
    FLI_MINI := 18.

    MAXCOLORS := 256.

    "
     FLIReader initialize
    "

    "Modified: 21.4.1997 / 21:16:48 / cg"
! !

!FLIReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains an FLI/FLC-movie"

    |header n inStream len type|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    header := ByteArray new:FILE_HEAD_SIZE.
    n := inStream nextBytes:FILE_HEAD_SIZE into:header.
    inStream close.
    n ~~ FILE_HEAD_SIZE ifTrue:[^ false].

    len := header doubleWordAt:(1+0).
    type := header wordAt:(1+4).

    type ~~ FLI_FILE_MAGIC ifTrue:[
        type ~~ FLC_FILE_MAGIC ifTrue:[
            ^ false
        ]
    ].
    ^ true

    "
     FLIReader isValidImageFile:'bitmaps/magtape.xpm'    
     FLIReader isValidImageFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Modified: 4.4.1997 / 22:30:19 / cg"
! !

!FLIReader methodsFor:'accessing'!

frameDelay
    "return the value of the instance variable 'frameDelay' (automatically generated)"

    ^ frameDelay

    "Created: 4.4.1997 / 21:59:02 / cg"
!

images
    "return a collection of all images as represented by myself"

    |image depth|

    depth := self bitsPerPixel.

    1 to:imageSequence size do:[:i |
        |frame|

        frame := imageSequence at:i.

        frame isImage ifFalse:[
            image := (Image implementorForDepth:depth) new.
            image 
                width:width 
                height:height
                photometric:photometric
                samplesPerPixel:samplesPerPixel
                bitsPerSample:bitsPerSample
                colorMap:colorMap
                bits:frame
                mask:mask.
            imageSequence at:i put:image.
        ]
    ].
    ^ imageSequence

    "Created: 4.4.1997 / 21:44:44 / cg"
    "Modified: 24.6.1997 / 15:57:22 / cg"
! !

!FLIReader methodsFor:'private-reading'!

getFrame
    "get a single frame"

    |header n len type dataLen nchunks|

    header := ByteArray new:FRAME_HEAD_SIZE.
    n := inStream nextBytes:FRAME_HEAD_SIZE into:header.
    n ~~ FRAME_HEAD_SIZE ifTrue:[^ false].

    len := header doubleWordAt:(1+0).
    type := header wordAt:(1+4).

    type ~~ FLI_FRAME_MAGIC ifTrue:[^ false].

    dataLen := len - FRAME_HEAD_SIZE.
    dataLen > frameBufferSize ifTrue:[
        frameBuffer := ByteArray uninitializedNew:dataLen.
        frameBufferSize := dataLen.
    ].

    n := inStream nextBytes:dataLen into:frameBuffer.
    n ~~ dataLen ifTrue:[^ false].

    nchunks := header wordAt:(1+6).
    nchunks == 0 ifTrue:[
        "/ mhmh - a timing frame; should add a dummy frame
        ^ self.
    ].     
    ^ self processChunks:nchunks size:dataLen.

    "
     FLIReader fromFile:'bitmaps/magtape.xpm'    
     FLIReader fromFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Created: 3.4.1997 / 22:15:19 / cg"
    "Modified: 4.4.1997 / 22:18:21 / cg"
!

getHeader
    "read the header; return true, if its valid"

    |header n len type speed|

    header := ByteArray new:FILE_HEAD_SIZE.
    n := inStream nextBytes:FILE_HEAD_SIZE into:header.
    n ~~ FILE_HEAD_SIZE ifTrue:[^ false].

    len := header doubleWordAt:(1+0).
    type := header wordAt:(1+4).

    type ~~ FLI_FILE_MAGIC ifTrue:[
        type ~~ FLC_FILE_MAGIC ifTrue:[
            ^ false
        ]
    ].

    nframes := header wordAt:(1+6).
    width := header wordAt:(1+8).
    height := header wordAt:(1+10).

    self reportDimension.

    flags := header wordAt:(1+14).
    speed := header wordAt:(1+16).
    speed <= 0 ifTrue:[
        speed := 1
    ].
    "/ FLI uses 1/70th of a second;
    "/ FLC measures the frameDelay in milliseconds
    type == FLI_FILE_MAGIC ifTrue:[
        frameDelay := 1000 * speed // 70
    ] ifFalse:[
        frameDelay := speed
    ].

    frameBufferSize := width * height.
    frameBuffer := ByteArray uninitializedNew:frameBufferSize.

    redPalette := ByteArray new:256.
    greenPalette := ByteArray new:256.
    bluePalette := ByteArray new:256.

    imageSequence := OrderedCollection new:nframes.

    ^ true

    "
     FLIReader fromFile:'bitmaps/magtape.xpm'    
     FLIReader fromFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Created: 3.4.1997 / 22:09:12 / cg"
    "Modified: 24.6.1997 / 15:31:39 / cg"
! !

!FLIReader methodsFor:'processing chunks'!

brunChunkAt:chunkOffs
    |offs lineIdx nextLineIdx packets sz|

"/    'brunChunkAt' infoPrintCR.

    imageBuffer := ByteArray uninitializedNew:(width*height).

    offs := chunkOffs.
    lineIdx := 1.
    1 to:height do:[:y |
        nextLineIdx := lineIdx + width.

        packets := frameBuffer byteAt:offs. offs := offs + 1.

        1 to:packets do:[:p |
            sz := frameBuffer signedByteAt:offs. offs := offs + 1.
            sz > 0 ifTrue:[
                data := frameBuffer at:offs. offs := offs + 1.
                imageBuffer from:lineIdx to:(lineIdx+sz-1) put:data.
            ] ifFalse:[
                sz == 0 ifTrue:[    
                    self halt:'error in brun chunk'.
                    ^ self.
                ].
                sz := sz negated.
                imageBuffer replaceFrom:lineIdx to:(lineIdx+sz-1) 
                            with:frameBuffer startingAt:offs.
                offs := offs + sz.
            ].
            lineIdx := lineIdx + sz.
        ].
        lineIdx := nextLineIdx
    ].

    imageSequence add:imageBuffer.

    "
     FLIReader imagesFromFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Modified: 24.6.1997 / 15:31:22 / cg"
!

color256ChunkAt:chunkOffs
"/    'color256Chunk' infoPrintCR.
    self colorChunkAt:chunkOffs shift:0

    "Modified: 4.4.1997 / 22:45:42 / cg"
!

color64ChunkAt:chunkOffs
"/    'color64Chunk' infoPrintCR.
    self colorChunkAt:chunkOffs shift:2

    "Modified: 4.4.1997 / 22:45:45 / cg"
!

colorChunkAt:chunkOffs shift:colorShift
    |b0 b1 packets offs ic skip change red green blue|

"/    '  colorChunk' infoPrintCR.

    offs := chunkOffs.
    packets := frameBuffer wordAt:offs. offs := offs + 2.

    ic := 0.
    1 to:packets do:[:i |
        skip := frameBuffer byteAt:offs. offs := offs + 1.   
        ic := ic + skip.
        ic := ic \\ MAXCOLORS.
        change := frameBuffer byteAt:offs. offs := offs + 1.
        change == 0 ifTrue:[change := 256].
        
        1 to:change do:[:n |
            red := frameBuffer at:offs. offs := offs + 1.
            green := frameBuffer at:offs. offs := offs + 1.
            blue := frameBuffer at:offs. offs := offs + 1.
            red := red bitShift:colorShift.
            green := green bitShift:colorShift.
            blue := blue bitShift:colorShift.
"/ red print. ' ' print. green print. ' ' print. blue printCR.

            redPalette at:(ic + 1) put:red.
            greenPalette at:(ic + 1) put:green.
            bluePalette at:(ic + 1) put:blue.
            ic := ic + 1.
        ]
    ].

    "
     FLIReader fromFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Modified: 4.4.1997 / 22:45:49 / cg"
!

deltaChunkAt:chunkOffs
"/    'deltaChunkAt' infoPrintCR.

    Image badImageFormatQuerySignal raiseErrorString:'FLIReader [error]: delta chunks not yet implemented'

    "Modified: 21.4.1997 / 21:15:05 / cg"
!

lcChunkAt:chunkOffs
    |jnext lines lineCnt offs lineIdx packets idx skip sz|

"/    'lcChunkAt' infoPrintCR.

    imageBuffer := imageBuffer copyFrom:1 to:(width*height).

    offs := chunkOffs.

    jnext := frameBuffer wordAt:offs. offs := offs + 2.
    lines := frameBuffer wordAt:offs. offs := offs + 2.
    lineCnt := 0.
    lineIdx := 1.

    0 to:height-1 do:[:row |
        lineCnt >= lines ifTrue:[
            imageSequence add:imageBuffer.
            ^ self
        ].

        row < jnext ifFalse:[
            packets := frameBuffer byteAt:offs. offs := offs + 1.
            lineCnt := lineCnt + 1.
            idx := lineIdx.
            1 to:packets do:[:p |
                skip := frameBuffer byteAt:offs. offs := offs + 1.
                idx := idx + skip.
                sz := frameBuffer signedByteAt:offs. offs := offs + 1.
                sz > 0 ifTrue:[
                    imageBuffer replaceFrom:idx to:(idx+sz-1) 
                                with:frameBuffer startingAt:offs.
                    offs := offs + sz.
                ] ifFalse:[
                    sz < 0 ifTrue:[
                        sz := sz negated.
                        data := frameBuffer at:offs. offs := offs + 1.
                        imageBuffer from:idx to:(idx+sz-1) put:data.
                    ]
                ].
                idx := idx + sz.
            ].
        ].
        lineIdx := lineIdx + width
    ].
    imageSequence add:imageBuffer.

    "Modified: 24.6.1997 / 15:31:25 / cg"
!

processChunks:nchunks size:dataLen
    "process chunks in a frame"

    |len type offs chunkOffs|

    offs := 1+0.
    1 to:nchunks do:[:chunkIndex |
        len := frameBuffer doubleWordAt:(offs+0).
        type := frameBuffer wordAt:(offs+4).
        chunkOffs := offs + CHUNK_HEAD_SIZE.

        type == FLI_COLOR ifTrue:[
            self color64ChunkAt:chunkOffs.
        ] ifFalse:[
            type == FLI_256_COLOR ifTrue:[
                self color256ChunkAt:chunkOffs.
            ] ifFalse:[
                type == FLI_DELTA ifTrue:[
                    self deltaChunkAt:chunkOffs.
                ] ifFalse:[
                    type == FLI_LC ifTrue:[
                        self lcChunkAt:chunkOffs.
                    ] ifFalse:[
                        type == FLI_BRUN ifTrue:[
                            self brunChunkAt:chunkOffs.
                        ] ifFalse:[
                            'FLI [info]: unknown chunk type: ' infoPrint.
                            type hexPrintString infoPrintCR.
                            ^ false.
                        ]
                    ]
                ]
            ].
        ].
        offs := offs + len
    ].

    "
     FLIReader fromFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Created: 3.4.1997 / 22:28:11 / cg"
    "Modified: 3.4.1997 / 22:52:38 / cg"
! !

!FLIReader methodsFor:'reading'!

fromStream:aStream
    "read a FLI-movie from aStream."

    inStream := aStream.

    (self getHeader) ifFalse:[^ nil].

    Image badImageFormatQuerySignal handle:[:ex |
        ex errorString infoPrintCR.
        ^ nil
    ] do:[
        1 to:nframes do:[:frameIndex |
            self getFrame
        ]
    ].

    colorMap := MappedPalette 
                    redVector:redPalette 
                    greenVector:greenPalette 
                    blueVector:bluePalette.

    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    "
     FLIReader fromFile:'/usr/local/FLI/jeffmild.fli'      
     Image fromFile:'/usr/local/FLI/jeffmild.fli'      
    "

    "Modified: 24.6.1997 / 15:58:18 / cg"
! !

!FLIReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/FLIReader.st,v 1.14 2003-11-19 15:28:19 cg Exp $'
! !


FLIReader initialize!

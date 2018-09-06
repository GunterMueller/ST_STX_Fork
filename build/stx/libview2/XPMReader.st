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

ImageReader subclass:#XPMReader
	instanceVariableNames:'charsPerPixel maskPixelValue characterTranslation imageName'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!XPMReader class methodsFor:'documentation'!

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
    This class provides methods for loading x-pixmap-file (xpm) images.

    These images are used (in X) for palette images 
    (see ctwm or hp-vue for a lot of them).
    The format is actually a piece of C-code, which can be compiled by the C-compiler
    into a constant image data structure.

    The code here is a hack - it may not work for all images 
    (it works for the testfiles I got here).

    Limitations: 
        only reads the full-color specification, ignoring monochrome
        and greyscale info.

        Can only handle single-character index.

        Only understands single-word color names (i.e. names with spaces 
        are not supported)

        Image writing is only supported for images with less than about 200
        colors (single byte encoding). 
        If present, the mask must be a single bit mask (i.e. no alpha channel).
        Due to the algorithm, writing may be slow for big images

    Suggestions: adapt & use the XPM library here.


    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XWDReader 
"
!

examples
"
  Reading from a file:
                                                                        [exBegin]
    |image|

    image := Image fromFile:('../../goodies/bitmaps/xpmBitmaps/INFO.xpm').
    image inspect
                                                                        [exEnd]


  Saving to a file:
                                                                        [exBegin]
    |image|

    image := Image fromScreen:(0@0 corner:30@30).
    image usedColors size > 256 ifTrue:[
        image := image asDitheredImageUsing:(Color standardDitherColorsForDepth8) depth:8.
    ].
    XPMReader save:image onFile:'/tmp/test.xpm'.
    '/tmp/test.xpm' asFilename contents asString inspect
                                                                        [exEnd]


  Or directly into a stream:
                                                                        [exBegin]
    |image stream|

    image := Image fromScreen:(0@0 corner:30@30).
    image usedColors size > 256 ifTrue:[
        image := image asDitheredImageUsing:(Color standardDitherColorsForDepth8) depth:8.
    ].
    stream := WriteStream on:(String new).
    XPMReader save:image onStream:stream.
    stream contents inspect
                                                                        [exEnd]
"
! !

!XPMReader class methodsFor:'initialization'!

initialize
    "tell Image-class, that a new fileReader is present
     for the '.xpm' and '.pm' extensions."

    MIMETypes defineImageType:'image/x-xpixmap' suffix:'xpm' reader:self.
    MIMETypes defineImageType:nil               suffix:'pm'  reader:self.

    "Modified: 1.2.1997 / 15:10:29 / cg"
! !

!XPMReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Currently only images with less than 80 colors are supported."

    anImage depth <= 6 ifTrue:[^ true].
    anImage photometric == #palette ifTrue:[
        anImage colorMap size < 256 ifTrue:[^ true].
    ].
    (anImage usedColorsMax:256) notNil ifTrue:[^ true].
    ('XPMReader [info]: too many colors in image (only up to 256 supported).') infoPrintCR.
    ^ false

    "Modified: 27.2.1997 / 12:40:22 / cg"
!

isValidImageFile:aFileName
    "return true, if aFileName contains an x-bitmap-file image"

    |line inStream |

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    Stream readErrorSignal handle:[:ex |
        line := nil
    ] do:[
        Stream lineTooLongErrorSignal handle:[:ex |
            line := nil.
            Transcript showCR:'XPMReader [info]: long line'.
            ex return.
        ] do:[
            line := inStream nextLine.
        ]
    ].
    inStream close.
    line isNil ifTrue:[^ false].
    (line startsWith:'/* XPM') ifFalse:[^ false].
    ^ true

    "
     XPMReader isValidImageFile:'fooBar'    
     XPMReader isValidImageFile:'../../goodies/bitmaps/xpmBitmaps/device_images/ljet.xpm'      
     XPMReader isValidImageFile:'bitmaps/gifImages/garfield.gif' 
    "

    "Modified: 24.4.1997 / 20:29:40 / cg"
! !

!XPMReader methodsFor:'private-reading'!

colorNameFrom:aStream
    "read either a color-name or value specified in X-notation
     (#rrggbb where rr, gg and bb are 2-digit hex numbers)"

    |s|

    aStream peek == $# ifTrue:[
	aStream next.
	s := '#'.
    ] ifFalse:[
	s := ''.
    ].
    [aStream peek isLetterOrDigit] whileTrue:[
	s := s copyWith:aStream next
    ].
    ^ s
!

readColorMap:colorMapSize
    |redMap greenMap blueMap s key lineDone state
     symbolicName monoName greyName grey4Name colorName|

    redMap := ByteArray new:colorMapSize.
    greenMap := ByteArray new:colorMapSize.
    blueMap := ByteArray new:colorMapSize.

    1 to:colorMapSize do:[:colorIndex |
        |index line color t word|

        line := inStream nextLine.
        [line notNil and:[line startsWith:'/*']] whileTrue:[
            [line notNil and:[(line endsWith:'*/') not]] whileTrue:[
                line := inStream nextLine.
            ].
            line := inStream nextLine.
        ].
        line notNil ifTrue:[
            line := line withoutSeparators
        ].
        (line notNil and:[line startsWith:'"']) ifFalse:[
            ^ self fileFormatError:'format error (expected color spec)'.
        ].

        s := ReadStream on:line.
        s next. "skip quote"
        charsPerPixel ~~ 1 ifTrue:[
            key := s next:charsPerPixel.
            characterTranslation at:key put:colorIndex - 1.
        ] ifFalse:[
            index := s next codePoint.
            characterTranslation at:index put:colorIndex - 1.
        ].

        lineDone := false.
        state := nil.

        [lineDone] whileFalse:[
            s skipSeparators.
            s peek == $# ifTrue:[
                word := self colorNameFrom:s
            ] ifFalse:[
                word := s nextAlphaNumericWord.
            ].
            word isNil ifTrue:[
                lineDone := true
            ] ifFalse:[
                word = 's' ifTrue:[
                    "/ symbolic name ...
                    state := $s. symbolicName := ''.
                ] ifFalse:[
                    word = 'm' ifTrue:[
                        "/ monochrome data
                        state := $m. monoName := ''.
                    ] ifFalse:[
                        word = 'g' ifTrue:[
                            "/ grey data
                            state := $g. greyName := ''.
                        ] ifFalse:[
                            word = 'g4' ifTrue:[
                                "/ grey data
                                state := $G. grey4Name := ''.
                            ] ifFalse:[
                                word = 'c' ifTrue:[
                                    "/ color data
                                    state := $c. colorName := ''.
                                ] ifFalse:[
                                    "/ append to name
                                    state isNil ifTrue:[
                                        ^ self fileFormatError:('format error got: ' 
                                                                , word printString 
                                                                , ' (expected ''c'',''m'',''g'' or ''s'')').
                                    ].

                                    state == $m ifTrue:[
                                        monoName := monoName , ' ' , word.
                                    ].
                                    state == $g ifTrue:[
                                        greyName := greyName , ' ' , word.
                                    ].
                                    state == $G ifTrue:[
                                        grey4Name := grey4Name , ' ' , word.
                                    ].
                                    state == $c ifTrue:[
                                        colorName := colorName , ' ' , word.
                                    ].
                                    state == $s ifTrue:[
                                        symbolicName := symbolicName , ' ' , word.
                                    ].
                                    (word startsWith:'#') ifTrue:[
                                        state := nil.
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ].
        ].

        colorName notNil ifTrue:[
            colorName := colorName withoutSeparators
        ].
        monoName notNil ifTrue:[
            monoName := monoName withoutSeparators
        ].
        greyName notNil ifTrue:[
            greyName := greyName withoutSeparators
        ].
        grey4Name notNil ifTrue:[
            grey4Name := grey4Name withoutSeparators
        ].
        symbolicName notNil ifTrue:[
            symbolicName := symbolicName withoutSeparators
        ].

        "/
        "/ for now - ignore everything, except
        "/ colorName (if there is one)
        "/
        colorName isNil ifTrue:[
            colorName := greyName.
            colorName isNil ifTrue:[
                colorName := monoName.
            ]
        ].

        (colorName sameAs: 'none') ifTrue:[
            color := Color noColor. "/ white
            redMap at:colorIndex put:0.
            greenMap at:colorIndex put:0.
            blueMap at:colorIndex put:0.
            maskPixelValue := colorIndex-1.
        ] ifFalse:[
            color := Color name:colorName ifIllegal:(Color black).
            redMap at:colorIndex put:(color red asFloat * 255.0 // 100).
            greenMap at:colorIndex put:(color green asFloat * 255.0 // 100).
            blueMap at:colorIndex put:(color blue asFloat * 255.0 // 100).
        ].
    ].

    colorMap := MappedPalette redVector:redMap greenVector:greenMap blueVector:blueMap.
! !

!XPMReader methodsFor:'private-writing'!

colorNameOf:aColor
    "generate a name for a color. If its a standard color,
     return its name; otherwise return the hex representation."

    #(white black red green blue
      yellow magenta cyan orange) do:[:aStandardColorName |
        aColor = (Color name:aStandardColorName) ifTrue:[
            ^ aStandardColorName.
        ]
    ].
    ^ '#' 
     , (aColor redByte hexPrintString:2)
     , (aColor greenByte hexPrintString:2)
     , (aColor blueByte hexPrintString:2)

    "Created: / 27.2.1997 / 11:48:40 / cg"
    "Modified: / 6.6.1998 / 20:58:49 / cg"
! !

!XPMReader methodsFor:'reading'!

readImage
    "read an XPM-image from my inStream. Return the receiver 
     (with all relevant instance variables set for the image) 
     or nil on error"

    |line 
     srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     colorMapSize   
     s bitsPerPixel bytesPerPixel 
     key lastKey lastChar1 lastChar2 
     c1 c2 lastXLation clr|

    line := inStream nextLine.
    (line notNil and:[line startsWith:'/* XPM']) ifFalse:[
        ^ self fileFormatError:'format error (expected XPM)'.
    ].

    line := inStream nextLine.
    [line notNil and:[(line startsWith:'/*') or:[line isBlank or:[(line startsWith:' *')]]]] whileTrue:[
        line := inStream nextLine.
    ].
    line notNil ifFalse:[
        ^ self fileFormatError:'format error (unexpected end of file)'.
    ].
    ((line startsWith:'static char') or:[(line startsWith:'static const char')]) ifFalse:[
        ^ self fileFormatError:'format error (expected static char)'.
    ].
    line := inStream nextLine.
    (line notNil and:[line startsWith:'/*']) ifTrue:[
        [line notNil 
         and:[(line startsWith:'/*') or:[line startsWith:' *']]] whileTrue:[
            line := inStream nextLine.
        ].
    ].
    line notNil ifTrue:[
        line := line withoutSeparators
    ].
    (line notNil and:[line startsWith:'"']) ifFalse:[
        ^ self fileFormatError:'format error (expected "ww hh nn mm)'.
    ].
    s := ReadStream on:line.
    s next.  "skip quote"
    width := Integer readFrom:s.
    height := Integer readFrom:s.
    colorMapSize := Integer readFrom:s.
    charsPerPixel := Integer readFrom:s.

    self reportDimension.

    charsPerPixel ~~ 1 ifTrue:[
        characterTranslation := Dictionary new:colorMapSize.
    ] ifFalse:[
        characterTranslation := Array new:256.
    ].

    self readColorMap:colorMapSize.

    "actually, could make it an image with less depth most of the time ..."

"
    bitsPerPixel := ((colorMapSize - 1) log:2) truncated + 1.
"
    colorMapSize > 16r100 ifTrue:[
        colorMapSize > 16r10000 ifTrue:[
            bitsPerPixel := 24.
            bytesPerPixel := 3.
        ] ifFalse:[
            bitsPerPixel := 16.
            bytesPerPixel := 2.
        ].
    ] ifFalse:[
        bitsPerPixel := 8.
        bytesPerPixel := 1.
    ].
    data := ByteArray new:(width * bytesPerPixel * height).

    dstIndex := 1.
    1 to:height do:[:row |
        line := inStream nextLine withoutSpaces.
        [line notNil and:[line startsWith:'/*']] whileTrue:[
            line := inStream nextLine withoutSpaces.
        ].
        line notNil ifTrue:[
            line := line withoutSeparators
        ].
        (line notNil and:[line startsWith:'"']) ifFalse:[
            ^ self fileFormatError:'format error (expected pixels)'.
        ].
        charsPerPixel == 1 ifTrue:[
            srcIndex := 2. "skip dquote"
            1 to:width do:[:col |
                key := line at:srcIndex.
                key ~~ lastKey ifTrue:[
                    lastXLation := characterTranslation at:key codePoint.
                    lastKey := key
                ].
                data at:dstIndex put:lastXLation.
                srcIndex := srcIndex + 1.
                dstIndex := dstIndex + 1
            ]
        ] ifFalse:[
            charsPerPixel == 2 ifTrue:[
                "/ sorry, but this ugly code does a lot for speed,
                "/ when reading big Xpm files (factor=5 for banner8.xpm)  ...
                srcIndex := 2."skip dquote"
                lastChar1 := lastChar2 := nil.
                key := String new:2.
                1 to:width do:[:col |
                    c1 := line at:srcIndex.
                    c2 := line at:srcIndex+1.
                    (c1 ~~ lastChar1 or:[c2 ~~ lastChar2]) ifTrue:[
                        key at:1 put:c1.
                        key at:2 put:c2.
                        lastXLation := characterTranslation at:key.
                        lastChar1 := c1.
                        lastChar2 := c2.
                    ].
                    bitsPerPixel == 8 ifTrue:[
                        data at:dstIndex put:lastXLation.
                        dstIndex := dstIndex + 1.
                    ] ifFalse:[    
                        bitsPerPixel == 16 ifTrue:[
                            data at:dstIndex   put:(lastXLation bitAnd:16rFF).
                            data at:dstIndex+1 put:((lastXLation bitShift:-8) bitAnd:16rFF).
                            dstIndex := dstIndex + 2.
                        ] ifFalse:[
                            clr := colorMap at:lastXLation+1.    
                            data at:dstIndex   put:clr redByte.
                            data at:dstIndex+1 put:clr greenByte.
                            data at:dstIndex+2 put:clr blueByte.
                            dstIndex := dstIndex + 3.
                        ]
                    ].
                    srcIndex := srcIndex + 2.
                ]
            ] ifFalse:[
                s := line readStream.
                s next. "/ skip dquote
                1 to:width do:[:col |
                    key := s next:charsPerPixel.
"/                data at:dstIndex put:(characterTranslation at:key).
                    key ~= lastKey ifTrue:[
                        lastXLation := characterTranslation at:key.
                        lastKey := key
                    ].
                    data at:dstIndex put:lastXLation.
                    dstIndex := dstIndex + 1
                ]
            ]
        ]
    ].

    bitsPerPixel == 24 ifTrue:[
        photometric := #rgb.
        samplesPerPixel := 3.
        bitsPerSample := #(8 8 8).
    ] ifFalse:[
        photometric := #palette.
        samplesPerPixel := 1.
        bitsPerSample := Array with:bitsPerPixel.
    ].

    maskPixelValue notNil ifTrue:[
        self buildMaskFromColor:maskPixelValue
    ].

    "
     XPMReader fromStream:('../../goodies/bitmaps/xpmBitmaps/FATAL.xpm' asFilename readStream)
    "

    "Created: / 24.9.1995 / 06:20:06 / claus"
    "Modified: / 24.9.1995 / 07:07:33 / claus"
    "Modified: / 5.7.1996 / 17:27:59 / stefan"
    "Modified: / 27.7.1998 / 20:01:56 / cg"
! !

!XPMReader methodsFor:'writing'!

save:image onFile:aFileName
    "save image as XPM file on aFileName.
     Caveat: currently, only a maximum of roughly 50 colors is handled
             (i.e. very simple images)"

    imageName := aFileName asFilename baseName asFilename withoutSuffix asString.
    imageName replaceAll:$. with:$_.

    super save:image onFile:aFileName.
!

save:image onStream:aStream
    "save image as XPM file on aStream.
     Caveat: currently, only a maximum of 256 colors is handled
            (i.e. very simple images)"

    |usedColors nColorsUsed nColors nChars map maskColorIndex
     isMasked imageMask|

    usedColors := image usedColorsMax:4096.
    usedColors isNil ifTrue:[
        ^ Image cannotRepresentImageSignal 
            raiseWith:image
            errorString:('XPMReader cannot represent this image (too many colors)').
    ].

    usedColors := usedColors asArray.
    nColors := nColorsUsed := usedColors size.
    (imageMask := image mask) notNil ifTrue:[
        nColors := nColors + 1.
        maskColorIndex := nColors.
    ].
    nColors > 256 ifTrue:[
        ^ Image cannotRepresentImageSignal 
            raiseWith:image
            errorString:('XPMReader cannot represent this image (too many colors)').
    ].

    map := ($a to: $z) asOrderedCollection.
    map addAll:($A to: $Z) "asOrderedCollection".
    map addAll:($0 to: $9) "asOrderedCollection".
    map addAll:#($. $, $` $^ $* $: $; $< $> $? $% $# $& $( $) $- $+ $=) "asOrderedCollection".
    nChars := 1.

    nColors > map size ifTrue:[
        map := OrderedCollection new.
        $a to: $j do:[:c1 |
            map addAll:(($a to: $z) collect:[:c2 | c1 asString , c2 asString]).
        ].
        nChars := 2.
    ].

    outStream := aStream.

    outStream nextPutLine:'/* XPM */'.
    outStream nextPutLine:'static char *' , (imageName ? 'unnamed') , '_xpm[] = {'.
    outStream nextPutLine:'/* width height ncolors chars_per_pixel */'.
    outStream nextPutLine:'"' , image width printString , ' '
                              , image height printString , ' '
                              , nColors printString , ' '
                              , nChars printString , '",'.


    outStream nextPutLine:'/* colors */'.
    1 to:nColorsUsed do:[:idx |
        |clr|

        clr := usedColors at:idx.
        outStream nextPutLine:'"' , (map at:idx) asString ,
                              ' ' , 'c ' , (self colorNameOf:clr) ,
                              '",'.
    ].
    maskColorIndex notNil ifTrue:[
        outStream nextPutLine:'"' , (map at:maskColorIndex) asString ,
                              ' c none",'.
    ].

    outStream nextPutLine:'/* pixels */'.

    maskColorIndex isNil ifTrue:[
        isMasked := false
    ].

    0 to:image height - 1 do:[:y |
        outStream nextPutAll:'"'.
        0 to:image width - 1 do:[:x |
            |clr idx|

            maskColorIndex notNil ifTrue:[
                isMasked := (imageMask pixelAtX:x y:y) == 0
            ].
            isMasked ifTrue:[
                outStream nextPutAll:(map at:maskColorIndex) asString
            ] ifFalse:[
                clr := image colorAtX:x y:y.
                idx := usedColors indexOf:clr.
                outStream nextPutAll:(map at:idx) asString
            ]
        ].
        outStream nextPutLine:'",'.
    ].
    outStream nextPutLine:'};'.

    "Modified: / 28.7.1998 / 21:52:13 / cg"
! !

!XPMReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


XPMReader initialize!

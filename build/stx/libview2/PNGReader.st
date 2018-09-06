"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

ImageReader subclass:#PNGReader
        instanceVariableNames:'colorType bitsPerChannel depth compressionMethod filterMethod
                interlaceMode bytesPerScanline globalDataChunk thisScanline
                prevScanline processTextChunks'
        classVariableNames:'Verbose'
        poolDictionaries:''
        category:'Graphics-Images-Readers'
!

!PNGReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    This class will provide methods for loading and saving PNG pictures.
    It is currenty unfinished (some interlaced image formats are unsupported, for example: grayscale+alpha)
    In the meantime, use a pngtoXXX converter for interlaced images, and read XXX.

    [caveats:]
        writer ignores any mask (for now).
        writer only generates unfiltered non-interlaced data
        
    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 

    [author:]
        Claus Gittinger
"
!

examples
"
    PNGReader fromFile:'/home/cg/AudioExplorer_51_files/use_small.png'
    PNGReader fromFile:'\\Exeptn\tmp\images\expeccoScreenshot4020_5526507.png'

    PNGReader fromFile:'C:\Users\cg\Desktop\croquet\cobalt-base-current-build-20090210\cobalt-base-current-build-20090210\content\models\textures\checkerboard.png'
    PNGReader fromFile:'C:\Dokumente und Einstellungen\cg\Desktop\misc\PNGs\Delete.png'
    PNGReader fromFile:'\\exeptn\unsaved\pd_stuff\PNGs\Delete.png'
    PNGReader fromFile:'\\exeptn\unsaved\pd_stuff\PNGs\Down.png'


    |img img2 outStream png|

    img := ToolbarIconLibrary error32x32Icon.
    outStream := WriteStream on:(ByteArray new:100).
    PNGReader save:img onStream:outStream.
    png := outStream contents.
    img2 := PNGReader fromStream:(png readStream).
    self assert:(img bits = img2 bits).
    img inspect.
    img2 inspect.
"
! !

!PNGReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table for the `.png' extension."

    MIMETypes defineImageType:'image/png'  suffix:'png' reader:self.
    "/ backward compatibility from times when png was not yet so common...
    MIMETypes defineImageType:'image/x-png' suffix:nil reader:self.
! !

!PNGReader class methodsFor:'queries'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Any image is supported."

    ^ true
! !

!PNGReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains a PNG image"

    |inStream magic|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    inStream binary.

    magic := ByteArray new:8.
    inStream nextBytes:8 into:magic.
    inStream close.

    ^ (magic = #[137 80 78 71 13 10 26 10])

    "
     self isValidImageFile:'/home/cg/AudioExplorer_51_files/use_small.png'
     self isValidImageFile:'C:\Users\cg\Desktop\croquet\cobalt-base-current-build-20090210\cobalt-base-current-build-20090210\content\models\textures\checkerboard.png'
     self isValidImageFile:'C:\Dokumente und Einstellungen\cg\Desktop\misc\PNGs\Delete.png'
    "

    "Modified: 21.6.1996 / 20:38:46 / cg"
! !

!PNGReader methodsFor:'private-chunks'!

doPass: pass
    "Certain interlace passes are skipped with certain small image dimensions"

    pass = 1 ifTrue: [ ^ true ].
    ((width = 1) and: [height = 1]) ifTrue: [ ^ false ].
    pass = 2 ifTrue: [ ^ width >= 5 ].
    pass = 3 ifTrue: [ ^ height >= 5 ].
    pass = 4 ifTrue: [ ^ (width >=3 ) or: [height >= 5] ].
    pass = 5 ifTrue: [ ^ height >=3 ].
    pass = 6 ifTrue: [ ^ width >=2 ].
    pass = 7 ifTrue: [ ^ height >=2 ].

    self error:'invalid argument'.
    ^ true
!

processBKGDChunkLen:len
    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:15:49 / cg"
!

processCHRMChunkLen:len
    "cHRM Primary chromaticities chunk - currently unhandled"

    |whitePointX whitePointY redX redY greenX greenY blueX blueY|

    whitePointX := (inStream nextInt32MSB:true) / 100000.0.
    whitePointY := (inStream nextInt32MSB:true) / 100000.0.
    redX := (inStream nextInt32MSB:true) / 100000.0.
    redY := (inStream nextInt32MSB:true) / 100000.0.
    greenX := (inStream nextInt32MSB:true) / 100000.0.
    greenY := (inStream nextInt32MSB:true) / 100000.0.
    blueX := (inStream nextInt32MSB:true) / 100000.0.
    blueY := (inStream nextInt32MSB:true) / 100000.0.

    Verbose == true ifTrue:[
        'PNGReader: CHRM chunk ignored:' infoPrintCR.
        'PNGReader:   whitePointX:' infoPrint. whitePointX infoPrintCR.
        'PNGReader:   whitePointY:' infoPrint. whitePointX infoPrintCR.
        'PNGReader:   redX:' infoPrint. redX infoPrintCR.
        'PNGReader:   redY:' infoPrint. redY infoPrintCR.
        'PNGReader:   greenX:' infoPrint. greenX infoPrintCR.
        'PNGReader:   greenY:' infoPrint. greenY infoPrintCR.
        'PNGReader:   blueX:' infoPrint. blueX infoPrintCR.
        'PNGReader:   blueY:' infoPrint. blueY infoPrintCR.
    ].
    ^ true
!

processChunk:type len:len
    |chunk|

    type = 'IDAT' ifTrue:[
        "---since the compressed data can span multiple
        chunks, stitch them all together first. later,
        if memory is an issue, we need to figure out how
        to do this on the fly---"
        chunk := inStream next:len.
        globalDataChunk isNil ifTrue:[
            globalDataChunk := ReadWriteStream on:(ByteArray new:(height * self bytesPerRow)).
        ].
        globalDataChunk nextPutAll:chunk.
        ^ true
    ].

    type = 'gAMA' ifTrue:[^ self processGAMAChunkLen:len].
    type = 'sBIT' ifTrue:[^ self processSBITChunkLen:len].
    type = 'tEXt' ifTrue:[^ self processTEXTChunkLen:len].
    type = 'tIME' ifTrue:[^ self processTIMEChunkLen:len].
    type = 'bKGD' ifTrue:[^ self processBKGDChunkLen:len].
    type = 'zTXt' ifTrue:[^ self processZTXTChunkLen:len].
    type = 'PLTE' ifTrue:[^ self processPLTEChunkLen:len].

    type = 'pHYs' ifTrue:[^ self processPHYSChunkLen:len].
    type = 'cHRM' ifTrue:[^ self processCHRMChunkLen:len].
    type = 'tRNS' ifTrue:[^ self processTRNSChunkLen:len].
    type = 'IHDR' ifTrue:[^ self processIHDRChunkLen:len].

    type = 'iTXt' ifTrue:[^ self processITXTChunkLen:len].
    type = 'iCCP' ifTrue:[^ self processICCPChunkLen:len].
    
    ('PNGReader: unrecognized chunk: ' , type , ' ignored.') infoPrintCR.

    inStream skip:len.
    ^ true.

    "Created: 21.6.1996 / 21:10:37 / cg"
    "Modified: 21.6.1996 / 21:22:37 / cg"
!

processGAMAChunkLen:len
    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:10:52 / cg"
!

processGlobalIDATChunk
    interlaceMode == 0 ifTrue: [
        ^ self processNonInterlacedGlobalDATA
    ]. 
    ^ self processInterlacedGlobalDATA
!

processICCPChunkLen:len
    "/ ignored
    "/ inStream nextBytes:len.

    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:15:58 / cg"
!

processIDATChunkLen:len
    interlaceMode == 0 ifTrue: [
        ^ self processNonInterlacedDATA:len
    ]. 
    ^ self processInterlacedDATA:len
!

processIHDRChunkLen:len
    "/ ignored
    
    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:15:58 / cg"
!

processITXTChunkLen:len
    "/ international (i.e.utf8) textual data.
    
    "/ currently ignored - not needed to display png images
    "/
    "/   Keyword:             1-79 bytes (character string)
    "/   Null separator:      1 byte
    "/   Compression flag:    1 byte
    "/   Compression method:  1 byte
    "/   Language tag:        0 or more bytes (character string)
    "/   Null separator:      1 byte
    "/   Translated keyword:  0 or more bytes
    "/   Null separator:      1 byte
    "/   Text:                0 or more bytes

    "/ if needed, set processTextChunks to true somewhere...
    processTextChunks == true ifTrue:[
        |chunkData keyword text i1 i2 i3 
         compressionFlag compressionMethod languageTag
         xlatedKeyword textBytes|

        chunkData := inStream nextBytes:len.
        i1 := chunkData indexOf:0.
        keyword := (chunkData copyTo:i1-1) asString.
        compressionFlag := chunkData at:i1+1.
        compressionMethod := chunkData at:i1+2.
        i2 := chunkData indexOf:0 startingAt:i1+3.
        languageTag := (chunkData copyFrom:i1+3 to:i2-1) asString.
        i3 := chunkData indexOf:0 startingAt:i2+1.
        xlatedKeyword := (chunkData copyFrom:i2+1 to:i3-1) asString.
        textBytes := chunkData copyFrom:i3+1.
        compressionFlag == 0 ifTrue:[
            text := textBytes
        ] ifFalse:[
            compressionFlag == 1 ifTrue:[
                "/ for now, only zlib compression is supported...
                'zlib compression currently unsupported' infoPrintCR.
            ] ifFalse:[
                'unsupported compression method' infoPrintCR.
            ].    
        ].    
        text := text utf8Decoded.
        self handleText:text keyword:keyword.
    ] ifFalse:[    
        inStream skip:len.
    ].
    ^ true

    "Created: 21.6.1996 / 21:15:58 / cg"
!

processInterlacedDATA:len
    inStream skip:len.
    ^ true
!

processInterlacedGlobalDATA
    "adam7 interlace method"

    | zlibReader filter 
      bytesPerPass startingCol colIncrement rowIncrement 
      startingRow 
      temp "filtersSeen"  
      cx       "{ Class: SmallInteger }"
      sc       "{ Class: SmallInteger }"
      cy       "{ Class: SmallInteger }"
      startRow "{ Class: SmallInteger }"
      w        "{ Class: SmallInteger }"
      h        "{ Class: SmallInteger }"
    |

    interlaceMode == 1 ifFalse: [
        self error:'unsupported interlaced mode'.
        ^ self
    ].

    "/ filtersSeen := Set new.

    startingCol := #(0 4 0 2 0 1 0 ).
    startingRow := #(0 0 4 0 2 0 1 ).
    colIncrement := #(8 8 4 4 2 2 1 ).
    rowIncrement := #(8 8 8 4 4 2 2 ).

    globalDataChunk reset.
    zlibReader := ZipStream readOpenAsZipStreamOn:globalDataChunk suppressHeaderAndChecksum:false.
    zlibReader binary.

    h := height.
    w := width.
    1 to: 7 do: [:pass |
        (self doPass: pass) ifTrue:[
            cx := colIncrement at: pass.
            sc := startingCol at: pass.
            cy := rowIncrement at: pass.
            bytesPerPass := (((w - sc + cx - 1) // cx * depth) + 7) // 8.
            prevScanline := ByteArray new: bytesPerPass.
            thisScanline := ByteArray new: bytesPerScanline.
            startRow := startingRow at: pass.
            startRow to: h-1 by: cy do: [:y |
                filter := zlibReader nextByte.
                "/ filtersSeen add: filter.
                (filter isNil or: [(filter between: 0 and: 4) not])
                    ifTrue: [^ self].
                zlibReader next: bytesPerPass into: thisScanline startingAt: 1.
                filter ~~ 0 ifTrue:[ self filterScanline: filter count: bytesPerPass ].
                self copyPixels:y at:sc by:cx.
                temp := prevScanline.
                prevScanline := thisScanline.
                thisScanline := temp.
            ]
        ]
    ].
    zlibReader atEnd ifFalse:[self error:'Unexpected data'].

    "Modified: / 03-05-2011 / 12:03:33 / cg"
!

processNonInterlacedDATA:len
    self halt:'not used'
"/
"/    | zlibReader filter temp prevScanline thisScanline bytesPerScanline filtersSeen|
"/
"/    zlibReader := ZipStream readOpenAsZipStreamOn:inStream suppressHeaderAndChecksum:false. 
"/    "/ zlibReader := ZLibReadStream on:inStream from: 1 to:len.
"/
"/    prevScanline := ByteArray new: self bytesPerRow.
"/    thisScanline := ByteArray new: self bytesPerRow.
"/    0 to: height - 1 do:[:index | 
"/            filter := (zlibReader next: 1) first.
"/            filtersSeen add: filter.
"/            (filter isNil or: [(filter between: 0 and: 4) not]) ifTrue: [^self].
"/            thisScanline := zlibReader next: bytesPerScanline into: thisScanline startingAt: 1.
"/            self filterScanline: filter count: bytesPerScanline.
"/            self copyPixels: index.
"/            temp := prevScanline.
"/            prevScanline := thisScanline.
"/            thisScanline := temp
"/    ]
!

processNonInterlacedGlobalDATA
    | "data n" zlibReader filter temp "filtersSeen" i|

    "/ filtersSeen := Set new.

"/    data := ByteArray new:(self bytesPerRow * height)+1000.
"/    n := ZipStream uncompress: globalDataChunk into: data.
"/    self halt.

    globalDataChunk reset.
    zlibReader := ZipStream readOpenAsZipStreamOn:globalDataChunk suppressHeaderAndChecksum:false.
    zlibReader binary.

    prevScanline := ByteArray new: bytesPerScanline.
    thisScanline := ByteArray new: bytesPerScanline.
    0 to: height - 1 do:[:y | 
        filter := zlibReader nextByte.
        "/ filtersSeen add: filter.
        (filter notNil and: [filter between: 0 and: 4]) ifFalse: [
            'PNGReader: unsupported filter: ' infoPrint. filter infoPrintCR.
            ^ self
        ].
        zlibReader next: bytesPerScanline into: thisScanline startingAt: 1.
        filter ~~ 0 ifTrue:[ self filterScanline: filter count: bytesPerScanline ].

        i := y * bytesPerScanline.
        data replaceFrom:i+1 to:(i+bytesPerScanline) with:thisScanline startingAt:1.

        temp := prevScanline.
        prevScanline := thisScanline.
        thisScanline := temp
    ].
    "/ Fill in mask if image contains alpha channel
    photometric == #rgba ifTrue:[ 
        | maskBits |

        mask := AlphaMask width: width height: height.
        maskBits := ByteArray new: width * height.

        0 to: height - 1 do:[:y | 
            0 to: width - 1 do:[:x |  
                | alpha |

                alpha := data at: (y * bytesPerScanline) + (x * 4) + 1.
                maskBits at: (y*width) + x + 1 put: alpha
            ]
        ].
        mask bits: maskBits
    ].

    "Modified: / 11-04-2016 / 08:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processPHYSChunkLen:len
    "physical pixel chunk - currently unhandled"

    |pixelPerUnitX pixelPerUnitY unit|

    pixelPerUnitX := inStream nextInt32MSB:true.  
    pixelPerUnitY := inStream nextInt32MSB:true.
    unit := inStream nextByte.

    Verbose == true ifTrue:[
        'PNGReader: PHYS chunk ignored:' infoPrintCR.
        'PNGReader:   ppuX:' infoPrint. pixelPerUnitX infoPrintCR.
        'PNGReader:   ppuY:' infoPrint. pixelPerUnitY infoPrintCR.
        'PNGReader:   unit:' infoPrint. unit infoPrintCR.
    ].

    ^ true
!

processPLTEChunkLen:len
    "read a color palette"

    |n "{ Class: SmallInteger }"
     redBytes greenBytes blueBytes|

    (len \\ 3) ~~ 0 ifTrue:[
        'PNGReader: invalid size of PLTE chunk' infoPrintCR.
        ^ false
    ].
    n := len // 3.
    redBytes := ByteArray new:n.
    greenBytes := ByteArray new:n.
    blueBytes := ByteArray new:n.

    1 to:n do:[:i |
        redBytes at:i put:(inStream nextByte).
        greenBytes at:i put:(inStream nextByte).
        blueBytes at:i put:(inStream nextByte)
    ].

    colorMap := MappedPalette 
                    redVector:redBytes 
                    greenVector:greenBytes 
                    blueVector:blueBytes.

    ^ true

    "Created: 21.6.1996 / 21:22:28 / cg"
    "Modified: 21.6.1996 / 21:43:01 / cg"
!

processSBITChunkLen:len
    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:13:09 / cg"
!

processTEXTChunkLen:len    
    "/ textual data in iso8859 coding.

    "/ currently ignored - not needed to display png images
    "/   Keyword:        1-79 bytes (character string)
    "/   Null separator: 1 byte
    "/   Text:           n bytes (character string)

    "/ if needed, set processTextChunks to true somewhere...
    processTextChunks == true ifTrue:[
        |chunkData keyword text i|

        chunkData := inStream nextBytes:len.
        i := chunkData indexOf:0.
        keyword := (chunkData copyTo:i-1) asString.
        text := (chunkData copyFrom:i+1) asString.
        self handleText:text keyword:keyword.
    ] ifFalse:[  
        inStream skip:len.
    ].    
    ^ true

    "Modified: 21.6.1996 / 21:15:27 / cg"
!

processTIMEChunkLen:len
    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:15:43 / cg"
    "Modified: 21.6.1996 / 21:20:42 / cg"
!

processTRNSChunkLen:len
    inStream skip:len.
    ^ true
!

processZTXTChunkLen:len
    "/ compressed text
    
    "/ currently ignored - not needed to display png images
    inStream skip:len.
    ^ true

    "Created: 21.6.1996 / 21:15:58 / cg"
! !

!PNGReader methodsFor:'private-filtering'!

filterAverage:count 
    "Use the average of the pixel to the left and the pixel above as a predictor"
    
    |delta|

%{
    if (__isByteArray(__INST(thisScanline))
     && __isByteArray(__INST(prevScanline))
     && __isSmallInteger(__INST(depth))
     && __isSmallInteger(count)) {
        unsigned char *__thisScanline = __byteArrayVal(__INST(thisScanline));
        unsigned int __sz_this = __byteArraySize(__INST(thisScanline));
        unsigned char *__prevScanline = __byteArrayVal(__INST(prevScanline));
        unsigned int __sz_prev = __byteArraySize(__INST(prevScanline));
        INT __count = __intVal(count);
        INT __delta = __intVal(__INST(depth)) / 8;
        int __i;

        if (__delta < 1) __delta = 1;
        for (__i=0; __i<__delta; __i++) {
            __thisScanline[__i] += (__prevScanline[__i] >> 1);
        }
        for (; __i < __count; __i++) {
            __thisScanline[__i] += ((__prevScanline[__i] + __thisScanline[__i-__delta]) >> 1);
        }
        RETURN(self);
    }
%}.

    delta := depth // 8 max:1.
    1 to:delta do:[:i | 
        thisScanline at:i put:((thisScanline at:i) + ((prevScanline at:i) // 2) bitAnd:255)
    ].
    delta + 1 to:count do:[:i | 
        thisScanline at:i put:((thisScanline at:i) + (((prevScanline at:i) + (thisScanline at:i - delta)) // 2) bitAnd:255)
    ]

    "Modified: / 03-05-2011 / 12:14:01 / cg"
!

filterHorizontal:count
    "use the pixel to the left as a predictor"

    |delta|

%{
    if (__isByteArray(__INST(thisScanline))
     && __isByteArray(__INST(prevScanline))
     && __isSmallInteger(__INST(depth))
     && __isSmallInteger(count)) {
        unsigned char *__thisScanline = __byteArrayVal(__INST(thisScanline));
        unsigned int __sz_this = __byteArraySize(__INST(thisScanline));
        unsigned char *__prevScanline = __byteArrayVal(__INST(prevScanline));
        unsigned int __sz_prev = __byteArraySize(__INST(prevScanline));
        INT __count = __intVal(count);
        INT __delta = __intVal(__INST(depth)) / 8;
        int __i;

        if (__delta < 1) __delta = 1;
        for (__i = __delta; __i < __count; __i++) {
            __thisScanline[__i] = __thisScanline[__i] + __thisScanline[__i-__delta];
        }
        RETURN(self);
    }
%}.

    delta := depth // 8 max:1.
    delta+1 to:count do:[:i|
        thisScanline at:i put:(((thisScanline at:i)+ (thisScanline at:i-delta)) bitAnd:255) 
    ]
!

filterNone: count
    "/ no filter - scanline is as is

    "Modified: / 03-05-2011 / 12:14:20 / cg"
!

filterPaeth:count 
    "Select one of (the pixel to the left, the pixel above and the pixel to above left) to
     predict the value of this pixel"
    
    |delta|

%{
    if (__isByteArray(__INST(thisScanline))
     && __isByteArray(__INST(prevScanline))
     && __isSmallInteger(__INST(depth))
     && __isSmallInteger(count)) {
        unsigned char *__thisScanline = __byteArrayVal(__INST(thisScanline));
        unsigned int __sz_this = __byteArraySize(__INST(thisScanline));
        unsigned char *__prevScanline = __byteArrayVal(__INST(prevScanline));
        unsigned int __sz_prev = __byteArraySize(__INST(prevScanline));
        INT __count = __intVal(count);
        INT __delta = __intVal(__INST(depth)) / 8;
        int __i;
        
        if (__delta < 1) __delta = 1;
        for (__i=0; __i<__delta; __i++) {
            unsigned int __pix = __thisScanline[__i] + __prevScanline[__i];
            __thisScanline[__i] = __pix;
        }
        for (; __i < __count; __i++) {
            int __pCenter = __thisScanline[__i];
            int __pLeft = __thisScanline[__i - __delta];
            int __pAbove = __prevScanline[__i];
            int __pAboveLeft = __prevScanline[__i - __delta];
            int __pa, __pb, __pc;
            int __p;
            
            __pa = (__pAbove - __pAboveLeft); 
            __pa = __pa < 0 ? -__pa : __pa;
            __pb = (__pLeft - __pAboveLeft);
            __pb = __pb < 0 ? -__pb : __pb;
            __pc = __pLeft + __pAbove - __pAboveLeft - __pAboveLeft;
            __pc = __pc < 0 ? -__pc : __pc; 
            if ((__pa <= __pb) && (__pa <= __pc)) __p = __pLeft;
            else if (__pb <= __pc) __p = __pAbove;
            else __p = __pAboveLeft;
            
            __thisScanline[__i] = __pCenter + __p;
        }
        RETURN(self);
    }
%}.

    delta := depth // 8 max:1.
    1 to:delta do:[:i | 
        thisScanline 
            at:i
            put:(((thisScanline at:i) + (prevScanline at:i)) bitAnd:255)
    ].
    delta + 1 to:count do:[:i | 
        thisScanline 
            at:i
            put:(((thisScanline at:i) + (self 
                            paethPredictLeft:(thisScanline at:i - delta)
                            above:(prevScanline at:i)
                            aboveLeft:(prevScanline at:i - delta))) 
                    bitAnd:255)
    ]

    "Modified: / 03-05-2011 / 12:14:43 / cg"
!

filterScanline:filterType count:count
    filterType == 0 ifTrue:[^ self].
    
    self 
        perform:(#(filterHorizontal: filterVertical: filterAverage: filterPaeth:) at:filterType)
        with:count

    "Modified: / 03-05-2011 / 12:13:31 / cg"
!

filterVertical:count 
    "Use the pixel above as a predictor"
    
%{
    if (__isByteArray(__INST(thisScanline))
     && __isByteArray(__INST(prevScanline))
     && __isSmallInteger(count)) {
        unsigned char *__thisScanline = __byteArrayVal(__INST(thisScanline));
        unsigned int __sz_this = __byteArraySize(__INST(thisScanline));
        unsigned char *__prevScanline = __byteArrayVal(__INST(prevScanline));
        unsigned int __sz_prev = __byteArraySize(__INST(prevScanline));
        INT __count = __intVal(count);
        int __i;

        for (__i=0; __i<__count; __i++) {
            unsigned int __pix = __thisScanline[__i] + __prevScanline[__i];
            __thisScanline[__i] = __pix;
        }
        RETURN(self);
    }
%}.

    1 to:count do:[:i | 
        thisScanline 
            at:i
            put:(((thisScanline at:i) + (prevScanline at:i)) bitAnd:255)
    ]

    "Modified: / 03-05-2011 / 12:14:34 / cg"
!

paethPredictLeft: l above: a aboveLeft: al
    "Predicts the value of a pixel based on nearby pixels, based on Paeth (GG II, 1991)"

    | pa pb pc |

    pa := a > al ifTrue: [a - al] ifFalse: [al - a].
    pb := l > al ifTrue: [l - al] ifFalse: [al - l].
    pc := l + a - al - al.
    pc < 0 ifTrue: [
        pc := pc * -1
    ].
    ((pa <= pb) and: [pa <= pc]) ifTrue: [^ l].
    (pb <= pc) ifTrue: [^ a].
    ^ al
! !

!PNGReader methodsFor:'private-pixel copy'!

copyPixels:y at:startX by:incX 
    "Handle interlaced pixels of supported colorTypes"
    
    |s|

    "/ per color type copy methods
    s := #( 
             #copyPixelsGray:at:by:         "/ 0
             nil
             #copyPixelsRGB:at:by:          "/ 2
             #copyPixelsIndexed:at:by:      "/ 3
             #copyPixelsGrayAlpha:at:by:    "/ 4 
             nil 
             #copyPixelsRGBA:at:by:         "/ 6
        ) at:colorType + 1.
    self perform:s with:y with:startX with:incX

    "Modified: / 03-05-2011 / 12:02:45 / cg"
!

copyPixelsGray:y at:startX by:incX 
    "Handle interlaced pixels of supported colorTypes.
     Untested code - please verify"

    |srcIndex "{ Class: SmallInteger }"
     srcMask  "{ Class: SmallInteger }"
     nPixels  "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     dstMask  "{ Class: SmallInteger }"
     x        "{ Class: SmallInteger }"
     bits     "{ Class: SmallInteger }"
     bitMask  "{ Class: SmallInteger }"
     rS       "{ Class: SmallInteger }"
     lS       "{ Class: SmallInteger }"
     rowIndex "{ Class: SmallInteger }"|
    
    nPixels := width // incX.
    srcIndex := 0. srcMask := 0. x := startX.

    depth == 1 ifTrue:[
        dstIndex := (y * bytesPerScanline) + (startX // 8) + 1.
        dstMask := 16r80 >> (x \\ 8).

        1 to:nPixels do:[:cnt |
            srcMask == 0 ifTrue:[
                srcMask := 16r80.
                srcIndex := srcIndex + 1.
                bits := thisScanline at:srcIndex. 
            ].
            bitMask := (bits bitAnd:srcMask) == 0 ifTrue:[0] ifFalse:[dstMask].
            bitMask ~~ 0 ifTrue:[
                data at:dstIndex put:((data at:dstIndex) bitOr:bitMask).
            ].    
            x := x + incX.
            dstMask := dstMask >> incX.
            dstMask == 0 ifTrue:[
                dstIndex := dstIndex + 1.
                dstMask := 16r80 >> (x \\ 8).
            ].
            srcMask := srcMask bitShift:-1.
        ].
        ^ self.
    ].
    
    depth == 2 ifTrue:[
        dstIndex := (y * bytesPerScanline) + (startX // 4) + 1.
        lS := 6 - ((x \\ 4) * 2).
        rS := -1. 
        1 to:nPixels do:[:cnt |
            rS < 0 ifTrue:[
                srcIndex := srcIndex + 1.
                bits := thisScanline at:srcIndex.
                rS := 6.
            ].
            bitMask := ((bits >> rS) bitAnd:2r11).
            bitMask ~~ 0 ifTrue:[
                bitMask := bitMask << lS.
                data at:dstIndex put:((data at:dstIndex) bitOr:bitMask).
            ].    
            lS := lS - (incX * 2).
            lS < 0 ifTrue:[
                lS <= -8 ifTrue:[
                    dstIndex := dstIndex + 2.
                    lS := lS + 8 + 8.
                ] ifFalse:[
                    dstIndex := dstIndex + 1.
                    lS := lS + 8.
                ].    
            ].
            rS := rS - 2.
        ].
        ^ self.
    ].
    
    depth == 4 ifTrue:[
        rowIndex := (y * bytesPerScanline) + 1.
        dstIndex := rowIndex + (x // 2).
        rS := -1. 
        1 to:nPixels do:[:cnt |
            rS < 0 ifTrue:[
                srcIndex := srcIndex + 1.
                bits := thisScanline at:srcIndex.
                rS := 4.
            ].
            bitMask := ((bits >> rS) bitAnd:2r1111).
            x even ifTrue:[    
                bitMask := bitMask bitShift:4.
            ].    
            data at:dstIndex put:((data at:dstIndex) bitOr:bitMask).
            x := x + incX.
            dstIndex := rowIndex + (x // 2).
            rS := rS - 4.
        ].
        ^ self.
    ].
    
    depth == 8 ifTrue:[
        srcIndex := 1.
        dstIndex := (y * bytesPerScanline) + (startX) + 1.

        1 to:nPixels do:[:n |
            data at:dstIndex put:(thisScanline at:srcIndex).
            srcIndex := srcIndex + 1.
            dstIndex := dstIndex + incX
        ].
        ^ self.
    ].

    depth == 16 ifTrue:[
        srcIndex := 1.
        dstIndex := (y * bytesPerScanline) + (startX*2) + 1.

        1 to:nPixels do:[:n |
            data unsignedInt16At:dstIndex put:(thisScanline unsignedInt16At:srcIndex).
            srcIndex := srcIndex + 2.
            dstIndex := dstIndex + (incX * 2)
        ].
        ^ self.
    ].
    self error:'unsupported depth'.
!

copyPixelsIndexed:y at:startX by:incX 
    self copyPixelsGray:y at:startX by:incX 
!

copyPixelsRGB:y at:startX by:incX 
    "Handle interlaced pixels of supported colorTypes.
     Untested code - please verify"

    |srcIndex "{ Class: SmallInteger }" 
     nPixels  "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     dstInc   "{ Class: SmallInteger }"
     bpp      "{ Class: SmallInteger }"|

    bpp := bytesPerScanline // width.
    
    "/ 1 byte per r,g,b
    srcIndex := 1.
    dstIndex := (y * bytesPerScanline) + (startX * bpp) + 1.
    dstInc := incX * bpp.

    nPixels := width // incX.
    1 to:nPixels do:[:n |
        data replaceFrom:dstIndex to:dstIndex+bpp-1 with:thisScanline startingAt:srcIndex.
        srcIndex := srcIndex + bpp.
        dstIndex := dstIndex + dstInc
    ].
!

copyPixelsRGBA:y at:startX by:incX 
    "Handle interlaced pixels of supported colorTypes.
     Untested code - please verify"

    |srcIndex "{ Class: SmallInteger }"
     nPixels  "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     dstInc   "{ Class: SmallInteger }"|

    srcIndex := 1.
    dstIndex := (y * bytesPerScanline) + (startX * 4) + 1.
    dstInc := incX * 4.

    nPixels := thisScanline size.
    [srcIndex < nPixels] whileTrue:[
        data replaceFrom:dstIndex to:dstIndex+3 with:thisScanline startingAt:srcIndex.
        srcIndex := srcIndex + 4.
        dstIndex := dstIndex + dstInc
    ].
! !

!PNGReader methodsFor:'private-reading'!

getChunk
    |len type crc|

    inStream atEnd ifTrue:[^ false].

    len := inStream nextInt32MSB:true.
    type := String new:4.
    (inStream nextBytes:4 into:type) ~~ 4 ifTrue:[^ false].

    Verbose == true ifTrue:[
        'len: ' infoPrint. len infoPrint. ' type: ' infoPrint. type infoPrintCR.
    ].

    type = 'IEND' ifTrue:[^ false].

    (self processChunk:type len:len) ifFalse:[^ false].

    crc := inStream nextInt32MSB:true.  "/ ignored - for now
    ^ true

    "Created: 21.6.1996 / 21:09:36 / cg"
    "Modified: 21.6.1996 / 21:20:26 / cg"
!

getIHDRChunk
    |len type crc|

    len := inStream nextInt32MSB:true.

    type := String new:4.
    inStream nextBytes:4 into:type.

    type = 'IHDR' ifFalse:[self halt:'expected IHDR magic'. ^ false].
    len == 13 ifFalse:[self halt:'unexpected IHDR length'. ^ false].

    width := inStream nextInt32MSB:true.        
    height := inStream nextInt32MSB:true.        

    (width <= 0 or:[height <= 0]) ifTrue:[
        'PNGReader: invalid dimension(s)' infoPrintCR.
        ^ false.
    ].
    self reportDimension.

    bitsPerChannel := inStream nextByte.
    depth := bitsPerChannel. "/ will be changed by setColorType.
    colorType := inStream nextByte.

    compressionMethod := inStream nextByte.
    filterMethod := inStream nextByte.
    interlaceMode := inStream nextByte.

    Verbose == true ifTrue:[
        'PNGReader: IHDR:' infoPrintCR.
        'PNGReader:   width: ' infoPrint. width infoPrintCR.
        'PNGReader:   height: ' infoPrint. height infoPrintCR.
        'PNGReader:   bitsPerChannel: ' infoPrint. bitsPerChannel infoPrintCR.
        'PNGReader:   colorType: ' infoPrint. colorType infoPrintCR.
        'PNGReader:   compressionMethod: ' infoPrint. compressionMethod infoPrintCR.
        'PNGReader:   filterMethod: ' infoPrint. filterMethod infoPrintCR.
        'PNGReader:   interlaceMode: ' infoPrint. interlaceMode infoPrintCR.
    ].

    crc := inStream nextInt32MSB:true.
    ^ true

    "Modified: 21.6.1996 / 21:38:35 / cg"
!

handleText:text keyword:keyword
    "/ things like exif data etc.
    "/ self halt.

    "/Standard keywords for text chunks:
    "/
    "/   Title            Short (one line) title or caption for image
    "/   Author           Name of image's creator
    "/   Description      Description of image (possibly long)
    "/   Copyright        Copyright notice
    "/   Creation Time    Time of original image creation
    "/   Software         Software used to create the image
    "/   Disclaimer       Legal disclaimer
    "/   Warning          Warning of nature of content
    "/   Source           Device used to create the image
    "/   Comment          Miscellaneous comment; conversion from
    "/                    GIF comment
!

setColorType:pngColorType
    pngColorType == 0 ifTrue:[
        photometric := #blackIs0.
        samplesPerPixel := 1.
        bitsPerSample := Array with:bitsPerChannel.
        depth := bitsPerChannel.
        ^ true.
    ].

    pngColorType == 2 ifTrue:[
        bitsPerChannel < 8 ifTrue:[
            'PNGReader: invalid colorType/depth combination' infoPrintCR.
            ^ false.
        ].
        photometric := #rgb.
        samplesPerPixel := 3.
        bitsPerSample := Array with:bitsPerChannel with:bitsPerChannel with:bitsPerChannel.
        depth := bitsPerChannel * 3.
        ^ true.
    ].

    pngColorType == 3 ifTrue:[
        bitsPerChannel == 16 ifTrue:[
            'PNGReader: invalid colorType/depth combination' infoPrintCR.
            ^ false.
        ].
        photometric := #palette.
        samplesPerPixel := 1.
        bitsPerSample := Array with:bitsPerChannel.
        depth := bitsPerChannel.
        ^ true.
    ].

    pngColorType == 4 ifTrue:[
        bitsPerChannel < 8 ifTrue:[
            'PNGReader: invalid colorType/depth combination' infoPrintCR.
            ^ false.
        ].
        photometric := #blackIs0.
        samplesPerPixel := 2.
        bitsPerSample := Array with:bitsPerChannel with:bitsPerChannel.
        depth := bitsPerChannel * 2.
        ^ true.
    ].

    pngColorType == 6 ifTrue:[
        bitsPerChannel < 8 ifTrue:[
            'PNGReader: invalid colorType/depth combination' infoPrintCR.
            ^ false.
        ].
        photometric := #rgba.
        samplesPerPixel := 4.
        bitsPerSample := Array with:bitsPerChannel with:bitsPerChannel with:bitsPerChannel with:bitsPerChannel.
        depth := bitsPerChannel * 4.
        ^ true.
    ].

    ('PNGReader: invalid colorType: ' , pngColorType printString , '.') infoPrintCR.
    ^ false

    "Modified: / 01-09-2015 / 16:02:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PNGReader methodsFor:'reading'!

fromStream:aStream
    "read a stream containing a PNG image.
     Leave image description in instance variables."

    |header|

    inStream := aStream.
    aStream binary.

    "PNG-files are always msb (network-world)"
    byteOrder := #msb.

    header := ByteArray new:8.
    aStream nextBytes:8 into:header.

    header ~= (self pngHeader) ifTrue:[
        'PNGReader: not a png file.' infoPrintCR.
        Image badImageFormatQuerySignal raiseRequestErrorString:'PNGReader: not a png file'.
        ^ nil
    ].

    (self getIHDRChunk) ifFalse:[
        'PNGReader: required IHDR chunk missing.' infoPrintCR.
        Image badImageFormatQuerySignal raiseRequestErrorString:'PNGReader: required IHDR chunk missing'.
        ^ nil
    ].

    compressionMethod ~~ 0 ifTrue:[
        ('PNGReader: compressionMethod %s not supported.' printfWith:compressionMethod printString) infoPrintCR.
        Image badImageFormatQuerySignal raiseRequestErrorString:'PNGReader: unsupported compression method'.
        ^ nil
    ].
    filterMethod > 0 ifTrue:[
        'PNGReader: invalid filterMethod' infoPrintCR.
        Image badImageFormatQuerySignal raiseRequestErrorString:'PNGReader: invalid/unsupported filterMethod'.
        ^ nil.
    ].
    interlaceMode > 1 ifTrue:[
        Image badImageFormatQuerySignal raiseRequestErrorString:'PNGReader: invalid/unsupported interlaceMode'.
        'PNGReader: invalid interlaceMode' infoPrintCR.
        ^ nil.
    ].
    (self setColorType:colorType) ifFalse:[
        ^ nil
    ].

    [self getChunk] whileTrue.

    bytesPerScanline := self bytesPerRow.
    data := ByteArray new:(bytesPerScanline * height).

    globalDataChunk notNil ifTrue:[
        self processGlobalIDATChunk.
        globalDataChunk := nil.
    ].

    photometric == #palette ifTrue:[
        colorMap isNil ifTrue:[
            Image badImageFormatQuerySignal raiseRequestErrorString:'PNGReader: palette chunk missing'.
            'PNGReader: palette chunk missing.' infoPrintCR.
            "/ ^ nil
        ].
    ].

    "
     PNGReader fromFile:'/home/cg/libpng-0.89c/pngtest.png'
    "

    "Modified: / 03-05-2011 / 12:17:34 / cg"
! !

!PNGReader methodsFor:'writing to file'!

pngHeader
    ^ #[137 80 78 71 13 10 26 10]
!

save:image onStream:aStream
    "save image in PNG-file-format onto aStream"

    outStream := aStream.
    outStream binary.

    byteOrder := #msb.
    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.
    colorMap := image colorMap.
    data := image bits.

    outStream nextPutAll:(self pngHeader).
    self writeIHDRChunk.
    photometric == #palette ifTrue: [self writePaletteChunk].
    self writeImageDataChunk.
    self writeEndChunk
!

writeChunk:chunkTypeChars size:len with:aBlock
    |crc realOutStream chunkBytes|

    realOutStream := outStream.
    outStream := WriteStream on:(ByteArray new:len).

    outStream nextPutBytes:4 from:chunkTypeChars startingAt:1.
    aBlock value.

    chunkBytes := outStream contents.
    crc := CRC32Stream hashValueOf:chunkBytes.

    outStream := realOutStream.

    realOutStream nextPutInt32:len MSB:true.
    realOutStream nextPutAll:chunkBytes.
    realOutStream nextPutInt32:crc MSB:true.
!

writeEndChunk
    self 
        writeChunk: 'IEND'
        size: 0
        with:[ ]
!

writeFileHeader
    outStream nextPutAll:(self pngHeader)
!

writeIHDRChunk
    ((photometric == #whiteIs0) or:[ (photometric == #blackIs0)]) ifTrue:[
        colorType := 0.
        samplesPerPixel > 1 ifTrue:[ colorType := colorType + 4].  "/ +alpha
    ].
    ((photometric == #rgb) or:[(photometric == #rgba)]) ifTrue:[
        colorType := 2.
        samplesPerPixel > 3 ifTrue:[ colorType := colorType + 4].  "/ +alpha
    ].
    (photometric == #palette) ifTrue:[
        colorType := 3.
        samplesPerPixel > 1 ifTrue:[ colorType := colorType + 4].  "/ +alpha
    ].
    colorType isNil ifTrue:[
        self error:'unhandled photometric'
    ].

    self 
        writeChunk: 'IHDR'
        size: 13
        with:[ 
            self writeLong:width.
            self writeLong:height.
            outStream nextPut: 8.  "Assume that all colors are 24bit"     "/ depth
            outStream nextPut: colorType.  
            outStream nextPut: 0.  "Compression"
            outStream nextPut: 0.  "Filter method"
            outStream nextPut: 0   "Non-interlaced"
        ]
!

writeImageDataChunk
    |compressedByteStream compressedBytes zlibWriter idx|

    bytesPerScanline := self bytesPerRow.
    
    compressedByteStream := WriteStream on:(ByteArray new:(bytesPerScanline*height)).
    zlibWriter := ZipStream writeOpenAsZipStreamOn:compressedByteStream suppressHeaderAndChecksum:false.
    zlibWriter binary.

    idx := 1.
    0 to:height-1 do:[:y |
        |row|

        row := data copyFrom:idx to:(idx+bytesPerScanline-1).
        zlibWriter nextPutAll:#[0].       "/ no filter
        zlibWriter nextPutAll:row.
        idx := idx + bytesPerScanline.
    ].

    zlibWriter close.
    compressedBytes := compressedByteStream contents.

    self 
        writeChunk: 'IDAT'
        size:(compressedBytes size)
        with:[ 
            outStream nextPutAll:compressedBytes
        ]
!

writePaletteChunk
    self 
        writeChunk: 'PLTE'
        size: 3 * colorMap size
        with:[
            colorMap do:[:color | 
                outStream
                    nextPut: color redByte;
                    nextPut: color greenByte;
                    nextPut: color blueByte
            ]
        ]
! !

!PNGReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


PNGReader initialize!

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

ImageReader subclass:#TIFFReader
	instanceVariableNames:'planarConfiguration subFileType stripOffsets rowsPerStrip
		fillOrder compression group3options predictor stripByteCounts
		currentOffset stripOffsetsPos stripByteCountsPos bitsPerSamplePos
		colorMapPos orientation'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

Dictionary subclass:#TIFFMetaData
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TIFFReader
!

!TIFFReader class methodsFor:'documentation'!

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
    This class knows how to read TIFF files and how to
    write uncompressed TIFF files.

    Implemented & Missing Features:

      - Only single image files are supported.
      - Not all formats are implemented, and of those that are, not all are tested.
        It should read with most rgb, palette, mono and greyscale images, 
        although the alpha channel is currently not supported and ignored.
        It supports reading of uncompressed, LZW, packbits and CCITT-G3 compressed images
        JPEG and many other formats are currently not implemented.

      - Only writing of uncompressed images is currently implemented.
        It should write (at least) mono, 8-bit palette and 24 bit rgb formats.

    More formats will come... (will they ever be needed ?)

    TODO (?): since I don't want to spend all of my life adding more formats here and
    reinventing the wheel, this code should be changed to use the tiff library.
    That would give us most formats and also writing capabilities for free.
    Late note: 
        I hate C and interfacing to C libraries: it almost always leads to trouble
        w.r.t. memory leaks, non-reentrancy, non-interruptability etc.
        (we recently fixed a malloc-non-reentrant bug for some architecture...)
        So its robably better to do it all in a real programming language ;-)

    [author:]
        Claus Gittinger

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
! !

!TIFFReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.tiff' and `.tif' extensions."

    MIMETypes defineImageType:'image/tiff' suffix:'tif'  reader:self.
    MIMETypes defineImageType:nil          suffix:'tiff' reader:self.

    "
     self initialize
    "

    "Modified: 1.2.1997 / 15:00:01 / cg"
! !

!TIFFReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Any image is supported."

    ^ true
!

isValidImageFile:aFileName
    "return true, if aFileName contains a GIF image"

    |inStream char1 char2 version|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    char1 := inStream next.
    char2 := inStream next.

    ((char1 ~~ char2) or:[(char1 ~~ $I) and:[char1 ~~ $M]]) ifTrue:[
        inStream close.
        ^ false
    ].

    inStream binary.
    version := inStream nextInt16MSB:(char1 == $M).
    inStream close.

    (version ~~ 42) ifTrue:[^ false].
    ^ true
! !

!TIFFReader methodsFor:'private'!

decodeTiffTag:tagType numberType:numberType length:length
    |offset value valueArray 
     val scaleFactor rV gV bV
     n  "{ Class: SmallInteger }"
     i2 "{ Class: SmallInteger }"
     i3 "{ Class: SmallInteger }" |

"/ 'tiffTag: ' print. tagType printCR.

    (numberType == 3 "TIFF_SHORT") ifTrue:[
        "16 bit ushort"
        valueArray := self readShorts:length signed:false.
        value := valueArray at:1
    ] ifFalse:[(numberType == 4 "TIFF_LONG") ifTrue:[
        "32 bit uinteger"
        valueArray := self readLongs:length signed:false.
        value := valueArray at:1
    ] ifFalse:[(numberType == 2 "TIFF_ASCII") ifTrue:[
        "ascii characters"
        value := self readChars:length
    ] ifFalse:[(numberType == 5 "TIFF_RATIONAL") ifTrue:[
        "64 (32+32) bit ufraction"
        valueArray := self readFracts:length signed:false.
        value := valueArray at:1
    ] ifFalse:[(numberType == 1 "TIFF_BYTE") ifTrue:[
        "8bit uinteger"
        value := self readBytes:length signed:false
    ] ifFalse:[(numberType == 6 "TIFF_SBYTE") ifTrue:[
        "TIFF6: 8bit signed integer"
        value := self readBytes:length  signed:true
    ] ifFalse:[(numberType == 8 "TIFF_SSHORT") ifTrue:[
        "TIFF6: 16bit signed integer"
        value := self readShorts:length signed:true
    ] ifFalse:[(numberType == 9 "TIFF_SLONG") ifTrue:[
        "TIFF6: 32bit signed integer"
        value := self readLongs:length signed:true
    ] ifFalse:[(numberType == 10 "TIFF_SRATIONAL") ifTrue:[
        "TIFF6: 64 (32+32) bit signed fraction"
        value := self readFracts:length signed:true
    ] ifFalse:[(numberType == 11 "TIFF_FLOAT") ifTrue:[
        "TIFF6: 32 bit IEEE float"
        value := self readFloats:length
    ] ifFalse:[(numberType == 12 "TIFF_DOUBLE") ifTrue:[
        "TIFF6: 64 bit IEEE double"
        value := self readDoubles:length
    ] ifFalse:[
        offset := (inStream nextInt32MSB:(byteOrder ~~ #lsb))
    ]]]]]]]]]]].

    (tagType < 300) ifTrue:[
        (tagType == 254) ifTrue:[
            "/ New SubfileType
            "/      REDUCEDIMAGE    -> 1
            "/      PAGE            -> 2
            "/      MASK            -> 4
            "newSubFileType := value."

            "/ 'newSubfiletype ' print. value printNewline.

            ^ self
        ].
        (tagType == 255) ifTrue:[
            "/ Old SubfileType
            "/      IMAGE           -> 1
            "/      REDUCEDIMAGE    -> 2
            "/      PAGE            -> 3
            subFileType := value.

            "/ 'subfiletype ' print. value printNewline.

            ^ self
        ].
        (tagType == 256) ifTrue:[
            "ImageWidth"
            width := value.

            "/ 'width ' print. width printNewline.

            ^ self
        ].
        (tagType == 257) ifTrue:[
            "ImageHeight"
            height := value.

            "/ 'height ' print. height  printNewline.

            ^ self
        ].
        (tagType == 258) ifTrue:[
            "bitspersample"  
             bitsPerSample := valueArray.

            "/ 'bitspersample ' print. bitsPerSample printNewline.

            ^ self
        ].
        (tagType == 259) ifTrue:[
            "/ compression
            "/      NONE            -> 1
            "/      CCITTRLE        -> 2
            "/      CCITTFAX3       -> 3
            "/      CCITTFAX4       -> 4
            "/      LZW             -> 5
            "/      OJPEG           -> 6
            "/      JPEG            -> 7
            "/      NEXT            -> 32766
            "/      CCITTRLEW       -> 32771
            "/      PACKBITS        -> 32773
            "/      THUNDERSCAN     -> 32809
            "/      PIXARFILM       -> 32908
            "/      PIXARLOG        -> 32909
            "/      DEFLATE         -> 32946
            "/      DCS             -> 32947
            "/      JBIG            -> 34661
            
            compression := value.

            "/ 'compression ' print. compression printNewline.

            ^ self
        ].
        (tagType == 262) ifTrue:[
            "photometric"

            (value == 0) ifTrue:[
              photometric := #whiteIs0
            ] ifFalse:[
              (value == 1) ifTrue:[
                photometric := #blackIs0
              ] ifFalse:[
                (value == 2) ifTrue:[
                  photometric := #rgb
                ] ifFalse:[
                  (value == 3) ifTrue:[
                    photometric := #palette
                  ] ifFalse:[
                    (value == 4) ifTrue:[
                      photometric := #transparencyMask
                    ] ifFalse:[
                      (value == 5) ifTrue:[
                        photometric := #cmyk  "/ color separations
                      ] ifFalse:[
                        (value == 6) ifTrue:[
                          photometric := #ycbcr    "/ CCIR 601
                        ] ifFalse:[
                          (value == 8) ifTrue:[
                            photometric := #cielab  "/ 1976 CIE L*a*b*
                          ] ifFalse:[
                            photometric := nil
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ].

            "/ 'photometric ' print. photometric printNewline.

            ^ self
        ].
        (tagType == 263) ifTrue:[
            "/ Treshholding
            "/      BILEVEL         -> 1
            "/      HALFTONE        -> 2
            "/      ERRORDIFFUSE    -> 3

            "threshholding := value."

            "/ 'treshholding ' print. value printNewline.

            ^ self
        ].
        (tagType == 264) ifTrue:[
            "CellWidth"
            "/ 'cellWidth ' print. value printNewline.
            metaData at:#CellWidth put:value.

            ^ self
        ].
        (tagType == 265) ifTrue:[
            "CellLength"
            "/ 'cellLength ' print. value printNewline.
            metaData at:#CellLength put:value.
            ^ self
        ].
        (tagType == 266) ifTrue:[
            "fillOrder"
            (value == 1) ifTrue:[
              fillOrder := #msb
            ] ifFalse:[
              (value == 2) ifTrue:[
                fillOrder := #lsb
              ] ifFalse:[
                fillOrder := nil
              ]
            ].

            "/ 'fillorder ' print. fillOrder printNewline.

            ^ self
        ].
        (tagType == 269) ifTrue:[
            "documentName - info only"
            "/ 'documentName ' print. value printNewline.
            metaData at:#DocumentName put:value.
            ^ self
        ].
        (tagType == 270) ifTrue:[
            "imageDescription - info only"
            "/ 'imageDescription ' print. value printNewline.
            metaData at:#ImageDescription put:value.
            ^ self
        ].
        (tagType == 271) ifTrue:[
            "make - info only"
            "/ 'make ' print. value printNewline.
            metaData at:#Make put:value.
            ^ self
        ].
        (tagType == 272) ifTrue:[
            "model - info only"
            "/ 'model ' print. value printNewline.
            metaData at:#Model put:value.
            ^ self
        ].
        (tagType == 273) ifTrue:[
            "stripoffsets"
            stripOffsets := valueArray.
            "/ 'stripOffsets Array(' print. stripOffsets size print. ')' printNewline.
            ^ self
        ].
        (tagType == 274) ifTrue:[
            "Orientation"

            orientation :=
                            #( nil          "/ 1 normal (topLeft)
                               unsupported  "/ 2 horizontal flip
                               unsupported  "/ 3 horizontal & vertical flip
                               vFlip        "/ 4 vertical flip
                               unsupported  "/ 5 rot 90' counter clock-wise
                               unsupported  "/ 6 rot 90' clock-wise
                               unsupported  "/ 7 rot 90' & flip
                               unsupported  "/ 8 rot 90' ccw & flip
                             ) at:value ifAbsent:#unsupported.
            metaData at:#Orientation put:value.
            "/ 'orientation ' print. value printNewline.
            ^ self
        ].
        (tagType == 277) ifTrue:[
            "samplesPerPixel"
            samplesPerPixel := value.
            "/ 'samplesperpixel ' print. samplesPerPixel printNewline.
            ^ self
        ].
        (tagType == 278) ifTrue:[
            "rowsperstrip"
            rowsPerStrip := value.
            "/ 'rowsperstrip ' print. rowsPerStrip printNewline.
            ^ self
        ].
        (tagType == 279) ifTrue:[
            "stripbytecount"
            stripByteCounts := valueArray.
            "/        'stripByteCounts Array(' print. 
            "/        stripByteCounts size print.
            "/        ')' printNewline.
            ^ self
        ].
        (tagType == 280) ifTrue:[
            "MinSampleValue"
            "/ 'minSampleValue ' print. value printNewline.
            metaData at:#MinSampleValue put:value.
            ^ self
        ].
        (tagType == 281) ifTrue:[
            "MaxSampleValue"
            "/ 'maxSampleValue ' print. value printNewline.
            metaData at:#MaxSampleValue put:value.
            ^ self
        ].
        (tagType == 282) ifTrue:[
            "xResolution"
            "/ 'xres ' print. value printNewline.
            metaData at:#ResolutionX put:value.
            ^ self
        ].
        (tagType == 283) ifTrue:[
            "yResolution"
            "/ 'yres ' print. value printNewline.
            metaData at:#ResolutionY put:value.
            ^ self
        ].
        (tagType == 284) ifTrue:[
            "planarconfig"
            (value == 1) ifTrue:[
              planarConfiguration := 1
            ] ifFalse:[
              (value == 2) ifTrue:[
                planarConfiguration := 2
              ] ifFalse:[
                planarConfiguration := nil
              ]
            ].
            "/ 'planarconfig ' print. planarConfiguration printNewline.
            ^ self
        ].
        (tagType == 285) ifTrue:[
            "pageName"
            "/ 'pageName ' print. value printNewline.
            metaData at:#PageName put:value.
            ^ self
        ].
        (tagType == 286) ifTrue:[
            "xPosition"
            "/ 'xPos ' print. value printNewline.
            metaData at:#PositionX put:value.
            ^ self
        ].
        (tagType == 287) ifTrue:[
            "yPosition"
            "/ 'yPos ' print. value printNewline.
            metaData at:#PositionY put:value.
            ^ self
        ].
        (tagType == 288) ifTrue:[
            "freeOffsets"
            "/ 'freeOffsets ' print. value printNewline.
            ^ self
        ].
        (tagType == 289) ifTrue:[
            "freeByteCounts"
            "/ 'freeByteCounts ' print. value printNewline.
            ^ self
        ].
        (tagType == 290) ifTrue:[
            "grayResponceUnit"
            "/ 'grayResponceUnit' print. value printNewline.
            metaData at:#GrayResponceUnit put:value.
            ^ self
        ].
        (tagType == 291) ifTrue:[
            "grayResponceCurve"
            "/ 'grayResponceCurve' print. value printNewline.
            metaData at:#GrayResponceCurve put:value.
            ^ self
        ].
        (tagType == 292) ifTrue:[
            "/ group3options
            "/      2DENCODING      -> 1
            "/      UNCOMPRESSED    -> 2
            "/      FILLBITS        -> 4

            group3options := value.
            "/ 'group3options ' print. group3options printNewline.
            ^ self
        ].
        (tagType == 293) ifTrue:[
            "/ group4options
            "/      UNCOMPRESSED    -> 2

            "group4options := value."
            "/ 'group4options ' print. value printNewline.
            ^ self
        ].
        (tagType == 296) ifTrue:[
            "resolutionunit"

    "/        (value == 1) ifTrue:[
    "/            'res-unit pixel' printNewline
    "/        ] ifFalse:[
    "/            (value == 2) ifTrue:[
    "/                'res-unit inch' printNewline
    "/            ] ifFalse:[
    "/                (value == 3) ifTrue:[
    "/                    'res-unit mm' printNewline
    "/                ] ifFalse:[
    "/                    'res-unit invalid' printNewline
    "/                ]
    "/            ]
    "/        ].
            metaData at:#ResolutionUnit put:value.
            ^ self
        ].
        (tagType == 297) ifTrue:[
            "pageNumber"
            "/ 'pageNumber ' print. value printNewline.
            metaData at:#PageNumber put:value.
            ^ self
        ].
    ].

    (tagType < 400) ifTrue:[
        (tagType == 300) ifTrue:[
            "colorResponceUnit"
            "/ 'colorResponceUnit' print. value printNewline.
            metaData at:#ColorResponceUnit put:value.
            ^ self
        ].
        (tagType == 301) ifTrue:[
            "colorResponceCurve"
            "/ 'colorResponceCurve' print. value printNewline.
            metaData at:#ColorResponceCurve put:value.
            ^ self
        ].
        (tagType == 305) ifTrue:[
            "software - info only"
            "/ 'software' print. value printNewline.
            metaData at:#Software put:value.
            ^ self
        ].
        (tagType == 306) ifTrue:[
            "dateTime - info only"
            "/ 'dateTime ' print. value printNewline.
            metaData at:#DateTime put:value.
            ^ self
        ].
        (tagType == 315) ifTrue:[
            "artist - info only"
            "/ 'artist ' print. value printNewline.
            metaData at:#Artist put:value.
            ^ self
        ].
        (tagType == 316) ifTrue:[
            "host computer - info only"
            "/ 'host ' print. value printNewline.
            metaData at:#HostComputer put:value.
            ^ self
        ].
        (tagType == 317) ifTrue:[
            "predictor"
            predictor := value.
            "/ 'predictor ' print. predictor printNewline.
            ^ self
        ].
        (tagType == 318) ifTrue:[
            "whitePoint"
            "/ 'whitePoint ' print. value printNewline.
            metaData at:#WhitePoint put:value.
            ^ self
        ].
        (tagType == 319) ifTrue:[
            "primaryChromatics"
            "/ 'primaryChromatics ' print. value printNewline.
            metaData at:#PrimaryChromatics put:value.
            ^ self
        ].
        (tagType == 320) ifTrue:[
            "ColorMap"

            "/ 'colorMap (size=' print. valueArray size print. ')' printNewline.

            "
             the tiff colormap contains 16bit values;
             our colormap expects 8bit values
            "
            n := valueArray size // 3.

            rV := ByteArray uninitializedNew:n.
            gV := ByteArray uninitializedNew:n.
            bV := ByteArray uninitializedNew:n.
            scaleFactor := 255.0 / 16rFFFF.
            i2 := n+1.
            i3 := 2*n+1.
            1 to:n do:[:vi |
                val := ((valueArray at:vi) * scaleFactor) rounded.
                rV at:vi put:val.
                val := ((valueArray at:i2) * scaleFactor) rounded.
                gV at:vi put:val.
                val := ((valueArray at:i3) * scaleFactor) rounded.
                bV at:vi put:val.
                i2 := i2 + 1.
                i3 := i3 + 1.
            ].
            colorMap := MappedPalette redVector:rV greenVector:gV blueVector:bV.
            ^ self
        ].
        (tagType == 321) ifTrue:[
            "halftonehints"
            "/ 'halftonehints' print. value printNewline.
            metaData at:#HalftoneHints put:value.
            ^ self
        ].
        (tagType == 322) ifTrue:[
            "tilewidth"
            "/ 'tilewidth' print. value printNewline.
            metaData at:#TileWidth put:value.
            ^ self
        ].
        (tagType == 323) ifTrue:[
            "tilelength"
            "/ 'tilelength' print. value printNewline.
            metaData at:#TileLength put:value.
            ^ self
        ].
        (tagType == 324) ifTrue:[
            "tileoffsets"
            "/ 'tileoffsets' print. value printNewline.
            metaData at:#TileOffsets put:value.
            ^ self
        ].
        (tagType == 325) ifTrue:[
            "tilebytecounts"
            "/ 'tilebytecounts' print. value printNewline.
            metaData at:#TileByteCounts put:value.
            ^ self
        ].
        (tagType == 326) ifTrue:[
            "BadFaxLines"
            "/ 'badFaxLines' print. value printNewline.
            ^ self
        ].
        (tagType == 327) ifTrue:[
            "CleanFaxData"

    "/        'cleanfaxdata' print. value printNewline.
    "/        (value == 0) ifTrue:[
    "/            'no lines with incorrect pixel counts' printNewline
    "/        ] ifFalse:[
    "/            (value == 1) ifTrue:[
    "/                'incorrect lines were regenerated' printNewline
    "/            ] ifFalse:[
    "/                (value == 2) ifTrue:[
    "/                    'incorrect lines were not regenerated' printNewline
    "/                ] ifFalse:[
    "/                    'cleanfaxdata invalid' printNewline
    "/                ]
    "/            ]
    "/        ].

            ^ self
        ].
        (tagType == 328) ifTrue:[
            "consecutiveBadFaxLines"

    "/        'consecutiveBadFaxLines' print. value printNewline.

            ^ self
        ].
        (tagType == 330) ifTrue:[
            "subifd"

    "/        'subifd' print. value printNewline.

            ^ self
        ].
        (tagType == 332) ifTrue:[
            "ink set"

    "/        'ink set' print. value printNewline.

            ^ self
        ].
        (tagType == 333) ifTrue:[
            "ink names"

            "/ 'ink names' print. value printNewline.
            metaData at:#IncNames put:value.
            ^ self
        ].
        (tagType == 336) ifTrue:[
            "dot range"

            "/ 'dot range' print. value printNewline.
            ^ self
        ].
        (tagType == 337) ifTrue:[
            "target printer"

            "/ 'target printer' print. value printNewline.
            ^ self
        ].
        (tagType == 338) ifTrue:[
            "extrasamples"

            "/ 'extrasamples' print. value printNewline.

            ^ self
        ].
        (tagType == 339) ifTrue:[
            "sample format"

            "/ 'sample format' print. value printNewline.

            ^ self
        ].
        (tagType == 340) ifTrue:[
            "min sample value"

    "/        'min sample value' print. value printNewline.

            ^ self
        ].
        (tagType == 341) ifTrue:[
            "max sample value"

    "/        'max sample value' print. value printNewline.

            ^ self
        ].
        (tagType == 347) ifTrue:[
            "jpegtables"

    "/        'jpegtables' print. value printNewline.

            ^ self
        ].
    ].

    (tagType < 600) ifTrue:[
        "/ obsolete JPEG tags
        (tagType == 512) ifTrue:[
            "jpeg proc"

    "/        'jpeg proc' print. value printNewline.

            ^ self
        ].
        (tagType == 513) ifTrue:[
            "jpeg proc"

    "/        'jpeg proc' print. value printNewline.

            ^ self
        ].
        (tagType == 514) ifTrue:[
            "jpeg ifByteCount"

    "/        'jpeg ifByteCount' print. value printNewline.

            ^ self
        ].
        (tagType == 515) ifTrue:[
            "jpeg restartInterval"

    "/        'jpeg restartInterval' print. value printNewline.

            ^ self
        ].
        (tagType == 517) ifTrue:[
            "jpeg glossLessPredictors"

    "/        'jpeg glossLessPredictors' print. value printNewline.

            ^ self
        ].
        (tagType == 518) ifTrue:[
            "jpeg pointTransform"

    "/        'jpeg pointTransform' print. value printNewline.

            ^ self
        ].
        (tagType == 519) ifTrue:[
            "jpeg qTables"

    "/        'jpeg qTables' print. value printNewline.

            ^ self
        ].
        (tagType == 520) ifTrue:[
            "jpeg dcTables"

    "/        'jpeg dcTables' print. value printNewline.

            ^ self
        ].
        (tagType == 521) ifTrue:[
            "jpeg acTables"

    "/        'jpeg acTables' print. value printNewline.

            ^ self
        ].


        (tagType == 529) ifTrue:[
            "ycbr coeff"

    "/        'ycbr coeff' print. value printNewline.

            ^ self
        ].
        (tagType == 530) ifTrue:[
            "ycbr subsampling"

    "/        'ycbr subsampling' print. value printNewline.

            ^ self
        ].
        (tagType == 531) ifTrue:[
            "ycbr positioning"

    "/        'ycbr positioning' print. value printNewline.

            ^ self
        ].
        (tagType == 532) ifTrue:[
            "referenceBlackWhite"

    "/        'ycbr positioning' print. value printNewline.

            ^ self
        ].
    ].

    (tagType > 32000) ifTrue:[

        "/ Private Island graphics tags
        (tagType == 32953) ifTrue:[
            "ref points"

    "/        'ref points' print. value printNewline.

            ^ self
        ].
        (tagType == 32954) ifTrue:[
            "regionTagPoint"

    "/        'regionTagPoint' print. value printNewline.

            ^ self
        ].
        (tagType == 32955) ifTrue:[
            "regionWarpCorners"

    "/        'regionWarpCorners' print. value printNewline.

            ^ self
        ].
        (tagType == 32956) ifTrue:[
            "regionAffine"

    "/        'regionAffine' print. value printNewline.

            ^ self
        ].


        "/ Private SGI tags

        (tagType == 32995) ifTrue:[
            "matteing"

    "/        'matteing' print. value printNewline.

            ^ self
        ].
        (tagType == 32996) ifTrue:[
            "datatype"

    "/        'datatype' print. value printNewline.

            ^ self
        ].
        (tagType == 32997) ifTrue:[
            "imagedepth"

    "/        'imagedepth' print. value printNewline.

            ^ self
        ].
        (tagType == 32998) ifTrue:[
            "tiledepth"

    "/        'tiledepth' print. value printNewline.

            ^ self
        ].

        "/ Private Pixar tags

        (tagType == 33300) ifTrue:[
            "image full width"

    "/        'image full width' print. value printNewline.

            ^ self
        ].
        (tagType == 33301) ifTrue:[
            "image full length"

    "/        'image full length' print. value printNewline.

            ^ self
        ].

        "/ Private Eastman Kodak tags

        (tagType == 33405) ifTrue:[
            "write serial number"

    "/        'write serial number' print. value printNewline.

            ^ self
        ].

        "/ unknown

        (tagType == 33432) ifTrue:[
            "copyright"

    "/        'copyright' print. value printNewline.

            ^ self
        ].

        "/ Private Texas instruments

        (tagType == 34232) ifTrue:[
            "sequence frame count"

    "/        'sequence frame count' print. value printNewline.

            ^ self
        ].

        "/ Private Pixel magic

        (tagType == 34232) ifTrue:[
            "jbig options"

    "/        'jbig options' print. value printNewline.

            ^ self
        ].

        "/ More Private SGI

        (tagType == 34908) ifTrue:[
            "fax recv params"

    "/        'fax recv params' print. value printNewline.

            ^ self
        ].
        (tagType == 34909) ifTrue:[
            "fax subaddress"

    "/        'fax subaddress' print. value printNewline.

            ^ self
        ].
        (tagType == 34910) ifTrue:[
            "fax recv time"

    "/        'fax recv time' print. value printNewline.

            ^ self
        ].
    ].

"/
"/ 'TIFFReader: tag:' print. tagType print. ' typ:' print. numberType print.
"/ ' len:' print. length print. ' offs:' print. offset print. 
"/ ' val:' print. value print. ' valArr:' print. valueArray printNewline.  
"/
    'TIFFReader [warning]: unknown tag type ' errorPrint. tagType errorPrintCR

    "Modified: 11.4.1997 / 01:11:17 / cg"
! !

!TIFFReader methodsFor:'private-data reading'!

readCCITT3RLETiffImageData
    ^ self fileFormatError:'ccitt G3 mod Huffman (rle) compression not implemented'

    "Modified: / 3.2.1998 / 18:03:14 / cg"
!

readCCITT3RLEWTiffImageData
    ^ self fileFormatError:'ccitt G3 mod Huffman (rlew) compression not implemented'.

    "Modified: / 3.2.1998 / 18:03:30 / cg"
!

readCCITTGroup3TiffImageData
    "not really tested - all I got is a single fax from NeXT step"

    |bytesPerRow bitsPerRow compressedStrip nPlanes 
     stripNr       "{ Class: SmallInteger }"
     offset        "{ Class: SmallInteger }"
     row           "{ Class: SmallInteger }"
     bytesPerStrip "{ Class: SmallInteger }" |

    nPlanes := samplesPerPixel.
    (nPlanes == 2) ifTrue:[
        'TIFFReader [info]: ignoring alpha plane' infoPrintCR.
        nPlanes := 1
    ].

    (nPlanes ~~ 1) ifTrue:[
        ^ self fileFormatError:'only monochrome/greyscale ccitt3supported'.
    ].

    stripByteCounts isNil ifTrue:[
        ^ self fileFormatError:'currently require stripByteCounts'.
    ].
    (rowsPerStrip ~~ 1) isNil ifTrue:[
        ^ self fileFormatError:'currently require rowsPerStrip to be 1'.
    ].

"/    'TIFFReader: decompressing CCITT-3 ...' infoPrintNL.

    bitsPerRow := width * (bitsPerSample at:1).
    bytesPerRow := bitsPerRow // 8.
    ((bitsPerRow \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].

    data := ByteArray new:(bytesPerRow * height).
    compressedStrip := ByteArray uninitializedNew:bytesPerRow.

    offset := 1.
    stripNr := 0.

    row := 1.
    bytesPerStrip := bytesPerRow * rowsPerStrip.
    [row <= height] whileTrue:[
        stripNr := stripNr + 1.
        self positionToStrip:stripNr.
        inStream nextBytes:(stripByteCounts at:stripNr) into:compressedStrip.
        self class decompressCCITT3From:compressedStrip
                                   into:data
                             startingAt:offset
                                  count:width.
        offset := offset + bytesPerStrip.
        row := row + rowsPerStrip
    ]

    "Modified: / 3.2.1998 / 18:04:21 / cg"
!

readCCITTGroup4TiffImageData
    ^ self fileFormatError:'ccitt group4 fax compression not implemented'.

    "Modified: / 3.2.1998 / 18:04:34 / cg"
!

readCCITTRLEWTiffImageData
    ^ self fileFormatError:'ccitt mod Huffman (rlew) compression not implemented'
!

readDCSTiffImageData
    ^ self fileFormatError:'dcs compression not implemented'.

    "Modified: / 3.2.1998 / 18:04:44 / cg"
!

readDeflateTiffImageData
    ^ self fileFormatError:'deflate compression not implemented'.

    "Modified: / 3.2.1998 / 18:04:54 / cg"
!

readJBIGTiffImageData
    ^ self fileFormatError:'jbig compression not implemented'.

    "Modified: / 3.2.1998 / 18:05:04 / cg"
!

readJPEGTiffImageData
    ^ self fileFormatError:'jpeg compression not implemented'.

    "Modified: / 3.2.1998 / 18:05:12 / cg"
!

readLZWTiffImageData
    "read LZW compressed tiff data; this method only
     handles 3x8 rgb and 1x2 or 2x2 greyscale images.
     For 2x2 greyscale images, the alpha plane is ignored.
     (maybe other formats work also - its simply not
      tested)"

    |bytesPerRow compressedStrip nPlanes overAllBytes
     bytesPerStrip "{ Class: SmallInteger }"
     nBytes        "{ Class: SmallInteger }"
     prevSize      "{ Class: SmallInteger }"
     stripNr       "{ Class: SmallInteger }"
     offset        "{ Class: SmallInteger }"
     row           "{ Class: SmallInteger }" |

    nPlanes := samplesPerPixel.

    (nPlanes == 3) ifTrue:[
        (((bitsPerSample at:1) ~~ 8) 
        or:[((bitsPerSample at:2) ~~ 8) 
        or:[((bitsPerSample at:3) ~~ 8)]]) ifTrue:[
            ^ self fileFormatError:'only 8/8/8 bit/sample are supported'.
        ].
        bytesPerRow := width * samplesPerPixel.
    ] ifFalse:[
        (nPlanes == 2) ifTrue:[
            (planarConfiguration ~~ 2) ifTrue:[
                ^ self fileFormatError:'only separate planes are supported'.
            ].
            'TIFFReader [info]: ignoring alpha plane' infoPrintCR.
            nPlanes := 1
        ].
        (nPlanes == 1) ifFalse:[
            ^ self fileFormatError:'unsupported nPlanes: ' , nPlanes printString, '; only 3-sample rgb / monochrome supported'.
        ].
        bytesPerRow := (width * (bitsPerSample at:1) + 7) // 8.
    ].

    stripByteCounts isNil ifTrue:[
        ^ self fileFormatError:'currently require stripByteCounts'.
    ].

"/    'TIFFReader: decompressing LZW ...' infoPrintNL.

    overAllBytes := bytesPerRow * height.
    bytesPerRow == width ifTrue:[
        data := ByteArray uninitializedNew:overAllBytes.
    ] ifFalse:[
        data := ByteArray new:overAllBytes.
    ].

    offset := 1.
    stripNr := 0.

    row := 1.
    bytesPerStrip := bytesPerRow * rowsPerStrip.
    prevSize := 0.
    [row <= height] whileTrue:[
        stripNr := stripNr + 1.
        self positionToStrip:stripNr.
        nBytes := stripByteCounts at:stripNr.
        (nBytes > prevSize) ifTrue:[
            compressedStrip := ByteArray uninitializedNew:nBytes.
            prevSize := nBytes
        ].
        inStream nextBytes:nBytes
                      into:compressedStrip.
        self class decompressLZWFrom:compressedStrip
                               count:nBytes
                                into:data
                          startingAt:offset.
        offset := offset + bytesPerStrip.
        row := row + rowsPerStrip
    ].

    (predictor == 2) ifTrue:[
        self class decodeDelta:3 in:data width:width height:height
    ]

    "Modified: / 12.8.1998 / 13:58:13 / cg"
!

readNeXTJPEGTiffImageData
    ^ self fileFormatError:'next jpeg compression not implemented'.

    "Modified: / 3.2.1998 / 18:10:45 / cg"
!

readNeXTRLE2TiffImageData
    ^ self fileFormatError:'next 2bit rle compression not implemented'.

    "Modified: / 3.2.1998 / 18:10:54 / cg"
!

readNewJPEGTiffImageData
    ^ self fileFormatError:'new jpeg compression not implemented'.
!

readPackbitsTiffImageData
    "this has only been tested with monochrome images"

    |bytesPerRow bitsPerRow nPlanes 
     stripNr       "{ Class: SmallInteger }"
     offset        "{ Class: SmallInteger }"
     row           "{ Class: SmallInteger }" 
     nBytes        "{ Class: SmallInteger }"
     nDecompressedBytes  "{ Class: SmallInteger }"
     bitsPerPixel overAllBytes buffer|

    nPlanes := samplesPerPixel.

    "only support 1-sample/pixel,
     with alpha - if separate planes,
     or rgb - if non separate planes and no alpha"

    (nPlanes == 2) ifTrue:[
        (planarConfiguration ~~ 2) ifTrue:[
            ^ self fileFormatError:'with alpha, only separate planes supported'.
        ].
        'TIFFReader [info]: ignoring alpha plane' infoPrintCR.
        nPlanes := 1.
        bitsPerPixel := bitsPerSample at:1.
        bitsPerSample := Array with:bitsPerPixel.
        samplesPerPixel := 1.
    ] ifFalse:[
        (nPlanes == 3) ifTrue:[
            (planarConfiguration ~~ 1) ifTrue:[
                ^ self fileFormatError:'only non separate planes supported'.
            ].
            bitsPerSample ~= #(8 8 8) ifTrue:[
                ^ self fileFormatError:'only 8/8/8 rgb images supported'.
            ].
            bitsPerPixel := 24
        ] ifFalse:[
            (nPlanes ~~ 1) ifTrue:[
                ^ self fileFormatError:'format not supported'.
            ].
            bitsPerPixel := bitsPerSample at:1.
        ]
    ].

    bitsPerRow := width * bitsPerPixel.
    bytesPerRow := bitsPerRow // 8.
    ((bitsPerRow \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].

    overAllBytes := bytesPerRow * height.
    bytesPerRow == width ifTrue:[
        data := ByteArray uninitializedNew:overAllBytes.
    ] ifFalse:[
        data := ByteArray new:overAllBytes.
    ].

    offset := 1.
    stripNr := 0.

    buffer := nil.
    row := 1.
    [row <= height] whileTrue:[
        stripNr := stripNr + 1.
        nBytes := stripByteCounts at:stripNr.
        self positionToStrip:stripNr.

        nBytes > buffer size ifTrue:[
            "/ realloc
            buffer := ByteArray uninitializedNew:nBytes.
        ].
        inStream nextBytes:nBytes into:buffer.

        nDecompressedBytes := self class decompressPackBits:nBytes from:buffer to:data startingAt:offset.

        offset := offset + nDecompressedBytes.
        row := row + rowsPerStrip
    ]

    "Modified: / 12.8.1998 / 13:57:34 / cg"
!

readPixarFilmTiffImageData
    ^ self fileFormatError:'pixar film compression not implemented'.

    "Modified: / 3.2.1998 / 18:11:45 / cg"
!

readPixarLogTiffImageData
    ^ self fileFormatError:'pixar log compression not implemented'.

    "Modified: / 3.2.1998 / 18:11:53 / cg"
!

readThunderScanTiffImageData
    ^ self fileFormatError:'thunderScan compression not implemented' .

    "Modified: / 3.2.1998 / 18:12:01 / cg"
!

readTiffImageData
    (compression == 1) ifTrue:[
        ^ self readUncompressedTiffImageData.
    ].
    (compression == 2) ifTrue:[
        ^ self readCCITT3RLETiffImageData.
    ].
    (compression == 3) ifTrue:[
        ^ self readCCITTGroup3TiffImageData.
    ]. 
    (compression == 4) ifTrue:[
        ^ self readCCITTGroup4TiffImageData.
    ]. 
    (compression == 5) ifTrue:[
        ^ self readLZWTiffImageData.
    ].
    (compression == 6) ifTrue:[
        ^ self readJPEGTiffImageData.
    ].
    (compression == 7) ifTrue:[
        ^ self readNewJPEGTiffImageData.
    ].

    (compression == 32766) ifTrue:[
        ^ self readNeXTRLE2TiffImageData.
    ].
    (compression == 32771) ifTrue:[
        ^ self readCCITTRLEWTiffImageData.
    ].
    (compression == 32773) ifTrue:[
        ^ self readPackbitsTiffImageData.
    ].
    (compression == 32809) ifTrue:[
        ^ self readThunderScanTiffImageData.
    ].
    (compression == 32908) ifTrue:[
        ^ self readPixarFilmTiffImageData.
    ].
    (compression == 32909) ifTrue:[
        ^ self readPixarLogTiffImageData.
    ].
    (compression == 32946) ifTrue:[
        ^ self readDeflateTiffImageData.
    ].
    (compression == 32947) ifTrue:[
        ^ self readDCSTiffImageData.
    ].
    (compression == 32865) ifTrue:[
        ^ self readNeXTJPEGTiffImageData.
    ].
    (compression == 34661) ifTrue:[
        ^ self readJBIGTiffImageData.
    ].

    ^ self fileFormatError:('compression type ' , compression printString , ' not known').

    "Created: / 11.4.1997 / 00:19:44 / cg"
    "Modified: / 3.2.1998 / 18:12:36 / cg"
!

readUncompressedTiffImageData
    |bytesPerRow   "{ Class: SmallInteger }"
     bitsPerRow    "{ Class: SmallInteger }"
     nPlanes 
     stripNr       "{ Class: SmallInteger }"
     offset        "{ Class: SmallInteger }"
     row           "{ Class: SmallInteger }" 
     nBytes        "{ Class: SmallInteger }"
     bitsPerPixel 
     overAllBytes  "{ Class: SmallInteger }"
     where         "{ Class: SmallInteger }"
     stripPos      |

    nPlanes := samplesPerPixel.

    "/ not all formats are supported here,

    (nPlanes == 2) ifTrue:[
        (planarConfiguration ~~ 2) ifTrue:[
            ^ self fileFormatError:'with alpha, only separate planes supported'.
        ].
        'TIFFReader [info]: ignoring alpha plane' infoPrintCR.
        nPlanes := 1.
        bitsPerPixel := bitsPerSample at:1.
        bitsPerSample := Array with:bitsPerPixel.
        samplesPerPixel := 1.
    ] ifFalse:[
        (nPlanes == 4) ifTrue:[
            (planarConfiguration ~~ 1) ifTrue:[
                ^ self fileFormatError:'only non separate planes supported'.
            ].
            bitsPerSample ~= #(8 8 8 8) ifTrue:[
                ^ self fileFormatError:'only 8/8/8/8 cmyk images supported'.
            ].
            bitsPerPixel := 32.
        ] ifFalse:[
            (nPlanes == 3) ifTrue:[
                (planarConfiguration ~~ 1) ifTrue:[
                    ^ self fileFormatError:'only non separate planes supported'.
                ].
                bitsPerSample ~= #(8 8 8) ifTrue:[
                    ^ self fileFormatError:'only 8/8/8 rgb images supported (is: ' , bitsPerSample printString , ')'.
                ].
                bitsPerPixel := 24
            ] ifFalse:[
                (nPlanes ~~ 1) ifTrue:[
                    ^ self fileFormatError:('unsupported format: nplanes=' , nPlanes printString).
                ].
                bitsPerPixel := bitsPerSample at:1.
            ]
        ]
    ].

    bitsPerRow := width * bitsPerPixel.
    bytesPerRow := bitsPerRow // 8.
    ((bitsPerRow \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].

    overAllBytes := bytesPerRow * height.
    bytesPerRow == width ifTrue:[
        data := ByteArray uninitializedNew:overAllBytes.
    ] ifFalse:[
        data := ByteArray new:overAllBytes.
    ].

    offset := 0.
    stripNr := 0.
    where := -1.
    row := 1.
    [row <= height] whileTrue:[
        stripNr := stripNr + 1.
        nBytes := stripByteCounts at:stripNr.
        stripPos := stripOffsets at:stripNr.
        where ~~ stripPos ifTrue:[
            inStream position:stripPos.
            where := stripPos.
        ].
        
        offset + nBytes > overAllBytes ifTrue:[
            nBytes := overAllBytes - offset.
        ].

        "/ read it 4k-wise; this leads to a better behavior,
        "/ when reading big images from a slow device (such as a cdrom)
        inStream nextBytes:nBytes into:data startingAt:offset+1 blockSize:4096.

        offset := offset + nBytes.
        row := row + rowsPerStrip.
        where := where + nBytes.
    ].

    "Modified: / 12.8.1998 / 13:57:14 / cg"
! !

!TIFFReader methodsFor:'private-reading'!

positionToStrip:stripNr
    inStream position:(stripOffsets at:stripNr).
!

readBytes:n signed:isSigned
    "read n 8bit signed or unsigned integers and return them in an array or byteArray"

    |oldPos offset bytes|

    n == 0 ifTrue:[^ ''].

    bytes := (isSigned ifTrue:[Array] ifFalse:[ByteArray]) new:n.
    (n <= 4) ifTrue:[
        isSigned ifTrue:[
            1 to:n do:[:i | bytes at:i put:(inStream nextSignedByte) ].
        ] ifFalse:[
            inStream nextBytes:n into:bytes.
        ].
        (n < 4) ifTrue:[
            inStream skip:(4 - n).
        ]
    ] ifFalse:[
        offset := inStream nextInt32MSB:(byteOrder ~~ #lsb).
        oldPos := inStream position.
        inStream position:offset.
        isSigned ifTrue:[
            1 to:n do:[:i | bytes at:i put:(inStream nextSignedByte) ].
        ] ifFalse:[
            inStream nextBytes:n into:bytes.
        ].
        inStream position:oldPos
    ].
    ^ bytes
!

readChars:n
    "read n characters and return them in a string"

    |oldPos offset string|

    n == 0 ifTrue:[^ ''].

    string := String new:(n - 1).
    (n <= 4) ifTrue:[
        inStream nextBytes:(n - 1) into:string.
        (n < 4) ifTrue:[
            inStream skip:(4 - n).
        ]
    ] ifFalse:[
        offset := inStream nextInt32MSB:(byteOrder ~~ #lsb).
        oldPos := inStream position.
        inStream position:offset.
        inStream nextBytes:(n - 1) into:string.
        inStream position:oldPos
    ].
    ^ string

    "Modified: 5.9.1996 / 12:21:08 / cg"
!

readDoubles:nFloats
    "read nFloats IEEE 64bit doubles and return them in an array"

    |oldPos offset values val msb 
     n "{ Class: SmallInteger }" |

    n := nFloats.

    msb := byteOrder ~~ #lsb.
    values := DoubleArray basicNew:n.
    (n == 1) ifTrue:[
        val := Float readBinaryIEEEDoubleFrom:inStream MSB:msb.
        values at:1 put:val.
    ] ifFalse:[
        offset := inStream nextInt32MSB:msb.
        oldPos := inStream position.
        inStream position:offset.
        1 to:n do:[:index |
            val := Float readBinaryIEEEDoubleFrom:inStream MSB:msb.
            values at:index put:val
        ].
        inStream position:oldPos
    ].
    ^ values
!

readFloats:nFloats
    "read nFloats IEEE 32bit floats and return them in an array"

    |oldPos offset values val msb 
     n "{ Class: SmallInteger }" |

    n := nFloats.

    msb := byteOrder ~~ #lsb.
    values := FloatArray basicNew:n.
    (n == 1) ifTrue:[
        val := ShortFloat readBinaryIEEESingleFrom:inStream MSB:msb.
        values at:1 put:val.
    ] ifFalse:[
        offset := inStream nextInt32MSB:msb.
        oldPos := inStream position.
        inStream position:offset.
        1 to:n do:[:index |
            val := ShortFloat readBinaryIEEESingleFrom:inStream MSB:msb.
            values at:index put:val
        ].
        inStream position:oldPos
    ].
    ^ values
!

readFracts:nFracts signed:isSigned
    "read nFracts fractions (2 32bit words) and return them in an array"

    |oldPos offset values numerator denominator msb
     n "{ Class: SmallInteger }" |

    n := nFracts.

    msb := byteOrder ~~ #lsb.
    values := Array basicNew:n.
    offset := inStream nextInt32MSB:msb.
    oldPos := inStream position.
    inStream position:offset.
    1 to:n do:[:index |
        numerator := isSigned ifTrue:[inStream nextInt32MSB:msb] ifFalse:[inStream nextUnsignedInt32MSB:msb].
        denominator := isSigned ifTrue:[inStream nextInt32MSB:msb] ifFalse:[inStream nextUnsignedInt32MSB:msb].
        values at:index put:(Fraction numerator:numerator denominator:denominator)
    ].
    inStream position:oldPos.
    ^ values
!

readLongs:nLongs signed:isSigned
    "read nLongs signed or unsigned long numbers (32bit) and return them in an array"

    |oldPos offset values val msb 
     n "{ Class: SmallInteger }" |

    n := nLongs.

    msb := byteOrder ~~ #lsb.
    values := Array basicNew:n.
    (n == 1) ifTrue:[
        val := isSigned ifTrue:[inStream nextInt32MSB:msb] ifFalse:[inStream nextUnsignedInt32MSB:msb].
        values at:1 put:val.
    ] ifFalse:[
        offset := inStream nextInt32MSB:msb.
        oldPos := inStream position.
        inStream position:offset.
        1 to:n do:[:index |
            val := isSigned ifTrue:[inStream nextInt32MSB:msb] ifFalse:[inStream nextUnsignedInt32MSB:msb].
            values at:index put:val
        ].
        inStream position:oldPos
    ].
    ^ values
!

readShorts:nShorts signed:isSigned
    "read nShorts signed or unsigned short numbers (16bit) and return them in an array"

    |oldPos offset values msb val1 val2
     n "{ Class: SmallInteger }" |

    n := nShorts.

    msb := (byteOrder ~~ #lsb).
    values := Array basicNew:n.
    (n <= 2) ifTrue:[
        isSigned ifTrue:[
            val1 := inStream nextInt16MSB:msb.
            val2 := inStream nextInt16MSB:msb.
        ] ifFalse:[
            val1 := inStream nextUnsignedInt16MSB:msb.
            val2 := inStream nextUnsignedInt16MSB:msb.
        ].
        values at:1 put:val1.
        (n == 2) ifTrue:[
            values at:2 put:val2
        ]
    ] ifFalse:[
        offset := inStream nextInt32MSB:msb.
        oldPos := inStream position.
        inStream position:offset.
        1 to:n do:[:index |
            isSigned ifTrue:[
                val1 := inStream nextInt16MSB:msb.
            ] ifFalse:[
                val1 := inStream nextUnsignedInt16MSB:msb.
            ].
            values at:index put:val1
        ].
        inStream position:oldPos
    ].
    ^ values
! !

!TIFFReader methodsFor:'private-writing'!

writeBitsPerSample
"
'bitsPerSample: ' print. bitsPerSample printNewline.
'store bitspersample at: ' print. outStream position printNewline.
"
    bitsPerSamplePos := outStream position.
    bitsPerSample do:[:n |
        self writeShort:n
    ]
!

writeColorMap
    |n|

    colorMapPos := outStream position.
    #(red green blue) do:[:component |
        n := 0.
        colorMap do:[:clr |
            |entry|

            clr isNil ifTrue:[
                entry := 0
            ] ifFalse:[
                entry := clr perform:component.
                "
                 tiff map is 16 bit - scale from percent to 0..16rFFFF
                "
                entry := (entry * 16rFFFF / 100) rounded.
            ].
            self writeShort:entry.
            n := n + 1
        ].

        "
         fill to 256 entries
        "
        [n < 256] whileTrue:[
            self writeShort:0.
            n := n + 1.
        ]
    ]

    "Modified: 20.2.1997 / 18:06:10 / cg"
!

writeStripByteCounts
"
'stripByteCounts: ' print. stripByteCounts printNewline.
'store stripbytecounts at: ' print. outStream position printNewline.
"
    stripByteCountsPos := outStream position.
    stripByteCounts do:[:c |
        self writeShort:c
    ]
!

writeStripOffsets
"
'stripOffsets: ' print. stripOffsets printNewline.
'store stripoffsets at: ' print. outStream position printNewline.
"
    stripOffsetsPos := outStream position.
    stripOffsets do:[:o |
        self writeLong:o
    ]
!

writeTag:tagType
    self writeTiffTag:tagType.
!

writeTiffTag:tagType
    |value valueArray numberType count address|

    count := 1.
    address := nil.
    (tagType == 253) ifTrue:[
        "tiff class"
    ].
    (tagType == 254) ifTrue:[
    ].
    (tagType == 255) ifTrue:[
        "SubfileType"
        value := subFileType.
        numberType := #long.
    ].
    (tagType == 256) ifTrue:[
        "ImageWidth"
        value := width.
        numberType := #short.
    ].
    (tagType == 257) ifTrue:[
        "ImageHeight"
        value := height.
        numberType := #short.
    ].
    (tagType == 258) ifTrue:[
        "bitspersample"
        address := bitsPerSamplePos.
        numberType := #short.
        count := bitsPerSample size.
        valueArray := bitsPerSample
    ].
    (tagType == 259) ifTrue:[
        "compression"
        value := compression.
        numberType := #short.
    ].
    (tagType == 262) ifTrue:[
        "photometric"
        (photometric == #whiteIs0) ifTrue:[
            value := 0
        ] ifFalse:[
            (photometric == #blackIs0) ifTrue:[
                value := 1
            ] ifFalse:[
                (photometric == #rgb) ifTrue:[
                    value := 2
                ] ifFalse:[
                    (photometric == #palette) ifTrue:[
                        value := 3
                    ] ifFalse:[
                        (photometric == #transparency) ifTrue:[
                            value := 4
                        ] ifFalse:[
                            self error:'bad photometric' mayProceed:true.
                        ]
                    ]
                ]
            ]
        ].
        numberType := #short.
    ].
    (tagType == 263) ifTrue:[
    ].
    (tagType == 264) ifTrue:[
    ].
    (tagType == 265) ifTrue:[
    ].
    (tagType == 266) ifTrue:[
        "fillOrder"
        (fillOrder == #msb) ifTrue:[
            value := 1
        ] ifFalse:[
            (fillOrder == #lsb) ifTrue:[
                value := 2
            ] ifFalse:[
                self error:'bad fillOrder' mayProceed:true
            ]
        ].
        numberType := #short.
    ].
    (tagType == 269) ifTrue:[
    ].
    (tagType == 270) ifTrue:[
    ].
    (tagType == 271) ifTrue:[
    ].
    (tagType == 272) ifTrue:[
    ].
    (tagType == 273) ifTrue:[
        "stripoffsets"
        address := stripOffsetsPos.
        numberType := #long.
        count := stripOffsets size.
        valueArray := stripOffsets
    ].
    (tagType == 274) ifTrue:[
    ].
    (tagType == 277) ifTrue:[
        "samplesPerPixel"
        value := samplesPerPixel.
        numberType := #short.
    ].
    (tagType == 278) ifTrue:[
        "rowsperstrip"
        value := rowsPerStrip.
        numberType := #short.
    ].
    (tagType == 279) ifTrue:[
        "stripbytecount"
        address := stripByteCountsPos.
        numberType := #short.
        count := stripByteCounts size.
        valueArray := stripByteCounts
    ].
    (tagType == 280) ifTrue:[
        "min sample value"
    ].
    (tagType == 281) ifTrue:[
        "max sample value"
    ].
    (tagType == 282) ifTrue:[
        "x resolution"
    ].
    (tagType == 283) ifTrue:[
        "y resolution"
    ].
    (tagType == 284) ifTrue:[
        "planarconfig"
        value := planarConfiguration.
        numberType := #short.
    ].
    (tagType == 285) ifTrue:[
        "pageName"
    ].
    (tagType == 286) ifTrue:[
        "xPosition"
    ].
    (tagType == 287) ifTrue:[
        "yPosition"
    ].
    (tagType == 288) ifTrue:[
        "freeOffsets"
    ].
    (tagType == 289) ifTrue:[
        "freeByteCounts"
    ].
    (tagType == 290) ifTrue:[
        "grayResponceUnit"
    ].
    (tagType == 291) ifTrue:[
        "grayResponceCurve"
    ].
    (tagType == 292) ifTrue:[
        "group3options"
        value := group3options.
        numberType := #long.
    ].
    (tagType == 293) ifTrue:[
        "group4options"
    ].
    (tagType == 296) ifTrue:[
        "resolutionunit"
        ^ self
    ].
    (tagType == 297) ifTrue:[
        "pageNumber"
    ].
    (tagType == 300) ifTrue:[
        "colorResponceUnit"
    ].
    (tagType == 301) ifTrue:[
        "colorResponceCurve"
    ].
    (tagType == 306) ifTrue:[
        "dateTime"
    ].
    (tagType == 315) ifTrue:[
        "artist"
    ].
    (tagType == 317) ifTrue:[
        "predictor"
    ].
    (tagType == 320) ifTrue:[
        "colormap"
        address := colorMapPos.
        numberType := #short.
        count := 256 "(colorMap at:1) size" * 3.
    ].

    (value isNil and:[address isNil]) ifTrue:[
        self error:'unhandled tag' mayProceed:true.
        ^ self
    ].

"
'tag:' print. tagType print. ' typ:' print. numberType print.
' len:' print. count print.
' val:' print. value printNewline.  
"

    self writeShort:tagType.
    numberType == #short ifTrue:[
        self writeShort:3.
        self writeLong:count.
    ] ifFalse:[
        numberType == #long ifTrue:[
            self writeShort:4.
            self writeLong:count.
        ] ifFalse:[
            numberType == #byte ifTrue:[
                self writeShort:1.
                self writeLong:count.
            ] ifFalse:[
                self error:'bad numbertype'
            ]
        ]
    ].
    address notNil ifTrue:[
        (numberType == #long and:[count == 1]) ifTrue:[
            self writeLong:(valueArray at:1).
            ^ self
        ].
        (numberType == #short and:[count <= 2]) ifTrue:[
            self writeShort:(valueArray at:1).
            count == 2 ifTrue:[
                self writeShort:(valueArray at:2).
            ] ifFalse:[
                self writeShort:0
            ].
            ^ self
        ].
        (numberType == #byte and:[count <= 4]) ifTrue:[
            outStream nextPut:(valueArray at:1).
            count > 1 ifTrue:[
                outStream nextPut:(valueArray at:2).
                count > 2 ifTrue:[
                    outStream nextPut:(valueArray at:3).
                    count > 3 ifTrue:[
                        outStream nextPut:(valueArray at:4).
                    ] ifFalse:[
                        outStream nextPut:0
                    ].
                ] ifFalse:[
                    outStream nextPut:0
                ].
            ] ifFalse:[
                outStream nextPut:0
            ].
            ^ self
        ].
        self writeLong:address.
        ^ self
    ].
    numberType == #short ifTrue:[
        self writeShort:value.
        self writeShort:0
    ] ifFalse:[
        numberType == #long ifTrue:[
            self writeLong:value
        ] ifFalse:[
            numberType == #byte ifTrue:[
                outStream nextPut:value.
                outStream nextPut:0.
                outStream nextPut:0.
                outStream nextPut:0.
            ] ifFalse:[
                self error:'bad numbertype'
            ]
        ]
    ].
!

writeUncompressedBits
    "write bits as one or multiple strips"

    |offs bytesPerRow nBytes
     h "{ Class: SmallInteger }"|

    nBytes := data size.
    nBytes < 16rFFFF ifTrue:[
        stripOffsets := Array with:(outStream position).
        stripByteCounts := Array with:nBytes.
        outStream nextPutBytes:nBytes from:data.
        rowsPerStrip := height
    ] ifFalse:[
        stripOffsets := Array basicNew:height.
        bytesPerRow := nBytes // height.
        stripByteCounts := (Array basicNew:height) atAllPut:bytesPerRow.

        offs := 1.
        h := height.
        1 to:h do:[:row |
            stripOffsets at:row put:(outStream position).
            outStream nextPutBytes:bytesPerRow from:data startingAt:offs.
            offs := offs + bytesPerRow
        ].
        rowsPerStrip := 1
    ].
"
    'stripOffsets: ' print. stripOffsets printNewline.
    'stripByteCounts: ' print. stripByteCounts printNewline.
"
! !

!TIFFReader methodsFor:'reading'!

fromStream:aStream
    "read a stream containing a TIFF image.
     Leave image description in instance variables."

    |char1 char2 version 
     numberOfTags "{ Class: SmallInteger }"
     tagType      "{ Class: SmallInteger }"
     numberType   "{ Class: SmallInteger }"
     length       "{ Class: SmallInteger }"
     result offset msb
     bytesPerRow offset1 offset2 tmp|

    inStream := aStream.
    aStream binary.

    char1 := aStream next.
    char2 := aStream next.
    (char1 ~~ char2) ifTrue:[
        ^ self fileFormatError:'not a tiff file'.
    ].
    (char1 == $I codePoint) ifTrue:[
        byteOrder := #lsb.
        msb := false.
    ] ifFalse:[
        (char1 == $M codePoint) ifTrue:[
            byteOrder := #msb.
            msb := true.
        ] ifFalse:[
            ^ self fileFormatError:'not a tiff file'.
        ]
    ].

    version := self readShort.
    (version ~~ 42) ifTrue:[
        ^ self fileFormatError:'version of tiff-file not supported'.
    ].

    "setup default values"
    metaData := TIFFMetaData new.
    
    compression := 1. "none"
    fillOrder := #msb.
    planarConfiguration := 1.
    photometric := nil.
    bitsPerSample := 1.
    samplesPerPixel := 1.
    width := nil.
    height := nil.
    stripOffsets := nil.
    rowsPerStrip := nil.
    "resolutionUnit := 2."
    predictor := 1.
    orientation := nil.

    offset := aStream nextInt32MSB:msb.
    aStream position:offset.

    numberOfTags := self readShort.
    1 to:numberOfTags do:[:index |
        tagType := self readShort.
        numberType := self readShort.
        length := aStream nextInt32MSB:msb.
        self decodeTiffTag:tagType numberType:numberType length:length
    ].

    offset := aStream nextInt32MSB:msb.
    (offset ~~ 0) ifTrue:[
        'TIFFReader [info]: more tags ignored' infoPrintCR
    ].

    "check for required tags"
    width isNil ifTrue:[
        ^ self fileFormatError:'missing width tag'.
    ].

    height isNil ifTrue:[
        ^ self fileFormatError:'missing length tag'.
    ].

    photometric isNil ifTrue:[
        ^ self fileFormatError:'missing photometric tag'.
    ].

    stripOffsets isNil ifTrue:[
        ^ self fileFormatError:'missing stripOffsets tag'.
    ].

    stripByteCounts isNil ifTrue:[
        stripOffsets size == 1 ifTrue:[
            stripByteCounts := Array with:(self bitsPerPixel // 8) * width * height
        ]
    ].

    stripByteCounts isNil ifTrue:[
        ^ self fileFormatError:'missing stripByteCounts tag'.
    ].

    self reportDimension.

    "given all the information, read the bits"

    rowsPerStrip isNil ifTrue:[
        rowsPerStrip := height
    ].

    result := self readTiffImageData.
    result isNil ifTrue:[
        "/ unsupported format.
        ^ nil
    ].

    orientation == #vFlip ifTrue:[
        "/ reverse rows to top-to bottom

        bytesPerRow := self bytesPerRow.
        tmp := ByteArray new:bytesPerRow.
        offset1 := 1.
        offset2 := (height-1)*bytesPerRow + 1.
        0 to:((height-1)//2) do:[:row |
            tmp replaceFrom:1 to:bytesPerRow
                with:data startingAt:offset1.
            data replaceFrom:offset1 to:offset1+bytesPerRow-1
                 with:data startingAt:offset2.
            data replaceFrom:offset2 to:offset2+bytesPerRow-1
                 with:tmp startingAt:1.
            offset1 := offset1 + bytesPerRow.
            offset2 := offset2 - bytesPerRow.
        ].
    ].
    orientation == #unsupported ifTrue:[
        'TIFFReader [warning]: unsupported orientation' errorPrintCR
    ].

    ^ result

    "Modified: / 3.2.1998 / 18:02:29 / cg"
! !

!TIFFReader methodsFor:'writing'!

save:image onStream:aStream
    "save image as (uncompressed) TIFF file on aFileName"

    |pos1 pos indicator|

    image mask notNil ifTrue:[
        Image informationLostQuerySignal
            raiseWith:image
            errorString:('TIFF writer does not (yet) support an imageMask').
    ].

    outStream := aStream.
    outStream binary.

    "save as msb"

    byteOrder := #msb.
"
    byteOrder := #lsb.
"
    fillOrder := #msb.
    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.

    colorMap := image colorMap.
    planarConfiguration := 1.
    compression := 1.   "none"
    data := image bits.

    currentOffset := 0.

    (byteOrder == #msb) ifTrue:[
        indicator := $M codePoint.
    ] ifFalse:[
        indicator := $I codePoint.
    ].
    outStream nextPut:indicator; nextPut:indicator.
    currentOffset := currentOffset + 2.

    self writeShort:42.
    currentOffset := currentOffset + 2.

    pos1 := outStream position.
    self writeLong:0.           "start of tags - filled in later"
    currentOffset := currentOffset + 4.

    "output strips"

    self writeUncompressedBits. "this outputs bits as strips, sets stripOffsets and stripByteCounts"
    self writeStripOffsets.     "this outputs strip offsets, sets stripOffsetsPos"
    self writeStripByteCounts.  "this outputs strip bytecounts, sets stripByteCountPos"
    self writeBitsPerSample.    "this outputs bitsPerSample, sets bitsPerSamplePos"
    photometric == #palette ifTrue:[
        self writeColorMap      "this outputs colorMap, sets colorMapPos"
    ].

    pos := outStream position.        "backpatch tag offset"
    outStream position:pos1.
    self writeLong:pos.                     "fill in tag offset"
    outStream position:pos.
"
('patch tag offset at: ', (pos1 printStringRadix:16) , ' to ',
                         (pos printStringRadix:16)) printNewline.
"
    "output tag data"

    photometric == #palette ifTrue:[
        self writeShort:11.  "11 tags"
    ] ifFalse:[
        self writeShort:10.  "10 tags"
    ].
    self writeTag:256.               "image width"
    self writeTag:257.               "image height"
    self writeTag:258.               "bits per sample"
    self writeTag:259.               "compression"
    self writeTag:262.               "photometric"
    self writeTag:273.               "strip offsets"
    self writeTag:277.               "samplesPerPixel"
    self writeTag:278.               "rowsPerStrip"
    self writeTag:279.               "strip byte counts"
    self writeTag:284.               "planarconfig"
    photometric == #palette ifTrue:[
        self writeTag:320            "colorMap"
    ].
    self writeLong:0.                "end of tags mark"
! !

!TIFFReader class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


TIFFReader initialize!

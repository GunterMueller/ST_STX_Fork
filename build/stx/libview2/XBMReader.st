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

ImageReader subclass:#XBMReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!XBMReader class methodsFor:'documentation'!

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
    this class provides methods for loading and saving x-bitmap-file images.
    These images can (for example) be created using the bitmap editor supplied
    with X. 
    Only monochrome images can be represented in this format.
    Both reading and writing of images is supported.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XPMReader XWDReader 

    [author:]
        Claus Gittinger
"
!

examples
"
  Reading from a file:
                                                                        [exBegin]
    |image|

    image := Image fromFile:('../../goodies/bitmaps/xbmBitmaps/TicTacToe.xbm').
    image inspect
                                                                        [exEnd]


  Saving to a file:
                                                                        [exBegin]
    |image|

    image := Image fromScreen:(0@0 corner:30@30).
    image := image asThresholdMonochromeImage.
    XBMReader save:image onFile:'/tmp/test.xbm'.
    '/tmp/test.xbm' asFilename contents asString inspect.
    (Image fromFile:('/tmp/test.xbm')) inspect.
                                                                        [exEnd]


  Or directly into a stream:
                                                                        [exBegin]
    |image stream|

    image := Image fromScreen:(0@0 corner:30@30).
    image := image asThresholdMonochromeImage.
    stream := WriteStream on:(String new).
    XPMReader save:image onStream:stream.
    stream contents inspect.
                                                                        [exEnd]
"
! !

!XBMReader class methodsFor:'initialization'!

initialize
    "tell Image-class, that a new fileReader is present
     for the '.xbm' extension."

    MIMETypes defineImageType:'image/x-xbitmap' suffix:'xbm' reader:self.
    MIMETypes defineImageType:nil               suffix:'bm'  reader:self.

    "Modified: 1.2.1997 / 15:08:18 / cg"
! !

!XBMReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format"

    |photometric clr0 clr1|

    (anImage depth == 1) ifTrue:[
        photometric := anImage photometric.
        ((photometric == #blackIs0) or:[photometric == #whiteIs0]) ifTrue:[^ true].

        photometric == #palette ifTrue:[
            clr0 := anImage colorFromValue:0.
            clr1 := anImage colorFromValue:1.
            (clr0 = Color white and:[clr1 = Color black]) ifTrue:[^true].
            (clr1 = Color white and:[clr0 = Color black]) ifTrue:[^true].
        ].
    ].
    ('XBMReader [info]: image depth is not 1 (only b&w images).') infoPrintCR.
    ^ false

    "Modified: / 17.8.1998 / 10:17:01 / cg"
!

isValidImageFile:aFileName
    "return true, if aFileName contains an x-bitmap-file image"

    |line inStream index1 index2 keyword|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    Stream readErrorSignal handle:[:ex |
        line := nil.
    ] do:[
        Stream lineTooLongErrorSignal handle:[:ex |
            line := nil.
            Transcript showCR:'XBMReader [info]: long line'.
            ex return.
        ] do:[
            line := inStream nextLine.
        ].
        [line notNil and:[line isEmpty]] whileTrue:[
            line := inStream nextLine.
        ].
    ].
    line isNil ifTrue:[
        inStream close.
        ^ false
    ].
    [line startsWith:'#'] whileFalse:[
        Stream readErrorSignal handle:[:ex |
            line := nil.
        ] do:[
            Stream lineTooLongErrorSignal handle:[:ex |
                line := nil.
                Transcript showCR:'long line'.
                ex return.
            ] do:[
                line := inStream nextLine.
            ].
            [line notNil and:[line isEmpty]] whileTrue:[
                line := inStream nextLine.
            ].
        ].
        line isNil ifTrue:[
            inStream close.
            ^ false
        ]
    ].
    index1 := line indexOf:(Character space).
    index2 := line indexOf:(Character space) startingAt:(index1 + 1).
    (index2 == 0) ifTrue:[
        inStream close.
        ^ false
    ].
    keyword := line copyFrom:index1 to:(index2 - 1).
    (keyword endsWith:'_width') ifFalse:[
        inStream close.
        ^ false
    ].
    inStream close.
    ^ true

    "Modified: / 18.3.1999 / 11:33:39 / cg"
! !

!XBMReader methodsFor:'private-reading'!

extractValueFor:keyword fromLine:lineString
    |index1 index2 value restString|

    index1 := lineString indexOf:(Character space).
    index2 := lineString indexOf:(Character space) startingAt:(index1 + 1).
    (index2 == 0) ifTrue:[
        ^ nil.
    ].
    ((lineString copyTo:index2 - 1) endsWith:keyword) ifFalse:[
        ^ nil.
    ].
    restString := lineString copyFrom:(index2 + 1).
    value := Number readFromString:restString onError:nil.
    value isNil ifTrue:[
        ^ nil.
    ].
    ^ value
! !

!XBMReader methodsFor:'reading'!

fromStream:aStream
    "read an image in xbm format from aStream"

    |lineString 
     index    "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     bytesPerRow
     lo       "{ Class: SmallInteger }"
     hi       "{ Class: SmallInteger }"
     val      "{ Class: SmallInteger }"
     reverseBits|

    inStream := aStream.

    lineString := aStream nextLine.
    lineString isNil ifTrue:[
        ^ self fileFormatError:'short file'.
    ].

    [lineString startsWith:'#'] whileFalse:[
        lineString := aStream nextLine.
        lineString isNil ifTrue:[
            ^ self fileFormatError:'short file'.
        ].
    ].

    (lineString startsWith:'#define') ifFalse:[
        ^ self fileFormatError:'format error (expected #define)'.
    ].

    width := self extractValueFor:'width' fromLine:lineString.
    width isNil ifTrue:[
        ^ self fileFormatError:'format error (expected width)'.
    ].

    lineString := aStream nextLine.
    [lineString notNil and:[lineString isEmpty]] whileTrue:[
        lineString := aStream nextLine.   
    ].
    height := self extractValueFor:'height' fromLine:lineString.
    height isNil ifTrue:[
        ^ self fileFormatError:'format error (expected height)'.
    ].

    self reportDimension.

    bytesPerRow := width // 8.
    ((width \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].

    reverseBits := self class reverseBits.

    data := ByteArray new:(bytesPerRow * height).
    dstIndex := 1.

    lineString := aStream nextLine.
    [(lineString startsWith:'#')
     or:[lineString isEmpty]] whileTrue:[
        lineString := aStream nextLine.
    ].

    [lineString notNil and:[(lineString startsWith:'static') not]] whileTrue:[
        lineString := aStream nextLine.
    ].
    lineString := aStream nextLine.
    [lineString notNil and:[lineString isEmpty]] whileTrue:[
        lineString := aStream nextLine.
    ].

    [lineString notNil] whileTrue:[
        dstIndex <= data size ifTrue:[
            index := 1.
            [index ~~ 0] whileTrue:[
                dstIndex <= data size ifTrue:[
                    index := lineString indexOf:$x startingAt:index.
                    (index ~~ 0) ifTrue:[
                        index := index + 1.
                        hi := (lineString at:index) digitValue.
                        index := index + 1.
                        lo := (lineString at:index) digitValue.
                        val := (hi bitShift:4) bitOr:lo.
                        data at:dstIndex put:(reverseBits at:(val + 1)).
                        dstIndex := dstIndex + 1
                    ]
                ] ifFalse:[
                    index := 0. "/ break loop
                ] 
            ].
        ].
        lineString := aStream nextLine.
        [lineString notNil and:[lineString isEmpty]] whileTrue:[
            lineString := aStream nextLine.
        ].

    ].
    photometric := #whiteIs0.
    samplesPerPixel := 1.
    bitsPerSample := #(1).

    "
     XBMReader fromFile:'bitmaps/globe1.xbm'
    "

    "Modified: / 18.3.1999 / 11:32:46 / cg"
! !

!XBMReader methodsFor:'writing'!

save:image onStream:aStream
    "save image as XBM cdata on aStream.
     Only depth1 b&w images can be represented in this format."

    |reverseBits bits byte
     h        "{ Class: SmallInteger }"
     srcIndex "{ Class: SmallInteger }"
     rowBytes "{ Class: SmallInteger }" |

    (self class canRepresent:image) ifFalse:[
        ^ Image cannotRepresentImageSignal 
            raiseWith:image
            errorString:('XBM format only supports monochrome images').
    ].

    image mask notNil ifTrue:[
        Image informationLostQuerySignal
            raiseWith:image
            errorString:('XBM format does not support an imageMask').
    ].

    outStream := aStream.

    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.
    colorMap := image colorMap.

    outStream nextPutAll: '#define xbm_width '.
    outStream nextPutAll:(width printString).
    outStream cr.
    outStream nextPutAll: '#define xbm_height '.
    outStream nextPutAll:(height printString).
    outStream cr.
    outStream nextPutAll: 'static char xbm_bits[] = {'; cr.

    reverseBits := self class reverseBits.

    rowBytes := width + 7 // 8.
    data := image bits.
    srcIndex := 1.

    h := height.
    h timesRepeat:[
        rowBytes timesRepeat:[
            outStream nextPutAll: '0x'.
            bits := data at:srcIndex. srcIndex := srcIndex + 1.
            photometric == #blackIs0 ifTrue:[
                bits := bits bitInvert bitAnd:16rFF
            ].
            byte := (reverseBits at:(bits + 1)).
            byte < 16 ifTrue:[
                outStream nextPut:$0
            ].
            byte printOn:outStream base:16.
            outStream nextPutAll: ', '.
        ].
        outStream cr
    ].
    outStream nextPutAll: '};'; cr.

    "
     XBMReader save:(Image fromFile:'../../goodies/bitmaps/xbmBitmaps/TicTacToe.xbm') onStream:Transcript
    "
! !

!XBMReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


XBMReader initialize!

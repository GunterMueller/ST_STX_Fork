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

Object subclass:#RIFFReader
	instanceVariableNames:'inStream fileType streamTypes client msb'
	classVariableNames:'UnsupportedFormatErrorSignal'
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!RIFFReader class methodsFor:'documentation'!

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
    Abstract helper class to read RIFF files. See concrete subclasses for details.
    RIFF is the abstract base-format used for a whole bunch of concrete file formats:
        WAV, AVI, AIF etc.
    Concrete formats must be parsed by concrete readers.

    Use:
        define your own concrete reader, with methods getChunk_FOO:,
        for each chunk type FOO you want to parse there.
        Define your reader as a client to this reader, and let it processChunks.
        See AVIReader for a concrete example.

    This is in an experimental state and not yet finished.
    The protocol may change.
"
! !

!RIFFReader class methodsFor:'instance creation'!

fromFile:aFilename
    |s reader|

    s := aFilename asFilename readStream.
    reader := self new fromStream:s.
    s close.
    ^ reader
! !

!RIFFReader class methodsFor:'class initialization'!

initialize
    UnsupportedFormatErrorSignal isNil ifTrue:[
        UnsupportedFormatErrorSignal := ErrorSignal newSignalMayProceed:true.
        UnsupportedFormatErrorSignal nameClass:self message:#unsupportedFormatErrorSignal.
    ].

    "
     RIFFReader initialize
    "

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 5.4.1997 / 16:12:16 / cg"
! !

!RIFFReader class methodsFor:'testing'!

isFORMFile:aFileName withAnyTypeFrom:typeList
    "return true, if aFileName contains FORM-encoded data of format:type"

    ^ self isFile:aFileName ofType:'FORM' withAnySubtypeFrom:typeList
!

isFile:aFileName ofType:mainType withAnySubtypeFrom:typeList
    "return true, if aFileName contains RIFF-encoded data of format:type"

    |data1 len data3 inStream|

    inStream := aFileName asFilename readStream.
    inStream isNil ifTrue:[^ false].
    inStream binary.

    data1 := String new:4.
    inStream nextBytes:4 into:data1.
    len := inStream nextLongMSB:true.
    data3 := String new:4.
    inStream nextBytes:4 into:data3.

    inStream close.

    data3 := data3 withoutTrailingSeparators.
    ((data1 = mainType)
    and:[typeList includes:data3]) ifTrue:[
        ^ true
    ].
    ^ false.

    "
     RIFFReader isRIFFFile:'bitmaps/magtape.xpm' withType:'AVI '   
     RIFFReader isRIFFFile:'/phys/exept/home/pd_stuff/movies/avi/drlair.avi' withType:'AVI'     
     RIFFReader isRIFFFile: '/usr/share/sounds/alsa/test.wav' withType:'WAVE'      
    "

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 5.4.1997 / 16:12:16 / cg"
!

isRIFFFile:aFileName
    "return true, if aFileName contains RIFF-encoded data"

    |data1 inStream|

    inStream := aFileName asFilename readStream.
    inStream isNil ifTrue:[^ false].
    inStream binary.

    data1 := String new:4.
    inStream nextBytes:4 into:data1.
    inStream close.

    ^ (data1 = 'RIFF')

    "
     RIFFReader isRIFFFile:'bitmaps/magtape.xpm'    
     RIFFReader isRIFFFile:'/phys/exept/home/pd_stuff/movies/avi/drlair.avi'      
     RIFFReader isRIFFFile: '/usr/share/sounds/alsa/test.wav'      
     RIFFReader isRIFFFile: '../../goodies/sounds/testSounds/wav/gong.wav'      
     RIFFReader isRIFFFile: '../../goodies/sounds/testSounds/aif/instr/conga_hi.aiff'      
    "

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 5.4.1997 / 16:12:16 / cg"
!

isRIFFFile:aFileName withAnyTypeFrom:typeList
    "return true, if aFileName contains RIFF-encoded data of format:type"

    ^ self isFile:aFileName ofType:'RIFF' withAnySubtypeFrom:typeList
!

isRIFFFile:aFileName withType:type
    "return true, if aFileName contains RIFF-encoded data of format:type"

    ^ self isRIFFFile:aFileName withAnyTypeFrom:(Array with:type)

    "
     RIFFReader isRIFFFile:'bitmaps/magtape.xpm' withType:'AVI '   
     RIFFReader isRIFFFile:'/phys/exept/home/pd_stuff/movies/avi/drlair.avi' withType:'AVI'     
     RIFFReader isRIFFFile: '/usr/share/sounds/alsa/test.wav' withType:'WAVE'      
    "

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 5.4.1997 / 16:12:16 / cg"
! !

!RIFFReader methodsFor:'accessing'!

addStream:type
    streamTypes add:type
!

client
    "return the value of the instance variable 'client' (automatically generated)"

    ^ client
!

client:something
    "set the value of the instance variable 'client' (automatically generated)"

    client := something.
!

msb
    "return the value of the instance variable 'msb' (automatically generated)"

    ^ msb
!

msb:something
    "set the value of the instance variable 'msb' (automatically generated)"

    msb := something.
!

streamTypes:something
    "set the value of the instance variable 'streamTypes' (automatically generated)"

    streamTypes := something.
! !

!RIFFReader methodsFor:'reading from stream'!

fromStream:aStream
    "read RIFF chunks from aStream. Process chunks in getChunkXXX methods
     (usually redefined in concrete reader classes."

    client := self.
    self processStream:aStream

    "
     RIFFReader fromFile:'/phys/exept/home/pd_stuff/movies/avi/hangldm.avi'      
     RIFFReader fromFile:'../../goodies/sounds/testSounds/wav/gong.wav'      

     AVIReader fromFile:'/phys/exept/home/pd_stuff/movies/avi/hangldm.avi'      
     WAVFileReader fromFile:'/phys/exept/opt/office52/share/gallery/sounds/gong.wav'      
     AIFFFileReader fromFile:'/phys/exept/opt/office52/share/gallery/sounds/gong.wav'      
    "

    "Modified: 17.4.1997 / 03:25:08 / cg"
!

getChunk
    "get a single chunk"

    |id sel sTyp chunkSize|

    'getChunk -> ' infoPrint.

    id := '    '.
    (inStream nextBytes:4 into:id startingAt:1) ~~ 4 ifTrue:[
        self error:'short chunk' mayProceed:true.
        ^ self
    ].
    chunkSize := inStream nextLongMSB:msb.

    (id at:1) == $0 ifTrue:[
        sTyp := '_Unknown'.
        streamTypes notNil ifTrue:[
            sTyp := streamTypes at:((id at:2) digitValue + 1) ifAbsent:nil.
        ].
        sel := 'getChunk_' , sTyp , '_' , (id copyFrom:3), ':'.

"/id infoPrint. ' -> ' infoPrint. sel infoPrintCR.
        sel := sel asSymbolIfInterned.
        (sel isNil or:[(client respondsTo:sel) not and:[(self respondsTo:sel) not]]) ifTrue:[
            sel := 'getChunk_' , sTyp , '_Unknown:'.
"/'  ' infoPrint. id infoPrint. ' -> ' infoPrint. sel infoPrintCR.
            sel := sel asSymbolIfInterned.
            (sel isNil or:[(client respondsTo:sel) not and:[(self respondsTo:sel) not]]) ifTrue:[
                '[' infoPrint. ('getChunk_' , sTyp , '_' , (id copyFrom:3)) infoPrint. '] ' infoPrint.
                sel := #'getChunk_Unknown:'.    
"/'    ' infoPrint. id infoPrint. ' -> ' infoPrint. sel infoPrintCR.
            ].
        ]
    ] ifFalse:[
        (id at:4) == Character space ifTrue:[
            id := id copyTo:3
        ].
        sel := ('getChunk_' , id , ':') asSymbolIfInterned.
        (sel isNil or:[(client respondsTo:sel) not and:[(self respondsTo:sel) not]]) ifTrue:[
            '[' infoPrint. ('getChunk_' , id) infoPrint. '] ' infoPrint.
            sel := #'getChunk_Unknown:'    
        ].
"/id infoPrint. ' -> ' infoPrint. sel infoPrintCR.
    ].

    client perform:sel with:chunkSize ifNotUnderstood:[self perform:sel with:chunkSize].
    '' infoPrintCR.

    "
     RIFFReader fromFile:'/phys/exept/home/pd_stuff/movies/avi/hangldm.avi'      
     AVIReader fromFile:'/phys/exept/home/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 4.4.1997 / 22:50:13 / cg"
    "Modified: 5.4.1997 / 15:47:48 / cg"
!

getChunk_DISP:chunkSize
    "process (ignore) a DISP chunk"

    'getChunk_DISP -> ' infoPrint.

    self skipChunk:chunkSize

    "Created: 5.4.1997 / 15:19:10 / cg"
!

getChunk_JUNK:chunkSize
    "ignore JUNK chunk"

    'getChunk_JUNK -> ' infoPrint.

    self skipChunk:chunkSize
!

getChunk_LIST:chunkSize
    "process a LIST chunk"

    'getChunk_LIST' infoPrint.

    inStream skip:4.

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
     RIFFReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
     RIFFReader fromFile:'/home2/cg/AFsp-V2R0/test/audiofiles/jg00b1ss.wav'      
    "

    "Created: 4.4.1997 / 23:18:33 / cg"
    "Modified: 17.4.1997 / 03:22:15 / cg"
!

getChunk_RIFF:chunkSize
    "process a RIFF chunk"

    'getChunk_RIFF' infoPrintCR.

    fileType := (inStream next:4) asString.

    'fileType -> ' infoPrint. fileType infoPrint.
!

getChunk_Unknown:chunkSize
    "ignore any other chunk"

    'getChunk_Unknown -> ' infoPrint.

    self skipChunk:chunkSize
!

processStream:aStream
    "read RIFF chunks from aStream. Process chunks in getChunkXXX methods
     (usually redefined in concrete reader classes."

    inStream := aStream.
    inStream binary.
    msb isNil ifTrue:[
        msb := false.
    ].

    [inStream atEnd] whileFalse:[
        client perform:#getChunk ifNotUnderstood:[self getChunk]. 
    ].
    ^ nil

    "
     RIFFReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
     RIFFReader fromFile:'/home2/cg/AFsp-V2R0/test/audiofiles/jg00b1ss.wav'      
    "

    "Modified: 17.4.1997 / 03:25:08 / cg"
!

skipChunk:chunkSize
    "skip a chunk"

    |sz|

    'skipChunk' infoPrint.

    sz := chunkSize.
    (sz bitTest:1) ifTrue:[
        sz := sz + 1
    ].

    inStream skip:sz.
! !

!RIFFReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/RIFFReader.st,v 1.10 2000-12-30 21:31:41 cg Exp $'
! !


RIFFReader initialize!

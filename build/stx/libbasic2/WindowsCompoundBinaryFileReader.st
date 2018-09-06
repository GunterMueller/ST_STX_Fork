"{ Package: 'stx:libbasic2' }"

Object subclass:#WindowsCompoundBinaryFileReader
	instanceVariableNames:'inStream fileType streamTypes client msb'
	classVariableNames:'UnsupportedFormatErrorSignal'
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!WindowsCompoundBinaryFileReader class methodsFor:'documentation'!

documentation
"
    compoundBinary is actually (kind of) the FAT Disk format in a file.
    It is very old, but still used by visio (vsd) files.
    CompoundBinary is actually a container format.

    Warning:
        ongoing, unfinished work.
"
! !

!WindowsCompoundBinaryFileReader class methodsFor:'instance creation'!

fromFile:aFilename
    |s reader|

    s := aFilename asFilename readStream.
    reader := self new fromStream:s.
    s close.
    ^ reader
! !

!WindowsCompoundBinaryFileReader methodsFor:'reading from stream'!

fromStream:aStream
    "read a stream from aStream."

    client := self.
    self processStream:aStream

    "
     WindowsCompoundBinaryFileReader fromFile:'C:\Users\cg\Downloads\vsdump\examples\Ian\Arrow & Text samples.vsd'      
    "
!

processStream:aStream
    "process a stream."

    inStream := aStream.
    self readHeaderSector.

    "
     WindowsCompoundBinaryFileReader fromFile:'C:\Users\cg\Downloads\vsdump\examples\Ian\Arrow & Text samples.vsd'      
    "
!

readHeaderSector
    "sector 0 is a header sector:
        _abSig = DOCF 11E0 A1B1 1AE1 
        _clid = 0000 0000 0000 0000 0000 0000 0000 0000 
        _uMinorVersion = 003B 
        _uDllVersion = 3 
        _uByteOrder = FFFE (Intel byte order) 
        _uSectorShift = 9 (512 bytes) 
        _uMiniSectorShift = 6 (64 bytes) 
        _usReserved = 0000 
        _ulReserved1 = 00000000 
        _ulReserved2 = 00000000 
        _csectFat = 00000001 
        _sectDirStart = 00000001 
        _signature = 00000000 
        _ulMiniSectorCutoff = 00001000 (4096 bytes) 
        _sectMiniFatStart = 00000002 
        _csectMiniFat = 00000001 
        _sectDifStart = FFFFFFFE (no DIF, file is < 7Mb) 
        _csectDIF = 00000000 _sectFat[] = 00000000 FFFFFFFF . . . (continues with FFFFFFFF)    
    "

    |sector sectorStream sig clsid uMinorVersion uDllVersion uByteOrder uSectorShift uMiniSectorShift usReserved ulReserved1 ulReserved2 csectFat sectDirStart signature ulMiniSectorCutoff sectMiniFatStart csectMiniFat sectDifStart csectDIF sectFat|

    sector := inStream nextBytes:512.
    sectorStream := sector readStream.

    sig := sectorStream nextBytes:8.
    sig = #[ 16rD0 16rCF 16r11 16rE0 16rA1 16rB1 16r1A 16rE1 ] ifFalse:[
        self error.
    ].
    clsid := sectorStream nextBytes:16.

    uMinorVersion := sectorStream nextUnsignedShortMSB:false. "/ = 003B 
    uDllVersion := sectorStream nextUnsignedShortMSB:false. "/ 3 
    uByteOrder := sectorStream nextUnsignedShortMSB:false. "/ = FFFE (Intel byte order)
    uByteOrder == 16rFFFE ifTrue:[
        msb := false.
    ] ifFalse:[
        uByteOrder == 16rFEFF ifTrue:[
            msb := true.
        ] ifFalse:[
            self error  
        ]
    ].
    uSectorShift := sectorStream nextUnsignedShortMSB:msb.      "/ = 9 (sector size 512 bytes) 
    uMiniSectorShift := sectorStream nextUnsignedShortMSB:msb.  "/ = 6 (mini sector size 64 bytes)
    usReserved := sectorStream nextUnsignedShortMSB:msb.
    ulReserved1 := sectorStream nextUnsignedLongMSB:msb. 
    ulReserved2 := sectorStream nextUnsignedLongMSB:msb.
    csectFat := sectorStream nextUnsignedLongMSB:msb.           "/ number of sectors in FAT chain
    sectDirStart := sectorStream nextUnsignedLongMSB:msb.       "/ first sector in directory chain
    signature := sectorStream nextUnsignedLongMSB:msb.
    ulMiniSectorCutoff := sectorStream nextUnsignedLongMSB:msb. "/ max size of ministreams (4096 bytes) 
    sectMiniFatStart := sectorStream nextUnsignedLongMSB:msb.   "/ first sect in mini-FAT = 00000002 
    csectMiniFat := sectorStream nextUnsignedLongMSB:msb.       "/ # of sects in mini-FAT chain = 00000001 
    sectDifStart := sectorStream nextUnsignedLongMSB:msb.       "/ first sect in DIF chain
    csectDIF := sectorStream nextUnsignedLongMSB:msb.           "/ # of sects in DIF chain = FFFFFFFE (no DIF, file is < 7Mb) 
    sectFat := OrderedCollection new.
    109 timesRepeat:[                                           "/ followed by first 109 FAT sectors.
        sectFat add:(sectorStream nextUnsignedLongMSB:msb).     "/ 00000000
    ].
    "/ ... FFFFFFFF
self halt.
    "
     WindowsCompoundBinaryFileReader fromFile:'C:\Users\cg\Downloads\vsdump\examples\Ian\Arrow & Text samples.vsd'      
    "
! !

!WindowsCompoundBinaryFileReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/WindowsCompoundBinaryFileReader.st,v 1.1 2009-04-30 21:20:57 cg Exp $'
! !

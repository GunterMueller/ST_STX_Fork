"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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

ImageReader subclass:#PICTReader
	instanceVariableNames:'currentOpcode rowBytes bounds srcRect dstRect mode ctSeed ctFlags
		ctSize ctTable packType baseAddr pmVersion packSize hRes vRes
		pixelType pixelSize cmpCount cmpSize planeBytes pmTable
		pmReserved picSize picFrame picVersion'
	classVariableNames:'Opcodes'
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

Object subclass:#PICTFrame
	instanceVariableNames:'image sourceRectangle destinationRectangle mode maskRegion'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PICTReader
!

!PICTReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    this class will eventually provide fnctionality for loading and storing
    Apple PICT files. (QuickTime).

    WARNING: this is a first sceletton, ported from the AidaWeb PICTReader.
    The implementation is VERY incomplete - it is provided here to provide a starting
    point for porters.

    For now, it does read a few sample images from the GFF books example CD.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader JPEGReader GIFReader PBMReader PCXReader 
        ST80FormReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader XWDReader 
"
!

examples
"
  PICTReader fromFile:'/unsaved2/stefan/nil/home/stefan/dos/winword/shared/ms.pct'
  PICTReader fromFile:'/phys/exept/tmp/pict/BLK.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/BLU.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/GRN.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/RED.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/WHT.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/YEL.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/FLAG_B24.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/MARBLES.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/TRU256.PCT'
  PICTReader fromFile:'/phys/exept/tmp/pict/VENUS.PCT'


  example7 --- Version 2 PICTure ---

    | array stream image |
    array := #(
        16r0078
        16r0000 16r0000 16r006C 16r00A8
        16r0011
        16r02FF
        16r0C00
                16rFFFE
                16r0000
                16r0048 16r0000
                16r0048 16r0000
                16r0002 16r0002 16r006E 16r00AA
                16r0000
        16r001E
        16r0001
                16r000A
                16r0002 16r0002 16r006E 16r00AA
        16r000A
                16r77DD 16r77DD 16r77DD 16r77DD
        16r0034
                16r0002 16r0002 16r006E 16r00AA
        16r000A
                16r8822 16r8822 16r8822 16r8822
        16r005C
        16r0008
                16r0008
        16r0071
                16r001A
                16r0002 16r0002 16r006E 16r00AA
                16r006E 16r0002 16r0002 16r0054 16r006E 16r00AA 16r006E 16r0002
        16r00FF
    ).

    stream := WriteStream on: (ByteArray new: array size * 2 + 512).
    stream next:512 put:0.
    array do:
        [:n | 
            stream nextPut: ((n bitAnd:16rFF00) bitShift: -8).
            stream nextPut: (n bitAnd: 16r00FF)
        ].
    image := PICTReader fromStream: (ReadStream on: stream contents).
    image


  example8
  --- Version 1 PICTure ---

    | array image |
    array := #[
    16r00 16r4F
    16r00 16r02 16r00 16r02 16r00 16r6E 16r00 16rAA
    16r11
            16r01
    16r01
            16r00 16r0A
            16r00 16r02 16r00 16r02 16r00 16r6E 16r00 16rAA
    16r0A
            16r77 16rDD 16r77 16rDD 16r77 16rDD 16r77 16rDD
    16r34
            16r00 16r02 16r00 16r02 16r00 16r6E 16r00 16rAA
    16r0A
            16r88 16r22 16r88 16r22 16r88 16r22 16r88 16r22
    16r5C
    16r71
            16r00 16r1A
            16r00 16r02 16r00 16r02 16r00 16r6E 16r00 16rAA
            16r00 16r6E 16r00 16r02 16r00 16r02 16r00 16r54 16r00 16r6E 16r00 16rAA 16r00 16r6E 16r00 16r02
    16rFF
    ].
    array := (ByteArray new:512) , array.
    image := PICTReader fromStream: (ReadStream on: array).
    image
"
! !

!PICTReader class methodsFor:'initialization'!

defineOpcodes00 
        Opcodes at: 16r0000 put: ('NOP' -> 0).
        Opcodes at: 16r0001 put: ('Clip' -> 'Region size').
        Opcodes at: 16r0002 put: ('BkPat' -> 8).
        Opcodes at: 16r0003 put: ('TxFont' -> 2).
        Opcodes at: 16r0004 put: ('TxFace' -> 1).
        Opcodes at: 16r0005 put: ('TxMode' -> 2).
        Opcodes at: 16r0006 put: ('SpExtra' -> 4).
        Opcodes at: 16r0007 put: ('PnSize' -> 4).
        Opcodes at: 16r0008 put: ('PnMode' -> 2).
        Opcodes at: 16r0009 put: ('PnPat' -> 8).
        Opcodes at: 16r000A put: ('FillPat' -> 8).
        Opcodes at: 16r000B put: ('OvSize' -> 4).
        Opcodes at: 16r000C put: ('Origin' -> 4).
        Opcodes at: 16r000D put: ('TxSize' -> 2).
        Opcodes at: 16r000E put: ('FgColor' -> 4).
        Opcodes at: 16r000F put: ('BkColor' -> 4).
!

defineOpcodes01
        Opcodes at: 16r0010 put: ('TxRatio' -> 8).
        Opcodes at: 16r0011 put: ('VersionOp' -> 1).
        Opcodes at: 16r0012 put: ('BkPixPat' -> 'Variable').
        Opcodes at: 16r0013 put: ('PnPixPat' -> 'Variable').
        Opcodes at: 16r0014 put: ('FillPixPat' -> 'Variable').
        Opcodes at: 16r0015 put: ('PnLocHFrac' -> 2).
        Opcodes at: 16r0016 put: ('ChExtra' -> 2).
        Opcodes at: 16r0017 put: ('Apple0017' -> 'Not determined').
        Opcodes at: 16r0018 put: ('Apple0018' -> 'Not determined').
        Opcodes at: 16r0019 put: ('Apple0019' -> 'Not determined').
        Opcodes at: 16r001A put: ('RGBFgCol' -> 6).
        Opcodes at: 16r001B put: ('RGBBkCol' -> 6).
        Opcodes at: 16r001C put: ('HiliteMode' -> 0).
        Opcodes at: 16r001D put: ('HiliteColor' -> 6).
        Opcodes at: 16r001E put: ('DefHilite' -> 0).
        Opcodes at: 16r001F put: ('OpColor' -> 6).
!

defineOpcodes02 
        Opcodes at: 16r0020 put: ('Line' -> 8).
        Opcodes at: 16r0021 put: ('LineFrom' -> 4).
        Opcodes at: 16r0022 put: ('ShortLine' -> 6).
        Opcodes at: 16r0023 put: ('ShortLineFrom' -> 2).
        Opcodes at: 16r0024 put: ('Apple0024' -> '2 + data length').
        Opcodes at: 16r0025 put: ('Apple0025' -> '2 + data length').
        Opcodes at: 16r0026 put: ('Apple0026' -> '2 + data length').
        Opcodes at: 16r0027 put: ('Apple0027' -> '2 + data length').
        Opcodes at: 16r0028 put: ('LongText' -> '5 + text').
        Opcodes at: 16r0029 put: ('DHText' -> '2 + text').
        Opcodes at: 16r002A put: ('DVText' -> '2 + text').
        Opcodes at: 16r002B put: ('DHDVText' -> '3 + text').
        Opcodes at: 16r002C put: ('fontName' -> '5 + name length').
        Opcodes at: 16r002D put: ('lineJustify' -> 10).
        Opcodes at: 16r002E put: ('glyphState' -> 8).
        Opcodes at: 16r002F put: ('Apple002F' -> '2 + data length').
!

defineOpcodes03
        Opcodes at: 16r0030 put: ('frameRect' -> 8).
        Opcodes at: 16r0031 put: ('paintRect' -> 8).
        Opcodes at: 16r0032 put: ('eraseRect' -> 8).
        Opcodes at: 16r0033 put: ('invertRect' -> 8).
        Opcodes at: 16r0034 put: ('fillRect' -> 8).
        Opcodes at: 16r0035 put: ('Apple0035' -> 8).
        Opcodes at: 16r0036 put: ('Apple0036' -> 8).
        Opcodes at: 16r0037 put: ('Apple0037' -> 8).
        Opcodes at: 16r0038 put: ('frameSameRect' -> 0).
        Opcodes at: 16r0039 put: ('paintSameRect' -> 0).
        Opcodes at: 16r003A put: ('eraseSameRect' -> 0).
        Opcodes at: 16r003B put: ('invertSameRect' -> 0).
        Opcodes at: 16r003C put: ('fillSameRect' -> 0).
        Opcodes at: 16r003D put: ('Apple003D' -> 0).
        Opcodes at: 16r003E put: ('Apple003E' -> 0).
        Opcodes at: 16r003F put: ('Apple003F' -> 0).
!

defineOpcodes04
        Opcodes at: 16r0040 put: ('frameRRect' -> 8).
        Opcodes at: 16r0041 put: ('paintRRect' -> 8).
        Opcodes at: 16r0042 put: ('eraseRRect' -> 8).
        Opcodes at: 16r0043 put: ('invertRRect' -> 8).
        Opcodes at: 16r0044 put: ('fillRect' -> 8).
        Opcodes at: 16r0045 put: ('Apple0045' -> 8).
        Opcodes at: 16r0046 put: ('Apple0046' -> 8).
        Opcodes at: 16r0047 put: ('Apple0047' -> 8).
        Opcodes at: 16r0048 put: ('frameSameRRect' -> 0).
        Opcodes at: 16r0049 put: ('paintSameRRect' -> 0).
        Opcodes at: 16r004A put: ('eraseSameRRect' -> 0).
        Opcodes at: 16r004B put: ('invertSameRRect' -> 0).
        Opcodes at: 16r004C put: ('fillSameRRect' -> 0).
        Opcodes at: 16r004D put: ('Apple004D' -> 0).
        Opcodes at: 16r004E put: ('Apple004E' -> 0).
        Opcodes at: 16r004F put: ('Apple004F' -> 0).
!

defineOpcodes05
        Opcodes at: 16r0050 put: ('frameOval' -> 8).
        Opcodes at: 16r0051 put: ('paintOval' -> 8).
        Opcodes at: 16r0052 put: ('eraseOval' -> 8).
        Opcodes at: 16r0053 put: ('invertOval' -> 8).
        Opcodes at: 16r0054 put: ('fillRect' -> 8).
        Opcodes at: 16r0055 put: ('Apple0055' -> 8).
        Opcodes at: 16r0056 put: ('Apple0056' -> 8).
        Opcodes at: 16r0057 put: ('Apple0057' -> 8).
        Opcodes at: 16r0058 put: ('frameSameOval' -> 0).
        Opcodes at: 16r0059 put: ('paintSameOval' -> 0).
        Opcodes at: 16r005A put: ('eraseSameOval' -> 0).
        Opcodes at: 16r005B put: ('invertSameOval' -> 0).
        Opcodes at: 16r005C put: ('fillSameOval' -> 0).
        Opcodes at: 16r005D put: ('Apple005D' -> 0).
        Opcodes at: 16r005E put: ('Apple005E' -> 0).
        Opcodes at: 16r005F put: ('Apple005F' -> 0).
!

defineOpcodes06
        Opcodes at: 16r0060 put: ('frameArc' -> 12).
        Opcodes at: 16r0061 put: ('paintArc' -> 12).
        Opcodes at: 16r0062 put: ('eraseArc' -> 12).
        Opcodes at: 16r0063 put: ('invertArc' -> 12).
        Opcodes at: 16r0064 put: ('fillRect' -> 12).
        Opcodes at: 16r0065 put: ('Apple0065' -> 12).
        Opcodes at: 16r0066 put: ('Apple0066' -> 12).
        Opcodes at: 16r0067 put: ('Apple0067' -> 12).
        Opcodes at: 16r0068 put: ('frameSameArc' -> 4).
        Opcodes at: 16r0069 put: ('paintSameArc' -> 4).
        Opcodes at: 16r006A put: ('eraseSameArc' -> 4).
        Opcodes at: 16r006B put: ('invertSameArc' -> 4).
        Opcodes at: 16r006C put: ('fillSameArc' -> 4).
        Opcodes at: 16r006D put: ('Apple006D' -> 4).
        Opcodes at: 16r006E put: ('Apple006E' -> 4).
        Opcodes at: 16r006F put: ('Apple006F' -> 4).
!

defineOpcodes07
        Opcodes at: 16r0070 put: ('framePoly' -> 'Polygon size').
        Opcodes at: 16r0071 put: ('paintPoly' -> 'Polygon size').
        Opcodes at: 16r0072 put: ('erasePoly' -> 'Polygon size').
        Opcodes at: 16r0073 put: ('invertPoly' -> 'Polygon size').
        Opcodes at: 16r0074 put: ('fillRect' -> 'Polygon size').
        Opcodes at: 16r0075 put: ('Apple0075' -> 'Polygon size').
        Opcodes at: 16r0076 put: ('Apple0076' -> 'Polygon size').
        Opcodes at: 16r0077 put: ('Apple0077' -> 'Polygon size').
        Opcodes at: 16r0078 put: ('frameSamePoly' -> 0).
        Opcodes at: 16r0079 put: ('paintSamePoly' -> 0).
        Opcodes at: 16r007A put: ('eraseSamePoly' -> 0).
        Opcodes at: 16r007B put: ('invertSamePoly' -> 0).
        Opcodes at: 16r007C put: ('fillSamePoly' -> 0).
        Opcodes at: 16r007D put: ('Apple007D' -> 0).
        Opcodes at: 16r007E put: ('Apple007E' -> 0).
        Opcodes at: 16r007F put: ('Apple007F' -> 0).
!

defineOpcodes08
        Opcodes at: 16r0080 put: ('frameRgn' -> 'Region size').
        Opcodes at: 16r0081 put: ('paintRgn' -> 'Region size').
        Opcodes at: 16r0082 put: ('eraseRgn' -> 'Region size').
        Opcodes at: 16r0083 put: ('invertRgn' -> 'Region size').
        Opcodes at: 16r0084 put: ('fillRect' -> 'Region size').
        Opcodes at: 16r0085 put: ('Apple0085' -> 'Region size').
        Opcodes at: 16r0086 put: ('Apple0086' -> 'Region size').
        Opcodes at: 16r0087 put: ('Apple0087' -> 'Region size').
        Opcodes at: 16r0088 put: ('frameSameRgn' -> 0).
        Opcodes at: 16r0089 put: ('paintSameRgn' -> 0).
        Opcodes at: 16r008A put: ('eraseSameRgn' -> 0).
        Opcodes at: 16r008B put: ('invertSameRgn' -> 0).
        Opcodes at: 16r008C put: ('fillSameRgn' -> 0).
        Opcodes at: 16r008D put: ('Apple008D' -> 0).
        Opcodes at: 16r008E put: ('Apple008E' -> 0).
        Opcodes at: 16r008F put: ('Apple008F' -> 0).
!

defineOpcodes09
        Opcodes at: 16r0090 put: ('BitsRect' -> 'Variable').
        Opcodes at: 16r0091 put: ('BitsRgn' -> 'Variable').
        Opcodes at: 16r0092 put: ('Apple0092' -> '2 + data length').
        Opcodes at: 16r0093 put: ('Apple0093' -> '2 + data length').
        Opcodes at: 16r0094 put: ('Apple0094' -> '2 + data length').
        Opcodes at: 16r0095 put: ('Apple0095' -> '2 + data length').
        Opcodes at: 16r0096 put: ('Apple0096' -> '2 + data length').
        Opcodes at: 16r0097 put: ('Apple0097' -> '2 + data length').
        Opcodes at: 16r0098 put: ('PackBitsRect' -> 'Variable').
        Opcodes at: 16r0099 put: ('PackBitsRgn' -> 'Variable').
        Opcodes at: 16r009A put: ('DirectBitsRect' -> 'Variable').
        Opcodes at: 16r009B put: ('DirectBitsRegn' -> 'Variable').
        Opcodes at: 16r009C put: ('Apple009C' -> '2 + data length').
        Opcodes at: 16r009D put: ('Apple009D' -> '2 + data length').
        Opcodes at: 16r009E put: ('Apple009E' -> '2 + data length').
        Opcodes at: 16r009F put: ('Apple009F' -> '2 + data length').
!

defineOpcodes10
        Opcodes at: 16r00A0 put: ('ShortComment' -> 2).
        Opcodes at: 16r00A1 put: ('LongComment' -> '4 + data').
        Opcodes at: 16r00A2 put: ('Apple00A2' -> '2 + data length').
        Opcodes at: 16r00A3 put: ('Apple00A3' -> '2 + data length').
        Opcodes at: 16r00A4 put: ('Apple00A4' -> '2 + data length').
        Opcodes at: 16r00A5 put: ('Apple00A5' -> '2 + data length').
        Opcodes at: 16r00A6 put: ('Apple00A6' -> '2 + data length').
        Opcodes at: 16r00A7 put: ('Apple00A7' -> '2 + data length').
        Opcodes at: 16r00A8 put: ('Apple00A8' -> '2 + data length').
        Opcodes at: 16r00A9 put: ('Apple00A9' -> '2 + data length').
        Opcodes at: 16r00AA put: ('Apple00AA' -> '2 + data length').
        Opcodes at: 16r00AB put: ('Apple00AB' -> '2 + data length').
        Opcodes at: 16r00AC put: ('Apple00AC' -> '2 + data length').
        Opcodes at: 16r00AD put: ('Apple00AD' -> '2 + data length').
        Opcodes at: 16r00AE put: ('Apple00AE' -> '2 + data length').
        Opcodes at: 16r00AF put: ('Apple00AF' -> '2 + data length').
!

defineOpcodes99
        Opcodes at: 16r00FF put: ('OpEndPic' -> 0).
        Opcodes at: 16r02FF put: ('Version' -> 2).
        Opcodes at: 16r0C00 put: ('HeaderOp' -> 24).
        Opcodes at: 16r8200 put: ('CompressedQuickTime' -> '4 + data length').
        Opcodes at: 16r8201 put: ('UncompressedQuickTime' -> '4 + data length').
!

initialize
    "install myself in the Image classes fileFormat table
     for the `.pic' and '.pict' extensions."

    MIMETypes defineImageType:nil suffix:'pict' reader:self.
    MIMETypes defineImageType:nil suffix:'pic'  reader:self.

    "PictReader initialize."
!

initializeOpcodes
        "PictImageStream initializeOpcodes."

        Opcodes := IdentityDictionary new: 100.
        self defineOpcodes00.
        self defineOpcodes01.
        self defineOpcodes02.
        self defineOpcodes03.
        self defineOpcodes04.
        self defineOpcodes05.
        self defineOpcodes06.
        self defineOpcodes07.
        self defineOpcodes08.
        self defineOpcodes09.
        self defineOpcodes10.
        self defineOpcodes99.
        ^Opcodes
! !

!PICTReader class methodsFor:'opcodes'!

opcodeAt: opcode 
        "PictImageStream opcodeAt: 16r8201."

        | key value string |

        Opcodes isNil ifTrue:[
            self initializeOpcodes
        ].

        (Opcodes includesKey: opcode)
                ifTrue: [^Opcodes at: opcode].

        string := opcode printStringRadix: 16.
        string := string leftPaddedTo:4 with:$0.   "/ 4 - string size timesRepeat: [string := '0' , string]. "

        key := 'Apple' , string.
        (16r00B0 <= opcode and: [opcode <= 16r00CF])
                ifTrue: 
                        [value := 0.
                        ^key -> value].
        (16r00D0 <= opcode and: [opcode <= 16r00FE])
                ifTrue: 
                        [value := '4 + data length'.
                        ^key -> value].
        (16r0100 <= opcode and: [opcode <= 16r01FF])
                ifTrue: 
                        [value := 2.
                        ^key -> value].
        (16r0200 <= opcode and: [opcode <= 16r02FE])
                ifTrue: 
                        [value := 4.
                        ^key -> value].
        (16r0300 <= opcode and: [opcode <= 16r0BFF])
                ifTrue: 
                        [value := 22.
                        ^key -> value].
        (16r0C01 <= opcode and: [opcode <= 16r7EFF])
                ifTrue: 
                        [value := 24.
                        ^key -> value].
        (16r7F00 <= opcode and: [opcode <= 16r7FFF])
                ifTrue: 
                        [value := 254.
                        ^key -> value].
        (16r8000 <= opcode and: [opcode <= 16r80FF])
                ifTrue: 
                        [value := 0.
                        ^key -> value].
        (16r8100 <= opcode and: [opcode <= 16r81FF])
                ifTrue: 
                        [value := '4 + data length'.
                        ^key -> value].
        (16r8201 <= opcode and: [opcode <= 16rFFFF])
                ifTrue: 
                        [value := '4 + data length'.
                        ^key -> value].
        ^nil
! !

!PICTReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains a sunraster image"

    |inStream nr|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    "try sun raster"
    inStream binary.
    ((inStream nextWord == 16r59A6) 
    and:[inStream nextWord == 16r6A95]) ifTrue: [
	inStream close.
	^ true
    ].

    inStream isPositionable ifFalse:[^ false].

    "try sun bitmap image format"
    inStream text.
    inStream reset.

    "must start with a comment"
    inStream skipSeparators.
    inStream next ~~ $/ ifTrue:[^ false].
    inStream next ~~ $* ifTrue:[^ false].

    (inStream skipThroughAll: 'idth') isNil ifTrue: [
	inStream close.
	^ false
    ].
    inStream next; skipSeparators.
    nr := Integer readFrom: inStream.
    (nr isNil or:[nr <= 0]) ifTrue: [
	inStream close.
	^ false
    ].

    (inStream skipThroughAll: 'eight') isNil ifTrue: [
	inStream close.
	^ false
    ].
    inStream next; skipSeparators.
    nr := Integer readFrom: inStream.
    (nr isNil or:[nr <= 0]) ifTrue: [
	inStream close.
	^ false
    ].

    inStream close.
    ^ true
! !

!PICTReader methodsFor:'commands'!

xBitsRect
        self debug:[ Transcript show:'xBitsRect'; cr ].
        ^self xPackBitsRect
!

xBitsRgn
        self debug:[ Transcript show:'xBitsRgn'; cr ].
        ^self xPackBitsRgn
!

xDHDVText
        | dh dv count string |
        self debug:[ Transcript show:'xDHDVText'; cr ].

        dh := self next.
        dv := self next.
        count := self next.
        string := (self next: count) asString.
        self
                debug: 
                        [Transcript space; show: dh printString.
                        Transcript space; show: dv printString.
                        Transcript space; show: count printString.
                        Transcript space; show: string printString].
        ^Array
                with: dh
                with: dv
                with: count
                with: string
!

xDHText
        | dh count string |

        self debug:[ Transcript show:'xDHText'; cr ].

        dh := self next.
        count := self next.
        string := (self next: count) asString.
        self
                debug: 
                        [Transcript space; show: dh printString.
                        Transcript space; show: count printString.
                        Transcript space; show: string printString].
        ^Array
                with: dh
                with: count
                with: string
!

xDVText
        | dv count string |

        self debug:[ Transcript show:'xDVText'; cr ].

        dv := self next.
        count := self next.
        string := (self next: count) asString.
        self
                debug: 
                        [Transcript space; show: dv printString.
                        Transcript space; show: count printString.
                        Transcript space; show: string printString].
        ^Array
                with: dv
                with: count
                with: string
!

xDirectBitsRect
        | record |

        self debug:[ Transcript show:'xDirectBitsRect'; cr ].

        record := self readDirectPixMap: false.
        self debug: [Transcript space; show: record printString].
        imageSequence add: record.
        ^record
!

xDirectBitsRgn
        ^self readDirectPixMap: true
!

xFontName
        | dataLength fontId nameLength fontName |

        self debug:[ Transcript show:'xFontName'; cr ].

        dataLength := self nextWord.
        fontId := self nextWord.
        nameLength := self next.
        fontName := (self next: nameLength) asString.
        self
                debug: 
                        [Transcript space; show: dataLength printString.
                        Transcript space; show: fontId printString.
                        Transcript space; show: nameLength printString.
                        Transcript space; show: fontName printString].
        ^Array
                with: dataLength
                with: fontId
                with: nameLength
                with: fontName
!

xLongComment
        | kind size bytes aStream char |

        self debug:[ Transcript show:'xLongComment'; cr ].

        kind := self nextWord.
        size := self nextWord.
        bytes := self next: size.
        aStream := WriteStream on: (String new: bytes size).
        bytes
                do: 
                        [:byte | 
                        char := Character value: byte.
                        ((33 <= byte and: [byte <= 126])
                                or: [char = Character tab or: [char = Character space or: [char = Character cr]]])
                                ifTrue: [aStream nextPut: char]
                                ifFalse: [aStream nextPut: Character space]].
        self
                debug: 
                        [Transcript space; show: kind printString.
                        Transcript space; show: size printString.
                        Transcript space; show: aStream contents printString].
        ^Array
                with: kind
                with: size
                with: bytes
!

xLongText
        | point count string |

        self debug:[ Transcript show:'xLongText'; cr ].

        point := self readPoint.
        count := self next.
        string := (self next: count) asString.
        self
                debug: 
                        [Transcript space; show: point printString.
                        Transcript space; show: count printString.
                        Transcript space; show: string printString].
        ^Array
                with: point
                with: count
                with: string
!

xPackBitsRect
        | position word record |

        self debug:[ Transcript show:'xPackBitsRect'; cr ].

        position := self position.
        word := self nextWord.
        self position: position.
        (word bitShift: -15)
                = 1
                ifTrue: [record := self readPixMap: false]
                ifFalse: [record := self readBitMap: false].
        self debug: [Transcript space; show: record printString].
        imageSequence add: record.
        ^record
!

xPackBitsRgn
        | position word record |

        self debug:[ Transcript show:'xPackBitsRgn'; cr ].

        position := self position.
        word := self nextWord.
        self position: position.
        (word bitShift: -15)
                = 1
                ifTrue: [record := self readPixMap: true]
                ifFalse: [record := self readBitMap: true].
        self debug: [Transcript space; show: record printString].
        imageSequence add: record.
        ^record
! !

!PICTReader methodsFor:'debugging'!

debug: aBlock
    aBlock value
! !

!PICTReader methodsFor:'decoding'!

readBitData
        | bitData |
        bitData := ByteArray new: rowBytes * bounds height.
        self progress: 0.
        1 to: bounds height
                do: 
                        [:column | 
                        | start stop replacement |
                        start := column - 1 * rowBytes + 1.
                        stop := column * rowBytes.
                        replacement := self readBitRowData.
                        bitData
                                replaceBytesFrom: start
                                to: stop
                                with: replacement
                                startingAt: 1.
                        self progress: column / bounds height].
        ^bitData
!

readBitMap: isMaskRgn 
        | bitData anImage pad anArray maskRgn |
        rowBytes := self nextWord.
        bounds := self readRect.
        srcRect := self readRect.
        dstRect := self readRect.
        mode := self nextWord.
        bitData := self readBitData.
        isMaskRgn = true ifTrue: [maskRgn := self readRegion].
        pad := rowBytes * 8 - bounds width.
        pad >= 8
                ifTrue: [pad >= 16
                                ifTrue: [pad := 32]
                                ifFalse: [pad := 16]]
                ifFalse: [pad := 8].

        anImage := Image
                                extent: bounds width @ bounds height
                                depth: 1
                                palette: MappedPalette monochromeDefault
                                bits: bitData
                                pad: pad.

        " self debug: [anImage displayOn: ScheduledControllers activeController view graphicsContext]. "
"/ OLD
"/        anArray := Array
"/                    with: anImage
"/                    with: srcRect
"/                    with: dstRect
"/                    with: mode.
"/        isMaskRgn = true ifTrue: [anArray := anArray , (Array with: maskRgn)].
"/ NEW:
        anArray := PICTFrame new
                    image:anImage 
                    sourceRectangle:srcRect 
                    destinationRectangle:dstRect 
                    mode:mode.
        isMaskRgn = true ifTrue: [
            anArray maskRegion:maskRgn
        ].
        ^anArray
!

readBitRowData
        | rawData byteCount |
        rowBytes < 8
                ifTrue: [rawData := self next: rowBytes]
                ifFalse: 
                        [rowBytes > 250
                                ifTrue: [byteCount := self nextWord]
                                ifFalse: [byteCount := self next].
                        rawData := self unPackBits: (self next: byteCount)].
        ^rawData
!

readColorTable
        ctSeed := self nextLong.
        ctFlags := self nextWord.
        ctSize := self nextWord.
        ctTable := Array new: ctSize + 1.
        1 to: ctTable size
                do: 
                        [:i | 
                        | value rgb |
                        value := self nextWord.
                        value yourself.
                        rgb := self nextWord bitShift: 32.
                        rgb := rgb + (self nextWord bitShift: 16).
                        rgb := rgb + self nextWord.
                        ctTable at: i put: rgb]
!

readDataLength2
        | length bytes |
        length := self nextWord.
        bytes := self next: length.
        " self debug: [Transcript space; show: bytes printString]. "
        ^Array with: length with: bytes
!

readDataLength4
        | length bytes |
        length := self nextLong.
        bytes := self next: length.
        " self debug: [Transcript space; show: bytes printString]. "
        ^Array with: length with: bytes
!

readDirectPixData
        packType = 0 ifTrue: [^self errorSorryNotSupported].
        packType = 1 ifTrue: [^self errorSorryNotSupported].
        packType = 2 ifTrue: [^self errorSorryNotSupported].
        packType = 3 ifTrue: [^self errorSorryNotSupported].
        packType = 4 ifTrue: [^self readDirectPixData4].
        ^self errorUnexpectedPakingType
!

readDirectPixData4
        | palette image row scalingValue color index r g b |
"/        palette := FixedPalette
"/                                redShift: 16
"/                                redMask: 255
"/                                greenShift: 8
"/                                greenMask: 255
"/                                blueShift: 0
"/                                blueMask: 255.
        image := Image
                                extent: bounds width @ bounds height
                                depth: 24
                                palette: palette.
        self progress: 0.
        0 to: bounds height - 1
                do: 
                        [:y | 
                        | x |
                        x := 0.
                        row := self readDirectPixRowData.
                        r := row size // 3 * 0 + 1.
                        g := row size // 3 * 1 + 1.
                        b := row size // 3 * 2 + 1.
                        row size // 3
                                timesRepeat: 
                                        [
                                        "/ ST/X
                                        image pixelAtX:x y:y put:( ((((row at: r) bitShift:8)
                                                                    bitOr:(row at: g)) bitShift:8)
                                                                   bitOr:(row at: b)).

                                        "/ VW
"/                                        scalingValue := ColorValue scalingValue.
"/                                        color := ColorValue
"/                                                                scaledRed: (self
"/                                                                                convertValue: ((row at: r)
"/                                                                                                bitAnd: 255)
"/                                                                                from: 255
"/                                                                                to: scalingValue)
"/                                                                scaledGreen: (self
"/                                                                                convertValue: ((row at: g)
"/                                                                                                bitAnd: 255)
"/                                                                                from: 255
"/                                                                                to: scalingValue)
"/                                                                scaledBlue: (self
"/                                                                                convertValue: (row at: b)
"/                                                                                from: 255
"/                                                                                to: scalingValue).
"/                                        index := palette indexOfPaintNearest: color.
"/                                        image
"/                                                atX: x
"/                                                y: y
"/                                                put: index.
                                        r := r + 1.
                                        g := g + 1.
                                        b := b + 1.
                                        x := x + 1].
                        self progress: y / (bounds height - 1)].
        ^image
!

readDirectPixMap: isMaskRgn 
        | anImage maskRgn anArray |

        baseAddr := self nextLong.
        rowBytes := self nextWord bitAnd: 16r3FFF.
        bounds := self readRect.
        pmVersion := self nextWord.
        packType := self nextWord.
        packSize := self nextLong.
        hRes := self nextLong.
        vRes := self nextLong.
        pixelType := self nextWord.
        pixelSize := self nextWord.
        cmpCount := self nextWord.
        cmpSize := self nextWord.
        planeBytes := self nextLong.
        pmTable := self nextLong.
        pmReserved := self nextLong.
        srcRect := self readRect.
        dstRect := self readRect.
        mode := self nextWord.
        isMaskRgn = true ifTrue: [maskRgn := self readRegion].
        anImage := self readDirectPixData.
        " self debug: [anImage displayOn: ScheduledControllers activeController view graphicsContext]. "
"/ OLD:
"/        anArray := Array
"/                                with: anImage
"/                                with: srcRect
"/                                with: dstRect
"/                                with: mode.
"/        isMaskRgn = true ifTrue: [
"/            anArray := anArray , (Array with: maskRgn)
"/        ].

"/ NEW:
        anArray := PICTFrame new
                    image:anImage 
                    sourceRectangle:srcRect 
                    destinationRectangle:dstRect 
                    mode:mode.
        isMaskRgn = true ifTrue: [
            anArray maskRegion:maskRgn
        ].
        ^anArray
!

readDirectPixRowData
        | rawData byteCount |
        (packType = 1 or: [rowBytes < 8])
                ifTrue: [rawData := self next: rowBytes]
                ifFalse: [packType = 2
                                ifTrue: [rawData := self next: (rowBytes * (3 / 4)) asInteger]
                                ifFalse: [packType > 2
                                                ifTrue: 
                                                        [rowBytes > 250
                                                                ifTrue: [byteCount := self nextWord]
                                                                ifFalse: [byteCount := self next].
                                                        rawData := self unPackBits: (self next: byteCount)]]].
        ^rawData
!

readHeader
        | position byte |
        picSize := self nextWord.
        picFrame := self readRect.
        position := self position.
        byte := self next.
        byte = 16r11
                ifTrue: [picVersion := self next]
                ifFalse: 
                        [byte := self next.
                        byte = 16r11
                                ifTrue: 
                                        [picVersion := self next.
                                        self next]
                                ifFalse: [^self errorCanNotRead]].
        self position: position
!

readPixData
        | pixData |
        pixData := ByteArray new: rowBytes * bounds height.
        self progress: 0.
        1 to: bounds height
                do: 
                        [:column | 
                        | start stop replacement |
                        start := column - 1 * rowBytes + 1.
                        stop := column * rowBytes.
                        replacement := self readPixRowData.
                        pixData
                                replaceBytesFrom: start
                                to: stop
                                with: replacement
                                startingAt: 1.
                        self progress: column / bounds height].
        ^pixData
!

readPixMap: isMaskRgn 
        | pixData aPalette anImage pad maskRgn anArray |
        rowBytes := self nextWord bitAnd: 16r3FFF.
        bounds := self readRect.
        pmVersion := self nextWord.
        packType := self nextWord.
        packSize := self nextLong.
        hRes := self nextLong.
        vRes := self nextLong.
        pixelType := self nextWord.
        pixelSize := self nextWord.
        cmpCount := self nextWord.
        cmpSize := self nextWord.
        planeBytes := self nextLong.
        pmTable := self nextLong.
        pmReserved := self nextLong.
        self readColorTable.
        srcRect := self readRect.
        dstRect := self readRect.
        mode := self nextWord.
        isMaskRgn = true ifTrue: [maskRgn := self readRegion].
        pixData := self readPixData.
        aPalette := MappedPalette withColors: (ctTable collect: [:rgb | self colorValueFrom: rgb]).
        pad := rowBytes * 8 - (bounds width * pixelSize).
        pad >= 8
                ifTrue: [pad >= 16
                                ifTrue: [pad := 32]
                                ifFalse: [pad := 16]]
                ifFalse: [pad := 8].
        anImage := Image
                                extent: bounds width @ bounds height
                                depth: pixelSize
                                palette: aPalette
                                bits: pixData
                                pad: pad.
        " self debug: [anImage displayOn: ScheduledControllers activeController view graphicsContext]. "
"/ OLD:
"/        anArray := Array
"/                                with: anImage
"/                                with: srcRect
"/                                with: dstRect
"/                                with: mode.
"/        isMaskRgn = true ifTrue: [anArray := anArray , (Array with: maskRgn)].
"/ NEW:
        anArray := PICTFrame new
                    image:anImage 
                    sourceRectangle:srcRect 
                    destinationRectangle:dstRect 
                    mode:mode.
        isMaskRgn = true ifTrue: [
            anArray maskRegion:maskRgn
        ].
        ^anArray
!

readPixRowData
        packType = 0 ifTrue: [^self readBitRowData].
        packType = 1 ifTrue: [^self readBitRowData].
        ^self errorCanNotRead
!

readPoint
        | x y point |
        x := self nextWord.
        y := self nextWord.
        point := x @ y.
        ^point
!

readPolygon
        | length bytes |
        length := self nextWord.
        bytes := self next: length - 2.
        " self
                debug: 
                        [Transcript space; show: length printString.
                        Transcript space; show: bytes printString]. "
        ^Array with: length with: bytes
!

readRect
        | top left bottom right rect |
        top := self nextWord.
        left := self nextWord.
        bottom := self nextWord.
        right := self nextWord.
        rect := left @ top corner: right @ bottom.
        ^rect
!

readRegion
        | length bytes |
        length := self nextWord.
        bytes := self next: length - 2.
        " self debug: 
                [Transcript space; show: length printString.
                Transcript space; show: bytes printString]. "
        ^Array with: length with: bytes
! !

!PICTReader methodsFor:'encoding'!

bitData: bitData 
        | imageRowBytes packStream |
        imageRowBytes := bounds width * pixelSize + 31 // 32 * 4.
        packStream := WriteStream on: (ByteArray new: bitData size).
        self progress: 0.
        1 to: bounds height
                do: 
                        [:h | 
                        | rowBits packedBits |
                        rowBits := bitData copyFrom: h - 1 * imageRowBytes + 1 to: h - 1 * imageRowBytes + rowBytes.
                        rowBytes < 8
                                ifTrue: [packStream nextPutAll: rowBits]
                                ifFalse: 
                                        [packedBits := self packBits: rowBits.
                                        rowBytes > 250
                                                ifTrue: 
                                                        [packStream nextPut: ((packedBits size bitShift: -8)
                                                                        bitAnd: 255).
                                                        packStream nextPut: (packedBits size bitAnd: 255)]
                                                ifFalse: [packStream nextPut: packedBits size].
                                        packStream nextPutAll: packedBits].
                        self progress: h / bounds height].
        ^packStream contents
!

directPixData4: anImage 
        | packStream palette r g b index color scalingValue stream |
        packStream := WriteStream on: (ByteArray new: anImage bits size).
        palette := anImage palette.
        self progress: 0.
        0 to: bounds height - 1
                do: 
                        [:y | 
                        r := WriteStream on: ByteArray new.
                        g := WriteStream on: ByteArray new.
                        b := WriteStream on: ByteArray new.
                        0 to: bounds width - 1
                                do: 
                                        [:x | 
                                        index := anImage atX: x y: y.
                                        (palette includesKey: index)
                                                ifTrue: [color := palette at: index]
                                                ifFalse: [color := palette at: (index bitAnd: palette maxIndex)].
                                        scalingValue := ColorValue scalingValue.
                                        r nextPut: (self
                                                        convertValue: color scaledRed
                                                        from: scalingValue
                                                        to: 255).
                                        g nextPut: (self
                                                        convertValue: color scaledGreen
                                                        from: scalingValue
                                                        to: 255).
                                        b nextPut: (self
                                                        convertValue: color scaledBlue
                                                        from: scalingValue
                                                        to: 255)].
                        stream := WriteStream on: ByteArray new.
                        stream nextPutAll: r contents.
                        stream nextPutAll: g contents.
                        stream nextPutAll: b contents.
                        packStream nextPutAll: (self directPixRowData: stream contents).
                        self progress: y / (bounds height - 1)].
        ^packStream contents
!

directPixRowData: row 
        | aStream rawData byteCount |
        aStream := WriteStream on: (ByteArray new: row size).
        rawData := self packBits: row.
        byteCount := rawData size.
        rowBytes > 250
                ifTrue: 
                        [aStream nextPut: ((byteCount bitShift: -8)
                                        bitAnd: 255).
                        aStream nextPut: (byteCount bitAnd: 255)]
                ifFalse: [aStream nextPut: byteCount].
        aStream nextPutAll: rawData.
        ^aStream contents
!

nextPutImage24: image 
        | anImage endOpcode |
        Cursor wait showWhile: [anImage := image "convertToPalette: (FixedPalette
                                                redShift: 16
                                                redMask: 255
                                                greenShift: 8
                                                greenMask: 255
                                                blueShift: 0
                                                blueMask: 255)
                                        renderedBy: ErrorDiffusion new"].
        baseAddr := 16r000000FF.
        rowBytes := anImage width * 32 + 7 // 8.
        bounds := anImage bounds.
        pmVersion := 0.
        packType := 4.
        packSize := 0.
        hRes := 16r00480000.
        vRes := 16r00480000.
        pixelType := 16.
        pixelSize := 32.
        cmpCount := 3.
        cmpSize := 8.
        planeBytes := 0.
        pmTable := 0.
        pmReserved := 0.
        srcRect := anImage bounds.
        dstRect := anImage bounds.
        mode := 64.
        endOpcode := 16r00FF.
        self writeImage24: anImage.
        self writeOpcode: endOpcode.
        ^anImage
!

sortPalette: image 
        | max array color |
        max := 1 bitShift: pixelSize.
        array := Array new: image palette maxIndex + 1.
        1 to: array size
                do: 
                        [:i | 
                        color := image palette at: i - 1 ifAbsent: [ColorValue white].
                        array at: i put: (self rgbIntegerFrom: color)].
        array size > max
                ifTrue: [array := array copyFrom: 1 to: max]
                ifFalse: [array size < max ifTrue: [array := array , (Array new: max - array size withAll: 0)]].
        array := array asSortedCollection reverse collect: [:rgb | self colorValueFrom: rgb].
        ^image convertToPalette: (MappedPalette withColors: array)
!

writeBits24: bits 
        | currentOpecode |
        currentOpecode := 16r009A.
        self writeOpcode: currentOpecode.
        self nextLongPut: baseAddr.
        self nextWordPut: rowBytes + (1 bitShift: 15).
        self writeRect: bounds.
        self nextWordPut: pmVersion.
        self nextWordPut: packType.
        self nextLongPut: packSize.
        self nextLongPut: hRes.
        self nextLongPut: vRes.
        self nextWordPut: pixelType.
        self nextWordPut: pixelSize.
        self nextWordPut: cmpCount.
        self nextWordPut: cmpSize.
        self nextLongPut: planeBytes.
        self nextLongPut: pmTable.
        self nextLongPut: pmReserved.
        self writeRect: srcRect.
        self writeRect: dstRect.
        self nextWordPut: mode.
        self nextPutAll: bits
!

writeBits: bits palette: palette 
        rowBytes < 8
                ifTrue: [currentOpcode := 16r90]
                ifFalse: [currentOpcode := 16r0098].
        picVersion = 1
                ifTrue: 
                        [self writeOpcode: currentOpcode.
                        self nextWordPut: rowBytes.
                        self writeRect: bounds.
                        self writeRect: srcRect.
                        self writeRect: dstRect.
                        self nextWordPut: mode.
                        self nextPutAll: bits]
                ifFalse: 
                        [self writeOpcode: currentOpcode.
                        self nextWordPut: rowBytes + (1 bitShift: 15).
                        self writeRect: bounds.
                        self nextWordPut: pmVersion.
                        self nextWordPut: packType.
                        self nextLongPut: packSize.
                        self nextLongPut: hRes.
                        self nextLongPut: vRes.
                        self nextWordPut: pixelType.
                        self nextWordPut: pixelSize.
                        self nextWordPut: cmpCount.
                        self nextWordPut: cmpSize.
                        self nextLongPut: planeBytes.
                        self nextLongPut: pmTable.
                        self nextLongPut: pmReserved.
                        self nextLongPut: ctSeed.
                        self nextWordPut: ctFlags.
                        self nextWordPut: ctSize.
                        ctTable := Array new: palette maxIndex + 1.
                        1 to: ctTable size
                                do: 
                                        [:i | 
                                        | color value rgb |
                                        color := palette at: i - 1 ifAbsent: [ColorValue white].
                                        value := 0.
                                        rgb := self rgbIntegerFrom: color.
                                        ctTable at: i put: rgb.
                                        self nextWordPut: value.
                                        self nextWordPut: ((rgb bitShift: -32)
                                                        bitAnd: 65535).
                                        self nextWordPut: ((rgb bitShift: -16)
                                                        bitAnd: 65535).
                                        self nextWordPut: (rgb bitAnd: 65535)].
                        self writeRect: srcRect.
                        self writeRect: dstRect.
                        self nextWordPut: mode.
                        self nextPutAll: bits]
!

writeClip: aRectangle 
        picVersion = 1
                ifTrue: [self writeOpcode: 16r01]
                ifFalse: [self writeOpcode: 16r0001].
        self nextWordPut: 10.
        self writeRect: aRectangle
!

writeHeader24: bits 
        | pictCodeSize |
        pictCodeSize := 2.
        picSize := 40.
        picSize := picSize + pictCodeSize.
        picSize := picSize + pictCodeSize + 10.
        picSize := picSize + pictCodeSize + 68 + bits size.
        bits size odd ifTrue: [picSize := picSize + 1].
        picSize := picSize + pictCodeSize.
        self nextWordPut: picSize \\ 65535.
        self writeRect: picFrame.
        self nextWordPut: 17.
        self nextWordPut: 767.
        self nextWordPut: 3072.
        1 to: 2 do: [:i | self nextWordPut: 65535].
        1 to: 4 do: [:i | self nextWordPut: 0].
        self nextWordPut: picFrame width.
        1 to: 1 do: [:i | self nextWordPut: 0].
        self nextWordPut: picFrame height.
        1 to: 3 do: [:i | self nextWordPut: 0]
!

writeHeader: bits palette: palette
        | pictCodeSize |
        picVersion = 1
                ifTrue: 
                        [pictCodeSize := 1.
                        picSize := 12.
                        picSize := picSize + pictCodeSize + 10.
                        picSize := picSize + pictCodeSize + 10 + 8 + 8 + 2 + bits size.
                        picSize := picSize + pictCodeSize]
                ifFalse: 
                        [pictCodeSize := 2.
                        picSize := 40.
                        picSize := picSize + pictCodeSize.
                        picSize := picSize + pictCodeSize + 10.
                        picSize := picSize + pictCodeSize + 46 + 8 + (palette maxIndex + 1 * 8) + 8 + 8 + 2 + bits size.
                        bits size odd ifTrue: [picSize := picSize + 1].
                        picSize := picSize + pictCodeSize].
        self nextWordPut: picSize \\ 65535.
        self writeRect: picFrame.
        picVersion = 1
                ifTrue: 
                        [self nextPut: 17.
                        self nextPut: 1]
                ifFalse: 
                        [self nextWordPut: 17.
                        self nextWordPut: 767.
                        self nextWordPut: 3072.
                        1 to: 2 do: [:i | self nextWordPut: 65535].
                        1 to: 4 do: [:i | self nextWordPut: 0].
                        self nextWordPut: picFrame width.
                        1 to: 1 do: [:i | self nextWordPut: 0].
                        self nextWordPut: picFrame height.
                        1 to: 3 do: [:i | self nextWordPut: 0]]
!

writeImage24: anImage 
        | bits |
        bits := self directPixData4: anImage.
        self writeHeader24: ByteArray new.
        self writeClip: bounds.
        self writeBits24: bits.
        ^anImage
!

writeImage: anImage 
        | image bits |
        image := self sortPalette: anImage.
        bits := self bitData: image bits.
        self writeHeader: bits palette: image palette.
        self writeClip: bounds.
        self writeBits: bits palette: image palette.
        ^anImage
!

writeOpcode: opcode 
        picVersion = 1
                ifTrue: [self nextPut: opcode]
                ifFalse: 
                        [self position odd ifTrue: [self nextPut: 0].
                        self nextWordPut: opcode]
!

writeRect: aRectangle 
        self nextWordPut: aRectangle top.
        self nextWordPut: aRectangle left.
        self nextWordPut: aRectangle bottom.
        self nextWordPut: aRectangle right
! !

!PICTReader methodsFor:'interpreting'!

fixedOpcode: opcodeName additionalData: additionalData 
    | bytes |

    " self debug: [Transcript space; show: opcodeName]. "
    bytes := self next: additionalData.
    " self debug: [Transcript space; show: bytes printString] "
!

interpretOpcode: association 
        | opcodeName additionalData |
        opcodeName := association key.
        additionalData := association value.

        self debug:[ Transcript show: 'op:'; show:opcodeName; show:' ['; show:additionalData; show:']'; cr ].

        additionalData isString
                ifTrue: [self variableOpcode: opcodeName additionalData: additionalData]
                ifFalse: [self fixedOpcode: opcodeName additionalData: additionalData]
!

nextOpcode
        | association |
        " self debug: [Transcript cr.
                     Transcript show: (self hexString4: self position).
                     Transcript show: ':']. "
        picVersion = 1
                ifTrue: [currentOpcode := self next]
                ifFalse: 
                        [self position odd ifTrue: [self next].
                        currentOpcode := self nextWord].
        association := self class opcodeAt: currentOpcode.
        association isNil ifTrue: [^self errorUnexpectedOpcode].
        self interpretOpcode: association.
        ^association
!

variableOpcode: opcodeName additionalData: additionalData 
        | aSymbol |

        " self debug: [Transcript space; show: opcodeName]. "
        additionalData = 'Polygon size' ifTrue: [^self readPolygon].
        additionalData = 'Region size' ifTrue: [^self readRegion].
        additionalData = '2 + data length' ifTrue: [^self readDataLength2].
        additionalData = '4 + data length' ifTrue: [^self readDataLength4].

        (opcodeName copyFrom: 1 to: ('Apple' size min: opcodeName size))
                = 'Apple' ifTrue: [^self errorUnexpectedOpcode].
        aSymbol := ((String with: $x with: opcodeName first asUppercase)
                                , (opcodeName copyFrom: 2 to: opcodeName size)) asSymbol.
        (self respondsTo: aSymbol)
                ifTrue: [^self perform: aSymbol].
        ^self errorUnexpectedOpcode
! !

!PICTReader methodsFor:'printing'!

hexString2: aNumber 
        | aString aStream |
        aString := aNumber printStringRadix: 16.
        aStream := WriteStream on: (String new: 12).
        aStream nextPutAll: '16r'.
        2 - aString size timesRepeat: [aStream nextPutAll: '0'].
        aStream nextPutAll: aString.
        ^aStream contents
!

hexString4: aNumber 
        | aString aStream |
        aString := aNumber printStringRadix: 16.
        aStream := WriteStream on: (String new: 12).
        aStream nextPutAll: '16r'.
        4 - aString size timesRepeat: [aStream nextPutAll: '0'].
        aStream nextPutAll: aString.
        ^aStream contents
!

hexString8: aNumber 
        | aString aStream |
        aString := aNumber printStringRadix: 16.
        aStream := WriteStream on: (String new: 12).
        aStream nextPutAll: '16r'.
        8 - aString size timesRepeat: [aStream nextPutAll: '0'].
        aStream nextPutAll: aString.
        ^aStream contents
! !

!PICTReader methodsFor:'private'!

colorValueFrom: rgbInteger 
        | scalingValue |

        ^ Color 
            redShort:((rgbInteger bitShift: -32) bitAnd: 65535)
            greenShort:((rgbInteger bitShift: -16) bitAnd: 65535) 
            blueShort:(rgbInteger bitAnd: 65535)

"/        scalingValue := ColorValue scalingValue.
"/        ^ColorValue
"/                scaledRed: (self
"/                                convertValue: ((rgbInteger bitShift: -32)
"/                                                bitAnd: 65535)
"/                                from: 65535
"/                                to: scalingValue)
"/                scaledGreen: (self
"/                                convertValue: ((rgbInteger bitShift: -16)
"/                                                bitAnd: 65535)
"/                                from: 65535
"/                                to: scalingValue)
"/                scaledBlue: (self
"/                                convertValue: (rgbInteger bitAnd: 65535)
"/                                from: 65535
"/                                to: scalingValue)
!

errorSorryNotSupported
        self error: 'sorry, not supported'.
        ^nil
!

errorUnexpectedOpcode
        | string |
        picVersion = 1
                ifTrue: [string := self hexString2: currentOpcode]
                ifFalse: [string := self hexString4: currentOpcode].
        string := (self hexString8: self position)
                                , ': ' , string.
        self error: 'unexpected opcode: ' , string.
        ^nil
!

errorUnexpectedPakingType
        self error: 'unexpected packing type: ' , packType printString.
        ^nil
!

mergeImages
        | aRectangle aDepth aPalette anImage aPattern indexValue |
        aRectangle := nil.
        aDepth := nil.
        aPalette := nil.
        imageSequence
                do: 
                        [:array | 
                        aRectangle isNil
                                ifTrue: [aRectangle := array at: 3]
                                ifFalse: [aRectangle := aRectangle merge: (array at: 3)].
                        aDepth isNil
                                ifTrue: 
                                        [aDepth := (array at: 1) depth.
                                        aPalette := (array at: 1) palette]
                                ifFalse: [aDepth < (array at: 1) depth
                                                ifTrue: 
                                                        [aDepth := (array at: 1) depth.
                                                        aPalette := (array at: 1) palette]]].
        anImage := Image
                                extent: aRectangle extent
                                depth: aDepth
                                palette: aPalette.
        aPattern := Image
                                extent: 16 @ 16
                                depth: anImage depth
                                palette: anImage palette.
        indexValue := aPattern palette indexOfPaintNearest: ColorValue white.
        0 to: aPattern width - 1 do: [:x | 0 to: aPattern height - 1 do: [:y | aPattern atPoint: x @ y put: indexValue]].
        anImage
                tile: aRectangle
                from: Point zero
                in: aPattern
                rule: RasterOp over.
        imageSequence
                do: 
                        [:array | 
                        | srcImage srcR dstR |
                        srcImage := array at: 1.
                        srcR := array at: 2.
                        dstR := array at: 3.
                        srcImage palette = aPalette ifFalse: [srcImage := srcImage convertToPalette: aPalette renderedBy: ErrorDiffusion new].
                        dstR := dstR translatedBy: Point zero - aRectangle origin.
                        anImage
                                copy: dstR
                                from: srcR origin
                                in: srcImage
                                rule: RasterOp over].
        ^anImage
!

packBits: bits 
        | packStream prev writeBlock bitSize bitPos start code replicateSize literalSize |
        packStream := WriteStream on: (ByteArray new: bits size).
        prev := nil.
        writeBlock := [:asc | asc key < 0
                                ifTrue: 
                                        ["replicate"
                                        packStream nextPut: asc key negated.
                                        packStream nextPut: asc value]
                                ifFalse: 
                                        ["literal"
                                        | litStart litStop |
                                        litStart := asc value first.
                                        litStop := asc value last.
                                        asc key = (litStop - litStart) ifFalse: [self error: 'can''t happen'].
                                        [litStop - litStart + 1 > 128]
                                                whileTrue: 
                                                        [packStream nextPut: 127.
                                                        litStart to: litStart + 127 do: [:litIndex | packStream nextPut: (bits at: litIndex)].
                                                        litStart := litStart + 128].
                                        litStart <= litStop
                                                ifTrue: 
                                                        [packStream nextPut: litStop - litStart + 1 - 1.
                                                        litStart to: litStop do: [:litIndex | packStream nextPut: (bits at: litIndex)]]]].
        bitSize := bits size.
        bitPos := 1.
        [bitPos <= bitSize]
                whileTrue: 
                        [start := bitPos.
                        code := bits at: start.
                        [(bitPos := bitPos + 1) <= bitSize and: [(bits at: bitPos)
                                        = code]]
                                whileTrue: [].
                        replicateSize := bitPos - start.
                        replicateSize > 128
                                ifTrue: 
                                        [prev == nil
                                                ifFalse: 
                                                        [writeBlock value: prev.
                                                        prev := nil].
                                        [replicateSize > 128]
                                                whileTrue: 
                                                        [writeBlock value: -129 -> code.
                                                        start := start + 128.
                                                        replicateSize := replicateSize - 128]].
                        replicateSize = 2
                                ifTrue: 
                                        ["treat as literal"
                                        literalSize := 2.
                                        prev ~~ nil ifTrue: [prev key >= 0
                                                        ifTrue: 
                                                                ["prev is literal"
                                                                literalSize := literalSize + prev value size.
                                                                start := prev value first]
                                                        ifFalse: 
                                                                [writeBlock value: prev.
                                                                prev := nil]].
                                        prev := literalSize - 1 -> (start to: start + literalSize - 1)]
                                ifFalse: [replicateSize > 2
                                                ifTrue: 
                                                        [prev == nil
                                                                ifFalse: 
                                                                        [writeBlock value: prev.
                                                                        prev := nil].
                                                        prev := (256 - (replicateSize - 1)) negated -> code]
                                                ifFalse: ["replicateSize < 2"
                                                        bitPos := bitPos - 1]].
                        (start := bitPos) <= bitSize
                                ifTrue: 
                                        [code := bits at: start.
                                        [(bitPos := bitPos + 1) <= bitSize and: [(bits at: bitPos)
                                                        ~= code]]
                                                whileTrue: [code := bits at: bitPos].
                                        bitPos <= bitSize ifTrue: [bitPos := bitPos - 1].
                                        literalSize := bitPos - start.
                                        literalSize > 0
                                                ifTrue: 
                                                        [prev ~~ nil ifTrue: [prev key >= 0
                                                                        ifTrue: 
                                                                                ["prev is literal"
                                                                                literalSize := literalSize + prev value size.
                                                                                start := prev value first]
                                                                        ifFalse: 
                                                                                [writeBlock value: prev.
                                                                                prev := nil]].
                                                        prev := literalSize - 1 -> (start to: start + literalSize - 1)]]].
        prev == nil
                ifFalse: 
                        [writeBlock value: prev.
                        prev := nil].
        ^packStream contents
!

progress:fraction
    self reportProgress:fraction
!

rgbIntegerFrom: aColorValue 
        | scalingValue |
        scalingValue := ColorValue scalingValue.
        ^((self
                convertValue: aColorValue scaledRed
                from: scalingValue
                to: 65535)
                bitShift: 32)
                + ((self
                                convertValue: aColorValue scaledGreen
                                from: scalingValue
                                to: 65535)
                                bitShift: 16) + (self
                        convertValue: aColorValue scaledBlue
                        from: scalingValue
                        to: 65535)
!

unPackBits: bits 
        | unpackStream bitSize bitPos code |
        unpackStream := WriteStream on: (ByteArray new: bits size).
        bitSize := bits size.
        bitPos := 0.
        [(bitPos := bitPos + 1) <= bitSize]
                whileTrue: 
                        [code := bits at: bitPos.
                        code < 128
                                ifTrue: [1 to: code + 1 do: [:i | unpackStream nextPut: (bits at: (bitPos := bitPos + 1))]]
                                ifFalse: [code > 128
                                                ifTrue: 
                                                        [bitPos := bitPos + 1.
                                                        1 to: 256 - code + 1 do: [:i | unpackStream nextPut: (bits at: bitPos)]]]].
        ^unpackStream contents
! !

!PICTReader methodsFor:'reading'!

fromStream: aStream 
    "read an image in my format from aStream.
     Dtermine if its a raster or icon file."

    |endOpcode|

"/    ^ self fileFormatError:'Sorry - PICT image implementation is incomplete'.

    inStream := aStream.
    aStream binary.

    inStream skip:512.      "apples file header"

    currentOpcode := nil.
    imageSequence := OrderedCollection new.
    self readHeader.
    self reportDimension.
    endOpcode := 16r00FF.
    [currentOpcode = endOpcode] whileFalse: [self nextOpcode].

    imageSequence isEmpty ifTrue: [^nil].
    imageSequence size = 1 ifTrue: [
        "/ OLD:
        "/ ^ imageSequence first first
        "/ NEW:
        ^ imageSequence first image
    ].
    ^ self mergeImages

    "
     PICTReader fromFile:'/unsaved2/stefan/nil/home/stefan/dos/winword/shared/ms.pct'
    "
! !

!PICTReader methodsFor:'support-IO'!

next
    ^ inStream nextByte
!

next:numBytes 
        ^ inStream next:numBytes
!

nextLong
"/    ^ (inStream next bitShift: 24)
"/            + (inStream next bitShift: 16) + (inStream next bitShift: 8) + inStream next
    ^ inStream nextUnsignedLongMSB:true
!

nextLongPut:a32BitW 
"/    outStream nextPut: ((a32BitW bitShift: -24)
"/                    bitAnd: 255).
"/    outStream nextPut: ((a32BitW bitShift: -16)
"/                    bitAnd: 255).
"/    outStream nextPut: ((a32BitW bitShift: -8)
"/                    bitAnd: 255).
"/    outStream nextPut: (a32BitW bitAnd: 255).
    outStream nextPutLong:a32BitW MSB:true.
    ^a32BitW
!

nextPut:aByte 
    outStream nextPut:aByte
!

nextWord
    ^ inStream nextUnsignedShortMSB:true
!

nextWordPut:a16BitW 
"/    outStream nextPut: ((a16BitW bitShift: -8)
"/                    bitAnd: 255).
"/    outStream nextPut: (a16BitW bitAnd: 255).
    outStream nextPutShort:a16BitW MSB:true.
    ^a16BitW
!

position
    ^ inStream position
!

position:arg 
    inStream position:arg
!

size
    self halt.
    ^ outStream size
!

skip: anInteger 
self halt.
    ^ inStream skip: anInteger
!

space
    ^ outStream space
!

tab
    ^ outStream tab
! !

!PICTReader methodsFor:'writing'!

nextPutImage: anImage 
        | endOpcode |

    ^ self fileFormatError:'Sorry - PICT image implementation is incomplete'.

"/        (anImage isKindOf: Image) not ifTrue: [^self errorCanNotWrite].
"/        ((imageStream isKindOf: ExternalStream)
"/                or: [(imageStream respondsTo: #stream)
"/                                and: [imageStream stream isKindOf: ExternalStream]])
"/                ifTrue: [self nextPutAll: (ByteArray new: 512)].
"/        picSize := 0.
"/        picFrame := 0 @ 0 extent: anImage extent.
"/        anImage bitsPerPixel = 1
"/                ifTrue: [picVersion := 1]
"/                ifFalse: [picVersion := 2].
"/        anImage bitsPerPixel > 8 ifTrue: [^self nextPutImage24: anImage].
"/        rowBytes := anImage width * anImage bitsPerPixel + 7 // 8.
"/        bounds := anImage bounds.
"/        pmVersion := 0.
"/        packType := 0.
"/        packSize := 0.
"/        hRes := '16r00480000' asNumber.
"/        vRes := '16r00480000' asNumber.
"/        pixelType := 0.
"/        pixelSize := anImage bitsPerPixel.
"/        cmpCount := 1.
"/        cmpSize := anImage bitsPerPixel.
"/        planeBytes := 0.
"/        pmTable := 0.
"/        pmReserved := 0.
"/        ctSeed := 0.
"/        ctFlags := '16r8000' asNumber.
"/        ctSize := anImage palette maxIndex.
"/        ctTable := nil.
"/        srcRect := anImage bounds.
"/        dstRect := anImage bounds.
"/        mode := 0.
"/        endOpcode := '16r00FF' asNumber.
"/        self writeImage: anImage.
"/        self writeOpcode: endOpcode.
"/        ^anImage
! !

!PICTReader::PICTFrame methodsFor:'accessing'!

destinationRectangle
    ^ destinationRectangle
!

image
    ^ image
!

image:imageArg sourceRectangle:sourceRectangleArg destinationRectangle:destinationRectangleArg mode:modeArg 
    "set instance variables (automatically generated)"

    image := imageArg.
    sourceRectangle := sourceRectangleArg.
    destinationRectangle := destinationRectangleArg.
    mode := modeArg.
!

maskRegion
    ^ maskRegion
!

maskRegion:something
    maskRegion := something.
!

mode
    ^ mode
!

sourceRectangle
    ^ sourceRectangle
! !

!PICTReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PICTReader.st,v 1.8 2003-11-19 19:19:27 cg Exp $'
! !


PICTReader initialize!

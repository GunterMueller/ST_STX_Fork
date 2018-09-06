"{ Package: 'stx:goodies/communication/thrift' }"

TProtocol subclass:#TCompactProtocol
	instanceVariableNames:''
	classVariableNames:'PROTOCOL_ID VERSION VERSION_MASK TYPE_MASK TYPE_SHIFT'
	poolDictionaries:'TConstants'
	category:'Net-Communication-Thrift-Protocol'
!


!TCompactProtocol class methodsFor:'class initialization'!

initialize
    PROTOCOL_ID := 16r82.
    VERSION := 1.
    VERSION_MASK := 16r1F.
    TYPE_MASK := 16rE0.
    TYPE_SHIFT := 5.
! !

!TCompactProtocol methodsFor:'initialization'!

initialize
    self halt:'unfinished'
! !

!TCompactProtocol methodsFor:'reading'!

intFromByteArray:buf 
    |vals|

    vals := Array new:buf size.
    1 to:buf size do:[:n | 
        vals at:n put:((buf at:n) bitShift:(buf size - n) * 8)
    ].
    ^ vals sum
!

readBool
    ^ self readByte ~~ 0
!

readByte
    ^ (self transport read:1) first
!

readDouble
    | val |

    Smalltalk isSmalltalkX ifTrue:[
        "/ TODO: care for byteorder
        val := Float basicNew.
        1 to:8 do:[:i | val basicAt:i put:(transport read:1) ].
        ^ val
    ] ifFalse:[
        val := Float new: 2.
        ^ val basicAt: 1 put: (self readRawInt: 4);
                basicAt: 2 put: (self readRawInt: 4);
                yourself
    ].
!

readFieldBegin
    |field|

    field := TField new type:self readByte.
    ^ field type = TType stop 
        ifTrue:[ field ]
        ifFalse:[
            field
                id:self readI16;
                yourself
        ]
!

readI16
    ^ self readInt:2
!

readI32
    ^ self readInt:4
!

readI64
    ^ self readInt:8
!

readInt:size 
    |buf val|

    buf := transport read:size.
    val := self intFromByteArray:buf.
    ^ buf first > 16r7F 
        ifTrue:[ self unsignedInt:val size:size ]
        ifFalse:[ val ]
!

readListBegin
    ^ (TList new)
        elemType:self readByte;
        size:self readI32
!

readMapBegin
    ^ (TMap new)
        keyType:self readByte;
        valueType:self readByte;
        size:self readI32
!

readMessageBegin
    |version|

    version := self readI32.
    (version bitAnd:self versionMask) = self version1 ifFalse:[
        TProtocolError signalWithCode:TProtocolError badVersion
    ].
    ^ (TMessage new)
        type:(version bitAnd:16r000000FF);
        name:self readString;
        seqid:self readI32
!

readRawInt:size 
    ^ self intFromByteArray:(transport read:size)
!

readSetBegin
    "element type, size"
    
    ^ (TSet new)
        elemType:self readByte;
        size:self readI32
!

readString
    |sz|

    sz := self readI32.
    ^ sz > 0 ifTrue:[ (transport read:sz) asString ] ifFalse:[ '' ]
!

unsignedInt:val size:size 
    ^ 0 - ((val - 1) bitXor:((2 raisedTo:(size * 8)) - 1))
! !

!TCompactProtocol methodsFor:'writing'!

write:aString 
    transport write:aString
!

writeBool:bool 
    self writeByte:(bool ifTrue:[1] ifFalse:[0])
!

writeByte: aNumber
    aNumber > 16rFF ifTrue: [TError signal: 'writeByte too big'].
    Smalltalk isSmalltalkX ifTrue:[
        transport write: (ByteArray with: aNumber)
    ] ifFalse:[
        transport write: (Array with: aNumber)
    ].
!

writeBytes: aByteArray
    transport write: aByteArray
!

writeDouble: aDouble
    Smalltalk isSmalltalkX ifTrue:[
        "/ TODO: care for byteorder
        1 to:8 do:[:i | transport writeByte:(aDouble basicAt:i) ].
    ] ifFalse:[
        self writeI32: (aDouble basicAt: 1);
             writeI32: (aDouble basicAt: 2)
    ].
!

writeField:aField 
    self
        writeByte:aField type;
        writeI16:aField id
!

writeFieldBegin:aField 
    self
        writeByte:aField type;
        writeI16:aField id
!

writeFieldStop
    self writeByte:TTypeStop
!

writeI16:i16 
    self writeInt:i16 size:2
!

writeI32:i32 
    self writeInt:i32 size:4
!

writeI64:i64 
    self writeInt:i64 size:8
!

writeInt:val size:size 
    1 to:size do:[:n | 
        self writeByte:((val bitShift:(size negated + n) * 8) bitAnd:16rFF)
    ]
!

writeListBegin: aList
    self 
        writeByte: aList elemType; 
        writeI32: aList size
!

writeMapBegin:aMap 
    self
        writeByte:aMap keyType;
        writeByte:aMap valueType;
        writeI32:aMap size
!

writeMessageBegin: msg
    transport stream log:'>writeMessageBegin'.

    self 
        writeByte: PROTOCOL_ID;
        writeByte: ((VERSION bitAnd: VERSION_MASK) bitOr: ((msg type bitShift:TYPE_SHIFT) bitAnd:TYPE_MASK));
        writeVarInt: (msg seqid);
        writeString: msg name.

    transport stream log:'<writeMessageBegin'.
!

writeSetBegin:aSet 
    self
        writeByte:aSet elemType;
        writeI32:aSet size
!

writeString:aString 
    transport stream log:'>writeString'.
    self
        writeI32:aString size;
        write:aString.
    transport stream log:'<writeString'.
!

writeStructBegin: aStruct
    "intentionally left blank"
! !

!TCompactProtocol class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TCompactProtocol.st,v 1.1 2013-03-20 07:28:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TCompactProtocol.st,v 1.1 2013-03-20 07:28:56 cg Exp $'
! !


TCompactProtocol initialize!

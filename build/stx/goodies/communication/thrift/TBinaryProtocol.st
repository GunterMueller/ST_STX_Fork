"{ Package: 'stx:goodies/communication/thrift' }"

TProtocol subclass:#TBinaryProtocol
	instanceVariableNames:'strictRead strictWrite'
	classVariableNames:''
	poolDictionaries:'TConstants'
	category:'Net-Communication-Thrift-Protocol'
!


!TBinaryProtocol methodsFor:'constants'!

typeMask
    ^ 16r000000FF
!

version1
    ^ 16r80010000
!

versionMask
    ^ 16rFFFF0000
! !

!TBinaryProtocol methodsFor:'initialization'!

initialize
    strictRead := strictWrite := true.
! !

!TBinaryProtocol methodsFor:'reading'!

intFromByteArray:buf 
    |vals|

    vals := Array new:buf size.
    1 to:buf size do:[:n | 
        vals at:n put:((buf at:n) bitShift:(buf size - n) * 8)
    ].
    ^ vals sum
!

readBool
    ^ transport readByte ~~ 0
!

readByte
    ^ transport readByte
!

readDouble
    | val bytes |

    Smalltalk isSmalltalkX ifTrue:[
        bytes := transport read:8.
        val := Float basicNew.
        Float readBinaryIEEEDoubleFrom:(bytes readStream) into:val MSB:true.
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

    field := TField new type:transport readByte.
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
        elemType:transport readByte;
        size:self readI32
!

readMapBegin
    ^ (TMap new)
        keyType:transport readByte;
        valueType:transport readByte;
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
        elemType:transport readByte;
        size:self readI32
!

readString
    |sz|

    sz := self readI32.
    ^ sz > 0 ifTrue:[ (transport read:sz) asString ] ifFalse:[ '' ]
!

readStructBegin
!

unsignedInt:val size:size 
    ^ 0 - ((val - 1) bitXor:((2 raisedTo:(size * 8)) - 1))
! !

!TBinaryProtocol methodsFor:'writing'!

write:aString 
    transport write:aString
!

writeBool:bool 
    transport writeByte:(bool ifTrue:[1] ifFalse:[0])
!

writeByte: aNumber
    transport writeByte:aNumber
!

writeBytes: aByteArray
    transport write: aByteArray
!

writeDouble: aDouble
    |bytes|

    Smalltalk isSmalltalkX ifTrue:[
        bytes := ByteArray new:8.
        aDouble storeBinaryIEEEDouble:aDouble on:(WriteStream on:bytes) MSB:true.
        self writeBytes:bytes
    ] ifFalse:[
        self writeI32: (aDouble basicAt: 1);
             writeI32: (aDouble basicAt: 2)
    ].
!

writeField:aField
    transport writeByte:aField type.
    self writeI16:aField id
!

writeFieldBegin:aField 
    transport writeByte:aField type.
    self writeI16:aField id
!

writeFieldStop
    transport writeByte:TTypeStop
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
    transport writeByte:aList elemType.
    self writeI32: aList size
!

writeMapBegin:aMap 
    transport writeByte:aMap keyType.
    transport writeByte:aMap valueType.
    self writeI32:aMap size
!

writeMessageBegin: msg
    strictWrite ifTrue:[
        self 
            writeI32: (self version1 bitOr: msg type);
            writeString: msg name;
            writeI32: msg seqid
    ] ifFalse:[
        self 
            writeString: msg name;
            writeByte: msg type;
            writeI32: msg seqid
    ].
!

writeSetBegin:aSet 
    transport writeByte:aSet elemType.
    self writeI32:aSet size
!

writeString:aString 
    self writeI32:aString size.
    transport write:aString.
!

writeStructBegin: aStruct
    "intentionally left blank"
! !

!TBinaryProtocol class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TBinaryProtocol.st,v 1.5 2013-03-20 16:02:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TBinaryProtocol.st,v 1.5 2013-03-20 16:02:40 cg Exp $'
! !


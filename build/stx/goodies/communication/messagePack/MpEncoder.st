"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpEncoder
	instanceVariableNames:'writeStream typeMapper settings'
	classVariableNames:''
	poolDictionaries:'MpConstantsPool'
	category:'MessagePack-Core'
!

!MpEncoder class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!MpEncoder class methodsFor:'actions'!

encode: anObject 
	^self new encode: anObject
!

encode: anObject on: aStream
	^self new encode: anObject on: aStream
!

encode: anObject on: aStream setting: aBlock
	^self new encode: anObject on: aStream setting: aBlock
!

encode: anObject setting: settingBlock
	^self new encode: anObject setting: settingBlock
!

on: aStream
	^self new writeStream: aStream; yourself
!

onBytes: byteArray
	^self on: (WriteStream on: byteArray).
! !

!MpEncoder methodsFor:'accessing'!

contents
	^self writeStream contents
!

settings
	^settings ifNil: [settings := self settingsClass new]
!

typeMapper
	^ typeMapper
		ifNil: [typeMapper := self typeMapperClass on: self.
			self buildTypeMapper: typeMapper]
!

typeMapperClass
	^MpPortableUtil default encodeTypeMapperClass
!

writeStream
	writeStream isNil
		ifTrue: [writeStream := self createWriteStream].
	^ writeStream
!

writeStream: anObject
	"Set the value of writeStream"

	writeStream := anObject
! !

!MpEncoder methodsFor:'building'!

buildTypeMapper: aTypeMapper
	self settings formatVersion = 2008 ifTrue: [
		aTypeMapper bytesAsRaw.
		self settings stringAsBytes 
			ifTrue: [aTypeMapper stringAsBytes]
			ifFalse: [aTypeMapper stringAsError]
	].
	^aTypeMapper
	
! !

!MpEncoder methodsFor:'dispatching'!

writeObject: anObject 
	^self
		writeObject: anObject
		ifNotApplied: [self signalError]
!

writeObject: anObject ifNotApplied: aBlock 

	^self typeMapper writeObject: anObject ifNotApplied: aBlock
! !

!MpEncoder methodsFor:'encoding'!

encode: anObject
	^self encode: anObject on: self writeStream
!

encode: anObject on: aStream
	self write: anObject on: aStream.
	^self contents.
!

encode: anObject on: aStream setting: aBlock
	aBlock value: self settings.
	self write: anObject on: aStream.
	^self contents.
!

encode: anObject setting: aBlock
	^self encode: anObject on: self writeStream setting: aBlock 
!

write: anObject on: aStream
	self writeStream: aStream "binary".
	self writeObject: anObject
! !

!MpEncoder methodsFor:'factory'!

createWriteStream
	self settings fastBulkWrite ifTrue: [
		^MpMemoryWriteStream chunkSized: self settings defaultStreamSize.	
	].

	^WriteStream on: (ByteArray new: self settings defaultStreamSize).
	
	
!

settingsClass
	^MpSettings
! !

!MpEncoder methodsFor:'signaling error'!

signalError
	self signalError: 'Cannot encode'
!

signalError: message
	^MpPortableUtil default signalException: (MpError encode messageText: message) 
! !

!MpEncoder methodsFor:'stream-like'!

nextPut: anObject
	self writeObject: anObject
!

nextPutAll: aCollection
	aCollection do: [:each | self nextPut: each]
! !

!MpEncoder methodsFor:'writing'!

writeArray: array
	| size |
	size := array size.
	self writeArraySize: size.
	array do: [:each | self writeObject: each].
	
!

writeBinBytes: bytes
	| size |
	size := bytes size.
	self writeBinBytesSize: size.
	self writeStream nextPutAll: bytes
!

writeDouble: aFloat
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_double;
            nextPutIEEEDouble:aFloat MSB:true.
    ] ifFalse:[    
        self writeStream nextPut: MpConstants double.
        MpPortableUtil default writeDouble: aFloat to: self writeStream
    ]
!

writeFalse: ignore
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream nextPut: CODE_boolFalse
    ] ifFalse:[
        self writeStream nextPut: MpConstants boolFalse
    ].
!

writeFloat: aFloat
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_float;
            nextPutIEEESingle:aFloat MSB:true
    ] ifFalse:[        
        self writeStream nextPut: MpConstants float.
        MpPortableUtil default writeFloat: aFloat to: self writeStream
    ]
!

writeInteger: anInteger 
	(anInteger between: 0 and: 127)
		ifTrue: [^self writePositiveFixNum: anInteger].
		
	(anInteger between: -32 and: -1)
		ifTrue: [^self writeNegativeFixNum: anInteger].
	
	anInteger >= 128 ifTrue: [
		anInteger <= 255 ifTrue: [^self writeUint8: anInteger].
		anInteger <= 65535 ifTrue: [^self writeUint16: anInteger].
		anInteger <= 4294967295 ifTrue: [^self writeUint32: anInteger].
		anInteger <= 18446744073709551615 ifTrue: [^self writeUint64: anInteger].
	].
	
	anInteger >= -128 ifTrue: [^self writeInt8: anInteger].
	anInteger >= -32768 ifTrue: [^self writeInt16: anInteger].
	anInteger >= -2147483648 ifTrue: [^self writeInt32: anInteger].
	anInteger >= -9223372036854775808 ifTrue: [^self writeInt64: anInteger].
	
	self signalError
!

writeMap: aDictionary
	| size |
	size := aDictionary size.
	self writeMapSize: size.
	aDictionary keysAndValuesDo: [:key :value | self writeObject: key; writeObject: value].
!

writeNil: ignore
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream nextPut: CODE_undefinedNil
    ] ifFalse:[    
        self writeStream nextPut: MpConstants undefinedNil
    ]
!

writeRawBytes: bytes
	"Obsolete"
	self writeStrBytes: bytes
!

writeStrBytes: bytes
	| size |
	size := bytes size.
	self writeStrBytesSize: size.
	self writeStream nextPutAll: bytes
!

writeTrue: ignore
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream nextPut: CODE_boolTrue
    ] ifFalse:[
        self writeStream nextPut: MpConstants boolTrue
    ]
! !

!MpEncoder methodsFor:'writing-ext'!

writeExt16: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_ext16;
            nextPutInt16:data size MSB:true;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[
        self writeStream nextPut: MpConstants ext16.
        MpPortableUtil default writeUint16: data size to: self writeStream.
        self writeStream
                nextPut: type;
                nextPutAll: data
    ]
!

writeExt32: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream
            nextPut: CODE_ext32;
            nextPutInt32: data size MSB:true;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[
        self writeStream nextPut: MpConstants ext32.
        MpPortableUtil default writeUint32: data size to: self writeStream.
        self writeStream
                nextPut: type;
                nextPutAll: data
    ]
!

writeExt8: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream
            nextPut: CODE_ext8;
            nextPut: data size;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[
        self writeStream nextPut: MpConstants ext8;
                nextPut: data size;
                nextPut: type;
                nextPutAll: data
    ]
!

writeExt: mpExtValue
	^self writeExt: mpExtValue data as: mpExtValue typeCode
!

writeExt: data as: type
	| sz |
	sz := data size.
	sz < 256 ifTrue: [^self writeExt8: data as: type].
	sz < 65536 ifTrue: [^self writeExt16: data as: type].
	sz < 4294967296 ifTrue: [^self writeExt32: data as: type].
! !

!MpEncoder methodsFor:'writing-fixext'!

writeFixext16: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_fixext16;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[        
        self writeStream nextPut: MpConstants fixext16;
                nextPut: type;
                nextPutAll: data
    ]
!

writeFixext1: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_fixext1;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[        
        self writeStream nextPut: MpConstants fixext1;
                nextPut: type;
                nextPutAll: data
    ]
!

writeFixext2: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_fixext2;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[        
        self writeStream nextPut: MpConstants fixext2;
                nextPut: type;
                nextPutAll: data
    ]
!

writeFixext4: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_fixext4;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[        
        self writeStream nextPut: MpConstants fixext4;
                nextPut: type;
                nextPutAll: data
    ]
!

writeFixext8: data as: type
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_fixext8;
            nextPut: type;
            nextPutAll: data
    ] ifFalse:[        
        self writeStream nextPut: MpConstants fixext8;
                nextPut: type;
                nextPutAll: data
    ]
!

writeFixext: mpFixextValue
	^self writeFixext: mpFixextValue data as: mpFixextValue typeCode
!

writeFixext: data as: type
	| sz |
	sz := data size.
	sz = 1 ifTrue: [^self writeFixext1: data as: type].
	sz = 2 ifTrue: [^self writeFixext2: data as: type].
	sz = 4 ifTrue: [^self writeFixext4: data as: type].
	sz = 8 ifTrue: [^self writeFixext8: data as: type].
	sz = 16 ifTrue: [^self writeFixext16: data as: type].
	
	self signalError
! !

!MpEncoder methodsFor:'writing-helper'!

writeArraySize: size
        size < 16r10 ifTrue: [^ self writeStream nextPut: (2r10010000 bitOr: size)].
        size < 16r10000  ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self writeStream 
                    nextPut: CODE_array16;
                    nextPutInt16: size MSB:true.
                ^ self
            ] ifFalse:[        
                self writeStream nextPut: MpConstants array16.
                ^MpPortableUtil default writeUint16: size to: self writeStream
            ].
        ].
        size < 16r100000000  ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self writeStream 
                    nextPut: CODE_array32;
                    nextPutInt32: size MSB:true.
                ^ self
            ] ifFalse:[        
                self writeStream nextPut: MpConstants array32.
                ^MpPortableUtil default writeUint32: size to: self writeStream
            ].
        ].
        
        self signalError
!

writeBinBytesSize:size 
    size < 16r10 ifTrue:[
        (self writeStream)
            nextPut:CODE_bin8 "MpConstants bin8";
            nextPut:size.
        ^ self
    ].
    size < 16r10000 ifTrue:[
        Smalltalk isSmalltalkX ifTrue:[
            (self writeStream)
                nextPut:CODE_bin16 "MpConstants bin16";
                nextPutInt16:size MSB:true.
            ^ self
        ] ifFalse:[
            self writeStream nextPut:MpConstants bin16.
            ^ MpPortableUtil default writeUint16:size to:self writeStream
        ].
    ].
    size < 16r100000000 ifTrue:[
        Smalltalk isSmalltalkX ifTrue:[
            (self writeStream)
                nextPut:CODE_bin32 "MpConstants bin32";
                nextPutInt32:size MSB:true.
            ^ self
        ] ifFalse:[
            self writeStream nextPut:MpConstants bin32.
            ^ MpPortableUtil default writeUint32:size to:self writeStream
        ].
    ].
    self signalError
!

writeInt16: value
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_int16;
            nextPutInt16:value MSB:true.
    ] ifFalse:[            
        self writeStream nextPut: MpConstants int16.
        MpPortableUtil default writeInt16: value to: self writeStream
    ]
!

writeInt32: value
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_int32;
            nextPutInt32:value MSB:true.
    ] ifFalse:[    
        self writeStream nextPut: MpConstants int32.
        MpPortableUtil default writeInt32: value to: self writeStream
    ]
!

writeInt64: value
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_int64;
            nextPutInt64:value MSB:true.
    ] ifFalse:[    
        self writeStream nextPut: MpConstants int64.
        MpPortableUtil default writeInt64: value to: self writeStream
    ].    
!

writeInt8: value
        | val |
        Smalltalk isSmalltalkX ifTrue:[
            self writeStream nextPut: CODE_int8.
        ] ifFalse:[    
            self writeStream nextPut: MpConstants int8.
        ].    
        val := value < 0 ifTrue: [256 + value] ifFalse: [value].
        self writeStream nextPut: val
!

writeMapSize: size
        size < 16r10 ifTrue: [^ self writeStream nextPut: (2r10000000 bitOr: size)].
        size < 16r10000  ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self 
                    writeStream nextPut: CODE_map16;
                    nextPutInt16:size MSB:true.
                ^ self
            ] ifFalse:[    
                self writeStream nextPut: MpConstants map16.
                ^MpPortableUtil default writeUint16: size to: self writeStream
            ].
        ].
        size < 16r100000000  ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self 
                    writeStream nextPut: CODE_map32;
                    nextPutInt32:size MSB:true.
                ^ self
            ] ifFalse:[    
                self writeStream nextPut: MpConstants map32.
                ^MpPortableUtil default writeUint32: size to: self writeStream
            ].
        ].
        
        self signalError
!

writeNegativeFixNum: number
	"-32 to -1"
	| val |
	val :=  256 + number.
	self writeStream nextPut: val
!

writePositiveFixNum: number

	self writeStream nextPut: number
	
!

writeStrBytesSize: size
        size < 16r10 ifTrue: [
            self writeStream nextPut: (2r10100000 bitOr: size).
            ^ self    
        ].
        size < 16r10000  ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self writeStream 
                    nextPut: CODE_str16;
                    nextPutInt16: size MSB:true.
                ^ self    
            ] ifFalse:[    
                self writeStream nextPut: MpConstants str16.
                ^MpPortableUtil default writeUint16: size to: self writeStream
            ].
        ].
        size < 16r100000000  ifTrue: [
            Smalltalk isSmalltalkX ifTrue:[
                self writeStream 
                    nextPut: CODE_str32;
                    nextPutInt32: size MSB:true.
                ^ self    
            ] ifFalse:[    
                self writeStream nextPut: MpConstants str32.
                ^MpPortableUtil default writeUint32: size to: self writeStream
            ].
        ].
        
        self signalError
!

writeUint16: value
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_uint16;
            nextPutInt16:value MSB:true
    ] ifFalse:[
        self writeStream nextPut: MpConstants uint16.
        MpPortableUtil default writeUint16: value to: self writeStream
    ]
!

writeUint32: value
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_uint32;
            nextPutInt32:value MSB:true
    ] ifFalse:[
        self writeStream nextPut: MpConstants uint32.
        MpPortableUtil default writeUint32: value to: self writeStream
    ]
!

writeUint64: value
    Smalltalk isSmalltalkX ifTrue:[
        self writeStream 
            nextPut: CODE_uint64;
            nextPutInt64:value MSB:true
    ] ifFalse:[
        self writeStream nextPut: MpConstants uint64.
        MpPortableUtil default writeUint64: value to: self writeStream
    ]
!

writeUint8: value
	self writeStream nextPut: MpConstants uint8.
	self writeStream nextPut: value
!

writeUnknown: unknown withHandler: aBlock
	| mode |
	mode := self settings encodeMode.
	mode == #strict ifTrue: [^aBlock value].
	mode == #unknownAsNil ifTrue: [^self writeNil: unknown].
	mode == #loose ifTrue: [^self writeObject: unknown asMpConverted].
	
	"If non supported mode, we just use handler"
	^aBlock value
	
! !

!MpEncoder methodsFor:'writing-string'!

writeString: aString
	self writeStrBytes: aString asByteArray
!

writeWideString: aString
	self writeStrBytes: (MpPortableUtil default bytesFromString: aString)
! !

!MpEncoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpEncoder.st,v 1.2 2018-05-08 11:02:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpEncoder.st,v 1.2 2018-05-08 11:02:12 cg Exp $'
! !


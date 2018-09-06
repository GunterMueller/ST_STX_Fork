"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpDecoder
	instanceVariableNames:'readStream typeMapper settings'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpDecoder class methodsFor:'actions'!

decode: byteArray
	^self new decode: byteArray
!

decode: byteArray setting: settingBlock 
	^self new decode: byteArray setting: settingBlock 
!

decodeFrom: aStream
	^self new decodeFrom: aStream
!

decodeFrom: aStream setting: settingBlock 
	^self new decodeFrom: aStream setting: settingBlock 
!

on: aStream
	^self new readStream: aStream "binary"
!

onBytes: byteArray
	^self on: (ReadStream on: byteArray)
! !

!MpDecoder methodsFor:'accessing'!

readStream
	"Answer the value of readStream"

	^ readStream
!

readStream: anObject
	"Set the value of readStream"

	readStream := anObject
!

settings
	^settings ifNil: [settings := self settingsClass new]
!

typeMapper
	^ typeMapper
		ifNil: [typeMapper := self typeMapperClass on: self.
			self buildTypeMapper: typeMapper]
! !

!MpDecoder methodsFor:'building'!

buildTypeMapper: aTypeMapper
	self settings formatVersion = 2008 ifTrue: [
		aTypeMapper bytesAsRaw.
		self settings bytesAsString ifTrue: [aTypeMapper bytesAsString].
	].
	^ aTypeMapper
! !

!MpDecoder methodsFor:'decoding'!

decode
	self readStream atEnd ifTrue: [^self signalError: 'No data to read'].
	^self read
!

decode: byteArray
	^self decodeFrom: byteArray readStream
!

decode: byteArray setting: settingBlock 
	settingBlock value: self settings.
	^self decodeFrom: byteArray readStream
!

decodeFrom: aStream
	self readStream: aStream "binary".
	^self decode
!

decodeFrom: aStream setting: settingBlock
	settingBlock value: self settings.
	self readStream: aStream "binary".
	^self decode
! !

!MpDecoder methodsFor:'dispatching'!

readObject
	| type |
	type := self readType.
	^ self readObjectOf: type
	
!

readObjectOf: type
	^ self readObjectOf: type ifNotApplied: [self signalError]
	
	
!

readObjectOf: type ifNotApplied: aBlock
	
	type <=16rBF ifTrue: [ | fixMapOrArray |
		type <= 16r7F ifTrue: [^ self readPositiveFixNum: type].
		fixMapOrArray := type bitShift: -4.
		fixMapOrArray = 2r1000 ifTrue: [^ self readFixMap: type].
		fixMapOrArray = 2r1001 ifTrue: [^ self readFixArray: type].
		^ self readFixStr: type.
	].
	(type bitShift: -5) = 2r111 ifTrue: [^ self readNegativeFixNum: type].
	^self typeMapper readObjectOf: type ifNotApplied: aBlock
! !

!MpDecoder methodsFor:'factory'!

createArray: size
	^Array new: size
!

createDictionary: size
	^Dictionary new: size
!

createOrderedCollection: size
	^OrderedCollection new: size
!

settingsClass
	^MpSettings
!

typeMapperClass
	^MpDecodeTypeMapper
! !

!MpDecoder methodsFor:'reading'!

read
	^self readObject.
	
!

readArray16
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt16MSB:true.
    ] ifFalse:[
        size := MpPortableUtil default readUint16From: self readStream.
    ].
    ^ self readArraySized: size
!

readArray32
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt32MSB:true.
    ] ifFalse:[    
        size := MpPortableUtil default readUint32From: self readStream.
    ].
    ^ self readArraySized: size
!

readBin16
    | size |
        
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt16MSB:true.
        ^readStream next: size
    ] ifFalse:[    
        size := MpPortableUtil default readUint16From: self readStream.
        ^self readStream next: size
    ]
!

readBin32
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt32MSB:true.
        ^readStream next: size
    ] ifFalse:[    
        size := MpPortableUtil default readUint32From: self readStream.
        ^self readStream next: size
    ]
!

readBin8
        | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream next.
        ^readStream next: size
    ] ifFalse:[    
        size := self readStream next.
        ^(self readStream next: size)
    ]
!

readDouble
        "64 bit"
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextIEEEDoubleMSB:true.
    ] ifFalse:[    
        ^MpPortableUtil default readDoubleFrom: self readStream
    ].
!

readFalse
	^false
!

readFixArray: firstByte
	| size |
	size := (firstByte bitAnd: 2r1111).
	^ self readArraySized: size
!

readFixMap: firstByte
	| size |
	size := (firstByte bitAnd: 2r1111).
	^self readMapSized: size
!

readFixRaw: firstByte
	| size |
	self typeMapper isBytesAsString ifTrue: [^self readFixString: firstByte].
	size := (firstByte bitAnd: 2r11111).
	^self readStream next: size
!

readFixStr: firstByte
	self settings formatVersion = 2008 ifTrue: [^self readFixRaw: firstByte].
	^self readFixString: firstByte
!

readFloat
        "32 bit"
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextIEEESingleMSB:true.
    ] ifFalse:[    
        ^MpPortableUtil default readFloatFrom: self readStream
    ]
!

readMap16
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt16MSB:true.
    ] ifFalse:[    
        size := MpPortableUtil default readUint16From: self readStream.
    ].
    ^ self readMapSized: size
!

readMap32
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt32MSB:true.
    ] ifFalse:[    
        size := MpPortableUtil default readUint32From: self readStream.
    ].
    ^ self readMapSized: size
!

readNegativeFixNum: firstByte
	| val |
	val := (firstByte bitAnd: 2r11111).
	^ val - 32
!

readNil
	^nil
!

readPositiveFixNum: firstByte
	"0 - 127"
	^ firstByte
!

readRaw16
    "Obsolete"
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt16MSB:true.
    ] ifFalse:[    
        size := MpPortableUtil default readUint16From: self readStream.
    ].
    ^self readStream next: size
!

readRaw32
    "Obsolete"
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt32MSB:true.
    ] ifFalse:[    
        size := MpPortableUtil default readUint32From: self readStream.
    ].
    ^self readStream next: size
!

readStr16
	^self readString16
!

readStr32
	^self readString32
!

readStr8
	^self readString8
!

readTrue
	^true
! !

!MpDecoder methodsFor:'reading-ext'!

readExt16
    | size type |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt16MSB:true.
        type := readStream next.
    ] ifFalse:[
        size := MpPortableUtil default readUint16From: self readStream.
        type := self readStream next.
    ].
    ^self readExtSized: size as: type
!

readExt32
    | size type |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt32MSB:true.
        type := readStream next.
    ] ifFalse:[
        size := MpPortableUtil default readUint32From: self readStream.
        type := self readStream next.
    ].
    ^self readExtSized: size as: type
!

readExt8
    | size type |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream next.
        type := readStream next.
    ] ifFalse:[
        size := self readStream next.
        type := self readStream next.
    ].
    ^self readExtSized: size as: type
!

readExtSized: size as: type
	^MpExtValue typeCode: type data: (self readStream next: size)
! !

!MpDecoder methodsFor:'reading-fixext'!

readFixext1
	| data type |
	type := self readStream next.
	data := ByteArray with: self readStream next.
	^self readFixext: data as: type
!

readFixext16
	| data type |
	type := self readStream next.
	data := self readStream next: 16.
	^self readFixext: data as: type
!

readFixext2
	| data type |
	type := self readStream next.
	data := self readStream next: 2.
	^self readFixext: data as: type
!

readFixext4
	| data type |
	type := self readStream next.
	data := self readStream next: 4.
	^self readFixext: data as: type
!

readFixext8
	| data type |
	type := self readStream next.
	data := self readStream next: 8.
	^self readFixext: data as: type
!

readFixext: data as: type
	^MpFixextValue typeCode: type data: data
! !

!MpDecoder methodsFor:'reading-helper'!

readArraySized: size
	| array |
	array := self createArray: size.
	1 to: size do: [:idx |
		array at: idx put: (self readObject)
	].
	^array
!

readMapSized: size
	| dic |
	dic := self createDictionary: size.
	size timesRepeat: [
		dic at: self readObject put: self readObject
	].
	^dic
!

readType
	^self readStream next
! !

!MpDecoder methodsFor:'reading-integer'!

readInt16
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextInt16MSB:true    
    ] ifFalse:[
        ^ MpPortableUtil default readInt16From: self readStream
    ].
!

readInt32
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextInt32MSB:true    
    ] ifFalse:[
        ^ MpPortableUtil default readInt32From: self readStream
    ].
!

readInt64
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextInt64MSB:true    
    ] ifFalse:[
        ^ MpPortableUtil default readInt64From: self readStream
    ].
!

readInt8
    | val |
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextSignedByte    
    ] ifFalse:[
        val := self readStream next.
        val >= 128 ifTrue: [^(256 - val) negated].
        ^val
    ].    
!

readUint16
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextUnsignedInt16MSB:true    
    ] ifFalse:[
        ^ MpPortableUtil default readUint16From: self readStream
    ]
!

readUint32
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextUnsignedInt32MSB:true    
    ] ifFalse:[
        ^ MpPortableUtil default readUint32From: self readStream
    ]
!

readUint64
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream nextUnsignedInt64MSB:true    
    ] ifFalse:[
        ^ MpPortableUtil default readUint64From: self readStream
    ]
!

readUint8
    Smalltalk isSmalltalkX ifTrue:[
        ^ readStream next    
    ] ifFalse:[
        ^ self readStream next
    ]
! !

!MpDecoder methodsFor:'reading-string'!

readFixString: firstByte
    | size |
    size := (firstByte bitAnd: 2r11111).
    Smalltalk isSmalltalkX ifTrue:[
        ^(readStream nextString: size)
    ] ifFalse:[    
        ^(self readStream next: size) asString
    ].
!

readString16
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt16MSB:true.    
        ^(readStream nextString: size)
    ] ifFalse:[
        size := MpPortableUtil default readUint16From: self readStream.
        ^(self readStream next: size) asString
    ]
!

readString32
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream nextUnsignedInt32MSB:true.    
        ^(readStream nextString: size)
    ] ifFalse:[
        size := MpPortableUtil default readUint32From: self readStream.
        ^(self readStream next: size) asString
    ]
!

readString8
    | size |
    Smalltalk isSmalltalkX ifTrue:[
        size := readStream next.    
        ^(readStream nextString: size)
    ] ifFalse:[
        size := self readStream next.
        ^(self readStream next: size) asString
    ]
! !

!MpDecoder methodsFor:'signaling error'!

signalError
	self signalError: 'Cannot decode'
!

signalError: message
	^MpPortableUtil default signalException: (MpError decode messageText: message) 
! !

!MpDecoder methodsFor:'stream-like'!

atEnd
	^self readStream atEnd
!

next
	^self read
! !

!MpDecoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpDecoder.st,v 1.2 2018-05-08 11:02:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpDecoder.st,v 1.2 2018-05-08 11:02:07 cg Exp $'
! !


"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

MpPortableUtil subclass:#MpSqPortableUtil
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Squeak-Core'
!


!MpSqPortableUtil class methodsFor:'class initialization'!

initialize
	"MpSqPortableUtil initialize"
	super initialize.
	MpPortableUtil dialectSpecificClass: self
! !

!MpSqPortableUtil methodsFor:'actions'!

bytesFromString: aString
	aString isWideString ifTrue: [^(aString convertToEncoding: #utf8) asByteArray].
	^super bytesFromString: aString
! !

!MpSqPortableUtil methodsFor:'actions-stream'!

readDoubleFrom: stream
	| float |
	float := Float new: 2.
	float at: 1 put: (stream nextNumber: 4).
	float at: 2 put: (stream nextNumber: 4).
	^float
!

readFloatFrom: stream
	"32 bit"
	^ Float fromIEEE32Bit: (stream nextNumber: 4)
!

readInt16From: stream
	^stream int16
!

readInt32From: stream
	^stream int32
!

readInt64From: stream
	^stream int64
!

readUint16From: stream
	^stream uint16
!

readUint32From: stream
	^stream uint32
!

readUint64From: stream
	^stream uint64
!

writeDouble: value to: stream
	self writeUint32: (value at:1) to: stream.
	self writeUint32: (value at:2) to: stream.
	
!

writeFloat: value to: stream
	self writeInt32: value asIEEE32BitWord to: stream
!

writeInt16: value to: stream
	stream int16: value
!

writeInt32: value to: stream
	stream int32: value
!

writeInt64: value to: stream
	stream int64: value
!

writeUint16: value to: stream
	stream uint16: value
!

writeUint32: value to: stream
	stream uint32: value
!

writeUint64: value to: stream
	stream uint64: value
! !

!MpSqPortableUtil methodsFor:'factory'!

encodeTypeMapperClass
    Smalltalk isSmalltalkX ifTrue:[
        ^MpSTXEncodeTypeMapper
    ].
    ^MpSqEncodeTypeMapper
! !

!MpSqPortableUtil class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSqPortableUtil.st,v 1.3 2018-05-08 15:58:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSqPortableUtil.st,v 1.3 2018-05-08 15:58:05 cg Exp $'
! !


MpSqPortableUtil initialize!

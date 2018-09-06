"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpPortableUtil
	instanceVariableNames:''
	classVariableNames:'Default DialectSpecificClass'
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpPortableUtil class methodsFor:'instance creation'!

default
	^Default ifNil: [Default := self dialectSpecificClass new]
! !

!MpPortableUtil class methodsFor:'class initialization'!

initialize
	Default := nil.
	DialectSpecificClass := nil
! !

!MpPortableUtil class methodsFor:'factory'!

dialectSpecificClass
	^DialectSpecificClass ifNil: [DialectSpecificClass := self subclasses at: 1]
!

dialectSpecificClass: aClass
	DialectSpecificClass := aClass
! !

!MpPortableUtil methodsFor:'actions'!

bytesFromString: aString
	^aString asByteArray
!

signalException: anException
	"Ansi"

	^anException signal
! !

!MpPortableUtil methodsFor:'actions-stream'!

readDoubleFrom: stream
	self subclassResponsibility 
!

readFloatFrom: stream
	self subclassResponsibility 
!

readInt16From: stream
	self subclassResponsibility 
!

readInt32From: stream
	self subclassResponsibility 
!

readInt64From: stream
	self subclassResponsibility 
!

readUint16From: stream
	self subclassResponsibility 
!

readUint32From: stream
	self subclassResponsibility 
!

readUint64From: stream
	self subclassResponsibility 
!

writeDouble: value to: stream
	self subclassResponsibility 
!

writeFloat: value to: stream
	self subclassResponsibility 
!

writeInt16: value to: stream
	self subclassResponsibility 
!

writeInt32: value to: stream
	self subclassResponsibility 
!

writeInt64: value to: stream
	self subclassResponsibility 
!

writeUint16: value to: stream
	self subclassResponsibility 
!

writeUint32: value to: stream
	self subclassResponsibility 
!

writeUint64: value to: stream
	self subclassResponsibility 
! !

!MpPortableUtil methodsFor:'defaults'!

useFastBulkWrite
	^ false
! !

!MpPortableUtil methodsFor:'factory'!

encodeTypeMapperClass
	^MpEncodeTypeMapper
!

newCollection: aCollectionClass sized: size withAll: elem
	"For testing"
	^ aCollectionClass new: size withAll: elem
!

randomClass
	"For testing"
	^Smalltalk at: #Random
! !

!MpPortableUtil methodsFor:'testing'!

collectionEquals: aCollection with: otherCollection
	"For testing"
	^ aCollection = otherCollection
! !

!MpPortableUtil class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpPortableUtil.st,v 1.2 2018-05-08 11:02:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpPortableUtil.st,v 1.2 2018-05-08 11:02:06 cg Exp $'
! !


MpPortableUtil initialize!

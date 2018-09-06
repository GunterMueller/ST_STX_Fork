"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

MpTypeMapper subclass:#MpEncodeTypeMapper
	instanceVariableNames:'encoder'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpEncodeTypeMapper class methodsFor:'instance creation'!

on: mpEncoder 
	^ self new encoder: mpEncoder;
		 initActionMaps;
		 yourself
! !

!MpEncodeTypeMapper class methodsFor:'actions for compounds'!

defineArrayActionTo: map
	map at: Array put: #writeArray:.
!

defineCompoundsActionsTo: map
	self defineArrayActionTo: map.
	self defineMapActionTo: map.
	
!

defineMapActionTo: map	
	map at: Dictionary put: #writeMap:.
	"map at: IdentityDictionary put: #writeDictionary:"
	
	
! !

!MpEncodeTypeMapper class methodsFor:'actions for exts'!

defineExtsActionsTo: map
	map at: MpExtValue put: #writeExt:.
	map at: MpFixextValue put: #writeFixext:
! !

!MpEncodeTypeMapper class methodsFor:'actions for primitives'!

defineBinBytesActionTo: map
	map at: ByteArray put: #writeBinBytes:
!

defineDoubleActionTo: map
	"Some dialect does not support Double"
	"map at: Double put: #writeDouble:"
!

defineFalseActionTo: map
	map at: False put: #writeFalse:
!

defineFloatActionTo: map
	"Suppose 32 bit float - Some dialect does not support it"
	"map at: Float put: #writeFloat:"
!

defineIntegerActionTo: map
	Integer allSubclasses do: [:each |
		map at: each put: #writeInteger:
	]
!

defineNilActionTo: map
	map at: UndefinedObject put: #writeNil:
!

definePrimitivesActionsTo: map
	self defineNilActionTo: map.
	self defineTrueActionTo: map.
	self defineFalseActionTo: map.
	self defineIntegerActionTo: map.
	self defineFloatActionTo: map.
	self defineDoubleActionTo: map.
	self defineBinBytesActionTo: map.
	self defineStrBytesActionTo: map.
!

defineStrBytesActionTo: map
	map at: String put: #writeStrBytes:
!

defineTrueActionTo: map
	map at: True put: #writeTrue:
! !

!MpEncodeTypeMapper methodsFor:'accessing'!

encoder
	"Answer the value of encoder"

	^ encoder
!

encoder: anObject
	"Set the value of encoder"

	encoder := anObject
! !

!MpEncodeTypeMapper methodsFor:'actions'!

writeObject: anObject ifNotApplied: aBlock 
	| actionSelector |
	actionMap
		ifNotNil: [actionSelector := self actionMap at: anObject class ifAbsent: [].
			actionSelector ifNotNil: [^ self encoder perform: actionSelector with: anObject]].
		
	actionSelector := anObject mpWriteSelector.
	actionSelector ifNil: [
		actionSelector := self defaultActionMap at: anObject class ifAbsent: [^ self encoder writeUnknown: anObject withHandler: aBlock ]
	].
	^ self encoder perform: actionSelector with: anObject
! !

!MpEncodeTypeMapper methodsFor:'encode customization'!

bytesAsRaw
    "For older MP specification"
    self actionMap at: ByteArray put: #writeRawBytes:.
!

stringAsBytes
	self actionMap at: String put: #writeString:
!

stringAsError
	"For older MP specification"
! !

!MpEncodeTypeMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpEncodeTypeMapper.st,v 1.3 2018-05-08 16:20:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpEncodeTypeMapper.st,v 1.3 2018-05-08 16:20:13 cg Exp $'
! !


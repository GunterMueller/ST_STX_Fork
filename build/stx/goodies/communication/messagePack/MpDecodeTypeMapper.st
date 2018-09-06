"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

MpTypeMapper subclass:#MpDecodeTypeMapper
	instanceVariableNames:'decoder isBytesAsString'
	classVariableNames:''
	poolDictionaries:'MpConstantsPool'
	category:'MessagePack-Core'
!

!MpDecodeTypeMapper class methodsFor:'documentation'!

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

!MpDecodeTypeMapper class methodsFor:'instance creation'!

on: mpDecoder 
	^ self new decoder: mpDecoder;
		 initActionMaps;
		 yourself
! !

!MpDecodeTypeMapper class methodsFor:'actions for compounds'!

defineArrayActionTo: map
        map at: CODE_array16 "MpConstants array16" put: #readArray16.
        map at: CODE_array32 "MpConstants array32" put: #readArray32.
!

defineCompoundsActionsTo: map
	self defineArrayActionTo: map.
	self defineMapActionTo: map.
!

defineMapActionTo: map  
        map at: CODE_map16 "MpConstants map16" put: #readMap16.
        map at: CODE_map32 "MpConstants map32" put: #readMap32.
! !

!MpDecodeTypeMapper class methodsFor:'actions for exts'!

defineExtsActionsTo: map
        map at: CODE_fixext1 "MpConstants fixext1" put: #readFixext1.
        map at: CODE_fixext2 "MpConstants fixext2" put: #readFixext2.
        map at: CODE_fixext4 "MpConstants fixext4" put: #readFixext4.
        map at: CODE_fixext8 "MpConstants fixext8" put: #readFixext8.
        map at: CODE_fixext16 "MpConstants fixext16" put: #readFixext16.
        map at: CODE_ext8 "MpConstants ext8" put: #readExt8.
        map at: CODE_ext16 "MpConstants ext16" put: #readExt16.
        map at: CODE_ext32 "MpConstants ext32" put: #readExt32.
! !

!MpDecodeTypeMapper class methodsFor:'actions for primitives'!

defineBinBytesActionTo: map
        map at: CODE_bin8 "MpConstants bin8" put: #readBin8.
        map at: CODE_bin16 "MpConstants bin16" put: #readBin16.
        map at: CODE_bin32 "MpConstants bin32" put: #readBin32.
!

defineDoubleActionTo: map
        map at: CODE_double "MpConstants double" put: #readDouble
!

defineFalseActionTo: map
        map at: CODE_boolFalse "MpConstants boolFalse" put: #readFalse
!

defineFloatActionTo: map
        map at: CODE_float "MpConstants float" put: #readFloat
!

defineIntegerActionTo: map
        map at: CODE_int8 "MpConstants int8" put: #readInt8.
        map at: CODE_int16 "MpConstants int16" put: #readInt16.
        map at: CODE_int32 "MpConstants int32" put: #readInt32.
        map at: CODE_int64 "MpConstants int64" put: #readInt64.
!

defineNilActionTo: map
        map at: CODE_undefinedNil "MpConstants undefinedNil" put: #readNil
!

definePrimitivesActionsTo: map
	self defineNilActionTo: map.
	self defineTrueActionTo: map.
	self defineFalseActionTo: map.
	self defineFloatActionTo: map.
	self defineDoubleActionTo: map.
	self defineUnsignedIntegerActionTo: map.
	self defineIntegerActionTo: map.
	self defineBinBytesActionTo: map.
	self defineStrBytesActionTo: map.
	
!

defineStrBytesActionTo: map
        map at: CODE_str8 "MpConstants str8" put: #readStr8.
        map at: CODE_str16 "MpConstants str16" put: #readStr16.
        map at: CODE_str32 "MpConstants str32" put: #readStr32.
!

defineTrueActionTo: map
        map at: CODE_boolTrue "MpConstants boolTrue" put: #readTrue
!

defineUnsignedIntegerActionTo: map
        map at: CODE_uint8 "MpConstants uint8" put: #readUint8.
        map at: CODE_uint16 "MpConstants uint16" put: #readUint16.
        map at: CODE_uint32 "MpConstants uint32" put: #readUint32.
        map at: CODE_uint64 "MpConstants uint64" put: #readUint64.
! !

!MpDecodeTypeMapper methodsFor:'accessing'!

decoder
	"Answer the value of decoder"

	^ decoder
!

decoder: anObject
	"Set the value of decoder"

	decoder := anObject
!

isBytesAsString: aBoolean

	isBytesAsString := aBoolean == true
! !

!MpDecodeTypeMapper methodsFor:'actions'!

readObjectOf: typeCode ifNotApplied: aBlock 
	| actionSelector |
	
	actionMap
		ifNotNil: [actionSelector := self actionMap at: typeCode ifAbsent: [].
			actionSelector ifNotNil: [^ self decoder perform: actionSelector]].
	
	actionSelector := self defaultActionMap
				at: typeCode
				ifAbsent: [^ aBlock value].
	^ self decoder perform: actionSelector
! !

!MpDecodeTypeMapper methodsFor:'decode customization'!

bytesAsRaw
        "For older MP specification"
        | map |
        map := self actionMap.
        map at: CODE_str8 "MpConstants str8" put: #signalError.
        map at: CODE_str16 "MpConstants str16" put: #readRaw16.
        map at: CODE_str32 "MpConstants str32" put: #readRaw32.
        
        self isBytesAsString: false
!

bytesAsString
        | map |
        map := self actionMap.
        map at: CODE_str8 "MpConstants str8" put: #readString8.
        map at: CODE_str16 "MpConstants str16" put: #readString16.
        map at: CODE_str32 "MpConstants str32" put: #readString32.
        
        self isBytesAsString: true
!

isBytesAsString
	isBytesAsString ifNil: [isBytesAsString := false].
	^ isBytesAsString
! !

!MpDecodeTypeMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpDecodeTypeMapper.st,v 1.4 2018-05-08 11:01:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpDecodeTypeMapper.st,v 1.4 2018-05-08 11:01:39 cg Exp $'
! !


"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

MpEncodeTypeMapper subclass:#MpSqEncodeTypeMapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Squeak-Core'
!


!MpSqEncodeTypeMapper class methodsFor:'actions for primitives'!

defineDoubleActionTo: map
        map at: Float put: #writeDouble:.
        map at: BoxedFloat64 put: #writeDouble:.
        map at: SmallFloat64 put: #writeDouble:
!

defineStrBytesActionTo: map
        map at: ByteString put: #writeString:.
        map at: WideString put: #writeWideString:.
! !

!MpSqEncodeTypeMapper methodsFor:'encode customization'!

stringAsBytes
        self actionMap at: ByteString put: #writeString:.
        self actionMap at: WideString put: #writeWideString:.
        self actionMap at: ByteSymbol put: #writeString:.
        self actionMap at: WideSymbol put: #writeWideString:.
!

stringAsError
        self actionMap at: ByteString put: #signalError:.
        self actionMap at: WideString put: #signalError:.
        self actionMap at: ByteSymbol put: #signalError:.
        self actionMap at: WideSymbol put: #signalError:.
! !

!MpSqEncodeTypeMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSqEncodeTypeMapper.st,v 1.5 2018-05-08 15:36:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSqEncodeTypeMapper.st,v 1.5 2018-05-08 15:36:46 cg Exp $'
! !


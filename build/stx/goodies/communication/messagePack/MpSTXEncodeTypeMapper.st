"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

MpEncodeTypeMapper subclass:#MpSTXEncodeTypeMapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Squeak-Core'
!


!MpSTXEncodeTypeMapper class methodsFor:'actions for compounds'!

defineArrayActionTo: map
    super defineArrayActionTo: map.
    map at: ImmutableArray put: #writeArray:.
    map at: FloatArray put: #writeArray:.
    map at: DoubleArray put: #writeArray:.
    map at: IntegerArray put: #writeArray:.
!

defineMapActionTo: map  
        map at: Dictionary put: #writeMap:.
        map at: IdentityDictionary put: #writeMap:
! !

!MpSTXEncodeTypeMapper class methodsFor:'actions for primitives'!

defineBinBytesActionTo: map
    super defineBinBytesActionTo: map.

    map at: ImmutableByteArray put: #writeBinBytes:
!

defineDoubleActionTo: map
    map at: Float put: #writeDouble:.
    map at: ShortFloat put: #writeFloat:.
!

defineStrBytesActionTo: map
    map at: String put: #writeString:.
    map at: ImmutableString put: #writeString:.
    map at: Unicode16String put: #writeWideString:
! !

!MpSTXEncodeTypeMapper methodsFor:'encode customization'!

bytesAsRaw
    "For older MP specification"
    self actionMap at: ByteArray put: #writeRawBytes:.
    self actionMap at: ImmutableByteArray put: #writeRawBytes:.
!

stringAsBytes
    self actionMap 
        at: String put: #writeString:;
        at: ImmutableString put: #writeString:;
        at: Unicode16String put: #writeWideString:;
        at: Unicode32String put: #writeWideString:;
        at: Symbol put: #writeString:
!

stringAsError
    self actionMap 
        at: String put: #signalError:;
        at: ImmutableString put: #signalError:;
        at: Unicode16String put: #signalError:;
        at: Symbol put: #signalError:
! !

!MpSTXEncodeTypeMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSTXEncodeTypeMapper.st,v 1.5 2018-05-08 16:29:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpSTXEncodeTypeMapper.st,v 1.5 2018-05-08 16:29:54 cg Exp $'
! !


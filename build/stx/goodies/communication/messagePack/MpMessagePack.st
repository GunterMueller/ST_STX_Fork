"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpMessagePack
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpMessagePack class methodsFor:'utilities'!

pack: anObject
	^ MpEncoder encode: anObject
!

packUnpack: anObject
	^self unpack: (self pack: anObject)
!

unpack: aByteArray
	^ MpDecoder decode: aByteArray
! !

!MpMessagePack class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpMessagePack.st,v 1.2 2018-05-08 11:02:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpMessagePack.st,v 1.2 2018-05-08 11:02:13 cg Exp $'
! !


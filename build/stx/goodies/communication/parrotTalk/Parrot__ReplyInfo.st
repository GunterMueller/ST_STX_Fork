"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#ReplyInfo
	instanceVariableNames:'cryptoProtocols dataEncoders'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

ReplyInfo comment:''
!


!ReplyInfo class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ReplyInfo class methodsFor:'as yet unclassified'!

headerType

	^ 11
!

initializeASN1Types

	((ASN1Module name: #Session) sequence: #SequenceOfString of: ASN1UTF8StringType).
	((ASN1Module name: #Session) sequence: #ReplyInfo mapping: ReplyInfo)
		add: #cryptoProtocols type: #SequenceOfString;
		add: #dataEncoders type: #SequenceOfString;
		yourself.
	(ASN1Module name: #Session) find: #ReplyInfo.
! !

!ReplyInfo methodsFor:'accessing'!

cryptoProtocols

	^ cryptoProtocols
!

cryptoProtocols: anObject

	cryptoProtocols := anObject
!

dataEncoders

	^ dataEncoders
!

dataEncoders: anObject

	dataEncoders := anObject
! !

!ReplyInfo methodsFor:'initialize-release'!

buildOverWireEncoders

	| stream |
	stream := WriteStream on: String new.
	dataEncoders 
		do: [:each | stream nextPutAll: each]
		separatedBy: [stream nextPut: $,].
	^ stream contents.
!

buildOverWireProtocols

	| protocolStream |
	protocolStream := WriteStream on: String new.
	self cryptoProtocols 
		do: [:each | protocolStream nextPutAll: each]
		separatedBy: [protocolStream nextPut: $,].
	^ protocolStream contents.
!

initialize

	cryptoProtocols := OrderedCollection new.
	dataEncoders := OrderedCollection new.
!

printOn: stream

	stream nextPutAll: self class asString.
	stream nextPutAll: '('.
	stream nextPutAll: self buildOverWireProtocols.
	stream nextPutAll: ', '.
	stream nextPutAll: self buildOverWireEncoders.
	stream nextPutAll: ')'.
! !

!ReplyInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ReplyInfo.st,v 1.2 2018-05-14 00:39:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ReplyInfo.st,v 1.2 2018-05-14 00:39:15 cg Exp $'
! !


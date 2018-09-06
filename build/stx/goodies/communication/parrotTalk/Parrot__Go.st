"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

PhaseHeader subclass:#Go
	instanceVariableNames:'cryptoProtocol dataEncoder diffieHellmanParameter signature'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

Go comment:''
!


!Go class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Go class methodsFor:'as yet unclassified'!

headerType

	^ 12
!

initializeASN1Types

	((ASN1Module name: #Session) sequence: #Go mapping: Go)
		add: #cryptoProtocol type: #ASN1UTF8StringType;
		add: #dataEncoder type: #ASN1UTF8StringType;
		add: #diffieHellmanParameter type: #ASN1ByteArrayType;
		add: #signature type: #ASN1ByteArrayType;
		yourself.
	(ASN1Module name: #Session) find: #Go.
! !

!Go methodsFor:'accessing'!

cryptoProtocol

	^ cryptoProtocol
!

cryptoProtocol: anObject

	cryptoProtocol := anObject
!

cryptoProtocols

	^ { cryptoProtocol. }
!

dataEncoder

	^ dataEncoder
!

dataEncoder: anObject

	dataEncoder := anObject
!

dataEncoders

	^ { dataEncoder. }
!

diffieHellmanParameter

	^ diffieHellmanParameter
!

diffieHellmanParameter: anObject

	diffieHellmanParameter := anObject
!

signature

	^ signature
!

signature: anObject

	signature := anObject.
	self recomputeSpec.
!

takeSignature

	| sig |
	sig := signature.
	signature := #[].
	self recomputeSpec.
	^ sig
! !

!Go methodsFor:'initialize-release'!

initialize

	self takeSignature.
!

printOn: stream

	stream nextPutAll: self class asString.
	stream nextPutAll: '('.
	stream nextPutAll: cryptoProtocol.
	stream nextPutAll: ', '.
	stream nextPutAll: dataEncoder.
	stream nextPutAll: ')'.
! !

!Go class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Go.st,v 1.2 2018-05-14 00:39:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Go.st,v 1.2 2018-05-14 00:39:05 cg Exp $'
! !


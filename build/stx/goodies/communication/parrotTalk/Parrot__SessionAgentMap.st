"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#SessionAgentMap
	instanceVariableNames:'selectedProtocolName selectedEncoderName cryptoProtocols
		dataEncoders'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

SessionAgentMap comment:''
!


!SessionAgentMap class methodsFor:'instance creation'!

new

	^ self shouldNotImplement
!

newProtocol: proto encoder: encoder

	^ self newProtocols: {proto} encoders: {encoder}
!

newProtocols: protos encoders: encoders

	^ super new
		initializeOnEncoders: encoders protocols: protos;
		yourself
! !

!SessionAgentMap methodsFor:'accessing'!

cryptoProtocolNames

	^ cryptoProtocols collect: [:p | p protocolName].
!

cryptoProtocols

	^ cryptoProtocols
!

dataEncoderNames

	^ dataEncoders collect: [:e | e encoderName].
!

dataEncoders

	^ dataEncoders
!

selectedEncoderName: anObject

	selectedEncoderName := anObject
!

selectedProtocolName: anObject

	selectedProtocolName := anObject
! !

!SessionAgentMap methodsFor:'action'!

buildEncoder

	^ self lookupEncoderByName: selectedEncoderName
!

buildProtocol

	^ self lookupProtocolByName: selectedProtocolName
!

lookupEncoderByName: encoderName

	^ dataEncoders 
		detect: [ :cls | cls encoderName = encoderName ] 
		ifNone: [ Exception signal: (encoderName, ' not found') ].
!

lookupProtocolByName: protoName

	^ cryptoProtocols
		detect: [ :proto | proto protocolName = protoName ]
		ifNone: [ Exception signal: (protoName, ' not found') ]
! !

!SessionAgentMap methodsFor:'initialize-release'!

initializeOnEncoders: encoders protocols: protocols

	cryptoProtocols := protocols.
	dataEncoders	:= encoders.
! !

!SessionAgentMap class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionAgentMap.st,v 1.1 2018-05-14 00:18:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionAgentMap.st,v 1.1 2018-05-14 00:18:51 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkLayer subclass:#SessionOperations
	instanceVariableNames:'stack session securityOps currentState'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

SessionOperations comment:''
!


!SessionOperations class methodsFor:'instance creation'!

newOnStack: stack session: sess map: map

	^ self new
		initializeOnSession: sess initState: self stateMap compile stack: stack map: map;
		yourself
! !

!SessionOperations class methodsFor:'class initialization'!

stateMap
	"(((SessionOperations stateMap compile)))"

	| desc |
	desc := ProtocolStateCompiler initialState: #initial.
	(desc newState: #initial -> (#processInvalidRequest: -> #dead))
		add: #answer -> (nil -> #receivingExpectProtocolOffered);
		add: #call -> (nil -> #receivingExpectProtocolAccepted).
	(desc newState: #connected -> (#processInvalidRequest: -> #dead))
		addInteger: 7 -> (#processBytes: -> #connected).
	(desc newState: #dead -> (#processInvalidRequest: -> #dead)).

	(desc newState: #receivingExpectProtocolOffered -> (#processInvalidRequest: -> #dead))
		addInteger: 1 -> (#processProtocolOffered: -> #receivingExpectIWant).
	(desc newState: #receivingExpectIWant -> (#processInvalidRequest: -> #dead))
		addInteger: 8 -> (#processIWant: -> #receivingExpectGiveInfo).
	(desc newState: #receivingExpectGiveInfo -> (#processInvalidRequest: -> #dead))
		addInteger: 10 -> (#processGiveInfo: -> #receivingExpectGo);
		addInteger: 14 -> (#processDuplicateConnection: -> #dead);
		addInteger: 15 -> (#processNotMe: -> #dead).
	(desc newState: #receivingExpectGo -> (#processInvalidRequest: -> #dead))
		addInteger: 12 -> (#processGo: -> #connected);
		addInteger: 14 -> (#processDuplicateConnection: -> #dead).

	(desc newState: #receivingExpectProtocolAccepted -> (#processInvalidRequest: -> #dead))
		addInteger: 3 -> (#processProtocolAccepted: -> #receivingExpectIAm).
	(desc newState: #receivingExpectIAm -> (#processInvalidRequest: -> #dead))
		addInteger: 9 -> (#processIAm: -> #receivingExpectReplyInfo);
		addInteger: 14 -> (#processDuplicateConnection: -> #dead);
		addInteger: 15 -> (#processNotMe: -> #dead).
	(desc newState: #receivingExpectReplyInfo -> (#processInvalidRequest: -> #dead))
		addInteger: 11 -> (#processReplyInfo: -> #receivingExpectGoToo);
		addInteger: 14 -> (#processDuplicateConnection: -> #dead).
	(desc newState: #receivingExpectGoToo -> (#processInvalidRequest: -> #dead))
		addInteger: 13 -> (#processGoToo: -> #connected).
	^desc.
! !

!SessionOperations methodsFor:'control'!

answer

	self transitionEvent: #answer frame: #answer.
!

call

	self sendProtocolOffered.
	self transitionEvent: #call frame: #call.
	self sendIWant. 
!

close
!

flush
!

isConnected

	^ currentState stateName == #connected
!

isExpectingGoToo

	^ currentState stateName == #receivingExpectGoToo
!

startupFailed: reason

	securityOps clearSensitiveInfo.
	securityOps := nil.
	self triggerEvent: #connectionFailed with: self.
	session shutdown.
!

startupSuccessful: incoming
	"Patch the protocol stack to include an encrypting protocol layer"

	securityOps installOnSession: session stack: stack incoming: incoming.
	securityOps clearSensitiveInfo.
	securityOps := nil.
	self triggerEvent: #connectionSuccessful with: session.
!

transitionEvent: event frame: frame

	| newState |
	newState := currentState transitionEvent: event value: frame client: self.
	(newState ~= currentState)
		ifTrue: [ currentState := newState. ^ true]
		ifFalse: [^ false]
! !

!SessionOperations methodsFor:'derived'!

farKey

	^ session farKey
!

isDomainInscope: domain

	^ true
!

localPublicKey

	^ self nearKey publicKey
!

localVatId

	^ self nearKey vatId
!

nearKey

	^ session portal portalKey
!

remoteIdentity

	^ session remoteIdentity
!

remotePublicKey

	^ self farKey publicKey
!

remotePublicKey: aKey

	^ self farKey receivePublicKey: aKey
!

remoteVatId

	^ self farKey vatId
!

remoteVatId: aVatId

	^ self farKey vatId: aVatId.
! !

!SessionOperations methodsFor:'initialize-release'!

initializeOnSession: sess initState: initState stack: localStack map: map

	session := sess.
	currentState := initState.
	stack := localStack.
	securityOps := SecurityOps newOnMap: map.
! !

!SessionOperations methodsFor:'protocol control'!

errorDead: aByte
!

processDuplicateConnection: frame

	self startupFailed: 'duplicate connection'.
!

processNotMe: frame

	self startupFailed: 'not me'.
!

processProtocolAccepted: frame

	securityOps addRemoteFrame: frame.
!

processProtocolOffered: frame

	securityOps addRemoteFrame: frame.
	self sendProtocolAccepted: frame header preferred.
!

sendDuplicateConnection: reason

	| msg |
	msg := DuplicateConnection new asFrame.
	self privateSendFrame: msg.
	session shutdown.

!

sendNotMe

	| msg |
	msg := NotMe new asFrame.
	self privateSendFrame: msg.
	session shutdown.
!

sendProtocolAccepted: accepted

	| msg |
	msg := ProtocolAccepted new.
	msg accepted: accepted.
	msg := msg asFrame.
	securityOps addLocalFrame: msg.
	self privateSendFrame: msg.

	
!

sendProtocolOffered

	| msg |
	msg := ProtocolOffered new.
	msg offered: 'ParrotTalk-3.6'.
	msg preferred: 'ParrotTalk-3.6'.
	msg := msg asFrame.
	securityOps addLocalFrame: msg.
	self privateSendFrame: msg.
! !

!SessionOperations methodsFor:'protocol data'!

privateSendFrame: frame

	stack downcall: frame from: self.
!

processBytes: dataFrame

	"stack upcall: dataFrame from: self."
! !

!SessionOperations methodsFor:'protocol startup'!

processGiveInfo: frame

	securityOps addRemoteFrame: frame.

	self remoteVatId: frame header vatId.
	self remotePublicKey: frame header publicKey.

	self sendReplyInfo.
!

processGo: frame

	|  sig dhParam |
	sig := frame header takeSignature.
	dhParam := securityOps dhParm.
	securityOps addRemoteFrame: frame.
	(securityOps authenticateSignature: sig withKey: self farKey)
		ifFalse: [ CryptographyError signal: 'signature authentication failed' ].
	securityOps processDhParm: frame header diffieHellmanParameter.

	self
		sendGoTooWithProtocol: (securityOps matchBestProtocol: frame header cryptoProtocols)
		encoder: (securityOps matchBestEncoder: frame header dataEncoders)
		dhParam: dhParam.
	self startupSuccessful: true.
!

processGoToo: frame

	|  sig |
	sig := frame header takeSignature.
	securityOps addRemoteFrame: frame.
	(securityOps authenticateSignature: sig withKey: self farKey)
		ifFalse: [ CryptographyError signal: 'signature authentication failed' ].
	securityOps processDhParm: frame header diffieHellmanParameter.
	self startupSuccessful: false.
!

processIAm: frame

	securityOps addRemoteFrame: frame.

	self remotePublicKey: frame header publicKey.

"	(frame header vatId = self remoteVatId and: [self isDomainInscope: frame header domain])"
	(self isDomainInscope: frame header domain)
		ifFalse: [^ self startupFailed: 'authorization failure'].

	self sendGiveInfo.
!

processIWant: frame

	securityOps addRemoteFrame: frame.
"	(frame header vatId = self localVatId and: [self isDomainInscope: frame header domain])"
	(self isDomainInscope: frame header domain)
		ifTrue: [self sendIAm]
		ifFalse: [self sendNotMe].
!

processInvalidRequest: frame

	session shutdown.
!

processReplyInfo: frame

	securityOps addRemoteFrame: frame.
	self 
		sendGoWithProtocol: (securityOps matchBestProtocol: frame header cryptoProtocols)
		encoder: (securityOps matchBestEncoder: frame header dataEncoders)
		dhParam: securityOps dhParm.
!

sendGiveInfo

	| msg |
	msg := GiveInfo new
		vatId: self localVatId;
		publicKey: self localPublicKey;
		asFrame.
	securityOps addLocalFrame: msg.
	self privateSendFrame: msg.
!

sendGoTooWithProtocol: protocol encoder: encoder dhParam: dhParam

	| msg |
	securityOps portalMap selectedProtocolName: protocol; selectedEncoderName: encoder.
	msg := GoToo new
		cryptoProtocol: protocol;
		dataEncoder: encoder;
		diffieHellmanParameter: dhParam;
		asFrame.
	securityOps addLocalFrame: msg.
	msg header signature: (securityOps generateSignatureWithKey: self nearKey).
	self privateSendFrame: msg.
!

sendGoWithProtocol: protocol encoder: encoder dhParam: dhParam

	| msg |
	securityOps portalMap selectedProtocolName: protocol; selectedEncoderName: encoder.
	msg := Go new
		cryptoProtocol: protocol;
		dataEncoder: encoder;
		diffieHellmanParameter: dhParam;
		asFrame.
	securityOps addLocalFrame: msg.
	msg header signature: (securityOps generateSignatureWithKey: self nearKey).
	self privateSendFrame: msg.
!

sendIAm

	| msg |
	msg := IAm new
		vatId: self localVatId;
		publicKey: self localPublicKey;
		asFrame.
	securityOps addLocalFrame: msg.
	self privateSendFrame: msg.
!

sendIWant

	| msg |
	msg := IWant new
		vatId: self remoteVatId;
		domain: '';
		asFrame.
	securityOps addLocalFrame: msg.
	self privateSendFrame: msg.
!

sendReplyInfo

	| msg |
	msg := ReplyInfo new
		cryptoProtocols: securityOps portalMap cryptoProtocolNames;
		dataEncoders: securityOps portalMap dataEncoderNames;
		asFrame.
	securityOps addLocalFrame: msg.
	self privateSendFrame: msg.
! !

!SessionOperations methodsFor:'thunk - accessing'!

doesPop

	^ false
!

doesPush

	^ false
!

downThunk

	^ [:frame | frame].
!

upThunk

	^ [:frame |
		(self transitionEvent: frame headerType frame: frame)
			ifTrue: [	BlockCannotReturn signal: 'gatekeeper processed frame'] ].
! !

!SessionOperations class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionOperations.st,v 1.1 2018-05-14 00:18:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionOperations.st,v 1.1 2018-05-14 00:18:19 cg Exp $'
! !


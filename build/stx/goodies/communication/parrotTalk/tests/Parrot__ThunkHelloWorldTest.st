"{ Package: 'stx:goodies/communication/parrotTalk/tests' }"

"{ NameSpace: Parrot }"

TestCase subclass:#ThunkHelloWorldTest
	instanceVariableNames:'conn1 conn2 msgMatch dataReceived conn1Closed conn2Closed'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-test'
!

ThunkHelloWorldTest comment:''
!


!ThunkHelloWorldTest methodsFor:'building'!

buildAESedeProtocolMaker

	^ CipherThunkMaker newName: 'AESede' cipherClass: Rijndael keySize: 32 blockSize: 16 hasIvParameter: true
!

buildAsn1DerEncoderThunk

	^ EncoderThunk
		newName: 'asn1der'
		serializeThunk: [:payload | payload asAsn1DerBytes ]
		materializeThunk: [:payload | ASN1InputStream decodeBytes: payload asByteArray ]
!

buildBytesEncoderThunk

	^ EncoderThunk
		newName: 'Bytes'
		serializeThunk: [:payload | payload asByteArray ]
		materializeThunk: [:payload | payload asByteArray ]
!

buildDESProtocolMaker

	^ CipherThunkMaker newName: 'DES' cipherClass: DES keySize: nil blockSize: 8 hasIvParameter: true
!

buildDESedeProtocolMaker

	^ CipherThunkMaker newName: 'DESede' cipherClass: TripleDES keySize: nil blockSize: 8 hasIvParameter: true
!

buildJsonEncoderThunk

"	^ EncoderThunk
		newName: 'bytes'
		serializeThunk: [:payload | Json render: payload ]
		materializeThunk: [:payload |  Json new readFrom: payload asString readStream ]"

	^ EncoderThunk
		newName: 'bytes'
		serializeThunk: [:payload | payload asByteArray ]
		materializeThunk: [:payload | payload asByteArray ]
!

buildMapAESedeAsn1Der

	^ SessionAgentMap newProtocol: self buildAESedeProtocolMaker encoder: self buildAsn1DerEncoderThunk
!

buildMapAESedeBytes

	^ SessionAgentMap newProtocol: self buildAESedeProtocolMaker encoder: self buildBytesEncoderThunk
!

buildMapAESedeJson

	^ SessionAgentMap newProtocol: self buildAESedeProtocolMaker encoder: self buildJsonEncoderThunk
!

buildMapDESAsn1Der

	^ SessionAgentMap newProtocol: self buildDESProtocolMaker encoder: self buildAsn1DerEncoderThunk
!

buildMapDESedeAsn1Der

	^ SessionAgentMap newProtocol: self buildDESedeProtocolMaker encoder: self buildAsn1DerEncoderThunk
!

tearDown

	SessionAgent allInstances do: [:e | e stop].
	Session allInstances do: [:e | e shutdown].
	Socket allInstances do: [:e | e destroy].
! !

!ThunkHelloWorldTest methodsFor:'testing'!

testConnectAES

	| vat1 vat2 msg |
	msg := 'test'.
	dataReceived := false.
	msgMatch := nil.
	conn1Closed := false.
	conn2Closed := false.

	conn1 := nil. conn2 := nil.
	vat1 := SessionAgent newOnKey: SessionIdentity sampleVatId1 map: self buildMapAESedeAsn1Der.
	vat2 := SessionAgent newOnKey: SessionIdentity sampleVatId2 map: self buildMapAESedeAsn1Der.
	vat2 when: #connectionRunning evaluate: [ :conn | 
"		Transcript cr; show: 'Connection running'."
		conn2 := conn.
		conn2 send: msg.
		conn2 when: #connectionClosed evaluate: [ :connA | 
"			Transcript cr; show: 'Connection 2 closed'."
			conn2Closed := true]].

	conn1 := vat1 connectToKey: vat2 portalKey asVatLocation.
	conn1 when: #dataReceived evaluate: [ :bytes | 
"		Transcript cr; show: 'data received: ', bytes asString."
		dataReceived := true.
		msgMatch := bytes asString].
	conn1 when: #connectionClosed evaluate: [ :conn | 
"		Transcript cr; show: 'Connection 1 closed'."
		conn1Closed := true].

	(Delay forMilliseconds: 1500) wait.

	self assert: dataReceived.
	self should: [msgMatch = msg].

	conn1 shutdown.
	
	(Delay forMilliseconds: 10) wait.

	self assert: conn1Closed.
	self assert: conn2Closed.
	
	self assert: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat1 stop.
	self deny: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat2 stop.
	self deny: vat1 isPortalOpen.
	self deny: vat2 isPortalOpen.
!

testConnectAESBytesAnonymous

	| vat1 vat2 msg connectVat |
	msg := 'test'.
	dataReceived := false.
	msgMatch := nil.
	conn1Closed := false.
	conn2Closed := false.

	conn1 := nil. conn2 := nil.
	vat1 := SessionAgent newOnKey: SessionIdentity sampleVatId1 map: self buildMapAESedeBytes.
	vat2 := SessionAgent newOnKey: SessionIdentity sampleVatId2 map: self buildMapAESedeBytes.
	vat2 when: #connectionRunning evaluate: [ :conn | 
"		Transcript cr; show: 'Connection running'."
		conn2 := conn.
		conn2 send: msg.
		conn2 when: #connectionClosed evaluate: [ :connA | 
"			Transcript cr; show: 'Connection 2 closed'."
			conn2Closed := true]].

	"build anony key"
	connectVat := vat2 portalKey asVatLocation
		vatId: '';
		yourself.
	conn1 := vat1 connectToKey: connectVat.
	conn1 when: #dataReceived evaluate: [ :bytes | 
"		Transcript cr; show: 'data received: ', bytes asString."
		dataReceived := true.
		msgMatch := bytes asString].
	conn1 when: #connectionClosed evaluate: [ :conn | 
"		Transcript cr; show: 'Connection 1 closed'."
		conn1Closed := true].

	(Delay forMilliseconds: 1500) wait.

	self assert: dataReceived.
	self should: [msgMatch = msg].

	conn1 shutdown.
	
	(Delay forMilliseconds: 10) wait.

	self assert: conn1Closed.
	self assert: conn2Closed.
	
	self assert: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat1 stop.
	self deny: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat2 stop.
	self deny: vat1 isPortalOpen.
	self deny: vat2 isPortalOpen.
!

testConnectDES

	| vat1 vat2 msg |
	msg := 'test'.
	dataReceived := false.
	msgMatch := nil.
	conn1Closed := false.
	conn2Closed := false.

	conn1 := nil. conn2 := nil.
	vat1 := SessionAgent newOnKey: SessionIdentity sampleVatId1 map: self buildMapDESAsn1Der.
	vat2 := SessionAgent newOnKey: SessionIdentity sampleVatId2 map: self buildMapDESAsn1Der.
	vat2 when: #connectionRunning evaluate: [ :conn | 
"		Transcript cr; show: 'Connection running..', conn nearKey, '->', conn farKey."
		conn2 := conn.
		conn2 send: msg.
		conn2 when: #connectionClosed evaluate: [ :connA | 
"			Transcript cr; show: 'Connection 2 closed'."
			conn2Closed := true]].

	conn1 := vat1 connectToKey: vat2 portalKey asVatLocation.
	conn1 when: #dataReceived evaluate: [ :bytes | 
"		Transcript cr; show: 'data received: ', bytes asString."
		dataReceived := true.
		msgMatch := bytes asString.
		conn1Closed := true].
	conn1 when: #connectionClosed evaluate: [ :conn | 
"		Transcript cr; show: 'Connection 1 closed'."
		conn2Closed := true].

	(Delay forMilliseconds: 1000) wait.

	self assert: dataReceived.
	self should: [msgMatch = msg].

	conn1 shutdown.
	
	(Delay forMilliseconds: 10) wait.

	self assert: conn1Closed.
	self assert: conn2Closed.
	
	self assert: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat1 stop.
	self deny: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat2 stop.
	self deny: vat1 isPortalOpen.
	self deny: vat2 isPortalOpen.
!

testConnectDESede

	| vat1 vat2 msg |
	msg := 'test'.
	dataReceived := false.
	msgMatch := nil.
	conn1Closed := false.
	conn2Closed := false.
 
	conn1 := nil. conn2 := nil.
	vat1 := SessionAgent newOnKey: SessionIdentity sampleVatId1 map: self buildMapDESedeAsn1Der.
	vat2 := SessionAgent newOnKey: SessionIdentity sampleVatId2 map: self buildMapDESedeAsn1Der.
	vat2 when: #connectionRunning evaluate: [ :conn | 
"		Transcript cr; show: 'Connection running'."
		conn2 := conn.
		conn2 send: msg.
		conn2 when: #connectionClosed evaluate: [ :connA | 
"			Transcript cr; show: 'Connection 2 closed'."
			conn2Closed := true]].

	conn1 := vat1 connectToKey: vat2 portalKey asVatLocation.
	conn1 when: #dataReceived evaluate: [ :bytes | 
"		Transcript cr; show: 'data received: ', bytes asString."
		dataReceived := true.
		msgMatch := bytes asString].
	conn1 when: #connectionClosed evaluate: [ :conn | 
"		Transcript cr; show: 'Connection 1 closed'."
		conn1Closed := true].

	(Delay forMilliseconds: 1000) wait.

	self assert: dataReceived.
	self should: [msgMatch = msg].

	conn1 shutdown.
	
	(Delay forMilliseconds: 10) wait.

	self assert: conn1Closed.
	self assert: conn2Closed.
	
	self assert: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat1 stop.
	self deny: vat1 isPortalOpen.
	self assert: vat2 isPortalOpen.
	vat2 stop.
	self deny: vat1 isPortalOpen.
	self deny: vat2 isPortalOpen.
! !

!ThunkHelloWorldTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__ThunkHelloWorldTest.st,v 1.1 2018-05-14 00:20:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__ThunkHelloWorldTest.st,v 1.1 2018-05-14 00:20:16 cg Exp $'
! !


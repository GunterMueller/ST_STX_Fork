"{ Package: 'stx:goodies/communication/parrotTalk/tests' }"

"{ NameSpace: Parrot }"

TestCase subclass:#HelloWorldTestServer
	instanceVariableNames:'vat2 conn2 msg conn2Closed'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-test'
!

HelloWorldTestServer comment:''
!


!HelloWorldTestServer methodsFor:'building'!

buildMapAESedeBytes

	^ SessionAgentMap 
		newProtocol: (CipherThunkMaker newName: 'AESede' cipherClass: Rijndael keySize: 32 blockSize: 16 hasIvParameter: true)
		encoder: (EncoderThunk
			newName: 'String'
			serializeThunk: [:payload | payload asByteArray ]
			materializeThunk: [:payload | payload asString ])
!

stop

	vat2 stop.
	vat2 := nil.
!

tearDown

	SessionAgent allInstances do: [:e | e stop].
	Session allInstances do: [:e | e shutdown].
	Socket allInstances do: [:e | e destroy].
! !

!HelloWorldTestServer methodsFor:'testing'!

startServerAESedeBytes

	| key |
	msg := 'hello world'.
	conn2Closed := false.

	conn2 := nil.
	key := SessionIdentity sampleVatId2 copy.
	key socketAddress port: 12222.
	vat2 := SessionAgent newOnKey: key map: self buildMapAESedeBytes.
	vat2 when: #connectionRunning evaluate: [ :conn | 
		Transcript cr; show: 'Connection running'.
		conn2 := conn.
		conn2 send: msg.
		conn2 when: #connectionClosed evaluate: [ :connA | 
			Transcript cr; show: 'Connection 2 closed'.
			conn2Closed := true]].
! !

!HelloWorldTestServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__HelloWorldTestServer.st,v 1.1 2018-05-14 00:20:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__HelloWorldTestServer.st,v 1.1 2018-05-14 00:20:04 cg Exp $'
! !


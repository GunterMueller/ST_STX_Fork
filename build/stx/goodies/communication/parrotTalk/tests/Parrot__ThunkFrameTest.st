"{ Package: 'stx:goodies/communication/parrotTalk/tests' }"

"{ NameSpace: Parrot }"

TestCase subclass:#ThunkFrameTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-test'
!

ThunkFrameTest comment:''
!


!ThunkFrameTest methodsFor:'as yet unclassified'!

buildChunk: size

	| bytes chunk start |
	chunk := ByteArray new: size.
	(size < 10) ifTrue: [ ^ self buildSmallChunk: size ].
	bytes := #[1 2 3 4 5 6 7 8 9 0].
	0 to: (size // bytes size - 1) do: [ :i | chunk replaceFrom: (i * bytes size + 1) to: ((i + 1) *bytes size) with: bytes startingAt: 1].
	start := (size // bytes size) * bytes size + 1.
	chunk replaceFrom: start to: size with: (self buildChunk: (size - start + 1)) startingAt: 1.
	^ chunk
!

buildSmallChunk: size

	| chunk |
	chunk := ByteArray new: size.
	1 to: size do: [ :index | chunk at: index put: index ].
	^ chunk.
!

testFrames

	[

			Frame readFrom: (ProtocolOffered new
				offered: '';
				preferred: '';
				asFrame) asByteArray readStream.

			Frame readFrom: (ProtocolAccepted new
				accepted: '';
				asFrame) asByteArray readStream.

			Frame readFrom: (IWant new
				vatId: SessionIdentity sampleVatId1 vatId;
				domain: 'rockabilly';
				asFrame) asByteArray readStream.

			Frame readFrom: (IAm new
				vatId: SessionIdentity sampleVatId1 vatId;
				domain: 'rockabilly';
				publicKey: SessionIdentity sampleVatId1 publicKey;
				asFrame) asByteArray readStream.

			Frame readFrom: (GiveInfo new
				vatId: SessionIdentity sampleVatId1 vatId;
				publicKey: SessionIdentity sampleVatId1 publicKey;
				asFrame) asByteArray readStream.

			Frame readFrom: (ReplyInfo new
				cryptoProtocols: '';
				dataEncoders: '';
				asFrame) asByteArray readStream.

			Frame readFrom: (Go new
				cryptoProtocol: 'rockabilly';
				dataEncoder: 'rockabilly';
				diffieHellmanParameter: '' asByteArray;
				signature: '' asByteArray;
				asFrame) asByteArray readStream.

			Frame readFrom: (GoToo new
				cryptoProtocol: 'rockabilly';
				dataEncoder: 'rockabilly';
				diffieHellmanParameter: '' asByteArray;
				signature: '' asByteArray;
				asFrame) asByteArray readStream.

			NotMe new asFrame.
			DuplicateConnection new asFrame
		] on: Exception do: [ :ex | self assert: false ].
!

testPayloadSpecification

	| frame |
	[
			frame := IWant new asFrame.
			self assert: (frame tags == 0).
			self assert: (frame multicast == 0).
			self assert: (frame frameVersion == 1).
			self assert: (frame priority == 0).
			self assert: (frame headerType == 8).
			self assert: (frame hash == 0).
			self assert: (frame messageSize == 14).
		] on: Exception do: [ :ex | self assert: false ].
!

testSignatures

	| vatIdentity sig |
	vatIdentity := SessionIdentity sampleVatId1.
	sig := vatIdentity signMessage: 'hello world' asByteArray.
	self assert: (vatIdentity verify: sig isSignatureOf: 'hello world' asByteArray).
! !

!ThunkFrameTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__ThunkFrameTest.st,v 1.1 2018-05-14 00:20:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__ThunkFrameTest.st,v 1.1 2018-05-14 00:20:08 cg Exp $'
! !


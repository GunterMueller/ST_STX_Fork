"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#Frame
	instanceVariableNames:'frameSpecification header payload'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

Frame comment:'Frame onHeader: ProtocolOffered new payload: #[].Frame onHeader: ProtocolAccepted new payload: #[].Frame onHeader: Ping new payload: #[].Frame onHeader: Pong new payload: #[].Frame onHeader: Data new payload: #[].Frame onHeader: NotMe new payload: #[].Frame onHeader: DuplicateConnection new payload: #[].Frame onHeader: IWant new payload: #[].Frame onHeader: IAm new payload: #[].Frame onHeader: GiveInfo new payload: #[].Frame onHeader: ReplyInfo new payload: #[].Frame onHeader: Go new payload: #[].Frame onHeader: GoToo new payload: #[].Frame onHeader: FECHeader new payload: #[].'
!


!Frame class methodsFor:'instance creation'!

new

	| frame |
	frame := self onFrameSpecification: (ByteArray new: self specificationSize withAll: 0).
	frame frameVersion: 1.
	^ frame
!

onFrameSpecification: spec

	| frame |
	(spec size >= self specificationSize)
		ifFalse: [CryptographyError signal: 'too few bytes'].
	frame := self basicNew initialize.
	frame initOnSpecification: spec.
	^ frame
!

onHeader: header

	^ self onHeader: header payload: #[]
!

onHeader: header payload: payload

	^ self new
		header: header;
		payload: payload;
		yourself.
!

onPayload: bytes

	^ self onHeader: RawData new payload: bytes.
!

readFrom: stream	

	^ (self onFrameSpecification: (stream next: self specificationSize))
		readRemainderFrom: stream
! !

!Frame class methodsFor:'asn1der'!

fromAsn1DerBytes: bytes

	^ self readFrom: bytes readStream.
!

initialize
!

specificationSize

	^ 8
! !

!Frame methodsFor:'accessing'!

hdr

	^ self header
!

header

	^ header
!

header: anObject

	header := anObject.
	header when: #recomputeSpec send: #recomputeSpec to: self.
	header recomputeSpec.
	
!

payload

	^ payload
!

payload: anObject

	payload := anObject.
	self recomputeSpec.
! !

!Frame methodsFor:'accessing 8-byte frame header'!

frameVersion

	^ (frameSpecification at: 4) bitAnd: 16r01.
!

frameVersion: version

	^ frameSpecification at: 4 put: (((frameSpecification at: 4) bitAnd: 16rFE) bitOr: (version bitAnd: 16r01)).
!

hash

	| highOrder lowOrder |
	lowOrder := ((frameSpecification at: 2) bitAnd: 16rC0) bitShift: -6.
	highOrder := ((frameSpecification at: 3) bitAnd: 16rFF) bitShift: 2.
	^ lowOrder bitOr: highOrder
!

hash: hash

	frameSpecification at: 2 put: (((frameSpecification at: 2) bitAnd: 16rCF) bitOr: ((hash bitAnd: 16r03) bitShift: 6)).
	frameSpecification at: 3 put: ((hash bitAnd: 16rFFC) bitShift: -2).
!

headerType

	^ ((frameSpecification at: 4) bitAnd: 16rF8) bitShift: -3.
!

headerType: headerType

	frameSpecification at: 4 put: (((frameSpecification at: 4) bitAnd: 16r07) bitOr: ((headerType bitAnd: 16r1F) bitShift: 3)). 
!

messageSize

	^ (frameSpecification copyFrom: 5 to: 8) asInteger
!

messageSize: size

	frameSpecification replaceFrom: 5 to: 8 with: size sizeAsFourBytes
!

multicast

	| highOrder lowOrder |
	lowOrder := ((frameSpecification at: 1) bitAnd: 16rF0) bitShift: -4.
	highOrder := ((frameSpecification at: 2) bitAnd: 16r3F) bitShift: 4.
	^ lowOrder bitOr: highOrder
!

multicast: multicast

	frameSpecification at: 1 put: (((frameSpecification at: 1) bitAnd: 16r0F) bitOr: ((multicast bitAnd: 16r0F) bitShift: 4)).
	frameSpecification at: 2 put: (((frameSpecification at: 2) bitAnd: 16rC0) bitOr: ((multicast bitAnd: 16r3F0) bitShift: -4)).
!

priority

	^ ((frameSpecification at: 4) bitAnd: 16r06) bitShift: -1
!

priority: priority

	frameSpecification at: 4 put: (((frameSpecification at: 4) bitAnd: 16rF9) bitOr: ((priority bitAnd: 16r03) bitShift: 1)).
!

tags

	^ (frameSpecification at: 1) bitAnd: 16r0F
!

tags: tags

	frameSpecification at: 1 put: (((frameSpecification at: 1) bitAnd: 16rF0) bitOr: (tags bitAnd: 16r0F)).
! !

!Frame methodsFor:'base access'!

encodedSize

	^ self messageSize - self specificationSize
!

payloadSize

	^ payload class isVariable
		ifTrue: [payload size]
		ifFalse: [0].
!

specificationSize

	^ self class specificationSize.
! !

!Frame methodsFor:'conversion'!

asAsn1DerBytes

	^ header asAsn1DerBytes
!

asAsn1DerBytesPlusPayload

	| stream |
	stream := #[] writeStream.
	stream nextPutAll: self asAsn1DerBytes.
	stream nextPutAll: self payload.
	^ stream contents.
!

asByteArray

	^ frameSpecification, self asAsn1DerBytesPlusPayload
!

readFrom: stream

"	msgSpec := MessageSpecification forFrame: self withEightBytes: (stream next: 8).
	header := msgSpec headerFromStream: stream.
	self setSpecificationDetails.
	payload := stream next: msgSpec payloadSize."

	frameSpecification := stream next: self specificationSize.
	self readRemainderFrom: stream.
!

readRemainderFrom: stream

	self header: (PhaseHeader readFrom: stream).
	self payload: stream upToEnd.
	self recomputeSpec.
! !

!Frame methodsFor:'initialize-release'!

initOnSpecification: spec

	frameSpecification := spec
!

initialize

	payload := #[].
!

printOn: stream

	stream nextPutAll: 'a Frame(';
		nextPutAll: header asString;
		nextPutAll: ' - ';
		nextPutAll: self payloadSize asString;
		nextPutAll: ' payload size)'.
!

recomputeSpec

	self messageSize: (self specificationSize + header asAsn1DerBytes size + self payloadSize).
	self headerType: header headerType.
! !

!Frame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Frame.st,v 1.1 2018-05-14 00:18:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__Frame.st,v 1.1 2018-05-14 00:18:03 cg Exp $'
! !


Frame initialize!

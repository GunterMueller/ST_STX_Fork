"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#PhaseHeader
	instanceVariableNames:'frame'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-load'
!

PhaseHeader comment:''
!


!PhaseHeader class methodsFor:'instance creation'!

readFrom: stream	

	| type |
	[type := (ASN1Module name: #Session) find: #PhaseHeader.
	^ (ASN1InputStream onStream: stream) decodeWithType: type]
		on: Error
		do: [:ex |
			self halt. ex resignalAs: (ASN1ParseError new messageText: 'frame header')].
	ASN1ParseError signal: 'frame header'.
! !

!PhaseHeader class methodsFor:'asn1der'!

headerType

	^ -1
!

initializeASN1Types

	self allSubclassesDo: [ :eachClass | eachClass initializeASN1Types ].

	((ASN1Module name: #Session) choice: #PhaseHeader)
		add: #DuplicateConnection type: #DuplicateConnection explicitTag: DuplicateConnection headerType;
		add: #NotMe type: #NotMe explicitTag: NotMe headerType;
		add: #ProtocolOffered type: #ProtocolOffered explicitTag: ProtocolOffered headerType;
		add: #ProtocolAccepted type: #ProtocolAccepted explicitTag: ProtocolAccepted headerType;
		add: #RawData type: #RawData explicitTag: RawData headerType;
		add: #Encoded type: #Encoded explicitTag: Encoded headerType;
		add: #Encrypted type: #Encrypted explicitTag: Encrypted headerType;
		add: #MAC type: #MAC explicitTag: MAC headerType;
		add: #IWant type: #IWant explicitTag: IWant headerType;
		add: #IAm type: #IAm explicitTag: IAm headerType;
		add: #GiveInfo type: #GiveInfo explicitTag: GiveInfo headerType;
		add: #ReplyInfo type: #ReplyInfo explicitTag: ReplyInfo headerType;
		add: #Go type: #Go explicitTag: Go headerType;
		add: #GoToo type: #GoToo explicitTag: GoToo headerType;
		yourself.

		^ (ASN1Module name: #Session) find: #PhaseHeader.
! !

!PhaseHeader class methodsFor:'class initialization'!

initialize

	self initializeASN1Types.
! !

!PhaseHeader methodsFor:'apply primitives'!

asFrame

	^ Frame onHeader: self payload: #[].
!

headerType

	^ self class headerType
!

recomputeSpec

	self triggerEvent: #recomputeSpec.
! !

!PhaseHeader methodsFor:'conversion'!

asAsn1DerBytes

	| stream |
	stream := #[] writeStream.
	self storeAsn1DerBytesOn: stream.
	^ stream contents.
!

asSignableBytes

	| stream |
	stream := #[] writeStream.
	self storeAsn1DerBytesOn: stream.
	^ stream contents.
!

storeAsn1DerBytesOn: stream

	| type |
	type := (ASN1Module name: #Session) find: #PhaseHeader.
	stream nextPutAll: (ASN1OutputStream encode: self withType: type).
! !

!PhaseHeader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__PhaseHeader.st,v 1.1 2018-05-14 00:17:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__PhaseHeader.st,v 1.1 2018-05-14 00:17:02 cg Exp $'
! !


PhaseHeader initialize!

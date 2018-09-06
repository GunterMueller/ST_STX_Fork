"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#InetSocketAddress
	instanceVariableNames:'host port'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

InetSocketAddress comment:'IpIdentity fromString: ''127.0.0.1:9999'''
!


!InetSocketAddress class methodsFor:'instance creation'!

fromString: hostPortString

	| colonPos host port |
	colonPos := hostPortString findString: ':'.
	colonPos isZero
		ifTrue: [
			host := hostPortString.
			port := '9999']
		ifFalse: [
			host := hostPortString first: colonPos - 1.
			port := hostPortString allButFirst: colonPos].
	^ self newOnName: host port: port asInteger
!

isPassByConstruction

	^ true
!

newOnAddress: address port: port

	^ self newOnName: (NetNameResolver stringFromAddress: address) port: port.
!

newOnName: hostName port: port

	^ self new
		host: hostName;
		port: port;
		yourself
!

newOnPort: port

	^ self new
		host: self localHostName;
		port: port;
		yourself
! !

!InetSocketAddress class methodsFor:'asn1der'!

fromAsn1DerBytes: bytes

	| type |
	type := (ASN1Module name: #Session) find: #TcpIdentity.
	^ ASN1InputStream decodeBytes: bytes withType: type.
!

initialize

	self initializeASN1Types.
!

initializeASN1Types

	| module |
	module := ASN1Module name: #Session.
	[module remove: (module find: #InetSocketAddress)] on: KeyNotFound do: [:ex | ].
	(module sequence: #InetSocketAddress mapping: InetSocketAddress)
		add: #host type: #ASN1UTF8StringType;
		add: #port type: #ASN1IntegerType;
		yourself.
	(ASN1Module name: #Session) find: #InetSocketAddress.
! !

!InetSocketAddress class methodsFor:'utility'!

localHostAddress

	| addr |
	addr := NetNameResolver localHostAddress.
	addr = #(0 0 0 0) asByteArray
		ifTrue: [addr := #(127 0 0 1) asByteArray].
	^ addr
!

localHostName

	| addr |
	addr := InetSocketAddress localHostAddress.
	^ NetNameResolver stringFromAddress: addr.
! !

!InetSocketAddress methodsFor:'accessing'!

address
	"Answer the address of host"

	| address |
	address := NetNameResolver addressFromString: host.
	address ifNil: [address := NetNameResolver addressForName: host].
	^ address
!

host
	"Answer the value of host"

	^ host
!

host: anObject
	"Set the value of host"

	host := anObject
!

port

	^ port
!

port: aPort

	port := aPort asInteger 
! !

!InetSocketAddress methodsFor:'comparing'!

= anObject

	^ (anObject class includesBehavior: self class) 
		and: [(self host = anObject host) 
			and: [self port = anObject port]]
!

hash

	^ self host hash + self port hash
!

isInternalNetwork

	^ ('192.168.*' match: self host) or: ['localhost' match: self host].
!

printOn: aStream

	aStream nextPutAll: self host, ':', self port asString.
! !

!InetSocketAddress methodsFor:'converting'!

asAsn1DerBytes

	| type |
	type := (ASN1Module name: #Session) find: #TcpIdentity.
	^ ASN1OutputStream encode: self withType: type.
! !

!InetSocketAddress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__InetSocketAddress.st,v 1.1 2018-05-14 00:17:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__InetSocketAddress.st,v 1.1 2018-05-14 00:17:42 cg Exp $'
! !


InetSocketAddress initialize!

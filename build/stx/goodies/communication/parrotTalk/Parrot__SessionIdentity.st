"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#SessionIdentity
	instanceVariableNames:'vatId publicKey privateKey socketAddress nickname'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

SessionIdentity comment:'| id hydratedId encodedBytes |id := SecureSessionRSAIdentity newRandom.encodedBytes := PBEEncryptor encryptRawBytes: id asBytes.hydratedId := SecureSessionRSAIdentity fromBytes: (PBEEncryptor decryptEncodedBytes: encodedBytes).id -> hydratedId| roundTripBlock |roundTripBlock := [:password :msg |	(PBEEncryptor decryptOn: password encodedBytes: 		(PBEEncryptor encryptOn: password rawBytes: msg))			asString].roundTripBlock value: ''password'' value: ''hello world''algorithmId := X509AlgorithmIdentifier	oidString: ''1.2.840.113549.1.5.12''	parameters: (OrderedCollection		with: salt		with: PBKDF2WithHmacSHA1 defaultIterations		with: PBKDF2WithHmacSHA1 defaultKeyBitLength		with: (X509AlgorithmIdentifier oidString: ''1.2.840.113549.7'')).algorithmBytes := ASN1Stream encode: algorithmId withType: ((ASN1Module name: #x509) find: #AlgorithmIdentifier).bytes := (OrderedCollection with: algorithmBytes with: concatPublicKeyBytes) asAsn1Bytes.| id bytes encryptor password salt iv encryptedBytes array params |id := SecureSessionRSAIdentity newRandom.password := (UIManager default requestPassword: ''SecureSession Identity password'') asByteArray.bytes := id asAsn1DerBytes.encryptor := PBEEncryptorWithSHA1 newOn: password.salt := encryptor salt.iv := encryptor iv.encryptedBytes := encryptor encrypt: bytes.array := Array with: salt with: iv with: encryptedBytes.| id bytes encryptor unencodedId decryptor password salt iv originalBytes encryptedBytes decryptedBytes |decryptor := PBEEncryptorWithSHA1 newOn: password salt: salt iv: iv.decryptedBytes := decryptor decrypt: encryptedBytes.self assert: (originalBytes = decryptedBytes).'
!


!SessionIdentity class methodsFor:'instance creation'!

fromByteArray: bytes

	^ self readFrom: bytes readStream
!

new

	^ super new
		socketAddress: (InetSocketAddress newOnPort: self defaultPort);
		vatId: '<unknown>';
		nickname: '<unknown>';
		yourself.
!

newOnAddress: address port: port

	^ self new 
		socketAddress: (InetSocketAddress newOnAddress: address port: port);
		yourself
!

newOnHostPortString: hostPort vatId: vatId

	^ self new 
		vatId: vatId;
		socketAddress: (InetSocketAddress fromString: hostPort);
		yourself
!

newOnKeys: keys

	^ self newOnKeys: keys port: self defaultPort.
!

newOnKeys: keys host: host port: port

	| identity |
	Socket initializeNetwork.
	identity := self new
		socketAddress: (InetSocketAddress newOnName: host port: port);
		yourself.
	identity setupOnPublicKey: keys key privateKey: keys value.
	^ identity
!

newOnKeys: keys host: host port: port nick: nick

	| vatId |
	vatId := self newOnKeys: keys host: host port: port.
	vatId nickname: nick.
	^ vatId.
!

newOnKeys: keys port: port

	| identity |
	Socket initializeNetwork.
	identity := self new
		socketAddress: (InetSocketAddress newOnPort: port);
		yourself.
	identity setupOnPublicKey: keys key privateKey: keys value.
	^ identity
!

newOnKeys: keys port: port nick: nick

	| vatId |
	vatId := self newOnKeys: keys port: port.
	vatId nickname: nick.
	^ vatId.
!

newOnPort: port

	^ self newOnAddress: InetSocketAddress localHostAddress port: port
!

newOnVatId: vatId

	^ self new 
		vatId: vatId;
		yourself
!

newRandomKeys

	^ self newRandomKeysOnPort: self randomPort
!

newRandomKeysOnPort: port

	^ self newOnKeys: self generate2048bitKeySet port: port
!

readFrom: stream

	| id |
	id := super new.
	[ id readFrom: stream ]
		on: Error
		do: [ :ex | NotFound signal].
	^ id
! !

!SessionIdentity class methodsFor:'asn1der'!

fromAsn1DerBytes: bytes

	| type |
	type := (ASN1Module name: #Session) find: #SessionIdentity.
	^ ASN1InputStream decodeBytes: bytes withType: type.
!

initialize

	self initializeASN1Types.
!

initializeASN1Types

	| secureSessionModule |
	secureSessionModule := ASN1Module name: #Session.
	[secureSessionModule remove: (secureSessionModule find: #SessionIdentity)] on: KeyNotFound do: [:ex | ].
	secureSessionModule addImport: (ASN1Module name: #RSA).

	(secureSessionModule sequence: #SessionIdentity mapping: SessionIdentity)
		add: #vatId type: #ASN1UTF8StringType;
		add: #publicKey type: #RSAPublicKey;
		add: #privateKey type: #RSAPrivateKey;
		add: #socketAddress type: #InetSocketAddress;
		add: #nickname type: #ASN1UTF8StringType;
		yourself.
	secureSessionModule find: #SessionIdentity.

! !

!SessionIdentity class methodsFor:'examples'!

sampleVatId1
	"SessionIdentity sampleVatId1"
	"
		| id |
		id := self newRandomKeysOnPort: 10011.
		((PBESHA1Encryptor newPassword: 'sampleVatId1') encrypt: id asByteArray) base64Encoded.
	"

	| pbeString id |
	pbeString := 'yF37H52C2fQAABOIAAABAAAQfRwyw+OEhn5qocJV+4ENYwQQ+MqNFRSF4fnBCKJZ/Hw6vtCy
kAl69Km2pujSxUuRySM1o3nZBlYbKpadEDAMIjkNSkVh+lQPu9EVTmJAE8kybmciin1PK28T
FAJQ141MsBI9pjMxJ9iNCKqzPWQt907NNhqHOqTEFL11X7Y5vnSALcX/glyAa4EVjoybVy7o
DF/ohpmvfHnD1ao8PfSgBMsnWGHrDgMl5nHDbmVT0Yetj6kPN3/8kAqMejPQSc7OKfVcYpbF
MdW9xo2B+imKVOrDe0cQynHMF5a3ievgPz02qCuzpjpS1XW0FIuhOCER6byTTgqbzLRh0CUk
ZE5tEqpGTnvjTPUXuRZqCNE3/PIjcyw08NZ2l9fCsOb9UrVpLZjbOI0iNPvf/wGynwEZrFhj
GUyX5fAEwUEGP/Z5et6uqK3IvtsHjg10KhEnWQzCZrMfpcuOZen/gfBwjYFVw+/GfFd5hpTb
YckE8VeXclokMXn0nzyVqQBWc4DQoX6TKoyvqAzS9wfgNS4t5GKeNbeMNJYfxBREi4M2mHLQ
yC9DrPrWfw6L95I3djVvXXtMLZ0X+TTvr03O4G7iGgqCkT6AAIybfo8QGlKaT0oKlt47Q2o+
JFy2VQGdEMQV8mAkH9teHLFHj4ruK5mMOa6H3h/V2FPg2360f2teUNwKiFXj3VAqSpd87AiI
/Z83cFcVs9IijuafL01Gg/esuQAbvgixUd/Me+v2cBF/dSil4obYjNy8ZnuegTC5m2h/eNn2
0eCH3KpQFlPtK5E1JxTjn3el48ujO3VrKf3LovGThv8NPH55NfcfTOKSbTdLZ4yYLfipJhzl
WwvIXOp0agRsW8tH57mIJR3NaaNXKlGSQYUsRgDZbqKSgoVzPwaYoY+742+Ep0CNUrbkVKyQ
zgx7PPFAjYRua/K80BPb5dXEoFS2VSJcBUVgKypX1f1ELVXYBjomc1nFkx/ad6TTufrOuFh4
Nb63FVIgepPWcf8phmbj0M0iUM/keNJQQJ05NQahzWi1WHc4Mwpnh3e6zcuow3T1+IYoZf6G
B/hTgj1wmM9srRqABXnuEZCIIY6M3ZOc/82tdNd44+y1jeh++5hcyCvuSW9CXNHRm8MkLEx/
x9DLPBaCdEpOqmfuLkqLpJBPiEntpsehnM4musR151aKSmyQmqBZITvWlHL1j0Bzz5T0N16e
yBQfMcgpBHGKqFeO+ayCqzeRq8fY0i8Tq7zmN9PeNZ52FIRXJTJf1NVMjNASq58/j4oajFYM
AdmRMQ+vR6XU/EE9y9A3Kc2CWBrOEnuS48rxbHJ6lPZJLnBCnvBFQag9qUG3PV5lmUyN8SBZ
pFJgD2j4FKcAPYa1F7hnBYDO8e2ySNSnH6U1jZtAslf7indtFK6QR4SdqeptZOZPqKQ='.

	id := self fromByteArray: ((PBESHA1Encryptor newPassword: 'sampleVatId1') decrypt: pbeString base64Decoded).
	id socketAddress: (InetSocketAddress newOnPort: id port).
	^ id
!

sampleVatId2
	"SessionIdentity sampleVatId2"
	"
		| id |
		id := self newRandomKeysOnPort: 10012.
		((PBESHA1Encryptor newPassword: 'sampleVatId2') encrypt: id asByteArray) base64Encoded.
	"

	| pbeString id |
	pbeString := 'uoUdJfiJVoUAABOIAAABAAAQu1pALMGbq0h/I68KZuwtlgQQN1r0EGADBBjNyocs8/iLFrhW
Z57Q5W3LbreGeZZyuM1Qx/2zoXoFiBQkV+fz8Imc/bQmIpEaQxAFDEVawk/8bOG4/Op7NWtu
jonoahx95WF1uEUlqp4XIkczE0buRKa2s+tL4KCyq+vdrurhos02HpImNH6fNWuN0dWiWaQf
AjPesvkrrJf7ZS1vgmzpgonnjrfvnZy6veKjd51TenG1NqZXMkrYQYXRFXUKC3CuDH4qqQri
t92J27sFBhEvbbu02mn+Y49t43Q0d6NsHODZbfz07wHngRXyB7K0+PtRKil5gWE9ryXbgZNG
IxyZk5Eatn9onRE+utTHehli5ptdMWIBWpU9zvXgZS6pDfB5JYnpiKjohhSrSK1xFvOOeTgZ
A6iuvko9gGujWW0r7/VDkZ1zFF3V2GXIveekO77buWm7VacQDRH/GCPtmho5Hu2f5Gjl3LeN
0WQXTMWl0cG6EjgeoBGcQhpJLKANJ94zl3vtyx3HkIoU7LYV++bDCw9maygVdBvpNHtmDbrT
7VLykaR2AGHr4OLp2HE/EmUdlt3L+MDEJeDAThH02FEff0VV5vbDDxQuPWg64Q0LQd2INuWV
J/LFVnsllowwttIqWhX0KhL/tg0yJALpYXcN4lxTyHE1dCQ/En9ODo1t7k7yyxUIVI6KzPHy
gRA//NSIfyQWwvPuv0y9MaUWFwqFk3WceVVTqeKtj5bene4tjYoH1ylvLNt1yhEGZeKtAjwn
QuLRxBewUkx/9wSTQCrbS+bGbA0O0njp+msc2nx1aQMRCLX+iit9oyrLdCkPEC7MPasvO53o
EbU7ItXDJMbYJLxJIKnjvatINdNXNYa8NHMuu3BauFYuiDbn8p9P00y1Wo5Oh2g9vPoBsJ8v
30Zj7Dl1hUMop6l+7calCiJDQx/OYz8jaHBx2HhDzXTpd2uUqYvm4twn1yOvdr81XZ6lW9Mb
Wj2bHIesaQYoOQnanVoGu5PXHHl+pdU9pHQ9NiFmbIkhc1QoaGVrkcBRi9Jsuh17Wb3MqJZn
YS851W7VXvL3Kjv+c75zZPf3gkJNrdgWHB6YLSxZOWs9uNEwbDN6jep/YYh3vJ8uD+Xs342k
Cu8JeNUxZBvQGOZFfinwk1jZrIu1V14ypX3+BgqV7N8uyeT3t54yAiU+8WmmSu6AA+Fe6UkJ
zq/+OGeU2j41wFxJTWZHRWm32vOy8C+Dt4CrLSd11JtnN/BO5QQ3m9HCeRwSdfnFXpCEQ7f8
RAzaBm9QFEtvc410XWYsvtZ1inCvnW63H4ZL1C0VZffBYIauu6Z6NbQeDWrGmTTvBvnAFofL
3Gr9DX9sX0jXyR9UIJxpXNVa/apUXiMJxRHvLkcxz/H6fc8ZKWIKycUInCdPvjuJZLQ='.

	id := self fromByteArray: ((PBESHA1Encryptor newPassword: 'sampleVatId2') decrypt: pbeString base64Decoded).
	id socketAddress: (InetSocketAddress newOnPort: id port).
	^ id
!

sampleVatId3
	"SessionIdentity sampleVatId3"
	"
		| id |
		id := self newRandomKeysOnPort: 10013.
		((PBESHA1Encryptor newPassword: 'sampleVatId3') encrypt: id asByteArray) base64Encoded.
	"

	| pbeString id |
	pbeString := 'wdNUSbe0oBIAAAu4AAABAAAQxD3MHNEpONvMcAldobOWIQQQ8uRnhuwapLIv5IEvOftcLQKO
ibcpMVuYDwJeWJSDWlEtYxY+Ss1MNZE9xaD1i0LG3EUNBzDBarYmOELmVsyYwFeukKUXh9PP
2PGGNW5hNt+8ZwwdmER9IZkMnpPTeSqRe0zyEqFoH1cVtoXf0h8oT9JoMKKjRNFG2dzx8ZJu
m69Is1dFb+TzoZ5m0rZQWBcy1CTlHRvfFq2BXobwRmV+eMm9IftMcykAtoktsljsMtfD00oF
ezyptbTNwWzxXjmYs9lJuWMyIKLmqxP7UVWrpbuOPtXDyzF30FIzQQzFR4VYYs1oLEV0xIMu
F+yKGtSACiQbj8Y7SNf1Tz6xBIb9biFGMrZyNJSL+3/mI3bLXCcPHjWNokBgdh47O+GU4qCy
DBdSsQ/CXSPCvp4x3Ebe/hl9wa5YFfs0YWpjfSzXh5OkEovIoA10H97Wl8eR/tyL6/KHSEBY
TjDw+lvT93IT4bLLwWYMF3BOk3Su1s39QieQCbGDqdKJeEyHdu1vzMIiVucZ/svUxGCcPxwA
oKUUkIP7fjV57RZpfBwVZVDI96BBO4qwOiWEL3NRRZNUu7asuV9ReSEd6joZG9Ax70qqxaU4
nna+HcSFWWsHq0bmwu6jmRnUGkt6ZTECAoweEx0n/pH+Md4Y2U03UoymN+VVHtNWSJlWJnT2
KnKxQQ7hHqhNo4JFAOWVLwnlU6v003M/Oii9ia6RGxqf3Rt07Mud2LPNnqdDBWW4z74vhqFB
SDBqpGr/xnZ7Rbe1rqrIEvRtpY77Nq4SwTm3z7mxtpPDaNTzhNpfrePsuxa/rRf71hAhCcsr
mpaXinFAmP/d/ac/WWxzd5WaTqpeIhxtgQrwyGCYq6jidBOWI1M4nFaDXMXNStDL+HUk9L9R
mAFBUryoGxgUswU24MmbPoH6KhhCbiGp466judfpRY2jKYoa6Q6zazLVMfUB/OSCRVh485dQ
diDMNCS+ghsRtGlYAoYQn1/ekoKtrt9Axbnjvgl7Os4dCgFlAGnDl9Rvu+xqkZP5aNZQmNsr
oJWG99MJVnVXjFlDNTZoq+VhSdO8x8Z/v/mLvtHgU1Kw+9bU4FVzGCSZ+7zzfFrgw8PzxRz7
jOL/6Tgf5VImkMwEIaxFgkGWMnXxM/UWt3BiLY01SL29L6jcMZezrKV1ub1OpmseCGiD3tCY
v0rtLkc2Xsvl85h1XuBSCRx/fkZXl2+MURijHRSfimidYBI9KwV0Inab8/rT7QiUujoRIx0R
0TKB3sBX4OVtsnundQflyInYR17HLTc+k6yycIcgUv8b7L/HfmXDMfKAOZ6SJF7EkVfVnyIm
eUXqM1/ZlgFdjrdt6b6v/lXdX99qDowQIIVV2Bqntn4lTuFSupD5YayEtmUY0zfmQbk='.

	id := self fromByteArray: ((PBESHA1Encryptor newPassword: 'sampleVatId3') decrypt: pbeString base64Decoded).
	id socketAddress: (InetSocketAddress newOnPort: id port).
	^ id
! !

!SessionIdentity class methodsFor:'private'!

defaultPort

	^ 10001
!

generate2048bitKeySet
	"self generateKeySet"

	| generator public private |
	generator := RSAKeyPairGenerator new bits: 2048.
	public := generator publicKey.
	private := generator privateKey.
	^ public -> private
!

generateKeySet
	"self generateKeySet"

	| generator public private |
	generator := RSAKeyPairGenerator new bits: 2048.
	public := generator publicKey.
	private := generator privateKey.
	^ public -> private
!

isPassByConstruction

	^ true
!

randomPort

	^ 10000 + 1000 atRandom.
! !

!SessionIdentity methodsFor:'accessing'!

address

	^ self socketAddress address
!

asPublicIdentity

	^ self class basicNew
		socketAddress: self socketAddress deepCopy;
		setupOnPublicKey: self publicKey deepCopy;
		yourself
!

asVatLocation

	^ self class basicNew
		socketAddress: self socketAddress deepCopy;
		vatId: self vatId deepCopy;
		yourself
!

host

	^ self socketAddress host
!

nickname

	^ nickname isNil
		ifTrue: [nickname := self vatId asString]
		ifFalse: [nickname].
!

nickname: nick

	nickname := nick.
!

port

	^ self socketAddress port
!

privateKey

	^ privateKey
!

privateKey: key

	privateKey := key.
!

publicKey

	^ publicKey
!

publicKey: key

	publicKey := key.
!

socketAddress

	^ socketAddress
!

socketAddress: anObject

	socketAddress := anObject
!

vatId

	^vatId
!

vatId: anObject

	vatId := anObject
! !

!SessionIdentity methodsFor:'binding'!

calculateVatId

	(self vatId isNil or: [self vatId = '<unknown>'])
		ifTrue: [self vatId: (SecurityOps base64EncodedCryptoHash: publicKey)].
	(self nickname isNil or: [self nickname = '<unknown>'])
		ifTrue: [self nickname: self vatId].
!

receivePublicKey: aKey

	publicKey := aKey
!

setupOnPublicKey: aPublicKey

	publicKey := aPublicKey.
	self calculateVatId.
!

setupOnPublicKey: aPublicKey privateKey: aPrivateKey

	publicKey := aPublicKey.
	privateKey := aPrivateKey.
	self calculateVatId.
! !

!SessionIdentity methodsFor:'comparing'!

= anotherObject

	^ ( anotherObject class includesBehavior: self class )
		and: [ self vatId = anotherObject vatId ].
!

hash

	^ self vatId hash
! !

!SessionIdentity methodsFor:'converting'!

asAsn1DerBytes

	| type |
	type := (ASN1Module name: #Session) find: #SessionIdentity.
	^ ASN1OutputStream encode: self withType: type
!

asByteArray

	| stream |
	stream := #[] writeStream.
	self writeTo: stream.
	^ stream contents.
!

readFrom: stream

	vatId := stream nextUtfString asByteArray asString.
	publicKey := (RSAPublicKey fromAsn1DerBytes: stream nextUtfString asByteArray readStream).
	privateKey := (RSAPrivateKey fromAsn1DerBytes: stream nextUtfString asByteArray readStream).
	self socketAddress: (InetSocketAddress fromString: stream nextUtfString asByteArray asString).
	self nickname: stream nextUtfString.
!

writeTo: stream

	stream nextUtfStringPut: self vatId.
	stream nextUtfStringPut: self publicKey asAsn1DerBytes.
	stream nextUtfStringPut: self privateKey asAsn1DerBytes.
	stream nextUtfStringPut: self socketAddress asString.
	stream nextUtfStringPut: self nickname.
! !

!SessionIdentity methodsFor:'encrypting'!

decrypt: bytes

	^ privateKey v15Decrypt: bytes.
!

encrypt: bytes

	^ publicKey v15Encrypt: bytes.
! !

!SessionIdentity methodsFor:'printing'!

printOn: aStream

	aStream nextPutAll: 'cap://'.
	self socketAddress notNil ifTrue: [self socketAddress printOn: aStream].
	aStream nextPutAll: '/'.
	self vatId notNil ifTrue: [aStream nextPutAll: (ParrotPercentEncoder encode: self vatId asString)].
! !

!SessionIdentity methodsFor:'signing'!

signMessage: aMsg

	^ privateKey signMessage: aMsg.
!

verify: signature isSignatureOf: byteArray

	^ publicKey verify: signature isSignatureOf: byteArray.
! !

!SessionIdentity methodsFor:'testing'!

canGenerateSignature

	^ self privateKey notNil 
		and: [self publicKey notNil 
		and: [self vatId notNil]]
! !

!SessionIdentity class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionIdentity.st,v 1.1 2018-05-14 00:16:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionIdentity.st,v 1.1 2018-05-14 00:16:50 cg Exp $'
! !


SessionIdentity initialize!

"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#CipherThunkMaker
	instanceVariableNames:'protocolName cipherClass keySize blockSize hasIvParameter'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

CipherThunkMaker comment:''
!


!CipherThunkMaker class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CipherThunkMaker class methodsFor:'as yet unclassified'!

newName: short cipherClass: ciphClass keySize: kSize blockSize: bSize hasIvParameter: hasIV

	^ self new
		initializeName: short cipherClass: ciphClass keySize: kSize blockSize: bSize hasIvParameter: hasIV;
		yourself
!

protocolName

	^ 'cipher'
! !

!CipherThunkMaker methodsFor:'accessing'!

blockSize

	^ blockSize
!

blockSize: anObject

	blockSize := anObject
!

cipherClass

	^ Rijndael
!

cipherClass: anObject

	cipherClass := anObject
!

hasIvParameter

	^ hasIvParameter
!

hasIvParameter: anObject

	hasIvParameter := anObject
!

keySize

	^ keySize
!

keySize: anObject

	keySize := anObject
!

protocolName

	^ protocolName
!

protocolName: anObject

	protocolName := anObject
! !

!CipherThunkMaker methodsFor:'initialize-release'!

initialize

	blockSize := 16.
	keySize := 32.
	hasIvParameter := true.
	protocolName := 'Squeak Rulez!!'.
	cipherClass := Rijndael.
	
!

initializeName: short cipherClass: ciphClass keySize: kSize blockSize: bSize hasIvParameter: hasIV

	protocolName := short.
	keySize := kSize ifNil: [ciphClass keySize].
	cipherClass := ciphClass.
	blockSize := bSize.
	hasIvParameter := hasIV.
	
! !

!CipherThunkMaker methodsFor:'private'!

cipherOnSecretBytes: secretBytes incoming: incoming mode: cryptMode

	| keyBytes cipher |
	keyBytes := (secretBytes size == keySize)
		ifTrue: [secretBytes]
		ifFalse: [keyBytes := secretBytes forceTo: keySize paddingWith: 16r98].
	cipher := cipherClass new.
	keySize ifNotNil: [[cipher keySize: keySize] on: Exception do: [:v|]].
	cipher := (cipher key: keyBytes) cbc.
	self hasIvParameter
		ifTrue: [cipher initialVector: (self computeIv: keyBytes incoming: incoming mode: cryptMode)].
	^ cipher
!

computeIv: secretBytes incoming: incoming mode: cryptMode

	| hash receive send |
	hash := self computeIvHash: secretBytes.

	incoming 
		ifTrue: [
			send := hash copyFrom: (self blockSize + 1) to: (self blockSize * 2).
			receive := hash copyFrom: 1 to: self blockSize]
		ifFalse: [
			send := hash copyFrom: 1 to: self blockSize.
			receive := hash copyFrom: (self blockSize + 1) to: (self blockSize * 2)].

	^ (cryptMode == #ENCRYPT)
		ifTrue: [send]
		ifFalse: [receive].
!

computeIvHash: secretBytes

	| opsHash |
	opsHash := SecurityOps hash: secretBytes pad: 16r33.
	[(blockSize * 2) > opsHash size] whileTrue: [opsHash := opsHash, (SecurityOps hash: secretBytes pad: 16r33)].
	^ opsHash
! !

!CipherThunkMaker methodsFor:'thunk'!

makeThunkOn: secretBytesHolder incoming: incoming

	| downCipher ivHolder upCipher |
	downCipher := self 	cipherOnSecretBytes: (secretBytesHolder at: 1) incoming: incoming mode: #ENCRYPT.
	upCipher := self cipherOnSecretBytes: (secretBytesHolder at: 1) incoming: incoming mode: #DECRYPT.
	secretBytesHolder at: 1 put: nil.
	ivHolder := Array new: 1.

	[^ (Thunk new)
					upThunk: [:frame | 
						upCipher hasVector ifTrue: [upCipher initialVector: frame header ivSequence].
						upCipher decrypt: frame payload ];
					headerMakerThunk: [:frame | Encrypted ivSequence: (ivHolder at: 1) ];
					downThunk: [:frame | | chunk |
						ivHolder at: 1 put: (downCipher hasVector ifTrue: [downCipher vector copy] ifFalse:[#[]]).
						chunk := downCipher encrypt: frame asByteArray.
						downCipher vector: (chunk copyFrom: (chunk size - downCipher blockSize + 1) to: chunk size).
						chunk ];
					yourself]
			on: Exception
			do: [ :ex | self error: 'protocol install failure: ', ex ].
! !

!CipherThunkMaker class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__CipherThunkMaker.st,v 1.2 2018-05-14 00:38:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__CipherThunkMaker.st,v 1.2 2018-05-14 00:38:44 cg Exp $'
! !


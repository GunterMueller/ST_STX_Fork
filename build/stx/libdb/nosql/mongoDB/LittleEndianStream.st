"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#LittleEndianStream
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-BSON'
!


!LittleEndianStream class methodsFor:'instance creation'!

on: aReadStream 
	^self new setReader: aReadStream
! !

!LittleEndianStream methodsFor:'accessing'!

contents
	^stream contents
!

position
	^stream position
!

position: anInteger 
	stream position: anInteger
! !

!LittleEndianStream methodsFor:'private'!

setReader: aReadStream 
	stream := aReadStream
! !

!LittleEndianStream methodsFor:'reading'!

nextByte
	"Worry about sign? What sayeth the spec?"

	^stream next
!

nextBytes: anInteger

	^stream next: anInteger
!

nextInt32
	| unsigned |
	unsigned := self nextUInt32.
	^unsigned <= ((2 raisedTo: 31) - 1)
		ifTrue: [unsigned]
		ifFalse: [((2 raisedTo: 32) - unsigned) negated]
!

nextInt64
	| unsigned |
	unsigned := stream next + (stream next bitShift: 8) + (stream next bitShift: 16) + (stream next bitShift: 24) + (stream next bitShift: 32) + (stream next bitShift: 40) + (stream next bitShift: 48) + (stream next bitShift: 56).
	^unsigned <= ((2 raisedTo: 63) - 1)
		ifTrue: [unsigned]
		ifFalse: [((2 raisedTo: 64) - unsigned) negated]
!

nextString
	| writer encoder |
	encoder := GratuitousIncompatibilities utf8Codec encoderFor: stream.
	writer := String new writeStream.
	[| next |
	next := GratuitousIncompatibilities codecNext: encoder.
	next asInteger = 0 ifTrue: [^writer contents asString].
	writer nextPut: next] repeat
!

nextUInt32
	^stream next + (stream next bitShift: 8) + (stream next bitShift: 16) + (stream next bitShift: 24)
! !

!LittleEndianStream methodsFor:'writing'!

encode: aString
	^(GratuitousIncompatibilities utf8Codec encode: aString) asByteArray
!

flush
	stream flush
!

nextBytePut: anInteger 
	stream nextPut: anInteger
!

nextBytesPut: aByteArray 
	stream nextPutAll: aByteArray
!

nextEncodedStringPut: aByteArray 
	self 
		nextBytesPut: aByteArray;
		null
!

nextInt32Put: anInteger 
	self nextBytePut: (anInteger bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -8) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -16) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -24) bitAnd: 16rFF)
!

nextInt64Put: anInteger 
	self nextBytePut: (anInteger bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -8) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -16) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -24) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -32) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -40) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -48) bitAnd: 16rFF).
	self nextBytePut: ((anInteger bitShift: -56) bitAnd: 16rFF)
!

nextSizedStringPut: aString
	| encoded |
	encoded := self encode: aString.
	self nextInt32Put: encoded size + 1.	"For terminating null"
	self nextEncodedStringPut: encoded
!

nextStringPut: aString 
	| encoded |
"	encoder := UTF8StreamEncoder new.
	aString do: [:each | encoder nextPut: each on: stream]."
	encoded := self encode: aString.
	self nextEncodedStringPut: encoded 
!

null
	self nextBytePut: 0
! !

!LittleEndianStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/LittleEndianStream.st,v 1.1 2013-04-04 21:54:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/LittleEndianStream.st,v 1.1 2013-04-04 21:54:27 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpMemoryWriteStream
	instanceVariableNames:'chunks currentChunk chunkPosition chunkSize lastSize'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpMemoryWriteStream class methodsFor:'instance creation'!

chunkSized: chunkSize
	
	^(self basicNew)
		chunkSize: chunkSize;
		initialize;
		yourself
!

new
	
	^super new initialize
! !

!MpMemoryWriteStream methodsFor:'*MessagePack-Squeak-Core'!

int16
	"Answer the next signed, 16-bit integer from this (binary) stream."
	| n |
	n := self next.
	n := (n bitShift: 8) + (self next).
	n >= 16r8000 ifTrue: [n := n - 16r10000].
	^ n
!

int16: anInteger
	"Store the given signed, 16-bit integer on this (binary) stream."

	| n |
	anInteger < 0
		ifTrue: [n := 16r10000 + anInteger]
		ifFalse: [n := anInteger].
	self nextPut: (n digitAt: 2).
	self nextPut: (n digitAt: 1).
!

int32
	"Answer the next signed, 32-bit integer from this (binary) stream."
	"Details: As a fast check for negative number, check the high bit of the first digit"
	| n firstDigit |
	n := firstDigit := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	firstDigit >= 128 ifTrue: [n := -16r100000000 + n].  "decode negative 32-bit integer"
	^ n
!

int32: anInteger
	"Store the given signed, 32-bit integer on this (binary) stream."

	| n |
	anInteger < 0
		ifTrue: [n := 16r100000000 + anInteger]
		ifFalse: [n := anInteger].
	self nextPut: (n digitAt: 4).
	self nextPut: (n digitAt: 3).
	self nextPut: (n digitAt: 2).
	self nextPut: (n digitAt: 1).
!

int64
	"Answer the next signed, 32-bit integer from this (binary) stream."
	"Details: As a fast check for negative number, check the high bit of the first digit"
	| n firstDigit |
	n := firstDigit := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	firstDigit >= 128 ifTrue: [n := -16r10000000000000000 + n].  "decode negative 64-bit integer"
	^ n
!

int64: anInteger
	"Store the given signed, 64-bit integer on this (binary) stream."

	| n |
	anInteger < 0
		ifTrue: [n := 16r10000000000000000 + anInteger]
		ifFalse: [n := anInteger].
	self nextPut: (n digitAt: 8).
	self nextPut: (n digitAt: 7).
	self nextPut: (n digitAt: 6).
	self nextPut: (n digitAt: 5).
	self nextPut: (n digitAt: 4).
	self nextPut: (n digitAt: 3).
	self nextPut: (n digitAt: 2).
	self nextPut: (n digitAt: 1).
!

uint16
	"Answer the next unsigned, 16-bit integer from this (binary) stream."
	| n |
	n := self next.
	n := (n bitShift: 8) + (self next).
	^ n
!

uint16: anInteger
	"Store the given unsigned, 16-bit integer on this (binary) stream."
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1).
!

uint32
	"Answer the next unsigned, 32-bit integer from this (binary) stream."
	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	^ n
!

uint32: anInteger
	"Store the given unsigned, 32-bit integer on this (binary) stream."
	self nextPut: (anInteger digitAt: 4).
	self nextPut: (anInteger digitAt: 3).
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1).
!

uint64
	"Answer the next unsigned, 64-bit integer from this (binary) stream."
	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	^ n
!

uint64: anInteger
	"Store the given unsigned, 64-bit integer on this (binary) stream."		
	self nextPut: (anInteger digitAt: 8).
	self nextPut: (anInteger digitAt: 7).
	self nextPut: (anInteger digitAt: 6).
	self nextPut: (anInteger digitAt: 5).
	self nextPut: (anInteger digitAt: 4).
	self nextPut: (anInteger digitAt: 3).
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1).
! !

!MpMemoryWriteStream methodsFor:'accessing'!

chunkPosition
	
	^chunkPosition
!

chunkPosition: anObject
	
	^chunkPosition := anObject
!

chunkSize
	
	^chunkSize ifNil: [chunkSize := 1024]
!

chunkSize: anObject
	
	chunkSize := anObject
!

chunks
	
	^chunks
!

chunks: anObject
	
	chunks := anObject
!

currentChunk
	
	^currentChunk
!

currentChunk: anObject
	
	^currentChunk := anObject
!

lastSize
	
	^lastSize
!

lastSize: anObject
	
	lastSize := anObject
! !

!MpMemoryWriteStream methodsFor:'actions'!

asByteArray
	"Answer receiver as byte array."
	
	| bytes pos idx len coll bytesSize |
	bytes := ByteArray new: (bytesSize := self size).
	pos := 0.
	idx := 1.
	[coll := self chunks at: idx.
	len := coll size.
	pos + len < bytesSize]
		whileTrue:
			[bytes
				replaceFrom: pos + 1
				to: (pos := pos + len)
				with: coll
				startingAt: 1.
			idx := idx + 1].
	bytes
		replaceFrom: pos + 1
		to: bytesSize
		with: coll
		startingAt: 1.
	^bytes
!

contents
	
	^self asByteArray
!

nextPut: integer
	
	self chunkPosition >= self chunkSize ifTrue: [self moveToNext].
	self chunkPosition: self chunkPosition + 1.
	self currentChunk
		at: self chunkPosition
		put: integer
!

nextPutAll: bytes
	
	self
		putBytes: bytes
		sized: bytes size
!

position
	
	| idx size coll |
	self currentChunk isNil ifTrue: [^0].
	idx := 1.
	size := 0.
	[(coll := self chunks at: idx) == self currentChunk]
		whileFalse:
			[idx := idx + 1.
			size := size + coll size].
	^size + self chunkPosition
!

size
	
	| size count |
	self currentChunk isNil ifTrue: [^0].
	size := 0.
	count := self chunks size.
	1
		to: count - 1
		do: [:idx | size := size + (self chunks at: idx) size].
	self currentChunk == (self chunks at: count)
		ifTrue:
			[self lastSize < self chunkPosition
				ifTrue: [self lastSize: self chunkPosition]].
	^size + self lastSize
! !

!MpMemoryWriteStream methodsFor:'initialize-release'!

initialize
	
	chunks := OrderedCollection new.
	self makeSpace
! !

!MpMemoryWriteStream methodsFor:'private'!

makeSpace
	
	self chunks add: self prepareCurrentChunk.
	self chunkPosition: 0.
	self lastSize: 0
!

moveToNext
	
	| curChunk |
	self chunkPosition: 0.
	curChunk := self currentChunk.
	(curChunk isNil or: [curChunk == self chunks last])
		ifTrue: [self makeSpace]
		ifFalse:
			[1
				to: self chunks size
				do:
					[:idx | 
					(self chunks at: idx) == curChunk
						ifTrue:
							[self currentChunk: (self chunks at: idx + 1).
							^self]]]
!

prepareCurrentChunk
	
	^self currentChunk: (ByteArray new: self chunkSize)
!

putBytes: bytes sized: len
	
	len > (self chunkSize - self chunkPosition)
		ifTrue:
			[(self currentChunk notNil
				and: [self chunks last == self currentChunk and: [len > 64]])
				ifTrue:
					[self chunks
						at: self chunks size
						put:
							(self currentChunk
								copyFrom: 1
								to: self chunkPosition).
					self chunks add: bytes.
					self makeSpace]
				ifFalse:
					[1
						to: len
						do: [:i | self nextPut: (bytes at: i)]]]
		ifFalse:
			[self currentChunk
				replaceFrom: self chunkPosition + 1
				to: self chunkPosition + len
				with: bytes
				startingAt: 1.
			self chunkPosition: self chunkPosition + len]
! !

!MpMemoryWriteStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpMemoryWriteStream.st,v 1.2 2018-05-08 11:02:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpMemoryWriteStream.st,v 1.2 2018-05-08 11:02:09 cg Exp $'
! !


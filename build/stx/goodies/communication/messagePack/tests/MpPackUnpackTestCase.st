'From Smalltalk/X, Version:7.1.0.0 on 07-05-2018 at 10:00:58 PM'                !

"{ Package: 'stx:goodies/communication/messagePack/tests' }"

"{ NameSpace: Smalltalk }"

MpTestCase subclass:#MpPackUnpackTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'MpConstantsPool'
	category:'MessagePackTest-Core'
!

!MpPackUnpackTestCase class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!MpPackUnpackTestCase methodsFor:'fixtures'!

complexArraysArray
	^ self complexCollectionSizes collect: [:each | self createComplexArraySized: each]
!

complexMapsArray
	^ self complexCollectionSizes collect: [:each | self createComplexMapSized: each]
!

floatsArray
	^ #(3.14159 3.141592653589793)
!

integersArray
	^ #(0 1 126 127 -1 -2 -31 -32 -128 -33 -32768 -129 128 32767 -2147483648 -32769 32768 2147483647 -9223372036854775808 -2147483649 2147483648 9223372036854775807 )
!

simpleArraysArray
	^ self simpleCollectionSizes collect: [:each | self createSimpleArraySized: each]
!

simpleMapsArray
	^ self simpleCollectionSizes collect: [:each | self createSimpleMapSized: each]
! !

!MpPackUnpackTestCase methodsFor:'private'!

complexCollectionSizes
	^ #(0 1 31 32) "For avoiding timeout"
!

createArraySized: size
	| col idx |
	col := OrderedCollection withAll: #(true false nil 1 -1 3.14 -3.14).
	"col add: (ByteArray new: 100 withAll: 100).
	col add: (Array new: 200 withAll: #(2)).
	col add: (Dictionary new at: 3 put: 333; yourself)."
	idx := self atRandom: col size.
	^self newCollection: Array sized: size withAll: (col at: idx)
!

createByteStringSized: size
	^ (self createRawBytesSized: size) asString
!

createComplexArraySized: size
	| col dict |
	col := OrderedCollection new.
	col add: (self newCollection: ByteArray sized: 100 withAll: 100).
	col add: (self newCollection: Array sized: 200 withAll: #(2)).
	col add: (Dictionary new at: 3 put: 333; yourself).
	
	dict := Dictionary new: size.
	1 to: size do: [:idx | dict at: (idx printString asByteArray) put: (self atRandom: col size)].
	^dict
!

createComplexMapSized: size
	| col idx |
	col := OrderedCollection new.
	col add: (self newCollection: ByteArray sized: 100 withAll: 100).
	col add: (self newCollection: Array sized: 200 withAll: #(2)).
	col add: (Dictionary new at: 3 put: 333; yourself).
	idx := self atRandom: col size.
	^ Array new: size withAll: (col at: idx)
!

createExtSized: size
	| data |
	data := self createRawBytesSized: size.
	^MpExtValue typeCode: 0 data: data	
!

createFixExtSized: size
	| data |
	data := self createRawBytesSized: size.
	^MpFixextValue typeCode: 0 data: data	
!

createRawBytesSized: size
	^ self newCollection: ByteArray sized: size withAll: (self atRandom: 255)
!

createSimpleArraySized: size
	| col idx |
	col := OrderedCollection withAll: #(true false nil 1 -1 3.14 -3.14).
	idx := self atRandom: col size.
	^self newCollection: Array sized: size withAll: (col at: idx)
!

createSimpleMapSized: size
	| values dic |
	values := #(true false nil 1 -1 3.14 -3.14).
	dic := Dictionary new: size.
	1 to: size do: [:idx | dic at: idx put: (values at: (idx - 1 \\ values size + 1))].
	^dic
	
!

mapSizes
	^ #(0 1 31 32 65535 65536)
!

rawBytesArray
	^ self rawBytesSizes collect: [:each | self createRawBytesSized: each]
!

rawBytesSizes
	^ #(0 1 31 32 65535 65536)
!

rawExtValueArray
	| exts |
	exts := self rawBytesSizes collect: [:each | self createExtSized: each].
	1 to: exts size do: [:idx | (exts at: idx) typeCode: idx].
	^exts
!

rawFixExtValueArray
	| sizes exts |
	sizes := #(1 2 4 8 16).
	exts := sizes collect: [:each | self createFixExtSized: each].
	1 to: exts size do: [:idx | (exts at: idx) typeCode: idx].
	^exts
!

rawStringArray
	^ self rawBytesSizes collect: [:each | self createByteStringSized: each]
!

simpleCollectionSizes
	^ #(0 1 31 32 65535 65536)
! !

!MpPackUnpackTestCase methodsFor:'testing'!

testPackUnpackArray
	"self debug: #testPackUnpackArray"
	self simpleArraysArray do: [:each | | packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]
	]
			
		
!

testPackUnpackBinBytes
	"self debug: #testPackUnpackBinBytes"
	self rawBytesArray do: [:each | | packed unpacked |
		packed := each messagePacked: [:settings | settings formatVersion: 2013].
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each].
	]
			
		
!

testPackUnpackComplexArray
	"self debug: #testPackUnpackComplexArray"
	self complexArraysArray do: [:each | | packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]
	]
			
		
!

testPackUnpackComplexMap
	"self debug: #testPackUnpackComplexMap"
	self simpleMapsArray do: [:each | | packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]
	]
			
		
!

testPackUnpackExt
	"self debug: #testPackUnpackExt"
	self rawExtValueArray do: [:each | | packed unpacked |
		packed := each messagePacked: [:settings | settings formatVersion: 2013].
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [unpacked isMemberOf: MpExtValue].
		self should: [each typeCode = unpacked typeCode].
		self should: [self collectionEquals: unpacked data with: each data].
	]
			
		
!

testPackUnpackFalse
	"self debug: #testPackUnpackFalse"
	| packed unpacked |
	packed := false messagePacked.
	self should: [packed isMemberOf: ByteArray].
	self should: [packed = (ByteArray with: MpConstants boolFalse)].
	unpacked := Object fromMessagePack: packed.
	self should: [unpacked = false]
	
			
		
!

testPackUnpackFixExt
	"self debug: #testPackUnpackFixExt"
	self rawFixExtValueArray do: [:each | | packed unpacked |
		packed := each messagePacked: [:settings | settings formatVersion: 2013].
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [unpacked isMemberOf: MpFixextValue].
		self should: [each typeCode = unpacked typeCode].
		self should: [self collectionEquals: unpacked data with: each data].
	]
			
		
!

testPackUnpackFloatingPoint
	"self debug: #testPackUnpackFloatingPoint"
	self floatsArray do: [:each | | packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [unpacked = each]
	]
			
		
!

testPackUnpackInteger
	"self debug: #testPackUnpackInteger"
	self integersArray do: [:each | | packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [unpacked = each]
	]
			
		
!

testPackUnpackMap
	"self debug: #testPackUnpackMap"
	self simpleMapsArray do: [:each | | packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]
	]
			
		
!

testPackUnpackNil
	"self debug: #testPackUnpackNil"
	| packed unpacked |
	packed := nil messagePacked.
	self should: [packed isMemberOf: ByteArray].
	self should: [packed = (ByteArray with: MpConstants undefinedNil)].
	unpacked := Object fromMessagePack: packed.
	self should: [unpacked = nil]
	
			
		
!

testPackUnpackRawBytes
	"self debug: #testPackUnpackRawBytes"
	self rawBytesArray do: [:each | | packed unpacked |
		packed := each messagePacked: [:settings | settings formatVersion: 2008].
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked asByteArray with: each].
		unpacked := Object fromMessagePack: packed setting: [:settings | settings formatVersion: 2008].
		self should: [self collectionEquals: unpacked with: each]
	]
			
		
!

testPackUnpackStrBytes
	"self debug: #testPackUnpackStrBytes"
	self rawStringArray do: [:each | | packed unpacked |
		packed := each messagePacked: [:settings | settings formatVersion: 2013].
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed setting: [:settings | settings formatVersion: 2013].
		self should: [unpacked = each].
	]
			
		
!

testPackUnpackTrue
	"self debug: #testPackUnpackTrue"
	| packed unpacked |
	packed := true messagePacked.
	self should: [packed isMemberOf: ByteArray].
	self should: [packed = (ByteArray with: MpConstants boolTrue)].
	unpacked := Object fromMessagePack: packed.
	self should: [unpacked = true]
	
			
		
! !


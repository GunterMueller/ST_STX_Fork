"{ Package: 'stx:libdb/nosql/mongoDB' }"

"{ NameSpace: Smalltalk }"

Object subclass:#BSON
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-BSON'
!


!BSON class methodsFor:'instance creation'!

writer
	^self new setStream: (LittleEndianStream on: ByteArray new writeStream)
! !

!BSON class methodsFor:'codec'!

read: aStream
	| reader |
	reader := LittleEndianStream on: aStream.
	^(self new setStream: reader) nextDictionary
!

write: aDictionary 
	^self writer 
		nextDictionaryPut: aDictionary; 
		contents
!

writeAll: aCollection 
	| writer |
	writer := self writer.
	aCollection do: [:each | writer nextDictionaryPut: each].
	^writer contents
! !

!BSON methodsFor:'accessing'!

contents
	^stream contents
!

epoch
	^DateAndTime year: 1970 day: 1
!

typeCode: anObject
	^anObject bsonTypeCode
! !

!BSON methodsFor:'private'!

addObjectType: anInteger to: aDictionary
	aDictionary 
		at: self nextKey
		put: (self nextValueForType: anInteger)
!

nextValueForType: anInteger 
	"Uglyness for performance"
	anInteger == 7 		ifTrue: [ ^self nextOID ].
	anInteger == 2 		ifTrue: [ ^self nextSizedString ].
	anInteger == 10 	ifTrue: [ ^self nextNil ].
	anInteger == 8 		ifTrue: [ ^self nextBoolean ].
	anInteger == 16 	ifTrue: [ ^self nextInt32 ].
	anInteger == 18 	ifTrue: [ ^self nextInt64 ].
	anInteger == 1 		ifTrue: [ ^self nextDouble ].
	anInteger == 4 		ifTrue: [ ^self nextArray ].
	anInteger == 3 		ifTrue: [ ^self nextDictionary ].
	anInteger == 14 	ifTrue: [ ^self nextSymbol ].
	anInteger == 9 		ifTrue: [ ^self nextDateAndTime ].
	anInteger == 17 	ifTrue: [ ^self nextTimestamp ].
	anInteger == 6 		ifTrue: [ ^self nextUndefined ].
	anInteger == 11 	ifTrue: [ ^self nextRegex ].
	anInteger == 5 		ifTrue: [ ^self nextBinary ].

	BSONUndefindedType signalCode: anInteger.
!

setStream: aStream
	stream := aStream
! !

!BSON methodsFor:'reading'!

nextArray
	| elements results index |
	elements := self nextDictionary.
	results := Array new: elements size.
	index := 1.
	elements associationsDo: [ :eachAssociation | 
		results at: (eachAssociation key asNumber +1) put: eachAssociation value.
		index := index + 1].
	^results
!

nextBinary
        | size subType |
        size := stream nextUInt32.
        subType := stream nextByte. "sub type byte"
        subType == 3 ifTrue: [ ^ self nextUUID: (stream nextBytes: size) ].
        ^ stream nextBytes: size 
!

nextBoolean
	^stream nextByte = 1
!

nextDate
	^(GratuitousIncompatibilities intToDate: stream nextInt64)
!

nextDateAndTime
	^(GratuitousIncompatibilities intToDateAndTime: stream nextInt64)
!

nextDictionary
        | result byteSize |
        result := Dictionary new.
        byteSize := stream nextUInt32.
        [
            | type |

            type := stream nextByte.
            type = 0 ifTrue: [^result].
            self addObjectType: type to: result
        ] loop.
        ^BSONError signal: 'Attempt to read off end of stream'
!

nextDouble
	^GratuitousIncompatibilities readDoubleFrom: stream
!

nextInt32
	^stream nextInt32
!

nextInt64
	^stream nextInt64
!

nextKey
	^stream nextString
!

nextNil
	^nil
!

nextOID
	| value |

	value := LargePositiveInteger basicNew: 12.
	1 to: 12 do: [:each | value basicAt: each put: stream nextByte].
	^OID value: (GratuitousIncompatibilities compressLargeInteger: value)
!

nextRegex 
	^RxParser safelyParse: self nextSizedString
!

nextSizedString
        | size |
        size := stream nextUInt32.
        ^stream nextString "maybe stream decode: (stream next: size) instead"
!

nextSymbol
	^self nextSizedString asSymbol
!

nextTimestamp
	^self nextDateAndTime asTimeStamp
!

nextUUID: aByteArray 
	^ UUID newFrom: aByteArray
!

nextUndefined
	"Not sure what I should reply here"
	^nil
! !

!BSON methodsFor:'testing'!

isInt32: anInteger
	^anInteger between: (2 raisedTo: 31) negated and: (2 raisedTo: 31) - 1
!

isInt64: anInteger
	^anInteger between: (2 raisedTo: 63) negated and: (2 raisedTo: 63) - 1
! !

!BSON methodsFor:'writing'!

nextArrayPut: anArray
	| elements start end |
	elements := Dictionary new.
	anArray
		keysAndValuesDo: [:eachKey :eachValue | elements at: (eachKey - 1) printString put: eachValue].
	start := stream position.
	stream nextInt32Put: 0.	"Just to make space"
	elements associations do: [:each | each writeBSONOn: self].
	stream null.
	end := stream position.
	stream position: start.
	stream nextInt32Put: end - start.
	stream position: end
!

nextAssociationPut: anAssociation 
	stream nextBytePut: (self typeCode: anAssociation value).
	self nextStringPut: anAssociation key.
	anAssociation value writeBSONOn: self
!

nextBooleanPut: aBoolean
	stream nextBytePut: (aBoolean ifTrue: [1] ifFalse: [0])
!

nextByteArrayPut: aByteArray
	stream 
		nextInt32Put: aByteArray size;
		nextBytePut: 0; "Subtype: Binary / Generic"
		nextBytesPut: aByteArray
!

nextDateAndTimePut: aDateAndTime
	stream nextInt64Put: (GratuitousIncompatibilities dateAndTimeToMilliseconds: aDateAndTime)
!

nextDatePut: aDate 
	stream nextInt64Put: (GratuitousIncompatibilities dateToMilliseconds: aDate)
!

nextDictionaryPut: aDictionary
	| start end |
	start := stream position.
	stream nextInt32Put: 0.	"Just to make space"
	(aDictionary associations asSortedCollection: [:a :b | a key = '_id' | (a key < b key)]) do: [:each | each writeBSONOn: self].
	stream null.
	end := stream position.
	stream position: start.
	stream nextInt32Put: end - start.
	stream position: end
!

nextDoublePut: aDouble 
	stream nextBytesPut: (GratuitousIncompatibilities doubleToBytes: aDouble)
!

nextIntegerPut: anInteger
	"Seems like this belongs here instead of the caller or the stream, but not certain"

	(self isInt32: anInteger) ifTrue: [^stream nextInt32Put: anInteger].
	(self isInt64: anInteger) ifTrue: [^stream nextInt64Put: anInteger].
	BSONError signal: 'Integer too large: ' , anInteger printString
!

nextNilPut
	"This method intentionally if reluctantly left blank"
!

nextOIDPut: anOID 
	| value |
	value := anOID value.
	12 timesRepeat: 
		[stream nextBytePut: (value bitAnd: 16rFF). 
		value := value bitShift: -8]
!

nextRegexPut: aBSONRegex
	stream nextStringPut: aBSONRegex value
!

nextSizedStringPut: aString
	| encoded |
	encoded := stream encode: aString.
	stream nextInt32Put: encoded size + 1.	"For terminating null"
	stream nextBytesPut: encoded asByteArray.
	stream null
!

nextStringPut: aByteString
	stream nextStringPut: aByteString
!

nextSymbolPut: aByteSymbol 
	self nextSizedStringPut: aByteSymbol
!

nextTimestampPut: aTimestamp 
	self nextDateAndTimePut: aTimestamp
!

nextUUIDPut: aUUID
	stream 
		nextInt32Put: aUUID size;
		nextBytePut: 3; "Subtype: Binary / UUID"
		nextBytesPut: aUUID 
!

nextWideStringPut: aWideString 
	self nextSizedStringPut: aWideString
! !

!BSON class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/BSON.st,v 1.3 2016-04-01 21:54:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/BSON.st,v 1.3 2016-04-01 21:54:45 cg Exp $'
! !


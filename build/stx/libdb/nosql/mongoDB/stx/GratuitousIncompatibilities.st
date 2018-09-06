"{ Package: 'stx:libdb/nosql/mongoDB/stx' }"

Object subclass:#GratuitousIncompatibilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core-STX'
!


!GratuitousIncompatibilities class methodsFor:'instance creation'!

new
	"Answer a newly created and initialized instance."

	^super new initialize
! !

!GratuitousIncompatibilities class methodsFor:'As yet unclassified'!

codecNext: aGRCodecStream 
	^aGRCodecStream next
!

compressLargeInteger: aLargeInteger 
	^aLargeInteger compressed
!

doubleToBytes: aDouble 
	| writer coerced |
	writer := ByteArray new writeStream.
	coerced := aDouble asDouble.
	1 to: 8 do: [:each | writer nextPut: (coerced basicAt: each)].
	^writer contents
!

epoch
	^self newYear: 1970 day: 1
!

intToTime: anInteger 
	^Timestamp fromMilliseconds: anInteger + self epoch asMilliseconds
!

newYear: yearInteger day: dayInteger 
	^Timestamp new fromDate: (Date newDay: dayInteger - 1 year: yearInteger)
!

nextPutTimestamp: aTimestamp on: aStream 
	aStream nextInt64Put: aTimestamp asMilliseconds - self epoch asMilliseconds
!

readDoubleFrom: aStream 
	| result |
	result := Double basicNew.
	1 to: 8 do: [:each | result basicAt: each put: aStream nextByte].
	^result
!

socketStreamHost: aString port: anInteger 
        | socket connection stream |
        Smalltalk isSmalltalkX ifTrue:[
            stream := Socket newTCPclientToHost: aString port: anInteger .
            stream isNil ifTrue:[ self error: ('cannot connect to %1:%2' bindWith: aString with: anInteger) ].
        ] ifFalse:[
            socket := SocketAccessor newTCPclientToHost: aString port: anInteger .
            connection := ExternalConnection new.
            connection 
                    input: socket; 
                    output: socket.
            stream := connection readAppendStream.
        ].
        stream binary.
        ^stream
!

timeToBytes: aTimestamp 
	| milliseconds writer |
	milliseconds := aTimestamp asMilliseconds - self epoch asMilliseconds.
	writer := LittleEndianStream on: (ByteArray new: 8) writeStream.
	writer nextInt64Put: milliseconds.
	^writer contents
!

utf8Codec
	^Grease.GRCodec forEncoding: 'utf8'
! !

!GratuitousIncompatibilities class methodsFor:'converting'!

dateAndTimeToMilliseconds: aDateAndTime
	^ (self dateToMilliseconds: aDateAndTime asUTC asDate) + aDateAndTime asUTC asTime asDuration asMilliseconds
!

dateToMilliseconds: aDate 
	^(aDate - ((Date year: 1970 day: 1))) asDuration asMilliseconds
!

intToDate: anInteger 
	^(self intToTime: anInteger) asDate - 1day
!

intToDateAndTime: anInteger
	^(self intToTime: anInteger) 
!

timeToMilliseconds: aDateAndTime 
	^aDateAndTime asDuration asMilliseconds 
! !

!GratuitousIncompatibilities methodsFor:'initialize-release'!

initialize
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Replace this comment with the appropriate initialization code *** "
	^self
! !

!GratuitousIncompatibilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/stx/GratuitousIncompatibilities.st,v 1.2 2013-04-15 16:06:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/stx/GratuitousIncompatibilities.st,v 1.2 2013-04-15 16:06:47 cg Exp $'
! !


"{ Package: 'stx:libdb/libopenDBX/driver' }"!

!Boolean class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString
	aString = '1' ifTrue: [ ^true ].
	aString = '0' ifTrue: [ ^false ].
	DBXError signal: 'Invalid boolean input: ', aString
! !

!ByteArray methodsFor:'*OpenDBXDriver'!

asDbxString
	self asString
! !

!ByteArray class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString 
	^ aString asByteArray 
! !

!Date methodsFor:'*OpenDBXDriver'!

asDbxString
	| stream |
	stream := String new writeStream.
	self printDbxOn: stream.
	^ stream contents asDbxString 
! !

!Date methodsFor:'*OpenDBXDriver'!

printDbxOn: aStream
	aStream
		nextPutAll: self year asString;
		nextPut: $-;
		nextPutAll: (self monthIndex asString padded: #left to: 2 with: $0);
		nextPut: $-;
		nextPutAll: (self dayOfMonth asString padded: #left to: 2 with: $0).
! !

!Date class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString 
	^ self readDbxFrom: aString readStream
! !

!Date class methodsFor:'*OpenDBXDriver'!

readDbxFrom: aStream
	| year month day |

	year := (aStream upTo: $-) asInteger.
	month := (aStream upTo: $-) asInteger.
	day := (aStream upToEnd) asInteger.

	^self year: year 
		month: month 
		day: day
! !

!False methodsFor:'*OpenDBXDriver'!

asDbxString
	^'false'
! !

!Number class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString
	^self readFrom: aString readStream
! !

!Object methodsFor:'*OpenDBXDriver'!

asDbxString
	^ self printString
! !

!Object class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString
	self subclassResponsibility
! !

!String methodsFor:'*OpenDBXDriver'!

asDbxString
	^self class new writeStream
		nextPut: $';
		nextPutAll: self;
		nextPut: $';
		contents
! !

!String class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString
	^aString
! !

!Time methodsFor:'*OpenDBXDriver'!

asDbxString
	| stream |
	stream := String new writeStream.
	self printDbxOn: stream.	
	^ stream contents asDbxString
! !

!Time methodsFor:'*OpenDBXDriver'!

printDbxOn: aStream
	aStream
		nextPutAll: (self hour asString padded: #left to: 2 with: $0);
		nextPut: $:;
		nextPutAll: (self minutes asString padded: #left to: 2 with: $0);
		nextPut: $:;
		nextPutAll: (self seconds asString padded: #left to: 2 with: $0).
! !

!Time class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString 
	^ self readDbxFrom: aString readStream
! !

!Time class methodsFor:'*OpenDBXDriver'!

readDbxFrom: aStream
	| hour minute second |

	hour := (aStream upTo: $:) asInteger.
	minute := (aStream upTo: $:) asInteger.
	second := (aStream upToEnd) asInteger.

	^self hour: hour  
		minute: minute 
		second:  second
! !

!Timestamp methodsFor:'*OpenDBXDriver'!

asDbxString
	| stream |
	stream := String new writeStream.
	self printDbxOn: stream.
	^ stream contents asDbxString
! !

!Timestamp methodsFor:'*OpenDBXDriver'!

printDbxOn: aStream
	aStream
		nextPutAll: self year asString;
		nextPut: $-;
		nextPutAll: (self monthIndex asString padded: #left to: 2 with: $0);
		nextPut: $-;
		nextPutAll: (self dayOfMonth asString padded: #left to: 2 with: $0);
		nextPut: Character space;	
		nextPutAll: (self hour asString padded: #left to: 2 with: $0);
		nextPut: $:;
		nextPutAll: (self minutes asString padded: #left to: 2 with: $0);
		nextPut: $:;
		nextPutAll: (self seconds asString padded: #left to: 2 with: $0).
! !

!Timestamp methodsFor:'*OpenDBXDriver'!

yyyymmddhhmmss
"It returns a String with tha timestamp in yyyy-mm-dd hh:mm:ss format.
Example: 

(TimeStamp 
			year: 2008 
			month: 1 
			day: 20 
			hour: 10 
			minute: 20 
			second: 30) yyyymmddhhmmss.

shows: '2008-01-20 10:20:30'  "

	| stream |
	stream := String new writeStream.
	self printDbxOn: stream.
	^ stream contents
! !

!Timestamp class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString 
	^self readDbxFrom: aString readStream
! !

!Timestamp class methodsFor:'*OpenDBXDriver'!

readDbxFrom: aStream
	| year month day hour minute second |

	year := (aStream upTo: $-) asInteger.
	month := (aStream upTo: $-) asInteger.
	day := (aStream upTo: Character space) asInteger.
	hour := (aStream upTo: $:) asInteger.
	minute := (aStream upTo: $:) asInteger.
	second := (aStream upToEnd) asInteger.
	
	^ self
		year: year
		month: month
		day: day
		hour: hour
		minute: minute
		second: second.
! !

!True methodsFor:'*OpenDBXDriver'!

asDbxString
	^'true'
! !

!UndefinedObject methodsFor:'*OpenDBXDriver'!

asDbxString
	^'NULL'
! !

!UndefinedObject methodsFor:'*OpenDBXDriver'!

isResultSet
	^ false.
! !

!stx_libdb_libopenDBX_driver class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/extensions.st,v 1.2 2013-04-15 13:10:00 cg Exp $'
! !

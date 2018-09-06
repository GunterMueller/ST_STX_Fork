"{ Package: 'stx:libdb/nosql/mongoDB/tests' }"

MongoTestCase subclass:#BSONTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-BSON'
!


!BSONTest methodsFor:'running'!

encodeAndDecode: anObject	
	"Only works with objects for which #= works"
	| actual decode data |
	data := (Dictionary new)
				at: 'k' put: anObject;
				yourself.
	actual := BSON write: data.
	decode := BSON read: actual readStream.
	self
		assert: (decode at: 'k') = anObject
!

testByteArray
	| actual decode data |
	data := (Dictionary new)
				at: 'k' put: #[23 44 12 2 23 55 32 1 23 54 5 32];
				yourself.
	actual := BSON write: data.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray
!

testDate
	| expected actual decode data |
	expected := #[16 0 0 0 9 107 0 0 0 0 0 0 0 0 0 0].
	data := (Dictionary new)
				at: 'k' put: (GratuitousIncompatibilities newYear: 1970 day: 1);
				yourself.
	actual := BSON write: data.
	self assert: expected = actual.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray
!

testDateAndTime
	| dateTime |

	dateTime := DateAndTime year: 2012 month: 11 day: 22 hour: 13 minute: 55 second: 12 offset: 0 asDuration.
	
	self encodeAndDecode: dateTime
!

testEmbeddedDictionary
	| actual decode data subData |
	subData := Dictionary new
		at: 'sk' put: 'v';
		yourself.
	data := Dictionary new
		at: 'k' put: subData;
		yourself.
	actual := BSON write: data.
	decode := BSON read: actual readStream.
	self assert: decode size = 1.
	self assert: (decode at: 'k') size = 1.
	self assert: ((decode at: 'k') at: 'sk') = 'v'
!

testEmpty
	| expected actual decode data |
	expected := #[5 0 0 0 0].
	data := Dictionary new.
	actual := BSON write: data.
	self assert: expected = actual.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray
!

testMultiple
	| actual data reader t f |
	data := Array with: ((Dictionary new)
						at: 't' put: true;
						yourself)
				with: ((Dictionary new)
						at: 'f' put: false;
						yourself).
	actual := BSON writeAll: data.
	reader := actual readStream.
	t := BSON read: reader.
	self assert: (t at: 't').
	f := BSON read: reader.
	self deny: (f at: 'f')
!

testOid
	| actual decode data |
	data := (Dictionary new)
				at: 'k' put: (OID value: 12345678901234);
				yourself.
	actual := BSON write: data.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray
!

testPair
	| expected actual decode data |
	expected := #[14 0 0 0 2 107 0 2 0 0 0 118 0 0].
	data := (Dictionary new)
				at: 'k' put: 'v';
				yourself.
	actual := BSON write: data.
	self assert: expected = actual.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray
!

testTwoPair
	| actual decode data |
	data := (Dictionary new)
				at: 'k' put: 'v';
				at: 'l' put: 'w';
				yourself.
	actual := BSON write: data.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray
!

testVariousTypes
	"2 raisedTo: 31 2147483648"
	"2 raisedTo: 63 9223372036854775808"
	| values |
	values := #('v' ('v') #v nil true false 1.0d 1 -1 -2 2147483647 2147483648 -2147483648 -2147483649 9223372036854775807 -9223372036854775808).
	values do: [:each | self encodeAndDecode: each]
!

testWideString
	| actual decode data |
	data := (Dictionary new)
				at: 'test' put: (String streamContents: [:stream| stream nextPutAll: 'nice test '; nextPut: (Character value: 128513)]);
				yourself.
	actual := BSON write: data.
	decode := BSON read: actual readStream.
	self
		assert: decode associations asArray = data associations asArray.
! !

!BSONTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/BSONTest.st,v 1.1 2013-04-04 22:22:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/BSONTest.st,v 1.1 2013-04-04 22:22:29 cg Exp $'
! !


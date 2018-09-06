"{ Package: 'stx:libdb/nosql/mongoDB/tests' }"

MongoTestCase subclass:#MongoTest
	instanceVariableNames:'collection root database'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core-Tests'
!


!MongoTest methodsFor:'running'!

setUp
	root := Mongo default.
	root open.
	database := root databaseNamed: 'test'.
	collection := database addCollection: 'testCollection'
!

tearDown
	collection drop.
	root close
!

testAdd
	| data |
	data := Dictionary new at: 'key' put: 'value'; yourself.
	collection add: data.
	self assert: (collection includes: data)
!

testAddAll
	| data |
	data := Array 
		with: (Dictionary new at: 'key' put: 'value'; yourself) 
		with: (Dictionary new at: 'key2' put: 'value2'; yourself).
	collection addAll: data.
	self assert: (collection includes: data first).
	self assert: (collection includes: data last)
!

testAddArray
	| data |
	data := Dictionary new at: 'key' put: #(3 1 2 44 5 432); yourself.
	collection add: data.
	self assert: (collection includes: data)
!

testCollectionValidation
	self assert: collection validate isOK
!

testCollections
	| new |
	new := database addCollection: 'collection'.
	[self assert: (database collections contains: [:each | each name = 'collection'])]
		ensure: [new drop]
!

testCursor
	| count data |
	self assert: collection size equals: 0.
	data := Dictionary new at: 'key' put: 'value'; yourself.
	4 timesRepeat: [collection add: data].
	self assert: collection size equals: 4.
	count := 0.
	(MongoCursor root: root query: (
		MongoQuery new
			database: database;
			collection: collection;
			query: data;
			doBlock: [:each | count := count + 1 ];
			chunkSize: 2;
			yourself)) execute.
	self assert: count equals: 4
!

testDatabases
	self assert: (root databases contains: [:each | each name = 'test'])
!

testDelete
	| results data |
	data := (Dictionary new)
				at: 'key' put: 'value';
				yourself.
	collection add: data.
	collection delete: data.
	results := collection query: (collection query).
	self assert: results size = 0
!

testDo
	| count |
	collection add: (Dictionary new at: 'key' put: 'value'; yourself).
	collection add: (Dictionary new at: 'key' put: 'value'; yourself).
	count := 0.
	collection do: [:each | self assert: (each at: 'key') = 'value'. count := count + 1].
	self assert: count equals: 2
!

testError
	"induce an error and make sure an exception is thrown"
!

testInjectInto
	collection add: (Dictionary new at: 'key' put: 2; yourself).
	collection add: (Dictionary new at: 'key' put: 3; yourself).
	self assert: (collection inject: 0 into: [:sum :each | sum + (each at: 'key')]) = 5
!

testInsertAndQuery
	| results |
	collection add: (Dictionary new at: 'key' put: 'value'; yourself).
	results := collection query: (collection query).
	self assert: results size equals: 1.
	self assert: (results first at: 'key') = 'value'
!

testInsertAndQueryWithFields
	| results |
	collection add: (Dictionary new 
		at: 'key' put: 'value'; 
		at: 'foo' put: 'bar'; 
		yourself).
	results := (collection query)
		q: Dictionary new;
		fields: (Dictionary new at: 'foo' put: 'bar'; yourself);
		perform.
	self assert: results size = 1.
	self assert: (results first at: 'foo') = 'bar'.
	self deny: (results first includesKey: 'key')
!

testInsertTwoAndQuery
	| results |
	collection add: (Dictionary new at: 'key1' put: 'value1'; yourself).
	collection add: (Dictionary new at: 'key2' put: 'value2'; yourself).
	self assert: collection size = 2.
	results := collection query: (collection query).
	self assert: results size = 2
!

testIsEmpty
	| data |
	data := Dictionary new at: 'key' put: 'value'; yourself.
	self assert: collection isEmpty.
	collection add: data.
	self deny: collection isEmpty
!

testOccurrencesOf
	| data |
	data := (Dictionary new)
				at: 'key1' put: 'value1';
				yourself.
	collection add: data.
	self assert: (collection occurrencesOf: data) equals: 1
!

testOrderBy
	| results query |
	collection add: (Dictionary new at: 'key' put: 'b'; yourself).
	collection add: (Dictionary new at: 'key' put: 'a'; yourself).
	collection add: (Dictionary new at: 'key' put: 'b'; yourself).
	query := MongoQuery new
		database: database;
		collection: collection;
		query: Dictionary new;
		order: { 'key' -> Mongo ascending} asDictionary.
	results := query perform.
	self assert: (results first at: 'key') equals: 'a'.
!

testRemove
	| data |
	data := Dictionary new at: 'key' put: 'value'; yourself.
	collection add: data.
	self assert: collection size = 1.
	collection remove: data.
	self assert: collection isEmpty
!

testRemoveAll
	| data |
	data := Array 
		with: (Dictionary new at: 'key' put: 'value'; yourself) 
		with: (Dictionary new at: 'key2' put: 'value2'; yourself).
	collection addAll: data.
	self assert: collection size = 2.
	collection removeAll: data.
	self assert: collection isEmpty
!

testRemoveBoth
	"Unlike regular collections, MongCollection>>remove: is more like copyWithout:,
	removing all instances of the offending element."

	| data |
	data := Dictionary new at: 'key' put: 'value'; yourself.
	collection add: data.
	collection add: data.
	self assert: collection size = 2.
	collection remove: data.
	self assert: collection isEmpty
!

testRemoveMissingElementSucceeds
	"Unlike Collection, MongoCollection succeeds if you try to remove a missing element.
	Hence there is no need for remove:ifAbsent:."
	collection add: ((Dictionary new)
				at: 'key1' put: 'value1';
				yourself).
	self assert: collection size = 1.
	collection remove: ((Dictionary new)
				at: 'key2' put: 'value2';
				yourself).
	self assert: collection size = 1 "No exception"
!

testSelect
	| selected |
	collection add: (Dictionary new at: 'key1' put: 'value1'; yourself).
	collection add: (Dictionary new at: 'key2' put: 'value2'; yourself).
	selected := collection select: { 'key1' -> 'value1'} asDictionary.
	self assert: selected size equals: 1
!

testSelectWithLimit
	| selected query |
	collection add: (Dictionary new at: 'key1' put: 'value1'; yourself).
	collection add: (Dictionary new at: 'key2' put: 'value2'; yourself).
	collection add: (Dictionary new at: 'key3' put: 'value3'; yourself).
	query := MongoQuery new
		database: database;
		collection: collection;
		limit: 2.
	selected := query perform.
	self assert: selected size equals: 2
!

testSelectWithLimitAndNumberToSkip
	| firstBatch secondBatch |
	collection add: (Dictionary new at: 'key1' put: 'value1'; yourself).
	collection add: (Dictionary new at: 'key2' put: 'value2'; yourself).
	collection add: (Dictionary new at: 'key3' put: 'value3'; yourself).
	firstBatch := collection query: (collection query
		query: Dictionary new;
		limit: 2).
	secondBatch := collection query: (collection query
		query: Dictionary new;
		limit: 2;
		offset: 2).
	self assert: firstBatch size equals: 2.
	self assert: secondBatch size equals: 1.
	
! !

!MongoTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/MongoTest.st,v 1.1 2013-04-04 21:28:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/tests/MongoTest.st,v 1.1 2013-04-04 21:28:55 cg Exp $'
! !


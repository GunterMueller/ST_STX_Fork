"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#Mongo
	instanceVariableNames:'host port stream requestID'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!Mongo class methodsFor:'instance creation'!

default
	^self host: 'localhost' port: 27017
!

host: aString port: anInteger
	^self new setHost: aString port: anInteger
! !

!Mongo class methodsFor:'constants'!

ascending
	^1
!

descending
	^-1
! !

!Mongo methodsFor:'accessing'!

stream
	^stream
!

stream: anObject
	stream := anObject
! !

!Mongo methodsFor:'operations'!

close
	stream close
!

databaseNamed: aString
	^MongoDatabase root: self name: aString
!

databases
	| raw aDictionary |
	aDictionary := (Dictionary new)
				at: 'listDatabases' put: 1;
				yourself.
	raw := (self admin command: aDictionary) at: 'databases'.
	^raw collect: [:each | self databaseNamed: (each at: 'name')]
!

open
	stream := GratuitousIncompatibilities socketStreamHost: host port: port
!

query: aMongoQuery
	| results |
	results := OrderedCollection new.
	aMongoQuery doBlock isNil ifTrue: [
		aMongoQuery doBlock: [:each | results add: each]].
	(MongoCursor root: self query: aMongoQuery ) execute.
	^results
!

queryOne: aMongoQuery
	aMongoQuery doBlock: [:each | ^each].
	aMongoQuery chunkSize: 1.
	(MongoCursor new
		root: self;
		query: aMongoQuery;
		execute).
	^nil
! !

!Mongo methodsFor:'private'!

admin
	^self databaseNamed: 'admin'
!

nextRequestID
	^requestID := requestID + 1
!

setHost: aString port: anInteger
	requestID := 0.
	host := aString.
	port := anInteger.
	"validate?"
! !

!Mongo methodsFor:'private-communicating'!

cursorQuery: aQuery
	(QueryOperation 
		id: self nextRequestID
		stream: stream
		query: aQuery)
			write
!

delete: aDictionary collection: aString
	(DeleteOperation
		collection: aString 
		id: self nextRequestID 
		stream: stream 
		query: aDictionary)
			write
!

getMore: idInteger collection: aString chunkSize: countInteger
	(GetMoreOperation
		collection: aString 
		id: idInteger 
		stream: stream 
		cursorId: idInteger 
		returnCount: countInteger)
			write
!

insert: aCollection collection: aString
	(InsertOperation
		collection: aString
		id: self nextRequestID
		stream: stream 
		objects: aCollection)
			write
!

update: origDictionary with: newDictionary collection: aString
	(UpdateOperation
		collection: aString
		id: self nextRequestID
		stream: stream
		originalObject: origDictionary 
		newObject: newDictionary)
			write
! !

!Mongo methodsFor:'testing'!

isOpen 
	^stream notNil and: [ stream isConnected ]
! !

!Mongo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/Mongo.st,v 1.1 2013-04-04 21:02:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/Mongo.st,v 1.1 2013-04-04 21:02:30 cg Exp $'
! !


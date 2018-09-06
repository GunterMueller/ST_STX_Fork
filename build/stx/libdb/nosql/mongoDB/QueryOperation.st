"{ Package: 'stx:libdb/nosql/mongoDB' }"

MongoOperation subclass:#QueryOperation
	instanceVariableNames:'mongoQuery dataBytes'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!QueryOperation class methodsFor:'instance creation'!

collection: aString id: idInteger stream: aStream query: queryDictionary fields: fieldsDictionary returnCount: countInteger numberToSkip: skipInteger
	self deprecated: 'Should be replaced by id:stream:query:'.
	^(self
		collection: aString 
		id: idInteger 
		stream: aStream)
			setQuery: queryDictionary 
			fields: fieldsDictionary 
			returnCount: countInteger
			numberToSkip: skipInteger
!

id: idInteger stream: aStream query: aMongoQuery
	^(self
		collection: aMongoQuery fullCollectionName 
		id: idInteger 
		stream: aStream)
			mongoQuery: aMongoQuery
! !

!QueryOperation methodsFor:'accessing'!

mongoQuery
	^ mongoQuery
!

mongoQuery: aMongoQuery
	mongoQuery := aMongoQuery
! !

!QueryOperation methodsFor:'private'!

opCode
	^2004
! !

!QueryOperation methodsFor:'writing'!

computeDataBytes
	| queryDictionary |
	queryDictionary := Dictionary new
		at: '$query' put: mongoQuery query;
		yourself.
	mongoQuery order ifNotNil: [
		queryDictionary at: '$orderby' put: mongoQuery order].
	
	^mongoQuery fields 
		ifNotNil: [BSON writeAll: { queryDictionary . mongoQuery fields}]
		ifNil: [BSON write: queryDictionary]
!

dataBytes 
	^dataBytes ifNil: [dataBytes := self computeDataBytes]
!

fixedHeaderSize
	^ 28
!

messageSize
	^ self dataBytes size + collectionBytes size + 1 + self fixedHeaderSize
!

writeBody
	writer
		nextInt32Put: 0;
		nextEncodedStringPut: collectionBytes;
		nextInt32Put: mongoQuery offset; "number of elements to skip"
		nextInt32Put: mongoQuery chunkSize;
		nextBytesPut: self dataBytes.
		
		"order is to be integrated in the dataBytes"
! !

!QueryOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/QueryOperation.st,v 1.1 2013-04-04 20:58:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/QueryOperation.st,v 1.1 2013-04-04 20:58:02 cg Exp $'
! !


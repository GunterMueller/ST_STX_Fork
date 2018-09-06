"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#MongoQuery
	instanceVariableNames:'database query fields limit offset order chunkSize doBlock
		collection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!MongoQuery methodsFor:'accessing'!

chunkSize
	^chunkSize ifNil: [ chunkSize := self defaultChunkSize ]
!

chunkSize: anInteger
	^chunkSize := anInteger
!

collection
	^collection
!

collection: aMongoCollection
	collection := aMongoCollection
!

database
	^ database
!

database: aMongoDatabase
	database := aMongoDatabase
!

doBlock
	^doBlock
!

doBlock: aBlock
	doBlock := aBlock.
!

fields
	^ fields ifNil: [ fields := self defaultFields ]
!

fields: aDictionary
	fields := aDictionary
!

limit
	^ limit ifNil: [ limit := self defaultLimit]
!

limit: anInteger
	limit := anInteger
!

offset
	^ offset ifNil: [ offset := self defaultOffset ].
!

offset: anInteger
	offset := anInteger
!

order
	^ order
!

order: anArrayOfAssociation
	order := anArrayOfAssociation asDictionary.
!

q: aDictionary
	"helper method"
	self query: aDictionary
!

query
	^ query ifNil: [ query := self defaultQuery]
!

query: aDictionary
	query := aDictionary
! !

!MongoQuery methodsFor:'accessing composite'!

fullCollectionName
	^database name , '.' , collection name
! !

!MongoQuery methodsFor:'default'!

defaultChunkSize
	^0
!

defaultFields
	^nil
!

defaultLimit
	^0
!

defaultOffset
	^0
!

defaultQuery
	^Dictionary new
! !

!MongoQuery methodsFor:'perform query'!

perform
	^collection query: self.
! !

!MongoQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoQuery.st,v 1.1 2013-04-04 21:06:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoQuery.st,v 1.1 2013-04-04 21:06:11 cg Exp $'
! !


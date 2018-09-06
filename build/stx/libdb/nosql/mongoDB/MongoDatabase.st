"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#MongoDatabase
	instanceVariableNames:'root name'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!MongoDatabase class methodsFor:'instance creation'!

root: aMongo name: aString 
	^self new
		setRoot: aMongo
		name: aString
! !

!MongoDatabase methodsFor:'accessing'!

name
	^name
!

qualifiedName
	^self name
! !

!MongoDatabase methodsFor:'operations'!

addCollection: aString 
	| command reply |
	command := Dictionary new.
	command at: 'create' put: aString.
	reply := self command: command.
	reply at: 'ok' ifAbsent: [self halt].
	^MongoCollection database: self name: aString
!

collections
	| query reply names real stripped |
	query := MongoQuery new collection: (MongoMetaCollection name: 'system.namespaces').
	reply := self query: query.
	"Drop options on the floor for now"
	names := reply collect: [:each | each at: 'name'].
	real := names select: [:each | (each occurrencesOf: $.) = 1].
	stripped := real collect: [:each | each readStream upTo: $.; upToEnd].
	^stripped collect: [:each | MongoCollection database: self name: each]
!

command: aDictionary
	| query |
	query := MongoQuery new
		database: self;
		collection: (MongoMetaCollection name: '$cmd');
		query: aDictionary;
		yourself.
	^root queryOne: query.
!

delete: aDictionary collection: aString 
	root delete: aDictionary collection: name , '.' , aString
!

drop
	self command: (Dictionary new at: 'dropDatabase' put: 1.0; yourself)
!

insert: aCollection collection: aString 
	root insert: aCollection collection: name , '.' , aString
!

query: aMongoQuery
	aMongoQuery database: self.
	^root query: aMongoQuery
!

queryOne: aMongoQuery
	aMongoQuery database: self.
	^root queryOne: aMongoQuery.
!

update: origDictionary with: newDictionary collection: aString 
	root update: origDictionary with: newDictionary collection: name , '.' , aString
!

username: user password: pass
	|nonce reply pwd key |
	reply := self command: (Dictionary new at: 'getnonce' put: 1; yourself).
	^ (reply at: 'ok') = 1.0 and:
		[nonce := reply at: 'nonce'.
		pwd := (MD5 hashMessage: (user, ':mongo:', pass)) hex asLowercase.
		key := (MD5 hashMessage: nonce, user, pwd) hex asLowercase.
		reply := self command: (Dictionary new at: 'authenticate' put: 1; at: 'user' put: user; at: 'nonce' put: nonce; at: 'key' put: key; yourself).
		(reply at: 'ok') = 1.0]
! !

!MongoDatabase methodsFor:'private'!

setRoot: aMongo name: aString 
	root := aMongo.
	name := aString
! !

!MongoDatabase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoDatabase.st,v 1.1 2013-04-04 21:05:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoDatabase.st,v 1.1 2013-04-04 21:05:12 cg Exp $'
! !


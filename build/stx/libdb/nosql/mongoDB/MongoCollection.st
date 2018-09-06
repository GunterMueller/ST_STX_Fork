"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#MongoCollection
	instanceVariableNames:'database name'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!MongoCollection class methodsFor:'instance creation'!

database: aMongoDatabase name: aString 
	^self new setDatabase: aMongoDatabase name: aString
! !

!MongoCollection methodsFor:'accessing'!

name
	^name
!

qualifiedName
	^database qualifiedName , '.' , name
!

size
	^self sizeForQuery: Dictionary new
! !

!MongoCollection methodsFor:'adding'!

add: aDictionary 
	self insert: (Array with: aDictionary)
!

addAll: aCollection 
	self insert: aCollection
!

replace: origDictionary with: newDictionary
	self update: origDictionary with: newDictionary
! !

!MongoCollection methodsFor:'enumerating'!

detect: aDictionary
	^self queryOne: (self query
		q: aDictionary;
		yourself)
!

do: aBlock
	| mongoQuery |
	mongoQuery := self query
		doBlock: aBlock;
		yourself.
		
	^self query: mongoQuery
!

inject: anObject into: aBlock
	| sum |
	sum := anObject.
	self do: [:each | sum := aBlock value: sum value: each].
	^sum
!

select: aDictionary
	^self query: (self query
		q: aDictionary;
		yourself)
! !

!MongoCollection methodsFor:'operations'!

drop
	| command |
	command := Dictionary new.
	command at: 'drop' put: name.
	database command: command "check return value"
!

validate
	| reply |
	reply := database command: (Dictionary new at: 'validate' put: name; yourself).
	^CollectionValidation on: reply
! !

!MongoCollection methodsFor:'private'!

setDatabase: aMongoDatabase name: aString
	database := aMongoDatabase.
	name := aString
! !

!MongoCollection methodsFor:'private-operations'!

delete: aDictionary 
	database delete: aDictionary collection: name
!

insert: aCollection
	database insert: aCollection collection: name
!

query: aMongoQuery
	^database query: aMongoQuery.
!

queryOne: aMongoQuery
	aMongoQuery collection:  self.
	^database queryOne: aMongoQuery
!

sizeForQuery: aDictionary
	| reply |
	reply := database command: ((Dictionary new)
						at: 'count' put: name;
						at: 'query' put: aDictionary;
						at: 'fields' put: Dictionary new;
						yourself).
	^(reply at: 'n') asInteger	"Why in the world is it a double?"
!

update: origDictionary with: newDictionary
	database update: origDictionary with: newDictionary collection: name
! !

!MongoCollection methodsFor:'query generator'!

query
	^MongoQuery new
		collection: self;
		yourself.
		
! !

!MongoCollection methodsFor:'removing'!

remove: aDictionary 
	database delete: aDictionary collection: name
!

removeAll: aCollection
	"Worry about atomicity?"

	aCollection do: [:each | self remove: each]
! !

!MongoCollection methodsFor:'testing'!

includes: aDictionary
	"May be inefficient"
	^(self sizeForQuery: aDictionary) > 0
!

isEmpty
	^self size = 0
!

occurrencesOf: aDictionary 
	^(self select: aDictionary) size
! !

!MongoCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoCollection.st,v 1.1 2013-04-04 21:08:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoCollection.st,v 1.1 2013-04-04 21:08:49 cg Exp $'
! !


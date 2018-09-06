"{ Package: 'stx:libdb/nosql/couchDB' }"

Object subclass:#CouchDB
	instanceVariableNames:'name objectType host port'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Core'
!


!CouchDB class methodsFor:'creation datastructure'!

createOn: aHost name: aName
	^ self new host: aHost; name: aName; create; yourself.
!

createOrOpenOn: aHost name: aName
	| couchdb |
	couchdb := self new host: aHost; name: aName.
	
	[ couchdb create ] on: CouchDBOperationFailedError do: [
		couchdb open.
	].
	
	^ couchdb yourself.
!

openOn: aHost name: aName
	^ self new host: aHost; name: aName; open; yourself.
! !

!CouchDB class methodsFor:'creation object based'!

createOn: aHost name: aName ofType: anObjectType
	| couchdb |
	couchdb := self createOn: aHost name: aName.
	couchdb objectType: anObjectType.
	^ couchdb.
!

createOrOpenOn: aHost name: aName ofType: anObjectType
	| couchdb |
	couchdb := self createOrOpenOn: aHost name: aName.
	couchdb objectType: anObjectType.
	^ couchdb.
!

openOn: aHost name: aName ofType: anObjectType
	| couchdb |
	couchdb := self openOn: aHost name: aName.
	couchdb objectType: anObjectType.
	^ couchdb.

! !

!CouchDB methodsFor:'api'!

bulkCreateOrUpdateDocumentsFrom: collectionOfObjectsOrDatastructures
	
	| collectionOfDictionaries |
	collectionOfDictionaries := collectionOfObjectsOrDatastructures collect: [:each | self dictionaryFrom: each. ].
	
	^ (self post: (self name), '/_bulk_docs/' contents: (collectionOfDictionaries asJsonString)).
!

createDocument
	" Create empty document with a generated id "
	^ (self post: (self name), '/' contents: '{}') at: 'id'.
!

createDocument: datastructureOrObject id: docId
	" Create document from datastructure or object, with a specified id "
	^ self createOrUpdateDocument: datastructureOrObject id: docId
!

readDocument: docId
	" Reads the document with the given id. Optionally converts it into an Object "
	| result |
	result := (self get: (self name), '/', docId asString).
	
	(objectType ~= nil) ifTrue: [
		^ self instanceFor: objectType fromDatastructure: result.
	].
	
	^ result.
!

updateDocument: datastructureOrObject
	| dictionary |
	dictionary := self dictionaryFrom: datastructureOrObject.
	^ self updateDocument: dictionary id: (dictionary at: '_id')
!

updateDocument: datastructureOrObject id: docId
	" Update the document. "
	^ self createOrUpdateDocument: datastructureOrObject id: docId
! !

!CouchDB methodsFor:'connection'!

host: aHost
	host := aHost 
!

port: aPort
	port := aPort
!

url
	^ 'http://' , host, ':', port asString, '/'.
! !

!CouchDB methodsFor:'conversion'!

dictionaryFrom: objectOrDictionary
	| dictionary |
	[
		dictionary := objectOrDictionary asCouchDBDocument.
	] onDNU: #asCouchDBDocument do: [
		dictionary := objectOrDictionary.
	].
	
	^ self sanitiseRevAndId: dictionary.
!

fromJSON: string
	^ (Json readFrom: (RWBinaryOrTextStream with: string))
!

instanceFor: clazz fromDatastructure: datastructure

	(clazz respondsTo: #fromCouchDBDocument:) ifFalse: [
		CouchDBError signal: 'Can not create instance from the given class, it does not respond to #fromCouchDBDocument:'.
	].

	^ clazz perform: #fromCouchDBDocument: with: datastructure.
!

jsonStringFor: datastructureOrObject
	^ (self dictionaryFrom: datastructureOrObject) asJsonString.
!

objectType
	^ objectType
!

objectType: anObjectType
	objectType := anObjectType.
!

sanitiseRevAndId: datastructure
	datastructure removeKeyIfValueNilOrEmptyString: '_rev'.
	datastructure removeKeyIfValueNilOrEmptyString: '_id'.
	
	^ datastructure.
! !

!CouchDB methodsFor:'creation'!

initialize
	super initialize.
	port := 5984.
! !

!CouchDB methodsFor:'http'!

get: namespace
	^ self handleResponse: (RestHTTPGetRequest url: (self url, namespace)).
!

handleResponse: httpResponse
	((httpResponse responseCode asString at: 1) = $2) ifTrue: [
		^ self fromJSON: (httpResponse response).
	].	
	
	((httpResponse responseCode asString at: 1) = $4) ifTrue: [
		CouchDBOperationFailedError signal: ((self fromJSON: httpResponse response) at: 'reason')
	].
	
	((httpResponse responseCode asString at: 1) = $5) ifTrue: [
		CouchDBOperationFailedError signal: ((self fromJSON: httpResponse response) at: 'reason')
	].

	CouchDBError signal: 'Unexpected response'
!

post: namespace contents: contents
	^ self handleResponse: (RestHTTPPostRequest url: (self url, namespace) contents: contents)
!

put: namespace contents: contents
	^ self handleResponse: (RestHTTPPutRequest url: (self url, namespace) contents: contents).
! !

!CouchDB methodsFor:'private'!

create
	self put: (self name), '/' contents: ''.
!

createDocument: datastructureOrObject
	| document id |
	
	document := self dictionaryFrom: datastructureOrObject.
	
	id := document at: '_id' ifAbsent: [ nil ].
	
	(id = nil)
		ifTrue: [ ^ self createNewDocument: datastructureOrObject. ]
		ifFalse: [ ^ self createOrUpdateDocument: document id: id. ].
!

createNewDocument: datastructureOrObject
	| result |
	result := (self post: (self name), '/' contents: (self jsonStringFor: datastructureOrObject)).
	^ result at: 'id'.
!

createOrUpdateDocument: datastructureOrObject id: docId
	| result |
	result := (self put: (self name), '/', docId asString contents: (self jsonStringFor: datastructureOrObject)).
	^ result at: 'id'.
!

escapeUrl: url
	| buildUrl parts |
	buildUrl := url.
	
	parts := url findTokens: '/'.
	
	buildUrl := (parts inject: nil into: [ :result :eachString | result ifNil: [eachString] ifNotNil: [result, '%2F', eachString] ]).
	
	^ buildUrl
!

name
	^ name.
!

name:  aName
	self validateDatabaseName: aName .
	name := self escapeUrl: aName.
!

open
	| response dbName |
	response := self get: (self name), '/'.
	dbName := response at: 'db_name'.
	(dbName ~= (self name)) ifTrue: [
		CouchDBError signal: 'The database name ', dbName, ' does not match up to the expected name of: ', self name.
	].
	
	^ self.
!

validateDatabaseName: dbName

	| filteredString |
	filteredString := dbName select: [ :c | 'abcdefghijklmnopqrstuvwxyz0123456789_$()+-/`' includesAnyOf: (c asString)  ].
	
	(filteredString ~= dbName) ifTrue: [
		CouchDBInvalidDatabaseNameError signal: 'Invalid databasename: ', dbName.
	].
	
! !

!CouchDB class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchDB.st,v 1.1 2013-04-04 14:38:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/CouchDB.st,v 1.1 2013-04-04 14:38:19 cg Exp $'
! !


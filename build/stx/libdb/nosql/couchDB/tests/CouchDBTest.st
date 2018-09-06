"{ Package: 'stx:libdb/nosql/couchDB/tests' }"

BaseCouchDBTest subclass:#CouchDBTest
	instanceVariableNames:'documentString dataStructure mockConnection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Tests-Unit'
!


!CouchDBTest methodsFor:'helpers'!

assertNoIdOrRev: dictionaryFromObject
	self assert: (dictionaryFromObject includesKey: '_id') not.
	self assert: (dictionaryFromObject includesKey: 'id') not.
	self assert: (dictionaryFromObject includesKey: '_rev') not.
	self assert: (dictionaryFromObject includesKey: 'rev') not.
!

setUp
	super setUp.

	documentString := '{"name" : "Frederic Manning"}'.
	dataStructure := self fromJSON: documentString.
! !

!CouchDBTest methodsFor:'testing'!

testEscapeDatabaseName
	| db |
	db := CouchDB new.

	db name: 'one'.
	self assert: (db name = 'one').

	db name: 'one/two'.
	self assert: (db name = 'one%2Ftwo').

	db name: 'one/two/three'.
	self assert: (db name = 'one%2Ftwo%2Fthree').

!

testHandleResponse

	| goodResponse jsonResponse db |
	db := CouchDB new.

	goodResponse :='{"name" : "Frederic Manning"}'.
	jsonResponse := self fromJSON: goodResponse.

	self assert: (db handleResponse: (RestHTTPResponse responseCode: 200 headers: '' response: goodResponse)) = jsonResponse.
	self assert: (db handleResponse: (RestHTTPResponse responseCode: 201 headers: '' response: goodResponse)) = jsonResponse.
	self assert: (db handleResponse: (RestHTTPResponse responseCode: 200 headers: '' response: goodResponse)) = jsonResponse.

	self should: [
		db handleResponse: (RestHTTPResponse responseCode: 407 headers: '' response: '{"error":"database_already_exists","reason":"Database \"test\" already exists."}').
	] raise: CouchDBOperationFailedError whoseDescriptionIncludes: 'already exists' description: 'Failed.'.
!

testInstanceFromDatastructure

	| datastructure db |
	db := CouchDB new.

	datastructure := db fromJSON: '{"_id":"12345","_rev":"3792344749","name":"Frederic Manning"}'.

	self assert: (db instanceFor: CouchDBTestObject fromDatastructure: datastructure) = CouchDBTestObject new.

	self should: [
		db instanceFor: String fromDatastructure: datastructure.
	] raise: CouchDBError whoseDescriptionIncludes: 'Can not create instance from the given class, it does not respond to #fromCouchDBDocument:' description: 'Failed?'.
!

testInvalidDBNames
	self should: [ CouchDB createOn: nil name: '*'] raise: CouchDBInvalidDatabaseNameError.
	self should: [ CouchDB createOn: nil name: '&asdasd_'] raise: CouchDBInvalidDatabaseNameError.
	self should: [ CouchDB createOn: nil name: 'Capital'] raise: CouchDBInvalidDatabaseNameError.
!

testSanitizedDictionaryFromObjectOrDatastructure

	| db datastructure object dictionaryFromObject |

	db := CouchDB new.

	datastructure := Dictionary new.
	object := CouchDBTestObject new.

	self assert: ((db dictionaryFrom: datastructure) isKindOf: Dictionary).

	dictionaryFromObject := db dictionaryFrom: object.
	self assert: (dictionaryFromObject isKindOf: Dictionary).
	self assert: ((dictionaryFromObject at: 'name') = object name).
	self assert: (object documentId = nil).
	self assert: (object documentRevision = nil).
	self assertNoIdOrRev: dictionaryFromObject.

	object documentId: ''.
	object documentRevision: ''.
	self assertNoIdOrRev: (db dictionaryFrom: object).
! !

!CouchDBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/CouchDBTest.st,v 1.2 2013-04-17 18:47:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/CouchDBTest.st,v 1.2 2013-04-17 18:47:34 cg Exp $'
! !


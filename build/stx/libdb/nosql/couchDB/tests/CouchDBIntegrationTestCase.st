"{ Package: 'stx:libdb/nosql/couchDB/tests' }"

BaseCouchDBIntegrationTestCase subclass:#CouchDBIntegrationTestCase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Tests-Integration'
!


!CouchDBIntegrationTestCase methodsFor:'helpers'!

assertCreateDatabaseFrom: dbName
	| db |
	db := CouchDB createOn: 'localhost' name: dbName.
	
	self should: [
		CouchDB createOn: 'localhost' name: dbName.
	] raise: CouchDBOperationFailedError whoseDescriptionIncludes: 'already exists' description: 'Failed?'.
	
	^ db
!

assertDocumentCreationOn: db
	| docid mydoc genId |
	
	" Empty Doc with generated ID "
	docid := db createDocument.
	self assert: (docid isKindOf: String).
	
	" Specified doc with generated ID "
	mydoc := Dictionary new.
	docid := db createDocument: mydoc.	
	self assert: (docid isKindOf: String).	
	
	" Specified doc with specified ID "
	genId := self generateTestID.
	docid := db createDocument: mydoc id: genId.
	self assert: (docid = genId).		
	
	" From Object that responds to #asCouchDBDocument "
	docid := db createDocument: (CouchDBTestObject new).
	self assert: (docid isKindOf: String).	
!

assertReadDocumentFrom: db
	| docid test object |
	db objectType: CouchDBTestObject.
	
	test := (CouchDBTestObject new).
	docid := db createDocument: test.
	
	object := db readDocument: docid.
	
	self assert: (object = test).
!

createTestDatabase
	| genId |
	genId := self generateTestID.
	^ CouchDB createOrOpenOn: 'localhost' name: 'testcouchdbintegration', genId.		
!

generateTestID
	^ (Date today asSeconds + 1000 atRandom) asString.

!

testCreateOrOpenDatabase
	| testdbName |
	testdbName := (self createTestDatabase) name.
	" Should not fail "
	CouchDB openOn: 'localhost' name: testdbName.
	
	" Should not fail "
	CouchDB createOrOpenOn: 'localhost' name: testdbName.
	CouchDB createOrOpenOn: 'localhost' name: testdbName ofType: CouchDBTestObject.
! !

!CouchDBIntegrationTestCase methodsFor:'testing'!

testCreateDatabase
	self assertCreateDatabaseFrom: 'testcouchdbintegration', self generateTestID.
!

testHierarchicalDatabase
	| db |
	db := self assertCreateDatabaseFrom: 'testcouchdbintegration/level', self generateTestID.
	self assertDocumentCreationOn: db.
	self assertReadDocumentFrom: db.
!

testOpenDatabase
	| genId |
	genId := self generateTestID.
	
	CouchDB createOn: 'localhost' name: 'testcouchdbintegration', genId.		
	
	CouchDB openOn: 'localhost' name: 'testcouchdbintegration', genId.
	
	self should: [
		CouchDB openOn: 'localhost' name: 'nosuch', genId.
	] raise: CouchDBOperationFailedError.
! !

!CouchDBIntegrationTestCase methodsFor:'testing-crud'!

testCreateBulk
	| bulk db document |
	db := self createTestDatabase.
	
	bulk := OrderedCollection new.
	
	1 to: 5 do: [:number |
		document := CouchDBTestObject new documentId: (number asString); name: 'Document ', number asString.
		bulk add: document.
	].
	
	" Duplicate "
	bulk add: document.
	
	db bulkCreateOrUpdateDocumentsFrom: bulk.
	
	self assert: ((db readDocument: '1') at: 'name') = 'Document 1'.
	self assert: ((db readDocument: '5') at: 'name') = 'Document 5'.
	
	
	self assert: false.
!

testCreateDocument
	self assertDocumentCreationOn: (self createTestDatabase).
!

testCreateDocumentFromObjectWithId
	| db docid document |
	db := self createTestDatabase.
	
	document := CouchDBTestObject new.
	document documentId: '1313'.

	docid := db createDocument: document.
	
	self assert: (docid = '1313').
!

testCreateDuplicateDocument
	| db mydoc |
	db := self createTestDatabase.
	
	mydoc := Dictionary new.
	db createDocument: mydoc id: '1313'.
	
	self should: [ db createDocument: mydoc id: '1313'] raise: CouchDBOperationFailedError.
!

testReadDocumentAsDatastructure
	| db docid document test |
	db := self createTestDatabase.
	
	test := (CouchDBTestObject new).
	docid := db createDocument: test.
	
	document := db readDocument: docid.
	
	self assert: (document isKindOf: Dictionary).
!

testReadDocumentAsObject
	| db |
	db := self createTestDatabase.
	self assertReadDocumentFrom: db.
!

testUpdateDocument
	| db docid test object |
	db := self createTestDatabase.
	db objectType: CouchDBTestObject.
	
	test := (CouchDBTestObject new).
	docid := db createDocument: test.
	
	object := db readDocument: docid.
	self assert: object name = test name.
	
	object name: 'Homer'.
	db updateDocument: object id: docid.	
	
	object := db readDocument: docid.	
	self assert: object name = 'Homer'.
	
	" Update document with _id property set in Dictionary "
	
	object name: 'Iliad'.	
	db updateDocument: object.	
	self assert: (db readDocument: docid) name = 'Iliad'.
! !

!CouchDBIntegrationTestCase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/CouchDBIntegrationTestCase.st,v 1.1 2013-04-04 14:40:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/CouchDBIntegrationTestCase.st,v 1.1 2013-04-04 14:40:59 cg Exp $'
! !


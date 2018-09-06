"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

DBXBaseTest subclass:#ApplicationEditionTest
	instanceVariableNames:'login session application'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!ApplicationEditionTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection
	"Nothing"
!

setUp
	| settings platform |
	super setUp.
	login := GlorpDatabaseLoginResource defaultLogin copy.
	settings := DBXConnectionSettings 
		host: login host 
		port: login port 
		database: login databaseName 
		userName: login username 
		userPassword: login password.
	platform := login database asOpenDBXDriverAdaptor.
	connection := DBXConnection platform: platform settings:  settings.
	connection connectAndOpen.
!

tearDown
	super tearDown.
		
	session ifNotNil: [
		session dropTables.
		session logout.
	].

	application
		removeClasses.
!

testGetApplicationFromDatabaseGetsAttributes
	| glorpDescriptor tables schema signature |
	
	"Init Application"
	
	(connection platform isKindOf: DBXPostgresBackend)
		ifTrue: [ schema := 'public' ]
		ifFalse: [ schema := 'sodbxtest' ].
	
	tables := (connection tablesDescriptionForSchema: schema) select: [ :t | #('STUDENT' 'COURSE' 'SIGNATURE') includes: t name asUppercase ].
	application := DBXApplication fromTables: tables defaultCategory: 'TestPhoseydon'.
	
	signature := application entityNamed: #Signature.
	self assert: (signature hasAttributeNamed: #idStudent).
	self assert: (signature hasAttributeNamed: #code).
	self assert: (signature hasAttributeNamed: #name).
	self assert: (signature hasAttributeNamed: #observations).
	self assert: (signature hasAttributeNamed: #courseGrade).
	self assert: (signature hasAttributeNamed: #finalGrade).
!

testGetApplicationFromDatabaseGetsForeignKeys
	| glorpDescriptor tables schema signature fkAttr |
	
	"Init Application"
	
	(connection platform isKindOf: DBXPostgresBackend)
		ifTrue: [ schema := 'public' ]
		ifFalse: [ schema := 'sodbxtest' ].
	tables := (connection tablesDescriptionForSchema: schema) select: [ :t | #('STUDENT' 'COURSE' 'SIGNATURE') includes: t name asUppercase ].
	application := DBXApplication fromTables: tables defaultCategory: 'TestPhoseydon'.
	signature := application entityNamed: #Signature.
	self assert: (signature hasAttributeNamed: #idStudent).

	fkAttr := signature attributeNamed: #idStudent.
	self assert: (fkAttr isKindOf: MAToOneRelationDescription).
	self assert: fkAttr isForeignKey.
	self assert: fkAttr foreignEntity = #Student
!

testInvertToOneMappingAsCollection
	| glorpDescriptor tables schema student signature peter firstSignature secondSignature thirdSignature newPeter |
	
	"Init Application"
	(connection platform isKindOf: DBXPostgresBackend)
		ifTrue: [ schema := 'public' ]
		ifFalse: [ schema := 'sodbxtest' ].
		
	tables := (connection tablesDescriptionForSchema: schema) select: [ :t | #('STUDENT' 'COURSE' 'SIGNATURE') includes: t name asUppercase ].
	application := DBXApplication fromTables: tables defaultCategory: 'TestPhoseydon'.
	
	student := application entityNamed: #Student.
	signature := application entityNamed: #Signature.
	
	self deny: (student anySatisfy: [ :attr | (attr isKindOf: MARelationDescription) and: [ attr foreignEntity = signature name ] ]).
	self assert: (signature hasAttributeNamed: #idStudent).
	
	(signature attributeNamed: #idStudent) mapInverseCollectionAs: #signatures.
	
	application
		writeClasses;
		writeMagritte.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login.
	session accessor login.
	
	peter := student createInstance.
	firstSignature := signature createInstance.
	firstSignature code: 1.
	firstSignature name: 'first'.
	
	secondSignature := signature createInstance.
	secondSignature code: 2.
	secondSignature name: 'second'.
	
	thirdSignature := signature createInstance.
	thirdSignature code: 3.
	thirdSignature name: 'third'.
	
	peter signatures: { firstSignature. secondSignature. thirdSignature }.
	
	session transact: [
		session register: peter.
	].

	session reset.
	
	newPeter := session readOneOf: student entityClass.
	self assert: (newPeter signatures size = 3).
	self assert: (newPeter signatures anySatisfy: [ :s | s code = 1 and: [ s name trimBoth = 'first' ] ]).
!

testInvertToOneMappingAsSingleRelationship
	| glorpDescriptor tables schema student signature peter firstSignature newPeter |
	
	"Init Application"
	
	(connection platform isKindOf: DBXPostgresBackend)
		ifTrue: [ schema := 'public' ]
		ifFalse: [ schema := 'sodbxtest' ].
	
	tables := (connection tablesDescriptionForSchema: schema) select: [ :t | #('STUDENT' 'COURSE' 'SIGNATURE') includes: t name asUppercase ].
	application := DBXApplication fromTables: tables defaultCategory: 'TestPhoseydon'.
	
	student := application entityNamed: #Student.
	signature := application entityNamed: #Signature.
	
	self deny: (student anySatisfy: [ :attr | (attr isKindOf: MARelationDescription) and: [ attr foreignEntity = signature name ] ]).
	self assert: (signature hasAttributeNamed: #idStudent).
	
	(signature attributeNamed: #idStudent) mapInverseAs: #signature.
	
	application
		writeClasses;
		writeMagritte.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login.
	session accessor login.
	
	peter := student createInstance.
	firstSignature := signature createInstance.
	firstSignature code: 1.
	firstSignature name: 'first'.
	
	peter signature: firstSignature .
	
	session transact: [
		session register: peter.
	].

	session reset.
	
	newPeter := session readOneOf: student entityClass.
	self assert: (newPeter signature notNil).
	self assert: newPeter signature code equals: 1.
	self assert: newPeter signature name trimBoth equals: 'first'.
! !

!ApplicationEditionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/ApplicationEditionTest.st,v 1.2 2013-04-15 13:35:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/ApplicationEditionTest.st,v 1.2 2013-04-15 13:35:03 cg Exp $'
! !


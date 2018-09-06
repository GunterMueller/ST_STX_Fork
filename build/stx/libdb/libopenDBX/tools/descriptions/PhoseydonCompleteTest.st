"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

DBXBaseTest subclass:#PhoseydonCompleteTest
	instanceVariableNames:'login session'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!PhoseydonCompleteTest class methodsFor:'as yet unclassified'!

resources
	^super resources , (Array with: GlorpDatabaseLoginResource)
! !

!PhoseydonCompleteTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection
	"Nothing to setup"
!

setUp
	| settings platform system asd |
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
	
	system := (GlorpDemoDescriptorSystem forPlatform: login database) .
	asd := system sessionForLogin: login copy.
	asd accessor login.
	asd dropTables: ((TableSorter for: system allTables) sort reverse).
	asd accessor logout.

	[connection execute: 'DROP TABLE PET'.]
		on: DBXRecoverableError
		do: [ ].
	[connection execute: 'DROP TABLE PERSON'.]
		on: DBXRecoverableError
		do: [ ].
	[connection execute: 'DROP SEQUENCE PERSON_id_seq'. ] 
		on: DBXRecoverableError
		do: [ ].
	[connection execute: 'DROP SEQUENCE PET_ID_SEQ'.]
		on: DBXRecoverableError
		do: [ ].
!

tearDown
	super tearDown.
	session ifNotNil: [
		session dropTables.
		session logout
	]
!

testBidirectionalTwoOneToManyRelatedEntitiesApplication
	| application glorpDescriptor tables schema personClass guille petClass fido scoobyDoo |
	[
	
	application := DBXApplication named: 'TestPhoseydon'.

	(application entityNamed: #Person)
		hasInteger:#id;
		hasString: #name;
		hasInteger: #age;
		hasBoolean: #isProgrammer;
		hasMany: #Pet as: #myPets.
	((application entityNamed: #Person) attributeNamed: #id) bePrimaryKey.
	
	(application entityNamed: #Pet)
		hasInteger:#id;
		hasString: #name;
		hasOne: #Person as: #owner.
	((application entityNamed: #Pet) attributeNamed: #id) bePrimaryKey.
	
	application
		writeClasses;
		writeMagritte;
		writeTables: login copy.
	
	application := DBXApplication fromCategory: 'TestPhoseydon'.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login copy.
	session accessor login.
	
	self assert: (Smalltalk globals includesKey: #Person).
	
	personClass := Smalltalk globals at: #Person.
	petClass := Smalltalk globals at: #Pet.
	
	fido := petClass new.
	fido name: 'Fido'.
	
	scoobyDoo := petClass new.
	scoobyDoo name: 'Scooby'.
	
	guille := personClass new.
	guille name: 'Guille'.
	guille age: 24.
	guille isProgrammer: true.
	
	guille myPets: Set new.
	
	guille myPets add: fido.
	fido owner: guille.
	
	guille myPets add: scoobyDoo.
	scoobyDoo owner: guille.
	
	session transact: [ 
		session register: guille 
	].
	
	session reset.
	
	guille := (session readOneOf: personClass).
	self assert: guille name equals: 'Guille'.
	self assert: guille age equals: 24.
	self assert: guille isProgrammer.
	
	self assert: guille myPets size equals: 2.
	self assert: (guille myPets anySatisfy: [ :p | p name = fido name ]).
	self assert: (guille myPets anySatisfy: [ :p | p name = scoobyDoo name ]).
	
	self assert: ((session readManyOf: petClass) allSatisfy: [ :pet | pet owner = guille ]).
	
	] ensure: [ 
	application removeClasses.
	session dropTables.
	]
!

testBidirectionalTwoOneToOneRelatedEntitiesApplication
	| application glorpDescriptor tables schema personClass guille petClass fido |
	[
	
	application := DBXApplication named: 'TestPhoseydon'.

	(application entityNamed: #Person)
		hasInteger:#id;
		hasString: #name;
		hasInteger: #age;
		hasBoolean: #isProgrammer;
		hasOne: #Pet as: #myPet.
	((application entityNamed: #Person) attributeNamed: #id) bePrimaryKey.
	
	(application entityNamed: #Pet)
		hasInteger:#id;
		hasString: #name;
		hasOne: #Person as: #owner.
	((application entityNamed: #Pet) attributeNamed: #id) bePrimaryKey.
	
	application
		writeClasses;
		writeMagritte;
		writeTables: login copy.
	
	application := DBXApplication fromCategory: 'TestPhoseydon'.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login copy.
	session accessor login.
	
	self assert: (Smalltalk globals includesKey: #Person).
	
	personClass := Smalltalk globals at: #Person.
	petClass := Smalltalk globals at: #Pet.
	
	fido := petClass new.
	fido name: 'Fido'.
	
	guille := personClass new.
	guille name: 'Guille'.
	guille age: 24.
	guille isProgrammer: true.
	
	guille myPet: fido.
	
	session transact: [ 
		session register: guille 
	].
	
	session reset.
	
	guille := (session readOneOf: personClass).
	self assert: guille name equals: 'Guille'.
	self assert: guille age equals: 24.
	self assert: guille isProgrammer.
	
	self assert: guille myPet name equals: 'Fido'.
	
	self assert: (session readOneOf: petClass) owner equals: guille.
	
	] ensure: [ 
	application removeClasses.
	session dropTables.
	]
!

testOneSimpleEntityApplication
	| application glorpDescriptor tables schema personClass guille |
	[
	application := DBXApplication named: 'TestPhoseydon'.

	(application entityNamed: #Person)
		hasInteger:#id;
		hasString: #name;
		hasInteger: #age;
		hasBoolean: #isProgrammer.
	((application entityNamed: #Person) attributeNamed: #id) bePrimaryKey.
	
	application
		writeClasses;
		writeMagritte;
		writeTables: login copy.
	
	application := DBXApplication fromCategory: 'TestPhoseydon'.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login copy.
	session accessor login.
	
	self assert: (Smalltalk globals includesKey: #Person).
	
	personClass := Smalltalk globals at: #Person.
	guille := personClass new.
	guille name: 'Guille'.
	guille age: 24.
	guille isProgrammer: true.
	
	session transact: [ 
		session register: guille 
	].
	
	session reset.
	
	guille := (session readOneOf: personClass).
	self assert: guille name equals: 'Guille'.
	self assert: guille age equals: 24.
	self assert: guille isProgrammer.
	
	] ensure: [ 
	application removeClasses.
	session dropTables.
	]
!

testOneSimpleEntityHasIdAsDefault
	| application glorpDescriptor tables schema personClass guille personEntity |
	
	application := DBXApplication named: 'TestPhoseydon'.

	personEntity := application entityNamed: #Person.
	personEntity
		hasString: #name;
		hasInteger: #age;
		hasBoolean: #isProgrammer.
		
	self assert: (personEntity isHasAttribute: #id).
	self assert: (personEntity attributeNamed: #id) isPrimaryKey.
!

testTwoOneToManyRelatedEntitiesApplication
	| application glorpDescriptor tables schema personClass guille petClass fido scoobyDoo |
	[
	
	application := DBXApplication named: 'TestPhoseydon'.

	(application entityNamed: #Person)
		hasInteger:#id;
		hasString: #name;
		hasInteger: #age;
		hasBoolean: #isProgrammer;
		hasMany: #Pet as: #myPets.
	((application entityNamed: #Person) attributeNamed: #id) bePrimaryKey.
	
	(application entityNamed: #Pet)
		hasInteger:#id;
		hasString: #name.
	((application entityNamed: #Pet) attributeNamed: #id) bePrimaryKey.
	
	application
		writeClasses;
		writeMagritte;
		writeTables: login copy.
	
	application := DBXApplication fromCategory: 'TestPhoseydon'.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login copy.
	session accessor login.
	
	self assert: (Smalltalk globals includesKey: #Person).
	
	personClass := Smalltalk globals at: #Person.
	petClass := Smalltalk globals at: #Pet.
	
	fido := petClass new.
	fido name: 'Fido'.
	
	scoobyDoo := petClass new.
	scoobyDoo name: 'Scooby'.
	
	guille := personClass new.
	guille name: 'Guille'.
	guille age: 24.
	guille isProgrammer: true.
	
	guille myPets: Set new.
	guille myPets add: fido.
	guille myPets add: scoobyDoo.
	
	session transact: [ 
		session register: guille 
	].
	
	session reset.
	
	guille := (session readOneOf: personClass).
	self assert: guille name equals: 'Guille'.
	self assert: guille age equals: 24.
	self assert: guille isProgrammer.
	
	self assert: guille myPets size equals: 2.
	self assert: (guille myPets anySatisfy: [ :p | p name = fido name ]).
	self assert: (guille myPets anySatisfy: [ :p | p name = scoobyDoo name ]).
	
	] ensure: [ 
	application removeClasses.
	session dropTables.
	]
!

testTwoOneToOneRelatedEntitiesApplication
	| application glorpDescriptor tables schema personClass guille petClass fido |
	[
	
	application := DBXApplication named: 'TestPhoseydon'.

	(application entityNamed: #Person)
		hasInteger:#id;
		hasString: #name;
		hasInteger: #age;
		hasBoolean: #isProgrammer;
		hasOne: #Pet as: #myPet.
	((application entityNamed: #Person) attributeNamed: #id) bePrimaryKey.
	
	(application entityNamed: #Pet)
		hasInteger:#id;
		hasString: #name.
	((application entityNamed: #Pet) attributeNamed: #id) bePrimaryKey.
	
	application
		writeClasses;
		writeMagritte;
		writeTables: login copy.
	
	application := DBXApplication fromCategory: 'TestPhoseydon'.
	
	glorpDescriptor := application glorpDescriptorForPlatform: login database.
	session := glorpDescriptor sessionForLogin: login copy.
	session accessor login.
	
	self assert: (Smalltalk globals includesKey: #Person).
	
	personClass := Smalltalk globals at: #Person.
	petClass := Smalltalk globals at: #Pet.
	
	fido := petClass new.
	fido name: 'Fido'.
	
	guille := personClass new.
	guille name: 'Guille'.
	guille age: 24.
	guille isProgrammer: true.
	
	guille myPet: fido.
	
	session transact: [ 
		session register: guille 
	].
	
	session reset.
	
	guille := (session readOneOf: personClass).
	self assert: guille name equals: 'Guille'.
	self assert: guille age equals: 24.
	self assert: guille isProgrammer.
	
	self assert: guille myPet name equals: 'Fido'.
	
	] ensure: [ 
	application removeClasses.
	session dropTables.
	]
! !

!PhoseydonCompleteTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/PhoseydonCompleteTest.st,v 1.2 2013-04-15 13:35:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/PhoseydonCompleteTest.st,v 1.2 2013-04-15 13:35:01 cg Exp $'
! !


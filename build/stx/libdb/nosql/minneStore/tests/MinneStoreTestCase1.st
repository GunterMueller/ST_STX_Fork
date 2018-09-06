"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

nil subclass:#MinneStoreTestCase1
	instanceVariableNames:'db'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

MinneStoreTestCase1 comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!MinneStoreTestCase1 class methodsFor:'As yet unclassified'!

all



	^OrderedCollection new

		add: (self new selector: #test1);

		add: (self new selector: #test2);

		add: (self new selector: #test3);

		add: (self new selector: #test4);

		yourself.
!

testingDirectory
	OperatingSystem isMSDOSlike ifFalse:[^ '/tmp/MSTest' ].


	^'C:\MSTest\'
! !

!MinneStoreTestCase1 methodsFor:'As yet unclassified'!

_testReading



	| results |

	results := (db getAll: #Persons)

			where: #age eq: 57;

			execute.

	self assert: (results size == 1).



	results := (db getAll: #Persons)

			where: #age eq: 63;

			execute.

	self assert: (results size == 2).



	results := (db getAll: #Persons)

			where: #age between: 40 and: 60;

			execute.

	self assert: (results size == 3).



	results := (db getAll: #Persons)

			where: #age eq: nil;

			execute.

	self assert: (results size == 1).



	results := (db getOne: #Persons)

			where: #age eq: nil;

			execute.

	self assert: results notNil.



	results := (db getAll: #Persons)

			where: #name startsWith: 'C.S.';

			execute.

	self assert: (results size == 1).



	results := (db getValuesOf: #name from: #Persons)

			execute.

	self assert: (results  size == 9).



	results := (db getValuesOf: #name from: #Persons)

			where: #age eq: 72;

			execute.

	self assert: (results  = (OrderedCollection with: 'J.R.R. Tolkien')).



	results := (db getValuesOf: #name from: #Persons)

			where: #age eq: 63;

			execute.

	self assert: (results size == 2).



	results := (db getValuesOf: #age from: #Persons)

			where: #name gte: 'a';

			execute.

	self assert: (results size == 8). "8 because there are two persons with age of 63"
!

_testUpdating



	| results |

	results := (db getOne: #Persons)

			where: #age eq: 57;

			execute.

	results age: 56.


	db store: results.



	results := (db getAll: #Persons)

			where: #age lte: 57;

			execute.

	self assert: (results size == 4).

	results do:

		[:each |

		each age isNil

			ifTrue: [each age: 100]

			ifFalse: [each age: each age + 100].

		db store: each.

		].



	results := (db getAll: #Persons)

			where: #age lte: 57; execute.

	self assert: (results isEmpty).



	results := (db getAll: #Persons)

			where: #age gte: 100; execute.

	self assert: (results size == 4).
!

allPersonObjects



	^(OrderedCollection new

		add: (DOTestObject name: 'Frederick Buechner' age: 57);

		add: (DOTestObject name: 'C.S. Lewis' age: 63);

		add: (DOTestObject name: 'Blaise Pascal' age: 63);

		add: (DOTestObject name: 'George MacDonald' age: nil);

		add: (DOTestObject name: 'Graham Greene'  age: 80);

		add: (DOTestObject name: 'Dietrich Bonhoeffer' age: 41);

		add: (DOTestObject name: 'Charles Williams' age: 55);

		add: (DOTestObject name: 'J.R.R. Tolkien' age: 72);

		add: (DOTestObject name: 'John Steinbeck' age: 66);

		yourself).
!

setUp
	self setup
!

setup



	| dir |

	dir := self class testingDirectory.

	FlavorCompatibility removeDirectoryNamed: dir ifAbsent: [].

	db := MinneStoreDB newOn: dir.

	db supportMultipleUsers.

	(db addObjectSetNamed: #Persons)

		objectsPerFile: 3;

		storesClass: DOTestObject;

		maximumLeavesPerBranch: 4;  "indexing parameter.  Default is 20"

		indexOn: #name domain: String;

		indexOn: #age domain: Integer.

	db save.
!

stopOnCheckFailure



	^true
!

stopOnError



	^true
!

test1

	"Store each object individually and do a general verification."



	| tmp oc i |

	i := 0.

	self allPersonObjects do:

		[:each |

		db store: each.

		i := i + 1.

		self assert: (db idFor: each) == i].

	self updateIndexes.  "This method does nothing in my class, but is used by my subclass."

	self _testReading.

	db := MinneStoreDB openOn: self class testingDirectory.

	self _testReading.
!

test2

	"Store the objects in one transaction and do a general verification."





	| results |

	db storeAll: self allPersonObjects.

	self updateIndexes.  "This method is used by my subclass."

	self _testReading.

	db := MinneStoreDB openOn: self class testingDirectory.

	self _testReading.

	self _testUpdating.
!

test3

	"Test the ability to rename or move the main database directory."



	| results |

	db storeAll: self allPersonObjects.

	self updateIndexes.  "This method is used by my subclass."

	FlavorCompatibility needsWork. "add a message box below or add rename code."

	"/ self halt. "Please rename C:\MSTest\ to C:\MSTest2\ and resume the process."
	OperatingSystem isMSDOSlike ifTrue:[
	    'C:\MSTest2' asFilename recursiveRemove.
	    'C:\MSTest' asFilename renameTo:'C:\MSTest2'.
	    db := MinneStoreDB openOn: 'C:\MSTest2\'.
	] ifFalse:[
	    '/tmp/MSTest2' asFilename recursiveRemove.
	    '/tmp/MSTest' asFilename renameTo:'/tmp/MSTest2'.
	    db := MinneStoreDB openOn: '/tmp/MSTest2'.
	].


	results := (db getAll: #Persons) where: #age lt: 100; execute.

	results do: [:each | self assertFalse: each isNil named: 'Nil Check'].

	self assertTrue: (results size == 9) named: 'Size Check'.



	"Do the exact same thing as above.  The second opening may be different."

	OperatingSystem isMSDOSlike ifTrue:[
	    db := MinneStoreDB openOn: 'C:\MSTest2\'.
	] ifFalse:[
	    db := MinneStoreDB openOn: '/tmp/MSTest2'.
	].

	results := (db getAll: #Persons) where: #age lt: 100; execute.

	results do: [:each | self assertFalse: each isNil named: 'Nil Check'].

	self assertTrue: (results size == 9) named: 'Size Check'.
!

test4

	"Test deleting an object.  Make sure its really deleted."

	"Test deleting an object with identical index value to another.  Read using that index value."



	| results deletedObject |

	db storeAll: self allPersonObjects.

	self updateIndexes.  "This method is used by my subclass."

	deletedObject := db delete: ((db getOne: #Persons) where: #name eq: 'C.S. Lewis'; execute).

	self assert: (deletedObject isDODeletedObject).

	deletedObject := (db getOne: #Persons) where: #name eq: 'C.S. Lewis'; execute.

	self assert: (deletedObject isNil).



	"The age of Lewis was 63, make sure only Pascal (also 63) gets read in."

	results := (db getAll: #Persons) where: #age eq: 63; execute.

	self assert: (results size == 1).

	self assert: (results first name = 'Blaise Pascal').
!

test5

	"Test changing an object that has already been changed since reading.  What happens?"



	"Test an index with 1-to-many values per object."
!

updateIndexes

	"Do nothing.  My subclass needs this."
! !

!MinneStoreTestCase1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/MinneStoreTestCase1.st,v 1.4 2014-02-17 21:41:54 cg Exp $'
! !

"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

nil subclass:#MinneStoreTestCase3
	instanceVariableNames:'db'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

MinneStoreTestCase3 comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!MinneStoreTestCase3 class methodsFor:'As yet unclassified'!

Comment

"

This class tests the sentence indexing capability and also tests

relationships between objects in the same object set.

"
!

all



	^OrderedCollection new

		add: (self new selector: #test1);

		yourself.
!

testingDirectory
	OperatingSystem isMSDOSlike ifFalse:[^ '/tmp/MSTest' ].


	^'C:\MSTest\'
! !

!MinneStoreTestCase3 methodsFor:'As yet unclassified'!

setUp
	self setup
!

setup



	| dir |

	dir := self class testingDirectory.

	FlavorCompatibility removeDirectoryNamed: dir ifAbsent: [].

	db := MinneStoreDB newOn: dir.

	db supportMultipleUsers.

	(db addObjectSetNamed: #Employees)

		objectsPerFile: 3;

		storesClass: Employee;

		maximumLeavesPerBranch: 4;  "indexing parameter.  Default is 20"

		indexOn: #name domain: String;

		indexOn: #notes domain: MSText;

		aspect: #manager holdsOne: #Employees;

		yourself.

	db save.
!

setupData1

	"This should result in an error because the aspects aren't being saved as they go along."



	| e1 e2 e3 |

	e1 := Employee new

			name: 'Jack Sprat';

			notes: 'could eat no fat, his wife could eat no lean.'.



	e2 := Employee new

			name: 'Miss Muffet';

			notes: 'sat on a tuffet, eating her curds and whey.';

			manager: e1.

	e3 :=

		(Employee new

			name: 'Humpty Dumpty';

			notes: 'sat on a wall; had a great fall';

			manager: e2).

	db store: e3.
!

setupData2



	db store:

		(Employee new

			name: 'Jack Sprat';

			notes: 'could eat no fat, his wife could eat no lean.').

	db store:

		(Employee new

			name: 'Miss Muffet';

			notes: 'sat on a tuffet, eating her curds and whey.';

			manager: ((db getOne: #Employees) where: #name eq: 'Jack Sprat'; execute)).

	db store:

		(Employee new

			name: 'Humpty Dumpty';

			notes: 'sat on a wall; had a great fall';

			manager: ((db getOne: #Employees) where: #name startsWith: 'Miss'; execute)).
!

stopOnCheckFailure



	^true
!

stopOnError



	^true
!

test1



	| result |

"/        self expect: #anyError during: [self setupData1].
	self should:[self setupData1] raise:Error.


	db := MinneStoreDB openOn: self class testingDirectory.

	self setupData2.



	result := (db getAll: #Employees)

			where: #notes hasWord: 'on';

			execute.

	self assertTrue: (result size == 2).



	"Case should not matter"

	result := (db getAll: #Employees)

			where: #notes hasAllWords: #('hAd' 'oN');

			execute.

	self assertTrue: (result size == 1).



	result := (db getAll: #Employees)

			where: #notes hasSomeWords: #('on' 'had' 'eat');

			execute.

	self assertTrue: (result size == 3).
! !

!MinneStoreTestCase3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/MinneStoreTestCase3.st,v 1.4 2014-02-17 21:41:56 cg Exp $'
! !

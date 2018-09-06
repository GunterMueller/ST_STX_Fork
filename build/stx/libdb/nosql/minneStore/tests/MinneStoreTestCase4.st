"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

MinneStoreTestCase1 subclass:#MinneStoreTestCase4
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

MinneStoreTestCase4 comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!MinneStoreTestCase4 methodsFor:'As yet unclassified'!

setup

	"Set up the same database as my superclass, but without indexes."



	| dir |

	dir := self class testingDirectory.

	FlavorCompatibility removeDirectoryNamed: dir ifAbsent: [].

	db := MinneStoreDB newOn: dir.

	db supportMultipleUsers.

	(db addObjectSetNamed: #Persons)

		objectsPerFile: 3;

		storesClass: DOTestObject;

		maximumLeavesPerBranch: 4.  "indexing parameter.  Default is 20"

	db save.
!

updateIndexes



	(db objectSetNamed: #Persons)

		indexOn: #name domain: String;

		indexOn: #age domain: Integer.
! !

!MinneStoreTestCase4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/MinneStoreTestCase4.st,v 1.4 2014-02-17 21:41:57 cg Exp $'
! !

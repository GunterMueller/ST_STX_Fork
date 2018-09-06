"{ Package: 'stx:libdb/nosql/minneStore/tests' }"

"{ NameSpace: Minnestore }"

TestCase subclass:#MinneStoreTestCase2
	instanceVariableNames:'db'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Testing'
!

MinneStoreTestCase2 comment:'Instances represent a single test case.  Most real uses will subclass TestCase,

adding instance variables and setUp/tearDown code for setting up data shared

between several test cases.



Instance variables:

    selector - a Symbol.  Name of the method to be invoked to run the test case

	represented by this instance.



Copyright (c) 1994, First Class Software, Inc.  All rights reserved.'
!


!MinneStoreTestCase2 class methodsFor:'As yet unclassified'!

Comment



	^'This class tests a complex set of object relationships.

	The following describes the parts and assemblies for a

	simplified lavatory faucet.'



"

Miscellaneous Parts:

		spout - 101

		aerator - 111



Assembly: Handle assembly - 151

Parts:  lever - 102

		o-ring* - 103

		elbow - 104

		hub - 112



Assembly: Drain assembly - 152

Parts:  seat - 106

		gasket - 105

		o-ring* - 103

		nut* - 107



Assembly: Lift Rod assembly - 153

Parts:  lift rod - 108

		strap - 109

		nut* - 107

		pivot rod - 110



Assembly: Faucet assembly - 154

Parts:  Drain assembly - 152

		Lift rod assembly - 153

		Handle assembly - 151

		spout - 101

		aerator - 111



* denotes shared part

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

!MinneStoreTestCase2 methodsFor:'As yet unclassified'!

setUp
	self setup
!

setup



	| dir |

	dir := self class testingDirectory.

	FlavorCompatibility removeDirectoryNamed: dir ifAbsent: [].

	db := MinneStoreDB newOn: dir.

	db supportMultipleUsers.

	(db addObjectSetNamed: #Parts)

		objectsPerFile: 3;

		storesClass: Part;

		maximumLeavesPerBranch: 4;  "indexing parameter.  Default is 20"

		indexOn: #name domain: String;

		indexOn: #number domain: Integer.

	(db addObjectSetNamed: #Assemblies)

		objectsPerFile: 3;

		storesClass: Assembly;

		maximumLeavesPerBranch: 4;  "indexing parameter.  Default is 20"

		indexOn: #name domain: String;

		indexOn: #number domain: Integer;

		aspect: #parts holdsMany: #Parts;

		aspect: #assemblies holdsMany: #Assemblies.

	db save.

	self setupData.
!

setupData

	"Setup and save the data for a simplified lavatory faucet assembly.

	Assemblies are composed of parts and other assemblies.

	Some of the parts are used in multiple assemblies."



	db store: (Part name: 'spout' number: 101).

	db store: (Part name: 'lever' number: 102).

	db store: (Part name: 'o-ring' number: 103).

	db store: (Part name: 'elbow' number: 104).

	db store: (Part name: 'gasket' number: 105).

	db store: (Part name: 'seat' number: 106).

	db store: (Part name: 'nut' number: 107).

	db store: (Part name: 'lift rod' number: 108).

	db store: (Part name: 'strap' number: 109).

	db store: (Part name: 'pivot rod' number: 110).

	db store: (Part name: 'aerator' number: 111).

	db store: (Part name: 'hub' number: 112).



	db store:

		((Assembly name: 'Handle' number: 151)

			addPart: ((db getOne: #Parts) where: #name eq: 'lever'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'o-ring'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'elbow'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'hub'; execute);

			yourself).

	db store:

		((Assembly name: 'Drain' number: 152)

			addPart: ((db getOne: #Parts) where: #name eq: 'seat'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'gasket'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'o-ring'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'nut'; execute);

			yourself).

	db store:

		((Assembly name: 'Lift Rod' number: 153)

			addPart: ((db getOne: #Parts) where: #name eq: 'lift rod'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'strap'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'nut'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'pivot rod'; execute);

			yourself).

	db store:

		((Assembly name: 'Faucet' number: 154)

			addAssembly: ((db getOne: #Assemblies) where: #name eq: 'Drain'; execute);

			addAssembly: ((db getOne: #Assemblies) where: #name eq: 'Lift Rod'; execute);

			addAssembly: ((db getOne: #Assemblies) where: #name eq: 'Handle'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'spout'; execute);

			addPart: ((db getOne: #Parts) where: #name eq: 'aerator'; execute);

			yourself).
!

stopOnCheckFailure



	^true
!

stopOnError



	^true
!

test1



	| result |

	result := (db getOne: #Assemblies) where: #name eq: 'Handle'; execute.

	self assertTrue: (result parts isMSReadProxy).

	self assertTrue: (result parts first number = 102).  "make sure it reads parts ok."

	result := (db getOne: #Assemblies) where: #name eq: 'Faucet'; execute.

	self assertTrue: (result assemblies isMSReadProxy).
! !

!MinneStoreTestCase2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/tests/MinneStoreTestCase2.st,v 1.4 2014-02-17 21:41:55 cg Exp $'
! !

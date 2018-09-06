"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSExample
	instanceVariableNames:'name number description'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Examples'
!


!MSExample class methodsFor:'instance creation'!

name: aString number: anInteger

	^self new
		name: aString;
		number: anInteger
! !

!MSExample class methodsFor:'examples'!

ExampleCode
"This is the example found on the MinneStore web site."
"Defining the database:"
   | db path|
   "This path'd work with Unix and Windows...By GG"
   path:= 'MinnieStoreDB-Example'.
   db := MinneStoreDB newOn: path.
   db supportMultipleUsers.

   (db addObjectSetNamed: #Parts)
      storesClass: Part;
      indexOn: #name domain: String;
      indexOn: #number domain: Integer.

   (db addObjectSetNamed: #Assemblies)
      storesClass: Assembly;
      indexOn: #name domain: String;
      indexOn: #number domain: Integer;
      aspect: #parts holdsMany: #Parts;
      aspect: #assemblies holdsMany: #Assemblies.

   db save.


"Creating and storing the objects:"

   db := MinneStoreDB openOn: path.

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


"Retrieving from the database:"

   db := MinneStoreDB openOn: path.

  (db getAll: #Parts)
      where: #number between: 105 and: 110;  "inclusive"
      execute.

   (db getAll: #Parts)
      where: #name eq: #('spout'  'aerator');   "either spout or aerator"
    or;  where: #number eq: 105;
      execute.

   (db getAll: #Assemblies)
      where: #name startsWith: 'Fa';
      execute.
!

testCodeSupplybyGG
	"This is an example to test the porting of propertyAT:... methods
	This is a crash-test and works well!!!!

	MSExample testCodeSupplybyGG
	GG
"
        
	| db path |
	"Defining the database:"
	path := 'MinnieStoreGGTestSuite'.
	FlavorCompatibility removeDirectoryNamed: path ifAbsent: [].
	db := MinneStoreDB newOn: path.
	db supportMultipleUsers.
	(db addObjectSetNamed: #IndirizzoPersona)
		storesClass: IndirizzoPersona;
		indexOn: #name domain: String;
		indexOn: #number domain: Integer;
		indexOn: #email domain: String.
	db save.


	"Creating and storing the objects:"
	db := MinneStoreDB openOn: path.
	Transcript show:        'Storing Objects...';cr.
	db
		store: (IndirizzoPersona name: 'Alex Simmerman' number: 7190000);
		store: ((IndirizzoPersona name: 'Frank Petzold' number: 0) 
					email: 'turbine@usa.net');

		store: ((IndirizzoPersona name: 'Mikey Mouse' number: 0) 
					email: 'mouse@acme.it').
        
	db save.
	Object  initPropertyEngine.
	Transcript show:        'REOPENING AND STORING ONE ENTRY AND DELETING ONE';cr.
	db := MinneStoreDB openOn: path.
	db              store: ((IndirizzoPersona name: 'Steffan Kisley' number: 0) 
					email: 'Kisley@iname.com').

	((db getAll: #IndirizzoPersona)
		where: #number
			between: 0
			and: 99999999;
		execute) inspect.       "inclusive"
	db delete:(     ((db getAll: #IndirizzoPersona)
		where: #email eq:#('mouse@acme.it');
		execute) at: 1 ).
	db save.
	"Second clean up"
	Object initPropertyEngine.
	db := MinneStoreDB openOn: path.
	Transcript show:        'Retrieving from the database:';cr.

	((db getAll: #IndirizzoPersona)
		where: #number
			between: 0
			and: 99999999;
		execute) inspect.       "inclusive"

	((db getAll: #IndirizzoPersona)
		where: #name eq: #( 'Frank Petzold');
		or;
		where: #number eq: 7190000;
		execute) inspect.       
	((db getAll: #IndirizzoPersona)
		where: #email startsWith: 'Ki';
		execute) inspect
!

unixTestCodeSupplybyGG
	"This is an example to test the porting of propertyAT:... methods
	This example do not work so well under Linux, but I am working on it!!!!

	MSExample unixTestCodeSupplybyGG
	GG
"
        
	| db path |
	"Defining the database:"
	path := '/tmp/MinnieStoreRubrica'.
	FlavorCompatibility removeDirectoryNamed: path ifAbsent: [].
	db := MinneStoreDB newOn: path.
	db supportMultipleUsers.
	(db addObjectSetNamed: #IndirizzoPersona)
		storesClass: IndirizzoPersona;
		indexOn: #name domain: String;
		indexOn: #number domain: Integer;
		indexOn: #email domain: String.
	db save.


	"Creating and storing the objects:"
	db := MinneStoreDB openOn: path.
	Transcript show:        'Storing Objects...';cr.
	db
		store: (IndirizzoPersona name: 'Alex Simmerman' number: 7190000);
		store: ((IndirizzoPersona name: 'Frank Petzold' number: 0) 
					email: 'turbine@usa.net');

		store: ((IndirizzoPersona name: 'Mikey Mouse' number: 0) 
					email: 'mouse@acme.it').
        
	db save.
	Object  initPropertyEngine.
	Transcript show:        'REOPENING AND STORING ONE ENTRY AND DELETING ONE';cr.
	db := MinneStoreDB openOn: path.
	db              store: ((IndirizzoPersona name: 'Steffan Kisley' number: 0) 
					email: 'Kisley@iname.com').

	((db getAll: #IndirizzoPersona)
		where: #number
			between: 0
			and: 99999999;
		execute) inspect.       "inclusive"
	db delete:(     ((db getAll: #IndirizzoPersona)
		where: #email eq:#('mouse@acme.it');
		execute) at: 1 ).
	db save.
	"Second clean up"
	Object initPropertyEngine.
	db := MinneStoreDB openOn: path.
	Transcript show:        'Retrieving from the database:';cr.

	((db getAll: #IndirizzoPersona)
		where: #number
			between: 0
			and: 99999999;
		execute) inspect.       "inclusive"

	((db getAll: #IndirizzoPersona)
		where: #name eq: #( 'Frank Petzold');
		or;
		where: #number eq: 7190000;
		execute) inspect.       
	((db getAll: #IndirizzoPersona)
		where: #email startsWith: 'Ki';
		execute) inspect
! !

!MSExample methodsFor:'As yet unclassified'!

description

	^description
!

description: aString

	description := aString
!

name

	^name
!

name: aString

	name := aString
!

number

	^number
!

number: anInteger

	number := anInteger
!

printOn: aStream

	super printOn: aStream.
	aStream 
		nextPut: $( ;
		print: name ;
		space;
		print: number;
		nextPut: $).
! !

!MSExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSExample.st,v 1.4 2014-02-17 21:19:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSExample.st,v 1.4 2014-02-17 21:19:29 cg Exp $'
! !

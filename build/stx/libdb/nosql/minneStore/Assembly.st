"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSTestClasses subclass:#Assembly
	instanceVariableNames:'parts assemblies'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-Examples'
!

!Assembly class methodsFor:'documentation'!

examples
"
   Defining the database definition:
                                                        [exBegin]
      |db|

      db := MinneStoreDB newOn: '/tmp/MyDB'.

      (db addObjectSetNamed: #Parts)
         storesClass: Minnestore::Part;
         indexOn: #name domain: String;
         indexOn: #number domain: Integer.

      (db addObjectSetNamed: #Assemblies)
         storesClass: Minnestore::Assembly;
         indexOn: #name domain: String;
         indexOn: #number domain: Integer;
         aspect: #parts holdsMany: #'Minnestore::Parts';
         aspect: #assemblies holdsMany: #'Minnestore::Assemblies'.

      db save.
                                                        [exEnd]

   Creating and storing the objects:
                                                        [exBegin]
      |db|

      db := MinneStoreDB openOn: '/tmp/MyDB'.

      'The parts in the transaction block will all be committed or rolled back.
      (The #transaction: message will not be supported until version 2.1)'.

      db transaction:
        [db store: (Part name: 'spout' number: 101).
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
        ].

      db store:
         ((Minnestore::Assembly name: 'Handle' number: 151)
            addPart: ((db getOne: #Parts) where: #name eq: 'lever'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'o-ring'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'elbow'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'hub'; execute);
            yourself).
      db store:
         ((Minnestore::Assembly name: 'Drain' number: 152)
            addPart: ((db getOne: #Parts) where: #name eq: 'seat'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'gasket'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'o-ring'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'nut'; execute);
            yourself).
      db store:
         ((Minnestore::Assembly name: 'Lift Rod' number: 153)
            addPart: ((db getOne: #Parts) where: #name eq: 'lift rod'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'strap'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'nut'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'pivot rod'; execute);
            yourself).
      db store:
         ((Minnestore::Assembly name: 'Faucet' number: 154)
            addAssembly: ((db getOne: #Assemblies) where: #name eq: 'Drain'; execute);
            addAssembly: ((db getOne: #Assemblies) where: #name eq: 'Lift Rod'; execute);
            addAssembly: ((db getOne: #Assemblies) where: #name eq: 'Handle'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'spout'; execute);
            addPart: ((db getOne: #Parts) where: #name eq: 'aerator'; execute);
            yourself).
                                                        [exEnd]

    Retrieving from the database: 
                                                        [exBegin]
      |db|

      db := MinneStoreDB openOn: '/tmp/MyDB'.

      (db getAll: #Parts)
         where: #number between: 105 and: 110;  
         execute.

      (db getAll: #Parts)
         where: #name eq: #('spout' 'aerator');   
         or: #number eq: 105;
         execute.

      (db getAll: #Assemblies)
         where: #name startsWith: 'Fa';
         execute.
                                                        [exEnd]
"
! !

!Assembly methodsFor:'As yet unclassified'!

addAssembly: anAssembly



	^self assemblies add: anAssembly
!

addPart: aPart



	^self parts add: aPart
!

assemblies



	assemblies isNil

		ifTrue: [assemblies := OrderedCollection new].

	^assemblies.
!

assemblies: anOrderedCollection



	assemblies := anOrderedCollection.
!

displayOn: aStream



	aStream

		print: name

		print: ' assembly'.
!

parts



	parts isNil

		ifTrue: [parts := OrderedCollection new].

	^parts.
!

parts: anOrderedCollection



	parts := anOrderedCollection.
! !

!Assembly class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/Assembly.st,v 1.4 2014-02-17 21:19:29 cg Exp $'
! !

"{ Package: 'stx:libdb/libopenDBX/tools/descriptions/tests' }"

Object subclass:#Dbxpet
	instanceVariableNames:'playerid id petName'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests-Domain'
!


!Dbxpet class methodsFor:'dbxDescriptions'!

descriptionContainer
	^DBXEntity
		new
		name: #Dbxpet;
		className: 'Dbxpet';
		tableName: 'dbxpet';
		category: 'DBXTools-DescriptionsTests-BidirectionalDomain';
		yourself
!

descriptionId
	^MANumberDescription new
		accessor: #id;
		
		primaryKey: true;
		columnType: #integer;
		columnName: 'id';
		instVariableName: 'id';
		name: 'id';
		required: true;
		yourself. 
!

descriptionPetName
	^MAStringDescription new
		accessor: #petName;
		
		columnType: #varchar;
		columnName: 'pet_name';
		instVariableName: 'petName';
		name: 'petName';
		required: true;
		length: '20';
		yourself. 
!

descriptionPlayerid
	^MAToOneRelationDescription new
		accessor: #playerid;
		classes: [Smalltalk at: #Dbxplayer];
		foreignKeyName: 'pet_player';
		columnName: 'playerid';
		name: 'playerid';
		instVariableName: 'playerid';
		foreignEntity: #Dbxplayer;
		yourself. 
! !

!Dbxpet methodsFor:'as yet unclassified'!

id	
		 ^id
!

petName	
		 ^petName
!

petName: aPetName	
		petName := aPetName
!

playerid	
		 ^playerid
!

playerid: aPlayerid	
		playerid := aPlayerid
! !

!Dbxpet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxpet.st,v 1.2 2013-04-15 13:36:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxpet.st,v 1.2 2013-04-15 13:36:32 cg Exp $'
! !


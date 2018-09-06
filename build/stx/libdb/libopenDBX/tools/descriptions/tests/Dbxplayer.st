"{ Package: 'stx:libdb/libopenDBX/tools/descriptions/tests' }"

Object subclass:#Dbxplayer
	instanceVariableNames:'playerName id playerLevel pet items playerClass'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests-Domain'
!


!Dbxplayer class methodsFor:'dbxDescriptions'!

descriptionContainer
	^DBXEntity
		new
		name: #Dbxplayer;
		className: 'Dbxplayer';
		tableName: 'dbxplayer';
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

descriptionItems
	"To many simple relation"
	^MAToManyRelationDescription new
		accessor: #items;
		classes: [Smalltalk at: #Dbxitem];
		foreignEntity: #Dbxitem;
		name: 'playerid';
		instVariableName: 'playerid';
		yourself. 
!

descriptionPet
	"To one bidirectional relation"
	^MAToOneRelationDescription new
		accessor: #pet;
		classes: [Smalltalk at: #Dbxpet];
		foreignEntity: #Dbxpet;
		columnName: 'petid';
		name: 'pet';
		instVariableName: 'pet';
		yourself. 
!

descriptionPlayerClass
	"To one single relation"
	^MAToOneRelationDescription new
		accessor: #playerClass;
		classes: [Smalltalk at: #Dbxclass];
		foreignEntity: #DBXclass;
		columnName: 'classid';
		name: 'playerClass';
		instVariableName: 'playerClass';
		yourself. 
!

descriptionPlayerLevel
	^MANumberDescription new
		accessor: #playerLevel;
		
		columnType: #integer;
		columnName: 'player_level';
		instVariableName: 'playerLevel';
		required: true;
		name: 'playerLevel';
		yourself. 
!

descriptionPlayerName
	^MAStringDescription new
		accessor: #playerName;
		
		columnType: #varchar;
		columnName: 'player_name';
		instVariableName: 'playerName';
		name: 'playerName';
		required: true;
		length: 20;
		yourself. 
! !

!Dbxplayer methodsFor:'as yet unclassified'!

addItem: itemName
	self items add: (Dbxitem new itemName: itemName; yourself)
!

id	
		 ^id
!

initialize
	items := Set new
!

items
	^items
!

items: someItems
	items := someItems
!

pet
	^pet
!

pet: aPet
	pet:= aPet
!

playerClass
	^playerClass
!

playerClass: aPlayerClass
	playerClass := aPlayerClass
!

playerLevel	
		 ^playerLevel
!

playerLevel: aPlayerLevel	
		playerLevel := aPlayerLevel
!

playerName	
		 ^playerName
!

playerName: aPlayerName	
		playerName := aPlayerName
! !

!Dbxplayer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxplayer.st,v 1.2 2013-04-15 13:36:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxplayer.st,v 1.2 2013-04-15 13:36:34 cg Exp $'
! !


"{ Package: 'stx:libdb/libopenDBX/tools/descriptions/tests' }"

Object subclass:#Dbxitem
	instanceVariableNames:'itemName playerid id'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests-Domain'
!


!Dbxitem class methodsFor:'dbxDescriptions'!

descriptionContainer
	^DBXEntity new
		name: #Dbxitem;
		className: 'Dbxitem';
		tableName: 'dbxitem';
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

descriptionItemName
	^MAStringDescription new
		accessor: #itemName;
		
		columnType: #varchar;
		columnName: 'item_name';
		instVariableName: 'itemName';
		name: 'itemName';
		required: true;
		length: '50';
		yourself. 
!

descriptionPlayerid
	^MAToOneRelationDescription new
		classes: [Smalltalk at: #Dbxplayer];
		foreignKeyName: 'item_player';
		columnName: 'playerid';
		name: 'playerid';
		foreignEntity: #Dbxplayer;
		yourself. 
! !

!Dbxitem methodsFor:'as yet unclassified'!

id	
		 ^id
!

itemName	
		 ^itemName
!

itemName: anItemName	
		itemName := anItemName
! !

!Dbxitem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxitem.st,v 1.2 2013-04-15 13:36:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxitem.st,v 1.2 2013-04-15 13:36:33 cg Exp $'
! !


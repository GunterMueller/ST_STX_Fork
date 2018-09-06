"{ Package: 'stx:libdb/libopenDBX/tools/descriptions/tests' }"

Object subclass:#Dbxclass
	instanceVariableNames:'className specialAbility powerBonus id'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests-Domain'
!


!Dbxclass class methodsFor:'as yet unclassified'!

descriptionContainer
	^DBXEntity new
		name: #Dbxclass;
		className: 'Dbxclass';
		tableName: 'dbxclass';
		category: 'DBXTools-DescriptionsTests-Domain';
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

descriptionPlayerName
	^MAStringDescription new
		accessor: #className;
		columnType: #varchar;
		columnName: 'class_name';
		instVariableName: 'className';
		name: 'className';
		required: true;
		length: 20;
		yourself. 
!

descriptionPlayerid
	^MAToOneRelationDescription new
		classes: [Smalltalk at: #Dbxplayer];
		foreignKeyName: 'class_player';
		columnName: 'playerid';
		name: 'playerid';
		foreignEntity: #Dbxplayer;
		yourself. 
!

descriptionPowerBonus
	^MANumberDescription new
		accessor: #powerBonus;
		columnType: #integer;
		columnName: 'power_bonus';
		instVariableName: 'powerBonus';
		name: 'powerBonus';
		required: true;
		yourself. 
!

descriptionSpecialAbility
	^MAStringDescription new
		accessor: #specialAbility;
		columnType: #varchar;
		columnName: 'special_ability';
		instVariableName: 'specialAbility';
		name: 'specialAbility';
		required: true;
		length: 20;
		yourself. 
! !

!Dbxclass methodsFor:'accessing'!

className
	^ className
!

className: anObject
	className := anObject
!

id
	^ id
!

id: anId
	id := anId
!

powerBonus
	^ powerBonus
!

powerBonus: anObject
	powerBonus := anObject
!

specialAbility
	^ specialAbility
!

specialAbility: anObject
	specialAbility := anObject
! !

!Dbxclass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxclass.st,v 1.2 2013-04-15 13:36:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/tests/Dbxclass.st,v 1.2 2013-04-15 13:36:35 cg Exp $'
! !


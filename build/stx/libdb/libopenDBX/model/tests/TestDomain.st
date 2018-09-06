"{ Package: 'stx:libdb/libopenDBX/model/tests' }"

Object subclass:#TestDomain
	instanceVariableNames:'provider'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModelTests'
!


!TestDomain methodsFor:'as yet unclassified'!

abilityTable
	| builder |
	builder := DBXTable named: 'dbxmple_Ability'.
	builder
		addColumn: 'id' ofType: 'integer';
		addColumn: 'ability_name' ofType: 'varchar' withLength: 20.
	^ builder
!

getTables
	| tables builder |
	tables := Set new.
	tables add: self petTable.
	tables add: self abilityTable.
	tables add: self playerAbilityTable.
	tables add: self playerTable.
	tables add: self witcherTable.
	^ tables
!

petTable
	| builder |
	builder := DBXTable named: 'dbxmple_Pet'.
	builder
		addColumn: 'id' ofType: 'integer';
		addColumn: 'playerId' ofType: 'integer';
		addColumn: 'pet_level' ofType: 'integer';
		addColumn: 'health' ofType: 'integer';
		addColumn: 'race' ofType: 'varchar' withLength: 20;
		addColumn: 'pet_name' ofType: 'varchar' withLength: 20.
	^ builder
!

playerAbilityTable
	| builder |
	builder := DBXTable named: 'dbxmple_Players_Abilities'.
	builder
		addColumn: 'id' ofType: 'integer';
		addColumn: 'player_id' ofType: 'integer';
		addColumn: 'ability_id' ofType: 'integer'.
	^ builder
!

playerTable
	| builder |
	builder := DBXTable named: 'dbxmple_Player'.
	builder
		addColumn: 'id' ofType: 'integer';
		addColumn: 'coins' ofType: 'integer';
		addColumn: 'health' ofType: 'integer';
		addColumn: 'player_level' ofType: 'integer';
		addColumn: 'player_name' ofType: 'varchar' withLength: 20.
	^ builder
!

witcherTable
	| builder |
	builder := DBXTable named: 'dbxmple_Witcher'.
	builder
		addColumn: 'id' ofType: 'integer';
		addColumn: 'playerId' ofType: 'integer';
		addColumn: 'witcherLevel' ofType: 'integer';
		addColumn: 'mutagensApplied' ofType: 'integer'.
	^ builder
! !

!TestDomain class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/tests/TestDomain.st,v 1.2 2013-04-15 13:33:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/tests/TestDomain.st,v 1.2 2013-04-15 13:33:38 cg Exp $'
! !


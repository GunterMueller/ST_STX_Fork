"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

Object subclass:#MagritteBuilderDomain
	instanceVariableNames:'provider'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!MagritteBuilderDomain methodsFor:'as yet unclassified'!

getTables
	| tables builder |
	
	tables := OrderedCollection new.

	"  Player table definition "	
	builder := DBXTable named: 'dbxplayer'.
	(builder addColumn: 'id' ofType: 'SERIAL') bePrimaryKey.
	builder addColumn: 'petId' ofType: 'integer'.
	builder addColumn: 'player_level' ofType: 'integer'.
	builder addColumn: 'player_name' ofType: 'varchar' withLength: 20.
	tables add: builder.

	"  pet table definition "			
	builder := DBXTable named: 'dbxpet'.
	(builder addColumn: 'id' ofType: 'SERIAL') bePrimaryKey.
	builder addColumn: 'playerId' ofType: 'integer'.
	builder addColumn: 'pet_name' ofType: 'varchar' withLength: 20.
	builder addComponentToForeignKey: 'pet_player' foreignTable: 'dbxplayer' foreignColumn: 'id' column: 'playerId'.
	tables add: builder.

	builder := DBXTable named: 'dbxitem'.
	(builder addColumn: 'id' ofType: 'SERIAL') bePrimaryKey.
	builder addColumn: 'item_name' ofType: 'varchar' withLength: 50.
	builder addColumn: 'playerid' ofType: 'integer'.
	builder addComponentToForeignKey: 'item_player' foreignTable: 'dbxplayer' foreignColumn: 'id' column: 'playerId'.
	tables add: builder.
	
	^tables 
! !

!MagritteBuilderDomain class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/MagritteBuilderDomain.st,v 1.2 2013-04-15 13:35:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/MagritteBuilderDomain.st,v 1.2 2013-04-15 13:35:04 cg Exp $'
! !


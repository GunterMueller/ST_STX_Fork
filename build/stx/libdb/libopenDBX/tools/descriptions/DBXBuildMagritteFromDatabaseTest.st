"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

TestCase subclass:#DBXBuildMagritteFromDatabaseTest
	instanceVariableNames:'tables builder'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!DBXBuildMagritteFromDatabaseTest methodsFor:'as yet unclassified'!

setUp
	tables := MagritteBuilderDomain new getTables.
	builder := DBXDescriptionFromTableBuilder new.
!

tableNames
	^tables collect: #name
!

testBuildAttributesFromColumns
	| description table |
	table := tables detect: [ :t | t name = 'dbxpet' ].
	description := DBXDescriptionFromTableBuilder new table: table; generateMagritteDescription.
	self assert: ((description children collect: #columnName) includesAllOf: (table columns collect: #name)).
!

testBuildForeignKeyAttrribute
	| table attribute playerDescription petDescription |
	playerDescription := DBXDescriptionFromTableBuilder new table: (tables detect: [ :t | t name = 'dbxplayer' ]); generateMagritteDescription.
	table := tables detect: [ :t | t name = 'dbxpet' ].
	petDescription := DBXDescriptionFromTableBuilder new table: table; generateMagritteDescription.
	attribute := (petDescription children detect: [ :attr | attr name = #playerid ]).
	self assert: (attribute isKindOf: MARelationDescription).
	self assert: (attribute foreignEntity = playerDescription name ) 
!

testBuildTables
	| descriptions |
	descriptions := tables collect: [ :table | DBXDescriptionFromTableBuilder new table: table; generateMagritteDescription ].	
	self assert: ((descriptions collect: #tableName) 
		includesAllOf: self tableNames).
	self assert: ((descriptions collect: #name) 
		includesAllOf: (self tableNames collect: [:n | n capitalized asSymbol ])).
! !

!DBXBuildMagritteFromDatabaseTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXBuildMagritteFromDatabaseTest.st,v 1.2 2013-04-15 13:34:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXBuildMagritteFromDatabaseTest.st,v 1.2 2013-04-15 13:34:53 cg Exp $'
! !


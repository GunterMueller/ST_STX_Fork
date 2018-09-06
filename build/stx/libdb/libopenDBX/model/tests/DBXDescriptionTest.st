"{ Package: 'stx:libdb/libopenDBX/model/tests' }"

DBXBaseTest subclass:#DBXDescriptionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModelTests'
!


!DBXDescriptionTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
!

testCreateAndDropTableFromDescription
	| descriptions domain conn| 
	[
	conn := self doConnectAndOpen.
	domain := (TestDomain new ) getTables.
	domain do:[ :table | conn execute: table generateCreateTable ].
	descriptions := domain collect: [:table | conn tableDescription: table name ].
	self assert:  descriptions size = domain size.
	] ensure: [ domain do: [ :table | [conn execute: table generateDropTable] on: Error do: [] ] ]
!

testGetAllTablesDescriptionNotEmptyTest
	|conn tables|
	conn := self doConnectAndOpen.
	tables := conn tablesDescription.
	self assert: tables notEmpty .  
	conn close.
	conn disconnect
!

testGetColumnDescription
	| conn select result aRow |
	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	result := conn execute: select.
	self
		should: [result description columnDescriptionAt: 0]
		raise: Error.
	self
		should: [result description columnDescriptionAt: 7]
		raise: Error.
	self
		shouldnt: [result description columnDescriptionAt: 1]
		raise: Error.
	self
		shouldnt: [result description columnDescriptionAt: 2]
		raise: Error.
	self assert: ((result description columnDescriptionAt: 1) name sameAs: 'code').
	aRow := result nextRow.
	self assert: aRow isNil.
	select := 'SELECT code FROM signature'.
	result := conn execute: select.
	self
		should: [result description columnDescriptionAt: 2]
		raise: Error.
	self
		shouldnt: [result description columnDescriptionAt: 1]
		raise: Error.
	self assert: ((result description columnDescriptionAt: 1) name sameAs: 'code').
	aRow := result nextRow.
	self assert: aRow isNil.
	conn close.
	conn disconnect
!

testGetColumnDescriptionWithName
	| conn select result aRow |
	conn := self doConnectAndOpen.
	select := 'SELECT code FROM signature'.
	result := conn execute: select.
	self
		should: [result columnDescriptionWithName: 'noexist']
		raise: DBXError.
	self
		should: [result columnDescriptionWithName: 'name']
		raise: DBXError.
	self
		shouldnt: [result columnDescriptionWithName: 'code']
		raise: DBXError.
	aRow := result nextRow.
	self assert: aRow isNil.
	conn close.
	conn disconnect
!

testGetColumnDescriptionWithNameAlias
	| conn select result aRow |
	conn := self doConnectAndOpen.
	select := 'SELECT code as aCode FROM signature'.
	result := conn execute: select.
	self
		should: [result columnDescriptionWithName: 'noexist']
		raise: DBXError.
	self
		should: [result columnDescriptionWithName: 'name']
		raise: DBXError.
	self
		should: [result columnDescriptionWithName: 'code']
		raise: DBXError.
	self
		shouldnt: [result columnDescriptionWithName: 'aCode']
		raise: DBXError.
	
	aRow := result nextRow.
	self assert: aRow isNil.
	conn close.
	conn disconnect
!

testGetTableDescription
	| conn description tableName attribute |
	conn := self doConnectAndOpen.

	tableName := 'signature'.
	description := self platform tableDescription: tableName on:  conn.
	self assert: description name equals: tableName.
	self shouldnt: (attribute := description columns 
		detect: [:at | at name asUppercase  = 'id_student' asUppercase ]) raise: Error .
	self assert: attribute typeName asUppercase equals: self platform int asUppercase.
	self deny: attribute nullable .  
	conn close.
	conn disconnect
!

testGetTablesFromSchema
	| descriptions domain conn schema | 
	[
	conn := self doConnectAndOpen.
	domain := (TestDomain new ) getTables.
	domain do:[ :table | conn execute: table generateCreateTable ].
	
	(conn platform isKindOf: DBXPostgresBackend)
		ifTrue: [ schema := 'public' ]
		ifFalse: [ schema := 'sodbxtest' ].
	
	descriptions := (conn tablesDescriptionForSchema: schema) 
		select: [ :t | t name asLowercase beginsWith: 'dbx' ].
	
	self assert:  descriptions size = domain size.
	] ensure: [ domain do: [ :table | [conn execute: table generateDropTable] on: Error do: [] ] ]
! !

!DBXDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/tests/DBXDescriptionTest.st,v 1.2 2013-04-15 13:33:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/tests/DBXDescriptionTest.st,v 1.2 2013-04-15 13:33:37 cg Exp $'
! !


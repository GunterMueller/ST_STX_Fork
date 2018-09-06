"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXLargeObjectsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXLargeObjectsTest methodsFor:'as yet unclassified'!

platformMysqlPrepareLargeObjects: aConnection

	| resultSet row |
	[ aConnection execute: 'DROP TABLE test_large_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_large_columns (
			large_clob 		TEXT,
			large_blob        BLOB)'.
	
	aConnection execute: '
          INSERT INTO test_large_columns (large_clob, large_blob)
		VALUES (''large_clob_data'', ''large_blob_data'')'.
		
	self shouldnt: [ resultSet := aConnection execute: 'SELECT * FROM test_large_columns' ]
		raise: DBXError.
			
	row := resultSet rows first.
	
	self assert: (row valueNamed: 'large_clob') = 'large_clob_data'.
	self assert: (row valueNamed: 'large_blob') = 'large_blob_data' asByteArray .
!

platformOraclePrepareLargeObjects: aConnection

	| resultSet row |
	[ aConnection execute: 'DROP TABLE test_large_columns' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_large_columns (
			large_clob 		CLOB,
			large_nclob       NCLOB,
			large_blob        BLOB)'.
	
	aConnection execute: '
          INSERT INTO test_large_columns (large_clob, large_nclob, large_blob)
		VALUES (''large_clob_data'' , ''large_nclob_data'' , EMPTY_BLOB() )'.
		
	self shouldnt: [ resultSet := aConnection execute: 'SELECT large_clob, large_nclob, large_blob FROM test_large_columns' ]
		raise: DBXError.
	row := resultSet rows first.
	
	self assert: (row valueNamed: 'large_clob') = 'large_clob_data'.
	self assert: (row valueNamed: 'large_nclob') = 'large_nclob_data' .
!

platformPgsqlPrepareLargeObjects: aConnection

	| resultSet row |
	[ aConnection execute: 'DROP TABLE test_large_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_large_columns (
			large_clob 		TEXT)'.
	
	aConnection execute: '
          INSERT INTO test_large_columns (large_clob)
		VALUES (''large_clob_data'')'.
		
	self shouldnt: [ resultSet := aConnection execute: 'SELECT * FROM test_large_columns' ]
		raise: DBXError.
			
	row := resultSet rows first.
	
	self assert: (row valueNamed: 'large_clob') = 'large_clob_data'.
!

platformSqlite3PrepareLargeObjects: aConnection

	| resultSet row |
	[ aConnection execute: 'DROP TABLE test_large_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_large_columns (
			large_clob 		CLOB,
			large_blob        BLOB)'.
	
	aConnection execute: '
          INSERT INTO test_large_columns (large_clob, large_blob)
		VALUES (''large_clob_data'', ''large_blob_data'')'.
		
	self shouldnt: [ resultSet := aConnection execute: 'SELECT * FROM test_large_columns' ]
		raise: DBXError.
			
	row := resultSet rows first.
	
	self assert: (row valueNamed: 'large_clob') = 'large_clob_data'.
	self assert: (row valueNamed: 'large_blob') = 'large_blob_data'.
!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
!

testReadLargeObjects
	| conn resultSet row |
	
	self facility platform supportsLargeObjects ifFalse: [ ^self ].
	
	conn := self doConnectAndOpen.
	self shouldnt: [ self platformCall: #prepareLargeObjects: with: conn ]
		raise: DBXError.
		
"	self shouldnt: [ resultSet := conn execute: 'SELECT * FROM test_datetime_columns' ]
		raise: DBXError.
			
	row := resultSet rows first.
	
"
	conn disconnect.
	
! !

!DBXLargeObjectsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXLargeObjectsTest.st,v 1.2 2013-04-15 13:18:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXLargeObjectsTest.st,v 1.2 2013-04-15 13:18:08 cg Exp $'
! !


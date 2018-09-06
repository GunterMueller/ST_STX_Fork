"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXTypeTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXTypeTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
! !

!DBXTypeTest methodsFor:'tests'!

platformFirebirdPrepareDatetime: aConnection
	[ aConnection execute: 'DROP TABLE test_datetime_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_datetime_columns (
			datetime_date 			DATE,
			datetime_time 			TIME,
			datetime_timestamp 	TIMESTAMP);'.

	aConnection execute: '
		INSERT INTO test_datetime_columns
			(datetime_date, datetime_time, datetime_timestamp)
		VALUES (''2008-01-20'', ''10:20:30'', ''2008-01-20 10:20:30'');'.
!

platformMssqlPrepareDatetime: aConnection
	[ aConnection execute: 'DROP TABLE test_datetime_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_datetime_columns (
			datetime_date 			DATETIME,
			datetime_time 			DATETIME,
			datetime_timestamp 		DATETIME);'.

	aConnection execute: '
		INSERT INTO test_datetime_columns
			(datetime_date, datetime_time, datetime_timestamp)
		VALUES (''2008-01-20'', ''10:20:30'', ''2008-01-20 10:20:30'');'.
!

platformMysqlPrepareDatetime: aConnection
	[ aConnection execute: 'DROP TABLE test_datetime_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_datetime_columns (
			datetime_date 			DATE,
			datetime_time 			TIME,
			datetime_timestamp 	DATETIME);'.

	aConnection execute: '
		INSERT INTO test_datetime_columns
			(datetime_date, datetime_time, datetime_timestamp)
		VALUES (''2008-01-20'', ''10:20:30'', ''2008-01-20 10:20:30'');'.
	
!

platformMysqlTestCharacter: aRow
	self assert: (aRow valueNamed: 'char_char') = 'test'.
!

platformMysqlTestDatetime: aRow
	self assert: (aRow valueNamed: 'datetime_time') = (Time hour: 10 minute: 20 second: 30).
!

platformOraclePrepareDatetime: aConnection 
	[aConnection execute: 'DROP TABLE test_datetime_columns']
		on: Error do: [:e | "table exists" e].
	aConnection execute: '
	CREATE TABLE test_datetime_columns (
			datetime_date 			DATE,
			datetime_timestamp 	TIMESTAMP)'.

	aConnection execute: '
          INSERT INTO test_datetime_columns
			(datetime_date, datetime_timestamp)
		VALUES (to_date(''2008-01-20 01:01:01'', ''yyyy-mm-dd hh:mi:ss''), to_date(''2008-01-20 10:20:30'', ''yyyy-mm-dd hh:mi:ss''))'
!

platformPgsqlPrepareDatetime: aConnection
	[ aConnection execute: 'DROP TABLE test_datetime_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_datetime_columns (
			datetime_date 			DATE,
			datetime_time 			TIME,
			datetime_timestamp 	TIMESTAMP);'.

	aConnection execute: '
		INSERT INTO test_datetime_columns
			(datetime_date, datetime_time, datetime_timestamp)
		VALUES (''2008-01-20'', ''10:20:30'', ''2008-01-20 10:20:30'');'.
!

platformPgsqlTestBoolean
	| conn resultSet row |
	conn := self doConnectAndOpen.
	self shouldnt: [
		conn execute: 'DROP TABLE IF EXISTS test_boolean_columns;'.
		conn execute: '
			CREATE TABLE test_boolean_columns (
				bool_boolean 	BOOLEAN);'.
		conn execute: '		
			INSERT INTO test_boolean_columns
				(bool_boolean)
				VALUES (true);' ]
		raise: DBXError.
		
	self shouldnt: [ resultSet := conn execute: 'SELECT * FROM test_boolean_columns' ]
		raise: DBXError.
			
	row := resultSet rows first.
	self assert: (row valueNamed: 'bool_boolean').
		
	conn close.
!

platformPgsqlTestCharacter: aRow
	self assert: (aRow valueNamed: 'char_char') = 
		('test' padded: #right to: 10 with: Character space).
!

platformPgsqlTestDatetime: aRow
	self assert: (aRow valueNamed: 'datetime_time') = (Time hour: 10 minute: 20 second: 30).
!

platformSqlite3PrepareDatetime: aConnection
	[ aConnection execute: 'DROP TABLE test_datetime_columns;' ]
	on: Error do: [ :e| "table exists" ].

	aConnection execute: '
		CREATE TABLE test_datetime_columns (
			datetime_date 			DATE,
			datetime_time 			TIME,
			datetime_timestamp 	TIMESTAMP);'.

	aConnection execute: '
		INSERT INTO test_datetime_columns
			(datetime_date, datetime_time, datetime_timestamp)
		VALUES (''2008-01-20'', ''10:20:30'', ''2008-01-20 10:20:30'');'.
!

testBoolean
	"Not all paltforms have Boolean type support"
	self platformCall: #testBoolean
!

testCharacter
	| conn resultSet row |
	conn := self doConnectAndOpen.
	self
		shouldnt: [[conn execute: 'DROP TABLE test_character_columns']
				on: Error
				do: [:e | "table exists"
					e].
		]
		raise: DBXError.
		conn execute: '
			CREATE TABLE test_character_columns (
				char_char		CHAR(10),
				char_varchar	VARCHAR(10))'.
			conn execute: '
			INSERT INTO test_character_columns
				(char_char, char_varchar)
				VALUES (''test'', ''test'')'.
	self
		shouldnt: [resultSet := conn execute: 'SELECT * FROM test_character_columns']
		raise: DBXError.
	row := resultSet rows first.
	self platformCall: #testCharacter: with: row.
	self assert: (row valueNamed: 'char_varchar')
			= 'test'.
			
	conn disconnect.
!

testDatetime
	| conn resultSet row |
	conn := self doConnectAndOpen.
	self shouldnt: [ self platformCall: #prepareDatetime: with: conn ]
		raise: DBXError.
		
	self shouldnt: [ resultSet := conn execute: 'SELECT * FROM test_datetime_columns' ]
		raise: DBXError.
			
	row := resultSet rows first.

	"Sqlite3 doesn't store time and dates values in specific types but uses CLOB instead. We map CLOB with String, yo for Sqlite3 we have to compare the date with the string'"
	
	(self platform class = DBXSqliteBackend) ifTrue:[
		
		self assert: (row valueNamed: 'datetime_date') = (Date year: 2008 month: 1 day: 20) yyyymmdd.
		
		self assert: (row valueNamed: 'datetime_timestamp') = 
			(TimeStamp 
				year: 2008 
				month: 1 
				day: 20 
				hour: 10 
				minute: 20 
				second: 30) yyyymmddhhmmss.	
		
	] ifFalse:[

	self assert: (row valueNamed: 'datetime_date') = (Date year: 2008 month: 1 day: 20).
	self assert: (row valueNamed: 'datetime_timestamp') = 
		(TimeStamp 
			year: 2008 
			month: 1 
			day: 20 
			hour: 10 
			minute: 20 
			second: 30).
			
	].


	"Not all platforms has the same behaivor (or types) for date-time, then I check specific 
	 behaivor separately"
	self platformCall: #testDatetime: with: row.
	
	conn disconnect.
!

testNumeric
	| conn resultSet row |
	conn := self doConnectAndOpen.
	self
		shouldnt: [[conn execute: 'DROP TABLE test_numeric_columns']
				on: Error
				do: [:e | "table exists"
					e]]
		raise: DBXError.
	conn execute: '
			CREATE TABLE test_numeric_columns (
				number_decimal 	DECIMAL(5,2),
				number_real 		REAL,
				number_float 		FLOAT,
				number_smallint 	SMALLINT,
				number_integer 		INTEGER)'.
	conn execute: '
			INSERT INTO test_numeric_columns
				(number_decimal, number_real, number_float, number_smallint, number_integer)
				VALUES (42.2, 42.2, 42.2, 42, 42)'.
	self
		shouldnt: [resultSet := conn execute: 'SELECT * FROM test_numeric_columns']
		raise: DBXError.
	row := resultSet rows first.
	self assert: (row valueNamed: 'number_decimal')
			= 42.2.
	"Some databases, like ODBC with postgres and Firebird return 42.20001 instead of 42.2. Because of this the roundTo."
	self assert: ((row valueNamed: 'number_real') roundTo: 0.01) = 42.2.
			
	self assert: ((row valueNamed: 'number_float') roundTo: 0.01)
			= 42.2.
	self assert: (row valueNamed: 'number_smallint')
			= 42.
	self assert: (row valueNamed: 'number_integer')
			= 42.
	
	conn disconnect.
! !

!DBXTypeTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTypeTest.st,v 1.2 2013-04-15 13:18:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTypeTest.st,v 1.2 2013-04-15 13:18:04 cg Exp $'
! !


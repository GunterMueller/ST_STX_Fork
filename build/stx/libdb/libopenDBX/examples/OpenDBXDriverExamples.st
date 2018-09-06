"{ Package: 'stx:libdb/libopenDBX/examples' }"

Object subclass:#OpenDBXDriverExamples
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTalkExamples'
!


!OpenDBXDriverExamples methodsFor:'queryDatabase'!

queryMySQLTable
	"self new queryMySQLTable"
	| settings connection resultset |
	settings := DBXConnectionSettings 
		host: 'localhost'
		port: '3306'
		database: 'sodbxtest' 
		userName: 'sodbxtest'
		userPassword: 'sodbxtest'.
	
	connection := DBXConnection 
		platform: DBXMySQLBackend new 
		settings: settings.
	[connection connectAndOpen.
	connection execute: 'CREATE TABLE USER (ID INT, NAME VARCHAR(255))'.
	connection execute: 'INSERT INTO USER VALUES(1, ''Guille'')'.
	connection execute: 'INSERT INTO USER VALUES(2, ''Santi'')'.
	connection execute: 'INSERT INTO USER VALUES(3, ''Marianito'')'.
	resultset := connection execute: 'SELECT * FROM USER'.
	DBXTranscript show: resultset. 
	connection execute: 'DROP TABLE USER'.]
		ensure: [ connection disconnect ]
!

queryOracleTable
	"self new queryOracleTable"
	| settings connection resultset |
	settings := DBXConnectionSettings 
		host: '127.0.0.1'
		port: '1521'
		database: 'xe'
		userName: 'sodbxtest'
		userPassword: 'sodbxtest'.
	
	connection := DBXConnection 
		platform: DBXOracleBackend new 
		settings: settings.
	[connection connectAndOpen.
	connection execute: 'CREATE TABLE USERS (ID INT, NAME VARCHAR(255))'.
	connection execute: 'INSERT INTO USERS VALUES(1, ''Guille'')'.
	connection execute: 'INSERT INTO USERS VALUES(2, ''Santi'')'.
	connection execute: 'INSERT INTO USERS VALUES(3, ''Marianito'')'.
	resultset := connection execute: 'SELECT * FROM USERS'.
	DBXTranscript show: resultset. 
	connection execute: 'DROP TABLE USERS'.]
		ensure: [ connection disconnect ]
!

queryPostgreSQLTable
	"self new queryPostgreSQLTable"
	| settings connection resultset |
	settings := DBXConnectionSettings 
		host: '127.0.0.1'
		port: '5432'
		database: 'sodbxtest'
		userName: 'sodbxtest'
		userPassword: 'sodbxtest'.
	
	connection := DBXConnection 
		platform: DBXPostgresBackend new 
		settings: settings.
	[connection connectAndOpen.
	connection execute: 'CREATE TABLE USERS (ID INT, NAME VARCHAR(255))'.
	connection execute: 'INSERT INTO USERS VALUES(1, ''Guille'')'.
	connection execute: 'INSERT INTO USERS VALUES(2, ''Santi'')'.
	connection execute: 'INSERT INTO USERS VALUES(3, ''Marianito'')'.
	resultset := connection execute: 'SELECT * FROM USERS'.
	DBXTranscript show: resultset. 
	connection execute: 'DROP TABLE USERS'.]
		ensure: [ connection disconnect ]
!

querySQLiteTable
	"self new querySQLiteTable"
	| settings connection resultset |
	settings := DBXConnectionSettings 
		host: SmalltalkImage current imagePath, '/'
		port: ''
		database: 'sodbxtest.db' 
		userName: ''
		userPassword: ''.
	
	connection := DBXConnection 
		platform: DBXSqliteBackend new 
		settings: settings.
	[connection connectAndOpen.
	connection execute: 'CREATE TABLE USER (ID INT, NAME VARCHAR(255))'.
	connection execute: 'INSERT INTO USER VALUES(1, ''Guille'')'.
	connection execute: 'INSERT INTO USER VALUES(2, ''Santi'')'.
	connection execute: 'INSERT INTO USER VALUES(3, ''Marianito'')'.
	resultset := connection execute: 'SELECT * FROM USER'.
	DBXTranscript show: resultset. 
	connection execute: 'DROP TABLE USER'.]
		ensure: [ connection disconnect ]
! !

!OpenDBXDriverExamples class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/OpenDBXDriverExamples.st,v 1.1 2013-04-15 13:48:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/OpenDBXDriverExamples.st,v 1.1 2013-04-15 13:48:04 cg Exp $'
! !


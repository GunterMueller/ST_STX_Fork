"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

TestCase subclass:#DBXExamples
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests-Extras'
!


!DBXExamples methodsFor:'as yet unclassified'!

testExampleConnection
	| conn connectionSettings |
	connectionSettings := DBXConnectionSettings
			host: '127.0.0.1'
			port: '5432'
			database: 'sodbxtest'
			userName: 'sodbxtest'
			userPassword: 'sodbxtest'.
	conn := DBXConnection platform: DBXPostgresBackend new settings: connectionSettings.
	conn connect.
	conn open.
	self addConnectionToRelease: conn.
	conn close.
	conn disconnect.
!

testExampleWithDML
	| conn connectionSettings resultUpdate resultDelete |
	connectionSettings := DBXConnectionSettings
			host: '127.0.0.1'
			port: '5432'
			database: 'sodbxtest'
			userName: 'sodbxtest'
			userPassword: 'sodbxtest'.
	conn := DBXConnection platform: DBXPostgresBackend new settings: connectionSettings.
	conn connect.
	conn open.
	self addConnectionToRelease: conn.
	conn execute: 'delete from student'.
	conn execute: 'INSERT INTO student (id, name_surname, age) VALUES (100, ''Mariano Squeak'', 23) '.
	resultUpdate := conn execute: 'update student set name_surname = ''something'' where id = 100'.
	self assert: resultUpdate class = DBXResult.
	self assert: resultUpdate rowsAffected = 1.
	resultDelete := conn execute: 'delete from student where id = 100'.
	self assert: resultDelete class = DBXResult.
	self assert: resultDelete rowsAffected = 1.
	conn startTransaction.
	conn execute: 'INSERT INTO student (id, name_surname, age) VALUES (101, ''Mariano Squeak'', 23) '.
	conn commit. 
	conn close.
	conn disconnect.
! !

!DBXExamples class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXExamples.st,v 1.2 2013-04-15 13:18:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXExamples.st,v 1.2 2013-04-15 13:18:03 cg Exp $'
! !


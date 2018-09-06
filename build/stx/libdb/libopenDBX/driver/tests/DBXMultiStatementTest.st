"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXMultiStatementTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXMultiStatementTest methodsFor:'as yet unclassified'!

expectedFailures
	^ (DBXBaseTest facility class = DBXMsSQLFacility) 
		ifTrue: [ #(testSQLThenDML testSQLWithoutIteratingAllRowsInAResult)]
		ifFalse: [ #()].
	
	
!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	aConnection execute:' INSERT INTO student (id, name_surname, age) VALUES (2, ''Hernan Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (3, ''German Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (4, ''Alejandro Squeak'', 30) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	
	aConnection execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (59, ''TADP'', ''Tecnicas Av'', 1) '.
	aConnection execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (60, ''APIT'', ''ARQUITECTURA DE PROYECTOS DE IT'', 2) '.
	
	"aConnection execute: 'INSERT INTO course(id_course, id_student, signature_code, starting_hour)  VALUES (5, 5, 5, null);'."
!

testDMLThenSQL
	| conn insert select iterator dmlResult sqlResult aRow supportsMultipleStatements |
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (11, ''Something'', ''Nothing'', 2)'.
	select := 'SELECT * FROM student'.
	
	iterator := conn executeMultiStatement: (insert, '; ', select).
	
	dmlResult := iterator next.
	self assert: dmlResult class = DBXResult.
	self assert: dmlResult rowsAffected = 1.

	sqlResult := iterator next.
	self assert: sqlResult class = DBXResultSet.
	self shouldnt: [ sqlResult nextRow ] raise: DBXError.
	[ aRow := sqlResult nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: aRow isNil.
	
	self assert: iterator next isNil.
	
	conn close.
	conn disconnect.
!

testMultiStatementTranscript
	| conn insert select iterator supportsMultipleStatements |
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (11, ''Something'', ''Nothing'', 2)'.
	select := 'SELECT * FROM student'.
	
	iterator := conn executeMultiStatement: (insert, '; ', select).
	DBXTranscript show: iterator.	

	conn close.
	conn disconnect.
!

testSQLThenDML
	| conn insert select iterator dmlResult sqlResult aRow supportsMultipleStatements |
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (11, ''Something'', ''Nothing'', 2)'.
	select := 'SELECT * FROM student'.
	
	iterator := conn executeMultiStatement: (select, '; ', insert).

	sqlResult := iterator next.
	self assert: sqlResult class = DBXResultSet.
	self shouldnt: [ sqlResult nextRow ] raise: DBXError.
	[ aRow := sqlResult nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: aRow isNil.
	
	dmlResult := iterator next.
	self assert: dmlResult class = DBXResult.
	self assert: dmlResult rowsAffected = 1.

	self assert: iterator next isNil.

	conn close.
	conn disconnect.
!

testSQLThenSQL
	| conn select iterator sqlResult supportsMultipleStatements select2 |
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	
	select := 'SELECT code FROM signature'.
	select2 := 'SELECT id, name_surname FROM student'.
	
	iterator := conn executeMultiStatement: (select, '; ', select2).

	sqlResult := iterator next.
	self assert: sqlResult class = DBXResultSet.
	self assert: sqlResult columnCount = 1.
	DBXTranscript show: sqlResult.
	
	sqlResult := iterator next.
	self assert: sqlResult class = DBXResultSet.
	self assert: sqlResult columnCount = 2.
	DBXTranscript show: sqlResult.

	self assert: iterator next isNil.

	conn close.
	conn disconnect.
!

testSQLWithoutIteratingAllResults
	| conn insert select iterator sqlResult aRow supportsMultipleStatements iterator2 sqlResult2 |
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (11, ''Something'', ''Nothing'', 2)'.
	select := 'SELECT * FROM student'.
	
	iterator := conn executeMultiStatement: (select, '; ', insert).

	sqlResult := iterator next.
	self assert: sqlResult class = DBXResultSet.
	self shouldnt: [ sqlResult nextRow ] raise: DBXError.
	[ aRow := sqlResult nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: aRow isNil.
	
	"I don't call iterator next for the following resultset"
	iterator2 := conn executeMultiStatement: ('SELECT * FROM student; INSERT INTO signature(code, name, observations, id_student) VALUES (19, ''Something'', ''Nothing'', 2)').
	sqlResult2 := iterator2 next.
	self assert: sqlResult2 class = DBXResultSet.
	self shouldnt: [ sqlResult2 nextRow ] raise: DBXError.
	[ aRow := sqlResult2 nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: aRow isNil.
	
	conn close.
	conn disconnect.
!

testSQLWithoutIteratingAllRowsInAResult
	| conn insert select iterator dmlResult supportsMultipleStatements |
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (11, ''Something'', ''Nothing'', 2)'.
	select := 'SELECT * FROM student'.
	
	iterator := conn executeMultiStatement: (select, '; ', insert).

	iterator next.
	"I don't iterate all rows"
	
	dmlResult := iterator next.
	self assert: dmlResult class = DBXResult.
	self assert: dmlResult rowsAffected = 1.

	conn close.
	conn disconnect.
! !

!DBXMultiStatementTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMultiStatementTest.st,v 1.2 2013-04-15 13:18:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMultiStatementTest.st,v 1.2 2013-04-15 13:18:48 cg Exp $'
! !


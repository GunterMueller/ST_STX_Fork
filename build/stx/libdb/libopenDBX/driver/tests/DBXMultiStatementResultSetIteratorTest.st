"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXMultiStatementResultSetIteratorTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXMultiStatementResultSetIteratorTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	aConnection execute:' INSERT INTO student (id, name_surname, age) VALUES (2, ''Hernan Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (3, ''German Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (4, ''Alejandro Squeak'', 30) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	
	"aConnection execute: 'INSERT INTO course(id_course, id_student, signature_code, starting_hour) VALUES (5, 5, 5, null);'."
!

testIsOpen
	| conn insert iterator supportsMultipleStatements select aResult insert2 select2 iterator2 |
	
	"When the connection is disconected, the resultset must be closed"
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	
	supportsMultipleStatements ifFalse: [
		conn disconnect.
		^ self].
	
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (11, ''Something'', ''Nothing'', 2)'.
	select := 'SELECT * FROM student'.
	iterator := conn executeMultiStatement: (insert, '; ', select).
	self assert: iterator isOpen.
	self assert: iterator next notNil.
	self assert: iterator isOpen.
	[ aResult := iterator next ] doWhileTrue: [ aResult notNil ].
	self assert: iterator isOpen.
	"Even after retrieving all results, the MultiStatementResultSet doesn't update its state to closed"
	conn disconnect.
	self deny: iterator isOpen.
	
	
	"When the connection is closed, the MultiStatementResultSet must be closed"
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	insert2 := 'INSERT INTO signature(code, name, observations, id_student) VALUES (12, ''Something'', ''Nothing'', 2)'.
	select2 := 'SELECT * FROM student'.
	iterator := conn executeMultiStatement: (insert2, '; ', select2).
	self assert: iterator isOpen.
	self assert: iterator next notNil.
	self assert: iterator isOpen.
	[ aResult := iterator next ] doWhileTrue: [ aResult notNil ].
	self assert: iterator isOpen.
	"Even after retrieving all results, the MultiStatementResultSet doesn't update its state to closed"
	conn close.
	self deny: iterator isOpen.
	conn disconnect.
	self deny: iterator isOpen.

	"When a new query is executed the previous query in the same conncion, must be closed."
		"When the connection is closed, the MultiStatementResultSet must be closed"
	conn := self doConnect.
	supportsMultipleStatements := conn enableMultipleStatements.
	conn open.
	iterator := conn executeMultiStatement: 'INSERT INTO signature(code, name, observations, id_student) VALUES (14, ''Something'', ''Nothing'', 2); SELECT * FROM student'.
	self assert: iterator isOpen.
	self assert: iterator next notNil.
	self assert: iterator isOpen.
	[ aResult := iterator next ] doWhileTrue: [ aResult notNil ].
	self assert: iterator isOpen.
	"Even after retrieving all results, the MultiStatementResultSet doesn't update its state to closed"
	iterator2 := conn executeMultiStatement: 'INSERT INTO signature(code, name, observations, id_student) VALUES (15, ''Something'', ''Nothing'', 2); SELECT * FROM student'.
	self deny: iterator isOpen.
	self assert: iterator2 isOpen.
	conn close.
	self deny: iterator2 isOpen.
	conn disconnect.
	self deny: iterator2 isOpen.
! !

!DBXMultiStatementResultSetIteratorTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMultiStatementResultSetIteratorTest.st,v 1.2 2013-04-15 13:18:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMultiStatementResultSetIteratorTest.st,v 1.2 2013-04-15 13:18:46 cg Exp $'
! !


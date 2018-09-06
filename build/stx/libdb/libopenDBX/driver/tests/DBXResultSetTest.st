"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXResultSetTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXResultSetTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	aConnection execute:' INSERT INTO student (id, name_surname, age) VALUES (2, ''Hernan Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (3, ''German Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (4, ''Alejandro Squeak'', 30) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	
	"aConnection execute: 'INSERT INTO course(id_course, id_student, signature_code, styarting_hour) VALUES (5, 5, 5, null);'."
!

testIsOpen
	| conn result select aRow result2 |
	
	"When the connection is disconected, the resultset must be closed"
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM student'.
	result := conn execute: select.
	self assert: result isOpen.
	self assert: result nextRow notNil.
	[ aRow := result nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: result isOpen.
	"Even after retrieving all rows, the resultset doesn't update its state to closed"
	conn disconnect.
	self deny: result isOpen.
	
	"When the connection is closed, the resultset must be closed"
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM student'.
	result := conn execute: select.
	self assert: result isOpen.
	self assert: result nextRow notNil.
	[ aRow := result nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: result isOpen.
	conn close.
	self deny: result isOpen.
	conn disconnect.
	self deny: result isOpen.
	
	"When a new query is executed the previous query in the same conncion, must be closed."
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM student'.
	result := conn execute: select.
	self assert: result isOpen.
	result2 := conn execute: 'SELECT * FROM signature'.
	self deny: result isOpen.
	self assert: result2 isOpen.
	conn disconnect.

! !

!DBXResultSetTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXResultSetTest.st,v 1.2 2013-04-15 13:18:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXResultSetTest.st,v 1.2 2013-04-15 13:18:40 cg Exp $'
! !


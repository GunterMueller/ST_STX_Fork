"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXConnectionCleanUpTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXConnectionCleanUpTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	aConnection execute:' INSERT INTO student (id, name_surname, age) VALUES (2, ''Hernan Squeak'', 23) '.
	
! !

!DBXConnectionCleanUpTest methodsFor:'tests'!

testNoTransactionNoCleanUp
	| conn select result |

	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	result := conn execute: select.
	self deny: conn transactionOpened.
	self deny: conn result isNil.
	conn close.
	self assert: conn result isNil.
	self assert: conn result isNil.
	conn disconnect.

	
!

testWithTransactionWithCleanUp
	| conn select result |
	
	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	conn startTransaction.
	result := conn execute: select.
	self assert: conn transactionOpened.
	self deny: conn result isNil.
	conn cleanUp.
	self deny: conn transactionOpened.
	self assert: conn result isNil.
	conn disconnect.
	
	
	conn := self doConnectAndOpen.
	conn startTransaction.
	conn execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (55, ''TADP'', ''Nothing'', 1) '.
	self assert: conn transactionOpened.
	self deny: conn result isNil.
	conn cleanUp.
	self deny: conn transactionOpened.
	self assert: conn result isNil.
	result := conn execute: select.
	self assert: result rows isEmpty.
	
!

testWithTransactionWithoutCleanUp
	| conn select result |
	
	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	conn startTransaction.
	result := conn execute: select.
	self assert: conn transactionOpened.
	conn commit.
	self deny: conn transactionOpened.
	self deny: conn result isNil.
	conn close.
	self assert: conn result isNil.
	conn disconnect.
	
	
	conn := self doConnectAndOpen.
	conn startTransaction.
	result := conn execute: select.
	self assert: conn transactionOpened.
	self deny: conn result isNil.
	conn close.
	self deny: conn transactionOpened.
	self assert: conn result isNil.
	conn disconnect.
	

	
	
! !

!DBXConnectionCleanUpTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionCleanUpTest.st,v 1.2 2013-04-15 13:18:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXConnectionCleanUpTest.st,v 1.2 2013-04-15 13:18:14 cg Exp $'
! !


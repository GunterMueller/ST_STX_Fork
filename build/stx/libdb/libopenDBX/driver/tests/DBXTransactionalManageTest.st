"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXQueryBaseTest subclass:#DBXTransactionalManageTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXTransactionalManageTest methodsFor:'tests'!

testTransactionCommit
	| conn result delete select |
	conn := self doConnectAndOpen.
	conn startTransaction.
	delete := 'delete from signature'.
	result := conn execute: delete.
	result releaseResult.
	conn commit.
	select := 'SELECT * FROM signature'.
	result := conn execute: select.
	self assert: result nextRow isNil.
	result releaseResult.
	conn disconnect
!

testTransactionRollback
	| conn result delete select |
	conn := self doConnectAndOpen.
	conn startTransaction.
	delete := 'delete from signature'.
	conn execute: delete.
	conn rollback.
	select := 'select * from signature'.
	result := conn execute: select.
	self assert: result nextRow notNil.
	result releaseResult.
	conn disconnect
! !

!DBXTransactionalManageTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTransactionalManageTest.st,v 1.2 2013-04-15 13:18:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTransactionalManageTest.st,v 1.2 2013-04-15 13:18:25 cg Exp $'
! !


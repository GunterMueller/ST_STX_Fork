"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXQueryBaseTest subclass:#DBXRowTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXRowTest methodsFor:'tests'!

testRawValueAt
	| conn result select aRow value |
	conn := self doConnectAndOpen.
	select := 'SELECT * FROM student where id = 1'.
	result := conn execute: select.
	aRow := result nextRow.
	self
		shouldnt: [value := aRow rawValueAt: 1]
		raise: DBXError.
	self assert: value class = ByteString.
	Transcript show: 'raw value: ' , value asString.
	self
		shouldnt: [value := aRow valueAt: 1]
		raise: DBXError.
	self assert: value class = SmallInteger.
	Transcript show: 'raw value: ' , value asString.
	result releaseResult.
	conn disconnect
!

testRawValueNamed
	| conn result select aRow |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM student where id = 1'.
	result := conn execute: select.	
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'id') = 1 asString).
	result releaseResult.
	conn disconnect.
!

testRawValueNamedNotFound
	| conn result select aRow |
	conn := self doConnectAndOpen.
	select:= 'SELECT name_surname FROM student where id = 1'.
	result := conn execute: select.	
	aRow := result nextRow.
	self should: [ (aRow rawValueNamed: 'id')] raise: DBXError.
	result releaseResult.
	conn disconnect.
!

testRawValues
	| conn result select aRow |
	conn := self doConnectAndOpen.
	select:= 'SELECT id, name_surname,age FROM student where id = 1'.
	result := conn execute: select.	
	aRow := result nextRow.
	self assert: aRow rawValues size = 3.
	result releaseResult.
	conn disconnect.
! !

!DBXRowTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXRowTest.st,v 1.2 2013-04-15 13:18:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXRowTest.st,v 1.2 2013-04-15 13:18:28 cg Exp $'
! !


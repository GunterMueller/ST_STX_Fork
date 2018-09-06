"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXQueryBaseTest subclass:#DBXQueryDMLTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXQueryDMLTest methodsFor:'deleteTests'!

testDelete
	| conn delete result |
	conn := self doConnectAndOpen.

	"SQLite implements the command 'DELETE FROM table' without a WHERE clause by dropping and recreating the 	table. (This is much faster than going through and deleting individual elements from the table.) Because of this 	optimization, the deletions in 'DELETE FROM table' are not row changes and will not be counted by the 	sqlite3_changes() or sqlite3_total_changes() functions, regardless of the number of elements that were originally 	in the table. To get an accurate count of the number of rows deleted, use 'DELETE FROM table WHERE 1' instead."


	delete := 'delete from signature WHERE 1=1'.
	result := conn execute: delete.
	self assert: result rowsAffected isZero not.
	
	conn disconnect.
!

testDeleteFollowedByAnotherDelete
	| conn aResult anotherResult aDelete anotherDelete |
	conn := self doConnectAndOpen.
	aDelete  := 'delete from signature where code = 59'.
	anotherDelete  := 'delete from signature where code = 60'.
	aResult := conn execute: aDelete.
	self shouldnt: [ anotherResult := conn execute: anotherDelete ] raise: DBXError.
	self assert: aResult rowsAffected isZero not.
	self assert: anotherResult rowsAffected isZero not.
	
	conn disconnect.
!

testDeleteIsClosedAfterExecute
	| conn delete |
	conn := self doConnectAndOpen.
	delete := 'delete from signature'.
	conn execute: delete.
	
	conn disconnect.
!

testDeleteWithBadData
	| conn delete |
	conn := self doConnectAndOpen.
	delete := 'delete from student where id = should be numeric'.
	self should: [ conn execute: delete  ] raise: DBXError.
	
	conn disconnect.
!

testDuplicateDelete
	| conn delete |
	conn := self doConnectAndOpen.
	delete := 'delete from signature'.
	conn execute: delete.
	self shouldnt: [ conn execute: delete ] raise: DBXError.
	
	conn disconnect.
! !

!DBXQueryDMLTest methodsFor:'insertTests'!

testDuplicateInsert
	| conn insert |
	
	"SQLite client library has a problem with duplicated inserts. So, we skip that tests for sqlite"
	(self platform class = DBXSqliteBackend) ifTrue: [^ nil]. 
	
	conn := self doConnectAndOpen.
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (55, ''TADP'', ''Nothing'', 1) '.
	conn execute: insert.
	self should: [ conn execute: insert ] raise: DBXError.
	
	conn disconnect.
!

testInsert
	| conn result insert |
	conn := self doConnectAndOpen.
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (55, ''TADP'', ''Nothing'', 1) '.
	result := conn execute: insert.
	self assert: result rowsAffected isZero not.
	
	conn disconnect.
!

testInsertFollowedByAnotherInsert
	| conn aResult anotherResult AnInsert anotherInsert |
	conn := self doConnectAndOpen.
	AnInsert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (55, ''TADP'', ''Nothing'', 1) '.
	anotherInsert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (56,''TADP2'',''Nothing'', 2)'.
	aResult := conn execute: AnInsert.
	self shouldnt: [ anotherResult := conn execute: anotherInsert ] raise: DBXError.
	self assert: aResult rowsAffected isZero not.
	self assert: anotherResult rowsAffected isZero not.
	
	conn disconnect.
!

testInsertIsClosedAfterExecute
	| conn insert |
	conn := self doConnectAndOpen.
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (55, ''TADP'', ''Nothing'', 1) '.
	conn execute: insert.
	
	conn disconnect.
!

testInsertWithBadData
	| conn insert |
	
	"SQLite does not enforce data type constraints. Any data can be inserted into any column. You can put arbitrary length strings into integer columns, floating point numbers in boolean columns, or dates in character columns. The datatype you assign to a column in the CREATE TABLE command does not restrict what data can be put into that column. Every column is able to hold an arbitrary length string. (There is one exception: Columns of type INTEGER PRIMARY KEY may only hold a 64-bit signed integer. An error will result if you try to put anything other than an integer into an INTEGER PRIMARY KEY column.)
    But SQLite does use the declared type of a column as a hint that you prefer values in that format. So, for example, if a column is of type INTEGER and you try to insert a string into that column, SQLite will attempt to convert the string into an integer. If it can, it inserts the integer instead. If not, it inserts the string. This feature is sometimes call type or column affinity. "
	(self platform class = DBXSqliteBackend ) ifTrue: [ ^ self ].
	
	
	conn := self doConnectAndOpen.
	insert := 'INSERT INTO signature(code, name, observations) VALUES ("should be numeric", 1, 1) '.
	self should: [ conn execute: insert  ] raise: DBXError.
	
	conn disconnect.
! !

!DBXQueryDMLTest methodsFor:'updateTests'!

testDuplicateUpdate
	| conn update |
	conn := self doConnectAndOpen.
	update := 'update student set age = ''25'' '.
	conn execute: update.
	self shouldnt: [ conn execute: update ] raise: DBXError.
	
	conn disconnect.
!

testMultipleUpdate
	| conn update |
	conn := self doConnectAndOpen.
	update := 'update student set age = ''25'' '.
	conn execute: update.
	conn execute: update.
	conn execute: update.
	conn execute: update.
	conn execute: update.
	conn execute: update.
	conn execute: update.
	
	conn disconnect.
!

testTimeout
"	| conn |
	conn := self doConnectAndOpen.
	
	MessageTally time: [
	10000 timesRepeat: [ 
		conn execute: 
			'INSERT INTO tiny_benchmark_insert
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')' ].].
	
	
	self break.
	Transcript show: 'tiempo final: ',
	(MessageTally time: [
	(conn execute: 'SELECT * FROM tiny_benchmark_insert')
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ]  ].
	]) asString.

	self break."
!

testUpdate
	| conn result update |
	conn := self doConnectAndOpen.
	update := 'update student set age = ''25'' '.
	result := conn execute: update.
	self assert: result rowsAffected isZero not.
	
	conn disconnect.
!

testUpdateFollowedByAnotherUpdate
	| conn aResult anotherResult anUpdate anotherUpdate |
	conn := self doConnectAndOpen.
	anUpdate := 'update student set age = ''25'' '.
	anotherUpdate := 'update student set age = ''23'' '.
	aResult := conn execute: anUpdate.
	self shouldnt: [ anotherResult := conn execute: anotherUpdate ] raise: DBXError.
	self assert: aResult rowsAffected isZero not.
	self assert: anotherResult rowsAffected isZero not.
	
	conn disconnect.
!

testUpdateIsClosedAfterExecute
	| conn update |
	conn := self doConnectAndOpen.
	update := 'update student set age = ''25'' '.
	conn execute: update.
	
	conn disconnect.
!

testUpdateWithBadData
	| conn update |	
	
	"SQLite does not enforce data type constraints. Any data can be inserted into any column. You can put arbitrary length strings into integer columns, floating point numbers in boolean columns, or dates in character columns. The datatype you assign to a column in the CREATE TABLE command does not restrict what data can be put into that column. Every column is able to hold an arbitrary length string. (There is one exception: Columns of type INTEGER PRIMARY KEY may only hold a 64-bit signed integer. An error will result if you try to put anything other than an integer into an INTEGER PRIMARY KEY column.)
    But SQLite does use the declared type of a column as a hint that you prefer values in that format. So, for example, if a column is of type INTEGER and you try to insert a string into that column, SQLite will attempt to convert the string into an integer. If it can, it inserts the integer instead. If not, it inserts the string. This feature is sometimes call type or column affinity. "
	(self platform class = DBXSqliteBackend ) ifTrue: [ ^ self ].
	

	conn := self doConnect.
	self flag: #todo.
	"Only for MySQL, I need to enable ansi and traditional mode in order to get an error in this query. We need the tests refactor for special backends"
	(self platform class = DBXMySQLBackend) ifTrue: [ conn enableSpecialModes: 'ANSI,TRADITIONAL'. ].
	
	
	
	
	conn open.
	update := 'update student set age = ''should be numeric'' '.
	self
		should: [conn execute: update]
		raise: DBXError.
		
	conn disconnect.
! !

!DBXQueryDMLTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryDMLTest.st,v 1.2 2013-04-15 13:18:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryDMLTest.st,v 1.2 2013-04-15 13:18:07 cg Exp $'
! !


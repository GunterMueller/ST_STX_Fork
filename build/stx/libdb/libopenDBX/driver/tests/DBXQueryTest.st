"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXQueryBaseTest subclass:#DBXQueryTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXQueryTest methodsFor:'tests'!

testCloseBeforeQuery
	| conn select |
	conn := self doConnectAndOpen.
	conn close.
	select := 'SELECT * FROM signature'.
	self
		should: [conn execute: select]
		raise: DBXError.
	conn disconnect
!

testCloseResultsByClosingConnection
	| conn result select |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature'.
	result := conn execute: select.
	conn disconnect.
	self deny: result isOpen.
!

testCorrectResult
	| conn select result aRow delete update insert drop |
	conn := self doConnectAndOpen.
	select := 'SELECT * FROM course'.
	result := conn execute: select.
	self
		should: [result class = DBXResultSet].
	aRow := result nextRow.
	self assert: aRow isNil.
	delete := 'delete from course'.
	result := conn execute: delete.
	self
		should: [result class = DBXResult].
	update := 'update signature set name = ''XXX'' '.
	result := conn execute: update.
	self
		should: [result class = DBXResult].
	insert := 'INSERT INTO signature(code, name, observations, id_student) VALUES (55, ''TADP'', ''Nothing'', 1) '.
	result := conn execute: insert.
	self
		should: [result class = DBXResult].
	drop := 'drop table course'.
	result := conn execute: drop.
	self
		should: [result class = DBXResult].
	conn disconnect
!

testDisconnectBeforeQuery
	| conn select |
	conn := self doConnectAndOpen.
	conn disconnect.
	select := 'SELECT * FROM signature'.
	self
		should: [conn execute: select]
		raise: DBXError.
!

testEmptyResultSet
	| conn result select aRow |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature where code = 99999'.
	result := conn execute: select.	
	aRow := result nextRow.	
	self assert: aRow isNil.
	result releaseResult.
	conn disconnect.
!

testEmptyResultSetRows
	| conn result select rows |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM course'.
	result := conn execute: select.	
	rows := result nextRow.	
	self assert: rows isNil.
	result releaseResult.
	conn disconnect.
!

testHasRowsEmptyResultSet
	| conn result select |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature where code = 99999'.
	result := conn execute: select.	
	result nextRow.	
	result releaseResult.
	conn disconnect.
!

testIterateResultSet
	| conn result select aRow |
	conn := self doConnectAndOpen.
	select := 'SELECT * FROM student'.
	result := conn execute: select.
	[ aRow := result nextRow ] doWhileTrue: [ aRow notNil ].
	self assert: aRow isNil.
	result releaseResult.
	conn disconnect
!

testMultipleSelect
	| conn result select |
	conn := self doConnectAndOpen.
	select := 'SELECT * FROM signature'.
	result := conn execute: select.
	result releaseResult.
	result := conn execute: select.
	result releaseResult.
	result := conn execute: select.
	DBXTranscript show: result.
	result releaseResult.
	result := conn execute: select.
	DBXTranscript show: result.
	result := conn execute: select.
	DBXTranscript show: result.
	result releaseResult.
	result := conn execute: select.
	result releaseResult.
	result := conn execute: select.
	result releaseResult.
	result releaseResult.
	result := conn execute: select.
	result := conn execute: select.
	result := conn execute: select.
	DBXTranscript show: result.
	result := conn execute: select.
	DBXTranscript show: result.
	result := conn execute: select.
	DBXTranscript show: result.
	result := conn execute: select.
	result := conn execute: select.
	conn close.
	conn disconnect
!

testNextRowAfterCloseResultSet
	| conn select result |

	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	result := conn execute: select.
	conn close.
	self should: [ result nextRow ] raise: DBXError.
	conn disconnect.
	
	
	
	
!

testNextRowAfterDisconnect
	| conn select result |
	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	result := conn execute: select.
	conn disconnect.
	"I have closed de connection, so this should rise an error"
	self
		should: [result nextRow]
		raise: DBXError
!

testNextRowAfterFinalizeResultSet
	| conn select result |

	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	result := conn execute: select.
	result releaseResult.
	
	"I have closed de resultSet, so this should rise an error"	
	self should: [ result nextRow ] raise: DBXError.
	
	conn disconnect.
!

testOrderBy
	| conn result select aRow|
	
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM student'.
	result := conn execute: select.
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Mariano Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Hernan Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'German Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Alejandro Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Esteban Squeak' asString).


	select:= 'SELECT * FROM student order by name_surname'.
	result := conn execute: select.	
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Alejandro Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Esteban Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'German Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Hernan Squeak' asString).
	aRow := result nextRow.
	self assert: ((aRow rawValueNamed: 'name_surname') = 'Mariano Squeak' asString).
	
	self assert: result nextRow isNil.

	conn disconnect.
!

testPrintARow
	| conn aResult select aRow stream |
	conn := self doConnectAndOpen.

	select := 'SELECT * FROM student'.
	aResult := conn execute: select.
	aRow := aResult nextRow.	
	stream := String new writeStream.
	aRow values
	do: [:each | stream nextPutAll: each asString]
	separatedBy: [stream nextPutAll: ' | '].
	Transcript show: stream contents;
	cr.	
		
	conn disconnect.
!

testQueryAfterQueryWithPartialResutlIteration
	| conn aResult select aRow |
	conn := self doConnectAndOpen.

	select := 'SELECT * FROM student'.
	aResult := conn execute: select.
	aRow := aResult nextRow.	
	aRow := aResult nextRow.
	
	select := 'SELECT * FROM signature'.
	aResult := conn execute: select.
	aRow := aResult nextRow.
	aRow := aResult nextRow.

	conn disconnect.
!

testQueryAfterQueryWithPartialResutlIterationWithFinalize
	| conn aResult select|
	conn := self doConnectAndOpen.

	select := 'SELECT * FROM student'.
	aResult := conn execute: select.
	aResult nextRow.	
	aResult nextRow.

	aResult releaseResult.
	select := 'SELECT * FROM signature'.
	aResult := conn execute: select.
	aResult nextRow.	
	aResult nextRow.
	
	conn disconnect.
!

testQueryAfterQueryWithTotalResutlIteration
	| conn aResult select |
	conn := self doConnectAndOpen.
	select := 'SELECT * FROM student'.
	aResult := conn execute: select.
	aResult
		rowsDo: [:row | Transcript
				show: (row valueNamed: 'age') asString].
	select := 'SELECT * FROM signature'.
	aResult := conn execute: select.
	aResult
		rowsDo: [:row | Transcript
				show: (row valueNamed: 'code') asString].
	conn disconnect
!

testQueryFollowedByAnotherQuery
	| conn aRresult select |
	conn := self doConnectAndOpen.
	select := 'SELECT * FROM course'.
	aRresult := conn execute: select.
	self
		shouldnt: [conn execute: select]
		raise: DBXError.
	conn disconnect.
!

testReleaseAllQueryResultsAfterDisconnectResultSet
	| conn select result |

	select := 'SELECT * FROM signature'.
	conn := self doConnectAndOpen.
	result := conn execute: select.
	conn disconnect.
	self shouldnt: [ result releaseResult ] raise: DBXError.
	
	
!

testReleaseAllQueryResultsTwiceResultSet
	| conn result select |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature'.
	result := conn execute: select.
	result releaseResult .
	self shouldnt: [ result releaseResult ] raise: DBXError.	
	conn disconnect.
!

testResultSetConsumed
	| conn result |
	conn := self doConnectAndOpen.
	result := conn execute: 'SELECT * FROM student'.
	result rows.
	self assert: result rows isEmpty.
!

testResultSetNextRow
	| conn result select |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature'.
	result := conn execute: select.
	self shouldnt: [ result nextRow ] raise: DBXError.
	result releaseResult.
	conn disconnect.
!

testResultSetWithData
	| conn result select aRow |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM student where id = 1'.
	result:= conn execute: select.
	aRow := result nextRow.
	self assert: aRow notNil.
	[ aRow notNil ] whileTrue: [ aRow := result nextRow ].
	result releaseResult.
	conn disconnect.
!

testSelect
	| conn result select |
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature'.
	result := conn execute: select.	
	self shouldnt: [ result nextRow ] raise: DBXError.
	result releaseResult.
	conn disconnect.
	
	conn := self doConnectAndOpen.
	select:= 'SELECT * FROM signature'.
	result := conn execute: select.	
	DBXTranscript show: result.
	self assert: result nextRow isNil.
	result releaseResult.
	conn disconnect.
!

testWrongSQL
	| conn select |
	conn := self doConnectAndOpen.
	select:= 'THIS IS NOT VALID SQL'.
	self should: [ conn execute: select. ] raise: DBXError.
	conn disconnect.
! !

!DBXQueryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryTest.st,v 1.2 2013-04-15 13:18:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryTest.st,v 1.2 2013-04-15 13:18:43 cg Exp $'
! !


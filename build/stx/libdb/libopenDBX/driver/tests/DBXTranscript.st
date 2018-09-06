"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

Object subclass:#DBXTranscript
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXTranscript class methodsFor:'stream extensions'!

show: result
	result class = DBXResult
		ifTrue: [self showResult: result].
	result class = DBXResultSet
		ifTrue: [self showResultSet: result].
	result class = DBXMultiStatementResultSetIterator
		ifTrue: [self showMultiStatementResultSetIterator: result ].
!

showMultiStatementResultSetIterator: anIterator
	anIterator allResultsDo: [ :each | self show: each ].
	
!

showResult: result 
	Transcript show: 'They were affected ' , result rowsAffected asString, ' rows';
		 cr
!

showResultSet: resultSet 
	| stream |
	stream := String new writeStream.
	resultSet columnDescriptions
		do: [:each | stream nextPutAll: each name]
		separatedBy: [stream nextPutAll: ' | '].
	Transcript show: stream contents;
		 cr.
	resultSet
		rowsDo: [:row | 
			stream := String new writeStream.
			row values
				do: [:each | stream nextPutAll: each asDbxString]
				separatedBy: [stream nextPutAll: ' | '].
			Transcript show: stream contents;
				 cr]
! !

!DBXTranscript class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTranscript.st,v 1.2 2013-04-15 13:18:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXTranscript.st,v 1.2 2013-04-15 13:18:27 cg Exp $'
! !


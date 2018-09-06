"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXOptionsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXOptionsTest methodsFor:'as yet unclassified'!

executeEncryptionWithOption: anEncrytionValue 
	| conn result |
	conn := self doConnect.
	result := conn enableEncryption: anEncrytionValue.
	conn open.
	result
		ifTrue: [ Transcript show: 'Encryption supported' ; cr.
				self shouldnt: [ conn execute: 'select code from signature' ] raise: Error .
				].
	result
		ifFalse: [ Transcript show: 'Encryption not supported' ; cr.
				self shouldnt: [ conn execute: 'select code from signature' ] raise: Error .
				].	
	conn close.
	conn disconnect.
	conn := nil
!

insertRows:  aNumberOfRows
	| conn |

	Transcript show: 'Inserting ', aNumberOfRows asString, ' rows'; cr.
	conn := self doConnectAndOpen.
	conn startTransaction.
	1
		to: aNumberOfRows
		do: [:i | conn
				execute: ('INSERT INTO student (id, name_surname, age) VALUES ( {1} ,''Esteban
	Squeak'', 42)' format: (OrderedCollection new add: i asInteger asDbxString;
							 yourself))].
	conn commit.
	conn disconnect.
	Transcript show: aNumberOfRows asString, ' rows were inserted'; cr.	
!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
!

selectRowsWithPageSize: aPageSize onConnection: aConnection 
	| resultQuery timeBefore timeAfter querySettings |
	
	querySettings := DBXQuerySettings pageSize: aPageSize timeout: DBXQuerySettings defaultTimeout.
	
	timeBefore := Time current asSeconds.
	Transcript show: 'PagedResults supported. Test with page size ' , aPageSize asString;
		 cr.
	
	resultQuery := aConnection execute: 'select * from student' querySettings: querySettings.
		
		
	"self
		shouldnt: [resultQuery := aConnection execute: 'select * from student' querySettings: querySettings]
		raise: Error."
		
		
	resultQuery
		rowsDo: [:row | row].
	timeAfter := Time current asSeconds.
	Transcript show: 'Time consumed: ' , (timeAfter - timeBefore) asString, ' seconds';
		 cr
!

testCompression
	| conn result |
	conn := self doConnect.
	result := conn enableCompression.
	conn open.
	result ifTrue: 
		[ Transcript
			show: 'Compression supported';
			cr.
		self 
			shouldnt: [ conn execute: 'select * from student' ]
			raise: Error ].
	result ifFalse: 
		[ Transcript
			show: 'Compression doesnt supported';
			cr.
		self 
			shouldnt: [ conn execute: 'select * from student' ]
			raise: Error ].
	conn close.
	conn disconnect.
	conn := nil
!

testEncryption
	self executeEncryptionWithOption: DBXEncryptionValues never.
	self executeEncryptionWithOption: DBXEncryptionValues try.
	self executeEncryptionWithOption: DBXEncryptionValues always.
	
!

testGetOption
	| conn isSupported |
	conn := self doConnect.
	isSupported := conn isOptionSupportedByPlattform: DBXSpecialOptions multipleStatements.
	conn open.
	conn close.
	conn disconnect.
	conn := nil
!

testMultipleStatments
	| conn result iterator iterator2 |
	"In ODBC case, as you cannot know trought ODBC if the current backends supports or not certain option, this 	features is disable. But, if you are using a backend that support its, the multistatement will work ok. 	Suppose 	you are using ODBC with a PostgeSQL server. ODBC doesn't	support this feature, but PostgreSQL will. 	So, If you 	actually use multistatement, it will work. Because of this, this test is disable for ODBC"
	(self platform class = DBXOdbcBackend) ifTrue: [ ^ self ].
	conn := self doConnect.
	result := conn enableMultipleStatements.
	conn open.
	
	conn execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	conn execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (59, ''TADP'', ''Tecnicas Av'', 5) '.
	
	result ifTrue: 
		[ Transcript show: 'MultipleStatments supported'; cr.
		self 
			shouldnt: 
				[ iterator := conn executeMultiStatement: 'select id from student; select code, name from signature'.
				DBXTranscript show: iterator. ]
			raise: DBXError.
		 ].
	
	result ifFalse: 
		[ Transcript show: 'MultipleStatments doesnt supported'; cr.	
		self 
			should: 
				[ iterator2 := conn executeMultiStatement: 'select id from student; select code, name from signature'.
				DBXTranscript show: iterator2. ]
			raise: DBXError.	
				
		].
	conn close.
	conn disconnect.
	conn := nil
!

testMultipleStatmentsDMLAndSQL
	| conn result iterator iterator2 |
	"In ODBC case, as you cannot know trought ODBC if the current backends supports or not certain option, this 	features is disable. But, if you are using a backend that support its, the multistatement will work ok. 	Suppose 	you are using ODBC with a PostgeSQL server. ODBC doesn't	support this feature, but PostgreSQL will. 	So, If you 	actually use multistatement, it will work. Because of this, this test is disable for ODBC"
	(self platform class = DBXOdbcBackend) ifTrue: [ ^ self ].
	conn := self doConnect.
	result := conn enableMultipleStatements.
	conn open.
	
	conn execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	conn execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (59, ''TADP'', ''Tecnicas Av'', 5) '.
	
	result ifTrue: 
		[ Transcript
			show: 'MultipleStatments supported';
			cr.
		self 
			shouldnt: 
				[ iterator := conn executeMultiStatement: 'select id from student; update student set age = ''23'' '.
				DBXTranscript show: iterator.
				 ]
			raise: DBXError.

	].
	
	
	result ifFalse: 
		[ Transcript
			show: 'MultipleStatments doesnt supported';
			cr.
			
			self 
			should: 
				[ iterator2 := conn executeMultiStatement: 'select id from student; update student set age = ''23'' '.
				DBXTranscript show: iterator2. ]
			raise: DBXError.

		].
	conn close.
	conn disconnect.
	conn := nil
!

testPagedResults
	| conn result rows |
	rows := 5000.
	self insertRows: rows.
	conn := self doConnect.
	result := conn enablePagedResults.
	conn open.
	result
		ifTrue: [self selectRowsWithPageSize: 0 onConnection: conn.
			self selectRowsWithPageSize: 1 onConnection: conn.
			self selectRowsWithPageSize: rows onConnection: conn.
			self selectRowsWithPageSize: rows / 10 onConnection: conn.
			self selectRowsWithPageSize: rows / 100 onConnection: conn].
	conn close.
	conn disconnect.
	conn := nil
!

testScpeialModes
	| conn result update |
	self platform class = DBXMySQLBackend ifFalse: [ ^ nil ].
	conn := self doConnect.
	result := conn enableSpecialModes: 'ANSI,TRADITIONAL'.
	conn open.
	conn execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	result ifTrue: 
		[ Transcript
			show: 'ScpecialMySQLModes supported';
			cr.
		update := 'update student set age = ''should be numeric'' '.
		self 
			should: [ conn execute: update ]
			raise: DBXError ].
	result ifFalse: 
		[ Transcript
			show: 'ScpecialMySQLModes supported';
			cr.
		update := 'update student set age = ''should be numeric'' '.
		self 
			shouldnt: [ conn execute: update ]
			raise: DBXError ].
	conn close.
	conn disconnect.
	conn := self doConnectAndOpen.
	conn execute: 'INSERT INTO student (id, name_surname, age) VALUES (2, ''Mariano Squeak'', 23) '.
	update := 'update student set age = ''should be numeric'' '.
		self 
			shouldnt: [ conn execute: update ]
			raise: DBXError.
	conn disconnect.
	conn := nil. 
! !

!DBXOptionsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOptionsTest.st,v 1.2 2013-04-15 13:18:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOptionsTest.st,v 1.2 2013-04-15 13:18:37 cg Exp $'
! !


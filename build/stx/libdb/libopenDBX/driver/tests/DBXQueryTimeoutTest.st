"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXQueryTimeoutTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXQueryTimeoutTest methodsFor:'as yet unclassified'!

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

test1000MicrosecondsTimeout
	| conn aQuerySettings rows aTimeSpec |
	
	rows := 5000.
	self insertRows: rows.
	
	conn := self doConnectAndOpen.
	aTimeSpec := DBXQueryTimeout seconds: 0 microseconds: 150.
	
	aQuerySettings := DBXQuerySettings timeout: aTimeSpec.
	conn execute: 'select * from student' querySettings: aQuerySettings.
	conn disconnect.
	
	
!

test3SecondsTimeout
	| conn aQuerySettings rows aTimeSpec |
	
	rows := 5000.
	self insertRows: rows.
	
	conn := self doConnectAndOpen.
	aTimeSpec := DBXQueryTimeout seconds: 3 microseconds: 0.
	
	aQuerySettings := DBXQuerySettings timeout: aTimeSpec.
	conn execute: 'select * from student' querySettings: aQuerySettings.
	conn disconnect.
	
	
!

testDefaultTimeout
	| conn aQuerySettings rows |
	
	rows := 5000.
	self insertRows: rows.
	
	conn := self doConnectAndOpen.
	aQuerySettings := DBXQuerySettings default.
	conn execute: 'select * from student' querySettings: aQuerySettings.
	conn disconnect.
	
	
	
	
!

testNoTimeout
	| conn aQuerySettings rows |
	
	rows := 5000.
	self insertRows: rows.
	
	conn := self doConnectAndOpen.
	aQuerySettings := DBXQuerySettings timeout: nil.
	conn execute: 'select * from student' querySettings: aQuerySettings.
	conn disconnect.
	
	
	
	
	
! !

!DBXQueryTimeoutTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryTimeoutTest.st,v 1.2 2013-04-15 13:18:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryTimeoutTest.st,v 1.2 2013-04-15 13:18:49 cg Exp $'
! !


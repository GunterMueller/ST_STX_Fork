"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXSecuenceTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXSecuenceTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
!

testPostgreSQLSecuence
	| conn result row secuence1 secuence2 |

	(self platform class = DBXPostgresBackend) ifFalse: [^ self].
		
	conn := self doConnectAndOpen.
	result := conn execute: 'SELECT nextval(''sequence_1'')'.
	row := result nextRow.
	self assert: row notNil.
	secuence1 := row valueAt: 1.
	result := conn execute: 'SELECT nextval(''sequence_1'')'.
	row := result nextRow.
	self assert: row notNil.
	secuence2 := row valueAt: 1.
	self assert: ((secuence1 + 1) = secuence2 ).
	
	conn disconnect.
! !

!DBXSecuenceTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXSecuenceTest.st,v 1.2 2013-04-15 13:18:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXSecuenceTest.st,v 1.2 2013-04-15 13:18:32 cg Exp $'
! !


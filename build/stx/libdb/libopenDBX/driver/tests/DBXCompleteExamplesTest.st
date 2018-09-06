"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXCompleteExamplesTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXCompleteExamplesTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	aConnection execute:'INSERT INTO student (id, name_surname, age) VALUES (2, ''Hernan Squeak'', 23) '.
!

testACompleteExample
	| conn connectionSettings result result2 |
	connectionSettings := self facility connectionSettings deepCopy.
	conn := DBXConnection platform: self platform deepCopy settings: connectionSettings.
	conn connect.
	conn open.
	self addConnectionToRelease: conn.
	result := conn execute: 'select * from signature'.
	DBXTranscript show: result.
	conn execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (59, ''TADP'', ''Tecnicas Av'', 1) '.
	conn execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (60, ''APIT'', ''ARQUITECTURA DE PROYECTOS DE IT'', 2) '.
	result := conn execute: 'select * from signature'.
	DBXTranscript show: result.
	result := conn execute: 'delete from signature where name = ''TADP'''.
	DBXTranscript show: result.
	result2 := conn execute: 'select * from signature'.
	DBXTranscript show: result2.
	result := conn execute: 'update signature set observations = ''something'' where code = 60'.
	DBXTranscript show: result.
	result2 := conn execute: 'select * from signature'.
	DBXTranscript show: result2.
	conn close.
	conn disconnect
! !

!DBXCompleteExamplesTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXCompleteExamplesTest.st,v 1.2 2013-04-15 13:18:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXCompleteExamplesTest.st,v 1.2 2013-04-15 13:18:26 cg Exp $'
! !


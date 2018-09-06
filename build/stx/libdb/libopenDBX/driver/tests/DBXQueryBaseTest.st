"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXQueryBaseTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXQueryBaseTest methodsFor:'running'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on each test. Each test may need different data. Because of this, it should be implemented by the subclass. "
	
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (1, ''Mariano Squeak'', 23) '.
	aConnection execute:' INSERT INTO student (id, name_surname, age) VALUES (2, ''Hernan Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (3, ''German Squeak'', 23) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (4, ''Alejandro Squeak'', 30) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	
	aConnection execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (59, ''TADP'', ''Tecnicas Av'', 1) '.
	aConnection execute: 'INSERT INTO signature(code, name, observations, id_student) VALUES (60, ''APIT'', ''ARQUITECTURA DE PROYECTOS DE IT'', 2) '.
	
	"aConnection execute: 'INSERT INTO course(id_course, id_student, signature_code, styarting_hour) VALUES (5, 5, 5, null);'."
! !

!DBXQueryBaseTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryBaseTest.st,v 1.2 2013-04-15 13:18:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXQueryBaseTest.st,v 1.2 2013-04-15 13:18:30 cg Exp $'
! !


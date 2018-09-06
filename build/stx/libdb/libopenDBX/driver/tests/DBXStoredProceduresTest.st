"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBaseTest subclass:#DBXStoredProceduresTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXStoredProceduresTest methodsFor:'as yet unclassified'!

runDMLSetUpScript: aConnection 
	"The DMLScript depends on the relational database engine. Because of this, it should be implemented by the subclass. Thi subclass is associated with a particular RDBMS"
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (4, ''Alejandro Squeak'', 30) '.
	aConnection execute: 'INSERT INTO student (id, name_surname, age) VALUES (5, ''Esteban Squeak'', 42) '.
	
!

testMySQLFunctions
	| conn result resultSet |

	(self platform class = DBXMySQLBackend ) ifFalse: [ ^self ].
	
	conn := self doConnect.
	result := conn enableMultipleStatements.
	conn open.
	result ifFalse: 
		[ conn disconnect.
		^ self ].
	
	conn execute: 'DROP PROCEDURE IF EXISTS `sodbxtest`.`allStudents` '.
	conn execute: 'CREATE DEFINER=`sodbxtest`@`%` PROCEDURE  `sodbxtest`.`allStudents`()
	BEGIN
   SELECT *
   FROM student;
	END'.

	resultSet := conn executeMultiStatement: 'call `sodbxtest`.`allStudents`()'.
	DBXTranscript show: resultSet.
	
	conn disconnect.
!

testOracleFunctions
       | conn result resultSet cmd param |

       (self platform class  = DBXOracleBackend ) ifFalse: [ ^self ].

       conn := self doConnect.
       result := conn enableMultipleStatements.
       conn open.

       result ifFalse: [
               conn disconnect.
               ^ self].

       "
       drop table testab;
               create table testab(name varchar2(20));

               create or replace procedure testproc(par in varchar2)
               as
                    sql_string varchar2(500);
                    mycursor integer;
                    retval integer;
               begin
                    sql_string := 'insert into testab(name)
values('''||par||''')';
                    mycursor := dbms_sql.open_cursor;

dbms_sql.parse(mycursor,sql_string,dbms_sql.native);
                    retval := dbms_sql.execute(mycursor);
                    dbms_sql.close_cursor(mycursor);
               end testproc;
       "

               param := 'testinsert'.
       cmd := 'begin testproc(''',param,''') end;'.
       resultSet := conn executeMultiStatement:(cmd).
       conn commit.
       DBXTranscript show: resultSet.

       conn disconnect.
!

testPostgreSQLFunctions
	| conn result resultSet |
	
	(self platform class = DBXPostgresBackend ) ifFalse: [ ^self ].
	
	conn := self doConnect.
	result := conn enableMultipleStatements.
	conn open.
	
	result ifFalse: [
		conn disconnect.
		^ self].

	conn execute: 'DROP FUNCTION IF EXISTS one (OUT sum int) '.
	conn execute: 'CREATE FUNCTION one (OUT sum int)
	AS ''SELECT 1''
	LANGUAGE SQL;'.
	
	resultSet := conn executeMultiStatement: 'SELECT * FROM one()'.
	DBXTranscript show: resultSet.
	
	conn disconnect.

	
! !

!DBXStoredProceduresTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXStoredProceduresTest.st,v 1.2 2013-04-15 13:18:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXStoredProceduresTest.st,v 1.2 2013-04-15 13:18:22 cg Exp $'
! !


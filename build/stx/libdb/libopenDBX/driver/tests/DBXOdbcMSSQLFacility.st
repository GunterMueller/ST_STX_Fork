"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBackendFacility subclass:#DBXOdbcMSSQLFacility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXOdbcMSSQLFacility class methodsFor:'as yet unclassified'!

new
	self error: 'Use facilityForTest or facilityForBenchmark'
! !

!DBXOdbcMSSQLFacility methodsFor:'benchmarks'!

bigBenchmarkScriptInsert
	
!

bigBenchmarkScriptSelect
	
!

tinyBenchmarkScript
!

tinyBenchmarkScript: aNumber 
! !

!DBXOdbcMSSQLFacility methodsFor:'connection'!

createConnection
	self connectionSettings: (DBXConnectionSettings 
		host: 'MSSQL'
		port: '3004'
		database: 'sodbxtest'
		userName: 'crapodino'
		userPassword: 'florynano').	
	self platform: DBXOdbcBackend new.
! !

!DBXOdbcMSSQLFacility methodsFor:'tests'!

addTestScripts
	| scriptDDL scriptDrops |
	scriptDDL := OrderedCollection new.
	scriptDrops := OrderedCollection new.
	
	scriptDDL add: 'CREATE TABLE student(
	   id INTEGER,
	   name_Surname VARCHAR(30) NULL,	   
	   regular BIT NULL,
	   age SMALLINT NULL,	   
	   average_grade DECIMAL(9,3) NULL,
	   sex CHARACTER(3) NULL,
	   description VARCHAR(200) NULL,
	   starting_hour DATETIME NULL,
	   sign_up_date DATETIME NULL,
	   born_date DATETIME NULL,
	   nullable_field VARCHAR(64) NULL,
	  CONSTRAINT pk_students_id PRIMARY KEY (id)
	) ;
'.
	scriptDDL add: 'CREATE TABLE signature(
	code INTEGER, 
	id_student INTEGER,
	name CHAR(35) NULL,
	observations VARCHAR(255) NULL,
	course_grade INTEGER NULL,
	final_grade INTEGER NULL,
	CONSTRAINT pk_signatures_code PRIMARY KEY (code)
)  '.
	scriptDDL add: 'CREATE TABLE course(
	id_course INTEGER,
	id_student INTEGER,
	code_signature INTEGER,
	starting_date DATETIME NULL,
	CONSTRAINT pk_courses_id_course PRIMARY KEY (id_student, code_signature)
) '.
	"scriptDDL add: 'ALTER TABLE curso
	ADD CONSTRAINT co_ao_fk FOREIGN KEY (id_alumno) REFERENCES
	alumno(id)'. 
	
	scriptDDL add: 'ALTER TABLE curso
	ADD CONSTRAINT co_ma_fk FOREIGN KEY (codigo_materia) REFERENCES
	materia(codigo)'. "
	"scriptDDL add: 'ALTER TABLE materia
	ADD CONSTRAINT ma_ao_fk FOREIGN KEY (id_alumno) REFERENCES
	alumno(id)'. "
	self scriptsDDL: scriptDDL.
	scriptDrops add: 'DROP TABLE course'.
	scriptDrops add: 'DROP TABLE signature'.
	scriptDrops add: 'DROP TABLE student'.
	self scriptsDrops: scriptDrops
! !

!DBXOdbcMSSQLFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOdbcMSSQLFacility.st,v 1.2 2013-04-15 13:18:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOdbcMSSQLFacility.st,v 1.2 2013-04-15 13:18:16 cg Exp $'
! !


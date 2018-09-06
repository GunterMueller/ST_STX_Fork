"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBackendFacility subclass:#DBXOdbcPostgreFacility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXOdbcPostgreFacility class methodsFor:'as yet unclassified'!

new
	self error: 'Use facilityForTest or facilityForBenchmark'
! !

!DBXOdbcPostgreFacility methodsFor:'benchmarks'!

bigBenchmarkScriptInsert
	
!

bigBenchmarkScriptSelect
	
!

tinyBenchmarkScript
!

tinyBenchmarkScript: aNumber 
! !

!DBXOdbcPostgreFacility methodsFor:'connection'!

createConnection
	self connectionSettings:( DBXConnectionSettings 
		host: 'sodbxtest'
		port: '5432'
		database: 'sodbxtest'
		userName: 'sodbxtest'
		userPassword: 'sodbxtest').
	self platform: DBXOdbcBackend new.
! !

!DBXOdbcPostgreFacility methodsFor:'tests'!

addTestScripts
	| scriptDDL scriptDrops |
	scriptDDL := OrderedCollection new.
	scriptDrops := OrderedCollection new.
	scriptDDL add: 'CREATE TABLE student(
	   id SERIAL,
	   name_surname VARCHAR,	
	   username VARCHAR(10),
        pass VARCHAR(200),
	   mail VARCHAR(50),
        regular BOOLEAN,
	   age SMALLINT,	   
	   average_grade DECIMAL(9,3),
	   sex CHARACTER(3),
	   description VARCHAR,
	   starting_hour TIME,
	   sign_up_date TIMESTAMP,
	   born_date DATE,
	   nullable_field VARCHAR(64) NULL,
	  CONSTRAINT pk_students_id PRIMARY KEY (id)
	)'.
	scriptDDL add: 'CREATE TABLE signature(
	code INTEGER,
	id_student INTEGER, 
	name CHAR(100),
	observations VARCHAR(255),
	course_grade INTEGER,
	final_grade INTEGER,
	CONSTRAINT pk_signatures_code PRIMARY KEY (id_student, code)
)'.
	scriptDDL add: 'CREATE TABLE course(
	id_course INTEGER,
	id_student INTEGER,
	code_signature INTEGER,
	starting_date DATE,
	CONSTRAINT pk_courses_id_course PRIMARY KEY (id_student, code_signature)
)'.
	"scriptDDL add: 'ALTER TABLE curso
	ADD CONSTRAINT co_ao_fk FOREIGN KEY (id_alumno) REFERENCES
	alumno(id)'. scriptDDL add: 'ALTER TABLE curso
	ADD CONSTRAINT co_ma_fk FOREIGN KEY (codigo_materia) REFERENCES
	materia(codigo)'. "
	scriptDDL add: 'ALTER TABLE signature
	ADD CONSTRAINT se_st_fk FOREIGN KEY (id_student) REFERENCES student(id)'.
	self scriptsDDL: scriptDDL.
	scriptDrops add: 'DROP TABLE course'.
	scriptDrops add: 'DROP TABLE signature'.
	scriptDrops add: 'DROP TABLE student'.
	self scriptsDrops: scriptDrops
! !

!DBXOdbcPostgreFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOdbcPostgreFacility.st,v 1.2 2013-04-15 13:18:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOdbcPostgreFacility.st,v 1.2 2013-04-15 13:18:34 cg Exp $'
! !


"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBackendFacility subclass:#DBXFirebirdFacility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXFirebirdFacility class methodsFor:'as yet unclassified'!

new
	self error: 'Use facilityForTest or facilityForBenchmark'
! !

!DBXFirebirdFacility methodsFor:'benchmarks'!

bigBenchmarkScriptInsert
	| scriptDDL |
	scriptDDL := OrderedCollection new.
	scriptDDL add: '
			CREATE TABLE big_benchmark_insert (
			num1 	REAL,
			num2 	FLOAT,
			num3 	DECIMAL(8,2),
			num4 	SMALLINT,
			str1 	CHAR(10),
			str2 	VARCHAR(255),
			date1 	DATE,
			date2 	TIMESTAMP)'.
	^ scriptDDL
!

bigBenchmarkScriptSelect
	| scriptDDL |
	scriptDDL := OrderedCollection new.
	scriptDDL add: '
			CREATE TABLE big_benchmark_select (
			num1 	REAL,
			num2 	FLOAT,
			num3 	DECIMAL(8,2),
			num4 	SMALLINT,
			str1 	CHAR(10),
			str2 	VARCHAR(255),
			date1 	DATE,
			date2 	TIMESTAMP)'.
	^ scriptDDL
!

tinyBenchmarkScript
	| scriptDDL |
	scriptDDL := OrderedCollection new.
	scriptDDL add: '
				CREATE TABLE tiny_benchmark_insert (
			num1 	REAL,
			num2 	FLOAT,
			num3 	DECIMAL(8,2),
			num4 	SMALLINT,
			str1 	CHAR(10),
			str2 	VARCHAR(255),
			date1 	DATE,
			date2 	TIMESTAMP)'.
	^ scriptDDL
!

tinyBenchmarkScript: aNumber 
	| script |
	script := OrderedCollection new.
	script add: '
		CREATE TABLE tiny_benchmark_' , aNumber asString , ' (
			id 		INTEGER,
			num1 	REAL,
			num2 	FLOAT,
			num3 	DECIMAL(8,2),
			num4 	SMALLINT,
			str1 	CHAR(10),
			str2 	VARCHAR(255),
			date1 	DATE,
			date2 	TIMESTAMP,
			PRIMARY KEY (id))'.
	1
		to: aNumber
		do: [:i | script
				add: ('INSERT INTO tiny_benchmark_' , aNumber asString , ' 
					(id, num1, num2, num3, num4, str1, str2, date1, date2)
				VALUES 
					({1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9})' format: (OrderedCollection new add: i asDbxString;
							 add: i asFloat asDbxString;
							 add: i asFloat asDbxString;
							 add: i asFloat asDbxString;
							 add: i asDbxString;
							 add: i asString asDbxString;
							 add: i asString asDbxString;
							 add: Date current asDbxString;
							 add: DateAndTime current asDbxString;
							 yourself))].
	^ script
! !

!DBXFirebirdFacility methodsFor:'connection'!

createConnection
	self	connectionSettings: (DBXConnectionSettings
				host: ''
				port: ''
				database: 'c:/mariano/firebird/sodbxtest.fdb'
				userName: 'sodbxtest'
				userPassword: 'sodbxtest').
	self platform: DBXFirebirdBackend new
! !

!DBXFirebirdFacility methodsFor:'tests'!

addTestScripts
| scriptDDL scriptDrops |
scriptDDL := OrderedCollection new.
	scriptDrops := OrderedCollection new.
	scriptDDL add: 'CREATE TABLE student(
   	   id INTEGER,
	   name_surname VARCHAR(50),	
	   mail VARCHAR(50),
      regular CHAR(1),
	   age SMALLINT,	   
	   average_grade DECIMAL(9,3),
	   sex CHARACTER(3),
	   description VARCHAR(200),
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
	signature_code INTEGER,
	starting_date DATE,
	CONSTRAINT pk_courses_id_course PRIMARY KEY (id_student, signature_code)
)'.

"	scriptDDL add: 'ALTER TABLE course
	ADD CONSTRAINT co_ao_fk FOREIGN KEY (id_student) REFERENCES student(id)'.
	scriptDDL add: 'ALTER TABLE course
	ADD CONSTRAINT co_ma_fk FOREIGN KEY (signature_code) REFERENCES signature(code)'."
	scriptDDL add: 'ALTER TABLE signature
	ADD CONSTRAINT se_st_fk FOREIGN KEY (id_student) REFERENCES student(id)'.
	
	self scriptsDDL: scriptDDL.
	scriptDrops add: 'DROP TABLE course'.
	scriptDrops add: 'DROP TABLE signature'.
	scriptDrops add: 'DROP TABLE student'.
	self scriptsDrops: scriptDrops.
! !

!DBXFirebirdFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXFirebirdFacility.st,v 1.2 2013-04-15 13:18:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXFirebirdFacility.st,v 1.2 2013-04-15 13:18:24 cg Exp $'
! !


"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBackendFacility subclass:#DBXMsSQLFacility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXMsSQLFacility class methodsFor:'as yet unclassified'!

new
	self error: 'Use facilityForTest or facilityForBenchmark'
! !

!DBXMsSQLFacility methodsFor:'benchmarks'!

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
			date1	DATETIME,
			date2    DATETIME)'.
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
			date1	DATETIME,
			date2    DATETIME)'.
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
			date1 	DATETIME,
			date2 	DATETIME)'.
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
			date1 	DATETIME,
			PRIMARY KEY (id))'.
	1
		to: aNumber
		do: [:i | script
				add: ('INSERT INTO tiny_benchmark_' , aNumber asString , ' 
					(id, num1, num2, num3, num4, str1, str2, date1)
				VALUES 
					({1}, {2}, {3}, {4}, {5}, {6}, {7}, {8})' format: (OrderedCollection new add: i asDbxString;
							 add: i asFloat asDbxString;
							 add: i asFloat asDbxString;
							 add: i asFloat asDbxString;
							 add: i asDbxString;
							 add: i asString asDbxString;
							 add: i asString asDbxString;
							 add: DateAndTime current asDbxString;
							 yourself))].
	^ script
! !

!DBXMsSQLFacility methodsFor:'connection'!

createConnection
self connectionSettings: (DBXConnectionSettings
				host: 'SQLSERVER_TDS'
				port: ''
				database: 'sodbxtest'
				userName: 'sodbxtest'
				userPassword: 'sodbxtest').
	self platform: DBXMSSQLBackend new.
! !

!DBXMsSQLFacility methodsFor:'tests'!

addTestScripts
| scriptDDL scriptDrops |
scriptDDL := OrderedCollection new. 
	scriptDrops := OrderedCollection new. 
	
	scriptDDL add: 'CREATE TABLE student(
	   id INTEGER,
	   name_surname VARCHAR(30) NULL,	   
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

	
	scriptDDL add:  'CREATE TABLE signature(
	code INTEGER, 
	id_student INTEGER,
	name CHAR(35) NULL,
	observations VARCHAR(255) NULL,
	course_grade INTEGER NULL,
	final_grade INTEGER NULL,
	CONSTRAINT pk_signatures_code PRIMARY KEY (code)
)  '.


	scriptDDL add:  
'CREATE TABLE course(
	id_course INTEGER,
	id_student INTEGER,
	code_signature INTEGER,
	starting_date DATETIME NULL,
	CONSTRAINT pk_courses_id_course PRIMARY KEY (id_student, code_signature)
) '.


"		scriptDDL add: 'ALTER TABLE curso
	ADD CONSTRAINT co_ao_fk FOREIGN KEY (id_alumno) REFERENCES alumno(id)'.  
		
			scriptDDL add: 'ALTER TABLE curso
	ADD CONSTRAINT co_ma_fk FOREIGN KEY (codigo_materia) REFERENCES materia(codigo)'."
	
	"scriptDDL add: 'ALTER TABLE materia
	ADD CONSTRAINT ma_ao_fk FOREIGN KEY (id_alumno) REFERENCES alumno(id)'.
	"
	
	self scriptsDDL: scriptDDL. 
	
	scriptDrops add: 'DROP TABLE course'.
	scriptDrops add: 'DROP TABLE signature'. 
	scriptDrops add: 'DROP TABLE student'.
	
	self scriptsDrops: scriptDrops.
! !

!DBXMsSQLFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMsSQLFacility.st,v 1.2 2013-04-15 13:18:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXMsSQLFacility.st,v 1.2 2013-04-15 13:18:29 cg Exp $'
! !


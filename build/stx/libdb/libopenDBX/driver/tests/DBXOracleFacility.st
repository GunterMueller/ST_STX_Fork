"{ Package: 'stx:libdb/libopenDBX/driver/tests' }"

DBXBackendFacility subclass:#DBXOracleFacility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverTests'
!


!DBXOracleFacility class methodsFor:'as yet unclassified'!

new
	self error: 'Use facilityForTest or facilityForBenchmark'
! !

!DBXOracleFacility methodsFor:'benchmarks'!

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

!DBXOracleFacility methodsFor:'connection'!

createConnection
self connectionSettings: (DBXConnectionSettings
				host: '127.0.0.1'
				port: '1521'
				database: 'xe'
				userName: 'sodbxtest'
				userPassword: 'sodbxtest').
	self platform: DBXOracleBackend new.
! !

!DBXOracleFacility methodsFor:'tests'!

addTestScripts
	| scriptDDL scriptDrops |
	scriptDDL := OrderedCollection new.
	scriptDrops := OrderedCollection new.
	scriptDDL add: 'CREATE table student (
    id               NUMBER NOT NULL,
    name_surname  VARCHAR2(4000),
    username VARCHAR2(10),
    pass VARCHAR2(50),
    mail VARCHAR2(50),
    regular          NUMBER(1),
    age             NUMBER,
    average_grade         NUMBER(9,3),
    sex             VARCHAR2(4000),
    description      VARCHAR2(4000),
    starting_hour     TIMESTAMP,
    sign_up_date       DATE,
    born_date DATE,
    nullable_field VARCHAR2(64) NULL,
    constraint  student_PK primary key (id)
)
'.
	scriptDDL add: 'CREATE table signature (
    code        NUMBER NOT NULL,
    id_student INTEGER NOT NULL,
    name        VARCHAR2(4000),
    observations VARCHAR2(4000),
    course_grade NUMBER,
    final_grade NUMBER,
    constraint  signature_pk primary key (code),
	constraint signature_student_fk FOREIGN KEY (id_student) references student(id)
)'.
	scriptDDL add: 'CREATE table course (
    id_course       NUMBER NOT NULL,
    id_student      NUMBER,
    code_signature NUMBER,
    starting_date   DATE,
    constraint  course2_pk primary key (id_course)
)'.
	scriptDDL add: 'CREATE SEQUENCE student_id_seq 
 	       start with 1 
  	      increment by 1 
   	     nomaxvalue'.
	"scriptDDL add: 
	'CREATE TRIGGER alumno_insert_trigger
	before insert on alumno
	for each row
	begin
	select alumno_id_seq.nextval into :new.id from dual;
	end'."
	"
	scriptDDL add: '
	alter table curso add constraint
	co_ao_fk foreign key (id_alumno) references alumno (id)
	'. 
	
	scriptDDL add: 'alter table curso add constraint
	co_ma_fk foreign key (codigo_materia) references materia (codigo)
	'.
	
	scriptDDL add: 'ALTER TABLE materia
	ADD CONSTRAINT ma_ao_fk FOREIGN KEY (id_alumno) REFERENCES
	alumno(id)'. "
	self scriptsDDL: scriptDDL.
	scriptDrops add: 'DROP TABLE course CASCADE CONSTRAINTS'.
	scriptDrops add: 'DROP TABLE signature CASCADE CONSTRAINTS'.
	scriptDrops add: 'DROP TABLE student CASCADE CONSTRAINTS'.
	scriptDrops add: 'DROP TRIGGER student_insert_trigger'.
	scriptDrops add: 'DROP SEQUENCE student_id_seq'.
	self scriptsDrops: scriptDrops
! !

!DBXOracleFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOracleFacility.st,v 1.2 2013-04-15 13:18:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/DBXOracleFacility.st,v 1.2 2013-04-15 13:18:38 cg Exp $'
! !


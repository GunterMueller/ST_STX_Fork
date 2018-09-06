"{ Package: 'stx:libdb/libopenDBX/examples' }"

Object subclass:#GlorpExamples
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTalkExamples'
!


!GlorpExamples methodsFor:'as yet unclassified'!

glorpMySQLExampleLogin
	"self new glorpMySQLExampleLogin"
	| login system session courses |
	login := (Login new)
			database: MySQLPlatform new;
			databaseName: 'sodbxtest';
			username: 'sodbxtest';
			password: 'sodbxtest';
			host: 'localhost';
 		      port: '3304'.
	system := DBXTalkExampleDescriptorSystem forPlatform: login database.
	session := system sessionForLogin: login.
	session accessor login.
	
	self setUpTables: session.
	self setUpSomeData: session.
	courses := session readManyOf: DBXCourse.
	
	"force to load the instances, because the proxy will not bring anything after the logout"
	courses do: [ :course | course teacher name].
	
	courses explore.
	session logout.
!

glorpOracleLogin
	"self new glorpOracleLogin"
	| login system session courses |
	login := (Login new)
			database: OraclePlatform new;
			username: 'sodbxtest';
			password: 'sodbxtest';
			host: '127.0.0.1';
			port: '1521';
			connectString: '127.0.0.1_xe'.
	system := DBXTalkExampleDescriptorSystem forPlatform: login database.
	session := system sessionForLogin: login.
	session accessor login.
	
	self setUpTables: session.
	self setUpSomeData: session.
	courses := session readManyOf: DBXCourse.
	
	"force to load the instances, because the proxy will not bring anything after the logout"
	courses do: [ :course | course teacher name].
	
	courses explore.
	session logout.
!

glorpPostgreSQLExampleLogin
	"self new glorpPostgreSQLExampleLogin"
	| login system session courses |
	login := (Login new)
			database: PostgreSQLPlatform new;
			username: 'sodbxtest';
			password: 'sodbxtest';
			connectString: '127.0.0.1:5432_sodbxtest'.
	system := DBXTalkExampleDescriptorSystem forPlatform: login database.
	session := system sessionForLogin: login.
	session accessor login.
	
	self setUpTables: session.
	self setUpSomeData: session.
	courses := session readManyOf: DBXCourse.
	
	"force to load the instances, because the proxy will not bring anything after the logout"
	courses do: [ :course | course teacher name].
	
	courses explore.
	session logout.
!

glorpSQLiteExampleLogin
	"self new glorpSQLiteExampleLogin"
	| login system session courses |
	login := (Login new)
			database: SQLite3Platform new;
			host: '/home/ubuntu/sqldbs/';
			port: '';
			username: '';
			password: '';
			databaseName: 'sodbxtest.db'.
	system := DBXTalkExampleDescriptorSystem forPlatform: login database.
	session := system sessionForLogin: login.
	session accessor login.
	
	self setUpTables: session.
	self setUpSomeData: session.
	courses := session readManyOf: DBXCourse.
	
	"force to load the instances, because the proxy will not bring anything after the logout"
	courses do: [ :course | course teacher name].
	
	courses explore
	session logout.
!

setUpSomeData: session
	| guille nico german computers2 programmingIntroduction graphicInterfaceDesign |
	session transact: [  

		computers2 := DBXCourse new id: 1; name: 'computers 2'; yourself.
		programmingIntroduction := DBXCourse new id: 2; name: 'Programming Introduction'; yourself.
		graphicInterfaceDesign := DBXCourse new id: 3; name: 'Graphic interface design'; yourself.

		guille := DBXTeacher new id: 1; name: 'Guille'; yourself.
		nico := DBXTeacher new id: 2; name: 'Nico'; yourself.
		german := DBXTeacher new id: 3; name: 'German'; yourself.

		session register: computers2.
		session register: programmingIntroduction.
		session register: graphicInterfaceDesign.	
	
		computers2 teacher: german.
		programmingIntroduction teacher: guille.
		graphicInterfaceDesign teacher: nico.
	].
	session reset.
!

setUpTables: session
	| system errorBlock |
	errorBlock := [ :ex |  ^ex ].
	system := session system.
	session accessor dropTables: ((TableSorter for: system allTables) sort reverse).
	system platform areSequencesExplicitlyCreated ifTrue: [
		session accessor dropSequences: system allSequences.
		system allSequences do: [:each |
			session accessor createSequence: each ifError: errorBlock]].
	system allTables do: [:each | 
			session accessor createTable: each
				ifError: errorBlock].
	system allTables do: [:each |
			session accessor createTableIndexes: each ifError: errorBlock]. 
	"SQLite3 doesn't support adding/dropping constraints."
	system platform supportsConstraints ifTrue: [
		system allTables do: [:each | 
				session accessor createTableFKConstraints: each ifError: errorBlock]].
! !

!GlorpExamples class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/GlorpExamples.st,v 1.1 2013-04-15 13:48:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/examples/GlorpExamples.st,v 1.1 2013-04-15 13:48:01 cg Exp $'
! !


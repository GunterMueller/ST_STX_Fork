"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#MysqlBigBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!MysqlBigBenchmarks class methodsFor:'defaults'!

defaultRuns
	^1
! !

!MysqlBigBenchmarks methodsFor:'running'!

benchmarkInsert100000
	| connection |
	connection := self createDbxConnection.
	100000 timesRepeat: [ 
		connection execute: 
			'INSERT INTO big_benchmark_insert
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')'
		querySettings: self querySetting ].
	connection close.	
!

benchmarkSelect100000
	| connection |
	connection := self createDbxConnection.
	(connection execute: 'SELECT * FROM big_benchmark_select'
		querySettings: self querySetting)
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ] ].
	connection := self createDbxConnection.
!

initialize
	super initialize.
	DBXBenchmark facility: DBXMySQLFacility facilityForBenchmark.
	self initializeDatabase.
	self initializeConnection.
!

initializeConnection
	| spec |
	spec := JdmConnectionSpec new initialize database: 'sodbxtest';				
				host: (NetNameResolver addressForName: 'localhost');
				 port: 3306;
				 user: 'sodbxtest';
				 password: 'sodbxtest'.
	connection := JdmConnection on: spec.
!

setUpBenchmarkInsert100000
	| conn |
	conn := self createDbxConnection.
	[ conn execute: 'DROP TABLE big_benchmark_insert' ] 
		on: DBXError
		do: 
			[ :e | 
			"DROP fails"
			 ].
	self facility bigBenchmarkScriptInsert do: 
		[ :script | 
		conn execute: script ].
	conn close
!

setUpBenchmarkSelect100000
	| connection |
	connection := self createDbxConnection.
	[ connection execute: 'DROP TABLE big_benchmark_select' ] 
		on: DBXError
		do: 
			[ :e | 
			"DROP fails"
			 ].
	self facility bigBenchmarkScriptSelect do: 
		[ :script | 
		connection execute: script ].
	100000 timesRepeat: 
		[ connection execute: 'INSERT INTO big_benchmark_select
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')' ].
	connection close
!

tearDownBenchmarkInsert100000
	| connection |
	connection := self createDbxConnection.
	connection execute: 'DROP TABLE big_benchmark_insert'.
	connection close.
!

tearDownBenchmarkSelect100000
	| connection |
	connection := self createDbxConnection.
	connection execute: 'DROP TABLE big_benchmark_select'.
	connection close.
! !

!MysqlBigBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/MysqlBigBenchmarks.st,v 1.2 2013-04-15 13:12:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/MysqlBigBenchmarks.st,v 1.2 2013-04-15 13:12:48 cg Exp $'
! !


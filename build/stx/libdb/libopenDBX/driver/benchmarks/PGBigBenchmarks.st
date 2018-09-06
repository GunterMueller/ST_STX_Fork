"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#PGBigBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!PGBigBenchmarks class methodsFor:'defaults'!

defaultRuns
	^1
! !

!PGBigBenchmarks methodsFor:'running'!

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
	DBXBenchmark facility: DBXPostgreFacility facilityForBenchmark.
	self initializeDatabase.
	self initializeConnection.
!

initializeConnection
	connection := PGConnection new
		connectionArgs: (PGConnectionArgs new
			hostname: 'localhost';
			portno: 5432;
			databaseName: 'sodbxtest';
			userName: 'sodbxtest';
			password: 'sodbxtest');
		yourself.
	connection startup.
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
	| conn |
	conn := self createDbxConnection.
	[ conn execute: 'DROP TABLE big_benchmark_select' ] 
		on: DBXError
		do: 
			[ :e | 
			"DROP fails"
			 ].
	self facility bigBenchmarkScriptSelect do: 
		[ :script | 
		conn execute: script ].
	100000 timesRepeat: 
		[ conn execute: 'INSERT INTO big_benchmark_select
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')' ].
	conn close
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

!PGBigBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/PGBigBenchmarks.st,v 1.2 2013-04-15 13:12:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/PGBigBenchmarks.st,v 1.2 2013-04-15 13:12:54 cg Exp $'
! !


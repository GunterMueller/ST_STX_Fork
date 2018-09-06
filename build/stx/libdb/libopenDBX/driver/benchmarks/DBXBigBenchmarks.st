"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#DBXBigBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!DBXBigBenchmarks class methodsFor:'defaults'!

defaultRuns
	^1
! !

!DBXBigBenchmarks methodsFor:'running'!

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
	self initializeDatabase.
	self initializeConnection.
!

initializeConnection
	connection := self createDbxConnection.
!

initializeDatabase
self setUpBenchmarkInsert100000.
self setUpBenchmarkSelect100000.
!

setUpBenchmarkInsert100000
	| connection |
	connection := self createDbxConnection.
	[ connection execute: 'DROP TABLE big_benchmark_insert' ] 
		on: DBXError
		do: 
			[ :e | 
			"DROP fails"
			 ].
	self facility bigBenchmarkScriptInsert do: 
		[ :script | 
		connection execute: script ].
	connection close
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

!DBXBigBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXBigBenchmarks.st,v 1.2 2013-04-15 13:12:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXBigBenchmarks.st,v 1.2 2013-04-15 13:12:52 cg Exp $'
! !


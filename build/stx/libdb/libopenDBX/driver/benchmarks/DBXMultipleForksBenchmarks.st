"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#DBXMultipleForksBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!DBXMultipleForksBenchmarks class methodsFor:'as yet unclassified'!

defaultRuns
	^3
! !

!DBXMultipleForksBenchmarks methodsFor:'as yet unclassified'!

benchmarkSelect100000
	| connection |
	Transcript show: 'benchmarkSelect100000'; cr.
	connection := self createDbxConnection.
	(connection execute: 'SELECT * FROM big_benchmark_select'
		querySettings: self querySetting)
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ] ].
!

collect: aBlock
|sem time|
sem := Semaphore new.

	1 to: self runs do: [:i |
		[
		time := MessageTally time: aBlock.
		mutex critical: [ times add: time ].
		sem signal.
		] fork		
	].

	self runs timesRepeat: [sem wait]
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

tearDownBenchmarkSelect100000
	| connection |
	Transcript show: 'aaaaa '; cr.
	connection := self createDbxConnection.
	connection execute: 'DROP TABLE big_benchmark_select'.
	connection close.
! !

!DBXMultipleForksBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXMultipleForksBenchmarks.st,v 1.2 2013-04-15 13:12:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXMultipleForksBenchmarks.st,v 1.2 2013-04-15 13:12:51 cg Exp $'
! !


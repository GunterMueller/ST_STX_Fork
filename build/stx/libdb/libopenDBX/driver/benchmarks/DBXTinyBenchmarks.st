"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#DBXTinyBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!DBXTinyBenchmarks methodsFor:'initialization'!

initialize
	super initialize.
	self initializeDatabase.
	self initializeConnection.
!

initializeConnection
	connection := self createDbxConnection.
! !

!DBXTinyBenchmarks methodsFor:'running'!

benchmarkInsert
	self class defaultInserts timesRepeat: [ 
		connection execute: 
			'INSERT INTO tiny_benchmark_insert  
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')'
			querySettings: self querySetting ]
!

benchmarkInsertConverted
	| date dateAndTime |
	
	date := Date current. 
	dateAndTime := DateAndTime current. 
	1 to: self class defaultInserts do: [ :i |  
		connection execute: (
			'INSERT INTO tiny_benchmark_insert  
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES ({1}, {2}, {3}, {4}, {5}, {6}, {7}, {8})' 
					format: (OrderedCollection new
						add: i asFloat asDbxString;
						add: i asFloat asDbxString;
						add: i asFloat asDbxString;
						add: i asDbxString;
						add: i asString asDbxString;
						add: i asString asDbxString;
						add: date asDbxString;
						add: dateAndTime asDbxString;
						yourself)
			) querySettings: self querySetting. ]
!

benchmarkSelect10
	(connection execute: 'SELECT * FROM tiny_benchmark_10' querySettings: self querySetting )
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ] ].
!

benchmarkSelect100
	(connection execute: 'SELECT * FROM tiny_benchmark_100' querySettings: self querySetting)
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ] ].
!

benchmarkSelect1000
	(connection execute: 'SELECT * FROM tiny_benchmark_1000' querySettings: self querySetting)
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ] ].
!

benchmarkSelect10000
	(connection execute: 'SELECT * FROM tiny_benchmark_10000' querySettings: self querySetting)
		ifNotNilDo: [ :resultSet | resultSet rowsDo: [ :each | each values ] ].
!

setUp
	self prepareInsert: connection.
! !

!DBXTinyBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXTinyBenchmarks.st,v 1.2 2013-04-15 13:12:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/DBXTinyBenchmarks.st,v 1.2 2013-04-15 13:12:42 cg Exp $'
! !


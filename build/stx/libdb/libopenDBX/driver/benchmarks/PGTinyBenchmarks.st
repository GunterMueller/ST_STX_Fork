"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#PGTinyBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!PGTinyBenchmarks methodsFor:'initialization'!

initialize
	DBXBenchmark facility: DBXPostgreFacility facilityForBenchmark.
	super initialize.
	self initializeDatabase.
	self initializeConnection
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
! !

!PGTinyBenchmarks methodsFor:'running'!

benchmarkInsert
	self class defaultInserts timesRepeat: [ 
		connection execute: 
			'INSERT INTO tiny_benchmark_insert  
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')' ]
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
						yourself)) ]
!

benchmarkSelect10
	(connection  execute: 'SELECT * FROM tiny_benchmark_10') lastResultSet 
		in: [ :resultSet |
			resultSet rows do: [ :each | each data ] ]  
!

benchmarkSelect100
	(connection  execute: 'SELECT * FROM tiny_benchmark_100') lastResultSet 
		in: [ :resultSet |
			resultSet rows do: [ :each | each data ] ]  
!

benchmarkSelect1000
	(connection  execute: 'SELECT * FROM tiny_benchmark_1000') lastResultSet 
		in: [ :resultSet |
			resultSet rows do: [ :each | each data ] ]  
!

benchmarkSelect10000
	(connection  execute: 'SELECT * FROM tiny_benchmark_10000') lastResultSet 
		in: [ :resultSet |
			resultSet rows do: [ :each | each data ] ]  
!

setUp
	| conn |
	conn := self createDbxConnection.
	self prepareInsert: conn.
	conn close.
! !

!PGTinyBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/PGTinyBenchmarks.st,v 1.2 2013-04-15 13:12:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/PGTinyBenchmarks.st,v 1.2 2013-04-15 13:12:50 cg Exp $'
! !


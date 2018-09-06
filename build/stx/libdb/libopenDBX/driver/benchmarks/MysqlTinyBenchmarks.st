"{ Package: 'stx:libdb/libopenDBX/driver/benchmarks' }"

DBXBenchmark subclass:#MysqlTinyBenchmarks
	instanceVariableNames:'connection'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverBenchmarks'
!


!MysqlTinyBenchmarks methodsFor:'initialization'!

initialize
	DBXBenchmark facility: DBXMySQLFacility facilityForBenchmark.
	super initialize.
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
! !

!MysqlTinyBenchmarks methodsFor:'running'!

benchmarkInsert
	| statement |
	statement := connection createStatement.
	self class defaultInserts
		timesRepeat: [statement executeQuery: 'INSERT INTO tiny_benchmark_insert  
				(num1, num2, num3, num4, str1, str2, date1, date2)
			VALUES 
				(1.0, 1.0, 1.0, 1, ''test'', ''test'', ''2008-01-01'', ''2008-01-01 10:00:00'')']
!

benchmarkInsertConverted
	| date dateAndTime statement |
	
	date := Date current. 
	dateAndTime := DateAndTime current. 
	statement := connection createStatement.
	1 to: self class defaultInserts do: [ :i |  
		statement executeQuery: (
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
	| statement resultSet dic |
	statement := connection createStatement.
	resultSet := statement executeQuery: 'SELECT * FROM tiny_benchmark_10'.
	[resultSet next]
		whileTrue: [dic := resultSet currentRowAsDictionary]
!

benchmarkSelect100
	| statement resultSet dic |
	statement := connection createStatement.
	resultSet := statement executeQuery: 'SELECT * FROM tiny_benchmark_100'.
	[resultSet next]
		whileTrue: [dic := resultSet currentRowAsDictionary]
!

benchmarkSelect1000
	| statement resultSet dic |
	statement := connection createStatement.
	resultSet := statement executeQuery: 'SELECT * FROM tiny_benchmark_1000'.
	[resultSet next]
		whileTrue: [dic := resultSet currentRowAsDictionary]
!

benchmarkSelect10000
	| statement resultSet dic |
	statement := connection createStatement.
	resultSet := statement executeQuery: 'SELECT * FROM tiny_benchmark_10000'.
	[resultSet next]
		whileTrue: [dic := resultSet currentRowAsDictionary]
!

setUp
	| conn |
	conn := self createDbxConnection.
	self prepareInsert: conn.
	conn close.
! !

!MysqlTinyBenchmarks class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/MysqlTinyBenchmarks.st,v 1.2 2013-04-15 13:12:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/benchmarks/MysqlTinyBenchmarks.st,v 1.2 2013-04-15 13:12:53 cg Exp $'
! !


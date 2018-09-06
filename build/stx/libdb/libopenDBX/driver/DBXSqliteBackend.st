"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXSqliteBackend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXSqliteBackend class methodsFor:'defaults'!

createDataTypesMap
	^super createDataTypesMap
		at: 16r20 put: String; "CLOB"
		at: 16r2F put: ByteArray;  "BLOB"
		yourself
		
! !

!DBXSqliteBackend methodsFor:'*dbxdatabasemodel'!

allColumnsQuery: aTableName
	^'Pragma table_info(' , aTableName, ')'
!

allColumnsQueryForSchema: aSchemaName
	^'SELECT sql FROM sqlite_master WHERE type = ''column'''
!

allTableNamesQuery
	^'SELECT name as table_name FROM sqlite_master
		WHERE type=''table''
		ORDER BY name;'
	
!

columnLengthForRow: aDBXRow
	^nil
!

columnNullableColumnName
	^'notnull'
!

fetchTable: aTableName on: aConnection
	| table columns columnName |
	table := DBXTable named: aTableName.
	columns := self executeStatement: (self allColumnsQuery: aTableName) on: aConnection.
	columns rows do: [ :aRow | 
		columnName := aRow rawValueNamed: 'name'.
		table 
			addColumn: columnName
			ofType: (aRow rawValueNamed: 'type') 
			withLength: nil
			nullable: (self stringToBool: (aRow rawValueNamed: self columnNullableColumnName )).

		(self stringToBool: (aRow rawValueNamed: 'pk'))
			ifTrue: [ (table columnNamed: columnName) bePrimaryKey ].
		table
	].
	^table
!

foreignKeysQuery: aTableName
	^'Pragma foreign_key_list(''{1}'')' format: { aTableName }
!

schemasOn: aDBXConnection
	^{ DBXSchema named: 'master' }
!

stringToBool: aBooleanString
	^aBooleanString ~= '0'
!

tablesDescriptionForSchema: aSchema on: connection
	"Returns a collection  with all the database tables descripted"
	|rs tablesNames tablesDescriptions |
	[
		rs := self executeStatement: self allTableNamesQuery on: connection.  
		^rs rows collect: [ :row | self fetchTable: (row rawValueNamed: 'table_name') on: connection ].
	] ensure: [ rs ifNotNil: [rs releaseResult] ]
! !

!DBXSqliteBackend methodsFor:'accessing'!

backend
	^'sqlite3'
!

name
	^'SQLite'
! !

!DBXSqliteBackend methodsFor:'resultSet'!

moveNext: aResultSet 
	"Moves the aResultSet one more row and this row is returned."
	| err |
	err := OpenDBX current apiQueryFetchRow: aResultSet handle.
	self log: ['odbx_row_fetch: called with values: resultSet handle = ', aResultSet handle asString].
	self log: ['odbx_row_fetch call returned ', err asString].
	self verifyError: err on: aResultSet connection.
	err = OpenDBX rowDone
		ifTrue: [ ^ nil ]
		ifFalse: [
			^ DBXRow on: aResultSet detectNewTypes]
!

queryDelimiter
	^';'
! !

!DBXSqliteBackend methodsFor:'transactional manage'!

startTransaction
	^'BEGIN TRANSACTION'
! !

!DBXSqliteBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXSqliteBackend.st,v 1.2 2013-04-15 13:11:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXSqliteBackend.st,v 1.2 2013-04-15 13:11:35 cg Exp $'
! !


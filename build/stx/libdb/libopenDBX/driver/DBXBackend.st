"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXBackend
	instanceVariableNames:''
	classVariableNames:'Properties'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-API'
!

DBXBackend class instanceVariableNames:'backends dataTypesMap'

"
 No other class instance variables are inherited by this class.
"
!


!DBXBackend class methodsFor:'accessing'!

createDataTypesMap
	"Creates and returns a map that maps Smalltalk classes to SQL datatypes.
	The 16r means it is hexadecimal."
	^Dictionary new
		at: 16r00 put: Boolean; "BOOLEAN"
		at: 16r01 put: Number; "SMALLINT"
		at: 16r02 put: Number; "INTEGER"
		at: 16r03 put: Number; "BIGINT"
		at: 16r07 put: Number; "DECIMAL"
		at: 16r08 put: Number; "REAL"
		at: 16r09 put: Number; "DOUBLE"
		at: 16r0F put: Number; "FLOAT"
		at: 16r10 put: String; "CHAR"
		at: 16r11 put: String; "NCHAR"
		at: 16r12 put: String; "VARCHAR"
		at: 16r13 put: String; "NVARCHAR"
		at: 16r20 put: String; "CLOB"
		at: 16r21 put: String; "NCLOB"
		at: 16r22 put: String; "XML"
		at: 16r2F put: ByteArray; "BLOB"
		at: 16r30 put: Time; "TIME"
		at: 16r31 put: Time; "TIMETZ"
		at: 16r32 put: TimeStamp; "TIMESTAMP"
		at: 16r33 put: TimeStamp; "TIMESTAMPTZ"
		at: 16r34 put: Date; "DATE"
		at: 16r35 put: (DBXTypeNotSupported type: #INTERVAL);
		at: 16r40 put: (DBXTypeNotSupported type: #ARRAY);
		at: 16r41 put: (DBXTypeNotSupported type: #MULTISET);
		at: 16r50 put: (DBXTypeNotSupported type: #DATALINK);
		at: 16rFF put: (DBXTypeNotSupported type: #UNKNOWN);
		yourself
!

dataTypeAt: aNumber
	"Returns the Smalltalk class associated with a particular SQL type."
	^self dataTypesMap at: aNumber ifAbsent: [ 
		DBXTypeNotSupported code: aNumber ]
!

dataTypesMap
	"Returns a map that maps Smalltalk classes to SQL datatypes."
	^dataTypesMap ifNil: [ dataTypesMap := self createDataTypesMap ]
! !

!DBXBackend class methodsFor:'defaults'!

resetDataTypesMap
	dataTypesMap := nil.
! !

!DBXBackend class methodsFor:'logging'!

allBackends
	^backends ifNil: [ backends := self allSubclasses collect: [ :backendClass | backendClass new ] ]
!

log: messageBlockOrString
	self isDebugMode ifTrue: [
		Transcript show: messageBlockOrString value; cr.
		    "self log info: messageBlockOrString." ].
! !

!DBXBackend class methodsFor:'testing'!

disableAutomaticConnectionReleaseOnGC
	self propertyAt: #automaticConnectionReleaseOnGC
 put: false
!

disableDebugMode
	self propertyAt: #debugMode put: false
!

enableAutomaticConnectionReleaseOnGC
	self propertyAt: #automaticConnectionReleaseOnGC
 put: true
!

enableDebugMode
	self propertyAt: #debugMode put: true
!

isAutomaticConnectionReleaseOnGC

	^self propertyAt: #automaticConnectionReleaseOnGC ifAbsentPut: [ true ]
!

isDebugMode
	^self propertyAt: #debugMode ifAbsentPut: [ false ]
!

isLarge: aNumber
	"Answer true if aNumber represents a large data object (BLOB, CLOB, NCLOB)"
	^#(16r20 16r21 16r2F) includes: aNumber
!

properties
	^Properties ifNil: [ Properties := Dictionary new ]
!

propertyAt: aSymbol
	^self properties at: aSymbol
!

propertyAt: aSymbol ifAbsent: aBlock
	^self properties at: aSymbol ifAbsent: aBlock
!

propertyAt: aSymbol ifAbsentPut: aBlock
	^self properties at: aSymbol ifAbsentPut: aBlock
!

propertyAt: aSymbol put: anObject
	^self properties at: aSymbol put: anObject
! !

!DBXBackend methodsFor:'*dbxdatabasemodel'!

addConstraintsToTable: aTable on: aConnection
	| rs |
	rs := aConnection execute: (self allConstraintsQueryForTable: aTable name).
	rs rowsDo: [ :aRow | aTable buildConstraintForRow: aRow ].
!

allColumnsQuery
	"SQL to obtain the table description from the database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^'SELECT 
		table_schema,
		table_name, 
		column_name, 
		is_nullable, 
		data_type as type, 
		character_maximum_length as length,
		NULL as constraint_name,
		NULL as constraint_type,
		NULL as own_column_name,
		NULL as foreign_table_name,
		NULL as foreign_column_name
	FROM information_schema.COLUMNS'
!

allColumnsQueryForSchema: aSchema
	^self allColumnsQueryWhere: ('TABLE_SCHEMA = ''{1}''' format: { aSchema }).
!

allColumnsQueryForTable: aTableName
	^self allColumnsQueryWhere: ('table_name = ''{1}''' format: { aTableName }).
!

allColumnsQueryWhere: aCriteria
	"SQL to obtain the table description from the database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^'{1} WHERE {2}' format: { self allColumnsQuery . aCriteria }
!

allConstraintsQuery
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^ 'SELECT 
			tc.table_schema,
			tc.table_name,
			NULL as column_name,
			NULL as is_nullable,
			NULL as type,
			NULL as length,
			tc.constraint_name, 
			tc.constraint_type AS constraint_type,
			(CASE WHEN tc.constraint_type = ''FOREIGN KEY'' THEN kcu.column_name ELSE ccu.column_name END) AS own_column_name, 
			(CASE WHEN tc.constraint_type = ''FOREIGN KEY'' THEN ccu.table_name ELSE NULL END) AS foreign_table_name, 
			(CASE WHEN tc.constraint_type = ''FOREIGN KEY'' THEN ccu.column_name ELSE NULL END) AS foreign_column_name 
	FROM information_schema.table_constraints AS tc 
	JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name 
	JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name'
	
!

allConstraintsQueryForSchema: aSchema
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^self allConstraintsQueryWhere: ('tc.table_schema = ''{1}''' format: { aSchema }).
!

allConstraintsQueryForTable: aTableName
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^self allConstraintsQueryWhere: ('tc.table_name = ''{1}''' format: { aTableName }).
!

allConstraintsQueryWhere: criteria
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^'{1} WHERE {2}' format: { self allConstraintsQuery . criteria }
	
!

allSchemasQuery
	self subclassResponsibility
!

allTableNamesQuery
	"SQL to obtain all the table name from the database. This is the ANSI SQL, if the database does not support this should be overwritten"
	^'SELECT * FROM INFORMATION_SCHEMA.TABLES'
	
!

allTableNamesQueryForSchema: aSchema
	"SQL to obtain all the table name from a dabatase schema. This is the ANSI SQL, if the database does not support this should be overwritten"
	^'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ''{1}'' ' format: { aSchema }
	
!

allTablesQueryForSchema: aSchema
	"SQL to obtain all the table name from a dabatase schema. This is the ANSI SQL, if the database does not support this should be overwritten"
	| columnsQuery constraintsQuery |

	columnsQuery := self allColumnsQueryForSchema: aSchema.
	constraintsQuery := self allConstraintsQueryForSchema: aSchema.

	^ ' {1} UNION {2} ' format: { columnsQuery . constraintsQuery }
!

buildTable: aTableName fromDescriptionCollection: tableDescription
	| aTable |
	aTable := DBXTable new name: aTableName; platform: self; yourself .
	tableDescription select: [ :aRow | (aRow rawValueNamed: 'column_name') notNil ]
		thenDo: [ :aRow | aTable buildColumnForRow: aRow ].
	tableDescription select: [ :aRow | (aRow rawValueNamed: 'constraint_name') notNil ]
		thenDo: [ :aRow | aTable buildConstraintForRow: aRow ].
	^aTable.
!

columnLengthForRow: aDBXRow
	| length |
	length := aDBXRow valueNamed: 'length'.
	^length = 0 ifTrue: [ nil ] ifFalse: [ length ]
!

columnNullableColumnName
	^'is_nullable'
!

defaultSchema
	self subclassResponsibility
!

foreignKeysQuery: tableName
	"SQL to obtain all the foreign keys from the given tableName database. This is the ANSI SQL, if the database does not support this should be overwrited"
	^ 'SELECT tc.constraint_name AS name, 
			kcu.column_name AS column_name, 
			ccu.table_name AS foreign_table_name, 
			ccu.column_name AS foreign_column_name 
	FROM information_schema.table_constraints AS tc 
	JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name 
	JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name 
	WHERE constraint_type = ''FOREIGN KEY'' AND tc.table_name=''{1}''' format: { tableName} .
	
!

int
	^'integer'
!

schemasOn: aDBXConnection
	| resultSet |
	[
		resultSet := self executeStatement: self allSchemasQuery on: aDBXConnection.
		^resultSet rows collect: [ :row | DBXSchema named: (row rawValueNamed: 'database') ]
	] ensure: [ resultSet ifNotNilDo: [ :rs | rs releaseResult ] ]
	
!

stringToBool: aBooleanString
	^aBooleanString ~= 'NO'
!

tablesDescriptionForSchema: aSchema on: connection
	"Returns a collection  with all the database tables descripted"
	|rs tablesNames tablesDescriptions |
	rs := self executeStatement: (self allTablesQueryForSchema: aSchema) on: connection.  
	tablesDescriptions := rs rows groupedBy: [ :row | row rawValueNamed: 'table_name' ].
	rs releaseResult .
	^tablesDescriptions keys collect: [ :tableName | self buildTable: tableName fromDescriptionCollection: (tablesDescriptions at: tableName) ].
! !

!DBXBackend methodsFor:'accessing'!

backend
	"Returns the name of the backend that OpenDBX understands for each RDBMS"
	^self subclassResponsibility
!

dataTypeAt: aSmallInteger 
	^ self class dataTypeAt: aSmallInteger 
! !

!DBXBackend methodsFor:'connection'!

closeConnection: aConnection
	"Closes the connection and throws a DBXError if an error occurs"
	| err |
	err := OpenDBX current apiUnbind: aConnection handle.
	self log: [ 'odbx_unbind called with values: handle = ', aConnection handle asString ].
	self verifyError: err handle: aConnection handle.
!

createConnection: aConnection 
	"It initializes and creates a handle for all further operations, and it is
	used within the OpenDBX library to identify the connection and to
	maintain connection information. Depending on the backend it can open
	a connection to the database server but often this is done not until
	performing authentication through 'openConnection:'
	throws an error if needed"
	| err handleArray handle |
	handleArray := WordArray with: 0.
	err := OpenDBX current
				apiInitialize: handleArray
				backend: self backend
				host: aConnection host
				port: aConnection port.
	self log: [ 'odbx_init called with values: backend = ', self backend, ' host = ', aConnection host, ' port = ', aConnection port asString ].
	handle := handleArray first.
	
	"If it fails here, it means it couldn't connect, so we let the signal pass'"	
	self verifyError: err handle: handle.	
	^ handle
!

disconnectConnection: aConnection 
	"It releases all the resources associated with a connection"
	| err |
	err := OpenDBX current apiFinalize: aConnection handle.
	self log: 
		[ 'odbx_finish: called with values: handle = ' , aConnection handle asString ].
	self 
		verifyError: err
		handle: aConnection handle
!

openConnection: aConnection 
	"'createConnection: should be called first'"
	"It opens the connection, by associating the handle created by
	'createConnection:' to a specific database after the server verified and
	accepted the user credentials. All further operations will (normally)
	only affect the tables and records within this database. The operations
	may be limited to certain subset depending on the privileges granted to
	the given user account. If 'openConnection:' succeeds, it also enables
	compatibility to the ANSI SQL standard if this is possible for the database
	server implementation."
	| err |
	
	self setNecessarySpecialOptions: aConnection. 
	
	err := OpenDBX current 
		apiBind: aConnection handle
		database: aConnection database
		name: aConnection userName
		password: aConnection userPassword
		method: aConnection authenticationMethod.
	self log: 
		[ 'odbx_bind: called with values:' , ' handle = ' , aConnection handle asString , ' database = ' , aConnection database , ' userName = ' , aConnection userName , ' userPassword = ' , aConnection userPassword ].

	self 
		verifyError: err
		handle: aConnection handle.
	^ true
! !

!DBXBackend methodsFor:'description'!

descriptionForColumn: anIndex handle: aHandle on: aConnection
	"Returns a DBXColumnDescription of the column at anIndex from the resultset with aHandle from aConnection."
	"anIndex is Zero based"
	| columnName dbxType |
	columnName := OpenDBX current apiQueryColumnName: aHandle index: anIndex.
	"self log: 'apiQueryColumnName called with values: handle = ', aHandle asString, ' index = ', anIndex asString."
	dbxType := OpenDBX current apiQueryColumnType: aHandle index: anIndex. 
	"self log: 'apiQueryColumnType called with values: handle = ', aHandle asString, ' index = ', anIndex asString."
	^DBXColumnDescription 
		name: columnName
		dbxType: dbxType
		type: (self class dataTypeAt: dbxType).
!

descriptionForResult: aHandle on: aConnection
	"Returns a DBXResultDescription of the query"
	| rowsAffected |
	rowsAffected := OpenDBX current apiQueryRowsAffected: aHandle.
	self log: [ 'odbx_rows_affected: called with values: resultSet handle = ', aHandle asString ].
	self  verifyError: rowsAffected on: aConnection. 
	^DBXResultDescription new
		rowsAffected: rowsAffected;
		yourself.
!

descriptionForResultSet: aHandle on: aConnection 
	"Returns a DBXResultSetDescription of the query"
	| description columnCount |
	columnCount := OpenDBX current apiQueryColumns: aHandle.
	self log: [ 'odbx_column_count: called with values: resultSet handle = ', aHandle asString ].
	self verifyError: columnCount on: aConnection.
	description := DBXResultSetDescription new.
	0 to: columnCount - 1
		do: [:i | description
				addColumnDescription: (self
						descriptionForColumn: i
						handle: aHandle
						on: aConnection)].
	^ description
! !

!DBXBackend methodsFor:'encoding'!

queryEncoding: aConnection
	"Method should use platorm spesific way to determine what is the encoding used to talk with the server using.
	Method should return the name of the encoding."

	self subclassResponsibility.
! !

!DBXBackend methodsFor:'error handling'!

errorCode: err handle: aHandle
	"This method manage errors that have occurred before a correct connection is created" 
	| type description |
	description := OpenDBX current apiError: aHandle number: err.
	description ifNil: [ description := 'Uknown message' ].
	type := OpenDBX current apiErrorType: aHandle number: err.
	"This method should only be called when there is no DBXConnection yet created with a valid handle.
	Because of this I don't have to release resultsets or things like that, just signal"
	(DBXErrorSeverity isFatal: type)
		ifTrue: [ DBXFatalError signal: description ].
	(DBXErrorSeverity isRecoverable: type)
		ifTrue: [ DBXRecoverableError signal: description ].
!

errorCode: err on: aConnection 
	"This method manage errors that have occurred after a correct connection is created" 
	| type description |
	description := OpenDBX current apiError: aConnection handle number: err.
	description ifNil: [ description := 'Uknown message' ].
	type := OpenDBX current apiErrorType: aConnection handle number: err.
	(DBXErrorSeverity isFatal: type)
		ifTrue: [
			"I have to close and disconnect the connection. They will also take care of releasing the results"
			aConnection close.
			aConnection disconnect.
			DBXFatalError signal: description].
	(DBXErrorSeverity isRecoverable: type)
		ifTrue: [
			"In this case I must free the resources of the results. 
			It may be the case where we have an error in the first query on a connection. In this case, the result is in 			nil so I can use the default query setting."
			aConnection result ifNil: [
				self endDBXResult: aConnection querySettings: DBXQuerySettings default .
			] ifNotNil: [
				self endDBXResult: aConnection querySettings: aConnection result querySettings .
			].
		DBXRecoverableError signal: description.
		].

!

verifyError: err handle: aHandle
	"If verifies if a returned number of a call to an openDBX function, is an error or not. If true, a DBXError or any 	subclass is thrown with the associated openDBX message for that error.
	Sometimes I don't have the DBXConnection object created or even with the handle set (for example when creating
	the conenction. In this case, You should use this method. If you have the connection created and set a handle
	you must use verifyError: err on: aConnection "
	err < 0
		ifTrue: [ self errorCode: err handle: aHandle]
!

verifyError: err on: aConnection 
	"It verifies if a returned number of a call to an OpenDBX function, is an
	error or not. If true, a DBXError or any subclass is thrown with the associated OpenDBX
	message for that error."
	err < 0
		ifTrue: [self errorCode: err on: aConnection]
! !

!DBXBackend methodsFor:'logging'!

log: messageBlockOrString
	self class log: messageBlockOrString
! !

!DBXBackend methodsFor:'multistatement'!

executeMultiStatement: aQuery on: aConnection 
	"It executes a multistatement query using the connection and can be used to retrieve all resultsets. 
	There are some important things:
    * this method returns a DBXMultiStatementResultSetIterator
    * The queries sent to the server must be understood by the DBMS because there is no translation done between the 	different dialects of SQL for example."
	^self executeMultiStatement: aQuery on: aConnection querySettings: DBXQuerySettings default.
!

executeMultiStatement: aString on: aConnection querySettings: aQuerySettings 
	"This is similar to executeStatement: aString on: aConnection querySettings: aQuerySettings 
	with the difference that in this case the SAME query settings is used for all the subqueries of
	the multistatement query."
	| err multiStatmentIterator encodedQuery|
	encodedQuery := (aConnection encodeString: aString).
	err := OpenDBX current 
		apiQuery: aConnection handle
		query: encodedQuery 
		length: encodedQuery size.
	self log: 'odbx_query: called with values: handle = ' , aConnection handle asString , ' query = ' , aString.
	self 
		verifyError: err
		on: aConnection.
	multiStatmentIterator := DBXMultiStatementResultSetIterator 
		on: aConnection querySettings: aQuerySettings.
	^ multiStatmentIterator
! !

!DBXBackend methodsFor:'options'!

getOption: anOption on: aConnection 
	"It asks the backend if an specific option is supported or not"
	| err isSupported |
	isSupported := WordArray with: 0.
	err := OpenDBX current 
		apiGetOption: aConnection handle
		option: anOption
		value: isSupported.
	self 
		verifyError: err
		on: aConnection.
	^ self dbxSmallIntegerAsBoolean: (isSupported first)
!

setNecessarySpecialOptions: aConnection 
	"This message will be called ALWAYS just before opening the connection. This can be used when you need to enable or disable ALWAYS a particular number of special options. The particular platform subclass can override this method to do this. For example, to get MySQL4 working, you always need to enable a special mode. Look for DBXMySQLBackend>>setNecessarySpecialOptions for an example"
	
!

setOption: anOption value: anObject on: aConnection 
	"It enables an specific option for a connection."
	| err value |
	(anObject class = True) ifTrue: [value := ByteArray with: anObject asBit ].
	(anObject class = False) ifTrue: [value := ByteArray with: anObject asBit ].
	(anObject class = SmallInteger) ifTrue: [value := ByteArray with: anObject].
	(anObject class = ByteString) ifTrue: [value := anObject ].
	err := OpenDBX current
				apiSetOption: aConnection handle
				option: anOption
				value: value.
	self verifyError: err on: aConnection
! !

!DBXBackend methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self name.
! !

!DBXBackend methodsFor:'private'!

dbxSmallIntegerAsBoolean: aSmallInteger 
	aSmallInteger = 1 ifTrue: [ ^ true ].
	aSmallInteger = 0 ifTrue: [ ^ false ].
	OpenDBXDriverError signal: 'Cannot convert form SmallInteger to Boolean'
!

setDateStyleOn: aDBXConnection 
	"Do nothing, only is implemented in the platform where dbx need a special format"
! !

!DBXBackend methodsFor:'query'!

executeStatement: aQuery on: aConnection 
	"It executes the query using the connection and retrieve al rows at once (no pagination is used). 
	
There are some important things:

    * this method returns a DBXResultSet if it was a select statement and a DBXResult in case the query was an update, delete, insert, create, drop or any other DML query.
    * The queries sent to the server must be understood by the DBMS because there is no translation done between the different dialects of SQL for example. But this is desired!! It adds no further level of complexity to the library and your program which slows down your real work. Usually only a few statements with varying values are used in programs and the easiest way make them adaptable to different databases by the users is to get them from a configuration file, strategy pattern or whatever. "

	^self executeStatement: aQuery on: aConnection querySettings: DBXQuerySettings default.
!

executeStatement: aString on: aConnection querySettings: aQuerySettings 
	"After executing a query, we will then want to retrieve the results. It may be possible to retrieve all rows at once, one by one or more than one row at once. All positive values including zero are allowed as values for a page size. As this is a special option that not all the engines support you must enable this feature using DBXConnection #enablePagedResults. If paging (more than one row at once) is not supported by the backend, it will use 'one by one' or 'all at once' if this is the only option provided."
	| err result encodedQuery |
	encodedQuery := (aConnection encodeString: aString).
	err := OpenDBX current
				apiQuery: aConnection handle
				query: encodedQuery
				length: encodedQuery size.
	self log: 'odbx_query: called with values: handle = ', aConnection handle asString, ' query = ', aString.
	self verifyError: err on: aConnection.
	result := self processNextResultSet: aConnection querySettings: aQuerySettings.

	"If the result is a DBXResult, I must end the resultset. If the result is nil, it will probably 	be a query of transaction, like begin transaction or rollback"
	(result isNil not and: [ result isResult]) 
		ifTrue: [ self endDBXResult: aConnection querySettings: aQuerySettings. ].
	^ result.
! !

!DBXBackend methodsFor:'resultSet'!

endDBXResult: aConnection querySettings: aQuerySettings
	"Releases all query resultsSets a query may return by iterating them.
	Each resultSet is Closed and all allocated memory by the OpenDBX
	library is freed ."
	| resultCode |	
	[self
		nextResultSet: aConnection
		querySettings:  aQuerySettings
		onReturn: [:handle :code | 
			code = OpenDBX resultWithRows
				ifTrue: [ self releaseResultSet: handle connection: aConnection  ].
			resultCode := code]]
	doWhileFalse: [resultCode = OpenDBX resultDone].
	
!

fieldRawValue: anIndex on: aResultSet
	"Returns the value of the column at anIndex of the current row from aResultSet"
	| value |
	value := OpenDBX current apiQueryFieldValue: (aResultSet handle) index: (anIndex - 1).
	^value isNil ifTrue:[value] ifFalse:[aResultSet connection decodeString: value].
!

largeFieldRawValue: anIndex on: aResultSet
	self halt: 'not yet implemented'.
!

moveNext: aResultSet 
	"Moves the aResultSet one more row and this row is returned."
	| err |
	err := OpenDBX current apiQueryFetchRow: aResultSet handle.
	self log: ['odbx_row_fetch: called with values: resultSet handle = ', aResultSet handle asString].
	self log: ['odbx_row_fetch call returned ', err asString].
	self verifyError: err on: aResultSet connection.
	err = OpenDBX rowDone
		ifTrue: [ ^ nil ]
		ifFalse: [^ DBXRow on: aResultSet]
!

nextResultSet: aResultSet ifDone: aBlock
	"Returns the next resultSet from the last resultSet. When there is no more resultSets, 
	the block is evaluated." 
	^ self
		nextResultSet: aResultSet connection
		querySettings: aResultSet querySettings
		onReturn: [:handle :code | code = OpenDBX resultDone
				ifTrue: [aBlock value]]
!

nextResultSet: aConnection querySettings: aQuerySettings onReturn: aBlock 
	"Returns the next resultSet from the last resultSet. When there is no more resultSets, 
	the block is evaluated." 
	| handle err handleArray |
	handleArray := WordArray with: 0.

	err := OpenDBX current
				apiQueryResult: aConnection handle
				handle: handleArray
				timeout: aQuerySettings timeoutAsDBXTimeSpec
				chunk: aQuerySettings pageSize.
	self log: [
		'odbx_result: called with values:',
			' handle = ', aConnection handle asString, 
			' chunk = ', aQuerySettings pageSize asString,
			String cr, 
		'odbx_result call return: ', err asString ].
	
	self verifyError: err on: aConnection.
	handle := handleArray first.
	self log: [ 'odbx_result resultSet handle returned: ', handle asString ].
	aBlock notNil
		ifTrue: [aBlock value: handle value: err].
	^ handle
!

processNextResultSet: aConnection querySettings: aQuerySettings
	"Gets the next resultSet of the query. Depending on the type of query, it will return a DBXResult or DBXResultSet.
	If there is a timeout, it will cicle till this is finished."
	| returnCode |
	[self
		nextResultSet: aConnection
		querySettings: aQuerySettings
		onReturn: [:handle :code | 
			returnCode := code.
			code = OpenDBX resultWithRows
				ifTrue: [ ^ self processResultWithRows: aConnection
					 resultHandle: handle 
					querySettings: aQuerySettings].
			code = OpenDBX resultWithoutRows
				ifTrue: [ ^ self processResultWithoutRows: aConnection
					 resultHandle: handle
					 querySettings: aQuerySettings].
			code = OpenDBX resultDone ifTrue: [^ nil].
			
			(code = OpenDBX resultTimeout) ifTrue: [ (Delay forMilliseconds: (aQuerySettings timeout asMiliseconds)) wait  ].
			
			]] 	doWhileTrue: [returnCode = OpenDBX resultTimeout].
		
		OpenDBXDriverError signal: 'Uknown problem with executeStatement'.
!

processResultWithRows: aConnection resultHandle: aHandle querySettings: aQuerySettings	
	"Process a result with rows and returns a DBXResultSet"
	| description |
	description := self descriptionForResultSet: aHandle on: aConnection.
	^ DBXResultSet
		on: aConnection
		handle: aHandle
		description: description
		querySettings: aQuerySettings	
	
!

processResultWithoutRows: aConnection resultHandle: aHandle querySettings: aQuerySettings	
	"Process a query with a result without rows and returns a DBXResult"
	| description err |
	description := self descriptionForResult: aHandle on: aConnection.
	err := OpenDBX current apiQueryFinalize: aHandle.
	self log: [ 'odbx_result_finish: called with values: resultSet handle = ', aHandle asString ].			
	self log: [ 'odbx_result_finish call returned ', err asString ].
	^ DBXResult
		on: aConnection
		handle: aHandle
		description: description
		querySettings: aQuerySettings.
!

queryDelimiter
	" Returns the delimiter of the query. For example, ';' . But this depends on the backend"
	^self subclassResponsibility
!

releaseAllQueryResultSets: aResultSet 
	"Releases all query resultsSets a query may return by iterating them.
	Each resultSet is Closed and all allocated memory by the OpenDBX
	library is freed ."
	self releaseResultSet: aResultSet.
	self endDBXResult: aResultSet connection querySettings: aResultSet querySettings
!

releaseResultSet: aResultSet 
	"Closes a resultSet and all allocated memory by the OpenDBX library is
	freed . In case you want to realese all query resultSets, yo must call
	realeseAllQueryResultSets: "
	self releaseResultSet: aResultSet handle connection: aResultSet connection
!

releaseResultSet: aResultSetHandle connection: aConnection
	"Closes a resultSet and all allocated memory by the OpenDBX library is
	freed . In case you want to realese all query resultSets, yo must call
	realeseAllQueryResultSets: "
	| err |
	err := OpenDBX current apiQueryFinalize: aResultSetHandle.
	self log: [ 'odbx_result_finish: called with values: resultSet handle = ', aResultSetHandle asString ].
	self verifyError: err on: aConnection
! !

!DBXBackend methodsFor:'testing'!

supportsLargeObjects
	^true
! !

!DBXBackend methodsFor:'transactional manage'!

commit
	"If a certain backend doesn't use this sintax, it must subclass and override this method."
	^ 'COMMIT'
!

commit: aConnection
	"executes a commit statement on a connection"
	^self executeStatement: self commit on: aConnection.
!

rollback
	"If a certain backend doesn't use this sintax, it must subclass and override this method."
	^ 'ROLLBACK'
!

rollback: aConnection
	"executes a rollback statement on a connection"
	^self executeStatement: self rollback on: aConnection.
!

startTransaction
	"It returns the start transaction statement most commonly used by the backends. If a certain backend
	doesn't use this sintax, it must subclass and override this method."
	^'START TRANSACTION'
!

startTransaction: aConnection
	"Starts a transaction on a connection"
	^self executeStatement: self startTransaction on: aConnection.
! !

!DBXBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXBackend.st,v 1.2 2013-04-15 13:12:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXBackend.st,v 1.2 2013-04-15 13:12:28 cg Exp $'
! !


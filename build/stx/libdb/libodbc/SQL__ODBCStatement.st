"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/libodbc' }"

"{ NameSpace: SQL }"

Statement subclass:#ODBCStatement
	instanceVariableNames:'session statementText columnDescriptions parameterDescriptions
		bindingBuffers'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

Object subclass:#BindingsBuffer
	instanceVariableNames:'columnIndex columnDescriptor smalltalkClass size sqlType
		valueBuffer sizeBuffer cType colSize'
	classVariableNames:'SqlTypeMapping'
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#BooleanBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#ByteArrayBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#DateBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#FloatBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#IntegerBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#NumberBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#ShortIntegerBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#StringBuffer
	instanceVariableNames:'characterEncoder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#TimeBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#TimestampBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#UUIDBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

ODBCStatement::BindingsBuffer subclass:#Unicode16StringBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCStatement
!

!ODBCStatement class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
    Please consult the examples in SQL::ODBCSession
"
! !

!ODBCStatement class methodsFor:'instance creation'!

newForSession:aSession
    |newStatement|

    newStatement := self new.
    newStatement session:aSession.
    ^ newStatement
!

newForSession:aSession text:aStatementTextString
    |newStatement|

    newStatement := self newForSession:aSession.
    newStatement prepare:aStatementTextString.
    ^ newStatement
! !

!ODBCStatement methodsFor:'accessing'!

session
    ^ session
!

text:sqlString
    "use #prepare: to change the text of an existing statement"

    columnDescriptions notEmptyOrNil ifTrue:[
        "there is an open cursor"
        self closeCursor.
    ].
    bindingBuffers := columnDescriptions := nil.
    statementText := sqlString.
! !

!ODBCStatement methodsFor:'binding support'!

bindColumnDescriptions
    "Allocate result buffers and 
     bind the columnDescriptions that describe the select result columns to them.
     Answer the result buffers."

    bindingBuffers isNil ifTrue:[
        bindingBuffers := self columnDescriptions collect:[:eachColumnDescription|
            eachColumnDescription bindingsBufferForStatement:self.
        ].
    ].
    ^ bindingBuffers.
!

bindParameters:valueCollection 
    "bind values"

    bindingBuffers isEmptyOrNil ifTrue:[
        bindingBuffers := BindingsBuffer 
                            buffersFromRow:(valueCollection first) 
                            withColumnDescriptions:self parameterDescriptions.
    ].
    bindingBuffers do:[:eachBindParam | 
        eachBindParam
            allocateAndFillBufferForValues:valueCollection;
            sqlBindParameterForStatement:self handle:handle type:#'SQL_PARAM_INPUT'.
    ].
!

bindVariable:columnIndex as:aSmalltalkClassOrSQLTypeSymbol size:sizeOrNil
    |buffer columnDescriptor|

    self assert:(columnIndex isInteger).

    columnDescriptor := self columnDescriptions at:columnIndex.

    aSmalltalkClassOrSQLTypeSymbol isSymbol ifTrue:[
        columnDescriptor sqlType:aSmalltalkClassOrSQLTypeSymbol.
    ] ifFalse:[aSmalltalkClassOrSQLTypeSymbol isBehavior ifTrue:[
        columnDescriptor stType:aSmalltalkClassOrSQLTypeSymbol. 
    ] ifFalse:[
        self error:'class or sqlTypeSymbol expected'
    ]].

    bindingBuffers notNil ifTrue:[
        "have to adapt buffer, if already present"
        buffer := BindingsBuffer bufferForColumnDescriptor:columnDescriptor.
        buffer size:sizeOrNil.

        bindingBuffers size < columnIndex ifTrue:[
            bindingBuffers isNil ifTrue:[
                bindingBuffers := OrderedCollection new:columnIndex.
            ].
            bindingBuffers grow:columnIndex
        ].
        bindingBuffers at:columnIndex put:buffer.
    ].
!

bulkInsertInto:tableName columnNames:aColOfColumnNames values:aColOfValues
    |buffers|

    buffers := BindingsBuffer 
                    buffersFromRow:aColOfValues first 
                    withColumnDescriptions:self parameterDescriptions.
    buffers do:[:eachBuffer |
        eachBuffer allocateAndFillBufferForValues:aColOfValues.
    ].

    ^ handle bulkInsertInto:tableName columnNames:aColOfColumnNames values:aColOfValues bufferBindings:buffers.


"
self new 
  bulkInsertInto:'employee' 
  columnNames:#('EmpName' 'Salary' 'Dept') 
  values:#(
      ( 'aaaa' 1000.0 'AAA' )
      ( 'bbbb' 2000.0 'BBB' )
      ( 'cccc' 3000.0 'CCC' )
      ( 'dddd' 4000.0 'DDD' )
      ( 'eeee' 5000.0 'EEE' )
  ).

"
!

preferWideChar:aBoolean
    "prefer fetching with wide characters.
     All strings will be returned as Unicode16Strings.

     This method must be re-issued when the statement
     gets a new statement text."

    self columnDescriptions do:[:each|
        each preferWideChar:aBoolean.
    ].
!

sqlDescribeCol:colNr
    "returns a value - not a returnCode"

    ^ handle sqlDescribeCol:colNr
!

sqlDescribeParam:paramNr
    "describe the parameters of a prepared statement.
     Unfortunately, most database drives do not support this or return dummy data.
     Returns a value - not a returnCode"

    ^ handle sqlDescribeParam:paramNr
!

sqlFetch
    |ret|

    ret := handle sqlFetch.
    ret isNoData ifFalse:[
        "this is a noo-op if ret is success"
        ret performErrorHandlingFor:handle statement:self.
    ].

    ^ ret
!

sqlNumParams
    "answer the number of parameters of a prepared statement.
     Returns a value - not a returnCode"

    ^ handle sqlNumParams
!

sqlNumResultCols
    "returns a value - not a returnCode"

    ^ handle sqlNumResultCols
! !

!ODBCStatement methodsFor:'column descriptions'!

columnDescriptions
    "answer the description of the columns affected by the statement.
     ColumnDescruptions are available after a prepare (or executeDirect, which does an implicit prepare).
     ColumnDescriptions are available only for select statements."

    |rowSize|

    columnDescriptions isNil ifTrue:[
        rowSize := self sqlNumResultCols.
        (rowSize == 0 or:[rowSize isNil]) ifTrue:[
            "if rowSize is nil, this is not a select statement"
            ^ #().
        ].
        columnDescriptions := Array new:rowSize.
        1 to:rowSize do:[:idx | columnDescriptions at:idx put:(self sqlDescribeCol:idx) ].
    ].
    ^ columnDescriptions
!

columnDescriptorAt:columnNameString
    "return the value of the columnDescriptor named columnNameString"

    ^ self columnDescriptions 
        detect:[:col | col name sameAs:columnNameString]
        ifNone:nil.
!

columnDescriptorAtIndex:columnIndex
    "return the value of the columnDescriptor at columnIndex"

    ^ self columnDescriptions at:columnIndex ifAbsent:nil.
!

columnNames
    "answer an array containing the column names of the query"

    ^ self columnDescriptions collect:[:aDesc | aDesc name asSymbol]
!

parameterDescriptions
    "answer the description of the parameters used by the statement.
     ParameterDescriptions are available after a prepare (or executeDirect, which does an implicit prepare).
     ParameterDescriptions are available only for statements with parameters."

    |numParams|

    parameterDescriptions isNil ifTrue:[
        numParams := self sqlNumParams.
        (numParams == 0 or:[numParams isNil]) ifTrue:[
            "if rowSize is nil, there are no parameters"
            ^ #().
        ].
        parameterDescriptions := Array new:numParams.
        1 to:numParams do:[:idx | parameterDescriptions at:idx put:(self sqlDescribeParam:idx) ].
    ].
    ^ parameterDescriptions
!

parameterDescriptorAt:columnNameString
    "return the value of the parameterDescriptions named columnNameString"

    ^ self parameterDescriptions 
        detect:[:col | col name sameAs:columnNameString]
        ifNone:nil.
!

parameterDescriptorAtIndex:columnIndex
    "return the value of the parameterDescriptions at columnIndex"

    ^ self parameterDescriptions at:columnIndex ifAbsent:nil.
! !

!ODBCStatement methodsFor:'execution'!

execute
    "executes a statement. The statement must have been prepared first"

    |ret|

    ret := handle sqlExecute.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.

    ^ ODBCCursor new statement:self.
!

executeBulk
    "executes a statement. The statement must have been prepared first"

    |ret|

    ret := handle sqlBulkExecute.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.

    ^ ODBCCursor new statement:self.
!

executeDirect
    "executes a statement."

    |ret|

    ret := handle sqlExecuteDirect:statementText.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.
    ^ ODBCCursor new statement:self.
!

executeDirect:aStatementString
    "executes a statement."

    ^ self 
        text:aStatementString;
        executeDirect.
!

executeDirectOn:aSession
    "executes a statement, possibly on another session.
     This is not allowed with ODBC (it might be with other databases)"

    session ~~ aSession ifTrue:[
        session notNil ifTrue:[
            self error:'cannot change session, after the handle was created'.
        ].
        self session:aSession.
    ].
    ^ self executeDirect.
!

executeDirectOn:aSession with:valueCollection
    "executes a statement, possibly on another session.
     This is not allowed with ODBC (it might be with other databases)"

    session ~~ aSession ifTrue:[
        session notNil ifTrue:[
            self error:'cannot change session, after the handle was created'.
        ].
        self session:aSession.
    ].
    ^ self executeDirectWith:valueCollection.
!

executeDirectWith:valueCollection 
    "executes a statement passing data."
    
    |numRows|

    numRows := valueCollection size.
    numRows ~~ 1 ifTrue:[
        false ifTrue:[
            "/ THE FOLLOWING DOES NOT WORK (I dont know why...).
            self setSqlStatementOption:#'SQL_ATTR_PARAMSET_SIZE' value:numRows.
        ] ifFalse:[
            "/ for now, only allow for single rows to be passed down.
            valueCollection do:[:eachRow | 
                self executeDirectWith:(Array with:eachRow)
            ].
            ^ self.
        ]
    ].
    self bindParameters:valueCollection.
    ^ self executeDirect.
!

executeNoCursor
    "executes a statement. The statement must have been prepared first"

    |ret|

    ret := handle sqlExecute.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.
!

executeOn:aSession
    "executes a statement, possibly on another session.
     The statement must have been prepared first
     This is not allowed with ODBC (it might be with other databases)"

    session ~~ aSession ifTrue:[
        session notNil ifTrue:[
            self error:'cannot change session, after the handle was created'.
        ].
        self session:aSession.
    ].
    ^ self execute.
!

executeOn:aSession with:valueCollection
    "executes a statement, possibly on another session.
     The statement must have been prepared first
     This is not allowed with ODBC (it might be with other databases)"

    session ~~ aSession ifTrue:[
        session notNil ifTrue:[
            self error:'cannot change session, after the handle was created'.
        ].
        self session:aSession.
    ].
    ^ self executeWith:valueCollection.
!

executeWith:valueCollection 
    "executes a statement passing data. The statement must have been prepared first"
    
    |numRows cursor|

    numRows := valueCollection size.
    numRows > 1 ifTrue:[
        false ifTrue:[
            "/ THE FOLLOWING DOES NOT WORK (I don't know why...).
            self 
                setSqlStatementOption:#SQL_ATTR_CURSOR_TYPE value:(ODBCHandle SQL_CURSOR_DYNAMIC);
                setSqlStatementOption:#SQL_ATTR_ROW_BIND_TYPE value:(ODBCHandle SQL_BIND_BY_COLUMN);
                setSqlStatementOption:#SQL_ATTR_ROW_STATUS_PTR value:nil;
                setSqlStatementOption:#SQL_ATTR_ROWS_FETCHED_PTR value:nil;
                setSqlStatementOption:#'SQL_ATTR_ROW_ARRAY_SIZE' value:numRows;
                setSqlStatementOption:#'SQL_ATTR_PARAMSET_SIZE' value:numRows.
        ] ifFalse:[
            "/ for now, only allow for single rows to be passed down.
            valueCollection do:[:eachRow | 
                self bindParameters:(Array with:eachRow).
                cursor isNil ifTrue:[
                    cursor := self execute.
                ] ifFalse:[
                    self executeNoCursor.
                ].
            ].
            ^ cursor.
        ]
    ].
    self bindParameters:valueCollection.
    ^ self execute.
!

prepare
    |ret|

    ret := handle sqlPrepare:statementText.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.
!

prepare:statementString
    self
        text:statementString;
        prepare
! !

!ODBCStatement methodsFor:'new'!

session:aSession
    session := aSession.
    handle := session serverHandle newStatementHandle.
! !

!ODBCStatement methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    statementText printOn:aStream.
    aStream nextPut:$).

    "Modified: / 23-05-2012 / 10:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ODBCStatement methodsFor:'private'!

getHandle
    ^ handle

!

setSqlStatementOption:optionSymbol value:value
    |ret|

    ret := handle sqlSetStatementOption:optionSymbol value:value.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.
! !

!ODBCStatement methodsFor:'queries'!

columnsInCatalog:catalogPattern schema:schemaPattern table:tablePattern column:columnPattern
    "list columns - return a cursor to enumerate the result"

    |ret|

    ret := handle sqlColumnsInCatalog:catalogPattern schema:schemaPattern table:tablePattern column:columnPattern.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.

    ^ ODBCCursor new statement:self.
!

primaryKeysInCatalog:catalogPattern schema:schemaPattern table:tablePattern
    "list primaryKeysI - return a cursor to enumerate the result"

    |ret|

    ret := handle sqlPrimaryKeysInCatalog:catalogPattern schema:schemaPattern table:tablePattern.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.

    ^ ODBCCursor new statement:self.
!

tablesInCatalog:catalogPattern schema:schemaPattern table:tablePattern type:typePattern
    "list tables - return a cursor to enumerate the result"

    |ret|

    ret := handle sqlTablesInCatalog:catalogPattern schema:schemaPattern table:tablePattern type:typePattern.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:self.

    ^ ODBCCursor new statement:self.
! !

!ODBCStatement methodsFor:'release'!

closeCursor
    "Close the cursor.
     All the prefetched data is discarded.
     The statement can be executed again with the same or different text."

    handle sqlCloseCursor.
!

release
    "release the statement.
     It is no longer valid"

    |h|

    h := handle.
    handle := nil.
    h release.
    session := statementText := bindingBuffers := columnDescriptions := nil.
! !

!ODBCStatement::BindingsBuffer class methodsFor:'initialization'!

initialize
    SqlTypeMapping := IdentityDictionary new.
    self allSubclasses do:[:eachSubClass|
        |sqlTypes|
        sqlTypes := eachSubClass sqlTypes.
        sqlTypes do:[:eachSqlType|
            SqlTypeMapping at:eachSqlType put:eachSubClass
        ]
    ].

    "
        self initialize.
        SqlTypeMapping inspect.
    "
!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ self subclassResponsibility
! !

!ODBCStatement::BindingsBuffer class methodsFor:'instance creation'!

bufferForColumnDescriptor:aColumnDescriptor
    |smalltalkClass columnType bufferClass typeSymbol|

    smalltalkClass := aColumnDescriptor stType.
    columnType := aColumnDescriptor sqlType.
    (aColumnDescriptor preferWideChar not and:[smalltalkClass notNil]) ifTrue:[
        typeSymbol := smalltalkClass odbcTypeSymbol.
    ] ifFalse:[
        typeSymbol := columnType.
    ].

    bufferClass := SqlTypeMapping at:typeSymbol ifAbsent:nil.
    bufferClass isNil ifTrue:[
        KeyNotFoundError raiseWith:typeSymbol errorString:'unsupported odbc sql type: ', typeSymbol
    ].
    ^ bufferClass new
            columnIndex:aColumnDescriptor index
            columnDescriptor:aColumnDescriptor
            sqlType:typeSymbol.
!

buffersFromRow:aRowWithValues withColumnDescriptions:columnDescriptions
    "allocate binding buffers for a statement's parameters.
     Find out the binding type from the data passed"

    |buffers|

    buffers := Array new:columnDescriptions size.
    columnDescriptions keysAndValuesDo:[:colNr :eachColumnDescriptor |
        eachColumnDescriptor stType:(aRowWithValues at:colNr) class.
        buffers 
            at:colNr 
            put:(self bufferForColumnDescriptor:eachColumnDescriptor)
    ].
    ^ buffers
! !

!ODBCStatement::BindingsBuffer methodsFor:'accessing'!

columnIndex
    ^ columnIndex
!

columnIndex:columnIndexArg columnDescriptor:columnDescriptorArg sqlType:aSqlTypeSymbol
    columnIndex := columnIndexArg.
    columnDescriptor := columnDescriptorArg.
    sqlType := aSqlTypeSymbol.
    colSize := columnDescriptorArg columnSize.
"/    size := sizeOrNil.
!

size
    ^ size
!

size:something
    size := something.
!

sizeBuffer
    ^ sizeBuffer
!

smalltalkClass
    ^ smalltalkClass
!

smalltalkClass:smalltalkClassArg
    smalltalkClass := smalltalkClassArg.
!

sqlCType
    ^ cType
!

sqlColSize
    ^ colSize
!

sqlScale
    ^ 0
!

sqlType
    ^ sqlType
!

sqlType:anSqlType
    sqlType := anSqlType.
!

valueBuffer
    ^ valueBuffer
!

valueBufferSize
    ^ valueBuffer size
! !

!ODBCStatement::BindingsBuffer methodsFor:'binding support'!

allocateAndFillBufferForValues:valueCollection
    |intSize valueBufferIndex sizeBufferIndex|

    self
        setupForValues:valueCollection;
        allocateBuffer:valueCollection size.

    sqlType isNil ifTrue:[
        sqlType := self class sqlTypes at:1.
    ].

    valueBufferIndex := sizeBufferIndex := 1.

    intSize := ODBCHandle sizeofSqlLen.
    valueCollection do:[:eachRow |
        |value length|

        value := eachRow at:columnIndex.
        value isNil ifTrue:[
            length := ODBCHandle SQL_NULL_DATA.
        ] ifFalse:[
            length := self
                        encode:value
                        into:valueBuffer
                        at:valueBufferIndex.
            valueBufferIndex := valueBufferIndex + length.
        ].

        sizeBuffer nativeIntAt:sizeBufferIndex put:length.
        sizeBufferIndex := sizeBufferIndex + intSize.
    ].
!

allocateBuffer:numRows
    "allocate a buffer for numRows rows"

    |numBytes intSize|

    intSize := ODBCHandle sizeofSqlLen.

    (colSize isNil or:[colSize == 0]) ifTrue:[
        colSize := ODBCHandle cSizeOf:cType.
    ].
    numBytes := numRows * colSize.
    valueBuffer size < numBytes ifTrue:[
        valueBuffer := ExternalBytes unprotectedNew:numBytes.
    ].
    sizeBuffer size < (intSize * numRows) ifTrue:[
        sizeBuffer := ExternalBytes unprotectedNew:(intSize * numRows).
    ].
!

setupForValues:valueCollection
    ^ self subclassResponsibility
!

sqlBindColForStatement:statement handle:handle
    |ret|

    ret := handle
            sqlBindCol:columnIndex
            cType:cType
            columnSize:colSize
            valueBuffer:valueBuffer
            sizeInfo:sizeBuffer.

    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:statement.
!

sqlBindParameterForStatement:statement handle:handle type:sqlBindTypeSymbol
    |ret|

    ret := handle
            sqlBindParameter:columnIndex
            type:sqlBindTypeSymbol
            cType:cType
            sqlType:sqlType
            columnSize:colSize
            scale:self sqlScale
            valueBuffer:valueBuffer
            sizeInfo:sizeBuffer.

    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:handle statement:statement.
! !

!ODBCStatement::BindingsBuffer methodsFor:'encoding & decoding'!

decode
    |nBytes bufferOffset|

    bufferOffset := 1.
    nBytes := sizeBuffer nativeIntAt:bufferOffset.
    nBytes = ODBCHandle SQL_NULL_DATA ifTrue:[
        ^ nil.
    ].
    ^ self decodeAt:bufferOffset size:nBytes.
!

decodeAt:bufferOffset size:nBytes
   "decode a value from a buffer at bufferOffset with size nBytes"

    ^ self subclassResponsibility
!

encode:anObject into:buffer at:bufferOffset
    ^ self subclassResponsibility
! !

!ODBCStatement::BindingsBuffer methodsFor:'printing'!

printOn:aStream
   aStream 
        nextPutAll:self class shortName;
        nextPut:$(.
    
   columnIndex printOn:aStream.
   aStream nextPutAll:', '. 
   smalltalkClass printOn:aStream.
   aStream nextPutAll:', '. 
   size printOn:aStream.
   aStream nextPutAll:', '. 
   sqlType printOn:aStream.
   aStream nextPutAll:', '. 
   valueBuffer printOn:aStream.
   aStream nextPutAll:', '. 
   sizeBuffer printOn:aStream.
   aStream nextPutAll:', '. 
   cType printOn:aStream.
   aStream nextPutAll:', '. 
   colSize printOn:aStream.
   aStream nextPut:$).
! !

!ODBCStatement::BooleanBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_BIT')
! !

!ODBCStatement::BooleanBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    ^ (valueBuffer byteAt:bufferOffset) ~= 0.
!

encode:aBoolean into:buffer at:bufferOffset
    buffer byteAt:bufferOffset put:(aBoolean ifTrue:[1] ifFalse:[0]).
    ^ colSize
! !

!ODBCStatement::BooleanBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_BIT.
    colSize := 1.
! !

!ODBCStatement::ByteArrayBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_BINARY' #'SQL_VARBINARY' #'SQL_LONGVARBINARY')
! !

!ODBCStatement::ByteArrayBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    nBytes > 0 ifTrue:[
        value := (ByteArray new:nBytes)
                replaceBytesFrom:1 to:nBytes with:valueBuffer startingAt:bufferOffset.
    ] ifFalse:[
        value := #[].
    ].
    (smalltalkClass notNil and:[smalltalkClass ~~ ByteArray]) ifTrue:[
        ^ smalltalkClass fromBytes:value.
    ].
    ^ value.
!

encode:aByteArray into:buffer at:bufferOffset
    |nBytes|

    nBytes := aByteArray size.
    nBytes > 0 ifTrue:[
        buffer replaceBytesFrom:bufferOffset to:(bufferOffset+nBytes-1) with:aByteArray startingAt:1.
    ].
    ^ nBytes
! !

!ODBCStatement::ByteArrayBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_BINARY.

    size notNil ifTrue:[
        colSize := size.
    ] ifFalse:[
        "/ compute from longest value
        valueCollection notEmptyOrNil ifTrue:[
            colSize := valueCollection
                inject:0
                into:
                    [:maxSoFar :eachRow |
                        maxSoFar max:(eachRow at:columnIndex) size
                    ].
        ].
    ].
! !

!ODBCStatement::DateBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_DATE' #'SQL_TYPE_DATE')
! !

!ODBCStatement::DateBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |year month day|

    year := valueBuffer unsignedShortAt:bufferOffset.
    month := valueBuffer unsignedShortAt:bufferOffset+2.
    day := valueBuffer unsignedShortAt:bufferOffset+4.
    ^ (smalltalkClass ? Date) year:year month:month day:day.
!

encode:aTime into:buffer at:bufferOffset
    buffer unsignedShortAt:bufferOffset+0 put:(aTime hours).
    buffer unsignedShortAt:bufferOffset+2 put:(aTime minutes).
    buffer unsignedShortAt:bufferOffset+4 put:(aTime seconds).
    ^ colSize
! !

!ODBCStatement::DateBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_DATE.
    colSize := 8.
! !

!ODBCStatement::FloatBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_DOUBLE' #'SQL_FLOAT' #'SQL_REAL')
! !

!ODBCStatement::FloatBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    ^ valueBuffer doubleAt:bufferOffset.
!

encode:aDouble into:buffer at:bufferOffset
    buffer doubleAt:bufferOffset put:aDouble.
    ^ colSize
! !

!ODBCStatement::FloatBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_DOUBLE.
    colSize := 8.
! !

!ODBCStatement::IntegerBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_INTEGER' #'SQL_BIGINT')
! !

!ODBCStatement::IntegerBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    cType == #'SQL_C_LONG' ifTrue:[
        value := valueBuffer longAt:bufferOffset.
    ] ifFalse:[cType == #'SQL_C_CHAR' ifTrue:[
        nBytes > 0 ifTrue:[
            value := (String new:nBytes)
                    replaceBytesFrom:1 to:nBytes with:valueBuffer startingAt:bufferOffset.
            value := Integer readFrom:value onError:[ConversionError raiseRequestWith:value].
        ] ifFalse:[
            value := 0.
        ].
    ]].
    smalltalkClass == Boolean ifTrue:[
        ^ value ~~ 0
    ].
    ^ value.
!

encode:anInteger into:buffer at:bufferOffset
    |string nBytes|

    cType == #'SQL_C_LONG' ifTrue:[
        buffer longAt:bufferOffset put:anInteger.
        ^ colSize
    ].
    string := anInteger printString.
    nBytes := string size.
    buffer replaceBytesFrom:bufferOffset to:(bufferOffset+nBytes-1) with:string startingAt:1.
    ^ nBytes
! !

!ODBCStatement::IntegerBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_LONG.
    colSize := 4.

    valueCollection do:[:eachRow |
        |value numBytes|

        value := eachRow at:columnIndex.
        value notNil ifTrue:[
            numBytes := value digitLength.
            numBytes > 4 ifTrue:[
                cType := #SQL_C_CHAR.
                numBytes > 8 ifTrue:[
                    colSize := 128.
                ] ifFalse:[
    "/ DOES NOT WORK correctly (at least, with MYODBC)
    "/                cType := #SQL_C_SBIGINT.
    "/                colSize := 8.
                    colSize := 32.
                ].
            ].
        ].
    ].
! !

!ODBCStatement::NumberBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_NUMERIC' #'SQL_FIXEDPOINT' #'SQL_DECIMAL')
! !

!ODBCStatement::NumberBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    nBytes > 0 ifTrue:[
        value := (String new:nBytes)
                replaceBytesFrom:1 to:nBytes with:valueBuffer startingAt:bufferOffset.
        value := (smalltalkClass ? Number) readFrom:value onError:[ConversionError raiseRequestWith:value].
    ] ifFalse:[
        value := 0.
    ].
    smalltalkClass == Boolean ifTrue:[
        ^ value ~~ 0
    ].
    ^ value.
!

encode:aNumber into:buffer at:bufferOffset
    |string nBytes|

    string := aNumber printString.
    nBytes := string size.
    buffer replaceBytesFrom:bufferOffset to:(bufferOffset+nBytes-1) with:string startingAt:1.
    ^ nBytes
! !

!ODBCStatement::NumberBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_CHAR.
    colSize := 128.
! !

!ODBCStatement::ShortIntegerBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_SMALLINT' #'SQL_TINYINT')
! !

!ODBCStatement::ShortIntegerBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    value := valueBuffer shortAt:bufferOffset.
    smalltalkClass == Boolean ifTrue:[
        ^ value ~~ 0
    ].
    ^ value.
!

encode:anInteger into:buffer at:bufferOffset
    buffer shortAt:bufferOffset put:anInteger.
    ^ colSize
! !

!ODBCStatement::ShortIntegerBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_SHORT.
    colSize := 2.
! !

!ODBCStatement::StringBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_CHAR' #'SQL_VARCHAR' #'SQL_LONGVARCHAR')
! !

!ODBCStatement::StringBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    nBytes > 0 ifTrue:[
        value := (String new:nBytes)
                replaceBytesFrom:1 to:nBytes with:valueBuffer startingAt:bufferOffset.
    ] ifFalse:[
        value := ''.
    ].
    smalltalkClass notNil ifTrue:[
        smalltalkClass == Boolean ifTrue:[
            ^ columnDescriptor decodeStringAsBoolean:value.
        ].
        smalltalkClass ~~ String ifTrue:[
            ^ smalltalkClass fromBytes:value.
        ].
    ].
    ^ value.
!

encode:anObject into:buffer at:bufferOffset
    |string nBytes|

    string := anObject asString.
    characterEncoder notNil ifTrue:[
        string := characterEncoder encodeString:string.
    ].

    nBytes := string size.
    nBytes > 0 ifTrue:[
        "/ buffer stringAt:bufferOffset put:s size:colSize.
        buffer replaceBytesFrom:bufferOffset to:(bufferOffset+nBytes-1) with:string startingAt:1.
    ].
    ^ nBytes
! !

!ODBCStatement::StringBuffer methodsFor:'setup'!

columnIndex:columnIndexArg columnDescriptor:columnDescriptorArg sqlType:aSqlTypeSymbol
    super columnIndex:columnIndexArg columnDescriptor:columnDescriptorArg sqlType:aSqlTypeSymbol.
    characterEncoder := columnDescriptorArg characterEncoder.
!

setupForValues:valueCollection
    cType := #SQL_C_CHAR.

    size notNil ifTrue:[
        colSize := size.
    ] ifFalse:[
        "/ compute from longest value
        valueCollection notEmptyOrNil ifTrue:[
            colSize := valueCollection
                inject:0
                into:
                    [:maxSoFar :eachRow |
                        |string|

                        string := eachRow at:columnIndex.
                        characterEncoder notNil ifTrue:[
                            string := characterEncoder encodeString:string.
                        ].
                        maxSoFar max:string size
                    ].
        ].
    ].
! !

!ODBCStatement::TimeBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_TYPE_TIME' #'SQL_TIME')
! !

!ODBCStatement::TimeBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |hour minute second|

    hour :=   valueBuffer unsignedShortAt:bufferOffset.
    minute := valueBuffer unsignedShortAt:bufferOffset+2.
    second := valueBuffer unsignedShortAt:bufferOffset+4.
    ^ (smalltalkClass ? Time) hours:hour minutes:minute seconds:second.
!

encode:aTime into:buffer at:bufferOffset
    buffer unsignedShortAt:bufferOffset+0 put:(aTime hours).
    buffer unsignedShortAt:bufferOffset+2 put:(aTime minutes).
    buffer unsignedShortAt:bufferOffset+4 put:(aTime seconds).
    ^ colSize
! !

!ODBCStatement::TimeBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_TIME.
    colSize := 6.
! !

!ODBCStatement::TimestampBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_TYPE_TIMESTAMP' #'SQL_TIMESTAMP' #'SQL_DATETIME')
! !

!ODBCStatement::TimestampBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |hour minute second year month day nanosecond|

    year :=       valueBuffer shortAt:bufferOffset.
    month :=      valueBuffer unsignedShortAt:bufferOffset+2.
    day :=        valueBuffer unsignedShortAt:bufferOffset+4.
    hour :=       valueBuffer unsignedShortAt:bufferOffset+6.
    minute :=     valueBuffer unsignedShortAt:bufferOffset+8.
    second :=     valueBuffer unsignedShortAt:bufferOffset+10.
    nanosecond := valueBuffer unsignedLongAt:bufferOffset+12.
    ^ (smalltalkClass ? Timestamp)
            year:year month:month day:day
            hour:hour minute:minute second:second millisecond:(nanosecond // 1000000).
!

encode:aTimestamp into:buffer at:bufferOffset
    |nanoseconds|

    buffer shortAt:bufferOffset+0 put:(aTimestamp year).
    buffer unsignedShortAt:bufferOffset+2 put:(aTimestamp month).
    buffer unsignedShortAt:bufferOffset+4 put:(aTimestamp day).
    buffer unsignedShortAt:bufferOffset+6 put:(aTimestamp hours).
    buffer unsignedShortAt:bufferOffset+8 put:(aTimestamp minutes).
    buffer unsignedShortAt:bufferOffset+10 put:(aTimestamp seconds).
    nanoseconds := aTimestamp milliseconds * 1000 * 1000.
    buffer unsignedLongAt:bufferOffset+12 put:nanoseconds.
    ^ colSize
! !

!ODBCStatement::TimestampBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_TIMESTAMP.
    colSize := 16.
! !

!ODBCStatement::UUIDBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(#'SQL_GUID')
! !

!ODBCStatement::UUIDBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    nBytes > 0 ifTrue:[
        value := UUID basicNew
                    replaceBytesFrom:1 to:nBytes with:valueBuffer startingAt:bufferOffset.
    ] ifFalse:[
        value := nil.
    ].
!

encode:aUUID into:buffer at:bufferOffset
    buffer replaceBytesFrom:bufferOffset to:(bufferOffset+colSize-1) with:aUUID startingAt:1.
    ^ colSize
! !

!ODBCStatement::UUIDBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_BINARY.
    colSize := 16.
! !

!ODBCStatement::Unicode16StringBuffer class methodsFor:'queries'!

sqlTypes
    "answer a collection of sqlTypes that I support"

    ^ #(SQL_WCHAR SQL_WVARCHAR SQL_WLONGVARCHAR 
        SQL_UNICODE SQL_UNICODE_VARCHAR SQL_UNICODE_LONGVARCHAR SQL_UNICODE_CHAR)
! !

!ODBCStatement::Unicode16StringBuffer methodsFor:'encoding & decoding'!

decodeAt:bufferOffset size:nBytes
    |value|

    nBytes > 0 ifTrue:[
        value := (Unicode16String new:nBytes//2)
                replaceBytesFrom:1 to:nBytes with:valueBuffer startingAt:bufferOffset.
    ] ifFalse:[
        value := ''.
    ].
    smalltalkClass == Boolean ifTrue:[
        ^ columnDescriptor decodeStringAsBoolean:value.
    ].
    ^ value.
!

encode:anObject into:buffer at:bufferOffset
    |string nBytes|

    string := anObject asString asUnicode16String.
    nBytes := string byteSize.
    nBytes > 0 ifTrue:[
        "/ buffer stringAt:bufferOffset put:s size:colSize.
        buffer replaceBytesFrom:bufferOffset to:(bufferOffset+nBytes-1) with:string startingAt:1.
    ].
"/        off := bufferOffset-1.
"/        1 to:s size by:2 do:[:idx|
"/            buffer unsignedShortAt:off+idx put:(s unsignedShortAt:idx).
"/        ].
    ^ nBytes
! !

!ODBCStatement::Unicode16StringBuffer methodsFor:'setup'!

setupForValues:valueCollection
    cType := #SQL_C_WCHAR.

    size notNil ifTrue:[
        colSize := 2 * size.
    ] ifFalse:[
        "/ compute from longest value
        valueCollection notEmptyOrNil ifTrue:[
            colSize := 2 * (valueCollection
                                inject:0
                                into:
                                    [:maxSoFar :eachRow |
                                        maxSoFar max:(eachRow at:columnIndex) size
                                    ]).
        ].
    ].
! !

!ODBCStatement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCStatement.st,v 1.85 2016-08-08 17:42:30 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCStatement.st,v 1.85 2016-08-08 17:42:30 mawalch Exp $'
! !


ODBCStatement::BindingsBuffer initialize!

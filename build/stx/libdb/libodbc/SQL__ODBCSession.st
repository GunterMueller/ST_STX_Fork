"
 COPYRIGHT (c) 1997 by eXept Software AG
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

DatabaseSession subclass:#ODBCSession
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

Object subclass:#SessionMetaData
	instanceVariableNames:'odbcSession'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCSession
!

!ODBCSession class methodsFor:'documentation'!

copyright

"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    This is the ODBC connection class. It provides a facade for all
    functionality as implemented in the OdbcHandle classes.

    [Instance variables:]

    [author:]
	David Queeney
	Claus Gittinger (complete rewrite)

    [See also:]
	OdbcHandle
"
!

examples
"
  create a session and connect to a db
                                                                        [exBegin]
    |session|

    session := self newConnectionForTests.
    Transcript showCR:'Connected'.
    session disconnect.
    Transcript showCR:'Disconnected'.
                                                                        [exEnd]

  Create a new table with three entries (delete old table if it is there)
  tests sqlAllocStmt sqlExecDirect sqlTransact sqlPrepare sqlSetParam sqlExecute sqlFreeStmt
                                                                        [exBegin]
    |connection|

    connection := self newConnectionForTests.

    connection executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER)'.

    connection
        executeDirect:'INSERT INTO NEWTABLE VALUES (?)'
        with:#( (1) (2) (3) ).

    connection disconnect.
                                                                        [exEnd]

  Drop the Table!!
                                                                        [exBegin]
    |connection|

    connection := self newConnectionForTests.

    connection executeDirect:'DROP TABLE NEWTABLE'.
    connection release.
                                                                        [exEnd]

  Create a new table with four entries (integer, string and uuid).
  Delete old table if it is there.
  Do a query on the table and show results. 
  Use RAW and

                                                                        [exBegin]
   |connection statement cursor|

    connection := self newConnectionForTests.
    statement := connection newStatement.
    SQL::SQLError ignoreIn:[
        statement executeDirect:'DROP TABLE NEWTABLE'.
    ].
    statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, TRUEORFALSE INTEGER, NAME VARCHAR(50), GID RAW(16))'.

    statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?, ?, ?)'.
    statement executeWith:{ {33. true. 'thirtythree'. UUID genUUID }}.
    statement executeWith:#( (55  false 'fifty-five' nil) ).
    statement executeWith:#( (20 true 'twenty' nil) ).
    statement executeWith:#( (101 false 'one hundred one' nil) ).
    statement executeWith:#( (105 nil 'hundertfünf' nil) ).

    statement prepare:'SELECT * FROM NEWTABLE WHERE ID > 30'.
    statement preferWideChar:true.
    cursor := statement execute.
    (cursor columnDescriptorAt:'TRUEORFALSE') type:Boolean.
    (cursor columnDescriptorAt:'GID') type:UUID.
    cursor next.
    {(cursor atIndex:3). (cursor at:'ID')} inspect.
    cursor cancel.
    cursor := statement execute.
    cursor upToEnd inspect.
    cursor := statement execute.
    (cursor collect:[:each| each rowAsObject]) inspect.
    cursor := statement executeDirect:'select ID from NEWTABLE'.
    (cursor collect:[:each| each rowAsArray]) inspect.
    connection release.
                                                                        [exEnd]

Bulk insert:
                                                                        [exBegin]
    |connection statement cursor|

    connection := self newConnectionForTests.

    SQL::SQLError ignoreIn:[
        connection executeDirect:'DROP TABLE NEWTABLE'.
    ].
    connection executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(50))'.

    statement := connection newStatementFor:'INSERT INTO NEWTABLE VALUES (?, ?)'.
    statement executeWith:#( 
                                (55 'fifty-five')   
                                (20 'twenty')
                                (101 'one hundred one')
                                (33 nil) 
                            ).
    statement release.

    cursor := connection executeDirect:'SELECT * FROM NEWTABLE WHERE ID > 30' release:false.
    [cursor next notNil] whileTrue:[
        Transcript showCR:(cursor rowAsDictionary).
    ].
    connection release.
                                                                        [exEnd]
"
!

obsoleteExamples
"
  These are old (low-level) examples, which are not longer executable.
  Will be rewritten over time...

        Browse the Connection!!!!
        Example: ODBCLib 1.0, example 11.0
                                                                        [exBegin]

        |connection odbcConnectString|

        connection := ODBCConnection open.
        connection setTraceBoxOn.

        odbcConnectString := connection browseConnect:('DSN=', OperatingSystem getHostname, ':MYDB').
        odbcConnectString inspect.
        odbcConnectString := connection browseConnect:'UID=demo;PWD=demo;'.
        odbcConnectString inspect.

        connection disconnect.
        connection free.
                                                                        [exEnd]

        Get the Data Sources.
        Example: ODBCLib 1.0, example 12.0
        Currently does NOT work.
                                                                        [exBegin]
        ODBCEnvironment getDataSources.
        ODBCEnvironment dataSources inspect.
                                                                        [exEnd]

        Get the parameter descriptions.
        Example: ODBCLib 1.0, example 13.0

                                                                        [exBegin]
        |connection statement|

        connection := ODBCConnection open.
        connection setTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?)'.

        statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
        statement setParam:2 fSqlType:#SQL_CHAR maxSize:512.
        statement describeParams.

        statement paramLength inspect.
        statement paramSqlType inspect.
        statement paramfNullable inspect.
        statement paramibScale inspect.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]

        SQLExtendedFetch Example
        Example: ODBCLib 1.0, example 14.0
                                                                        [exBegin]
        |connection statement numOfRows|

        connection := ODBCConnection open.
        connection setTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.
        statement := connection newStatement.

        statement executeDirect:'DROP TABLE NEWTABLE'.
        statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(25), TEST BOOLEAN)'.

        connection transact:#SQL_COMMIT.
        statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?, ?)'.

        statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
        statement setParam:2 fSqlType:#SQL_CHAR maxSize:25.
        statement setParam:3 fSqlType:#SQL_BIT maxSize:1.

        1 to: 10000 do:[ :index |
            statement parmValue:1 at:1 put:index.
            statement parmValue:2 at:1 put:('test entry #', index printString).
            statement parmValue:3 at:1 put:(index \\ 2).
            statement execute.
        ].

        statement setStatementOption:#SQL_ROWSET_SIZE vParam:2500.

        statement executeDirect:'SELECT ID, NAME FROM NEWTABLE' release:false.
        statement bindColumnsToDefault.

        [statement noDataFound] whileFalse:[
            numOfRows := statement extendedFetch:#SQL_FETCH_NEXT irow:1.
            statement noDataFound ifFalse:[
                statement rowset inspect.
            ].
        ].

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]



        Get- and SetConnectOption Example
        Example: ODBCLib 1.0, example 16.0
                                                                        [exBegin]
        |connection statement vParam|

        connection := ODBCConnection open.
        connection setTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        vParam := connection getConnectOption: #SQL_ACCESS_MODE.
        connection hasError ifTrue:[(Array with:#SQL_ACCESS_MODE with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_ACCESS_MODE with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_AUTOCOMMIT.
        connection hasError ifTrue:[(Array with:#SQL_AUTOCOMMIT with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_AUTOCOMMIT with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_CURRENT_QUALIFIER.
        connection hasError ifTrue:[(Array with:#SQL_CURRENT_QUALIFIER with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_CURRENT_QUALIFIER with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_LOGIN_TIMEOUT.
        connection hasError ifTrue:[(Array with:#SQL_LOGIN_TIMEOUT with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_LOGIN_TIMEOUT with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_ODBC_CURSORS.
        connection hasError ifTrue:[(Array with:#SQL_ODBC_CURSORS with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_ODBC_CURSORS with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_OPT_TRACE.
        connection hasError ifTrue:[(Array with:#SQL_OPT_TRACE with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_OPT_TRACE with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_OPT_TRACEFILE.
        connection hasError ifTrue:[(Array with:#SQL_OPT_TRACEFILE with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_OPT_TRACEFILE with:vParam) inspect].

        vParam := connection getConnectOption: #SQL_TXN_ISOLATION.
        connection hasError ifTrue:[(Array with:#SQL_TXN_ISOLATION with:(connection sqlState) with:(connection errorText)) inspect] ifFalse:[(Array with:#SQL_TXN_ISOLATION with:vParam) inspect].

        connection disconnect.
        connection free.
                                                                        [exEnd]

        Get- and SetCursorName Example
        Example: ODBCLib 1.0, example 17.0
                                                                        [exBegin]
        |connection statement|

        connection := ODBCConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        statement := connection newStatement.
        statement executeDirect:'SELECT ID, NAME FROM NEWTABLE WHERE id = 5' release:false.

        statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
        statement setParam:2 fSqlType:#SQL_CHAR maxSize:512.

        1 to: 210 do:[ :index |
            statement parmValue:1 at:1 put:(index \\ 7).
            statement parmValue:2 at:1 put:('test entry #', index printString).
            statement execute.
        ].

        statement executeDirect:'SELECT ID, NAME FROM NEWTABLE WHERE id = 5' release:false.
        statement bindColumnsToDefault.
        statement fetch.
        (statement getCursorName) inspect.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]


        SQLGetData Example
        Example: ODBCLib 1.0, example 18.0
                                                                        [exBegin]
        |connection statement|

        connection := ODBCConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        statement := connection newStatement.
        statement executeDirect:'SELECT ID, NAME FROM NEWTABLE WHERE id = 9999' release:false.

        statement fetch.
        (Array with:(statement getData:1) with:(statement getData:2)) inspect.

        statement drop.
        connection disconnect.
        connection free.

                                                                        [exEnd]

        SQLGetData Example
        Example: ODBCLib 1.0, example 18.0
                                                                        [exBegin]
        |connection statement numOfRows rowSet|

        connection := ODBCConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement executeDirect:'SELECT ID, NAME FROM TABLE3 WHERE id = 5' release:false.
        rowSet := OrderedCollection new.
        statement describeColumns.
        rowSet add:(statement rowHeader).
        [(statement noDataFound) | (statement hasError)] whileFalse:[
            statement fetch.
            ((statement noDataFound) | (statement hasError)) ifFalse:[
                rowSet add:(Array with:(statement getData:1) with:(statement getData:2)).
            ].
        ].
        rowSet inspect.
        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]


        SQLGetFunctions Example
        Example: ODBCLib 1.0, example 19.0
                                                                        [exBegin]
        |connection functions|

        connection := ODBCConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        functions := connection getAllFunctions.
        functions inspect.

        connection disconnect.
        connection free.
                                                                        [exEnd]

        SQLInfo Example
        Example: ODBCLib 1.0, example 20.0
                                                                        [exBegin]
        |connection functions|

        connection := ODBCConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        functions := connection getAllInfo.
        functions inspect.

        connection disconnect.
        connection free.
                                                                        [exEnd]


        Get the type info (NAMEID).
        Example: ODBCLib 1.0, example 21.0
        XXX: does not work.
                                                                        [exBegin]

        |connection statement info|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection open.
        connection setTraceBoxOn.
        ODBCLib allInstancesDo:[:o | o setTraceFlagOn].

        connection connect:':MYDB' userId:'demo' password:'demo'.
        statement := connection newStatement.

        info := statement getAllTypeInfo.
        info inspect.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]

        Get the type info (NAMEID).
        Example: ODBCLib 1.0, example 21.0
                                                                        [exBegin]

        |connection statement info message numOfRows|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        (connection hasError) ifTrue:[
            connection error.
            message := connection popWarningBox:'Could not Connect!!\'.
        ] ifFalse:[
            statement := connection newStatement.
            statement setStatementOption:#SQL_CONCURRENCY vParam:#SQL_CONCUR_READ_ONLY.
            statement setStatementOption:#SQL_CURSOR_TYPE vParam:#SQL_CURSOR_KEYSET_DRIVEN.
            statement setStatementOption:#SQL_ROWSET_SIZE vParam:1000.

            statement getTypeInfo:#SQL_ALL_TYPES.
            statement bindColumns.

            [statement noDataFound] whileFalse:[
                numOfRows := statement extendedFetch:#SQL_FETCH_NEXT irow:1.
                statement noDataFound ifFalse:[
                    (statement rowset:(numOfRows - 1)) inspect.
                ].
            ].

            statement drop.
            connection disconnect.
        ].
        connection free.
                                                                        [exEnd]

        Get SQL native code.
        Example: ODBCLib 1.0, example 22.0
                                                                        [exBegin]

        |connection sqlStr nativeSql|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection open.
        connection setTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        sqlStr := 'SELECT { fn CONVERT (id, SQL_INTEGER) } FROM nameid'.
        nativeSql := connection nativeSQL:sqlStr cbSqlStrIn:sqlStr size + 1.
        nativeSql inspect.

        connection disconnect.
        connection free.
                                                                        [exEnd]

        Bind Parameter.
        Example: ODBCLib 1.0, example 23.0
                                                                        [exBegin]

        |connection statement|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement executeDirect:'DROP TABLE NEWTABLE'.
        statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(50))'.

        connection transact:#SQL_COMMIT.
        statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?)'.

        statement bindParameter:1 fParamType:#SQL_PARAM_INPUT fSqlType:#SQL_SMALLINT  maxSize:4.
        statement bindParameter:2 fParamType:#SQL_PARAM_INPUT fSqlType:#SQL_CHAR  maxSize:512.

        statement parmValue:1 at:1 put:55.
        statement parmValue:2 at:1 put:'fifty-five'.
        statement execute.

        statement parmValue:1 at:1 put:20.
        statement parmValue:2 at:1 put:'twenty'.
        statement execute.

        statement parmValue:1 at:1 put:101.
        statement parmValue:2 at:1 put:'one hundred one'.
        statement execute.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]


        ParamOptions
        Example: ODBCLib 1.0, example 25.0
                                                                        [exBegin]

        |connection statement|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement executeDirect:'DROP TABLE NAMEID2'.
        statement executeDirect:'CREATE TABLE NAMEID2 (ID INTEGER, NAME VARCHAR(50))'.
        connection transact:#SQL_COMMIT.

        connection setConnectionOption:#SQL_AUTOCOMMIT vParam:#SQL_AUTOCOMMIT_OFF.
        statement prepare:'INSERT INTO NAMEID2 VALUES (?, ?)'.
        statement paramOptions:100.

        statement bindParameter:1 fParamType:#SQL_PARAM_INPUT fSqlType:#SQL_SMALLINT  maxSize:4.
        statement bindParameter:2 fParamType:#SQL_PARAM_INPUT fSqlType:#SQL_CHAR  maxSize:512.

        1 to:100 do:[ :index |
             statement parmValue:1 at:index put:index.
             statement parmValue:2 at:index put:('test entry #', index printString).
        ].
        statement execute.
        connection transact:#SQL_COMMIT.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]

        Get the Procedures.
        Example: ODBCLib 1.0, example 26.0

                                                                        [exBegin]
        |connection statement rowSet|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement procedures:'%' szProcOwner:'%' szProcName:'%'.

        statement bindColumns.

        rowSet := OrderedCollection new.
        rowSet add:(statement rowHeader).
        [(statement noDataFound) | (statement hasError)] whileFalse:[
            statement fetch.
            ((statement noDataFound) | (statement hasError)) ifFalse:[
                rowSet add:(statement row).
            ].
        ].
        InspectorView openOn:rowSet.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]



        Get the columns for a Procedure (NAMEID).
        Example: ODBCLib 1.0, example 27.0

                                                                        [exBegin]
        |connection statement|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement procedureColumns: '%' szProcOwner:'%' szProcName:'%'  szColumnName:'%'.

        statement bindColumnsToDefault.
        statement fetch.
        ((statement noDataFound) | (statement hasError)) ifFalse:[
            statement row inspect.
        ].
        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]


        Get the Row Count
        Example: ODBCLib 1.0, example 28.0
                                                                        [exBegin]
        |connection statement numOfRows|

        OdbcObject clearOdbc.
        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.

        connection connect:':MYDB' userId:'demo' password:'demo'.
        statement := connection newStatement.
        statement executeDirect:'DROP TABLE NEWTABLE'.
        statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(50))'.
        connection transact:#SQL_COMMIT.
        statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?)'.

        statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
        statement setParam:2 fSqlType:#SQL_CHAR maxSize:512.

        1 to: 210 do:[ :index |
            statement parmValue:1 at:1 put:(index \\ 7).
            statement parmValue:2 at:1 put:('test entry #', index printString).
            statement execute.
        ].

        statement executeDirect:'UPDATE NEWTABLE SET name=''test entry #0'' WHERE id=0' release:false.
        numOfRows := statement rowCount.
        numOfRows inspect.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]



        Get the  tables (MYDB).
        Example: ODBCLib 1.0, example 33.0

                                                                        [exBegin]
        |connection statement rowSet|

        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement tables:'%' szTableOwner:'%' szTableName:'%'  szTableType:'%'.

        statement bindColumns.
        rowSet := OrderedCollection new.
        rowSet add:(statement rowHeader).
        [(statement noDataFound) | (statement hasError)] whileFalse:[
            statement fetch.
            ((statement noDataFound) | (statement hasError)) ifFalse:[
                rowSet add:(statement row asArray).
            ].
        ].
        InspectorView openOn:rowSet.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]

        Create a new table with three entries (integer, string and date).
        Delete old table if it is there.
        Example: ODBCLib 1.0, example 6.0 with changes (DATE type).

                                                                        [exBegin]
        |connection statement|

        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement executeDirect:'DROP TABLE NEWTABLE'.
        statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(1000), BIRTHDAY DATE)'.

        connection transact:#SQL_COMMIT.
        statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?, ?)'.

        statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
        statement setParam:2 fSqlType:#SQL_CHAR maxSize:1000.
        statement setParam:3 fSqlType:#SQL_DATE maxSize:32.

        statement parmValue:1 at:1 put:55.
        statement parmValue:2 at:1 put:'fifty-five'.
        statement parmValue:3 at:1 put:Date today.
        statement execute.

        statement parmValue:1 at:1 put:20.
        statement parmValue:2 at:1 put:'twenty'.
        statement parmValue:3 at:1 put:(Date today addDays:7).
        statement execute.

        statement parmValue:1 at:1 put:101.
        statement parmValue:2 at:1 put:'one hundred one'.
        statement parmValue:3 at:1 put:(Date today addDays:196).
        statement execute.

        statement parmValue:1 at:1 put:9999.
        statement parmValue:2 at:1 put:(String new:1000 withAll:$X).
        statement parmValue:3 at:1 put:(Date today addDays:196).
        statement execute.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]

        Create a new table with three entries (integer, string, time and date).
        Delete old table if it is there.
        Example: ODBCLib 1.0, example 6.0 with changes (TIME and DATE types).

                                                                        [exBegin]
        |connection statement|

        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.

        statement := connection newStatement.
        statement executeDirect:'DROP TABLE NEWTABLE'.
        statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(25), WHEN TIME, BIRTHDAY DATE)'.

        connection transact:#SQL_COMMIT.
        statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?, ?, ?)'.

        statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
        statement setParam:2 fSqlType:#SQL_CHAR maxSize:512.
        statement setParam:3 fSqlType:#SQL_TIME maxSize:32.
        statement setParam:4 fSqlType:#SQL_DATE maxSize:32.

        statement parmValue:1 at:1 put:55.
        statement parmValue:2 at:1 put:'fifty-five'.
        statement parmValue:3 at:1 put:(Time hour:2 minutes:33 seconds:0).
        statement parmValue:4 at:1 put:Date today.
        statement execute.

        statement parmValue:1 at:1 put:20.
        statement parmValue:2 at:1 put:'twenty'.
        statement parmValue:3 at:1 put:(Time hour:0 minutes:0 seconds:0).
        statement parmValue:4 at:1 put:(Date today addDays:7).
        statement execute.

        statement parmValue:1 at:1 put:101.
        statement parmValue:2 at:1 put:'one hundred one'.
        statement parmValue:3 at:1 put:(Time hour:23 minutes:59 seconds:59).
        statement parmValue:4 at:1 put:(Date today addDays:196).
        statement execute.

        statement drop.
        connection disconnect.
        connection free.
                                                                        [exEnd]

        SQLExtendedFetch Example
        Example: ODBCLib 1.0, example 14.0 with changes (TIME and DATE types)
                                                                        [exBegin]
        |connection statement numOfRows message|

        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.
        connection setTraceBoxOn.

        (connection hasError) ifTrue:[
            connection error.
            message := connection popWarningBox:'Could not Connect!!\'.
        ] ifFalse:[
            statement := connection newStatement.
            statement setTraceBoxOn.
            statement executeDirect:'DROP TABLE NEWTABLE'.
            statement executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(25), WHEN TIME, BIRTHDAY DATE)'.

            connection transact:#SQL_COMMIT.
            statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?, ?, ?)'.

            statement setParam:1 fSqlType:#SQL_SMALLINT maxSize:4.
            statement setParam:2 fSqlType:#SQL_CHAR maxSize:512.
            statement setParam:3 fSqlType:#SQL_TIME maxSize:32.
            statement setParam:4 fSqlType:#SQL_DATE maxSize:32.

            1 to: 50 do:[ :index |
                statement parmValue:1 at:1 put:index.
                statement parmValue:2 at:1 put:('test entry #', index printString).
                statement parmValue:3 at:1 put:Time now.
                statement parmValue:4 at:1 put:Date today.
                statement execute.
            ].

            statement drop.
            statement := connection newStatement.
            statement setTraceBoxOn.

            statement setStatementOption:#SQL_CONCURRENCY vParam:#SQL_CONCUR_READ_ONLY.
            statement setStatementOption:#SQL_CURSOR_TYPE vParam:#SQL_CURSOR_KEYSET_DRIVEN.
            statement setStatementOption:#SQL_ROWSET_SIZE vParam:1000.

            statement executeDirect:'SELECT * FROM NEWTABLE' release:false.
            statement bindColumns.

            [statement noDataFound] whileFalse:[
                numOfRows := statement extendedFetch:#SQL_FETCH_NEXT irow:1.
                statement noDataFound ifFalse:[
                    (statement rowset:numOfRows) inspect.
                ].
            ].

            statement drop.
            connection disconnect.
        ].
        connection free.
                                                                        [exEnd]


        SQLExtendedFetch Example
        Example: ODBCLib 1.0, example 14.0 with changes (FLOAT type)
                                                                        [exBegin]
        |connection statement numOfRows message|

        OdbcObject instanciateOdbcLibrary.
        connection := OdbcConnection openTraceBoxOn.
        connection connect:':MYDB' userId:'demo' password:'demo'.
        (connection hasError) ifTrue:[
            connection error.
            message := connection popWarningBox:'Could not Connect!!\'.
        ] ifFalse:[
            statement := connection newStatement.
            statement executeDirect:'DROP TABLE NEWTABLE'.
            statement executeDirect:'CREATE TABLE NEWTABLE (D DECIMAL, DP DOUBLE PRECISION, F FIXED, FL FLOAT, R REAL )'.
            connection transact:#SQL_COMMIT.
            statement prepare:'INSERT INTO NEWTABLE VALUES (?, ?, ?, ?, ?)'.

            statement setParam:1 fSqlType:#SQL_DECIMAL maxSize:32.
            statement setParam:2 fSqlType:#SQL_DOUBLE  maxSize:32.
            statement setParam:3 fSqlType:#SQL_NUMERIC maxSize:32.
            statement setParam:4 fSqlType:#SQL_FLOAT   maxSize:32.
            statement setParam:5 fSqlType:#SQL_REAL    maxSize:32.

            1 to: 50000 do:[ :index |
                statement parmValue:1 at:1 put:((index asFloat) / 2.0).
                statement parmValue:2 at:1 put:((index asFloat) * 3.14159).
                statement parmValue:3 at:1 put:((index  asFloat) / 3.0).
                statement parmValue:4 at:1 put:(index asShortFloat).
                statement parmValue:5 at:1 put:((index  asShortFloat) * 33.33) asShortFloat.
                statement execute.
            ].

            statement drop.
            statement := connection newStatement.
            statement setStatementOption:#SQL_CONCURRENCY vParam:#SQL_CONCUR_READ_ONLY.
            statement setStatementOption:#SQL_CURSOR_TYPE vParam:#SQL_CURSOR_KEYSET_DRIVEN.
            statement setStatementOption:#SQL_ROWSET_SIZE vParam:25000.

            statement executeDirect:'SELECT * FROM NEWTABLE' release:false.
            statement setUpBindingColumns.
            statement bindCol:1 type:#SQL_DECIMAL.
            statement bindCol:2 type:#SQL_DOUBLE.
            statement bindCol:3 type:#SQL_NUMERIC.
            statement bindCol:4 type:#SQL_FLOAT.
            statement bindCol:5 type:#SQL_REAL.

            [(statement noDataFound) | (statement hasError)] whileFalse:[
                numOfRows := statement extendedFetch:#SQL_FETCH_NEXT irow:1.
                statement noDataFound ifFalse:[
                    (numOfRows > 0) ifTrue:[
                        (numOfRows < 1000) ifTrue:[numOfRows := numOfRows - 1].
                        (statement rowset:numOfRows) inspect.
                    ].
                ].
            ].

            statement drop.
            connection disconnect.
        ].
        connection free.
                                                                        [exEnd]
"
! !

!ODBCSession class methodsFor:'instance creation'!

defaultEnvironment
    ^ ODBCEnvironment default
! !

!ODBCSession class methodsFor:'class initialization'!

initialize
    Lobby isNil ifTrue:[
	Lobby := Registry new
    ].

    "
     self initialize
    "
!

unregister:anObject
    Lobby isNil ifFalse:[
	Lobby unregister:anObject
    ].

! !

!ODBCSession methodsFor:'ODBC 1.0, Core'!

connect:dataBaseName userId:userName password:password
    "connects to a data source"

    self connectWithUsername:userName password:password dbname:dataBaseName
!

connectWithUsername:userName password:password dbname:dataBaseName
    "establish a server to the database dbname and start a user session with username and password.
     If already connected, do nothing.
    "

    |ret|

    self isConnected ifTrue:[^ self].

    self initializeDatabaseHandle.
    ret := serverHandle sqlConnectTo:dataBaseName userName:userName password:password.
    "this is a noo-op if ret is success"
    ret performErrorHandlingFor:serverHandle statement:nil.

    self connected:(serverHandle connected).
!

disconnect
    "terminate a database session and disconnect from the database server.
     The server handle is deallocated.
     It is possible to disconnect while a statement is executed."

    |ret|

    self isConnected ifTrue:[
        ret := serverHandle sqlDisconnect.
        "this is a no-op if ret is succes"
        ret performErrorHandlingFor:serverHandle statement:nil.

        self connected:false.
        self releaseServerHandle.
    ].
!

error
    "retrieves a message asscoiated with this connection "

    self shouldImplement.
"/    |lenErrorText usedErrorText sqlStateWork sqlCodeWork errorTextWork lenErrorTextWork usedErrorTextWork|
"/
"/    sqlStateWork      := ExternalBytes unprotectedNew:10.
"/    sqlCodeWork       := ExternalLong unprotectedNew.
"/    errorTextWork     := ExternalBytes unprotectedNew:512.
"/    lenErrorTextWork  := ExternalLong unprotectedNew.
"/    usedErrorTextWork := ExternalLong unprotectedNew.
"/
"/    moreMessages:= Odbc sqlError:self environment hdbc:hdbc hstmt:#SQL_NULL_HSTMT sqlState:sqlStateWork sqlCode:sqlCodeWork errorText:errorTextWork lenErrorText:lenErrorTextWork usedErrorText:usedErrorTextWork.
"/
"/    sqlState      := sqlStateWork stringAt:1.
"/    sqlCode       := sqlCodeWork asInteger.
"/    errorText     := errorTextWork stringAt:1.
"/    lenErrorText  := lenErrorTextWork asInteger.
"/    usedErrorText := usedErrorTextWork asInteger.
"/
"/    ^errorText.
!

free
    "free a connection"

    self shouldImplement.
"/    hdbc notNil ifTrue:[
"/        sqlError := Odbc sqlFreeConnect:hdbc.
"/        (self hasError) ifTrue:[
"/            self popWarningBox:('free: failure!!\', 'Odbc sqlFreeConnect: ',(hdbc printString), '\').
"/        ].
"/        hdbc := nil.
"/    ]
! !

!ODBCSession methodsFor:'ODBC 1.0, Level 1'!

getFunction:fFunction
    "returns true if a function is supported - otherwise returns false"

    self shouldImplement.
"/    |pfExists|
"/
"/    pfExists  := ExternalLong unprotectedNew.
"/    sqlError := Odbc sqlGetFunctions:hdbc fFunction:fFunction pfExists:pfExists.
"/    (self hasError) ifTrue:[
"/        self popWarningBox:('getFunction: ',fFunction asString,' failure!!\',
"/                            'Odbc sqlGetFunctions: ',((hdbc) printString),' fFunction: ',fFunction asString,' pfExists: ',pfExists,'\').
"/        ^ false.
"/    ].
"/
"/    ^ (pfExists asInteger)  ~= 0
!

getInfo: infoTypeSymbol
    "returns information as per infoTypeSymbol"

    ^ serverHandle sqlGetInfo:infoTypeSymbol
! !

!ODBCSession methodsFor:'ODBC 1.0, Level 2'!

browseConnect:szConnStrIn
    "allows the discovery of the arguments required by a database driver to connect to a datasource"

    self shouldImplement.
"/    |szConnStrOut pcbConnStrOut|
"/
"/    szConnStrOut := ExternalBytes unprotectedNew: 512.
"/    pcbConnStrOut := ExternalLong unprotectedNew.
"/
"/    sqlError := Odbc sqlBrowseConnect:hdbc szConnStrIn:szConnStrIn cbConnStrIn:szConnStrIn size szConnStrOut:szConnStrOut cbConnStrOutMax:(szConnStrOut size - 1) pcbConnStrOut:pcbConnStrOut.
"/    (self hasError) ifTrue:[
"/        self popWarningBox:('browseConnect: ',szConnStrIn,' failure!!\','Odbc sqlBrowseConnect: ',(hdbc printString),' szConnStrIn: ', szConnStrIn,' cbConnStrIn:#SQL_NTS szConnStrOut: ',szConnStrOut,' cbConnStrOutMax: ',((szConnStrOut size - 1) printString),' pcbConnStrOut: ',pcbConnStrOut,'\').
"/        ^ nil.
"/    ].
"/
"/    ^(szConnStrOut stringAt:1 size:(pcbConnStrOut wordAt:1)).
!

nativeSQL:szSqlStrIn cbSqlStrIn:cbSqlStrIn
    "returns the translation of sqlString"

    self shouldImplement.
"/    |szSqlStr pcbSqlStr|
"/
"/    szSqlStr  := ExternalBytes unprotectedNew: cbSqlStrIn.
"/    pcbSqlStr := ExternalLong unprotectedNew.
"/
"/    sqlError := Odbc sqlNativeSql:hdbc szSqlStrIn:szSqlStrIn cbSqlStrIn:cbSqlStrIn szSqlStr:szSqlStr cbSqlStrMax:szSqlStr size pcbSqlStr:pcbSqlStr.
"/    (self hasError) ifTrue:[
"/        self popWarningBox:('nativeSQL: ',szSqlStrIn,' maxSize: ',(cbSqlStrIn printString),' failure!!\','Odbc sqlNativeSql: ',(hdbc printString),' szSqlStrIn: ', szSqlStrIn,' cbSqlStrIn: ',(cbSqlStrIn printString),' szSqlStr: ',szSqlStr,' cbSqlStrMax: ',((szSqlStr size) printString),' pcbSqlStr: ',pcbSqlStr,'\').
"/        ^ nil.
"/    ].
"/
"/    ^ szSqlStr stringAt:1
! !

!ODBCSession methodsFor:'creating ODBC objects'!

newParamQuery
    "allocates and returns a new param query"

    self shouldImplement.
"/    |parameterQuery|
"/
"/    parameterQuery := OLD_OdbcParamQuery new.
"/    parameterQuery setTraceBox:(self getTraceBox).
"/    ^parameterQuery alloc:self.
!

newStatement
    "allocates and returns a new statement"

    ^ ODBCStatement newForSession:self.
!

newStatementFor:aStatementText
    "return a new statement for the text aStatementText.

     <return: ODBCStatement>"

    ^ ODBCStatement newForSession:self text:aStatementText.
!

openQuery: aQuery
    "allocates and returns an OdbcQuery"

    self shouldImplement.
"/    |newQuery|
"/
"/    newQuery := OLD_OdbcQuery new.
"/    newQuery setTraceBox:(self getTraceBox).
"/    newQuery open:self withSql:aQuery.
"/    ^ newQuery
!

openTable
    "allocates and returns a Table"

    self shouldImplement.
"/    |newTable|
"/
"/    newTable := OLD_OdbcTable new open:self.
"/    newTable setTraceBox:(self getTraceBox).
"/    ^ newTable
!

openTable:aTableName qualifier:aTableQualifier owner:aTableOwner
    "allocates and returns an OdbcTable"

    self shouldImplement.
"/    |newTable|
"/
"/    newTable := OLD_OdbcTable new.
"/    newTable setTraceBox:(self getTraceBox).
"/    newTable open: self qualifier:aTableQualifier owner:aTableOwner name:aTableName.
"/    ^newTable
! !

!ODBCSession methodsFor:'private'!

autocommit
    "answer 'on' or 'off'"

    ^ serverHandle autocommit ifTrue:['on'] ifFalse:['off'].
!

autocommit:aBooleanOrString
   "Backward compatibility: aString is 'on' or 'off'"

    |arg|

    arg := aBooleanOrString.
    arg isBoolean ifFalse:[
        arg := aBooleanOrString asLowercase = 'on'.
    ].
    ^ serverHandle autocommit:arg
!

commit
    serverHandle commit
!

getAllFunctions

    |functions|

    functions := Dictionary new.
    #(
        SQL_API_SQLALLOCCONNECT
        SQL_API_SQLALLOCENV
        SQL_API_SQLALLOCSTMT
        SQL_API_SQLBINDCOL
        SQL_API_SQLCANCEL
        SQL_API_SQLCOLATTRIBUTES
        SQL_API_SQLCONNECT
        SQL_API_SQLDESCRIBECOL
        SQL_API_SQLDISCONNECT
        SQL_API_SQLERROR
        SQL_API_SQLEXECDIRECT
        SQL_API_SQLEXECUTE
        SQL_API_SQLFETCH
        SQL_API_SQLFREECONNECT
        SQL_API_SQLFREEENV
        SQL_API_SQLFREESTMT
        SQL_API_SQLGETCURSORNAME
        SQL_API_SQLNUMRESULTCOLS
        SQL_API_SQLPREPARE
        SQL_API_SQLROWCOUNT
        SQL_API_SQLSETCURSORNAME
        SQL_API_SQLSETPARAM
        SQL_API_SQLTRANSACT
        SQL_API_SQLCOLUMNS
        SQL_API_SQLDRIVERCONNECT
        SQL_API_SQLGETCONNECTOPTION
        SQL_API_SQLGETDATA
        SQL_API_SQLGETFUNCTIONS
        SQL_API_SQLGETINFO
        SQL_API_SQLGETSTMTOPTION
        SQL_API_SQLGETTYPEINFO
        SQL_API_SQLPARAMDATA
        SQL_API_SQLPUTDATA
        SQL_API_SQLSETCONNECTOPTION
        SQL_API_SQLSETSTMTOPTION
        SQL_API_SQLSPECIALCOLUMNS
        SQL_API_SQLSTATISTICS
        SQL_API_SQLTABLES
        SQL_API_SQLBROWSECONNECT
        SQL_API_SQLCOLUMNPRIVILEGES
        SQL_API_SQLDATASOURCES
        SQL_API_SQLDESCRIBEPARAM
        SQL_API_SQLEXTENDEDFETCH
        SQL_API_SQLFOREIGNKEYS
        SQL_API_SQLMORERESULTS
        SQL_API_SQLNATIVESQL
        SQL_API_SQLNUMPARAMS
        SQL_API_SQLPARAMOPTIONS
        SQL_API_SQLPRIMARYKEYS
        SQL_API_SQLPROCEDURECOLUMNS
        SQL_API_SQLPROCEDURES
        SQL_API_SQLSETPOS
        SQL_API_SQLSETSCROLLOPTIONS
        SQL_API_SQLTABLEPRIVILEGES
        SQL_API_SQLDRIVERS
        SQL_API_SQLBINDPARAMETER
    ) do:[:key |
         functions at:key put:(self getFunction:key).
    ].
    ^ functions.

    "
        self newConnectionForTests getAllFunctions
    "
!

getAllInfo
    |info|

    info := Dictionary new.
    #(
        SQL_DRIVER_NAME
        SQL_DRIVER_VER
        SQL_ODBC_API_CONFORMANCE
        SQL_ODBC_VER
        SQL_SERVER_NAME
        SQL_DBMS_NAME
        SQL_DBMS_VER
        SQL_IDENTIFIER_CASE
        SQL_IDENTIFIER_QUOTE_CHAR
        SQL_MAX_COLUMN_NAME_LEN
        SQL_MAX_OWNER_NAME_LEN
        SQL_MAX_PROCEDURE_NAME_LEN
        SQL_MAX_QUALIFIER_NAME_LEN
        SQL_MAX_TABLE_NAME_LEN
        SQL_MAX_COLUMNS_IN_GROUP_BY
        SQL_MAX_COLUMNS_IN_INDEX
        SQL_MAX_COLUMNS_IN_ORDER_BY
        SQL_MAX_COLUMNS_IN_SELECT
        SQL_MAX_COLUMNS_IN_TABLE
        SQL_MAX_INDEX_SIZE
        SQL_MAX_ROW_SIZE_INCLUDES_LONG
        SQL_MAX_ROW_SIZE
        SQL_MAX_STATEMENT_LEN
        SQL_MAX_TABLES_IN_SELECT
        SQL_MAX_USER_NAME_LEN
        SQL_MAX_CHAR_LITERAL_LEN
        SQL_ACTIVE_STATEMENTS
        SQL_DATA_SOURCE_NAME
        SQL_FETCH_DIRECTION

        SQL_ROW_UPDATES               
        SQL_ODBC_SAG_CLI_CONFORMANCE   
        SQL_SEARCH_PATTERN_ESCAPE      
        SQL_ODBC_SQL_CONFORMANCE       
        SQL_ACCESSIBLE_TABLES          
        SQL_ACCESSIBLE_PROCEDURES      
        SQL_PROCEDURES                 
        SQL_CONCAT_NULL_BEHAVIOR       
        SQL_CURSOR_COMMIT_BEHAVIOR     
        SQL_CURSOR_ROLLBACK_BEHAVIOR  
        SQL_DATA_SOURCE_READ_ONLY      
        SQL_DEFAULT_TXN_ISOLATION     
        SQL_EXPRESSIONS_IN_ORDERBY   
        SQL_MAX_CURSOR_NAME_LEN        
        SQL_MULT_RESULT_SETS           
        SQL_MULTIPLE_ACTIVE_TXN      
        SQL_OUTER_JOINS                
        SQL_OWNER_TERM                 
        SQL_PROCEDURE_TERM            
        SQL_QUALIFIER_NAME_SEPARATOR  
        SQL_QUALIFIER_TERM            
        SQL_SCROLL_CONCURRENCY       
        SQL_SCROLL_OPTIONS            
        SQL_TABLE_TERM                
        SQL_TXN_CAPABLE               
        SQL_USER_NAME                 
        SQL_CONVERT_FUNCTIONS         
        SQL_NUMERIC_FUNCTIONS         
        SQL_STRING_FUNCTIONS         
        SQL_SYSTEM_FUNCTIONS           
        SQL_TIMEDATE_FUNCTIONS        
        SQL_CONVERT_BIGINT         
        SQL_CONVERT_BINARY           
        SQL_CONVERT_BIT                
        SQL_CONVERT_CHAR               
        SQL_CONVERT_DATE              
        SQL_CONVERT_DECIMAL            
        SQL_CONVERT_DOUBLE            
        SQL_CONVERT_FLOAT              
        SQL_CONVERT_INTEGER           
        SQL_CONVERT_LONGVARCHAR        
        SQL_CONVERT_NUMERIC            
        SQL_CONVERT_REAL               
        SQL_CONVERT_SMALLINT          
        SQL_CONVERT_TIME               
        SQL_CONVERT_TIMESTAMP          
        SQL_CONVERT_TINYINT            
        SQL_CONVERT_VARBINARY          
        SQL_CONVERT_VARCHAR            
        SQL_CONVERT_LONGVARBINARY      
        SQL_TXN_ISOLATION_OPTION      
        SQL_ODBC_SQL_OPT_IEF          
        SQL_CORRELATION_NAME           
        SQL_NON_NULLABLE_COLUMNS       
        SQL_DRIVER_HLIB               
        SQL_DRIVER_ODBC_VER           
        SQL_LOCK_TYPES               
        SQL_POS_OPERATIONS            
        SQL_POSITIONED_STATEMENTS    
        SQL_GETDATA_EXTENSIONS         
        SQL_BOOKMARK_PERSISTENCE      
        SQL_STATIC_SENSITIVITY         
        SQL_FILE_USAGE               
        SQL_NULL_COLLATION            
        SQL_ALTER_TABLE               
        SQL_COLUMN_ALIAS             
        SQL_GROUP_BY                  
        SQL_KEYWORDS                
        SQL_ORDER_BY_COLUMNS_IN_SELECT 
        SQL_OWNER_USAGE              
        SQL_QUALIFIER_USAGE          
        SQL_QUOTED_IDENTIFIER_CASE   
        SQL_SPECIAL_CHARACTERS        
        SQL_SUBQUERIES                                                           
        SQL_UNION                      
        SQL_TIMEDATE_ADD_INTERVALS    
        SQL_TIMEDATE_DIFF_INTERVALS   
        SQL_NEED_LONG_DATA_LEN         
        SQL_MAX_BINARY_LITERAL_LEN     
        SQL_LIKE_ESCAPE_CLAUSE        
        SQL_QUALIFIER_LOCATION        
    ) do:[:key |
        [
            info at:key put:(self getInfo:key).
        ] on:KeyNotFoundError do:[:ex|
            info at:key put:'Unsupported'.
        ]
    ].

    "
        self newConnectionForTests getAllInfo
    "


    ^ info
!

initializeDatabaseHandle
    serverHandle notNil ifTrue:[^ self].    "if server handle already initialized, return"
    serverHandle := environment newDatabaseHandle.
!

isAnsiApp:aBoolean
    "if true, convert all unicode data to ansi"

    ^ serverHandle isAnsiApp:aBoolean.
!

rollback
    serverHandle rollback
! !

!ODBCSession methodsFor:'queries'!

getMetaData
    ^ SessionMetaData on:self
!

isValid
    "check if the serverHandle the receiver is in a valid state.
     On image restart a serverHandle address can be set to 0 in which case it is
     invalid.

     This method may be deleted if it proves to be useless
    "
    ^ serverHandle address ~= 0
! !

!ODBCSession methodsFor:'schema queries'!

columnsInCatalog:catalogArg schema:schemaArg table:tableArg column:columnArg
    |statement cursor columns descr|

    statement := self newStatement.
    cursor := statement columnsInCatalog:catalogArg schema:schemaArg table:tableArg column:columnArg.
"/    statement bindVariable:11 as:Boolean size:nil.
"/    bindingBuffers := statement bindColumnDescriptions.

    columns := OrderedCollection new.

    [
        cursor next notNil
    ] whileTrue:[
        descr := ODBCSchemaColumnDescription new.
        cursor fetchInto:descr.
        columns add:descr.
    ].
    statement release.
    ^ columns.

    "
        self newConnectionForTests columnsInCatalog:nil schema:'SYS' table:nil column:nil
        self newConnectionForTests columnsInCatalog:nil schema:nil table:'USER_CONS_COLUMNS' column:nil
    "
!

columnsInTable:tableArg
    ^ self columnsInCatalog:nil schema:nil table:tableArg column:nil

    "
        self newConnectionForTests columnsInTable:'USER_CONS_COLUMNS'
    "
!

primaryKeysInCatalog:catalog schema:schema table:table
    |statement cursor keys|

    statement := self newStatement.
    cursor := statement primaryKeysInCatalog:catalog schema:schema table:table.
    keys := OrderedCollection new.

    [
        cursor next notNil
    ] whileTrue:[
        keys add:(cursor fetchInto:ODBCKeyDescription new).
    ].

    statement release.
    ^ keys.

    "
        self newConnectionForTests primaryKeysInCatalog:nil schema:nil table:'APEX_MIGRATION_ACC_RPTS'.
        self newConnectionForTests primaryKeysInTable:'adressen'
    "
!

primaryKeysInTable:table
    ^ self primaryKeysInCatalog:nil schema:nil table:table

    "
        self newConnectionForTests primaryKeysInTable:'adressen'
    "
!

tables
    ^ self tablesInCatalog:nil schema:nil table:nil type:nil

    "
        self newConnectionForTests tables
    "
!

tablesInCatalog:catalogPattern schema:schemaPattern table:tablePattern type:typePattern
    |statement cursor tables|

    statement := self newStatement.
    cursor := statement tablesInCatalog:catalogPattern schema:schemaPattern table:tablePattern type:typePattern.

    tables := OrderedCollection new.
    [
        cursor next notNil
    ] whileTrue:[
        tables add:(cursor fetchInto:ODBCTableDescription new).
    ].
    statement release.
    ^ tables.

    "
        self newConnectionForTests tablesInCatalog:nil schema:'SYS' table:'USER_CONS_COLUMNS' type:nil
    "
! !

!ODBCSession::SessionMetaData class methodsFor:'instance creation'!

on:anODBCSession
    ^ self new odbcSession:anODBCSession
! !

!ODBCSession::SessionMetaData methodsFor:'accessing'!

odbcSession
    ^ odbcSession
!

odbcSession:something
    odbcSession := something.
! !

!ODBCSession::SessionMetaData methodsFor:'helper'!

getInfo:aSymbol
    ^ odbcSession getInfo:aSymbol
! !

!ODBCSession::SessionMetaData methodsFor:'interface'!

allProceduresAreCallable
"Can all the procedures returned by getProcedures
 be called by the current user?

    <returns: Boolean>"

    ^ self getInfo:#SQL_ACCESSIBLE_PROCEDURES
!

allTablesAreSelectable
"
    Can all the tables returned by getTable
    be selected?

<return: Boolean>
"
    ^ self getInfo:#SQL_ACCESSIBLE_TABLES
!

dataDefinitionCausesTransactionCommit
    self shouldImplement
!

dataDefinitionIgnoredInTransactions
    self shouldImplement
!

extraNameCharacters
    self shouldImplement
!

getDatabaseProductName
"
    The name of this database product e.g. 'ACCESS'
<return: String>
"
    ^ self getInfo:#SQL_DBMS_NAME
!

getDatabaseProductVersion
"
    summary:
	The version of this database product

<return: String>
"
    ^ self getInfo:#SQL_DBMS_VER
!

getDriverMajorVersion
    ^ self getDriverVersion copyUpTo:$.
!

getDriverMinorVersion
    ^ (self getDriverVersion asCollectionOfSubstringsSeparatedBy:$.) at:2 ifAbsent:'0'
!

getDriverVersion
"
    summary:
	The version of this database product

<return: String>
"
    ^ self getInfo:#SQL_DRIVER_VER
!

getMaxBinaryLiteralLength
"
    The hex characters can you have in an inline binary literal

<return: Integer>
"

    ^ self getInfo:#SQL_MAX_BINARY_LITERAL_LEN
!

getMaxCatalogNameLength
"
    The maximum length of a catalog name

<return: Integer>
"
    ^ self getInfo:#SQL_MAX_CATALOG_NAME_LEN
!

getMaxCharLiteralLength
"
    The max length for a character literal
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_CHAR_LITERAL_LEN
!

getMaxColumnNameLength
"
    The limit on column name length.

<return: Integer>
"
    ^ self getInfo:#SQL_MAX_TABLE_NAME_LEN
!

getMaxColumnsInIndex
"
    The maximum number of columns allowed in an index
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_COLUMNS_IN_INDEX
!

getMaxColumnsInOrderBy
"
    The maximum number of columns in an 'ORDER BY' clause
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_COLUMNS_IN_ORDER_BY
!

getMaxColumnsInSelect
"
    The maximum number of columns in a 'SELECT' list
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_COLUMNS_IN_SELECT
!

getMaxColumnsInTable
"
    The maximum number of columns in a table.

<return: Integer>
"
    ^ self getInfo:#SQL_MAX_COLUMNS_IN_TABLE
!

getMaxConnections
"
    The number of active connections can we have at a time to this database.
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_DRIVER_CONNECTIONS
!

getMaxCursorNameLength
"
      The maximum cursor name length.
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_CURSOR_NAME_LEN
!

getMaxIndexLength
"
    Retrieves the maximum number of bytes for an index,
    including all of the parts of the index.
"
    ^ self getInfo:#SQL_MAX_INDEX_SIZE
!

getMaxLengthInGroupBy
"
    The maximum number of columns in a 'GROUP BY' clause
<return: Integer>
"
    self getInfo:#SQL_MAX_COLUMNS_IN_GROUP_BY

!

getMaxProcedureNameLength
"
    The maximum length of a procedure name
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_PROCEDURE_NAME_LEN
!

getMaxRowSize
"
    The maximum length of a single row.
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_ROW_SIZE

!

getMaxSchemaNameLength
"
    The maximum length allowed for a schema name
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_SCHEMA_NAME_LEN
!

getMaxStatementLength
"
    The maximum length of an SQL statement
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_STATEMENT_LEN

!

getMaxStatements
"
    The number of active statements can we
    have open at one time to this database

<return: Integer>
"
    self shouldImplement
!

getMaxTableNameLength
"
    The maximum length of a table name
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_TABLE_NAME_LEN
!

getMaxTablesInSelect
"
    The maximum number of tables in a SELECT statement

<return: Integer>
"
    ^ self getInfo:#SQL_MAX_TABLES_IN_SELECT
!

getMaxUserNameLength
"
    The maximum length of a user name.
<return: Integer>
"
    ^ self getInfo:#SQL_MAX_USER_NAME_LEN
!

getNumericFunctions
    "Get a list of math functions.
     returns: <Collection>"

    self shouldImplement.
    ^ self getInfo:#SQL_NUMERIC_FUNCTIONS
!

getProcedureTerm
"
    summary:
        The database vendor's preferred term for 'procedure'

    note:
        MS Access returns 'QUERY' as the return value for this
        method. Is this a bug?
<return: String>
"
    ^ self getInfo:#SQL_PROCEDURE_TERM
!

getSQLKeywords
"
    Gets a comma-separated list of all a database's SQL keywords
    that are NOT also SQL92 keywords.

<return: Collection>
"
    ^ ((self getInfo:#SQL_KEYWORDS) asCollectionOfSubstringsSeparatedBy:$,) asSet
!

getSchemaTerm
"
    summary:
        Gets the schema names available in this database.
    note:
        MS Access returns '' on this. Is this correct?
<return: String>
"
    ^ self getInfo:#SQL_SCHEMA_TERM
!

getSearchStringEscape
"
    summary:
	Gets the string that can be used to escape wildcard characters.

<returns: String>
"
    ^ self getInfo:#SQL_SEARCH_PATTERN_ESCAPE
!

getStringFunctions
    "Get a list of string functions.
     returns: <Collection>"

    self shouldImplement.
    ^ self getInfo:#SQL_STRING_FUNCTIONS
!

getSystemFunctions
    "Get a list of system functions.
     returns: <Collection>"

    self shouldImplement.
    ^ self getInfo:#SQL_SYSTEM_FUNCTIONS.
!

getTimeDateFunctions
    "Get a list of time/date functions.
     returns: <Collection>"

    self shouldImplement.
    ^ self getInfo:#SQL_TIMEDATE_FUNCTIONS
!

getUserName
"
    summary:
	The user name known to the database as us.
<return: String>
"
    ^ self getInfo:#SQL_USER_NAME
!

isCatalogAtStart
"
    Does a catalog appear at the start of a qualified table name?
    (Otherwise it appears at the end)

<return: String>
"
     ^ (self getInfo:#SQL_CATALOG_LOCATION) == 1
!

isReadOnly
"
    summary:
	Is the database in read-only mode?
<return: Boolean>
"
    ^ self getInfo:#SQL_DATA_SOURCE_READ_ONLY
!

maxConnections
    ^ self getInfo:#SQL_MAX_DRIVER_CONNECTIONS
!

maxRowSize
    ^ self getInfo:#SQL_MAX_ROW_SIZE
!

supportsColumnAliasing
"
    summary:
	Is column aliasing supported?
<return: Boolean>
"
    ^ self getInfo:#SQL_COLUMN_ALIAS
! !

!ODBCSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCSession.st,v 1.51 2016-03-01 20:36:25 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCSession.st,v 1.51 2016-03-01 20:36:25 stefan Exp $'
! !


ODBCSession initialize!

"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestCase subclass:#TestODBC
	instanceVariableNames:''
	classVariableNames:'Username Password DataSource'
	poolDictionaries:''
	category:'DataBase-ODBC-Tests'
!


!TestODBC methodsFor:'helpers'!

createScenarioOn:aSession inTableNamed:aTableName
    |aStatement prepareStatement|
    ((aSession tables collect:[:aDesc | aDesc name]) includes:aTableName) ifTrue:[
        aStatement := aSession newStatementFor:'
        DROP TABLE ', aTableName,'
        '.
        aStatement execute.
    ].

    aStatement := aSession newStatementFor:'
    CREATE TABLE ' , aTableName, '(
        id integer,
        type varchar(255),
        name varchar(255)
    )
    '.
    aStatement execute.

    prepareStatement := aSession newStatement.
    prepareStatement prepare:'INSERT INTO ', aTableName,' VALUES (?, ?, ?)'.
    prepareStatement bindVariable:1 as:Integer size:0.
    prepareStatement bindVariable:2 as:String size:255.
    prepareStatement bindVariable:3 as:String size:255.
    prepareStatement executeWith:#(
        #(1 'String instrument' 'Violin')

        #(2 'String instrument' 'Viola')
        #(3 'String instrument' 'Cello')
        #(4 'String instrument' 'Viola da Gamba')
        #(5 'String instrument' 'Double bass')
        #(6 'String instrument' 'Banhu')
        #(7 'String instrument' 'Baryton')
        #(8 'String instrument' 'Cizhonghu')
        #(9 'String instrument' 'Viola d''amore')
        #(10 'String instrument' 'Banjo')
        #(11 'String instrument' 'Guitar')
        #(12 'String instrument' 'Irish bouzouki')
        #(13 'String instrument' 'Lute')
        #(14 'String instrument' 'Sitar')
        #(15 'String instrument' 'Hurdy gurdy')

        #(16 'Woodwind' 'Saxophone')
        #(17 'Woodwind' 'Oboe')
        #(18 'Woodwind' 'Cor anglais')
        #(19 'Woodwind' 'Bassoon')
        #(20 'Woodwind' 'Bagpipes')
        #(21 'Woodwind' 'Flute')
        #(22 'Woodwind' 'Tin whistle')
        #(23 'Woodwind' 'Recorder')
        #(24 'Woodwind' 'Ocarina')
        #(25 'Woodwind' 'Clarinet')

    ).
!

databaseHandleClass
    ^ SQL::ODBCHandle
!

databaseSessionClass
    ^ SQL::ODBCSession
!

doTestWithAll:aCollection
    |session handle|
    
    session := self getSession.
    session isNil ifTrue:[ self skip:'No session'. ^ self].
    self assert:(session notNil).
    
    handle := session instVarNamed:'serverHandle'.

    1 timesRepeat:[
        aCollection do:[:aValueArray |
            |att val expVal |
            expVal := Array with:nil.
            att := handle class perform:aValueArray first.
            val := handle class perform:aValueArray second.

            handle
                prim_sqlSetConnectAttr:att
                value:val.


             handle prim_sqlGetConnectAttr:att into:expVal.
             self assert:(val == expVal first).

        ].

    ].
!

getSession
    |session|
    "/ Username := Password := DataSource := nil.

    session := self databaseSessionClass new.
    self assert:(session notNil).
    self assert:(session isConnected not).

    (Username isNil or:[Password isNil or:[DataSource isNil]]) ifTrue:[
        | information |
        SQL::GetConnectionInformation isNil ifTrue:[
            Smalltalk fileIn:'SQL__GetConnectionInformation.st' inPackage:'stx:libdb/libodbc/applications'.
            self assert:(SQL::GetConnectionInformation notNil).
        ].
        information := SQL::GetConnectionInformation new.
        (information open) ifFalse:[
            ^ nil
        ].
        Username := information username.
        Password := information password.
        DataSource := information datasource.
    ].

    session connectWithUsername:Username password:Password dbname:DataSource.
    self assert:(session isConnected).
    ^ session

    "
     UserName := nil.
    "
!

removeScenarioFrom:aSession inTableNamed:aTableName
    |aStatement|
    ((aSession tables collect:[:aDesc | aDesc name]) includes:aTableName) ifTrue:[
	aStatement := aSession newStatementFor:'
	DROP TABLE ', aTableName,'
	'.
	aStatement execute.
    ].
! !

!TestODBC methodsFor:'test get session'!

test1_allattributes
"
    Tests that all attributes are there
"
    |  |
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_ACCESS_MODE) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_ASYNC_ENABLE) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_AUTO_IPD) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_AUTOCOMMIT) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_CONNECTION_DEAD) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_CONNECTION_TIMEOUT) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_CURRENT_CATALOG) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_LOGIN_TIMEOUT) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_METADATA_ID) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_ODBC_CURSORS) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_PACKET_SIZE) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_QUIET_MODE) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_TRACE) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_TRACEFILE) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_TRANSLATE_LIB) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_TRANSLATE_OPTION) isInteger.
    self assert:(ODBCHandle::ODBCDatabaseHandle SQL_ATTR_TXN_ISOLATION) isInteger.


    "
     self run:#test1
     self new test1
    "
! !

!TestODBC methodsFor:'test parallel access'!

testParallel
"
   self new testParallel
"
    |session process|

    session := self getSession.
    session isNil ifTrue:[ self skip:'No session'. ^ self].
    
    process := [
        100000 timesRepeat:[ |cur|
            cur := session executeDirect:'SELECT * FROM activitylog'.
            cur release.
        ]
    ] fork.

    [process isActive] whileFalse:[
        Delay waitForMilliseconds:10.
        process suspend.
        process id isNil ifFalse:[
            process resume.  
        ].
    ].

    session release.
! !

!TestODBC methodsFor:'test prepared statements'!

test_bulkInsert_01
    |session cur row insertStmt selectStmt|
    [
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_insert_01'.

            insertStmt := session newStatement.
            insertStmt prepare:'INSERT INTO test_insert_01 VALUES(1, ''Brass'', ?)'.

            insertStmt bindVariable:1 as:String size:255.
            insertStmt executeWith:(Array with:#('Trumpet' 'Trombone') ).
            insertStmt release.

            selectStmt := session newStatementFor:'SELECT COUNT(*) FROM test_insert_01'.
            cur :=  selectStmt execute.

            row := cur next rowAsArray.
            selectStmt release.

            self assert:(row first = (25 + 2)).

    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_insert_01'.
        session release.
    ]

    "
     self run:#test_bulkInsert_01
     self new test_bulkInsert_01
    "
!

test_delete_01
    |session|
    [
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_delete_01'.
        (1 to:20) do:[:idx |
            |cur row deleteStmt selectStmt|

            deleteStmt := session newStatement.
            deleteStmt prepare:'DELETE FROM test_delete_01 WHERE id = ?'.

            deleteStmt bindVariable:1 as:Integer size:0.
            deleteStmt executeWith:(Array with:(Array with:idx) ).
            deleteStmt release.

            selectStmt := session newStatementFor:'SELECT COUNT(*) FROM test_delete_01'.
            cur :=  selectStmt execute.

            row := cur next rowAsArray.
            selectStmt release.

            self assert:(row first == (25 - idx)).

        ].
    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_delete_01'.
        session release.
    ]

    "
     self run:#test_delete_01
     self new test_delete_01
    "
!

test_insert_01
    |session|
    [
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_insert_01'.
        #('Trumpet' 'Trombone') keysAndValuesDo:[:key :value |
            |cur row insertStmt selectStmt|

            insertStmt := session newStatement.
            insertStmt prepare:'INSERT INTO test_insert_01 VALUES(1, ''Brass'', ?)'.

            insertStmt bindVariable:1 as:String size:255.
            insertStmt executeWith:(Array with:(Array with:value) ).
            insertStmt release.

            selectStmt := session newStatementFor:'SELECT COUNT(*) FROM test_insert_01'.
            cur :=  selectStmt execute.

            row := cur next rowAsArray.
            selectStmt release.

            self assert:(row first = (25 + key)).
        ].

    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_insert_01'.
        session release.
    ]

    "
     self run:#test_insert_01
     self new test_insert_01
    "
!

test_select_01
    |session statement|
    [  |cur row|
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_select_01'.

        statement := session newStatement.
        statement prepare:'SELECT COUNT(*), 2 * ? FROM test_select_01 WHERE id > ?'.

        statement bindVariable:1 as:Integer size:0.
        statement bindVariable:2 as:Integer size:0.
        cur := statement executeWith:(Array with:(Array with:1 with:2) ).
        row := cur next rowAsArray.
        statement release.
        self assert:(row = #(23 2) ).
    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_select_01'.
        session release.
    ]

    "
     self run:#test_select_01
     self new test_select_01
    "
!

test_select_02
    |session statement|
    [  |cur row|
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_select_02'.

        statement := session newStatement.
        statement prepare:'SELECT COUNT(*), 2 * ? FROM test_select_02 WHERE id > ? AND type = ?'.

        statement bindVariable:1 as:Integer size:0.
        statement bindVariable:2 as:Integer size:0.
        statement bindVariable:3 as:String size:255.

        cur := statement executeWith:(Array with:(Array with:1 with:2 with:'Woodwind')).
        row := cur next rowAsArray.
        statement release.
        self assert:(row = #(10 2) ).
    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_select_02'.
        session release.
    ]

    "
     self run:#test_select_02
     self new test_select_02
    "
!

test_select_03
    |session statement|
    [
        session := self getSession.
        self createScenarioOn:session inTableNamed:'test_select_03'.
        (1 to:20) do:[:idx |
            |cur|
            statement := session newStatement.
            statement prepare:'SELECT COUNT(*) FROM test_select_03 WHERE id <= ?'.

            statement bindVariable:1 as:Integer size:0.
            cur := statement executeWith:(Array with:(Array with:idx)).
            cur next rowAsArray first == idx.
            statement release.
        ].

    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_select_03'.
        session release.
    ]

    "
     self run:#test_select_03
     self new test_select_03
    "
!

test_select_04
    |session statement|
    [  |cur row|
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_select_04'.

        statement := session newStatement.
        statement prepare:'SELECT COUNT(*), 2 * ? FROM test_select_04 WHERE id = ?'.

        statement bindVariable:1 as:Integer size:0.
        statement bindVariable:2 as:Integer size:0.
        cur := statement executeWith:(Array with:(Array with:1 with:2) ).
        row := cur next rowAsArray.
        statement release.
        self assert:(row first == 1).
        self assert:(row second = 2).

    ] ensure:[
        self removeScenarioFrom:session inTableNamed:'test_select_04'.
        session release.
    ]

    "
     self run:#test_select_04
     self new test_select_04
    "
! !

!TestODBC methodsFor:'test set session (ODBC 1.0)'!

test001_SQL_AUTOCOMMIT_ON
    self doTestWithAll:#(

	#(SQL_ATTR_AUTOCOMMIT SQL_AUTOCOMMIT_ON)
	#(SQL_ATTR_AUTOCOMMIT SQL_AUTOCOMMIT_OFF)
    )
!

test002_SQL_ATTR_ACCESS_MODE
    self doTestWithAll:#(

	#(SQL_ATTR_ACCESS_MODE  SQL_MODE_READ_ONLY)
	#(SQL_ATTR_ACCESS_MODE  SQL_MODE_READ_WRITE)
    )
!

test003_SQL_ATTR_LOGIN_TIMEOUT
    self doTestWithAll:(
	(0 to: 100) collect:[:idx |
	    Array with:#'SQL_ATTR_LOGIN_TIMEOUT' with:idx
	]
    )
!

test004_SQL_ATTR_TRACE
    self doTestWithAll:#(

	#(SQL_ATTR_TRACE  SQL_OPT_TRACE_OFF)
	#(SQL_ATTR_TRACE  SQL_OPT_TRACE_ON)
    )
!

test005_SQL_ATTR_TRACEFILE
    self error:'Dont know how to test this yet...'
!

test006_SQL_ATTR_TRANSLATE_LIB
    self error:'Dont know how to test this yet...'
!

test006_SQL_ATTR_TRANSLATE_OPTION
    self error:'Dont know how to test this yet...'
!

test006_SQL_ATTR_TXN_ISOLATION
    self error:'Dont know how to test this yet...'
! !

!TestODBC methodsFor:'test set session (ODBC 3.0)'!

test001_SQL_ATTR_ASYNC_ENABLE
    self doTestWithAll:#(

	#(SQL_ATTR_ASYNC_ENABLE  SQL_ASYNC_ENABLE_OFF)
	#(SQL_ATTR_ASYNC_ENABLE  SQL_ASYNC_ENABLE_ON)
    )
!

test002_SQL_ATTR_AUTO_IPD
    self doTestWithAll:#(

	#(SQL_ATTR_AUTO_IPD  SQL_TRUE)
	#(SQL_ATTR_AUTO_IPD  SQL_FALSE)
    )
!

test003_SQL_ATTR_METADATA_ID
    self doTestWithAll:#(
	#(#SQL_ATTR_METADATA_ID #SQL_TRUE)
	#(#SQL_ATTR_METADATA_ID #SQL_FALSE)
    )
! !

!TestODBC methodsFor:'test set session (ODBC 3.5)'!

test001_SSQL_ATTR_CONNECTION_DEAD
    self doTestWithAll:#(

	#(SQL_ATTR_CONNECTION_DEAD  SQL_CD_TRUE)
	#(SQL_ATTR_CONNECTION_DEAD  SQL_CD_FALSE)
    )
! !

!TestODBC methodsFor:'test set session(ODBC 2.0)'!

test001_SQL_ATTR_CURRENT_CATALOG
    self error:'Needs to be tested somehow?'
!

test002_SQL_ATTR_ODBC_CURSORS
    self doTestWithAll:#(
	#(#SQL_ATTR_ODBC_CURSORS #SQL_CUR_USE_IF_NEEDED)
	#(#SQL_ATTR_ODBC_CURSORS #SQL_CUR_USE_ODBC)
	#(#SQL_ATTR_ODBC_CURSORS #SQL_CUR_USE_DRIVER)
    )
!

test003_SQL_ATTR_PACKET_SIZE
"
    Does not work with many drivers
"
    self doTestWithAll:#(
	#(#SQL_ATTR_PACKET_SIZE 256)
	#(#SQL_ATTR_PACKET_SIZE 512)
	#(#SQL_ATTR_PACKET_SIZE 1024)
    )
!

test004_SQL_ATTR_QUIET_MODE
"
    Does not work with many drivers
"
    self error:'Dont know how to test this'
! !

!TestODBC class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestODBC.st,v 1.9 2016-11-11 23:45:15 cg Exp $'
! !


"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestCase subclass:#TestPreparedStatements
	instanceVariableNames:''
	classVariableNames:'Username Password DataSource'
	poolDictionaries:''
	category:'DataBase-ODBC-Tests'
!


!TestPreparedStatements methodsFor:'helpers'!

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
    );
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

getSession
    |session|

    session := self databaseSessionClass new.
    self assert:(session notNil).
    self assert:(session isConnected not).

    (Username isNil or:[Password isNil or:[DataSource isNil]]) ifTrue:[
        | information |
        SQL::GetConnectionInformation isNil ifTrue:[
            Smalltalk fileIn:'SQL__GetConnectionInformation.st' inPackage:'stx:libdb\libodbc\applications'.
        ].
        information := SQL::GetConnectionInformation new.
        (information open) ifFalse:[
            AbortSignal raise.
            ^ nil
        ].
        Username := information username.
        Password := information password.
        DataSource := information datasource.
    ].

    SQLError handle:[:ex |
        session := nil
    ] do:[
        session connectWithUsername:Username password:Password dbname:DataSource.
    ].
    self assert:(session notNil and:[session isConnected]).
    ^ session

    "
     Username := nil.
    "
!

removeScenarioFrom:aSession inTableNamed:aTableName
    |aStatement|

    ((aSession tables collect:[:aDesc | aDesc name]) includes:aTableName) ifTrue:[
        aStatement := aSession newStatementFor:'DROP TABLE ', aTableName,';'.
        aStatement execute.
    ].
! !

!TestPreparedStatements methodsFor:'tests'!

test_delete_01
    |session deleteStmt selectStmt|
    [
        session := self getSession.
        self createScenarioOn:session  inTableNamed:'test_delete_01'.
        (1 to:20) do:[:idx |
            |cur row|
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
    |session deleteStmt selectStmt|
    [
        session := self getSession.
        Transcript showCR:'creating scenario...'.
        self createScenarioOn:session  inTableNamed:'test_insert_01'.
        Transcript showCR:'starting tests...'.

        #('Trumpet' 'Trombone') keysAndValuesDo:[:key :value |
            |cur row|
            deleteStmt := session newStatement.
            deleteStmt prepare:'INSERT INTO test_insert_01 VALUES(1, ''Brass'', ?)'.

            deleteStmt bindVariable:1 as:String size:255.
            deleteStmt executeWith:(Array with:(Array with:value) ).
            deleteStmt release.

            selectStmt := session newStatementFor:'SELECT COUNT(*) FROM test_insert_01'.
            cur :=  selectStmt execute.

            row := cur next rowAsArray.
            selectStmt release.

            self assert:(row first == (25 + key)).
        ].
        Transcript showCR:'done.'.
    ] ensure:[
self halt.
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
        self assert:(row first == 1).
        self assert:(row second = 2).

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

!TestPreparedStatements class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestPreparedStatements.st,v 1.10 2005-12-06 20:46:21 cg Exp $'
! !

"{ Package: 'stx:libdb/libodbc' }"

"{ NameSpace: SQL }"

TestCase subclass:#ODBCTests
	instanceVariableNames:''
	classVariableNames:'DatabaseName UserName Password'
	poolDictionaries:''
	category:'DataBase-ODBC'
!

!ODBCTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ODBCTests class methodsFor:'helpers'!

connectDialog
    |bindings user password db loginParameters|

    bindings := IdentityDictionary new.
    bindings at:#inputFieldDBNameModel put:(DatabaseName ? 'test') asValue.
    bindings at:#inputFieldDBUserModel put:(UserName ? 'root') asValue.
    bindings at:#inputFieldDBPasswordModel put:(Password ? '') asValue.

    (SimpleDialog new
	openDialogSpec:(self connectDialogSpec) withBindings:bindings)
    ifFalse:[
	AbortOperationRequest raise.
	^ nil
    ].

    UserName := user := (bindings at:#inputFieldDBUserModel) value.
    Password := password := (bindings at:#inputFieldDBPasswordModel) value.
    DatabaseName := db := (bindings at:#inputFieldDBNameModel) value.

    loginParameters := Structure
		with:#userName -> user
		with:#password -> password
		with:#databaseName -> db.
    ^ loginParameters

     "
      DatabaseName := UserName := Password := nil.
      self connectDialog
     "
!

connectDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCTests andSelector:#connectDialogSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: connectDialogSpec
	window:
       (WindowSpec
	  label: 'Database connect dialog'
	  name: 'Database connect dialog'
	  min: (Point 300 149)
	  max: (Point 300 149)
	  bounds: (Rectangle 16 46 316 195)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Connect to an ODBC Database:'
	      name: 'Label4'
	      layout: (LayoutFrame 0 0.0 0 0 0 1.0 22 0)
	      style: (FontDescription #'MS SANS SERIF' bold roman 10)
	      translateLabel: true
	      adjust: left
	    )
	   (LabelSpec
	      label: 'Databasename:'
	      name: 'Label1'
	      layout: (LayoutFrame 0 0 29 0 100 0 51 0)
	      translateLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'EntryField3'
	      layout: (LayoutFrame 100 0 29 0 0 1.0 51 0)
	      model: inputFieldDBNameModel
	      acceptOnLeave: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: true
	    )
	   (LabelSpec
	      label: 'User:'
	      name: 'Label2'
	      layout: (LayoutFrame 0 0 59 0 100 0 81 0)
	      translateLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'EntryField1'
	      layout: (LayoutFrame 100 0 59 0 300 0 81 0)
	      model: inputFieldDBUserModel
	      acceptOnLeave: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: true
	    )
	   (LabelSpec
	      label: 'Password:'
	      name: 'Label3'
	      layout: (LayoutFrame 0 0 89 0 100 0 111 0)
	      translateLabel: true
	      adjust: right
	    )
	   (InputFieldSpec
	      name: 'EntryField2'
	      layout: (LayoutFrame 100 0 89 0 300 0 111 0)
	      model: inputFieldDBPasswordModel
	      type: password
	      formatString: ''
	      acceptOnLeave: true
	      acceptOnLostFocus: true
	      acceptOnPointerLeave: true
	    )
	   (HorizontalPanelViewSpec
	      name: 'HorizontalPanel1'
	      layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
	      horizontalLayout: spreadSpace
	      verticalLayout: center
	      horizontalSpace: 3
	      verticalSpace: 3
	      reverseOrderIfOKAtLeft: true
	      component:
	     (SpecCollection
		collection: (
		 (ActionButtonSpec
		    label: 'Cancel'
		    name: 'Button1'
		    translateLabel: true
		    model: cancel
		    extent: (Point 125 22)
		  )
		 (ActionButtonSpec
		    label: 'OK'
		    name: 'Button2'
		    translateLabel: true
		    model: accept
		    isDefault: true
		    extent: (Point 125 22)
		  )
		 )

	      )
	    )
	   )

	)
      )
! !

!ODBCTests methodsFor:'helpers'!

databaseHandleClass
    ^ SQL::ODBCHandle
!

databaseSessionClass
    ^ SQL::ODBCSession
!

dbIsMySQL:session
    ^ (session getInfo:#'SQL_DBMS_NAME') = 'MySQL'
!

getSession
    "remembers the last UserName, Password & DatabaseName.
     Set any to nil to be asked again"

    |session|

    session := self databaseSessionClass new.
    self assert:(session notNil).
    self assert:(session isConnected not).

    (UserName isNil or:[Password isNil or:[DatabaseName isNil]]) ifTrue:[
        self class connectDialog
    ].

    session connectWithUsername:UserName password:Password dbname:DatabaseName.
    self assert:(session isConnected).
    ^ session

    "
     UserName := nil.
    "
! !

!ODBCTests methodsFor:'tests'!

test01_environmentHandle
    "check allocation and release of handles"

    |hEnv result|

    hEnv := self databaseHandleClass newEnvironmentHandle.
    self assert:(hEnv notNil).
    self assert:(hEnv address ~~ 0).

    result := hEnv release.
    self assert:(result notNil).
    self assert:(hEnv address == 0).

    "
     ODBCEnvironment debug:true.

     self run:#test01_environmentHandle
     self new test01_environmentHandle
    "
!

test02_databaseHandle
    "check allocation and release of handles"

    |hEnv hDb result|

    hEnv := self databaseHandleClass newEnvironmentHandle.
    self assert:(hEnv notNil).
    self assert:(hEnv address ~~ 0).

    hDb := hEnv newDatabaseHandle.
    self assert:(hDb notNil).
    self assert:(hDb address ~~ 0).

    result := hDb release.
    self assert:(result notNil).
    self assert:(hDb address == 0).

    result := hEnv release.
    self assert:(result notNil).
    self assert:(hEnv address == 0).

    "
     ODBCEnvironment debug:true.

     self run:#test02_databaseHandle
     self new test02_databaseHandle
    "
!

test03_environmentHandleFinalization
    "check allocation and finalization release of handles"

    |hEnv|

    100 timesRepeat:[
	hEnv := self databaseHandleClass newEnvironmentHandle.
	self assert:(hEnv notNil).
	self assert:(hEnv address ~~ 0).
    ].
    ObjectMemory garbageCollect.

    "
     self run:#test03_environmentHandleFinalization
     self new test03_environmentHandleFinalization
    "
!

test04_databaseHandleAutomaticRelease
    "check allocation and release of handles"

    |hEnv hDb result|

    hEnv := self databaseHandleClass newEnvironmentHandle.
    self assert:(hEnv notNil).
    self assert:(hEnv address ~~ 0).

    hDb := hEnv newDatabaseHandle.
    self assert:(hDb notNil).
    self assert:(hDb address ~~ 0).

    result := hEnv release.
    self assert:(result notNil).
    self assert:(hEnv address == 0).

    self assert:(hDb address == 0).

    "
     self run:#test04_databaseHandleAutomaticRelease
     self new test04_databaseHandleAutomaticRelease
    "
!

test05_databaseHandleFinalization
    "check allocation and finalization/release of handles & subHandles"

    |hEnv hDb|

    100 timesRepeat:[
	hEnv := self databaseHandleClass newEnvironmentHandle.
	hDb := hEnv newDatabaseHandle.

	self assert:(hDb notNil).
	self assert:(hDb address ~~ 0).
    ].
    ObjectMemory garbageCollect.

    "
     self run:#test05_databaseHandleFinalization
     self new test05_databaseHandleFinalization
    "
!

test06_databaseTypeQueries
    #(
	SQL_INTEGER
	SQL_FLOAT
	SQL_DOUBLE
	SQL_REAL
	SQL_CHAR
	SQL_VARCHAR
	SQL_NUMERIC
	SQL_DECIMAL
	SQL_SMALLINT
    ) do:[:eachSym |
	|num sym|

	num := self databaseHandleClass sqlTypeNumberFromSqlTypeSymbol:eachSym.
	sym := self databaseHandleClass sqlTypeSymbolFromSqlTypeNumber:num.
	self assert:(sym == eachSym).
    ].

    #(
	SQL_C_CHAR
	SQL_C_LONG
	SQL_C_SHORT
	SQL_C_FLOAT
	SQL_C_DOUBLE
    ) do:[:eachSym |
	|num sym|

	num := self databaseHandleClass cTypeNumberFromCTypeSymbol:eachSym.
	sym := self databaseHandleClass cTypeSymbolFromCTypeNumber:num.
	self assert:(sym == eachSym).
    ].
    "
     self run:#test06_databaseTypeQueries
     self new test06_databaseTypeQueries
    "
!

test10_session
    "check session creation"

    |session|

    session := self databaseSessionClass new.
    self assert:(session notNil).
    self assert:(session isConnected not).
    self assert:(session environment notNil).
    self assert:(session environment handle notNil).
    self assert:(session environment handle address ~~ 0).

    "
     self run:#test10_session
     self new test10_session
    "
!

test11_sessionFinalization
    "check session finalization (and handle release)"

    |session|

    100 timesRepeat:[
	session := self databaseSessionClass new.
	self assert:(session notNil).
	self assert:(session isConnected not).
	self assert:(session environment notNil).
	self assert:(session environment handle notNil).
	self assert:(session environment handle address ~~ 0).
    ]

    "
     self run:#test11_sessionFinalization
     self new test11_sessionFinalization
    "
!

test20_connect
    "check connect/disconnect"

    |session|

    session := self getSession.
    session disconnect.
    self assert:(session isConnected not).

    "
     ODBCHandle debug:true.

     self run:#test20_connect
     self new test20_connect
    "
!

test21_connectFinalization
    "check disconnect on finalization"

    |session|

    50 timesRepeat:[
        session := self getSession.
    ].
    ObjectMemory garbageCollect.
    ObjectMemory garbageCollect.

    "
     ODBCEnvironment debug:true.

     self run:#test21_connectFinalization
     self new test21_connectFinalization
    "
!

test22_connectWithError
    "check exception on bad connect"

    |session savUserName savPassword savDatabaseName|

    savUserName := UserName.
    savPassword := Password.
    savDatabaseName := DatabaseName.

    UserName := 'fooBar'.
    Password := 'fooBar'.
    DatabaseName := 'fooBar'.

    [
	self
	    should:
		[
		    session := self getSession.
		]
	    raise:SQL::SQLError.
    ] ensure:[
	UserName := savUserName.
	Password := savPassword.
	DatabaseName := savDatabaseName.
    ].

    "
     ODBCEnvironment debug:true.

     self run:#test22_connectWithError
     self new test22_connectWithError
    "
!

test23_connectViaURI
    "check exception on bad connect"

    |session|

    (UserName isNil or:[Password isNil or:[DatabaseName isNil]]) ifTrue:[
        self class connectDialog
    ].

    session := Database
                newConnectionForUri:'stdb:odbc://localhost/', DatabaseName
                user:UserName
                password:Password.

    self assert:(session notNil).
    self assert:(session isConnected).
    session disconnect.


    session := Database
                newConnectionForUri:'stdb:odbc:', UserName,':', Password,'@localhost/', DatabaseName.

    self assert:(session notNil).
    self assert:(session isConnected).
    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test23_connectViaURI
     self new test23_connectViaURI
    "
!

test24_getInfo
    |session value|

    session := self getSession.

    #(
	(SQL_DRIVER_NAME        isString    nil)
	(SQL_DRIVER_ODBC_VER    isString    nil)
	(SQL_DRIVER_VER         isString    nil)
	(SQL_USER_NAME          isString    nil)
	(SQL_ODBC_VER           isString    nil)
	(SQL_SERVER_NAME        isString    nil)
	(SQL_SPECIAL_CHARACTERS isString    nil)
	(SQL_DATABASE_NAME      isString    nil)
	(SQL_DBMS_NAME          isString    nil)
	(SQL_CATALOG_TERM       isString    nil)
	(SQL_PROCEDURE_TERM     isString    nil)
	(SQL_SCHEMA_TERM        isString    nil)
	(SQL_TABLE_TERM         isString    nil)

	(SQL_TXN_CAPABLE        isInteger   nil)
"/        (SQL_MAX_IDENTIFIER_LEN isInteger   nil)
	(SQL_MAX_COLUMN_NAME_LEN isInteger   nil)
	(SQL_MAX_TABLE_NAME_LEN isInteger   nil)
	(SQL_MAX_USER_NAME_LEN  isInteger   nil)
    ) do:[:each|
	|infoType testOrNil exectedValueOrNil|

	infoType := each at:1.
	testOrNil := each at:2.
	exectedValueOrNil := each at:3.

	value := session getInfo:infoType.

	Transcript show:'getInfo(' , infoType, ') -> '.
	Transcript show:value printString.
	value isInteger ifTrue:[
	    Transcript show:' 0b'; show:(value printStringRadix:2).
	].
	Transcript cr.

	testOrNil notNil ifTrue:[
	    self assert:(value perform:testOrNil).
	].
	exectedValueOrNil notNil ifTrue:[
	    self assert:(value = exectedValueOrNil).
	].
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test24_getInfo
     self new test24_getInfo
    "
!

test30_statement
    "check statement creation and finalization"

    |session stmt|

    session := self getSession.
    stmt := session newStatementFor:'CREATE TABLE NEWTABLE (ID INTEGER)'.
    session disconnect.
    self assert:(session isConnected not).

    "
     ODBCEnvironment debug:true.

     self run:#test30_statement
     self new test30_statement
    "
!

test31_createAndDropTable
    "check execution without parameters/data"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session newStatementFor:'DROP TABLE NEWTABLE'.
	    stmt execute.
	].

    stmt := session newStatementFor:'CREATE TABLE NEWTABLE (ID INTEGER)'.
    stmt execute.
    stmt := session newStatementFor:'DROP TABLE NEWTABLE'.
    stmt execute.

    session disconnect.
    self assert:(session isConnected not).

    "
     ODBCEnvironment debug:true.

     self run:#test31_createAndDropTable
     self new test31_createAndDropTable
    "
!

test33_execute_createAndDropTable
    "check execution without parameters/data"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER)'.
    session execute:'DROP TABLE NEWTABLE'.

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test33_execute_createAndDropTable
     self new test33_execute_createAndDropTable
    "
!

test34_executeDirect_createAndDropTable
    "check execution without parameters/data"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session executeDirect:'DROP TABLE NEWTABLE'.
	].

    session executeDirect:'CREATE TABLE NEWTABLE (ID INTEGER)'.
    session executeDirect:'DROP TABLE NEWTABLE'.

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test34_executeDirect_createAndDropTable
     self new test34_executeDirect_createAndDropTable
    "
!

test40a_insert
    "check execution with data; with bindingInfo, single row"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement is given binding-info here..."
    stmt bindVariable:1 as:SmallInteger.
    stmt bindVariable:2 as:String.

    "single insert-rows here..."
    stmt executeWith:#( (1 'Fritz') ).
    stmt executeWith:#( (2 'Franz') ).
    stmt executeWith:#( (3 'Stefan') ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test40a_insert
     self new test40a_insert
    "
!

test40b_insert
    "check execution with data; with bindingInfo, single row"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement is given binding-info here..."
    stmt bindVariable:1 as:#SQL_INTEGER.
    stmt bindVariable:2 as:String.

    "single insert-rows here..."
    stmt executeWith:#( (1 'Fritz') ).
    stmt executeWith:#( (2 'Franz') ).
    stmt executeWith:#( (3 'Stefan') ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test40b_insert
     self new test40b_insert
    "
!

test40c_insert
    "check execution with data; with bindingInfo, single row"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement is given binding-info here..."
    stmt bindVariable:1 as:#SQL_INTEGER.
    stmt bindVariable:2 as:String.

    "single insert-rows here..."
    stmt executeWith:#( (1 'Fritz') ).
    stmt executeWith:#( (2 'Franz') ).
    stmt executeWith:#( (3 'Stefan') ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test40c_insert
     self new test40c_insert
    "
!

test41_insert
    "check execution with data; no bindingInfo, single row"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement must find out binding-info itself here..."

    "single insert-rows here..."
    stmt executeWith:#( (1 'Fritz') ).
    stmt executeWith:#( (2 'Franz') ).
    stmt executeWith:#( (3 'Stefan') ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test41_insert
     self new test41_insert
    "
!

test42_insertWithError
    "check execution with data; no bindingInfo, single row, data too long"

    |session stmt|

    session := self getSession.

    SQL::SQLError
        handle:[:ex | ]
        do:[
            session execute:'DROP TABLE NEWTABLE'.
            session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
        ].
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.

    self 
        should:[
            stmt executeWith:#( (1 'aNameWhichIsTooLong') ).
        ]
        raise:SQL::SQLError.

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test42_insertWithError
     self new test42_insertWithError
    "
!

test44_insertVariousTypes
    "check insert with data of many different types"

    |session|

    session := self getSession.

    SQL::SQLError
        handle:[:ex | ]
        do:[
            session execute:'drop table NEWTABLE'.
        ].

    session execute:'
create table NEWTABLE (
          textField               text
        , varcharField            varchar(4)
        , charField               char(4)
        , integerField            integer

        , int2Field               int2
        , int8Field               int8

        , numericField            numeric(6,2)
        , floatField              float
        , float4Field             float4
        , dateField               date
        , timeField               time
        , timestampField          timestamp
/*
        , oidField                oid
        , intervalField           interval
        , boolField               bool
        , pointField              point
        , lsegField               lseg
        , pathField               path
        , boxField                box
        , circleField             circle
        , polygonField            polygon
        , inetField               inet
        , cidrField               cidr
        , macaddrField            macaddr
        , byteArrayField          bytea
*/
)'.
    session execute:'
insert into NEWTABLE
(
        textField
        , varcharField
        , charField
        , integerField
        , int2Field
        , int8Field

        , numericField
        , floatField
        , float4Field
        , dateField
        , timeField
        , timestampField
/*
        , oidField
        , intervalField
        , boolField
        , pointField
        , lsegField
        , pathField
        , boxField
        , circleField
        , polygonField
        , inetField
        , cidrField
        , macaddrField
        , byteArrayField
*/
)
values (
          ''Text value''
        , ''VC1''
        , ''C4''
        , 1234
        , 2468
        , 1311768467463790320 /* 1248 */

        , 123.45
        , 0.1234
        , 123456.78
        , ''2007-09-20''
        , ''14:53:42''
        , ''2003-09-07 14:54:55''
/*
        , 1357
        , ''4 05:00:30''
        , ''true''
        , ''(2,7)''
        , ''[(0,0),(1,3)]''
        , ''((0,0),(3,0),(4,5),(1,6))''
        , ''(1,1),(3,3)''
        , ''<(1,2),60>''
        , ''((3,1),(3,3),(1,0))''
        , ''192.168.1.12''
        , ''172.20.90.150/24''
        , ''0:50:4:1d:f6:db''
        , ''000''
*/
)'.

    "/ session execute:'drop table NEWTABLE'.
    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test44_insertVariousTypes
     self new test44_insertVariousTypes
    "
!

test52_insert
    "check execution with data; with bindingInfo, multiple rows"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement is given binding-info here..."
    stmt bindVariable:1 as:SmallInteger.
    stmt bindVariable:2 as:String.

    "multiple insert-rows here..."
    stmt executeWith:#(
	    (1 'Fritz')
	    (2 'Franz')
	    (3 'Stefan') ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test52_insert
     self new test52_insert
    "
!

test53_insert
    "check execution with data; no bindingInfo, multiple rows"

    |session stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement must find out binding-info itself here..."

    "multiple insert-rows here..."
    stmt executeWith:#(
	    (1 'Fritz')
	    (2 'Franz')
	    (3 'Stefan') ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test53_insert
     self new test53_insert
    "
!

test61_select
    "check execution with data; with bindingInfo, multiple rows"

    |session stmt cursor|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    "test preparation..."
    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    stmt executeWith:#( (1 'Fritz') ).
    stmt executeWith:#( (2 'Franz') ).
    stmt executeWith:#( (3 'Stefan') ).

    "The real test begins here..."
    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    self assert:(cursor notNil).
    self assert:(cursor rowSize == 2).

    cursor next.
    self assert:((cursor atIndex:1) = 1).
    self assert:((cursor atIndex:2) = 'Fritz').

    cursor next.
    self assert:(cursor rowAsArray = #( 2 'Franz' ) ).

    cursor next.
    self assert:(cursor rowAsArray = #( 3 'Stefan' ) ).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test61_select
     self new test61_select
    "
!

test62_select
    |session stmt cursor insertDidFail|

    "mhmh: some DBs silently truncate long data in the INSERT statement,
           others report an error. 
           This test is prepared for both variants, but one of them is expected."

    insertDidFail := false.

    session := self getSession.

    SQL::SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    "test preparation..."
    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) , PARTY VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME, PARTY) VALUES (?,?,?)'.
    stmt executeWith:#( (1 'Schroeder' 'SPD') ).
    SQL::SQLError handle:[:ex |
        insertDidFail := true
    ] do:[
        stmt executeWith:#( (2 'Muentefering' 'SPD') ).    "NOTICE: longer than 10"
    ].
    SQL::SQLError handle:[:ex |
        insertDidFail := true
    ] do:[
        stmt executeWith:#( (3 'Westerwelle' 'FPD') ).     "NOTICE: longer than 10"
    ].
    stmt executeWith:#( (4 'Stoiber' 'CSU') ).

    "The real test begins here..."
    stmt := session newStatementFor:'SELECT NAME FROM NEWTABLE'.
    cursor := stmt execute.
    self assert:(cursor notNil).
    cursor next.
    self assert:(cursor rowAsArray = #( 'Schroeder' )).
    cursor next.
    insertDidFail ifFalse:[
        self assert:(cursor rowAsArray = #( 'Muenteferi' )).   "/ because of VARCHAR(10)
        cursor next.
        self assert:(cursor rowAsArray = #( 'Westerwell' )).   "/ because of VARCHAR(10)
        cursor next.
    ].
    self assert:((cursor rowAsDictionary at:'NAME') = 'Stoiber').

    cursor next.
    self assert:(cursor rowAsArray isNil).



    stmt := session newStatementFor:'SELECT NAME FROM NEWTABLE WHERE PARTY = ''SPD'' '.
    cursor := stmt execute.
    self assert:(cursor notNil).
    cursor next.
    self assert:(cursor rowAsArray = #( 'Schroeder' )).
    insertDidFail ifFalse:[
        cursor next.
        self assert:(cursor rowAsArray = #( 'Muenteferi' )).   "/ because of VARCHAR(10)
    ].
    cursor next.
    self assert:(cursor rowAsArray isNil).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test62_select
     self new test62_select
    "
!

test63_selectExpression
    |session stmt cursor|

    session := self getSession.

    stmt := session newStatementFor:'SELECT ABS(-1)'.
    cursor := stmt execute.
    self assert:(cursor notNil).
    cursor next.
    self assert:(cursor rowAsArray = #( 1 )).
    cursor next.
    self assert:(cursor rowAsArray isNil).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test63_selectExpression
     self new test63_selectExpression
    "
!

test64_selectExpressionValues
    |session stmt cursor|

    session := self getSession.

    stmt := session newStatementFor:'SELECT ABS(-1)'.
    cursor := stmt execute.
    self assert:(cursor notNil).
    cursor next.
    self assert:(cursor rowAsArray = #( 1 )).
    cursor next.
    self assert:(cursor rowAsArray isNil).
    stmt release.

    stmt := session newStatementFor:'SELECT DATABASE()'.
    cursor := stmt execute.
    self assert:(cursor notNil).
    cursor next.
    self assert:((cursor rowAsArray at:1) = DatabaseName).
    stmt release.

    #(
	0
	16rF
	16rF0
	16rF00
	16rF000
	16rF0000
	16rF00000
	16rF000000
	16rF0000000
	16rF00000000
	16rF000000000
	16rF0000000000
	16rF00000000000
	16rF000000000000
	16rF0000000000000
	16rF00000000000000
	16rF000000000000000
	16rF0000000000000000
	16rF00000000000000000
	16rF000000000000000000
    ) do:[:v |
	stmt := session newStatementFor:'SELECT ABS(' , v negated printString , ')'.
	cursor := stmt execute.
	cursor next.
	self assert:((cursor atIndex:1) = v).
	stmt release.
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test64_selectExpressionValues
     self new test64_selectExpressionValues
    "
!

test65_select
    |session stmt cursor values|

    values :=
	#(
	    0

	    10
	    100
	    1000
	    10000
	    100000
	    1000000
	    10000000
	    100000000
	    1000000000

	    -10
	    -100
	    -1000
	    -10000
	    -100000
	    -1000000
	    -10000000
	    -100000000
	    -1000000000
	).

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    "test preparation..."
    session execute:'CREATE TABLE NEWTABLE (ID1 INTEGER, NAME VARCHAR(10) , ID2 INTEGER )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID1, NAME, ID2) VALUES (?,?,?)'.
    values keysAndValuesDo:[:idx :v |
	stmt executeWith:(Array with:(Array with:idx with:(idx printString) with:v)).
    ].

    "The real test begins here..."
    stmt := session newStatementFor:'SELECT ID2 FROM NEWTABLE'.
    cursor := stmt execute.

    values do:[:expectedValue |
	|actualValue|

	cursor next.
	actualValue := cursor rowAsArray at:1.
	self assert:(actualValue = expectedValue).
    ].


    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test65_select
     self new test65_select
    "
!

test69a_tables
    |session tables tableNames stmt|

    session := self getSession.

    SQL::SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE1'.
        ].
    SQL::SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE2'.
        ].
    SQL::SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE3'.
        ].

    "test preparation..."
    session execute:'CREATE TABLE NEWTABLE1 (ID1 INTEGER, NAME1 VARCHAR(10) , PARTY1 VARCHAR(10) )'.
    session execute:'CREATE TABLE NEWTABLE2 (ID2 INTEGER, NAME2 VARCHAR(10) , PARTY2 VARCHAR(10) )'.
    session execute:'CREATE TABLE NEWTABLE3 (ID3 INTEGER, NAME3 VARCHAR(10) , PARTY3 VARCHAR(10) )'.

    "The real test begins here..."
    tables := session tables.
    tableNames := tables collect:[:t | t name].

    self assert:((tableNames includes:'NEWTABLE1') or:[tableNames includes:'newtable1']).
    self assert:((tableNames includes:'NEWTABLE2') or:[tableNames includes:'newtable2']).
    self assert:((tableNames includes:'NEWTABLE3') or:[tableNames includes:'newtable3']).

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test69a_tables
     self new test69a_tables
    "
!

test69b_columns
    |session columns stmt|

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE1'.
	].

    "test preparation..."
    session execute:'CREATE TABLE NEWTABLE1 (ID1 INTEGER, NAME1 VARCHAR(10) , PARTY1 VARCHAR(10) )'.

    "The real test begins here..."
    columns := session columnsInTable:'NEWTABLE1'.

    self assert:(columns size == 3).
    self assert:((columns at:1) name = 'ID1').

    self assert:((columns at:2) name = 'NAME1').
    self assert:((columns at:2) columnSize = 10).

    self assert:((columns at:3) name = 'PARTY1').
    self assert:((columns at:3) columnSize = 10).
    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test69b_columns
     self new test69b_columns
    "
!

test70_varchar
    "decimal dataType"

    |session stmt cursor values|

    values      := #( '' '***' 'abcdef' 'ABCDEF').

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID VARCHAR(100), VAL VARCHAR(100) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:(idx printString) with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx printString).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test70_varchar
     self new test70_varchar
    "
!

test71a_integer_int1
    "int1 dataType"

    |session stmt cursor values|

    values      := #(0 16r7F -16r80).

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL INT1 )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71a_integer_int1
     self new test71a_integer_int1
    "
!

test71b_integer_int2
    "int2 dataType"

    |session stmt cursor values|

    values      := #(0 16r7FFF -16r8000).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL INT2 )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71b_integer_int2
     self new test71b_integer_int2
    "
!

test71c_integer_int4
    "int4 dataType"

    |session stmt cursor values|

    values      := #(16r7FFFFFFF -16r80000000 0 ).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL INT4 )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71c_integer_int4
     self new test71c_integer_int4
    "
!

test71d_integer_int8
    "int8 dataType"

    |session stmt cursor values|

    values      := #(0 16r7FFFFFFFFFFFFFFF -16r8000000000000000).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL INT8 )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71d_integer_int8
     self new test71d_integer_int8
    "
!

test71e_integer_decimal
    "decimal dataType"

    |session stmt cursor values|

    values      := #(0 16r7FFFFFFFFFFFFFFF -16r8000000000000000).

    session := self getSession.

    SQL::SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL DECIMAL(20) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71e_integer_decimal
     self new test71e_integer_decimal
    "
!

test71f_integer_numeric1
    "numeric dataType"

    |session stmt cursor values|

    session := self getSession.
    (self dbIsMySQL:session) ifTrue:[
	"/ test skipped - mySQL is broken here
	^ self
    ].

    values      := #(0 16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF -16r80000000000000000000000000000000).

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL NUMERIC(50) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :expectedValue |
	|actualValue|

	cursor next.

	self assert:((cursor atIndex:1) = idx).
	actualValue := (cursor atIndex:2).
	self assert:(actualValue = expectedValue).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71f_integer_numeric1
     self new test71f_integer_numeric1
    "
!

test71f_integer_numeric2
    "numeric dataType"

    |session stmt cursor values|

    session := self getSession.
    (self dbIsMySQL:session) ifTrue:[
	"/ test skipped - mySQL is broken here
	^ self
    ].

    values      := #(16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF -16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
		     16r80000000000000000000000000000000 -16r80000000000000000000000000000000
		    ).

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL NUMERIC(50) )'.
    session execute:'INSERT INTO NEWTABLE (ID, VAL)
		VALUES (1 , 170141183460469231731687303715884105727)'.

    session execute:'INSERT INTO NEWTABLE (ID, VAL)
		VALUES (1 , -170141183460469231731687303715884105727)'.

    session execute:'INSERT INTO NEWTABLE (ID, VAL)
		VALUES (1 , 170141183460469231731687303715884105728)'.

    session execute:'INSERT INTO NEWTABLE (ID, VAL)
		VALUES (1 , -170141183460469231731687303715884105728)'.

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :expectedValue |
	|actualValue|

	cursor next.

	self assert:((cursor atIndex:1) = idx).
	actualValue := (cursor atIndex:2).
	self assert:(actualValue = expectedValue).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test71f_integer_numeric2
     self new test71f_integer_numeric2
    "
!

test72_float
    "float dataType"

    |session stmt cursor values|

    values      := #(0.0 -1.0 1.0 1.2345 1e5).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL FLOAT )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test72_float
     self new test72_float
    "
!

test73_double
    "double dataType"

    |session stmt cursor values|

    values      := #(0.0 -1.0 1.0 1.2345 1e5).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL DOUBLE )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test73_double
     self new test73_double
    "
!

test74_real
    "real dataType"

    |session stmt cursor values|

    values      := #(0.0 -1.0 1.0 1.2345 1e5).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL REAL )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test74_real
     self new test74_real
    "
!

test75_date
    "date dataType"

    |session stmt cursor values|

    values      := Array
                        with:Date today
                        with:(Date newDay:1 month:1 year:1950)
                        with:(Date newDay:1 month:1 year:1920)
                        with:(Date newDay:1 month:1 year:1900)
                        with:(Date newDay:1 month:1 year:2020)
                        with:(Date newDay:1 month:1 year:2100).

    session := self getSession.

    SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL DATE )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
        stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
        cursor next.

        self assert:((cursor atIndex:1) = idx).
        self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test75_date
     self new test75_date
    "
!

test76_time
    "time dataType"

    |session stmt cursor values|

    values      := Array
			with:Time now
			with:(Time hours:0 minutes:0 seconds:0)
			with:(Time hours:0 minutes:0 seconds:1)
			with:(Time hours:1 minutes:0 seconds:0)
			with:(Time hours:11 minutes:59 seconds:59)
			with:(Time hours:12 minutes:0 seconds:0)
			with:(Time hours:23 minutes:59 seconds:59)
			with:(Time hours:24 minutes:0 seconds:0).

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL TIME )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test76_time
     self new test76_time
    "
!

test77_timeStamp
    "timeStamp dataType"

    |session stmt cursor values|

    values      := Array
                        with:(Timestamp fromDate:(Date today) andTime:(Time now))
                        "/ with:Timestamp now  -- does not work, as DB does not store milliseconds
                        with:(Time hours:0 minutes:0 seconds:0) asTimestamp
                        with:(Time hours:0 minutes:0 seconds:1) asTimestamp
                        with:(Time hours:1 minutes:0 seconds:0) asTimestamp
                        with:(Time hours:11 minutes:59 seconds:59) asTimestamp
                        with:(Time hours:12 minutes:0 seconds:0) asTimestamp
                        with:(Time hours:23 minutes:59 seconds:59) asTimestamp
                        with:(Time hours:24 minutes:0 seconds:0) asTimestamp.

    session := self getSession.

    SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL TIMESTAMP )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
        stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :expectedValue |
        |actualValue|

        cursor next.

        self assert:((cursor atIndex:1) = idx).
        actualValue := cursor atIndex:2.
        self assert:(actualValue = expectedValue).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test77_timeStamp
     self new test77_timeStamp
    "
!

test78_byteArray
    "binary dataType"

    |session stmt cursor values|

    values      := Array
                        with:(1 to:10) asByteArray
                        with:(0 to:10) asByteArray
                        with:(1 to:255) asByteArray
                        with:#[]
                        with:''
                        with:'123456'.

    session := self getSession.

    SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL BINARY(255) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
        stmt executeWith:(Array with:(Array with:idx with:value)).
    ].
    stmt release.

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :expectedValue |
        |actualValue zeroFilledExpectedValue|

        zeroFilledExpectedValue := expectedValue , (ByteArray new:255-expectedValue size).
        cursor next.
        self assert:((cursor atIndex:1) = idx).
        actualValue := (cursor atIndex:2).
        self assert:(((actualValue = expectedValue) or:[actualValue = zeroFilledExpectedValue])
                    or:[(actualValue = expectedValue asString) or:[actualValue = zeroFilledExpectedValue asString]]).
    ].
    stmt release.
    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test78_byteArray
     self new test78_byteArray
    "
!

test79_blob_a
    "binary dataType - small blobs"

    |session stmt cursor values|

    values      := Array
                        with:#[]
                        with:(1 to:10) asByteArray
                        with:(0 to:255) asByteArray .

    session := self getSession.

    SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL BLOB )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
        stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
        cursor next.

        self assert:((cursor atIndex:1) = idx).
        self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test79_blob_a
     self new test79_blob_a
    "
!

test79_blob_b
    "binary dataType - medium sized blobs"

    |session stmt cursor values|

    values      := Array
                        with:(ByteArray new:1000 withAll:16rAF)
                        with:(ByteArray new:10000 withAll:16rAF)
                        .

    session := self getSession.

    SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL BLOB )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
        stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
        cursor next.

        self assert:((cursor atIndex:1) = idx).
        self assert:((cursor atIndex:2) size = value size).
        self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     SQL::ODBCHandle debug:true.

     self run:#test79_blob_b
     self new test79_blob_b
    "
!

test79_blob_c
    "binary dataType - huge blob"

    |session stmt cursor values|

    values      := Array
                        with:(ByteArray new:100000 withAll:16rAF)
                        .

    session := self getSession.

    SQLError
        handle:[:ex | ]
        do:[
            stmt := session execute:'DROP TABLE NEWTABLE'.
        ].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL BLOB )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
        stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
        cursor next.

        self assert:((cursor atIndex:1) = idx).
        self assert:((cursor atIndex:2) size = value size).
        self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     SQL::ODBCHandle debug:true.

     self run:#test79_blob_c
     self new test79_blob_c
    "
!

test80_guid
    "guid dataType"

    |session stmt cursor values|

    session := self getSession.
    (self dbIsMySQL:session) ifTrue:[
	"/ test skipped - mySQL does not support this
	^ self
    ].
    values      := Array
			with:(UUID fromBytes:#[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16])
			with:(UUID new)
			with:(UUID new).

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, VAL GUID )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, VAL) VALUES (?,?)'.
    values keysAndValuesDo:[:idx :value |
	stmt executeWith:(Array with:(Array with:idx with:value)).
    ].

    stmt := session newStatementFor:'SELECT * FROM NEWTABLE'.
    cursor := stmt execute.
    values keysAndValuesDo:[:idx :value |
	cursor next.

	self assert:((cursor atIndex:1) = idx).
	self assert:((cursor atIndex:2) = value).
    ].

    session disconnect.

    "
     ODBCEnvironment debug:true.

     self run:#test80_guid
     self new test80_guid
    "
!

test91_dataSources
    |env dataSources|

    env := SQL::ODBCEnvironment new.
    dataSources := env dataSources.

    self assert:(dataSources conform:[:eachEntry | eachEntry isAssociation]).
    self assert:(dataSources conform:[:eachEntry | eachEntry value isKindOf:Dictionary]).
    dataSources isEmpty
	ifTrue:
	    [
	    ]
	ifFalse:
	    [
	    ].

    "
     ODBCEnvironment debug:true.

     self run:#test91_dataSources
     self new test91_dataSources
    "
!

test92_drivers
    |env drivers|

    env := SQL::ODBCEnvironment new.
    drivers := env drivers.

    self assert:(drivers conform:[:eachEntry | eachEntry isAssociation]).
    self assert:(drivers conform:[:eachEntry | eachEntry value isKindOf:Dictionary]).

    drivers isEmpty
	ifTrue:
	    [
	    ]
	ifFalse:
	    [
	    ].

    "
     ODBCEnvironment debug:true.

     self run:#test92_drivers
     self new test92_drivers
    "
!

test93_privateProfileStrings
    |env h val|

"this test is disabled: it is only useful with some particular ODBC-Drivermanager under Unix"
^self.

    env := SQL::ODBCEnvironment new.
    h := env handle.

    val := h sqlGetPrivateProfileStringFromFile:'foo' section:'xxx' entry:'yyy' default:'bla'.
    self assert:(val = 'bla').

    h sqlWritePrivateProfileStringToFile:'foo' section:'a' entry:'b' value:'something'.
    val := h sqlGetPrivateProfileStringFromFile:'foo' section:'a' entry:'b' default:'bla'.
    self assert:(val = 'something').

    val := h sqlGetPrivateProfileStringFromFile:'foo' section:nil entry:nil default:'bla'.
    self assert:(val = 'a').

    h sqlWritePrivateProfileStringToFile:'foo' section:'a' entry:'b' value:nil.
"/    val := h sqlGetPrivateProfileStringFromFile:'foo' section:'a' entry:'b' default:'bla'.
"/    self assert:(val = 'bla').

    "
     ODBCEnvironment debug:true.

     self run:#test93_privateProfileStrings
     self new test93_privateProfileStrings
    "
!

test94_privateProfileStrings
    |env h val|

"this test is disabled: it is only useful with some particular ODBC-Drivermanager under Unix"
^self.

    env := SQL::ODBCEnvironment new.
    h := env handle.

    val := h sqlGetPrivateProfileStringFromFile:'foo' section:nil entry:nil default:''.

    "
     ODBCEnvironment debug:true.

     self run:#test94_privateProfileStrings
     self new test94_privateProfileStrings
    "
!

test95_rowAsObject
    |row c s h val o|

    row := #(1 2 3 'four' 5 6 7).

    "/ handcrafted setup of the cursors state after a next operation
    c := SQL::ODBCCursor new.
    c instVarNamed:#columns put:row.
    c instVarNamed:#columnDescriptions put:
        (Array 
            with:(SQL::ODBCColumnDescription new 
                columnNumber:1 name:'a' type:nil columnSize:nil scale:nil nullable:nil)
            with:(SQL::ODBCColumnDescription new
                columnNumber:2 name:'b' type:nil columnSize:nil scale:nil nullable:nil)
           with:(SQL::ODBCColumnDescription new
                columnNumber:3 name:'c' type:nil columnSize:nil scale:nil nullable:nil)
            with:(SQL::ODBCColumnDescription new
                columnNumber:4 name:'d' type:nil columnSize:nil scale:nil nullable:nil)
            with:(SQL::ODBCColumnDescription new
                columnNumber:5 name:'e' type:nil columnSize:nil scale:nil nullable:nil)
            with:(SQL::ODBCColumnDescription new
                columnNumber:6 name:'f' type:nil columnSize:nil scale:nil nullable:nil)
            with:(SQL::ODBCColumnDescription new
                columnNumber:7 name:'g' type:nil columnSize:nil scale:nil nullable:nil)).

    c instVarNamed:#statement put:(s := SQL::ODBCStatement new).
    s instVarNamed:#session put:(SQL::ODBCSession new).
    o := c rowAsObject.

    self assert:(o class instSize == 7).
    self assert:(o a == (row at:1)).
    self assert:(o b == (row at:2)).
    self assert:(o c == (row at:3)).
    self assert:(o d == (row at:4)).
    self assert:(o e == (row at:5)).
    self assert:(o f == (row at:6)).
    self assert:(o g == (row at:7)).

    "
     self run:#test95_rowAsObject
     self new test95_rowAsObject
    "

    "Created: / 17-07-2006 / 13:09:41 / cg"
!

time_insert10000
    "timing"

    |session stmt row rows n t|

    n := 10000.

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement is given binding-info here..."
    stmt bindVariable:1 as:SmallInteger.
    stmt bindVariable:2 as:String.

    t := Time millisecondsToRun:[
	row := Array new:2.
	rows := Array with:row.
	1 to:n do:[:idx |
	    row at:1 put:idx.
	    row at:2 put:('x_' , idx printString).
	    stmt executeWith:rows.
	].
    ].
    Transcript showCR:'Time to insert ',n printString,' rows: ',t printString,'ms'.
    session disconnect.

    "
     ODBCEnvironment debug:true.
     ODBCEnvironment debug:false.

     self run:#time_insert10000
     self new time_insert10000
    "
!

time_insert10000_bulk
    "timing"

    |session stmt row rows n t|

    n := 10000.

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    session execute:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
    stmt := session newStatementFor:'INSERT INTO NEWTABLE (ID, NAME) VALUES (?,?)'.
    "statement is given binding-info here..."
    stmt bindVariable:1 as:SmallInteger.
    stmt bindVariable:2 as:String.

    rows := OrderedCollection new:n.
    1 to:n do:[:idx |
	row := Array with:idx with:('x_' , idx printString).
	rows add:row.
    ].
    t := Time millisecondsToRun:[
	stmt executeWith:rows.
    ].
    Transcript showCR:'Time to insert ',n printString,' rows: ',t printString,'ms'.
    session disconnect.

    "
     ODBCEnvironment debug:true.
     ODBCEnvironment debug:false.

     self run:#time_insert10000_bulk
     self new time_insert10000_bulk
    "
!

time_newStatement
    "timing"

    |session stmt n t|

    n := 10000.

    session := self getSession.

    SQLError
	handle:[:ex | ]
	do:[
	    stmt := session execute:'DROP TABLE NEWTABLE'.
	].

    t := Time millisecondsToRun:[
	n timesRepeat:[
	    stmt := session newStatementFor:'CREATE TABLE NEWTABLE (ID INTEGER, NAME VARCHAR(10) )'.
	    stmt release.
	]
    ].
    Transcript showCR:'Time to allocate ',n printString,' statement handles: ',t printString,'ms'.
    session disconnect.

    "
     ODBCEnvironment debug:true.
     ODBCEnvironment debug:false.

     self run:#time_newStatement
     self new time_newStatement
    "
!

xtest32_dropTable
    |session stmt|

    session := self getSession.
    stmt := session newStatementFor:'DROP TABLE NEWTABLE'.
    stmt execute.

    session disconnect.
    self assert:(session isConnected not).

    "
     ODBCEnvironment debug:true.

     self run:#xtest32_dropTable
     self new xtest32_dropTable
    "
! !

!ODBCTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCTests.st,v 1.92 2014-10-28 11:58:17 cg Exp $'
! !


"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestCase subclass:#TestSetSessionAttributes
	instanceVariableNames:''
	classVariableNames:'Username Password DataSource'
	poolDictionaries:''
	category:'DataBase-ODBC-Tests'
!


!TestSetSessionAttributes methodsFor:'helpers'!

databaseHandleClass
    ^ SQL::ODBCHandle
!

databaseSessionClass
    ^ SQL::ODBCSession
!

doTestWithAll:aCollection

    |session handle|
    session := self getSession.
    handle := session instVarNamed:'serverHandle'.

    1000 timesRepeat:[
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
! !

!TestSetSessionAttributes methodsFor:'tests (ODBC 1.0)'!

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

!TestSetSessionAttributes methodsFor:'tests (ODBC 2.0)'!

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

!TestSetSessionAttributes methodsFor:'tests (ODBC 3.0)'!

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

!TestSetSessionAttributes methodsFor:'tests (ODBC 3.5)'!

test001_SSQL_ATTR_CONNECTION_DEAD
    self doTestWithAll:#(

	#(SQL_ATTR_CONNECTION_DEAD  SQL_CD_TRUE)
	#(SQL_ATTR_CONNECTION_DEAD  SQL_CD_FALSE)
    )
! !

!TestSetSessionAttributes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestSetSessionAttributes.st,v 1.5 2005-12-06 20:39:30 cg Exp $'
! !

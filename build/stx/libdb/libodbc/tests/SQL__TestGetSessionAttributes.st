"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestCase subclass:#TestGetSessionAttributes
	instanceVariableNames:''
	classVariableNames:'Username Password DataSource'
	poolDictionaries:''
	category:'Database-ODBC-session attributes'
!

!TestGetSessionAttributes class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 28-11-2005 / 10:28:02 / james"
! !

!TestGetSessionAttributes methodsFor:'helpers'!

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

!TestGetSessionAttributes methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!TestGetSessionAttributes methodsFor:'tests'!

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

!TestGetSessionAttributes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestGetSessionAttributes.st,v 1.2 2005-12-06 12:26:40 cg Exp $'
! !

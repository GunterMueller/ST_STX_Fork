"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestCase subclass:#TestGetInfo
	instanceVariableNames:''
	classVariableNames:'Username Password DataSource'
	poolDictionaries:''
	category:'DataBase-ODBC-Tests'
!

!TestGetInfo class methodsFor:'documentation'!

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
    "Created: / 24-11-2005 / 14:28:24 / james"
! !

!TestGetInfo methodsFor:'helpers'!

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

!TestGetInfo methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!TestGetInfo methodsFor:'tests'!

ensureGetInfo:aSymbol is:aBlock
    | session |
    [
	session := self getSession.
	self assert:(aBlock value:(session getInfo:aSymbol)).
    ] ensure:[
	session disconnect
    ].
! !

!TestGetInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestGetInfo.st,v 1.4 2005-12-06 20:39:50 cg Exp $'
! !

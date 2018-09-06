"
 COPYRIGHT (c) 2003 by eXept Software AG
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

Database subclass:#ODBCEnvironment
	instanceVariableNames:'handle'
	classVariableNames:'DefaultEnvironment'
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCEnvironment class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    This class implements an ODBC environment and is the parent of all
    odbc objects (handles) and cached data. 
    Usually a single environment is sufficient, but more environments may be used.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        handle      ODBCEnvironmentHandle   the environment handle

    [class variables:]
        DefaultEnvironmentHandle            a single, default instance of myself

    [see also:]
"
! !

!ODBCEnvironment class methodsFor:'initialization'!

initialize
    "I implement all sorts of odbc"

    self registerForUriPrefix:'stdb:odbc:'.

    "
     self initialize
    "
!

newConnectionForUri:uriString user:userString password:passwordString 
    "get a connection for a given uri"

    |uri i rest user host password file|

    i := uriString indexOf:$:.
    i == 0 ifTrue:[
        self error:'bad uri'.
    ].
    rest := uriString copyFrom:i+1.
    uri := URI fromString:rest.

    self assert:(uri scheme = 'odbc').
    host := uri authority ? 'localhost'.
    file := uri pathSegments first.
"/    (file startsWith:'/') ifTrue:[
"/        file := file copyFrom:2
"/    ].

    i := file indexOf:$@.
    i ~~ 0 ifTrue:[
        user := file copyTo:i-1.
        host := file copyFrom:i+1.
        file := uri pathSegments at:2.

        i := user indexOf:$:.
        i ~~ 0 ifTrue:[
            password := user copyFrom:i+1.
            user := user copyTo:i-1.
        ].
    ].

    userString notNil ifTrue:[
        user := userString
    ].
    passwordString notNil ifTrue:[
        password := passwordString
    ].
    ^ self new 
        newSession
            connectWithUsername:user password:password dbname:file
    "
     Database newConnectionForUri:'stdb:odbc:root:password@mysql'

     Database newConnectionForUri:'stdb:odbc:/test' user:'scott' password:'tiger'
     Database newConnectionForUri:'stdb:odbc:/scott@test' user:nil password:'tiger'
     Database newConnectionForUri:'stdb:odbc:/scott:tiger@test' user:nil password:nil
     Database newConnectionForUri:'stdb:odbc://db.exept.de/test' user:'scott' password:'tiger'
     Database newConnectionForUri:'stdb:odbc://db.exept.de/scott:tiger@test' user:nil password:nil
    "
!

update:anAspect with:parameter from:changedObject
    "Clear the default environment when restarted from a snapshot"

    (anAspect == #restarted) ifTrue:[
        DefaultEnvironment := nil.
        ^ self.
    ].

    ^ super update:anAspect with:parameter from:changedObject
! !

!ODBCEnvironment class methodsFor:'accessing'!

debug:aBoolean
    ODBCHandle debug:aBoolean
!

default
    DefaultEnvironment isNil ifTrue:[   
        ObjectMemory addDependent:self.
        DefaultEnvironment := self new.
    ].
    ^ DefaultEnvironment.

    "
     DefaultEnvironment := nil.
    "
! !

!ODBCEnvironment methodsFor:'accessing'!

handle
   handle isNil ifTrue:[
        handle := ODBCHandle newEnvironmentHandle
   ].
   ^ handle
!

newSession
    ^ ODBCSession newForEnvironment:self
!

newStatement:statementText
    ^ ODBCStatement newForEnvironment:self text:statementText
! !

!ODBCEnvironment methodsFor:'handle creation'!

newDatabaseHandle
    ^ handle newDatabaseHandle
! !

!ODBCEnvironment methodsFor:'queries'!

dataSourceNames
    ^ self dataSources collect:[:eachAssoc | eachAssoc key]
!

dataSources
    |sources entry|

    sources := OrderedCollection new.

    ODBCHandle supportsMultipleDataSources ifFalse:[
        sources add:(ODBCHandle databaseName -> Dictionary new).
        ^ sources
    ].

    entry := self handle sqlDataSources:#SQL_FETCH_FIRST.
    [ entry notNil ] whileTrue:[
        sources add:entry.
        entry := self handle sqlDataSources:#SQL_FETCH_NEXT.
    ].
    ^ sources

    "Modified: / 18-07-2006 / 08:55:36 / cg"
!

driverNames
    ^ self drivers collect:[:eachAssoc | eachAssoc key]
!

drivers
    |drivers entry|

    drivers := OrderedCollection new.

    ODBCHandle supportsMultipleDrivers ifFalse:[
        drivers add:(ODBCHandle databaseName -> Dictionary new).
        ^ drivers
    ].

    entry := self handle sqlDrivers:#SQL_FETCH_FIRST.
    [ entry notNil ] whileTrue:[
        drivers add:entry.
        entry := self handle sqlDrivers:#SQL_FETCH_NEXT.
    ].
    ^ drivers

    "Modified: / 18-07-2006 / 08:54:47 / cg"
! !

!ODBCEnvironment methodsFor:'release'!

release
    handle release.
! !

!ODBCEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCEnvironment.st,v 1.18 2017-01-25 01:29:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCEnvironment.st,v 1.18 2017-01-25 01:29:17 cg Exp $'
! !


ODBCEnvironment initialize!

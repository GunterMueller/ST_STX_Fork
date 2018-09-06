"{ NameSpace: DB }"

Object subclass:#ODBCDataSource
	instanceVariableNames:'name description driver driverInst host databaseId handle'
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Interface'
!

!ODBCDataSource class methodsFor:'documentation'!

documentation
"
    documentation to be added.
"
!

examples
"
    examples to be added.
"
!

history
    "Created: 3.10.1996 / 13:47:34 / ah"
! !

!ODBCDataSource methodsFor:'accessing'!

databaseId
    "return databaseId"

    ^ databaseId!

databaseId:something
    "set databaseId"

    databaseId := something.!

description
    "return description"

    ^ description!

description:something
    "set description"

    description := something.!

driver
    "return driver"

    ^ driver
!

driver:something
    "set driver"

    driver := something.
!

driverInst
    "return driver instance"

    ^ driverInst
!

driverInst:something
    "set driver instance"

    driverInst := something.
!

handle
    "return handle"

    ^ handle
!

handle:something
    "set handle"

    handle := something.
!

host
    "return host"

    ^ host!

host:something
    "set host"

    host := something.!

name
    "return name"

    ^ name!

name:something
    "set name"

    name := something.! !

!ODBCDataSource methodsFor:'printing & storing'!

printToStream: aStream

    aStream nextPutLine: '#===================================='.
    aStream nextPutLine: '#'.
    aStream nextPutLine: 'DataSourceDefinitionStart'.

    name notNil ifTrue: [
        aStream nextPutLine: ('  dataSourceName:  ', name).
    ] ifFalse: [
        ^ false.
    ].
    driver notNil ifTrue: [
        aStream nextPutLine: ('  driver:  ', driver).
    ].
    host notNil ifTrue: [
        aStream nextPutLine: ('  hostname:  ', host).
    ].
    databaseId notNil ifTrue: [
        aStream nextPutLine: ('  dataBaseId: ', databaseId).
    ].
    description notNil ifTrue: [
        aStream nextPutLine: ('  description: ', name).
    ].

    aStream nextPutLine: 'DataSourceDefinitionStop'.
    aStream nextPutLine: '#'.
    aStream nextPutLine: '#===================================='.

    ^ true.
! !

!ODBCDataSource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCDataSource.st,v 1.1 1997-01-13 17:53:06 ah Exp $'
! !

"{ NameSpace: DB }"

Object subclass:#ODBCInterfaceMSQLtest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Driver'
!

!ODBCInterfaceMSQLtest class methodsFor:'documentation'!

documentation
"
    documentation to be added.
"
!

examples
"
    examples to be added.

    -------------------------------------
        Form a connection to a MSQL server 
        a disconnect after connetion was
        established

    |odbcIf handle hostName|

    hostName := 'localhost'.

    odbcIf := ODBCInterfaceMSQL new.
    handle := odbcIf sqlConnect: hostName.
    handle = -1 ifTrue: [
        Transcript showCR: ('connection to host ', hostName, ' failed.').
        ^ self.
    ].

    Transcript showCR:  'connection to host '
                        , hostName
                        , ' established; handle = '
                        , (handle printString).
    odbcIf sqlDisconnect: handle.

    -------------------------------------
    -------------------------------------
        Request a list of available databases
        from a  MSQL server 

    |odbcIf handle hostName dbCol dbName|

    hostName := 'localhost'.
    dbName   := 'test'.

    odbcIf := ODBCInterfaceMSQL new.
    handle := odbcIf sqlConnect: hostName.
    handle ~~ -1 ifFalse: [
        Transcript showCR: ('connection to host ', hostName, ' failed.').
        ^ self.
    ].

    (odbcIf sqlSelectDB: dbName onService: handle) ifFalse: [
        Transcript showCR: ('can`t select database ', dbName, '.').
        odbcIf sqlDisconnect: handle.
        ^ self.
    ].

    (odbcIf sqlListTables: handle) ifFalse: [
        Transcript showCR: ('no table info exists.').
        odbcIf sqlDisconnect: handle.
        ^ self.
    ].

    dbCol := odbcIf sqlFetchRow.
    dbCol inspect.
    odbcIf sqlFreeResult.
    odbcIf sqlDisconnect: handle.

    -------------------------------------
"

!

history
    "Created: 13.1.1997 / 07:48:45 / ah"
! !

!ODBCInterfaceMSQLtest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/obsolete_libDB/ODBCInterfaceMSQLtest.st,v 1.1 1997-01-13 17:52:51 ah Exp $'
! !

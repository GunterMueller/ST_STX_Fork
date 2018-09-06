"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestGetInfo subclass:#TestODBCGetInfo_2_01
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Database-ODBC-Tests-GetInfo'
!

!TestODBCGetInfo_2_01 class methodsFor:'documentation'!

documentation
"
    Tests that we get the right type of info from the GetInfo messages for ODBC level 2.01

    [author:]
        james (james@CHANTI)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TestODBCGetInfo_2_01 methodsFor:'tests'!

test1_SQL_OJ_CAPABILITIES

    self ensureGetInfo:#SQL_OJ_CAPABILITIES is:[:aValue |
        aValue isInteger
    ].
! !

!TestODBCGetInfo_2_01 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestODBCGetInfo_2_01.st,v 1.3 2005-11-28 10:07:11 cg Exp $'
! !

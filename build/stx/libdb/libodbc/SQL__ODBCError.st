"
 COPYRIGHT (c) 2004 by eXept Software AG
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

SQLError subclass:#ODBCError
	instanceVariableNames:'state nativeErrorCode'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ODBCError methodsFor:'accessing'!

nativeErrorCode
    ^ nativeErrorCode
!

nativeErrorCode:something
    nativeErrorCode := something.
!

state
    ^ state
!

state:something
    state := something.
!

state:stateArg nativeErrorCode:errorCodeArg errorString:messageTextArg 
    state := stateArg.
    nativeErrorCode := errorCodeArg.
    messageText := messageTextArg.
! !

!ODBCError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCError.st,v 1.9 2009-10-07 08:03:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCError.st,v 1.9 2009-10-07 08:03:15 cg Exp $'
! !

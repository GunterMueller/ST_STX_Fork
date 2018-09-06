"
 COPYRIGHT (c) 2009 by eXept Software AG
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

ODBCError subclass:#ODBCConnectionError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCConnectionError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    added to make it easier to react on a connection failure error
    (by reconnecting) in a handler.
"
! !

!ODBCConnectionError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCConnectionError.st,v 1.2 2009-10-07 08:03:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCConnectionError.st,v 1.2 2009-10-07 08:03:24 cg Exp $'
! !

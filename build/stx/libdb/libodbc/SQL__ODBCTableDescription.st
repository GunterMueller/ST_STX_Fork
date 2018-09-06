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

DatabaseTableDescription subclass:#ODBCTableDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCTableDescription class methodsFor:'documentation'!

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

!ODBCTableDescription methodsFor:'accessing'!

catalog
    ^ catalog
!

catalog:something
    catalog := something.
!

comment
    ^ comment
!

comment:something
    comment := something.
!

name
    ^ name
!

name:something
    name := something.
!

schema
    ^ schema
!

schema:something
    schema := something.
!

type
    ^ type
!

type:something
    type := something.
! !

!ODBCTableDescription methodsFor:'accessing odbc compliant'!

remarks:aString
    comment := aString
!

table_cat:aString
    catalog := aString
!

table_name:aString
    name := aString
!

table_schem:aString
    schema := aString
!

table_type:aString
    type := aString
! !

!ODBCTableDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCTableDescription.st,v 1.4 2016-03-01 16:16:42 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCTableDescription.st,v 1.4 2016-03-01 16:16:42 stefan Exp $'
! !


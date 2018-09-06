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

DatabaseKeyDescription subclass:#ODBCKeyDescription
	instanceVariableNames:'catalog schema'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCKeyDescription class methodsFor:'documentation'!

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

!ODBCKeyDescription methodsFor:'accessing'!

catalog
    ^ catalog
!

catalog:something
    catalog := something.
!

schema
    ^ schema
!

schema:something
    schema := something.
! !

!ODBCKeyDescription methodsFor:'accessing odbc compliant'!

column_name:aString
    columnName := aString
!

key_seq:anObject
    keySeq := anObject
!

pk_name:aString
    keyName := aString
!

table_cat:aString
    catalog := aString
!

table_name:aString
    tableName := aString
!

table_schem:aString
    schema := aString
! !

!ODBCKeyDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCKeyDescription.st,v 1.5 2016-03-01 16:18:52 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCKeyDescription.st,v 1.5 2016-03-01 16:18:52 stefan Exp $'
! !


"
 COPYRIGHT (c) 2016 by eXept Software AG
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

ODBCColumnDescription subclass:#ODBCSchemaColumnDescription
	instanceVariableNames:'tableName tableSchema typeName tableCategory buffer_length
		char_octet_length column_def is_nullable num_prec_radix
		sql_datetime_sub'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCSchemaColumnDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    This describes a database table column.
    It is created whn doing explicit schema queries and contains
    a superset of the information provided in ODBCColumnDescription.

    [author:]
        Stefan Vogel

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ODBCSchemaColumnDescription methodsFor:'accessing odbc compliant'!

column_name
    ^ name
!

column_name:anObject
    name := anObject
!

column_size
    ^ columnSize
!

column_size:anObject
    columnSize := anObject
!

data_type
    ^ sqlTypeNr
!

data_type:anObject
!

decimal_digits
    ^ scale
!

decimal_digits:anObject
    scale := anObject
!

nullable:anObject
    nullable := anObject ~~ 0
!

ordinal_position
    ^ index
!

ordinal_position:anObject
    index := anObject
!

remarks
    ^ comment
!

remarks:anObject
    comment := anObject
!

sql_data_type
    ^ sqlTypeNr
!

sql_data_type:anObject
    self setSqlTypeNr:anObject.
    sqlType := ODBCHandle sqlTypeSymbolFromSqlTypeNumber:anObject
!

table_cat
    ^ tableCategory
!

table_cat:anObject
    tableCategory := anObject
!

table_name
    ^ tableName
!

table_name:anObject
    tableName := anObject
!

table_schem
    ^ tableSchema
!

table_schem:anObject
    tableSchema := anObject
!

type_name
    ^ typeName
!

type_name:anObject
    typeName := anObject
! !

!ODBCSchemaColumnDescription methodsFor:'more odbc attributes'!

buffer_length
    ^ buffer_length
!

buffer_length:anObject
    buffer_length := anObject
!

char_octet_length
    ^ char_octet_length
!

char_octet_length:anObject
    char_octet_length := anObject
!

column_def
    ^ column_def
!

column_def:anObject
    column_def := anObject
!

is_nullable
    ^ is_nullable
!

is_nullable:anObject
    is_nullable := anObject
!

num_prec_radix
    ^ num_prec_radix
!

num_prec_radix:anObject
    num_prec_radix := anObject
!

sql_datetime_sub
    ^ sql_datetime_sub
!

sql_datetime_sub:anObject
    sql_datetime_sub := anObject
! !

!ODBCSchemaColumnDescription methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:(self class name).
    aStream nextPutAll:'(index='.
    index printOn:aStream.
    aStream nextPutAll:' name='.
    tableSchema printOn:aStream. aStream nextPut:$:. tableName printOn:aStream. aStream nextPut:$:. name printOn:aStream.
    aStream nextPutAll:' type='.
    sqlType printOn:aStream.
    aStream nextPut:$).
! !

!ODBCSchemaColumnDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCSchemaColumnDescription.st,v 1.2 2017-05-10 12:24:14 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCSchemaColumnDescription.st,v 1.2 2017-05-10 12:24:14 mawalch Exp $'
! !


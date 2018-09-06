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

Cursor subclass:#ODBCCursor
	instanceVariableNames:'statement columnDescriptionDictionary columns rowSize'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-ODBC'
!

!ODBCCursor class methodsFor:'documentation'!

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

!ODBCCursor methodsFor:'accessing'!

statement
    ^ statement
!

statement:something
    statement := something.
! !

!ODBCCursor methodsFor:'accessing column descriptors'!

columnDescriptionDictionary
    columnDescriptionDictionary isNil ifTrue:[
        "/chaged to OrderedDictionary because MSSQLSERVER needs columns in order....
        columnDescriptionDictionary := OrderedDictionary new.
        statement columnDescriptions do:[:eachDesc|
            columnDescriptionDictionary at:eachDesc name put:eachDesc
        ].
    ].
    ^ columnDescriptionDictionary
!

columnDescriptions
    "external interface - have to answer a SequenceableCollection here"

    ^ statement columnDescriptions
!

columnDescriptorAt:columnNameString
    "return the value of the columnDescriptor named columnNameString"

    ^ self columnDescriptionDictionary at:columnNameString ifAbsent:nil
!

columnDescriptorAtIndex:columnIndex
    "return the value of the columnDescriptor at columnIndex"

    ^ statement columnDescriptorAtIndex:columnIndex.
! !

!ODBCCursor methodsFor:'accessing columns'!

at:columnNameString
    "return the value of the current row/column named columnNameString"

    |columnDescriptor|

    columnDescriptor := self columnDescriptorAt:columnNameString.
    ^ columnDescriptor sqlGetDataForStatement:statement
!

atIndex:columnIndex
    "return the value of the current row/column at columnIndex"

    ^ (statement columnDescriptions at:columnIndex) sqlGetDataForStatement:statement
!

rowAs:dictionaryClass
    "answer the current row as some Dictionary (columnName -> columnValue)"

    |newDictionary|

    newDictionary := dictionaryClass new:self rowSize.
    self columnDescriptionDictionary keysAndValuesDo:[:eachName :eachColumnDescriptor |
        newDictionary 
            at:eachName 
            put:(eachColumnDescriptor sqlGetDataForStatement:statement)
    ].
    ^ newDictionary
!

rowAsArray
    "answer the current row as array"

    columns isNil ifTrue:[
        columns := statement columnDescriptions collect:[:eachColumnDescriptor|
                eachColumnDescriptor sqlGetDataForStatement:statement.
            ].
    ].
    ^ columns
! !

!ODBCCursor methodsFor:'fetching'!

next
    "advance the cursor to the next row.
     Answer nil, if there are no more rows in the cursor."

    |ret|

    columns := nil.     "clear cached column data"
    self rowSize = 0 ifTrue:[
        "here we detect, that no rows are to be fetched.
         This happens, if the statement wasn't a select statement,
         but e.g. an insert statement"
        ^ nil.
    ].

    ret := statement sqlFetch.
    ret isNoData ifTrue:[
        ^ nil.  "there are no more rows to fetch"
    ].
    ^ self 
! !

!ODBCCursor methodsFor:'formatting data'!

preferWideChar:aBoolean
    "prefer fetching with wide characters.
     All strings will be returned as Unicode16Strings"

    statement preferWideChar:aBoolean.
! !

!ODBCCursor methodsFor:'queries'!

columnNames
    "answer an array containing the column names of the query"

    ^ statement columnNames
!

rowSize
    "the size of a row, i.e. the number of columns"

    rowSize isNil ifTrue:[
        rowSize := statement sqlNumResultCols ? 0.
    ].
    ^ rowSize
!

session
    ^ statement session
! !

!ODBCCursor methodsFor:'releasing'!

cancel
    "cancel the cursor.
     After this, the statement is still valid and may be executed again."

    statement closeCursor.
    statement := nil.
!

release
    "Release the statement and the cursor.
     After this, the statement is invalid."

    statement release.
    statement := nil.
! !

!ODBCCursor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCCursor.st,v 1.34 2016-03-01 09:57:04 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCCursor.st,v 1.34 2016-03-01 09:57:04 stefan Exp $'
! !


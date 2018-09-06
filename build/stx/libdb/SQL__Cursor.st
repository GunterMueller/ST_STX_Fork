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
"{ Package: 'stx:libdb' }"

"{ NameSpace: SQL }"

Object subclass:#Cursor
	instanceVariableNames:'objectClass'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!Cursor class methodsFor:'documentation'!

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

!Cursor methodsFor:'accessing columns'!

at:columnNameString
    "return the value of the current row/column named columnNameString"

    ^ self subclassResponsibility
!

atIndex:columnIndex
    "return the value in the current row/column number columnIndex (1-based)"

    ^ self subclassResponsibility
!

columnNames
    "answer an array containing the column names of the query"

    ^ self subclassResponsibility
! !

!Cursor methodsFor:'enumerating'!

collect:aBlock
    "for each element in the receiver, evaluate the argument, aBlock
     and return a new collection with the results"

    |newCollection|

    newCollection := OrderedCollection new.
    self do:[:cursorForEachRow | newCollection add:(aBlock value:cursorForEachRow)].
    ^ newCollection
!

do: aBlock
    "Enumerates over all rows in a cursor"

    [ self next notNil ] whileTrue:[
        aBlock value: self
    ].

    "Created: / 31-08-2011 / 16:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

upToEnd
    ^ self collect:[:cursorForEachRow| cursorForEachRow rowAsDictionary].
! !

!Cursor methodsFor:'fetching'!

fetchInto:anObject
    "fetch the data from the current row into an object"

    self columnNames keysAndValuesDo:[:eachColumnIndex :eachColumnName|
        anObject perform:(eachColumnName, ':') asLowercase asSymbol with:(self atIndex:eachColumnIndex).
    ].
    ^ anObject
!

nextRowAsArray
    "advance and answer the next row as an array"

    ^ self 
        next;
        rowAsArray
!

rowAs:dictionaryClass
    "answer the current row as some Dictionary (columnName -> columnValue).
     dictionaryClass needs to implement #at:put:"

    ^ self subclassResponsibility
!

rowAsArray
    "answer the current row as an array"
    
    ^ self subclassResponsibility
!

rowAsDictionary
    "answer the current row as a Dictionary (columnName -> columnValue)"

    ^ self rowAs:Dictionary
!

rowAsObject
    "answer the current row as an object which understands getter methods as per column"

    |currentRow|

    currentRow := self rowAsArray.
    currentRow isNil ifTrue:[
        "there is no row"
        ^ nil
    ].

    objectClass isNil ifTrue:[
        |names|

        names := self columnNames collect:[:each| each asLowercase asSymbol] as:Array.  
        objectClass := self session cachedRowObjectClasses 
                            at:names 
                            ifAbsentPut:[
                                SQL::DatabaseRowObject subclassForNames:names
                            ].
    ].

    ^ objectClass fromArray:currentRow.

    "Modified: / 17-07-2006 / 13:20:46 / cg"
!

rowAsOrderedDictionary
    "answer the current row as an OrderedDictionary (columnName -> columnValue)"

    ^ self rowAs:OrderedDictionary
! !

!Cursor methodsFor:'positioning'!

next
    "advance the cursor to the next row.
     Answer nil, if there are no more rows in the cursor."

    ^ self subclassResponsibility
! !

!Cursor methodsFor:'queries'!

rowSize
    "return the number of columns in each row"

    ^ self subclassResponsibility
!

session
    "answer the session for this cursor"

    ^ self subclassResponsibility
! !

!Cursor methodsFor:'releasing'!

cancel
    "cancel the cursor, no further access is possible"

    ^ self subclassResponsibility
!

release
    "release the cursor and all associated data,
     no further access is possible"

    ^ self subclassResponsibility

    "Created: / 05-01-2012 / 15:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Cursor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__Cursor.st,v 1.14 2016-03-01 16:14:35 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__Cursor.st,v 1.14 2016-03-01 16:14:35 stefan Exp $'
! !


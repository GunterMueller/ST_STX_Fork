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
"{ Package: 'stx:libdb/libsqlite' }"

Object subclass:#SqliteResult
	instanceVariableNames:'buffer rows columns columnNames index'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite-Internals'
!

!SqliteResult class methodsFor:'documentation'!

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
! !

!SqliteResult class methodsFor:'as yet unclassified'!

buffer: aResultBuffer rows: nRows columns: nColumns
    ^ self new setBuffer: aResultBuffer rows: nRows columns: nColumns
! !

!SqliteResult class methodsFor:'queries'!

messageForErrorNumber:nr
    nr <= 26 ifTrue:[
        ^ #(
            "SQLITE_OK           0   " 'Successful result'
            "SQLITE_ERROR        1   " 'SQL error or missing database'
            "SQLITE_INTERNAL     2   " 'Internal logic error in SQLite'
            "SQLITE_PERM         3   " 'Access permission denied'
            "SQLITE_ABORT        4   " 'Callback routine requested an abort'
            "SQLITE_BUSY         5   " 'The database file is locked'
            "SQLITE_LOCKED       6   " 'A table in the database is locked'
            "SQLITE_NOMEM        7   " 'A malloc() failed'
            "SQLITE_READONLY     8   " 'Attempt to write a readonly database'
            "SQLITE_INTERRUPT    9   " 'Operation terminated by sqlite3_interrupt('
            "SQLITE_IOERR       10   " 'Some kind of disk I/O error occurred'
            "SQLITE_CORRUPT     11   " 'The database disk image is malformed'
            "SQLITE_NOTFOUND    12   " 'NOT USED. Table or record not found'
            "SQLITE_FULL        13   " 'Insertion failed because database is full'
            "SQLITE_CANTOPEN    14   " 'Unable to open the database file'
            "SQLITE_PROTOCOL    15   " 'Database lock protocol error'
            "SQLITE_EMPTY       16   " 'Database is empty'
            "SQLITE_SCHEMA      17   " 'The database schema changed'
            "SQLITE_TOOBIG      18   " 'String or BLOB exceeds size limit'
            "SQLITE_CONSTRAINT  19   " 'Abort due to constraint violation'
            "SQLITE_MISMATCH    20   " 'Data type mismatch'
            "SQLITE_MISUSE      21   " 'Library used incorrectly'
            "SQLITE_NOLFS       22   " 'Uses OS features not supported on host'
            "SQLITE_AUTH        23   " 'Authorization denied'
            "SQLITE_FORMAT      24   " 'Auxiliary database format error'
            "SQLITE_RANGE       25   " '2nd parameter to sqlite3_bind out of range'
            "SQLITE_NOTADB      26   " 'File opened that is not a database file'
        ) at:nr+1.
    ].

    nr == 100 ifTrue:[
        ^ "SQLITE_ROW         100  " 'sqlite3_step() has another row ready'
    ].
    nr == 101 ifTrue:[
        ^ "SQLITE_DONE        101  " 'sqlite3_step() has finished executing'
    ].
    ^ 'other error'

    "Created: / 19-10-2010 / 22:56:20 / cg"
! !

!SqliteResult methodsFor:'as yet unclassified'!

currentAddress
    |bytePointers bytes base current|

    bytePointers := buffer "(buffer pointerAt:1)" asExternalBytes.
    bytePointers setSize:(1 + ((index - 1) * 4) + 3).
    bytes := bytePointers pointerAt:(1 + ((index - 1) * 4)).
    ^ bytes.

    bytes _ buffer value getHandle asByteArrayPointer.
    base _ bytes unsignedLongAt: 1.
    current _ base + (index - 1 * 4).
    bytes unsignedLongAt: 1 put: current.
    ^ bytes asExternalPointer

    "Modified: / 11-10-2010 / 12:40:37 / cg"
!

nextString
    |str|

    buffer isNil ifTrue: [self error: 'Result has been freed'].
    str := self readString.
    index := index + 1.
    ^ str

    "Modified: / 18-11-2011 / 14:54:20 / cg"
!

readColumns
    columnNames _ OrderedCollection new.
    columns timesRepeat: [columnNames add: self nextString]
!

readString
    ^ self readStringAtAddress: (self currentAddress)
!

readStringAtAddress: anAddress
    |deref i char|

    anAddress isNull ifTrue:[^ nil].

    ^ anAddress copyCStringFromHeap
"/    deref _ anAddress pointerAt: 1.
"/    (deref allSatisfy: [:ea | ea = 0]) ifTrue: [^ nil].
"/    ^ String streamContents:
"/        [:stream |
"/        i _ 1.
"/        [(char _ deref unsignedCharAt: i) asciiValue = 0] 
"/            whileFalse:
"/                [stream nextPut: char isoToSqueak.
"/                 i _ i + 1]]

    "Modified: / 26-10-2010 / 23:18:11 / cg"
!

setBuffer: aResultBuffer rows: nRows columns: nColumns
    buffer _ aResultBuffer.
    rows _ nRows.
    columns _ nColumns.
    self reset.
! !

!SqliteResult methodsFor:'public'!

allRows
    |rows|

    rows := OrderedCollection new.
    [ self atEnd ] whileFalse:[
        rows add: (self nextRow )
    ].
    ^ rows

    "Created: / 11-04-2012 / 09:53:54 / cg"
!

atEnd
    ^ index > (rows + 1 * columns)
!

columnNames
    ^ columnNames
!

do: aBlock
    self reset.
    rows timesRepeat: [aBlock value: self nextRow].
    
!

free
    SqliteLibrary default freeResultBuffer: buffer.
    buffer _ nil.
!

nextKeysAndValuesDo: aBlock
    self atEnd ifTrue: [self error: 'Trying to read past end of results'].
    columnNames do: [:ea | aBlock value: ea value: self nextString]

    "Modified: / 26-10-2010 / 23:16:11 / cg"
!

nextRow
    |row|
    row _ Dictionary new.
    self nextKeysAndValuesDo: [:k :v | row at: k put: v].
    ^ row
!

nextValues
    ^ columnNames collect: [:ea | self nextString]
!

numColumns
    ^ columns

    "Created: / 26-12-2011 / 01:46:56 / cg"
!

numRows
    ^ rows

    "Created: / 26-12-2011 / 01:46:45 / cg"
!

reset
    index _ 1.
    self readColumns.
! !

!SqliteResult class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SqliteResult.st,v 1.11 2013-03-06 17:13:34 cg Exp $'
! !


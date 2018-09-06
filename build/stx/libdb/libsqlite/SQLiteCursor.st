"{ Package: 'stx:libdb/libsqlite' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SQLiteCursor
	instanceVariableNames:'statement result resultStream row descriptions'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite'
!

!SQLiteCursor class methodsFor:'documentation'!

documentation
"
    Instances of SQLiteCursor represents a query result. 

    Note: This class does not inherit from SQL::Cursor by
    purpose - libsqlite should be lite and independent.
    However, it conforms its SQL::Cursor protocol, so the code
    written for ODBC-based databases should also work for
    with SQLite.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        SQL::Cursor

"
! !

!SQLiteCursor class methodsFor:'utilities'!

checkAPI
    "Checks if SQLite cursor supports whole protocol of
     SQL::Cursor. It does not inherit from SQL::Cursor by
     purpose"

    "        
    SQLiteCursor checkAPI
    "

    SQL::Cursor allSelectors do:[:sel|
        (SQLiteCursor canUnderstand: sel) ifFalse:[
            Transcript showCR: 'SQLiteCursor >> #',sel,' should be implemented'.
            self error:'SQLiteCursor does not implement #',sel mayProceed: true.
        ]
    ]

    "Created: / 20-01-2012 / 11:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteCursor methodsFor:'accessing'!

columnDescriptions
    ^descriptions

    "Created: / 11-05-2012 / 11:54:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteCursor methodsFor:'accessing columns'!

at:columnNameString
    "return the value of the current row/column named columnNameString"

    ^row at: columnNameString

    "Modified: / 31-08-2011 / 16:42:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

atIndex:columnIndex

    ^self at: (self columnNames at: columnIndex)

    "Modified: / 31-08-2011 / 16:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

columnNames
    "answer an array containing the column names of the query"

    ^result columnNames

    "Modified: / 31-08-2011 / 16:42:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fetchInto:anObject
    "fetch the data from the current row into an object"

    ^ self shouldImplement

    "Modified (comment): / 31-08-2011 / 16:46:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rowAs:classKind
    "answer the current row as an instance of classKind"

    ^ self columnDescriptions collect:[:d|self at: d name] as:classKind
!

rowAsArray
    "answer the current row as an array"

    ^ self columnDescriptions collect:[:d|self at: d name]

    "Modified: / 11-05-2012 / 12:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rowAsDictionary
    "answer the current row as a Dictionary
     (columnName->columnValue)"

    ^ row

    "Modified: / 31-08-2011 / 16:43:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rowAsObject
    "answer the current row as an object (with getter per col)"

    "FIXME: must inherit form SQL::Cursor"

    ^ self shouldImplement

    "Modified: / 31-08-2011 / 16:45:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rowAsOrderedDictionary
    "answer the current row as an OrderedDictionary"

    ^ self rowAs:OrderedDictionary
! !

!SQLiteCursor methodsFor:'enumerating'!

collect:aBlock
    "for each element in the receiver, evaluate the argument, aBlock
     and return a new collection with the results"

    |newCollection|

    newCollection := OrderedCollection new.
    self do:[:cursorForEachRow | newCollection add:(aBlock value:cursorForEachRow)].
    ^ newCollection

    "Created: / 29-11-2013 / 17:01:46 / cg"
!

do: aBlock

    "Enumerates over all rows in a cursor"

    [ self next notNil ] whileTrue:[
        aBlock value: self
    ].

    "Created: / 31-08-2011 / 16:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteCursor methodsFor:'initialization'!

appendResult: anArray"of Dictionaries"
    result isNil ifTrue:[
        result := anArray
    ] ifFalse:[
        result := result , anArray
    ]

    "Created: / 26-01-2012 / 11:30:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setColumnNames: names types: types

    descriptions notNil ifTrue:[
        self assert: descriptions size == names size.
        self assert: descriptions size == types size.
        descriptions do:[:desc :idx|
            self assert: desc typeId = (types at: desc index).
            self assert: desc name   = (names at: desc index).
        ].
    ] ifFalse:[
        descriptions := Array new: names size.
        1 to: descriptions size do: [:i|
            descriptions at: i put:
                (SQLiteColumnDescription 
                    name: (names at: i)
                    index: i
                    type: (types at: i))
        ].
    ]

    "Created: / 14-05-2012 / 15:08:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setResult: anArray"of Dictionaries"
    result := anArray

    "Created: / 31-08-2011 / 16:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setStatement: aSQLiteStatement
    statement := aSQLiteStatement

    "Created: / 26-01-2012 / 11:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteCursor methodsFor:'positioning'!

next
    "advance the cursor to the next row"

    resultStream isNil ifTrue:[
        resultStream := result readStream.
    ].

    resultStream atEnd ifTrue:[
        row := nil.
        ^nil "/ MUST BE SO - ask stefan
    ].
    row := resultStream next.

    ^self "/ MUST BE SO - ask stefan

    "Modified: / 26-01-2012 / 11:28:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteCursor methodsFor:'queries'!

numberOfColumns
    "return the number of columns in each row"

    ^ descriptions size

    "Created: / 29-11-2013 / 18:50:39 / cg"
!

rowSize
    "return the number of columns in each row"

    ^ result numColumns

    "Modified: / 05-01-2012 / 14:59:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

session
    "answer the database session/connection"

    ^ statement connection
! !

!SQLiteCursor methodsFor:'releasing'!

cancel
    "cancel the cursor, no further access is possible"

    ^ self release

    "Modified: / 05-01-2012 / 15:28:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    "release the cursor and all associated data,
     no further access is possible"

    ^ result := nil

    "Created: / 05-01-2012 / 15:28:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteCursor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteCursor.st,v 1.12 2016-03-01 16:16:52 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteCursor.st,v 1.12 2016-03-01 16:16:52 stefan Exp $'
! !


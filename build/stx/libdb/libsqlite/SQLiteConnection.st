"{ Package: 'stx:libdb/libsqlite' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SQLiteConnection
	instanceVariableNames:'reference fileName statements'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite'
!

!SQLiteConnection class methodsFor:'documentation'!

documentation
"
    Description:

    This is a first cut at an FFI wrapper for SQLite3 based on Avi Bryant's wrapper for
    SQLite version 2.

    It requires the FFI plugin (SqueakFFIPrims), and SQLite3 (it comes with Tiger, but you can
    also get it and documentation from http://www.hwaci.com/sw/sqlite).

    The wrapper has only been tested with Squeak 3.8 and Mac OS X Tiger (10.4.2).
    If there is a desire for it, I may try to make it work smoothly on other platforms.
    In order to load the library on Mac OS X, you should execute the following EXACT commands
    in the Terminal:

	sudo mkdir /System/Library/Frameworks/libsqlite3.framework
	sudo ln -s /usr/local/lib/libsqlite3.dylib /System/Library/Frameworks/libsqlite3.framework/libsqlite3

    The wrapper is simply a modification of Avi's code, so they will not work side by side.

    It passes Avi's test code for me:

	|con s1 s2 s3 arrayOfDicts|

	con := SQLiteConnection fileNamed: 'test.db'.
	con inspect.
	s1 := 'create table employee (id, name)'.
	s2 := 'insert into employee values (1, ''Adam'')'.
	s3 := 'insert into employee values (2, ''Eve'')'.
	(Array
	    with: s1
	    with: s2
	    with: s3)
	do: [:sql | con executeQuery: sql].
	arrayOfDicts := con executeQuery: 'SELECT * FROM employee'.
	arrayOfDicts inspect.
	con close.

    Note that if you are having trouble getting FFI to find the library and functions,
    you may need to inspect SqliteLibrary, and set the default class variable default to nil and
    try again.

    Releases

    * 1-0.1.0 - A simple FFI wrapper for SQLite3 on Mac OS X 10.4 (Tiger)
"
! !

!SQLiteConnection class methodsFor:'instance creation'!

fileNamed: aFilenameOrString
    ^ self new fileName: aFilenameOrString
! !

!SQLiteConnection methodsFor:'accessing'!

handle
    ^ reference
! !

!SQLiteConnection methodsFor:'finalization'!

disconnect
    self close.

    "Created: / 04-04-2012 / 15:18:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalize
    self close.
!

register
    self registerForFinalization.
    "/ self class registry add: self
!

unregister
    self unregisterForFinalization
    "/ self class registry remove: self ifAbsent: []
! !

!SQLiteConnection methodsFor:'private'!

close

    statements notNil ifTrue:[
        statements copy do:[:each|each release].
        self assert: statements isEmpty.
    ].
    self unregister.
    self isOpen ifTrue: [
        SqliteLibrary default close:reference.
    ].
    reference := nil.

    "Modified: / 26-01-2012 / 10:33:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileName: aString
    fileName _ aString
!

isOpen
    ^ reference notNil and: [reference address ~~ 0]
!

open
    self isOpen ifFalse:[
        reference := SqliteLibrary default open:(fileName asFilename pathName).
        self register.
    ].

    "Modified: / 15-11-2010 / 10:16:35 / cg"
    "Modified: / 13-06-2011 / 22:13:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releaseStatement: statement

    statements remove: statement ifAbsent:[
        self error: 'Statement already released'
    ].

    "Created: / 26-01-2012 / 10:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteConnection methodsFor:'public'!

changedRows
    ^ self isOpen
	ifTrue: [SqliteLibrary default changedRows: reference]
	ifFalse: [0]

!

executeQuery: query
    "Evaluates SQL query and returns an open SQLiteCursor containg the result"

    "JV@2012-05-14: Changed to use prepared statements, as this
     does not result in unnecessary data copying and does not
     discard type information"

    | stmt cursor |

    self isOpen ifFalse: [self open].
    [
        stmt := self newStatementFor: query.
        stmt prepare.
        cursor := stmt execute.
    ] ensure:[
        stmt notNil ifTrue:[ stmt release ].
    ].
    ^cursor
    

"/    
"/     conn executeQuery:('INSERT INTO myTable (name, telno) VALUES ("miller", "0815")
"/

    "Modified: / 10-04-2011 / 11:33:22 / cg"
    "Modified: / 14-05-2012 / 17:06:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeQuery:aString with:param
    "execute an sql statement. Return the resulting row."

    ^ self executeQuery:(aString bindWith:param) 

"/    
"/     conn executeQuery:('INSERT INTO myTable (name, telno) VALUES ("miller", "0815")
"/

    "Created: / 10-04-2011 / 11:34:07 / cg"
!

executeQuery:aString with:param1 with:param2
    "execute an sql statement. Return the resulting row."

    ^ self executeQuery:(aString bindWith:param1 with:param2) 

"/    
"/     conn executeQuery:('INSERT INTO myTable (name, telno) VALUES ("miller", "0815")
"/

    "Created: / 10-04-2011 / 11:34:18 / cg"
!

executeQuery:aString with:param1 with:param2 with:param3
    "execute an sql statement. Return the resulting row."

    ^ self executeQuery:(aString bindWith:param1 with:param2 with:param3) 

"/    
"/     conn executeQuery:('INSERT INTO myTable (name, telno) VALUES ("miller", "0815")
"/

    "Created: / 10-04-2011 / 11:34:26 / cg"
!

executeQuery:aString with:param1 with:param2 with:param3 with:param4
    "execute an sql statement. Return the resulting row."

    ^ self executeQuery:(aString bindWith:param1 with:param2 with:param3 with:param4) 

"/    
"/     conn executeQuery:('INSERT INTO myTable (name, telno) VALUES ("miller", "0815")
"/

    "Created: / 10-04-2011 / 11:34:35 / cg"
!

fileName
    ^ fileName
!

lastInsertId
    self isOpen ifFalse:[^ 0].
    ^ SqliteLibrary default lastInsertId:reference
!

tables
    "preliminary - do not depend on this for now"

    |rslt|

    rslt := self executeQuery:'SELECT name FROM sqlite_master WHERE type=''table'';'.
    ^ rslt 
        collect:[:each |
            SQL::DatabaseTableDescription new
                        name:(each at:#name)
                        catalog:nil 
                        schema:nil 
                        type:nil 
                        comment:nil.
        ]

    "Modified (comment): / 29-11-2013 / 21:47:58 / cg"
!

withResultForQuery: aString do: aBlock
    |result|

    self isOpen ifFalse: [self open].
    result := SqliteLibrary default resultForQuery: aString on: reference.
    ^ [aBlock value: result] ensure: [result free]

    "Modified: / 10-04-2011 / 11:31:39 / cg"
! !

!SQLiteConnection methodsFor:'statements'!

newStatement
    "return a new statement for the text aStatementText. 
     Different statement types could be returned depending on the text.

     ^<SQLiteStatement>"

    statements isNil ifTrue:[
        statements := Set new.
    ].
    ^ statements add: (SQLiteStatement new setConnection: self)

    "Created: / 26-01-2012 / 10:23:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newStatementFor:aString 
    "return a new statement for the text aStatementText. 
     Different statement types could be returned depending on the text.

     ^<SQLiteStatement>"

    ^self newStatement query: aString

    "Modified: / 26-01-2012 / 10:24:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteConnection class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteConnection.st,v 1.26 2016-11-02 16:30:40 cg Exp $'
! !


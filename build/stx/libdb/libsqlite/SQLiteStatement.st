"{ Package: 'stx:libdb/libsqlite' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SQLiteStatement
	instanceVariableNames:'handle connection query bindValues mustBind pool'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite'
!


!SQLiteStatement methodsFor:'accessing'!

connection
    ^ connection
!

query
    ^ query
!

query:aString

    query notNil ifTrue:[
        self error: 'Query string already set'.
    ].
    query := aString.

    "Modified: / 20-01-2012 / 12:11:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteStatement methodsFor:'execution'!

bindValues: values
    "Bind statement variables. 'values' is a collection of ROWS!!!!!!"

    self clearParameters.
    bindValues := values.
    mustBind := values notNil.

    "Created: / 20-01-2012 / 12:17:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

execute
    "Executes the statement and returns cursor on result (possibly empty)"
    | cursor |

    handle isNil ifTrue:[self prepare].
    cursor := SQLiteCursor new setStatement: self.
    (mustBind or:[bindValues size > 1]) ifTrue:[
        bindValues do:[:row|
            self bindParameters: row.
            self executeResultInto: cursor.
            self clearParameters.
            self reset.
        ]
    ] ifFalse:[
        self executeResultInto: cursor.        
        self reset.
    ].
    ^cursor

    "Created: / 25-01-2012 / 20:12:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeDirect
    "for compatibility with odbc cursors. Same as execute.
     Executes the statement and returns cursor on result (possibly empty)"

    ^ self execute
!

prepare
    "Prepares the statement so it can be executed later using #execute"

    connection isNil ifTrue:[
        self error: 'Statement released'.
    ].
    handle notNil ifTrue:[ ^ self ]. "/already prepared.
    handle := SqliteLibrary default statementPrepare: query on: connection handle.
    handle isNil ifTrue:[
        self error:'Error when preparing statement: no handle returned'.
        ^self.
    ].
    self register.

    "Created: / 25-01-2012 / 17:19:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteStatement methodsFor:'finalization'!

finalize
    self release.

    "Modified: / 26-01-2012 / 10:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

register
    self registerForFinalization.
    "/ self class registry add: self
!

unregister
    self unregisterForFinalization
    "/ self class registry remove: self ifAbsent: []
! !

!SQLiteStatement methodsFor:'initialization'!

setConnection: aSQLiteConnection

    bindValues := nil.
    mustBind := false.
    connection := aSQLiteConnection

    "Created: / 20-01-2012 / 12:12:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setConnection: aSQLiteConnection query: aString

    self setConnection: aSQLiteConnection.
    self query: aString

    "Created: / 20-01-2012 / 12:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteStatement methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    query printOn:aStream.
    aStream nextPut:$).

    "Modified: / 23-05-2012 / 10:30:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteStatement methodsFor:'private'!

bindParameters: row
    | nParams lib |

    "Named parameter not yet supported"
    self assert: row isSequenceable.
    lib := SqliteLibrary default.
    pool := OrderedCollection new: row size.
    nParams := lib statementParameterCount: handle.
    row size ~~ nParams ifTrue:[
        self error:'Number of passed parameters does not match parameters in the query'.
    ].
    1 to: nParams do:[:i|
        | eb |

        eb := lib statementParameter: handle bind: i to: (row at: i).
        eb notNil ifTrue:[
            pool add: eb
        ]
    ].

    "Created: / 26-01-2012 / 12:04:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

clearParameters
    handle notNil ifTrue:[
        SqliteLibrary default statementParametersClear: handle
    ].
    self releasePool.

    "Created: / 26-01-2012 / 11:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeResultInto: cursor
    handle isNil ifTrue:[ self prepare ].
    [
        SqliteLibrary default statementExecute: handle withResultDo:[:result :names :types|
            cursor setColumnNames: names types: types.
            cursor appendResult: result.
        ]
    ] ensure:[
        SqliteLibrary default statementReset: handle.
    ].

    "Created: / 26-01-2012 / 11:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteStatement methodsFor:'release'!

release
    "Releases a statement. Released statement cannot be executed"

    connection isNil ifTrue:[ ^ self ]. "/already released
    SqliteLibrary default statementFinalize: handle.
    connection releaseStatement: self.
    handle := nil.
    connection := nil.
    self releasePool.
    self unregister.

    "Created: / 25-01-2012 / 17:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releasePool
    "Releases all external bytes allocated for parameters"

    pool notNil ifTrue:[
        pool do:[:each|each free].
    ].
    pool := nil.

    "Created: / 05-06-2012 / 13:22:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset

    handle isNil ifTrue:[^self].
    SqliteLibrary default statementReset: handle.

    "Created: / 25-01-2012 / 23:14:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteStatement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteStatement.st,v 1.12 2016-08-08 17:41:41 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteStatement.st,v 1.12 2016-08-08 17:41:41 mawalch Exp $'
! !


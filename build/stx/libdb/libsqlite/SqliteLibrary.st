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

"{ NameSpace: Smalltalk }"

ExternalLibrary subclass:#SqliteLibrary
	instanceVariableNames:''
	classVariableNames:'SQLiteLibraryPath'
	poolDictionaries:'SqliteResultCodes'
	category:'DataBase-SQLite-Internals'
!

!SqliteLibrary class methodsFor:'documentation'!

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

!SqliteLibrary class methodsFor:'accessing'!

default
    default isNil ifTrue: [default := super new].
    ^ default

    "Modified: / 18-11-2011 / 14:54:05 / cg"
!

dllPath
    "guess where the sqlite3.dll library is found"

    |path|

    path := OrderedCollection new.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        path addAll:#( 'C:\Windows' 'C:\Windows\System32' "Wild guess, should not harm" ).

        "/ for windows systems, we provide a dll...
        ExternalAddress pointerSize == 4 ifTrue:[
            path add:(self packageDirectory / 'support/win32')
        ] ifFalse:[
            path add:(self packageDirectory / 'support/win64')
        ].
        ^ path
    ].

    OperatingSystem isUNIXlike ifTrue:[
        path addAll:#( '/lib' '/usr/lib' '/usr/local/lib' ).

        OperatingSystem getSystemType == #linux ifTrue:[
            (OperatingSystem getSystemInfo at:#machine) = 'x86_64' ifTrue:[
                "If the machine is 64bit, prepend standard path for 32bit libs.
                 Leave standard paths at the end, as the system might be completely
                 32bit but running on 64bit-capable CPU.

                CAVEAT: This is bit dangerous, as on 64bit OS, if ia32 libs are
                not installed but 64bit sqlite libs are, then 64bit libs are found
                and when a function is called, segfault will occur!!

                Q: Is there a way how to figure out if the OS itself is 32bit,
                regardles on CPU?"
                ExternalAddress pointerSize == 4 ifTrue:[
                    path addAllFirst: #( '/lib32' '/usr/lib32' '/usr/local/lib32' ).
                ] ifFalse:[
                    path addAllFirst: #( '/lib64' '/usr/lib64' '/usr/local/lib64' ).
                ].
            ].
        ].
        ^ path.
    ].

    "/ if we ever have to support VMS again, add code here ;-)    
    self error:'Unsupported operating system'

    "
        SqliteLibrary dllPath
    "

    "Created: / 31-08-2011 / 18:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2013 / 16:58:46 / cg"
!

libraryName

    SQLiteLibraryPath notNil ifTrue:[
	^SQLiteLibraryPath
    ].

    OperatingSystem isMSWINDOWSlike ifTrue:[
	^ 'sqlite3'
    ].

    OperatingSystem isUNIXlike ifTrue:[
	OperatingSystem getSystemType == #linux ifTrue:[
	    "/JV@2011-02-03: Used to be
	    "/ ^ 'libsqlite3.so'
	    "/ but is seems that SuSE has only .so.0 version.
	    "/ this file exists also on Ubuntu/Linux Mint,
	    "/ hopefully all modern Linux distributions contains
	    "/ .so.0 version
	    ^ 'libsqlite3.so.0'
	].
	OperatingSystem getSystemType == #osx ifTrue:[
	    ^ 'libsqlite3.dylib'
	].
	^ 'libsqlite3.so'
    ].

    self error:'Unsupported operating system'

    "
	SqliteLibrary libraryName
	SQLiteLibraryPath := '/home/jv/Private/Projects/SmalltalkX/sqlite-autoconf-3071000-32bit/dist/lib/libsqlite3.so.0.8.6'
    "

    "Created: / 31-08-2011 / 17:56:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moduleName
    ^ 'sqlite3'
    "/ ^ 'libsqlite3.framework'
! !

!SqliteLibrary methodsFor:'api'!

apiBindBlob: handle index: index value: value size: size destructor: mustBeNil
    "Binds Value To Prepared Statement"
    "
    int sqlite3_bind_blob(sqlite3_stmt*, int, const char*, int n, void(*)(void*));
    "
    <cdecl: int 'sqlite3_bind_blob' (handle int char* int void*) >
    ^ self externalCallFailed

    "Created: / 26-01-2012 / 12:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiBindDouble: handle index: index value: value
    "Binds Value To Prepared Statement"
    "
    int sqlite3_bind_double(sqlite3_stmt*, int, int);
    "
    <cdecl: int 'sqlite3_bind_double' (handle int double) >
    ^ self externalCallFailed

    "Created: / 26-01-2012 / 12:19:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiBindInt: handle index: index value: value
    "Binds Value To Prepared Statement"
    "
    int sqlite3_bind_int(sqlite3_stmt*, int, int);
    "
    <cdecl: int 'sqlite3_bind_int' (handle int int) >
    ^ self externalCallFailed

    "Created: / 26-01-2012 / 11:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiBindNull: handle index: index
    "Binds Value To Prepared Statement"
    "
    int sqlite3_bind_null(sqlite3_stmt*, int);
    "
    <cdecl: int 'sqlite3_bind_null' (handle int) >
    ^ self externalCallFailed

    "Created: / 26-01-2012 / 12:20:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiBindParameterCount: handle
    "Return Number Of SQL Parameters"
    "
    This routine can be used to find the number of SQL parameters in
    a prepared statement. SQL parameters are tokens of the form
    '?', '?NNN', ':AAA', '$AAA', or '@AAA' that serve as placeholders
    for values that are bound to the parameters at a later time.

    This routine actually returns the index of the largest (rightmost)
    parameter. For all forms except ?NNN, this will correspond to the
    number of unique parameters. If parameters of the ?NNN form are
    used, there may be gaps in the list.

    See also: sqlite3_bind(), sqlite3_bind_parameter_name(), and
    sqlite3_bind_parameter_index().

    int sqlite3_bind_parameter_count(sqlite3_stmt*);

    "
    <cdecl: int 'sqlite3_bind_parameter_count' (handle) >
    ^ self externalCallFailed

    "Created: / 26-01-2012 / 11:38:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiBindText: handle index: index value: value size: size destructor: mustBeNil
    "Binds Value To Prepared Statement"
    "
    int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int n, void(*)(void*));
    "
    <cdecl: int 'sqlite3_bind_text' (handle int char* int void*) >
    ^ self externalCallFailed

    "Created: / 26-01-2012 / 12:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiChanges: sqlite
    "int sqlite_changes(sqlite*)"
    <cdecl: long 'sqlite3_changes' (handle)>
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiClearBindings: statementHandle
    "Reset All Bindings On A Prepared Statement"
    "
     Contrary to the intuition of many, sqlite3_reset() does not reset
     the bindings on a prepared statement. Use this routine to reset
     all host parameters to NULL.

     See also lists of Objects, Constants, and Functions.

     int sqlite3_clear_bindings(sqlite3_stmt*);
    "

    <cdecl: long 'sqlite3_clear_bindings' (handle) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 21:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiClose: sqlite
    "int sqlite3_close(sqlite3*)"

    <cdecl: long 'sqlite3_close' (handle)>
    ^ self externalCallFailed

    "Modified: / 01-09-2011 / 13:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnCount: statementHandle
    "Returns a number Of Columns In A Result Set"
    "
     Return the number of columns in the result set returned
     by the prepared statement. This routine returns 0 if pStmt
     is an SQL statement that does not return data (for example
     an UPDATE).

     int sqlite3_column_count(sqlite3_stmt *pStmt);
    "

    <cdecl: long 'sqlite3_column_count' (handle) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 21:24:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnDouble: statementHandle index: i
    "
    double sqlite3_column_double(sqlite3_stmt*, int iCol);
    "
    <cdecl: double 'sqlite3_column_double' (handle int) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 22:44:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnInt:aStatementHandle iCol:iCol
    "int sqlite3_column_int(sqlite3_stmt*, int iCol)"

    <cdecl: long 'sqlite3_column_int' (handle long)>
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:06:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnInt: statementHandle index: i
    "
    int sqlite3_column_int(sqlite3_stmt*, int iCol);
    "
    <cdecl: int 'sqlite3_column_int' (handle int) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 22:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnName: statementHandle index: i
    "Return a column names in a result set"
    "
     These routines return the name assigned to a particular
     column in the result set of a SELECT statement. The
     sqlite3_column_name() interface returns a pointer to a
     zero-terminated UTF-8 string and sqlite3_column_name16()
     returns a pointer to a zero-terminated UTF-16 string. The
     first parameter is the prepared statement that implements
     the SELECT statement. The second parameter is the column
     number. The leftmost column is number 0.

     The returned string pointer is valid until either the prepared
     statement is destroyed by sqlite3_finalize() or until the
     statement is automatically reprepared by the first call to
     sqlite3_step() for a particular run or until the next call
     to sqlite3_column_name() or sqlite3_column_name16() on the
     same column.

     If sqlite3_malloc() fails during the processing of either
     routine (for example during a conversion from UTF-8 to UTF-16)
     then a NULL pointer is returned.

     The name of a result column is the value of the 'AS' clause for
     that column, if there is an AS clause. If there is no AS clause
     then the name of the column is unspecified and may change from
     one release of SQLite to the next.

     const char *sqlite3_column_name(sqlite3_stmt*, int N);
    "
    <cdecl: charPointer 'sqlite3_column_name' (handle int) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 22:30:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnText: statementHandle index: i
    "
    const unsigned char *sqlite3_column_text(sqlite3_stmt*, int iCol);
    "
    <cdecl: charPointer 'sqlite3_column_text' (handle int) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 22:43:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiColumnType: statementHandle index: i
    "Return a column names in a result set"
    "
     The sqlite3_column_type() routine returns the datatype code
     for the initial data type of the result column. The returned
     value is one of SQLITE_INTEGER, SQLITE_FLOAT, SQLITE_TEXT,
     SQLITE_BLOB, or SQLITE_NULL. The value returned by
     sqlite3_column_type() is only meaningful if no type
     conversions have occurred as described below. After a
     type conversion, the value returned by sqlite3_column_type()
     is undefined. Future versions of SQLite may change the behavior
     of sqlite3_column_type() following a type conversion.

     int *sqlite3_column_type(sqlite3_stmt*, int N);
    "
    <cdecl: int 'sqlite3_column_type' (handle int) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 22:32:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiErrorMessage: anSqlite
    "const char *sqlite3_errmsg(sqlite3*)"
    <cdecl: SqliteErrorHolder 'sqlite3_errmsg' (handle) >
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiFinalize: statementHandle
    "int sqlite3_finalize(sqlite3_stmt *pStmt)"

    <cdecl: long 'sqlite3_finalize' (handle) >
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiFreeTable: buffer
    "void sqlite3_free_table(char **result)"
    <cdecl: void 'sqlite3_free_table' (handle)>
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiGetTable: anSqlite sql: sql buffer: result rows: nRows columns: nColumns error: errBuffer
    "
int sqlite3_get_table(
  sqlite*,
  char *sql,
  char ***result,
  int *nrow,
  int *ncolumn,
  char **errmsg
)"
    "/ <cdecl: long 'sqlite3_get_table' (handle SqliteReference char* SqliteResultBuffer* long* long* SqliteError*)>
    <cdecl: long 'sqlite3_get_table' (handle char* char*** long* long* char**) >
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiLastInsertId: sqlite
    "long long int sqlite3_last_insert_rowid(sqlite3*)"

    <cdecl: longlong 'sqlite3_last_insert_rowid' (handle)  >
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiOpen: dbName sqlite: sqlite
    "int sqlite3_open(const char*, sqlite3**);"

    <cdecl: long 'sqlite3_open' (char* handle)  >
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiPrepare:aSqlite sql:sql nByte:nByte statementHandle:statementHandle tail:tail
    "
int sqlite3_prepare_v2(
  sqlite3 *db,            /* Database handle */
  const char *zSql,       /* SQL statement, UTF-8 encoded */
  int nByte,              /* Maximum length of zSql in bytes. */
  sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
  const char **pzTail     /* OUT: Pointer to unused portion of zSql */
)"
    "/ <cdecl: long 'sqlite3_get_table' (handle SqliteReference char* SqliteResultBuffer* long* long* SqliteError*)>
    <cdecl: long 'sqlite3_prepare_v2' (handle char* int  handle char**) >
    ^ self externalCallFailed

    "Modified: / 25-01-2012 / 18:25:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiReset: statementHandle
    "The sqlite3_reset() function is called to reset a prepared"
    "
    The sqlite3_reset() function is called to reset a prepared
     statement object back to its initial state, ready to be
     re-executed. Any SQL statement variables that had values bound
     to them using the sqlite3_bind_*() API retain their values. Use
     sqlite3_clear_bindings() to reset the bindings.

    The sqlite3_reset(S) interface resets the prepared statement
    S back to the beginning of its program.

    If the most recent call to sqlite3_step(S) for the prepared
    statement S returned SQLITE_ROW or SQLITE_DONE, or if sqlite3_step(S)
    has never before been called on S, then sqlite3_reset(S) returns
    SQLITE_OK.

    If the most recent call to sqlite3_step(S) for the prepared statement
    S indicated an error, then sqlite3_reset(S) returns an appropriate
    error code.

    The sqlite3_reset(S) interface does not change the values of
    any bindings on the prepared statement S.

    int sqlite3_reset(sqlite3_stmt *pStmt);
   "

    <cdecl: long 'sqlite3_reset' (handle) >
    ^ self externalCallFailed

    "Created: / 25-01-2012 / 21:02:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

apiStep: statementHandle
    "int sqlite3_step(sqlite3_stmt*)"

    <cdecl: long 'sqlite3_step' (handle) >
    ^ self externalCallFailed

    "Modified: / 31-08-2011 / 18:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SqliteLibrary methodsFor:'as yet unclassified'!

changedRows: anSqliteRef
    ^ self apiChanges: anSqliteRef
!

checkError: anErrorMsgHolder
    |message errMsg|

    anErrorMsgHolder address = 0 ifTrue: [^ self].
    errMsg := anErrorMsgHolder pointerAt:1.
    errMsg address = 0 ifTrue: [^ self].
    message := errMsg copyCStringFromHeap.
"/    (anError getHandle allSatisfy: [:i | i = 0]) ifTrue: [^ self].
"/    message := anError value fromCString.
"/    anError free.
    "/ self error: message
    SqliteError raiseRequestErrorString:message

    "Modified: / 27-11-2010 / 11:09:58 / cg"
!

checkErrorInteger: anError
    |message|

    (anError = 0) ifTrue: [^self].

    message := 'Result Code: %1 (%2)' bindWith:anError with:(SqliteResult messageForErrorNumber:anError).
    "/ self error: message
    SqliteError raiseErrorString:message
!

close: anSqliteRef
    | err |
    err _ self apiClose: anSqliteRef.
    self checkErrorInteger: err.
!

freeResultBuffer: aResultBuffer
    self apiFreeTable: aResultBuffer

    "Modified: / 11-10-2010 / 12:33:58 / cg"
!

lastInsertId: anSqliteRef
    ^ self apiLastInsertId: anSqliteRef
!

open: aString
    |err ref|

    ref := ExternalLong new.
    err := self apiOpen: aString sqlite: ref.
    self checkErrorInteger: err.

    ^ ref asPointer
!

resultForQuery: aString on: sqliteRef
    |nrows ncols buffer err|

"/    nrows _ WordArray new: 1.
"/    ncols _ WordArray new: 1.
"/    err _ SqliteError new.
"/    buffer _ SqliteResultBuffer new.
    nrows := ExternalLong new.
    ncols := ExternalLong new.
    err := ExternalLong new. "/ ExternalBytes new:4.   !!!!!! wrong for 64bit machines !!!!!!
    buffer := ExternalLong new. "/ ExternalBytes new:4. !!!!!! wrong for 64bit machines !!!!!!
    self apiGetTable: sqliteRef sql: aString buffer:buffer rows: nrows columns: ncols error: err.
    self checkError: err.

    ^ SqliteResult buffer:(buffer pointerAt:1) rows:(nrows value) columns:(ncols value)

    "Modified: / 19-10-2010 / 23:04:48 / cg"
! !

!SqliteLibrary methodsFor:'statements'!

statementExecute: stmtHandle withResultDo: block
    | rows code nCols colNames colTypes |

    code := self apiStep: stmtHandle.
    rows := OrderedCollection new writeStream.
    code == SQLITE_ROW ifTrue:[
	"Statement returned data..."
	nCols := self apiColumnCount: stmtHandle.
	colNames := Array new: nCols.
	colTypes := Array new: nCols.
	1 to: nCols do:[:i|
	    colNames at:i put: (self apiColumnName: stmtHandle index: i - 1"0-based index!!!!!!").
	    colTypes at:i put: (self apiColumnType: stmtHandle index: i - 1"0-based index!!!!!!").
	].
	[ code == SQLITE_ROW ] whileTrue:[
	    rows nextPut:
		(self statementFetchRow: stmtHandle names: colNames types: colTypes).
	    code := self apiStep: stmtHandle.
	].
    ].
    code ~~ SQLITE_DONE ifTrue:[
	self checkErrorInteger: code.
	^self.
    ].
    ^block value: rows contents value: colNames value: colTypes

    "Created: / 25-01-2012 / 20:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementFetchRow: stmtHandle names: colNames types: colTypes
    | row |

    row := Dictionary new.
    1 to: colNames size do:[:i|
	| t v |

	t := colTypes at: i.
	t == SQLITE_INTEGER ifTrue:[
	    v := self apiColumnInt: stmtHandle index: i - 1.
	] ifFalse:[
	t == SQLITE_FLOAT ifTrue:[
	    v := self apiColumnDouble: stmtHandle index: i - 1.
	] ifFalse:[
	t == SQLITE_TEXT ifTrue:[
	    v := self apiColumnText: stmtHandle index: i - 1.
	] ifFalse:[
	t == SQLITE_NULL ifTrue:[
	    v := nil.
	] ifFalse:[
	t == SQLITE_BLOB ifTrue:[
	    self error: 'Not (yet) supported. Need to read docs'.
	    v := self apiColumnBlob: stmtHandle index: i - 1.
	] ifFalse:[
	    self error: 'Unssuported column type'
	]]]]].
	row at: (colNames at: i) put: v.
    ].
    ^row.

    "Created: / 25-01-2012 / 22:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementFinalize: stmtHandle
    | err |

    err := self apiFinalize: stmtHandle.
    self checkErrorInteger: err.

    "Created: / 25-01-2012 / 20:39:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementParameter: stmtHandle bind: index to: value
    "Given a statement handle, binds a parameter at index to value.
     Returns either nil or an instance of ExternalBytes. These bytes
     MUST be freed when a statement is released. They MUST NOT be freed
     before the statement is executed with given bound value."

    | err eb |

    value isNil ifTrue:[
	err := self apiBindNull: stmtHandle index: index.
	self checkErrorInteger: err.
	^nil.
    ].
    value isInteger ifTrue:[
	err := self apiBindInt: stmtHandle index: index value: value.
	self checkErrorInteger: err.
	^nil.
    ].
    value isString ifTrue:[
	value bitsPerCharacter ~~ 8 ifTrue:[
	    self error:'Multi-byte strings are not supported'.
	    "You must (UTF8)encode them yourself"
	    ^nil
	].
	err := self apiBindText: stmtHandle index: index value: (eb := value asExternalBytesUnprotected) size: value size "means up to first NULL terminator" destructor: nil.
	self checkErrorInteger: err.
	^eb.
    ].
    value isFloat ifTrue:[
	err := self apiBindDouble: stmtHandle index: index value: value asFloat.
	self checkErrorInteger: err.
	^self.
    ].
    (value isByteArray and:[value class ~~ UUID]) ifTrue:[
	err := self apiBindBlob: stmtHandle index: index value: (eb := value asExternalBytesUnprotected) size: value size destructor: nil.
	self checkErrorInteger: err.
	^eb.

    ].

    self statementParameter: stmtHandle bind: index to: value printString.
    ^eb

    "Created: / 26-01-2012 / 11:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementParameterCount: stmtHandle
    ^self apiBindParameterCount: stmtHandle.

    "Created: / 26-01-2012 / 11:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementParametersClear: stmtHandle

    self apiClearBindings: stmtHandle.

    "Created: / 26-01-2012 / 11:48:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementPrepare: query on: sqliteHandle
    | stmtHandleCell tailCell errCode sql|

    stmtHandleCell := ExternalLong new.
    tailCell := ExternalLong new.
    sql := query utf8Encoded.
    errCode := self apiPrepare: sqliteHandle
		    sql: sql nByte: -1 "/means: read up to first null terminator
		    statementHandle: stmtHandleCell
		    tail: tailCell.
    self checkErrorInteger: errCode.

    ^ stmtHandleCell asPointer



"/|nrows ncols buffer err|
"/
"/"/    nrows _ WordArray new: 1.
"/"/    ncols _ WordArray new: 1.
"/"/    err _ SqliteError new.
"/"/    buffer _ SqliteResultBuffer new.
"/    nrows := ExternalLong new.
"/    ncols := ExternalLong new.
"/    err := ExternalBytes new:4.
"/    buffer := ExternalBytes new:4.
"/    self apiGetTable: sqliteRef sql: aString buffer:buffer rows: nrows columns: ncols error: err.
"/    self checkError: err.
"/
"/    ^ SqliteResult buffer:(buffer pointerAt:1) rows:(nrows value) columns:(ncols value)
"/
"/

    "Modified: / 19-10-2010 / 23:04:48 / cg"
    "Created: / 25-01-2012 / 20:39:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statementReset: stmtHandle

    self apiReset: stmtHandle.
    self apiClearBindings: stmtHandle.

    "Created: / 25-01-2012 / 21:16:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SqliteLibrary class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SqliteLibrary.st,v 1.37 2018-02-24 12:14:14 stefan Exp $'
! !


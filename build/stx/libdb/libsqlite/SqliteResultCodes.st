"
 COPYRIGHT (c) 2012 by eXept Software AG
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

SharedPool subclass:#SqliteResultCodes
	instanceVariableNames:''
	classVariableNames:'SQLITE_OK SQLITE_ERROR SQLITE_INTERNAL SQLITE_PERM SQLITE_ABORT
		SQLITE_BUSY SQLITE_LOCKED SQLITE_NOMEM SQLITE_READONLY
		SQLITE_INTERRUPT SQLITE_IOERR SQLITE_NOTFOUND SQLITE_FULL
		SQLITE_CANTOPEN SQLITE_PROTOCOL SQLITE_EMPTY SQLITE_SCHEMA
		SQLITE_TOOBIG SQLITE_CONSTRAINT SQLITE_MISMATCH SQLITE_MISUSE
		SQLITE_NOLFS SQLITE_AUTH SQLITE_FORMAT SQLITE_RANGE SQLITE_NOTADB
		SQLITE_ROW SQLITE_DONE SQLITE_IOERR_READ SQLITE_IOERR_SHORT_READ
		SQLITE_IOERR_WRITE SQLITE_IOERR_FSYNC SQLITE_IOERR_DIR_FSYNC
		SQLITE_IOERR_FSTAT SQLITE_IOERR_UNLOCK SQLITE_IOERR_RDLOCK
		SQLITE_IOERR_DELETE SQLITE_IOERR_BLOCKED SQLITE_IOERR_NOMEM
		SQLITE_IOERR_ACCESS SQLITE_IOERR_CHECKRESERVEDLOCK
		SQLITE_IOERR_LOCK SQLITE_IOERR_CLOSE SQLITE_IOERR_DIR_CLOSE
		SQLITE_IOERR_SHMOPEN SQLITE_IOERR_SHMSIZE SQLITE_IOERR_SHMLOCK
		SQLITE_IOERR_SHMMAP SQLITE_IOERR_SEEK SQLITE_LOCKED_SHAREDCACHE
		SQLITE_BUSY_RECOVERY SQLITE_CANTOPEN_NOTEMPDIR
		SQLITE_CORRUPT_VTAB SQLITE_READONLY_RECOVERY
		SQLITE_READONLY_CANTLOCK SQLITE_INTEGER SQLITE_FLOAT SQLITE_BLOB
		SQLITE_NULL SQLITE_TEXT SQLITE3_TEXT SQLITE_CORRUPT
		SQLITE_IOERR_TRUNCATE'
	poolDictionaries:''
	category:'DataBase-SQLite-Internals'
!

!SqliteResultCodes class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

"
! !

!SqliteResultCodes class methodsFor:'class initialization'!

initialize

    "Result codes - http://www.sqlite.org/capi3ref.html#SQLITE_OK"

    SQLITE_OK        :=   0.   " /* Successful result */ "
    SQLITE_ERROR     :=   1.   " /* SQL error or missing database */ "
    SQLITE_INTERNAL  :=   2.   " /* Internal logic error in SQLite */ "
    SQLITE_PERM      :=   3.   " /* Access permission denied */ "
    SQLITE_ABORT     :=   4.   " /* Callback routine requested an abort */ "
    SQLITE_BUSY      :=   5.   " /* The database file is locked */ "
    SQLITE_LOCKED    :=   6.   " /* A table in the database is locked */ "
    SQLITE_NOMEM     :=   7.   " /* A malloc() failed */ "
    SQLITE_READONLY  :=   8.   " /* Attempt to write a readonly database */ "
    SQLITE_INTERRUPT :=   9.   " /* Operation terminated by sqlite3_interrupt()*/ "
    SQLITE_IOERR     :=  10.  " /* Some kind of disk I/O error occurred */ "
    SQLITE_CORRUPT   :=  11.   " /* The database disk image is malformed */ "
    SQLITE_NOTFOUND  :=  12.   " /* Unknown opcode in sqlite3_file_control() */ "
    SQLITE_FULL      :=  13.   " /* Insertion failed because database is full */ "
    SQLITE_CANTOPEN  :=  14.   " /* Unable to open the database file */ "
    SQLITE_PROTOCOL  :=  15.   " /* Database lock protocol error */ "
    SQLITE_EMPTY     :=  16.   " /* Database is empty */ "
    SQLITE_SCHEMA    :=  17.   " /* The database schema changed */ "
    SQLITE_TOOBIG    :=  18.   " /* String or BLOB exceeds size limit */ "
    SQLITE_CONSTRAINT:=  19.   " /* Abort due to constraint violation */ "
    SQLITE_MISMATCH  :=  20.   " /* Data type mismatch */ "
    SQLITE_MISUSE    :=  21.   " /* Library used incorrectly */ "
    SQLITE_NOLFS     :=  22.   " /* Uses OS features not supported on host */ "
    SQLITE_AUTH      :=  23.   " /* Authorization denied */ "
    SQLITE_FORMAT    :=  24.   " /* Auxiliary database format error */ "
    SQLITE_RANGE     :=  25.   " /* 2nd parameter to sqlite3_bind out of range */ "
    SQLITE_NOTADB    :=  26.   " /* File opened that is not a database file */ "
    SQLITE_ROW       := 100.   " /* sqlite3_step() has another row ready */ "
    SQLITE_DONE      := 101.   " /* sqlite3_step() has finished executing */ "

    "Extended result codes"
    SQLITE_IOERR_READ              := (SQLITE_IOERR | (1<<8)).
    SQLITE_IOERR_SHORT_READ        := (SQLITE_IOERR | (2<<8)).
    SQLITE_IOERR_WRITE             := (SQLITE_IOERR | (3<<8)).
    SQLITE_IOERR_FSYNC             := (SQLITE_IOERR | (4<<8)).
    SQLITE_IOERR_DIR_FSYNC         := (SQLITE_IOERR | (5<<8)).
    SQLITE_IOERR_TRUNCATE          := (SQLITE_IOERR | (6<<8)).
    SQLITE_IOERR_FSTAT             := (SQLITE_IOERR | (7<<8)).
    SQLITE_IOERR_UNLOCK            := (SQLITE_IOERR | (8<<8)).
    SQLITE_IOERR_RDLOCK            := (SQLITE_IOERR | (9<<8)).
    SQLITE_IOERR_DELETE            := (SQLITE_IOERR | (10<<8)).
    SQLITE_IOERR_BLOCKED           := (SQLITE_IOERR | (11<<8)).
    SQLITE_IOERR_NOMEM             := (SQLITE_IOERR | (12<<8)).
    SQLITE_IOERR_ACCESS            := (SQLITE_IOERR | (13<<8)).
    SQLITE_IOERR_CHECKRESERVEDLOCK := (SQLITE_IOERR | (14<<8)).
    SQLITE_IOERR_LOCK              := (SQLITE_IOERR | (15<<8)).
    SQLITE_IOERR_CLOSE             := (SQLITE_IOERR | (16<<8)).
    SQLITE_IOERR_DIR_CLOSE         := (SQLITE_IOERR | (17<<8)).
    SQLITE_IOERR_SHMOPEN           := (SQLITE_IOERR | (18<<8)).
    SQLITE_IOERR_SHMSIZE           := (SQLITE_IOERR | (19<<8)).
    SQLITE_IOERR_SHMLOCK           := (SQLITE_IOERR | (20<<8)).
    SQLITE_IOERR_SHMMAP            := (SQLITE_IOERR | (21<<8)).
    SQLITE_IOERR_SEEK              := (SQLITE_IOERR | (22<<8)).
    SQLITE_LOCKED_SHAREDCACHE      := (SQLITE_LOCKED |  (1<<8)).
    SQLITE_BUSY_RECOVERY           := (SQLITE_BUSY   |  (1<<8)).
    SQLITE_CANTOPEN_NOTEMPDIR      := (SQLITE_CANTOPEN | (1<<8)).
    SQLITE_CORRUPT_VTAB            := (SQLITE_CORRUPT | (1<<8)).
    SQLITE_READONLY_RECOVERY       := (SQLITE_READONLY | (1<<8)).
    SQLITE_READONLY_CANTLOCK       := (SQLITE_READONLY | (2<<8)).

    "Column types"
    SQLITE_INTEGER  := 1.
    SQLITE_FLOAT    := 2.
    SQLITE_BLOB     := 4.
    SQLITE_NULL     := 5.
    SQLITE_TEXT     := 3.
    SQLITE3_TEXT    := 3.

    "Created: / 25-01-2012 / 20:26:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SqliteResultCodes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SqliteResultCodes.st,v 1.3 2016-12-29 10:41:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SqliteResultCodes.st,v 1.3 2016-12-29 10:41:39 cg Exp $'
! !


SqliteResultCodes initialize!

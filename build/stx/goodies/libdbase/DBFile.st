"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This code is part of Smalltalk/X - not part of the Manchester goodies
"
"{ Package: 'stx:goodies/libdbase' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DBFile
	instanceVariableNames:'handle pathName mode'
	classVariableNames:'Lobby ErrorNumber'
	poolDictionaries:''
	category:'DataBase-DBase-Interface'
!

!DBFile primitiveDefinitions!
%{

/*
 * although included here as a demonstration, don't use
 * this class with ndbm; ndbm has a 4096 byte/record limit
 * which will not work for persistency.
 *
 * to compile for db/db-1.6-library, define DBASE in the Makefile.
 * Otherwise it is compiled for ndbm/gdbm.
 */
# ifndef O_RDONLY
#  define O_RDONLY 0
#  define O_RDWR   2
# endif

#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <errno.h>

#ifndef NODBASE

# ifdef DBASE /* db1.x or db3.x */
#  include <db.h>
#  define DB_HANDLE DB
#  define DB_TYPE   DBT
#  define DATA      data
#  define SIZE      size

#  ifdef DBASE1_x
#   define DB_STORE(handle, key, value)           \
	((handle)->put)(handle, &(key), &(value), 0)

#   define DB_FETCH(handle, key, value)           \
	((handle)->get)(handle, &(key), &(value), 0)

#   define DB_DELETE(handle, key)                 \
	((handle)->del)(handle, &(key), 0)

#   define DB_CLOSE(handle)                       \
	((handle)->close)(handle)

#   define DB_SEQ(handle, key, data, how)         \
	((handle)->seq)(handle, &(key), &(data), how)

#   define DB_OPEN(name, flags, mode, type)       \
	dbopen(name, flags, mode, type, NULL)

#   define DB_SYNC(handle)                        \
	((handle)->sync)(handle, 0)

#  else /* DB3.x */
#   define DB_STORE(handle, key, value)           \
	((handle)->put)(handle, &(key), &(value), 0)

#   define DB_FETCH(handle, key, value)           \
	((handle)->get)(handle, &(key), &(value), 0)

#   define DB_DELETE(handle, key)                 \
	((handle)->del)(handle, &(key), 0)

#   define DB_CLOSE(handle)                       \
	((handle)->close)(handle)

#   define DB_SEQ(handle, key, data, how)         \
	((handle)->seq)(handle, &(key), &(data), how)

#   define DB_OPEN(name, flags, mode, type)       \
	dbopen(name, flags, mode, type, NULL)

#   define DB_SYNC(handle)                        \
	((handle)->sync)(handle, 0)
#  endif

# else /* NDBM or GDBM */

#  include <ndbm.h>

#  define DB_HANDLE DBM
#  define DB_TYPE   datum
#  define DATA      dptr
#  define SIZE      dsize

#  define DB_STORE(handle, key, value)   \
	dbm_store(handle, key, value, DBM_REPLACE)

#  define DB_DELETE(handle, key)         \
	dbm_delete(handle, key)

#  define DB_CLOSE(handle)               \
	dbm_close(handle)

#  define DB_SEQ(handle, key, data, how)         \
	((how == R_FIRST)                       \
		? dbm_firstkey(handle)          \
		: dbm_nextkey(handle))

#  define DB_OPEN(name, flags, mode, type)       \
	dbm_open(name, flags, mode)

#  define DB_SYNC(handle)                        \
	(-1)

# endif

# define __MKDB(o)       (DB_HANDLE *)__MKCP(o)
# ifndef R_FIRST
#  define R_FIRST 1
#  define R_NEXT  2
#  define R_LAST  3
#  define R_PREV  4
# endif

#endif /* NODBASE */

%}
! !

!DBFile class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This code is part of Smalltalk/X - not part of the Manchester goodies
"
!

documentation
"
    This class provides an interface to the ndbm/db1.6-functions (see libdb),
    which are new public versions of the dbm/ndbm functions with less restrictions
    and some new features.
    The code found here can be compiled for both db1.6-library and ndbm/gdbm-library access.
    However, for persistncy, ndbm is not useful due to its 4096 bytes/record limitation.
    Ndbm support is included anyway, for those who wish to access existing
    (non-smalltalk) ndbm databases.

    Provided here is a very low-level (non-object) access only;
    the only things that can be stored into the database are byteArrays
    and instances of its subclasses. Retrieval always returns a bytearray, since
    no information about the original class is stored.

    (this could be changed, by storing an additional byte, to at least support
     Strings, TwoByteStrings, ByteArrays etc.)
    Currently, this does not make any problem, because usually the binary-store-bytes of the
    actual object are stored, which are always ByteArrays and which contain all required info
    to reconstruct the original.
    The keys can be either ByteArrays or Strings; if a string is used, the 0-byte at the
    end is also included in the key. Thus, the string-key 'hello' and the byteArray-key
    #[104 101 108 108 111 0] are considered equal.

    See the implementation of PersistencyManager for higher level object storage.

    Using Structures/ByteArrays and Strings, databases shared with C/C++ programs can be set up.

    Instances of DBFile behave somewhat like Dictionaries, where both key and value must
    be byteArray-like. You can use the well known #at: and #at:put: methods to access the database.

    If only ByteArrays/Strings are used for keys and data, the database is
    also accessible via C programs - have a look at the corresponding C library
    interfaces (see directory 'support/db/db-1.6').

    Caveat:
	should make this two separate classes; one for NDBM and another for DB1.6,
	because even if db1.6 is used for persistency, some might need to access older ndbm
	databases also.

    [class variables:]
	Lobby           <Registry>      keeps track of open db-files, for automatic close on dispose
	ErrorNumber     <Integer>       the last value of errno

    [see also:]
	PersistencyManager
	(dbm manual pages (if available): man: dbm )
	http://unixpapa.com/incnote/dbm.html

    [author:]
	Claus Gittinger
"
!

examples
"
    storing into the database:
									[exBegin]
	|db|

	db := DBFile dataBaseNamed:'english_To_german.dbm'.
	db at:'hello' put:'Hallo'.
	db at:'world' put:'Welt'.
	db at:'this' put:'dies'.
	db at:'is' put:'ist'.
	db at:'a' put:'ein'.
	db at:'stupid' put:'dummes'.
	db at:'example' put:'Beispiel'.
	db close.
									[exEnd]


    retrieving:
									[exBegin]
	|db|

	db := DBFile readonlyDataBaseNamed:'english_To_german.dbm'.
	'hello world - this is a stupid example'
	  asCollectionOfWords do:[:w |
	    Transcript show:(db at:w ifAbsent:w) asString; space.
	].
	Transcript cr.
	db close
									[exEnd]


    retrieving keys sequentially (no specific order):
									[exBegin]
	|db|

	db := DBFile readonlyDataBaseNamed:'english_To_german.dbm'.
	db keysDo:[:key |
	    Transcript showCR:key asString
	].
	db close
									[exEnd]


    retrieving keysAndValues sequentially:
									[exBegin]
	|db|

	db := DBFile readonlyDataBaseNamed:'english_To_german.dbm'.
	db keysAndValuesDo:[:key :value|
	    Transcript showCR:key asString , ' -> ', value asString
	].
	db close
									[exEnd]
"
! !

!DBFile class methodsFor:'initialization'!

initLobby
    "initialize automaic closing & make me depend on the OS
     (to catch snapshot restarts in #update:with:from)"

    Lobby isNil ifTrue:[
	Lobby := Registry new.

	"want to get informed when returning from snapshot"
	ObjectMemory addDependent:self.
    ]

    "Modified: 12.5.1996 / 14:47:07 / cg"
!

update:something with:aParameter from:changedObject
    "reopen files when returning from snapshot"

    something == #returnFromSnapshot ifTrue:[
	Lobby notNil ifTrue:[
	    Lobby do:[:aDatabase |
		aDatabase deInit
	    ]
	]
    ]

    "Modified: 12.5.1996 / 14:46:30 / cg"
    "Created: 12.5.1996 / 14:47:18 / cg"
! !

!DBFile class methodsFor:'instance creation'!

dataBaseNamed:path
    "open a database, return an instance of myself or nil on failure."

    ^ ((self basicNew) pathName:path) openForReadWrite
!

readonlyDataBaseNamed:path
    "open a database, return an instance of myself or nil on failure."

    ^ ((self basicNew) pathName:path) openForReading
! !

!DBFile class methodsFor:'Signal constants'!

invalidKeySignal
    "return the signal raised if an invalid key is passed for access"

    ^ Collection invalidKeySignal

    "Created: 23.10.1997 / 02:26:50 / cg"
!

invalidValueSignal
    "return the signal raised if an invalid value is passed for access"

    ^ ElementOutOfBoundsSignal

    "Created: 23.10.1997 / 02:27:36 / cg"
!

ioErrorSignal
    "return the signal raised if an io error occurs during a database access"

    ^ ExternalStream streamErrorSignal

    "Created: 23.10.1997 / 02:25:27 / cg"
    "Modified: 23.10.1997 / 02:28:28 / cg"
!

openErrorSignal
    "return the signal raised if an error occurs during an open"

    ^ ExternalStream openErrorSignal

    "Created: 23.10.1997 / 02:25:27 / cg"
!

readErrorSignal
    "return the signal raised if a read error occurs during a database read access"

    ^ ExternalStream readErrorSignal

    "Created: 23.10.1997 / 02:29:00 / cg"
    "Modified: 23.10.1997 / 02:29:47 / cg"
!

writeErrorSignal
    "return the signal raised if a write error occurs during a database read access"

    ^ ExternalStream writeErrorSignal

    "Created: 23.10.1997 / 02:29:40 / cg"
! !

!DBFile methodsFor:'closing'!

close
    "close the dbFile - tell operating system"

    handle notNil ifTrue:[
	Lobby unregister:self.
	self closeFile.
	handle := nil.
	mode := nil.
    ]
! !

!DBFile methodsFor:'enumerating'!

associationsDo:aBlock
    "evaluate aBlock for all key/data pairs"

    |assoc|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

    assoc := self firstAssociation.
    [assoc notNil] whileTrue:[
	aBlock value:assoc.
	assoc := self nextAssociation
    ]
!

do:aBlock
    "evaluate aBlock for all data blocks"

    |data|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

    data := self first.
    [data notNil] whileTrue:[
	aBlock value:data.
	data := self next
    ]
!

keysAndValuesDo:aTwoArgBlock
    "evaluate aBlock for all key/data pairs"

    self associationsDo:[:assoc |
	aTwoArgBlock value:assoc key value:assoc value.
    ]
!

keysDo:aBlock
    "evaluate aBlock for all keys"

    |key|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

    key := self firstKey.
    [key notNil] whileTrue:[
	aBlock value:key.
	key := self nextKey
    ]
! !

!DBFile methodsFor:'error handling'!

alreadyOpenError
    "report an error, if a dbFile is opened twice with readWrite
     access (this confuses the dbm library and may lead to strange
     errors ...)"

    ^ OpenError
	raiseRequestWith:self
	errorString:('database already opened for R/W')
!

errorInvalidKey:aKey
    "this error is reported, if a non-byte-like object is given
     as key. Valid keys are Strings, ByteArrays or Symbols."

    ^ Collection invalidKeySignal raiseRequestWith:aKey
!

errorInvalidValue
    "this error is reported, if a non-byte-like object is given
     as value. Valid values are Strings, ByteArrays or Symbols."

    ^ ElementOutOfBoundsSignal raiseErrorString:'invalid datum (not bytes-like)'
!

errorNotOpen
    ^ StreamNotOpenError raiseRequestWith:self  "/ in:thisContext sender
!

ioError
    "this error is reported, if some file-I/O error is encountered."

    ^ StreamIOError raiseRequestWith:self
!

openError
    "this error is reported, if some database file could not be opened"

    ^ OpenError
	raiseRequestWith:self
	errorString:('cannot open database: ' , pathName)

    "Modified: 15.7.1996 / 16:35:08 / cg"
!

readError
    "this error is reported, if some file-I/O error is encountered."

    ^ ReadError raiseRequestWith:self
!

storeError
    "this error is reported, if a value is store via #at:put:
     and there is already some value stored under the given key.
     The database requires any old value to be removed first."

    ^ Collection invalidKeySignal raiseRequestErrorString:'must remove old datum first'
!

writeError
    "this error is reported, if some file-I/O error is encountered."

    ^ WriteError raiseRequestWith:self
! !

!DBFile methodsFor:'finalization'!

finalizationLobby
    "answer the registry used for finalization.
     DBFiles have their own Registry"

    ^ Lobby
!

finalize
    "some dataBase has been collected - close it if not already done"

    self closeFile
! !

!DBFile methodsFor:'instance release'!

closeFile
    "close the database - any buffered data is written to disk now"

%{  /* STACK: 32000 */
#ifndef NODBASE
    DB_HANDLE *dbHandle;

    dbHandle = __MKDB(__INST(handle));
    if (dbHandle) {
	DB_CLOSE(dbHandle);
	__INST(handle) = nil;
    }
    RETURN(self);
#endif
%}.
    self error:'no DB support available'
!

deInit
    handle := nil
! !

!DBFile methodsFor:'misc'!

sync
    "flush all buffered data, force it to disk - this is needed, if
     more than one program accesses a database at one time."

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{  /* STACK: 32000 */
#ifndef NODBASE
    DB_HANDLE *dbHandle;

    dbHandle = __MKDB(__INST(handle));
# ifdef DBASE
    switch (DB_SYNC(dbHandle)) {
	default:
	    RETURN(self);

	case -1:
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [error]: sync error");
	    }
	    break;
    }
# else
    /* no sync functionality present */
    RETURN(self);
# endif
#endif
%}.
    ^ self ioError
! !

!DBFile methodsFor:'private'!

mode
    "return the mode with which the db-file was opened"

    ^ mode
!

openForReadWrite
    "open/create the database for read/write"

    ^ self openWithAccess:#hash mode:#readwrite access:8r664

    "Modified: 10.2.1997 / 14:21:20 / stefan"
!

openForReading
    "open the database for readonly"

    ^ self openWithAccess:#hash mode:#readonly access:8r400
!

openWithAccess:type mode:openMode access:access
    "actually open the dataBase;

     For db-1.6, a type is allowed, to specify the access
     as hashed, btree or sequential.
     The argument must be one of #hash, #btree or #recno).
     Ndbm and gdbm only support hashed accesses (the arg is ignored).

     The openMode argument can be #readwrite or #readonly.

     Finally, access (if its an integer) specifies the access bits
     as rwxrwxrwx - however, execute permission (the x's) does not make
     sense here.
     If access is nil, 0664 is taken (i.e. r/w for you and group, read for the rest)"

    |retVal errorNr|

    "/ check if file is already in use -
    "/ libdb is not prepared to handle this and
    "/ may crash badly otherwise

    Lobby notNil ifTrue:[
	Lobby do:[:aDBFile |
	    (aDBFile notNil
	    and:[aDBFile mode == #readwrite
	    and:[aDBFile pathName = pathName]]) ifTrue:[
		^ self alreadyOpenError
	    ]
	]
    ].

%{  /* STACK: 32000 */
#ifndef NODBASE
    DB_HANDLE *dbHandle;
    int dbType;
    int dbMode = 0, dbFlags = 0;
    int ok;
    extern errno;
    char *fileName;
    OBJ hID;
    OBJ path;

    retVal = false;
    if (__INST(handle) == nil) {
	path = __INST(pathName);
	if (__isStringLike(path)) {
	    ok = 1;
# ifdef DBASE
	    if (type == @symbol(hash))
		dbType = DB_HASH;
	    else if (type == @symbol(btree))
		dbType = DB_BTREE;
	    else if (type == @symbol(recno))
		dbType = DB_RECNO;
	    else
		ok = 0;
# endif
	    if (openMode == @symbol(readonly))
		dbFlags = O_RDONLY;
	    else if (openMode == @symbol(readwrite))
		dbFlags = O_RDWR;
	    else
		ok = 0;

	    if (__isSmallInteger(access))
		dbMode = __intVal(access);
	    else
		dbMode = 0664;

	    if (ok) {
		fileName = (char *) __stringVal(path);

		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [info]: DB_OPEN(\"%s\", %d, %d, %d)...\n", fileName, dbFlags, dbMode, dbType);
		}
		dbHandle = DB_OPEN(fileName, dbFlags, dbMode, dbType);
		if ((dbHandle == NULL) /* && (errno == ENOENT) */) {
		    if (openMode == @symbol(readwrite)) {
			dbFlags = O_CREAT | O_RDWR;
			if (@global(InfoPrinting) == true) {
			    fprintf(stderr, "DBFILE [info]: DB_OPEN(\"%s\", %d, %d, %d)...\n", fileName, dbFlags, dbMode, dbType);
			}
			dbHandle = DB_OPEN(fileName, dbFlags, dbMode, dbType);
		    }
		}

		if (dbHandle == NULL) {
		    errorNr = __MKSMALLINT(errno);
		} else {
		    hID = __MKOBJ(dbHandle);
		    __INST(handle) = hID;
		    __STORE(self, hID);
		    retVal = true;
		}
	    }
	}
    }
#endif
%}.
    errorNr notNil ifTrue:[
	ErrorNumber := errorNr.
	self openError
    ].
    retVal isNil ifTrue:[
	"db functions not avalable"
	^ nil
    ].
    retVal ifTrue:[
	Lobby isNil ifTrue:[
	    self class initLobby
	].
	mode := openMode.
	Lobby register:self.
	^ self
    ].
    ^ nil
!

pathName
    "return the pathName of the db-file"

    ^ pathName
!

pathName:path
    "set the pathName to the db-file"

    pathName := path

    "Modified: 12.5.1996 / 14:48:06 / cg"
! !

!DBFile methodsFor:'private-sequential access'!

seq:how
    "retrieve a sequential datum, or nil.
     How can be one of #first, #next, #prev or #last for db-1.6,
     and any of #first, #next for ndbm."

    |dat outOfMemory|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{  /* STACK: 32000 */
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey, dbData;
    unsigned int flag;
    unsigned ok = 1;

    dbHandle = __MKDB(__INST(handle));

#ifdef DBASE
    if (how == @symbol(first))
	flag = R_FIRST;
    else if (how == @symbol(next))
	flag = R_NEXT;
    else if (how == @symbol(last))
	flag = R_LAST;
    else if (how == @symbol(prev))
	flag = R_PREV;
    else ok = 0;

    if (ok) {
	switch (DB_SEQ(dbHandle, dbKey, dbData, flag)) {
	    case 0:
		dat = __MKBARRAY(dbData.size);
		if (dat == nil) {
		    outOfMemory = true;
		    break;
		}
		bcopy(dbData.data, __ByteArrayInstPtr(dat)->ba_element, dbData.size);
		RETURN (dat);

	    case 1:
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [info]: not found (seq)\n");
		}
		RETURN (nil);
		break;

	    default:
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [error]: seq error (seq)\n");
		}
		break;
	}
    }
#else
    if (how == @symbol(first))
	dbKey = dbm_firstkey (dbHandle);
    else if (how == @symbol(next))
	dbKey = dbm_nextkey (dbHandle);
    else goto error;

    if (dbKey.DATA == NULL) {
	RETURN (nil);
    }
    dbData = dbm_fetch (dbHandle, dbKey);
    if (dbData.DATA != NULL) {
	dat = __MKBARRAY(dbData.SIZE);
	if (dat == nil) {
	    outOfMemory = true;
	} else {
	    bcopy(dbData.DATA, __ByteArrayInstPtr(dat)->ba_element, dbData.SIZE);
	    RETURN(dat);
	}
    }
error: ;

#endif /* DBASE */
%}.
    outOfMemory == true ifTrue:[
	"
	 memory allocation failed.
	 When we arrive here, there was no memory for the object
	 This means, that the VM wanted to get some more memory from the
	 Operatingsystem, which was not kind enough to give it.
	 Bad luck - you should increase the swap space on your machine.
	"
	^ AllocationFailure raise.
    ].
    "/
    "/ arrive here on ioError and if an invalid operation is
    "/ attempted (i.e. not supported by this database)
    "/
    ^ self ioError
!

seqAssociation:how
    "retrieve a sequential key/data pair or nil.
     How can be one of #first, #next, #prev or #last for db-1.6,
     and any of #first, #next for ndbm."

    |key dat outOfMemory|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{  /* STACK: 32000 */
#ifndef NODBASE
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey, dbData;
    unsigned int flag;
    unsigned ok = 1;

    dbHandle = __MKDB(__INST(handle));

# ifdef DBASE
    if (how == @symbol(first))
	flag = R_FIRST;
    else if (how == @symbol(next))
	flag = R_NEXT;
    else if (how == @symbol(last))
	flag = R_LAST;
    else if (how == @symbol(prev))
	flag = R_PREV;
    else ok = 0;

    if (ok) {
	switch (DB_SEQ(dbHandle, dbKey, dbData, flag)) {
	    case 0:
		key = __MKBARRAY(dbKey.size);
		if (key == nil) {
		    outOfMemory = true;
		    break;
		}
		dat = __MKBARRAY(dbData.size);
		if (dat == nil) {
		    outOfMemory = true;
		    break;
		}
		bcopy(dbKey.data, __ByteArrayInstPtr(key)->ba_element, dbKey.size);
		bcopy(dbData.data, __ByteArrayInstPtr(dat)->ba_element, dbData.size);
		break;

	    case 1:
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [info]: not found (seqAssoc)\n");
		}
		RETURN (nil);
		break;

	    default:
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [error]: seq error (seqAssoc)\n");
		}
		break;
	}
    }
# else
    if (how == @symbol(first))
	dbKey = dbm_firstkey (dbHandle);
    else if (how == @symbol(next))
	dbKey = dbm_nextkey (dbHandle);
    else goto error;

    if (dbKey.DATA == NULL) {
	RETURN (nil);
    }
    dbData = dbm_fetch(dbHandle, dbKey);
    if (dbData.DATA != NULL) {
	key = __MKBARRAY(dbKey.SIZE);
	if (key == nil) {
	    outOfMemory = true;
	} else {
	    bcopy(dbKey.DATA, __ByteArrayInstPtr(key)->ba_element, dbKey.SIZE);

	    dat = __MKBARRAY(dbData.SIZE);
	    if (dat == nil) {
		outOfMemory = true;
	    } else {
		bcopy(dbData.DATA, __ByteArrayInstPtr(dat)->ba_element, dbData.SIZE);
	    }
	}
    }
error: ;

# endif /* DBASE */
#endif /* NODBASE */
%}.
    outOfMemory == true ifTrue:[
	"
	 memory allocation failed.
	 When we arrive here, there was no memory for the object
	 This means, that the VM wanted to get some more memory from the
	 Operatingsystem, which was not kind enough to give it.
	 Bad luck - you should increase the swap space on your machine.
	"
	^ AllocationFailure raise.
    ].
    key isNil ifTrue:[
	"/
	"/ arrive here on ioError and if an invalid operation is
	"/ attempted (i.e. not supported by this database)
	"/
	^ self ioError
    ].
    ^ key -> dat
!

seqKey:how
    "retrieve a sequential key, or nil.
     How can be one of #first, #next, #prev or #last for db-1.6,
     and any of #first, #next for ndbm."

    |key outOfMemory|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{  /* STACK: 32000 */
#ifndef NODBASE
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey, dbData;
    unsigned int flag = R_FIRST;
    unsigned ok = 1;

    dbHandle = __MKDB(__INST(handle));

    if (how == @symbol(first))
	flag = R_FIRST;
    else if (how == @symbol(next))
	flag = R_NEXT;
# ifdef DBASE
    else if (how == @symbol(last))
	flag = R_LAST;
    else if (how == @symbol(prev))
	flag = R_PREV;
# endif
    else ok = 0;

    if (ok) {
# ifdef DBASE
	switch (DB_SEQ(dbHandle, dbKey, dbData, flag)) {
	    case 0:
		key = __MKBARRAY(dbKey.size);
		if (key == nil) {
		    outOfMemory = true;
		    break;
		}
		bcopy(dbKey.data, __ByteArrayInstPtr(key)->ba_element, dbKey.size);
		RETURN (key);
		break;

	    case 1:
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [info]: not found (seqKey)\n");
		}
		RETURN (nil);
		break;

	    default:
		if (@global(InfoPrinting) == true) {
		    fprintf(stderr, "DBFILE [error]: seq error (seqKey)\n");
		}
		break;
	}
# else
	if (flag == R_FIRST) {
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [info]: seqKey first\n");
	    }
	    dbKey = dbm_firstkey(dbHandle);
	} else {
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [info]: seqKey next\n");
	    }
	    dbKey = dbm_nextkey(dbHandle);
	}
	if (dbKey.DATA == NULL) {
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [info]: not found (seqKey)\n");
	    }
	    RETURN (nil);
	}
	if (@global(InfoPrinting) == true) {
	    fprintf(stderr, "DBFILE [info]: size=%d\n", dbKey.SIZE);
	}
	key = __MKBARRAY(dbKey.SIZE);
	if (key == nil) {
	    outOfMemory = true;
	} else {
	    bcopy(dbKey.DATA, __ByteArrayInstPtr(key)->ba_element, dbKey.SIZE);
	    RETURN (key);
	}
# endif /* NDBM */
    }

#endif
%}.
    outOfMemory == true ifTrue:[
	"
	 memory allocation failed.
	 When we arrive here, there was no memory for the object
	 This means, that the VM wanted to get some more memory from the
	 Operatingsystem, which was not kind enough to give it.
	 Bad luck - you should increase the swap space on your machine.
	"
	^ AllocationFailure raise.
    ].
    "/
    "/ arrive here on ioError and if an invalid operation is
    "/ attempted (i.e. not supported by this database)
    "/
    ^ self ioError
! !

!DBFile methodsFor:'queries'!

includesKey:key
    "return true, if data is stored under aKey in the database.
     false otherwise."

    |keySize retVal|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
    key class isBytes ifFalse:[
	"
	 key must be derived from ByteArray ..
	 (ByteArray, String, Symbol or a subclass)
	"
	^ self errorInvalidKey:key
    ].
    keySize := key basicSize.
    retVal := false.
%{  /* STACK: 32000 */
#ifndef NODBASE
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey, dbData;
    char *keyPtr;
    OBJ cls;

    dbHandle = __MKDB(__INST(handle));
    keyPtr = (char *)(__ByteArrayInstPtr(key)->ba_element);
    if ((cls = __qClass(key)) != @global(ByteArray))
	keyPtr += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    if (__isStringLike(key)) {
	keySize++;
    }
    dbKey.DATA = keyPtr;
    dbKey.SIZE = __intVal(keySize);

# ifdef DBASE
    switch (DB_FETCH(dbHandle, dbKey, dbData)) {
	case 0:
	    RETURN (true);
	    break;

	case 1:
	    RETURN (false);
	    break;

	default:
	case -1:
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [error]: get error (includesKey)\n");
	    }
	    break;
    }
# else /* NDBM */
    dbData = dbm_fetch(dbHandle, dbKey);
    if (dbData.DATA != NULL) {
	RETURN (true);
    }
    RETURN (false);
# endif

#endif
%}.
    ^ self ioError
! !

!DBFile methodsFor:'random access'!

at:key
    "retrieve datum stored under aKey in the database.
     Datum is returned as a ByteArray - independent of what was
     stored originally.
     Raise an exception, if no datum is stored under the key."

    ^ self at:key ifAbsent:[self errorKeyNotFound:key]
!

at:key ifAbsent:exceptionBlock
    "retrieve datum stored under aKey in the database.
     Datum is returned as a ByteArray - independent of what was
     stored originally.
     If no datum is available for that key, the value
     of exceptionBlock is returned."

    |keySize status dat outOfMemory|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
    key class isBytes ifFalse:[
	"
	 key must be derived from ByteArray ..
	 (ByteArray, String, Symbol or a subclass)
	"
	^ self errorInvalidKey:key
    ].
    keySize := key size.
%{  /* STACK: 32000 */
#ifndef NODBASE
    char *keyPtr;
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey, dbData;
    OBJ cls;

    dbHandle = __MKDB(__INST(handle));

    keyPtr = (char *)(__ByteArrayInstPtr(key)->ba_element);
    if ((cls = __qClass(key)) != @global(ByteArray))
	keyPtr += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    if (__isStringLike(key)) {
	keySize++;
    }
    dbKey.DATA = keyPtr;
    dbKey.SIZE = __intVal(keySize);
# ifdef DBASE
    switch (DB_FETCH(dbHandle, dbKey, dbData)) {
	case 0:
	    dat = __MKBARRAY(dbData.size);
	    if (dat == nil) {
		outOfMemory = true;
		break;
	    }
	    bcopy(dbData.data, __ByteArrayInstPtr(dat)->ba_element, dbData.size);
	    RETURN(dat);
	    break;

	case 1:
	    status = __MKSMALLINT(1);
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [info]: not found (at)\n");
	    }
	    break;

	default:
	    status = __MKSMALLINT(2);
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [error]: get error (at)\n");
	    }
	    break;
    }
# else /* NDBM */
    dbData = dbm_fetch(dbHandle, dbKey);
    if (dbData.DATA != NULL) {
	dat = __MKBARRAY(dbData.SIZE);
	if (dat == nil) {
	    outOfMemory = true;
	} else {
	    bcopy(dbData.DATA, __ByteArrayInstPtr(dat)->ba_element, dbData.SIZE);
	    RETURN(dat);
	}
    }
# endif
#endif
%}.
    outOfMemory == true ifTrue:[
	"
	 memory allocation failed.
	 When we arrive here, there was no memory for the object
	 This means, that the VM wanted to get some more memory from the
	 Operatingsystem, which was not kind enough to give it.
	 Bad luck - you should increase the swap space on your machine.
	"
	^ AllocationFailure raise.
    ].
    status == 2 ifTrue:[
	"/
	"/ arrive here on ioError and if an invalid operation is
	"/ attempted (i.e. not supported by this database)
	"/
	^ self ioError
    ].
    ^ exceptionBlock value
!

at:key put:dat
    "store datum under aKey in the database; Return datum (sigh).
     both datum and aKey must be some kind of ByteArray.
     If there is already a value stored under key, an error is reported
     (db requires a delete first)"

    |keySize dataSize status|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
    key class isBytes ifFalse:[
	"
	 key must be derived from ByteArray ..
	 (ByteArray, String, Symbol or a subclass)
	"
	^ self errorInvalidKey:key
    ].
    dat class isBytes ifFalse:[
	"
	 data must be derived from ByteArray ..
	 (ByteArray, String, Symbol or a subclass)
	"
	^ self errorInvalidValue
    ].
    keySize := key size.
    dataSize := dat size.

%{  /* STACK: 32000 */
#ifndef NODBASE
    char *keyPtr, *dataPtr;
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey, dbData;
    OBJ cls;
    int retVal;

    dbHandle = __MKDB(__INST(handle));

    keyPtr = (char *)(__ByteArrayInstPtr(key)->ba_element);
    if ((cls = __qClass(key)) != @global(ByteArray))
	keyPtr += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    if (__isStringLike(key)) {
	keySize++;
    }
    dbKey.DATA = keyPtr;
    dbKey.SIZE = __intVal(keySize);

    dataPtr = (char *)(__ByteArrayInstPtr(dat)->ba_element);
    if ((cls = __qClass(dat)) != @global(ByteArray))
	dataPtr += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    dbData.DATA = dataPtr;
    dbData.SIZE = __intVal(dataSize);

# ifdef DBASE
    switch (retVal = DB_STORE(dbHandle, dbKey, dbData)) {
	case 0:
	    RETURN(dat);
	    break;

	case 1:
	    status = __MKSMALLINT(1);
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [info]: would overwrite (at:put:)\n");
	    }
	    break;

	default:
	    status = __MKSMALLINT(2);
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [error]: put error (at:put:)\n");
	    }
	    break;
    }
# else  /* NDBM */
    if (retVal = DB_STORE(dbHandle, dbKey, dbData) >= 0) {
	RETURN(dat);
    }
    if (@global(InfoPrinting) == true) {
	fprintf(stderr, "DBFILE [error]: retVal = %d (at:put:)\n", retVal);
    }
# endif
#endif
%}.
    status == 2 ifTrue:[
	"/
	"/ arrive here on ioError and if an invalid operation is
	"/ attempted (i.e. not supported by this database)
	"/
	^ self ioError
    ].
    "/
    "/ there is already somthing stored under that key
    "/
    ^ self errorCannotStore:dat

    "Modified: 19.4.1996 / 11:19:28 / cg"
! !

!DBFile methodsFor:'removing'!

remove:key
    "remove datum stored under aKey in the database.
     Raise an exception if no datum is present for that key.
     Otherwise, return true."

    ^ self remove:key ifAbsent:[self errorKeyNotFound:key]
!

remove:key ifAbsent:exceptionBlock
    "remove datum stored under aKey in the database.
     Return the result from evaluating exceptionBlock if the operation
     failed; true if ok.
     Notice: this is different from the dictionary protocol
     (which returns the previously stored object). The reason is
     that a remove alone (i.e. without value access) may be much faster.
     Time will show, if this is a good idea."

    |keySize status|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
    key class isBytes ifFalse:[
	"
	 key must be derived from ByteArray ..
	 (ByteArray, String, Symbol or a subclass)
	"
	^ self errorInvalidKey:key
    ].
    keySize := key basicSize.
%{  /* STACK: 32000 */
#ifndef NODBASE
    char *keyPtr;
    DB_HANDLE *dbHandle;
    DB_TYPE dbKey;
    OBJ cls;

    dbHandle = __MKDB(__INST(handle));

    keyPtr = (char *)(__ByteArrayInstPtr(key)->ba_element);
    if ((cls = __qClass(key)) != @global(ByteArray))
	keyPtr += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    if (__isStringLike(key)) {
	keySize++;
    }
    dbKey.DATA = keyPtr;
    dbKey.SIZE = __intVal(keySize);

    switch ( DB_DELETE(dbHandle, dbKey)) {
	case 0:
	    RETURN(true);
	    break;

	case 1:
	    status = __MKSMALLINT(1);
	    if (@global(InfoPrinting) == true) {
		fprintf(stderr, "DBFILE [info]: not found (remove)\n");
	    }
	    break;

	default:
	    status = __MKSMALLINT(2);
	    if (@global(InfoPrinting) == true) {
		 fprintf(stderr, "DBFILE [error]: get error (remove)\n");
	    }
	    break;
    }
#endif
%}.
    status == 2 ifTrue:[
	"/
	"/ arrive here on ioError and if an invalid operation is
	"/ attempted (i.e. not supported by this database)
	"/
	^ self ioError
    ].
    "/ no such key
    ^ exceptionBlock value
! !

!DBFile methodsFor:'sequential access'!

first
    "retrieve the first datum or nil"

    ^ self seq:#first
!

firstAssociation
    "retrieve the first key/data pair or nil"

    ^ self seqAssociation:#first
!

firstKey
    "retrieve the first key, or nil"

    ^ self seqKey:#first
!

next
    "retrieve the next datum, or nil"

    ^ self seq:#next
!

nextAssociation
    "retrieve the next key/data, or nil"

    ^ self seqAssociation:#next
!

nextKey
    "retrieve the next key, or nil"

    ^ self seqKey:#next
! !

!DBFile class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/libdbase/DBFile.st,v 1.10 2016-11-02 00:45:39 cg Exp $'
! !

"
 COPYRIGHT (c) 2002 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication/tests' }"

"{ NameSpace: SunRPC }"

TestCase subclass:#XDRParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-RPC-Tests'
!

!XDRParserTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    [author:]
	Claus Gittinger
"
! !

!XDRParserTest class methodsFor:'specs'!

xdr_example2
    ^ '
	 /*
	  * A list:
	  */
	 struct *file {
	    string str<255>;
	    int    type;
	    file   rest;
	 };
'
!

xdr_rfc1014_example
    ^ '
	 const MAXUSERNAME = 32;     /* max length of a user name */
	 const MAXFILELEN = 65535;   /* max length of a file      */
	 const MAXNAMELEN = 255;     /* max length of a file name */

	 /*
	  * Types of files:
	  */
	 enum filekind {
	    TEXT = 0,       /* ascii data */
	    DATA = 1,       /* raw data   */
	    EXEC = 2        /* executable */
	 };

	 /*
	  * File information, per kind of file:
	  */
	 union filetype switch (filekind kind) {
	 case TEXT:
	    void;                           /* no extra information */
	 case DATA:
	    string creator<MAXNAMELEN>;     /* data creator         */
	 case EXEC:
	    string interpretor<MAXNAMELEN>; /* program interpretor  */
	 };

	 /*
	  * A complete file:
	  */
	 struct file {
	    string filename<MAXNAMELEN>; /* name of file    */
	    filetype type;               /* info about file */
	    string owner<MAXUSERNAME>;   /* owner of file   */
	    opaque data<MAXFILELEN>;     /* file data       */
	 };
'
!

xdr_rfc1094_example
    ^ '
   /*
    * Remote file service routines
    */

   /*
    * The maximum number of bytes of data in a READ or WRITE
    * request.
    */
   const MAXDATA = 8192;

   /* The maximum number of bytes in a pathname argument. */
   const MAXPATHLEN = 1024;

   /* The maximum number of bytes in a file name argument. */
   const MAXNAMLEN = 255;

   /* The size in bytes of the opaque "cookie" passed by READDIR. */
   const COOKIESIZE  = 4;

   /* The size in bytes of the opaque file handle. */
   const FHSIZE = 32;

   enum stat {
       NFS_OK = 0,
       NFSERR_PERM=1,
       NFSERR_NOENT=2,
       NFSERR_IO=5,
       NFSERR_NXIO=6,
       NFSERR_ACCES=13,
       NFSERR_EXIST=17,
       NFSERR_NODEV=19,
       NFSERR_NOTDIR=20,
       NFSERR_ISDIR=21,
       NFSERR_FBIG=27,
       NFSERR_NOSPC=28,
       NFSERR_ROFS=30,
       NFSERR_NAMETOOLONG=63,
       NFSERR_NOTEMPTY=66,
       NFSERR_DQUOT=69,
       NFSERR_STALE=70,
       NFSERR_WFLUSH=99
   };

   enum ftype {
       NFNON = 0,
       NFREG = 1,
       NFDIR = 2,
       NFBLK = 3,
       NFCHR = 4,
       NFLNK = 5
   };

   typedef string filename<MAXNAMLEN>;
   typedef string path<MAXPATHLEN>;

   typedef opaque fhandle[FHSIZE];
   typedef opaque nfsdata<MAXDATA>;
   typedef opaque nfscookie<COOKIESIZE>;

   struct timeval {
       unsigned int seconds;
       unsigned int useconds;
   };

   struct fattr {
       ftype        type;
       unsigned int mode;
       unsigned int nlink;
       unsigned int uid;
       unsigned int gid;
       unsigned int size;
       unsigned int blocksize;
       unsigned int rdev;
       unsigned int blocks;
       unsigned int fsid;
       unsigned int fileid;
       timeval      atime;
       timeval      mtime;
       timeval      ctime;
   };

   union attrstat switch (stat status) {
   case NFS_OK:
       fattr attributes;
   default:
       void;
   };

   struct sattr {
       unsigned int mode;
       unsigned int uid;
       unsigned int gid;
       unsigned int size;
       timeval      atime;
       timeval      mtime;
   };

   struct sattrargs {
	   fhandle file;
	   sattr attributes;
   };

   union diropres switch (stat status) {
   case NFS_OK:
       struct {
	   fhandle file;
	   fattr   attributes;
       } diropok;
   default:
       void;
   };

   struct diropargs {
       fhandle  dir;
       filename name;
   };

   union readlinkres switch (stat status) {
   case NFS_OK:
       path data;
   default:
       void;
   };

   struct readargs {
       fhandle file;
       unsigned offset;
       unsigned count;
       unsigned totalcount;
   };

   struct readresok {
	   fattr attributes;
	   nfsdata data;
   };

   union readres switch (stat status) {
   case NFS_OK:
	   readresok attributesAndData;
//           fattr attributes;
//           nfsdata data;
   default:
	   void;
   };

   struct writeargs {
       fhandle file;
       unsigned beginoffset;
       unsigned offset;
       unsigned totalcount;
       nfsdata data;
   };

struct createargs {
    diropargs where;
    sattr attributes;
};

struct renameargs {
    diropargs from;
    diropargs to;
};

struct linkargs {
    fhandle from;
    diropargs to;
};

struct symlinkargs {
    diropargs from;
    path to;
    sattr attributes;
};

struct readdirargs {
    fhandle dir;
    nfscookie cookie;
    unsigned count;
};

struct entry {
    unsigned fileid;
    filename name;
    nfscookie cookie;
    entry *nextentry;
};

struct readdirok {
    entry *entries;
    bool eof;
};

union readdirres switch (stat status) {
  case NFS_OK:
    readdirok readdirok;
  default:
    void;
};

struct statfsresinfo {
    unsigned tsize;
    unsigned bsize;
    unsigned blocks;
    unsigned bfree;
    unsigned bavail;
};

union statfsres switch (stat status) {
  case NFS_OK:
    statfsresinfo info;
  default:
    void;
};

   program NFS_PROGRAM {
       version NFS_VERSION {
	   void
	   NFSPROC_NULL(void)              = 0;

	   attrstat
	   NFSPROC_GETATTR(fhandle)        = 1;

	   attrstat
	   NFSPROC_SETATTR(sattrargs)      = 2;

	   void
	   NFSPROC_ROOT(void)              = 3;

	   diropres
	   NFSPROC_LOOKUP(diropargs)       = 4;

	   readlinkres
	   NFSPROC_READLINK(fhandle)       = 5;

	   readres
	   NFSPROC_READ(readargs)          = 6;

	   void
	   NFSPROC_WRITECACHE(void)        = 7;

	   attrstat
	   NFSPROC_WRITE(writeargs)        = 8;

	   diropres
	   NFSPROC_CREATE(createargs)      = 9;

	   stat
	   NFSPROC_REMOVE(diropargs)       = 10;

	   stat
	   NFSPROC_RENAME(renameargs)      = 11;

	   stat
	   NFSPROC_LINK(linkargs)          = 12;

	   stat
	   NFSPROC_SYMLINK(symlinkargs)    = 13;

	   diropres
	   NFSPROC_MKDIR(createargs)       = 14;

	   stat
	   NFSPROC_RMDIR(diropargs)        = 15;

	   readdirres
	   NFSPROC_READDIR(readdirargs)    = 16;

	   statfsres
	   NFSPROC_STATFS(fhandle)         = 17;
       } = 2;
   } = 100003;
'
! !

!XDRParserTest methodsFor:'tests'!

testEncode1
    |parser types encoder fileType file data|

    parser := XDRParser for:(self class xdr_rfc1014_example).
    parser nextToken.
    parser definitions.

    types := parser types.
    fileType := types at:'file'.

    file := Dictionary new.
    file at:'filename' put:'sillyprog'.
    file at:'type' put:(#'EXEC' -> 'lisp').
    file at:'owner' put:'john'.
    file at:'data' put:'(quit)'.

    encoder := XDRCoder new.
    fileType encode:file on:encoder with:nil.

    data := encoder contents.
    self assert:(data = #[
			  16r00 16r00 16r00 16r09
			  16r73 16r69 16r6c 16r6c
			  16r79 16r70 16r72 16r6f
			  16r67 16r00 16r00 16r00
			  16r00 16r00 16r00 16r02
			  16r00 16r00 16r00 16r04
			  16r6c 16r69 16r73 16r70
			  16r00 16r00 16r00 16r04
			  16r6a 16r6f 16r68 16r6e
			  16r00 16r00 16r00 16r06
			  16r28 16r71 16r75 16r69
			  16r74 16r29 16r00 16r00
			 ] ).

"/       OFFSET  HEX BYTES       ASCII    COMMENTS
"/       ------  ---------       -----    --------
"/        0      00 00 00 09     ....     -- length of filename = 9
"/        4      73 69 6c 6c     sill     -- filename characters
"/        8      79 70 72 6f     ypro     -- ... and more characters ...
"/       12      67 00 00 00     g...     -- ... and 3 zero-bytes of fill
"/       16      00 00 00 02     ....     -- filekind is EXEC = 2
"/       20      00 00 00 04     ....     -- length of interpretor = 4
"/       24      6c 69 73 70     lisp     -- interpretor characters
"/       28      00 00 00 04     ....     -- length of owner = 4
"/       32      6a 6f 68 6e     john     -- owner characters
"/       36      00 00 00 06     ....     -- length of file data = 6
"/       40      28 71 75 69     (qui     -- file data bytes ...
"/       44      74 29 00 00     t)..     -- ... and 2 zero-bytes of fill


    "
     self run:#testEncode1
     self new testEncode1
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
!

testEncode2
    |parser types encoder fileType file data|

    parser := XDRParser for:(self class xdr_rfc1014_example).
    parser nextToken.
    parser definitions.

    types := parser types.
    fileType := types at:'file'.

    file := Structure
		with:#'filename' -> 'sillyprog'
		with:#'type'     -> (#'EXEC' -> 'lisp')
		with:#'owner'    -> 'john'
		with:#'data'     -> '(quit)'.

    encoder := XDRCoder new.
    fileType encode:file on:encoder with:nil.

    data := encoder contents.
    self assert:(data = #[
			  16r00 16r00 16r00 16r09
			  16r73 16r69 16r6c 16r6c
			  16r79 16r70 16r72 16r6f
			  16r67 16r00 16r00 16r00
			  16r00 16r00 16r00 16r02
			  16r00 16r00 16r00 16r04
			  16r6c 16r69 16r73 16r70
			  16r00 16r00 16r00 16r04
			  16r6a 16r6f 16r68 16r6e
			  16r00 16r00 16r00 16r06
			  16r28 16r71 16r75 16r69
			  16r74 16r29 16r00 16r00
			 ] ).

"/       OFFSET  HEX BYTES       ASCII    COMMENTS
"/       ------  ---------       -----    --------
"/        0      00 00 00 09     ....     -- length of filename = 9
"/        4      73 69 6c 6c     sill     -- filename characters
"/        8      79 70 72 6f     ypro     -- ... and more characters ...
"/       12      67 00 00 00     g...     -- ... and 3 zero-bytes of fill
"/       16      00 00 00 02     ....     -- filekind is EXEC = 2
"/       20      00 00 00 04     ....     -- length of interpretor = 4
"/       24      6c 69 73 70     lisp     -- interpretor characters
"/       28      00 00 00 04     ....     -- length of owner = 4
"/       32      6a 6f 68 6e     john     -- owner characters
"/       36      00 00 00 06     ....     -- length of file data = 6
"/       40      28 71 75 69     (qui     -- file data bytes ...
"/       44      74 29 00 00     t)..     -- ... and 2 zero-bytes of fill


    "
     self run:#testEncode2
     self new testEncode2
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
!

testEncode3
    |parser types encoder fileType file list data|

    parser := XDRParser for:(self class xdr_example2).
    parser nextToken.
    parser definitions.

    types := parser types.
    fileType := types at:'file'.

    list := OrderedCollection new.
    file := Structure
		with:#'str'      -> 'str1'
		with:#'type'     -> 1.
    list add:file.
    file := Structure
		with:#'str'      -> 'str2'
		with:#'type'     -> 2.
    list add:file.
    file := Structure
		with:#'str'      -> 'str3'
		with:#'type'     -> 3.
    list add:file.

    encoder := XDRCoder new.
    fileType encode:list on:encoder with:nil.

    data := encoder contents.
    self assert:(data = #[
			  16r00 16r00 16r00 16r01
			  16r00 16r00 16r00 16r04
			  16r73 16r74 16r72 16r31     "/ str1
			  16r00 16r00 16r00 16r01     "/ 1

			  16r00 16r00 16r00 16r01
			  16r00 16r00 16r00 16r04
			  16r73 16r74 16r72 16r32     "/ str2
			  16r00 16r00 16r00 16r02     "/ 2

			  16r00 16r00 16r00 16r01
			  16r00 16r00 16r00 16r04
			  16r73 16r74 16r72 16r33     "/ str3
			  16r00 16r00 16r00 16r03     "/ 3

			  16r00 16r00 16r00 16r00
			 ] ).

    "
     self run:#testEncode3
     self new testEncode3
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
!

testParse1
    |parser types t consts progs prog version f p|

    parser := XDRParser for:(PortMapperClient xdr).
    parser nextToken.
    parser definitions.

    types := parser types.

    self assert:( types includesKey: 'mapping' ).
    t := types at: 'mapping'.
    self assert:( t notNil ).
    self assert:( t isXDRStruct ).
    self assert:( t isOptional not ).
    f := t fields detect:[:f | f name = 'prog'] ifNone:nil.
    self assert:( f notNil ).
    f type isXDRInteger.
    f type isXDRUnsigned.

    self assert:( types includesKey: 'pmaplist' ).
    t := types at: 'pmaplist'.
    self assert:( t notNil ).
    self assert:( t isOptional ).
    self assert:( t isXDRStruct ).
    f := t fields detect:[:f | f name = 'map'] ifNone:nil.
    self assert:( f notNil ).
    f := t fields detect:[:f | f name = 'next'] ifNone:nil.
    self assert:( f notNil ).
    f type isXDRStruct.
    f type isXDROpaque not.

    self assert:( types includesKey: 'call_result' ).
    t := types at: 'call_result'.
    self assert:( t notNil ).
    self assert:( t isOptional not ).
    self assert:( t isXDRStruct ).
    f := t fields detect:[:f | f name = 'res'] ifNone:nil.
    self assert:( f notNil ).
    f type isXDROpaque.

    self assert:( types includesKey: 'call_args' ).

    consts := parser constants.
    self assert:( consts includesKey: 'PMAP_PORT' ).
    self assert:( (consts at: 'PMAP_PORT') = 111 ).
    self assert:( consts includesKey: 'IPPROTO_TCP' ).
    self assert:( (consts at: 'IPPROTO_TCP') = 6 ).
    self assert:( consts includesKey: 'IPPROTO_UDP' ).
    self assert:( (consts at: 'IPPROTO_UDP') = 17 ).

    progs := parser programs.
    self assert:( progs includesKey: 'PMAP_PROG' ).
    prog := progs at: 'PMAP_PROG' ifAbsent:nil.
    self assert:( prog notNil ).
    self assert:( prog programNumber = 100000 ).
    version := prog versions at: 'PMAP_VERS' ifAbsent:nil.
    self assert:( version notNil ).
    self assert:( version versionNumber = 2 ).

    p := version procedures detect:[:p | p name = 'null'] ifNone:nil.
    self assert:( p notNil ).
    self assert:( p type isXDRVoid ).
    self assert:( p arguments size == 0 ).

    p := version procedures detect:[:p | p name = 'set'] ifNone:nil.
    self assert:( p notNil ).
    self assert:( p type isXDRBoolean ).
    self assert:( p arguments size == 1 ).

    "
     self run:#testParse1
     self new testParse1
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
!

testParse2
    |parser types t consts f|

    parser := XDRParser for:(self class xdr_rfc1014_example).
    parser nextToken.
    parser definitions.

    types := parser types.

    self assert:( types includesKey: 'filekind' ).
    t := types at: 'filekind'.
    self assert:( t notNil ).
    self assert:( t isXDREnum ).
    self assert:( (t enumValues at:#'TEXT') = 0 ).
    self assert:( (t enumValues at:#'DATA') = 1 ).
    self assert:( (t enumValues at:#'EXEC') = 2 ).

    self assert:( types includesKey: 'filetype' ).
    t := types at: 'filetype'.
    self assert:( t notNil ).
    self assert:( t isXDRUnion ).
    self assert:( t discriminant notNil ).
    self assert:( t discriminant name = 'kind' ).
    self assert:( t discriminant type name = 'filekind' ).
    f := t fields first.
    self assert:(f type isXDRVoid).

    f := t fields second.
    self assert:(f type isXDRString).
    self assert:(f name = 'creator').

    self assert:( types includesKey: 'file' ).
    t := types at: 'file'.
    self assert:( t notNil ).
    self assert:( t isOptional not ).
    self assert:( t isXDRStruct ).

    consts := parser constants.
    self assert:( consts includesKey: 'MAXUSERNAME' ).
    self assert:( (consts at: 'MAXUSERNAME') = 32 ).
    self assert:( consts includesKey: 'MAXFILELEN' ).
    self assert:( (consts at: 'MAXFILELEN') = 65535 ).
    self assert:( consts includesKey: 'MAXNAMELEN' ).
    self assert:( (consts at: 'MAXNAMELEN') = 255 ).

    "
     self run:#testParse2
     self new testParse2
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
!

testParse3
    |parser types t consts f|

    parser := XDRParser for:(self class xdr_rfc1014_example).
    parser nextToken.
    parser definitions.

    types := parser types.

    self assert:( types includesKey: 'filekind' ).
    t := types at: 'filekind'.
    self assert:( t notNil ).
    self assert:( t isXDREnum ).
    self assert:( (t enumValues at:#'TEXT') = 0 ).
    self assert:( (t enumValues at:#'DATA') = 1 ).
    self assert:( (t enumValues at:#'EXEC') = 2 ).

    self assert:( types includesKey: 'filetype' ).
    t := types at: 'filetype'.
    self assert:( t notNil ).
    self assert:( t isXDRUnion ).
    self assert:( t discriminant notNil ).
    self assert:( t discriminant name = 'kind' ).
    self assert:( t discriminant type name = 'filekind' ).
    f := t fields first.
    self assert:(f type isXDRVoid).

    f := t fields second.
    self assert:(f type isXDRString).
    self assert:(f name = 'creator').

    self assert:( types includesKey: 'file' ).
    t := types at: 'file'.
    self assert:( t notNil ).
    self assert:( t isOptional not ).
    self assert:( t isXDRStruct ).

    consts := parser constants.
    self assert:( consts includesKey: 'MAXUSERNAME' ).
    self assert:( (consts at: 'MAXUSERNAME') = 32 ).
    self assert:( consts includesKey: 'MAXFILELEN' ).
    self assert:( (consts at: 'MAXFILELEN') = 65535 ).
    self assert:( consts includesKey: 'MAXNAMELEN' ).
    self assert:( (consts at: 'MAXNAMELEN') = 255 ).

    "
     self run:#testParse3
     self new testParse3
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
!

testParse4
    |parser types|

    parser := XDRParser for:(self class xdr_rfc1094_example).
    parser nextToken.
    parser definitions.

    types := parser types.


    "
     self run:#testParse4
     self new testParse4
    "

    "Created: / 21.12.2001 / 22:40:22 / cg"
    "Modified: / 22.12.2001 / 17:07:03 / cg"
! !

!XDRParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/tests/SunRPC_XDRParserTest.st,v 1.2 2016-05-02 15:41:10 cg Exp $'
! !

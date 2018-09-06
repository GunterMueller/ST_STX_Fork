"{ Encoding: utf8 }"

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
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

RPCServer subclass:#NFSServer
	instanceVariableNames:''
	classVariableNames:'PathPerHandle HandlePerPath NextSequenceNumber TraceOps TraceArgs
		VeryVerbose CachedClassSourceSizes ClassModificationTime
		ClassModificationTimes LastClass LastSource CachedPackages
		CachedClassNames LastFile LastFileModificationTime
		LastFileContents'
	poolDictionaries:''
	category:'Net-Communication-SunRPC-NFS'
!

!NFSServer class methodsFor:'documentation'!

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
    an nfs daemon (nfsd); see RFC1057 and examples.
    *** VERY COOL - see examples in MountServer ***

    No need to start separately - will be started by MountServer;
    see instructions there.

    [author:]
        Claus Gittinger

    [start with:]
        SunRPC::MountServer start
        SunRPC::MountServer startUDP

        SunRPC::NFSServer start
        SunRPC::NFSServer startUDP

        TraceArgs := true.

    [see also:]
        RFC1057
"
!

examples
"
    SunRPC::NFSServer start
    SunRPC::NFSServer startUDP

    SunRPC::RPCServer killAll.

    SunRPC::NFSServer killAll.
    SunRPC::NFSServer initialize
"
! !

!NFSServer class methodsFor:'accessing'!

handleFor:aPath
    |handleNr realPath|

    HandlePerPath isNil ifTrue:[
        HandlePerPath := Dictionary new.
        PathPerHandle := Dictionary new.
        NextSequenceNumber := 0.
    ].

    realPath := aPath.
    (realPath endsWith:'/.') ifTrue:[
        realPath := realPath copyButLast:2.
        realPath = '' ifTrue:[
            realPath := '/'
        ]
    ].
    (realPath endsWith:'/..') ifTrue:[
        self breakPoint:#cg.
    ].

    handleNr := HandlePerPath at:realPath ifAbsent:nil.
    handleNr isNil ifTrue:[
        NextSequenceNumber := NextSequenceNumber + 1.
        handleNr := NextSequenceNumber.

        HandlePerPath at:realPath put:handleNr.
        PathPerHandle at:handleNr put:realPath.
    ].

    ^ handleNr
!

pathForHandle:handleNr
    PathPerHandle isNil ifTrue:[
        PathPerHandle := Dictionary new.
    ].
    ^ PathPerHandle at:handleNr ifAbsent:nil
! !

!NFSServer class methodsFor:'change and update'!

flushCachedClassInfoFor:aClass
    |cls|

    cls := aClass theNonMetaclass.
    CachedClassSourceSizes notNil ifTrue:[
        CachedClassSourceSizes removeKey:cls ifAbsent:nil.
    ].
    ClassModificationTimes notNil ifTrue:[
        ClassModificationTimes removeKey:cls ifAbsent:nil.
    ].

    "Created: / 1.2.2002 / 12:58:20 / cg"
!

update:something with:aParameter from:changedObject
    |cls|

    changedObject == ObjectMemory ifTrue:[
        something == #aboutToSnapshot ifTrue:[
                CachedClassSourceSizes := ClassModificationTime := nil.
                ClassModificationTimes := nil.
                LastClass := LastSource := CachedPackages := nil.
                CachedClassNames := LastFile := LastFileModificationTime := nil.
                LastFileContents := nil.
        ].
        ^ self.
    ].

    changedObject == Smalltalk ifTrue:[
        (something == #methodInClass 
        or:[something == #methodInClassRemoved]) ifTrue:[
            self flushCachedClassInfoFor:(aParameter at:1).
            ^ self.
        ].

        something == #classDefinition ifTrue:[
            aParameter isBehavior ifTrue:[
                cls := aParameter.
            ] ifFalse:[
                cls := aParameter at:1
            ].
            self flushCachedClassInfoFor:cls.
            ^ self.
        ].

        something == #newClass ifTrue:[
            ClassModificationTime := nil.
            CachedPackages := nil.
            ^ self.
        ].

"/ Transcript show:'NFSServer: update:' , something storeString.
"/ Transcript show:' with:' , aParameter printString.
"/ Transcript showCR:' from:' , changedObject printString.

        CachedClassNames := nil.
        CachedClassSourceSizes := nil.
        ClassModificationTime := nil.
        ClassModificationTimes := nil.
        CachedPackages := nil.
    ].

    "
     Smalltalk addDependent:self
    "

    "Modified: / 1.2.2002 / 15:20:20 / cg"
! !

!NFSServer class methodsFor:'spec'!

xdr
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

enum ftype {
    NFNON = 0,
    NFREG = 1,
    NFDIR = 2,
    NFBLK = 3,
    NFCHR = 4,
    NFLNK = 5
};

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

typedef string filename<MAXNAMLEN>;
typedef string path<MAXPATHLEN>;

typedef opaque fhandle[FHSIZE];
typedef opaque nfsdata<MAXDATA>;
typedef opaque nfscookie[COOKIESIZE];

struct timeval {
    unsigned int seconds;
    unsigned int useconds;
};

const S_IFSOCK = 0140000;
const S_IFLNK  = 0120000;
const S_IFREG  = 0100000;
const S_IFBLK  = 0060000;
const S_IFDIR  = 0040000;
const S_IFCHR  = 0020000;
const S_IFIFO  = 0010000;
const S_ISUID  = 0004000;
const S_ISGID  = 0002000;
const S_ISVTX  = 0001000;

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

struct attributesAndData {
    fattr attributes;
    nfsdata data;
};

struct readargs {
    fhandle file;
    unsigned offset;
    unsigned count;
    unsigned totalcount;
};

union readres switch (stat status) {
  case NFS_OK:
    // fattr attributes;
    // nfsdata data;
    attributesAndData attributesAndData;

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
            null(void)              = 0;

            attrstat
            getattr(fhandle)        = 1;

            attrstat
            setattr(sattrargs)      = 2;

            void
            root(void)              = 3;

            diropres
            lookup(diropargs)       = 4;

            readlinkres
            readlink(fhandle)       = 5;

            readres
            read(readargs)          = 6;

            void
            writecache(void)        = 7;

            attrstat
            write(writeargs)        = 8;

            diropres
            create(createargs)      = 9;

            stat
            remove(diropargs)       = 10;

            stat
            rename(renameargs)      = 11;

            stat
            link(linkargs)          = 12;

            stat
            symlink(symlinkargs)    = 13;

            diropres
            mkdir(createargs)       = 14;

            stat
            rmdir(diropargs)        = 15;

            readdirres
            readdir(readdirargs)    = 16;

            statfsres
            statfs(fhandle)         = 17;
    } = 2;
} = 200003;   /* standard: 100003 */
'

    "Modified: / 30.1.2002 / 16:26:54 / cg"
! !

!NFSServer class methodsFor:'startup'!

deinitialize
    Smalltalk removeDependent:self.
    ObjectMemory removeDependent:self.

    "
     self deinitialize
    "
!

initialize
    super initialize.

    PathPerHandle := HandlePerPath := NextSequenceNumber := nil.
    Smalltalk addDependent:self.
    ObjectMemory addDependent:self.

    "
     self initialize
     self initDefinitions.
    "
! !

!NFSServer methodsFor:'helpers'!

allPackages
    CachedPackages isNil ifTrue:[
        CachedPackages := Smalltalk allPackageIDs asOrderedCollection.
    ].
    ^ CachedPackages

    "CachedPackages := nil.
     self basicNew allPackages
    "
!

attributesFor:aPathName
    |attributes type mode size mtime atime ctime uid gid id info nLink
     nr p baseName cls realFilename
     isProcess isDirectory isFile isClass|

"/ Transcript showCR:aPathName.
    isProcess := isDirectory := isFile := isClass := false.

    realFilename := self physicalFileNameFor:aPathName.
    realFilename notNil ifTrue:[
        isFile := true.
    ] ifFalse:[
        (aPathName startsWith:'/processes/') ifTrue:[
            baseName := aPathName copyFrom:'/processes/' size + 1.
            nr := Integer readFrom:baseName onError:nil.
            nr notNil ifTrue:[
                p := ProcessorScheduler knownProcesses detect:[:p | p id == nr] ifNone:nil.
                p notNil ifTrue:[
                    isProcess := true.
                ]
            ]
        ] ifFalse:[
            (aPathName startsWith:'/classes/') ifTrue:[
                baseName := aPathName copyFrom:'/classes/' size + 1.
                baseName knownAsSymbol ifTrue:[
                    cls := Smalltalk at:baseName asSymbol ifAbsent:nil.
                    cls isBehavior ifTrue:[
                        isClass := true.
                    ]
                ]
            ] ifFalse:[
                (aPathName startsWith:'/packages/') ifTrue:[
                    baseName := aPathName copyFrom:'/packages/' size + 1.
                    (self allPackages includes:baseName) ifTrue:[
                        isFile := true.
                    ].
                ] ifFalse:[
                    ( #(
                      '/' '/classes' '/processes' '/packages' '/windows'
                    ) includes:aPathName) ifTrue:[
                        isDirectory := true.
                        mtime := ClassModificationTime.
                        mtime isNil ifTrue:[
                            ClassModificationTime := mtime := Timestamp now getMilliseconds
                        ]
                    ]
                ].
            ].
        ].
    ].

    (isFile or:[isClass or:[isDirectory or:[isProcess]]]) ifFalse:[
        Transcript show:'ignored attrib for: '; showCR:aPathName.
        ^ nil
    ].

    attributes := Dictionary new.

    "/  0040000 This is a directory; "type" field should be NFDIR.
    "/  0020000 This is a character special file; "type" field should be NFCHR.
    "/  0060000 This is a block special file; "type" field should be NFBLK.
    "/  0100000 This is a regular file; "type" field should be NFREG.
    "/  0120000 This is a symbolic link file;  "type" field should be NFLNK
    "/  0140000 This is a named socket; "type" field should be NFNON.

    "/  0004000 Set user id on execution.
    "/  0002000 Set group id on execution.
    "/  0001000 Save swapped text even after use.
    "/  0000400 Read permission for owner.
    "/  0000200 Write permission for owner.
    "/  0000100 Execute and search permission for owner.
    "/  0000040 Read permission for group.
    "/  0000020 Write permission for group.
    "/  0000010 Execute and search permission for group.
    "/  0000004 Read permission for others.
    "/  0000002 Write permission for others.
    "/  0000001 Execute and search permission for others.

    realFilename notNil ifTrue:[
        mode := 0.
        realFilename isSymbolicLink ifTrue:[
            info := realFilename linkInfo.
            info isNil ifTrue:[
                ^ nil
            ].
            type := #NFLNK.
            mode := (mode bitOr:8r0120000).
        ] ifFalse:[
            realFilename exists ifTrue:[
                info := realFilename info.
            ].
            info isNil ifTrue:[
                ^ nil
            ].
            info type == #directory ifTrue:[
                type := #NFDIR.
                mode := (mode bitOr:8r0040000).
            ] ifFalse:[
                type := #NFREG.
                mode := (mode bitOr:8r0100000).
            ].
        ].

        mode := mode bitOr:(info mode bitAnd:8r777).
        size := info fileSize.
        uid := info uid.
        gid := info gid.
        mtime := info modificationTime getMilliseconds.
        atime := info accessTime getMilliseconds.
        ctime := info modificationTime getMilliseconds.
        nLink := info numLinks.
    ] ifFalse:[
        isDirectory ifTrue:[
            type := #NFDIR.
            mode := (8r0777 bitOr:8r0040000).
            size := 8192.
        ] ifFalse:[
            type := #NFREG.
            mode := (8r0777 bitOr:8r0100000).
            isClass ifTrue:[
                [
                    CachedClassSourceSizes notNil ifTrue:[
                        size := CachedClassSourceSizes at:cls ifAbsent:nil.
                    ]
                ] valueUninterruptably.
                size isNil ifTrue:[
                    size := (self sourceForClass:cls) size.
                    [
                        CachedClassSourceSizes isNil ifTrue:[
                            CachedClassSourceSizes := IdentityDictionary new.
                        ].
                        CachedClassSourceSizes at:cls put:size.
                    ] valueUninterruptably.
                ].

                [
                    ClassModificationTimes notNil ifTrue:[
                        mtime := ClassModificationTimes at:cls ifAbsent:nil.
                    ]
                ] valueUninterruptably.
                mtime isNil ifTrue:[
                    mtime := Timestamp now getMilliseconds.
                    [
                        ClassModificationTimes isNil ifTrue:[
                            ClassModificationTimes := IdentityDictionary new.
                        ].
                        ClassModificationTimes at:cls put:mtime
                    ] valueUninterruptably.
                ].
            ] ifFalse:[
                size := (self dataFor:aPathName) size.
            ]
        ].
    ].

    id := self class handleFor:aPathName.

    VeryVerbose == true ifTrue:[
        Transcript show:'attrib for: '; show:aPathName; 
                   show:' type:'; show:type; 
                   show:' mode:'; show:(mode printStringRadix:8); 
                   show:' id:'; showCR:id.
    ].

    attributes at:'type'      put:type.
    attributes at:'mode'      put:mode.
    attributes at:'nlink'     put:(nLink ? 1).
    attributes at:'uid'       put:(uid ? OperatingSystem getUserID).
    attributes at:'gid'       put:(gid ? OperatingSystem getGroupID).
    attributes at:'size'      put:size.
    attributes at:'blocksize' put:8192.
    attributes at:'rdev'      put:0.     "/ only used with block/char devices
    attributes at:'blocks'    put:1.
    attributes at:'fsid'      put:1.
    attributes at:'fileid'    put:id.

    mtime isNil ifTrue:[
        mtime := Timestamp now getMilliseconds.
    ].
    ctime isNil ifTrue:[
        ctime := Timestamp now getMilliseconds.
    ].
    atime isNil ifTrue:[
        atime := Timestamp now getMilliseconds.
    ].

    attributes 
        at:'mtime' 
        put:(Dictionary new
                at:'seconds'  put:(mtime // 1000);
                at:'useconds' put:(mtime \\ 1000) * 1000;
                yourself).

    attributes 
        at:'ctime' 
        put:(Dictionary new
                at:'seconds'  put:(ctime // 1000);
                at:'useconds' put:(ctime \\ 1000) * 1000;
                yourself).

    attributes 
        at:'atime' 
        put:(Dictionary new
                at:'seconds'  put:(atime // 1000);
                at:'useconds' put:(atime \\ 1000) * 1000;
                yourself).
    ^ attributes

    "Modified: / 19.2.2002 / 15:43:18 / cg"
!

dataFor:aPathName
    |realFilename baseName cls fn nr p|

    realFilename := self physicalFileNameFor:aPathName.
    realFilename isNil ifTrue:[
        (aPathName startsWith:'/classes/') ifTrue:[
            baseName := aPathName copyFrom:'/classes/' size + 1.
            baseName knownAsSymbol ifTrue:[
                cls := Smalltalk at:baseName asSymbol ifAbsent:nil.
                cls isBehavior ifTrue:[
                    ^ self sourceForClass:cls.
                ]
            ]
        ].
        (aPathName startsWith:'/processes/') ifTrue:[
            fn := aPathName copyFrom:'/processes/' size + 1.
            nr := Integer readFrom:fn onError:nil.
            nr notNil ifTrue:[
                p := ProcessorScheduler knownProcesses detect:[:p | p id == nr] ifNone:nil.
                p notNil ifTrue:[
                    ^ p id printString , Character tab ,
                      p name , Character tab ,
                      p state , Character tab ,
                      p priority printString 
                ]
            ].
            ^ nil
        ].
        ^ 'hello world - this is smalltalk/x' , Character nl
    ].

    realFilename = LastFile ifTrue:[
        realFilename modificationTime = LastFileModificationTime ifTrue:[
"/                Transcript showCR:'cache hit ', LastFile pathName.
            ^ LastFileContents
        ].
    ].
    LastFile := realFilename.
    LastFileModificationTime := realFilename modificationTime.
    LastFileContents := realFilename contentsOfEntireFile.
    ^ LastFileContents
!

filesFor:dirPath
    |realFilename files knownTopViews|

    realFilename := self physicalFileNameFor:dirPath.
    realFilename isNil ifTrue:[
        dirPath = '/' ifTrue:[
            ^ #( 
                 'classes' 
                 'processes' 
                 'packages'
                 'changes'
                 'files'
    "/             'windows'
               ).
        ].

        dirPath = '/processes' ifTrue:[
            files := ProcessorScheduler knownProcesses asOrderedCollection.
            files := files select:[:p | p id notNil].
            files := files collect:[:p | p id printString].
            ^ files.
        ].

        dirPath = '/windows' ifTrue:[
            knownTopViews := IdentitySet new.
            Screen allScreens do:[:aScreen |
                aScreen allViewsDo:[:aView |
                    |top showIt wg|

                    aView notNil ifTrue:[
                        top := aView topView.
                        top isNil ifTrue:[
                            showIt := false.
                        ] ifFalse:[
                            (top isDebugView) ifTrue:[
                                "/ although modal, show it.
                                showIt := top realized
                            ] ifFalse:[
                                wg := top windowGroup.
                                showIt := (wg notNil and:[wg isModal not]).
                            ].
                        ].
                        showIt ifTrue:[
                            knownTopViews add:top
                        ]
                    ]
                ]
            ].
            files := knownTopViews asOrderedCollection.
            files := files select:[:p | p id notNil].
            files := files collect:[:p | p id address printString].
            ^ files.
        ].

        dirPath = '/classes' ifTrue:[
            ^ Smalltalk allClasses collect:[:each | each name].
        ].

        dirPath = '/packages' ifTrue:[
            ^ self allPackages.
        ].
    ].

    realFilename isDirectory ifTrue:[
        ^ realFilename directoryContents
    ].
    ^ nil
!

handleFor:aPathName
    |handleNr fHandle|

    handleNr := self class handleFor:aPathName.

    fHandle := ByteArray new:4.
    fHandle unsignedLongAt:1 put:handleNr.
    ^ fHandle
!

physicalFileNameFor:aPathName
    |realFilename isFile|

    (aPathName = '/processes' or:[aPathName startsWith:'/processes/']) ifTrue:[
        ^ nil
    ].
    (aPathName = '/classes' or:[aPathName startsWith:'/classes/']) ifTrue:[
        ^ nil
    ].
    (aPathName = '/packages' or:[aPathName startsWith:'/packages/']) ifTrue:[
        ^ nil
    ].
    (aPathName startsWith:'/files') ifTrue:[
        isFile := true.
        (aPathName = '/files') ifTrue:[
            realFilename := '/' 
        ] ifFalse:[
            realFilename := aPathName copyFrom:('/files' size+1).
        ].
        ^ self simulatedFileHome asFilename construct:realFilename.
    ].
    ((aPathName startsWith:'C:') 
    or:[(aPathName startsWith:'D:')
    or:[(aPathName startsWith:'/home')]])ifTrue:[
        isFile := true.
        ^ aPathName asFilename.
    ].
    ( #(
      '/changes'
    ) includes:aPathName) ifTrue:[
        isFile := true.
        ^ 'changes' asFilename
    ].

    ^ nil
!

sourceForClass:cls
    LastClass == cls ifTrue:[
        LastSource notNil ifTrue:[
            ^ LastSource
        ].
    ].
    LastSource := cls source asString.
    LastClass := cls.

    ^ LastSource
!

unpackFileHandle:handle
    |hNr path|

    "/ only the first 4 bytes are used here...
    hNr := handle unsignedLongAt:1.

    path := self class pathForHandle:hNr.
    ^ path 
! !

!NFSServer methodsFor:'operations'!

create:args
    |arg dirPath name mode uid gid size diropok
     atimeSeconds atimeuSeconds mtimeSeconds mtimeuSeconds
     attributes status realDirPath newFile s fHandle newName|

    arg := args first.

    "/ diropargs
    dirPath := self unpackFileHandle:((arg at:'where') at:'dir').
    name    := (arg at:'where') at:'name'.

    "/ sattr
    attributes := arg at:'attributes'.
    mode := attributes at:'mode'.
    uid := attributes at:'uid'.
    gid := attributes at:'gid'.
    size := attributes at:'size'.
    atimeSeconds := (attributes at:'atime') at:'seconds'.
    atimeuSeconds := (attributes at:'atime') at:'useconds'.
    mtimeSeconds := (attributes at:'mtime') at:'seconds'.
    mtimeuSeconds := (attributes at:'mtime') at:'useconds'.

    TraceOps == true ifTrue:[
        Transcript show:'create "', name , '" in: "'; show:dirPath; showCR:'"'.
    ].

    status := #NFSERR_PERM.

    realDirPath := self physicalFileNameFor:dirPath.
    realDirPath isNil ifTrue:[
        status := #NFSERR_STALE.
    ] ifFalse:[
        realDirPath isDirectory ifTrue:[
            newFile := realDirPath construct:name.
            newFile exists ifTrue:[
                status := #NFSERR_EXIST.
            ] ifFalse:[
                s := newFile writeStream.
                s notNil ifTrue:[
                    s close.
                    newName := (dirPath asFilename construct:name) name.
                    attributes := self attributesFor:newName.
                    fHandle := self handleFor:newName.
                    status := #NFS_OK.
                    diropok := Dictionary new
                        at:'file'       put:fHandle;
                        at:'attributes' put:attributes;
                        yourself.
                ]
            ]
        ].
    ].

"/ Transcript show:'getattr for: '; showCR:dirPath.

    ^ Dictionary new
        at:'status'    put:status;
        at:'diropok'   put:diropok;
        yourself
!

getattr:args
    |dirPath status attributes|

    dirPath := self unpackFileHandle:(args first).

    TraceOps == true ifTrue:[
        Transcript show:'getattr for: '; showCR:dirPath.
    ].

    status := #NFSERR_NOENT.
    dirPath notNil ifTrue:[
        attributes := self attributesFor:dirPath.
        attributes notNil ifTrue:[
            status := #NFS_OK.
        ].
    ].

    ^ Dictionary new
        at:'status' put:status;
        at:'attributes' put:attributes;
        yourself
!

link:args
    |arg toDirPath toName fromPath |

    arg := args first.

    fromPath := self unpackFileHandle:(arg at:'from').

    "/ diropargs
    toDirPath := self unpackFileHandle:((arg at:'to') at:'dir').
    toName    := (arg at:'to') at:'name'.

    TraceOps == true ifTrue:[
        Transcript 
                show:'link from: '; show:fromPath; 
                show:' to'; show:toName; show:' in '; showCR:toDirPath.
    ].

    ^ #NFSERR_PERM
!

lookup:args
    |arg dirPath path name status attributes diropok fHandle|

    arg := args first.

    "/ diropargs
    dirPath := self unpackFileHandle:(arg at:'dir').
    name    := arg at:'name'.

    TraceOps == true ifTrue:[
        Transcript show:'lookup "', name , '" in: "'; show:dirPath; showCR:'"'.
    ].

    status := #NFSERR_NOENT.

    dirPath isNil ifTrue:[
        self breakPoint:#cg. "/ should not happen
        status := #NFSERR_EXIST.
    ] ifFalse:[
        "/ path := dirPath asFilename constructString:name.
        path := (UnixFilename named:dirPath) constructString:name.
        attributes := self attributesFor:path.
    ].
    attributes notNil ifTrue:[
        status := #NFS_OK.
        fHandle := self handleFor:path.
        diropok := Dictionary new
            at:'file'       put:fHandle;
            at:'attributes' put:attributes;
            yourself.
    ].

    ^ Dictionary new
        at:'status'    put:status;
        at:'diropok'   put:diropok;
        yourself

    "Modified: / 19.2.2002 / 15:38:19 / cg"
!

mkdir:args
    |arg where dirPath name mode uid gid size diropok
     atimeSeconds atimeuSeconds mtimeSeconds mtimeuSeconds
     attributesIn attributesOut status fHandle 
     realFilename newName newPath|

    arg := args first.

    where := arg at:'where'.
    "/ diropargs
    dirPath := self unpackFileHandle:(where at:'dir').
    name    := where at:'name'.

    "/ sattr
    attributesIn := arg at:'attributes'.
    mode := attributesIn at:'mode'.
    uid := attributesIn at:'uid'.
    gid := attributesIn at:'gid'.
    size := attributesIn at:'size'.
    atimeSeconds := (attributesIn at:'atime') at:'seconds'.
    atimeuSeconds := (attributesIn at:'atime') at:'useconds'.
    mtimeSeconds := (attributesIn at:'mtime') at:'seconds'.
    mtimeuSeconds := (attributesIn at:'mtime') at:'useconds'.

    TraceOps == true ifTrue:[
        Transcript show:'mkdir "', name , '" in: "'; show:dirPath; showCR:'"'.
    ].

    realFilename := self physicalFileNameFor:dirPath.
    realFilename notNil ifTrue:[
        realFilename isDirectory ifTrue:[
            newName := realFilename construct:name.
            newName exists ifFalse:[
                newName makeDirectory.
                "/ newPath := dirPath asFilename constructString:name.
                newPath := (UnixFilename named:dirPath) constructString:name.
                attributesOut := self attributesFor:newPath
            ].
        ]
    ].

    attributesOut isNil ifTrue:[
        status := #NFSERR_PERM.
    ] ifFalse:[
        status := #NFS_OK.
        fHandle := self handleFor:newPath.
        diropok := Dictionary new
            at:'file'       put:fHandle;
            at:'attributes' put:attributesOut;
            yourself.
    ].

    ^ Dictionary new
        at:'status' put:status;
        at:'diropok' put:diropok;
        yourself

    "Modified: / 19.2.2002 / 15:39:38 / cg"
!

read:args
    |arg status path offset count totalCount attributes data attributesAndData|

    arg := args first.

    path := self unpackFileHandle:(arg at:'file').
    offset := arg at:'offset'.
    count := arg at:'count'.
    totalCount := arg at:'totalcount'.

    TraceOps == true ifTrue:[
        Transcript show:'read "'; show:path; 
                   show:'" offset: "'; show:offset; show:'"'; 
                   show:'" count: "'; show:count; show:'"'; 
                   show:'" totalCount: "'; show:totalCount; show:'"'; 
                   cr.
    ].

    attributes := self attributesFor:path.
    attributes isNil ifTrue:[
        "/ oops - file no longer exists
        status := #NFSERR_IO.
    ] ifFalse:[
        status := #NFS_OK.
        data := self dataFor:path.
        data isNil ifTrue:[
            "/ oops - file no longer exists
            status := #NFSERR_IO.
        ] ifFalse:[
            data := data copyFrom:offset+1 to:((offset+1+count-1) min:data size).
            attributesAndData := Dictionary new
                at:'attributes' put:attributes;
                at:'data' put:data;
                yourself.
        ].
    ].

    ^ Dictionary new
        at:'status' put:status;
        at:'attributesAndData' put:attributesAndData;
        yourself
!

readdir:args
    |arg dirPath cookieIn count firstId status
     files entries id nBytes readdirok more|

    arg := args first.

    dirPath := self unpackFileHandle:(arg at:'dir').
    cookieIn := arg at:'cookie'.
    count := arg at:'count'.

    TraceOps == true ifTrue:[
        Transcript show:'readdir "', dirPath , '"'.
        TraceArgs == true ifTrue:[
            Transcript show:' cookieIn='; show:cookieIn.
            Transcript show:' count='; showCR:count.
        ].
        Transcript cr.
    ].

    firstId := cookieIn unsignedLongAt:1.

    status := #NFSERR_NOENT.
    dirPath notNil ifTrue:[
        files := self filesFor:dirPath.
    ].

    files notNil ifTrue:[
        files := #('..' '.' ) , files.

        status := #NFS_OK.
        id := -1.
        nBytes := 0.

        entries := OrderedCollection new.
        more := false.
        files doWithExit:[:nm :exit | 
            |i fullName cookie entry szEntry|
     
            id := id + 1.

            id < firstId ifTrue:[
                VeryVerbose == true ifTrue:[
                    Transcript showCR:'skipped'.
                ]
            ] ifFalse:[
                nm = '..' ifTrue:[
                    i := dirPath lastIndexOf:$/.
                    i == 0 ifTrue:[
                        fullName := dirPath.
                    ] ifFalse:[
                        i == 1 ifTrue:[
                            fullName := '/'
                        ] ifFalse:[
                            fullName := dirPath copyTo:i-1.
                        ]
                    ].
                ] ifFalse:[
                    "/ fullName := dirPath asFilename constructString:nm.
                    fullName := (UnixFilename named:dirPath) constructString:nm.
                ].
                cookie := ByteArray new:4.
                cookie unsignedLongAt:1 put:id.

                VeryVerbose == true ifTrue:[
                    Transcript show:'name:'; show:nm.
                    Transcript show:' full:'; show:fullName.
                    Transcript show:' id:'; show:(self class handleFor:fullName).
                    Transcript show:' cookie:'; showCR:cookie.
                ] ifFalse:[
                    "/ Verbose == true ifTrue:[
nm = 'Array' ifTrue:[
                        Transcript show:'name:'; showCR:nm.
].
                    "/ ].
                ].

                entry := Dictionary new
                    at:'fileid'    put:(self class handleFor:fullName);
                    at:'name'      put:nm;
                    at:'cookie'    put:cookie;
                    yourself.


                szEntry := 4                        "fileID"
                           + 4                      "name size"
                           + (nm size + 3) // 4 * 4 "padded name"
                           + 4.                     "cookie"
                nBytes + szEntry >= count ifTrue:[
                    more := true.
                    exit value:nil
                ].

                entries add:entry.
                nBytes := nBytes + szEntry.
            ].
        ].
        
        readdirok := Dictionary new
                        at:'entries' put:entries;
                        at:'eof'     put:(more not);
                        yourself
    ].

"/ self halt.

    ^ Dictionary new
        at:'status' put:status;
        at:'readdirok' put:readdirok;
        yourself

    "Modified: / 19.2.2002 / 15:39:54 / cg"
!

readlink:args
    |arg path status realFilename info linkData|

    arg := args first.

    "/ fhandle
    path := self unpackFileHandle:arg.

    TraceOps == true ifTrue:[
        Transcript show:'readlink for: '; showCR:path.
    ].

    realFilename := self physicalFileNameFor:path.
    (realFilename isNil
    or:[realFilename isSymbolicLink not
    or:[(info := realFilename linkInfo) isNil]]) ifTrue:[
        linkData := '/tmp/badLink'.
        status := #NFS_OK.
    ] ifFalse:[
        linkData := info path.
        status := #NFS_OK.
    ].

    ^ Dictionary new
        at:'status' put:status;
        at:'data' put:linkData;
        yourself
!

remove:args
    |arg dirPath name realFilename oldName|

    arg := args first.

    "/ diropargs
    dirPath := self unpackFileHandle:(arg at:'dir').
    name    := arg at:'name'.

    TraceOps == true ifTrue:[
        Transcript show:'remove "', name , '" in: "'; show:dirPath; showCR:'"'.
    ].
    realFilename := self physicalFileNameFor:dirPath.
    realFilename isNil ifTrue:[
        ^ #NFSERR_NOENT
    ].
    realFilename isDirectory ifFalse:[
        ^ #NFSERR_NOENT
    ].
    oldName := realFilename construct:name.
    oldName exists ifFalse:[
        oldName isSymbolicLink ifFalse:[
            ^ #NFSERR_NOENT
        ]
    ].
    oldName isDirectory ifTrue:[
        ^ #NFSERR_ISDIR
    ].

    OsError handle:[:ex |
        ^ #NFSERR_PERM
    ] do:[
        oldName remove.
    ].
    ^ #NFS_OK
!

rename:args
    |arg fromDirPath fromName toDirPath toName
     fromRealFilename fromOldName toRealFilename toNewName|

    arg := args first.

    "/ diropargs
    fromDirPath := self unpackFileHandle:((arg at:'from') at:'dir').
    fromName    := (arg at:'from') at:'name'.

    toDirPath := self unpackFileHandle:((arg at:'to') at:'dir').
    toName    := (arg at:'to') at:'name'.

    TraceOps == true ifTrue:[
        Transcript 
                show:'rename '; show:fromName; show:' in: '; show:fromDirPath; 
                show:' to'; show:toName; show:' in '; showCR:toDirPath.
    ].

    fromRealFilename := self physicalFileNameFor:fromDirPath.
    fromRealFilename notNil ifTrue:[
        fromRealFilename isDirectory ifTrue:[
            fromOldName := fromRealFilename construct:fromName.
            fromOldName exists ifTrue:[

                toRealFilename := self physicalFileNameFor:toDirPath.
                toRealFilename notNil ifTrue:[
                    toRealFilename isDirectory ifTrue:[
                        toNewName := toRealFilename construct:toName.
                        toNewName exists ifFalse:[
                            OsError catch:[
                                fromOldName renameTo:toNewName.
                                ^ #NFS_OK
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].
    ^ #NFSERR_PERM
!

rmdir:args
    |arg dirPath name realFilename oldName|

    arg := args first.

    "/ diropargs
    dirPath := self unpackFileHandle:(arg at:'dir').
    name    := arg at:'name'.

    TraceOps == true ifTrue:[
        Transcript show:'rmdir "', name , '" in: "'; show:dirPath; showCR:'"'.
    ].

    realFilename := self physicalFileNameFor:dirPath.
    realFilename notNil ifTrue:[
        realFilename isDirectory ifTrue:[
            oldName := realFilename construct:name.
            oldName exists ifTrue:[
                oldName isDirectory ifTrue:[
                    OsError catch:[
                        oldName removeDirectory.
                        ^ #NFS_OK
                    ].
                
                ].
            ].
        ]
    ].
    ^ #NFSERR_PERM
!

root
    "/ void
!

setattr:args
    |arg path attributesIn attributesOut mode uid gid size 
     atimeSeconds atimeuSeconds mtimeSeconds mtimeuSeconds
     status|

    attributesOut := nil.

    arg := args first.

    "/ fhandle
    path := self unpackFileHandle:(args first at:'file').

    "/ sattr
    attributesIn := args first at:'attributes'.
    mode := attributesIn at:'mode'.
    uid := attributesIn at:'uid'.
    gid := attributesIn at:'gid'.
    size := attributesIn at:'size'.
    atimeSeconds := (attributesIn at:'atime') at:'seconds'.
    atimeuSeconds := (attributesIn at:'atime') at:'useconds'.
    mtimeSeconds := (attributesIn at:'mtime') at:'seconds'.
    mtimeuSeconds := (attributesIn at:'mtime') at:'useconds'.

    TraceOps == true ifTrue:[
        Transcript show:'setattr '; showCR:path.
    ].

    "/ I will never change any file attributes!!

    status := #NFSERR_PERM.
    "/ attributesOut := self attributesFor:path.
    attributesOut notNil ifTrue:[
        status := #NFS_OK.
    ].
    ^ Dictionary new
        at:'status' put:status;
        at:'attributes' put:attributesOut;
        yourself
!

statfs:args
    |dirPath status attributes|

    dirPath := self unpackFileHandle:(args first).

    TraceOps == true ifTrue:[
        Transcript show:'statfs '; showCR:dirPath.
    ].

    dirPath isNil ifTrue:[
        status := #NFSERR_EXIST.
        self breakPoint:#cg. "/ should not happen
    ] ifFalse:[
        status := #NFS_OK.
        attributes := Dictionary new.

        attributes at:'tsize' put:8192.
        attributes at:'bsize' put:1.
        attributes at:'blocks' put:1024.
        attributes at:'bfree' put:0.
        attributes at:'bavail' put:0.
    ].

    ^ Dictionary new
        at:'status' put:status;
        at:'info' put:attributes;
        yourself
!

symlink:args
    |arg fromArg fromDirPath fromName toPath attributes mode uid gid size 
     atimeSeconds atimeuSeconds mtimeSeconds mtimeuSeconds|

    arg := args first.

    "/ diropargs
    fromArg := arg at:'from'.
    fromDirPath := self unpackFileHandle:(fromArg at:'dir').
    fromName    := fromArg at:'name'.

    toPath := (arg at:'to').

    TraceOps == true ifTrue:[
        Transcript 
                show:'symlink from: '; show:fromName; show:' in '; show:fromDirPath; 
                show:' to'; showCR:toPath.
    ].

    "/ sattr
    attributes := arg at:'attributes'.
    mode := attributes at:'mode'.
    uid := attributes at:'uid'.
    gid := attributes at:'gid'.
    size := attributes at:'size'.
    atimeSeconds := (attributes at:'atime') at:'seconds'.
    atimeuSeconds := (attributes at:'atime') at:'useconds'.
    mtimeSeconds := (attributes at:'mtime') at:'seconds'.
    mtimeuSeconds := (attributes at:'mtime') at:'useconds'.

    ^ #NFSERR_PERM
!

write:args
    |arg path beginOffset offset totalCount data status attributes 
     realFilename s|

    arg := args first.

    path := self unpackFileHandle:(args first at:'file').
    beginOffset := args first at:'beginoffset'.        "/ ignored
    offset := args first at:'offset'.
    totalCount := args first at:'totalcount'.          "/ ignored
    data := args first at:'data'.

    TraceOps == true ifTrue:[
        Transcript show:'write "'; show:path; 
           show:'" beginOffset: "'; show:beginOffset; show:'"'; 
           show:'" offset: "'; show:offset; show:'"'; 
           show:'" totalCount: "'; show:totalCount; show:'"'; 
           cr.
    ].

    status := #NFSERR_PERM.

    realFilename := self physicalFileNameFor:path.
    realFilename isNil ifTrue:[
        status := #NFSERR_STALE.
    ] ifFalse:[
        realFilename isDirectory ifFalse:[

            s := realFilename writeStream.
            s binary.
            s position:(offset + s class zeroPosition).
            s nextPutAll:data.
            s close.
            attributes := self attributesFor:path.
        ].
    ].

    attributes notNil ifTrue:[
        status := #NFS_OK.
    ].

    ^ Dictionary new
        at:'status' put:status;
        at:'attributes' put:attributes;
        yourself
!

writecache
    "/ void
! !

!NFSServer methodsFor:'queries'!

portNumbers
    ^ #( 33334 43334 53334 )
!

simulatedFileHome
    OperatingSystem isUNIXlike ifTrue:[
        ^ OperatingSystem getHomeDirectory , '/'
    ].
    ^ 'c:\'

    "Modified: / 1.2.2002 / 11:26:07 / cg"
! !

!NFSServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_NFSServer.st,v 1.48 2018-01-19 22:32:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_NFSServer.st,v 1.48 2018-01-19 22:32:25 cg Exp $'
! !


NFSServer initialize!

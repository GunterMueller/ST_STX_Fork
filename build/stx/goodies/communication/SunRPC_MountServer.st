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

RPCServer subclass:#MountServer
	instanceVariableNames:''
	classVariableNames:'Lock MountsPerHost'
	poolDictionaries:''
	category:'Net-Communication-SunRPC-NFS'
!

!MountServer class methodsFor:'documentation'!

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
    a mount daemon (mountd); see RFC1057 and examples.
    *** VERY COOL - see examples ***

    [author:]
        Claus Gittinger

    [start with:]
        SunRPC::MountServer start
        SunRPC::MountServer startUDP

        SunRPC::MountServer debug:true

    [see also:]
        RFC1057
"
!

examples
"
    SunRPC::MountServer killAll.
    SunRPC::MountServer initialize

    get it running:

  1) evaluate:
        SunRPC::MountServer start
    or,
        SunRPC::MountServer startUDP

  2) (in a terminal), create a directory:
        mkdir /smalltalk
        mkdir /smalltalk/local
        mkdir /smalltalk/<hostName>

  3) add the following line(s) to your /etc/fstab (must be root):
        localhost:/  /smalltalk/local  nfs rw,nolock,noauto,user,noatime,bg,soft,intr,
                                       retry=1,mountprog=200003,nfsprog=x200004
     and/or (even works remote):
        <hostname>:/  /smalltalk/<hostname>  nfs rw,nolock,noauto,user,noatime,bg,soft,
                                             intr,retry=1,mountprog=200003,nfsprog=x200004

  4) mount it/them with:
        mount /smalltalk/local
        mount /smalltalk/<hostname>

    finally, change directory to /smalltalk/local or /smalltalk/<hostname>
    and see (ls) what is there...
"
! !

!MountServer class methodsFor:'spec'!

xdr
    ^ '
//
// from RFC1094
//

/* The maximum number of bytes in a pathname argument. */
const MNTPATHLEN = 1024;

/* The maximum number of bytes in a name argument. */
const MNTNAMLEN = 255;

/* The size in bytes of the opaque file handle. */
const FHSIZE = 32;


typedef opaque fhandle[FHSIZE];

union fhstatus switch (unsigned int status) {
case 0:
    fhandle directory;
default:
    void;
};

typedef string dirpath<MNTPATHLEN>;

typedef string name<MNTNAMLEN>;

struct *mountlist {
        name      hostname;
        dirpath   directory;
        mountlist nextentry;
};

struct *groups {
        name grname;
        groups grnext;
};

struct *exportlist {
        dirpath filesys;
        groups groups;
        exportlist next;
};

/*
 * Protocol description for the mount program
 */
program MOUNTPROG {
        /*
         * Version 1 of the mount protocol used with
         * version 2 of the NFS protocol.
         */
        version MOUNTVERS {
                void
                null(void) = 0;

                fhstatus
                mnt(dirpath) = 1;

                mountlist
                dump(void) = 2;

                void
                umnt(dirpath) = 3;

                void
                umntall(void) = 4;

                exportlist
                export(void)  = 5;
        } = 1;
} = 200003; /* standard: 100003 */


'

    "Modified: / 30.1.2002 / 16:27:11 / cg"
! !

!MountServer methodsFor:'operations'!

dump
    |mounts|

    mounts := OrderedCollection new.
    MountsPerHost size > 0 ifTrue:[
        MountsPerHost keysAndValuesDo:[:eachHost :eachDir |
            mounts add:(Dictionary new
                            at:'hostname'  put:eachHost;
                            at:'directory' put:eachDir;
                            yourself).
        ].
    ].
    ^ mounts
!

export
    |exported|

    exported := OrderedCollection new.

    self exportedFileSystems do:[:entry |
        |groups dir group|

        dir := entry first. 
        group := entry second.

        groups := OrderedCollection new.
        groups add:(Dictionary new
                    at:'grname' put:group;
                    yourself).

        exported add:(Dictionary new
                    at:'filesys' put:dir;
                    at:'groups'  put:groups;
                    yourself).
    ].
    ^ exported

    "Modified: / 1.2.2002 / 11:46:04 / cg"
!

mnt:args
    |dirpath handleNr opaqueHandle ok|

    dirpath := args first.

    Transcript show:'mount: dirpath="'; show:dirpath; showCR:'"'.

    ok := self exportedFileSystems contains:[:entry | entry first = dirpath].
    ok ifFalse:[
        RPCOperationError raiseWith:#ENOENT.
    ].

    Lock isNil ifTrue:[
        Lock := Semaphore forMutualExclusion
    ].
    Lock critical:[
        MountsPerHost isNil ifTrue:[
            MountsPerHost := OrderedCollection new.
        ].
        "/ fs := self simulatedFileSystemFor:dirpath.
        MountsPerHost add:(requestHost -> dirpath).
    ].

    handleNr := NFSServer handleFor:dirpath.
    opaqueHandle := ByteArray new:4.
    opaqueHandle unsignedLongAt:1 put:handleNr.

    Lock critical:[
        self startNFSServerIfNotYetRunning.
    ].

    ^ Dictionary new
        at:'status'    put:0;
        at:'directory' put:opaqueHandle;
        yourself

    "Modified: / 1.2.2002 / 12:55:21 / cg"
!

umnt:args
    |dirpath found|

    dirpath := args first.

    Transcript show:'unmount: dirpath="'; show:dirpath; showCR:'"'.

    found := false.
    MountsPerHost notNil ifTrue:[
        Lock critical:[
            MountsPerHost keysAndValuesDo:[:idx :eachEntry |
                eachEntry value = dirpath ifTrue:[
                    "/ remove this one
                    MountsPerHost at:idx put:nil.
                    found := true.
                ]
            ].
        ].
    ].

    found ifFalse:[
        RPCOperationError raiseWith:#ENOENT.
    ].
    Lock critical:[
        MountsPerHost := MountsPerHost select:[:entry | entry notNil].
    ].

    "Modified: / 1.2.2002 / 12:03:19 / cg"
!

umntall
    self unimplementedOperation.
! !

!MountServer methodsFor:'private'!

simulatedFileSystemFor:dirpath
    |fs rootDir file|

    rootDir := SimulatedDirectory new.
    rootDir fileNumber:1.

    file := SimulatedFile new.
    file fileNumber:2.
    rootDir add:('A' -> file).

    file := SimulatedFile new.
    file fileNumber:3.
    rootDir add:('B' -> file).

    file := SimulatedFile new.
    file fileNumber:4.
    rootDir add:('C' -> file).

    fs := SimulatedFileSystem new.
    fs rootDirectory:rootDir.
!

startNFSServerIfNotYetRunning
    SunRPC::NFSServer 
        startServerIfNotYetRunningAtPort:(portNumber + 1) 
        protocol:protocol
! !

!MountServer methodsFor:'queries'!

exportedFileSystems
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ #(
                ('/'            '*')
                ('C:'           '*')
                ('D:'           '*')
                ('F:'           '*')
           )
    ].

    ^ #(
            ('/'            '*')
       )

    "Created: / 1.2.2002 / 11:44:19 / cg"
    "Modified: / 19.2.2002 / 15:33:29 / cg"
!

portNumbers
    ^ #( 33333 43333 53333 )
! !

!MountServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_MountServer.st,v 1.27 2017-11-18 09:52:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_MountServer.st,v 1.27 2017-11-18 09:52:05 cg Exp $'
! !


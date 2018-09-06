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

RPCClient subclass:#MountClient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-NFS'
!

!MountClient class methodsFor:'documentation'!

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
    interface to the mount daemon (mountd); see RFC1057 and examples.

    [author:]
        Claus Gittinger

    [see also:]
        RFC1057
"
!

examples
"
  connect test:
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient toHost:'localhost'.
    mountClient null.
                                                                [exEnd]

  connect test (use standard MOUNT program number; explicit protocol & port):
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient new.
    mountClient programNumber:100005; host:'exeptn' protocol:#udp port:20048.
    mountClient null; export.
                                                                [exEnd]

  connect test (acquires port via portMapper):
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient toHost:'exeptn' protocol:#udp port:nil.
    mountClient null.
                                                                [exEnd]

  dump local mounts:
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient toHost:'localhost'.
    mountClient dumpToTranscript.
                                                                [exEnd]
  dump mounts on some machine:
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient toHost:'alan' protocol:#udp port:33333.
    mountClient dumpToTranscript.
                                                                [exEnd]

  dump export list:
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient toHost:'localhost'.
    mountClient export.
                                                                [exEnd]

  use another (non default) port number:
                                                                [exBegin]
    |mountClient|

    mountClient := SunRPC::MountClient toHost:'localhost' port:33333.
    mountClient dumpToTranscript.
                                                                [exEnd]
"
! !

!MountClient class methodsFor:'spec'!

xdr
    ^ MountServer xdr

    "Modified: / 30.1.2002 / 15:55:29 / cg"
! !

!MountClient methodsFor:'operations'!

dump
    "return the mountd information (i.e. who has mounted what)."

    ^ self operation:#dump.

    "
     (self toHost:'localhost') dumpToTranscript; close
     (self toHost:'exept') dumpToTranscript; close
     (self toHost:'funkfix') dumpToTranscript; close

     (self toHost:'joshua' protocol:#udp port:33333) dumpToTranscript; close
    "

    "Modified: / 31.1.2002 / 15:32:28 / cg"
!

export
    "return the exported directory mountd information."

    ^ self operation:#export.

    "
     (self toHost:'localhost') export; close
     (self toHost:'exept') export; close
     (self toHost:'funkfix') export; close

     (self toHost:'joshua' protocol:#udp port:33333) exportToTranscript; close
    "

    "Modified: / 30.1.2002 / 16:23:14 / cg"
!

mount:dirPath
    "mount a directory - not yet operational from here 
     (need to access the mounted files via my own NFSClient, which is not yet ready)"

    |reply status handle errMsg|

    reply := self operation:#mnt argument:dirPath. "/ fhstatus

    status := reply at:'status'.
    status == 0 ifFalse:[
        errMsg := OperatingSystem errorTextForNumber:status.

        self error:'mount failed with: ' , errMsg , ' (status code: ' , status printString , ')'
    ].

    handle := reply at:'directory'.
    ^ handle

    "
     (self new programNumber:100005; host:'localhost') mount:'/foo'; close
     (self new programNumber:100005; host:'localhost') mount:'/'; close
     (self new programNumber:100005; host:'exept') mount:'/foo'; close
     (self new programNumber:100005; host:'exept') mount:'/home'; close
     (self new programNumber:100005; host:'exept') mount:'/'; close
     (self new programNumber:100005; protocol:#tcp; host:'alan')  mount:'/'; close
     (self new programNumber:100005; protocol:#tcp; host:'exept') export; close

     (self new programNumber:200005; protocol:#tcp; host:'alan')  mount:'/'; close
     (self new programNumber:200005; protocol:#tcp; host:'exept') export; close

     (self toHost:'joshua' protocol:#udp port:33333) mount:'C:'; close
    "

    "Modified: / 31.1.2002 / 15:20:19 / cg"
! !

!MountClient methodsFor:'utilities'!

dumpToTranscript
    "dump the mountd information (i.e. who has mounted what).
     roughly equivalent to showmount unix command"

    |reply|

    reply := self dump.

    Transcript showCR:'Mounts at ' , host , ':'.
    Transcript showCR:'----------------------------------------'.
    reply do:[:eachMountAssoc |
        |hostname hostaddr directory|

        hostname := eachMountAssoc at:'hostname'.
        directory := eachMountAssoc at:'directory'.

        "/ hostname could be string in dot-notation; resolve
        hostaddr := Socket ipAddressOfHost:hostname.
        hostaddr notNil ifTrue:[
            hostname := Socket hostWithIpAddress:hostaddr.
        ].

        Transcript 
            show:'hostname: '; show:hostname;     
            show:' directory: '; show:directory; 
            cr    
    ].
    Transcript showCR:'----------------------------------------'.

    "
     (self toHost:'localhost') dumpToTranscript; close
     (self toHost:'exept') dumpToTranscript; close
     (self toHost:'funkfix') dumpToTranscript; close
     (self toHost:'joshua' protocol:#udp port:33333) dumpToTranscript; close
    "

    "Modified: / 31.1.2002 / 15:32:28 / cg"
!

exportToTranscript
    "dump the exported directory mountd information.
     roughly equivalent to exports unix command"

    |reply|

    reply := self export.

    Transcript showCR:'Exported by ' , host , ':'.
    Transcript showCR:'----------------------------------------'.
    reply do:[:eachExportedFS |
        |dirpath names|

        dirpath := eachExportedFS at:'filesys'.
        names := eachExportedFS at:'groups'.

        Transcript 
            show:'path: '; show:dirpath.
        names do:[:eachNameEntry |
            Transcript space; show:(eachNameEntry at:'grname')
        ].
        Transcript cr    
    ].
    Transcript showCR:'----------------------------------------'.

    "
     (self toHost:'localhost') export; close
     (self toHost:'exept') export; close
     (self toHost:'funkfix') export; close
     (self toHost:'joshua' protocol:#udp port:33333) exportToTranscript; close
    "

    "Modified: / 30.1.2002 / 16:23:14 / cg"
! !

!MountClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_MountClient.st,v 1.21 2017-11-18 09:52:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_MountClient.st,v 1.21 2017-11-18 09:52:17 cg Exp $'
! !


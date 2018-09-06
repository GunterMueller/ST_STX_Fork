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

RPCClient subclass:#NFSClient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-NFS'
!

!NFSClient class methodsFor:'documentation'!

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
!

examples
"
                                                        [exBegin]
    |pm|

    pm := PortMapperClient toHost:'exeptn'.
    pm null    
                                                        [exEnd]
"
! !

!NFSClient class methodsFor:'spec'!

xdr
        ^ NFSServer xdr

    "Modified: / 30.1.2002 / 15:55:13 / cg"
! !

!NFSClient methodsFor:'operations'!

create
    "/ to be implemented...
    self unimplementedOperation
!

getattr
    "/ to be implemented...
    self unimplementedOperation
!

link
    "/ to be implemented...
    self unimplementedOperation
!

lookup
    "/ to be implemented...
    self unimplementedOperation
!

mkdir
    "/ to be implemented...
    self unimplementedOperation
!

null
    "/ to be implemented...
    self unimplementedOperation
!

read
    "/ to be implemented...
    self unimplementedOperation
!

readdir
    "/ to be implemented...
    self unimplementedOperation
!

readlink
    "/ to be implemented...
    self unimplementedOperation
!

remove
    "/ to be implemented...
    self unimplementedOperation
!

rename
    "/ to be implemented...
    self unimplementedOperation
!

rmdir
    "/ to be implemented...
    self unimplementedOperation
!

root
    "/ to be implemented...
    self unimplementedOperation
!

setattr
    "/ to be implemented...
    self unimplementedOperation
!

statfs
    "/ to be implemented...
    self unimplementedOperation
!

symlink
    "/ to be implemented...
    self unimplementedOperation
!

write
    "/ to be implemented...
    self unimplementedOperation
!

writecache
    "/ to be implemented...
    self unimplementedOperation
! !

!NFSClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_NFSClient.st,v 1.15 2017-11-18 09:51:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_NFSClient.st,v 1.15 2017-11-18 09:51:53 cg Exp $'
! !


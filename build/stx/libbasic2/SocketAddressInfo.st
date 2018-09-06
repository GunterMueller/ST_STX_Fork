"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic2' }"

Object subclass:#SocketAddressInfo
	instanceVariableNames:'domain type protocol socketAddress canonicalName flags
		serviceName'
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Sockets'
!

!SocketAddressInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SocketAddressInfo methodsFor:'accessing'!

canonicalName
    ^ canonicalName
!

canonicalName:something
    canonicalName := something.
!

domain
    ^ domain
!

domain:something
    domain := something.
!

flags
    ^ flags
!

flags:something
    flags := something.
!

protocol
    ^ protocol
!

protocol:something
    protocol := something.
!

serviceName
    ^ serviceName
!

serviceName:something
    "service name is only used when raising an error"

    serviceName := something.
!

socketAddress
    ^ socketAddress
!

socketAddress:something
    socketAddress := something.
!

type
    ^ type
!

type:something
    type := something.
! !

!SocketAddressInfo methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:self className.
    aStream nextPutAll:'(domain='.
    domain printOn:aStream.
    aStream nextPutAll:' type='.
    type printOn:aStream.
    aStream nextPutAll:' addr='.
    socketAddress printOn:aStream.
    aStream nextPutAll:')'.
! !

!SocketAddressInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/SocketAddressInfo.st,v 1.5 2004-08-22 18:09:08 stefan Exp $'
! !

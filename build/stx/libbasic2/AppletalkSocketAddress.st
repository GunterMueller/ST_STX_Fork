"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SocketAddress variableByteSubclass:#AppletalkSocketAddress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Sockets'
!

!AppletalkSocketAddress class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Instances of AppletalkSocketAddress represent appletalk socket addresses.
    These consist of a network (2 bytes), a node (1 byte) and a port number.

    [author:]
        Claus Gittinger (cg@exept)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!AppletalkSocketAddress class methodsFor:'addressing'!

anyNet

    ^ 0
!

anyNode

    ^ 0
!

anyPort

    ^ 0
!

firstUnreservedPort

   ^ 128
!

maxPort

   ^ 254   "254 is only legal on localtalk"
! !

!AppletalkSocketAddress class methodsFor:'queries'!

domain

    ^ #'AF_APPLETALK'
!

obsoleteDomainSymbol
    ^ #appletalk
!

vwDomainSymbol
    ^ #afAppletalk
! !

!AppletalkSocketAddress methodsFor:'accessing'!

net
    ^ self unsignedShortAt:4 bigEndian:true
!

net:aNodeAddress
    self unsignedShortAt:4 put:aNodeAddress bigEndian:true

    "
     self new net:16r1234
    "
!

net:netNr node:nodeNr port:portNr
    self 
        net:netNr;
        node:nodeNr;
        port:portNr

    "
     AppletalkSocketAddress new net:1234 node:10 port:20
    "
    "
     AppletalkSocketAddress hostAddress:#[1 2 3] port:10
    "
!

node
    ^ self at:6
!

node:aNodeNr
    self at:6 put:aNodeNr
!

port
    ^ self at:3
!

port:aPortNr
    self at:3 put:aPortNr
! !

!AppletalkSocketAddress methodsFor:'printing & storing'!

printAddressOn:aStream
    self net printOn:aStream.
    aStream nextPut:$:.
    self node printOn:aStream.
! !

!AppletalkSocketAddress methodsFor:'queries'!

portOrName
    ^ self port
! !

!AppletalkSocketAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


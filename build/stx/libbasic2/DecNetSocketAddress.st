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

"{ NameSpace: Smalltalk }"

SocketAddress variableByteSubclass:#DecNetSocketAddress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Sockets'
!

!DecNetSocketAddress class methodsFor:'documentation'!

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
!

documentation
"
    Instances of DecNetSocketAddress might eventually represent decnet socket addresses.
    This is an unfinished sceleton (who knows if there will ever be any interest in decnet...)


    [author:]
        Claus Gittinger (cg@exept)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!DecNetSocketAddress class methodsFor:'queries'!

domain

    ^ #'AF_DECnet'
!

obsoleteDomainSymbol
    ^ #decnet
!

vwDomainSymbol
    ^ #afDecnet
! !

!DecNetSocketAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


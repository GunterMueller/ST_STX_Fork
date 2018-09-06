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

XDRItem subclass:#XDRProgram
	instanceVariableNames:'versions'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

!XDRProgram class methodsFor:'documentation'!

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
    helper entity for the XDR-IDL parser

    [author:]
        Claus Gittinger
"
! !

!XDRProgram methodsFor:'accessing'!

programNumber
    "return the value of the instance variable 'programNumber' (automatically generated)"

    ^ number
!

programNumber:something
    "set the value of the instance variable 'programNumber' (automatically generated)"

    number := something.
!

versions
    "return the value of the instance variable 'versions' (automatically generated)"

    ^ versions
!

versions:something
    "set the value of the instance variable 'versions' (automatically generated)"

    versions := something.
! !

!XDRProgram methodsFor:'queries'!

isProgram
    ^ true
! !

!XDRProgram class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRProgram.st,v 1.9 2017-11-18 09:51:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRProgram.st,v 1.9 2017-11-18 09:51:57 cg Exp $'
! !


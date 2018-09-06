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

XDRItem subclass:#XDRProcedure
	instanceVariableNames:'type arguments'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

!XDRProcedure class methodsFor:'documentation'!

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

!XDRProcedure methodsFor:'accessing'!

arguments
    "return the value of the instance variable 'arguments' (automatically generated)"

    ^ arguments
!

arguments:something
    "set the value of the instance variable 'arguments' (automatically generated)"

    arguments := something.
!

programNumber
    ^ number 
!

programNumber:something
    number := something.
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.
! !

!XDRProcedure class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRProcedure.st,v 1.9 2017-11-18 09:52:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRProcedure.st,v 1.9 2017-11-18 09:52:10 cg Exp $'
! !


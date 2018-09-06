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

XDRItem subclass:#XDRProgramVersion
	instanceVariableNames:'procedures'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

!XDRProgramVersion class methodsFor:'documentation'!

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

!XDRProgramVersion methodsFor:'accessing'!

procedures
    "return the value of the instance variable 'procedures' (automatically generated)"

    ^ procedures
!

procedures:something
    "set the value of the instance variable 'procedures' (automatically generated)"

    procedures := something.
!

versionNumber
    ^ number
!

versionNumber:something
    number := something.
! !

!XDRProgramVersion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRProgramVersion.st,v 1.9 2017-11-18 09:52:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRProgramVersion.st,v 1.9 2017-11-18 09:52:21 cg Exp $'
! !


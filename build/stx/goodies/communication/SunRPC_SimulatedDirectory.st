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

OrderedCollection subclass:#SimulatedDirectory
	instanceVariableNames:'fileNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

!SimulatedDirectory class methodsFor:'documentation'!

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
! !

!SimulatedDirectory methodsFor:'accessing'!

fileNumber
    "return the value of the instance variable 'fileNumber' (automatically generated)"

    ^ fileNumber
!

fileNumber:something
    "set the value of the instance variable 'fileNumber' (automatically generated)"

    fileNumber := something.
! !

!SimulatedDirectory class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_SimulatedDirectory.st,v 1.4 2017-11-18 09:51:26 cg Exp $'
! !


"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

Object subclass:#ExternalInterface
	instanceVariableNames:'_errorCode'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!ExternalInterface class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    ExternalInterface is mostly provided as a mimicri class to be able to fileIn
    visualWorks extern-library interfacing classes.
"
! !

!ExternalInterface methodsFor:'queries'!

externalAccessFailedWith:errno
    self primitiveFailed
!

libraryName
    "should be redefined in a subclass to provide a proper name"

    ^ 'unknown.dll'
! !

!ExternalInterface class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ExternalInterface.st,v 1.1 2009-08-13 13:30:42 cg Exp $'
! !

"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

AbstractDesktop subclass:#WindowsDesktop
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Desktop'
!

!WindowsDesktop class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!WindowsDesktop class methodsFor:'accessing'!

priority

    ^1

    "Modified: / 11-08-2009 / 16:40:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WindowsDesktop class methodsFor:'testing'!

isAvailable

    ^OperatingSystem isMSWINDOWSlike

    "Modified: / 11-08-2009 / 16:40:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WindowsDesktop class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/WindowsDesktop.st,v 1.1 2011-06-28 10:09:58 vrany Exp $'
!

version_SVN
    ^ ' Id: WindowsDesktop.st 10524 2010-05-20 13:35:23Z vranyj1  '
! !

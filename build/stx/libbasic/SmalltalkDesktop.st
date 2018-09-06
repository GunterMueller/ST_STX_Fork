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

AbstractDesktop subclass:#SmalltalkDesktop
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Desktop'
!

!SmalltalkDesktop class methodsFor:'documentation'!

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

!SmalltalkDesktop class methodsFor:'accessing'!

priority

    ^0

    "Modified: / 12-08-2009 / 10:44:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDesktop class methodsFor:'testing'!

isAvailable

    "
        Smalltalk desktop is always available.
    "

    ^true

    "Modified: / 12-08-2009 / 10:45:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDesktop class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/SmalltalkDesktop.st,v 1.1 2011-06-28 10:09:43 vrany Exp $'
!

version_SVN
    ^ ' Id: SmalltalkDesktop.st 10524 2010-05-20 13:35:23Z vranyj1  '
! !

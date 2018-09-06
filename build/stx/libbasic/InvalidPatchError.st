"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ProceedableError subclass:#InvalidPatchError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!InvalidPatchError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    Patch could not be loaded.
    The reason is passed in the message string

    [author:]
        Stefan Vogel

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!InvalidPatchError class methodsFor:'initialization'!

initialize
    NotifierString := 'Cannot load patch'.
! !

!InvalidPatchError class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/InvalidPatchError.st,v 1.1 2011-02-03 11:49:27 stefan Exp $'
! !

InvalidPatchError initialize!

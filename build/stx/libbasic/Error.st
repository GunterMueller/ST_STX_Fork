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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Exception subclass:#Error
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!Error class methodsFor:'documentation'!

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
    Error is the superclass and parent of all error exceptions in the system

    [author:]
        Stefan Vogel

    [see also:]
        Signal
"
! !

!Error class methodsFor:'initialization'!

initialize
    NotifierString := 'error encountered'.

    "Created: / 04-08-1999 / 08:48:18 / stefan"
    "Modified: / 17-11-2010 / 17:53:07 / cg"
! !


!Error class methodsFor:'queries'!

mayProceed
    "By default, errors do not allow to proceed.
     Subclasses may change this"

    ^ false

    "Created: / 23.7.1999 / 14:52:26 / stefan"
    "Modified: / 23.7.1999 / 14:52:39 / stefan"
! !

!Error methodsFor:'testing'!

isError
    ^ true
! !

!Error class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Error initialize!

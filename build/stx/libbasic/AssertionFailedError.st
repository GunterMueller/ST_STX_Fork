"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2007 by eXept Software AG
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

ExecutionError subclass:#AssertionFailedError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!AssertionFailedError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    Raised by failing assertions.
"
! !

!AssertionFailedError class methodsFor:'testing'!

isProgramError
    "redefined in all exceptions which are programmer's errors,
     and which should probably not be ignored.
     I.e. a global error handler should reject and let a debugger get control."

    ^ true
! !

!AssertionFailedError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: AssertionFailedError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !




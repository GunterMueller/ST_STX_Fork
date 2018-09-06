"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2005 by eXept Software AG
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

ExecutionError subclass:#ArithmeticError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!ArithmeticError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
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
     common superclass for all arithmetic errors.
"
! !

!ArithmeticError class methodsFor:'testing'!

isProgramError
    "redefined in all exceptions which are programmer's errors,
     and which should probably not be ignored.
     I.e. a global error handler should reject and let a debugger get control."

    ^ true
! !

!ArithmeticError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: ArithmeticError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


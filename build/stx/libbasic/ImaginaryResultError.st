"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic' }"

DomainError subclass:#ImaginaryResultError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!ImaginaryResultError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Raised by square root functions when the functions-arg is negative,
    so that the result would be imaginary.
    For example,
	-1 sqrt

    Can be caught (see Complex >> trapImaginary) to automagically convert to Complex)
"
! !

!ImaginaryResultError class methodsFor:'initialize'!

initialize
    NotifierString := 'imaginary result'.
! !

!ImaginaryResultError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ImaginaryResultError.st,v 1.3 2014-06-10 10:13:28 cg Exp $'
! !

ImaginaryResultError initialize!

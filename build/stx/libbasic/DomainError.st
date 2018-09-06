"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ArithmeticError subclass:#DomainError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!DomainError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    Raised by certain mathematical functions when the function-args
    value is not within the allowed domain.
    For example, 
        arcSin receiver not in -1..1
    or
        log receiver <= 0
"
! !

!DomainError class methodsFor:'initialization'!

initialize
    NotifierString := 'domain error'.
! !

!DomainError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/DomainError.st,v 1.4 2003/08/29 19:14:53 cg Exp $'
!

version_SVN
    ^ '$Id: DomainError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

DomainError initialize!




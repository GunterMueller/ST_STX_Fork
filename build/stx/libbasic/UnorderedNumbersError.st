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

ArithmeticError subclass:#UnorderedNumbersError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!UnorderedNumbersError class methodsFor:'documentation'!

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
    raised when unordered numbers are compared (i.e. complex number comparison)
"
! !


!UnorderedNumbersError class methodsFor:'initialization'!

initialize
    NotifierString := 'unordered'.
! !


!UnorderedNumbersError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UnorderedNumbersError.st,v 1.5 2013-03-13 23:44:03 cg Exp $'
!

version_SVN
    ^ '$Id: UnorderedNumbersError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


UnorderedNumbersError initialize!

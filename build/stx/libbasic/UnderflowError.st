"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

RangeError subclass:#UnderflowError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!UnderflowError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    raised when the function-result underflows the allowed range.
    (Float underflow)
"
! !


!UnderflowError class methodsFor:'initialization'!

initialize
    NotifierString := 'underflow'.
! !


!UnderflowError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UnderflowError.st,v 1.4 2013-03-13 23:43:59 cg Exp $'
!

version_SVN
    ^ '$Id: UnderflowError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


UnderflowError initialize!

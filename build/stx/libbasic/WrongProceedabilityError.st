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

SignalError subclass:#WrongProceedabilityError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!WrongProceedabilityError class methodsFor:'documentation'!

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
    WrongProceedabilityError is raised to indicate that someone tries
    to raise a nonproceedable exception proceedable.

    The parameter is the unproceedable signal.
"



! !

!WrongProceedabilityError class methodsFor:'initialization'!

initialize

    NotifierString := 'attempt to raise a nonproceedable signal proceedable'.

    "
     self initialize
    "


! !

!WrongProceedabilityError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/WrongProceedabilityError.st,v 1.4 2003/08/29 19:14:38 cg Exp $'
!

version_SVN
    ^ '$Id: WrongProceedabilityError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

WrongProceedabilityError initialize!




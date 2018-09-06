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

ProceedableError subclass:#TimeoutError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!TimeoutError class methodsFor:'documentation'!

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
    TimeoutError may be raised, when a timeout on some operation occurs.
    It is recommended to perform the operation in a while-loop, and to raise the
    exception proceedable, in order to retry the operation or wait
    by proceeding the exception.

    [author:]
        Stefan Vogel

    [instance variables]
        parameter      value of the timer in seconds

"
! !

!TimeoutError class methodsFor:'initialization'!

initialize

    NotifierString := 'timeout occurred'.

    "
     self initialize
    "
! !

!TimeoutError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: TimeoutError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


TimeoutError initialize!




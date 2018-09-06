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

ExecutionError subclass:#NonBooleanReceiverError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!NonBooleanReceiverError class methodsFor:'documentation'!

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
    Triggered by the VM, if a non-boolean is encountered in an inlined if or while
"
! !

!NonBooleanReceiverError class methodsFor:'initialization'!

initialize
    NotifierString := 'if/while on non-boolean receiver'.
! !

!NonBooleanReceiverError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/NonBooleanReceiverError.st,v 1.4 2003/09/05 10:27:38 stefan Exp $'
!

version_SVN
    ^ '$Id: NonBooleanReceiverError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

NonBooleanReceiverError initialize!




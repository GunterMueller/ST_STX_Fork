"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ExecutionError subclass:#MethodNotAppropriateError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!MethodNotAppropriateError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!MethodNotAppropriateError class methodsFor:'initialization'!

initialize
    NotifierString := 'method is not appropriate'.

    "Modified: / 02-11-2012 / 09:54:51 / cg"
! !

!MethodNotAppropriateError methodsFor:'accessing'!

messageSend
    ^ suspendedContext sender messageSend
! !

!MethodNotAppropriateError methodsFor:'printing & storing'!

description
    ^ super description, ': ', suspendedContext sender printString
! !

!MethodNotAppropriateError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/MethodNotAppropriateError.st,v 1.2 2013-12-06 14:32:12 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/MethodNotAppropriateError.st,v 1.2 2013-12-06 14:32:12 stefan Exp $'
! !


MethodNotAppropriateError initialize!

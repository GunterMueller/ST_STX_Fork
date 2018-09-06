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

ExecutionError subclass:#InvalidTypeError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!InvalidTypeError class methodsFor:'documentation'!

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
!

documentation
"
    Common error raised when some object has an unexpected type
"
! !

!InvalidTypeError class methodsFor:'initialization'!

initialize
    NotifierString := 'if/while on non-boolean receiver'.
! !

!InvalidTypeError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/InvalidTypeError.st,v 1.1 2012-11-02 09:19:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/InvalidTypeError.st,v 1.1 2012-11-02 09:19:52 cg Exp $'
! !

InvalidTypeError initialize!

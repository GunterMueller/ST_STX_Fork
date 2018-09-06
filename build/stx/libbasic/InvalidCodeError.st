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

ExecutionError subclass:#InvalidCodeError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!InvalidCodeError class methodsFor:'documentation'!

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
    Triggered by the VM, if an invalid code object is encountered in a method/block
"
! !

!InvalidCodeError class methodsFor:'initialization'!

initialize
    NotifierString := 'invalid code-object - not executable'.
! !

!InvalidCodeError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/InvalidCodeError.st,v 1.4 2003/09/05 10:27:13 stefan Exp $'
!

version_SVN
    ^ '$Id: InvalidCodeError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

InvalidCodeError initialize!




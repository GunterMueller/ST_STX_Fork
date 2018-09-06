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

InvalidCodeError subclass:#NoByteCodeError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!NoByteCodeError class methodsFor:'documentation'!

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
    Triggered by the VM, if an method/block without code is to be executed
"
! !

!NoByteCodeError class methodsFor:'initialization'!

initialize
    NotifierString := 'nil byteCode in code-object - not executable'.
! !

!NoByteCodeError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/NoByteCodeError.st,v 1.4 2003/09/05 10:27:06 stefan Exp $'
!

version_SVN
    ^ '$Id: NoByteCodeError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

NoByteCodeError initialize!




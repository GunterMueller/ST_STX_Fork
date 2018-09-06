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

ArgumentError subclass:#WrongNumberOfArgumentsError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!WrongNumberOfArgumentsError class methodsFor:'documentation'!

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
    Triggered by the VM, if a method/block is called with a wrong number of arguments.

    For normal method invocations (using message sends), 
    the smalltalk compiler protects you from this error,
    as the number of arguments to a method is defined by the selector.
    However, using reflection or perform-like operations, it is possible to
    ask for a method to be called with the wrong number of arguments.
"
! !

!WrongNumberOfArgumentsError class methodsFor:'initialization'!

initialize
    NotifierString := 'wrong number of argument(s)'.
! !

!WrongNumberOfArgumentsError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/WrongNumberOfArgumentsError.st,v 1.5 2003/12/05 15:47:45 cg Exp $'
!

version_SVN
    ^ '$Id: WrongNumberOfArgumentsError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

WrongNumberOfArgumentsError initialize!




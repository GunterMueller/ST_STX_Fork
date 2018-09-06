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

InvalidCodeError subclass:#BadLiteralsError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!BadLiteralsError class methodsFor:'documentation'!

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
    Triggered by the VM, if an invalid literal array is encountered in a method/block
"
! !

!BadLiteralsError class methodsFor:'initialization'!

initialize
    NotifierString := 'bad literal table in code-object'.
! !

!BadLiteralsError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/BadLiteralsError.st,v 1.4 2003/09/05 10:27:45 stefan Exp $'
!

version_SVN
    ^ '$Id: BadLiteralsError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

BadLiteralsError initialize!




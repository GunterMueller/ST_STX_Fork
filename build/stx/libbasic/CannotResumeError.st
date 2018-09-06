"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ContextError subclass:#CannotResumeError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!CannotResumeError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    Raised if a method which was compiled non-resumable is asked to do so.
    As non-resumable code is faster and shorter, the compilers do not
    generate resumable code by default.
    Resumability can be enforced by a compiler switch or via a #return/#resume directive.
"
! !

!CannotResumeError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CannotResumeError.st,v 1.6 2013-12-24 10:39:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/CannotResumeError.st,v 1.6 2013-12-24 10:39:51 cg Exp $'
!

version_SVN
    ^ '$Id: CannotResumeError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


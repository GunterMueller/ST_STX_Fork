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

"{ NameSpace: Smalltalk }"

ExecutionError subclass:#SubclassResponsibilityError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!SubclassResponsibilityError class methodsFor:'documentation'!

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
    Raised when a method which should have been reimplemented by a
    concrete subclass was not, and the method of the abstract class was
    invoked instead.
"
! !

!SubclassResponsibilityError class methodsFor:'initialization'!

initialize

   NotifierString := 'method must be reimplemented in subclass'
! !

!SubclassResponsibilityError methodsFor:'queries'!

description
    |dscr|

    dscr := super description.

    parameter isNil ifTrue:[^ dscr].
    ^ '"',parameter , '" ', dscr

    "Modified: / 19-12-2010 / 08:50:13 / cg"
! !

!SubclassResponsibilityError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


SubclassResponsibilityError initialize!

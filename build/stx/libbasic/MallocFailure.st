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

AllocationFailure subclass:#MallocFailure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!MallocFailure class methodsFor:'documentation'!

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
    raised when a malloc (non-object memory allocation) fails.
    Typically by ExternalBytes and similar classes.
"
! !


!MallocFailure class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/MallocFailure.st,v 1.3 2013-03-13 23:47:08 cg Exp $'
!

version_SVN
    ^ '$Id: MallocFailure.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


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

Error subclass:#VMInternalError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!VMInternalError class methodsFor:'documentation'!

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
    VMInternalError is raised, when VM hits some bad error,
    such as corrupted class, corrupted method/selector array, etc.
    The message text gives some more information on what happened.
    (for example, if you set an objects class to a non-behavior, nil etc.).
    It is not guaranteed, that the system is in a working condition once
    such an error occurred.

    Instance Variables:
        parameter - the object that triggered the error.
"
! !

!VMInternalError class methodsFor:'initialization'!

initialize
    NotifierString := 'VM internal error: '.
! !

!VMInternalError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/VMInternalError.st,v 1.3 2011-09-29 11:19:50 cg Exp $'
! !

VMInternalError initialize!

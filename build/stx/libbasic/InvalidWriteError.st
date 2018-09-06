"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

WriteError subclass:#InvalidWriteError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!InvalidWriteError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    raised when writing to readonly streams
"
! !

!InvalidWriteError methodsFor:'printing & storing'!

description
    ^ super description, ': ', parameter classNameWithArticle
! !

!InvalidWriteError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/InvalidWriteError.st,v 1.4 2014-11-28 09:39:53 cg Exp $'
! !


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

StreamError subclass:#StreamNotOpenError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!StreamNotOpenError class methodsFor:'documentation'!

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
! !

!StreamNotOpenError methodsFor:'printing & storing'!

description
    ^ super description, ': ', parameter classNameWithArticle
! !

!StreamNotOpenError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/StreamNotOpenError.st,v 1.3 2005/02/02 10:59:49 cg Exp $'
!

version_SVN
    ^ '$Id: StreamNotOpenError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !




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

NotFoundError subclass:#KeyNotFoundError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!KeyNotFoundError class methodsFor:'documentation'!

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
    raised when a key was not found in a collection.
"
! !

!KeyNotFoundError class methodsFor:'initialization'!

initialize
    NotifierString := 'no such key: '.

    "
     self initialize
    "
! !

!KeyNotFoundError methodsFor:'accessing'!

index
    "the index, which was not found"

    ^ parameter
! !

!KeyNotFoundError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/KeyNotFoundError.st,v 1.3 2015-03-26 13:21:27 cg Exp $'
! !


KeyNotFoundError initialize!

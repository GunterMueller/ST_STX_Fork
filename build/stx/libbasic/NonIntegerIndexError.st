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

IndexNotFoundError subclass:#NonIntegerIndexError
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-Errors'
!

!NonIntegerIndexError class methodsFor:'documentation'!

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
    raised when a non-integer index is used when accessing an 
    arrayed collection.
"
! !


!NonIntegerIndexError class methodsFor:'initialization'!

initialize
    NotifierString := 'index must be integer'.

    "
     self initialize
    "
! !


!NonIntegerIndexError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: NonIntegerIndexError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


NonIntegerIndexError initialize!

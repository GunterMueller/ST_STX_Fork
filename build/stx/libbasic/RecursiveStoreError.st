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

Notification subclass:#RecursiveStoreError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!RecursiveStoreError class methodsFor:'documentation'!

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
    Raised on an attempt to store an object with cycles with a store mechanism,
    that does not support cycles (e.g. #storeOn:).
"
! !

!RecursiveStoreError class methodsFor:'initialization'!

initialize

    NotifierString := 'attempt to store an recursive object'.

    "
     self initialize
    "
! !

!RecursiveStoreError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/RecursiveStoreError.st,v 1.2 2012-11-23 12:14:02 cg Exp $'
! !

RecursiveStoreError initialize!

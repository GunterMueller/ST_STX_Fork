"
 COPYRIGHT (c) 2014 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

PackageLoadError subclass:#PackageNotFoundError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!PackageNotFoundError class methodsFor:'documentation'!

documentation
"
    raised when a package is not found
"
! !

!PackageNotFoundError class methodsFor:'initialization'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

initialize
    NotifierString := 'Package not found'.
! !

!PackageNotFoundError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/PackageNotFoundError.st,v 1.2 2014-11-20 00:11:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/PackageNotFoundError.st,v 1.2 2014-11-20 00:11:17 cg Exp $'
! !


PackageNotFoundError initialize!

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

ProceedableError subclass:#PackageLoadError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!PackageLoadError class methodsFor:'documentation'!

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

documentation
"
    Superclass of all package load errors
"
! !

!PackageLoadError class methodsFor:'initialization'!

initialize
    NotifierString := 'Package load failed'.
! !

!PackageLoadError methodsFor:'printing & storing'!

description
    ^ super description, ': ''', parameter printString, ''''
! !

!PackageLoadError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/PackageLoadError.st,v 1.2 2014-11-20 00:11:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/PackageLoadError.st,v 1.2 2014-11-20 00:11:08 cg Exp $'
! !


PackageLoadError initialize!

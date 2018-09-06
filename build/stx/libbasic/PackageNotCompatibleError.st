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

PackageNotFoundError subclass:#PackageNotCompatibleError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!


!PackageNotCompatibleError class methodsFor:'initialization'!

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
    raised when a package is not compatible with this platform/machine.
    There are not many, for which this is raised; one example is OLE, COM,
    which are only supported for windows systems.
"
!

initialize
    NotifierString := 'Package is not compatible with this platform'.
! !

!PackageNotCompatibleError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/PackageNotCompatibleError.st,v 1.1 2014-11-20 00:11:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/PackageNotCompatibleError.st,v 1.1 2014-11-20 00:11:55 cg Exp $'
! !


PackageNotCompatibleError initialize!

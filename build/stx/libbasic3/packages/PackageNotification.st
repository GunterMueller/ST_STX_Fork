"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Notification subclass:#PackageNotification
	instanceVariableNames:'package'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Exception-Notifications'
!

!PackageNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PackageNotification class methodsFor:'raising'!

raiseUnloadingWorkingPackage:aPackageName
    ^ self raiseErrorString:'Attempting to unload a workingPackage, will by default unload the package /'withCRs,
        'and set the working package as the default package!!'.
! !

!PackageNotification class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/PackageNotification.st,v 1.3 2006-01-10 09:32:07 cg Exp $'
! !

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

Prerequisite subclass:#PackagePrerequisite
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Prerequisite'
!

!PackagePrerequisite class methodsFor:'documentation'!

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

!PackagePrerequisite methodsFor:'evaluation'!

testCondition
    ^ (PackageManager smalltalkPackageManager includesPackageNamed:name)
! !

!PackagePrerequisite methodsFor:'queries'!

isPackagePrerequisite
    ^ true
! !

!PackagePrerequisite class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PackagePrerequisite.st,v 1.2 2006/01/10 09:32:00 cg Exp $'
! !
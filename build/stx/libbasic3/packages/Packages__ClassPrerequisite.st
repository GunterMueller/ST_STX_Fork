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

Prerequisite subclass:#ClassPrerequisite
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Prerequisite'
!

!ClassPrerequisite class methodsFor:'documentation'!

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

!ClassPrerequisite methodsFor:'evaluation'!

testCondition
    "returns a boolean"
    ^ (Smalltalk at:name) notNil
! !

!ClassPrerequisite methodsFor:'queries'!

isClassPrerequisite
    ^ true
! !

!ClassPrerequisite class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/ClassPrerequisite.st,v 1.2 2006/01/10 09:29:39 cg Exp $'
! !
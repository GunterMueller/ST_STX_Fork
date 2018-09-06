"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Change subclass:#NameSpaceCreationChange
	instanceVariableNames:'otherParameters nameSpaceName'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!NameSpaceCreationChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

! !

!NameSpaceCreationChange methodsFor:'accessing'!

fullClassName
    ^ nameSpaceName
!

name:nm
    nameSpaceName := nm

    "Created: / 16.2.1998 / 14:31:14 / cg"
!

nameSpaceName:nm
    nameSpaceName := nm

    "Created: / 16.2.1998 / 14:31:14 / cg"
!

otherParameters
    "return the value of the instance variable 'otherParameters' (automatically generated)"

    ^ otherParameters
!

otherParameters:something
    "set the value of the instance variable 'otherParameters' (automatically generated)"

    otherParameters := something.
! !

!NameSpaceCreationChange methodsFor:'applying'!

apply
    "apply the change"

    NameSpace fullName:nameSpaceName
! !

!NameSpaceCreationChange methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:'NameSpace fullName:'; 
        nextPutAll:nameSpaceName asSymbol storeString

    "Created: / 16.2.1998 / 14:31:41 / cg"
! !

!NameSpaceCreationChange methodsFor:'testing'!

isNameSpaceCreationChange
    ^ true

    "Created: / 24-11-2011 / 12:10:12 / cg"
! !

!NameSpaceCreationChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/NameSpaceCreationChange.st,v 1.5 2015-03-24 18:00:15 cg Exp $'
! !


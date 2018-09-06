"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

Change subclass:#OtherChange
	instanceVariableNames:'type file position'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!OtherChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !


!OtherChange methodsFor:'accessing'!

file
    "return the value of the instance variable 'file' (automatically generated)"

    ^ file
!

file:something
    "set the value of the instance variable 'file' (automatically generated)"

    file := something.
!

file:aFilename position:anInteger
    "set the value of the instance variable 'file' (automatically generated)"

    file := aFilename.
    position := anInteger
!

position
    "return the value of the instance variable 'position' (automatically generated)"

    ^ position
!

position:something
    "set the value of the instance variable 'position' (automatically generated)"

    position := something.
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.
! !


!OtherChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'OtherChange: '.
    source notNil ifTrue:[
        aStream nextPutAll:source.
    ].
! !


!OtherChange methodsFor:'testing'!

isOtherChange
    ^ true
! !


!OtherChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/OtherChange.st,v 1.5 2012-07-31 12:23:08 vrany Exp $'
!

version_CVS
    ^ '§Header: /cvs/stx/stx/libbasic3/OtherChange.st,v 1.5 2012-07-31 13:23:08 +0100 vrany Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: OtherChange.st 1942 2012-07-27 14:53:23Z vranyj1 §'
! !


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

ClassChange subclass:#ClassOtherChange
	instanceVariableNames:'type objectType'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassOtherChange class methodsFor:'documentation'!

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
!

documentation
"
    Any other class related change
"
! !

!ClassOtherChange methodsFor:'accessing'!

objectType
    "return the value of the instance variable 'objectType' (automatically generated)"

    ^ objectType
!

objectType:something
    "set the value of the instance variable 'objectType' (automatically generated)"

    objectType := something.
!

source
    type == #initialize ifTrue:[
        ^ self className , ' initialize'.
    ].
    self halt:'as yet unhandled doIt expression in change file'.
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.
! !

!ClassOtherChange class methodsFor:'documentation'!

version
    ^ '$Header: ClassOtherChange.st 1909 2012-03-31 00:14:49Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: ClassOtherChange.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !


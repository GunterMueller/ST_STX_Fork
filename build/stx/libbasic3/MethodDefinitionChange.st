"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

MethodChange subclass:#MethodDefinitionChange
	instanceVariableNames:'attributes'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!MethodDefinitionChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    instances represent method-code changes (as done in the browser). 
"
! !

!MethodDefinitionChange methodsFor:'accessing'!

attributes
    "return the value of the instance variable 'attributes' (automatically generated)"

    ^ attributes
!

attributes:something
    "set the value of the instance variable 'attributes' (automatically generated)"

    attributes := something.
! !

!MethodDefinitionChange methodsFor:'testing'!

isMethodDefinitionChange
    ^ true
! !

!MethodDefinitionChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodDefinitionChange.st,v 1.5 2013-01-18 12:55:22 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: MethodDefinitionChange.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !


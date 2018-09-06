"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ClassDescription subclass:#InlineObjectClassDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Programming-Support'
!

!InlineObjectClassDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!InlineObjectClassDescription methodsFor:'queries'!

name
    "although inline objects have no name, we return something
     useful here - there are many places (inspectors) where
     a classes name is asked for."

    ^ #'someInlineObject'
!

nameSpace
    ^ nil

    "Created: / 13-08-2010 / 18:23:33 / cg"
! !

!InlineObjectClassDescription class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


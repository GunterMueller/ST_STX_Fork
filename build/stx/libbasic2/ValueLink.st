"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Link subclass:#ValueLink
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!ValueLink class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this class provides Links which can hold a value.
    Instances are typically used as elements in a linkedList.

    [see also:]
        LinkedList
        Collection OrderedCollection

    [author:]
        Claus Gittinger
"
! !

!ValueLink class methodsFor:'instance creation'!

value: aValue
    "return a new instance with a value of aValue."

    ^self basicNew value:aValue

    "Created: 9.5.1996 / 16:12:19 / cg"
! !

!ValueLink methodsFor:'accessing'!

value
    "return the Links contents"

    ^ value
!

value:anObject
    "set the Links contents"

    value := anObject
! !

!ValueLink methodsFor:'printing'!

printOn:aStream
    aStream show:'%1(%2)' with:(self class name) with:self value.
! !

!ValueLink class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


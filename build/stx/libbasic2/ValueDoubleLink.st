"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2016 by eXept Software AG
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

DoubleLink subclass:#ValueDoubleLink
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!ValueDoubleLink class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    this class provides DoubleLinks which can hold a value.
    Instances are typically used as elements in a doubleLinkedList.

    [see also:]
        LinkedList DoubleLinkedList ValueLink Link
        Collection OrderedCollection

    [author:]
        Claus Gittinger
"
! !

!ValueDoubleLink class methodsFor:'instance creation'!

value: aValue
    "return a new instance with a value of aValue."

    ^self basicNew value:aValue

    "Created: 9.5.1996 / 16:12:19 / cg"
! !

!ValueDoubleLink methodsFor:'accessing'!

value
    ^ value
!

value:something
    value := something.
! !

!ValueDoubleLink methodsFor:'printing'!

printOn:aStream
    aStream show:'%1(%2)' with:(self class name) with:self value.
! !

!ValueDoubleLink class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


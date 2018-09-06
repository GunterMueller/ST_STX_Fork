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

Link subclass:#DoubleLink
	instanceVariableNames:'previousLink'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!DoubleLink class methodsFor:'documentation'!

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
    this class provides the basic functionality for DoubleLink-nodes.
    DoubleLinks are abstract in that they do not provide a place for storing 
    something, just the link-chains. So concrete linkedList elements
    must subclass from me and add their value slots.
    
    For more usability look at ValueDoubleLink or other subclasses.

    [author:]
        Claus Gittinger
"
! !

!DoubleLink methodsFor:'accessing'!

previousLink
    "return the previous link"
    
    ^ previousLink
!

previousLink:aLInk
    "set the previous link"

    previousLink := aLInk.
! !

!DoubleLink methodsFor:'converting'!

asDoubleLink
    ^ self
! !

!DoubleLink class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


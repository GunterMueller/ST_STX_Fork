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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Link
	instanceVariableNames:'nextLink'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!Link class methodsFor:'documentation'!

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
    this class provides the basic functionality for Link-nodes.
    Links are abstract in that they do not provide a place for storing 
    something, just the link-chain. So concrete linkedList elements
    must subclass from me and add their value slots.
    
    For more usability look at ValueLink or other subclasses.

    [author:]
        Claus Gittinger
"
! !

!Link methodsFor:'accessing'!

nextLink
    "return the next link"

    ^ nextLink
!

nextLink:aLink
    "set the next link"

    nextLink := aLink
! !

!Link methodsFor:'converting'!

asLink
    ^ self
! !

!Link class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


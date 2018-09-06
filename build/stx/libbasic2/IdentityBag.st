"
 COPYRIGHT (c) 2013 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Bag subclass:#IdentityBag
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!IdentityBag class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by Claus Gittinger
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
    Like a Bag, but does identity compares (i.e. same as super identityNew).
    For Squeak compatibility.

    [author:]
        Claus Gittinger

    [See also:]
        Set IdentitySet
        Dictionary IdentityDictionary
        OrderedCollection Array
"
! !

!IdentityBag class methodsFor:'instance creation'!

contentsClass
    "the default class to use for the underlying contents array,
     used when instantiated with new/new:"

    ^ IdentityDictionary
!

new:size
    "return a new empty Bag with initial space for size elements.
     Elements will be compared using identity compare (i.e. #== not #= equality)."

    ^ self identityNew:size
! !

!IdentityBag class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/IdentityBag.st,v 1.1 2013-08-23 00:21:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/IdentityBag.st,v 1.1 2013-08-23 00:21:51 cg Exp $'
! !


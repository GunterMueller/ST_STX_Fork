"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

Magnitude subclass:#LookupKey
	instanceVariableNames:'key'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!LookupKey class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    LookupKey has been extracted from Association for ST-80 compatibility.
    This class is currently not used directly.

    [Instance variables:]

        key             <Object>        the key

    [author:]
        Claus Gittinger
"
! !

!LookupKey class methodsFor:'instance creation'!

key:aKey
    "return a new instance."

    ^ self basicNew key:aKey
! !

!LookupKey methodsFor:'accessing'!

key
    "return the key of the receiver"

    ^ key
!

key:anObject
    "set the key of the receiver to be anObject.
     Return the receiver"

    key := anObject
! !

!LookupKey methodsFor:'comparing'!

< aKey
    "return true, if the receiver's Key is less than the argument's key. 
     The argument must be a kind of lookupKey"

    ^ key < aKey key
!

= aLookupKey
    "return true if the receiver's key equals the argument's key.
     The argument must be a kind of lookupKey."

    ^ (self species == aLookupKey species) and:[key = aLookupKey key]
!

> aKey
    "return true, if the receiver's Key is greater than the argument's key. 
     The argument must be a kind of lookupKey"

    ^ key > aKey key
!

hash
    "return an integer useful for hashing on the receiver;
     redefined since = is redefined here."

    ^ key hash
! !

!LookupKey methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream 
        nextPutAll:self className; 
        nextPut:$(.
    key displayOn:aGCOrStream.
    aGCOrStream nextPut:$)
!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    key printOn:aStream.
! !

!LookupKey class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


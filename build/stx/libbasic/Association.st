"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

LookupKey subclass:#Association
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!Association class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Associations are a key-value pair; conceptionally, they are the elements of 
    Dictionaries - storing value under the key. (However, the real implementation
    of Dictionary is different).
    Taken by itself, an association is not very useful.

    [Instance variables:]

        key             <Object>        the key (inherited)
        value           <Object>        the value

    [author:]
        Claus Gittinger

    [See also:]
        Dictionary IdentityDictionary
"
! !

!Association class methodsFor:'instance creation'!

key:aKey value:aValue
    "return a new Association"

    ^ self basicNew key:aKey value:aValue
! !

!Association methodsFor:'accessing'!

key:aKey value:aValue
    "set both the key and value of the receiver.
     Return the receiver"

    key := aKey.
    value := aValue
!

value
    "return the value of the association"

    ^ value
!

value:anObject
    "set the value of the receiver to be anObject.
     Return the receiver"

    value := anObject
! !

!Association methodsFor:'collection mimicri'!

keysAndValuesDo:aBlock
    "evaluate the argument, aBlock for each element in the collection.
     Pass both index and element to the block.
     Added here to allow for an association to be added via the comma operation
     to an existing dictionary"

    aBlock value:key value:value.

    "
     |d1 d2|

     d1 := Dictionary new.
     d1 at:#a put:'aaa'.
     d1 at:#b put:'bbb'.
     d2 := d1 , (#c -> 'ccc').
     d2
    "
! !

!Association methodsFor:'comparing'!

= anAssociation
    "return true if the receiver equals the argument.
     Notice, that this compares both key AND value.
     Time will show if this is ok."

    ^ self species == anAssociation species 
        and:[anAssociation key = key and:[anAssociation value = value]]
!

hash
    "return an integer useful for hashing on the receiver;
     redefined since = is redefined here."

    ^ (key hash) bitXor:(value hash)
! !

!Association methodsFor:'printing & storing'!

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

    key displayOn:aGCOrStream.
    aGCOrStream nextPutAll:'->'.
    value displayOn:aGCOrStream.
!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    key printOn:aStream.
    aStream nextPutAll:'->'.
    value printOn:aStream
!

storeOn:aStream
    "append a string representing an expression to reconstruct the receiver
     to aStream."

    aStream nextPut:$(. 
    key storeOn:aStream.
    aStream nextPutAll:'->'. 
    value storeOn:aStream.
    aStream nextPut:$).

    "Created: / 3.2.2000 / 22:31:28 / cg"
! !

!Association methodsFor:'queries'!

isAssociation
    "return true, if the receiver is some kind of association;
     true is returned here - the method is redefined from Object."

    ^ true

    "Created: 14.5.1996 / 17:04:13 / cg"
! !

!Association class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/Association.st,v 1.26 2014-07-11 09:55:51 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/Association.st,v 1.26 2014-07-11 09:55:51 stefan Exp $'
! !


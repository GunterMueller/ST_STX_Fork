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

Bag subclass:#SmallBag
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!SmallBag class methodsFor:'documentation'!

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
    SmallBag behaves like Bag, but is tuned for a small number of distinct objects (in the order of 10),
    by not using a dictionary, but a linear array holding count-value pairs in consecutive slots.
    Only use it when many small bags are required, as this will be slower if too many (distinct) elements are added.

    [Instance variables:]
        contents        <Array>    holds count/value info in consecutive slots


    [author:]
        Claus Gittinger

    [See also:]
        Bag Set IdentitySet
        Dictionary IdentityDictionary
        OrderedCollection Array
"
! !

!SmallBag methodsFor:'accessing'!

contents
    "return the dictionary which associates occurrence-counts
     to the bags elements."

    |d|

    d := Dictionary new.
    1 to:contents size-1 by:2 do:[:countIndex | 
       |count object|

        (count := contents at:countIndex) > 0 ifTrue:[
            object := (contents at:countIndex+1).
            d at:object put:count
        ].
    ].
    ^ d

    "
     SmallBag new contents     
     SmallBag new size     
    "
! !

!SmallBag methodsFor:'adding & removing'!

add:newObject
    "add the argument, anObject to the receiver.
     Returns the object.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    ^ self add:newObject withOccurrences:1
!

add:newObject withOccurrences:nMore
    "add the argument, anObject anInteger times to the receiver.
     Returns the object.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    |firstEmptySlot newContents|

    1 to:contents size-1 by:2 do:[:countIndex |
        |count|

        count := contents at:countIndex.
        (contents at:countIndex+1) = newObject ifTrue:[
            contents at:countIndex put:count + nMore.
            ^ newObject.
        ].
        count == 0 ifTrue:[ firstEmptySlot := firstEmptySlot ? countIndex ].
    ].
    "/ not already there

    firstEmptySlot isNil ifTrue:[
        newContents := Array new:contents size * 2 withAll:0.
        newContents replaceFrom:1 with:contents startingAt:1.
        firstEmptySlot := contents size + 1.
        contents := newContents.
    ].
    contents at:firstEmptySlot put:nMore.
    contents at:firstEmptySlot+1 put:newObject.
    ^ newObject
!

remove:oldObject ifAbsent:anExceptionBlock
    "Remove oldObject from the collection.
     If it was not present, return the value of the exceptionBlock;
     otherwise return the removed object.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    1 to:contents size by:2 do:[:countIndex |
        |count el|

        count := contents at:countIndex.
        (el := contents at:countIndex+1) = oldObject ifTrue:[
            contents at:countIndex put:count - 1.
            ^ el.
        ].
    ].

    "/ not found
    ^  anExceptionBlock value
!

removeAll
    self initContents
!

removeAllOccurrencesOf:oldObject ifAbsent:anExceptionBlock
    "Remove oldObject completely from the collection.
     If it was not present, return the value of the exceptionBlock;
     otherwise return the removed object.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    1 to:contents size by:2 do:[:countIndex |
        |count el|

        count := contents at:countIndex.
        (el := contents at:countIndex+1) = oldObject ifTrue:[
            contents at:countIndex put:0.
            ^ el.
        ].
    ].

    "/ not found
    ^  anExceptionBlock value
! !

!SmallBag methodsFor:'converting'!

asSet
    "return the receiver as a set"

    |set|

    set := Set new.
    self valuesAndCountsDo:[:el :n | set add:el ].
    ^ set

    "
     |b|

     b := Bag new.
     b add:1; add:2; add:3; add:1; add:1.
     b asSet.
    "
! !

!SmallBag methodsFor:'enumerating'!

do:aBlock
    "evaluate the block for all elements in the collection.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    1 to:contents size by:2 do:[:countIndex|
        |count el|

        (count := contents at:countIndex) ~~ 0 ifTrue:[
            el:= contents at:countIndex+1.
            count timesRepeat:[ aBlock value: el ]
        ]
    ]

    "Modified: 1.3.1996 / 21:42:39 / cg"
!

valuesAndCountsDo:aBlock
    "evaluate the block for all distinct elements in the collection,
     passing both the element and the occurrence count as arguments.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    1 to:contents size by:2 do:[:countIndex|
        |count el|

        (count := contents at:countIndex) ~~ 0 ifTrue:[
            el:= contents at:countIndex+1.
            aBlock value: el value:count
        ]
    ]

    "Modified: 1.3.1996 / 21:42:39 / cg"
! !

!SmallBag methodsFor:'private'!

initContents
    "set the contents to be an empty contents array"

    contents := Array new:10 withAll:0
!

initContents:size
    "set the contents to be an empty contents array with initial size"

    contents := Array new:size*2 withAll:0
! !

!SmallBag methodsFor:'queries'!

size
    "return the number of bag elements"

    |count|

    count := 0.
    1 to:contents size-1 by:2 do:[:countIndex | count := count + (contents at:countIndex)].
    ^ count
! !

!SmallBag methodsFor:'testing'!

occurrencesOf:anObject
    "return how often anObject is in the receiver"

    1 to:contents size-1 by:2 do:[:countIndex |
        |element|

        (contents at:countIndex+1) = anObject ifTrue:[
            ^ contents at:countIndex.
        ].
    ].

    ^ 0
! !

!SmallBag class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/SmallBag.st,v 1.1 2013-01-23 17:16:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/SmallBag.st,v 1.1 2013-01-23 17:16:58 cg Exp $'
! !


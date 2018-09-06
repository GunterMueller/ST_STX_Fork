"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

Collection subclass:#Bag
	instanceVariableNames:'contents'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!Bag class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    Bags are collections where the elements are unordered and have no external key. 
    Elements may occur more than once in a bag. 
    There is no defined order within a bag.
    The default implementation uses a dictionary to store each object's occurrence count, 
    using the object itself as key 
    (i.e. using = and hash for inclusion tests).

    There is also an instance creation variant (#identityNew:) which creats a
    bag which compares using #== and hashes using #identityHash.
    (I'd say that instantiating an IdentityBag explicitly is better,
     ... but for compatibility ... we do it here as well)

    [Instance variables:]

        contents        <Dictionary>    for each element, the number of occurrences


    [author:]
        Claus Gittinger

    [See also:]
        Set IdentitySet
        Dictionary IdentityDictionary
        OrderedCollection Array
"
! !

!Bag class methodsFor:'instance creation'!

contentsClass
    "the default class to use for the underlying contents array,
     used when instantiated with new/new:"

    ^ Dictionary
!

equalityNew
    "return a new empty Bag.
     Elements will be compared using equality compare (i.e. #= not #== identity)."

    ^ self basicNew initContentsForEquality
!

equalityNew:size
    "return a new empty Bag with initial space for size elements.
     Elements will be compared using equality compare (i.e. #= not #== identity)."

    ^ self basicNew initContentsForEquality:size
!

identityNew
    "return a new empty Identity-Bag.
     Elements will be compared using identity compare (i.e. #== not #= equality)."

    ^ self basicNew initContentsForIdentity
!

identityNew:size
    "return a new empty Bag with initial space for size elements.
     Elements will be compared using identity compare (i.e. #== not #= equality)."

    ^ self basicNew initContentsForIdentity:size
!

new
    "return a new empty Bag which compares for equality (i.e. not identity)"

    ^ self basicNew initContents
!

new:size
    "return a new empty Bag with initial space for size elements.
     Elements will be compared using equality compare (i.e. #= not #== identity)."

    ^ self equalityNew:size
! !

!Bag methodsFor:'Compatibility-Dolphin'!

asAssociations
    "return the dictionary which associates occurrence-counts
     to the bags elements. 
     Same as #contents for dolphin compatibility."

    ^ self contents
! !

!Bag methodsFor:'accessing'!

at:index
    "report an error: at: is not allowed for Bags"

    ^ self errorNotKeyed
!

at:index put:anObject
    "report an error: at:put: is not allowed for Bags"

    ^ self errorNotKeyed
!

contents
    "return the dictionary which associates occurrence-counts
     to the bags elements."

    ^ contents

    "
     Bag new
        add:'abc';
        add:'def';
        add:'ghi';
        add:'abc';
        add:'def';
        add:'abc';
        add:'abc';
        contents
    "
!

sortedCounts
    "Answer with a collection of counts associated to elements, sorted by decreasing count."
    "Suggested by l. Uzonyi"
    
    ^ (Array new:contents size
        streamContents:[:stream | 
            contents associationsDo:[:each | stream nextPut:each value -> each key ]
        ])
        sort:[:x :y | y < x];
        yourself

    "
     Bag new
        add:'abc';
        add:'def';
        add:'ghi';
        add:'abc';
        add:'def';
        add:'abc';
        add:'abc';
        sortedCounts
    "
!

valuesSortedByCounts
    "Answer with a collection of values, sorted by decreasing count. 
     Count informtion is lost in the result"
    
    ^ self sortedCounts collect:[:assoc | assoc value].

    "
     Bag new
        add:'abc';
        add:'def';
        add:'ghi';
        add:'abc';
        add:'def';
        add:'abc';
        add:'abc';
        valuesSortedByCounts   
    "
! !

!Bag methodsFor:'adding & removing'!

add:newObject
    "add the argument, anObject to the receiver.
     Returns the object (sigh).

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    |n|

    n := contents at:newObject ifAbsent:0.
    contents at:newObject put:(n + 1).
    ^ newObject

    "Modified: 1.3.1996 / 21:43:06 / cg"
!

add:newObject withOccurrences:anInteger
    "add the argument, anObject anInteger times to the receiver.
     Returns the object.

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |n|

    n := contents at:newObject ifAbsent:0.
    contents at:newObject put:(n + anInteger).
    ^ newObject

    "Modified: 1.3.1996 / 21:43:12 / cg"
    "Created: 11.5.1996 / 12:13:43 / cg"
!

remove:oldObject ifAbsent:anExceptionBlock
    "Remove one occurrence of oldObject from the collection.
     If it was not present, return the value of the exceptionBlock;
     otherwise return the removed object.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    |count|

    count := contents at:oldObject ifAbsent:0.
    (count == 0) ifTrue:[^ anExceptionBlock value].
    (count == 1) ifTrue:[
        contents removeKey:oldObject
    ] ifFalse:[
        contents at:oldObject put:(count - 1)
    ].
    ^ oldObject

    "Modified: 1.3.1996 / 21:43:18 / cg"
!

removeAll
    "remove all objects from the receiver collection (i.e. make it empty).
     Returns the receiver."

    contents := contents species new.

    "
     |b|

     b := Bag new.
     b add:1; add:2; add:3; add:2; add:1.
     Transcript showCR:b.

     b removeAll.

     Transcript showCR:b
    "

    "Modified: 12.4.1996 / 13:34:34 / cg"
!

removeAllOccurrencesOf:oldObject ifAbsent:anExceptionBlock
    "Remove all occurrences of oldObject from the collection.
     If it was not present, return the value of the exceptionBlock;
     otherwise return the number of removes.

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    |count|

    count := contents at:oldObject ifAbsent:0.
    (count == 0) ifTrue:[^ anExceptionBlock value].
    contents removeKey:oldObject.
    ^ oldObject

    "Modified: 1.3.1996 / 21:43:26 / cg"
! !

!Bag methodsFor:'bulk operations'!

sum
    "sum up all elements; return 0 for an empty collection.
     can be done easier, using bags knowledge."

    |accu|

    self isEmpty ifTrue:[ ^ 0 ].

    accu := nil.
    self 
        valuesAndCountsDo:[:n :count |
            |thisAmount|

            thisAmount := count * n.
            accu := (accu isNil ifTrue:[thisAmount] ifFalse:[accu + thisAmount]) ].
    ^ accu

    "
     TestCase assert:((Bag new add:1; add:2; add:3; add:1; add:2; add:1; yourself) sum = 10).
    "
! !

!Bag methodsFor:'comparing'!

= aBag
    "Compare the receiver with the argument and return true if the
     receiver is equal to the argument (i.e. has the same size and elements).
     Otherwise return false."

    aBag species == self species ifFalse:[^ false].
    self size == aBag size ifFalse:[^ false].
    self valuesAndCountsDo:[:val :cnt |
        (aBag occurrencesOf:val) == cnt ifFalse:[^ false]
    ].
    ^ true
!

hash
    "return an integer useful for hashing on the receiver;
     redefined since = is redefined here."

    |h|

    h := self size.
    self valuesAndCountsDo:[:val :cnt |
        h := h + cnt hash.
    ].
    ^ h
! !

!Bag methodsFor:'converting'!

asBag
    "return the receiver as a bag"

    "could be an instance of a subclass..."
    self class == Bag ifTrue:[
	^ self
    ].
    ^ super asBag
!

asSet
    "return the receiver as a set"

    ^ contents keys copy

    "
     |b|

     b := Bag new.
     b add:1; add:2; add:3; add:1; add:1.
     b asSet.
    "
! !

!Bag methodsFor:'copying'!

postCopy
    "must copy the contents as well"

    contents := contents copy
! !

!Bag methodsFor:'enumerating'!

do:aBlock
    "evaluate the block for all elements in the collection.

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    contents keysAndValuesDo:[:key :value|
	value timesRepeat:[
	    aBlock value:key
	]
    ]

    "Modified: 1.3.1996 / 21:42:39 / cg"
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the block for all distinct elements in the collection,
     passing both the element and the occurrence count as arguments.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    ^ contents keysAndValuesDo:aTwoArgBlock
!

valuesAndCounts
    "return an orderedCollection containing value->count associations"

    |coll|

    coll := OrderedCollection new.
    self valuesAndCountsDo:[:value :count | coll add:(value->count)].
    ^ coll

    "Modified: 1.3.1996 / 21:42:44 / cg"
!

valuesAndCountsDo:aTwoArgBlock
    "evaluate the block for all distinct elements in the collection,
     passing both the element and the occurrence count as arguments.

     WARNING: do not add/remove elements while iterating over the receiver.
	      Iterate over a copy to do this."

    ^ contents keysAndValuesDo:aTwoArgBlock

    "Modified: 1.3.1996 / 21:42:44 / cg"
!

valuesAndCountsSelect:aTwoArgBlock
    "evaluate the block for all distinct elements in the collection,
     passing both the element and the occurrence count as arguments.
     If that returns true, add the element to the OrderedCollection.
     Answer the OrderedCollection.

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    |collected|

    collected := OrderedCollection new.
    self valuesAndCountsDo:[:eachValue :eachCount|
        (aTwoArgBlock value:eachValue value:eachCount) ifTrue:[
            collected add:eachValue
        ].
    ].
    ^ collected

    "
     #(10 20 20 30 40) asBag
        valuesAndCountsSelect:[:eachValue :eachCount | eachCount > 1] 
    "


    "Modified: 1.3.1996 / 21:42:44 / cg"
! !


!Bag methodsFor:'printing & storing'!

printElementsDo:aBlock
    self valuesAndCountsDo:[:value :count|
        aBlock value:('%1(*%2)' bindWith:value with:count).
    ]
! !

!Bag methodsFor:'private'!

grow:newSize
    "/ ignored here
!

initContents
    "set the contents to be an empty Dictionary.
     This is the default method for initialization, which can be redefined in subclasses."

    contents := self class contentsClass new
!

initContents:size
    "set the contents to be an empty Dictionary with initial size.
     This is the default method for initialization, which can be redefined in subclasses."

    contents := self class contentsClass new: size
!

initContentsForEquality
    "set the contents to be an empty Dictionary"

    contents := Dictionary new
!

initContentsForEquality:size
    "set the contents to be an empty Dictionary with initial size"

    contents := Dictionary new:size
!

initContentsForIdentity
    "set the contents to be an empty IdentityDictionary"

    contents := IdentityDictionary new
!

initContentsForIdentity:size
    "set the contents to be an empty IdentityDictionary with initial size"

    contents := IdentityDictionary new:size
! !

!Bag methodsFor:'queries'!

size
    "return the number of bag elements"

    |count|

    count := 0.
    contents do:[:element | count := count + element].
    ^ count
! !

!Bag methodsFor:'statistical functions'!

variance
    "compute the variance over a complete data set (and not of a sample)"

    |m sz sumDeltaSquares|

    m := self arithmeticMean.
    sumDeltaSquares := 0.
    sz := 0.
    self 
        valuesAndCountsDo:[:val :count |
            sumDeltaSquares :=  sumDeltaSquares + ((val - m) squared).
            sz := sz + 1.
        ].

    ^ sumDeltaSquares / sz

    "
     TestCase assert:( #(1 1 1 2 2 2 1 1 1 2 2 2) asBag variance = #(1 1 1 2 2 2 1 1 1 2 2 2) variance).
     TestCase assert:( #(1 1 1 1 1 0 0 0 0 0) asBag variance = #(1 1 1 1 1 0 0 0 0 0) variance).
    "
! !

!Bag methodsFor:'testing'!

includes:anObject
    "return true, if anObject is in the receiver"

    ^ (self occurrencesOf:anObject) > 0
!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

isOrdered
    "return true, if the receiver's elements are ordered.
     Redefined to return false here, because the order of keys and values
     may change due to rehashing, when elements are added/removed"

    ^ false
!

occurrencesOf:anObject
    "return how many times anObject is in the receiver"

    ^ contents at:anObject ifAbsent:0
! !

!Bag class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

OrderedCollection subclass:#SortedCollection
	instanceVariableNames:'sortBlock'
	classVariableNames:'DefaultSortBlock'
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!SortedCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    I keep my elements sorted. The sort order is defined by a sortblock,
    a two-argument block which, when given two elements of the collection,
    should return true if the element given as first arg has to come before the
    element given as second arg.

    Equal elements may occur multiple times.

    SortedCollection uses quickSort to resort and a binary search when adding/removing elements.
    Because insertion/removal may require that remaining elements have to
    be shifted within the container, adding many individual elements will be faster above a
    particular number of added elements by creating a completely new collection from the 
    unsorted elements.
    (see examples)

    A sortblock, given arguments a,b should return true, if a is to be shown before b.
    A sortBlock of [:a :b | a < b] defines ascending sort-order,
    while [:a :b | a > b] defines descening order.
    The default sortBlock for SortedCollections is the first one (i.e. sorting in ascending order).

    Compatibility Warning:
        VW seems to use a default sortBlock which compares a<=b, wheras ST/X uses a<b.
        That means, that elements which are compared MUST understand #< in ST/X
        while the minumum protocol is #<= in VW.
        This may be changed in a future release of ST/X
        (it is not yet, to not confuse existing applications ...
         ... be aware, that the sortBlock has an effect on a few algorithms
         found here; especially #indexForInserting is critical.)

    [caveat:]
        a balanced tree may be a better choice, as inserting may be slow when
        elements have to be shifted. See the performance measuremens in AATree.

    [author:]
        Claus Gittinger
"
!

examples
"
    when many elements are to be added, it may be better to add them
    all en-bloeque instead of individually.
    The reason is that for each individual #add:, the contents has to be
    shifted, to create an empty slot for the new element.

    timing example:

        |o rnd|

        o := SortedCollection new.
        rnd := Random new.
        10000 timesRepeat:[
            o add:rnd next.
        ]

    takes 1365 ms on a P5 (admitted: this is a fast machine ;-)
    Times are a'changing: 
        Just came around 2005: on my 1.5Ghz laptop, this now takes 260ms...
        an another comment 2008: on a 1.8Ghz laptop, it takes now 105ms...

    In contrast:

        |o rnd|

        o := OrderedCollection new.
        rnd := Random new.
        10000 timesRepeat:[
            o add:rnd next.
        ].
        o := o asSortedCollection

    takes 383 ms on the same machine.
        2005: on my 1.5Ghz laptop, this now takes 100ms
        2008: on a 1.8Ghz laptop, this now takes 47ms

    If you already have a big sortedCollection at hand, adding multiple
    items may be better done with #addAll:, which resorts all elements, if
    the number of added items is more than some threshold number.
    However, the break-even point where bulk-adding is faster depends
    on the machine ... (and ST/X version ;-).


  adding elements in order:

    |c|
    Time millisecondsToRun:[
        10 timesRepeat:[
            |c|
            c := SortedCollection new.
            (1 to:100000) do:[:e | c add:e].
        ]
    ].    

    (5.4.1: 2031 2187)
    (5.4.3: 484 516)

    |c|
    c := SortedCollection new.
    (1 to:100000) do:[:e | c add:e].
    self assert:(c asBag = (1 to:100000) asBag).

  adding elements in reverse order:

    Time millisecondsToRun:[
        10 timesRepeat:[
            |c|
            c := SortedCollection new.
            (1 to:100000) reverseDo:[:e | c add:e].
        ]
    ].        

    (5.4.1: 201969)
    (5.4.3: 1609 1766)

    |c|
    c := SortedCollection new.
    (1 to:100000) reverseDo:[:e | c add:e].
    self assert:(c asBag = (1 to:100000) asBag).

  adding elements in random order:

    |toAdd|

    toAdd := (1 to:100000) asOrderedCollection randomShuffle.

    Time millisecondsToRun:[
        10 timesRepeat:[
            |c|
            c := SortedCollection new.
            toAdd do:[:e | c add:e].
        ]
    ].

    (5.4.1: 108484)
    (5.4.3: 75734)

    |c|
    c := SortedCollection new.
    (1 to:100000) asOrderedCollection randomShuffle do:[:e | c add:e].
    self assert:(c asBag = (1 to:100000) asBag).
"
! !

!SortedCollection class methodsFor:'initialization'!

initialize
    "setup the default sortBlock.
     Use #<, since this is the base method in Magnitude."

    "/ only do this once at early startup
    DefaultSortBlock isNil ifTrue:[
        DefaultSortBlock := [:a :b | a < b]
    ]

    "
     SortedCollection initialize
    "

    "Modified: 12.4.1996 / 12:29:27 / cg"
! !

!SortedCollection class methodsFor:'instance creation'!

forStrings
    "this is supposed to return a sortedCollection, which sorts using
     the current locales collating sequence. For now, simply use a
     normal string compare.
     This will change"

    ^ self new

    "Modified: 13.9.1997 / 10:18:58 / cg"
    "Created: 13.9.1997 / 10:41:54 / cg"
!

forStrings:size
    "this is supposed to return a sortedCollection, which sorts using
     the current locales collating sequence. For now, simply use a
     normal string compare.
     This will change"

    ^ self new:size

    "Modified: 13.9.1997 / 10:18:58 / cg"
!

new
    "return a new sortedCollection, the sorting is done using
     a compare for a < b, in ascending order"

    ^ super new setSortBlock:DefaultSortBlock

    "Modified: 12.4.1996 / 12:28:18 / cg"
!

new:size
    "return a new sortedCollection with preallocated size.
     The sorting is done using a compare for a < b, in ascending order"

    ^ (super new:size) setSortBlock:DefaultSortBlock

    "Modified: 12.4.1996 / 12:28:22 / cg"
!

sortBlock:aBlock
    "return a new sortedCollection, whe the sort order is defined
     by aBlock.
     This must be a two-argument block which returns true if its arg1 has to come before
     its arg2 in the collection."

    ^ super new setSortBlock:aBlock

    "default:
     |s|

     s := SortedCollection new.
     s add:15; add:99; add:3; add:-29; add:17; add:-6.
     Transcript showCR:s
    "

    "sorting by absolute values:
     |s|

     s := SortedCollection sortBlock:[:a :b | a abs < b abs].
     s add:15; add:99; add:3; add:29; add:17; add:-6.
     Transcript showCR:s
    "

    "default again:
     |s|

     s := SortedCollection new.
     s add:'foo'; add:'Bar'; add:'baz'; add:'hello'; add:'world'; add:'Wow'.
     Transcript showCR:s
    "

    "sorting strings caseless:
     |s|

     s := SortedCollection sortBlock:[:a :b | a asLowercase < b asLowercase].
     s add:'foo'; add:'Bar'; add:'baz'; add:'hello'; add:'world'; add:'Wow'.
     Transcript showCR:s
    "

    "Modified: 12.4.1996 / 12:26:28 / cg"
!

withAll:aCollection sortBlock:aBlock
    "initialize from aCollection and set the sort-block"

    ^ (self sortBlock:aBlock) addAll:aCollection; yourself

    "
     SortedCollection withAll:#(1 2 3 4 5 6 7 8 9 0)
		      sortBlock:[:a :b | a > b]
    "

    "default:
     |s|

     s := SortedCollection withAll:#(15 99 3 29 17 -6).
     Transcript showCR:s
    "

    "sorting by absolute values:
     |s|

     s := SortedCollection withAll:#(15 99 3 29 17 -6) sortBlock:[:a :b | a abs < b abs].
     Transcript showCR:s
    "

    "default again:
     |s|

     s := SortedCollection withAll:#('foo' 'Bar' 'baz' 'hello' 'world' 'Wow').
     Transcript showCR:s
    "

    "sorting strings caseless:
     |s|

     s := SortedCollection withAll:#('foo' 'Bar' 'baz' 'hello' 'world' 'Wow') sortBlock:[:a :b | a asLowercase < b asLowercase].
     Transcript showCR:s
    "

    "Modified: 12.4.1996 / 12:28:09 / cg"
! !

!SortedCollection class methodsFor:'Compatibility-Dolphin'!

sortBlock:aBlock withAll:aCollection
    ^ self withAll:aCollection sortBlock:aBlock
! !

!SortedCollection methodsFor:'adding & removing'!

add:anObject
    "add the argument, anObject at the proper place in the receiver. 
     Returns the argument, anObject (sigh)."

    |index lastElement|

    "/
    "/ cg: the original code was simply:
    "/
    "/  index := self indexForInserting:anObject.
    "/  index := self makeRoomAtIndex:index.
    "/  contentsArray basicAt:index put:anObject.
    "/
    "/  which was nice and simple to understand.
    "/ However, the code below is 5 times faster, if elements are added in an already ordered fashion,
    "/ which often happens.
    "/ so we allow the code to be a bit more complicated...

    (lastIndex < firstIndex "i.e. self size == 0"
    or:[ 
        lastElement := contentsArray basicAt:lastIndex.
        (sortBlock value:lastElement value:anObject)    
    ]) ifTrue:[
        "/ empty or lastElement is smaller then newElement; add at the end
        index := lastIndex.
        (index == contentsArray size) ifTrue:[
            self makeRoomAtLast.
            index := lastIndex.
        ].
        lastIndex := index := index + 1.
    ] ifFalse:[
        index := self indexForInserting:anObject.
        (index == firstIndex) ifTrue:[
            (firstIndex == 1) ifTrue:[
                self makeRoomAtFront.
            ].
            index := firstIndex := firstIndex - 1.
        ] ifFalse:[
            index := self makeRoomAtIndex:index.
        ].
    ].
    contentsArray basicAt:index put:anObject.
    ^ anObject

    "
     #(7 3 9 10 99) asSortedCollection add:5; yourself
     #(7 3 9 10 99) asSortedCollection add:1; yourself
     #(7 3 9 10 99) asSortedCollection add:1000; yourself
     #(7 3 9 10 99) asSortedCollection add:1; yourself   
    "

    "Modified: / 22-10-2008 / 17:09:39 / cg"
!

addAll:aCollection
    "add all elements of the argument, aCollection to the receiver.
     Returns the argument, aCollection (sigh)."

    |addedCollection|

    (aCollection isSortedCollection
     and:[aCollection sortBlock == sortBlock]) ifTrue:[
        addedCollection := aCollection.
    ] ifFalse:[
        addedCollection := Array withAll:aCollection.
        addedCollection stableSort:sortBlock.

        self size == 0 ifTrue:[
            "/ special case: I am empty - add them en-bloque.
            contentsArray := addedCollection.
            firstIndex := 1.
            lastIndex := aCollection size.
            ^ aCollection
        ].
    ].

    "/
    "/ do a mergeSort with the sortedContents
    "/
    self mergeSorted:addedCollection.
    ^ aCollection

    "
     #(7 3 9 10 99) asSortedCollection addAll:#(77 0 1 16 5); yourself

     ( #(7 3 9 10 99) asSortedCollection:[:a :b | a > b])
         addAll:#(77 0 1 16 5); yourself

     #(7 3 9 10 99) asSortedCollection
        addAll:( #(77 0 1 16 5) asSortedCollection:[:a :b | a > b]); yourself

     (#(7 3 9 10 99) asSortedCollection:[:a :b | a > b])
        addAll:( #(77 0 1 16 5) asSortedCollection:[:a :b | a < b]); yourself
    "

    "
     |x e|

     e := (1 to:100) asSortedCollection.
     TimeDuration toRun:[
         10000 timesRepeat:[
            x := SortedCollection new:100.
            x addAll:e. 
         ].
     ].      
    "

    "Modified: 13.4.1996 / 12:42:15 / cg"
!

mergeSorted:aSortedCollection
    "add all elements of the argument, aSortedCollection to the receiver.
     This leads to an error, if the argument is not sorted.

     This should be used when a number of elements is to be added.
     Notice, that quicksort degenerates to a veeery slow bubble-like
     sort when a collection of already sorted elements is given to it.
     Therefore, adding chunks is better done by sorting the chunk and merging
     it in, instead of resorting the receiver.

     aSortedCollection must be sorted by the same sortBlock as myself!!"

    |newContentsArray
     contentsArray2
     destIndex "{ Class: SmallInteger }"
     n1        "{ Class: SmallInteger }"
     n2        "{ Class: SmallInteger }"
     srcIndex1 "{ Class: SmallInteger }"
     srcIndex2 "{ Class: SmallInteger }"
     last1     "{ Class: SmallInteger }"
     last2     "{ Class: SmallInteger }"
     end1Reached end2Reached
     el1 el2 |

    n2 := aSortedCollection size.
    n2 == 0 ifTrue:[
        ^ self.
    ].

    aSortedCollection isSortedCollection ifTrue:[
        contentsArray2 := aSortedCollection contentsArray.
        srcIndex2 := aSortedCollection firstIndex.
    ] ifFalse:[
        contentsArray2 := aSortedCollection.
        srcIndex2 := 1.
    ].

    n1 := self size.
    n1 == 0 ifTrue:[
        firstIndex := srcIndex2.
        lastIndex := firstIndex + n2 - 1.
        contentsArray := contentsArray2 copy.
        ^ self.
    ].

    newContentsArray := Array new:(n1 + n2).
    destIndex := 1.

    last2 := srcIndex2 + n2 -1.

    srcIndex1 := firstIndex.
    last1 := srcIndex1 + n1 -1.

    (srcIndex1 <= last1 and:[srcIndex2 <= last2]) ifTrue:[
        el1 := contentsArray basicAt:srcIndex1.
        el2 := contentsArray2 basicAt:srcIndex2.
        end1Reached := end2Reached := false.

        [end1Reached or:[end2Reached]] whileFalse:[
            (sortBlock value:el1 value:el2) ifTrue:[
                "/ el1 to come before el2
                newContentsArray basicAt:destIndex put:el1. destIndex := destIndex + 1.
                srcIndex1 := srcIndex1 + 1.
                srcIndex1 <= last1 ifTrue:[
                    el1 := contentsArray basicAt:srcIndex1.
                ] ifFalse:[
                    end1Reached := true
                ]
            ] ifFalse:[
                "/ el2 to come before el1
                newContentsArray basicAt:destIndex put:el2. destIndex := destIndex + 1.
                srcIndex2 := srcIndex2 + 1.
                srcIndex2 <= last2 ifTrue:[
                    el2 := contentsArray2 basicAt:srcIndex2.
                ] ifFalse:[
                    end2Reached := true
                ]
            ]
        ]
    ].

    "/ fill up with remaining elements from source1
    (srcIndex1 <= last1) ifTrue:[
        newContentsArray
            replaceFrom:destIndex
            to:(destIndex+(last1-srcIndex1))
            with:contentsArray
            startingAt:srcIndex1
    ].

    "/ fill up with remaining elements from source2
    (srcIndex2 <= last2) ifTrue:[
        newContentsArray
            replaceFrom:destIndex
            to:(destIndex+(last2-srcIndex2))
            with:contentsArray2
            startingAt:srcIndex2
    ].

    firstIndex := 1.
    lastIndex := n1 + n2.
    contentsArray := newContentsArray

    "
     #(7 3 9 10 99) asSortedCollection
        mergeSorted:#(77 0 1 16 5) asSortedCollection

     #(7 3 9 10 99) asSortedCollection
        mergeSorted:#(77 0 3 1 98 99 16 5) asSortedCollection

     #() asSortedCollection
        mergeSorted:#(77 0 3 1 98 99 16 5) asSortedCollection

     #(7 3 9 10 99) asSortedCollection
        mergeSorted:#() asSortedCollection
    "

    "Modified: / 30.1.1998 / 01:49:42 / cg"
! !

!SortedCollection methodsFor:'blocked'!

add:newObject after:oldObject
    "catch this - its not allowed for sortedCollections"

    self shouldNotImplement
!

add:newObject before:oldObject
    "catch this - its not allowed for sortedCollections"

    self shouldNotImplement
!

addFirst:anObject
    "catch this - its not allowed for sortedCollections"

    self shouldNotImplement
!

addLast:anObject
    "catch this - its not allowed for sortedCollections"

    self shouldNotImplement
! !

!SortedCollection methodsFor:'converting'!

asSortedCollection
    "return the receiver as a sorted collection"

    "could be an instance of a subclass..."
    self class == SortedCollection ifTrue:[
	sortBlock == DefaultSortBlock ifTrue:[
	    ^ self
	]
    ].
    ^ super asSortedCollection
!

asSortedCollection:aSortBlock
    "return the receiver as a sorted collection, using aSortBlock.
     Return the receiver, if its a sortedCollection and the sortBlock
     is the same as the argument-sortBlock"

    "could be an instance of a subclass..."
    self class == SortedCollection ifTrue:[
	"/ if the sortBlock is the same, return the receiver
	aSortBlock == sortBlock ifTrue:[
	    ^ self
	].
    ].
    ^ super asSortedCollection:aSortBlock
! !

!SortedCollection methodsFor:'copying'!

copyEmpty:size
    "return a copy of the receiver with no elements, but
     the same size. This method has been be redefined to
     preserve the sortBlock."

    ^ (super copyEmpty:size) sortBlock:sortBlock
!

postCopyFrom:anOriginal
    "sent after a copy or when a new collection species has been created.
     The new collection should have the same sortBlock as the original."

    sortBlock := anOriginal sortBlock

    "
     #(4 7 1 99 -1 17) asSortedCollection inspect
     #(4 7 1 99 -1 17) asSortedCollection copy inspect
     (#(4 7 1 99 -1 17) asSortedCollection sortBlock:[:a :b | a > b]) inspect
     (#(4 7 1 99 -1 17) asSortedCollection sortBlock:[:a :b | a > b]) copy inspect
     (#(4 7 1 99 -1 17) asSortedCollection select:[:e| e even]) inspect
    "
! !

!SortedCollection methodsFor:'enumerating'!

collect:aBlock
    "evaluate the argument, aBlock for every element in the collection
     and return a collection of the results. Redefined to return an OrderedCollection;
     see X3J20 spec. (SortedCollection>>collect: should return an OrderedCollection)"

    |newCollection
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }" |

    newCollection := self speciesForCollecting new:(self size).
    stop := lastIndex.
    start := firstIndex.
    start to:stop do:[:index |
        newCollection add:(aBlock value:(contentsArray basicAt:index)).
    ].
    ^ newCollection
! !

!SortedCollection methodsFor:'instance protocol'!

sort:aSortBlock
    "redefined from superclass to change the sortBlock"

    sortBlock ~~ aSortBlock ifTrue:[
	self sortBlock:aSortBlock.
    ].

!

sortBlock
    "return the block used for sorting"

    ^ sortBlock
!

sortBlock:aSortBlock
    "change the sort criteria for a sorted collection, resort the elements of
    the collection, and return the receiver. The argument, aSortBlock must
    be a two-argument block which returns true if its arg1 has to come before
    its arg2 in the collection."

    sortBlock := aSortBlock.
    lastIndex > firstIndex ifTrue:[
	contentsArray quickSortFrom:firstIndex to:lastIndex sortBlock:aSortBlock
    ]

    "
     #(9 8 7 6 5 4 3) asSortedCollection
     #(9 8 7 6 5 4 3) asSortedCollection sortBlock:[:a : b | a < b]
     #(9 8 7 6 5 4 3) asSortedCollection sortBlock:[:a : b | a > b]
     #($f $G $z $Y $o $H) asSortedCollection
     #($f $G $z $Y $o $H) asSortedCollection sortBlock:[:a : b | a asUppercase < b asUppercase]
    "
! !

!SortedCollection methodsFor:'private'!

indexForInserting:anObject
    "search the index at which to insert anObject.
     Can also be used to search for an existing element
     by checking if the element at the returned index is the one we look for.
     Uses a binarySearch since we can depend on the elements being in sorted order.
     The returned index is a physical one, for accessing contentsArray."

    |low    "{ Class: SmallInteger}"
     high   "{ Class: SmallInteger}"
     middle "{ Class: SmallInteger}"
     element|

    "
     we can of course use a binary search - since the elements are sorted
    "
    low := firstIndex.
    high := lastIndex.
    [low > high] whileFalse:[
        middle := (low + high) // 2.
        element := contentsArray basicAt:middle.
        (sortBlock value:element value:anObject) ifTrue:[
            "middleelement is smaller than object"
            low := middle + 1
        ] ifFalse:[
            high := middle - 1
        ]
    ].
    ^ low

    "
     #(1 2 3 4 7 99 1313 981989 898989898) asSortedCollection indexForInserting:50

     #(1.0 2.0 3 4 7 49.0 51.0 99 1313 981989 898989898) asSortedCollection indexForInserting:50

    "

    "Modified: 12.4.1996 / 13:22:03 / cg"
!

setSortBlock: aSortBlock
    "set the sortblock without resorting - private only"

    sortBlock := aSortBlock
! !

!SortedCollection methodsFor:'queries'!

isSorted
    "return true. if my elements are sorted"

    ^ true
!

isSortedBy:aBlock
    "return true, if my elements are sorted (already) by the given criterion (sortBlock)."

    aBlock == sortBlock ifTrue:[^ true].
    ^ super isSortedBy:aBlock


!

isSortedCollection
    "return true. if I am a sorted collection"

    ^ true
!

speciesForCollecting
    "Redefined to return an OrderedCollection;
     see X3J20 spec. (SortedCollection>>collect: should return an OrderedCollection)"

    ^ OrderedCollection
! !

!SortedCollection methodsFor:'searching'!

after:anObject ifAbsent:exceptionBlock
    "return the element after the argument, anObject; or nil if there is none.
     If anObject is contained multiple times in the collection, return the
     the first element which is non-equal to anObject.
     If the receiver does not contain anObject, return the result from evaluating
     exceptionBlock."

    |index      "{ Class: SmallInteger }"
     last       "{ Class: SmallInteger }"|

    index := self indexOf:anObject.
    index == 0 ifTrue:[
        ^ exceptionBlock value.
    ].

    "skip multiple occurrences of the same ..."
    index := index + firstIndex - 1.
    last := lastIndex.
    [(index <= last) and:[(contentsArray basicAt:index) = anObject]] whileTrue:[
        index := index + 1
    ].
    (index > last) ifTrue:[^ exceptionBlock value].
    ^ contentsArray basicAt:index

    "
     #(7 3 9 10 99) asSortedCollection after:50
     #(7 3 9 10 99) asSortedCollection after:3
     #(7 3 9 10 99) asSortedCollection after:1
     #(7 3 9 10 99) asSortedCollection after:10
     #(7 3 9 10 99) asSortedCollection after:7
     #(7 3 9 10 99) asSortedCollection after:99
     #(7 10 3 10 9 10 10 99) asSortedCollection after:9
     #(7 10 3 10 9 10 10 99) asSortedCollection after:10
    "
!

before:anObject ifAbsent:exceptionBlock
    "return the element before the argument, anObject; or nil if there is none.
     If the receiver does not contain anObject, return the result from evaluating
     exceptionBlock."

    |index      "{ Class: SmallInteger }"|

    index := self indexOf:anObject.
    index <= 1 ifTrue:[
        ^ exceptionBlock value.
    ].
    ^ contentsArray basicAt:firstIndex + index - 2

    "
     #(7 3 9 10 99) asSortedCollection before:50
     #(7 3 9 10 99) asSortedCollection before:3
     #(7 3 9 10 99) asSortedCollection before:1
     #(7 3 9 10 99) asSortedCollection before:10
     #(7 3 9 10 99) asSortedCollection before:7
     #(7 3 9 10 99) asSortedCollection before:99
     #(7 10 3 10 9 10 10 99) asSortedCollection before:9
     #(7 10 3 10 9 10 10 99) asSortedCollection before:10
    "
!

indexOf:anObject
    "return true, if the argument, anObject is in the collection.
     Redefined, since due to being sorted, the inclusion check can
     be done with log-n compares i.e. much faster."

    |index "{ Class: SmallInteger }"
     initialIndex "{ Class: SmallInteger }"
     element|

    "/ if I am small, the inherited linear search is faster ...
    (lastIndex - firstIndex) < 20 ifTrue:[
        firstIndex > lastIndex ifTrue:[
            "/ empty
            ^ 0
        ].
        ^ super indexOf:anObject.
    ].

    initialIndex := self indexForInserting:anObject.
    initialIndex > lastIndex ifTrue:[
        initialIndex := lastIndex
    ] ifFalse:[
        initialIndex < firstIndex ifTrue:[
            initialIndex := firstIndex
        ]
    ].

    "the complex case: the collection may include elements, which are ordered only by
     a single component (e.g. Associations by key). So we have to test all
     previous and next elements having the same component"

    "for previous elements: while element is not smaller and not larger than anObject ... compare"
    index := initialIndex.
    [index >= firstIndex 
     and:[
        element := contentsArray basicAt:index. 
        ((sortBlock value:element value:anObject) or:[sortBlock value:anObject value:element]) not]
    ] whileTrue:[
        element = anObject ifTrue:[
            ^ index - firstIndex + 1.
        ].
        index := index - 1.
    ].

    "for next elements: while element is not smaller and not larger than anObject ... compare"
    index := initialIndex.
    [index <= lastIndex 
     and:[
        element := contentsArray basicAt:index. 
        ((sortBlock value:element value:anObject) or:[sortBlock value:anObject value:element]) not]
    ] whileTrue:[
        element = anObject ifTrue:[
            ^ index - firstIndex + 1.
        ].
        index := index + 1.
    ].

    ^ 0.

    "
     #(7 3 9 10 99) asSortedCollection indexOf:50
     #(7 3 9 10 99) asSortedCollection indexOf:10

     #('aa' 'bb' 'cc' 'dd') asSortedCollection indexOf:'bb'
     #('aa' 'bb' 'cc' 'dd' 'aa' 'bb' 'cc' 'dd') asSortedCollection indexOf:'bb'

     |allSyms indices|
     allSyms := Symbol allInstances asSortedCollection.
     Time millisecondsToRun:[
         indices := allSyms collect:[:el | allSyms indexOf:el].
     ].
     indices = (1 to:allSyms size)
    "
!

indexOf:anElement ifAbsent:exceptionBlock
    "Return the index of anElement within the receiver.
     If the receiver does not contain anElement,
     return the result of evaluating the argument, exceptionBlock."

    |idx|

    idx := self indexOf:anElement.
    idx == 0 ifTrue:[^ exceptionBlock value].
    ^ idx.
!

largest:n
    "return a collection containing the n largest elements, largest last.
     Raises an exception, if the receiver does not contain at least n elements"

    |mySize|

    mySize := self size.
    n > mySize ifTrue:[
        self notEnoughElementsError
    ].
    sortBlock == DefaultSortBlock ifTrue:[
        ^ self copyFrom:(mySize-n+1)
    ].
    "/ do not trust the sortblock to sort small-to-large
    ^ super largest:n

    "
     #(10 35 20 45 30 5) asSortedCollection largest:3  
     (#(10 35 20 45 30 5) asSortedCollection:[:a :b | a > b]) largest:3    

     #(10 35 20 45 30 5) asSortedCollection largest:6  
     #(10 35 20 45 30 5) asSortedCollection largest:7  
    "
!

max
    "return the maximum value in the receiver collection,
     redefined, since this can be easily computed.
     Raises an error, if the receiver is empty."

    sortBlock == DefaultSortBlock ifTrue:[
        ^ self last
    ].
    ^ super max

    "
     #(10 35 20 45 30 5) asSortedCollection max 
     #(10 35 20 45 30 5) max 
     #() asSortedCollection max 
    "
!

min
    "return the minimum value in the receiver collection,
     redefined, since this can be easily computed.
     Raises an error, if the receiver is empty."

    sortBlock == DefaultSortBlock ifTrue:[
        ^ self first
    ].
    ^ super min

    "
     #(10 35 20 45 30 5) asSortedCollection min
     #(10 35 20 45 30 5) min
    "
!

minMax
    "return the minimum and maximum values in the receiver collection
     as a two element array, using #< to compare elements.
     Raises an error, if the receiver is empty."

    "return the minimum value in the receiver collection,
     redefined, since this can be easily computed.
     Raises an error, if the receiver is empty."

    sortBlock == DefaultSortBlock ifTrue:[
        ^ { self first . self last }
    ].
    ^ super minMax

    "
     #(10 35 20 45 30 5) asSortedCollection minMax
     #(10 35 20 45 30 5) minMax
    "
!

smallest:n
    "return a collection containing the n smallest elements, largest last.
     Raises an exception, if the receiver does not contain at least n elements"

    |mySize|

    mySize := self size.
    n > mySize ifTrue:[
        self notEnoughElementsError
    ].
    sortBlock == DefaultSortBlock ifTrue:[
        ^ self copyTo:n
    ].
    "/ do not trust the sortblock to sort small-to-large
    ^ super smallest:n

    "
     #(10 35 20 45 30 5) asSortedCollection smallest:3  
     (#(10 35 20 45 30 5) asSortedCollection:[:a :b | a > b]) smallest:3    

     #(10 35 20 45 30 5) asSortedCollection smallest:6  
     #(10 35 20 45 30 5) asSortedCollection smallest:7  
    "
! !

!SortedCollection methodsFor:'statistical functions'!

median
    "Return the middle element, or as close as we can get."

    ^ self basicAt:(self size + 1 // 2)

    "
     #(10 35 20 45 30 5) asSortedCollection median
     #(10 35 20 45 30 5) median
    "
! !

!SortedCollection methodsFor:'testing'!

includes:anObject
    "return true, if the argument, anObject is in the collection.
     Redefined, since due to being sorted, the inclusion check can
     be done with log-n compares i.e. much faster."

    |index "{ Class: SmallInteger }"
     initialIndex "{ Class: SmallInteger }"
     element|

    "/ if I am small, the inherited linear search is faster ...
    (lastIndex - firstIndex) < 20 ifTrue:[
        firstIndex > lastIndex ifTrue:[
            "/ empty
            ^ false
        ].
        ^ super includes:anObject.
    ].

    initialIndex := self indexForInserting:anObject.
    ((initialIndex < firstIndex) or:[initialIndex > lastIndex]) ifTrue:[^ false].
    (contentsArray basicAt:initialIndex) = anObject ifTrue:[
        "the simple case - plain objects"
        ^ true.
    ].

    "the complex case: the collection may include elements, which are odered only by
     a single component (e.g. Associations by key). So we have to test all
     previous and next elements having the same component"

    "for previous elements: while element is not smaller and not larger than anObject ... compare"
    index := initialIndex - 1.
    [index >= firstIndex 
     and:[
        element := contentsArray basicAt:index. 
        ((sortBlock value:element value:anObject) or:[sortBlock value:anObject value:element]) not]
    ] whileTrue:[
        element = anObject ifTrue:[
            ^ true.
        ].
        index := index - 1.
    ].

    "for next elements: while element is not smaller and not larger than anObject ... compare"
    index := initialIndex + 1.
    [index <= lastIndex 
     and:[
        element := contentsArray basicAt:index. 
        ((sortBlock value:element value:anObject) or:[sortBlock value:anObject value:element]) not]
    ] whileTrue:[
        element = anObject ifTrue:[
            ^ true.
        ].
        index := index + 1.
    ].

    ^ false.

    "
     #(7 3 9 10 99) asSortedCollection includes:50
     #(7 3 9 10 99) asSortedCollection includes:10
    "
!

occurrencesOf:anObject
    "return how many times the argument, anObject is in the collection.
     Redefined, since due to being sorted, the range of checked objects
     can be limited i.e. it can be done much faster.
      Uses #= (i.e. equality) compare."

    |index      "{ Class: SmallInteger }"
     tally      "{ Class: SmallInteger }"
     last       "{ Class: SmallInteger }" |

    index := self indexOf:anObject.
    index == 0 ifTrue:[
        ^ 0
    ].

    index := index + firstIndex - 1.
    last := lastIndex.

    "/ there may be multiple of them; count 'em

    tally := 0.
    [(index <= last) and:[(contentsArray basicAt:index) = anObject]] whileTrue:[
        tally := tally + 1.
        index := index + 1
    ].
    ^ tally

    "
     #(7 3 9 10 99) asSortedCollection occurrencesOf:50
     #(7 3 9 10 99) asSortedCollection occurrencesOf:10
     #(7 10 3 10 9 10 10 10 10 10 10 10 10 99) asSortedCollection occurrencesOf:10
    "

    "Modified: 12.4.1996 / 18:48:40 / cg"
! !

!SortedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


SortedCollection initialize!

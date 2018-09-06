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

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#OrderedCollection
	instanceVariableNames:'contentsArray firstIndex lastIndex'
	classVariableNames:'MinContentsArraySize'
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!OrderedCollection class methodsFor:'documentation'!

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
    OrderedCollections (OCs) have their elements ordered as they were added.
    In addition, they provide all indexing access protocol
    and bulk copying (much like Arrays).

    Insertion and removal at both ends is possible and also usually fast
    - therefore they can be used for queues and stacks.

    [Instance variables:]
	contentsArray   <Array>         the actual contents

	firstIndex      <SmallInteger>  index of first valid element

	lastIndex       <SmallInteger>  index of last valid element

    [performance hint:]
	They overallocate a few slots to make insertion at either end often O(1),
	but sometimes O(n), where n is the current size of the collection
	(i.e. they have reallocate the underlying element buffer and therefore copy the
	 elements into a new one. However, this reallocation is not done on every insert,
	 and if elements are deleted and others reinserted, the buffer is usually already able
	 to hold the new element)

	Insertion in the middle is O(n), and therefore slower, because elements have to be
	shuffled towards either end, in order to make space for the new element.
	Therefore, it is often cheaper, to instantiate a new object, and copy over the
	elements.
	see SegmentedOrderedCollection for a collection, which is specialized for this
	kind of usage with many elements.

    [beginners bug hint:]
	notice that:
	    Array new:n
	is quite different from:
	    OrderedCollection new:n

	The later creates an OC which is prepared to hold <n> elements,
	but has a logical size of 0 (zero). To get an OC containing <n> nils,
	use:
	     (OrderedCollection new) grow:n
	or the syntactic sugar for that:
	     OrderedCollection newWithSize:n

	I know, this is confusing for beginners and was a bad semantic decision.
	However, that's the way the standard was defined and how all Smalltalk's behave,
	so we can't change that here.

    [memory requirements:]
	OBJ-HEADER + (3 * ptr-size)
		   + (size-roundedUpToNextPowerOf2 * ptr-size)

    [complexity:]
	access by index: O(1)
	insertion at either end: mostly O(1)
	removal at either end: O(1)
	insertion in the middle: O(n)
	searching: O(n)
	min/max: O(n)

    [see also:]
	Array

    [author:]
	Claus Gittinger
"
!

examples
"
  using OC as a stack:
									[exBegin]
    |stack top|

    stack := OrderedCollection new.

    1 to:10 do:[:i |
	stack add:i
    ].

    10 timesRepeat:[
	top := stack removeLast.
	Transcript showCR:top
    ]
									[exEnd]
  using OC as a queue (you should use Queue right away ..):
									[exBegin]
    |queue dequeued|

    queue := OrderedCollection new.

    1 to:10 do:[:i |
	queue addLast:i
    ].

    10 timesRepeat:[
	dequeued := queue removeFirst.
	Transcript showCR:dequeued
    ]
									[exEnd]


  examples to support the performance hint (see documentation)

    timing removal of all odd elements in a collection of 10000:
    (940 ms on P5/133)
									[exBegin]
	|coll time|

	coll := (1 to:10000) asOrderedCollection.
	time := Time millisecondsToRun:[
	    coll removeAllSuchThat:[:el | el even]
	].
	Transcript show:'time is '; show:time; showCR:' ms'.
									[exEnd]

    tuning the removal by doing it reverse
    (less copying in #removeAtIndex:) speeds it up by a factor of 2:
									[exBegin]
	|coll time|

	coll := (1 to:10000) asOrderedCollection.
	time := Time millisecondsToRun:[
	    coll size to:1 by:-1 do:[:index |
		(coll at:index) even ifTrue:[
		    coll removeAtIndex:index
		]
	    ]
	].
	Transcript show:'time is '; show:time; showCR:' ms'.
									[exEnd]

    rebuilding a new collection:
    (64 ms on P5/133)
									[exBegin]
	|coll time|

	coll := (1 to:10000) asOrderedCollection.
	time := Time millisecondsToRun:[
	    coll := coll select:[:el | el odd]
	].
	Transcript show:'time is '; show:time; showCR:' ms'.
									[exEnd]

    adding at the end (fast):
									[exBegin]
	|coll time|

	coll := OrderedCollection new.
	time := TimeDuration toRun:[
	    (1 to:100000) do:[:el | coll add:el].
	].
	Transcript show:'time is '; showCR:time.
	self assert:(coll = (1 to:100000)).
	self assert:(coll asBag = (1 to:100000) asBag).
									[exEnd]
    adding at front (fast):
									[exBegin]
	|coll time|

	coll := OrderedCollection new.
	time := TimeDuration toRun:[
	    (1 to:100000) reverseDo:[:el | coll addFirst:el].
	].
	Transcript show:'time is '; showCR:time.
	self assert:(coll = (1 to:100000)).
	self assert:(coll asBag = (1 to:100000) asBag).
									[exEnd]
    inserting in the middle (slow):
									[exBegin]
	|coll time|

	coll := OrderedCollection new.
	time := TimeDuration toRun:[
	    (1 to:100000) do:[:el | coll add:el beforeIndex:(coll size // 2)+1 ].
	].
	Transcript show:'time is '; showCR:time.
	self assert:(coll asBag = (1 to:100000) asBag).
									[exEnd]
"
! !

!OrderedCollection class methodsFor:'initialization'!

initialize
    MinContentsArraySize := 4. "the minimum size of a non-empty contentsArray"
! !

!OrderedCollection class methodsFor:'instance creation'!

new
    "create a new, empty OrderedCollection"

    ^ self basicNew initContents:0

    "
	self new

	|nEmpty|
	nEmpty := 0.
	self allInstancesDo:[:e| e size == 0 ifTrue:[nEmpty := nEmpty + 1]].
	nEmpty

	|nEmpty|
	nEmpty := OrderedCollection new.
	self allInstancesDo:[:e| (e size == 0 and:[e contentsArray size ~~ 0]) ifTrue:[nEmpty add:e]].
	nEmpty
    "

    "Modified: 19.3.1996 / 17:53:12 / cg"
!

new:size
    "create a new, empty OrderedCollection with a preallocated physical
     size.
     NOTICE:
	the logical size of the returned collection is 0 (i.e. it is empty).
	This may be confusing, in that it is different from what Array>>new:
	returns. However, that's the way OrderedCollections work in every other
	Smalltalk, so here it should as well.
     See also newWithSize:, which might do what you really want.
     "

    ^ self basicNew initContents:size

    "Modified: 19.3.1996 / 17:53:47 / cg"
!

new:size withAll:element
    "return a new collection of size, where all elements are
     initialized to element."

    |newCollection|

    newCollection := self newWithSize:size.
    newCollection atAllPut:element.
    ^ newCollection

    "
     OrderedCollection new:10 withAll:1234
    "
!

newFrom:aCollection
    "return a new OrderedCollection filled with all elements from the argument,
     aCollection"

    |newColl|

    newColl := self new:(aCollection size).
    newColl addAll:aCollection.
    ^ newColl

    "
     OrderedCollection newFrom:#(1 2 3 4)
     OrderedCollection newFrom:(Set with:1 with:2 with:3)
    "
!

newLikelyToRemainEmpty
    "create a new, empty OrderedCollection, for which we already know
     that it is very likely to remain empty.
     Use this for collections which may sometimes get elements added, but usually not.
     This is now obsolete and the same as new:
     as the algorithm is now clever enough to deal efficiently with this situation"

    ^ self new:0

    "
     self newLikelyToRemainEmpty size
     self newLikelyToRemainEmpty add:1; size
     self newLikelyToRemainEmpty addAll:#(1 2); size
    "
! !


!OrderedCollection methodsFor:'accessing'!

at:anInteger
    "return the element at index, anInteger"

    |idx "{ Class: SmallInteger }"|

    idx := anInteger + firstIndex - 1.
    ((anInteger < 1) or:[idx > lastIndex]) ifTrue:[
	^ self subscriptBoundsError:anInteger
    ].
    ^ contentsArray basicAt:idx

    "Modified: / 12.11.1997 / 17:56:05 / cg"
!

at:anInteger ifAbsent:exceptionValue
    "return the element at index, anInteger.
     If the index is invalid, return the value from exceptionValue"

    |idx "{ Class: SmallInteger }"|

    idx := anInteger + firstIndex - 1.
    ((anInteger < 1) or:[idx > lastIndex]) ifTrue:[
	^ exceptionValue value
    ].
    ^ contentsArray basicAt:idx
!

at:anInteger put:anObject
    "set the element at index, to be anInteger.
     Return anObject (sigh)."

    |idx "{ Class: SmallInteger }"|

    idx := anInteger + firstIndex - 1.
    ((anInteger < 1) or:[idx > lastIndex]) ifTrue:[
	^ self subscriptBoundsError:anInteger
    ].
    ^ contentsArray basicAt:idx put:anObject

    "Modified: / 12.11.1997 / 17:56:32 / cg"
!

first
    "return the first element"

    firstIndex <= lastIndex ifTrue:[
	^ contentsArray at:firstIndex
    ].
    "error if collection is empty"
    ^ self emptyCollectionError

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) first
     (SortedCollection withAll:#(5 4 3 2 1)) first
    "
!

last
    "return the last element"

    firstIndex <= lastIndex ifTrue:[
	^ contentsArray at:lastIndex
    ].
    "error if collection is empty"
    ^ self emptyCollectionError

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) last
     (SortedCollection withAll:#(5 4 3 2 1)) last
    "
! !

!OrderedCollection methodsFor:'adding & removing'!

add:anObject
    "add the argument, anObject to the end of the collection
     Return the argument, anObject."

    |idx "{ Class:SmallInteger }"|

    idx := lastIndex.

    (idx == contentsArray size) ifTrue:[
	self makeRoomAtLast.
	idx := lastIndex.
    ].
    lastIndex := idx := idx + 1.
    contentsArray basicAt:idx put:anObject.
    ^ anObject

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here'
    "

    "Modified: / 12.11.1997 / 17:49:47 / cg"
!

add:newObject after:oldObject
    "insert the argument, newObject after oldObject.
     If oldObject is not in the receiver, report an error,
     otherwise return the argument, anObject."

    |idx|

    idx := self indexOf:oldObject.
    idx ~~ 0 ifTrue:[
	self add:newObject beforeIndex:(idx + 1).
	^ newObject
    ].
    ^ self errorValueNotFound:oldObject

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' after:3; yourself.
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' after:1; yourself.
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' after:5; yourself
    "

    "Modified: 12.4.1996 / 13:51:56 / cg"
!

add:anObject afterIndex:index
    "insert the argument, anObject to become located at index.
     Return the receiver (sigh - ST-80 compatibility)."

    ^ self add:anObject beforeIndex:(index + 1)

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' afterIndex:2
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' afterIndex:4
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' afterIndex:0
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' afterIndex:5
    "

    "Modified: 12.4.1996 / 13:52:41 / cg"
!

add:newObject before:oldObject
    "insert the argument, newObject before oldObject.
     If oldObject is not in the receiver, report an error,
     otherwise return the argument, anObject."

    |idx|

    idx := self indexOf:oldObject.
    idx ~~ 0 ifTrue:[
	self add:newObject beforeIndex:idx.
	^ newObject
    ].
    ^ self errorValueNotFound:oldObject

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' before:3.
     c add:'here' before:5
    "

    "Modified: 12.4.1996 / 13:25:47 / cg"
!

add:anObject beforeIndex:index
    "insert the argument, anObject to become located at index.
     Return the receiver (sigh - ST-80 compatibility)."

    |idx physicalIndex|

    physicalIndex := index + firstIndex - 1.
    physicalIndex > lastIndex ifTrue:[
	"can only add to the end of the collection"
	physicalIndex == (lastIndex+1) ifTrue:[
	    idx := lastIndex.
	    (idx == contentsArray size) ifTrue:[
		self makeRoomAtLast.
		idx := lastIndex.
	    ].
	    lastIndex := idx := idx + 1.
	] ifFalse:[
	    ^ self subscriptBoundsError:index.
	]
    ] ifFalse:[
	"notice: this may change firstIndex"
	idx := self makeRoomAtIndex:physicalIndex.
    ].
    contentsArray basicAt:idx put:anObject.

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' beforeIndex:3
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' beforeIndex:1
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c add:'here' beforeIndex:5
    "

    "Modified: / 28.1.1998 / 17:17:48 / cg"
!

addAll:aCollection
    "add all elements of the argument, aCollection to the receiver.
     Returns the argument, aCollection (sigh)."

    self addAll:aCollection beforeIndex:(1 + self size).
    ^ aCollection
!

addAll:aCollection afterIndex:index
    "insert the argument, anObject to become located after index.
     Return the receiver (sigh - ST-80 compatibility)."

    ^ self addAll:aCollection beforeIndex:(index + 1)

    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c addAll:#(10 20 30) afterIndex:2
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c addAll:#(10 20 30) afterIndex:4
    "
    "
     |c|
     c := #(4 3 2 1) asOrderedCollection.
     c addAll:#(10 20 30) afterIndex:0
    "

    "Modified: 12.4.1996 / 13:52:41 / cg"
!

addAll:aCollection beforeIndex:index
    "insert all elements of the argument, anObject to become located at index.
     The collection may be unordered, but then order of the sliced-in elements
     is undefined.
     Return the receiver."

    |idx count|

    aCollection isSequenceable ifTrue:[
	"/ we are lucky - that thing can count & do bulk copies

	count := aCollection size.
	idx := self makeRoomAtIndex:(index + firstIndex - 1) for:count.
	"/ notice: the above may change firstIndex
	contentsArray replaceFrom:idx to:(idx + count - 1) with:aCollection startingAt:1.
	^ self
    ].

    idx := index.
    aCollection do:[:element |
	self add:element beforeIndex:idx.
	idx := idx + 1.
    ].

    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:'here' beforeIndex:3
    "
    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c removeFirst.
     c addAll:'here' beforeIndex:3
    "
    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:'here' beforeIndex:1
    "
    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:'here' beforeIndex:5
    "

    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addAll:('hello' asSet) beforeIndex:3
    "

    "Modified: 15.4.1997 / 12:43:59 / cg"
!

addFirst:anObject
    "add the argument, anObject to the beginning of the collection.
     Return the argument, anObject."

    |idx "{ Class:SmallInteger }"|

    (idx := firstIndex) == 1 ifTrue:[
	self makeRoomAtFront.
	idx := firstIndex.
    ].
    firstIndex := idx := idx - 1.
    contentsArray basicAt:idx put:anObject.
    ^ anObject

    "
     |c|
     c := #(1 2 3 4) asOrderedCollection.
     c addFirst:'here'.
     c
    "

    "
     |c|
     c := #() asOrderedCollection.
     c addFirst:'here'.
     c
    "

    "Modified: / 12.11.1997 / 17:58:05 / cg"
!

clearContents
    "remove all elements from the collection but keep the contentsArray.
     Useful for huge lists, if the contents will be rebuild soon (using #add:)
     to a size which is similar to the lists current size.
     Destructive: modifies the receiver.
     Returns the receiver."

    "/ clear those references, to give the garbage collector
    "/ a chance ...

    firstIndex >= lastIndex ifTrue:[
	contentsArray from:firstIndex to:lastIndex put:nil.
    ].
    firstIndex := 1.
    lastIndex := 0.

    "/ this is the same as:
    "/ self initContents:(self size)

    "Modified: 12.4.1996 / 13:34:19 / cg"
!

remove:anObject ifAbsent:exceptionBlock
    "remove the first element which is equal to anObject;
     if found, remove and return it;
     if not, return the value from evaluating exceptionBlock.
     Destructive: modifies the receiver.
     Uses equality compare (=) to search for the element."

    |index retVal|

    index := self indexOf:anObject.
    index ~~ 0 ifTrue:[
	retVal := contentsArray at:index+firstIndex-1.
	self removeFromIndex:index toIndex:index.
	^ retVal
    ].
    ^ exceptionBlock value

    "
     #(1 2 3 4 5) asOrderedCollection remove:9 ifAbsent:[self halt]; yourself
     #(1 2 3 4 5) asOrderedCollection remove:3 ifAbsent:[self halt]; yourself

     #(1 2 3 4 5 6 7 8 9) asOrderedCollection remove:3 ifAbsent:'oops'
     #(1 2 3 4 5) asOrderedCollection remove:9 ifAbsent:'oops'
     #(1.0 2.0 3.0 4.0 5.0) asOrderedCollection remove:4 ifAbsent:'oops'
     #(1.0 2.0 3.0 4.0 5.0) asOrderedCollection removeIdentical:4 ifAbsent:'oops'
    "

    "Modified: 8.2.1997 / 19:17:19 / cg"
!

removeAll
    "remove all elements from the collection.
     Returns the receiver.
     Destructive: modifies the receiver."

    self initContents:0

    "Modified: 12.4.1996 / 13:34:19 / cg"
!

removeAllSuchThat:aBlock
    "remove all elements that meet a test criteria as specified in aBlock.
     The argument, aBlock is evaluated for successive elements and all those,
     for which it returns true, are removed.
     Destructive: modifies the receiver.
     Return a collection containing the removed elements.

     Performance:
	this is an O(N) algorithm (the receiver's elements are scanned once)."

    "/ this is a q&d implementation (possibly slow).

    |removed element
     srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     lastIdx "{ Class: SmallInteger }"|

    "/ first search forward to the first element which has
    "/ to be removed (meets the criteria)
    srcIndex := firstIndex.
    lastIdx := lastIndex.

    [
	srcIndex > lastIdx
	or:[ aBlock value:(contentsArray at:srcIndex) ]
    ] whileFalse:[
	srcIndex := srcIndex + 1.
    ].
    srcIndex > lastIdx ifTrue:[
	"/ nothing removed
	^ #()
    ].

    "/ now srcIndex is the index of element, which is the first to be removed
    removed := OrderedCollection new.
    removed add:(contentsArray at:srcIndex).

    dstIndex := srcIndex.
    srcIndex := srcIndex + 1.

    srcIndex to:lastIdx do:[:idx|
	element := contentsArray at:idx.
	(aBlock value:element) ifTrue:[
	    removed add:element
	] ifFalse:[
	    contentsArray at:dstIndex put:element.
	    dstIndex := dstIndex + 1.
	].
    ].
    contentsArray from:dstIndex to:lastIdx put:nil.
    lastIndex := dstIndex - 1.
    ^ removed

    "
     |coll|

     coll := OrderedCollection withAll:(1 to:10).
     Transcript show:'removed: '; showCR:(coll removeAllSuchThat:[:el | el even]).
     Transcript show:'coll: '; showCR:coll
    "

    "
     |coll1 coll2|

     Transcript showCR:'no element removed:'.

     coll1 := OrderedCollection withAll:(1 to:1000).
     Transcript show:'  (1000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll1 copy removeAllSuchThat:[:el | el == 500] ]
	]).

     coll2 := OrderedCollection withAll:(1 to:10000).
     Transcript show:'  (10000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll2 copy removeAllSuchThat:[:el | el == 5000] ]
	]).

     coll2 := OrderedCollection withAll:(1 to:50000).
     Transcript show:'  (50000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll2 copy removeAllSuchThat:[:el | el == 25000] ]
	]).

     Transcript showCR:'small number of elements removed:'.

     coll1 := OrderedCollection withAll:(1 to:1000).
     Transcript show:'  (1000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll1 copy removeAllSuchThat:[:el | el between:500 and:550] ]
	]).

     coll2 := OrderedCollection withAll:(1 to:10000).
     Transcript show:'  (10000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll2 copy removeAllSuchThat:[:el | el between:5000 and:5050] ]
	]).

     coll2 := OrderedCollection withAll:(1 to:50000).
     Transcript show:'  (50000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll2 copy removeAllSuchThat:[:el | el between:25000 and:25050] ]
	]).

     Transcript showCR:'many elements removed:'.

     coll1 := OrderedCollection withAll:(1 to:1000).
     Transcript show:'  (1000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll1 copy removeAllSuchThat:[:el | el even] ]
	]).

     coll2 := OrderedCollection withAll:(1 to:10000).
     Transcript show:'  (10000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll2 copy removeAllSuchThat:[:el | el even] ]
	]).

     coll2 := OrderedCollection withAll:(1 to:50000).
     Transcript show:'  (50000) - '; showCR:(
	Time millisecondsToRun:[
	    100 timesRepeat:[ coll2 copy removeAllSuchThat:[:el | el even] ]
	]).
    "
    "
		    compiled bytecode bytecode/new (no jitter)
	no element removed:
	  (1000)  -  10          20         20
	  (10000) -  70         240        200
	  (50000) - 390        1190        940
	small number of elements removed:
	  (1000)  -  10          30         20
	  (10000) - 160         300        260
	  (50000) - 700        1540       1180
	many elements removed:
	  (1000)  -  10          20         30
	  (10000) - 130         290        260
	  (50000) - 720        1470       1300
    "
    "Modified: 8.2.1997 / 19:19:00 / cg"
!

removeFirst
    "remove the first element from the collection; return the element.
     If there is no element in the receiver collection, raise an error.
     Destructive: modifies the receiver"

    |anObject
     fI "{ Class: SmallInteger }" |

    fI := firstIndex.

    fI > lastIndex ifTrue:[
	"error if collection is empty"
	^ self emptyCollectionError.
    ].

    anObject := contentsArray basicAt:fI.

    "/ nil it out, to allow GC to reclaim it.
    contentsArray basicAt:fI put:nil.

    fI := fI + 1.

    fI > lastIndex ifTrue:[
	"reset to avoid ever growing"
	fI := 1.
	lastIndex := 0
    ].
    firstIndex := fI.
    ^ anObject

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) removeFirst; yourself
     OrderedCollection new removeFirst
     (SortedCollection withAll:#(5 4 3 2 1)) removeFirst; yourself
    "

    "Modified: / 5.2.1999 / 23:22:58 / cg"
!

removeFirst:n
    "remove the first n elements from the collection;
     Return a collection containing the removed elements.
     Destructive: modifies the receiver"

    |mySize ret newFirstIndex|

    mySize := self size.
    mySize < n ifTrue:[
	"error if collection has not enough elements"
	^ self notEnoughElementsError.
    ].

    ret := Array new:n.
    ret replaceFrom:1 to:n with:contentsArray startingAt:firstIndex.

    "/
    "/ nil-out contents array, to not keep elements from being GC'd
    "/
    newFirstIndex := firstIndex + n.
    contentsArray from:firstIndex to:newFirstIndex - 1 put:nil.

    newFirstIndex > lastIndex ifTrue:[
	"reset to avoid ever growing"
	newFirstIndex := 1.
	lastIndex := 0
    ].
    firstIndex := newFirstIndex.
    ^ ret

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) removeFirst:2; yourself
     (OrderedCollection withAll:#(1 2 3 4 5)) removeFirst:0; yourself
     OrderedCollection new removeFirst:2
     (OrderedCollection withAll:#(1 2 3 4 5)) removeFirst:6
     (SortedCollection withAll:#(5 4 3 2 1)) removeFirst:2; yourself
    "

    "Modified: 8.2.1997 / 19:20:18 / cg"
!

removeFirstIfAbsent:exceptionBlock
    "remove the first element from the collection; return the element.
     If there is no element in the receiver collection, return the value from
     exceptionBlock.
     Destructive: modifies the receiver"

    |anObject fI "{ Class: SmallInteger }" |

    fI := firstIndex.

    fI > lastIndex ifTrue:[
	"error if collection is empty"
	^ exceptionBlock value.
    ].

    anObject := contentsArray basicAt:fI.

    "/ nil it out, to allow GC to reclaim it.
    contentsArray basicAt:fI put:nil.

    fI := fI + 1.

    fI > lastIndex ifTrue:[
	"reset to avoid ever growing"
	fI := 1.
	lastIndex := 0
    ].
    firstIndex := fI.
    ^ anObject

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) removeFirst; yourself
     OrderedCollection new removeFirst
     (SortedCollection withAll:#(5 4 3 2 1)) removeFirst; yourself
    "

    "Modified: / 12.11.1997 / 17:58:43 / cg"
    "Created: / 30.7.1998 / 13:19:42 / cg"
!

removeFrom:startIndex to:stopIndex
    "added for ST-80 compatibility.
     Same as removeFromIndex:toIndex:."

    ^ self removeFromIndex:startIndex toIndex:stopIndex

    "Created: 15.4.1997 / 12:39:00 / cg"
!

removeFromIndex:startIndex toIndex:stopIndex
    "remove the elements stored under startIndex up to and including
     the elements under stopIndex.
     Destructive: modifies the receiver
     Return the receiver.
     Returning the receiver here is a historic leftover - it may change.
     Please use yourself in a cascade, if you need the receiver's value
     when using this method."

    |nDeleted "{ Class: SmallInteger }"
     fI "{ Class: SmallInteger }"
     lI "{ Class: SmallInteger }"
     newLastIndex sz|

    sz := self size.

    (startIndex < 1 or:[stopIndex > sz]) ifTrue:[
	^ self notEnoughElementsError
    ].

    nDeleted := stopIndex - startIndex + 1.
    nDeleted < 0 ifTrue:[
	"/ mhmh - what should be done here ?
	^ self error:'bad index range'
    ].
    nDeleted == 0 ifTrue:[^ self].

    fI := firstIndex.
    lI := lastIndex.

    "/
    "/ can be done faster, when removing the first elements
    "/
    startIndex == 1 ifTrue:[
	"/ nil out (helps GC)
	contentsArray
	    from:fI
	    to:fI + nDeleted - 1
	    put:nil.
	firstIndex := fI := fI + nDeleted
    ] ifFalse:[
	"/
	"/ can be done faster, when removing the last elements
	"/
	stopIndex == sz ifTrue:[
	    "/ nil out (helps GC)
	    contentsArray
		from:lI - nDeleted + 1
		to:lI
		put:nil.
	    lastIndex := lI := lI - nDeleted
	] ifFalse:[
	    "/
	    "/ must shuffle
	    "/ TODO:
	    "/    for big collections, try to copy the smallest
	    "/    possible number of elements

	    newLastIndex := lI - nDeleted.

	    contentsArray
		replaceFrom:(fI + startIndex - 1)
		to:newLastIndex
		with:contentsArray
		startingAt:(fI + stopIndex).

	    "/ nil out rest (helps GC)
	    contentsArray
		from:(newLastIndex + 1)
		to:lI
		put:nil.

	    lastIndex := lI := newLastIndex.
	]
    ].

    fI > lI ifTrue:[
	"reset to avoid ever growing"
	firstIndex := 1.
	lastIndex := 0
    ]

    "
     #(1 2 3 4 5 6 7 8 9) asOrderedCollection removeFromIndex:3 toIndex:6
     #(1 2 3 4 5 6 7 8 9) asOrderedCollection removeFromIndex:6 toIndex:8
     #(1 2 3 4 5 6 7 8 9) asOrderedCollection removeFromIndex:1 toIndex:3
     #(1 2 3 4 5 6 7 8 9) asOrderedCollection removeFromIndex:6 toIndex:9
     #(1 2 3 4 5) asOrderedCollection removeFromIndex:3 toIndex:6
    "

    "Modified: / 5.2.1999 / 23:22:07 / cg"
!

removeIdentical:anObject ifAbsent:exceptionBlock
    "remove the first element which is identical to anObject;
     if found, remove and return it;
     if not, return the value from evaluating exceptionBlock.
     Destructive: modifies the receiver.
     Uses identity compare (==) to search for the element."

    |index|

    index := contentsArray identityIndexOf:anObject startingAt:firstIndex endingAt:lastIndex.
    index ~~ 0 ifTrue:[
	index == firstIndex ifTrue:[
	    contentsArray basicAt:firstIndex put:nil.
	    firstIndex := firstIndex + 1.
	    firstIndex > lastIndex ifTrue:[
		"reset to avoid ever growing"
		firstIndex := 1.
		lastIndex := 0
	    ].
	] ifFalse:[
	    index == lastIndex ifTrue:[
		contentsArray basicAt:lastIndex put:nil.
		lastIndex := lastIndex - 1.
		firstIndex > lastIndex ifTrue:[
		    "reset to avoid ever growing"
		    firstIndex := 1.
		    lastIndex := 0
		].
	    ] ifFalse:[
		index := index - firstIndex + 1.
		self removeFromIndex:index toIndex:index.
	    ]
	].
	^ anObject
    ].
    ^ exceptionBlock value

    "
     #(1.0 2.0 3.0 4.0 5.0) asOrderedCollection remove:4 ifAbsent:'oops'
     #(1.0 2.0 3.0 4.0 5.0) asOrderedCollection remove:4 ifAbsent:'oops'; yourself
     #(1.0 2.0 3.0 4.0 5.0) asOrderedCollection removeIdentical:4 ifAbsent:'oops'
     #(fee foo bar baz) asOrderedCollection removeIdentical:#fee; yourself
     #(fee foo bar baz) asOrderedCollection removeIdentical:#foo; yourself
     #(fee foo bar baz) asOrderedCollection removeIdentical:#baz; yourself
     #(fee) asOrderedCollection removeIdentical:#fee; yourself
     #(fee) asOrderedCollection removeIdentical:#foo; yourself
    "

    "Modified: 8.2.1997 / 18:57:43 / cg"
!

removeIndices:aSortedCollectionOfIndices
    "remove all elements stored in any of aSortedCollectionOfIndices,
     which must be sorted and sequenceable.
     Destructive: modifies the receiver.
     Returns a collection of removed elements.

     Performance:
	this is an O(N) algorithm (N being the size of the receiver).

     This could be done much better, especially if the removed indices are
     at either end of the receiver. However, as it is currently not heavily used,
     I leave that as an exercise to the brave reader..."

    |removed element dstIndex indexIndex nextIndex numIndices|

    removed := OrderedCollection new.

    dstIndex := firstIndex.
    numIndices := aSortedCollectionOfIndices size.
    indexIndex := 1.
    nextIndex := aSortedCollectionOfIndices at:1.
    firstIndex to: lastIndex do:[:srcIndex |
	element := contentsArray at:srcIndex.
	srcIndex == nextIndex ifTrue:[
	    removed add:element.
	    indexIndex := indexIndex + 1.
	    indexIndex > numIndices ifTrue:[
		nextIndex := nil.
	    ] ifFalse:[
		nextIndex := aSortedCollectionOfIndices at:indexIndex.
	    ].
	] ifFalse:[
	    contentsArray at:dstIndex put:element.
	    dstIndex := dstIndex + 1.
	].
    ].
    contentsArray from:dstIndex to:lastIndex put:nil.
    lastIndex := dstIndex - 1.
    ^ removed

    "
     |coll|

     coll := OrderedCollection withAll:(1 to:10).
     Transcript showCR:(coll removeIndices:#(1 5 7)).
     Transcript showCR:coll
    "
!

removeLast
    "remove the last element from the collection.
     Return the removed element.
     Destructive: modifies the receiver"

    |anObject
     idx "{ Class: SmallInteger }" |

    idx := lastIndex.
    firstIndex > idx ifTrue:[
	"error if collection is empty"
	^ self emptyCollectionError.
    ].
    anObject := contentsArray basicAt:idx.

    "/ nil it (helps GC)
    contentsArray basicAt:idx put:nil.
    lastIndex := idx := idx - 1.

    firstIndex > idx ifTrue:[
	"reset to avoid ever growing"
	firstIndex := 1.
	lastIndex := 0
    ].
    ^ anObject

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) removeLast; yourself
     OrderedCollection new removeLast
     (SortedCollection withAll:#(5 4 3 2 1)) removeLast; yourself
    "

    "Modified: / 12.11.1997 / 17:58:57 / cg"
!

removeLast:n
    "remove the last n elements from the receiver collection.
     Destructive: modifies the receiver.
     Return a collection of removed elements."

    |mySize ret|

    mySize := self size.
    mySize < n ifTrue:[
	"error if collection has not enough elements"
	^ self notEnoughElementsError.
    ].

    ret := Array new:n.
    ret replaceFrom:1 to:n with:contentsArray startingAt:lastIndex - n + 1.

    "/
    "/ nil-out contents array, to not keep elements from being GC'd
    "/
    contentsArray from:lastIndex - n + 1 to:lastIndex put:nil.
    lastIndex := lastIndex - n.

    firstIndex > lastIndex ifTrue:[
	"reset to avoid ever growing"
	firstIndex := 1.
	lastIndex := 0
    ].
    ^ ret

    "
     (OrderedCollection withAll:#(1 2 3 4 5)) removeLast:2; yourself
     (OrderedCollection withAll:#(1 2 3 4 5)) removeLast:0; yourself
     (OrderedCollection withAll:#(1 2 3 4 5)) removeLast:6; yourself
     (SortedCollection withAll:#(5 4 3 2 1)) removeLast:2; yourself
     (SortedCollection withAll:#(5 4 3 2 1)) removeLast:0; yourself
     (SortedCollection withAll:#(5 4 3 2 1)) removeLast:0
    "

    "Modified: 12.4.1996 / 13:39:12 / cg"
!

reset
    "logically remove all elements from the collection.
     That's almost the same as #removeAll, but keeps the contentsArray.
     Returns the receiver."

    firstIndex := contentsArray size // 3 max: 1.
    lastIndex := firstIndex - 1
! !

!OrderedCollection methodsFor:'converting'!

asArray
    "return the receiver as an array."

    ^ contentsArray copyFrom:firstIndex to:lastIndex

"/    |newArray sz|
"/
"/    sz := self size.
"/    newArray := Array new:sz.
"/    newArray replaceFrom:1 to:sz with:contentsArray startingAt:firstIndex.
"/    ^ newArray

    "
     OrderedCollection new asArray
     OrderedCollection new add:1;add:2;asArray
     OrderedCollection new add:1;removeFirst;asArray
    "

    "
     |o rnd|

     o := OrderedCollection new.
     rnd := Random new.
     10000 timesRepeat:[
	 o add:rnd next.
     ].
     Time millisecondsToRun:[o asArray]
    "

    "Modified: 13.4.1996 / 12:10:56 / cg"
!

asNewOrderedCollection
    "return the receiver as an ordered collection.
     Make sure to return a unique new OrderedCollection"

    "could be an instance of a subclass..."
    self class == OrderedCollection ifTrue:[
	^ self copy
    ].
    ^ super asOrderedCollection

    "
	|s|
	s := #(1 2 3 4) asOrderedCollection.
	self assert:(s ~~ s asNewOrderedCollection).
	self assert:(s = s asNewOrderedCollection).
     "
!

asOrderedCollection
    "return the receiver as an ordered collection.
     Notice: this returns the receiver. Use asNewOrderedCollection, if you intent to
     modify the returned collection."

    "could be an instance of a subclass..."
    self class == OrderedCollection ifTrue:[
	^ self
    ].
    ^ super asOrderedCollection
! !

!OrderedCollection methodsFor:'copying'!

, aCollection
    "return a new collection formed from concatenating the receiver with the argument"

    |newCollection|

    newCollection := self copyEmpty:(self size + aCollection size).
    ^ newCollection
	addAll:self;
	addAll:aCollection;
	yourself.

    "
     #(1 2 3) asOrderedCollection , #(4 5 6) asOrderedCollection
     #(1 3 5) asSortedCollection , #(6 4 2) asSortedCollection
     #(1 3 5) asSortedCollection , #(6 4 2) asOrderedCollection
     #(1 3 5) asSortedCollection , (#(6 4 2) asSortedCollection:[:a :b| a > b])
    "

    "Modified (comment): / 01-04-2012 / 13:17:30 / cg"
!

copy
    "return a new OrderedCollection containing the elements of the receiver."

    "redefinition is a consequence of the implementation with a
     separate array - otherwise we get a shallow copy of the
     contents array, which is not what we want here"

    ^ self copyFrom:1 to:self size
!

postCopy
    "have to copy the contentsArray too"

    contentsArray := contentsArray shallowCopy
! !

!OrderedCollection methodsFor:'enumerating'!

collect:aBlock
    "evaluate the argument, aBlock for every element in the collection
     and return a collection of the results"

    |newCollection
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }" |

    newCollection := self copyEmpty:(self size).
    stop := lastIndex.
    start := firstIndex.
    start to:stop do:[:index |
	newCollection add:(aBlock value:(contentsArray at:index)).
    ].
    ^ newCollection

    "
     #(1 2 3 4) asOrderedCollection collect:[:i | i * i]
     #(1 2 3 4) asOrderedCollection collect:[:i | i even]
    "
!

collect:collectBlock thenSelect:selectBlock
    "combination of collect followed by select;
     redefined to avoid the creation of an intermediate (garbage) collection."

    |newCollection newElement
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }" |

    newCollection := self copyEmpty.
    stop := lastIndex.
    start := firstIndex.
    start to:stop do:[:index |
	newElement := collectBlock value:(contentsArray at:index).
	(selectBlock value:newElement) ifTrue:[
	    newCollection add:newElement.
	]
    ].
    ^ newCollection

    "
     #(1 2 3 4) asOrderedCollection collect:[:i | i * i] thenSelect:[:each | each > 5]
     ( #(1 2 3 4) asOrderedCollection collect:[:i | i * i]) select:[:each | each > 5]

     |coll|
     coll := #(1 2 3 4) asOrderedCollection.
     Time millisecondsToRun:[
	100000 timesRepeat:[
	    coll collect:[:i | i * i] thenSelect:[:each | each > 5]
	]
     ]

     |coll|
     coll := #(1 2 3 4) asOrderedCollection.
     Time millisecondsToRun:[
	100000 timesRepeat:[
	    ( coll collect:[:i | i * i]) select:[:each | each > 5]
	]
     ]
    "
!

do:aBlock
    "evaluate the argument, aBlock for every element in the collection."

    contentsArray from:firstIndex to:lastIndex do:aBlock
!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments."

    |start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
     idx    "{ Class:SmallInteger }" |

    stop := lastIndex.
    start := firstIndex.
    idx := 1.
    start to:stop do:[:index |
	aTwoArgBlock value:idx value:(contentsArray at:index).
	idx := idx + 1.
    ]

    "
     #(10 20 30 40) asOrderedCollection keysAndValuesDo:[:index :value |
	Transcript show:index; show:' '; showCR:value
     ]
    "
    "
     |oc|

     oc := #(10 20 30 40 50 60 70 80) asOrderedCollection.
     oc removeFirst; removeFirst.
     oc keysAndValuesDo:[:index :value |
	Transcript show:index; show:' '; showCR:value
     ]
    "

!

keysAndValuesReverseDo:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments."

    |start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
     idx    "{ Class:SmallInteger }"|

    stop := lastIndex.
    start := firstIndex.
    idx := (stop - start + 1).
    stop to:start by: -1 do:[:index |
	aTwoArgBlock value:idx value:(contentsArray at:index).
	idx := idx - 1.
    ]

    "
     #(10 20 30 40) asOrderedCollection keysAndValuesReverseDo:[:index :value |
	Transcript show:index; show:' '; showCR:value
     ]
    "

    "
     |oc|

     oc := #(10 20 30 40 50 60 70 80) asOrderedCollection.
     oc removeFirst; removeFirst.
     oc keysAndValuesReverseDo:[:index :value |
	Transcript show:index; show:' '; showCR:value
     ]
    "
!

reverseDo:aBlock
    "evaluate the argument, aBlock for every element in the collection
     procesing elements in reverse direction (i.e. starting with the last)"

    contentsArray from:firstIndex to:lastIndex reverseDo:aBlock
!

select:selectBlock thenCollect:collectBlock
    "combination of select followed by collect;
     redefined to avoid the creation of an intermediate (garbage) collection."

    |newCollection element
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }" |

    newCollection := self copyEmpty.
    stop := lastIndex.
    start := firstIndex.
    start to:stop do:[:index |
	element := contentsArray at:index.
	(selectBlock value:element) ifTrue:[
	    newCollection add:(collectBlock value:element).
	]
    ].
    ^ newCollection

    "
     #(1 2 3 4 5 6 7 8) asOrderedCollection
	select:[:each | each > 5] thenCollect:[:i | i * i]
     ( #(1 2 3 4 5 6 7 8) asOrderedCollection
	select:[:each | each > 5]) collect:[:i | i * i]

     |coll|
     coll := #(1 2 3 4 5 6 7 8) asOrderedCollection.
     Time millisecondsToRun:[
	100000 timesRepeat:[
	    coll select:[:each | each > 5] thenCollect:[:i | i * i]
	]
     ]

     |coll|
     coll := #(1 2 3 4 5 6 7 8) asOrderedCollection.
     Time millisecondsToRun:[
	100000 timesRepeat:[
	    ( coll select:[:each | each > 5]) collect:[:i | i * i]
	]
     ]
    "
! !

!OrderedCollection methodsFor:'filling & replacing'!

replaceFrom:start to:stop with:aCollection startingAt:repStart
    "replace elements in the receiver between index start and stop,
     with elements  taken from replacementCollection starting at repStart.
     Return the receiver.
     Redefined here; can be done faster as the inherited operation."

    |end|

    end := stop + firstIndex - 1.
    ((start >= 1) and:[end <= lastIndex]) ifTrue:[
	aCollection class == self class ifTrue:[
	    contentsArray
		replaceFrom:(start + firstIndex - 1)
		to:end
		with:aCollection contentsArray
		startingAt:(repStart + aCollection firstIndex - 1).
	] ifFalse:[
	    contentsArray
		replaceFrom:(start + firstIndex - 1)
		to:end
		with:aCollection
		startingAt:repStart.
	].
	^ self
    ].
    ^ super replaceFrom:start to:stop with:aCollection startingAt:repStart

    "
     |c1 c2|

     c1 := #(1 2 3 4 5 6) asOrderedCollection.
     c2 := #(a b c d e f) asOrderedCollection.
     c2 replaceFrom:3 to:6 with:c1.
     c2
    "
    "
     |c1 c2|

     c1 := #(1 2 3 4 5 6) asOrderedCollection.
     c2 := #(a b c d e f) asOrderedCollection.
     c2 replaceFrom:3 to:6 with:c1 startingAt:2.
     c2
    "
    "
     |c|

     c := #(1 2 3 4 5 6) asOrderedCollection.
     c replaceFrom:3 to:6 with:c startingAt:2.
     c
    "
    "
     |c|

     c := #(1 2 3 4 5 6) asOrderedCollection.
     c replaceFrom:3 to:5 with:c startingAt:4.
     c
    "

    "Modified: / 28.1.1998 / 16:49:31 / cg"
! !

!OrderedCollection methodsFor:'grow & shrink'!

ensureSizeAtLeast:minSize
    "ensure that the size is at least minSize.
     If the receiver's size is smaller, grow the receiver to minSize,
     filling new slots with nil.
     Otherwise, if the size is already >= minSize, leave the receiver unchanged."

    (self size < minSize) ifTrue:[
	self grow:minSize
    ].

    "
     |oc|

     oc := OrderedCollection new.
     oc ensureSizeAtLeast:10.
     oc at:10 put:10.
     oc add:11.
     oc at:11.
     oc ensureSizeAtLeast:20.
     oc at:20 put:20.
     oc.
    "
!

grow:newSize
    "grow the receiver to newSize.
     This only logically changes the receiver's size;
     the underlying contentsArray is kept
     (except if growing to a zero size, or too small for newSize)"

    |oldSize newContents oldLast newLast|

    oldSize := lastIndex - firstIndex + 1.
    newSize ~~ oldSize ifTrue:[
	newLast := firstIndex + newSize - 1.
	newSize < oldSize ifTrue:[
	    newSize == 0 ifTrue:[
		self initContents:0.
		^ self.
	    ].
	    oldLast := lastIndex.
	    lastIndex := newLast.
	    "
	     nil out rest, to give GC a chance to reclaim things
	    "
	    contentsArray from:lastIndex + 1 to:oldLast put:nil.
	] ifFalse:[
	    newLast <= contentsArray size ifTrue:[
		lastIndex := newLast.
		^ self
	    ].

	    newContents := Array basicNew:newSize.
	    newContents replaceFrom:1 to:oldSize with:contentsArray startingAt:firstIndex.
	    contentsArray := newContents.
	    firstIndex := 1.
	    lastIndex := newSize
	]
    ]
! !



!OrderedCollection methodsFor:'private'!

initContents:size
    "setup the receiver-collection to hold size entries"

    size == 0 ifTrue:[
	contentsArray := #().   "save memory by using a shared instance"
    ] ifFalse:[
	contentsArray := Array basicNew:size.
    ].
    firstIndex := 1.
    lastIndex := 0
!

makeRoomAtFront
    "grow/shift the contents for more room at the beginning.
     Does not change the logical size.
     i.e. the contents array is changed from:
	#(1 2 3 4 5 6) -> #(nil 1 2 3 4 5 6)
     and the start/stopIndices are adjusted as required"

    |newContents
     oldSize    "{ Class:SmallInteger }"
     newSize    "{ Class:SmallInteger }"
     startIndex "{ Class:SmallInteger }"
     sz         "{ Class:SmallInteger }"|

    oldSize := contentsArray size.
    sz := lastIndex - firstIndex + 1.

    ((oldSize == 0) or:[sz == 0]) ifTrue:[
	contentsArray := Array basicNew:MinContentsArraySize.
	firstIndex := 2. lastIndex := 1.
	^ self
    ].

    "
     if there is lots of room at the end (> 50%),
     shift instead of growing. This helps collections
     which get elements removed at the end and added at front.
    "
    oldSize > (sz * 2) ifTrue:[
	startIndex := oldSize // 4.
	startIndex > 1 ifTrue:[
	    contentsArray
		replaceFrom:startIndex to:(startIndex + sz - 1)
		with:contentsArray startingAt:1.
	    contentsArray from:1 to:(startIndex - 1) put:nil.
	    firstIndex := startIndex.
	    lastIndex := startIndex + sz - 1.
	    ^ self
	]
    ].
    newSize := oldSize * 2.
    newContents := Array basicNew:newSize.
    newContents
	replaceFrom:(oldSize + 1) to:newSize
	with:contentsArray startingAt:1.
    contentsArray := newContents.
    firstIndex := firstIndex + oldSize.
    lastIndex := lastIndex + oldSize

    "Created: / 08-11-1995 / 12:47:49 / cg"
    "Modified: / 22-10-2008 / 17:10:13 / cg"
!

makeRoomAtIndex:whereToMakeEmptySlot
    "grow the contents for inserting at whereToMakeEmptySlot.
     The whereToMakeEmptySlot argument must be a physical index within the contentsArray.
     If there is (plenty of) room at either end, elements are shifted inplace to create
     an empty slot; otherwise, a new contentsArray is allocated.
     Since this changes the logical size, the modified index is returned.
     i.e.
     #(1 2 3 4 5 6) asOrderedCollection makeRoomAtIndex:3 -> #(1 2 nil 3 4 5 6)
     #(1 2 3 4 5 6) asOrderedCollection makeRoomAtIndex:1 -> #(nil 1 2 3 4 5 6)
     #(1 2 3 4 5 6) asOrderedCollection makeRoomAtIndex:7 -> #(1 2 3 4 5 6 nil)"

    |newContents
     newSize         "{ Class:SmallInteger }"
     oldSize         "{ Class:SmallInteger }"
     first           "{ Class:SmallInteger }"
     last            "{ Class:SmallInteger }"
     index           "{ Class:SmallInteger }"
     shiftLeft shiftRight|

    oldSize := contentsArray size.
    index := whereToMakeEmptySlot.
    first := firstIndex.
    last := lastIndex.

    (first > 1) ifTrue:[
	"there is room at the beginning"

	shiftLeft := true.

	index == first ifFalse:[
	    "/ so, we'd have to copy all elements before that index
	    "/ one slot towards the containers beginning ...
	    "/ if there is also space at the end, AND the number of
	    "/ elements after the index is smaller than the number before,
	    "/ copy the remaining elements. To copy the least possible number.

	    (last - index) < (index - first) ifTrue:[
		last < oldSize ifTrue:[
		    shiftLeft := false.
		    shiftRight := true.
		]
	    ]
	]
    ] ifFalse:[
	last < oldSize ifTrue:[
	    shiftRight := true
	]
    ].

    shiftLeft == true ifTrue:[
	"there is room at the beginning"

	index == first ifFalse:[
	    contentsArray
		replaceFrom:(first - 1) to:(index - 2)
		with:contentsArray startingAt:first.
	    contentsArray at:index-1 put:nil.
	].
	firstIndex := first - 1.
	^ index - 1
    ].

    shiftRight == true ifTrue:[
	"there is room at the end"

	last := last + 1.
	index == last ifFalse:[
	    contentsArray
		replaceFrom:(index + 1) to:last
		with:contentsArray startingAt:index.
	    contentsArray at:index put:nil
	].
	lastIndex := last.
	^ index
    ].

    "/ no space at either end
    oldSize < MinContentsArraySize ifTrue:[
	newSize := MinContentsArraySize
    ] ifFalse:[
	newSize := oldSize * 2.
    ].
    newContents := Array basicNew:newSize.
    index == first ifTrue:[
	"/ if there is a lot at the end (> 50), make all new space at the beginning.
	"/ otherwise make 3/4 of the new space to the beginning, 1/4 to the end
	oldSize ~~ 0 ifTrue:[
	    (last < (oldSize - 50)) ifTrue:[
		lastIndex := newSize - (oldSize-last).
		firstIndex := lastIndex - (last - first).
	    ] ifFalse:[
		firstIndex := oldSize * 3 // 4.
		firstIndex < 2 ifTrue:[firstIndex := 2]. "/ pathological case (was explicitly allocated with size<MinSize
		lastIndex := firstIndex + (last - first).
	    ].
	    newContents
		replaceFrom:firstIndex to:lastIndex
		with:contentsArray startingAt:first.
	].
	contentsArray := newContents.
	firstIndex := firstIndex - 1.

	^ firstIndex.
    ] ifFalse:[
	oldSize ~~ 0 ifTrue:[
	    newContents
		replaceFrom:1 to:(index - first)
		with:contentsArray startingAt:first.

	    index <= last ifTrue:[
		newContents
		    replaceFrom:(index - first + 2) to:(last - first + 2)
		    with:contentsArray startingAt:index.
	    ].
	].
	contentsArray := newContents.
	firstIndex := 1.
	lastIndex := last - first + 2.

	"/ return the modified index
	^ index - (first - firstIndex).
    ].

    "Modified: / 22-10-2008 / 17:11:06 / cg"
!

makeRoomAtIndex:whereToMakeEmptySlots for:howMany
    "grow the contents for inserting at whereToMakeEmptySlot.
     The whereToMakeEmptySlot argument must be a physical index within the contentsArray.
     If there is (plenty of) room at either end, elements are shifted inplace to create
     an empty slot; otherwise, a new contentsArray is allocated.
     Since this changes the logical size, the modified index is returned.
     i.e.
     #(1 2 3 4 5 6) asOrderedCollection makeRoomAtIndex:3 for:2 -> #(1 2 nil nil 3 4 5 6)
     #(1 2 3 4 5 6) asOrderedCollection makeRoomAtIndex:1 for:2 -> #(nil nil 1 2 3 4 5 6)
     #(1 2 3 4 5 6) asOrderedCollection makeRoomAtIndex:7 for:2 -> #(1 2 3 4 5 6 nil nil)"

    |newContents
     newSize         "{ Class:SmallInteger }"
     oldSize         "{ Class:SmallInteger }"
     oneFourthOfSize "{ Class:SmallInteger }"
     first           "{ Class:SmallInteger }"
     last            "{ Class:SmallInteger }"
     index           "{ Class:SmallInteger }"
     shiftLeft shiftRight|

    oldSize := contentsArray size.
    oneFourthOfSize := (oldSize // 4).
    oneFourthOfSize == 0 ifTrue:[oneFourthOfSize := 1].
    index := whereToMakeEmptySlots.
    first := firstIndex.
    last := lastIndex.

    shiftLeft := shiftRight := false.
    ((first > howMany) and:[first > oneFourthOfSize]) ifTrue:[
	"there is room (>25%) at the beginning"
	shiftLeft := true.
    ] ifFalse:[
	((last + howMany) <= oldSize
	and:[last < (oneFourthOfSize * 3)]) ifTrue:[
	    shiftRight := true
	]
    ].

    shiftLeft == true ifTrue:[
	"there is room at the beginning"

	index == first ifFalse:[
	    contentsArray
		replaceFrom:(first - howMany)
		to:(index - howMany - 1)
		with:contentsArray
		startingAt:first.
	    contentsArray from:index-howMany to:index-1 put:nil.
	].
	firstIndex := first - howMany.
	^ index - howMany
    ].

    shiftRight == true ifTrue:[
	"there is room at the end"

	last := last + howMany.
	index == last ifFalse:[
	    contentsArray
		replaceFrom:(index + howMany)
		to:last
		with:contentsArray
		startingAt:index.
	    contentsArray from:index to:index+howMany-1 put:nil
	].
	lastIndex := last.
	^ index
    ].

    newSize := (oldSize+howMany) nextPowerOf2.
    "/ newSize := (oldSize * 2).
    "/ [newSize < (oldSize+howMany)] whileTrue:[
    "/    newSize := (newSize * 2) max:howMany
    "/ ].

    newContents := Array basicNew:newSize.
    oldSize ~~ 0 ifTrue:[
	index > first ifTrue:[
	    newContents
		replaceFrom:1
		to:(index - first)
		with:contentsArray
		startingAt:first.
	].
	index <= last ifTrue:[
	    newContents
		replaceFrom:(index - first + howMany + 1)
		to:(last - first + howMany + 1)
		with:contentsArray
		startingAt:(index).
	].
    ].
    contentsArray := newContents.
    firstIndex := 1.
    lastIndex := last - first + howMany + 1.

    "/ return the modified index
    ^ index - (first - firstIndex).

    "Modified: 15.4.1997 / 12:34:16 / cg"
!

makeRoomAtLast
    "grow/shift the contents for more room at the end.
     Does not change the logical size.
     i.e.
     #(1 2 3 4 5 6) -> #(1 2 3 4 5 6 nil)"

    |newContents
     oldSize    "{ Class:SmallInteger }"
     newSize    "{ Class:SmallInteger }"
     startIndex "{ Class:SmallInteger }"
     sz         "{ Class:SmallInteger }"|

    oldSize := contentsArray size.
    sz := lastIndex - firstIndex + 1.

    "
     if there is lots of room at the beginning (> 50%),
     shift instead of growing. This helps collections which get
     elements removed at front and added at the end.
    "
    oldSize > (sz * 2) ifTrue:[
	startIndex := firstIndex // 4.
	startIndex == 0 ifTrue:[
	    startIndex := 1
	].
	contentsArray
	    replaceFrom:startIndex to:startIndex + sz - 1
	    with:contentsArray startingAt:firstIndex.
	contentsArray from:startIndex + sz to:lastIndex put:nil.
	firstIndex := startIndex.
	lastIndex := startIndex + sz - 1.
	^ self
    ].
    oldSize == 0 ifTrue:[
	newSize := MinContentsArraySize
    ] ifFalse:[
	newSize := oldSize * 2.
    ].
    newContents := Array basicNew:newSize.
    oldSize ~~ 0 ifTrue:[
	newContents
	    replaceFrom:1 to:oldSize
	    with:contentsArray startingAt:1.
    ].
    contentsArray := newContents

    "Modified: / 22-10-2008 / 11:50:28 / cg"
!

setFirstIndex:newFirstIndex lastIndex:newLastIndex
    "set first and last index"

    firstIndex := newFirstIndex.
    lastIndex := newLastIndex.
!

setIndices
    "added for VW compatibility: set the indices for an empty collection"

    firstIndex := 1.
    lastIndex := 0.
! !

!OrderedCollection methodsFor:'private-accessing'!

contentsArray
    "return the orderedCollections underlying contentsArray.
     The actual elements are found here starting at firstIndex,
     and ending at lastIndex."

    ^ contentsArray
!

firstIndex
    "return the index of my first element in my underlying contentsArray.
     The actual elements are found starting this index,
     and ending at lastIndex."

    ^ firstIndex
! !

!OrderedCollection methodsFor:'queries'!

capacity
    "return the number of elements, that the receiver is prepared to take
     without growing. 
     Notice, that OCs do automatically resize as required, 
     so knowing the capacity is of no real use.
     Not used by the system; added for ST-80 compatibility."

    ^ contentsArray size
!

size
    "return the number of elements in the collection"

    ^ lastIndex - firstIndex + 1
! !

!OrderedCollection methodsFor:'searching'!

identityIndexOf:anObject
    "return the index of anObject or 0 if not found. Compare using =="

    |index|

    index := contentsArray
		identityIndexOf:anObject
		startingAt:firstIndex
		endingAt:lastIndex.
    index == 0 ifTrue:[^ 0].
    ^ index - firstIndex + 1

    "Modified: 12.4.1996 / 17:58:25 / cg"
!

identityIndexOf:anObject startingAt:startIndex
    "return the index of anObject, starting search at startIndex.
     Compare using ==; return 0 if not found in the collection"

    |index|

    index := contentsArray
		identityIndexOf:anObject
		startingAt:(startIndex + firstIndex - 1)
		endingAt:lastIndex.
    index == 0 ifTrue:[^ 0].
    ^ index - firstIndex + 1

    "Modified: 12.4.1996 / 17:58:19 / cg"
!

indexOf:anObject
    "return the index of anObject or 0 if not found in the collection.
     Compare using ="

    |index|

    index := contentsArray
		indexOf:anObject
		startingAt:firstIndex
		endingAt:lastIndex.
    index == 0 ifTrue:[^ 0].
    ^ index - firstIndex + 1

    "
     |c|

     c := OrderedCollection new:10000.
     c add:10; add:20; add:30.
     c indexOf:99
    "

    "
     |c|

     c := OrderedCollection new:10000.
     c add:10; add:20; add:30.
     c indexOf:30
    "

    "Modified: 12.4.1996 / 17:57:54 / cg"
!

indexOf:anObject ifAbsent:exceptionValue
    "return the index of anObject or 0 if not found in the collection.
     Compare using =
     If the receiver does not contain anElement,
     return the result of evaluating the argument, exceptionBlock."

    |index|

    index := contentsArray
		indexOf:anObject
		startingAt:firstIndex
		endingAt:lastIndex.
    index == 0 ifTrue:[^ exceptionValue value].
    ^ index - firstIndex + 1

    "
     |c|

     c := OrderedCollection new:10000.
     c add:10; add:20; add:30.
     c indexOf:99 ifAbsent:'nope'
    "

    "
     |c|

     c := OrderedCollection new:10000.
     c add:10; add:20; add:30.
     c indexOf:30 ifAbsent:'nope'
    "
!

indexOf:anObject startingAt:startIndex
    "return the index of anObject, starting search at startIndex.
     Compare using =; return 0 if not found in the collection"

    |index|

    index := contentsArray
		indexOf:anObject
		startingAt:(startIndex + firstIndex - 1)
		endingAt:lastIndex.
    index == 0 ifTrue:[^ 0].
    ^ index - firstIndex + 1

    "
     |c|

     c := OrderedCollection new:10000.
     c add:1; add:2; add:3.
     c indexOf:4 startingAt:5
    "

    "Modified: 12.4.1996 / 17:58:53 / cg"
! !

!OrderedCollection methodsFor:'testing'!

includes:anObject
    "return true if anObject is in the collection. Compare using ="

    ^ (contentsArray
		indexOf:anObject
		startingAt:firstIndex
		endingAt:lastIndex) ~~ 0

    "Modified: 12.4.1996 / 17:57:27 / cg"
!

includesIdentical:anObject
    "return true if anObject is in the collection. Compare using =="

    ^ (contentsArray
		identityIndexOf:anObject
		startingAt:firstIndex
		endingAt:lastIndex) ~~ 0

    "Modified: 12.4.1996 / 17:57:09 / cg"
!

isEmpty
    "return true, if the receiver has no elements"

    ^ lastIndex < firstIndex
!

isEmptyOrNil
    "return true, if the receiver has no elements"

    ^ lastIndex < firstIndex
!

isFixedSize
    "return true if the receiver cannot grow - this will vanish once
     Arrays and Strings learn how to grow ..."

    ^ false
!

isOrderedCollection
    "return true, if the receiver is some kind of ordered collection (or list etc);
     true is returned here - the method is only redefined in Object."

    ^ true


!

notEmpty
    "return true, if the receiver has any elements"

    ^ lastIndex >= firstIndex
! !

!OrderedCollection methodsFor:'tuning'!

quickSortFrom:inBegin to:inEnd
    self class == OrderedCollection ifTrue:[
	"/ because array-at/at:put: is much faster, this speeds up sorting by
	"/ up to 30%
	contentsArray
	    quickSortFrom:(firstIndex + inBegin - 1)
	    to:(firstIndex + inEnd - 1)
    ] ifFalse:[
	super quickSortFrom:inBegin to:inEnd
    ].
!

quickSortFrom:inBegin to:inEnd sortBlock:sortBlock
    self class == OrderedCollection ifTrue:[
	"/ because array-at/at:put: is much faster, this speeds up sorting by
	"/ up to 30%
	contentsArray
	    quickSortFrom:(firstIndex + inBegin - 1)
	    to:(firstIndex + inEnd - 1)
	    sortBlock:sortBlock
    ] ifFalse:[
	super quickSortFrom:inBegin to:inEnd sortBlock:sortBlock
    ]
! !

!OrderedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


OrderedCollection initialize!

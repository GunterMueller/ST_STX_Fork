"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#Heap
	instanceVariableNames:'array tally sortBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

Heap comment:'Class Heap implements a special data structure commonly referred to as ''heap''. Heaps are more efficient than SortedCollections if:
a) Elements are only removed at the beginning
b) Elements are added with arbitrary sort order.
The sort time for a heap is O(n log n) in all cases.
Instance variables:
	array		<Array>		the data repository
	tally		<Integer>	the number of elements in the heap
	sortBlock	<Block|nil>	a two-argument block defining the sort order,
							or nil in which case the default sort order is
								[:element1 :element2| element1 <= element2]'
!


!Heap class methodsFor:'instance creation'!

new
	^self new: 10
!

new: n
	^super new setCollection: (Array new: n)
!

sortBlock: aBlock
	"Create a new heap sorted by the given block"
	^self new sortBlock: aBlock
!

withAll: aCollection
        "Create a new heap with all the elements from aCollection"
        ^(self basicNew)
                setCollection: aCollection asNewArray tally: aCollection size;
                reSort;
                yourself
!

withAll: aCollection sortBlock: sortBlock
        "Create a new heap with all the elements from aCollection"
        ^(self basicNew)
                setCollection: aCollection asNewArray tally: aCollection size;
                sortBlock: sortBlock;
                yourself
! !

!Heap class methodsFor:'examples'!

documentation
"
    Class Heap implements a special data structure commonly referred to as 'heap'.
    Heaps are more efficient than SortedCollections if:
        a) Elements are only removed at the beginning
        b) Elements are added with arbitrary sort order.

    The sort time for a heap is O(n log n) in all cases.
    Instance variables:
        array           <Array>         the data repository
        tally           <Integer>       the number of elements in the heap
        sortBlock       <Block|nil>     a two-argument block defining the sort order,
                                        or nil in which case the default sort order is
                                            [:element1 :element2| element1 <= element2]
"

    "Created: / 31-05-2007 / 14:53:44 / cg"
!

examples
"
    Create a sorted collection of numbers, remove the elements
    sequentially and add new objects randomly.
    Note: This is the kind of benchmark a heap is designed for.
                                                                             [exBegin]
        | n rnd array time sorted |
        n := 50000. 
        rnd := Random new.
        array := (1 to: n) collect:[:i| rnd next].

        time := Time millisecondsToRun:[
                sorted := Heap withAll: array.
                1 to: n do:[:i| 
                        sorted removeFirst.
                        sorted add: rnd next].
        ].
        Transcript showCR:'Time for Heap: ', time printString,' msecs'.

        time := Time millisecondsToRun:[
                sorted := SortedCollection withAll: array.
                1 to: n do:[:i| 
                        sorted removeFirst.
                        sorted add: rnd next].
        ].
        Transcript showCR:'Time for SortedCollection: ', time printString,' msecs'.
                                                                             [exEnd]

    Sort a random collection of Floats and compare the results with
    SortedCollection (using the quick-sort algorithm) and 
                                                                             [exBegin]
        | n rnd array out time sorted |
        n := 40000. 
        rnd := Random new.
        array := (1 to: n) collect:[:i| rnd next].

        out := Array new: n. 
        time := Time millisecondsToRun:[
                sorted := Heap withAll: array.
                1 to: n do:[:i| sorted removeFirst].
        ].
        Transcript showCR:'Time for heap-sort: ', time printString,' msecs'.

        time := Time millisecondsToRun:[
                sorted := SortedCollection withAll: array.
        ].
        Transcript showCR:'Time for quick-sort: ', time printString,' msecs'.
                                                                             [exEnd]
"

    "Created: / 31-05-2007 / 14:46:59 / cg"
! !

!Heap methodsFor:'accessing'!

at: index
        "Return the element at the given position within the receiver"
        (index < 1 or:[index > tally]) ifTrue:[^self subscriptBoundsError: "errorSubscriptBounds:" index].
        ^array at: index

    "Modified: / 31-05-2007 / 14:44:58 / cg"
!

at: index put: newObject
	"Heaps are accessed with #add: not #at:put:"
	^self shouldNotImplement
!

first
    "Return the first element in the receiver"

    self isEmpty ifTrue:[
       ^ self emptyCollectionError.
    ].
    ^ array at: 1

    "
      Heap new first
    "
!

firstOrNil
	tally = 0 ifTrue:[^nil] ifFalse:[^array at: 1]
!

reSort
	"Resort the entire heap"
	self isEmpty ifTrue:[^self].
	tally // 2 to: 1 by: -1 do:[:i| self downHeap: i].
!

size
	"Answer how many elements the receiver contains."

	^ tally
!

sortBlock
	^sortBlock
!

sortBlock: aBlock
	sortBlock := aBlock.
	sortBlock fixTemps.
	self reSort.
! !

!Heap methodsFor:'adding'!

add: anObject
    "Include newObject as one of the receiver's elements. Answer newObject."
    tally = array size ifTrue:[self grow].
    array at: (tally := tally + 1) put: anObject.
    self upHeap: tally.
    ^anObject
! !

!Heap methodsFor:'comparing'!

= anObject

	^ self == anObject
		ifTrue: [true]
		ifFalse: [anObject isHeap
			ifTrue: [sortBlock = anObject sortBlock and: [super = anObject]]
			ifFalse: [super = anObject]]
! !

!Heap methodsFor:'enumerating'!

do: aBlock
	"Evaluate aBlock with each of the receiver's elements as the argument."
	1 to: tally do:[:i| aBlock value: (array at: i)]
! !

!Heap methodsFor:'growing'!

grow
	"Become larger."
	self growTo: self size + self growSize.
!

growSize
	"Return the size by which the receiver should grow if there are no empty slots left."
	^array size max: 5
!

growTo: newSize
	"Grow to the requested size."
	| newArray |
	newArray := Array new: (newSize max: tally).
	newArray replaceFrom: 1 to: array size with: array startingAt: 1.
	array := newArray
!

trim
	"Remove any empty slots in the receiver."
	self growTo: self size.
! !

!Heap methodsFor:'private'!

array
	^array
!

privateRemoveAt: index
    "Remove the element at the given index and make sure the sorting order is okay.
     Return the removed object"

    | removed |

    removed := array at: index.
    array at: index put: (array at: tally).
    array at: tally put: nil.
    tally := tally - 1.
    index > tally ifFalse:[
        "Use #downHeapSingle: since only one element has been removed"
        self downHeapSingle: index
    ].
    ^removed
!

setCollection: aCollection
	array := aCollection.
	tally := 0.
!

setCollection: aCollection tally: newTally
	array := aCollection.
	tally := newTally.
!

species
	^ Array
! !

!Heap methodsFor:'private-heap'!

downHeap: anIndex
	"Check the heap downwards for correctness starting at anIndex.
	 Everything above (i.e. left of) anIndex is ok."
	| value k n j |
	anIndex = 0 ifTrue:[^self].
	n := tally bitShift: -1.
	k := anIndex.
	value := array at: anIndex.
	[k <= n] whileTrue:[
		j := k + k.
		"use max(j,j+1)"
		(j < tally and:[self sorts: (array at: j+1) before: (array at: j)])
				ifTrue:[ j := j + 1].
		"check if position k is ok"
		(self sorts: value before: (array at: j)) 
			ifTrue:[	"yes -> break loop"
					n := k - 1]
			ifFalse:[	"no -> make room at j by moving j-th element to k-th position"
					array at: k put: (array at: j).
					"and try again with j"
					k := j]].
	array at: k put: value.
!

downHeapSingle: anIndex
	"This version is optimized for the case when only one element in the receiver can be at a wrong position. It avoids one comparison at each node when travelling down the heap and checks the heap upwards after the element is at a bottom position. Since the probability for being at the bottom of the heap is much larger than for being somewhere in the middle this version should be faster."
	| value k n j |
	anIndex = 0 ifTrue:[^self].
	n := tally bitShift: -1.
	k := anIndex.
	value := array at: anIndex.
	[k <= n] whileTrue:[
		j := k + k.
		"use max(j,j+1)"
		(j < tally and:[self sorts: (array at: j+1) before: (array at: j)])
				ifTrue:[	j := j + 1].
		array at: k put: (array at: j).
		"and try again with j"
		k := j].
	array at: k put: value.
	self upHeap: k
!

upHeap: anIndex
	"Check the heap upwards for correctness starting at anIndex.
	 Everything below anIndex is ok."
	| value k kDiv2 tmp |
	anIndex = 0 ifTrue:[^self].
	k := anIndex.
	value := array at: anIndex.
	[ (k > 1) and:[self sorts: value before: (tmp := array at: (kDiv2 := k bitShift: -1))] ] 
		whileTrue:[
			array at: k put: tmp.
			k := kDiv2].
	array at: k put: value.
! !

!Heap methodsFor:'removing'!

remove: oldObject ifAbsent: aBlock
    "Remove the first occurrence of oldObject as one of the receiver's elements. 
     If several of the elements are equal to oldObject, only one is removed. 
     If no element is equal to oldObject, answer the result of evaluating anExceptionBlock. 
     Otherwise, answer the removed object
     (which may be non-identical, but equal to oldObject)"
     
    1 to: tally do:[:i| 
        (array at: i) = oldObject ifTrue:[^self privateRemoveAt: i]
    ].
    ^aBlock value
!

removeAt: index
        "Remove the element at given position"
        (index < 1 or:[index > tally]) ifTrue:[^self subscriptBoundsError: "errorSubscriptBounds:" index].
        ^self privateRemoveAt: index

    "Modified: / 31-05-2007 / 14:45:42 / cg"
!

removeFirst
	"Remove the first element from the receiver"
	^self removeAt: 1
!

removeIdentical: oldObject ifAbsent: aBlock
    "Remove the first occurrence of oldObject as one of the receiver's elements. 
     If oldObject is present multiple times, only the first occurrence is removed. 
     If oldObject is not present, answer the result of evaluating anExceptionBlock. 
     Otherwise, answer the argument, oldObject."
     
    1 to: tally do:[:i| 
        (array at: i) == oldObject ifTrue:[^self privateRemoveAt: i]
    ].
    ^aBlock value
! !

!Heap methodsFor:'testing'!

isEmpty
	"Answer whether the receiver contains any elements."
	^tally = 0
!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

isHeap

	^ true
!

sorts: element1 before: element2
        "Return true if element1 should be sorted before element2.
        This method defines the sort order in the receiver"
        
        ^sortBlock isNil
                ifTrue:[element1 <= element2]
                ifFalse:[sortBlock value: element1 value: element2].
! !

!Heap class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


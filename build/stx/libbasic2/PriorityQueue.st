"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#PriorityQueue
	instanceVariableNames:'size maxSize heap comparator'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered'
!

!PriorityQueue class methodsFor:'documentation'!

documentation
"
    a priority queue is a collection with a given maximum size
    which only keeps the maxSize largest values.
    Only up to maxSize elements are stored at any time.
    The internal organization is a heap; 
    eg. elements are not kept sorted internally.

    When elements are added, a check is made, 
    if the new element should be kept or not.

    Finally, when all elements have been added,
    get the elements in sorted order by repeated calls to removeFirst,
    which will remove and return the smallest element.

    [author:]
        Claus Gittinger
"
!

examples
"
  find the 10 largest files in the stx source tree
                                                            [exBegin]
    |pq dir|

    pq := PriorityQueue new:10 comparator:[:a :b | a fileSize > b fileSize].
    dir := '../../' asFilename.
    dir directoryContentsAsFilenamesDo:[:eachLib |
        (eachLib baseName startsWith:'lib') ifTrue:[
            eachLib filesWithSuffix:'st' do:[:fn |
                pq add:fn
            ].
        ].
    ].
    [ pq notEmpty ] whileTrue:[
        |next|

        next := pq removeFirst.
        Transcript show:next fileSize; space; showCR:next pathName
    ].
                                                            [exEnd]

  generate 1 million random numbers and show the 10 largest
                                                            [exBegin]
    |pq|

    pq := PriorityQueue new:10.
    1000000 timesRepeat:[
        pq add:(Random nextInteger).
    ].
    [ pq notEmpty ] whileTrue:[
        Transcript showCR:pq removeFirst.
    ].
                                                            [exEnd]

  a little test
                                                            [exBegin]
    |pq|

    #(10 20 30 40 50 60 70 80) permutationsDo:[:p |
        pq := PriorityQueue new:5.
        pq addAll:p.
        self assert:(pq contents copy sort = #(40 50 60 70 80)).
    ].
                                                            [exEnd]
"
! !

!PriorityQueue class methodsFor:'instance creation'!

new:maxSize
    "retun a new PriorityQueue, which holds at most maxNode elements,
     the largest one's added"

    ^ self new initializeFor:maxSize
!

new:maxSize comparator:aBlock
    "retun a new PriorityQueue, which holds at most maxNode elements,
     the largest one's added"

    ^ self new initializeFor:maxSize comparator:aBlock
! !

!PriorityQueue methodsFor:'adding'!

add:anElement
    "if the argument is larger than the currently smallest element,
     then add it and remove the smallest.
     Otherwise do nothing"

    size < maxSize ifTrue:[
        size := size + 1.
        heap at:size put:anElement.
        self upHeap.
    ] ifFalse:[
        (comparator value:anElement value:(heap at:1)) ifTrue:[
            heap at:1 put:anElement.
            self downHeap.
        ].
    ]

    "
     |pq|

     pq := PriorityQueue new:5.
     pq add:1.
     pq add:10.
     pq add:5.
     pq add:9.
     pq add:17.
     pq add:-1.
     pq add:29.
     pq
    "
!

isEmpty
    ^ size == 0
!

size
    ^ size
! !

!PriorityQueue methodsFor:'enumerating'!

do:aBlock
    heap from:1 to:size do:aBlock
! !

!PriorityQueue methodsFor:'initialization'!

comparator:aBlock
    comparator := aBlock
!

initializeFor:maxSizeArg
    self assert:(maxSizeArg > 0).

    heap := Array new:maxSizeArg.
    maxSize := maxSizeArg.
    size := 0.
    comparator := [:a :b | a > b].
!

initializeFor:maxSizeArg comparator:aBlock
    self initializeFor:maxSizeArg.
    comparator := aBlock
! !

!PriorityQueue methodsFor:'private'!

contents
    "return the current contents.   
     It is not sorted by size, but a heap structure"

    ^ heap
!

downHeap
    "an element was added at the bottom of the heap;
     shift it to its place"

    |i j k node|

    i := 1.
    node := heap at:i.
    j := i * 2.
    k := j + 1.
    ((k <= size) and:[ comparator value:(heap at:j) value:(heap at:k)]) ifTrue:[
        j := k
    ].

    [ (j <= size) and:[ comparator value:node value:(heap at:j) ]] whileTrue:[
        heap at:i put:(heap at:j).
        i := j.
        j := j * 2.
        k := j + 1.
        ((k <= size) and:[ comparator value:(heap at:j) value:(heap at:k)]) ifTrue:[
            j := k
        ].
    ].
    heap at:i put:node
!

upHeap
    "an element was added to the top of the heap;
     shift it to its place"

    |i j node|

    i := size.
    node := heap at:i.
    j := i // 2.
    [ (j > 0) and:[ comparator value:(heap at:j) value:node ]] whileTrue:[
        heap at:i put:(heap at:j).
        i := j.
        j := j // 2
    ].
    heap at:i put:node
! !

!PriorityQueue methodsFor:'removing'!

removeAll
    size := 0
!

removeFirst
    "removes and returns the smallest element from the priority queue"

    |rslt|

    size == 0 ifTrue:[ self emptyCollectionError ].

    rslt := heap at:1.
    heap at:1 put:(heap at:size).
    size := size - 1.
    self downHeap.
    ^ rslt
! !

!PriorityQueue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


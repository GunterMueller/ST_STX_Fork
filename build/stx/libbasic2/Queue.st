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
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#Queue
	instanceVariableNames:'contentsArray readPosition writePosition tally'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered'
!

!Queue class methodsFor:'documentation'!

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
    Queues provide a simple implementation of a collection,
    where elements are added at one end and removed at the other.

    Access protocol is somewhat like a stream's protocol, 
    i.e. access is by #nextPut: and #next.

    The queue is created with a size argument, defining how many elements
    are to be stored. It will report an error if the queue ever becomes full
    and another element is to be added. 
    Likewise, it will report an error if it is empty and an element is to be removed.

    It is NOT safe when two processes access the same queue-instance simultaneously,
    since accesses to the internals are not protected against process-switches.
    See SharedQueue for a class which IS safe w.r.t. processes and which blocks
    on write when full or on read when empty.

    [Implementation note:]
        All of queue's functionality is also provided by the OrderedCollection (OC)
        class; OC could easily simulate a queue (using #addLast: / #removeFirst).
        The reason for providing Queue is not any speed advantage
        (actually, OC seems to be even a tiny bit faster).
        The point is that an implementation of SharedQueue as a subclass of OC
        would require that many OC methods had to be blocked and/or redefined in
        such a subclass, to care for simultaneous access.
        Since queue implements a much more lightweight protocol,
        the sharedQueue implementation is much cleaner when based on this more
        lightweight Queue class.

    [author:]
        Claus Gittinger
"
!

examples
"
  adding at one end, removing at the other ...
                                                        [exBegin]
    |q element  |

    q := Queue new:10.
    1 to:5 do:[:i |
        Transcript showCR:('adding ' , i printString).
        q nextPut:i
    ].

    [q notEmpty] whileTrue:[
        element := q next.
        Transcript showCR:('removed ' , element printString).
    ].
                                                        [exEnd]



  timing; Queue vs. OrderedCollection
                                                        [exBegin]
    |q oc tQueue tOC  |

    q := Queue new:100.
    tQueue := Time millisecondsToRun:[
        1000 timesRepeat:[
            1 to:100 do:[:i |
                q nextPut:i
            ].
            [q isEmpty] whileFalse:[
                q next
            ].
        ]
    ].

    oc := OrderedCollection new:100.
    tOC := Time millisecondsToRun:[
        1000 timesRepeat:[
            1 to:100 do:[:i |
                oc addLast:i
            ].
            [oc isEmpty] whileFalse:[
                oc removeFirst
            ].
        ]
    ].
    Transcript showCR:('queue time: ' , tQueue printString , ' ms').
    Transcript showCR:('oc time   : ' , tOC printString , ' ms').
                                                        [exEnd]


"
! !

!Queue class methodsFor:'instance creation'!

new
    "return a new queue with space for some elements"

    ^ self new:50
!

new:size
    "return a new queue with space for size elements"

    ^ super new init:size

    "
     |q|

     q := Queue new.
     (1 to:5) do:[:i | q nextPut:i].
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     q nextPutAll:(6 to:10).
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript show:(q next); space.
     Transcript showCR:(q next).
    "
! !

!Queue class methodsFor:'defaults'!

defaultSize
    ^ 50
! !

!Queue methodsFor:'accessing'!

at:index
    "return an element from the queue - indexing starts at 1 with the element
     which would next be fetched"

    (index between:1 and:tally) ifFalse:[ self subscriptBoundsError:index ].
    ^ contentsArray at:((readPosition+index-1-1) \\ contentsArray size)+1.

    "
     |q|

     q := Queue new:10.
     (1 to:5) do:[:i | q add:i].
     (6 to:100) do:[:i | q removeFirst. q add:i ].
     self assert:(q at:1) = 96.
     self assert:(q at:2) = 97.
     self assert:(q at:3) = 98.
     self assert:(q at:4) = 99.
     self assert:(q at:5) = 100.
     self should:[ q at:6 ] raise:Error.
    "
!

removeAll
    "remove all elements in the queue; return the receiver"

    tally := 0.
    readPosition := writePosition := 1.
    contentsArray atAllPut:nil          "/ to help the garbage collector
!

removeIdentical:anElement ifAbsent:exceptionalValue
    "remove and return a particular element from the queue;
     Return the value from exceptionalValue if the element is not in the queue"

    |rPos "{ Class: SmallInteger }"
     wPos "{ Class: SmallInteger }"
     countRemoved
     el sz|


    (tally == 0) ifTrue:[
        ^ exceptionalValue value
    ].
    sz := contentsArray size.

    rPos := wPos := readPosition.

    countRemoved := 0.

    1 to:tally do:[:index|
        el := contentsArray at:rPos.
        el == anElement ifTrue:[
            countRemoved := countRemoved + 1.
            contentsArray at:wPos put:nil.
        ] ifFalse:[
            rPos ~~ wPos ifTrue:[
                contentsArray at:wPos put:el.
            ].
            wPos == sz ifTrue:[
                wPos := 1.
            ] ifFalse:[
                wPos := wPos + 1.
            ].
        ].
        rPos == sz ifTrue:[
            rPos := 1.
        ] ifFalse:[
            rPos := rPos + 1.
        ].
    ].
    countRemoved == 0 ifTrue:[
        ^ exceptionalValue value
    ].

    tally = countRemoved ifTrue:[
        wPos := readPosition.
    ].
    writePosition := wPos.
    tally := tally - countRemoved.
    ^ anElement

    "
     |q|

     q := Queue new:10.
     q nextPut:1; nextPut:2; nextPutAll:(3 to:10).
     q next.
     q nextPut:11.
     q next.
     q nextPut:12.
     q next.
     q removeIdentical:5.
     q

     |q|

     q := Queue new:10.
     q nextPut:1; nextPut:2; nextPutAll:(3 to:8).
     self assert:(q next == 1).
     self assert:(q next == 2).
     q removeIdentical:5.
     self assert:(q next == 3).
     self assert:(q next == 4).
     self assert:(q next == 6).
     self assert:(q next == 7).
     self assert:(q next == 8).
     self assert:(q isEmpty).
     q

     |q|

     q := Queue new:10.
     q nextPut:1; nextPut:2.
     self assert:(q next == 1).
     q removeIdentical:2.
     self assert:(q isEmpty).
     q nextPut:3.
     self assert:(q isEmpty not).
     self assert:(q next == 3).
     self assert:(q isEmpty).

     |q|

     q := Queue new:10.
     q nextPut:1; nextPut:2; nextPut:3.
     self assert:(q next == 1).
     q removeIdentical:3.
     self assert:(q isEmpty not).
     q nextPut:4.
     q removeIdentical:4.
     q nextPut:5.
     self assert:(q isEmpty not).
     self assert:(q next == 2).
     self assert:(q next == 5).
     self assert:(q isEmpty).

    "
!

removeLast
    "remove and return the last value in the queue;
     Return nil, if the queue is empty"

    |value pos "{ Class: SmallInteger }"|

    (tally == 0) ifTrue:[^ nil].

    pos := writePosition.
    pos == 1 ifTrue:[
        pos := contentsArray size
    ] ifFalse:[
        pos := pos - 1.
    ].

    value := contentsArray at:pos.
    contentsArray at:pos put:nil.       "/ to help the garbage collector
    writePosition := pos.
    tally := tally - 1.
    ^ value

    "Created: 22.6.1996 / 18:49:41 / cg"
! !

!Queue methodsFor:'accessing-protocol compatibility'!

add:someObject
    "same as #nextPut: - for protocol compatibility with other collections"

    self nextPut:someObject.
    ^ someObject
!

removeFirst
    "same as #next - for protocol compatibility with other collections"

    ^ self next

    "Created: / 27.8.1998 / 11:15:48 / cg"
! !

!Queue methodsFor:'accessing-reading'!

next
    "return the next value in the queue;
     Return nil, if the queue is empty.
     WARNING: this is an old behavior, which should be changed
     to raise an error if empty.
     It is left in here until all queue-users have been changed to
     call nextOrNil instead, to avoid breaking existing applications."

    ^ self nextOrNil
!

nextOrNil
    "return the next value in the queue;
     Return nil, if the queue is empty"

    |value pos "{ Class: SmallInteger }"|

    (tally == 0) ifTrue:[^ nil].

    pos := readPosition.

    value := contentsArray at:pos.
    contentsArray at:pos put:nil.       "/ to help the garbage collector
    pos := pos + 1.
    pos > contentsArray size ifTrue:[pos := 1].
    readPosition := pos.
    tally := tally - 1.
    ^ value
!

peek
    "return the next value in the queue without removing it.
     If the queue is empty, return nil."

    (tally == 0) ifTrue:[^ nil].
    ^ contentsArray at:readPosition.
!

peekOrNil
    "return the next value in the queue without removing it.
     If the queue is empty, return nil."

    (tally == 0) ifTrue:[^ nil].
    ^ contentsArray at:readPosition.
! !

!Queue methodsFor:'accessing-writing'!

nextPut:anObject
    "enter anObject into the queue - if the queue is full, report an error"

    |sz pos "{ Class: SmallInteger }" |

    sz := contentsArray size.
    pos := writePosition.

    (tally == sz) ifTrue:[
        self error:'queue is full' mayProceed:true.
        ^ self
    ].

    contentsArray at:pos put:anObject.
    pos := pos + 1.
    pos > sz ifTrue:[pos := 1].
    writePosition := pos.
    tally := tally + 1.
    ^ self.
!

nextPutAll:aCollection
    "enter all elements from aCollection into the queue."

    aCollection do:[:element | self nextPut:element].
    ^ self
!

nextPutFirst:anObject
    |sz pos "{ Class: SmallInteger }" |

    tally == 0 ifTrue:[
        self nextPut:anObject.
        ^ self
    ].

    sz := contentsArray size.
    (tally == sz) ifTrue:[
        self error:'queue is full' mayProceed:true.
        ^ self
    ].
    pos := readPosition - 1.
    pos < 1 ifTrue:[pos := sz].
    contentsArray at:pos put:anObject.
    readPosition := pos.

    tally := tally + 1
! !

!Queue methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for each element in the queue"

    |n   "{ Class: SmallInteger }"
     pos "{ Class: SmallInteger }"|

    pos := readPosition.
    n := tally.
    1 to:n do:[:i |
        aBlock value:(contentsArray at:pos).
        pos := pos + 1.
        pos > contentsArray size ifTrue:[
            pos := 1
        ]
    ]

    "Modified: 18.10.1997 / 16:24:01 / cg"
! !

!Queue methodsFor:'initialization'!

capacity:newSize
    "change the capacity of the queue. 
     That is the number of slots it can hold."

    |newContentsArray n1 n2|
    
    newSize < tally ifTrue:[
        "/ cannot make me smaller, if I hold at least this number of elements.
        self error:'queue cannot be resized to this size while holding more elements' mayProceed:true.
        "/ if proceeded
        ^ self
    ].
    newContentsArray := Array new:newSize.
    tally ~~ 0 ifTrue:[
        n1 := contentsArray size - readPosition + 1.
        n1 > tally ifTrue:[
            newContentsArray replaceFrom:1 to:tally with:contentsArray startingAt:readPosition.
        ] ifFalse:[
            newContentsArray replaceFrom:1 to:n1 with:contentsArray startingAt:readPosition.
            n2 := writePosition - 1.
            newContentsArray replaceFrom:n1+1 to:tally with:contentsArray startingAt:1.
        ].    
    ].    
    contentsArray := newContentsArray.
    readPosition := 1.
    writePosition := tally+1.

    "
     |q|
     1 to:10 do:[:fill |
         1 to:10 do:[:read |
             Transcript show:'fill: '; show:fill; show:' read: '; showCR:read.
             q := Queue new:10.
             fill timesRepeat:[ q nextPut: #foo ].
             read timesRepeat:[ q next ].
             q capacity:12.
             self assert:(q size == (fill-read)).
             self assert:((Array streamContents:[:s | q do:[:e |s nextPut:e]]) = (Array new:(fill-read) withAll:#foo)).
        ].    
     ].    
    "
!

init:size
    "initialize the receiver for size entries"

    contentsArray := Array new:size.
    readPosition := writePosition := 1.
    tally := 0.
! !

!Queue methodsFor:'queries'!

capacity
    "return the number of elements the queue can hold.
     Trying to add more will:
        - raise an error in queue
        - block the writer in sharedQueue
        - lead to an automatic resize in UnlimitedSharedQueue"

    ^ contentsArray size
!

size
    "return the number of elements in the queue"

    ^ tally
!

species
    "return the type of collection to be returned by collect, select etc."

    ^ OrderedCollection
! !

!Queue methodsFor:'testing'!

isEmpty
    "return true, if there are no elements in the queue"

    ^ tally == 0
!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

isFull
    "return true, if the queue is full i.e. if writing is not
     possible"

    ^ tally == contentsArray size
! !

!Queue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


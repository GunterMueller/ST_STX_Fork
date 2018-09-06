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

"{ NameSpace: Smalltalk }"

SequenceableCollection subclass:#SegmentedOrderedCollection
	instanceVariableNames:'segments maxSegmentSize tally'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!SegmentedOrderedCollection class methodsFor:'documentation'!

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
    SegmentedOrderedCollections are intended as a replacement for huge OrderedCollections or Lists.
    They keep their elements in chunks (segments), allowing for fast 
    adding/removing at either end AND relatively fast add/remove inside the collection.
    Compared to regular orderedColletions, there is not much of a difference if
    elements are added at either end.
    However, when adding/removing inner elements, the performance of SegmentedOrderedCollections
    is much better above a certain number of elements (actually quite big).

    However, notice again: 
        when only removing at either end only, an OrderedCollection is faster.

    The break-even in performance depends on the number of elements and the usage pattern.
    Consider it with (say) > 10000 elements and many adds/removes from the inside.

    This class was added to support huge selection-in-lists (>100k elements), which are
    constantly changing by adding/removing elements at arbitrary positions.

    Possibly unfinished (may need optimized search and replace).

    [author:]
        Claus Gittinger

    [see also:]
        Array OrderedCollection BTree 
"
! !

!SegmentedOrderedCollection class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

new:size
    "return an initialized instance with space for size elements.
     However, be aware that the logical size is 0"

    ^ self basicNew initialize.
! !

!SegmentedOrderedCollection methodsFor:'accessing'!

at:index
    "return the element at index, anInteger"

    |segStart segEnd|

    (index between:1 and:tally) ifFalse:[
        ^ self indexNotIntegerOrOutOfBounds:index
    ].
    segStart := 1.
    segments do:[:seg |
        segEnd := segStart + (seg size - 1).
        (index between:segStart and:segEnd) ifTrue:[
            ^ seg at:(index - segStart + 1).
        ].
        segStart := segEnd + 1.
    ].
    self error:'oops - should not be here'
!

at:index put:newElement
    "set the element at index, to be anInteger.
     Return anObject (sigh)."

    |segStart segEnd|

    (index between:1 and:tally) ifFalse:[
        ^ self indexNotIntegerOrOutOfBounds:index
    ].

    segStart := 1.
    segments do:[:seg |
        segEnd := segStart + (seg size - 1).
        (index between:segStart and:segEnd) ifTrue:[
            ^ seg at:(index - segStart + 1) put:newElement.
        ].
        segStart := segEnd + 1.
    ].
    self error:'oops - should not be here'
!

first
    "return the first element"

    tally == 0 ifTrue:[^ self emptyCollectionError].
    ^ segments first first
!

last
    "return the last element"

    tally == 0 ifTrue:[^ self emptyCollectionError].
    ^ segments last last
! !

!SegmentedOrderedCollection methodsFor:'adding & removing'!

add:anObject
    "add anObject to the end.
     Returns the object (sigh)"

    |seg|

    (seg := segments last) size >= maxSegmentSize ifTrue:[
        self splitSegmentAt:(segments size).
        seg := segments last.
    ].
    seg add:anObject.
    tally := tally + 1.
    self changed:#insert: with:tally.
    ^ anObject.
!

add:anObject beforeIndex:index
    "insert the first argument, anObject into the collection before slot index.
     Return the receiver (sigh - ST-80 compatibility).

     Notice that this modifies the receiver, NOT a copy."

    |prevSeg segStart|

    index == (tally+1) ifTrue:[
        ^ self add:anObject
    ].
    segStart := 1.
    segments do:[:seg |
        |segEnd|

        segEnd := segStart + (seg size - 1).
        (index between:segStart and:segEnd) ifTrue:[
            index == segStart ifTrue:[
                prevSeg notNil ifTrue:[
                    prevSeg size < seg size ifTrue:[
                        prevSeg add:anObject.
                        tally := tally + 1.
                        ^ anObject
                    ].
                ].
            ].
            seg add:anObject beforeIndex:(index - segStart + 1).
            tally := tally + 1.
            self changed:#insert: with:index.
            ^ anObject
        ].
        segStart := segEnd + 1.
        prevSeg := seg.
    ].
    self error:'oops - should not be here'
!

addFirst:anObject
    "add anObject to the beginning (insert as new first element)."

    |seg|

    (seg := segments first) size >= maxSegmentSize ifTrue:[
        self splitSegmentAt:1.
        seg := segments first.
    ].
    seg addFirst:anObject.
    tally := tally + 1.
    self changed:#insert: with:1
!

removeAll
    "remove all elements from the receiver. Returns the receiver."

    |prevSize|

    prevSize := tally.
    segments := OrderedCollection with:(OrderedCollection new).
    tally := 0.
    self changed:#removeFrom: with:(Array with:1 with:prevSize)

    
    "Modified: / 30-07-2013 / 19:31:05 / cg"
!

removeFirst
    "remove the first element from the collection; return the element.
     If there is no element in the receiver collection, raise an error."

    ^ self removeFirstIfAbsent:[self emptyCollectionError]
!

removeFirstIfAbsent:exceptionBlock
    "remove the first element from the collection; return the element.
     If there is no element in the receiver collection, return the value from
     exceptionBlock.
     Destructive: modifies the receiver"

    |seg el|

    tally == 0 ifTrue:[
        ^ exceptionBlock value
    ].
    seg := segments first.
    el := seg removeFirst.
    seg isEmpty ifTrue:[
        tally == 1 ifTrue:[
            segments := OrderedCollection with:(OrderedCollection new).
        ] ifFalse:[
            segments removeFirst.
        ]    
    ].
    tally := tally - 1.
    self changed:#remove: with:1.
    ^ el
!

removeFromIndex:startIndex toIndex:endIndex
    "remove the elements stored under startIndex up to and including
     the elements under stopIndex.
     Return the receiver.
     Returning the receiver here is a historic leftover - it may change.
     Please use yourself in a cascade, if you need the receiver's value
     when using this method."

    |segStart segEnd removing segIndex nextSegIndex seg|

    (startIndex between:1 and:tally) ifFalse:[
        ^ self indexNotIntegerOrOutOfBounds:startIndex
    ].
    (endIndex between:1 and:tally) ifFalse:[
        ^ self indexNotIntegerOrOutOfBounds:endIndex
    ].

    segStart := 1.
    segIndex := 1.
    removing := false.
    [
        seg := segments at:segIndex.
        nextSegIndex := segIndex + 1.

        segEnd := segStart + (seg size - 1).

        removing ifFalse:[
            "still searching for the segment"
            (startIndex between:segStart and:segEnd) ifTrue:[
                (endIndex between:segStart and:segEnd) ifTrue:[
                    seg removeFromIndex:(startIndex - segStart + 1) toIndex:(endIndex - segStart + 1).
                    seg isEmpty ifTrue:[
                        segments removeAtIndex:segIndex.
                        segments isEmpty ifTrue:[
                            segments := OrderedCollection with:(OrderedCollection new).
                        ]    
                    ].
                    tally := tally - (endIndex - startIndex + 1).
                    self changed:#removeFrom: with:(Array with:startIndex with:endIndex).
                    ^ self.
                ].
                seg removeFromIndex:(startIndex - segStart + 1).        
                seg isEmpty ifTrue:[
                    segments removeAtIndex:segIndex.
                    segments isEmpty ifTrue:[
                        segments := OrderedCollection with:(OrderedCollection new).
                    ].    
                    nextSegIndex := segIndex.    
                ].
                removing := true.
            ].
        ] ifTrue:[
            (endIndex between:segStart and:segEnd) ifTrue:[
                seg removeFromIndex:1 toIndex:(endIndex - segStart + 1).
                seg isEmpty ifTrue:[
                    segments removeAtIndex:segIndex.
                    segments isEmpty ifTrue:[
                        segments := OrderedCollection with:(OrderedCollection new).
                    ]    
                ].
                tally := tally - (endIndex - startIndex + 1).
                self changed:#removeFrom: with:(Array with:startIndex with:endIndex).
                ^ self.
            ] ifFalse:[
                "/ remove the whole segment
                segments removeAtIndex:segIndex.
                segments isEmpty ifTrue:[
                    segments := OrderedCollection with:(OrderedCollection new).
                ].    
                nextSegIndex := segIndex.
            ]
        ].
        segStart := segEnd + 1.
        segIndex := nextSegIndex.
    ] loop.
!

removeLast
    "remove the last element from the collection; return the element"

    |seg el|

    tally == 0 ifTrue:[
        ^ self emptyCollectionError
    ].
    seg := segments last.
    el := seg removeLast.
    seg isEmpty ifTrue:[
        tally == 1 ifTrue:[
            segments := OrderedCollection with:(OrderedCollection new).
        ] ifFalse:[
            segments removeLast.
        ]    
    ].
    tally := tally - 1.
    self changed:#remove: with:(1 + tally).
    ^ el
! !

!SegmentedOrderedCollection methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for every element in the collection."

    segments do:[:seg |
        seg do:aBlock
    ].
!

keysAndValuesDo:aBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both index and element as arguments."

    |idx|

    idx := 1.
    segments do:[:seg |
        seg do:[:each |
            aBlock value:idx value:each.
            idx := idx + 1.
        ]
    ].
! !

!SegmentedOrderedCollection methodsFor:'grow & shrink'!

grow:newSize
    "adjust the logical size to newSize"

    |numExtraSegments segStart segEnd segIndex seg|

    newSize == 0 ifTrue:[
        segments := OrderedCollection with:(OrderedCollection new).
        tally := 0.
        ^ self
    ].

    newSize < tally ifTrue:[
        "/ shrinking
        segStart := 1.
        segIndex := 1.
        [
            seg := segments at:segIndex.
            segEnd := segStart + (seg size - 1).
            (newSize between:segStart and:segEnd) ifTrue:[
                (segments at:segIndex) removeFromIndex:(newSize - segStart + 1 + 1).
                segments removeFromIndex:segIndex+1.
                tally := newSize.
                ^ self
            ].
            segStart := segEnd + 1.
            segIndex := segIndex + 1.
        ] loop.
        "/ not reached
    ].

    "/ growing
    numExtraSegments := (newSize - tally) // maxSegmentSize + 1.
    numExtraSegments timesRepeat:[
        segments add:((OrderedCollection new:maxSegmentSize) grow:maxSegmentSize)
    ].
    tally := newSize
! !

!SegmentedOrderedCollection methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    segments := OrderedCollection with:(OrderedCollection new).
    maxSegmentSize := 200.
    tally := 0.

    "Modified: / 30-07-2013 / 19:31:12 / cg"
! !

!SegmentedOrderedCollection methodsFor:'private'!

splitSegmentAt:segmentIndex
    |seg segSize rightPart|

    seg := segments at:segmentIndex.
    segSize := seg size.
    
    rightPart := OrderedCollection new:20.
    rightPart grow:10.
    rightPart replaceFrom:1 to:10 with:seg startingAt:(segSize - 9).

    seg removeFromIndex:(segSize - 9) toIndex:segSize.

    segments add:rightPart afterIndex:segmentIndex.
! !

!SegmentedOrderedCollection methodsFor:'queries'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

size
    "return the number of elements in the collection"

    ^ tally
! !

!SegmentedOrderedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


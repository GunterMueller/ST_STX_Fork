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

SequenceableCollection subclass:#LinkedList
	instanceVariableNames:'firstLink lastLink numberOfNodes'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Linked'
!

!LinkedList class methodsFor:'documentation'!

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
    this class implements an anchor to a list of Links.
    The data itself is held in the link elements.
    See (the abstract) Link, ValueLink and (possibly other) classes,
    which can be used as elements of a linkedList.

    LinkedList does not care for storage; all it does is handling
    chained link elements, which must respond to #nextLink/#nextLink:.
    (i.e. any object which can do this, can be used as elements of a linked list).
    An abstract superclass for linkElements is Link; a concrete class is
    ValueLink, which holds a reference to some object.

    [warning:]
        Be careful when subclassing Link, since there is a big drawback,
        which may be overlooked by beginners:
            a Link element can ONLY be in one LinkedList at a time
            - adding the same element to another LinkedList
              will remove it from the first as a side effect.
        Therefore, NEVER simply add something to a linkedList (except for
        valueLinks) unless you know what you do.
        The ST-80 implementors probably wanted this behavior, to move
        processes from the waitingList to runLists and vice versa;
        however, literature seems to not point this out enough.

    Although LinkedList is a subclass of SequenceableCollection (and therefore
    supports indexed access via at:), you should be careful in using it or
    other methods based upon at:.
    The reason is that #at: walks the linkedlist to find the indexed element
    and is therefore slow.
    This means that some linear-in-time algorithms inherited from
    SequenceableCollection become square in runtime.
    In general, if you need access via a numeric index, you better use Array,
    OrderedCollection or similar.

    For the above reasons, the system does not make heavily use of LinkedLists;
    the only good application is where elements must be repeatedly be removed
    at the front and added at the end.
    (the scheduler's process handling code does this to manage process lists.)

    [memory requirements:]
        (OBJ-HEADER + (3 * ptr-size)) * size
                    + any additional instvars due to subclassing

    [author:]
        Claus Gittinger (July 1993)

    [see also:]
        Link ValueLink Process
"
!

examples
"
                                                                        [exBegin]
    |l|

    l := LinkedList new.
    l addLast:'one'.
    l addLast:'two'.
    l addLast:'three'.
    l addLast:'four'.
    l inspect
                                                                        [exEnd]

                                                                        [exBegin]
    |l|

    l := LinkedList new.
    l addLast:(ValueLink new value:'one').
    l addLast:(ValueLink new value:'two').
    l addLast:(ValueLink new value:'three').
    l addLast:(ValueLink new value:'four').
    l inspect
                                                                        [exEnd]

                                                                        [exBegin]
    |l|

    l := LinkedList new.
    l addLast:(ValueLink new value:'one').
    l addLast:(ValueLink new value:'two').
    l addLast:(ValueLink new value:'three').
    l addLast:(ValueLink new value:'four').
    (l at:3) value inspect.        'slow operation for large lists'.
                                                                        [exEnd]


                                                                        [exBegin]
    |l link|

    l := LinkedList new.
    l addLast:(ValueLink new value:'one').
    l addLast:(ValueLink new value:'two').
    l addLast:(ValueLink new value:'three').
    l addLast:(ValueLink new value:'four').
    link := l removeFirst.
    l addLast:link.
    l inspect.
                                                                        [exEnd]
"
! !

!LinkedList class methodsFor:'instance creation'!

new
    "create and return a new LinkedList"

    ^ self basicNew initialize
! !

!LinkedList methodsFor:'accessing'!

at:index
    "return the n'th value - use of this method should be avoided,
     since it is slow to walk through the list - think about using
     another collection if you need indexed access.
     Notice:
        that many methods in SeqColl are based on at:-access,
        so other inherited methods may be very slow (showing O^2 runtime).
        It is a very bad idea to access LinkedList elements by index.
        many algorithms degenerate to poor performance if you do.
        This method is provided for protocol completeness,
        but please consider using another type of collection if you use it"

    ^ self at:index ifAbsent:[ self subscriptBoundsError:index]
!

at:index ifAbsent:exceptionValue
    "return the n'th value - use of this method should be avoided,
     since it is slow to walk through the list - think about using
     another collection if you need indexed access.
     Notice:
        that many methods in SeqColl are based on at:-access,
        so other inherited methods may be very slow (showing O^2 runtime).
        It is a very bad idea to access LinkedList elements by index.
        many algorithms degenerate to poor performance if you do.
        This method is provided for protocol completeness,
        but please consider using another type of collection if you use it"

    |theLink|

    theLink := self linkAt:index ifAbsent:[^ exceptionValue value].
    ^ theLink value

    "
     |l|

     l := LinkedList new.
     l add:'one'.
     l add:'two'.
     l add:'hello'.
     l at:3 ifAbsent:'missing'.
     l at:4 ifAbsent:'missing'.
    "
!

first
    "return the first value in the list"

    ^ self firstLink value
!

firstIfEmpty:exceptionalValue
    "return the first value in the list or exceptionlValue, if empty"

    firstLink isNil ifTrue:[^ exceptionalValue value].
    ^ firstLink value
!

firstLink
    "return the first node in the list"

    firstLink isNil ifTrue:[^ self emptyCollectionError].
    ^ firstLink
!

firstLinkIfEmpty:exceptionalValue
    "return the first node in the list or exceptionlValue, if empty"

    firstLink isNil ifTrue:[^ exceptionalValue value].
    ^ firstLink
!

last
    "return last value in the list"

    lastLink isNil ifTrue:[^ self emptyCollectionError].
    ^ lastLink value
!

lastLink
    "return last node in the list"

    lastLink isNil ifTrue:[self emptyCollectionError].
    ^ lastLink
!

linkAt:index ifAbsent:exceptionBlock
    "return the n'th link - use of this method should be avoided,
     since it is slow to walk through the list - think about using
     another collection if you need indexed access.
     Notice:
        that many methods in the superclass, SequenceableCollection are based on at:-access,
        so other inherited methods may be very slow (showing O^2 runtime).
        It is a very bad idea to access LinkedList elements by index.
        many algorithms degenerate to poor performance if you do.
        This method is provided for protocol completeness,
        but please consider using another type of collection if you use it"

    |theLink
     count "{Class: SmallInteger}"|

    count := index.
    (count < 1 or:[count > numberOfNodes]) ifTrue:[
        ^ exceptionBlock value.
    ].

    theLink := firstLink.
    count-1 timesRepeat:[
        theLink isNil ifTrue:[^ exceptionBlock value].
        theLink := theLink nextLink.
    ].
    ^ theLink
! !

!LinkedList methodsFor:'adding & removing'!

add:aLinkOrAnyOtherObject
    "adds aLink to the end of the sequence. Returns aLink"

    |newLink|

    newLink := aLinkOrAnyOtherObject asLink.
    
    newLink nextLink:nil.
    lastLink isNil ifTrue:[
        firstLink := newLink
    ] ifFalse: [
        lastLink nextLink:newLink
    ].
    lastLink := newLink.
    numberOfNodes := numberOfNodes + 1.
    ^ newLink
!

add:aLinkOrAnyOtherObject after:aLinkOrValue
    "adds aLinkOrAnyOtherObject after another aLinkOrValue. 
     If aLinkOrValue is nil, linkToAdd is inserted at the beginning.
     If aLinkOrValue is not in the list, linkToAdd is added at the end.
     Returns aLinkOrAnyOtherObject."

    |this linkToAdd linkOrValue|

    aLinkOrValue isNil ifTrue:[^ self addFirst:aLinkOrAnyOtherObject ].

    linkToAdd := aLinkOrAnyOtherObject asLink.
    linkOrValue := aLinkOrValue value.
    
    this := firstLink.
    [this notNil and:[this ~~ linkOrValue]] whileTrue:[
        this := this nextLink
    ].
    this isNil ifTrue:[^ self add:linkToAdd ].
    linkToAdd nextLink:(this nextLink).
    this nextLink:linkToAdd.
    numberOfNodes := numberOfNodes + 1.
    ^ linkToAdd
!

addFirst:aLinkOrAnyOtherObject
    "adds aLink to the beginning of the sequence. Returns aLink"

    |linkToAdd|

    linkToAdd := aLinkOrAnyOtherObject asLink.

    firstLink isNil ifTrue:[
        lastLink := linkToAdd.
    ].
    linkToAdd nextLink:firstLink.
    firstLink := linkToAdd.
    numberOfNodes := numberOfNodes + 1.
    ^ linkToAdd
!

remove:aLinkOrValue ifAbsent:exceptionBlock
    "remove the argument, aLinkOrValue from the sequence and return it;
     if absent, evaluate the exceptionBlock."

    |prevNode nextNode thisNode linkOrValue|

    linkOrValue := aLinkOrValue value.
    thisNode := firstLink.
    [thisNode notNil] whileTrue:[
        nextNode := thisNode nextLink.
        (thisNode value = linkOrValue) ifTrue:[
            prevNode isNil ifTrue:[
                firstLink := nextNode
            ] ifFalse:[
                prevNode nextLink:nextNode
            ].
            nextNode isNil ifTrue:[
                lastLink := prevNode
            ].
            numberOfNodes := numberOfNodes - 1.
            thisNode nextLink:nil.
            ^ thisNode value
        ].
        prevNode := thisNode.
        thisNode := nextNode
    ].
    ^ exceptionBlock value

    "Created: / 30-11-2010 / 13:38:25 / cg"
!

removeAll
    "remove all elements from the sequence. Returns the receiver."

    firstLink := lastLink := nil.
    numberOfNodes := 0

    "Created: 21.3.1996 / 15:24:38 / cg"
    "Modified: 12.4.1996 / 13:34:53 / cg"
!

removeFirst
    "remove and return the first node from the sequence"

    |link|

    firstLink isNil ifTrue:[
	^ self emptyCollectionError
    ].
    link := firstLink.
    firstLink := firstLink nextLink.
    firstLink isNil ifTrue:[
	lastLink := nil
    ].
    link nextLink:nil.
    numberOfNodes := numberOfNodes - 1.
    ^ link
!

removeIdentical:aLinkOrValue ifAbsent:exceptionBlock
    "remove the argument, aLinkOrValue from the sequence and return it;
     if absent, evaluate the exceptionBlock."

    |prevNode nextNode thisNode linkOrValue|

    linkOrValue := aLinkOrValue value.
    thisNode := firstLink.
    [thisNode notNil] whileTrue:[
        nextNode := thisNode nextLink.
        (thisNode value == linkOrValue) ifTrue:[
            prevNode isNil ifTrue:[
                firstLink := nextNode
            ] ifFalse:[
                prevNode nextLink:nextNode
            ].
            nextNode isNil ifTrue:[
                lastLink := prevNode
            ].
            numberOfNodes := numberOfNodes - 1.
            thisNode nextLink:nil.
            ^ thisNode value
        ].
        prevNode := thisNode.
        thisNode := nextNode
    ].
    ^ exceptionBlock value

    "Created: / 30-11-2010 / 13:38:25 / cg"
!

removeLast
    "remove the last link element and return it;
     if empty, raise an exception."

    |nextNode thisNode|

    thisNode := firstLink.
    thisNode isNil ifTrue:[
        ^ self emptyCollectionError
    ].
    thisNode == lastLink ifTrue:[
        firstLink := lastLink := nil.
        numberOfNodes := 0.
        ^ thisNode
    ].

    [
        nextNode := thisNode nextLink.
        nextNode == lastLink ifTrue:[
            firstLink == lastLink ifTrue:[
                firstLink := thisNode
            ].
            lastLink := thisNode.
            numberOfNodes := numberOfNodes - 1.
            thisNode nextLink:nil.
            ^ nextNode.
        ].
        thisNode := nextNode
    ] loop.
! !

!LinkedList methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock with 1 arg for every value element in the list"

    |thisNode|

    "aBlock may add elements, so do not use 'numberOfNodes-1 timesRepeat:[]'"
    thisNode := firstLink.
    [thisNode notNil] whileTrue:[
        aBlock value:thisNode value.
        thisNode := thisNode nextLink
    ]
!

linksDo:aBlock
    "evaluate the argument, aBlock with 1 arg for every link element in the list"

    |thisNode|

    "aBlock may add elements, so do not use 'numberOfNodes-1 timesRepeat:[]'"
    thisNode := firstLink.
    [thisNode notNil] whileTrue:[
        aBlock value:thisNode.
        thisNode := thisNode nextLink
    ]
!

printElementsDo:aBlock
    "perform aBlock (1 arg) for all elements.
     Used in #printOn:."

    ^ self linksDo:aBlock
! !

!LinkedList methodsFor:'initialization'!

initialize
    numberOfNodes := 0
! !

!LinkedList methodsFor:'queries'!

size
    "return the size of the LinkedList i.e. the number of nodes"

    ^ numberOfNodes
! !

!LinkedList methodsFor:'searching-equality'!

indexOf:aLinkOrValue startingAt:start
    "search the collection for aLinkOrValue, starting the search at index start;
     if found, return the index otherwise return 0. 
     Here, index is defined as the link-node's position in the list.
     The comparison is done using = (i.e. equality test - not identity test).
     Warning: 
        it is a very bad idea to access LinkedList elements by index.
        many algorithms degenerate to poor performance if you do.
        This method is provided for protocol completeness,
        but please consider using another type of collection if you use it.
     "

    |theNode count "{ Class: SmallInteger }"
     linkOrValue|

    count := start.
    (count < 1 or:[count > numberOfNodes]) ifTrue:[
        ^ 0.
    ].

    theNode := firstLink.
    count-1 timesRepeat:[
        theNode isNil ifTrue:[^ 0].     "reached the end"
        theNode := theNode nextLink.
    ].

    linkOrValue := aLinkOrValue value.

    [theNode notNil] whileTrue:[
        (linkOrValue = theNode value) ifTrue:[^ count].
        theNode := theNode nextLink.
        count := count + 1.
    ].                                  "reached the end"
    ^ 0

    "
     |l|

     l := LinkedList new.
     l indexOf:'hello' startingAt:1
    "

    "
     |l v|

     l := LinkedList new.
     l add:(ValueLink new value:'one').
     l add:(ValueLink new value:'two').
     l add:(v := ValueLink new value:'hello').
     l indexOf:v startingAt:2.
    "
! !

!LinkedList methodsFor:'searching-identity'!

identityIndexOf:aLinkOrValue startingAt:start
    "search the collection for aLinkOrValue, starting the search at index start;
     if found, return the index otherwise return 0. 
     Here, index is defined as the link-node's position in the list.
     The comparison is done using == (i.e. identity test - not equality test).
     Warning: 
        it is a very bad idea to access LinkedList elements by index.
        many algorithms degenerate to poor performance if you do.
        This method is provided for protocol completeness,
        but please consider using another type of collection if you use it.
     "

    |theNode count "{ Class: SmallInteger }"
     linkOrValue|

    count := start.
    (count < 1 or:[count > numberOfNodes]) ifTrue:[
        ^ 0.
    ].

    theNode := firstLink.
    count-1 timesRepeat:[
        theNode isNil ifTrue:[^ 0].     "reached the end"
        theNode := theNode nextLink.
    ].

    linkOrValue := aLinkOrValue value.

    [theNode notNil] whileTrue:[
        (linkOrValue == theNode value) ifTrue:[^ count].
        theNode := theNode nextLink.
        count := count + 1.
    ].                                  "reached the end"
    ^ 0

    "
     |l|

     l := LinkedList new.
     l identityIndexOf:'hello' startingAt:1
    "

    "
     |l v|

     l := LinkedList new.
     l add:(ValueLink new value:'one').
     l add:(ValueLink new value:'two').
     l add:(v := ValueLink new value:'hello').
     l identityIndexOf:v startingAt:2.
    "
! !

!LinkedList methodsFor:'testing'!

isEmpty
    "return true, if the collection is empty"

    ^ firstLink isNil
!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

notEmpty
    "return true, if the collection is not empty"

    ^ firstLink notNil
! !

!LinkedList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 COPYRIGHT (c) 2016 by eXept Software AG
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

LinkedList subclass:#DoubleLinkedList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Linked'
!

!DoubleLinkedList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
                                                                        [exBegin]
    |l|

    l := DoubleLinkedList new.
    l addLast:'one'.
    l addLast:'two'.
    l addLast:'three'.
    l addLast:'four'.
    l inspect
                                                                        [exEnd]


                                                                        [exBegin]
    |l|

    l := LinkedList new.
    l addLast:(ValueDoubleLink new value:'one').
    l addLast:(ValueDoubleLink new value:'two').
    l addLast:(ValueDoubleLink new value:'three').
    l addLast:(ValueDoubleLink new value:'four').
    (l at:3) value inspect.        'slow operation for large lists'.
                                                                        [exEnd]


                                                                        [exBegin]
    |l link|

    l := LinkedList new.
    l addLast:(ValueDoubleLink new value:'one').
    l addLast:(ValueDoubleLink new value:'two').
    l addLast:(ValueDoubleLink new value:'three').
    l addLast:(ValueDoubleLink new value:'four').
    link := l removeFirst.
    l addLast:link.
    l inspect.
                                                                        [exEnd]
"
! !

!DoubleLinkedList methodsFor:'adding & removing'!

add:aLinkOrAnyOtherObject
    "adds aLink to the end of the sequence. Returns aLink"

    |newLink|

    newLink := aLinkOrAnyOtherObject asDoubleLink.

    newLink nextLink:nil.
    newLink previousLink:lastLink.
    lastLink isNil ifTrue:[
        firstLink := newLink
    ] ifFalse: [
        lastLink nextLink:newLink
    ].
    lastLink := newLink.
    numberOfNodes := numberOfNodes + 1.
    ^ newLink

    "
     |l e1 e2|
     l := DoubleLinkedList new.
     e1 := l add:'one'.
     e2 := l add:'two'.
     self assert:(l firstLink == e1).
     self assert:(l lastLink == e2).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink isNil).
     self assert:(e1 previousLink isNil).
     self assert:(e2 previousLink == e1).
    "
!

add:aLinkOrAnyOtherObject after:aLinkOrValue
    |linkToAddAfter newLink this nextLink|

    aLinkOrValue asDoubleLink == aLinkOrValue ifTrue:[
        linkToAddAfter := aLinkOrValue
    ] ifFalse:[
        this := firstLink.
        [this notNil and:[this value ~~ aLinkOrAnyOtherObject]] whileTrue:[
            this := this nextLink
        ].
        this isNil ifTrue:[
            ^ self addLast:aLinkOrAnyOtherObject
        ].
        linkToAddAfter := this.
    ].
    newLink := aLinkOrAnyOtherObject asDoubleLink.

    newLink nextLink:(nextLink := linkToAddAfter nextLink).
    newLink previousLink:linkToAddAfter.
    linkToAddAfter nextLink:newLink.
    nextLink isNil ifTrue:[
        lastLink := newLink
    ] ifFalse:[
        nextLink previousLink:newLink.
    ].
    numberOfNodes := numberOfNodes + 1.
    ^ newLink

    "
     |l e1 e2 e3 e2_5 e4|
     l := DoubleLinkedList new.
     e1 := l add:'one'.
     e2 := l add:'two'.
     e3 := l add:'three'.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     e2_5 := l add:'twoPointFife' after:e2.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e2_5).
     self assert:(e2_5 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2_5).
     self assert:(e2_5 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     e4 := l add:'four' after:e3.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e2_5).
     self assert:(e2_5 nextLink == e3).
     self assert:(e3 nextLink == e4).
     self assert:(e4 nextLink isNil).

     self assert:(l lastLink == e4).
     self assert:(e4 previousLink == e3).
     self assert:(e3 previousLink == e2_5).
     self assert:(e2_5 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).
    "
!

addFirst:aLinkOrAnyOtherObject
    "adds aLink to the beginning of the sequence. Returns aLink"

    |newLink|

    newLink := aLinkOrAnyOtherObject asDoubleLink.

    newLink nextLink:firstLink.
    firstLink isNil ifTrue:[
        lastLink := newLink
    ] ifFalse: [
        firstLink previousLink:newLink
    ].
    firstLink := newLink.
    numberOfNodes := numberOfNodes + 1.
    ^ newLink

    "
     |l e1 e0|
     l := DoubleLinkedList new.
     e1 := l add:'one'.
     e0 := l addFirst:'zero'.
     self assert:(l firstLink == e0).
     self assert:(l lastLink == e1).
     self assert:(e0 nextLink == e1).
     self assert:(e1 nextLink isNil).
     self assert:(e0 previousLink isNil).
     self assert:(e1 previousLink == e0).
    "
!

remove:aLinkOrValue ifAbsent:exceptionBlock
    "remove the argument, aLinkOrValue from the sequence and return it;
     if absent, evaluate the exceptionBlock."

    |linkToRemove this nextLink previousLink|

    aLinkOrValue asDoubleLink == aLinkOrValue ifTrue:[
        linkToRemove := aLinkOrValue
    ] ifFalse:[
        this := firstLink.
        [this notNil and:[this value ~= aLinkOrValue]] whileTrue:[
            this := this nextLink
        ].
        this isNil ifTrue:[
            ^ exceptionBlock value
        ].
        linkToRemove := this.
    ].

    nextLink := linkToRemove nextLink.
    previousLink := linkToRemove previousLink.
    nextLink notNil ifTrue:[
        nextLink previousLink:previousLink.
    ] ifFalse:[
        lastLink := previousLink
    ].
    previousLink notNil ifTrue:[
        previousLink nextLink:nextLink.
    ] ifFalse:[
        firstLink := nextLink
    ].
    numberOfNodes := numberOfNodes - 1.
    ^ linkToRemove

    "
     |l e1 e2 e3 e2_5 e4|
     l := DoubleLinkedList new.
     e1 := l add:'one'.
     e2 := l add:'two'.
     e3 := l add:'three'.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l remove:'two'.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l remove:'one'.
     self assert:(l firstLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink isNil).

     l remove:'three'.
     self assert:(l size == 0).
    "
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
    ] ifFalse:[ 
        firstLink previousLink:nil.
    ].        
    link nextLink:nil.
    link previousLink:nil.
    numberOfNodes := numberOfNodes - 1.
    ^ link

    "
     |l v1 v2 v3 e1 e2 e3 e2_5 e4|

     l := DoubleLinkedList new.
     e1 := l add:'one'.
     e2 := l add:'two'.
     e3 := l add:'three'.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l removeFirst.
     self assert:(l firstLink == e2).
     self assert:(e2 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2).
     self assert:(e2 previousLink isNil).

     l removeFirst.
     self assert:(l firstLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink isNil).

     l removeFirst.
     self assert:(l size == 0).
    "
!

removeIdentical:aLinkOrValue ifAbsent:exceptionBlock
    "remove the argument, aLinkOrValue from the sequence and return it;
     if absent, evaluate the exceptionBlock."

    |linkToRemove this nextLink previousLink|

    aLinkOrValue asDoubleLink == aLinkOrValue ifTrue:[
        linkToRemove := aLinkOrValue
    ] ifFalse:[
        this := firstLink.
        [this notNil and:[this value ~~ aLinkOrValue]] whileTrue:[
            this := this nextLink
        ].
        this isNil ifTrue:[
            ^ exceptionBlock value
        ].
        linkToRemove := this.
    ].

    nextLink := linkToRemove nextLink.
    previousLink := linkToRemove previousLink.
    nextLink notNil ifTrue:[
        nextLink previousLink:previousLink.
    ] ifFalse:[
        lastLink := previousLink
    ].
    previousLink notNil ifTrue:[
        previousLink nextLink:nextLink.
    ] ifFalse:[
        firstLink := nextLink
    ].
    numberOfNodes := numberOfNodes - 1.
    ^ linkToRemove

    "
     |l v1 v2 v3 e1 e2 e3 e2_5 e4|
     l := DoubleLinkedList new.
     e1 := l add:(v1 := 'one').
     e2 := l add:(v2 := 'two').
     e3 := l add:(v3 := 'three').
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l removeIdentical:v2.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l removeIdentical:v1.
     self assert:(l firstLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink isNil).

     l removeIdentical:v3.
     self assert:(l size == 0).
    "
!

removeLast
    "remove and return the last node from the sequence"

    |link|

    lastLink isNil ifTrue:[
        ^ self emptyCollectionError
    ].
    link := lastLink.
    lastLink := lastLink previousLink.
    lastLink isNil ifTrue:[
        firstLink := nil
    ] ifFalse:[ 
        lastLink nextLink:nil.
    ].        
    link nextLink:nil.
    link previousLink:nil.
    numberOfNodes := numberOfNodes - 1.
    ^ link

    "
     |l v1 v2 v3 e1 e2 e3 e2_5 e4|

     l := DoubleLinkedList new.
     e1 := l add:'one'.
     e2 := l add:'two'.
     e3 := l add:'three'.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink == e3).
     self assert:(e3 nextLink isNil).

     self assert:(l lastLink == e3).
     self assert:(e3 previousLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l removeLast.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink == e2).
     self assert:(e2 nextLink isNil).

     self assert:(l lastLink == e2).
     self assert:(e2 previousLink == e1).
     self assert:(e1 previousLink isNil).

     l removeLast.
     self assert:(l firstLink == e1).
     self assert:(e1 nextLink isNil).

     self assert:(l lastLink == e1).
     self assert:(e1 previousLink isNil).

     l removeLast.
     self assert:(l size == 0).
    "
! !

!DoubleLinkedList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


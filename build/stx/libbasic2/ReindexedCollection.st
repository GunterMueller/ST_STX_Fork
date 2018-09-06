"
 COPYRIGHT (c) 2006 by eXept Software AG
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

SequenceableCollection subclass:#ReindexedCollection
	instanceVariableNames:'sequence interval'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!ReindexedCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    ReindexedCollection is a wrapper around a sequenceable collection that remaps the indices 
    with in linear algorithm.  
    The elements in the ReindexedCollection are the elements of the original collection 
    at 'some start' to 'some stop' (optionally 'by some step').  

    ReindexedCollection allows for efficient use of first/rest-like algorithms (i.e. aka Lisp)
    applied to Sequenceable collections, as they avoid element-copying.

    For example,
        coll1 := #(1 2 3 4 5 6 7 8 9 10).
        coll2 := coll1 from:8.
    gives us a collection in coll2, which 'contains' 3 elements, 8, 9, 10
    with indices 1,2,3. 
    I.e. a slice from the other array.

    The reindexed collection is 'read-only'. I.e. it does not allow for elements to be changed.
    
    See class side examples.

    [Instance Variables:]
        sequence        <SequenceableCollection>    the sequence that will be reindexed.
        interval        <Interval>                  the object that describes indicies of interest in the sequence.

    [Origin:]
        Part of the Engineering Math Goodies package from Travis.
    
    [Author:]
        Travis Griggs (tgriggs@keyww.com or tkc@bmi.net)
        Ported from Squeak by Claus Gittinger (not much of a port, though)
"
!

examples
"
    |coll|

    coll := #(1 2 3 4 5 6 7 8 9 10) from:8.
    Transcript show:'from 8: '; showCR:coll.     
    Transcript show:'size: '; showCR:(coll size).  
    Transcript show:'at 1: '; showCR:(coll at:1).   
    Transcript show:'first: '; showCR:(coll first).   
    Transcript show:'last: '; showCR:(coll last).   
    coll do:[:each | Transcript show:'do: '; showCR:each].
    coll reverseDo:[:each | Transcript show:'reverseDo: '; showCR:each].


    |coll|

    coll := (1 to:10) asOrderedCollection from:3 to:8.
    coll.     
    coll size.  
    coll at:1.   
    coll do:[:each | Transcript showCR:each].


    |coll|

    coll := (1 to:10) asOrderedCollection to:4.
    coll.     
    coll size.  
    coll at:1.   
    coll last.   
    coll do:[:each | Transcript showCR:each].
"
! !

!ReindexedCollection class methodsFor:'instance creation'!

on: aSequence from: start 
    "Create a reindexedCollection on aSequence from start to the end of aSequence"

    ^ self
        on: aSequence
        from: start
        to: aSequence size
        by: 1
!

on: aSequence from: start by: step 
    "Create a reindexedCollection on aSequence start to the end of aSequence 
     if step is positive, else  
     from start to the beginning of the sequence if step is negative."

    ^ self
        on: aSequence
        from: start
        to: (step > 0
                ifTrue: [aSequence size]
                ifFalse: [1])
        by: step
!

on: aSequence from: start to: stop 
    "Create a reindexedCollection on aSequence from start to stop by 1 
     (or -1 if start is greater than stop)"

    ^ self
        on: aSequence
        from: start
        to: stop
        by: (start <= stop
                ifTrue: [1]
                ifFalse: [-1])
!

on: aSequence from: start to: stop by: step 
    "Create a reindexedCollection on aSequence from start to stop by step"

    ^ self new
            initialize: aSequence
            from: start
            to: stop
            by: step
!

on: aSequence to: stop 
    "Create a reindexedCollection on aSequence from 1 to stop by 1"

    ^ self
        on: aSequence
        from: 1
        to: stop
        by: 1
!

on: aSequence to: stop by: step 
    "Create a reindexedCollection on aSequence from 1 to stop (if step is 
     positive) or the end to stop (if  
     step is negative). Note: if step is not 1 or -1, there is a chance that the 
     index specified by stop may  
     not be in the interval."

    ^ self
        on: aSequence
        from: (step > 0
                ifTrue: [1]
                ifFalse: [aSequence size])
        to: stop
        by: step
!

on: aSequence with: anInterval 
    "Create a reindexedCollection on aSequence"

    ^ self new initialize: aSequence with: anInterval
! !

!ReindexedCollection methodsFor:'accessing'!

at: index 
    "Answer the value of an indexable field in the sequence instance variable. "

    ^ sequence at: (interval at: index)
!

at: index put: value 
    "Store the argument value in the indexable field of the sequence 
     instance variable indicated by index.  
     Answer the value that was stored."

    ^ sequence at: (interval at: index) put: value
!

size
    "Answer how many elements the receiver contains."

    ^ interval size
!

slide
    "slide by 1"

    self slide: 1
!

slide: anIncrement 
    "given an increment, adjust the reindex map by sliding it that far"

    interval := interval + anIncrement
! !

!ReindexedCollection methodsFor:'adding & removing'!

add: anObject 
    "report an error; reindexedCollections cannot add elements"

    self shouldNotImplement
! !

!ReindexedCollection methodsFor:'converting-reindexed'!

from:startIndex
    "return a new collection representing the receiver's elements starting at startIndex."

    interval step == 1 ifTrue:[
        ^ ReindexedCollection 
            on:sequence 
            from:(interval start + startIndex - 1) 
            to:(interval stop)
            by:(interval step)
    ].
    "could be more intelligent here..."
    ^ super from:startIndex

    "
     |coll cdr cddr cdddr|

     coll := #(1 2 3 4 5 6 7 8 9 10).
     cdr := coll from:2.            
     cddr := cdr from:2.        
     cdddr := cddr from:2.
    "
!

from:startIndex to:stopIndex
    "return a new collection representing the receiver's elements 
     starting at startIndex upTo and including endIndex."

    interval step == 1 ifTrue:[
        ^ ReindexedCollection 
            on:sequence 
            from:(interval start + startIndex - 1) 
            to:((interval start + stopIndex - 1) min:interval stop)
            by:1
    ].
    "could be more intelligent here..."
    ^ super from:startIndex to:stopIndex

    "
     |coll cdrButLast cddrButLast2 cdddrButLast3|

     coll := #(1 2 3 4 5 6 7 8 9 10).
     cdrButLast := coll from:2 to:9.             
     cddrButLast2 := cdrButLast from:2 to:7.          
     cdddrButLast3 := cddrButLast2 from:2 to:5.     
    "

    "
     |coll cdrButLast cddrButLast2 cdddrButLast3|

     coll := 1 to:100.
     cdrButLast := coll from:2 to:99.             
     cddrButLast2 := cdrButLast from:2 to:97.          
     cdddrButLast3 := cddrButLast2 from:2 to:95.     
    "
!

to:stopIndex
    "return a new collection representing the receiver's elements upTo and including endIndex."

    interval step == 1 ifTrue:[
        ^ ReindexedCollection 
            on:sequence 
            from:(interval start) 
            to:((interval start + stopIndex - 1) min:interval stop)
            by:1
    ].
    "could be more intelligent here..."
    ^ super to:stopIndex

    "
     |coll butLast butLast2 butLast3|

     coll := #(1 2 3 4 5 6 7 8 9 10).
     butLast := coll to:9.              
     butLast2 := butLast to:8.          
     butLast3 := butLast2 to:7.     
    "
! !

!ReindexedCollection methodsFor:'initialization'!

initialize: aSequence from: start to: stop by: step 
    sequence := aSequence.
    interval := Interval from: start to: stop by: step
!

initialize: aSequence with: anInterval 
        sequence := aSequence.
        interval := anInterval
! !

!ReindexedCollection methodsFor:'queries'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ sequence isFixedSize
!

species
    "Answer the preferred class for reconstructing the receiver, 
     that is, the sequence."

    ^ sequence species
!

speciesForAdding
    "Answer the preferred class for reconstructing the receiver incrementally"

    ^ sequence speciesForAdding
! !

!ReindexedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


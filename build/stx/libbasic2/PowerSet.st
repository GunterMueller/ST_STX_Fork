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

Collection subclass:#PowerSet
	instanceVariableNames:'baseSet'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!PowerSet class methodsFor:'documentation'!

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
    A PowerSet of a collection is the set of all possible (sub-)collections
    built from the original collection's elements.
    This includes the empty collection.

    The PowerSet of [1 2 3] is therefore:
        []
        [1]
        [2]
        [3]
        [1 2]
        [1 3]
        [2 3]
        [1 2 3]

    As the powerset can quickly become huge in size (for a baseSet of n elements, we
    get a powerSet size of 2^N), the elements of the powerset are created dynamically.
    I.e. they are only created on demand.
    As this, this is a good example of polymorphism: powerSets represent collections,
    but do not really store their elements (see Interval for another such Collection).

    [author:]
        Claus Gittinger

    [see also:]
        Set Interval
"
!

examples
"
                                                                        [exBegin]
    |s p|

    s := #(1 2 3).
    p := PowerSet for:s.

    p do:[:eachSubSet |
        Transcript showCR:eachSubSet
    ].
                                                                        [exEnd]

  A huge powerSet - do not enumerate its elements ;-)
                                                                        [exBegin]
    |s p|

    s := (1 to:1000).
    p := PowerSet for:s.

    Transcript show:'p''s size is: '; showCR:p size
                                                                        [exEnd]

                                                                        [exBegin]
    |s p|

    s := (1 to:10).
    p := PowerSet for:s.
    p includes:#(1 2 3) asSet.   
    p includes:#(1 2 4) asSet.   
    p includes:#(0 1 2) asSet.         
                                                                        [exEnd]
"
! !

!PowerSet class methodsFor:'instance creation'!

for:aCollection 
    "Create & return a new instance for aCollection."

    ^ self basicNew initializeFor:aCollection 
! !

!PowerSet methodsFor:'enumerating'!

do:aBlock 
    "evaluate the argument, aBlock for each element"

    |firstElement restElements restPowerSet|

    baseSet isEmpty ifTrue:[
        aBlock value:baseSet species new.
    ] ifFalse:[
        baseSet isSequenceable ifTrue:[
            firstElement := baseSet first.
            restElements := baseSet from:2.
        ] ifFalse:[
            firstElement := baseSet anElement.
            restElements := Set withAll:baseSet.
            restElements remove:firstElement.
        ].

        restPowerSet := PowerSet for:restElements.
        restPowerSet do:[:each | 
            aBlock value:(baseSet species with:firstElement), each.
        ].
        restPowerSet do:aBlock.
    ].
! !

!PowerSet methodsFor:'initialization'!

initializeFor:aCollection 
    baseSet := aCollection.
! !

!PowerSet methodsFor:'queries'!

includes:aCollection
    ^ aCollection conform:[:each | baseSet includes:each].

    "Created: / 02-08-2012 / 19:32:24 / cg"
!

size
    ^ 2 raisedTo:baseSet size
! !

!PowerSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/PowerSet.st,v 1.5 2014-02-23 01:14:33 cg Exp $'
! !


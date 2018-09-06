"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SegmentedOrderedCollectionTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

!SegmentedOrderedCollectionTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SegmentedOrderedCollectionTests methodsFor:'tests'!

test01
    |c t249 t250 t251|

    c := SegmentedOrderedCollection new.
    self assert:(c size == 0).
    self should:[ c at: 1 ] raise:SubscriptOutOfBoundsError.

    c add:10.
    self assert:(c size == 1).
    self assert:(c first == 10).
    self assert:(c last == 10).

    20 to:20000 by:10 do:[:each |
	c add:each
    ].
    self assert:(c size == 2000).
    self assert:(c first == 10).
    self assert:(c last == 20000).

    1 to:1000 do:[:i |
	c removeFirst
    ].
    self assert:(c first == 10010).
    self assert:(c last == 20000).
    self assert:(c size == 1000).

    self assert:(c collect:[:el | el] as:OrderedCollection) = (10010 to: 20000 by:10) asOrderedCollection.
    self assert:(c at:1) == 10010.
    self assert:(c at:499) == 14990.

    c removeFromIndex:1 toIndex:499.
    self assert:(c first == 15000).
    self assert:(c last == 20000).
    self assert:(c size == 501).

    self assert:(c collect:[:el | el] as:OrderedCollection) = (15000 to: 20000 by:10) asOrderedCollection.

    c addFirst:'xxx'.
    self assert:(c first = 'xxx').
    self assert:(c last == 20000).
    self assert:(c size == 502).
    self assert:(c removeFirst = 'xxx').
    self assert:(c size == 501).
    self assert:(c first == 15000).

    1 to:999 do:[:i |
	c addFirst:i
    ].
    1 to:999 do:[:i |
	self assert:(c at:i) == (1000-i).
    ].
    self assert:(c size == (501+999)).

    t249 := c at:249.
    t250 := c at:250.
    t251 := c at:251.
    c add:999 beforeIndex:250.
    self assert:(c size == (501+999+1)).
    self assert:(c at:249) == t249.
    self assert:(c at:250) == 999.
    self assert:(c at:251) == t250.
    self assert:(c at:252) == t251.
    c removeIndex:250.

    999 to:1 by:-1 do:[:i |
	self assert:(c removeFirst == i)
    ].

    c removeFirst.
    self assert:(c first == 15010).
    self assert:(c last == 20000).
    self assert:(c size == 500).

    c removeLast.
    self assert:(c first == 15010).
    self assert:(c last == 19990).
    self assert:(c size == 499).

    c removeFromIndex:2 toIndex:498.
    self assert:(c first == 15010).
    self assert:(c last == 19990).
    self assert:(c size == 2).

    c grow:1000.
    self assert:(c size == 1000).
    self assert:(c at:1) == 15010.
    self assert:(c at:2) == 19990.
    3 to:1000 do:[:i |
	self assert:(c at:i) == nil
    ].

    c grow:105.
    self assert:(c size == 105).
    self assert:(c at:1) == 15010.
    self assert:(c at:2) == 19990.
    3 to:105 do:[:i |
	self assert:(c at:i) == nil
    ].

    "
     self run:#test01
     self new test01
    "
!

test02_timing
    |c tAdd tRemove|

    "/ adding at the end: OC is faster

    tAdd := TimeDuration toRun:[
	c := SegmentedOrderedCollection new.
	1 to:200000 do:[:i |
	    c add:i
	].
    ].
    Transcript show:'Time to add 200000 elements to sc: '; showCR:tAdd.

    tAdd := TimeDuration toRun:[
	c := OrderedCollection new.
	1 to:200000 do:[:i |
	    c add:i
	].
    ].
    Transcript show:'Time to add 200000 elements to oc: '; showCR:tAdd.

    "/ ---------------------
    "/ removing at the beginning: OC is faster

    c := SegmentedOrderedCollection withAll:(1 to:200000).
    tRemove := TimeDuration toRun:[
	1 to:200000 do:[:i |
	    c removeFirst
	].
    ].
    Transcript show:'Time to remove 200000 elements from sc: '; showCR:tRemove.

    c := OrderedCollection withAll:(1 to:200000).
    tRemove := TimeDuration toRun:[
	1 to:200000 do:[:i |
	    c removeFirst
	].
    ].
    Transcript show:'Time to remove 200000 elements from oc: '; showCR:tRemove.

    "/ ---------------------
    "/ removing inside: SC is much faster

    c := SegmentedOrderedCollection withAll:(1 to:200000).
    tRemove := TimeDuration toRun:[
	1 to:100000 do:[:i |
	    c removeIndex:2000
	].
    ].
    Transcript show:'Time to remove 100000 elements from inside sc: '; showCR:tRemove.

    c := OrderedCollection withAll:(1 to:200000).
    tRemove := TimeDuration toRun:[
	1 to:100000 do:[:i |
	    c removeIndex:2000
	].
    ].
    Transcript show:'Time to remove 100000 elements from inside oc: '; showCR:tRemove.


    "
     self run:#test02_timing
     self new test02_timing
    "
!

test03
    |c|

    c := SegmentedOrderedCollection new.
    self assert:(c size == 0).
    self assert:(c isEmpty).
    self assert:(c notEmpty not).
    self should:[ c at: 1 ] raise:SubscriptOutOfBoundsError.

    c add:10.
    self assert:(c size == 1).
    self assert:(c first == 10).
    self assert:(c last == 10).
    self assert:(c isEmpty not).
    self assert:(c notEmpty).

    c removeFirst.

    self assert:(c size == 0).
    self assert:(c isEmpty).
    self assert:(c notEmpty not).
    self should:[ c at: 1 ] raise:SubscriptOutOfBoundsError.

    "
     self run:#test03
     self new test03
    "
! !

!SegmentedOrderedCollectionTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


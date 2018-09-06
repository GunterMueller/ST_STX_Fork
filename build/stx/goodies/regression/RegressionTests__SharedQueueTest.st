"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SharedQueueTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!SharedQueueTest methodsFor:'Testing'!

test2Readers

    |q scale p1 p2 s1 s2 next1 next2|

    scale := 10000.
    q := SharedQueue new:10.

    s1 := ReadWriteStream on:(Array new:1000).
    s2 := ReadWriteStream on:(Array new:1000).

    p1 := [
	[
	    s1 nextPut:q next
	] loop.
    ] fork.

    p2 := [
	[
	    s2 nextPut:q next
	] loop.
    ] fork.

    1 to:1000 do:[:i|
	q nextPut:i
    ].

    Delay waitForMilliseconds:20.

    p1 terminate.
    p2 terminate.

    self assert:s1 position0Based + s2 position0Based == 1000.

    s1 reset.
    s2 reset.

    next1 := s1 next.
    next2 := s2 next.

    1 to: 1000 do:[:i|
	self should:[
	    next1 == i ifTrue:[
		next1 := s1 next.
		true.
	    ] ifFalse:[
		next2 == i ifTrue:[
		    next2 := s2 next.
		    true
		].
	    ]
	]
    ].
!

test2ReadersAndWriters

    |q scale p1 p2 pw s1 s2 next1 next2 all|

    scale := 100000.
    q := SharedQueue new:10.

    s1 := ReadWriteStream on:(Array new:20000).
    s2 := ReadWriteStream on:(Array new:20000).

    p1 := [
	[
	    s1 nextPut:q next
	] loop.
    ] fork.

    p2 := [
	[
	    s2 nextPut:q next
	] loop.
    ] fork.

    pw := [
	1 to:10000 do:[:i|
	    q nextPut:i+scale
	].
    ] fork.

    1 to:10000 do:[:i|
	q nextPut:i
    ].

    pw waitUntilTerminated.
    Delay waitForMilliseconds:20.

    p1 terminate.
    p2 terminate.

    self assert:s1 position0Based + s2 position0Based == 20000.

    s1 reset.
    s2 reset.

    next1 := next2 := 0.
    self should:[
	s1 contents conform:[:i|
	    i < scale ifTrue:[
		next1 < i and:[next1 := i. true]
	    ] ifFalse:[
		next2 < i and:[next2 := i. true]
	    ].
	].
    ].
    next1 := next2 := 0.
    self should:[
	s2 contents conform:[:i|
	    i < scale ifTrue:[
		next1 < i and:[next1 := i. true]
	    ] ifFalse:[
		next2 < i and:[next2 := i. true]
	    ].
	].
    ].

    s1 reset.
    s2 reset.

    all := SortedCollection new:20000.
    all addAll:s1 contents.
    all addAll:s2 contents.

    1 to: 10000 do:[:i|
	self assert:((all at:i) == i).
	self assert:((all at:(i+10000)) == (i+scale)).
    ].
!

test2Writers

    |q scale next1 next2|

    scale := 10000.
    q := SharedQueue new:10.

    [
	1 to:1000 do:[:i|
	    q nextPut:i.
	].
    ] fork.
    [
	1 to:1000 do:[:i|
	    q nextPut:i+scale.
	].
    ] fork.


    next1 := 1.
    next2 := next1 + scale.

    2000 timesRepeat:[ |i|
	i := q next.
	i < scale ifTrue:[
	    self assert:i == next1.
	    next1 := next1 + 1.
	] ifFalse:[
	    self assert:i == next2.
	    next2 := next2 + 1.
	]
    ].

    self assert:next1 == 1001.
    self assert:next2 == (next1 + scale).
    self assert:q isEmpty
!

testBasics

    |q|

    q := SharedQueue new:5.
    self assert:q isEmpty.
    self assert:q size == 0.
!

testReaderWriter

    |q|

    q := SharedQueue new:10.

    [
	1 to:1000 do:[:i|
	    q nextPut:i.
	].
    ] fork.

    1 to: 1000 do:[:i|
	self assert:q next == i.
    ].

    self assert:q isEmpty
!

testRemoveAll

    0 to:10 do:[:i|
	self removeAllSize:10 fill:i.
    ].
! !

!SharedQueueTest methodsFor:'helpers'!

removeAllSize:size fill:fill

    |q|

    q := SharedQueue new:size.

    1 to:fill do:[:i|
	q nextPut:i.
    ].
    q removeAll.
    self assert:q isEmpty.
! !

!SharedQueueTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


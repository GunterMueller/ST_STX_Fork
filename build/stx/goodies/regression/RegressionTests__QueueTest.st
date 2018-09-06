"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#QueueTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!QueueTest class methodsFor:'queries'!

coveredClassNames
    ^ #( Queue )
! !

!QueueTest methodsFor:'Testing'!

testBasic1

    |q el|

    q := Queue new:5.
    self assert:q isEmpty.
    self assert:q size == 0.
    q nextPut:1.
    self assert:q notEmpty.
    self assert:q size == 1.
    q nextPut:2.
    self assert:q notEmpty.
    self assert:q size == 2.
    el := q next.
    self assert:q notEmpty.
    self assert:q size == 1.
    self assert:(el==1).
    el := q next.
    self assert:q isEmpty.
    self assert:q size == 0.
    self assert:(el==2).

    "
     self new testBasic1
    "
!

testBasic2

    |q el|

    q := Queue new:5.
    self assert:q isEmpty.
    self assert:q size == 0.
    q nextPut:1.
    q nextPut:2.
    q nextPut:3.
    q nextPut:4.
    q nextPut:5.
    el := q next.
    self assert:(el==1).
    el := q next.
    self assert:(el==2).
    el := q next.
    self assert:(el==3).
    el := q next.
    self assert:(el==4).
    el := q next.
    self assert:(el==5).

    "
     self new testBasic2
    "
!

testBasic3

    |q el|

    q := Queue new:5.
    self assert:q isEmpty.
    self assert:q size == 0.
    q nextPut:1.
    q nextPut:2.
    q nextPut:3.
    q nextPut:4.
    q nextPut:5.
    self should:[q nextPut:6] raise:Error.
    el := q next.
    self assert:(el==1).
    el := q next.
    self assert:(el==2).
    el := q next.
    self assert:(el==3).
    el := q next.
    self assert:(el==4).
    el := q next.
    self assert:(el==5).

    "
     self new testBasic3
    "
!

testBasic4

    |q el|

    q := Queue new:5.
    self assert:q isEmpty.
    self assert:q size == 0.
    q nextPut:1.
    q nextPutFirst:2.
    q nextPutFirst:3.
    q nextPutFirst:4.
    q nextPutFirst:5.
    self should:[q nextPutFirst:6] raise:Error.
    el := q next.
    self assert:(el==5).
    el := q next.
    self assert:(el==4).
    el := q next.
    self assert:(el==3).
    el := q next.
    self assert:(el==2).
    el := q next.
    self assert:(el==1).

    "
     self new testBasic4
    "
!

testBasic5

    |q el|

    q := Queue new:5.
    self assert:q isEmpty.
    self assert:q size == 0.
    q nextPutFirst:1.
    q nextPutFirst:2.
    q nextPutFirst:3.
    el := q next.
    self assert:(el==3).
    el := q next.
    self assert:(el==2).
    el := q next.
    self assert:(el==1).

    "
     self new testBasic5
    "
!

testChangeCapacity
    "tests all kinds of boundary conditions in the capacity-change code
     (i.e. especially wraps)"
     
     |q|

     #(false true) do:[:wrap |
        1 to:10 do:[:fill |
            1 to:fill do:[:read |
                 Transcript show:'wrap: '; show:wrap; show:' fill: '; show:fill; show:' read: '; showCR:read.
                
                 q := Queue new:10.
                 self assert:(q capacity == 10).
                 wrap ifTrue:[
                     1 to:5 do:[:i | q nextPut:#foo ].
                 ].

                 1 to:fill do:[:i | q nextPut:i.
                                    (i==1 and:[wrap]) ifTrue:[ 1 to:5 do:[:i | q next ] ].
                              ].
                "/ (wrap and:[fill==9 and:[read == 8]]) ifTrue:[self halt].
                 read timesRepeat:[ q next ].
                 q capacity:12.
                 self assert:(q capacity == 12).
                 self assert:(q size == (fill-read)).
                 self assert:((Array streamContents:[:s | q do:[:e |s nextPut:e]]) = (read+1 to:fill) asArray).
                 self assert:(q size == (fill-read)).
                 fill==read ifTrue:[
                     self assert:(q isEmpty).
                     self assert:(q notEmpty not).
                     self assert:(q size == 0).
                     self assert:(q nextOrNil == nil).
                     self assert:(q peekOrNil == nil).
                     self should:[q at:1] raise:SubscriptOutOfBoundsError.
                 ] ifFalse:[
                     self assert:(q notEmpty).
                     self assert:(q isEmpty not).
                     self assert:(q at:1) == (read+1).
                     self assert:(q peek) == (read+1).
                     self assert:(q peekOrNil) == (read+1).
                 ].        
            ].    
        ].    
     ]. 
!

testRemoveAll
    0 to:10 do:[:i|
	self removeAllSize:10 fill:i.
    ].
! !

!QueueTest methodsFor:'helpers'!

removeAllSize:size fill:fill

    |q|

    q := Queue new:size.

    1 to:fill do:[:i|
	q nextPut:i.
    ].
    q removeAll.
    self assert:q isEmpty.
! !

!QueueTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


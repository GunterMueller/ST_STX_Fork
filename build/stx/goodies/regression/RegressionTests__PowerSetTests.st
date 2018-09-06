"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#PowerSetTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!PowerSetTests methodsFor:'testing'!

test01
    |s p|

    s := #(1 2 3) asSet.
    p := PowerSet for:s.

    p do:[:subSet | Transcript showCR:subSet].

    self assert:(p notEmpty).
    self assert:(p size = 8).     "/ [] [1] [2] [3] [1 2] [1 3] [2 3] [1 2 3]

    #(
	#()
	#(1)
	#(2)
	#(3)
	#(1 2)
	#(1 3)
	#(2 3)
	#(1 2 3)
    ) do:[:eachExpectedElement |
	self assert:(p includes: eachExpectedElement asSet).
    ].

    "
     self new test01
    "
!

test02
    |p|

    p := PowerSet for:(1 to:1000).

    self assert:(p notEmpty).
    self assert:(p size = (2 raisedTo:1000)).

    "
     self new test02
    "
! !

!PowerSetTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


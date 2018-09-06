"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#GCTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!


!GCTest methodsFor:'tests'!

testRemSetOverflow1
    |arr|

    arr := Array new:100000.
    100 timesRepeat:[
	1 to:100000 do:[:i |
	    arr at:i put:(Array new:1).
	].
    ].

    "
     self new testRemSetOverflow1
    "
! !

!GCTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


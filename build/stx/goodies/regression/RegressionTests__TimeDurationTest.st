"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#TimeDurationTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-DateAndTime'
!


!TimeDurationTest methodsFor:'Testing'!

test_01_PrintingReading
     #(
	(0 0 0 0)
	(0 0 0 1)
	(0 0 0 9)
	(0 0 0 10)
	(0 0 0 11)
	(0 0 0 99)
	(0 0 0 100)
	(0 0 0 101)
	(0 0 0 999)
	(0 0 0 1000)
	(0 0 0 1001)

	(0 33 0 123)
	(2 0 0 123)
	(2 33 0 123)
	(100 33 0 123)
	(10000 33 0 123)
	(1000000 33 0 123)

	(2 33 0 0)
	(2 0 0 0)
	(24 0 0 0)
	(0 0 0 123)
    ) do:[:hmsms |
	|h m s ms d1 d2 s1 s2|

	h := hmsms first.
	m := hmsms second.
	s := hmsms third.
	ms := hmsms fourth.
	d1 := TimeDuration hours:h minutes:m seconds:s milliseconds:ms.
	s1 := d1 printString.
	d2 := TimeDuration readFrom:s1.
	s2 := d2 printString.
	self assert:(d1 = d2).
	self assert:(d1 timeEncoding = d2 timeEncoding).
	self assert:(s1 = s2).
     ].


"/     (TimeDuration hours:0 minutes:0 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'
"/     (TimeDuration hours:0 minutes:0 seconds:10 milliseconds:123) printStringFormat:'%h:%m:%s'
"/     (TimeDuration hours:0 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'
"/     (TimeDuration hours:2 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'
"/     (TimeDuration hours:100 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'
"/     (TimeDuration hours:10000 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'
"/     (TimeDuration hours:1000000 minutes:33 seconds:0 milliseconds:123) printStringFormat:'%h:%m:%s'

    "
     self new test_01_PrintingReading
    "

    "Created: / 18-07-2007 / 14:02:01 / cg"
! !

!TimeDurationTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


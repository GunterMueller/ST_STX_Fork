"{ Package: 'stx:goodies/communication/zeromq/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#ZmqVersionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Tests'
!

ZmqVersionTest comment:''
!


!ZmqVersionTest methodsFor:'as yet unclassified'!

testBetween
	self assert: ((ZmqVersion fromString: '0.5.0') between: '0.5.0' and: '1.1.0').
	self assert: ((ZmqVersion fromString: '1.0.0') between: '0.5.0' and: '1.1.0').
	self assert: ((ZmqVersion fromString: '1.1.0') between: '0.5.0' and: '1.1.0').
!

testEquality
	self assert: (ZmqVersion fromString:'1.2.3') = (ZmqVersion fromString:'1.2.3').
!

testEqualityNegativeCase
	self deny: (ZmqVersion fromString:'1.2.3') = (ZmqVersion fromString:'1.2.4').
!

testGreaterThan
	self assert: (ZmqVersion fromString:'1.2.3') > (ZmqVersion fromString:'1.2.2').
	self assert: (ZmqVersion fromString:'1.2.3') > (ZmqVersion fromString:'1.1.3').
	self assert: (ZmqVersion fromString:'1.2.3') > (ZmqVersion fromString:'0.2.4').

!

testLesserThan
	self assert: (ZmqVersion fromString:'2.2.1') < (ZmqVersion fromString:'2.2.2').
	self assert: (ZmqVersion fromString:'2.1.2') < (ZmqVersion fromString:'2.2.2').
	self assert: (ZmqVersion fromString:'1.2.2') < (ZmqVersion fromString:'2.2.2').

!

testPrinting
	self assert: (ZmqVersion major:2 minor: 3 patch: 4) asString = '2.3.4'.
! !

!ZmqVersionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqVersionTest.st,v 1.1 2018-05-08 19:51:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqVersionTest.st,v 1.1 2018-05-08 19:51:15 cg Exp $'
! !


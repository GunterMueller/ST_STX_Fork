"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SmallIntegerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!


!SmallIntegerTest class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!SmallIntegerTest methodsFor:'tests-arithmetic'!

testBitShift
    #(
	(1 1 2)
	(1 2 4)
	(1 3 8)
	(1 7 16r080)
	(1 8 16r100)
	(1 15 16r08000)
	(1 16 16r10000)
	(1 17 16r20000)
	(1 30 16r040000000)
	(1 31 16r080000000)
	(1 32 16r100000000)
	(1 33 16r200000000)

	(1 62 16r04000000000000000)
	(1 63 16r08000000000000000)
	(1 64 16r10000000000000000)
	(1 65 16r20000000000000000)

	(1 126 16r040000000000000000000000000000000)
	(1 127 16r080000000000000000000000000000000)
	(1 128 16r100000000000000000000000000000000)
	(1 129 16r200000000000000000000000000000000)

	(16r10 1 16r20)
	(16r10 2 16r40)
	(16r10 3 16r80)
	(16r10 7 16r0800)
	(16r10 8 16r1000)
	(16r10 15 16r080000)
	(16r10 16 16r100000)
	(16r10 17 16r200000)
	(16r10 30 16r0400000000)
	(16r10 31 16r0800000000)
	(16r10 32 16r1000000000)
	(16r10 33 16r2000000000)

	(16r10 62 16r040000000000000000)
	(16r10 63 16r080000000000000000)
	(16r10 64 16r100000000000000000)
	(16r10 65 16r200000000000000000)

	(16r10 126 16r0400000000000000000000000000000000)
	(16r10 127 16r0800000000000000000000000000000000)
	(16r10 128 16r1000000000000000000000000000000000)
	(16r10 129 16r2000000000000000000000000000000000)
    ) triplesDo:[:val :cnt :expected |
	|rslt1 rslt2|

	rslt1 := val bitShift:cnt.
	self assert:(rslt1 = expected).
	expected class == SmallInteger ifTrue:[
	    self assert:(rslt1 == expected)
	].
	rslt2 := rslt1 bitShift:cnt negated.
	self assert:(rslt2 = val).
	val class == SmallInteger ifTrue:[
	    self assert:(rslt2 == val)
	].
    ].
!

testBitShiftNegative
    #(
	(-1 1 -2)
	(-1 2 -4)
	(-1 3 -8)
	(-1 7 -16r080)
	(-1 8 -16r100)
	(-1 15 -16r08000)
	(-1 16 -16r10000)
	(-1 17 -16r20000)
	(-1 30 -16r040000000)
	(-1 31 -16r080000000)
	(-1 32 -16r100000000)
	(-1 33 -16r200000000)

	(-1 62 -16r04000000000000000)
	(-1 63 -16r08000000000000000)
	(-1 64 -16r10000000000000000)
	(-1 65 -16r20000000000000000)

	(-1 126 -16r040000000000000000000000000000000)
	(-1 127 -16r080000000000000000000000000000000)
	(-1 128 -16r100000000000000000000000000000000)
	(-1 129 -16r200000000000000000000000000000000)

	(-16r10 1 -16r20)
	(-16r10 2 -16r40)
	(-16r10 3 -16r80)
	(-16r10 7 -16r0800)
	(-16r10 8 -16r1000)
	(-16r10 15 -16r080000)
	(-16r10 16 -16r100000)
	(-16r10 17 -16r200000)
	(-16r10 30 -16r0400000000)
	(-16r10 31 -16r0800000000)
	(-16r10 32 -16r1000000000)
	(-16r10 33 -16r2000000000)

	(-16r10 62 -16r040000000000000000)
	(-16r10 63 -16r080000000000000000)
	(-16r10 64 -16r100000000000000000)
	(-16r10 65 -16r200000000000000000)

	(-16r10 126 -16r0400000000000000000000000000000000)
	(-16r10 127 -16r0800000000000000000000000000000000)
	(-16r10 128 -16r1000000000000000000000000000000000)
	(-16r10 129 -16r2000000000000000000000000000000000)
    ) triplesDo:[:val :cnt :expected |
	|rslt1 rslt2|

	rslt1 := val bitShift:cnt.
	self assert:(rslt1 = expected).
	expected class == SmallInteger ifTrue:[
	    self assert:(rslt1 == expected)
	].
	rslt2 := rslt1 bitShift:cnt negated.
	self assert:(rslt2 = val).
	val class == SmallInteger ifTrue:[
	    self assert:(rslt2 == val)
	].
    ].
!

testDivide
	|zero _1 _2 _3 _4 _m2 _m4|

	"circumvent compiler error about division by zero"
	zero := 0.

	self assert: 2 / 1 = 2.
	self assert: (3 / 2) isFraction.
	self assert: 4 / 2 = 2.
	self assert: 4 / -2 = -2.
	self assert: -4 / 2 = -2.
	self assert: -4 / -2 = 2.
	self should: [ 1 / zero ] raise: ZeroDivide.

	_1 := 1.
	_2 := 2.
	_3 := 3.
	_4 := 4.
	_m2 := -2.
	_m4 := -4.

	self assert: _2 / _1 = _2.
	self assert: (_3 / _2) isFraction.
	self assert: _4 / _2 = 2.
	self assert: _4 / _m2 = -2.
	self assert: _m4 / _2 = -2.
	self assert: _m4 / _m2 = 2.
!

testMultiply
    |i ii|

    #(
	16r3fff
	16r7fff
	16rffff
	16r3fffffff
	16r7fffffff
	16rffffffff
	16r20000000
	16r40000000
	16r80000000
	16r100000000
	16r20000001
	16r40000001
	16r80000001
	16r100000001

	"/ for 64 bit machines:
	16r3fffffffffffffff
	16r7fffffffffffffff
	16rffffffffffffffff
	16r2000000000000000
	16r4000000000000000
	16r8000000000000000
	16r10000000000000000
	16r2000000000000001
	16r4000000000000001
	16r8000000000000001
	16r10000000000000001
    ) do:[:x |
	i := x.
	ii := i * i.
	self assert:((ii / i) = i).
	i class == SmallInteger ifTrue:[
	    self assert:((ii / i) == i).
	].

	i := x negated.
	ii := i * i.
	self assert:((ii / i) = i).
	i class == SmallInteger ifTrue:[
	    self assert:((ii / i) == i).
	].
    ].
!

testNegation
    |i iN iNN|

    #(
	16r3fffffff
	16r7fffffff
	16rffffffff
	16r20000000
	16r40000000
	16r80000000
	16r100000000
	16r20000001
	16r40000001
	16r80000001
	16r100000001

	"/ for 64bit machines:
	16r3fffffffffffffff
	16r7fffffffffffffff
	16rffffffffffffffff
	16r2000000000000000
	16r4000000000000000
	16r8000000000000000
	16r10000000000000000
	16r2000000000000001
	16r4000000000000001
	16r8000000000000001
	16r10000000000000001
    ) do:[:x |
	i := x.
	iN := i negated.
	iNN := iN negated.
	self assert:(i = iNN).
	i class == SmallInteger ifTrue:[
	    self assert:(i == iNN).
	].
    ].
    self assert:(SmallInteger maxVal negated class == SmallInteger).
    self assert:(SmallInteger maxVal negated negated == SmallInteger maxVal).

    self assert:(SmallInteger maxVal negated -1 == SmallInteger minVal).
    self assert:(SmallInteger minVal negated negated class == SmallInteger).
! !

!SmallIntegerTest methodsFor:'tests-class protocol'!

testBasicNew
    self should: [SmallInteger basicNew] raise: TestResult error.
!

testMaxVal
    "/ the original code did not check for pointer-size;

    Smalltalk isSmalltalkX ifTrue:[
	SmallInteger maxBytes == 4 ifTrue:[
	    self should: [SmallInteger maxVal = 16r3FFFFFFF].
	    self should: [SmallInteger maxVal == 16r3FFFFFFF].
	] ifFalse:[
	    self should: [SmallInteger maxVal = 16r3FFFFFFFFFFFFFFF].
	    self should: [SmallInteger maxVal == 16r3FFFFFFFFFFFFFFF].
	].
    ] ifFalse:[
	self should: [SmallInteger maxVal = 16r3FFFFFFF].
    ]
!

testMaxValPointerSizeConsistency
    SmallInteger maxBytes == 4 ifTrue:[
	self assert: ((SmallInteger maxBits == 31) or:[SmallInteger maxBits == 32]).
	self assert: (ExternalAddress pointerSize == 4).
    ] ifFalse:[
	self assert: ((SmallInteger maxBits == 63) or:[SmallInteger maxBits == 64]).
	self assert: (ExternalAddress pointerSize == 8).
    ]
!

testMinVal
    "/ the original code did not check for pointer-size;

    Smalltalk isSmalltalkX ifTrue:[
	SmallInteger maxBytes == 4 ifTrue:[
	    self should: [SmallInteger minVal = -16r40000000].
	    self should: [SmallInteger minVal == -16r40000000].
	] ifFalse:[
	    self should: [SmallInteger minVal = -16r4000000000000000].
	    self should: [SmallInteger minVal == -16r4000000000000000].
	].
    ] ifFalse:[
	self should: [SmallInteger minVal = -16r40000000].
    ]
!

testNew
    self should: [SmallInteger new] raise: TestResult error.
! !

!SmallIntegerTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


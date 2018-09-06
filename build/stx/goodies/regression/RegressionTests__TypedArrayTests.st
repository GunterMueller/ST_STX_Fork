"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#TypedArrayTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!TypedArrayTests class methodsFor:'queries'!

coveredClassNames
    ^ #( FloatArray )
! !

!TypedArrayTests methodsFor:'tests'!

test01_createArrays
    |a|

    a := FloatArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:3.

    self assert:(a at:1) = 1.0.
    self assert:(a at:2) = 2.0.
    self assert:(a at:3) = 3.0.

"/ -------------------------------------

    a := DoubleArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:3.

    self assert:(a at:1) = 1.0.
    self assert:(a at:2) = 2.0.
    self assert:(a at:3) = 3.0.

"/ -------------------------------------

    a := ByteArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = 2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := SignedByteArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:-2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = -2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := WordArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = 2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := SignedWordArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:-2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = -2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := IntegerArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = 2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := SignedIntegerArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:-2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = -2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := LongIntegerArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = 2.
    self assert:(a at:3) = 3.

"/ -------------------------------------

    a := SignedLongIntegerArray new:3.

    self assert:(a size == 3).

    a at:1 put:1.
    a at:2 put:-2.
    a at:3 put:3.

    self assert:(a at:1) = 1.
    self assert:(a at:2) = -2.
    self assert:(a at:3) = 3.
!

test02_copyArrays
    |src copy|

"/ -------------------------------------

    src := FloatArray new:5.
    self assert:(src size == 5).

    src at:1 put:1.
    src at:2 put:2.
    src at:3 put:3.

    self assert:(src at:1) = 1.0.
    self assert:(src at:2) = 2.0.
    self assert:(src at:3) = 3.0.

    copy := src copyFrom:1 to:3.
    
    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.0.
    self assert:(copy at:2) = 2.0.
    self assert:(copy at:3) = 3.0.

"/ -------------------------------------

    src := DoubleArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:2.
    src at:3 put:3.

    self assert:(src at:1) = 1.0.
    self assert:(src at:2) = 2.0.
    self assert:(src at:3) = 3.0.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.0.
    self assert:(copy at:2) = 2.0.
    self assert:(copy at:3) = 3.0.

"/ -------------------------------------

    src := ByteArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = 2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = 2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := SignedByteArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:-2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = -2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = -2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := WordArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = 2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = 2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := SignedWordArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:-2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = -2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = -2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := IntegerArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = 2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = 2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := SignedIntegerArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:-2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = -2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = -2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := LongIntegerArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = 2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = 2.
    self assert:(copy at:3) = 3.

"/ -------------------------------------

    src := SignedLongIntegerArray new:9.
    self assert:(src size == 9).

    src at:1 put:1.
    src at:2 put:-2.
    src at:3 put:3.

    self assert:(src at:1) = 1.
    self assert:(src at:2) = -2.
    self assert:(src at:3) = 3.

    copy := src copyFrom:1 to:3.

    self assert:(copy size == 3).
    self assert:(copy at:1) = 1.
    self assert:(copy at:2) = -2.
    self assert:(copy at:3) = 3.
!

test03_byteAt
    |a flt1 flt2 flt3|

"/ -------------------------------------

    a := FloatArray new:3.

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:99.

    flt1 := 1 asShortFloat.
    flt2 := 2 asShortFloat.
    flt3 := 3 asShortFloat.

    self assert:(a byteAt:1) = (flt1 byteAt:1).
    self assert:(a byteAt:2) = (flt1 byteAt:2).
    self assert:(a byteAt:3) = (flt1 byteAt:3).
    self assert:(a byteAt:4) = (flt1 byteAt:4).

    self assert:(a byteAt:5) = (flt2 byteAt:1).
    self assert:(a byteAt:6) = (flt2 byteAt:2).
    self assert:(a byteAt:7) = (flt2 byteAt:3).
    self assert:(a byteAt:8) = (flt2 byteAt:4).

    a byteAt:5 put:(flt3 byteAt:1).
    a byteAt:6 put:(flt3 byteAt:2).
    a byteAt:7 put:(flt3 byteAt:3).
    a byteAt:8 put:(flt3 byteAt:4).

    self assert:(a at:1) = flt1.
    self assert:(a at:2) = flt3.
    self assert:(a at:3) = 99.

"/ -------------------------------------

    a := DoubleArray new:3.

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:99.

    flt1 := 1 asFloat.
    flt2 := 2 asFloat.
    flt3 := 3 asFloat.

    self assert:(a byteAt:1) = (flt1 byteAt:1).
    self assert:(a byteAt:2) = (flt1 byteAt:2).
    self assert:(a byteAt:3) = (flt1 byteAt:3).
    self assert:(a byteAt:4) = (flt1 byteAt:4).
    self assert:(a byteAt:5) = (flt1 byteAt:5).
    self assert:(a byteAt:6) = (flt1 byteAt:6).
    self assert:(a byteAt:7) = (flt1 byteAt:7).
    self assert:(a byteAt:8) = (flt1 byteAt:8).

    self assert:(a byteAt:9)  = (flt2 byteAt:1).
    self assert:(a byteAt:10) = (flt2 byteAt:2).
    self assert:(a byteAt:11) = (flt2 byteAt:3).
    self assert:(a byteAt:12) = (flt2 byteAt:4).
    self assert:(a byteAt:13) = (flt2 byteAt:5).
    self assert:(a byteAt:14) = (flt2 byteAt:6).
    self assert:(a byteAt:15) = (flt2 byteAt:7).
    self assert:(a byteAt:16) = (flt2 byteAt:8).

    a byteAt:9  put:(flt3 byteAt:1).
    a byteAt:10 put:(flt3 byteAt:2).
    a byteAt:11 put:(flt3 byteAt:3).
    a byteAt:12 put:(flt3 byteAt:4).
    a byteAt:13 put:(flt3 byteAt:5).
    a byteAt:14 put:(flt3 byteAt:6).
    a byteAt:15 put:(flt3 byteAt:7).
    a byteAt:16 put:(flt3 byteAt:8).

    self assert:(a at:1) = flt1.
    self assert:(a at:2) = flt3.
    self assert:(a at:3) = 99.

"/ -------------------------------------

    a := IntegerArray new:3.

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:99.

    "/ this depends on the machine's byte order!!
    UninterpretedBytes isBigEndian ifTrue:[
        self assert:(a byteAt:1) = 0.
        self assert:(a byteAt:2) = 0.
        self assert:(a byteAt:3) = 0.
        self assert:(a byteAt:4) = 1.

        self assert:(a byteAt:5) = 0.
        self assert:(a byteAt:6) = 0.
        self assert:(a byteAt:7) = 0.
        self assert:(a byteAt:8) = 2.

        a byteAt:5 put:(flt3 byteAt:1).
        a byteAt:6 put:(flt3 byteAt:2).
        a byteAt:7 put:(flt3 byteAt:3).
        a byteAt:8 put:(flt3 byteAt:4).

        a byteAt:8 put:3.
    ] ifFalse:[
        self assert:(a byteAt:1) = 1.
        self assert:(a byteAt:2) = 0.
        self assert:(a byteAt:3) = 0.
        self assert:(a byteAt:4) = 0.

        self assert:(a byteAt:5) = 2.
        self assert:(a byteAt:6) = 0.
        self assert:(a byteAt:7) = 0.
        self assert:(a byteAt:8) = 0.

        a byteAt:5 put:3.
    ].

    self assert:(a at:1) = 1.
    self assert:(a at:2) = 3.
    self assert:(a at:3) = 99.

"/ -------------------------------------

    a := LongIntegerArray new:3.

    a at:1 put:1.
    a at:2 put:2.
    a at:3 put:99.

    "/ this depends on the machine's byte order!!
    UninterpretedBytes isBigEndian ifTrue:[
        self assert:(a byteAt:1) = 0.
        self assert:(a byteAt:2) = 0.
        self assert:(a byteAt:3) = 0.
        self assert:(a byteAt:4) = 0.
        self assert:(a byteAt:5) = 0.
        self assert:(a byteAt:6) = 0.
        self assert:(a byteAt:7) = 0.
        self assert:(a byteAt:8) = 1.

        self assert:(a byteAt:8+1) = 0.
        self assert:(a byteAt:8+2) = 0.
        self assert:(a byteAt:8+3) = 0.
        self assert:(a byteAt:8+4) = 0.
        self assert:(a byteAt:8+5) = 0.
        self assert:(a byteAt:8+6) = 0.
        self assert:(a byteAt:8+7) = 0.
        self assert:(a byteAt:8+8) = 2.

        a byteAt:8+8 put:3.
    ] ifFalse:[
        self assert:(a byteAt:1) = 1.
        self assert:(a byteAt:2) = 0.
        self assert:(a byteAt:3) = 0.
        self assert:(a byteAt:4) = 0.
        self assert:(a byteAt:5) = 0.
        self assert:(a byteAt:6) = 0.
        self assert:(a byteAt:7) = 0.
        self assert:(a byteAt:8) = 0.

        self assert:(a byteAt:8+1) = 2.
        self assert:(a byteAt:8+2) = 0.
        self assert:(a byteAt:8+3) = 0.
        self assert:(a byteAt:8+4) = 0.
        self assert:(a byteAt:8+5) = 0.
        self assert:(a byteAt:8+6) = 0.
        self assert:(a byteAt:8+7) = 0.
        self assert:(a byteAt:8+8) = 0.

        a byteAt:8+1 put:3.
    ].

    self assert:(a at:1) = 1.
    self assert:(a at:2) = 3.
    self assert:(a at:3) = 99.

"/ -------------------------------------

    a := SignedLongIntegerArray new:3.

    a at:1 put:1.
    a at:2 put:-2.
    a at:3 put:99.

    "/ this depends on the machine's byte order!!
    UninterpretedBytes isBigEndian ifTrue:[
        self assert:(a byteAt:1) = 0.
        self assert:(a byteAt:2) = 0.
        self assert:(a byteAt:3) = 0.
        self assert:(a byteAt:4) = 0.
        self assert:(a byteAt:5) = 0.
        self assert:(a byteAt:6) = 0.
        self assert:(a byteAt:7) = 0.
        self assert:(a byteAt:8) = 1.

        self assert:(a byteAt:8+1) = 16rFF.
        self assert:(a byteAt:8+2) = 16rFF.
        self assert:(a byteAt:8+3) = 16rFF.
        self assert:(a byteAt:8+4) = 16rFF.
        self assert:(a byteAt:8+5) = 16rFF.
        self assert:(a byteAt:8+6) = 16rFF.
        self assert:(a byteAt:8+7) = 16rFF.
        self assert:(a byteAt:8+8) = 16rFE.

        a byteAt:8+8 put:16rFD.
    ] ifFalse:[
        self assert:(a byteAt:1) = 1.
        self assert:(a byteAt:2) = 0.
        self assert:(a byteAt:3) = 0.
        self assert:(a byteAt:4) = 0.
        self assert:(a byteAt:5) = 0.
        self assert:(a byteAt:6) = 0.
        self assert:(a byteAt:7) = 0.
        self assert:(a byteAt:8) = 0.

        self assert:(a byteAt:8+1) = 16rFE.
        self assert:(a byteAt:8+2) = 16rFF.
        self assert:(a byteAt:8+3) = 16rFF.
        self assert:(a byteAt:8+4) = 16rFF.
        self assert:(a byteAt:8+5) = 16rFF.
        self assert:(a byteAt:8+6) = 16rFF.
        self assert:(a byteAt:8+7) = 16rFF.
        self assert:(a byteAt:8+8) = 16rFF.

        a byteAt:8+1 put:16rFD.
    ].

    self assert:(a at:1) = 1.
    self assert:(a at:2) = -3.
    self assert:(a at:3) = 99.

"/ -------------------------------------
"/ -------------------------------------

    "Modified: / 26-08-2016 / 13:27:57 / cg"
! !

!TypedArrayTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


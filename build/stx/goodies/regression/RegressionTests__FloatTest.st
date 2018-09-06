"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#FloatTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!

!FloatTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FloatTest methodsFor:'helpers'!

actualPrecisionOf:aFloatClass
    "get the actual number of valid bits in the mantissa.
     This does a real test (i.e. does not believe the compiled-in ifdefs)"

    |one x count two|

    one := aFloatClass unity.  "/ 1.0 in this class
    two := one coerce:2.0.
    x := one.
    count := 0.
    
    [one + x > one] whileTrue:[
	x := x / two.
	count := count + 1.
    ].
    ^ count

    "
     self basicNew actualPrecisionOf:ShortFloat
     self basicNew actualPrecisionOf:Float
     self basicNew actualPrecisionOf:LongFloat
    "
! !

!FloatTest methodsFor:'tests'!

test00_Precision
    "computed precision vs. assumed precision."

    |a b|

    self assert:( (a := Float precision) = (b := self actualPrecisionOf:Float))
                description:('Float precision: %1 ~~ actual: %2' bindWith:a with:b).
    self assert:( (a := ShortFloat precision) = (b := self actualPrecisionOf:ShortFloat))
                description:('ShortFloat precision: %1 ~~ actual: %2' bindWith:a with:b).
    "
     self basicNew test00_Precision
    "

    "Modified: / 03-05-2012 / 18:47:21 / cg"
    "Modified: / 12-07-2016 / 14:59:00 / jv"
!

test00_Precision2
    "computed precision vs. assumed precision."

    |a b|

    self skipIf: OperatingSystem isMSWINDOWSlike description:'Known to fail on Windows/MING for an unknown reason'.
    self assert:( (a := LongFloat precision) = (b := self actualPrecisionOf:LongFloat))
                description:('LongFloat precision: %1 ~~ actual: %2' bindWith:a with:b).

    "
     self basicNew test00_Precision2
    "

    "Created: / 12-07-2016 / 14:58:54 / jv"
!

test01_Nan
    "NaN in all avaliable formats."

    |shouldBeFloatNaN shouldBeLongFloatNaN shouldBeShortFloatNaN|

    shouldBeFloatNaN := 0.0 uncheckedDivide: 0.0.
    self assert:( shouldBeFloatNaN isMemberOf:Float ).
    self assert:( shouldBeFloatNaN isNaN ).
    self assert:( shouldBeFloatNaN isFinite not ).

    shouldBeShortFloatNaN := 0.0 asShortFloat uncheckedDivide: 0.0 asShortFloat.
    self assert:( shouldBeShortFloatNaN isMemberOf:ShortFloat ).
    self assert:( shouldBeShortFloatNaN isNaN ).
    self assert:( shouldBeShortFloatNaN isFinite not ).

    shouldBeLongFloatNaN := 0.0 asLongFloat uncheckedDivide: 0.0 asLongFloat.
    self assert:( shouldBeLongFloatNaN isMemberOf:LongFloat ).
    self assert:( shouldBeLongFloatNaN isNaN ).
    self assert:( shouldBeLongFloatNaN isFinite not ).

    shouldBeFloatNaN := 0.0 uncheckedDivide: 0.0.
    self assert:( shouldBeFloatNaN asShortFloat isNaN ).
    self assert:( shouldBeFloatNaN asLongFloat isNaN ).

    shouldBeShortFloatNaN := 0.0 asShortFloat uncheckedDivide: 0.0.
    self assert:( shouldBeShortFloatNaN asFloat isNaN ).
    self assert:( shouldBeShortFloatNaN asLongFloat isNaN ).

    shouldBeLongFloatNaN := 0.0 asLongFloat uncheckedDivide: 0.0.
    self assert:( shouldBeLongFloatNaN asShortFloat isNaN ).
    self assert:( shouldBeLongFloatNaN asLongFloat isNaN ).

    shouldBeFloatNaN := 0.0 uncheckedDivide: 0.0.
    self should:[ shouldBeFloatNaN asInteger ] raise:DomainError.

"/ mhmh - the following are not true (they silently return NaNs).
"/    self should:[ shouldBeFloatNaN + 1 ] raise:DomainError.
"/    self should:[ shouldBeFloatNaN + 1.0 ] raise:DomainError.
"/    self should:[ shouldBeFloatNaN + 1.0 asShortFloat ] raise:DomainError.
"/    self should:[ shouldBeFloatNaN + 1.0 asLongFloat ] raise:DomainError.
"/
"/    self should:[ shouldBeFloatNaN - 1 ] raise:DomainError.
"/    self should:[ shouldBeFloatNaN - 1.0 ] raise:DomainError.
"/    self should:[ shouldBeFloatNaN - 1.0 asShortFloat ] raise:DomainError.
"/    self should:[ shouldBeFloatNaN - 1.0 asLongFloat ] raise:DomainError.

    "/ but these are:
    self assert:( shouldBeFloatNaN + 1 ) isNaN.
    self assert:( shouldBeFloatNaN + 1.0 ) isNaN.
    self assert:( shouldBeFloatNaN + 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeFloatNaN + 1.0 asLongFloat ) isNaN.

    self assert:( shouldBeFloatNaN - 1 ) isNaN.
    self assert:( shouldBeFloatNaN - 1.0 ) isNaN.
    self assert:( shouldBeFloatNaN - 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeFloatNaN - 1.0 asLongFloat ) isNaN.


    shouldBeShortFloatNaN := 0.0 asShortFloat uncheckedDivide: 0.0.
    self should:[ shouldBeShortFloatNaN asInteger ] raise:DomainError.

    self assert:( shouldBeShortFloatNaN + 1 ) isNaN.
    self assert:( shouldBeShortFloatNaN + 1.0 ) isNaN.
    self assert:( shouldBeShortFloatNaN + 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeShortFloatNaN + 1.0 asLongFloat ) isNaN.

    self assert:( shouldBeShortFloatNaN - 1 ) isNaN.
    self assert:( shouldBeShortFloatNaN - 1.0 ) isNaN.
    self assert:( shouldBeShortFloatNaN - 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeShortFloatNaN - 1.0 asLongFloat ) isNaN.

    shouldBeLongFloatNaN := 0.0 asLongFloat uncheckedDivide: 0.0.
    self should:[ shouldBeLongFloatNaN asInteger ] raise:DomainError.

    self assert:( shouldBeLongFloatNaN + 1 ) isNaN.
    self assert:( shouldBeLongFloatNaN + 1.0 ) isNaN.
    self assert:( shouldBeLongFloatNaN + 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeLongFloatNaN + 1.0 asLongFloat ) isNaN.

    self assert:( shouldBeLongFloatNaN - 1 ) isNaN.
    self assert:( shouldBeLongFloatNaN - 1.0 ) isNaN.
    self assert:( shouldBeLongFloatNaN - 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeLongFloatNaN - 1.0 asLongFloat ) isNaN.

    "
     self basicNew test01_Nan
    "
!

test02_Inf
    "Infinity in all avaliable formats."

    |check posInf negInf|

    check :=
	[:v1 :v2 |

	    posInf := v1 uncheckedDivide: v2.

	    self assert:( posInf isMemberOf:v1 class ).
	    self assert:( posInf isNaN not ).
	    self assert:( posInf isFinite not ).
	    self assert:( posInf isInfinite ).
	    self assert:( posInf positive ).
	    self assert:( posInf negative not ).
	    self assert:( posInf isNegativeInfinity not).
	    self assert:( posInf isPositiveInfinity ).

	    negInf := v1 negated uncheckedDivide: v2.

	    self assert:( negInf isMemberOf:v1 class ).
	    self assert:( negInf isNaN not ).
	    self assert:( negInf isFinite not ).
	    self assert:( negInf isInfinite ).
	    self assert:( negInf positive not).
	    self assert:( negInf negative ).
	    self assert:( negInf isNegativeInfinity ).
	    self assert:( negInf isPositiveInfinity not ).

	    self assert:( negInf + negInf = negInf).
	    self assert:( posInf + posInf = posInf).
	    self assert:( negInf + posInf) isNaN.
	    self assert:( posInf + negInf) isNaN.

	    self assert:( negInf - posInf = negInf).
	    self assert:( negInf - negInf) isNaN.
	    self assert:( posInf - negInf = posInf).
	    self assert:( posInf - posInf) isNaN.

	    self assert:( posInf + v1) = posInf.
	    self assert:( posInf - v1) = posInf.
	    self assert:( negInf + v1) = negInf.
	    self assert:( negInf - v1) = negInf.
	].

    check value: 1.0 value: 0.0.
    check value: 1.0 asShortFloat value: 0.0 asShortFloat.
    check value: 1.0 asLongFloat value: 0.0 asLongFloat.

"/ these are not guaranteed to work with uncheckedDivide...
"/    check value: 1.0 value: 0.0 asShortFloat.
"/    check value: 1.0 value: 0.0 asLongFloat.
"/
"/    check value: 1.0 asShortFloat value: 0.0.
"/    check value: 1.0 asShortFloat value: 0.0 asLongFloat.
"/
"/    check value: 1.0 asLongFloat value: 0.0 asShortFloat.
"/    check value: 1.0 asLongFloat value: 0.0.

    "
     self basicNew test02_Inf
    "
!

test03_Conversion
    self assert:( 1.0 asTrueFraction == 1 ).
    self assert:( 2.0 asTrueFraction == 2 ).
    self assert:( 4.0 asTrueFraction == 4 ).
    self assert:( 8.0 asTrueFraction == 8 ).
    self assert:( 16.0 asTrueFraction == 16 ).
    self assert:( 1048576.0 asTrueFraction == 1048576 ).
    self assert:( 0.5 asTrueFraction = (1/2) ).
    self assert:( 0.25 asTrueFraction = (1/4) ).
    self assert:( 0.125 asTrueFraction = (1/8) ).

    self assert:( 1.0 asShortFloat asTrueFraction == 1 ).
    self assert:( 2.0 asShortFloat asTrueFraction == 2 ).
    self assert:( 4.0 asShortFloat asTrueFraction == 4 ).
    self assert:( 8.0 asShortFloat asTrueFraction == 8 ).
    self assert:( 16.0 asShortFloat asTrueFraction == 16 ).
    self assert:( 1048576.0 asShortFloat asTrueFraction == 1048576 ).
    self assert:( 0.5 asShortFloat asTrueFraction = (1/2) ).
    self assert:( 0.25 asShortFloat asTrueFraction = (1/4) ).
    self assert:( 0.125 asShortFloat asTrueFraction = (1/8) ).

    self assert:( 1.0 asLongFloat asTrueFraction == 1 ).
    self assert:( 2.0 asLongFloat asTrueFraction == 2 ).
    self assert:( 4.0 asLongFloat asTrueFraction == 4 ).
    self assert:( 8.0 asLongFloat asTrueFraction == 8 ).
    self assert:( 16.0 asLongFloat asTrueFraction == 16 ).
    self assert:( 1048576.0 asLongFloat asTrueFraction == 1048576 ).
    self assert:( 0.5 asLongFloat asTrueFraction = (1/2) ).
    self assert:( 0.25 asLongFloat asTrueFraction = (1/4) ).
    self assert:( 0.125 asLongFloat asTrueFraction = (1/8) ).

    self assert: ((5/9) asFloat     - 0.555555555555) abs < 0.0000000001.
    self assert: ((5/9) asLongFloat - 0.555555555555) abs < 0.0000000001.
    self assert: ((Fraction basicNew setNumerator:500000000000 denominator:900000000000)
			asLongFloat - 0.555555555555) abs <  0.000000000001.
    self assert: ((Fraction basicNew setNumerator:500000000001 denominator:900000000000)
			asLongFloat - 0.555555555555) abs >= 0.000000000001.

    "/ under windows, a longFloat has only 10bytes with 64 bits precision
    OperatingSystem isMSWINDOWSlike ifFalse:[
	self assert: (8901234567890123456 asLongFloat asInteger = 8901234567890123456).
	self assert: (-8901234567890123456 asLongFloat asInteger = -8901234567890123456).
    ].
    self assert: (89012345678901234567 asLongFloat = 89012345678901234567).
    self assert: (-89012345678901234567 asLongFloat = -89012345678901234567).
    self assert: (89012345678901234567 negated asLongFloat = -89012345678901234567).

    self assert: ((89012345678901234567 / 123456789123456789) asLongFloat  - (89012345678901234567 asLongFloat / 123456789123456789 asLongFloat) ) abs < 0.000000000001.
    self assert: ((-89012345678901234567 / 123456789123456789) asLongFloat - (-89012345678901234567 asLongFloat / 123456789123456789 asLongFloat)) abs < 0.000000000001.

    "
     self basicNew test03_Conversion
    "

    "Modified: / 09-08-2011 / 21:01:57 / cg"
!

test04_Arithmetic
    self assert:( 1.0 + 1.0 ) class == Float.
    self assert:( 1.0 + 1.0 asShortFloat) class == Float.
    self assert:( 1.0 + 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 + 1) class == Float.

    self assert:( 1.0 asShortFloat + 1.0 ) class == Float.
    self assert:( 1.0 asShortFloat + 1.0 asShortFloat) class == ShortFloat.
    self assert:( 1.0 asShortFloat + 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 asShortFloat + 1) class == ShortFloat.

    self assert:( 1.0 asLongFloat + 1.0 ) class == LongFloat.
    self assert:( 1.0 asLongFloat + 1.0 asShortFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat + 1.0 asFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat + 1 ) class == LongFloat.


    self assert:( 1.0 - 1.0 ) class == Float.
    self assert:( 1.0 - 1.0 asShortFloat) class == Float.
    self assert:( 1.0 - 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 - 1) class == Float.

    self assert:( 1.0 asShortFloat - 1.0 ) class == Float.
    self assert:( 1.0 asShortFloat - 1.0 asShortFloat) class == ShortFloat.
    self assert:( 1.0 asShortFloat - 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 asShortFloat - 1) class == ShortFloat.

    self assert:( 1.0 asLongFloat - 1.0 ) class == LongFloat.
    self assert:( 1.0 asLongFloat - 1.0 asShortFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat - 1.0 asFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat - 1 ) class == LongFloat.


    self assert:( 1.0 * 1.0 ) class == Float.
    self assert:( 1.0 * 1.0 asShortFloat) class == Float.
    self assert:( 1.0 * 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 * 1) class == Float.

    self assert:( 1.0 asShortFloat * 1.0 ) class == Float.
    self assert:( 1.0 asShortFloat * 1.0 asShortFloat) class == ShortFloat.
    self assert:( 1.0 asShortFloat * 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 asShortFloat * 1) class == ShortFloat.

    self assert:( 1.0 asLongFloat * 1.0 ) class == LongFloat.
    self assert:( 1.0 asLongFloat * 1.0 asShortFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat * 1.0 asFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat * 1 ) class == LongFloat.


    self assert:( 1.0 / 1.0 ) class == Float.
    self assert:( 1.0 / 1.0 asShortFloat) class == Float.
    self assert:( 1.0 / 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 / 1) class == Float.

    self assert:( 1.0 asShortFloat / 1.0 ) class == Float.
    self assert:( 1.0 asShortFloat / 1.0 asShortFloat) class == ShortFloat.
    self assert:( 1.0 asShortFloat / 1.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 asShortFloat / 1) class == ShortFloat.

    self assert:( 1.0 asLongFloat / 1.0 ) class == LongFloat.
    self assert:( 1.0 asLongFloat / 1.0 asShortFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat / 1.0 asFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat / 1 ) class == LongFloat.

    self assert:( 1.0 / 2.0 ) class == Float.
    self assert:( 1.0 / 2.0 asShortFloat) class == Float.
    self assert:( 1.0 / 2.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 / 2) class == Float.

    self assert:( 1.0 asShortFloat / 2.0 ) class == Float.
    self assert:( 1.0 asShortFloat / 2.0 asShortFloat) class == ShortFloat.
    self assert:( 1.0 asShortFloat / 2.0 asLongFloat) class == LongFloat.
    self assert:( 1.0 asShortFloat / 2) class == ShortFloat.

    self assert:( 1.0 asLongFloat / 2.0 ) class == LongFloat.
    self assert:( 1.0 asLongFloat / 2.0 asShortFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat / 2.0 asFloat ) class == LongFloat.
    self assert:( 1.0 asLongFloat / 2 ) class == LongFloat.

    self assert:( 5.0 rem: 2.0 ) class == Float.
    self assert:( 5.0 rem: 2.0 asShortFloat) class == Float.
    self assert:( 5.0 rem: 2.0 asLongFloat) class == LongFloat.
    self assert:( 5.0 rem: 2) class == Float.

    self assert:( 5.0 asShortFloat rem: 2.0 ) class == Float.
    self assert:( 5.0 asShortFloat rem: 2.0 asShortFloat) class == ShortFloat.
    self assert:( 5.0 asShortFloat rem: 2.0 asLongFloat) class == LongFloat.
    self assert:( 5.0 asShortFloat rem: 2) class == ShortFloat.

    self assert:( 5.0 asLongFloat rem: 2.0 ) class == LongFloat.
    self assert:( 5.0 asLongFloat rem: 2.0 asShortFloat ) class == LongFloat.
    self assert:( 5.0 asLongFloat rem: 2.0 asFloat ) class == LongFloat.
    self assert:( 5.0 asLongFloat rem: 2 ) class == LongFloat.

    "
     self basicNew test04_Arithmetic
    "
!

test05_Comparing
    |check v1 v2 v1b|

    check := [:iv1 :iv2|
	#(yourself asInteger asFloat asShortFloat asLongFloat asLargeFloat) do:[:conv1 |
	    v1 := (iv1 perform:conv1).

	    self assert:( v1 = nil ) not.
	    self assert:( nil = v1 ) not.
	    self assert:( v1 ~= nil ).
	    self assert:( nil ~= v1 ).

	    #(yourself asInteger asFloat asShortFloat asLongFloat asLargeFloat) do:[:conv2 |
		v1b := (iv1 perform:conv2).

		self assert:( v1 = v1b ).
		self assert:( v1 <= v1b ).
		self assert:( v1 >= v1b ).

		v2 := (iv2 perform:conv2).

		self assert:( v1 < v2 ).
		self assert:( v1 <= v2 ).
		self assert:( v2 >= v1 ).
		self assert:( v2 > v1 ).
	    ]
	].
    ].

    check value:2 value:3.
    check value:0 value:1.
    check value:-1 value:0.
    check value:-3 value:-2.
    check value:-3 value:3.

    check value:-30 value:1.
    check value:-1 value:30.

    self assert:( 200000000000000000000.0 = 200000000000000000001 ).

    self assert:( 200000000000000000000.0 = 200000000000000000000 ).
    self assert:( 200000000000000000000.0 asLongFloat = 200000000000000000000 ).
    self assert:( 2000000.0 asShortFloat = 2000000 ).

    self assert:( 200000000000000000000 = 200000000000000000000.0).
    self assert:( 200000000000000000000 = 200000000000000000000.0 asLongFloat ).
    self assert:( 2000000 = 2000000.0 asShortFloat ).


    self assert:( 200000000000000000000.0 < 200000100000000000000 ).
    self assert:( 200000000000000000000.0 asLongFloat < 200000000000100000000 ).
    self assert:( 200000000000000000000.0 asShortFloat < 200001000000000000000 ).

    self assert:( 200000000000000000000 < 200001000000000000000.0).
    self assert:( 200000000000000000000 < 200001000000000000000.0 asLongFloat ).
    self assert:( 200000000000000000000 < 200001000000000000000.0 asShortFloat ).


    self assert:( 200000000000000000000.0 <= 200000100000000000000 ).
    self assert:( 200000000000000000000.0 <= 200000000000000000000 ).
    self assert:( 200000000000000000000.0 asLongFloat <= 200000000000000000001 ).
    self assert:( 200000000000000000000.0 asLongFloat <= 200000000000000000000 ).
    self assert:( 2000000.0 asShortFloat <= 200000100000000000000 ).
    self assert:( 2000000.0 asShortFloat <= 2000000 ).

    self assert:( 200000000000000000000 <= 200001000000000000000.0).
    self assert:( 200000000000000000000 <= 200000000000000000000.0).
    self assert:( 200000000000000000000 <= 200001000000000000000.0 asLongFloat ).
    self assert:( 200000000000000000000 <= 200000000000000000000.0 asLongFloat ).
    self assert:( 2000000 <= 2000000.0 asShortFloat ).
    self assert:( 2000000 <= 2000000.0 asShortFloat ).

    "
     self basicNew test05_Comparing
    "
!

test06_MiscMath
    |epsilon|

    epsilon := 0.000001.

    #(
	sqrt       0.5       0.707107
	exp        0.5       1.64872
	ln         0.5       -0.693147
	log10      0.5       -0.30103

	sin        0.5      0.479426
	cos        0.5      0.877583
	tan        0.5      0.546302
	arcSin     0.5      0.523599
	arcCos     0.5      1.0472
	arcTan     0.5      0.463648
	sinh       0.5      0.521095
	cosh       0.5      1.12763
	tanh       0.5      0.462117
	arcSinh    0.5      0.481212
	arcCosh    1.5      1.24983
	arcTanh    0.5      0.549306

	sin        0.0      0.0
	cos        0.0      1.0
	tan        0.0      0.0
	sinh       0.0      0.0
	cosh       0.0      1.0
	tanh       0.0      0.0

	sin        1.0      0.841471
	cos        1.0      0.540302
	tan        1.0      1.55741
	sinh       1.0      1.1752
	cosh       1.0      1.54308
	tanh       1.0      0.761594

	sin        3.14159  0.0
	cos        3.14159  -1.0
	tan        3.14159  0.0
	sinh       3.14159  11.5487
	cosh       3.14159  11.5919
	tanh       3.14159  0.996272


	tan        0.785398 1.0         "pi/4  -> should be 1"
	arcCos     -1.0     3.14159     "should be pi"
	arcSin     1.0      1.5708      "should be pi/2 (1.5708)"
	arcTan     1.0      0.785398    "should be pi/4 (.785398)"
    ) inGroupsOf:3 do:[:op :x :expected|
	|rslt rsltShortFloat rsltLongFloat rsltLargeFloat|

	rslt := x perform:op.
	rsltShortFloat := x asShortFloat perform:op.
	rsltLongFloat := x asLongFloat perform:op.
"/        rsltLargeFloat := arg asLargeFloat perform:op.

	self assert:(rslt class == Float).
	"/ self assert:(rsltShortFloat class == Float).  "/ ??? not a good test; some return a float
	self assert:(rsltLongFloat class == LongFloat).

	self assert:( rslt - rsltShortFloat ) < epsilon.
	self assert:( rslt - rsltLongFloat ) < epsilon.
"/        self assert:( rslt - rsltLargeFloat ) < epsilon.
	self assert:( rslt - rslt asShortFloat ) < epsilon.
	self assert:( rslt - rslt asLongFloat ) < epsilon.
"/        self assert:( rslt - rslt asLargeFloat ) < epsilon.
    ].

    self should:[ -2 arcSin ] raise:DomainError.
    self should:[ -2 arcCos ] raise:DomainError.
    self should:[ -1 arcTanh ] raise:DomainError.

    #(
	0.0
	0.5
	1.0
	2.0
	1.57079
     ) do:[:x |
	self assert:( x sin arcSin - x < epsilon).
	self assert:( x cos arcCos - x < epsilon).
	self assert:( x tan arcTan - x < epsilon).
    ].

    #(
	-1.0
	-0.5
	0.0
	0.5
	1.0
     ) do:[:x |
	self assert:( x arcSin sin - x < epsilon).
	self assert:( x arcCos cos - x < epsilon).
	self assert:( x arcTan tan - x < epsilon).
    ].

    #(
	0.0
	0.5
	1.0
	2.0
	10
     ) do:[:x |
	self assert:( x cosh arcCosh - x < epsilon).
    ].
    #(
	-10
	-2
	-1
	-0.5
	0.0
	0.5
	1.0
	2.0
	10
     ) do:[:x |
	self assert:( x sinh arcSinh - x < epsilon).
	self assert:( x tanh arcTanh - x < epsilon).
    ].


    #(
	-0.99
	-0.5
	0.0
	0.5
	0.99
     ) do:[:x |
	self assert:( x arcTanh - (( ( (1+x)/(1-x) ) ln ) / 2 ) ) < epsilon.
    ].

    #(
	-10
	-5
	-2.0
	-1.0
	0.0
	1.0
	2.0
	10
     ) do:[:x |
	self assert:( x arcSinh sinh - x < epsilon).
    ].

    #(
	1.0
	2.0
	10.0
     ) do:[:x |
	self assert:( x arcCosh cosh - x < epsilon).
    ].

    "
     self basicNew test06_MiscMath
    "

    "Modified (comment): / 27-02-2016 / 00:33:20 / cg"
!

test07_Truncation
    |check|

    check := [:num |
	self assert:( num fractionPart + num truncated ) = num.
	self assert:( num fractionPart + num truncated ) class == num class.
    ].

    check value:1.6.
    check value:-1.6.

    check value:1.6 asShortFloat.
    check value:-1.6 asShortFloat.

    check value:1.6 asLongFloat.
    check value:-1.6 asLongFloat.


    self assert:( 1.6 ceiling ) = 2.
    self assert:( 1.6 asShortFloat ceiling ) = 2.
    self assert:( 1.6 asLongFloat ceiling ) = 2.

    self assert:( 1.6 ceilingAsFloat ) = 2.0.
    self assert:( 1.6 ceilingAsFloat ) class == Float.
    self assert:( 1.6 asShortFloat ceilingAsFloat ) = 2.0 asShortFloat.
    self assert:( 1.6 asShortFloat ceilingAsFloat ) class == ShortFloat.
    self assert:( 1.6 asLongFloat ceilingAsFloat ) = 2.0 asLongFloat.
    self assert:( 1.6 asLongFloat ceilingAsFloat ) class == LongFloat.


    self assert:( 1.6 floor ) = 1.
    self assert:( 1.6 asShortFloat floor ) = 1.
    self assert:( 1.6 asLongFloat floor ) = 1.

    self assert:( 1.6 floorAsFloat ) = 1.0.
    self assert:( 1.6 floorAsFloat ) class == Float.
    self assert:( 1.6 asShortFloat floorAsFloat ) = 1.0 asShortFloat.
    self assert:( 1.6 asShortFloat floorAsFloat ) class == ShortFloat.
    self assert:( 1.6 asLongFloat floorAsFloat ) = 1.0 asLongFloat.
    self assert:( 1.6 asLongFloat floorAsFloat ) class == LongFloat.


    self assert:( 0.4 rounded ) class == SmallInteger.
    self assert:( 0.4 rounded = 0 ).
    self assert:( 0.5 rounded = 1 ).
    self assert:( 0.6 rounded = 1 ).
    self assert:( -0.4 rounded = 0 ).
    self assert:( -0.5 rounded = -1 ).
    self assert:( -0.6 rounded = -1 ).

    self assert:( 0.4 roundedAsFloat ) class == Float.
    self assert:( 0.4 roundedAsFloat  = 0.0 ).
    self assert:( 0.5 roundedAsFloat  = 1.0 ).
    self assert:( 0.6 roundedAsFloat  = 1.0 ).
    self assert:( -0.4 roundedAsFloat = 0 ).
    self assert:( -0.5 roundedAsFloat = -1.0 ).
    self assert:( -0.6 roundedAsFloat = -1.0 ).

    self assert:( 0.4 asShortFloat rounded ) class == SmallInteger.
    self assert:( 0.4 asShortFloat rounded = 0 ).
    self assert:( 0.5 asShortFloat rounded = 1 ).
    self assert:( 0.6 asShortFloat rounded = 1 ).
    self assert:( -0.4 asShortFloat rounded = 0 ).
    self assert:( -0.5 asShortFloat rounded = -1 ).
    self assert:( -0.6 asShortFloat rounded = -1 ).

    self assert:( 0.4 asShortFloat roundedAsFloat ) class == ShortFloat.
    self assert:( 0.4 asShortFloat roundedAsFloat  = 0.0 ).
    self assert:( 0.5 asShortFloat roundedAsFloat  = 1.0 ).
    self assert:( 0.6 asShortFloat roundedAsFloat  = 1.0 ).
    self assert:( -0.4 asShortFloat roundedAsFloat = 0 ).
    self assert:( -0.5 asShortFloat roundedAsFloat = -1.0 ).
    self assert:( -0.6 asShortFloat roundedAsFloat = -1.0 ).

    self assert:( 0.4 asLongFloat rounded ) class == SmallInteger.
    self assert:( 0.4 asLongFloat rounded = 0 ).
    self assert:( 0.5 asLongFloat rounded = 1 ).
    self assert:( 0.6 asLongFloat rounded = 1 ).
    self assert:( -0.4 asLongFloat rounded = 0 ).
    self assert:( -0.5 asLongFloat rounded = -1 ).
    self assert:( -0.6 asLongFloat rounded = -1 ).

    self assert:( 0.4 asLongFloat roundedAsFloat ) class == LongFloat.
    self assert:( 0.4 asLongFloat roundedAsFloat  = 0.0 ).
    self assert:( 0.5 asLongFloat roundedAsFloat  = 1.0 ).
    self assert:( 0.6 asLongFloat roundedAsFloat  = 1.0 ).
    self assert:( -0.4 asLongFloat roundedAsFloat = 0 ).
    self assert:( -0.5 asLongFloat roundedAsFloat = -1.0 ).
    self assert:( -0.6 asLongFloat roundedAsFloat = -1.0 ).

    self assert:( 0.4 truncated ) class == SmallInteger.
    self assert:( 0.4 truncated = 0 ).
    self assert:( 0.5 truncated = 0 ).
    self assert:( 0.6 truncated = 0 ).
    self assert:( -0.4 truncated = 0 ).
    self assert:( -0.5 truncated = 0 ).
    self assert:( -0.6 truncated = 0 ).

    self assert:( 0.4 truncatedAsFloat ) class == Float.
    self assert:( 0.4 truncatedAsFloat  = 0.0 ).
    self assert:( 0.5 truncatedAsFloat  = 0.0 ).
    self assert:( 0.6 truncatedAsFloat  = 0.0 ).
    self assert:( -0.4 truncatedAsFloat = 0 ).
    self assert:( -0.5 truncatedAsFloat = 0.0 ).
    self assert:( -0.6 truncatedAsFloat = 0.0 ).

    self assert:( 0.4 asShortFloat truncated ) class == SmallInteger.
    self assert:( 0.4 asShortFloat truncated = 0 ).
    self assert:( 0.5 asShortFloat truncated = 0 ).
    self assert:( 0.6 asShortFloat truncated = 0 ).
    self assert:( -0.4 asShortFloat truncated = 0 ).
    self assert:( -0.5 asShortFloat truncated = 0 ).
    self assert:( -0.6 asShortFloat truncated = 0 ).

    self assert:( 0.4 asShortFloat truncatedAsFloat ) class == ShortFloat.
    self assert:( 0.4 asShortFloat truncatedAsFloat  = 0.0 ).
    self assert:( 0.5 asShortFloat truncatedAsFloat  = 0.0 ).
    self assert:( 0.6 asShortFloat truncatedAsFloat  = 0.0 ).
    self assert:( -0.4 asShortFloat truncatedAsFloat = 0 ).
    self assert:( -0.5 asShortFloat truncatedAsFloat = 0.0 ).
    self assert:( -0.6 asShortFloat truncatedAsFloat = 0.0 ).

    self assert:( 0.4 asLongFloat truncated ) class == SmallInteger.
    self assert:( 0.4 asLongFloat truncated = 0 ).
    self assert:( 0.5 asLongFloat truncated = 0 ).
    self assert:( 0.6 asLongFloat truncated = 0 ).
    self assert:( -0.4 asLongFloat truncated = 0 ).
    self assert:( -0.5 asLongFloat truncated = 0 ).
    self assert:( -0.6 asLongFloat truncated = 0 ).

    self assert:( 0.4 asLongFloat truncatedAsFloat ) class == LongFloat.
    self assert:( 0.4 asLongFloat truncatedAsFloat  = 0.0 ).
    self assert:( 0.5 asLongFloat truncatedAsFloat  = 0.0 ).
    self assert:( 0.6 asLongFloat truncatedAsFloat  = 0.0 ).
    self assert:( -0.4 asLongFloat truncatedAsFloat = 0 ).
    self assert:( -0.5 asLongFloat truncatedAsFloat = 0.0 ).
    self assert:( -0.6 asLongFloat truncatedAsFloat = 0.0 ).

    "
     self basicNew test07_Truncation
    "
!

test08_Representation
    self assert: (Float unity class == Float).
    self assert: (ShortFloat unity class == ShortFloat).
    self assert: (LongFloat unity class == LongFloat).

    self assert: (Float unity = 1.0).
    self assert: (ShortFloat unity = 1.0).
    self assert: (LongFloat unity = 1.0).

    self assert: (Float zero class == Float).
    self assert: (ShortFloat zero class == ShortFloat).
    self assert: (LongFloat zero class == LongFloat).

    self assert: (Float zero = 0.0).
    self assert: (ShortFloat zero = 0.0).
    self assert: (LongFloat zero = 0.0).

    self assert:( LongFloat unity = 1 asLongFloat ).
    self assert:( ShortFloat unity = 1 asShortFloat ).
    self assert:( Float unity = 1 asFloat ).

    self assert:( 0.0 exponent = 0 ).
    self assert:( 1.0 exponent = 1 ).
    self assert:( 2.0 exponent = 2 ).
    self assert:( 3.0 exponent = 2 ).
    self assert:( 4.0 exponent = 3 ).
    self assert:( 0.5 exponent = 0 ).
    self assert:( 0.4 exponent = -1 ).
    self assert:( 0.25 exponent = -1 ).
    self assert:( 0.125 exponent = -2 ).
    self assert:( 0.00000011111 exponent = -23 ).

    self assert:( 0.0 asShortFloat exponent = 0 ).
    self assert:( 1.0 asShortFloat exponent = 1 ).
    self assert:( 2.0 asShortFloat exponent = 2 ).
    self assert:( 3.0 asShortFloat exponent = 2 ).
    self assert:( 4.0 asShortFloat exponent = 3 ).
    self assert:( 0.5 asShortFloat exponent = 0 ).
    self assert:( 0.4 asShortFloat exponent = -1 ).
    self assert:( 0.25 asShortFloat exponent = -1 ).
    self assert:( 0.125 asShortFloat exponent = -2 ).
    self assert:( 0.00000011111 asShortFloat exponent = -23 ).

    self assert:( 0.0 asLongFloat exponent = 0 ).
    self assert:( 1.0 asLongFloat exponent = 1 ).
    self assert:( 2.0 asLongFloat exponent = 2 ).
    self assert:( 3.0 asLongFloat exponent = 2 ).
    self assert:( 4.0 asLongFloat exponent = 3 ).
    self assert:( 0.5 asLongFloat exponent = 0 ).
    self assert:( 0.4 asLongFloat exponent = -1 ).
    self assert:( 0.25 asLongFloat exponent = -1 ).
    self assert:( 0.125 asLongFloat exponent = -2 ).
    self assert:( 0.00000011111 asLongFloat exponent = -23 ).

    "
     self basicNew test08_Representation
    "

    "Modified: / 02-08-2011 / 18:34:39 / cg"
! !

!FloatTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


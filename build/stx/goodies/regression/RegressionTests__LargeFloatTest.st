"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#LargeFloatTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!


!LargeFloatTest methodsFor:'helpers'!

actualPrecisionOf:aFloatClass
    "get the actual number of valid bits in the mantissa.
     This does a real test (i.e. does not believe the compiled-in ifdefs)"

    |one half x count|

    one := aFloatClass unity.  "/ 1.0 in this class
    half := one coerce:0.5.
    x := one.
    count := 0.

    [ one + x ~= one] whileTrue:[
	x := x * half.
	count := count + 1.
    ].
    ^ count

    "
     self basicNew actualPrecisionOf:ShortFloat
     self basicNew actualPrecisionOf:Float
     self basicNew actualPrecisionOf:LongFloat
    "
! !

!LargeFloatTest methodsFor:'tests'!

test01_Nan
    "NaN in all avaliable formats."

    |shouldBeNaN|

    shouldBeNaN := 0.0 asLargeFloat uncheckedDivide: 0.0.
    self assert:( shouldBeNaN isMemberOf:LargeFloat ).
    self assert:( shouldBeNaN isNaN ).
    self assert:( shouldBeNaN isFinite not ).


    shouldBeNaN := 0.0 asLargeFloat uncheckedDivide: 0.0.
    self assert:( shouldBeNaN asShortFloat isNaN ).
    self assert:( shouldBeNaN asLongFloat isNaN ).
    self should:[ shouldBeNaN asInteger ] raise:DomainError.


    self assert:( shouldBeNaN + 1 ) isNaN.
    self assert:( shouldBeNaN + 1.0 ) isNaN.
    self assert:( shouldBeNaN + 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeNaN + 1.0 asLongFloat ) isNaN.
    self assert:( shouldBeNaN + 1.0 asLargeFloat ) isNaN.

    self assert:( 1 + shouldBeNaN ) isNaN.
    self assert:( 1.0 + shouldBeNaN ) isNaN.
    self assert:( 1.0 asShortFloat + shouldBeNaN ) isNaN.
    self assert:( 1.0 asLongFloat + shouldBeNaN ) isNaN.
    self assert:( 1.0 asLargeFloat + shouldBeNaN ) isNaN.

    self assert:( shouldBeNaN - 1 ) isNaN.
    self assert:( shouldBeNaN - 1.0 ) isNaN.
    self assert:( shouldBeNaN - 1.0 asShortFloat ) isNaN.
    self assert:( shouldBeNaN - 1.0 asLongFloat ) isNaN.
    self assert:( shouldBeNaN - 1.0 asLargeFloat ) isNaN.

    self assert:( 1 - shouldBeNaN ) isNaN.
    self assert:( 1.0 - shouldBeNaN ) isNaN.
    self assert:( 1.0 asShortFloat - shouldBeNaN ) isNaN.
    self assert:( 1.0 asLongFloat - shouldBeNaN ) isNaN.
    self assert:( 1.0 asLargeFloat - shouldBeNaN ) isNaN.

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

    check value: 1.0 asLargeFloat value: 0.0 asLargeFloat.

    "
     self basicNew test02_Inf
    "
!

test03_Conversion
    self assert:( 1.0 asLargeFloat asTrueFraction == 1 ).
    self assert:( 2.0 asLargeFloat asTrueFraction == 2 ).
    self assert:( 4.0 asLargeFloat asTrueFraction == 4 ).
    self assert:( 8.0 asLargeFloat asTrueFraction == 8 ).
    self assert:( 16.0 asLargeFloat asTrueFraction == 16 ).
    self assert:( 1048576.0 asLargeFloat asTrueFraction == 1048576 ).
    self assert:( 0.5 asLargeFloat asTrueFraction = (1/2) ).
    self assert:( 0.25 asLargeFloat asTrueFraction = (1/4) ).
    self assert:( 0.125 asLargeFloat asTrueFraction = (1/8) ).

    "
     self basicNew test03_Conversion
    "
!

test04_Arithmetic
    self assert:( 1.0 asLargeFloat + 1.0 ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat + 1.0 asShortFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat + 1.0 asFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat + 1 ) class == LargeFloat.

    self assert:( 1.0 asLargeFloat - 1.0 ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat - 1.0 asShortFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat - 1.0 asFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat - 1 ) class == LargeFloat.

    self assert:( 1.0 asLargeFloat * 1.0 ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat * 1.0 asShortFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat * 1.0 asFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat * 1 ) class == LargeFloat.

    self assert:( 1.0 asLargeFloat / 1.0 ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat / 1.0 asShortFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat / 1.0 asFloat ) class == LargeFloat.
    self assert:( 1.0 asLargeFloat / 1 ) class == LargeFloat.

    self assert:( 1.0 asLargeFloat + 1.0 asLargeFloat) = 2.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat + 0.0 asLargeFloat) = 1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat + 2.0 asLargeFloat) = 3.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat + 3.0 asLargeFloat) = 4.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat + 1.0 asLargeFloat negated) = 0.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat + 2.0 asLargeFloat negated) = -1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat + -1.0 asLargeFloat negated) = 2.0 asLargeFloat.

    self assert:( 1.0 asLargeFloat - 1.0 asLargeFloat) = 0.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat - 0.0 asLargeFloat) = 1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat - 2.0 asLargeFloat) = -1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat - 3.0 asLargeFloat) = -2.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat - 1.0 asLargeFloat negated) = 2.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat - 2.0 asLargeFloat negated) = 3.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat - -1.0 asLargeFloat negated) = 0.0 asLargeFloat.

    self assert:( 1.0 asLargeFloat * 1.0 asLargeFloat) = 1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat * 0.0 asLargeFloat) = 0.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat * 2.0 asLargeFloat) = 2.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat * 3.0 asLargeFloat) = 3.0 asLargeFloat.
    self assert:( 2.0 asLargeFloat * 3.0 asLargeFloat) = 6.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat * 1.0 asLargeFloat negated) = -1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat * 2.0 asLargeFloat negated) = -2.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat * -1.0 asLargeFloat negated) = 1.0 asLargeFloat.

    self assert:( 1.0 asLargeFloat / 1.0 asLargeFloat) = 1.0 asLargeFloat.
    self assert:( 1.0 asLargeFloat / 2.0 asLargeFloat) = 0.5 asLargeFloat.
    self assert:( 3.0 asLargeFloat / 2.0 asLargeFloat) = (3/2) asLargeFloat.

    "
     self basicNew test04_Arithmetic
    "
!

test05_Comparing
    self assert:( 2.0 asLargeFloat = 2 ).
    self assert:( 2.0 asLargeFloat = 2.0 asShortFloat ).
    self assert:( 2.0 asLargeFloat = 2.0 ).
    self assert:( 2.0 asLargeFloat = 2.0 asLongFloat ).
    self assert:( 2.0 asLargeFloat = 2.0 asLargeFloat ).

    self assert:( 2.0 asLargeFloat = 3 ) not.
    self assert:( 2.0 asLargeFloat = 3.0 asShortFloat ) not.
    self assert:( 2.0 asLargeFloat = 3.0 ) not.
    self assert:( 2.0 asLargeFloat = 3.0 asLongFloat ) not.
    self assert:( 2.0 asLargeFloat = 3.0 asLargeFloat ) not.

    self assert:( 2.0 asLargeFloat < 3 ).
    self assert:( 2.0 asLargeFloat < 3.0 asShortFloat ).
    self assert:( 2.0 asLargeFloat < 3.0 asLargeFloat ).

    self assert:( 200000000000000000000.0 asLargeFloat < 200000000000100000000 ).

    self assert:( 200000000000000000000 < 200001000000000000000.0 asLargeFloat ).


    self assert:( 2.0 asLargeFloat <= 3 ).
    self assert:( 2.0 asLargeFloat <= 2 ).
    self assert:( 2.0 asLargeFloat <= 3.0 asShortFloat ).
    self assert:( 2.0 asLargeFloat <= 2.0 asShortFloat ).
    self assert:( 2.0 asLargeFloat <= 3.0 asLongFloat ).
    self assert:( 2.0 asLargeFloat <= 2.0 asLongFloat ).
    self assert:( 2.0 asLargeFloat <= 3.0 asLargeFloat ).
    self assert:( 2.0 asLargeFloat <= 2.0 asLargeFloat ).

    self assert:( 200000000000000000000.0 asLargeFloat <= 200000000000000000001 ).
    self assert:( 200000000000000000000.0 asLargeFloat <= 200000000000000000000 ).

    self assert:( 200000000000000000000 <= 200001000000000000000.0 asLargeFloat ).
    self assert:( 200000000000000000000 <= 200000000000000000000.0 asLargeFloat ).

    "
     self basicNew test05_Comparing
    "
!

test06_MiscMath
    #(
"/        sqrt       0.5
"/        exp        0.5
"/        ln         0.5
"/        log10      0.5
"/        sin        0.5
"/        cos        0.5
"/        tan        0.5
"/        arcSin     0.5
"/        arcCos     0.5
"/        arcTan     0.5

	sinh       0.5
	cosh       0.5
	tanh       0.5
	arcSinh    0.5
	arcCosh    1.5
	arcTanh    0.5
    ) pairWiseDo:[:op :arg |
"/        self assert:( arg asLargeFloat perform:op ) class == LargeFloat.
	( arg asLargeFloat perform:op ) class == LargeFloat ifFalse:[
	    Transcript showCR:'warning: missing LargeFloat function: ' , op.
	].

	self assert:( (arg perform:op) - (arg asLargeFloat perform:op) ) < 0.000001.
	self assert:( (arg perform:op) - (arg perform:op) asLargeFloat ) < 0.000001.
    ].

    "
     self basicNew test06_MiscMath
    "
!

test07_Truncation
    |check|

    check := [:num |
	self assert:( num fractionPart + num truncated ) = num.
	self assert:( num fractionPart + num truncated ) class == num class.
    ].

    check value:1.6 asLargeFloat.
    check value:-1.6 asLargeFloat.


    self assert:( 1.6 asLargeFloat ceiling ) = 2.

    self assert:( 1.6 asLargeFloat ceilingAsFloat ) = 2.0 asLargeFloat.
    self assert:( 1.6 asLargeFloat ceilingAsFloat ) class == LargeFloat.


    self assert:( 1.6 asLargeFloat floor ) = 1.

    self assert:( 1.6 asLargeFloat floorAsFloat ) = 1.0 asLargeFloat.
    self assert:( 1.6 asLargeFloat floorAsFloat ) class == LargeFloat.


    self assert:( 0.4 asLargeFloat rounded ) class == SmallInteger.
    self assert:( 0.4 asLargeFloat rounded = 0 ).
    self assert:( 0.5 asLargeFloat rounded = 1 ).
    self assert:( 0.6 asLargeFloat rounded = 1 ).
    self assert:( -0.4 asLargeFloat rounded = 0 ).
    self assert:( -0.5 asLargeFloat rounded = -1 ).
    self assert:( -0.6 asLargeFloat rounded = -1 ).

    self assert:( 0.4 asLargeFloat roundedAsFloat ) class == LargeFloat.
    self assert:( 0.4 asLargeFloat roundedAsFloat  = 0.0 ).
    self assert:( 0.5 asLargeFloat roundedAsFloat  = 1.0 ).
    self assert:( 0.6 asLargeFloat roundedAsFloat  = 1.0 ).
    self assert:( -0.4 asLargeFloat roundedAsFloat = 0 ).
    self assert:( -0.5 asLargeFloat roundedAsFloat = -1.0 ).
    self assert:( -0.6 asLargeFloat roundedAsFloat = -1.0 ).

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

    self assert:( 0.4 asLargeFloat truncated ) class == SmallInteger.
    self assert:( 0.4 asLargeFloat truncated = 0 ).
    self assert:( 0.5 asLargeFloat truncated = 0 ).
    self assert:( 0.6 asLargeFloat truncated = 0 ).
    self assert:( -0.4 asLargeFloat truncated = 0 ).
    self assert:( -0.5 asLargeFloat truncated = 0 ).
    self assert:( -0.6 asLargeFloat truncated = 0 ).

    self assert:( 0.4 asLargeFloat truncatedAsFloat ) class == LargeFloat.
    self assert:( 0.4 asLargeFloat truncatedAsFloat  = 0.0 ).
    self assert:( 0.5 asLargeFloat truncatedAsFloat  = 0.0 ).
    self assert:( 0.6 asLargeFloat truncatedAsFloat  = 0.0 ).
    self assert:( -0.4 asLargeFloat truncatedAsFloat = 0 ).
    self assert:( -0.5 asLargeFloat truncatedAsFloat = 0.0 ).
    self assert:( -0.6 asLargeFloat truncatedAsFloat = 0.0 ).

    "
     self basicNew test07_Truncation
    "
!

test08_Representation
"/    self assert:( 0.0 asLargeFloat exponent = 0 ).
"/    self assert:( 1.0 asLargeFloat exponent = 0 "1" ).
"/    self assert:( 2.0 asLargeFloat exponent = 1 "2" ).
"/    self assert:( 3.0 asLargeFloat exponent = 2 ).
"/    self assert:( 4.0 asLargeFloat exponent = 3 ).
"/    self assert:( 0.5 asLargeFloat exponent = 0 ).
"/    self assert:( 0.4 asLargeFloat exponent = -1 ).
"/    self assert:( 0.25 asLargeFloat exponent = -1 ).
"/    self assert:( 0.125 asLargeFloat exponent = -2 ).
"/    self assert:( 0.00000011111 asLargeFloat exponent = -23 ).

    "
     self basicNew test08_Representation
    "
!

test09_Testing
    self assert:( 0.0 asLargeFloat isZero ).
    self assert:( 1.0 asLargeFloat isZero not ).

    self assert:( 0.0 asLargeFloat negative not ).
    self assert:( 1.0 asLargeFloat negative not ).
    self assert:( -1.0 asLargeFloat negative ).

    self assert:( 0.0 asLargeFloat positive ).
    self assert:( 1.0 asLargeFloat positive ).
    self assert:( -1.0 asLargeFloat positive not ).

    self assert:( 0.0 asLargeFloat strictlyPositive not ).
    self assert:( 1.0 asLargeFloat strictlyPositive ).
    self assert:( -1.0 asLargeFloat strictlyPositive not ).

    self assert:( 0.0 asLargeFloat sign == 0 ).
    self assert:( 1.0 asLargeFloat sign == 1 ).
    self assert:( -1.0 asLargeFloat sign == -1 ).

    "
     self basicNew test09_Testing
    "
! !

!LargeFloatTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


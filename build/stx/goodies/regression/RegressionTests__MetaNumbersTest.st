"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#MetaNumbersTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!


!MetaNumbersTest methodsFor:'tests'!

test01_Nan
    "NaN in all avaliable formats."

    |check|

    check := [:nan |
	self assert:( nan isNaN ).
	self assert:( nan isFinite not ).

	nan isLimitedPrecisionReal ifTrue:[
	    self assert:( nan asFloat isNaN ).
	    self assert:( nan asLargeFloat isNaN ).
	    self assert:( nan asShortFloat isNaN ).
	    self assert:( nan asLongFloat isNaN ).
	].

	"/ self assert:( nan asFraction isNaN ).
	"/ self assert:( nan asInteger isNaN ).
	self should:[ nan asFraction ] raise:DomainError.
	self should:[ nan asInteger ] raise:DomainError.

	self assert:( nan + 1 ) isNaN.
	self assert:( nan + 1.0 ) isNaN.
	self assert:( nan + 1.0 asShortFloat ) isNaN.
	self assert:( nan + 1.0 asLongFloat ) isNaN.
	self assert:( nan + 1.0 asLargeFloat ) isNaN.

	self assert:( 1 + nan ) isNaN.
	self assert:( 1.0 + nan ) isNaN.
	self assert:( 1.0 asShortFloat + nan ) isNaN.
	self assert:( 1.0 asLongFloat + nan ) isNaN.
	self assert:( 1.0 asLargeFloat + nan ) isNaN.

	self assert:( nan - 1 ) isNaN.
	self assert:( nan - 1.0 ) isNaN.
	self assert:( nan - 1.0 asShortFloat ) isNaN.
	self assert:( nan - 1.0 asLongFloat ) isNaN.
	self assert:( nan - 1.0 asLargeFloat ) isNaN.

	self assert:( 1 - nan ) isNaN.
	self assert:( 1.0 - nan ) isNaN.
	self assert:( 1.0 asShortFloat - nan ) isNaN.
	self assert:( 1.0 asLongFloat - nan ) isNaN.
	self assert:( 1.0 asLargeFloat - nan ) isNaN.

	self assert:( nan * 1 ) isNaN.
	self assert:( nan * 1.0 ) isNaN.
	self assert:( nan * 1.0 asShortFloat ) isNaN.
	self assert:( nan * 1.0 asLongFloat ) isNaN.
	self assert:( nan * 1.0 asLargeFloat ) isNaN.

	self assert:( 1 * nan ) isNaN.
	self assert:( 1.0 * nan ) isNaN.
	self assert:( 1.0 asShortFloat * nan ) isNaN.
	self assert:( 1.0 asLongFloat * nan ) isNaN.
	self assert:( 1.0 asLargeFloat * nan ) isNaN.

	self assert:( nan / 1 ) isNaN.
	self assert:( nan / 1.0 ) isNaN.
	self assert:( nan / 1.0 asShortFloat ) isNaN.
	self assert:( nan / 1.0 asLongFloat ) isNaN.
	self assert:( nan / 1.0 asLargeFloat ) isNaN.

	self assert:( 1 / nan ) isNaN.
	self assert:( 1.0 / nan ) isNaN.
	self assert:( 1.0 asShortFloat / nan ) isNaN.
	self assert:( 1.0 asLongFloat / nan ) isNaN.
	self assert:( 1.0 asLargeFloat / nan ) isNaN.
    ].

    check value:(0.0 uncheckedDivide: 0.0).
    check value:(0.0 asShortFloat uncheckedDivide: 0.0).
    check value:(0.0 asLongFloat uncheckedDivide: 0.0).
    check value:(0.0 asLargeFloat uncheckedDivide: 0.0).
    check value:(0 uncheckedDivide: 0).

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
	    negInf := v1 negated uncheckedDivide: v2.

	    v1 isLimitedPrecisionReal ifTrue:[
		self assert:( posInf isMemberOf:v1 class ).
		self assert:( negInf isMemberOf:v1 class ).
	    ].
	    self assert:( posInf isNaN not ).
	    self assert:( posInf isFinite not ).
	    self assert:( posInf isInfinite ).
	    self assert:( posInf positive ).
	    self assert:( posInf negative not ).
	    self assert:( posInf isNegativeInfinity not).
	    self assert:( posInf isPositiveInfinity ).

	    self assert:( negInf isNaN not ).
	    self assert:( negInf isFinite not ).
	    self assert:( negInf isInfinite ).
	    self assert:( negInf positive not).
	    self assert:( negInf negative ).
	    self assert:( negInf isNegativeInfinity ).
	    self assert:( negInf isPositiveInfinity not ).

	    self assert:( negInf + negInf = negInf).
	    self assert:( posInf + posInf = posInf).
	    "/ self assert:( negInf + posInf) isNaN.
	    self assert:( Number undefinedResultSignal ignoreIn:[ negInf + posInf]) isNaN.
	    "/ self should:[ negInf + posInf ] raise:Number undefinedResultSignal.
	    self assert:( Number undefinedResultSignal ignoreIn:[ posInf + negInf]) isNaN.

	    self assert:( negInf - posInf = negInf).
	    self assert:( Number undefinedResultSignal ignoreIn:[ negInf - negInf]) isNaN.
	    self assert:( posInf - negInf = posInf).
	    self assert:( Number undefinedResultSignal ignoreIn:[ posInf - posInf]) isNaN.

	    self assert:( posInf + v1) = posInf.
	    self assert:( posInf - v1) = posInf.
	    self assert:( negInf + v1) = negInf.
	    self assert:( negInf - v1) = negInf.

	    self assert:( posInf + 1) = posInf.
	    self assert:( posInf + 1.0) = posInf.
	    self assert:( posInf + 1.0 asShortFloat) = posInf.
	    self assert:( posInf + 1.0 asLongFloat) = posInf.
	    self assert:( posInf + 1.0 asLargeFloat) = posInf.
	    self assert:( posInf + (1/2)) = posInf.
	    self assert:( posInf + 100 factorial) = posInf.

	    self assert:( negInf + 1) = negInf.
	    self assert:( negInf + 1.0) = negInf.
	    self assert:( negInf + 1.0 asShortFloat) = negInf.
	    self assert:( negInf + 1.0 asLongFloat) = negInf.
	    self assert:( negInf + 1.0 asLargeFloat) = negInf.
	    self assert:( negInf + (1/2)) = negInf.
	    "take care, that the factorial is not poitive infinite when converting"
	    self assert:( negInf + 20 factorial asShortFloat) = negInf.

	    self assert:( 1 + posInf) = posInf.
	    self assert:( 1.0 + posInf) = posInf.
	    self assert:( 1.0 asShortFloat + posInf) = posInf.
	    self assert:( 1.0 asLongFloat + posInf) = posInf.
	    self assert:( 1.0 asLargeFloat + posInf) = posInf.
	    self assert:( (1/2) + posInf) = posInf.
	    self assert:( 20 factorial + posInf) = posInf.

	    self assert:( 1 + negInf) = negInf.
	    self assert:( 1.0 + negInf) = negInf.
	    self assert:( 1.0 asShortFloat + negInf) = negInf.
	    self assert:( 1.0 asLongFloat + negInf) = negInf.
	    self assert:( 1.0 asLargeFloat + negInf) = negInf.
	    self assert:( (1/2) + negInf) = negInf.
	    "take care, that the factorial is not poitive infinite when converting"
	    self assert:( 20 factorial + negInf) = negInf.
	].

    check value: 1.0 value: 0.0.
    check value: 1.0 asShortFloat value: 0.0 asShortFloat.
    check value: 1.0 asLongFloat value: 0.0 asLongFloat.
    check value: 1.0 asLargeFloat value: 0.0 asLargeFloat.

    check value: 1 value: 0.

    "
     self basicNew test02_Inf
    "
! !

!MetaNumbersTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ComplexTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Numbers'
!


!ComplexTest class methodsFor:'accessing'!

testedClasses
    "for the browser and for coverage analysis:
     return a collection of classNames, which are tested by this testCase"

    ^ #( Complex )
! !

!ComplexTest methodsFor:'tests'!

testAbs
    | c |

    c := (6 - 6 i).
    self assert: c abs  = 72 sqrt.

    "
     self new testAbs

     self run: #testAbs
     self debug: #testAbs
    "
!

testAddition
    | c1 c2 c3 |

    self shouldnt: [ c1 := Complex real: 1 imaginary: 2 ] raise: Exception.
    self shouldnt: [ c2 := Complex real: 3 imaginary: 4 ] raise: Exception.

    self should: [ (c1 + c2) = (Complex real: 4 imaginary: 6) ].

    c3 := (5 - 6 i) + (-5 + 8 i).     "Complex with Complex"
    self assert: (c3 = (0 + 2 i)).

    self assert: (c1 + 1)   = (2 + 2 i).
    self assert: (c1 + 1.0) = (2 + 2 i).
    self assert: (1 + c1) = (2 + 2 i).
    self assert: (1.0 + c1) = (2 + 2 i).

    "
     self run: #testAddition
     self new testAddition
    "
!

testAngle
    | c |

    c := (1 + 1 i).
    self assert: (c angle radiansToDegrees rounded = 45).
    self assert: (c asPoint x = 1).
    self assert: (c asPoint y = 1).

    c := (-1 + 1 i).
    self assert: (c angle radiansToDegrees rounded = 135).
    self assert: (c asPoint x = -1).
    self assert: (c asPoint y = 1).

    c := (-1 - 1 i).
    self assert: (c angle radiansToDegrees rounded = -135).
    self assert: (c asPoint x = -1).
    self assert: (c asPoint y = -1).

    "
     self new testAngle

     self run: #testAngle
     self debug: #testAngle
    "
!

testCompare
    | c1 c2 |

    c1 := Complex real: 1 imaginary: 2.
    c2 := Complex real: 3 imaginary: 4.

    self assert: ( c1 ~= c2 ).
    self assert: ( c1 = c2 ) not.

    self should: [ c1 < c2 ] raise: Exception.
    self should: [ c1 <= c2 ] raise: Exception.
    self should: [ c1 >= c2 ] raise: Exception.
    self should: [ c1 > c2 ] raise: Exception.

    c1 := Complex fromReal: 1.

    self assert: ( c1 = 1 ).
    self assert: ( c1 = 1.0 ).
    self assert: ( c1 ~= 2 ).
    self assert: ( c1 ~= 2.0 ).

    self assert: ( 1 = c1 ).
    self assert: ( 1.0 = c1 ).
    self assert: ( 2 ~= c1 ).
    self assert: ( 2.0 ~= c1 ).
!

testConjugated
    | c |

    c := (2 + 5 i) .
    self assert: c conjugated  = (2 - 5i).

    "
     self run: #testConjugated
     self new testConjugated
    "
!

testConversion
    | c |

    c := Complex fromReal:1.
    self assert: (c asComplex = c).
    self assert: (c asFloat = 1).
    self assert: (c asInteger = 1).
    self assert: (c asPoint = (1@0) ).

    c := (1 + 1 i).
    self assert: (c asComplex = c).
    self should:[ c asFloat ] raise:Exception.
    self should:[ c asInteger ] raise:Exception.
    self assert: (c isComplex ).
    self assert: (c asPoint = (1@1) ).

    "
     self new testConversion

     self run: #testConversion
     self debug: #testConversion
    "
!

testCreation
    | c |

    false ifTrue:[
	"cg: I dont think this has to be known outside complex"
	"i.e. should it really be allowed to create complex numbers with new ?"
	self should: [ (c := Complex new) realPart = 0 ].
	self should: [ c imaginaryPart = 0 ].
    ].
    self should: [ (c := Complex real: 1 imaginary: 2) realPart = 1 ].
    self should: [ c imaginaryPart = 2 ].

    self should: [ (c := Complex real: -1 imaginary: 2) realPart = -1 ].
    self should: [ c imaginaryPart = 2 ].

    self should: [ (c := Complex real: 1 imaginary: -2) realPart = 1 ].
    self should: [ c imaginaryPart = -2 ].

    self should: [ (c := Complex real: -1 imaginary: -2) realPart = -1 ].
    self should: [ c imaginaryPart = -2 ].

    c := (1 % 2).
    self assert: (c real = 1).
    self assert: (c imaginary = 2).

    c := (-1 % 2).
    self assert: (c real = -1).
    self assert: (c imaginary = 2).

    c := (1 % -2).
    self assert: (c real = 1).
    self assert: (c imaginary = -2).

    c := (-1 % -2).
    self assert: (c real = -1).
    self assert: (c imaginary = -2).

    c := (1.0 % 2.0).
    self assert: (c real = 1.0).
    self assert: (c imaginary = 2.0).

    c := (-1.0 % 2.0).
    self assert: (c real = -1.0).
    self assert: (c imaginary = 2.0).

    c := (1.0 % -2.0).
    self assert: (c real = 1.0).
    self assert: (c imaginary = -2.0).

    c := (-1.0 % -2.0).
    self assert: (c real = -1.0).
    self assert: (c imaginary = -2.0).

    c := 5 i.
    self assert: (c real = 0).
    self assert: (c imaginary = 5).

    c := 6 + 7 i.
    self assert: (c real = 6).
    self assert: ( c imaginary = 7).

    c := 5.6 - 8 i.
    self assert: (c real = 5.6).
    self assert: (c imaginary = -8).

    c := Complex real: 10 imaginary: 5.
    self assert: (c real = 10).
    self assert: (c imaginary = 5).

    c := Complex abs: 5 arg: (Float pi/2).
    self assert: (c real rounded = 0).
    self assert: (c imaginary = 5).

    "
     self run: #testCreation
     self new testCreation
    "
!

testDivision
	| c1 c2 |

	self shouldnt: [ c1 := Complex real: 2 imaginary: 2 ] raise: Exception.
	self shouldnt: [ c2 := Complex real: 3 imaginary: 6 ] raise: Exception.

	self should: [ (c1 / c1) = (Complex real: 1 imaginary: 0) ].
	self should: [ (c1 / c2) = (Complex real: 2/5 imaginary: (-2/15)) ].
	self should: [ (c2 / c1) = (Complex real: 9/4 imaginary: 3/4) ].

	self should: [ c2 / 3 = (Complex real: 1 imaginary: 2) ].
	self should: [ c1 / 2 = (Complex real: 1 imaginary: 1) ].
!

testEquality
    self should: [ 3 = (Complex real: 3 imaginary: 0) ].
    self should: [ (Complex real: 3 imaginary: 0) = 3 ].

    self should: [ 3.0 = (Complex real: 3 imaginary: 0) ].
    self should: [ (Complex real: 3 imaginary: 0) = 3.0 ].

    self shouldnt: [ 3 = (Complex real: 3 imaginary: 1) ].
    self shouldnt: [ (Complex real: 3 imaginary: 1) = 3 ].

    self shouldnt: [ 3.0 = (Complex real: 3 imaginary: 1) ].
    self shouldnt: [ (Complex real: 3 imaginary: 1) = 3.0 ].

    self should: [ 3 ~= (Complex real: 3 imaginary: 1) ].
    self should: [ (Complex real: 3 imaginary: 1) ~= 3 ].

    self should: [ 3.0 ~= (Complex real: 3 imaginary: 1) ].
    self should: [ (Complex real: 3 imaginary: 1) ~= 3.0 ].

    self assert: 0i = 0.
    self assert: (2 - 5i) = ((1 -4 i) + (1 - 1i)).
    self assert: 0i isZero.
    self deny: (1 + 3 i) = 1.
    self deny: (1 + 3 i) = (1 + 2i).

    "
     self run: #testEquality
     self new testEquality
    "
!

testFloorCeiling
    | c1 c2 |

    c1 := Complex real: 1 imaginary: 2.
    c2 := Complex real: 3 imaginary: 4.

    self should: [ c1 floor ] raise:Error.
    self should: [ c1 ceiling ] raise:Error.

    "Created: / 02-11-2012 / 10:04:43 / cg"
!

testModulus
	| c1 c2 |

	"Test case where |a| < |b| in complex number (a + ib)."

	self shouldnt: [ c1 := Complex real: 2 imaginary: 3 ] raise: Exception.
	self should: [ c1 modulus = (3 * ((1 + ((2 / 3) * (2 / 3))) sqrt)) ].

	"Test case where |a| >= |b| in complex number (a + ib)."

	self shouldnt: [ c2 := Complex real: 4 imaginary: -2 ] raise: Exception.
	self should: [ c2 modulus = (4 * ((1 + ((-2 / 4) * (-2 / 4))) sqrt)) ].
!

testMultiplication
    | c1 c2 |

    self shouldnt: [ c1 := Complex real: 1 imaginary: 2 ] raise: Exception.
    self shouldnt: [ c2 := Complex real: 3 imaginary: 4 ] raise: Exception.

    self should: [ (c1 * c2) = (Complex real: -5 imaginary: 10) ].
    self should: [ (c1 * Complex zero) = Complex zero ].

    self should: [ c1 * 5 = (Complex real: 5 imaginary: 10) ].
    self should: [ c1 * 1.1 = (Complex real: 1.1 imaginary: 2.2) ].
    self should: [ c1 * (2/3) = (Complex real: 2/3 imaginary: 4/3) ].

    self assert:( 1.0 * c1 = c1 ).
!

testNegated
    | c |
    c := (2 + 5 i) .
    self assert: c negated  = (-2 - 5i).

    "
     self run: #testNegated
     self new testNegated
    "
!

testRaisedTo
	| c |

	self shouldnt: [ c := Complex real: 3 imaginary: 2 ] raise: Exception.
	self assert:  ((c raisedTo: 2) = (c * c)).
	self assert:  ((c raisedTo: 3) = (c * c * c)).
	self assert:  ((c raisedTo: 4) = (c * c * c * c)).
!

testReciprocal
    | c |
    c := (2 + 5 i).
    self assert: c reciprocal  = ((2/29) - (5/29)i).

    "
     self run: #testReciprocal
     self new testReciprocal
    "
!

testReciprocalError
    | c |
    c := (0 i).
	self should: [c reciprocal] raise: ZeroDivide
    "
     self run: #testReciprocalError
     self new testReciprocalError
    "
!

testSqrt
	| c w |

	self shouldnt: [ c := Complex real: 0 imaginary: 0 ] raise: Exception.
	self should: [ c sqrt = 0 ].

	self shouldnt: [ c := Complex real: 9 imaginary: 4 ] raise: Exception.
	"cg: that cannot be tested easily, due to rounding errors"
	"original" false ifTrue:[
	    self should: [ w := 3 * (((1 + (1 + ((4/9) * (4/9))) sqrt) / 2) sqrt).
			    c sqrt = (Complex real: w imaginary: 4 / (2 * w)) ].
	] ifFalse:[
	    self should: [ |t1 t2 epsilon|
			    w := 3 * (((1 + (1 + ((4/9) * (4/9))) sqrt) / 2) sqrt).
			    t1 := c sqrt.
			    t2 := (Complex real: w imaginary: 4 / (2 * w)).
			    epsilon := 0.0000001.
			    (t1 realPart - t2 realPart) < epsilon
			    and:[ (t1 imaginaryPart - t2 imaginaryPart) < epsilon ]
			 ].
	].

	self shouldnt: [ c := Complex imaginary: -2 ] raise: Exception.
	"self should: [ c sqrt = (Complex real: 1 imaginary: -1) ].  Should be true, but rounding bites us..."
	self should: [ (c sqrt realPart - 1) abs < 1.0e-10 ].
	self should: [ (c sqrt imaginaryPart + 1) abs < 1.0e-10 ].
!

testSquared
    | c c2 |
    c := (6 - 6 i).
    c2 := (c squared).
    self assert: c2 imaginary = -72.
    self assert: c2 real = 0.

    "
     self new testSquared

     self run: #testSquared
     self debug: #testSquared
    "
!

testSubtraction
    | c1 c2 |

    self shouldnt: [ c1 := Complex real: 1 imaginary: 2 ] raise: Exception.
    self shouldnt: [ c2 := Complex real: 3 imaginary: 4 ] raise: Exception.

    self should: [ (c1 - c2) = (Complex real: -2 imaginary: -2) ].

    self assert: ( (c1 - 1.0) = (Complex real: 0 imaginary: 2) ).
    self assert: ( (1.0 - c1) = (Complex real: 0 imaginary: -2) ).
    self assert: ( (1.0 - (Complex fromReal:1.0)) = 0 ).
!

xxtestSecureDivision1
    | c1 c2 quotient |
    c1 := 2.0e252 + 3.0e70 i.
    c2 := c1.
    quotient := c1 divideSecureBy: c2.
    self assert: (quotient - 1) isZero.

    "
     self run: #testSecureDivision1
     self new testSecureDivision1
    "
!

xxtestSecureDivision2
    | c1 c2 quotient |
    c1 := 2.0e252 + 3.0e70 i.
    c2 := c1.
    quotient := c1 divideFastAndSecureBy: c2.
    self assert: (quotient - 1) isZero.

    "
     self run: #testSecureDivision2
     self new testSecureDivision2
    "
! !

!ComplexTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


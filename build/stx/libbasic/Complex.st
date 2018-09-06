"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help

 This is an additional goody-class, which is NOT covered by the
 ST/X license. It has been packaged with the ST/X distribution to
 make your live easier instead. NO WARRANTY.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ArithmeticValue subclass:#Complex
	instanceVariableNames:'real imaginary'
	classVariableNames:'ComplexOne ComplexZero'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!Complex class methodsFor:'documentation'!

copyright
"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help

 This is an additional goody-class, which is NOT covered by the
 ST/X license. It has been packaged with the ST/X distribution to
 make your live easier instead. NO WARRANTY.
"
!

documentation
"
    This class implements complex numbers.
    A complex number has real and imaginary parts which must be manipulated simultaneously
    in any numeric processing.
    Complex numbers can be used in many of the same places that regular numbers
    can be used with one major exception of comparisons, since complex numbers cannot
    be directly compared for size
    (except through lengths of vectors (see absolute value)).

    [Instance variables:]
       real        <Number> the part of the number which can be expressed as a Real number
       imaginary   <Number> the part of the number which, in terms of how the number behaves,
			    has been multiplied by 'i' (-1 sqrt)

    [Author:]
	Kurt Hebel (hebel@uinova.cerl.uiuc.edu)
	minor changes and double dispatching code by cg.
"
!

examples
"
    (5 % 7) real
    (5 % 7) imaginary
    (5 % 7) = 5
    (5 % 0) = 5
    (5.0 % 0) = 5

    (1 % 0) + (2 % 0)
    (1 % 0) + (0 % 2)
    (1 % 0) + (2 % 3)

    (1 % 0) * (2 % 0)
    (1 % 0) * (0 % 2)
    (1 % 0) * (2 % 3)

    (1 % 2) + 2
    (1 % 2) * 2
    2 + (1 % 2)
    2 * (1 % 2)

"
! !

!Complex class methodsFor:'instance creation'!

abs:aNumber1 arg:aNumber2
    |real imaginary|

    real := aNumber1 * aNumber2 cos.
    imaginary := aNumber1 * aNumber2 sin.
    ^ real + imaginary i
!

fromReal: aNumber
    "Create a new complex number from the given real number."

    ^ self basicNew setReal: aNumber setImaginary: 0
!

imaginary: v
    "Create a new complex number with 0 as real and given imaginary parts.
     If the imaginary part is zero, return the real part of the number."

    v = 0 ifTrue: [^ 0].
    ^ self basicNew setReal: 0 setImaginary: v
!

real: aNumber
    "Create a new complex number from the given real number."

    ^ self basicNew setReal: aNumber setImaginary: 0
!

real: u imaginary: v
    "Create a new complex number with the given real and imaginary parts.  If the
     imaginary part is zero, return the real part of the number."

    v = 0 ifTrue: [^ u].
    ^ self basicNew setReal: u setImaginary: v
! !

!Complex class methodsFor:'constants access'!

unity
    "Answer the value which allows, for any given arithmetic value, the following to be true:
	aNumber * aNumber class unity = aNumber
     This must be true regardless of how a given subclass chooses to define #*"

    ComplexOne isNil ifTrue:[
	ComplexOne := self fromReal: 1
    ].
    ^ ComplexOne
!

zero
    "Answer the value which allows, for any given arithmetic value, the following to be true:
	aNumber + aNumber class zero = aNumber
     This must be true regardless of how a given subclass chooses to define #+"

    ComplexZero isNil ifTrue:[
	ComplexZero := self fromReal: 0
    ].
    ^ ComplexZero
! !

!Complex class methodsFor:'exception handling'!

trapImaginary:aBlock
    "evaluate aBlock; if any DomainError occurs inside, with respect to square roots,
     convert the root to a complex root and proceed.
     This allows for regular (failing) code to transparently convert to complex."

    |send|

    ^ ImaginaryResultError handle: [:ex |
	|selector|

	send := ex parameter.
	selector := send selector.
	(selector = #sqrt or: [selector = #sqrtTruncated]) ifTrue: [
	    send receiver: send receiver asComplex.
	    ex proceedWith: send value
	] ifFalse: [
	    ex reject
	]
    ] do: aBlock

    "
     Complex trapImaginary: [-2 sqrt]
    "

    "failing code:
	 |a|

	 a := -2.
	 (a sqrt + 5) * 17.
    "
    "complex code:
	 |a|

	 Complex trapImaginary:[
	     a := -2.
	     (a sqrt + 5) * 2.
	 ]
    "
! !

!Complex methodsFor:'accessing'!

imaginary
    "Return the imaginary part of the complex number."

    ^ imaginary
!

imaginaryPart
    "Return the imaginary part of the complex number.
     An alias for imaginary (for compatibility with other complex implementations)"

    ^ imaginary
!

real
    "Return the real part of the complex number."

    ^ real
!

realPart
    "Return the real part of the complex number.
     An alias for real (for compatibility with other complex implementations)"

    ^ real
! !

!Complex methodsFor:'arithmetic'!

* aNumber
    "Return the product of the receiver and the argument."

"/    | u v r i |
"/
"/    aNumber isComplex ifTrue:[
"/        u := aNumber real.
"/        v := aNumber imaginary.
"/        r := (real * u) - (imaginary * v).
"/        i  := (real * v) + (imaginary * u).
"/        i = 0 ifTrue:[ ^ r ].
"/        ^ Complex real:r imaginary:i
"/    ].
    ^ aNumber productFromComplex:self.

    "Modified: / 8.7.1998 / 12:12:37 / cg"
!

+ aNumber
    "Return the sum of the receiver and the argument."

"/    | r i |
"/
"/    aNumber isComplex ifTrue: [
"/        r := aNumber real + real.
"/        i := aNumber imaginary + imaginary.
"/        i = 0 ifTrue:[ ^ r ].
"/        ^ Complex real:r imaginary:i
"/    ].
    ^ aNumber sumFromComplex:self.

    "Modified: / 8.7.1998 / 12:15:42 / cg"
!

- aNumber
    "Return the difference of the receiver and the argument."

"/    | r i |
"/
"/    aNumber isComplex ifTrue: [
"/        r := real - aNumber real.
"/        i := imaginary - aNumber imaginary.
"/        i = 0 ifTrue:[ ^ r ].
"/        ^ Complex real:r imaginary:i.
"/    ].
    ^ aNumber differenceFromComplex:self.

    "Modified: / 8.7.1998 / 12:15:38 / cg"
!

/ aNumber
    "Return the quotient of the receiver and the argument."

"/    | denom u v r i |
"/
"/    aNumber isComplex ifTrue:[
"/        u := aNumber real.
"/        v := aNumber imaginary.
"/        denom := u * u + (v * v).
"/        r := u * real + (v * imaginary) / denom.
"/        i := u * imaginary - (v * real) / denom.
"/        i = 0 ifTrue:[ ^ r ].
"/        ^ Complex real:r imaginary:i
"/    ].
    ^ aNumber quotientFromComplex:self.

    "Modified: / 8.7.1998 / 12:15:34 / cg"
!

abs
    "Return the magnitude (or absolute value) of the complex number
     (that's the distance from the origin in the complex plane)."

    ^ (real * real + (imaginary * imaginary)) sqrt

    "
     (1 % 1) abs
    "
!

conjugated
    "Return the complex conjugate of this complex number
     (i.e. with imaginary part negated)."

    ^ self class
        real: real
        imaginary: imaginary negated
!

modulus
    | absReal absImag multiplicand quotient |

    absReal := real abs.
    absImag := imaginary abs.

    absReal >= absImag ifTrue: [
	multiplicand := absReal.
	quotient := imaginary / real
    ] ifFalse: [
	multiplicand := absImag.
	quotient := real / imaginary
    ].
    ^ multiplicand * ((1 + (quotient * quotient)) sqrt)
!

negated
    "return a new complex with both real and imaginary parts negated"

    ^ self class
        real: real negated
        imaginary: imaginary negated
! !

!Complex methodsFor:'coercing'!

coerce: aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asComplex
!

generality
    ^ 150
! !

!Complex methodsFor:'comparing'!

< aNumber
    "raises an error - complex numbers are not well ordered"

    ^ Number
	raise: #unorderedSignal
	receiver: self
	selector: #<
	arg: aNumber
	errorString: 'Complex numbers are not well ordered'

    "
     1 < (2 % 2)
     (2 % 2) < 1
    "
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise."

    ^ aNumber equalFromComplex:self
!

hash
    "Hash is implemented because equals is implemented."

    ^ (real hash) bitXor:(imaginary hash bitShift:16)

    "
     (1+0i) hash
     (1+1i) hash
    "
! !

!Complex methodsFor:'converting'!

asComplex
    "I am a complex - so return the receiver"

    ^ self
!

asFloat
    imaginary = 0 ifTrue: [^ real asFloat].
    ^ Number
	    raise: #coercionErrorSignal
	    receiver: self
	    selector: #asFloat
	    errorString: 'Can''t coerce an instance of Complex to a Float'
!

asInteger
    imaginary = 0 ifTrue: [^real asInteger].
    ^ Number
	raise: #coercionErrorSignal
	receiver: self
	selector: #asInteger
	errorString: 'Can''t coerce an instance of Complex to an Integer'
!

asPoint
    "Return the complex number as a point."

    ^ real @ imaginary
!

reduceGeneralityIfPossible
    "Answer the receiver transformed to a lower generality, if such a
     transformation is possible without losing information.
     If not, answer the receiver"

    imaginary isZero
	ifTrue: [^ real]
	ifFalse: [^ self]
! !

!Complex methodsFor:'double dispatching'!

differenceFromComplex:aComplex
    "Return the difference of the argument, aComplex and the receiver."

    | r i |

    r := aComplex real - real.
    i := aComplex imaginary - imaginary.
    i = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:i.
!

differenceFromFixedPoint: aFixedPoint
    "Return the difference of the argument, aFixedPoint and the receiver."

    ^ aFixedPoint asComplex - self
!

differenceFromFloat:aFloat
    "Return the difference of the argument, aFloat and the receiver."

    "/ ^ aFloat asComplex - self

    | r |

    r := aFloat - real.
    imaginary = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:imaginary negated

    "
     (1 % 1) - 1.0
     1.0 - (1 % 1)
    "
!

differenceFromFraction: aFraction
    "Return the difference of the argument, aFraction and the receiver."

    ^ aFraction asComplex - self
!

differenceFromInteger: anInteger
    "Return the difference of the argument, anInteger and the receiver."

    ^ anInteger asComplex - self
!

equalFromComplex:aComplex
    ^ (aComplex real = real) and:[aComplex imaginary = imaginary]
!

equalFromFloat:aFloat
    imaginary = 0 ifFalse:[^ false].
    ^ real = aFloat
!

productFromComplex:aComplex
    "Return the product of the receiver and the argument, aComplex."

    | u v r i |

    u := aComplex real.
    v := aComplex imaginary.
    r := (real * u) - (imaginary * v).
    i  := (real * v) + (imaginary * u).
    i = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:i
!

productFromFixedPoint: aFixedPoint
    "Return the product of the receiver and the argument, aFixedPoint."

    ^ aFixedPoint asComplex * self
!

productFromFloat: aFloat
    "Return the product of the receiver and the argument, aFloat."

    "/  ^ aFloat asComplex * self

    | u r i |

    u := aFloat.
    r := (real * aFloat).
    i  := (imaginary * aFloat).
    i = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:i

    "
     (1 % 1) * 2.0
     (1 % 1) * 0.0
     2.0 * (1 % 1)
    "
!

productFromFraction: aFraction
    "Return the product of the receiver and the argument, aFraction."

    ^ aFraction asComplex * self
!

productFromInteger: anInteger
    "Return the product of the receiver and the argument, anInteger."

    ^ anInteger asComplex * self
!

quotientFromComplex:aComplex
    "Return the quotient of the argument, aComplex and the receiver."

    | denom nr ni r i |

    nr := aComplex real.
    ni := aComplex imaginary.
    denom := real * real + (imaginary * imaginary).
    r := (real * nr + (imaginary * ni)) / denom.
    i := (real * ni - (imaginary * nr)) / denom.
    i = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:i

"/ is the stuff below better ?
"/    "Implement complex division (a + ib) / (c + id).
"/     Due to double dispatch, in this routine
"/        self = (c + id) and aComplex = (a + ib)."
"/
"/    | quotient denominator |
"/
"/    self realPart abs >= (self imaginaryPart abs)
"/        ifTrue: [
"/            quotient := self imaginaryPart / self realPart.
"/            denominator := self realPart + (self imaginaryPart * quotient).
"/            ^ Complex
"/                real: (aComplex realPart + (aComplex imaginaryPart * quotient)) / denominator
"/                imaginary: (aComplex imaginaryPart - (aComplex realPart * quotient)) / denominator ]
"/        ifFalse: [
"/            quotient := self realPart / self imaginaryPart.
"/            denominator := (self realPart * quotient) + self imaginaryPart.
"/            ^ Complex
"/                real: ((aComplex realPart * quotient) + aComplex imaginaryPart) / denominator
"/                imaginary: ((aComplex imaginaryPart * quotient) - aComplex realPart) / denominator ]
!

quotientFromFixedPoint:aFixedPoint
    "Return the quotient of the argument, aFixedPoint and the receiver."

    ^ aFixedPoint asComplex / self
!

quotientFromFloat:aFloat
    "Return the quotient of the argument, aFloat and the receiver."

    ^ aFloat asComplex / self
!

quotientFromFraction:aFraction
    "Return the quotient of the argument, aFraction and the receiver."

    ^ aFraction asComplex / self
!

quotientFromInteger:anInteger
    "Return the quotient of the argument, anInteger and the receiver."

    ^ anInteger asComplex / self
!

sumFromComplex:aComplex
    "Return the sum of the receiver and the argument, aComplex."

    | r i |

    r := aComplex real + real.
    i := aComplex imaginary + imaginary.
    i = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:i
!

sumFromFixedPoint: aFixedPoint
    "Return the sum of the receiver and the argument, aFixedPoint."

    ^ aFixedPoint asComplex + self
!

sumFromFloat: aFloat
    "Return the sum of the receiver and the argument, aFloat."

    "/ ^ aFloat asComplex + self

    | r |

    r := aFloat + real.
    imaginary = 0 ifTrue:[ ^ r ].
    ^ self class real:r imaginary:imaginary

    "
     (1 % 1) + 1.0
     1.0 + (1 % 1)
    "
!

sumFromFraction: aFraction
    "Return the sum of the receiver and the argument, aFraction."

    ^ aFraction asComplex + self
!

sumFromInteger: anInteger
    "Return the sum of the receiver and the argument, anInteger."

    ^ anInteger asComplex + self
! !

!Complex methodsFor:'mathematical functions'!

angle
    "Return the radian angle for this Complex number."

    real < 0 ifTrue: [
	imaginary < 0 ifTrue: [
	    ^ (imaginary / real) arcTan - Float pi
	].
	^ Float pi + (imaginary / real) arcTan
    ].
    ^ (imaginary / real) arcTan

    "
     (1 % 1) angle radiansToDegrees
    "
!

exp
    "Return the complex exponential of the receiver."

    ^ (imaginary cos % imaginary sin) * real exp
!

sqrt
    "Return the square root of the receiver"

    | w quotient absReal absImag |

    ((real = 0) and: [ imaginary = 0 ]) ifTrue: [
        ^ self class zero
    ].
    absReal := real abs.
    absImag := imaginary abs.

    absReal >= absImag ifTrue:[
        quotient := imaginary / real.
        w := (absReal sqrt) * (((1 + (1 + (quotient * quotient)) sqrt) / 2) sqrt)
    ] ifFalse: [
        quotient := real / imaginary.
        w := (absImag sqrt) * (((quotient abs + (1 + (quotient * quotient)) sqrt) / 2) sqrt)
    ].

    real >= 0 ifTrue:[
        ^ self class real: w imaginary: (imaginary / (2 * w))
    ].
    imaginary >= 0 ifTrue: [
        ^ self class real: absImag / (2 * w) imaginary: w
    ].
    ^ self class real: absImag / (2 * w) imaginary: -1 * w
!

sqrt_bad
    "Return the square root of the receiver"

    | u v |

    (imaginary = 0 and: [real >= 0]) ifTrue: [^ real sqrt].
    v := ((self abs - real) / 2) sqrt.
    u := imaginary / 2 / v.
    ^ self class real: u imaginary: v

    "
     -4 asComplex sqrt
     4 asComplex sqrt
    "
    "
     -4 asComplex sqrt squared
    "
! !

!Complex methodsFor:'printing'!

displayOn: aGCOrStream
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].
    aGCOrStream nextPut: $(.
    self realPart printOn: aGCOrStream.
    self imaginaryPart >= 0
        ifTrue: [ aGCOrStream nextPut: $+ ]
        ifFalse: [ aGCOrStream nextPut: $- ].
    self imaginaryPart abs printOn: aGCOrStream.
    aGCOrStream nextPutAll: 'i)'

    "
     Complex real:1 imaginary:1
    "
!

printOn: aStream
    aStream nextPut: $(.
    real storeOn: aStream.
    aStream nextPutAll: '%'.
    imaginary storeOn: aStream.
    aStream nextPut: $).
!

printString
    ^ '(' , real printString, '%', imaginary printString, ')'
!

storeOn: aStream
    self printOn:aStream
! !

!Complex methodsFor:'private'!

setReal: u setImaginary: v
    real := u.
    imaginary := v.
! !

!Complex methodsFor:'testing'!

isComplex
    "Answer whether the receiver has an imaginary part
     (i.e. if it is a complex number). Always true here."

    ^ true
!

isReal
    "Return true if this Complex number has a zero imaginary part."

    ^ imaginary = 0
!

isZero
    "Answer whether 'self = self class zero'.
     We can't use #= because #= is defined in terms of #isZero"

    ^real isZero and: [imaginary isZero]
!

sign
    "return a new complex, consisting of the signs of the real and imaginary parts.
     Q: is this a good thing to do ?"

    ^ self class real: real sign imaginary: imaginary sign
! !

!Complex methodsFor:'truncation & rounding'!

ceiling
    "blocked: complex numbers have no ceiling"

    ^ self shouldNotImplement
!

floor
    "blocked: complex numbers have no floor"

    ^ self shouldNotImplement
! !

!Complex class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


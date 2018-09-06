"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Magnitude subclass:#ArithmeticValue
	instanceVariableNames:''
	classVariableNames:'DivisionByZeroSignal DomainErrorSignal OverflowSignal
		UnderflowSignal ArithmeticSignal UnorderedSignal
		ConversionErrorSignal'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!ArithmeticValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    ArithmeticValue is an abstract superclass for all things responding to
    arithmetic messages. It was inserted into the hierarchy, to allow objects
    like matrices, functions etc. to share the arithmetic methods defined here.

    Notice, that what used to be signals are now exception classes - the class
    variables and signal accessors remain here for backward compatibility.

    [class variables:]
	ArithmeticSignal        <Error>         parent of all arithmetic signals
						(never raised itself)
						New: now a reference to ArithmeticError

	DomainErrorSignal       <Error>         raised upon float errors
						(for example range in trigonometric)
						New: now a reference to DomainError

	DivisionByZeroSignal    <Error>         raised when division by 0 is attempted
						New: now a reference to ZeroDivide

	OverflowSignal          <Error>         raised on overflow/underflow conditions
	UnderflowSignal                         in float arithmetic.
						Notice: some OperatingSystems do not
						provide enough information for ST/X to
						extract the real reason for the floatException
						thus raising DomainErrorSignal in these cases.

    [author:]
	Claus Gittinger

    [See also:]
	Number
"
! !

!ArithmeticValue class methodsFor:'Signal constants'!

arithmeticSignal
    "return the parent of all arithmetic signals"

    ^ ArithmeticError
!

divisionByZeroSignal
    "return the signal which is raised on division by zero"

    ^ ZeroDivide
!

domainErrorSignal
    "return the signal which is raised on math errors
     (such as log of 0 etc.)"

    ^ DomainError
!

imaginaryResultSignal
    "return the signal which is raised when an imaginary result would be created
     (such as when taking the sqrt of a negative number)"

    ^ ImaginaryResultError
!

operationNotPossibleSignal
    ^ Error
!

overflowSignal
    "return the signal which is raised on overflow conditions (in floats)"

    ^ OverflowError
!

rangeErrorSignal
    "return the parent of the overflow/underflow signals"

    ^ RangeError
!

undefinedResultSignal
    ^ Error
!

underflowSignal
    "return the signal which is raised on underflow conditions (in floats)"

    ^ UnderflowError
!

unorderedSignal
    "return the signal which is raised when numbers are compared,
     for which no ordering is defined (for example: complex numbers)"

    ^ UnorderedNumbersError
! !

!ArithmeticValue class methodsFor:'class initialization'!

initialize
    "setup the signals"

    "/ Notice that we now use class based exceptions;
    "/ however, for backward compatibility, the class variables
    "/ referring to those are kept for a while, for subclass compatibility.
    "/ Please convert your code to access those via the Signal-constants class
    "/ messages (accessors) instead of referring to the class variables.

    ArithmeticSignal := ArithmeticError.
    DomainErrorSignal := DomainError.
    DivisionByZeroSignal := ZeroDivide.
    UnorderedSignal := UnorderedNumbersError.
    ConversionErrorSignal := ConversionError.
    OverflowSignal := OverflowError.
    UnderflowSignal := UnderflowError.
! !

!ArithmeticValue class methodsFor:'coercing & converting'!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver (class) and return it."

    ^ self subclassResponsibility
! !

!ArithmeticValue class methodsFor:'constants'!

NaN
    "return the constant NaN (not a Number)."

    ^ NotANumber new
!

infinity
    "return something which represents infinity (for my instances)"

    ^ Infinity positive
!

nan
    "VW compatibility"

    ^ self NaN
!

negativeInfinity
    "return something which represents negative infinity (for my instances)"

    ^ Infinity negative
!

unity
    "return something which represents the unity element (for my instances).
     That is the neutral element for multiplication."

    self subclassResponsibility
!

zero
    "return something which represents the zero element (for my instances).
     That is the neutral element for addition."

    self subclassResponsibility
! !

!ArithmeticValue class methodsFor:'error reporting'!

raise:aSignalSymbolOrErrorClass receiver:someNumber selector:sel arguments:argArray errorString:text 
    "ST-80 compatible signal raising. Provided for PD numeric classes.
     aSignalSymbolOrErrorClass is either an Error-subclass, or
     the selector which is sent to myself, to retrieve the Exception class / Signal."

    <context: #return>

    |msg signalOrException|

    msg := MessageSend
                receiver:someNumber
                selector:sel
                arguments:argArray.

    aSignalSymbolOrErrorClass isSymbol ifTrue:[
        signalOrException := self perform:aSignalSymbolOrErrorClass.
    ] ifFalse:[
        signalOrException := aSignalSymbolOrErrorClass.    "/ assume its an Error-Subclass
    ].

    ^ signalOrException
         raiseRequestWith:msg 
         errorString:text 
         in:thisContext sender

    "
     Number 
        raise:#domainErrorSignal
        receiver:1.0
        selector:#foo 
        errorString:'foo bar test'
    "

    "Modified: / 16.11.2001 / 14:12:09 / cg"
! !

!ArithmeticValue class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for ArithmeticValue here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == ArithmeticValue
! !

!ArithmeticValue methodsFor:'arithmetic'!

* something
    "return the product of the receiver and the argument."

    ^ self subclassResponsibility
!

+ something
    "return the sum of the receiver and the argument"

    ^ self subclassResponsibility
!

- something
    "return the difference of the receiver and the argument"

    ^ self subclassResponsibility
!

/ something
    "return the quotient of the receiver and the argument"

    ^ self subclassResponsibility
!

// something
    "return the integer quotient of dividing the receiver by aNumber with
     truncation towards negative infinity.
     
     Please be aware of the effect of truncation on negative receivers,
     and understand the difference between '//' vs. 'quo:'
     and the corresponding '\\' vs. 'rem:'"

    "/ Note: '^ (self / something) floor' may lead to infinite recursion

    ^ self subclassResponsibility

    "Modified: / 5.11.1996 / 11:46:27 / cg"
    "Modified: / 12.2.1998 / 16:31:36 / stefan"
!

\\ something
    "return the receiver modulo something.
     The remainder has the same sign as the argument, something.
     The following is always true:
        (receiver // something) * something + (receiver \\ something) = receiver

     Please be aware of the effect of truncation on negative receivers,
     and understand the difference between '//' vs. 'quo:'
     and the corresponding '\\' vs. 'rem:'."

    ^ self - ((self // something) * something)

   "
     0.9 \\ 0.4
     0.9 \\ -0.4
    -0.9 \\ 0.4
    -0.9 \\ -0.4
   "

    "Modified: / 12.2.1998 / 19:14:37 / stefan"
!

abs
    "return the absolute value of the receiver"

    (self negative) ifTrue:[^ self negated].
    ^ self
!

dist:arg
    "return the distance between the arg and the receiver."

    ^ (arg - self) abs

    "
     (1%1) dist:(0%0)
     (1@1) dist:(0@0)
     (1) dist:(0)
    "
!

modulusOf:aNumber
    "return aNumber modulo the receiver.
     The remainder has the same sign as something.
     Defined for protocol compatibility with ModuloNumber."

    ^ aNumber \\ self
!

negated
    "return the receiver negated"

    ^ self class zero - self
!

quo:something
    "Return the integer quotient of dividing the receiver by the argument
     with truncation towards zero.

     Please be aware of the effect of truncation on negative receivers,
     and understand the difference between '//' vs. 'quo:'
     and the corresponding '\\' vs. 'rem:'.

     The following is always true:
        (receiver quo: aNumber) * aNumber + (receiver rem: aNumber) = receiver
     For positive results, this is the same as #//,
     for negative results, the remainder is ignored.
     I.e.: '9 // 4 = 2' and '-9 // 4 = -3'
     in contrast: '9 quo: 4 = 2' and '-9 quo: 4 = -2'"

    ^ (self / something) truncated
!

reciprocal
    "return the receiver's reciprocal"

    ^ self class unity / self
!

rem:something
    "Return the integer remainder of dividing the receiver by the argument
     with truncation towards zero.
     The remainder has the same sign as the receiver.
     The following is always true:
        (receiver quo: something) * something + (receiver rem: something) = receiver

     Please be aware of the effect of truncation on negative receivers,
     and understand the difference between '//' vs. 'quo:'
     and the corresponding '\\' vs. 'rem:'."

    ^ self - ((self quo:something) * something)
!

uncheckedDivide:aNumber
    "return the quotient of the receiver and the argument, aNumber.
     Do not check for divide by zero (return NaN or Infinity).
     This operation is provided for emulators of other languages/semantics,
     where no exception is raised for these results (i.e. Java).
     It is only defined if the argument's type is the same as the receiver's."

    aNumber isZero ifTrue:[
        self isZero ifTrue:[^ self class NaN].
        self negative ifTrue:[^ self class negativeInfinity].
        ^ self class infinity.
    ].
    ^ self / aNumber
! !

!ArithmeticValue methodsFor:'arithmetic destructive'!

*= aNumber
    "Return the product of self multiplied by aNumber.
     The receiver MAY, but NEED NOT be changed to contain the product.
     So this method must be used as: 'a := a *= 5'.
     This method can be redefined for constructed datatypes to do optimisations"

    ^ self * aNumber

    "Created: / 28.4.1999 / 11:46:11 / stefan"
    "Modified: / 28.4.1999 / 11:53:28 / stefan"
!

+= aNumber
    "Return the sum of self and aNumber.
     The receiver MAY, but NEED NOT be changed to contain the sum.
     So this method must be used as: 'a := a += 5'.
     This method can be redefined for constructed datatypes to do optimisations"

    ^ self + aNumber

    "Created: / 28.4.1999 / 10:13:41 / stefan"
    "Modified: / 28.4.1999 / 11:54:11 / stefan"
!

-= aNumber
    "Return the difference of self and aNumber.
     The receiver MAY, but NEED NOT be changed to contain the difference.
     So this method must be used as: 'a := a -= 5'.
     This method can be redefined for constructed datatypes to do optimisations"

    ^ self - aNumber

    "Created: / 28.4.1999 / 10:13:58 / stefan"
    "Modified: / 28.4.1999 / 11:54:37 / stefan"
!

/= aNumber
    "Return the quotient of self and aNumber.
     The receiver MAY, but NEED NOT be changed to contain the quotient.
     So this method must be used as: 'a := a /= 5'.
     This method can be redefined for constructed datatypes to do optimisations"

    ^ self / aNumber

    "Created: / 28.4.1999 / 11:46:22 / stefan"
    "Modified: / 28.4.1999 / 11:55:06 / stefan"
!

div2
    "Return the quotient of self divided by 2.
     The receiver MAY, but NEED NOT be changed to contain the result.
     So this method must be used as: 'a := a div2.
     This method can be redefined for constructed datatypes to do optimisations"

    ^ self // 2

    "Created: / 28.4.1999 / 10:12:44 / stefan"
    "Modified: / 28.4.1999 / 11:56:09 / stefan"
!

mul2
    "Return the product of self multiplied by 2.
     The receiver MAY, but NEED NOT be changed to contain the result.
     So this method must be used as: a := a mul2.
     This method can be redefined for constructed datatypes to do optimisations"

    ^ self * 2

    "Created: / 28.4.1999 / 10:12:55 / stefan"
    "Modified: / 28.4.1999 / 11:56:38 / stefan"
! !

!ArithmeticValue methodsFor:'coercing & converting'!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ self subclassResponsibility
!

generality
    "return a number giving the receiver's generality.
     That number is used to convert one of the arguments in a mixed expression.
     The generality has to be defined in subclasses,
     such that gen(a) > gen(b) iff, conversion of b into a's class
     does not cut precision. 
     For example, Integer has 40, Float has 80, meaning that if we convert a Float to an Integer, 
     some precision may be lost. 
     The generality is used by ArithmeticValue>>retry:coercing:,
     which converts the lower-precision number to the higher precision
     number's class, when mixed-type arithmetic is performed."

    ^ self subclassResponsibility

    "Modified: / 5.11.1996 / 15:05:30 / cg"
    "Modified: / 13.2.1998 / 15:36:01 / stefan"
!

retry:aSymbol coercing:aNumber
    "arithmetic represented by the binary operator, aSymbol,
     could not be performed with the receiver and the argument, aNumber,
     because of the differences in representation.
     Coerce either the receiver or the argument, depending on which has higher
     generality, and try again.
     If the operation is compare for same value (=), return false if
     the argument is not a Number.
     If the generalities are the same, create an error message, since this
     means that a subclass has not been fully implemented."

    |hasGenerality myGenerality otherGenerality|

    hasGenerality := aNumber respondsTo:#generality.
    hasGenerality ifFalse:[
        (aSymbol == #=) ifTrue:[
            ^ false
        ].
        (aSymbol == #~=) ifTrue:[
            ^ true
        ].
        ^ self error:'retry:coercing: argument is not a number'.
    ].

    myGenerality := self generality.
    otherGenerality := aNumber generality.
    (myGenerality > otherGenerality) ifTrue:[
        ^ self perform:aSymbol with:(self coerce:aNumber)
    ].
    (myGenerality < otherGenerality) ifTrue:[
        ^ (aNumber coerce:self) perform:aSymbol with:aNumber
    ].
"/    self error:'retry:coercing: oops - same generality; retry should not happen'
     "same generality may happen with Lazy and LazyValue"
     ^ self perform:aSymbol with:aNumber
    
    "
        ([3] lazyValue) * ([2] lazyValue)
    "

    "Modified: 5.11.1996 / 15:03:38 / cg"
!

retry:aSymbol coercing:aNumber with:anArgument
    "arithmetic represented by the binary operator, aSymbol,
     could not be performed with the receiver and the argument, aNumber,
     because of the differences in representation.
     Coerce either the receiver or the argument, depending on which has higher
     generality, and try again.
     If the operation is compare for same value (=), return false if
     the argument is not a Number.
     If the generalities are the same, create an error message, since this
     means that a subclass has not been fully implemented."

    |hasGenerality myGenerality otherGenerality|

    hasGenerality := aNumber respondsTo:#generality.
    hasGenerality ifFalse:[
        ^ self error:'retry:coercing: argument is not a number'.
    ].

    myGenerality := self generality.
    otherGenerality := aNumber generality.
    (myGenerality > otherGenerality) ifTrue:[
        ^ self perform:aSymbol with:(self coerce:aNumber) with:anArgument
    ].
    (myGenerality < otherGenerality) ifTrue:[
        ^ (aNumber coerce:self) perform:aSymbol with:aNumber with:anArgument
    ].
"/    self error:'retry:coercing: oops - same generality; retry should not happen'
     "same generality may happen with Lazy and LazyValue"
     ^ self perform:aSymbol with:aNumber with:anArgument


    "Modified: 5.11.1996 / 15:03:38 / cg"
! !

!ArithmeticValue methodsFor:'converting'!

as32BitIEEEFloatBytesMSB:msb
    ^ self asShortFloat digitBytesMSB:msb

    "
        2  as32BitIEEEFloatBytesMSB:true
        2.0  as32BitIEEEFloatBytesMSB:true
    "
!

as64BitIEEEFloatBytesMSB:msb
    ^ self asFloat digitBytesMSB:msb

    "
        2  as64BitIEEEFloatBytesMSB:true
        2.0  as64BitIEEEFloatBytesMSB:true
    "
!

asDouble
    "ST80 compatibility: return a double with receiver's value.
     Attention: our floats are the identical to ST80's doubles"

   ^ self asFloat

    "Created: / 13.2.1998 / 15:40:14 / stefan"
!

asFixedPoint
    "return the receiver as fixedPoint number.
     Q: what should the scale be here ?"

    ^ self asFraction asFixedPoint

    "
     0.3 asFixedPoint
     0.5 asFixedPoint
     (1/5) asFloat asFixedPoint
     (1/3) asFloat asFixedPoint
     (2/3) asFloat asFixedPoint
     (1/8) asFloat asFixedPoint
     3.14159 asFixedPoint
     0.0000001 asFraction
     0.0000001 asFixedPoint
    "

    "Modified: / 25.10.1997 / 15:36:54 / cg"
!

asFixedPoint:scale
    "return the receiver as fixedPoint number with the given
     number of post-decimal-digits."

    ^ self asFraction asFixedPoint:scale

    "
     0.3 asFixedPoint:4
     0.3 asFixedPoint:3
     0.3 asFixedPoint:2
     0.3 asFixedPoint:1
     0.3 asFixedPoint:0

     0.5 asFixedPoint:3
     (1/5) asFloat asFixedPoint:1
     (1/8) asFloat asFixedPoint:1
     1.0 asFixedPoint:2
     3.14159 asFixedPoint:2
     3.14159 asFixedPoint:3
     (3.14159 asFixedPoint:2) asFixedPoint:5
    "
!

asFixedPointRoundedToScale
    "return the receiver as fixedPoint number, rounded to its scale."

    ^ self asFixedPoint roundedToScale

    "
     0.3 asFixedPoint
     0.5 asFixedPoint
     (2/3) asFloat asFixedPoint
     (1/8) asFloat asFixedPoint
     3.14159 asFixedPoint

     0.3 asFixedPointRoundedToScale
     0.5 asFixedPointRoundedToScale
     (2/3) asFloat asFixedPointRoundedToScale
     (1/8) asFloat asFixedPointRoundedToScale
     3.14159 asFixedPointRoundedToScale
    "

    "Created: / 02-08-2010 / 13:32:16 / cg"
!

asFixedPointRoundedToScale:scale
    "return the receiver as fixedPoint number with the given
     number of post-decimal-digits, rounded to its scale"

    ^ (self asFixedPoint:scale) roundedToScale

    "
     3.14159 asFixedPointRoundedToScale:1
     3.14159 asFixedPointRoundedToScale:2
     3.14159 asFixedPointRoundedToScale:3
     3.14159 asFixedPointRoundedToScale:4
    "

    "Created: / 02-08-2010 / 13:33:11 / cg"
!

asFloat
    "return a float with same value"

   ^ self subclassResponsibility
!

asFloatD
    "return a double precision float with same value.
     Added for ANSI compatibility"

   ^ self asFloat

    "Created: / 7.9.2001 / 13:36:48 / cg"
    "Modified: / 7.9.2001 / 13:38:10 / cg"
!

asFloatE
    "return a single precision float with same value.
     Added for ANSI compatibility"

   ^ self asShortFloat

    "Created: / 7.9.2001 / 13:37:06 / cg"
    "Modified: / 7.9.2001 / 13:38:15 / cg"
!

asFloatQ
    "return a quad precision float with same value.
     Added for ANSI compatibility"

   ^ self asLongFloat

    "Created: / 7.9.2001 / 13:38:44 / cg"
!

asFraction
    "return a fraction with same value"

   ^ self subclassResponsibility
!

asInteger
    "return an integer with same value - might truncate"

    ^ self truncated
!

asLimitedPrecisionReal
    "return a float of any precision with same value"

   ^ self asFloat
!

asLongFloat
    "return a longFloat with same value"

    "WARNING: could loose precision here, if not redefined in concrete classes which
     have more than float precision (i.e. LargeIntegers and Fractions)"

    ^ self asFloat asLongFloat "/ subclassResponsibility

    "Modified: / 17.4.1996 / 12:21:35 / cg"
    "Created: / 7.9.2001 / 13:39:31 / cg"
!

asScaledDecimal:scale
    "return a fixedPoint approximating the receiver's value"

    ^ self asFixedPoint:scale

    "
     1.234 asScaledDecimal:2
    "

    "Created: / 7.9.2001 / 13:46:26 / cg"
    "Modified: / 7.9.2001 / 13:46:44 / cg"
!

asShortFloat
    "return a shortFloat with same value"

   ^ self asFloat asShortFloat

    "Modified: 17.4.1996 / 12:21:35 / cg"
!

degreesToRadians
    "interpreting the receiver as degrees, return the radians"

    ^ self asFloat degreesToRadians
!

radiansToDegrees
    "interpreting the receiver as radians, return the degrees"

    ^ self asFloat radiansToDegrees
! !

!ArithmeticValue methodsFor:'double dispatching'!

differenceFromComplex:aComplex
    "the receiver does not know how to subtract from a complex -
     retry the operation by coercing to higher generality"

    ^ aComplex retry:#- coercing:self
!

differenceFromFixedPoint:aFixedPoint
    "the receiver does not know how to subtract from a fixedPoint number -
     retry the operation by coercing to higher generality"

    ^ aFixedPoint retry:#- coercing:self

    "Created: 5.11.1996 / 14:55:51 / cg"
!

differenceFromFloat:aFloat
    "the receiver does not know how to subtract from a float -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#- coercing:self
!

differenceFromFraction:aFraction
    "the receiver does not know how to subtract from a fraction -
     retry the operation by coercing to higher generality"

    ^ aFraction retry:#- coercing:self
!

differenceFromInteger:anInteger
    "the receiver does not know how to subtract from an integer -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#- coercing:self
!

differenceFromLargeFloat:aLargeFloat
    "the receiver does not know how to subtract from a largeFloat -
     retry the operation by coercing to higher generality"

    ^ aLargeFloat retry:#- coercing:self
!

differenceFromLongFloat:aLongFloat
    "the receiver does not know how to subtract from a longFloat -
     retry the operation by coercing to higher generality"

    ^ aLongFloat retry:#- coercing:self

    "Created: 17.4.1996 / 12:33:16 / cg"
!

differenceFromShortFloat:aShortFloat
    "the receiver does not know how to subtract from a shortFloat -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#- coercing:self

    "Created: 17.4.1996 / 12:33:16 / cg"
!

equalFromComplex:aComplex
    "the receiver does not know how to compare to a complex number -
     retry the operation by coercing to higher generality"

    ^ aComplex retry:#= coercing:self
!

equalFromFixedPoint:aFixedPoint
    "the receiver does not know how to compare to a fixed point -
     retry the operation by coercing to higher generality"

    ^ aFixedPoint retry:#= coercing:self
!

equalFromFloat:aFloat
    "the receiver does not know how to compare to a float -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#= coercing:self
!

equalFromFraction:aFraction
    "the receiver does not know how to compare to a fraction -
     retry the operation by coercing to higher generality"

    ^ aFraction retry:#= coercing:self
!

equalFromInteger:anInteger
    "the receiver does not know how to compare to an integer -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#= coercing:self
!

equalFromLargeFloat:aLargeFloat
    "the receiver does not know how to compare to a large float -
     retry the operation by coercing to higher generality"

    ^ aLargeFloat retry:#= coercing:self
!

equalFromLongFloat:aLongFloat
    "the receiver does not know how to compare to a long float -
     retry the operation by coercing to higher generality"

    ^ aLongFloat retry:#= coercing:self
!

equalFromShortFloat:aShortFloat
    "the receiver does not know how to compare to a short float -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#= coercing:self
!

integerQuotientFromInteger:anInteger
    "anInteger does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#// coercing:self

    "Created: / 09-08-2010 / 19:49:26 / cg"
!

isAlmostEqualToFromFloat:aFloat nEpsilon:nE
    "the receiver does not know how to compare to a short float -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#isAlmostEqualTo:nEpsilon: coercing:self with:nE
!

isAlmostEqualToFromShortFloat:aShortFloat nEpsilon:nE
    "the receiver does not know how to compare to a short float -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#isAlmostEqualTo:nEpsilon: coercing:self with:nE
!

lessFromFixedPoint:aFixedPoint
    "the receiver does not know how to compare to a fixedPoint number -
     Return true if aFixedPoint < self.
     retry the operation by coercing to higher generality"

    ^ aFixedPoint retry:#< coercing:self

    "Created: 5.11.1996 / 14:56:12 / cg"
!

lessFromFloat:aFloat
    "the receiver does not know how to compare to a float -
     Return true if aFloat < self.
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#< coercing:self
!

lessFromFraction:aFraction
    "the receiver does not know how to compare to a fraction -
     Return true if aFraction < self.
     retry the operation by coercing to higher generality"

    ^ aFraction retry:#< coercing:self
!

lessFromInteger:anInteger
    "the receiver does not know how to compare to an integer -
     Return true if anInteger < self.
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#< coercing:self
!

lessFromLargeFloat:aLargeFloat
    "the receiver does not know how to compare to a largeFloat -
     Return true if aLargeFloat < self.
     retry the operation by coercing to higher generality"

    ^ aLargeFloat retry:#< coercing:self
!

lessFromLongFloat:aLongFloat
    "the receiver does not know how to compare to a longFloat -
     Return true if aLongFloat < self.
     retry the operation by coercing to higher generality"

    ^ aLongFloat retry:#< coercing:self

    "Modified: 17.4.1996 / 12:33:33 / cg"
!

lessFromShortFloat:aShortFloat
    "the receiver does not know how to compare to a shortFloat -
     Return true if aShortFloat < self.
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#< coercing:self

    "Modified: 17.4.1996 / 12:33:33 / cg"
!

moduloFromInteger:anInteger
    "anInteger does not know how to compute the modulo from the receiver -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#\\ coercing:self

    "Created: / 12-02-2012 / 20:38:13 / cg"
!

productFromComplex:aComplex
    "the receiver does not know how to multiply a complex -
     retry the operation by coercing to higher generality"

    ^ aComplex retry:#* coercing:self
!

productFromFixedPoint:aFixedPoint
    "the receiver does not know how to multiply a fixed point number -
     retry the operation by coercing to higher generality"

    ^ aFixedPoint retry:#* coercing:self

    "Created: 5.11.1996 / 14:56:28 / cg"
!

productFromFloat:aFloat
    "the receiver does not know how to multiply a float -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#* coercing:self
!

productFromFraction:aFraction
    "the receiver does not know how to multiply a fraction -
     retry the operation by coercing to higher generality"

    ^ aFraction retry:#* coercing:self
!

productFromInteger:anInteger
    "the receiver does not know how to multiply an integer -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#* coercing:self
!

productFromLargeFloat:aLargeFloat
    "the receiver does not know how to multiply a largeFloat -
     retry the operation by coercing to higher generality"

    ^ aLargeFloat retry:#* coercing:self

    "Created: 17.4.1996 / 12:33:48 / cg"
!

productFromLongFloat:aLongFloat
    "the receiver does not know how to multiply a longFloat -
     retry the operation by coercing to higher generality"

    ^ aLongFloat retry:#* coercing:self

    "Created: 17.4.1996 / 12:33:48 / cg"
!

productFromShortFloat:aShortFloat
    "the receiver does not know how to multiply a shortFloat -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#* coercing:self

    "Created: 17.4.1996 / 12:33:48 / cg"
!

quotientFromComplex:aComplex
    "aComplex does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aComplex retry:#/ coercing:self
!

quotientFromFixedPoint:aFixedPoint
    "aFixedPoint does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aFixedPoint retry:#/ coercing:self

    "Created: 5.11.1996 / 14:56:41 / cg"
!

quotientFromFloat:aFloat
    "aFloat does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#/ coercing:self
!

quotientFromFraction:aFraction
    "aFraction does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aFraction retry:#/ coercing:self
!

quotientFromInteger:anInteger
    "anInteger does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#/ coercing:self
!

quotientFromLargeFloat:aLargeFloat
    "aLargeFloat does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aLargeFloat retry:#/ coercing:self

    "Created: 17.4.1996 / 12:34:00 / cg"
!

quotientFromLongFloat:aLongFloat
    "aLongFloat does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aLongFloat retry:#/ coercing:self

    "Created: 17.4.1996 / 12:34:00 / cg"
!

quotientFromShortFloat:aShortFloat
    "aShortFloat does not know how to divide by the receiver -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#/ coercing:self

    "Created: 17.4.1996 / 12:34:00 / cg"
!

remainderFromFloat:aFloat
    "aFloat does not know how to compute the remainder with the receiver -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#rem: coercing:self
!

remainderFromShortFloat:aShortFloat
    "aShortFloat does not know how to compute the remainder with the receiver -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#rem: coercing:self
!

sumFromComplex:aComplex
    "the receiver does not know how to add a complex -
     retry the operation by coercing to higher generality"

    ^ aComplex retry:#+ coercing:self
!

sumFromFixedPoint:aFixedPoint
    "the receiver does not know how to add a fixed point number -
     retry the operation by coercing to higher generality"

    ^ aFixedPoint retry:#+ coercing:self

    "Created: 5.11.1996 / 14:56:56 / cg"
!

sumFromFloat:aFloat
    "the receiver does not know how to add a float -
     retry the operation by coercing to higher generality"

    ^ aFloat retry:#+ coercing:self
!

sumFromFraction:aFraction
    "the receiver does not know how to add a fraction -
     retry the operation by coercing to higher generality"

    ^ aFraction retry:#+ coercing:self
!

sumFromInteger:anInteger
    "the receiver does not know how to add an integer -
     retry the operation by coercing to higher generality"

    ^ anInteger retry:#+ coercing:self
!

sumFromLargeFloat:aLargeFloat
    "the receiver does not know how to add a largeFloat -
     retry the operation by coercing to higher generality"

    ^ aLargeFloat retry:#+ coercing:self

    "Created: 17.4.1996 / 12:34:10 / cg"
!

sumFromLongFloat:aLongFloat
    "the receiver does not know how to add a longFloat -
     retry the operation by coercing to higher generality"

    ^ aLongFloat retry:#+ coercing:self

    "Created: 17.4.1996 / 12:34:10 / cg"
!

sumFromShortFloat:aShortFloat
    "the receiver does not know how to add a shortFloat -
     retry the operation by coercing to higher generality"

    ^ aShortFloat retry:#+ coercing:self

    "Created: 17.4.1996 / 12:34:10 / cg"
! !

!ArithmeticValue methodsFor:'mathematical functions'!

** aNumber
    "Answer the receiver raised to the power of the argument, aNumber."
    "same as Number>>raisedTo:"

    ^self raisedTo: aNumber

    "Created: / 15-07-2006 / 15:11:05 / cg"
    "Modified: / 17-07-2006 / 12:51:33 / cg"
!

basicRaisedToInteger:exp
    "return the receiver raised to exp"

    |result e t|

    "use the addition chaining algorithm,
     which is much faster for big exponents"

    result := 1.
    t := self.
    exp < 0 ifTrue:[
        e := exp negated.
    ] ifFalse:[
        e := exp.
    ].

    [e ~~ 0] whileTrue:[
        [(e bitAnd:1) == 0] whileTrue:[
            e := e bitShift:-1.
            t := t * t.
        ].
        e := e - 1.
        result := result * t.
    ].

    (exp < 0) ifTrue:[
        ^ 1 / result
    ].

    ^ result

    "
     (2.0 raisedToInteger:216)
     (2 raisedToInteger:216)
     (2 raisedTo:216)
            -> 105312291668557186697918027683670432318895095400549111254310977536

     (2 raisedToInteger:216) asFloat
     (2 raisedTo:216) asFloat
            -> 1.05312E+65

     (2 raisedToInteger:500)
     (2 raisedTo:500)
            -> 3273390607896141870013189696827599152216642046043064789483291368096133796404674554883270092325904157150886684127560071009217256545885393053328527589376
     (2 raisedTo:-500)
            -> (1/3273390607896141870013189696827599152216642046043064789483291368096133796404674554883270092325904157150886684127560071009217256545885393053328527589376)
     2 raisedToInteger:10
            -> 1024
    -2 raisedToInteger:10
            -> 1024
     -2 raisedToInteger:9
            -> -512
     10 raisedToInteger:-10
            -> (1/10000000000)
     2 raisedToInteger:0
            -> 1
     2 raisedToInteger:-1
            -> (1/2)

     Time millisecondsToRun:[
        10000 timesRepeat:[
            (2 raisedToInteger:500)
        ]
     ]

     Time millisecondsToRun:[
        |bigNum|
        bigNum := 2 raisedToInteger:500.
        10 timesRepeat:[
            (bigNum raisedToInteger:500)
        ]
     ]
    "

    "Created: / 27.4.1999 / 15:19:22 / stefan"
    "Modified: / 27.4.1999 / 16:16:11 / stefan"
!

raisedTo: aNumber
    aNumber isInteger ifTrue:[
	^ self raisedToInteger:aNumber
    ].
    ^ self subclassResponsibility
!

raisedToInteger:exp
    "return the receiver raised to exp.
     Warning: if the receiver is a float/double, currently INF
     may be returned. This may be changed silently to raise an error
     in future versions."

    ^ self basicRaisedToInteger:exp

    "
     (2.0 raisedToInteger:10000)
     (2 raisedToInteger:10000)
     (2 raisedToInteger:-10000)

     (2.0 raisedToInteger:216)
     (2 raisedToInteger:216)
     (2 raisedTo:216)
            -> 105312291668557186697918027683670432318895095400549111254310977536

     (2 raisedToInteger:216) asFloat
     (2 raisedTo:216) asFloat
            -> 1.05312E+65

     (2 raisedToInteger:500)
     (2 raisedTo:500)
            -> 3273390607896141870013189696827599152216642046043064789483291368096133796404674554883270092325904157150886684127560071009217256545885393053328527589376
     2 raisedToInteger:10
            -> 1024
    -2 raisedToInteger:10
            -> 1024
     -2 raisedToInteger:9
            -> -512
     10 raisedToInteger:-10
            -> (1/10000000000)
     2 raisedToInteger:0
            -> 1
     2 raisedToInteger:-1
            -> (1/2)

     Time millisecondsToRun:[
        10000 timesRepeat:[
            (2 raisedToInteger:500)
        ]
     ]

     Time millisecondsToRun:[
        |bigNum|
        bigNum := 2 raisedToInteger:500.
        10 timesRepeat:[
            (bigNum raisedToInteger:500)
        ]
     ]
    "

    "Created: / 27.4.1999 / 15:19:22 / stefan"
    "Modified: / 27.4.1999 / 16:16:11 / stefan"
!

squared
    "return receiver * receiver"

    ^ self * self
! !

!ArithmeticValue methodsFor:'queries'!

respondsToArithmetic
    "return true, if the receiver responds to arithmetic messages"

    ^ true
! !

!ArithmeticValue methodsFor:'testing'!

denominator
    "return the denominator of the receiver"

    ^ 1
!

even
    "return true if the receiver is divisible by 2.
     Only defined for whole-numbers."

    ^ self class
        raise:DomainError
        receiver:self
        selector:#even
        arguments:#()
        errorString:'Receiver must be a whole-number'

    "/ No, this is bad: ^ self truncated asInteger even

    "
        2.4 even
        2.0 even
    "
!

isComplex
    "Answer whether the receiver has an imaginary part
     (i.e. if it is a complex number). Always false here."

    ^ false

    "Modified: / 9.7.1998 / 10:19:27 / cg"
!

isFinite
    "return true, if the receiver is finite
     i.e. it can be represented as a rational number."

    ^ true
!

isInfinite
    ^ false
!

isNegativeInfinity
    ^ self negative and:[self isInfinite]
!

isNegativeZero
    "return false - must be redefined by subclasses which can represent a negative zero
     (i.e. limitedPrecisionReal classes)"

    ^ false
!

isPositiveInfinity
    ^ self positive and:[self isInfinite]
!

isReal
    "return true, if the receiver is some kind of real number (as opposed to a complex);
     false is returned here - the method is only redefined in Number (and Complex)."

    ^ false

    "Modified: / 6.11.2001 / 13:20:20 / cg"
    "Created: / 6.11.2001 / 13:26:29 / cg"
!

isZero
    "return false - must be redefined by subclasses which can represent a negative zero
     (i.e. limitedPrecisionReal classes)"

    ^ self = self class zero
!

negative
    "return true if the receiver is less than zero."

    ^ self < self class zero
!

numerator
    "return the numerator of the receiver."

    ^ self
!

odd
    "return true if the receiver is not divisible by 2"

    ^ self even not
!

positive
    "return true, if the receiver is greater or equal to zero (not negative)"

    ^ self negative not
!

sign
    "return the sign of the receiver (-1, 0 or 1)"

    |zero|

    zero := self class zero.
    (self < zero) ifTrue:[^ -1].
    (zero < self) ifTrue:[^ 1].
    ^ 0
!

strictlyPositive
    "return true, if the receiver is greater than zero"

    ^ self class zero < self
! !

!ArithmeticValue methodsFor:'truncation & rounding'!

ceiling
    "return the integer nearest the receiver towards positive infinity."

    |anInteger|

    anInteger := self // 1.       "truncates towards negative infinity"
    anInteger = self ifTrue:[^ anInteger].
    ^ anInteger + 1
!

floor
    "return the receiver truncated towards negative infinity"

    ^ self // 1
!

roundTo:aNumber
    "return the receiver rounded to multiples of aNumber"

    ^ (self / aNumber) rounded * aNumber

    "
     0 roundTo:4
     1 roundTo:4
     2 roundTo:4
     3 roundTo:4
     4 roundTo:4
     5 roundTo:4
     6 roundTo:4
     7 roundTo:4

     7.123 roundTo:0.1
     7.523 roundTo:0.1
     7.583 roundTo:0.1 
     7.623 roundTo:0.1
     7.623 roundTo:0.01 
     7.628 roundTo:0.01 
    "
!

roundUpTo:aNumber
    "return the receiver rounded up to the next multiple of aNumber"

    ^ (self / aNumber) ceiling * aNumber

    "
     0 roundUpTo:4
     1 roundUpTo:4
     2 roundUpTo:4
     3 roundUpTo:4
     4 roundUpTo:4
     5 roundUpTo:4
     6 roundUpTo:4
     7 roundUpTo:4
     8 roundUpTo:4
     (3@4) roundUpTo:8
     (3@4) roundUpTo:(5 @ 4)
     (3@3) roundUpTo:(5 @ 4) 
    "
!

rounded
    "return the integer nearest the receiver"

    self negative ifTrue:[
	^ (self - 0.5) ceiling
    ].
    ^ (self + 0.5) floor

    "Modified: 5.11.1996 / 11:31:59 / cg"
!

truncateTo:aNumber
    "return the receiver truncated to multiples of aNumber"

    |t|
    
    aNumber <= 0 ifTrue:[self error:'argument must be positive'].
    
    t := (self / aNumber) floor * aNumber.
    (aNumber isInteger) ifTrue:[
        ^ t asInteger
    ].    
    ^ t

    "
     truncate to multiples of 4 
        123.456 truncateTo:4
        124.456 truncateTo:4
     truncate to multiples of 2 
        122.456 truncateTo:2
        123.456 truncateTo:2
        124.456 truncateTo:2
     normal truncate
        123.456 truncateTo:1
        124.456 truncateTo:1
     truncate to decimal digits    
        123.456 truncateTo:0.1
        123.987 truncateTo:0.1
        123.456 truncateTo:0.01
    "
!

truncated
    "return the receiver truncated towards zero"

    self negative ifTrue:[
	^ self ceiling
    ].
    ^ self floor
! !

!ArithmeticValue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ArithmeticValue initialize!

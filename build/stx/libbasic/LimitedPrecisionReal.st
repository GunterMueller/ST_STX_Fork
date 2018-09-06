"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

Number subclass:#LimitedPrecisionReal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!LimitedPrecisionReal class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Abstract superclass for any-precision floating point numbers (i.e. IEE floats and doubles).

    Due to historic reasons, ST/X's Floats are what Doubles are in ST-80.
    The reason is that in some Smalltalk's, double floats are called Float, and no single float exists (VSE, V'Age),
    whereas in others, there are both Float and Double classes (VisualWorks).
    In order to allow code from both families to be loaded into ST/X without a missing class error,
    we decided to use IEE doubles as the internal representation of Float and make Double an alias to it.
    This should work for either family.
    If you really only want single precision floating point numbers, use ShortFloat instances.
    But be aware, that there is usually no advantage (neither in memory usage, due to memory alignment restrictions),
    nor in speed, as these days, the CPUs are just as fast doing double precision operations.
    (There is a difference when doing bulk operations, and you should consider using FloatArray for those).

    Range and Precision of Storage Formats:
    =======================================

      Format |   Class    |   Array Class   | Bits / Significant  | Smallest Pos Number | Largest Pos Number | Significant Digits 
             |            |                 |      (Binary)       |                     |                    |     (Decimal)
      -------+------------+-----------------+---------------------+---------------------+--------------------+--------------------    
      half   |     --     | HalfFloatArray  |    16 / 11          |  6.10... x 10−5     |  6.55...  x 10+5   |      3.3
      -------+------------+-----------------+---------------------+---------------------+--------------------+--------------------    
      single | ShortFloat | FloatArray      |    32 / 24          |  1.175...x 10-38    |  3.402... 10+38    |      6-9
      -------+------------+-----------------+---------------------+---------------------+--------------------+--------------------    
      double | Float      | DoubleArray     |    64 / 53          |  2.225...x 10-308   |  1.797... 10+308   |     15-17
      -------+------------+-----------------+---------------------+---------------------+--------------------+--------------------    
      double | LongFloat  |     --          |   128 / 113         |  3.362...x 10-4932  |  1.189... 10+4932  |     33-36
      ext    |            |                 |                     |                     |                    |
      (SPARC)|            |                 |                     |                     |                    |
      -------+            |                 |---------------------+---------------------+--------------------+--------------------    
      double |            |                 |    96 / 64          |  3.362...x 10-4932  |  1.189... 10+4932  |     18-21
      ext    |            |                 |                     |                     |                    |
      (x86)  |            |                 |                     |                     |                    |
      -------+------------+-----------------+---------------------+---------------------+--------------------+--------------------    
        --   | LargeFloat |     --          |     arbitrary       |  arbitrarily small  |  arbitrarily large |     arbitrary
      -------+------------+-----------------+---------------------+---------------------+--------------------+--------------------    

    HalfFloats are only supported in fixed array containers. This was added for OpenGL and other graphic libraries which allow
    for texture, and vertex data to be passed quickly in that format (see http://www.opengl.org/wiki/Small_Float_Formats).
    Long- and LargeFloat are not supported as array containers. 
    These formats are seldom used for bulk data.

    Bulk Containers:
    ================
    If you have a vector or matrix (and especially: large one's) of floating point numbers, the well known
    Array is a very inperformant choice. The reason is that it keeps pointers to each of its elements, and each element
    (if it is a float) is itself stored somewhere in the object memory.
    Thus, there is both a space overhead (every float object has an object header, for class and other information), and
    also a performance overhead (extra indirection, cache misses and alignment inefficiencies).
    For this, the bulk numeric containers are provided, which keep the elements unboxed and properly aligned.
    Use them for matrices and large numeric vectors. They also provide some optimized bulk operation methods,
    such as adding, multiplying etc.
    
    Comparing Floats:
    =================
    Due to rounding errors (usually on the last bit), you shalt not compare two floating point numbers
    using the #= operator. For example, the value 0.1 cannot be represented as a sum of powers of two fractions,
    and will therefore be always an approximation with a half bit error in the last bit of the mantissa.
    Usually, the print functions take this into consideration and return a (faked) '0.1'.
    However, this half bit error may accumulate, for example, when multiplying that by 10, the error may get large
    enough to be no longer pushed under the rug by the print function, and you will get '0.9999999999999' from it.

    Also, comparing against a proper 1.0 (which is representable as an exact power of 2), you will get a false result.
    (i.e. 0.1 * 10 ~= 1.0)
    This often confuses non-computer scientists (and even some of those are ocasionally).
    For this, you should always provide an epsilon value, when comparing two numbers. The epsilon value is
    the distance you accept two number to be apart to be still considered equal. Effectively the epsilon says
    are those nearer than this epsilon?.
    Now we could say is the delta between two numbers smaller than 0.00001,
    and get a reasonable answer for big numbers. But what if we compare two tiny numbers?
    Then a reasonable epsilon must also be much smaller. 
    Actually, the epsilon should always be computed dynamically depending on the two values compared.
    That is what the #isAlmostEqualTo:nEpsilon: method does for you. It does not take an absolute epsilon,
    but instead the number of distinct floating point numbers that the two compared floats may be apart.
    That is: the number of actually representable numbers between those two. Effectively, that is the difference between
    the two mantissas, when the numbers are scaled to the same exponent, taking the number of mantissa bits into account.

    [author:]
        Claus Gittinger

    [see also:]
        Fraction FixedPoint
"
! !

!LimitedPrecisionReal class methodsFor:'instance creation'!

fromInteger:anInteger
    "return a float with anInteger's value.
     Since floats have a limited precision, you usually loose bits when doing this
     (see Float decimalPrecision, LongFloat decimalPrecision."

    |newFloat sign absVal completeAbsVal delta mask|

    newFloat := self zero.
    sign := anInteger sign.
    (sign ~~ 0) ifTrue:[
        "be careful to do round to nearest even floating point value -
         thanks to Nicolas Cellier for this code"

        absVal := anInteger abs.
        delta := absVal highBit - self precision.
        delta > 0 ifTrue: [
            completeAbsVal := absVal.
            "eliminate insignificant/trailing bits"
            absVal := absVal bitShift: delta negated.
            "inexact := trailingBits ~= 0.
             Round to nearest even"
            (completeAbsVal bitAt:delta) ~= 0 ifTrue:[
                mask := (1 bitShift:delta-1) - 1.
                ((completeAbsVal bitAnd:mask) ~= 0 or:[absVal odd]) ifTrue:[
                    absVal := absVal + 1
                ].
            ].
        ] ifFalse: [
            delta := 0
        ].
        absVal digitLength to:1 by:-1 do:[:i |
            newFloat := (newFloat * 256) + (absVal digitByteAt:i).
        ].
        delta ~~ 0 ifTrue: [
            newFloat := newFloat timesTwoPower:delta.
        ].
        (sign < 0) ifTrue:[
            newFloat := newFloat negated
        ]
    ].
    ^ newFloat


    "
     ShortFloat fromInteger:2
     12345678901234567890 asShortFloat            

     1234567890 asFloat                     
     1234567890 asFloat asInteger                    
     -1234567890 asFloat asInteger                    

     12345678901234567890 asFloat storeString            
     12345678901234567890 asFloat asInteger   
     -12345678901234567890 asFloat asInteger   

     12345678901234567890 asLongFloat           
     12345678901234567890 asLongFloat asInteger 
     -12345678901234567890 asLongFloat asInteger 

     123456789012345678901234567890 asLongFloat           
     123456789012345678901234567890 asLongFloat asInteger  
     -123456789012345678901234567890 asLongFloat asInteger  

     1234567890123456789012345678901234567890 asLongFloat           
     1234567890123456789012345678901234567890 asLongFloat asInteger  
     -1234567890123456789012345678901234567890 asLongFloat asInteger

     'this test is on 65 bits'.
     self assert: 16r1FFFFFFFFFFFF0801 asDouble ~= 16r1FFFFFFFFFFFF0800 asDouble.
     'this test is on 64 bits'.
     self assert: 16r1FFFFFFFFFFFF0802 asDouble ~= 16r1FFFFFFFFFFFF0800 asDouble.
     'nearest even is upper'.
     self assert: 16r1FFFFFFFFFFF1F800 asDouble = 16r1FFFFFFFFFFF20000 asDouble.
     'nearest even is lower'.
     self assert: 16r1FFFFFFFFFFFF0800 asDouble = 16r1FFFFFFFFFFFF0000 asDouble.
    "
!

fromLimitedPrecisionReal:anLPReal
    "return a float with anLPReals value.
     You might loose bits when doing this.
     Slow fallback."

    |fract|

    anLPReal isFinite ifFalse:[
        anLPReal isNaN ifTrue:[^ self NaN].
        anLPReal negative ifTrue:[^ self negativeInfinity].
        ^ self infinity
    ].

    fract := anLPReal asTrueFraction.
    ^ (self fromInteger:fract numerator) / (self fromInteger:fract denominator)
!

fromNumerator:numerator denominator:denominator
    "Create a limited precision real from a Rational.
     This version will answer the nearest flotaing point value,
     according to IEEE 754 round to nearest even default mode"

    |a b q r exponent floatExponent n ha hb hq q1 eMin precision nSubHq|

    a := numerator abs.
    b := denominator abs.
    ha := a highBit.
    hb := b highBit.    

    precision := self precision.

    "If both numerator and denominator are represented exactly in floating point number,
     then fastest thing to do is to use hardwired float division"
    (ha <= precision and:[hb <= precision]) ifTrue: [
        ^ (self coerce:numerator) / (self coerce:denominator)
    ].

    "Try and obtain a mantissa with 1 bit excess precision.
     First guess is rough, we might get one more bit or one less"
    exponent := ha - hb - precision - 1.
    exponent > 0
        ifTrue: [b := b bitShift: exponent]
        ifFalse: [a := a bitShift: exponent negated].
    q := a quo: b.
    r := a - (q * b).
    hq := q highBit.

    "check for gradual underflow, in which case we should use less bits"
    floatExponent := exponent + hq - 1.
    eMin := 2 - (1 bitShift: (self numBitsInExponent - 1)).
    n := floatExponent >= eMin
        ifTrue: [precision + 1]
        ifFalse: [precision + 1 + floatExponent - eMin].

    nSubHq := n - hq.

    nSubHq < 0 ifTrue: [
        exponent := exponent + hq - n.
        r := (q bitAnd: (1 bitShift:nSubHq) - 1) * b + r.
        q := q bitShift:nSubHq
    ] ifFalse:[nSubHq > 0 ifTrue: [
        exponent := exponent + hq - n.
        q1 := (r bitShift:nSubHq) quo: b.
        q := (q bitShift:nSubHq) bitAnd: q1.
        r := r - (q1 * b)
    ]].

    "check if we should round upward.
     The case of exact half (q bitAnd: 1) isZero not & (r isZero)
     will be handled by self fromInteger: conversion"
    ((q bitAnd:1) ~~ 0 and:[r ~~ 0]) ifTrue:[
        q := q + 1
    ].

    (numerator negative xor:denominator negative) ifTrue: [
        q := q negated.
    ].

    ^ (self coerce:q) timesTwoPower:exponent

    "
        Time millisecondsToRun:[
            1000000  timesRepeat:[
                Float fromNumerator:12345678901234567890 denominator:987654321
            ].
        ]

        |fraction|
        fraction := 12345678901234567890//987654321.
        Time millisecondsToRun:[
            1000000  timesRepeat:[
                fraction asFloat
            ].
        ]
    "
!

new:aNumber
    "catch this message - not allowed for floats/doubles"

    self error:'Floats/Doubles cannot be created with new:'
!

readFrom:aStringOrStream onError:exceptionBlock
    "read a float from a string"

    |num|

    num := super readFrom:aStringOrStream onError:[^ exceptionBlock value].
    ^ self coerce:num

    "
     Float readFrom:'.1'
     Float readFrom:'0.1'
     Float readFrom:'0'

     ShortFloat readFrom:'.1'
     ShortFloat readFrom:'0.1'
     ShortFloat readFrom:'0'

     LongFloat readFrom:'.1'
     LongFloat readFrom:'0.1'
     LongFloat readFrom:'0'

     LimitedPrecisionReal readFrom:'bla' onError:nil
     Float readFrom:'bla' onError:nil
     ShortFloat readFrom:'bla' onError:nil
    "

    "Created: / 07-01-1998 / 16:17:19 / cg"
    "Modified: / 23-11-2010 / 14:35:41 / cg"
! !

!LimitedPrecisionReal class methodsFor:'class initialization'!

initialize
    "initialize ANSI compliant float globals"

    Smalltalk at:#FloatE put:ShortFloat.
    Smalltalk at:#FloatD put:Float.
    Smalltalk at:#FloatQ put:LongFloat.

    "
     self initialize
    "

    "Created: / 7.9.2001 / 14:02:45 / cg"
    "Modified: / 7.9.2001 / 14:02:54 / cg"
! !

!LimitedPrecisionReal class methodsFor:'constants & defaults'!

NaN
    "return the constant NaN (not a Number)."

    |zero|

    zero := self zero.
    ^ zero uncheckedDivide:zero.

    "
      ShortFloat NaN  
      Float NaN       
      LongFloat NaN   
      LargeFloat NaN   
    "
!

computeEpsilon
    "return the maximum relative spacing"

    ^ self radix asFloat raisedToInteger:(1 - self precision).

    "
      ShortFloat computeEpsilon  
      Float computeEpsilon       
      LongFloat computeEpsilon   
    "
!

e
    "return the closest approximation of the irrational number e"

    self subclassResponsibility

    "Modified: / 7.9.2001 / 14:05:02 / cg"
!

emax
    "return the largest exponent"

    ^ (1 << (self numBitsInExponent-1)) - 1

    "
     Float emax
     ShortFloat emax
    "
!

emin
    "return the smallest exponent"

    ^ self subclassResponsibility

    "
     Float emin  
     ShortFloat emin  
    "
!

epsilon
    "return the maximum relative spacing"

    ^ self radix asFloat raisedToInteger:(1 - self precision)

    "
      ShortFloat epsilon  
      Float epsilon       
      LongFloat epsilon   
    "
!

fmax
    "The largest value allowed by instances of this class."

    |radix _radix|

    radix := self radix.
    _radix := (self fromNumber: radix).
    ^ ((self fromNumber: 1) -
            (_radix timesTwoPower: self precision negated - 1)) * radix
            * (_radix timesTwoPower: self emax - 1)

    "
     Float fmax      
     ShortFloat fmax 
     LongFloat fmax  
    "

    "Modified (comment): / 16-11-2016 / 23:12:36 / cg"
!

fmin
    "The smallest value allowed by instances of this class."

    ^ self subclassResponsibility
!

infinity
    "return a float representing infinity"

    ^ self unity uncheckedDivide:self zero

    "
      ShortFloat infinity  
      Float infinity       
      LongFloat infinity   
      LargeFloat infinity   
    "
!

maxSmallInteger
    "answer the largest possible SmallIntger value as instance of myself"

    ^ self fromInteger:SmallInteger maxVal.

    "
       Float maxSmallInteger.
       LongFloat maxSmallInteger.
       ShortFloat maxSmallInteger.
    "
!

negativeInfinity
    "return a float representing negative infinity"

    ^ self unity negated uncheckedDivide:self zero

    "
      ShortFloat negativeInfinity   
      Float negativeInfinity       
      LongFloat negativeInfinity   
      LargeFloat negativeInfinity   
    "
!

pi
    "return the closest approximation of the irrational number pi"

    self subclassResponsibility

    "Created: / 7.9.2001 / 14:07:35 / cg"
! !

!LimitedPrecisionReal class methodsFor:'queries'!

decimalPrecision
    "return the number of valid decimal digits"

    ^ ((self precision + 1) / (10.0 log:self radix)) ceiling   "use ceiling, since the last decimal digit contains some precision"

    "
     ShortFloat decimalPrecision 
     Float decimalPrecision      
     LongFloat decimalPrecision  
    "
!

denormalized
    "Return whether the instances of this class can
     represent values in denormalized format."

    ^ true
!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     Although not really shared, floats should be treated
     so, to be independent of the implementation of the arithmetic methods."

    ^ true


!

isAbstract
    "Return if this class is an abstract class.
     True is returned for LimitedPrecisionReal here; false for subclasses."

    ^ self == LimitedPrecisionReal

    "
     1.0 class isAbstract
    "
!

isIEEEFormat
    "return true, if this machine represents floats in IEEE format.
     Currently, no support is provided for non-ieee machines
     to convert their floats into this (which is only relevant,
     if such a machine wants to send floats as binary to some other
     machine).
     Machines with non-IEEE format are VAXed and IBM370-type systems
     (among others). Today, most systems use IEEE format floats."

%{
#ifdef __s390__
    RETURN(false);
#endif
%}.

    ^ true "/ this may be a lie
!

numBitsInExponent
    "return the number of bits in the exponent"

    ^ self subclassResponsibility
!

numBitsInIntegerPart
    "answer the number of bits in the integer part of the mantissa.
     Most floating point formats are normalized to get rid of the extra
     bit."

    ^ 0
!

numBitsInMantissa
    "return the number of bits in the mantissa
     (typically 1 less than the precision due to the hidden bit)"

    ^ self subclassResponsibility
!

precision
    "return the number of valid mantissa bits"

    ^ self numBitsInMantissa + 1 - self numBitsInIntegerPart 
!

radix
    "return the radix (base)"

    self subclassResponsibility

    "Created: / 7.9.2001 / 14:08:20 / cg"
! !

!LimitedPrecisionReal methodsFor:'accessing'!

at:index
    "redefined to prevent access to individual bytes in a real."

    self error:'not allowed for floats/doubles'
!

at:index put:aValue
    "redefined to prevent access to individual bytes in a real"

    self error:'not allowed for floats/doubles'
! !

!LimitedPrecisionReal methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument."

"/ as soon as Float are float & Double are doubles,
"/ use:
"/    ^ aNumber productFromDouble:self asDouble

    ^ aNumber productFromFloat:self asFloat

    "Modified: 17.4.1996 / 12:35:36 / cg"
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber"

"/ as soon as Float are float & Double are doubles,
"/ use:
"/    ^ aNumber sumFromDouble:self asDouble

    ^ aNumber sumFromFloat:self asFloat

    "Modified: 17.4.1996 / 12:35:55 / cg"
!

- aNumber
    "return the difference of the receiver and the argument, aNumber"

"/ as soon as Float are float & Double are doubles,
"/ use:
"/    ^ aNumber differenceFromDouble:self asDouble

    ^ aNumber differenceFromFloat:self asFloat

    "Modified: 17.4.1996 / 12:36:07 / cg"
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber"

    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
        ^ ZeroDivide raiseRequestWith:thisContext.
    ].
"/ as soon as Float are float & Double are doubles,
"/ use:
"/    ^ aNumber quotientFromDouble:self asDouble

    ^ aNumber quotientFromFloat:self asFloat

    "Modified: / 17.4.1996 / 12:36:21 / cg"
    "Modified: / 26.7.1999 / 10:46:11 / stefan"
!

// aNumber
    "return the integer quotient of dividing the receiver by aNumber with
     truncation towards negative infinity."

    ^ (self / aNumber) floor asInteger

    "Modified: 5.11.1996 / 11:45:37 / cg"
!

ceiling
    ^ self asTrueFraction ceiling
!

floor
    ^ self asTrueFraction floor
!

timesTwoPower:anInteger
    "multiply self by a power of two.
     Implementation takes care of preserving class and avoiding overflow/underflow
     Thanks to Nicolas Cellier for this code"

    |half two h1 h2|

    two := self coerce:2.0.

    anInteger abs highBit >= (self class numBitsInExponent - 2) ifTrue:[
        half := anInteger // 2.

        anInteger even ifTrue:[
            "/ halves are equal
            h2 := h1 := (two raisedToInteger: half).
        ] ifFalse:[
            h1 := (two raisedToInteger: half).
            anInteger > 0 ifTrue:[
                h2 := h1 * two.
            ] ifFalse:[
                h2 := (two raisedToInteger: anInteger - half).
            ].
        ].
        ^ (self * h1) * h2
    ] ifFalse: [
        ^ self * (two raisedToInteger: anInteger).
    ]

    "
     (1 asShortFloat timesTwoPower: 3) class = ShortFloat.
     (1 asLongFloat timesTwoPower: 1024).
     (1 asFloat timesTwoPower: -1024) timesTwoPower: 1024.

     (2.0 asShortFloat timesTwoPower: -150) timesTwoPower: 150    
     (2.0 asLongFloat timesTwoPower: -150) timesTwoPower: 150   
     (2.0 asFloat timesTwoPower: -150) timesTwoPower: 150       

     (2.0 asShortFloat timesTwoPower: -149) timesTwoPower: 149  
     (2.0 asLongFloat timesTwoPower: -149) timesTwoPower: 149    
     (2.0 asFloat timesTwoPower: -149) timesTwoPower: 149        

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            (2.0 timesTwoPower: 150)
        ]
     ]  
    "
! !

!LimitedPrecisionReal methodsFor:'bytes access'!

digitBytes
    "answer the float's digit bytes im IEEE format.
     Use the native machine byte ordering."

    |sz "{ Class:SmallInteger }"
     bytes|

    sz := self basicSize.
    bytes := ByteArray new:sz.
    1 to:sz do:[:i|
        bytes at:i put:(self basicAt:i).
    ].
    ^ bytes

    "
        Float pi digitBytes
        ShortFloat pi digitBytes
    "
!

digitBytesMSB:msb
    "answer the float's digit bytes im IEEE format.
     If msb == true, use MSB byte order, otherwise LSB byte order."

    |sz "{ Class:SmallInteger }"
     bytes|

    self class isIEEEFormat ifFalse:[self error:'unsupported operation'].

    sz := self basicSize.
    bytes := ByteArray new:sz.

    (UninterpretedBytes isBigEndian == msb) ifTrue:[
        1 to:sz do:[:i|
            bytes at:i put:(self basicAt:i).
        ].
    ] ifFalse:[
        "reverse the bytes"
        1 to:sz do:[:i|
            bytes at:sz-i+1 put:(self basicAt:i).
        ].
    ].
    ^ bytes

    "
        Float pi digitBytesMSB:false
        Float pi digitBytesMSB:true
        ShortFloat pi digitBytesMSB:false
        ShortFloat pi digitBytesMSB:true
    "
! !

!LimitedPrecisionReal methodsFor:'coercing & converting'!

asFloat
    ^ Float fromLimitedPrecisionReal:self
!

asFraction
    "Answer a rational number (Integer or Fraction) representing the receiver.
     This conversion uses the continued fraction method to approximate 
     a floating point number.
     In contrast to #asTrueFraction, which returns exactly the value of the float,
     this rounds in the last significant bit of the floating point number.
    "

    |num1 denom1 num2 denom2 int frac newD temp limit|

    self isFinite ifFalse:[
"/        ^ self asMetaNumber.
        ^ self class
            raise:#domainErrorSignal
            receiver:self
            selector:#asFraction
            arguments:#()
            errorString:'Cannot represent non-finite number as fraction'
    ].

    limit := 10 raisedToInteger:self defaultNumberOfDigits.
    num1 := self truncated. 
    denom1 := 1.            "The first of two alternating denominators"
    num2 := 1.              "The second numerator"
    denom2 := 0.            "The second denominator--will update"
    int := num1.            "The integer part of self"
    frac := self fractionPart.             
    [frac = 0] whileFalse:[                
        newD := 1.0 / frac.                   
        int := newD truncated.        
        frac := newD fractionPart.      "save the fractional part for next time"
        temp := num2.                   "old numerator and save it"
        num2 := num1.                         
        num1 := num1 * int + temp.      "Update first numerator"
        temp := denom2.                 "old denominator and save it"
        denom2 := denom1.                    
        denom1 := int * denom1 + temp.  "Update first denominator"
        limit < denom1 ifTrue:[
            "Is ratio past float precision?  If so, pick which of the two ratios to use"
            num2 = 0.0 ifTrue:[
                "Is second denominator 0?"
                ^ Fraction numerator:num1 denominator:denom1
            ].
            ^ Fraction numerator:num2 denominator:denom2
        ]
    ].

    "If fractional part is zero, return the first ratio"
    denom1 = 1 ifTrue:[
        "Am i really an Integer?"
        ^ num1 "Yes, return Integer result"
    ].
    "Otherwise return Fraction result"
    ^ Fraction numerator:num1 denominator:denom1

    "
     1.1 asFraction      
     1.2 asFraction      
     0.3 asFraction   
     0.5 asFraction  
     (1/5) asFloat asFraction  
     (1/8) asFloat asFraction  
     (1/13) asFloat asFraction 
     (1/10) asFloat asFraction 
     (1/10) asFloat asTrueFraction asFixedPoint scale:20 
     3.14159 asFixedPoint scale:20        
     3.14159 storeString       
     3.14159 asFraction asFloat storeString       
     1.3 asFraction            
     1.0 asFraction            
     1E6 asFraction            
     1E-6 asFraction            
    "

    "Modified: / 25.10.1997 / 16:41:19 / cg"
!

asInteger
    "return an integer with same value - might truncate"

    |max maxF|

    self isFinite ifFalse:[
"/        ^ self asMetaNumber.
        ^ self class
            raise:#domainErrorSignal
            receiver:self
            selector:#asInteger
            arguments:#()
            errorString:'Cannot represent non-finite number as integer'
    ].

    self abs < 2e16 ifTrue:[
        "/ NOTICE: this must be redefined in float
        "/ subclasses to handle the smallinteger range;
        "/ i.e. this may only be invoked for reals
        "/ which are NOT within the smallInt range.
        "/ otherwise, endless recursion is the consequence.

        max := SmallInteger maxVal // 2 + 1.
        maxF := max asFloat.

        ^ (self quo:maxF) * max + (self rem:maxF) truncated
    ].
    ^ self asTrueFraction

    "
     12345.0 asInteger     
     1e15 asInteger        
     1e33 asInteger asFloat
     1e303 asInteger asFloat
    "

    "Modified: / 16.11.2001 / 14:15:33 / cg"
!

asLargeFloat
    ^ LargeFloat fromLimitedPrecisionReal:self
!

asLimitedPrecisionReal
    "return a float of any precision with same value"

   ^ self
!

asLongFloat
    ^ LongFloat fromLimitedPrecisionReal:self
!

asRational
    "Answer a Rational number--Integer or Fraction--representing the receiver.
     Same as asFraction fro st-80 compatibility."

    ^ self asFraction

    "
     1.1 asRational      
     1.2 asRational      
     0.3 asRational   
     0.5 asRational 
     (1/5) asFloat asRational
     (1/8) asFloat asRational  
     (1/13) asFloat asRational 
     3.14159 asRational        
     3.14159 asRational asFloat       
     1.3 asRational  
     1.0 asRational  
    "
!

asShortFloat
    ^ ShortFloat fromLimitedPrecisionReal:self
!

asTrueFraction
    "Answer a fraction or integer that EXACTLY represents self,
     an any-precision IEEE floating point number, consisting of:
        numMantissaBits bits of normalized mantissa (i.e. with hidden leading 1-bit)
        optional numExtraBits between mantissa and exponent (normalized flag for ext-real)
        numExponentBits bits of 2s complement exponent
        1 sign bit.
     Taken from Floats asTrueFraction"

    |shifty sign expPart exp fraction fractionPart result zeroBitsCount
     numBytes numBits numBitsInMantissa maskMantissa numBitsInExponent maskExponent
     biasExponent numIntegerBits|

    self isFinite ifFalse:[
        ^ self asMetaNumber
"/        ^ self class
"/            raise:#domainErrorSignal
"/            receiver:self
"/            selector:#asTrueFraction
"/            arguments:#()
"/            errorString:'Cannot represent non-finite float as a fraction'.
    ].

    "Extract the bits of an IEEE anySize float "
    numBytes := self basicSize.
    numIntegerBits := self class numBitsInIntegerPart.
    numBitsInMantissa := self class numBitsInMantissa. maskMantissa := (1 bitShift:numBitsInMantissa) - 1.
    numBitsInExponent := self class numBitsInExponent. maskExponent := (1 bitShift:numBitsInExponent) - 1.
    numBits := numBitsInMantissa + numBitsInExponent. "not (numBytes * 8 - 1) -- there could be 80 float bits in 96 overall bits"
    biasExponent := maskExponent bitShift:-1.

    shifty := LargeInteger basicNew numberOfDigits:numBytes.
    UninterpretedBytes isBigEndian ifTrue:[
        1 to:numBytes do:[:i | shifty digitAt:(numBytes+1-i) put:(self basicAt:i)].
    ] ifFalse:[
        1 to:numBytes do:[:i | shifty digitAt:i put:(self basicAt:i)].
    ].

    " Extract the sign and the biased exponent "
    sign := (shifty bitAt:numBits+1) == 0 ifTrue: [1] ifFalse: [-1].
    expPart := (shifty bitShift:numBitsInMantissa negated) bitAnd: maskExponent.

    " Extract fractional part; answer 0 if this is a true 0.0 value "
    fractionPart := shifty bitAnd:maskMantissa.
    ( expPart=0 and: [ fractionPart=0 ] ) ifTrue: [ ^ 0  ].

    numIntegerBits == 0 ifTrue:[
        " Replace omitted leading 1 in fraction (Notice: quadIEEE format does not do this)"
        fraction := fractionPart bitOr: (maskMantissa + 1).
    ] ifFalse:[
        fraction := fractionPart.
    ].

    "Unbias exponent"
    exp := biasExponent - expPart + (numBitsInMantissa - numIntegerBits).

    " Form the result. When exp>fractionalPrecision, the exponent is adjusted by
      the number of trailing zero bits in the fraction to minimize
      the (huge) time otherwise spent in #gcd: of fraction handling code."
    exp negative ifTrue: [
        result := sign * (fraction bitShift: exp negated) 
    ] ifFalse:[
        zeroBitsCount := fraction lowBit - 1.
        exp := exp - zeroBitsCount.
        exp <= 0 ifTrue: [
            zeroBitsCount := zeroBitsCount + exp.
            result := sign * (fraction bitShift:zeroBitsCount negated) 
        ] ifFalse: [
            result := Fraction
                    numerator: (sign * (fraction bitShift: zeroBitsCount negated))
                    denominator: (1 bitShift:exp) 
        ] 
    ].

    "Low cost validation omitted after extensive testing"
    "(result asFloat = self) ifFalse: [self error: 'asTrueFraction validation failed']."

    ^ result 

    "
     0.3 asFloat asTrueFraction   
     0.3 asShortFloat asTrueFraction  
     0.3 asLongFloat asTrueFraction   

     1.25 asTrueFraction     
     1.25 asShortFloat asTrueFraction     
     0.25 asTrueFraction     
     -0.25 asTrueFraction    
     3e37 asTrueFraction     

     LongFloat NaN asTrueFraction              
     LongFloat infinity asTrueFraction          
     LongFloat negativeInfinity asTrueFraction 
    "
!

exponent
    "extract a normalized floats exponent.
     The returned value depends on the float-representation of
     the underlying machine and is therefore highly unportable.
     This is not for general use.
     This assumes that the mantissa is normalized to
     0.5 .. 1.0 and the floats value is mantissa * 2^exp"

    |shifty expPart exp numBytes numBitsInMantissa maskMantissa numBitsInExponent maskExponent
     biasExponent numIntegerBits fractionPart|

    "Extract the bits of an IEEE anySize float "
    numBytes := self basicSize.
    numBitsInMantissa := self class numBitsInMantissa. maskMantissa := (1 bitShift:numBitsInMantissa) - 1.
    numBitsInExponent := self class numBitsInExponent. maskExponent := (1 bitShift:numBitsInExponent) - 1.
    numIntegerBits := self class numBitsInIntegerPart.
    biasExponent := maskExponent bitShift:-1.

    shifty := LargeInteger basicNew numberOfDigits:numBytes.
    UninterpretedBytes isBigEndian ifTrue:[
        1 to:numBytes do:[:i | shifty digitAt:(numBytes+1-i) put:(self basicAt:i)].
    ] ifFalse:[
        1 to:numBytes do:[:i | shifty digitAt:i put:(self basicAt:i)].
    ].

    " Extract the sign and the biased exponent "
    expPart := (shifty bitShift:numBitsInMantissa negated) bitAnd: maskExponent.

    " Extract fractional part; answer 0 if this is a true 0.0 value "
    fractionPart := shifty bitAnd:maskMantissa.
    ( expPart=0 and: [ fractionPart=0 ] ) ifTrue: [ ^ 0  ].

    exp := expPart - biasExponent + 1.
    ^ exp

    "
     0.3 asFloat exponent  
     0.3 asShortFloat exponent  
     0.3 asLongFloat exponent  

     0.0 exponent2      0
     1.0 exponent2      1
     2.0 exponent2      2
     3.0 exponent2      2
     4.0 exponent2      3
     0.5 exponent2      0
     0.4 exponent2      -1
     0.25 exponent2     -1
     0.00000011111 exponent2  -23 
    "
!

fractionalPart
    "This has been renamed to #fractionPart for ST80 compatibility.

     extract the after-decimal fraction part.
     the floats value is 
        float truncated + float fractionalPart"

    <resource:#obsolete>

    self obsoleteMethodWarning:'please use #fractionPart'.
    ^ self fractionPart

    "Modified: / 28.10.1998 / 17:10:12 / cg"
    "Created: / 28.10.1998 / 17:10:32 / cg"
! !

!LimitedPrecisionReal methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater"

    ^ aNumber lessFromFloat:self asFloat

    "Modified: 17.4.1996 / 13:34:50 / cg"
! !

!LimitedPrecisionReal methodsFor:'copying'!

deepCopy
    "return a deep copy of myself
     - because storing into floats is not recommended/allowed, its ok to return the receiver"

    ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of myself
     - because storing into floats is not recommended/allowed, its ok to return the receiver"

    ^ self
!

shallowCopy
    "return a shallow copy of the receiver"

    ^ self
!

simpleDeepCopy
    "return a deep copy of the receiver
     - because storing into floats is not recommended/allowed, its ok to return the receiver"

    ^ self
! !

!LimitedPrecisionReal methodsFor:'double dispatching'!

differenceFromFraction:aFraction
    "sent when a fraction does not know how to subtract the receiver, a float"

    |d|

    d := aFraction denominator.
    ^ (aFraction numerator - (self * d)) / d
!

productFromFraction:aFraction
    "sent when a fraction does not know how to multiply the receiver, a float"

    ^ self * aFraction numerator / aFraction denominator
!

quotientFromFraction:aFraction
    "Return the quotient of the argument, aFraction and the receiver.
     Sent when aFraction does not know how to divide by the receiver."

    ^ aFraction numerator / (self * aFraction denominator)
!

sumFromFraction:aFraction
    "sent when a fraction does not know how to add the receiver, a float"

    |d|

    d := aFraction denominator.
    ^ (self * d + aFraction numerator) / d
!

sumFromTimestamp:aTimestamp
    "I am to be interpreted as seconds, return the timestamp this number of seconds
     after aTimestamp"

    ^ aTimestamp addMilliseconds:(self * 1000) truncated.

    "
     Timestamp now sumFromTimestamp:aTimestamp   
     100.0 sumFromTimestamp:Timestamp now 

     |t1 t2|
     t1 := Timestamp now. 
     t2 := 1.5 sumFromTimestamp:t1.
     t1 inspect. t2 inspect.
    "
! !



!LimitedPrecisionReal methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to
     the argument, aStream.

     LimitedPrecisonReal and its subclasses use #printString instead of
     #printOn: as basic print mechanism."

    aStream nextPutAll:self printString

    "Modified: / 20.1.1998 / 14:10:46 / stefan"
!

printString
    "return a printed representation of the receiver
     LimitedPrecisonReal and its subclasses use #printString instead of
     #printOn: as basic print mechanism."

    ^ self subclassResponsibility

    "Created: / 17.4.1996 / 12:12:20 / cg"
    "Modified: / 20.1.1998 / 14:10:47 / stefan"
!

storeOn:aStream
    "append a printed representation of the receiver to
     the argument, aStream.

     LimitedPrecisonReal and its subclasses use #storeString instead of
     #storeOn: as basic store mechanism."

    aStream nextPutAll:self storeString
!

storeString
    "return a printed representation of the receiver
     LimitedPrecisonReal and its subclasses use #storeString instead of
     #storeOn: as basic print mechanism."

    ^ self subclassResponsibility
! !

!LimitedPrecisionReal methodsFor:'queries'!

defaultNumberOfDigits
    "Answer how many digits of accuracy this class supports"

    ^ self class decimalPrecision 

    "
        Float new defaultNumberOfDigits
        LongFloat new defaultNumberOfDigits
        ShortFloat new defaultNumberOfDigits
    "
!

precision
    "return the number of valid mantissa bits.
     Should be redefined in classes which allow per-instance precision specification"

    ^ self class precision
!

size
   "redefined since reals are kludgy (ByteArry)"

   ^ 0
! !


!LimitedPrecisionReal methodsFor:'testing'!

isFinite
   ^ self subclassResponsibility

    "Created: / 7.1.1998 / 12:02:06 / stefan"
!

isFloat
    "return true, if the receiver is some kind of floating point number;
     false is returned here.
     Same as #isLimitedPrecisionReal, but a better name ;-)"

    ^ true

    "Created: / 14.11.2001 / 14:57:55 / cg"
!

isInfinite
    "return true, if the receiver is an infinite float (Inf).
     These are not created by ST/X float operations (they raise an exception);
     however, inline C-code could produce them ..."

    ^ (self isFinite or:[self isNaN]) not.

    "
        1.0 isInfinite
        (0.0 uncheckedDivide: 0.0) isInfinite
        (1.0 uncheckedDivide: 0.0) isInfinite
    "

    "Modified: / 7.1.1998 / 12:01:30 / stefan"
!

isLimitedPrecisionReal
    "return true, if the receiver is some kind of limited precision real (i.e. floating point) number;
     true is returned here - the method is redefined from Object."

    ^ true
!

isNaN
   ^ self subclassResponsibility

    "Modified: 12.2.1997 / 16:45:27 / cg"
!

isNegativeZero
    "many systems have two float.Pnt zeros"

    ^ (self isZero) and:[self printString first == $-]

    "
     0.0 asLongFloat isNegativeZero     
     -0.0 asLongFloat isNegativeZero       
     -1.0 asLongFloat isNegativeZero       
     1.0 asLongFloat isNegativeZero       

     0.0 asLargeFloat isNegativeZero     
     -0.0 asLargeFloat isNegativeZero       
    "
    "
     0.0 asLongFloat isZero                      
     -0.0 asLongFloat isZero       

     0.0 > 0   
     -0.0 < 0       
    "
!

numberOfBits
    "return the size (in bits) of the real;
     typically, this is 64 for Floats and 32 for ShortFloats,
     but who knows ..."

    self subclassResponsibility
!

positive
    "return true if the receiver is greater or equal to zero (not negative)"

    ^ self sign >= 0

    "Modified: 17.4.1996 / 13:35:10 / cg"
!

sign
    "return the sign of the receiver (-1, 0 or 1)"

    self strictlyPositive  ifTrue:[^ 1].
    self negative ifTrue:[^ -1].
    ^ 0

    "
        -1.0 sign
        -0.0 sign
        1.0 sign
        0.0 sign
    "
! !

!LimitedPrecisionReal methodsFor:'truncation & rounding'!

ceilingAsFloat
    ^ self coerce:(self ceiling).

    "
     0.4 asLongFloat ceilingAsFloat
    "
!

floorAsFloat
    ^ self coerce:(self floor).

    "
     0.4 asLongFloat floorAsFloat
    "
!

roundedAsFloat
    self negative ifTrue:[ ^ (self - 0.5) ceilingAsFloat ].
    ^ (self + 0.5) floorAsFloat
!

truncatedAsFloat
    ^ self coerce:(self truncated).

    "
     0.4 asLongFloat truncatedAsFloat
    "
! !

!LimitedPrecisionReal methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitFloat:with: to aVisitor."

    ^ aVisitor visitFloat:self with:aParameter
! !

!LimitedPrecisionReal class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


LimitedPrecisionReal initialize!

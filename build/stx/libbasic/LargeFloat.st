"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic' }"

LimitedPrecisionReal subclass:#LargeFloat
	instanceVariableNames:'exponent mantissa precision'
	classVariableNames:'Zero One NaN PositiveInfinity NegativeInfinity Pi_1000 E_1000'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!LargeFloat class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Experimental Code.
    The implementation is neither complete nor tuned for performance - still being developed.

    This class provides arbitrary precision floats. These are represented as:
      exponent,
      mantissa

    [author:]
        Claus Gittinger

    [see also:]
        Number
        Float LongFloat ShortFloat Fraction FixedPoint 
        SmallInteger LargeInteger
"
!

examples
"

     (1 to:1000) inject:1 asLargeFloat into:[:p :m | p * m]          
     (1 to:1000) inject:1 into:[:p :m | p * m]                 

     Time millisecondsToRun:[ 
        (1 to:20000) inject:1 asLargeFloat into:[:p :m | p * m]
     ]  

     Time millisecondsToRun:[ 
        (1 to:20000) inject:1 into:[:p :m | p * m]
     ]   
"
! !

!LargeFloat class methodsFor:'instance creation'!

fromInteger:anInteger
    ^ self basicNew 
        mantissa:anInteger 
        exponent:0

    "
     LargeFloat fromInteger:123456

     1 asLargeFloat       
     2 asLargeFloat       
     1000 factorial asLargeFloat             
    "
!

fromLimitedPrecisionReal:aLimitedPrecisionReal
    |shifty numBytes numBitsInMantissa maskMantissa numBitsInExponent maskExponent
     numIntegerBits numBits biasExponent lpRealClass sign expPart fractionPart fraction exp|

    aLimitedPrecisionReal isFinite ifFalse:[
        aLimitedPrecisionReal isNaN ifTrue:[^ self NaN].
        aLimitedPrecisionReal > 0 ifTrue:[^ self infinity].
        ^ self negativeInfinity
    ].

    lpRealClass := aLimitedPrecisionReal class.
    numBytes := aLimitedPrecisionReal basicSize.
    numBitsInMantissa := lpRealClass numBitsInMantissa. maskMantissa := (1 bitShift:numBitsInMantissa) - 1.
    numBitsInExponent := lpRealClass numBitsInExponent. maskExponent := (1 bitShift:numBitsInExponent) - 1.
    numIntegerBits := lpRealClass numBitsInIntegerPart.
    numBits := numBitsInMantissa + numBitsInExponent. 
    biasExponent := maskExponent bitShift:-1.

    shifty := LargeInteger basicNew numberOfDigits:numBytes.
    UninterpretedBytes isBigEndian ifTrue:[
        1 to:numBytes do:[:i | shifty digitAt:(numBytes+1-i) put:(aLimitedPrecisionReal basicAt:i)].
    ] ifFalse:[
        1 to:numBytes do:[:i | shifty digitAt:i put:(aLimitedPrecisionReal basicAt:i)].
    ].
    sign := (shifty bitAt:numBits+1) == 0 ifTrue: [1] ifFalse: [-1].
    expPart := (shifty bitShift:numBitsInMantissa negated) bitAnd: maskExponent.
    fractionPart := shifty bitAnd:maskMantissa.
    ( expPart=0 and: [ fractionPart=0 ] ) ifTrue: [ ^ self zero  ].

    numIntegerBits == 0 ifTrue:[
        " Replace omitted leading 1 in fraction (Notice: quadIEEE format does not do this)"
        fraction := fractionPart bitOr: (maskMantissa + 1).
    ] ifFalse:[
        fraction := fractionPart.
    ].

    "Unbias exponent"
    exp := biasExponent - expPart + (numBitsInMantissa - numIntegerBits).

    ^ self basicNew 
        mantissa:(fraction * sign) 
        exponent:(exp negated)

    "
     1.0 asLargeFloat       
     2.0 asLargeFloat       
     20000.0 asLargeFloat   
     2e6 asLargeFloat                                  
     1e300 asLargeFloat             
     2e300 asLargeFloat             

     0.5 asLargeFloat      
     0.25 asLargeFloat     
     (1.0/20000.0) asLargeFloat 
     2e-6 asLargeFloat        
     2e-300 asLargeFloat      

     -1.0 asLargeFloat       
     -0.5 asLargeFloat      

     Float NaN asLargeFloat              
     Float infinity asLargeFloat         
     Float negativeInfinity asLargeFloat 
    "
!

mantissa:m exponent:e
    ^ self basicNew mantissa:m exponent:e

    "
     LargeFloat mantissa:1 exponent:0 
     LargeFloat mantissa:2 exponent:0 
     LargeFloat mantissa:4 exponent:0   
     LargeFloat mantissa:8 exponent:0 
     LargeFloat mantissa:1 exponent:-1
     LargeFloat mantissa:1 exponent:-2
     LargeFloat mantissa:1 exponent:-3
    "
!

mantissa:m exponent:e precision:p
    ^ self basicNew mantissa:m exponent:e precision:p
! !

!LargeFloat class methodsFor:'class initialization'!

initialize
    NaN := self mantissa:0 exponent:999.
    PositiveInfinity := self mantissa:0 exponent:1.
    NegativeInfinity := self mantissa:0 exponent:-1.
    One := self mantissa:1 exponent:0.
    Zero := self mantissa:0 exponent:0.

    "
     LargeFloat initialize
    "
! !

!LargeFloat class methodsFor:'constants'!

NaN
    ^ NaN

    "
     LargeFloat NaN
     (0.0 uncheckedDivide:0.0)
    "
!

infinity
    ^ PositiveInfinity 

    "
     LargeFloat infinity
     (1.0 uncheckedDivide:0.0)
    "
!

negativeInfinity
    ^ NegativeInfinity

    "
     LargeFloat negativeInfinity
     (-1.0 uncheckedDivide:0.0)
    "
!

pi
    Pi_1000 isNil ifTrue:[
        Pi_1000 := FixedPoint pi asLargeFloat
    ].
    ^ Pi_1000.

    "
     LargeFloat pi
    "
!

unity
    ^ One

    "
     LargeFloat unity
    "
!

zero
    ^ Zero

    "
     LargeFloat zero
    "
! !

!LargeFloat class methodsFor:'queries'!

radix
   "answer the radix of a LargeFloats exponent"

    ^ 2 
! !

!LargeFloat methodsFor:'accessing'!

exponent
    ^ exponent
!

mantissa
    ^ mantissa
!

precision
    ^ precision ? 200
! !

!LargeFloat methodsFor:'arithmetic'!

* aNumber
    ^ aNumber productFromLargeFloat:self
!

+ aNumber
    ^ aNumber sumFromLargeFloat:self

    "
     1.0 asLargeFloat
    "
!

- aNumber
    ^ aNumber differenceFromLargeFloat:self
!

/ aNumber
    ^ aNumber quotientFromLargeFloat:self
!

negated
    mantissa = 0 ifTrue:[
        exponent = 0 ifTrue:[ ^ self ].
        self == NaN ifTrue:[^ self].
        self == NegativeInfinity ifTrue:[^ PositiveInfinity].
        ^ NegativeInfinity
    ].

    ^ self class 
        mantissa:(mantissa negated)
        exponent:exponent 
        precision:self precision.

    "
     LargeFloat unity negated
    "
! !

!LargeFloat methodsFor:'coercing & converting'!

asInteger
    "return an integer with same value - might truncate"

    exponent = 0 ifTrue:[^ mantissa].

    mantissa == 0 ifTrue:[
        "/ INF or NAN
        ^ self class
            raise:#domainErrorSignal
            receiver:self
            selector:#asInteger
            arguments:#()
            errorString:'Cannot represent non-finite as integer'.
"/        ^ self asMetaNumber.
    ].

    exponent > 0 ifTrue:[
        ^ mantissa * (2 raisedTo:exponent)
    ].
    ^ mantissa // (2 raisedTo:exponent negated)

    "
     (self new exponent:0 mantissa:100) asInteger 
     (self new exponent:1 mantissa:100) asInteger 
     (self new exponent:-1 mantissa:100) asInteger 
    "
!

asLargeFloat
    "return a large float with same value - thats me"

    ^ self
!

asTrueFraction
    "Answer a fraction or integer that EXACTLY represents self."

    exponent = 0 ifTrue: [ ^ mantissa].

    mantissa == 0 ifTrue:[
        "/ INF or NAN
        ^ self class
            raise:#conversionErrorSignal
            receiver:self
            selector:#asTrueFraction
            arguments:#()
            errorString:'Cannot represent non-finite float as fraction'.
"/        ^ self asMetaNumber.
    ].

    exponent > 0 ifTrue: [
        ^ mantissa bitShift:exponent 
    ].
    ^ Fraction
        numerator: mantissa
        denominator: (1 bitShift:exponent negated) 

    "
     0.3 asFloat asTrueFraction   
     0.3 asShortFloat asTrueFraction  
     0.3 asLongFloat asTrueFraction   
     0.3 asLargeFloat asTrueFraction   

     1 asLargeFloat asTrueFraction     
     2 asLargeFloat asTrueFraction     
     0.5 asLargeFloat asTrueFraction     

     0.25 asLargeFloat asTrueFraction     
     -0.25 asLargeFloat asTrueFraction    
     0.125 asLargeFloat asTrueFraction    
     -0.125 asLargeFloat asTrueFraction    

     1.25 asLargeFloat asTrueFraction       
     3e37 asLargeFloat asTrueFraction     

     LargeFloat NaN asTrueFraction               -> error
     LargeFloat infinity asTrueFraction          -> error
     LargeFloat negativeInfinity asTrueFraction  -> error
    "
!

coerce:aNumber
    "return the argument as a LargeFloat"

    ^ aNumber asLargeFloat
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 100
! !

!LargeFloat methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater"

    ^ aNumber lessFromLargeFloat:self
!

= aNumber
    "return true, if the argument is equal in value"

    ^ aNumber equalFromLargeFloat:self

    "
     LargeFloat unity = LargeFloat zero  
     LargeFloat unity = LargeFloat unity 

     LargeFloat unity = nil            
     LargeFloat unity ~= nil            
    "
!

hash
    "return a number for hashing; redefined, since floats compare
     by numeric value (i.e. 3.0 = 3), therefore 3.0 hash must be the same
     as 3 hash."

    exponent == 0 ifTrue:[^ mantissa hash].
    exponent < 64 ifTrue:[^ (mantissa bitShift:exponent) hash ].
    ^ mantissa hash bitXor:exponent hash

    "
     LargeFloat unity hash
     LargeFloat zero hash

     3 hash       
     3.0 hash
     3.1 hash  
     3.14159 hash  
     31.4159 hash 
     3.141591 hash 
     1.234567890123456 hash  
     1.234567890123457 hash   
     Set withAll:#(3 3.0 99 99.0 3.1415)
    "
! !

!LargeFloat methodsFor:'double dispatching'!

differenceFromLargeFloat:aLargeFloat
    |otherExponent otherMantissa e m|

    otherExponent := aLargeFloat exponent.
    otherMantissa := aLargeFloat mantissa.

    otherMantissa == 0 ifTrue:[
        otherExponent = 0 ifTrue:[^ self negated].
        "/ INF or NaN
        aLargeFloat isNaN ifTrue:[^ NaN].
        self isFinite ifTrue:[^ aLargeFloat].
        aLargeFloat sign ~~ self sign ifTrue:[^ self negated].
        ^ NaN
    ].
    mantissa == 0 ifTrue:[
        exponent = 0 ifTrue:[^ aLargeFloat].
        "/ INF or NaN
        self isNaN ifTrue:[^ NaN].
        ^ self negated
    ].

    otherExponent = exponent ifTrue:[
        m := otherMantissa - mantissa. 
        e := exponent
    ] ifFalse:[
        otherExponent> exponent ifTrue:[
            m := (otherMantissa bitShift:(otherExponent-exponent)) - mantissa.
            e := exponent
        ] ifFalse:[
            m := otherMantissa - (mantissa bitShift:(exponent-otherExponent)).
            e := otherExponent
        ]
    ].
    ^ self class
        mantissa:m 
        exponent:e
        precision:(self precision min:aLargeFloat precision)
!

equalFromLargeFloat:aLargeFloat
    aLargeFloat exponent = exponent ifTrue:[
        ^ aLargeFloat mantissa = mantissa
    ].
    "assuming normalized numbers, they cannot be equal then"
    ^ false
!

lessFromLargeFloat:aLargeFloat
    |otherExponent otherMantissa|

    otherExponent := aLargeFloat exponent.
    otherMantissa := aLargeFloat mantissa.

    otherExponent > exponent ifTrue:[
        ^ otherMantissa < (mantissa bitShift:(otherExponent-exponent))
    ].
    otherExponent < exponent ifTrue:[
        ^ (otherMantissa bitShift:(exponent-otherExponent)) < mantissa
    ].
    ^ otherMantissa < mantissa
!

productFromLargeFloat:aLargeFloat
    |otherMantissa otherExponent|

    otherMantissa := aLargeFloat mantissa.
    otherExponent := aLargeFloat exponent.

    otherMantissa == 0 ifTrue:[
        otherExponent ~= 0 ifTrue:[
            "/ INF or NaN
            aLargeFloat isNaN ifTrue:[^ NaN].
            self negative ifTrue:[^ aLargeFloat negated].
            ^ aLargeFloat
        ].
    ].
    mantissa == 0 ifTrue:[
        exponent = 0 ifTrue:[^ self].
        "/ INF or NaN
        self isNaN ifTrue:[^ NaN].
        aLargeFloat negative ifTrue:[^ self negated].
        ^ self
    ].

    ^ self class
        mantissa:(mantissa * otherMantissa) 
        exponent:(exponent + otherExponent)
        precision:(self precision min:aLargeFloat precision)
!

quotientFromLargeFloat:aLargeFloat
    "Return the quotient of the argument, aLargeFloat and the receiver.
     Sent when aLargeFloat does not know how to divide by the receiver."

    |otherMantissa otherExponent q|

    otherMantissa := aLargeFloat mantissa.
    otherExponent := aLargeFloat exponent.

    otherMantissa == 0 ifTrue:[
        otherExponent = 0 ifTrue:[^ aLargeFloat].
        "/ INF or NaN
        aLargeFloat isNaN ifTrue:[^ NaN].
        self negative ifTrue:[^ aLargeFloat negated].
        ^ aLargeFloat
    ].
    mantissa == 0 ifTrue:[
        exponent = 0 ifTrue:[^ self].
        "/ INF or NaN
        self isNaN ifTrue:[^ NaN].
        aLargeFloat negative ifTrue:[^ self negated].
        ^ self
    ].
    q := (otherMantissa / mantissa).
    q isInteger ifFalse:[
        self halt.    
    ].
    ^ self class
        mantissa:q 
        exponent:(otherExponent - exponent)
!

sumFromLargeFloat:aLargeFloat
    |otherExponent otherMantissa e m|

    otherExponent := aLargeFloat exponent.
    otherMantissa := aLargeFloat mantissa.

    otherMantissa == 0 ifTrue:[
        otherExponent = 0 ifTrue:[^ self].
        "/ INF or NaN
        aLargeFloat isNaN ifTrue:[^ NaN].
        self isFinite ifTrue:[^ aLargeFloat].
        aLargeFloat sign == self sign ifTrue:[^ aLargeFloat].
        ^ NaN
    ].
    mantissa == 0 ifTrue:[
        exponent = 0 ifTrue:[^ aLargeFloat].
        "/ INF or NaN
        self isNaN ifTrue:[^ NaN].
        ^ self
    ].

    otherExponent = exponent ifTrue:[
        m := otherMantissa + mantissa. 
        e := exponent
    ] ifFalse:[
        otherExponent> exponent ifTrue:[
            m := (otherMantissa bitShift:(otherExponent-exponent)) + mantissa.
            e := exponent
        ] ifFalse:[
            m := otherMantissa + (mantissa bitShift:(exponent-otherExponent)).
            e := otherExponent
        ]
    ].
    ^ self class
        mantissa:m 
        exponent:e
        precision:(self precision min:aLargeFloat precision)
! !

!LargeFloat methodsFor:'printing'!

printOn:aStream
    exponent == 0 ifTrue:[
        mantissa printOn:aStream.
        aStream nextPutAll:'.0'.
        ^ self
    ].
    mantissa == 0 ifTrue:[
        self == NaN ifTrue:[ aStream nextPutAll:'NAN'. ^ self ].
        self == NegativeInfinity ifTrue:[ aStream nextPutAll:'-INF'. ^ self].
        self == PositiveInfinity ifTrue:[ aStream nextPutAll:'INF'. ^ self].
        self error:'invalid largeFloat' mayProceed:true.
        aStream nextPutAll:'Invalid'. ^ self.
    ].

    exponent > 0 ifTrue:[
self halt.
        (mantissa bitShift:exponent) printOn:aStream.
        aStream nextPutAll:'.0'.
        ^ self
    ].
    ((mantissa / (1 bitShift:exponent negated)) asFixedPoint:6) printOn:aStream.

    "
    
    "
! !

!LargeFloat methodsFor:'private'!

mantissa:mantissaArg exponent:exponentArg  
    "set instance variables.
     Notice, that the floats value is m * 2^e"

    exponent := exponentArg.
    mantissa := mantissaArg.
    precision := Infinity positive.
    self normalize.
!

mantissa:mantissaArg exponent:exponentArg precision:precisionArg  
    "set instance variables.
     Notice, that the floats value is m * 2^e"

    exponent := exponentArg.
    mantissa := mantissaArg.
    precision := precisionArg.
    self normalize
!

normalize
    "adjust m & e such that m is the smallest possible 
     (i.e. has no least significant zero bit).
     Notice, that the floats value is m * 2^e"

    |shift|

    shift := mantissa lowBit - 1.
    shift > 0 ifTrue:[
        mantissa := mantissa bitShift:shift negated.
        exponent := exponent + shift
    ].

    "
     self mantissa:1 exponent:0
     self mantissa:2 exponent:0
     self mantissa:4 exponent:0  
     self mantissa:8 exponent:0  
     self mantissa:10 exponent:-1
     self mantissa:10 exponent:0 
     self mantissa:10 exponent:1 
    "
! !

!LargeFloat methodsFor:'queries'!

epsilon
   "answer the radix of a LargeFloats exponent"

    |p|

    p := precision.
    p isFinite ifTrue:[
        ^ self class radix asFloat raisedTo:(1 - p)
    ].
    "/ mhmh - what should we use here ???
    ^ LongFloat epsilon
! !

!LargeFloat methodsFor:'testing'!

isFinite
    ^ mantissa ~= 0 or:[exponent = 0]
!

isInfinite
    ^ mantissa = 0 and:[exponent ~= 0]
!

isNaN
    ^ self == NaN
!

isZero
    ^ self == Zero
!

negative
    "return true if the receiver is negative"

    mantissa == 0 ifTrue:[ ^ exponent negative].
    ^ mantissa negative
!

sign
    "return the sign of the receiver"

    mantissa == 0 ifTrue:[ 
        "special value for infinites"
        ^ exponent sign
    ].
    ^ mantissa sign
! !

!LargeFloat class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/LargeFloat.st,v 1.7 2004/11/12 12:23:46 cg Exp $'
! !

LargeFloat initialize!




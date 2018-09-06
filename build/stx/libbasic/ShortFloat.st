"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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

LimitedPrecisionReal variableByteSubclass:#ShortFloat
	instanceVariableNames:''
	classVariableNames:'DefaultPrintFormat Pi E Epsilon'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!ShortFloat primitiveDefinitions!
%{

#include <stdio.h>
#include <errno.h>

#ifndef __OPTIMIZE__
# define __OPTIMIZE__
#endif

#define __USE_ISOC9X 1
#define __USE_ISOC99 1
#include <math.h>

#ifndef INT32
# define INT32 int
#endif

/*
 * on some systems errno is a macro ... check for it here
 */
#ifndef errno
 extern errno;
#endif

#if !defined (__win32__)
# include <locale.h>
#endif

#if defined (__aix__)
# include <float.h>
#endif

#if defined(__irix__)
# include <nan.h>
#endif

#if defined(__linux__)
# ifndef NAN
#  include <bits/nan.h>
# endif
#endif

#if defined(__solaris__) || defined(__sunos__)
# include <nan.h>
#endif

#ifdef __win32__
/*
 * no finite(x) ?
 * no isnan(x) ?
 */
# ifndef isnan
#  define isnan(x)      \
	((((unsigned int *)(&x))[0] == 0x00000000) && \
	 (((unsigned int *)(&x))[1] == 0xFFF80000))
# endif

# ifndef isPositiveInfinity
#  define isPositiveInfinity(x) \
	((((unsigned int *)(&x))[0] == 0x00000000) && \
	 (((unsigned int *)(&x))[1] == 0x7FF00000))
# endif

# ifndef isNegativeInfinity
#  define isNegativeInfinity(x) \
	((((unsigned int *)(&x))[0] == 0x00000000) && \
	 (((unsigned int *)(&x))[1] == 0xFFF00000))
# endif

# ifndef isinf
#  define isinf(x) \
	((((unsigned int *)(&x))[0] == 0x00000000) && \
	 ((((unsigned int *)(&x))[1] & 0x7FF00000) == 0x7FF00000))
# endif

# ifndef isfinite
#  define isfinite(x) (!isinf(x) && !isnan(x))
# endif

# ifndef isnanf
#  define isnanf(x)      \
	(((unsigned int *)(&x))[0] == 0xFFC00000)
# endif

# ifndef isPositiveInfinityf
#  define isPositiveInfinityf(x)      \
	(((unsigned int *)(&x))[0] == 0x7F800000)
# endif

# ifndef isNegativeInfinityf
#  define isNegativeInfinityf(x)      \
	(((unsigned int *)(&x))[0] == 0xFF800000)
# endif

# ifndef isinff
#  define isinff(x)      \
	((((unsigned int *)(&x))[0] & 0x7FFFFFFF) == 0x7F800000)
# endif

# ifndef isfinitef
#  define isfinitef(x) (!isinff(x) && !isnanf(x))
# endif

# define NO_ASINH
# define NO_ACOSH
# define NO_ATANH
# ifdef __BORLANDC__
#  define NO_FMODF
#  define NO_MODFF
# endif

# ifdef __MINGW__
#  include <string.h>
# endif

#endif /* __win32__ */

#ifdef __solaris__
# ifndef isfinite
#  define isfinite(f) finite((double)(f))
# endif
#endif

#ifdef __realIX__
# ifndef isfinite
#  define isfinite(x)     1
# endif
#endif /* realIX */

#ifndef isfinitef
# define isfinitef(x) isfinite(x)
#endif
#ifndef isnanf
# define isnanf(x) isnan(x)
#endif

%}
! !

!ShortFloat class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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
    ShortFloats represent rational numbers with limited precision.
    They use the C-compilers 'float' format, which is usually the IEEE single float format.

    In contrast to Floats (which use the C-compilers 64bit 'double' format),
    ShortFloats give you 32 bit floats.

    Notice, that ST/X Floats are what Doubles are in ST-80 and ShortFloats are
    ST-80's Floats respectively. The reason was to make ST/X's floats compatible
    to bothe visualWorks and other smalltalks, which use C-doubles for the Float class.
    Thus, STX's Float precision is not worse than that of other ST's.

    WARNING:
	The layout of shortFloat instances is known by the runtime system and the compiler;
	you may not add instance variables here.
	Also, subclassing is complicated by the fact, that the VM creates floats/shortFloats,
	and does some of its float-checks by an identity compare with the ShortFloat-class.
	(i.e. your subclasses instances may not be recognized as float-like objects,
	 thus mixed mode arithmetic will always coerce them, effectively slowing things down).
	This may be changed, to use a flag bit in the class.

    Mixed mode arithmetic:
	shortFloat op shortFloat   -> shortFloat
	shortFloat op fix         -> shortFloat
	shortFloat op fraction    -> shortFloat
	shortFloat op integer     -> shortFloat
	shortFloat op longFloat   -> longFloat
	shortFloat op float       -> float
	shortFloat op complex     -> complex

    Representation:
	    32bit single precision IEEE floats
	    23 bit mantissa,
	    8 bit exponent,
	    6 decimal digits (approx)

    Range and Precision of Storage Formats: see LimitedPrecisionReal >> documentation

    [author:]
	Claus Gittinger

    [see also:]
	Number
	Float LongFloat Fraction FixedPoint Integer Complex
	FloatArray DoubleArray
"
! !

!ShortFloat class methodsFor:'instance creation'!

basicNew
    "return a new shortFloat - here we return 0.0
     - shortFloats are usually NOT created this way ...
     Its implemented here to allow things like binary store & load
     of shortFloats. (but even this support will go away eventually, its not
     a good idea to store the bits of a float - the reader might have a
     totally different representation - so floats will eventually be
     binary stored in a device independent format."

%{  /* NOCONTEXT */
    OBJ newFloat;

    __qMKSFLOAT(newFloat, 0.0);
    RETURN (newFloat);
%}
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asShortFloat.
!

fastFromString:aString at:startIndex
    "return the next ShortFloat from the string starting at startIndex.
     No spaces are skipped.

     This is a specially tuned entry (using a low-level C-call), which
     returns garbage if the argument string is not a valid float number.
     It has been added to allow higher speed string decomposition into numbers,
     especially for mass-data."

%{   /* NOCONTEXT */
     if (__isStringLike(aString) && __isSmallInteger(startIndex)) {
	char *cp = (char *)(__stringVal(aString));
	int idx = __intVal(startIndex) - 1;
	double atof();
	double val;

	if ((unsigned)idx < __stringSize(aString)) {
	    val = atof(cp + idx);
	    RETURN (__MKSFLOAT(val));
	}
     }
%}.
     self primitiveFailed.

    "
     ShortFloat fastFromString:'123.45' at:1
     ShortFloat fastFromString:'123.45' at:2
     ShortFloat fastFromString:'123.45E4' at:1
     ShortFloat fastFromString:'hello123.45E4' at:6
     ShortFloat fastFromString:'12345' at:1
     ShortFloat fastFromString:'12345' at:2
     ShortFloat fastFromString:'12345' at:3
     ShortFloat fastFromString:'12345' at:4
     ShortFloat fastFromString:'12345' at:5
     ShortFloat fastFromString:'12345' at:6
     ShortFloat fastFromString:'12345' at:0
     ShortFloat fastFromString:'hello123.45E4' at:1

     Time millisecondsToRun:[
	100000 timesRepeat:[
	    ShortFloat readFrom:'123.45'
	]
     ]
    "

    "
     Time millisecondsToRun:[
	100000 timesRepeat:[
	    ShortFloat fastFromString:'123.45' at:1
	]
     ]
    "
!

fromIEEE32Bit: anInteger
    "creates a float, given the four native float bytes as an integer"

%{  /* NOCONTEXT */

    REGISTER union {
	unsigned int    i;
	float           f;
    } r;

    r.i = __unsignedLongIntVal( anInteger );
    RETURN( __MKSFLOAT(r.f) );
%}

    "
	ShortFloat fromIEEE32Bit:(#[64 73 15 219] asInteger)
    "
!

fromNumber:aNumber
    ^aNumber asShortFloat
! !

!ShortFloat class methodsFor:'accessing'!

defaultPrintFormat
    ^ DefaultPrintFormat
!

defaultPrintFormat:aString
    DefaultPrintFormat := aString.
!

epsilon
    Epsilon isNil ifTrue:[
	Epsilon := self computeEpsilon.
    ].
    ^ Epsilon
! !

!ShortFloat class methodsFor:'binary storage'!

readBinaryIEEESingleFrom:aStream
    "read a float value from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 4-byte float.
     The bytes are read in the native byte order (i.e.lsb on intel)"

    |f|

    f := ShortFloat basicNew.
    self readBinaryIEEESingleFrom:aStream into:f MSB:(UninterpretedBytes isBigEndian).
    ^ f

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Created: / 16-04-1996 / 21:00:35 / cg"
    "Modified: / 23-08-2006 / 16:01:47 / cg"
!

readBinaryIEEESingleFrom:aStream MSB:msbFirst
    "read a float value from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 4-byte float.
     The bytes are read in the soecified byte order"

    |f|

    f := ShortFloat basicNew.
    self readBinaryIEEESingleFrom:aStream into:f MSB:msbFirst.
    ^ f

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Created: / 16-04-1996 / 21:00:35 / cg"
    "Modified: / 23-08-2006 / 16:01:47 / cg"
!

readBinaryIEEESingleFrom:aStream into:aBasicNewShortFloat
    "read a float value from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 4-byte float.
     The bytes are read in the native byte order (i.e.lsb on intel)"

    ^ self readBinaryIEEESingleFrom:aStream into:aBasicNewShortFloat MSB:(UninterpretedBytes isBigEndian)

    "Modified: / 23-08-2006 / 16:01:52 / cg"
!

readBinaryIEEESingleFrom:aStream into:aBasicNewShortFloat MSB:msb
    "read a float value from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 4-byte float.
     If msb is true, the stream bytes are most-significant-first."

    aBasicNewShortFloat class == self ifFalse:[self error:'no a ShortFloat'].

    "
     this implementation is wrong: does not work on non-IEEE machines
     (to date all machines where ST/X is running on use
      IEEE float format. Need more here, when porting ST/X to 370's)
    "
    self isIEEEFormat ifFalse:[self error:'unsupported operation'].

    (UninterpretedBytes isBigEndian == msb) ifFalse:[
	"swap the bytes"
	4 to:1 by:-1 do:[:i |
	    aBasicNewShortFloat basicAt:i put:(aStream next)
	].
	^ self
    ].
    1 to:4 do:[:i |
	aBasicNewShortFloat basicAt:i put:aStream next
    ]

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Modified: / 23-08-2006 / 16:01:52 / cg"
!

storeBinaryIEEESingle:aFloat on:aStream
    "store aFloat as an IEEE formatted 4-byte float
     onto the binary stream, aStream.
     The bytes are written in the native byte order (i.e.lsb on intel)"

    self storeBinaryIEEESingle:aFloat on:aStream MSB:(UninterpretedBytes isBigEndian).
!

storeBinaryIEEESingle:aFloat on:aStream MSB:msb
    "store aFloat as an IEEE formatted 4-byte float
     onto the binary stream, aStream.
     If msb is true, the stream bytes are written most-significant-first."

    |float|

    float := aFloat asShortFloat.

    "
     this implementation is wrong: does not work on non-IEEE machines
     (to date all machines where ST/X is running on use
      IEEE float format. Need more here, when porting ST/X to 370's)
    "
    self isIEEEFormat ifFalse:[self error:'unsupported operation'].

    (UninterpretedBytes isBigEndian == msb) ifFalse:[
	"swap the bytes"
	4 to:1 by:-1 do:[:i |
	    aStream nextPut:(float basicAt:i).
	].
	^ self
    ].
    1 to:4 do:[:i |
	aStream nextPut:(float basicAt:i).
    ]

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Modified: / 23-08-2006 / 16:01:55 / cg"
! !

!ShortFloat class methodsFor:'class initialization'!

initialize
    DefaultPrintFormat := '.7'.  "/ print 7 valid digits

    "
     self initialize
    "
! !

!ShortFloat class methodsFor:'constants'!

e
    "return the constant e as ShortFloat"

    E isNil ifTrue:[
	E := Float e asShortFloat
    ].
    ^ E
!

emax
    "Answer the maximum exponent for this representation."

    ^127
!

emin
    "Answer the minimum exponent for this representation."

    ^-126
!

pi
    "return the constant pi as ShortFloat"

    Pi isNil ifTrue:[
	Pi := Float pi asShortFloat
    ].
    ^ Pi
!

unity
    "return the neutral element for multiplication (1.0) as ShortFloat"

    ^ 1.0 asShortFloat

    "Modified: 23.4.1996 / 09:26:51 / cg"
!

zero
    "return the neutral element for addition (0.0) as ShortFloat"

    ^ 0.0 asShortFloat

    "Modified: 23.4.1996 / 09:26:45 / cg"
! !


!ShortFloat class methodsFor:'queries'!

exponentCharacter
    ^ $e
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == ShortFloat

    "Modified: 23.4.1996 / 16:00:23 / cg"
!

numBitsInExponent
    "answer the number of bits in the exponent
     This is an IEEE float, where 8 bits are available:
	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    "

    ^ 8
!

numBitsInMantissa
    "answer the number of bits in the mantissa.
     This is an IEEE float, where 23 bits (the hidden one is not counted here) are available:
	seeeeeee emmmmmmm mmmmmmmm mmmmmmmm
    "

    ^ 23
!

precision
    "answer the precision of a ShortFloat (in bits)
     This is an IEEE float, where only the fraction from the normalized mantissa is stored
     and so there is a hidden bit and the mantissa is actually represented by 24 binary digits
     (although only 23 are needed in the binary representation)"

    ^  24

    "
     self numBitsInMantissa + 1
     self precision
    "
!

radix
    "answer the radix of a ShortFloats exponent
     This is an IEEE float, which is represented as binary"

    ^ 2 "must be careful here, whenever ST/X is used on a VAX or a 370"
! !

!ShortFloat methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument."

%{  /* NOCONTEXT */

    OBJ newFloat;
    float result;
    double dResult;

    if (__isSmallInteger(aNumber)) {
	result = __shortFloatVal(self) * (float)(__intVal(aNumber));
retResult:
	__qMKSFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (__isShortFloat(aNumber)) {
	result = __shortFloatVal(self) * __shortFloatVal(aNumber);
	goto retResult;
    }
    if (__isFloatLike(aNumber)) {
	dResult = (double) __shortFloatVal(self)* __floatVal(aNumber);
	__qMKFLOAT(newFloat, dResult);
	RETURN ( newFloat );
    }
%}.
    ^ aNumber productFromShortFloat:self
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    OBJ newFloat;
    float result;
    double dResult;

    if (__isSmallInteger(aNumber)) {
	result = __shortFloatVal(self) + (float)(__intVal(aNumber));
retResult:
	__qMKSFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (__isShortFloat(aNumber)) {
	result = __shortFloatVal(self) + __shortFloatVal(aNumber);
	goto retResult;
    }
    if (__isFloatLike(aNumber)) {
	dResult = (double) __shortFloatVal(self) + __floatVal(aNumber);
	__qMKFLOAT(newFloat, dResult);
	RETURN ( newFloat );
    }
%}.
    ^ aNumber sumFromShortFloat:self
!

- aNumber
    "return the difference of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    OBJ newFloat;
    float result;
    double dResult;

    if (__isSmallInteger(aNumber)) {
	result = __shortFloatVal(self) - (float)(__intVal(aNumber));
retResult:
	__qMKSFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (__isShortFloat(aNumber)) {
	result = __shortFloatVal(self) - __shortFloatVal(aNumber);
	goto retResult;
    }
    if (__isFloatLike(aNumber)) {
	dResult = (double) __shortFloatVal(self) - __floatVal(aNumber);
	__qMKFLOAT(newFloat, dResult);
	RETURN ( newFloat );
    }
%}.
    ^ aNumber differenceFromShortFloat:self
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    OBJ newFloat;
    float result, val;
    double dResult, dVal;

    if (__isSmallInteger(aNumber)) {
	if (aNumber != __mkSmallInteger(0)) {
	    result = __shortFloatVal(self) / (float)(__intVal(aNumber));
retResult:
	    __qMKSFLOAT(newFloat, result);
	    RETURN ( newFloat );
	}
    }
    if (__isShortFloat(aNumber)) {
	val = __shortFloatVal(aNumber);
	if (val != 0.0) {
	    result = __shortFloatVal(self) / val;
	    goto retResult;
	}
    }
    if (__isFloatLike(aNumber)) {
	dVal = __floatVal(aNumber);
	if (dVal != 0.0) {
	    dResult = (double) __shortFloatVal(self) / dVal;
	    __qMKFLOAT(newFloat, dResult);
	    RETURN ( newFloat );
	}
    }
%}.
    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
	"
	 No, you shalt not divide by zero
	"
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber quotientFromShortFloat:self
!

abs
    "return the absolute value of the receiver
     reimplemented here for speed"

%{  /* NOCONTEXT */

    OBJ newFloat;
    float val = __shortFloatVal(self);

    if (val < 0.0) {
	__qMKSFLOAT(newFloat, -val);
	RETURN ( newFloat );
    }
    RETURN (self);
%}.

    "
     3.0 asShortFloat abs
     -3.0 asShortFloat abs
    "
!

negated
    "return myself negated"

%{  /* NOCONTEXT */
    OBJ newFloat;
    float rslt = - __shortFloatVal(self);

    __qMKSFLOAT(newFloat, rslt);
    RETURN ( newFloat );
%}.
    ^ 0.0 - self

!

rem: aNumber
    "return the floating point remainder of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */
    OBJ newFloat;
    float result, val;
    double dResult, dVal;

    if (__isSmallInteger(aNumber)) {
	if (aNumber != __mkSmallInteger(0)) {
	    val = (float)__intVal(aNumber);
computeResult:
#ifdef NO_FMODF
	    dResult = fmod((double)__shortFloatVal(self), (double)val) ;
	    result = (float)dResult;
#else
	    result = fmodf(__shortFloatVal(self), val) ;
#endif
	    __qMKSFLOAT(newFloat, result);
	    RETURN ( newFloat );
	}
    } else if (__isFloatLike(aNumber)) {
	dVal = __floatVal(aNumber);
	if (dVal != 0.0) {
	    dResult = fmod((double)(__shortFloatVal(self)), dVal) ;
	    __qMKFLOAT(newFloat, dResult);
	    RETURN ( newFloat );
	}
    } else if (__isShortFloat(aNumber)) {
	val = __shortFloatVal(aNumber);
	if (val != 0.0) {
	    goto computeResult;
	}
    }
%}.
    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
	"
	 No, you shalt not divide by zero
	"
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber remainderFromShortFloat:self
!

uncheckedDivide:aNumber
    "return the quotient of the receiver and the argument, aNumber.
     Do not check for divide by zero (return NaN or Infinity).
     This operation is provided for emulators of other languages/semantics,
     where no exception is raised for these results (i.e. Java).
     It is only defined if the argument's type is the same as the receiver's."

%{  /* NOCONTEXT */

    OBJ newFloat;
    float result, val;
    double dResult, dVal;

    if (__isSmallInteger(aNumber)) {
	result = __shortFloatVal(self) / (float)(__intVal(aNumber));
retResult:
	__qMKSFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (__isShortFloat(aNumber)) {
	val = __shortFloatVal(aNumber);
	result = __shortFloatVal(self) / val;
	goto retResult;
    }
    if (__isFloatLike(aNumber)) {
	dVal = __floatVal(aNumber);
	dResult = (double) __shortFloatVal(self) / dVal;
	__qMKFLOAT(newFloat, dResult);
	RETURN ( newFloat );
    }
%}.
    ^ aNumber quotientFromShortFloat:self

    "
      0.0 asShortFloat uncheckedDivide:0
      1.0 asShortFloat uncheckedDivide:0.0
    "
! !

!ShortFloat methodsFor:'coercing & converting'!

asFloat
    "return a Float with same value as the receiver.
     Redefined for performance (machine can do it faster)"

%{  /* NOCONTEXT */

    OBJ newFloat;
    double dVal = (double)__shortFloatVal(self);

    __qMKFLOAT(newFloat, dVal);
    RETURN ( newFloat );
%}

    "
     1.0 asShortFloat asFloat
    "
!

asInteger
    "return an integer with same value - might truncate"

%{  /* NOCONTEXT */
    float fVal;

    fVal = __shortFloatVal(self);
#ifdef __win32__
    if (! isnanf(fVal))
#endif
    {
	if ((fVal >= (float)_MIN_INT) && (fVal <= (float)_MAX_INT)) {
	    RETURN ( __mkSmallInteger( (INT)fVal) );
	}
    }
%}.
    ^ super asInteger

    "
     12345.0 asShortFloat asInteger
     1e15 asShortFloat asInteger
    "
!

asLongFloat
    ^ LongFloat fromShortFloat:self
!

asShortFloat
    "return a ShortFloat with same value as the receiver - that's me"

    ^ self
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asShortFloat
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 70


! !

!ShortFloat methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__shortFloatVal(self) < (float)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (double)(__shortFloatVal(self) < __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__shortFloatVal(self) < __shortFloatVal(aNumber)) ? true : false );
	}
    }
%}.
    ^ aNumber lessFromShortFloat:self

    "
     1.0 asShortFloat > (1/3)
    "
!

<= aNumber
    "return true, if the argument is greater or equal"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__shortFloatVal(self) <= (float)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (double)(__shortFloatVal(self) <= __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__shortFloatVal(self) <= __shortFloatVal(aNumber)) ? true : false );
	}
    }
%}.
    ^ self retry:#<= coercing:aNumber
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__shortFloatVal(self) == (float)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber == nil) {
	RETURN (false);
    }
    if (__qIsFloatLike(aNumber)) {
	RETURN ( (double)(__shortFloatVal(self) == __floatVal(aNumber)) ? true : false );
    }
    if (__qIsShortFloat(aNumber)) {
	RETURN ( (__shortFloatVal(self) == __shortFloatVal(aNumber)) ? true : false );
    }
%}.
    ^ aNumber equalFromShortFloat:self
!

> aNumber
    "return true, if the argument is less"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__shortFloatVal(self) > (float)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (double)(__shortFloatVal(self) > __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__shortFloatVal(self) > __shortFloatVal(aNumber)) ? true : false );
	}
    }
%}.
    ^ self retry:#> coercing:aNumber
!

>= aNumber
    "return true, if the argument is less or equal"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__shortFloatVal(self) >= (float)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (double)(__shortFloatVal(self) >= __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__shortFloatVal(self) >= __shortFloatVal(aNumber)) ? true : false );
	}
    }
%}.
    ^ self retry:#>= coercing:aNumber
!

hash
    "return a number for hashing; redefined, since floats compare
     by numeric value (i.e. 3.0 = 3), therefore 3.0 hash must be the same
     as 3 hash."

    |i|

    (self >= SmallInteger minVal and:[self <= SmallInteger maxVal]) ifTrue:[
	i := self asInteger.
	self = i ifTrue:[
	    ^ i hash
	].
    ].

    ^ self asFloat hash

    "
     1.2345 hash
     1.2345 asShortFloat hash
     1.0 hash
     1.0 asShortFloat hash
     0.5 asShortFloat hash
     0.25 asShortFloat hash
     0.5 hash
     0.25 hash
    "
!

isAlmostEqualTo:aNumber nEpsilon:nE
    "return true, if the argument, aNumber represents almost the same numeric value
     as the receiver, false otherwise.

     nE is the number of minimal float distances, that the numbers may differ and
     still be considered equal.

     For background information why floats need this
     read: http://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/
    "

    Epsilon isNil ifTrue:[
        Epsilon := self class computeEpsilon.
    ].

%{  /* NOCONTEXT */

    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */

    INT32 ulpDiff;
    union {
        float f;
        INT32 i;
    } myself, otherFloat;
    int nEpsilon;
    float scaledEpsilon;

    if (!__isSmallInteger(nE)) {
        goto tryHarder;
    }

    nEpsilon =  __intVal(nE);
    scaledEpsilon = nEpsilon *__shortFloatVal(@global(Epsilon));

    if (__isSmallInteger(aNumber)) {
        otherFloat.f = (float)(__intVal(aNumber));
    } else if (aNumber == nil) {
        RETURN(false)
    } else if (__qIsFloatLike(aNumber)) {
        otherFloat.f = (float)(__floatVal(aNumber));
    } else if (__qIsShortFloat(aNumber)) {
        otherFloat.f = (double)(__shortFloatVal(aNumber));
    } else {
        goto tryHarder;
    }

    myself.f = __shortFloatVal(self);

    // Check if the numbers are really close -- needed
    // when comparing numbers near zero (ULP method below fails for numbers near 0!).
    if (fabs(myself.f - otherFloat.f) <= scaledEpsilon) {
        RETURN(true);
    }

    // if the signs differ, the numbers are different
    if ((myself.f >= 0) != (otherFloat.f >= 0)) {
        RETURN(false);
    }

    // compute the difference of the 'units in the last place" ULP
    // (if ulpDiff == 1, two floats are adjecant)
    ulpDiff = myself.i - otherFloat.i;
    if (ulpDiff < 0) ulpDiff = -ulpDiff;
    if (ulpDiff <= nEpsilon) {
        RETURN(true);
    } else {
        RETURN(false)
    }

tryHarder:;
%}.
    ^ aNumber isAlmostEqualToFromShortFloat:self nEpsilon:nE

    "
        67329.234 asShortFloat isAlmostEqualTo:67329.23400000001 nEpsilon:1
        1.0 asShortFloat isAlmostEqualTo:1.0001 nEpsilon:1
        1.0 asShortFloat isAlmostEqualTo:-1.0 nEpsilon:1
        1.0 asShortFloat isAlmostEqualTo:1 nEpsilon:1
    "
!

~= aNumber
    "return true, if the arguments value are not equal"

%{  /* NOCONTEXT */

    if (aNumber != nil) {
	if (__isSmallInteger(aNumber)) {
	    RETURN ( (__shortFloatVal(self) != (float)(__intVal(aNumber))) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (double)(__shortFloatVal(self) !=  __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__shortFloatVal(self) !=  __shortFloatVal(aNumber)) ? true : false );
	}
    } else {
	RETURN ( true );
    }
%}.
    ^ super ~= aNumber
! !

!ShortFloat methodsFor:'mathematical functions'!

fastInverseSqrt
    "return a rough but fast approximation of (1 / self sqrt).
     The error is some 1%, which is ok for many 3D computations or physics simulations.
     Do not use this for now: it is non-portable and probably not speeding things up
     much, unless inlined into the sender code.
     The code is here as a reminder and might be later used as a hint for the inliner
     (to speed up 3D computations, for example).
     see: http://betterexplained.com/articles/understanding-quakes-fast-inverse-square-root/"

%{  /* NOCONTEXT */
    float x, rslt;
    OBJ newFloat;

    if (sizeof(float) == 4) {
	x = __shortFloatVal(self);
	{
	    float xhalf = 0.5f * x;
	    int i = *(int*)&x; // store floating-point bits in integer

	    i = 0x5f3759d5 - (i >> 1); // initial guess for Newton's method
	    x = *(float*)&i; // convert new bits into float
	    x = x*(1.5f - xhalf*x*x); // One round of Newton's method
	    __qMKSFLOAT(newFloat, x);
	    RETURN ( newFloat );
	}
    }
%}.
    ^ 1 / self sqrt

    "
     10.0 asShortFloat fastInverseSqrt
     (1 / 10.0 asShortFloat sqrt)
    "

    "
     |a b t0 t1 t2|

     a := 345 asShortFloat.
     t0 := Time millisecondsToRun:[
	1000000 timesRepeat:[
	]
     ].
     t1 := Time millisecondsToRun:[
	1000000 timesRepeat:[
	    a fastInverseSqrt
	]
     ].
     t2 := Time millisecondsToRun:[
	1000000 timesRepeat:[
	    (1 / a sqrt)
	]
     ].
     Transcript show:'empty: '; showCR:t0.
     Transcript show:'fast: '; showCR:t1.
     Transcript show:'regular: '; showCR:t2.
    "
! !

!ShortFloat methodsFor:'printing & storing'!

printString
    "return a printed representation of the receiver
     LimitedPrecisonReal and its subclasses use #printString instead of
     #printOn: as basic print mechanism."

    ^ self printStringWithFormat:DefaultPrintFormat

    "
	1.234 asShortFloat printString.
	1.0 asShortFloat printString.
	1e10 asShortFloat printString.
	1.2e3 asShortFloat printString.
	1.2e30 asShortFloat printString.
	(1.0 uncheckedDivide:0) asShortFloat printString.
	(0.0 uncheckedDivide:0) asShortFloat printString.
	self pi printString.

	self pi printString.
	DefaultPrintFormat := '.3'.
	self pi printString.
	DefaultPrintFormat := '.7'.

	DecimalPointCharacterForPrinting := $,.
	1.234 asShortFloat printString.
	1.0 asShortFloat printString.
	1e10 asShortFloat printString.
	1.2e3 asShortFloat printString.
	1.2e30 asShortFloat printString.
	(1.0 uncheckedDivide:0) asShortFloat printString.
	(0.0 uncheckedDivide:0) asShortFloat printString.
	DecimalPointCharacterForPrinting := $.
    "
!

printStringWithFormat:format
    "return a printed representation of the receiver;
     fmt must be of the form: .nn, where nn is the number of digits.
     To print 6 valid digits, use printStringWithFormat:'.6'
     For Floats, the default used in printString, is 15 (because its a double);
     for ShortFloats, it is 6 (because it is a float)"

%{  /* NOCONTEXT */

    char buffer[64];
    REGISTER char *cp;
    int len;
    OBJ s;
    char *fmt;
    char fmtBuffer[20];

    if (__isStringLike(format)) {
	fmt = (char *) __stringVal(format);
    } else {
	/*
	 * in case we get called with garbage...
	 */
	fmt = ".7";
    }

    /*
     * build a printf format string
     */
    fmtBuffer[0] = '%';
    strncpy(fmtBuffer+1, fmt, 10);
    strcat(fmtBuffer, "g");

    /*
     * actually only needed on sparc: since thisContext is
     * in a global register, which gets destroyed by printf,
     * manually save it here - very stupid ...
     */
    __BEGIN_PROTECT_REGISTERS__
    len = snprintf(buffer, sizeof(buffer), fmtBuffer, (float)__shortFloatVal(self));
    __END_PROTECT_REGISTERS__

    if (len >= 0 && len <= sizeof(buffer)-3) {
	/*
	 * kludge to make integral float f prints as "f.0" (not as "f" as printf does)
	 * (i.e. look if string contains '.' or 'e' and append '.0' if not)
	 */
	for (cp = buffer; *cp; cp++) {
	    if ((*cp == '.') || (*cp == ',') || (*cp == 'E') || (*cp == 'e')) break;
	}
	if (!*cp && (cp[-1] >= '0') && (cp[-1] <= '9')) {
	    if (__isCharacter(@global(DecimalPointCharacterForPrinting))) {
		*cp++ = __intVal(__characterVal(@global(DecimalPointCharacterForPrinting)));
	    } else {
		*cp++ = '.';
	    }
	    *cp++ = '0';
	    *cp = '\0';
	} else {
	    if (cp && (*cp == '.')) {
		if (__isCharacter(@global(DecimalPointCharacterForPrinting))) {
		    *cp = __intVal(__characterVal(@global(DecimalPointCharacterForPrinting)));
		}
	    }
	}

	s = __MKSTRING(buffer);
	if (s != nil) {
	    RETURN (s);
	}
    }
%}.
    ^ self asFloat printString

    "
	1.234 asShortFloat printString.
	ShortFloat pi printString.
	1.0 asShortFloat printString.
	1e10 asShortFloat printString.
	1.2e3 asShortFloat printString.
	1.2e30 asShortFloat printString.
	(1.0 uncheckedDivide:0) asShortFloat printString.
	(0.0 uncheckedDivide:0) asShortFloat printString.
	self pi printString.

	self pi printString.
	DefaultPrintFormat := '.3'.
	self pi printString.
	DefaultPrintFormat := '.7'.

	DecimalPointCharacterForPrinting := $,.
	1.234 asShortFloat printString.
	1.0 asShortFloat printString.
	1e10 asShortFloat printString.
	1.2e3 asShortFloat printString.
	1.2e30 asShortFloat printString.
	(1.0 uncheckedDivide:0) asShortFloat printString.
	(0.0 uncheckedDivide:0) asShortFloat printString.
	DecimalPointCharacterForPrinting := $.
    "
!

printfPrintString:formatString
    "non-standard: return a printed representation of the receiver
     as specified by formatString, which is defined by printf.
     If you use this, be aware, that specifying doubles differs on
     systems; on SYSV machines you have to give something like %lf,
     while on BSD systems the format string has to be %F.
     Also, the resulting string may not be longer than 255 bytes -
     since that's the (static) size of the buffer.
     This method is NONSTANDARD and may be removed without notice.
     WARNNG: this goes directly to the C-printf function and may therefore me inherently unsafe.
     Please use the printf: method, which is safe as it is completely implemented in Smalltalk."

%{  /* STACK: 400 */
    char buffer[256];
    OBJ s;
    int len;

    if (__isStringLike(formatString)) {
	/*
	 * actually only needed on sparc: since thisContext is
	 * in a global register, which gets destroyed by printf,
	 * manually save it here - very stupid ...
	 */
	__BEGIN_PROTECT_REGISTERS__

	len = snprintf(buffer, sizeof(buffer), __stringVal(formatString), __shortFloatVal(self));

	__END_PROTECT_REGISTERS__

	if (len < 0) goto fail;

	s = __MKSTRING_L(buffer, len);
	if (s != nil) {
	    RETURN (s);
	}
    }
fail: ;
%}.
    self primitiveFailed

    "ShortFloat pi printfPrintString:'%%lg -> %lg'"
    "ShortFloat pi printfPrintString:'%%lf -> %lf'"
    "ShortFloat pi printfPrintString:'%%7.5lg -> %7.5lg'"
    "ShortFloat pi printfPrintString:'%%G -> %G'"
    "ShortFloat pi printfPrintString:'%%F -> %F'"
    "ShortFloat pi printfPrintString:'%%7.5G -> %7.5G'"
    "ShortFloat pi printfPrintString:'%%7.5F -> %7.5F'"
!

storeString
    "return a printed representation of the receiver;
     all valid digits are printed.
     LimitedPrecisonReal and its subclasses use #storeString instead of
     #storeOn: as basic print mechanism."

%{  /* NOCONTEXT */

    char buffer[64];
    REGISTER char *cp;
    OBJ s;
    int len;

    /*
     * build a printf format string
     */

    __BEGIN_PROTECT_REGISTERS__
    len = snprintf(buffer, sizeof(buffer), "%.8g", (float)__shortFloatVal(self));
    __END_PROTECT_REGISTERS__

    if (len >= 0 && len < sizeof(buffer)-3) {
	/*
	 * kludge to make integral float f prints as "f.0" (not as "f" as printf does)
	 * (i.e. look if string contains '.' or 'e' and append '.0' if not)
	 */
	for (cp = buffer; *cp; cp++) {
	    if ((*cp == '.') || (*cp == ',') || (*cp == 'E') || (*cp == 'e')) break;
	}
	if (!*cp && (cp[-1] >= '0') && (cp[-1] <= '9')) {
	    *cp++ = '.';
	    *cp++ = '0';
	    *cp = '\0';
	}

	s = __MKSTRING(buffer);
	if (s != nil) {
	    RETURN (s);
	}
    }
%}.
    "
     memory allocation (for the new string) failed.
     When we arrive here, there was no memory, even after a garbage collect.
     This means, that the VM wanted to get some more memory from the
     OS, which was not kind enough to give it.
     Bad luck - you should increase the swap space on your machine.
    "
    ^ AllocationFailure raise.

    "
	0.1 asShortFloat storeString
	((Array new:10 withAll:0.1 asShortFloat) inject:0 into:[:v :sumSoFar| sumSoFar + v]) storeString
	1.0 asShortFloat storeString
	1.234 asShortFloat storeString
	1e10 asShortFloat storeString
	1.2e3 asShortFloat storeString
	1.2e30 asShortFloat storeString
	Float pi asShortFloat storeString
	(1.0 uncheckedDivide:0) asShortFloat storeString
	(0.0 uncheckedDivide:0) asShortFloat storeString

     notice that the storeString is NOT affected by DecimalPointCharacterForPrinting:

	DecimalPointCharacterForPrinting := $,.
	1.234 asShortFloat storeString.
	1.0 asShortFloat storeString.
	1e10 asShortFloat storeString.
	1.2e3 asShortFloat storeString.
	1.2e30 asShortFloat storeString.
	(1.0 uncheckedDivide:0) asShortFloat storeString.
	(0.0 uncheckedDivide:0) asShortFloat storeString.
	DecimalPointCharacterForPrinting := $.
    "
! !

!ShortFloat methodsFor:'private accessing'!

basicAt:index
    "return an internal byte of the float.
     The value returned here depends on byte order, float representation etc.
     Therefore, this method should be used strictly private.

     Notice:
	the need to redefine this method here is due to the
	inability of many machines to store floats in non-double aligned memory.
	Therefore, on some machines, the first 4 bytes of a float are left unused,
	and the actual float is stored at index 5 .. 12.
	To hide this at one place, this method knows about that, and returns
	values as if this filler wasnt present."

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned char *cp;

    /*
     * notice the missing test for self being a nonNilObject -
     * this can be done since basicAt: is defined both in UndefinedObject
     * and SmallInteger
     */
    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	if (((unsigned INT)(indx)) < sizeof(float)) {
	    cp = (unsigned char *)(& (__ShortFloatInstPtr(self)->f_floatvalue));
	    RETURN ( __mkSmallInteger(cp[indx] & 0xFF) );
	}
    }
%}.
    ^ self indexNotIntegerOrOutOfBounds:index
!

basicAt:index put:value
    "set an internal byte of the float.
     The value to be stored here depends on byte order, float representation etc.
     Therefore, this method should be used strictly private.

     Notice:
	the need to redefine this method here is due to the
	inability of many machines to store floats in non-double aligned memory.
	Therefore, on some machines, the first 4 bytes of a float are left unused,
	and the actual float is stored at index 5 .. 12.
	To hide this at one place, this method knows about that, and returns
	values as if this filler wasnt present."

%{  /* NOCONTEXT */
    REGISTER INT indx, val;
    unsigned char *cp;

    /*
     * notice the missing test for self being a nonNilObject -
     * this can be done since basicAt: is defined both in UndefinedObject
     * and SmallInteger
     */
    if (__bothSmallInteger(index, value)) {
	val = __intVal(value);
	if ((val & ~0xFF) == 0 /* i.e. (val >= 0) && (val <= 255) */) {
	    indx = __intVal(index) - 1;
	    if (((unsigned INT)(indx)) < sizeof(float)) {
		cp = (unsigned char *)(& (__ShortFloatInstPtr(self)->f_floatvalue));
		cp[indx] = val;
		RETURN ( value );
	    }
	}
    }
%}.
    value isInteger ifFalse:[
	"
	 the object to store should be an integer number
	"
	^ self elementNotInteger
    ].
    (value between:0 and:255) ifFalse:[
	"
	 the object to store must be a bytes value
	"
	^ self elementBoundsError:value
    ].
    ^ self indexNotIntegerOrOutOfBounds:index
! !

!ShortFloat methodsFor:'queries'!

nextFloat:count
    "answer the next float count places after (or before if count is negative) myself"

%{
    union u {
	float d;
	INT32 i;
    } this;

    if (__isSmallInteger(count)) {
	this.d = __shortFloatVal(self);
	if (isfinite(this.d))
	    this.i += __intVal(count);

	RETURN(__MKSFLOAT(this.d));
    }
%}.
    self primitiveFailed:#badArgument

  "
     (1.0 asShortFloat nextFloat:2) storeString
     (67329.234 asShortFloat nextFloat:1) storeString
     ShortFloat NaN nextFloat:100000
     ShortFloat infinity nextFloat:100000
  "
! !

!ShortFloat methodsFor:'special access'!

exponent
    "extract a normalized floats exponent.
     The returned value depends on the float-representation of
     the underlying machine and is therefore highly unportable.
     This is not for general use.
     This assumes that the mantissa is normalized to
     0.5 .. 1.0 and the floats value is mantissa * 2^exp"

%{  /* NOCONTEXT */
    int exp;

#if defined(__i386__) && defined(__GNUC__)
    frexpf( __shortFloatVal(self), &exp);
#else
    frexp( (double)(__shortFloatVal(self)), &exp);
#endif
    RETURN (__mkSmallInteger(exp));
%}.

    "
     4.0 asShortFloat exponent
     2.0 asShortFloat exponent
     1.0 asShortFloat exponent
     0.5 asShortFloat exponent
     0.25 asShortFloat exponent
     0.00000011111 asShortFloat exponent
    "
!

mantissa
    "extract a normalized floats mantissa.
     The returned value depends on the float-representation of
     the underlying machine and is therefore highly unportable.
     This is not for general use.
     This assumes that the mantissa is normalized to
     0.5 .. 1.0 and the floats value is mantissa * 2^exp"

%{  /* NOCONTEXT */
    int exp;

#if defined(__i386__) && defined(__GNUC__)
    float frac = frexpf(__shortFloatVal(self), &exp);
    RETURN (__MKSFLOAT(frac));
#else
    double frac = frexp( (double)(__shortFloatVal(self)), &exp);
    RETURN (__MKFLOAT(frac));
#endif
%}.
    ^ super mantissa

    "
     1.0 asShortFloat exponent
     1.0 asShortFloat mantissa

     0.5 asShortFloat exponent
     0.5 asShortFloat mantissa

     0.25 asShortFloat exponent
     0.25 asShortFloat mantissa

     0.00000011111 asShortFloat exponent
     0.00000011111 asShortFloat mantissa
    "
! !

!ShortFloat methodsFor:'testing'!

isFinite
    "return true, if the receiver is a finite float
     i.e. not NaN and not infinite."

%{  /* NOCONTEXT */
    float fV = __shortFloatVal(self);

    /*
     * notice: on machines which do not provide
     * a isfinite() macro or function (WIN32),
     * this may always ret true here ...
     */
    if (isfinitef(fV)) { RETURN (true); }
%}.
    ^ false

    "
	1.0 asShortFloat isFinite
	(0.0 asShortFloat uncheckedDivide: 0.0) isFinite
	(1.0 asShortFloat uncheckedDivide: 0.0) isFinite
    "
!

isNaN
    "return true, if the receiver is an invalid float (NaN - not a number).
     These are not created by ST/X float operations (they raise an exception);
     however, inline C-code could produce them ..."

%{  /* NOCONTEXT */
    float sV = __shortFloatVal(self);

    /*
     * notice: on machines which do not provide
     * a isnan() macro or function (WIN32),
     * this may always ret false here ...
     */
    if (isnanf(sV)) { RETURN (true); }
%}.
    ^ false

    "
     1.0 asShortFloat isNaN
     (0.0 asShortFloat uncheckedDivide: 0.0) isNaN
     (0.0 asShortFloat uncheckedDivide: 0.0 asShortFloat) isNaN
    "
!

isNegativeZero
    "many systems have two float.Pnt zeros"

%{ /* NOCONTEXT */
#if defined(__BORLANDC__)
    union { float f; int i; } __u;
   __u.f = __shortFloatVal(self);
    RETURN ( (__u.f == 0.0 && __u.i < 0) ? true : false );
#else
    RETURN ( (__shortFloatVal(self) == 0.0 && signbit(__shortFloatVal(self)) != 0) ? true : false );
#endif
%}.

    "
     0.0 asShortFloat isNegativeZero
     -0.0 asShortFloat isNegativeZero
    "
!

negative
    "return true if the receiver is less than zero.
     -0.0 is positive for now."

%{  /* NOCONTEXT */

    RETURN ( __shortFloatVal(self) < 0.0  ? true : false );
    // RETURN ( signbit(__shortFloatVal(self)) != 0  ? true : false );
%}.

    "
	0.0 asShortFloat negative
	-0.0 asShortFloat negative
	1.0 asShortFloat negative
	-1.0 asShortFloat negative
	(1.0 uncheckedDivide: 0.0) asShortFloat negative
	(-1.0 uncheckedDivide: 0.0) asShortFloat negative
    "
!

numberOfBits
    "return the size (in bits) of the real;
     typically, 32 is returned here,
     but who knows ..."

%{  /* NOCONTEXT */

    RETURN (__mkSmallInteger (sizeof(float) * 8));
%}

    "
     1.2 numberOfBits
     1.2 asShortFloat numberOfBits
    "

!

positive
    "return true if the receiver is greater or equal to zero (not negative)
     0.0 and -0.0 are positive for now."

%{  /* NOCONTEXT */

    RETURN ( __shortFloatVal(self) >= 0.0 ? true : false );
//    RETURN ( (signbit(__shortFloatVal(self)) == 0 ? true : false ) );
%}.

    "
	0.0 asShortFloat positive
	-0.0 asShortFloat positive
	1.0 asShortFloat positive
	-1.0 asShortFloat positive
	(1.0 uncheckedDivide: 0.0) asShortFloat positive
	(-1.0 uncheckedDivide: 0.0) asShortFloat positive
    "
!

strictlyPositive
    "return true if the receiver is greater than zero"

%{  /* NOCONTEXT */

    RETURN ( (__shortFloatVal(self) > 0.0) ? true : false );
%}
! !

!ShortFloat methodsFor:'truncation & rounding'!

ceiling
    "return the smallest integer which is greater or equal to the receiver."

    |val|

%{
    float fVal;

#if defined(__i386__) && defined(__GNUC__)
    fVal = ceilf(__shortFloatVal(self));
#else
    fVal = (float)(ceil((double)__shortFloatVal(self)));
#endif
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((fVal >= (float)_MIN_INT) && (fVal <= (float)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) fVal ) );
    }
    __qMKSFLOAT(val, fVal);
%}.
    ^ val asInteger

    "
     0.5 asShortFloat ceiling
     -0.5 asShortFloat ceiling
    "
!

ceilingAsFloat
    "return the smallest integer-valued float greater or equal to the receiver.
     This is much like #ceiling, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another float-operation."

%{  /* NOCONTEXT */
    float fVal;
    OBJ v;

#if defined(__i386__) && defined(__GNUC__)
    fVal = ceilf(__shortFloatVal(self));
#else
    fVal = (float) ceil((double)__shortFloatVal(self));
#endif
    __qMKSFLOAT(v, fVal);
    RETURN (v);
%}
    "
     0.5 asShortFloat ceilingAsFloat
     -0.5 asShortFloat ceilingAsFloat
     -1.5 asShortFloat ceilingAsFloat
    "
!

floor
    "return the integer nearest the receiver towards negative infinity."

    |val|

%{
    float fVal;

#if defined(__i386__) && defined(__GNUC__)
    fVal = floorf(__shortFloatVal(self));
#else
    fVal = (float)(floor((double)__shortFloatVal(self)));
#endif
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((fVal >= (float)_MIN_INT) && (fVal <= (float)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) fVal ) );
    }
    __qMKSFLOAT(val, fVal);
%}.
    ^ val asInteger

    "
     0.5 asShortFloat floor
     -0.5 asShortFloat floor
    "
!

floorAsFloat
    "return the float which represents the next lower
     integer nearest the receiver towards negative infinity.
     Much like floor, but returns a float result - useful if the result
     will be used in another float operation, to avoid costy int-conversion."

%{  /* NOCONTEXT */
    float fVal;
    OBJ v;

#if defined(__i386__) && defined(__GNUC__)
    fVal = floorf(__shortFloatVal(self));
#else
    fVal = (float)(floor((double)__shortFloatVal(self)));
#endif
    __qMKSFLOAT(v, fVal);
    RETURN ( v );
%}

    "
     0.5 asShortFloat floorAsFloat
     -0.5 asShortFloat floorAsFloat
    "
!

fractionPart
    "extract the after-decimal fraction part.
     such that (self truncated + self fractionPart) = self"

%{  /* NOCONTEXT */
#ifdef NO_MODFF
    double dFrac, dTrunc;
#else
# ifndef __VISUALC__
    float modff(float, float *);
# endif
#endif
    float frac, trunc;

    __threadErrno = 0;
#ifdef NO_MODFF
	dFrac = modf((double)__shortFloatVal(self), &dTrunc) ;
	frac = (float)dFrac;
#else
    frac = modff(__shortFloatVal(self), &trunc);
#endif
    if (! isnan(frac)) {
	if (__threadErrno == 0) {
	    RETURN (__MKSFLOAT(frac));
	}
    }
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#fractionPart
	arguments:#()
	errorString:'bad receiver in fractionPart'

    "
     1.6 asShortFloat fractionPart + 1.6 asShortFloat truncated
     -1.6 asShortFloat fractionPart + -1.6 asShortFloat truncated

     1.0 asShortFloat fractionPart
     0.5 asShortFloat fractionPart
     0.25 asShortFloat fractionPart
     3.14159 asShortFloat fractionPart
     12345673.14159 asShortFloat fractionPart
     123456731231231231.14159 asShortFloat fractionPart
    "
!

rounded
    "return the receiver rounded to the nearest integer"

    |val|

%{
    float fVal;

    fVal = __shortFloatVal(self);
#if defined(__i386__) && defined(__GNUC__)
    if (fVal < 0.0) {
	fVal = ceilf(fVal - (float)0.5);
    } else {
	fVal = floorf(fVal + (float)0.5);
    }
#else
    if (fVal < 0.0) {
	fVal = (float)ceil((double)fVal - 0.5);
    } else {
	fVal = (float)floor((double)fVal + 0.5);
    }
#endif
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((fVal >= (float)_MIN_INT) && (fVal <= (float)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) fVal ) );
    }
    __qMKSFLOAT(val, fVal);
%}.
    ^ val asInteger

    "
     0.4 asShortFloat rounded
     0.5 asShortFloat rounded
     0.6 asShortFloat rounded
     -0.4 asShortFloat rounded
     -0.5 asShortFloat rounded
     -0.6 asShortFloat rounded
    "
!

roundedAsFloat
    "return the receiver rounded to the nearest integer as a float.
     This is much like #rounded, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another float-operation."

%{  /* NOCONTEXT */
    float fVal;
    OBJ v;

    fVal = __shortFloatVal(self);
#if defined(__i386__) && defined(__GNUC__)
    if (fVal < 0.0) {
	fVal = ceilf(fVal - (float)0.5);
    } else {
	fVal = floorf(fVal + (float)0.5);
    }
#else
    if (fVal < 0.0) {
	fVal = (float)ceil((double)fVal - 0.5);
    } else {
	fVal = (float)floor((double)fVal + 0.5);
    }
#endif
    __qMKSFLOAT(v, fVal);
    RETURN (v);
%}

    "
     0.4 asShortFloat rounded
     0.5 asShortFloat rounded
     0.6 asShortFloat rounded
     -0.4 asShortFloat rounded
     -0.5 asShortFloat rounded
     -0.6 asShortFloat rounded

     0.4 asShortFloat roundedAsFloat
     0.5 asShortFloat roundedAsFloat
     0.6 asShortFloat roundedAsFloat
     -0.4 asShortFloat roundedAsFloat
     -0.5 asShortFloat roundedAsFloat
     -0.6 asShortFloat roundedAsFloat
    "
!

truncated
    "return the receiver truncated towards zero as an integer"

    |val|

%{
    float fVal;

    fVal = __shortFloatVal(self);
#if defined(__i386__) && defined(__GNUC__)
    if (fVal < 0.0) {
	fVal = ceilf(fVal);
    } else {
	fVal = floorf(fVal);
    }
#else
    if (fVal < 0.0) {
	fVal = (float)ceil((double)fVal);
    } else {
	fVal = (float)floor((double)fVal);
    }
#endif
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((fVal >= (float)_MIN_INT) && (fVal <= (float)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) fVal ) );
    }
    __qMKSFLOAT(val, fVal);
%}.
    ^ val asInteger

    "
     0.5 asShortFloat truncated
     -0.5 asShortFloat truncated
     0.5 asShortFloat truncatedAsFloat
     -0.5 asShortFloat truncatedAsFloat
    "
!

truncatedAsFloat
    "return the receiver truncated towards zero as a float.
     This is much like #truncated, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another
     float-operation."

%{  /* NOCONTEXT */
    float fVal;
    OBJ v;

    fVal = __shortFloatVal(self);
#if defined(__i386__) && defined(__GNUC__)
    if (fVal < 0.0) {
	fVal = ceilf(fVal);
    } else {
	fVal = floorf(fVal);
    }
#else
    if (fVal < 0.0) {
	fVal = (float)ceil((double)fVal);
    } else {
	fVal = (float)floor((double)fVal);
    }
#endif
    __qMKSFLOAT(v, fVal);
    RETURN (v);
%}

    "
     0.5 asShortFloat truncated
     -0.5 asShortFloat truncated
     0.5 asShortFloat truncatedAsFloat
     -0.5 asShortFloat truncatedAsFloat
    "
! !

!ShortFloat class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ShortFloat initialize!

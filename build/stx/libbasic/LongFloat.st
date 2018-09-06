"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1999 by eXept Software AG
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

LimitedPrecisionReal variableByteSubclass:#LongFloat
	instanceVariableNames:''
	classVariableNames:'DefaultPrintFormat LongFloatZero LongFloatOne Pi E Epsilon'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!LongFloat primitiveDefinitions!
%{
#include <stdio.h>
#include <errno.h>

#ifndef __OPTIMIZE__
# define __OPTIMIZE__
#endif

#define __USE_ISOC9X 1
#define __USE_ISOC99 1
#include <math.h>

/*
 * on some systems, errno is a macro ... check for it here
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

#if defined(__irix__) || defined(__solaris__) || defined(__sunos__)
# include <nan.h>
#endif

#if defined(__linux__)
# ifndef NAN
#  include <bits/nan.h>
# endif
#endif

#ifdef __win32__
/*
 * no finite(x) ?
 * no isnan(x) ?
 */
# ifndef isnanl
#  define isnanl(x)      \
	((((unsigned int *)(&x))[0] == 0x00000000) && \
	 (((unsigned int *)(&x))[1] == 0xC0000000) && \
	 (((unsigned short *)(&x))[4] == 0xFFFF))
# endif

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

# define NO_ASINH
# define NO_ACOSH
# define NO_ATANH

# ifdef __MINGW__
#  include <string.h>

// sigh: the default ming setup uses the microsoft printf,
// which does not support long doubles
# define snprintf  __mingw_snprintf
# endif /* __MINGW__ */

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

#if defined(__GNUC__) || defined(__MINGW__) || defined(__win32__)
# define LONGFLOAT      long double

# if defined(__linux__) || defined(__osx__) || defined(__win32__)
#  define LONG_ceil     ceill
#  define LONG_floor    floorl
#  define LONG_sqrt     sqrtl
#  define LONG_sin      sinl
#  define LONG_cos      cosl
#  define LONG_tan      tanl
#  define LONG_sinh     sinhl
#  define LONG_cosh     coshl
#  define LONG_tanh     tanhl
#  define LONG_asin     asinl
#  define LONG_acos     acosl
#  define LONG_atan     atanl
#  define LONG_exp      expl
#  define LONG_frexp    frexpl
#  define LONG_log      logl
#  define LONG_log10    log10l
#  define LONG_modf     modfl
#  define LONG_trunc    truncl
#  define LONG_pow      powl
#  ifdef __llvm__
#   define LONG_isnan    isnan
#  else
#   define LONG_isnan    isnanl
#  endif
#  define LONG_isfinite isfinitel

#  if !defined(__win32__)
#   define LONG_asinh    asinhl
#   define LONG_acosh    acoshl
#   define LONG_atanh    atanhl
#  endif /* linux */

# endif  /* defined(__linux__) || defined(__win32__) */

# if !defined(LONG_isnan)
/* This should be true for ISO C99 systems - even for newer linux systems */
#  define LONG_isnan    isnan
#  define LONG_isfinite isfinite
# endif /* !defined(LONG_isnan) */

#endif /* defined(__GNUC__) || defined(__win32__) */

/*
 * on systems which do not support long doubles, fall back to double
 * arithmetic
 */
#ifndef LONGFLOAT
# define LONGFLOAT        double
# define LONGFLOAT_CLASS  Float
# define LONGFLOAT_GLOBAL @global(Float)
#else
# define LONGFLOAT_CLASS  LongFloat
# define LONGFLOAT_GLOBAL @global(LongFloat)
#endif

struct __longfloatstruct {
	STX_OBJ_HEADER
#ifdef __NEED_DOUBLE_ALIGN
	__FILLTYPE_DOUBLE f_filler;
#endif
	LONGFLOAT f_longfloatvalue;
};

#define __LongFloatInstPtr(obj)      ((struct __longfloatstruct *)(__objPtr(obj)))

#ifndef __longFloatVal
# define __longFloatVal(o) \
	__LongFloatInstPtr(o)->f_longfloatvalue
#endif

#ifndef __qMKLFLOAT
# define __qMKLFLOAT(__newFloat__, __fVal__) \
    { \
	__qNew(__newFloat__ , sizeof(struct __longfloatstruct)); \
	if (__newFloat__) { \
	    __objPtr(__newFloat__)->o_class = LONGFLOAT_GLOBAL; \
	    __LongFloatInstPtr(__newFloat__)->f_longfloatvalue = (LONGFLOAT)(__fVal__); \
	} \
    }
#endif

#ifndef __isLongFloat
# define __isLongFloat(o) \
	(__Class(o) == @global(LongFloat))
#endif

#ifndef __qIsLongFloat
# define __qIsLongFloat(o) \
	(__qClass(o) == @global(LongFloat))
#endif

%}
! !

!LongFloat class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    LongFloats represent rational numbers with limited precision.
    They use the C-compilers 'long double' format, which is usually
    mapped to the IEEE extended float or IEEE quad float format.

    In contrast to Floats (which use the C-compilers 64bit 'double' format),
    LongFloats give you 80 bit floats (extended) or 128 bit floats (quad).
    The actual number of bits depends on the underlying CPU.
    Thus, code using longFloats is not guaranteed to be portable from one architecture
    to another.

    NO GARANTY:
	on systems which do not support 'long doubles', LongFloats are (silently)
	represented as 'doubles'.

    Representation:
	gcc-x86:
	    80bit extended IEEE floats stored in in 96bits (12bytes);
	    64 bit mantissa,
	    16 bit exponent,
	    19 decimal digits (approx.)

	borland-x86 (WIN32):
	    80bit extended IEEE floats stored in in 80bits (10bytes);
	    64 bit mantissa,
	    16 bit exponent,
	    19 decimal digits (approx.)

	gcc-x86_64: (WIN64)
	    like gcc-x86

	gcc-sparc:
	    128bit quad IEEE floats (16bytes);
	    112 bit mantissa,
	    16 bit exponent,
	    34 decimal digits (approx.)

    Mixed mode arithmetic:
	longFloat op longFloat   -> longFloat
	longFloat op fix         -> longFloat
	longFloat op fraction    -> longFloat
	longFloat op integer     -> longFloat
	longFloat op shortFloat  -> longFloat
	longFloat op float       -> longFloat
	longFloat op complex     -> complex

    Range and Precision of Storage Formats: see LimitedPrecisionReal >> documentation

    [author:]
	Claus Gittinger

    [see also:]
	Number
	Float ShortFloat Fraction FixedPoint Integer Complex
	FloatArray DoubleArray
"
! !

!LongFloat class methodsFor:'instance creation'!

basicNew
    "return a new longFloat - here we return 0.0
     - LongFloats are usually NOT created this way ...
     Its implemented here to allow things like binary store & load
     of longFloats. (but even this support will go away eventually, its not
     a good idea to store the bits of a float - the reader might have a
     totally different representation - so floats will eventually be
     binary stored in a device independent format."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( new STDouble(0.0) );
#else
    OBJ newFloat;
    if (sizeof(LONGFLOAT) == sizeof(double)) {
	__qMKFLOAT(newFloat, 0.0);   /* OBJECT ALLOCATION */
    } else {
	__qMKLFLOAT(newFloat, 0.0);   /* OBJECT ALLOCATION */
    }
    RETURN (newFloat);
#endif /* not SCHTEAM */
%}
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asLongFloat.
!

fromFloat:aFloat
    "return a new longFloat, given a float value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aFloat.isDouble()) {
	return __c__._RETURN(aFloat);
    }
    if (aFloat.isFloat()) {
	return __c__._RETURN( new STDouble(aFloat.floatValue()) );
    }
#else
    OBJ newFloat;
    LONGFLOAT f;

    if (sizeof(LONGFLOAT) == sizeof(double)) {
	RETURN (aFloat);
    }

    if (__isFloatLike(aFloat)) {
	f = (LONGFLOAT)(__floatVal(aFloat));
	__qMKLFLOAT(newFloat, f);   /* OBJECT ALLOCATION */
	RETURN (newFloat);
    }
#endif
%}.
    self error:'invalid argument'

    "
     LongFloat fromFloat:123.0
     123.0 asLongFloat
     123 asLongFloat
    "
!

fromIEEE32Bit: anInteger
    "creates a long float, given the four native float bytes as an integer"

%{  /* NOCONTEXT */
    OBJ newFloat;

    REGISTER union {
	unsigned int    i;
	float           f;
    } r;

    r.i = __unsignedLongIntVal( anInteger );
    __qMKLFLOAT(newFloat, r.f);
    RETURN( newFloat );
%}.
    ^ Float fromIEEE32Bit: anInteger

    "
     LongFloat fromIEEE32Bit:(ShortFloat pi digitBytesMSB:true) asInteger
    "
!

fromIEEE64Bit: anInteger
    "creates a long double, given the eight native float bytes as an integer"

%{  /* NOCONTEXT */
    extern int __unsignedLong64IntVal(OBJ o, __uint64__ *pI);

    REGISTER union {
	__uint64__  u64;
	double      d;
    } r;

    if (__unsignedLong64IntVal(anInteger, &r.u64))  {
	OBJ newFloat;

	__qMKLFLOAT(newFloat, r.d);
	RETURN( newFloat );
    }
%}.
    ^ Float fromIEEE32Bit: anInteger

    "
	LongFloat fromIEEE64Bit:(Float pi digitBytesMSB:true) asInteger
    "
!

fromInteger:anInteger
    "return a new longFloat, given an integer value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (anInteger.isSmallInteger()) {
	return __c__._RETURN( STDouble._new( (double)(anInteger.longValue()) ));
    }
#else
    OBJ newFloat;

    if (__isSmallInteger(anInteger)) {
	LONGFLOAT f = (LONGFLOAT)__smallIntegerVal(anInteger);
	__qMKLFLOAT(newFloat, f);   /* OBJECT ALLOCATION */
	RETURN (newFloat);
    }
#endif /* not SCHTEAM */
%}.
    ^ super fromInteger:anInteger

    "
     LongFloat fromInteger:123
     LongFloat fromInteger:(100 factorial)
     (100 factorial) asLongFloat
    "
!

fromNumber:aNumber
    ^aNumber asLongFloat
!

fromShortFloat:aFloat
    "return a new longFloat, given a shortFloat value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aFloat.isFloat()) {
	return __c__._RETURN( new STDouble(aFloat.floatValue()) );
    }
    if (aFloat.isDouble()) {
	return __c__._RETURN( aFloat );
    }
#else
    OBJ newFloat;
    LONGFLOAT f;

    if (__isShortFloat(aFloat)) {
	f = (LONGFLOAT)(__shortFloatVal(aFloat));
	__qMKLFLOAT(newFloat, f);   /* OBJECT ALLOCATION */
	RETURN (newFloat);
    }
#endif /* not SCHTEAM */
%}.
    self error:'invalid argumnet'

    "
     LongFloat fromShortFloat:(123.0 asShortFloat)
     LongFloat fromShortFloat:122
    "
! !

!LongFloat class methodsFor:'accessing'!

defaultPrintFormat
    ^ DefaultPrintFormat
!

defaultPrintFormat:something
    DefaultPrintFormat := something.
!

epsilon
    Epsilon isNil ifTrue:[
	Epsilon := self computeEpsilon.
    ].
    ^ Epsilon
! !

!LongFloat class methodsFor:'class initialization'!

initialize
    DefaultPrintFormat := '.19'.  "/ 19 valid digits

    "
     self initialize
    "

    "
     DefaultPrintFormat := '.19'.
     LongFloat pi printString.

     DefaultPrintFormat := '.9'.
     LongFloat pi printString.

     DefaultPrintFormat := '.6'.
     LongFloat pi printString.
    "
! !

!LongFloat class methodsFor:'constants'!

e
    "return the constant e as LongFloat"

    E isNil ifTrue:[
	"/ enough digits for 128bit IEEE quads
	"/ do not write as a literal constant here - we cannot depend on the underlying C-compiler here...

	E  := self readFrom:'2.7182818284590452353602874713526625'.
    ].
    ^ E
!

pi
    "return the constant pi as LongFloat"

    Pi isNil ifTrue:[
	"/ enough digits for 128bit IEEE quads
	"/ do not write as a literal constant here - we cannot depend on the underlying C-compiler here...

	Pi := self readFrom:'3.1415926535897932384626433832795029'. "/ 3.14159265358979323846264338327950288419716939937510582097494459q
    ].
    ^ Pi
!

unity
    "return the neutral element for multiplication (1.0) as LongFloat"

    LongFloatOne isNil ifTrue:[
	LongFloatOne := 1.0 asLongFloat.
    ].
    ^ LongFloatOne

    "Modified: 23.4.1996 / 09:26:51 / cg"
!

zero
    "return the neutral element for addition (0.0) as LongFloat"

    LongFloatZero isNil ifTrue:[
	LongFloatZero := 0.0 asLongFloat
    ].
    ^ LongFloatZero

    "Modified: 23.4.1996 / 09:26:45 / cg"
! !

!LongFloat class methodsFor:'queries'!

exponentCharacter
    ^ $q
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == LongFloat

    "Modified: 23.4.1996 / 16:00:23 / cg"
!

numBitsInExponent
    "answer the number of bits in the exponent
     i386: This is an 80bit longfloat stored in 96 bits (upper 16 bits are unused),
	   where 15 bits are available in the exponent (i bit is ignored):
	00000000 00000000 seeeeeee eeeeeeee immmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
     x86_64: This is an 80bit longfloat stored in 128 bits (upper 48 bits are unused),
	   where 15 bits are available in the exponent:
	00000000 00000000 seeeeeee eeeeeeee immmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
     sparc & others: This is an 128bit longfloat,
	   where 15 bits are available in the exponent:
	00000000 00000000 seeeeeee eeeeeeee mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm ...
    "
%{  /* NOCONTEXT */
#if defined(__x86__) || defined(__x86_64__)
    if (sizeof(LONGFLOAT) == 10) {      /* x86 - WIN32: 80bit floats */
	RETURN (__mkSmallInteger(15));
    }
    if (sizeof(LONGFLOAT) == 12) {      /* x86 - some unixes: 96bit floats */
	RETURN (__mkSmallInteger(15));
    }
    if (sizeof(LONGFLOAT) == 16) {      /* amd64, x86_64 */
	RETURN (__mkSmallInteger(15));
    }
#else
    if (sizeof(LONGFLOAT) == 16) {
	RETURN (__mkSmallInteger(15));  /* sparc */
    }
#endif
%}.
    "systems without longFloat support use doubles instead"
    self basicNew basicSize == Float basicNew basicSize ifTrue:[
	^ Float numBitsInExponent
    ].
    self error:'missing definition'  "ifdef missing in above primitive code for this architecture"

    "
     1.0 asLongFloat class numBitsInExponent
    "
!

numBitsInIntegerPart
    "answer the number of bits in the integer part of the mantissa
     i386: This is an 80bit longfloat stored in 96 bits (upper 16 bits are unused),
	   where 1 bit is used for the integer part in the mantissa:
	00000000 00000000 seeeeeee eeeeeeee immmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
     x86_64: This is an 80bit longfloat stored in 128 bits (upper 48 bits are unused),
	   where 1+63 bits are available in the mantissa:
	00000000 00000000 seeeeeee eeeeeeee immmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
     sparc & others: This is an 128bit longfloat,
	   where 112 bits are available in the mantissa:
	00000000 00000000 seeeeeee eeeeeeee mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm ...
    "
%{  /* NOCONTEXT */
#if defined(__x86__) || defined(__x86_64__)
    if (sizeof(LONGFLOAT) == 10) {      /* x86 - WIN32: 80bit floats */
	RETURN (__mkSmallInteger(1));
    }
    if (sizeof(LONGFLOAT) == 12) {      /* x86 - some other unixes: 96bit floats*/
	RETURN (__mkSmallInteger(1));
    }
    if (sizeof(LONGFLOAT) == 16) {
	RETURN (__mkSmallInteger(1));   /* amd64, x86_64 */
    }
#else
    if (sizeof(LONGFLOAT) == 16) {
	RETURN (__mkSmallInteger(0));   /* sparc */
    }
#endif
%}.
    "systems without longFloat support use doubles instead"
    self basicNew basicSize == Float basicNew basicSize ifTrue:[
	^ Float numBitsInIntegerPart
    ].
    self error:'missing definition'  "ifdef missing in above primitive code for this architecture"

    "
     self numBitsInIntegerPart
    "
!

numBitsInMantissa
    "answer the number of bits in the mantissa
     i386: This is an 80bit longfloat stored in 96 bits (upper 16 bits are unused),
	   where 1+63 bits are available in the mantissa:
	00000000 00000000 seeeeeee eeeeeeee immmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
     x86_64: This is an 80bit longfloat stored in 128 bits (upper 48 bits are unused),
	   where 1+63 bits are available in the mantissa:
	00000000 00000000 seeeeeee eeeeeeee immmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
     sparc: This is an 128bit longfloat,
	   where 112 bits are available in the mantissa:
	00000000 00000000 seeeeeee eeeeeeee mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
    "
%{  /* NOCONTEXT */
#if defined(__x86__) || defined(__x86_64__)
    if (sizeof(LONGFLOAT) == 10) {      /* x86 - WIN32: 80bit */
	RETURN (__mkSmallInteger(64));
    }
    if (sizeof(LONGFLOAT) == 12) {      /* x86 some unixes: 96bit */
	RETURN (__mkSmallInteger(64));
    }
    if (sizeof(LONGFLOAT) == 16) {
	RETURN (__mkSmallInteger(64));  /* amd64, x86_64 */
    }
#else
    if (sizeof(LONGFLOAT) == 16) {
	RETURN (__mkSmallInteger(112)); /* sparc */
    }
#endif
%}.
    "systems without longFloat support use doubles instead"
    self basicNew basicSize == Float basicNew basicSize ifTrue:[
	^ Float numBitsInMantissa
    ].
    self error:'missing definition'  "ifdef missing in above primitive code for this architecture"

    "
     1.0 class numBitsInMantissa
     1.0 asShortFloat class numBitsInMantissa
     1.0 asLongFloat class numBitsInMantissa
    "
!

radix
   "answer the radix of a LongFloats exponent
    This is an IEEE float, which is represented as binary"

    ^ 2 "must be careful here, whenever ST/X is used on VAX or a 370"
! !

!LongFloat methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument."

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result, val;

    if (__isSmallInteger(aNumber)) {
	val = (LONGFLOAT)(__intVal(aNumber));
doMul:
	result = __longFloatVal(self) * val;
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    val = __longFloatVal(aNumber);
	    goto doMul;
	}
	if (__qIsFloatLike(aNumber)) {
	    val = (LONGFLOAT)(__floatVal(aNumber));
	    goto doMul;
	}
	if (__qIsShortFloat(aNumber)) {
	    val = (LONGFLOAT)(__shortFloatVal(aNumber));
	    goto doMul;
	}
    }
%}.
    ^ aNumber productFromLongFloat:self
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result, val;

    if (__isSmallInteger(aNumber)) {
	val = (LONGFLOAT)(__intVal(aNumber));
doAdd:
	result = __longFloatVal(self) + val;
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    val = __longFloatVal(aNumber);
	    goto doAdd;
	}
	if (__qIsFloatLike(aNumber)) {
	    val = (LONGFLOAT)(__floatVal(aNumber));
	    goto doAdd;
	}
	if (__qIsShortFloat(aNumber)) {
	    val = (LONGFLOAT)(__shortFloatVal(aNumber));
	    goto doAdd;
	}
    }
%}.
    ^ aNumber sumFromLongFloat:self
!

- aNumber
    "return the difference of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result, val;

    if (__isSmallInteger(aNumber)) {
	val = (LONGFLOAT)(__intVal(aNumber));
doSub:
	result = __longFloatVal(self) - val;
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    val = __longFloatVal(aNumber);
	    goto doSub;
	}
	if (__qIsFloatLike(aNumber)) {
	    val = (LONGFLOAT)(__floatVal(aNumber));
	    goto doSub;
	}
	if (__qIsShortFloat(aNumber)) {
	    val = (LONGFLOAT)(__shortFloatVal(aNumber));
	    goto doSub;
	}
    }
%}.
    ^ aNumber differenceFromLongFloat:self
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result, val;

    if (__isSmallInteger(aNumber)) {
	val = (LONGFLOAT)(__intVal(aNumber));
doDiv:
	if (val == 0.0) goto badArg;

	result = __longFloatVal(self) / val;
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    val = __longFloatVal(aNumber);
	    goto doDiv;
	}
	if (__qIsFloatLike(aNumber)) {
	    val = (LONGFLOAT)(__floatVal(aNumber));
	    goto doDiv;
	}
	if (__qIsShortFloat(aNumber)) {
	    val = (LONGFLOAT)(__shortFloatVal(aNumber));
	    goto doDiv;
	}
    }
badArg: ;
%}.
    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
	"
	 No, you shalt not divide by zero
	"
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber quotientFromLongFloat:self
!

abs
    "return the absolute value of the receiver
     reimplemented here for speed"

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT val = __longFloatVal(self);

    if (val < (LONGFLOAT)0.0) {
	__qMKLFLOAT(newFloat, -val);
	RETURN ( newFloat );
    }
    RETURN (self);
%}.

    "
     3.0 asLongFloat abs
     -3.0 asLongFloat abs
    "
!

negated
    "return myself negated"

%{  /* NOCONTEXT */
    OBJ newFloat;
    LONGFLOAT rslt = - __longFloatVal(self);

    __qMKLFLOAT(newFloat, rslt);
    RETURN ( newFloat );
%}.
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
    LONGFLOAT result, val;

    if (__isSmallInteger(aNumber)) {
	if (aNumber != __mkSmallInteger(0)) {
	    val = (LONGFLOAT)__intVal(aNumber);
	    if (val == 0.0) goto badArg;
computeResult:
	    result = fmodl(__longFloatVal(self), val) ;
	    __qMKLFLOAT(newFloat, result);
	    RETURN ( newFloat );
	}
    } else if (__isFloatLike(aNumber)) {
	val = (LONGFLOAT)__floatVal(aNumber);
	goto computeResult;
    } else if (__isShortFloat(aNumber)) {
	val = (LONGFLOAT)__shortFloatVal(aNumber);
	goto computeResult;
    } else if (__isLongFloat(aNumber)) {
	val = __longFloatVal(aNumber);
	goto computeResult;
    }
badArg: ;
%}.
    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
	"
	 No, you shalt not divide by zero
	"
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber remainderFromLongFloat:self
!

uncheckedDivide:aNumber
    "return the quotient of the receiver and the argument, aNumber.
     Do not check for divide by zero (return NaN or Infinity).
     This operation is provided for emulators of other languages/semantics,
     where no exception is raised for these results (i.e. Java).
     It is only defined if the argument's type is the same as the receiver's."

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result, val;

    if (__isSmallInteger(aNumber)) {
	val = (LONGFLOAT)(__intVal(aNumber));
doDiv:
	result = __longFloatVal(self) / val;
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    val = __longFloatVal(aNumber);
	    goto doDiv;
	}
	if (__qIsShortFloat(aNumber)) {
	    val = (LONGFLOAT)(__shortFloatVal(aNumber));
	    goto doDiv;
	}
	if (__qIsFloatLike(aNumber)) {
	    val = (LONGFLOAT)(__floatVal(aNumber));
	    goto doDiv;
	}
    }
%}.
    ^ aNumber quotientFromLongFloat:self

    "
      0.0 asLongFloat uncheckedDivide:0
      1.0 asLongFloat uncheckedDivide:0.0
      -1.0 asLongFloat uncheckedDivide:0.0
    "
! !

!LongFloat methodsFor:'coercing & converting'!

asFloat
    "return a Float with same value as the receiver.
     CAVEAT: should raise an error if the receiver exceeds the quadFloat range."

%{  /* NOCONTEXT */

    OBJ newFloat;
    double dVal = (double)__longFloatVal(self);

    __qMKFLOAT(newFloat, dVal);
    RETURN ( newFloat );
%}

    "
     1.0 asLongFloat
    "
!

asInteger
    "return an integer with same value - might truncate"

%{  /* NOCONTEXT */
    LONGFLOAT fVal;

    fVal = __longFloatVal(self);
    if (!LONG_isnan(fVal) && (fVal >= (LONGFLOAT)_MIN_INT) && (fVal <= (LONGFLOAT)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT)fVal) );
    }
%}.
    ^ super asInteger

    "
     12345.0 asLongFloat asInteger
     1e15 asLongFloat asInteger
    "
!

asLongFloat
    "return a LongFloat with same value as the receiver - that's me"

    ^ self
!

asShortFloat
    "return a ShortFloat with same value as the receiver.
     CAVEAT: should raise an error if the receiver exceeds the float range."

%{  /* NOCONTEXT */

    OBJ newFloat;
    float fVal = (float)__longFloatVal(self);

    __qMKSFLOAT(newFloat, fVal);
    RETURN ( newFloat );
%}

    "
     1.0 asLongFloat asShortFloat
    "
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asLongFloat
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 90
! !

!LongFloat methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__longFloatVal(self) < (LONGFLOAT)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) < __longFloatVal(aNumber)) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__longFloatVal(self) < (LONGFLOAT)(__floatVal(aNumber))) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) < (LONGFLOAT)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
%}.
    ^ aNumber lessFromLongFloat:self

    "
     1.0 asLongFloat > (1/3)
     1.0 asLongFloat > (1/3) asLongFloat
    "
!

<= aNumber
    "return true, if the argument is greater or equal"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__longFloatVal(self) <= (LONGFLOAT)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) <= __longFloatVal(aNumber)) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__longFloatVal(self) <= (LONGFLOAT)(__floatVal(aNumber))) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) <= (LONGFLOAT)(__shortFloatVal(aNumber))) ? true : false );
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
	RETURN ( (__longFloatVal(self) == (LONGFLOAT)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) == __longFloatVal(aNumber)) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__longFloatVal(self) == (LONGFLOAT)(__floatVal(aNumber))) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) == (LONGFLOAT)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
%}.
    ^ aNumber equalFromLongFloat:self
!

> aNumber
    "return true, if the argument is less"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__longFloatVal(self) > (LONGFLOAT)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) > __longFloatVal(aNumber)) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__longFloatVal(self) > (LONGFLOAT)(__floatVal(aNumber))) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) > (LONGFLOAT)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
%}.
    ^ self retry:#> coercing:aNumber
!

>= aNumber
    "return true, if the argument is less or equal"

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__longFloatVal(self) >= (LONGFLOAT)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsLongFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) >= __longFloatVal(aNumber)) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__longFloatVal(self) >= (LONGFLOAT)(__floatVal(aNumber))) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) >= (LONGFLOAT)(__shortFloatVal(aNumber))) ? true : false );
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
     1.2345 asLongFloat hash
     1 hash
     1.0 hash
     1.0 asLongFloat hash
    "
!

~= aNumber
    "return true, if the arguments value are not equal."

%{  /* NOCONTEXT */

    if (__isSmallInteger(aNumber)) {
	RETURN ( (__longFloatVal(self) != (LONGFLOAT)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__isLongFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) != __longFloatVal(aNumber)) ? true : false );
	}
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__longFloatVal(self) != (LONGFLOAT)(__floatVal(aNumber))) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__longFloatVal(self) != (LONGFLOAT)(__shortFloatVal(aNumber))) ? true : false );
	}
    } else {
	RETURN ( true );
    }
%}.
    ^ super ~= aNumber
! !

!LongFloat methodsFor:'double dispatching'!

productFromInteger:anInteger
    "sent when an integer does not know how to multiply the receiver, a float"

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result;

    if (__isSmallInteger(anInteger)) {
	result = __longFloatVal(self) * (LONGFLOAT)(__intVal(anInteger));
retResult:
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
%}.
    ^ super productFromInteger:anInteger
!

sumFromInteger:anInteger
    "sent when an integer does not know how to add the receiver, a float"

%{  /* NOCONTEXT */

    OBJ newFloat;
    LONGFLOAT result;

    if (__isSmallInteger(anInteger)) {
	result = __longFloatVal(self) + (LONGFLOAT)(__intVal(anInteger));
retResult:
	__qMKLFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
%}.
    ^ super sumFromInteger:anInteger
! !

!LongFloat methodsFor:'mathematical functions'!

exp
    "return e raised to the power of the receiver"

    |useFallBack|

%{
#if defined(LONG_exp)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_exp(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super exp
    ].

    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#exp
	arguments:#()
	errorString:'bad receiver in exp'
!

ln
    "return the natural logarithm of myself.
     Raises an exception, if the receiver is less or equal to zero."

    |useFallBack|

%{
#if defined(LONG_log)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val > 0.0)
# endif
    {
	__threadErrno = 0;
	rslt = LONG_log(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super ln
    ].

    "
     an invalid value for logarithm
    "
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#ln
	arguments:#()
	errorString:'bad receiver in ln'
!

log10
    "return the base10 logarithm of myself.
     Raises an exception, if the receiver is less or equal to zero."

    |useFallBack|

%{
#if defined(LONG_log10)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val > 0.0)
# endif
    {
	__threadErrno = 0;
	rslt = LONG_log10(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super log10
    ].

    "
     an invalid value for logarithm
    "
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#log10
	arguments:#()
	errorString:'bad receiver in log10'
!

raisedTo:aNumber
    "return self raised to the power of aNumber"

    |n useFallBack|

    n := aNumber asFloat.
%{
#if defined(LONG_pow)
    LONGFLOAT rslt;
    OBJ newFloat;

    if (__isFloatLike(n)) {
	__threadErrno = 0;
	rslt = LONG_pow(__longFloatVal(self), __floatVal(n));
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super raisedTo:aNumber
    ].

    "/ the c-library pow functin, has a bug:
    "/ it does not deal correctly with negative numbers.
    "/ I.e. it raises an error on -8^(1/3) instead of returning a negative -2
    "/ work around with a kludge:
    self < 0 ifTrue:[
	^ (self negated raisedTo:n) negated
    ].

    "
     an invalid argument (not convertable to float ?)
    "
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#raisedTo:
	arguments:(Array with:aNumber)
	errorString:'bad receiver/arg in raisedTo:'

    "Modified: / 16.11.2001 / 14:16:51 / cg"
!

sqrt
    "return the square root of myself.
     Raises an exception, if the receiver is less than zero."

    |useFallBack|

%{
#if defined(LONG_sqrt)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val >= 0.0)
# endif
    {
	__threadErrno = 0;
	rslt = LONG_sqrt(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super sqrt
    ].

    ^ self class
	raise:#imaginaryResultSignal
	receiver:self
	selector:#sqrt
	arguments:#()
	errorString:'bad (negative) receiver in sqrt'

    "
     10 asLongFloat sqrt
     -10 asLongFloat sqrt
    "

    "Modified: / 16.11.2001 / 14:14:43 / cg"
! !

!LongFloat methodsFor:'printing & storing'!

printString
    "return a printed representation of the receiver
     LimitedPrecisonReal and its subclasses use #printString instead of
     #printOn: as basic print mechanism."

    ^ self printStringWithFormat:DefaultPrintFormat

    "
	LongFloat pi printString.
	1.234 asLongFloat printString.
	1.0 asLongFloat printString.
	1e10 asLongFloat printString.
	1.2e3 asLongFloat printString.
	1.2e30 asLongFloat printString.
	(1.0 uncheckedDivide:0) asLongFloat printString.
	(0.0 uncheckedDivide:0) asLongFloat printString.
	self pi printString.

	DecimalPointCharacterForPrinting := $,.
	1.234 asLongFloat printString.
	1.0 asLongFloat printString.
	1e10 asLongFloat printString.
	1.2e3 asLongFloat printString.
	1.2e30 asLongFloat printString.
	(1.0 uncheckedDivide:0) asLongFloat printString.
	(0.0 uncheckedDivide:0) asLongFloat printString.
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
    char fmtBuffer[20];
    char *fmt;
    REGISTER char *cp;
    OBJ s;
    int len ;

    if (__isStringLike(format)) {
	fmt = (char *) __stringVal(format);
    } else {
	fmt = ".19";
    }
    /*
     * build a printf format string
     */
    fmtBuffer[0] = '%';
    strncpy(fmtBuffer+1, fmt, 10);
    if (sizeof(LONGFLOAT) == sizeof(double)) {
#ifdef SYSV
	strcat(fmtBuffer, "lg");
#else
	strcat(fmtBuffer, "G");
#endif
    } else {
	strcat(fmtBuffer, "LG");
    }

    /*
     * actually only needed on sparc: since thisContext is
     * in a global register, which gets destroyed by printf,
     * manually save it here - very stupid ...
     */
    __BEGIN_PROTECT_REGISTERS__
    len = snprintf(buffer, sizeof(buffer), fmtBuffer, __longFloatVal(self));
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
    "
     memory allocation (for the new string) failed.
     When we arrive here, there was no memory, even after a garbage collect.
     This means, that the VM wanted to get some more memory from the
     OS, which was not kind enough to give it.
     Bad luck - you should increase the swap space on your machine.
    "
    ^ AllocationFailure raise.

    "
	1.234 asLongFloat printString.
	1.0 asLongFloat printString.
	1e10 asLongFloat printString.
	1.2e3 asLongFloat printString.
	1.2e30 asLongFloat printString.
	(1.0 uncheckedDivide:0)  isInfinite.
	(0.0 uncheckedDivide:0)  isNaN.
	(1.0 uncheckedDivide:0) asLongFloat isInfinite.
	(0.0 uncheckedDivide:0) asLongFloat isNaN.
	(1.0 uncheckedDivide:0) asLongFloat printString.
	(0.0 uncheckedDivide:0) asLongFloat printString.
	self pi printString.

	DecimalPointCharacterForPrinting := $,.
	1.234 asLongFloat printString.
	1.0 asLongFloat printString.
	1e10 asLongFloat printString.
	1.2e3 asLongFloat printString.
	1.2e30 asLongFloat printString.
	(1.0 uncheckedDivide:0) asLongFloat printString.
	(0.0 uncheckedDivide:0) asLongFloat printString.
	DecimalPointCharacterForPrinting := $.
    "
!

printfPrintString:formatString
    "non-standard: return a printed representation of the receiver
     as specified by formatString, which is defined by printf.
     If you use this, be aware, that specifying long doubles differs on
     systems; on Linux/gnuc machines you have to give something like %LF/%LG.
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

	len = snprintf(buffer, sizeof(buffer), __stringVal(formatString), __longFloatVal(self));

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

    "
     Float pi asLongFloat printfPrintString:'%%LG -> %LG'
     Float pi asLongFloat printfPrintString:'%%LF -> %LF'
     Float pi asLongFloat printfPrintString:'%%7.15LG -> %7.15LG'
     Float pi asLongFloat printfPrintString:'%%7.15LF -> %7.15LF'
    "
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
    char *fmtBuffer;

    /*
     * build a printf format string
     */
    if (sizeof(LONGFLOAT) == sizeof(double)) {
#ifdef SYSV
	fmtBuffer = "%.17lg";
#else
	fmtBuffer = "%.17G";
#endif
    } else {
	fmtBuffer = "%.20LG";
    }

    __BEGIN_PROTECT_REGISTERS__
    len = snprintf(buffer, sizeof(buffer), fmtBuffer, __longFloatVal(self));
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
	1.0 asLongFloat storeString
	1.234 asLongFloat storeString
	1e10 asLongFloat storeString
	1.2e3 asLongFloat storeString
	1.2e30 asLongFloat storeString
	LongFloat pi asLongFloat storeString
	(1.0 uncheckedDivide:0) asLongFloat storeString
	(0.0 uncheckedDivide:0) asLongFloat storeString

     notice that the storeString is NOT affected by DecimalPointCharacterForPrinting:

	DecimalPointCharacterForPrinting := $,.
	1.234 asLongFloat storeString.
	1.0 asLongFloat storeString.
	1e10 asLongFloat storeString.
	1.2e3 asLongFloat storeString.
	1.2e30 asLongFloat storeString.
	(1.0 uncheckedDivide:0) asLongFloat storeString.
	(0.0 uncheckedDivide:0) asLongFloat storeString.
	DecimalPointCharacterForPrinting := $.
    "
! !

!LongFloat methodsFor:'private-accessing'!

basicAt:index
    "return an internal byte of the float.
     The value returned here depends on byte order, float representation etc.
     Therefore, this method should be used strictly private.

     Notice:
	the need to redefine this method here is due to the
	inability of many machines to store floats in non-double aligned memory.
	Therefore, on some machines, the first <nPad> bytes of a float are left unused,
	and the actual float is stored at index <nPad>+1 ...
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
	if (((unsigned INT)(indx)) < sizeof(LONGFLOAT)) {
	    cp = (unsigned char *)(& (__LongFloatInstPtr(self)->f_longfloatvalue));
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
	Therefore, on some machines, the first <nPad> bytes of a float are left unused,
	and the actual float is stored at index <nPad>+1 .. .
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
	    if (((unsigned INT)(indx)) < sizeof(LONGFLOAT)) {
		cp = (unsigned char *)(& (__LongFloatInstPtr(self)->f_longfloatvalue));
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
!

basicSize
    "return the size in bytes of the float.

     Notice:
	the need to redefine this method here is due to the
	inability of many machines to store floats in non-double aligned memory.
	Therefore, on some machines, the first <nPad> bytes of a float are left unused,
	and the actual float is stored at index <nPad>+1 ...
	To hide this at one place, this method knows about that, and returns
	values as if this filler wasnt present."

%{  /* NOCONTEXT */

    RETURN (__mkSmallInteger(sizeof(LONGFLOAT)));
%}.
! !

!LongFloat methodsFor:'special access'!

exponent
    "extract a normalized floats exponent.
     The returned value depends on the float-representation of
     the underlying machine and is therefore highly unportable.
     This is not for general use.
     This assumes that the mantissa is normalized to
     0.5 .. 1.0 and the floats value is mantissa * 2^exp"

%{  /* NOCONTEXT */

#if defined(LONG_frexp)
    int exp;

    LONG_frexp( __longFloatVal(self), &exp);
    RETURN (__mkSmallInteger(exp));
#endif
%}.
    ^ super exponent

    "
     4.0q exponent
     2.0q exponent
     1.0q exponent
     0.5q exponent
     0.25q exponent
     0.00000011111q exponent
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
#if defined(LONG_frexp)
    LONGFLOAT frac;
    int exp;
    OBJ v;

    frac = LONG_frexp( __longFloatVal(self), &exp);
    __qMKLFLOAT(v, frac);
    RETURN (v);
#endif
%}.

    "
     1.0q exponent
     1.0q asLongFloat mantissa

     0.5q exponent
     0.5q  mantissa

     0.25q exponent
     0.25q mantissa

     0.00000011111q exponent
     0.00000011111q mantissa
    "
! !

!LongFloat methodsFor:'testing'!

isFinite
    "return true, if the receiver is a finite float
     i.e. not NaN and not infinite."

%{  /* NOCONTEXT */

#ifdef LONG_finite
    LONGFLOAT lV = __longFloatVal(self);

    if (LONG_finite(lV)) {
	RETURN (true);
    } else {
	RETURN (false);
    }
#else
    double dV = (double) __longFloatVal(self);

    if (isfinite(dV)) {
	RETURN (true);
    } else {
	RETURN (false);
    }
#endif
%}

    "
	1.0 asLongFloat isFinite
	(0.0 asLongFloat uncheckedDivide: 0.0) isFinite
	(1.0 asLongFloat uncheckedDivide: 0.0) isFinite
	(-1.0 asLongFloat uncheckedDivide: 0.0) isFinite
    "
!

isNaN
    "return true, if the receiver is an invalid float (NaN - not a number).
     These are not created by ST/X float operations (they raise an exception);
     however, inline C-code could produce them ..."

%{  /* NOCONTEXT */

#ifdef LONG_isnan
    LONGFLOAT lV = __longFloatVal(self);
    if (LONG_isnan(lV)) {
	RETURN (true);
    } else {
	RETURN (false);
    }
#else
    double dV = (double)(__longFloatVal(self));

    if (isnan(dV)) {
	RETURN (true);
    } else {
	RETURN (false);
    }
#endif
%}

    "
	1.0 asLongFloat isNaN
	(0.0 asLongFloat uncheckedDivide: 0.0) isNaN
    "
!

isNegativeZero
    "many systems have two float.Pnt zeros"

%{ /* NOCONTEXT */
#if defined(__BORLANDC__)
    union { LONGFLOAT ld; int i[3]; } __u;
   __u.ld = __longFloatVal(self);
    RETURN ( (__u.ld == 0.0 && (__u.i[2] & 0x8000)) ? true : false );
#else
    RETURN ( (__longFloatVal(self) == 0.0 && signbit(__longFloatVal(self)) != 0) ? true : false );
#endif
%}.

    "
     0.0 asLongFloat isNegativeZero
     -0.0 asLongFloat isNegativeZero
    "
!

negative
    "return true if the receiver is less than zero.
     -0.0 is positive for now."

%{  /* NOCONTEXT */

    RETURN ( __longFloatVal(self) < 0.0  ? true : false );
    // RETURN ( signbit(__longFloatVal(self)) != 0  ? true : false );
%}.

    "
	0.0 asLongFloat negative
	-0.0 asLongFloat negative
	1.0 asLongFloat negative
	-1.0 asLongFloat negative
	(1.0 uncheckedDivide: 0.0) asLongFloat negative
	(-1.0 uncheckedDivide: 0.0) asLongFloat negative
    "
!

numberOfBits
    "return the size (in bits) of the real;
     typically, 80 or 96 is returned here,
     but who knows ..."

%{  /* NOCONTEXT */

    RETURN (__mkSmallInteger (sizeof(LONGFLOAT) * 8));
%}

    "
     LongFloat basicNew numberOfBits
     1.2 asLongFloat numberOfBits
     1.2 asShortFloat numberOfBits
     1.2 numberOfBits
    "
!

positive
    "return true if the receiver is greater or equal to zero (not negative)
     0.0 and -0.0 are positive for now."

%{  /* NOCONTEXT */

    RETURN ( __longFloatVal(self) >= 0.0 ? true : false );
//    RETURN ( (signbit(__longFloatVal(self)) == 0 ? true : false ) );
%}.

    "
	0.0 asLongFloat positive
	-0.0 asLongFloat positive
	1.0 asLongFloat positive
	-1.0 asLongFloat positive
	(1.0 uncheckedDivide: 0.0) asLongFloat positive
	(-1.0 uncheckedDivide: 0.0) asLongFloat positive
    "
!

strictlyPositive
    "return true if the receiver is greater than zero"

%{  /* NOCONTEXT */

    RETURN ( (__longFloatVal(self) > 0.0) ? true : false );
%}
! !

!LongFloat methodsFor:'trigonometric'!

arcCos
    "return the arccosine of the receiver (as radians).
     Raises an exception, if the receiver is not in -1..1"

    |useFallBack|

%{
#if defined(LONG_acos)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if ((val >= -1.0) && (val <= 1.0))
# endif
    {
	__threadErrno = 0;
	rslt = LONG_acos(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super arcCos
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcCos
	arguments:#()
	errorString:'bad receiver in arcCos'

    "
     -10 asLongFloat arcCos
     1 asLongFloat arcCos
     0.5 asLongFloat arcCos
    "
!

arcCosh
    "return the hyperbolic arccosine of the receiver."

    |useFallBack|

%{
#if defined(LONG_acosh)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val >= 1.0)
# endif
    {
	__threadErrno = 0;
	rslt = LONG_acosh(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super arcCosh
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcCosh
	arguments:#()
	errorString:'bad receiver in arcCosh'

    "
     -10 asLongFloat arcCosh
     1 asLongFloat arcCosh
     0.5 asLongFloat arcCosh
    "
!

arcSin
    "return the arcsine of the receiver (as radians).
     Raises an exception, if the receiver is not in -1..1"

    |useFallBack|

%{
#if defined(LONG_asin)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if ((val >= -1.0) && (val <= 1.0))
# endif
    {
	__threadErrno = 0;
	rslt = LONG_asin(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super arcSin
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcSin
	arguments:#()
	errorString:'bad receiver in arcSin'

    "
     -10 asLongFloat arcSin
     1 asLongFloat arcSin
     0.5 asLongFloat arcSin
    "
!

arcSinh
    "return the hyperbolic arcsine of the receiver."

    |useFallBack|

%{
#if defined(LONG_asinh)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val >= 1.0)
# endif
    {
	__threadErrno = 0;
	rslt = LONG_asinh(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super arcSinh
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcSinh
	arguments:#()
	errorString:'bad receiver in arcSinh'

    "
     -10 asLongFloat arcSinh
     1 asLongFloat arcSinh
     0.5 asLongFloat arcSinh
    "
!

arcTan
    "return the arctangent of the receiver (as radians)"

    |useFallBack|

%{
#if defined(LONG_atan)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_atan(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    {
	if (__threadErrno == 0) {
	    __qMKLFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super arcTan
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcTan
	arguments:#()
	errorString:'bad receiver in arcTan'
!

arcTanh
    "return the hyperbolic arctangent of the receiver."

    |useFallBack|

%{
#if defined(LONG_atanh)

    LONGFLOAT val, rslt;
    OBJ newFloat;

    val = __longFloatVal(self);
    __threadErrno = 0;
# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if ((val >= -1.0) && (val <= 1.0))
# endif
    {
	rslt = LONG_atanh(val);
# ifdef LONG_isnan
	if (! LONG_isnan(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKLFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super arcTanh
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcTanh
	arguments:#()
	errorString:'bad receiver in arcTanh'
!

cos
    "return the cosine of the receiver (interpreted as radians)"

    |useFallBack|

%{
#if defined(LONG_cos)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_cos(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super cos
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#cos
	arguments:#()
	errorString:'bad receiver in cos'
!

cosh
    "return the hyperbolic cosine of the receiver"

    |useFallBack|

%{
#if defined(LONG_cosh)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_cosh(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super cosh
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#cosh
	arguments:#()
	errorString:'bad receiver in cosh'
!

sin
    "return the sine of the receiver (interpreted as radians)"

    |useFallBack|

%{
#if defined(LONG_sin)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_sin(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super sin
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#sin
	arguments:#()
	errorString:'bad receiver in sin'
!

sinh
    "return the hyperbolic sine of the receiver"

    |useFallBack|

%{
#if defined(LONG_sinh)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_sinh(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super sinh
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#sinh
	arguments:#()
	errorString:'bad receiver in sinh'
!

tan
    "return the tangens of the receiver (interpreted as radians)"

    |useFallBack|

%{
#if defined(LONG_tan)

    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_tan(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super tan
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#tan
	arguments:#()
	errorString:'bad receiver in tan'
!

tanh
    "return the hyperbolic tangens of the receiver"

    |useFallBack|

%{
#if defined(LONG_tanh)
    LONGFLOAT rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = LONG_tanh(__longFloatVal(self));
# ifdef LONG_isnan
    if (! LONG_isnan(rslt))
# endif
    if (__threadErrno == 0) {
	__qMKLFLOAT(newFloat, rslt);
	RETURN ( newFloat );
    }
#else
    useFallBack = true;
#endif
%}.
    useFallBack notNil ifTrue:[
	^ super tanh
    ].
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#tanh
	arguments:#()
	errorString:'bad receiver in tanh'
! !

!LongFloat methodsFor:'truncation & rounding'!

ceiling
    "return the smallest integer which is greater or equal to the receiver."

    |val|

%{
#if defined(LONG_ceil)
    LONGFLOAT lVal;

    lVal = LONG_ceil(__longFloatVal(self));
    if ((lVal >= (LONGFLOAT)_MIN_INT) && (lVal <= (LONGFLOAT)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) lVal ) );
    }
    __qMKLFLOAT(val, lVal);
#endif
%}.
    val notNil ifTrue:[
	^ val asInteger
    ].
    ^ super ceiling.

    "
     0.5q ceiling
     -0.5q ceiling
    "
!

ceilingAsFloat
    "return the smallest integer-valued float greater or equal to the receiver.
     This is much like #ceiling, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another float-operation."

%{  /* NOCONTEXT */
#if defined(LONG_ceil)
    LONGFLOAT lVal;
    OBJ v;

    lVal = LONG_ceil(__longFloatVal(self));
    __qMKLFLOAT(v, lVal);
    RETURN (v);
#endif
%}.
    ^ super ceilingAsFloat

    "
     0.5q ceilingAsFloat
     -0.5q ceilingAsFloat
     -1.5q ceilingAsFloat
    "
!

floor
    "return the integer nearest the receiver towards negative infinity."

    |val|

%{
#if defined(LONG_floor)
    LONGFLOAT lVal;

    lVal = LONG_floor(__longFloatVal(self));
    if ((lVal >= (LONGFLOAT)_MIN_INT) && (lVal <= (LONGFLOAT)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) lVal ) );
    }
    __qMKLFLOAT(val, lVal);
#endif
%}.
    val notNil ifTrue:[
	^ val asInteger
    ].
    ^ super floor.

    "
     0.5q floor
     -0.5q floor
    "
!

floorAsFloat
    "return the float which represents the next lower
     integer nearest the receiver towards negative infinity.
     Much like floor, but returns a float result - useful if the result
     will be used in another float operation, to avoid costy int-conversion."

%{  /* NOCONTEXT */
#if defined(LONG_floor)
    LONGFLOAT lVal;
    OBJ v;

    lVal = LONG_floor(__longFloatVal(self));
    __qMKLFLOAT(v, lVal);
    RETURN (v);
#endif
%}.
    ^ super floorAsFloat

    "
     0.5q floorAsFloat
     -0.5q floorAsFloat
     -1.5q floorAsFloat
    "
!

fractionPart
    "extract the after-decimal fraction part.
     such that (self truncated + self fractionPart) = self"

%{  /* NOCONTEXT */
#if defined(LONG_modf)
    LONGFLOAT frac, trunc;
    OBJ v;

    // mingw64 runtime modfl has a bug, triggering a SEGV
    // see https://sourceforge.net/p/mingw-w64/bugs/478/
# if defined(MINGW_MODFL_BUG)
    {
	LONGFLOAT value = __longFloatVal(self);
	LONGFLOAT int_part = LONG_trunc(value);
	frac = (isinf (value) ?  0.0L : value - int_part);
    }
# else
    frac = LONG_modf(__longFloatVal(self), &trunc);
# endif
    __qMKLFLOAT(v, frac);
    RETURN (v);
#endif
%}.
    ^ super fractionPart

    "
     1.6q fractionPart + 1.6q truncated
     -1.6q fractionPart + -1.6q truncated

     1.0q fractionPart
     2.0q fractionPart
     3.0 asLongFloat fractionPart
     4.0 asLongFloat fractionPart
     0.5 asLongFloat fractionPart
     0.25 asLongFloat fractionPart
     3.14159 asLongFloat fractionPart
     12345673.14159 asLongFloat fractionPart
     123456731231231231.14159 asLongFloat fractionPart

     3.14159 asLongFloat fractionPart + 3.14159 asLongFloat truncated

     12345673.14159 asLongFloat fractionPart + 12345673.14159 asLongFloat truncated

     123456731231231231.14159 asLongFloat fractionPart + 123456731231231231.14159 asLongFloat truncated
    "
!

rounded
    "return the receiver rounded to the nearest integer"

%{  /* NOCONTEXT */
#if defined(LONG_ceil) && defined(LONG_floor)
    LONGFLOAT lVal;
    OBJ v;

    lVal = __longFloatVal(self);
    if (lVal < 0.0) {
	lVal = LONG_ceil(lVal - (LONGFLOAT)0.5);
    } else {
	lVal = LONG_floor(lVal + (LONGFLOAT)0.5);
    }
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((lVal >= (LONGFLOAT)_MIN_INT) && (lVal <= (LONGFLOAT)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) lVal ) );
    }
    __qMKLFLOAT(v, lVal);
    RETURN (v);
#endif
%}.
    ^ super rounded

    "
     0.4q rounded
     0.5q rounded
     0.6qqrounded
     -0.4q rounded
     -0.5q rounded
     -0.6q rounded
    "
!

roundedAsFloat
    "return the receiver rounded to the nearest integer as a float.
     This is much like #rounded, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another float-operation."

%{  /* NOCONTEXT */
#if defined(LONG_ceil) && defined(LONG_floor)
    LONGFLOAT lVal;
    OBJ v;

    lVal = __longFloatVal(self);
    if (lVal < 0.0) {
	lVal = LONG_ceil(lVal - (LONGFLOAT)0.5);
    } else {
	lVal = LONG_floor(lVal + (LONGFLOAT)0.5);
    }
    __qMKLFLOAT(v, lVal);
    RETURN (v);
#endif
%}.
    ^ super roundedAsFloat
!

truncated
    "return the receiver truncated towards zero as an integer"

    |val|

%{
#if defined(LONG_ceil) && defined(LONG_floor)
    LONGFLOAT lVal;

    lVal = __longFloatVal(self);
    if (lVal < 0.0) {
	lVal = LONG_ceil(lVal);
    } else {
	lVal = LONG_floor(lVal);
    }

    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((lVal >= (LONGFLOAT)_MIN_INT) && (lVal <= (LONGFLOAT)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) lVal ) );
    }
    __qMKLFLOAT(val, lVal);
#endif
%}.
    val notNil ifTrue:[
	^ val asInteger
    ].
    ^ super truncated

    "
     0.5q truncated
     -0.5q truncated
     0.5q truncatedAsFloat
     -0.5q truncatedAsFloat
    "
!

truncatedAsFloat
    "return the receiver truncated towards zero as a float.
     This is much like #truncated, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another
     float-operation."

%{  /* NOCONTEXT */
#if defined(LONG_ceil) && defined(LONG_floor)
    LONGFLOAT lVal;
    OBJ v;

    lVal = __longFloatVal(self);
    if (lVal < 0.0) {
	lVal = LONG_ceil(lVal);
    } else {
	lVal = LONG_floor(lVal);
    }
    __qMKLFLOAT(v, lVal);
    RETURN (v);
#endif
%}.
    ^ super truncatedAsFloat

    "
     0.5q truncated
     -0.5q truncated
     0.5q truncatedAsFloat
     -0.5q truncatedAsFloat
    "
! !

!LongFloat class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


LongFloat initialize!

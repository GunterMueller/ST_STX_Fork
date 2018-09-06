"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

LimitedPrecisionReal variableByteSubclass:#Float
	instanceVariableNames:''
	classVariableNames:'DefaultPrintFormat Pi E Halfpi HalfpiNegative Twopi
		RadiansPerDegree Ln2 Ln10 Sqrt2 Epsilon MaxSmallInteger'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!Float primitiveDefinitions!
%{
#include <stdio.h>
#include <errno.h>

#ifndef __OPTIMIZE__
# define __OPTIMIZE__
#endif

#define __USE_ISOC9X 1
#define __USE_ISOC99 1
#include <math.h>

#ifndef INT64
# ifdef HAS_LONGLONG
#  define INT64 long long int
# else
# define INT64 __int64
# endif
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

/*
 * sigh - some systems define that stuff; others dont.
 * (AIX even declares them as macros, so an external decl
 *  will not work below ...
 */
#if !defined(__aix__) && !defined(NEXT3)

# ifdef acos
  double acos();
# endif
# ifdef asin
  double asin();
# endif
# ifndef atan
  double atan();
# endif
# ifndef cos
  double cos();
# endif
# ifndef sin
  double sin();
# endif
# ifndef pow
  double pow();
# endif
# ifndef log
  double log();
# endif
# ifndef exp
  double exp();
# endif
# ifndef sqrt
  double sqrt();
# endif
# ifndef cbrt
#  ifndef WIN32
  double cbrt();
#  endif
# endif
# ifndef tan
  double tan();
# endif

#endif /* not AIX */

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

# define NO_ASINH
# define NO_ACOSH
# define NO_ATANH

# ifdef __MINGW__
#  include <string.h>
# endif

#endif /* __win32__ */

#ifdef solaris
# ifndef isfinite
#  define isfinite(f) finite((double)(f))
# endif
#endif

#ifdef realIX
# ifndef isfinite
#  define isfinite(x)     1
# endif
#endif

#ifndef NEXT3
# ifndef ceil
double ceil();
double floor();
# endif
#endif

%}
! !

!Float class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    Floats represent rational numbers with limited precision.
    They use the C-compilers 'double' format, which is usually the 8byte IEEE double float format.

    Floats give you 64 bit floats.
    In contrast to ShortFloats (32bit) and LongFloats (>=64bit).

    WARNING:
	The layout of Float instances is known by the runtime system and the compiler;
	you may not add instance variables here.
	Also, subclassing is complicated by the fact, that the VM creates floats/shortFloats,
	and does some float-checks by an identity compare with the Float-class.
	(i.e. your subclasses instances may not be recognized as float-like objects,
	 thus mixed mode arithmetic will always coerce them, effectively slowing things down).

    Notice, that Floats are defined as Byte-array to prevent the garbage collector
    from going into the value ... otherwise I needed a special case in many places.

    Also notice, that ST/X Floats are what Doubles are in ST-80. The reason for doing this
    was to be compatible to both Digitalk, Squeak AND ParcPlace smalltalk implementations
    (ParcPlace uses a 4-byte Float and an 8-byte Double class, in contrast to
     Digitalk and Squeak, which have an 8-byte Float class).
    Thus, by providing an 8-byte Float class, code would not loose precicion
    (although some memory is wasted when porting from VW).
    Notice that ST/X provides an alias called Double, and an extra ShortFloat class, which has 4-byte
    instances.

    Mixed mode arithmetic:
	float op float       -> float
	float op fix         -> float
	float op fraction    -> float
	float op integer     -> float
	float op shortFloat  -> float
	float op longFloat   -> longFloat
	float op complex     -> complex

    Representation:
	    64bit double precision IEEE floats
	    53 bit mantissa,
	    11 bit exponent,
	    15 decimal digits (approx)

    Range and Precision of Storage Formats: see LimitedPrecisionReal >> documentation

    [author:]
	Claus Gittinger

    [see also:]
	Number
	ShortFloat LongFloat Fraction FixedPoint Integer Complex
	FloatArray DoubleArray
"
!

errorHandling
"
    Floating point error handling and signalling depends on the systems
    (actually: the C-runtime systems) ability to handle floating point errors.
    Most systems report errors by raising an OS floatingPoint exception,
    which is mapped to a fpExceptionInterrupt in ST/X.
    However, some systems do return NaN as result.

    Currently, ST/X does not care specially for these systems - it maybe added
    easily, if there is sufficient customer interest, though.

    Try:
	|f1 f2|

	f1 := 1.0.
	f2 := 0.0.
	f1 / f2

    or:
	2 arcSin
"
! !

!Float class methodsFor:'instance creation'!

basicNew
    "return a new float - here we return 0.0
     - floats are usually NOT created this way ...
     Its implemented here to allow things like binary store & load
     of floats. (but even this support will go away eventually, its not
     a good idea to store the bits of a float - the reader might have a
     totally different representation - so floats will eventually be
     binary stored in a device independent format."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ERROR("trying to instantiate a float");
#else
    OBJ newFloat;

    __qMKFLOAT(newFloat, 0.0);
    RETURN (newFloat);
#endif /* not SCHTEAM */
%}
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver (class) and return it."

    ^ aNumber asFloat.
!

fastFromString:aString at:startIndex
    "return the next Float from the string starting at startIndex.
     No spaces are skipped.

     This is a specially tuned entry (using a low-level C-call), which
     returns garbage if the argument string is not a valid float number.
     It has been added to allow high speed string decomposition into numbers,
     especially for mass-data."

%{   /* NOCONTEXT */
     if (__isStringLike(aString) && __isSmallInteger(startIndex)) {
	char *cp = (char *)(__stringVal(aString));
	int idx = __intVal(startIndex) - 1;
	double atof();
	double val;

	if ((unsigned)idx < __stringSize(aString)) {
	    val = atof(cp + idx);
	    RETURN (__MKFLOAT(val));
	}
     }
%}.
     self primitiveFailed.

    "
     Float fastFromString:'123.45' at:1
     Float fastFromString:'123.45' at:2
     Float fastFromString:'123.45E4' at:1
     Float fastFromString:'hello123.45E4' at:6
     Float fastFromString:'12345' at:1
     Float fastFromString:'12345' at:2
     Float fastFromString:'12345' at:3
     Float fastFromString:'12345' at:4
     Float fastFromString:'12345' at:5
     Float fastFromString:'12345' at:6
     Float fastFromString:'12345' at:0
     Float fastFromString:'hello123.45E4' at:1

     Time millisecondsToRun:[
	100000 timesRepeat:[
	    Float readFrom:'123.45'
	]
     ]
    "

    "
     Time millisecondsToRun:[
	100000 timesRepeat:[
	    Float fastFromString:'123.45' at:1
	]
     ]
    "
!

fromIEEE32Bit: anInteger
    "creates a double, given the four native float bytes as an integer"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    REGISTER union {
	unsigned int    i;
	float           f;
    } r;

    r.i = __unsignedLongIntVal( anInteger );
    RETURN( __MKFLOAT((double)(r.f)) );
#endif
%}

    "
	ShortFloat fromIEEE32Bit:(ShortFloat pi digitBytesMSB:true) asInteger
    "
!

fromIEEE64Bit: anInteger
    "creates a double, given the four native float bytes as an integer"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    __uint64__  __unsignedLongLongIntVal(OBJ);

    REGISTER union {
	__uint64__  u64;
	double      d;
    } r;

    if (__unsignedLong64IntVal(anInteger, &r.u64))  {
	RETURN( __MKFLOAT(r.d) );
    }
#endif
%}.
    self primitiveFailed.

    "
	Float fromIEEE64Bit:(Float pi digitBytesMSB:true) asInteger
    "
!

fromInteger:anInteger
    "return a new float, given an integer value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (anInteger.isSmallInteger()) {
	return __c__._RETURN( STDouble._new( (double)(anInteger.longValue()) ));
    }
#else
    OBJ newFloat;

    if (__isSmallInteger(anInteger)) {
	double f = (double)__smallIntegerVal(anInteger);
	__qMKFLOAT(newFloat, f);   /* OBJECT ALLOCATION */
	RETURN (newFloat);
    }
#endif /* not SCHTEAM */
%}.
    ^ super fromInteger:anInteger

    "
     Float fromInteger:123
     Float fromInteger:(100 factorial)
     (100 factorial) asFloat
    "
!

fromNumber:aNumber
    ^aNumber asFloat
!

fromVAXFloatBytes:b1 b2:b2 b3:b3 b4:b4
    "creates a double, given the four vax float bytes to an ieee double.
     For NaNs and Infinity, nil is returned.
    "

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else

    REGISTER union {
	unsigned char   b[4];
	unsigned int    l;
	float           f;
    } r;

# ifdef __LSBFIRST__
    r.b[3] = __intVal( b2 );
    r.b[2] = __intVal( b1 );
    r.b[1] = __intVal( b4 );
    r.b[0] = __intVal( b3 );
# else
    r.b[0] = __intVal( b2 );
    r.b[1] = __intVal( b1 );
    r.b[2] = __intVal( b4 );
    r.b[3] = __intVal( b3 );
# endif
    if( (r.l & 0xff800000) != 0x80000000 )
    {
	if( (r.l & 0x7f800000) > 0x01000000 )
	    r.l -= 0x01000000;
	else
	    r.l = 0;

	RETURN( __MKFLOAT(r.f) );
    }
#endif
%}.
    ^ nil
! !

!Float class methodsFor:'accessing'!

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

!Float class methodsFor:'binary storage'!

readBinaryIEEEDoubleFrom:aStream
    "read a float from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 8-byte float.
     The bytes are read in the native byte order (i.e.lsb on intel)"

    |f|

    f := self basicNew.
    self readBinaryIEEEDoubleFrom:aStream into:f MSB:(UninterpretedBytes isBigEndian).
    ^ f

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Created: / 16-04-1996 / 20:59:59 / cg"
    "Modified: / 23-08-2006 / 16:00:42 / cg"
!

readBinaryIEEEDoubleFrom:aStream MSB:msbFirst
    "read a float from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 8-byte float.
     The bytes are read in the specified byte order"

    |f|

    f := self basicNew.
    self readBinaryIEEEDoubleFrom:aStream into:f MSB:msbFirst.
    ^ f

    "not part of libboss, as this is also used by others (TIFFReader)"
!

readBinaryIEEEDoubleFrom:aStream into:aBasicNewFloat
    "read the receiver's value from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 8-byte float.
     The bytes are read in the native byte order (i.e.lsb on intel)"

    ^ self readBinaryIEEEDoubleFrom:aStream into:aBasicNewFloat MSB:(UninterpretedBytes isBigEndian)
!

readBinaryIEEEDoubleFrom:aStream into:aFloat MSB:msb
    "read the receiver's value from the binary stream, aStream,
     interpreting the next bytes as an IEEE formatted 8-byte float.
     If msb is true, the stream bytes are most-significant-first."

    "
     this implementation is wrong: does not work on non-IEEE machines
     (to date all machines where ST/X is running on use
      IEEE float format. Will need more here, when porting ST/X to 370's)
    "
    self isIEEEFormat ifFalse:[self error:'unsupported operation'].

    (UninterpretedBytes isBigEndian == msb) ifFalse:[
	"swap the bytes"
	8 to:1 by:-1 do:[:i |
	    aFloat basicAt:i put:(aStream next)
	].
	^ self
    ].
    1 to:8 do:[:i |
	aFloat basicAt:i put:aStream next
    ]

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Modified: / 23-08-2006 / 16:00:37 / cg"
!

storeBinaryIEEEDouble:aFloat on:aStream
    "store aFloat as an IEEE formatted 8-byte float
     onto the binary stream, aStream.
     The bytes are written in the native byte order (i.e.lsb on intel)"

    self storeBinaryIEEEDouble:aFloat on:aStream MSB:(UninterpretedBytes isBigEndian)
!

storeBinaryIEEEDouble:aFloat on:aStream MSB:msb
    "store aFloat as an IEEE formatted 8-byte float
     onto the binary stream, aStream.
     If msb is true, the stream bytes are written most-significant-first."

    "
     this implementation is wrong: does not work on non-IEEE machines
     (to date all machines where ST/X is running on use
      IEEE float format. Need more here, when porting ST/X to 370's)
    "
    self isIEEEFormat ifFalse:[self error:'unsupported operation'].

    (UninterpretedBytes isBigEndian == msb) ifFalse:[
	"swap the bytes"
	8 to:1 by:-1 do:[:i |
	    aStream nextPut:(aFloat basicAt:i).
	].
	^ self
    ].
    1 to:8 do:[:i |
	aStream nextPut:(aFloat basicAt:i).
    ].

    "not part of libboss, as this is also used by others (TIFFReader)"

    "Modified: / 23-08-2006 / 16:00:47 / cg"
! !

!Float class methodsFor:'class initialization'!

initialize
    Pi isNil ifTrue:[
	DefaultPrintFormat := '.15'.  "/ print 15 valid digits
	Pi := 3.14159265358979323846264338327950288419716939937510582097494459.
	Halfpi := Pi / 2.0.
	HalfpiNegative := Halfpi negated.
	Twopi := Pi * 2.0.
	E := 2.7182818284590452353602874713526625.
	Sqrt2 := 1.41421356237309504880168872420969808.
	RadiansPerDegree := Pi / 180.0.
	Ln2 := 0.69314718055994530941723212145817657.
	Ln10 := 10.0 ln.
	MaxSmallInteger := super maxSmallInteger.
    ].

    "
     Pi := nil.
     self initialize
    "

    "
     DefaultPrintFormat := '.9'.
     Float pi printString.

     DefaultPrintFormat := '.6'.
     Float pi printString.
    "

    "Modified: / 07-06-2007 / 21:17:53 / cg"
! !

!Float class methodsFor:'constants'!

NaN
    "return the constant NaN (not a Number).
     Do not use (yet) - for now, this is only defined for a
     few selected architectures."

%{  /* NOCONTEXT */
#if defined(LINUX) && defined(__i386__)
# ifdef NAN
    RETURN (__MKFLOAT(NAN));
# else
    RETURN (__MKFLOAT(_SNAN));
# endif
#endif
%}.
    ^ super NaN

    "
     Float NaN
     Float NaN + 0.0
     Float NaN + Float NaN
     0.0 + Float NaN
    "
!

e
    "return the constant e as Float"

    "/ don't expect this many valid digits on all machines;
    "/ The actual precision is very CPU specific.

    ^ 2.7182818284590452353602874713526625
!

emax
    "Answer the maximum exponent for this representation."

    ^1023
!

emin
    "Answer the minimum exponent for this representation."

    ^ -1022
!

ln10
    "return the natural logarithm of 10;
     will return something like 2.30258509299405"

    ^ Ln10
!

ln2
    "return the natural logarithm of 2"

    "/ don't expect this many valid digits on all machines;
    "/ The actual precision is very CPU specific.

    ^ 0.69314718055994530941723212145817657.

    "Created: / 07-06-2007 / 21:11:55 / cg"
!

maxSmallInteger
    ^ MaxSmallInteger
!

pi
    "return the constant pi as Float"

    "/ don't expect this many valid digits on all machines;
    "/ The actual precision is very CPU specific.

    ^ 3.14159265358979323846264338327950288419716939937510582097494459

    "Modified: 23.4.1996 / 09:27:02 / cg"
!

sqrt2
    "/ don't expect this many valid digits on all machines;
    "/ The actual precision is very CPU specific.

    ^ 1.41421356237309504880168872420969808

    "Created: / 07-06-2007 / 21:12:33 / cg"
!

unity
    "return the neutral element for multiplication (1.0) as Float"

    ^ 1.0

    "Modified: 23.4.1996 / 09:27:09 / cg"
!

zero
    "return the neutral element for addition (0.0) as Float"

    ^ 0.0

    "Modified: 23.4.1996 / 09:27:15 / cg"
! !

!Float class methodsFor:'misc'!

getFPUControl
    "get the fpu control word."

%{
#ifdef __BORLANDC__
    unsigned int _control87();

    int result = _control87(0, 0);
    RETURN(__MKSMALLINT(result));
#endif
%}

    "
	self getFPUControl
    "
!

setFPUControl
    "set the fpu control word.
     We want 64 bit precision for long double here"

%{
#ifdef __BORLANDC__
#include <float.h>

    // Set precision to long double / 64bit
    int result = _control87(PC_64, MCW_PC);
    RETURN(__MKSMALLINT(result));
#endif
%}

    "
	self setFPUControl
    "
! !


!Float class methodsFor:'queries'!

exponentCharacter
    ^ $d
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Float

    "Modified: 23.4.1996 / 15:59:04 / cg"
!

numBitsInExponent
    "answer the number of bits in the exponent
     This is an IEEE float, where 11 bits are available:
	seeeeeee eeeemmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
    "

    ^ 11
!

numBitsInMantissa
    "answer the number of bits in the mantissa.
     This is an IEEE double, where 52 bits (the hidden one is not counted here) are available:
	seeeeeee eeeemmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm mmmmmmmm
    "

     ^ 52
!

precision
    "answer the precision of a Float (in bits)
     This is an IEEE double, where only the fraction from the normalized mantissa is stored
     and so there is a hidden bit and the mantissa is actually represented
     by 53 binary digits (although only 52 are needed in the binary representation)"

    ^  53

    "
     self numBitsInMantissa + 1
     self precision
    "
!

radix
    "answer the radix of a Floats exponent
     This is an IEEE float, which is represented as binary"

    ^ 2 "must be careful here, whenever ST/X is used on VAX or a 370"
! !


!Float methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.times(aNumber) );
    }
#else

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
    double result;

    if (__isSmallInteger(aNumber)) {
	result = __floatVal(self) * (double)(__intVal(aNumber));
retResult:
	__qMKFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    /* knowing that aNumber is not a SmallInt, we only need to check for nil;
     * then can use qIsXXX macros which saves us some checks
     */
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    result = __floatVal(self) * __floatVal(aNumber);
	    goto retResult;
	}
	if (__qIsShortFloat(aNumber)) {
	    result = __floatVal(self) * (double)(__shortFloatVal(aNumber));
	    goto retResult;
	}
    }
#endif
%}.
    ^ aNumber productFromFloat:self
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.plus(aNumber) );
    }
#else
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
    double result;

    if (__isSmallInteger(aNumber)) {
	result = __floatVal(self) + (double)(__intVal(aNumber));
retResult:
	__qMKFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    /* knowing that aNumber is not a SmallInt, we only need to check for nil;
     * then can use qIsXXX macros which saves us some checks
     */
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    result = __floatVal(self) + __floatVal(aNumber);
	    goto retResult;
	}
	if (__qIsShortFloat(aNumber)) {
	    result = __floatVal(self) + (double)(__shortFloatVal(aNumber));
	    goto retResult;
	}
    }
#endif
%}.
    ^ aNumber sumFromFloat:self
!

- aNumber
    "return the difference of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.minus(aNumber) );
    }
#else

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
    double result;

    if (__isSmallInteger(aNumber)) {
	result = __floatVal(self) - (double)(__intVal(aNumber));
retResult:
	__qMKFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    /* knowing that aNumber is not a SmallInt, we only need to check for nil;
     * then can use qIsXXX macros which saves us some checks
     */
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    result = __floatVal(self) - __floatVal(aNumber);
	    goto retResult;
	}
	if (__qIsShortFloat(aNumber)) {
	    result = __floatVal(self) - (double)(__shortFloatVal(aNumber));
	    goto retResult;
	}
    }
#endif
%}.
    ^ aNumber differenceFromFloat:self
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.quotient(aNumber) );
    }
#else

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
    double result, val;

    if (__isSmallInteger(aNumber)) {
	if (aNumber != __mkSmallInteger(0)) {
	    result = __floatVal(self) / ( (double)__intVal(aNumber)) ;
retResult:
	    __qMKFLOAT(newFloat, result);
	    RETURN ( newFloat );
	}
    } else if (__isFloatLike(aNumber)) {
	val = __floatVal(aNumber);
	if (val != 0.0) {
	    result = __floatVal(self) / val;
	    goto retResult;
	}
    } else if (__isShortFloat(aNumber)) {
	val = (double)(__shortFloatVal(aNumber));
	if (val != 0.0) {
	    result = __floatVal(self) / val;
	    goto retResult;
	}
    }
#endif
%}.
    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
	"
	 No, you shalt not divide by zero
	"
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber quotientFromFloat:self
!

abs
    "return the absolute value of the receiver
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.abs() );
#else

    OBJ newFloat;
    double val =__floatVal(self);

    if (val < 0.0) {
	__qMKFLOAT(newFloat, -val);
	RETURN ( newFloat );
    }
    RETURN (self);
#endif
%}.

    "
     3.0 abs
     -3.0 abs
    "
!

negated
    "return the receiver negated"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.negated() );
#else
    OBJ newFloat;
    double rslt = - __floatVal(self);

    __qMKFLOAT(newFloat, rslt);
    RETURN ( newFloat );
#endif
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
    double result, val;

    if (__isSmallInteger(aNumber)) {
	if (aNumber != __mkSmallInteger(0)) {
	    val = (double)__intVal(aNumber);
computeResult:
	    result = fmod(__floatVal(self), val) ;
	    __qMKFLOAT(newFloat, result);
	    RETURN ( newFloat );
	}
    } else if (__isFloatLike(aNumber)) {
	val = __floatVal(aNumber);
	if (val != 0.0) {
	    goto computeResult;
	}
    } else if (__isShortFloat(aNumber)) {
	val = (double)(__shortFloatVal(aNumber));
	if (val != 0.0) {
	    goto computeResult;
	}
#ifdef LONGFLOAT_KNOWN_HERE
    } else if (__isLongFloat(aNumber)) {
	long double lval;

	lval = (long double)(__longFloatVal(aNumber));
	if (val != 0.0) {
	    long double lResult;

	    lResult = fmodl((long double)(__floatVal(self)), lval);
	    __qMKLFLOAT(newFloat, lResult);
	    RETURN (newFloat);
	}
#endif
    }
%}.
    ((aNumber == 0) or:[aNumber = 0.0]) ifTrue:[
	"
	 No, you shalt not divide by zero
	"
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber remainderFromFloat:self
!

uncheckedDivide:aNumber
    "return the quotient of the receiver and the argument, aNumber.
     Do not check for divide by zero (return NaN or Infinity).
     This operation is provided for emulators of other languages/semantics,
     where no exception is raised for these results (i.e. Java).
     It is only defined if the argument's type is the same as the receiver's."

%{  /* NOCONTEXT */

    OBJ newFloat;
    double result, val;

    if (__isSmallInteger(aNumber)) {
	result = __floatVal(self) / ( (double)__intVal(aNumber)) ;
retResult:
	__qMKFLOAT(newFloat, result);
	RETURN ( newFloat );
    }
    if (__isFloatLike(aNumber)) {
	val = __floatVal(aNumber);
	result = __floatVal(self) / val;
	goto retResult;
    }
    if (__isShortFloat(aNumber)) {
	val = (double)(__shortFloatVal(aNumber));
	result = __floatVal(self) / val;
	goto retResult;
    }
%}.
    ^ aNumber quotientFromFloat:self

    "
      0.0 uncheckedDivide:0.0
      1.0 uncheckedDivide:0.0
      -1.0 uncheckedDivide:0.0
    "
! !


!Float methodsFor:'coercing & converting'!

asDouble
    "ST80 compatibility: return a double with the receiver's value.
     In ST/X, floats are the equivalent to ST80 doubles"

    ^ self
!

asFloat
    "return a float with same value - that's me"

    ^ self
!

asInteger
    "return an integer with same value - might truncate"

%{  /* NOCONTEXT */
    double dVal;

    dVal = __floatVal(self);
#ifdef __win32__
    if (! isnan(dVal))
#endif
    {
	if ((dVal >= (double)_MIN_INT) && (dVal <= (double)_MAX_INT)) {
	    RETURN ( __mkSmallInteger( (INT)dVal) );
	}
    }
%}.
    ^ super asInteger

    "12345.0 asInteger"
    "1e15 asInteger"
!

asLongFloat
    "return a longFloat with same value as receiver"

    ^ LongFloat fromFloat:self

    "
     123 asFloat asLongFloat
    "

    "Created: / 7.9.2001 / 13:43:04 / cg"
    "Modified: / 7.9.2001 / 13:43:16 / cg"
!

asShortFloat
    "return a shortFloat with same value as receiver.
     CAVEAT: should raise an error if the receiver exceeds the float range."

%{  /* NOCONTEXT */

    OBJ dummy = @global(ShortFloat);
    OBJ newFloat;
    float fVal = (float)__floatVal(self);

    __qMKSFLOAT(newFloat, fVal);
    RETURN ( newFloat );
%}.
    self primitiveFailed
!

asTrueFraction
    "Answer a fraction or integer that EXACTLY represents the receiver,
     a double precision IEEE floating point number.
     Floats are stored in the same form on all platforms.
     (Does not handle gradual underflow or NANs.)
     By David N. Smith with significant performance
     improvements by Luciano Esteban Notarfrancesco.
     (Version of 11April97)"

    |shifty sign expPart exp fraction fractionPart result zeroBitsCount|

    self isFinite ifFalse:[
	^ self asMetaNumber
"/        ^ self class
"/            raise:#domainErrorSignal
"/            receiver:self
"/            selector:#asTrueFraction
"/            arguments:#()
"/            errorString:'Cannot represent non-finite float as a fraction'.
    ].

    "Extract the bits of an IEEE double float "
    shifty := LargeInteger basicNew numberOfDigits:8.
    UninterpretedBytes isBigEndian ifTrue:[
"/        shifty := ((self longWordAt: 1) bitShift: 32) + (self longWordAt: 2).
	1 to:8 do:[:i | shifty digitAt:(9-i) put:(self basicAt:i)].
    ] ifFalse:[
	1 to:8 do:[:i | shifty digitAt:i put:(self basicAt:i)].
    ].

    " Extract the sign and the biased exponent "
    sign := (shifty bitShift: -63) = 0 ifTrue: [1] ifFalse: [-1].
    expPart := (shifty bitShift: -52) bitAnd: 16r7FF.

    " Extract fractional part; answer 0 if this is a true 0.0 value "
    fractionPart := shifty bitAnd:  16r000FFFFFFFFFFFFF.
    ( expPart=0 and: [ fractionPart=0 ] ) ifTrue: [ ^ 0  ].

    " Replace omitted leading 1 in fraction "
    fraction := fractionPart bitOr: 16r0010000000000000.

    "Unbias exponent: 16r3FF is bias; 52 is fraction width"
    exp := 16r3FF - expPart + 52.

    " Form the result. When exp>52, the exponent is adjusted by
      the number of trailing zero bits in the fraction to minimize
      the (huge) time otherwise spent in #gcd:. "
    exp negative ifTrue: [
	result := sign * (fraction bitShift: exp negated)
    ] ifFalse:[
	zeroBitsCount := fraction lowBit - 1.
	exp := exp - zeroBitsCount.
	exp <= 0 ifTrue: [
	    zeroBitsCount := zeroBitsCount + exp.
	    "exp := 0."   " Not needed; exp not refernced again "
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
     0.3 asTrueFraction          - as you can see, Float is not able to represent this exactly
     1.25 asTrueFraction         - but this one (it is a sum of powers of two)
     0.25 asTrueFraction
     -0.25 asTrueFraction
     3e37 asTrueFraction
     2e37 asTrueFraction
     1e37 asTrueFraction
     1e30 asTrueFraction
     Float NaN asTrueFraction
     Float infinity asTrueFraction
    "
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asFloat
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 80
! !

!Float methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.ltP(aNumber) );
    }
#else
    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */
    if (__isSmallInteger(aNumber)) {
	RETURN ( (__floatVal(self) < (double)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__floatVal(self) < __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__floatVal(self) < (double)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
#endif
%}.
    ^ aNumber lessFromFloat:self
!

<= aNumber
    "return true, if the argument is greater or equal"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.leP(aNumber) );
    }
#else
    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */
    if (__isSmallInteger(aNumber)) {
	RETURN ( (__floatVal(self) <= (double)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__floatVal(self) <= __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__floatVal(self) <= (double)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
#endif
%}.
    ^ self retry:#<= coercing:aNumber
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.eqNrP(aNumber) );
    }
#else

    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */
    if (__isSmallInteger(aNumber)) {
	RETURN ( (__floatVal(self) == (double)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__floatVal(self) == __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__floatVal(self) == (double)(__shortFloatVal(aNumber))) ? true : false );
	}
    } else {
	RETURN (false);
    }
#endif
%}.
    ^ aNumber equalFromFloat:self
!

> aNumber
    "return true, if the argument is less"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.gtP(aNumber) );
    }
#else
    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */
    if (__isSmallInteger(aNumber)) {
	RETURN ( (__floatVal(self) > (double)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__floatVal(self) > __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__floatVal(self) > (double)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
#endif
%}.
    ^ self retry:#> coercing:aNumber
!

>= aNumber
    "return true, if the argument is less or equal"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
	return context._RETURN( self.geP(aNumber) );
    }
#else
    /*
     * notice:
     * the following inline code handles some common cases,
     * and exists as an optimization, to speed up those cases.
     *
     * Conceptionally, (and for most other argument types),
     * mixed arithmetic is implemented by double dispatching
     * (see the message send at the bottom)
     */
    if (__isSmallInteger(aNumber)) {
	RETURN ( (__floatVal(self) >= (double)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__floatVal(self) >= __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__floatVal(self) >= (double)(__shortFloatVal(aNumber))) ? true : false );
	}
    }
#endif
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

    "
     mhmh take some of my value-bits to hash on
    "
    ^ (((self basicAt:8) bitAnd:16r1F) bitShift:24) +
      ((self basicAt:7) bitShift:16) +
      ((self basicAt:6) bitShift:8) +
      (((self basicAt:5) + (self basicAt:1) + (self basicAt:2)) bitAnd:16rFF)

    "
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

    INT64 ulpDiff;
    union {
        double d;
        INT64 i;
    } myself, otherFloat;
    int nEpsilon;
    double scaledEpsilon;

    if (!__isSmallInteger(nE)) {
        goto tryHarder;
    }

    nEpsilon =  __intVal(nE);
    scaledEpsilon = nEpsilon *__floatVal(@global(Epsilon));

    if (__isSmallInteger(aNumber)) {
        otherFloat.d = (double)(__intVal(aNumber));
    } else if (aNumber == nil) {
        RETURN(false)
    } else if (__qIsFloatLike(aNumber)) {
        otherFloat.d = (double)(__floatVal(aNumber));
    } else if (__qIsShortFloat(aNumber)) {
        otherFloat.d = (double)(__shortFloatVal(aNumber));
    } else {
        goto tryHarder;
    }

    myself.d = __floatVal(self);

    // Check if the numbers are really close -- needed
    // when comparing numbers near zero (ULP method below fails for numbers near 0!).
    if (fabs(myself.d - otherFloat.d) <= scaledEpsilon) {
        RETURN(true);
    }

    // if the signs differ, the numbers are different
    if ((myself.d >= 0) != (otherFloat.d >= 0)) {
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
    ^ aNumber isAlmostEqualToFromFloat:self nEpsilon:nE

    "
        67329.234 isAlmostEqualTo:67329.23400000001 nEpsilon:1
        1.0 isAlmostEqualTo:1.0001 nEpsilon:1
        1.0 isAlmostEqualTo:-1.0 nEpsilon:1
        1 isAlmostEqualTo:1.000000000000001 nEpsilon:1
        1 isAlmostEqualTo:1.000000000000001 nEpsilon:10
        1.0 isAlmostEqualTo:1 nEpsilon:1
        1.0 isAlmostEqualTo:1 asFraction nEpsilon:1
    "
!

~= aNumber
    "return true, if the arguments value are not equal"

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
    if (__isSmallInteger(aNumber)) {
	RETURN ( (__floatVal(self) != (double)(__intVal(aNumber))) ? true : false );
    }
    if (aNumber != nil) {
	if (__qIsFloatLike(aNumber)) {
	    RETURN ( (__floatVal(self) != __floatVal(aNumber)) ? true : false );
	}
	if (__qIsShortFloat(aNumber)) {
	    RETURN ( (__floatVal(self) != (double)(__shortFloatVal(aNumber))) ? true : false );
	}
    } else {
	RETURN ( true );
    }
%}.
    ^ super ~= aNumber
! !

!Float methodsFor:'mathematical functions'!

cbrt
    "return the cubic root of myself."

%{  /* NOCONTEXT */

#ifndef __win32__ /* seems to be not avail. in WIN32 math lib */
    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

    {
	__threadErrno = 0;
	rslt = cbrt(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
# endif /* WIN32 */
%}.
    ^ super cbrt

    "
     8 cbrt
     -8 cbrt
    "
!

exp
    "return e raised to the power of the receiver"

%{  /* NOCONTEXT */

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = exp(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#exp
	arguments:#()
	errorString:'bad receiver in exp'

    "Modified: / 16.11.2001 / 14:14:29 / cg"
!

ln
    "return the natural logarithm of myself.
     Raises an exception, if the receiver is less or equal to zero."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.log() );
#else

    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val > 0.0)
# endif
    {
	__threadErrno = 0;
	rslt = log(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#endif
%}.
    "
     an invalid value for logarithm
    "
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#ln
	arguments:#()
	errorString:'bad receiver in ln'

    "Modified: / 16.11.2001 / 14:14:33 / cg"
!

log10
    "return the base-10 logarithm of myself.
     Raises an exception, if the receiver is less or equal to zero."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.log10() );
#else

    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val > 0.0)
# endif
    {
	__threadErrno = 0;
	rslt = log10(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#endif
%}.
    "
     an invalid value for logarithm
    "
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#log10
	arguments:#()
	errorString:'bad receiver in log10'

    "Modified: / 16.11.2001 / 14:14:33 / cg"
!

raisedTo:aNumber
    "return self raised to the power of aNumber"

    |n|

    n := aNumber asFloat.
%{
    double rslt;
    OBJ newFloat;

    if (__isFloatLike(n)) {
	__threadErrno = 0;
	rslt = pow(__floatVal(self), __floatVal(n));
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
%}.
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

%{  /* NOCONTEXT */

    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

#ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val >= 0.0)
#endif
    {
	__threadErrno = 0;
	rslt = sqrt(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
%}.
    ^ self class
	raise:#imaginaryResultSignal
	receiver:self
	selector:#sqrt
	arguments:#()
	errorString:'bad (negative) receiver in sqrt'

    "
     10 sqrt
     -10 sqrt
    "

    "Modified: / 16.11.2001 / 14:14:43 / cg"
! !

!Float methodsFor:'printing & storing'!

printString
    "return a printed representation of the receiver;
     if not specified otherwise (by setting DefaultPrintFormat),
     6 valid digits are printed.
     LimitedPrecisonReal and its subclasses use #printString instead of
     #printOn: as basic print mechanism."

    ^ self printStringWithFormat:DefaultPrintFormat

    "
	Float pi printString.
	1.0 printString
	1.234 printString
	1e10 printString
	1.2e3 printString
	1.2e30 printString
	(1.0 uncheckedDivide:0) printString
	(0.0 uncheckedDivide:0) printString
	self pi printString.

	DecimalPointCharacter := $,.
	1.234 printString.
	1.0 printString.
	1e10 printString.
	1.2e3 printString.
	1.2e30 printString.
	(1.0 uncheckedDivide:0) printString.
	(0.0 uncheckedDivide:0) printString.
	DecimalPointCharacter := $.
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
    OBJ s;
    char *fmt;
    char fmtBuffer[20];
    int len;

    if (__isStringLike(format)) {
	fmt = (char *) __stringVal(format);
    } else {
	/*
	 * in case we get called with garbage ...
	 */
	fmt = ".15";
    }

    /*
     * build a printf format string
     */
    fmtBuffer[0] = '%';
    strncpy(fmtBuffer+1, fmt, 10);
#ifdef SYSV
    strcat(fmtBuffer, "lg");
#else
    strcat(fmtBuffer, "G");
#endif

    __BEGIN_PROTECT_REGISTERS__
    len = snprintf(buffer, sizeof(buffer), fmtBuffer, __floatVal(self));
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
	    if (cp && ((*cp == '.') || (*cp == ','))) {
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
	1.0 printString
	1.234 printString
	1e10 printString
	1.2e3 printString
	1.2e30 printString
	(1.0 uncheckedDivide:0) printString
	(0.0 uncheckedDivide:0) printString
	self pi printString.

	DecimalPointCharacter := $,.
	1.234 printString.
	1.0 printString.
	1e10 printString.
	1.2e3 printString.
	1.2e30 printString.
	(1.0 uncheckedDivide:0) printString.
	(0.0 uncheckedDivide:0) printString.
	DecimalPointCharacter := $.
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

	len = snprintf(buffer, sizeof(buffer), __stringVal(formatString), __floatVal(self));

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
     Float pi printfPrintString:'%%lg -> %lg'
     Float pi printfPrintString:'%%lf -> %lf'
     Float pi printfPrintString:'%%7.15lg -> %7.15lg'
     Float pi printfPrintString:'%%7.5lf -> %7.5lf'
     Float pi printfPrintString:'%%G -> %G'
     Float pi printfPrintString:'%%F -> %F'
     Float pi printfPrintString:'%%7.5G -> %7.5G'
     Float pi printfPrintString:'%%7.5F -> %7.5F'
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

    __BEGIN_PROTECT_REGISTERS__
#ifdef SYSV
    len = snprintf(buffer, sizeof(buffer), "%.17lg", __floatVal(self));
#else
    len = snprintf(buffer, sizeof(buffer), "%.17G", __floatVal(self));
#endif
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
	1.0 storeString
	0.1 storeString
	((Array new:10 withAll:0.1) inject:0 into:[:v :sumSoFar| sumSoFar + v]) storeString
	1.234 storeString
	1e10 storeString
	1.2e3 storeString
	1.2e30 storeString
	Float pi storeString
	(1.0 uncheckedDivide:0) storeString
	(0.0 uncheckedDivide:0) storeString

     notice that the storeString is NOT affected by DecimalPointCharacterForPrinting:

	DecimalPointCharacterForPrinting := $,.
	1.234 storeString.
	1.0 storeString.
	1e10 storeString.
	1.2e3 storeString.
	1.2e30 storeString.
	(1.0 uncheckedDivide:0) storeString.
	(0.0 uncheckedDivide:0) storeString.
	DecimalPointCharacterForPrinting := $.
    "
! !


!Float methodsFor:'private-accessing'!

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
	if (((unsigned INT)(indx)) < sizeof(double)) {
	    cp = (unsigned char *)(& (__FloatInstPtr(self)->f_floatvalue));
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
	    if (((unsigned INT)(indx)) < sizeof(double)) {
		cp = (unsigned char *)(& (__FloatInstPtr(self)->f_floatvalue));
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
	Therefore, on some machines, the first 4 bytes of a float are left unused,
	and the actual float is stored at index 5 .. 12.
	To hide this at one place, this method knows about that, and returns
	values as if this filler wasn't present."

%{  /* NOCONTEXT */

    RETURN (__mkSmallInteger(sizeof(double)));
%}.
! !

!Float methodsFor:'queries'!

nextFloat:count
    "answer the next float count places after (or before if count is negative) myself"

%{
    union {
	double d;
	INT64 i;
    } this;

    if (__isSmallInteger(count)) {
	this.d = __floatVal(self);
	if (isfinite(this.d))
	    this.i += __intVal(count);

	RETURN(__MKFLOAT(this.d));
    }
%}.
    self primitiveFailed:#badArgument

  "
     (1.0 nextFloat:1) storeString
     (67329.234 nextFloat:1) storeString
     (67329.234 asShortFloat nextFloat:1) storeString
     Float NaN nextFloat:100000
     Float infinity nextFloat:100000
  "
! !

!Float methodsFor:'special access'!

exponent
    "extract a normalized floats exponent.
     The returned value depends on the float-representation of
     the underlying machine and is therefore highly unportable.
     This is not for general use.
     This assumes that the mantissa is normalized to
     0.5 .. 1.0 and the float's value is: mantissa * 2^exp"

%{  /* NOCONTEXT */

    double frac;
    int exp;

    frac = frexp(__floatVal(self), &exp);
    RETURN (__mkSmallInteger(exp));
%}.

    "
     1.0 exponent
     2.0 exponent
     3.0 exponent
     4.0 exponent
     0.5 exponent
     0.4 exponent
     0.25 exponent
     0.2 exponent
     0.00000011111 exponent
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

    double frac;
    int exp;

    frac = frexp(__floatVal(self), &exp);
    RETURN (__MKFLOAT(frac));
%}.
    ^ super mantissa

    "
     1.0 exponent
     1.0 mantissa

     0.25 exponent
     0.25 mantissa

     0.00000011111 exponent
     0.00000011111 mantissa
    "
! !


!Float methodsFor:'testing'!

isFinite
    "return true, if the receiver is a finite float
     i.e. not NaN and not infinite."

%{  /* NOCONTEXT */

    /*
     * notice: on machines which do not provide
     * a finite() macro or function (WIN32),
     * this may always ret true here ...
     */
    RETURN (isfinite(__floatVal(self)) ? true : false)
%}.

    "
	1.0 isFinite
	self NaN isFinite
	self infinity isFinite
	(0.0 uncheckedDivide: 0.0) isFinite
	(1.0 uncheckedDivide: 0.0) isFinite
    "
!

isInfinite
    "return true, if the receiver is an infinite float (Inf).
     These are not created by ST/X float operations (they raise an exception);
     however, inline C-code could produce them ...
     Redefined here for speed"

%{  /* NOCONTEXT */

    double dV = __floatVal(self);

    /*
     * notice: on machines which do not provide
     * finite() & isnan() macros or functions (WIN32),
     * this may always ret false here ...
     */
#if defined(isinf)
    if (isinf(dV)) { RETURN (true); }
#else
    if (!isfinite(dV) && !isnan(dV)) { RETURN (true); }
#endif
%}.
    ^ false

    "
	1.0 isInfinite
	(0.0 uncheckedDivide: 0.0) isInfinite
	(1.0 uncheckedDivide: 0.0) isInfinite
	(-1.0 uncheckedDivide: 0.0) isInfinite
    "
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true


!

isNaN
    "return true, if the receiver is an invalid float (NaN - not a number).
     These are not created by ST/X float operations (they raise an exception);
     however, inline C-code could produce them ..."

%{  /* NOCONTEXT */

    RETURN (isnan(__floatVal(self)) ? true : false)
%}.

    "
	self NaN isNaN
	1.0 isNaN
	(0.0 uncheckedDivide: 0.0) isNaN
	(1.0 uncheckedDivide: 0.0) isNaN
	(-1.0 uncheckedDivide: 0.0) isNaN
    "
!

isNegativeZero
    "many systems have two float.Pnt zeros"

%{  /* NOCONTEXT */

#if defined(__BORLANDC__)
    union { double d; int i[2]; } __u;
   __u.d = __floatVal(self);
    RETURN ( (__u.d == 0.0 && __u.i[1] < 0) ? true : false );
#else
    RETURN ( (__floatVal(self) == 0.0 && signbit(__floatVal(self)) != 0) ? true : false );
#endif
%}.

    "
     0.0 isNegativeZero
     -0.0 isNegativeZero
     -1.0 isNegativeZero
     1.0 isNegativeZero
    "
!

negative
    "return true if the receiver is less than zero.
     -0.0 is positive for now."

%{  /* NOCONTEXT */

    RETURN ( __floatVal(self) < 0.0  ? true : false );
    // RETURN ( signbit(__floatVal(self)) != 0  ? true : false );
%}.

    "
	0.0 negative
	-0.0 negative
	1.0 negative
	-1.0 negative
	(1.0 uncheckedDivide: 0.0) negative
	(-1.0 uncheckedDivide: 0.0) negative
    "
!

numberOfBits
    "return the size (in bits) of the real;
     typically, 64 is returned here,
     but who knows ..."

%{  /* NOCONTEXT */

    RETURN (__mkSmallInteger (sizeof(double) * 8));
%}

    "
     1.2 numberOfBits
     1.2 asShortFloat numberOfBits
    "
!

positive
    "return true if the receiver is greater or equal to zero (not negative).
     0.0 and -0.0 are positive for now."

%{  /* NOCONTEXT */

    RETURN ( __floatVal(self) >= 0.0 ? true : false );
    // RETURN ( signbit(__floatVal(self)) == 0 ? true : false  );
%}.

    "
	0.0 positive
	-0.0 positive
	1.0 positive
	-1.0 positive
	(1.0 uncheckedDivide: 0.0) positive
	(-1.0 uncheckedDivide: 0.0) positive
    "
!

strictlyPositive
    "return true if the receiver is greater than zero"

%{  /* NOCONTEXT */

    RETURN ( (__floatVal(self) > 0.0) ? true : false );
%}
! !

!Float methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceFloat:self level:level from:referrer


! !

!Float methodsFor:'trigonometric'!

arcCos
    "return the arccosine of the receiver (as radians).
     Raises an exception, if the receiver is not in -1..1"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.acos() );
#else

    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if ((val >= -1.0) && (val <= 1.0))
# endif
    {
	__threadErrno = 0;
	rslt = acos(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcCos
	arguments:#()
	errorString:'bad receiver in arcCos'

    "
     -10 arcCos
     1 arcCos
    "

    "Modified: / 16.11.2001 / 14:14:13 / cg"
!

arcCosh
    "return the hyperbolic arccosine of the receiver."

    |useFallBack|

%{
#ifdef NO_ACOSH
    useFallBack = true;
#else
    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val >= 1.0)
# endif
    {
	__threadErrno = 0;
	rslt = acosh(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
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
     -10.0 arcCosh
     1.0 arcCosh
    "

    "Modified: / 16.11.2001 / 14:14:13 / cg"
!

arcSin
    "return the arcsine of myself (I am interpreted as radians).
     Raises an exception, if the receiver is not in -1..1"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.asin() );
#else

    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if ((val >= -1.0) && (val <= 1.0))
# endif
    {
	__threadErrno = 0;
	rslt = asin(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcSin
	arguments:#()
	errorString:'bad receiver in arcSin'

    "
     -10 arcSin
     1 arcSin
    "

    "Modified: / 16.11.2001 / 14:14:18 / cg"
!

arcSinh
    "return the hyperbolic arcsine of the receiver."

    |useFallBack|
%{
#ifdef NO_ASINH
    useFallBack = true;
#else
    double val, rslt;
    OBJ newFloat;

    val = __floatVal(self);

# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if (val >= 1.0)
# endif
    {
	__threadErrno = 0;
	rslt = asinh(val);
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
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
     -10.0 arcSinh
     1.0 arcSinh
    "
!

arcTan
    "return the arctangent of the receiver (as radians)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.atan() );
#else

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = atan(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcTan
	arguments:#()
	errorString:'bad receiver in arcTan'

    "Modified: / 16.11.2001 / 14:14:22 / cg"
!

arcTan2:x
    "return the atan2(self,x)"

%{  /* NOCONTEXT */

    double rslt;
    OBJ newFloat;

    if (__isFloat(x)) {
	__threadErrno = 0;
	rslt = atan2(__floatVal(self),__floatVal(x));
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
%}.
    x isFloat ifFalse:[
	^ self arcTan2:(x asFloat).
    ].

    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#arcTan2:
	arguments:(Array with:x)
	errorString:'bad receiver in arcTan2:'
!

arcTan: denominator
    (self = 0.0) ifTrue: [
	(denominator > 0.0)
	    ifTrue: [ ^ 0 ]
	    ifFalse: [ ^ Pi ]
    ].
    (denominator = 0.0) ifTrue: [
	(self > 0.0)
	    ifTrue: [ ^ Halfpi ]
	    ifFalse: [ ^ HalfpiNegative ]
    ].
    (denominator > 0)
	ifTrue: [ ^ (self / denominator) arcTan ]
	ifFalse: [ ^ ((self / denominator) arcTan) + Pi ]

    "Created: / 07-06-2007 / 21:10:32 / cg"
    "Modified: / 11-06-2007 / 12:58:34 / cg"
!

arcTanh
    "return the hyperbolic arctangent of the receiver."

    |useFallBack|
%{
#ifdef NO_ATANH
    useFallBack = true;
#else
    double val, rslt;
    OBJ newFloat;

    __threadErrno = 0;
    val = __floatVal(self);
# ifdef __win32__ /* to suppress the warnBox opened by win32 */
    if ((val >= -1.0) && (val <= 1.0))
# endif
    {
	rslt = atanh(__floatVal(self));
	if (! isnan(rslt))  /* Currently all our systems support isnan() */
# ifdef __osx__
	if (! isinf(rslt))
# endif
	{
	    if (__threadErrno == 0) {
		__qMKFLOAT(newFloat, rslt);
		RETURN ( newFloat );
	    }
	}
    }
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

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.cos() );
#else

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = cos(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#cos
	arguments:#()
	errorString:'bad receiver in cos'

    "Modified: / 16.11.2001 / 14:14:26 / cg"
!

cosh
    "return the hyperbolic cosine of the receiver"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.cosh() );
#else

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = cosh(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#cosh
	arguments:#()
	errorString:'bad receiver in cosh'
!

sin
    "return the sine of the receiver (interpreted as radians)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.sin() );
#else

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = sin(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#sin
	arguments:#()
	errorString:'bad receiver in sin'

    "Modified: / 16.11.2001 / 14:14:37 / cg"
!

sinh
    "return the hyperbolic sine of the receiver"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.sinh() );
#else

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = sinh(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#sinh
	arguments:#()
	errorString:'bad receiver in sinh'
!

tan
    "return the tangens of the receiver (interpreted as radians)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.tan() );
#else

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = tan(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
#endif
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#tan
	arguments:#()
	errorString:'bad receiver in tan'

    "Modified: / 16.11.2001 / 14:14:49 / cg"
!

tanh
    "return the hyperbolic tangens of the receiver"

%{  /* NOCONTEXT */

    double rslt;
    OBJ newFloat;

    __threadErrno = 0;
    rslt = tanh(__floatVal(self));
    if (! isnan(rslt))  /* Currently all our systems support isnan() */
    {
	if (__threadErrno == 0) {
	    __qMKFLOAT(newFloat, rslt);
	    RETURN ( newFloat );
	}
    }
%}.
    ^ self class
	raise:#domainErrorSignal
	receiver:self
	selector:#tanh
	arguments:#()
	errorString:'bad receiver in tanh'
! !

!Float methodsFor:'truncation & rounding'!

ceiling
    "return the smallest integer which is greater or equal to the receiver."

    |val|

%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    double dVal;

    dVal = ceil(__floatVal(self));
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((dVal >= (double)_MIN_INT) && (dVal <= (double)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) dVal ) );
    }
    __qMKFLOAT(val, dVal);
#endif
%}.
    ^ val asInteger
!

ceilingAsFloat
    "return the smallest integer-valued float greater or equal to the receiver.
     This is much like #ceiling, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another float-operation."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.ceiling() );
#else
    double dVal;
    OBJ v;

    dVal = ceil(__floatVal(self));
    __qMKFLOAT(v, dVal);
    RETURN (v);
#endif
%}
    "
     0.5 ceilingAsFloat
     -0.5 ceilingAsFloat
     -1.5 ceilingAsFloat
    "
!

floor
    "return the integer nearest the receiver towards negative infinity."

    |val|

%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    double dVal;

    dVal = floor(__floatVal(self));
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((dVal >= (double)_MIN_INT) && (dVal <= (double)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) dVal ) );
    }
    __qMKFLOAT(val, dVal);
#endif
%}.
    ^ val asInteger

    "
     0.5 floor
     0.5 floorAsFloat
     -0.5 floor
     -0.5 floorAsFloat
    "
!

floorAsFloat
    "return the integer nearest the receiver towards negative infinity as a float.
     This is much like #floor, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another float-operation."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.floor() );
#else
    double dVal;
    OBJ v;

    dVal = floor(__floatVal(self));
    __qMKFLOAT(v, dVal);
    RETURN (v);
#endif
%}

    "
     0.5 floor
     0.5 floorAsFloat
     -0.5 floor
     -0.5 floorAsFloat
    "
!

fractionPart
    "extract the after-decimal fraction part.
     such that (self truncated + self fractionPart) = self"

%{  /* NOCONTEXT */

    double modf(double, double*);
    double frac, trunc;

    __threadErrno = 0;
    frac = modf(__floatVal(self), &trunc);
    if (! isnan(frac)) {
	if (__threadErrno == 0) {
	    RETURN (__MKFLOAT(frac));
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
     1.6 fractionPart + 1.6 truncated
     -1.6 fractionPart + -1.6 truncated

     1.0 fractionPart
     2.0 fractionPart
     3.0 fractionPart
     4.0 fractionPart
     0.5 fractionPart
     0.25 fractionPart
     3.14159 fractionPart
     12345673.14159 fractionPart
     123456731231231231.14159 fractionPart

     3.14159 fractionPart + 3.14159 truncated

     12345673.14159 fractionPart + 12345673.14159 truncated

     123456731231231231.14159 fractionPart + 123456731231231231.14159 truncated
    "
!

rounded
    "return the receiver rounded to the nearest integer"

    |val|

%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    double dVal;

    dVal = __floatVal(self);
    if (dVal < 0.0) {
	dVal = ceil(dVal - 0.5);
    } else {
	dVal = floor(dVal + 0.5);
    }
    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((dVal >= (double)_MIN_INT) && (dVal <= (double)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) dVal ) );
    }
    __qMKFLOAT(val, dVal);
#endif
%}.
    ^ val asInteger

    "
     0.4 rounded
     0.5 rounded
     0.6 rounded
     -0.4 rounded
     -0.5 rounded
     -0.6 rounded
    "
!

roundedAsFloat
    "return the receiver rounded to the nearest integer as a float.
     This is much like #rounded, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another
     float-operation."

    |val|

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.round() );
#else
    double dVal;
    OBJ v;

    dVal = __floatVal(self);
    if (dVal < 0.0) {
	dVal = ceil(dVal - 0.5);
    } else {
	dVal = floor(dVal + 0.5);
    }
    __qMKFLOAT(v, dVal);
    RETURN (v);
#endif
%}

    "
     0.5 rounded
     -0.5 rounded
     0.5 roundedAsFloat
     -0.5 roundedAsFloat
    "
!

truncated
    "return the receiver truncated towards zero as an integer"

    |val|

%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    double dVal;

    dVal = __floatVal(self);
    if (dVal < 0.0) {
	dVal = ceil(dVal);
    } else {
	dVal = floor(dVal);
    }

    /*
     * ST-80 (and X3J20) returns integer.
     */
    if ((dVal >= (double)_MIN_INT) && (dVal <= (double)_MAX_INT)) {
	RETURN ( __mkSmallInteger( (INT) dVal ) );
    }
    __qMKFLOAT(val, dVal);
#endif
%}.
    ^ val asInteger

    "
     0.5 truncated
     -0.5 truncated
     0.5 truncatedAsFloat
     -0.5 truncatedAsFloat
    "

!

truncatedAsFloat
    "return the receiver truncated towards zero as a float.
     This is much like #truncated, but avoids a (possibly expensive) conversion
     of the result to an integer.
     It may be useful, if the result is to be further used in another
     float-operation."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.truncated() );
#else
    double dVal;
    OBJ v;

    dVal = __floatVal(self);
    if (dVal < 0.0) {
	dVal = ceil(dVal);
    } else {
	dVal = floor(dVal);
    }
    __qMKFLOAT(v, dVal);
    RETURN (v);
#endif
%}

    "
     0.5 truncated
     -0.5 truncated
     0.5 truncatedAsFloat
     -0.5 truncatedAsFloat
    "

! !

!Float class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Float initialize!

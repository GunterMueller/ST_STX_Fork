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

Integer subclass:#SmallInteger
	instanceVariableNames:''
	classVariableNames:'ZeroString'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!SmallInteger primitiveDefinitions!
%{
#include <stdio.h>
%}
! !

!SmallInteger class methodsFor:'documentation'!

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
    SmallIntegers are Integers in the range of at least +/- 2^30
    i.e. 31 bits, but this is not a guaranteed:
        on an alpha or x86_64, 63 bits are used, if the system was configured for 64bit mode.
        under the Schteam-VM, 64 bits are used (i.e. a full long integer)

    These are no real objects - they have no instances (not even storage !!)
    and cannot be subclassed.
    The reason is to save both storage and runtime by not boxing and
    garbage collecting SmallIntegers in the system. 
    SmallInts are marked by having the TAG_INT
    bit set, in contrast to all other objects which do not.
    Since this knowledge is hardwired into the system (and there is no
    class-field stored with SmallIntegers) there can be no subclass of
    SmallInteger (sorry).

    If you really need this kind of thing, create a subclass of Integer,
    with an instance variable holding the value.

    Because the range and sharing of SmallIntegers is different among implementations
    (both in different dialects, and in different architectures within the Smalltalk/X family),
    you should not depend on the identity of two integers with the same value.
    For portable code, when comparing integers, use #'=' and #'~=' (instead of #'==' / #'~~'), 
    unless you are comparing very small integers in the -1024 .. 0 .. 1024 range.

    [author:]
        Claus Gittinger

    [see also:]
        Number
        Float Fraction FixedPoint
        LargeInteger
"
! !

!SmallInteger class methodsFor:'instance creation'!

basicNew
    "catch instance creation
     - SmallIntegers cannot be created with new"

    self error:'instances of SmallInteger cannot be created with new'
!

basicNew:size
    "catch instance creation
     - SmallIntegers cannot be created with new"

    self error:'instances of SmallInteger cannot be created with new'
! !

!SmallInteger class methodsFor:'bit mask constants'!

bitMaskFor:index
    "return a bitmask for the index's bit (index starts at 1)"

    (index between:1 and:SmallInteger maxBits) ifFalse:[
        ^ SubscriptOutOfBoundsSignal
                raiseRequestWith:index
                errorString:'index out of bounds'
    ].
    ^ 1 bitShift:(index - 1)
! !

!SmallInteger class methodsFor:'class initialization'!

initialize
    ZeroString := '0'
! !

!SmallInteger class methodsFor:'constants'!

maxBits
    "return the number of bits in instances of me.
     For very special uses only - not constant across implementations"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    // longs are always 64bits
    return context._RETURN ( STInteger._new(64) );
#else
    RETURN ( __mkSmallInteger(N_INT_BITS) );
#endif
%}
    "
     SmallInteger maxBits
    "
!

maxBytes
    "return the number of bytes in instances of me.
     For very special uses only - not constant across implementations.
     Notice: this is inlined by the compiler(s) as a constant,
     therefore, a query like 'SmallInteger maxBytes == 8'
     costs nothing; it is compiled in as a constant."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    // longs are always 8 bytes
    return context._RETURN ( STInteger._new(8) );
#else
    RETURN ( __mkSmallInteger(N_INT_BITS / 8 + 1) );
#endif
%}
    "
     SmallInteger maxBytes
    "
!

maxVal
    "return the largest Integer representable as SmallInteger.
     For very special uses only - not constant across implementations"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN ( STInteger._MAX_INTVAL );
#else
    RETURN ( __mkSmallInteger(_MAX_INT) );
#endif
%}
    "
     SmallInteger maxVal
    "
!

minVal
    "return the smallest Integer representable as SmallInteger.
     For very special uses only - not constant across implementations"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN ( STInteger._MIN_INTVAL );
#else
    RETURN ( __mkSmallInteger(_MIN_INT) );
#endif
%}
    "
     SmallInteger minVal
    "
! !

!SmallInteger class methodsFor:'queries'!

canBeSubclassed
    "return true, if its allowed to create subclasses of the receiver.
     Return false here - since it is NOT possible for SmallInteger
     (due to the tagged representation of SmallIntegers)"

    ^ false

    "Modified: / 5.11.1998 / 16:11:27 / cg"
!

hasImmediateInstances
    "return true if this class has immediate instances
     i.e. if the instances are represented in the pointer itself and
     no real object header/storage is used for the object.
     Redefined from Behavior"

    ^ true

    "Created: 3.6.1997 / 12:01:26 / cg"
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned."

    ^ true

    "Modified: 23.4.1996 / 16:00:33 / cg"
! !

!SmallInteger methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.times( aNumber ));
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

    INT myValue, otherValue;
    unsigned INT productLow, productHi;
    int negative;

    myValue = __intVal(self);

#   define low16Bits(foo)  ((foo) & 0xFFFF)
#   define hi16Bits(foo)   ((foo) >> 16)
#   define low32Bits(foo)  ((foo) & 0xFFFFFFFFL)
#   define hi32Bits(foo)   ((foo) >> 32)

    /*
     * can we use long long arithmetic ?
     *
     * long-long arithmetic seems to be buggy with some systems
     * (took me a while to find this out :-(
     * (try 10000 * 10000)
     */
# if defined(__sparc__) && defined(__GNUC__) && (__GNUC__ >= 2)
#  define USE_LONGLONG_FOR_MUL
# endif

# if defined(__i386__) && defined(__GNUC__) && (__GNUC__ >= 2)
#  define USE_LONGLONG_FOR_MUL
# endif

    if (__isSmallInteger(aNumber)) {
        otherValue = __intVal(aNumber);

# if defined(USE_LONGLONG_FOR_MUL)
        {
#  if defined(__alpha__) && !defined(__alpha64__)
#   define LONGLONG      INT64
#  else
#   define LONGLONG      long long
#  endif
            LONGLONG product;

            product = (LONGLONG)myValue * (LONGLONG)otherValue;
            if ((product >= (LONGLONG)_MIN_INT)
             && (product <= (LONGLONG)_MAX_INT)) {
                RETURN ( __mkSmallInteger((INT)product) );
            }
            if (product < 0) {
                negative = -1;
                product = -product;
            } else {
                negative = 1;
            }
            productHi = product >> 32;
            productLow = product & 0xFFFFFFFFLL;
        }
# else /* no long-long */
        negative = 1;
        if (myValue < 0) {
            negative = -1;
            myValue = -myValue;
        }
        if (otherValue < 0) {
            negative = -negative;
            otherValue = -otherValue;
        }

#  if defined(__GNUC__) && defined(__mc68k__)
        asm ("mulu%.l %3,%1:%0"
                : "=d"  ((unsigned long)(productLow)),
                  "=d"  ((unsigned long)(productHi))
                : "%0"  ((unsigned long)(myValue)),
                  "dmi" ((unsigned long)(otherValue)));
#  else
#   if defined (__GNUC__) && defined(__x86__)
        asm ("mull %3"
                : "=a"  ((unsigned long)(productLow)),
                  "=d"  ((unsigned long)(productHi))
                : "%0"  ((unsigned long)(myValue)),
                  "rm"  ((unsigned long)(otherValue)));
#   else
#    if defined(__win32__) && defined(__BORLANDC__)
        asm {
            mov   eax, myValue
            mov   edx, otherValue
            mul   edx
            mov   productLow, eax
            mov   productHi, edx
        }
#    else /* generic */
        {
            unsigned INT pHH, pHL, pLH, pLL;
            unsigned INT low1, low2, hi1, hi2;
            unsigned INT t;

            /* unsigned multiply myValue * otherValue -> productHi, productLow
             *
             * this is too slow:
             * since most machines can do 32*32 to 64 bit multiply,
             * (or at least 32*32 with Overflow check)
             * - need more assembler (inline) functions here
             */
#     if __POINTER_SIZE__ == 8
            low1 = low32Bits((unsigned INT)myValue);
            hi1 = hi32Bits((unsigned INT)myValue);
            low2 = low32Bits((unsigned INT)otherValue);
            hi2 = hi32Bits((unsigned INT)otherValue);
#      define LLMASK 0xC000000000000000LL
#     else
            low1 = low16Bits((unsigned INT)myValue);
            hi1 = hi16Bits((unsigned INT)myValue);
            low2 = low16Bits((unsigned INT)otherValue);
            hi2 = hi16Bits((unsigned INT)otherValue);
#      define LLMASK 0xC0000000L
#     endif

            pLH = low1 * hi2;
            pHL = hi1 * low2;
            pLL = low1 * low2;
            pHH = hi1 * hi2;

            /*
             * the common case ...
             */
            if ((pHL == 0)
             && (pLH == 0)
             && (pHH == 0)
             && ((pLL & LLMASK) == 0)) {
                if (negative < 0) {
                    RETURN ( __mkSmallInteger(- ((INT)pLL)) );
                }
                RETURN ( __mkSmallInteger((INT)pLL) );
            }

            /*
             *   pHH |--------|--------|
             *   pLH          |--------|--------|
             *   pHL          |--------|--------|
             *   pLL                   |--------|--------|
             */

#     if __POINTER_SIZE__ == 8
            t = low32Bits(pLH) + low32Bits(pHL) + hi32Bits(pLL);
            productLow = (t << 32) + low32Bits(pLL);
            productHi = pHH + hi32Bits(t) + hi32Bits(pHL) + hi32Bits(pLH);
#     else
            t = low16Bits(pLH) + low16Bits(pHL) + hi16Bits(pLL);
            productLow = (t << 16) + low16Bits(pLL);
            productHi = pHH + hi16Bits(t) + hi16Bits(pHL) + hi16Bits(pLH);
#     endif
        }
#    endif /* ! __win32__ */
#   endif /* ! (__GNUC__ && __x86__) */
#  endif /* ! (__GNUC__ && __mc68k__) */

        if (productHi == 0) {
            if (negative < 0) {
                if (productLow <= -(_MIN_INT)) {
                    RETURN ( __mkSmallInteger(-((INT)productLow)) );
                }
            } else {
                if (productLow <= _MAX_INT) {
                    RETURN ( __mkSmallInteger(productLow) );
                }
            }
        }
# endif /* ! USE_LONGLONG */

# if __POINTER_SIZE__ == 8
        RETURN (__MKLARGEINT128(negative, productLow, productHi));
# else
        RETURN (__MKLARGEINT64(negative, productLow, productHi));
# endif
    } else if (__isFloatLike(aNumber)) {
        OBJ newFloat;
        double val = (double)myValue * __floatVal(aNumber);

        __qMKFLOAT(newFloat, val);
        RETURN ( newFloat );
    } else if (__isShortFloat(aNumber)) {
        OBJ newFloat;
        float val = (float)myValue * __shortFloatVal(aNumber);

        __qMKSFLOAT(newFloat, val);
        RETURN ( newFloat );
    } else if (__isFractionLike(aNumber)) {
        OBJ t = __FractionInstPtr(aNumber)->f_numerator;

        if (myValue == 0) {
            RETURN(__mkSmallInteger(0));
        }

        if (__isSmallInteger(t)) {
            INT num = __intVal(t);
            t = __FractionInstPtr(aNumber)->f_denominator;
            if (__isSmallInteger(t)) {
                INT prod = myValue * num;
                if (prod / myValue == num) { // check for overflow
                    INT den = __intVal(t);
                    INT quo = prod / den;
                    if (quo * den == prod) {        // check for integer result
                        RETURN ( __mkSmallInteger(quo) );
                    }
                }
            }
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ aNumber productFromInteger:self

    "
        3 * (1/2)
        6 * (1/2)
        6 * (-1/2)
   "
!

+ aNumber
    "return the sum of the receiver's value and the argument's value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.plus( aNumber ));
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
# ifdef _ADD_IO_IO
        RETURN ( _ADD_IO_IO(self, aNumber) );
# else
        REGISTER INT sum;

        sum =  __intVal(self) + __intVal(aNumber);
        if (__ISVALIDINTEGER(sum)) {
            RETURN ( __mkSmallInteger(sum) );
        }
        RETURN ( __MKLARGEINT(sum) );
# endif
    }
    if (__isFloatLike(aNumber)) {
        OBJ newFloat;
        double val = (double)__intVal(self) + __floatVal(aNumber);

        __qMKFLOAT(newFloat, val);
        RETURN ( newFloat );
    }
    if (__isShortFloat(aNumber)) {
        OBJ newFloat;
        float val = (float)__intVal(self) + __shortFloatVal(aNumber);

        __qMKSFLOAT(newFloat, val);
        RETURN ( newFloat );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ aNumber sumFromInteger:self
!

- aNumber
    "return the difference of the receiver's value and the argument's value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.minus( aNumber ));
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
# ifdef _SUB_IO_IO
        RETURN ( _SUB_IO_IO(self, aNumber) );
# else
        REGISTER INT diff =  __intVal(self) - __intVal(aNumber);
        if (__ISVALIDINTEGER(diff)) {
            RETURN ( __mkSmallInteger(diff) );
        }
        RETURN ( __MKLARGEINT(diff) );
# endif
    }
    if (__isFloatLike(aNumber)) {
        OBJ newFloat;
        double val = (double)__intVal(self) - __floatVal(aNumber);

        __qMKFLOAT(newFloat, val);
        RETURN ( newFloat );
    }
    if (__isShortFloat(aNumber)) {
        OBJ newFloat;
        float val = (float)__intVal(self) - __shortFloatVal(aNumber);

        __qMKSFLOAT(newFloat, val);
        RETURN ( newFloat );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ aNumber differenceFromInteger:self
!

/ aNumber
    "return the quotient of the receiver's value and the argument's value"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.quotient( aNumber ));
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

    INT t, val;
    double dval;
    INT myValue = __intVal(self);

    if (__isSmallInteger(aNumber)) {
        val = __intVal(aNumber);
        if (val != 0) {
            t = myValue / val;
# ifdef GOOD_OPTIMIZER
            if (myValue % val == 0) {
# else
            /* this is stupid - all I want is to look for a remainder ...
               but most compilers are too stupid and generate an extra modulus
               instruction for "if (me % val)".
               Even if most divide instructions already leave the remainder in
               some register.
               Therefore I use a multiplication which is faster than a modulo
               on most machines. Hint to GNU people :-)
            */
            if ((t * val) == myValue) {
# endif
                RETURN ( __mkSmallInteger(t) );
            }
        }
    } else {
        if (__isFloatLike(aNumber)) {
            dval = __floatVal(aNumber);
            if (dval != 0.0) {
                OBJ newFloat;
                double val = (double)myValue / dval;

                __qMKFLOAT(newFloat, val);
                RETURN ( newFloat );
            }
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    aNumber isInteger ifTrue:[
        aNumber == 0 ifTrue:[
            ^ ZeroDivide raiseRequestWith:thisContext.
        ].
        ^ Fraction numerator:self denominator:aNumber
    ].
    ^ aNumber quotientFromInteger:self

    "
     8 / 4
     9 / 4
     9 // 4
     9 quo:4

     -8 / 4
     -9 / 4
     -9 // 4
     -9 quo:4
    "
!

// aNumber
    "return the integer part of the quotient of the receiver's value
     and the argument's value.
     The result is truncated toward negative infinity
     and will be negative, if the operands signs differ.
     The following is always true:
        (receiver // aNumber) * aNumber + (receiver \\ aNumber) = receiver

     Be careful with negative results: 9 // 4 -> 2, while -9 // 4 -> -3.
     Especially surprising (because of truncation toward negative infinity):
        -1 // 10 -> -1 (because -(1/10) is truncated towards next smaller integer, which is -1.
        -10 // 3 -> -4 (because -(10/3) is truncated towards next smaller integer, which is -4.

     See #quo: which truncates toward zero and returns -2 in the above case 
     and #rem: which is the corresponding remainder."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.quotientTruncated( aNumber ));
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

    INT divisor, rslt;
    INT dividend = __intVal(self);

    if (__isSmallInteger(aNumber)) {
        divisor = __intVal(aNumber);
        if (divisor != 0) {
            rslt = dividend / divisor;
            /*
             * Optimized to speed up positive result
             */
            if (rslt <= 0) {
                if (rslt == 0) {
                    if ((dividend ^ divisor) < 0) {
                        /*
                         * result (negative) has been truncated toward 0.
                         * Return -1, because we truncate toward negative inf.
                         */
                         rslt = -1;
                    }
                } else {
                    /*
                     * If result (negative) has been truncated toward 0,
                     * subtract 1, because we truncate toward negative inf.
                     */
                    if (divisor > 0) {
                        if (rslt * divisor > dividend) {
                            rslt--;
                        }
                    } else {
                        if (rslt * divisor < dividend) {
                            rslt--;
                        }
                    }
                }
            }
            RETURN ( __mkSmallInteger(rslt) );
        }
    } else {
        if (__isFractionLike(aNumber)) {
            OBJ t = __FractionInstPtr(aNumber)->f_numerator;
            if (__isSmallInteger(t)) {
                INT num = __intVal(t);
                t = __FractionInstPtr(aNumber)->f_denominator;
                if (__isSmallInteger(t)) {
                    INT den = __intVal(t);
                    INT prod;
#if 0 && defined(__GNUC__) // supported from GCC 5
                    if (!__builtin_mul_overflow(myself, den, &prod)) {
                        goto out;   // overflow, try harder...
                    }
#else
                    prod = dividend * den;
                    // make sure, that no overflow occurred
                    if (prod / den != dividend) {
                        goto out;   // overflow, try harder...
                    }
#endif
                    rslt = prod / num;

                    /*
                     * Optimized to speed up positive result
                     */
                    if (rslt <= 0) {
                        if (rslt == 0) {
                            if ((dividend ^ num) < 0) {
                                /*
                                 * result (negative) has been truncated toward 0.
                                 * Return -1, because we truncate toward negative inf.
                                 */
                                 rslt = -1;
                            }
                        } else {
                            /*
                             * If result (negative) has been truncated toward 0,
                             * subtract 1, because we truncate toward negative inf.
                             */
                            if (num > 0) {
                                if (rslt * num > prod) rslt--;
                            } else {
                                if (rslt * num < prod) rslt--;
                            }
                        }
                    }
                    RETURN ( __mkSmallInteger(rslt) );
                }
            }
        }
    }
out:;
#endif /* not __SCHTEAM__ */
%}.
    (aNumber = 0) ifTrue:[
        ^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber integerQuotientFromInteger:self

    "
     9 // 4     ~~ 2 ifTrue:[self halt].
     -9 // 4    ~~ -3 ifTrue:[self halt].
     9 // -4    ~~ -3 ifTrue:[self halt].
     -9 // -4   ~~ 2 ifTrue:[self halt].
     1 // 2     ~~ 0 ifTrue:[self halt].
     -1 // 2    ~~ -1 ifTrue:[self halt].
     1 // -2    ~~ -1 ifTrue:[self halt].
     -1 // -2   ~~ 0 ifTrue:[self halt].

     -7 // (4/3)
     -7 quo: (4/3)

     7 // (-4/3)
     7 quo: (-4/3)

     10000 // 3600000 ~~ 0 ifTrue:[self halt].
     12 // (1 / 1000000000000000000)
     12 // (1 / 100000000000000)
     12 // 0.00000000000001s

     9 quo:4   => 2
     -9 quo:4  => -2
     9 quo:-4  => -2
     -9 quo:-4 => 2
    "

    "Modified: / 09-08-2010 / 19:50:23 / cg"
!

\\ aNumber
    "Answer the integer remainder m defined by division with truncation toward
     negative infinity.
     m < |aNumber| AND there is an integer k with (k * aNumber + m) = self

     The returned remainder has the same sign as aNumber.
     The following is always true:
        (receiver // aNumber) * aNumber + (receiver \\ aNumber) = receiver

     Be careful with negative results: 9 // 4 -> 2, while -9 // 4 -> -3.
     Especially surprising:
        -1 \\ 10 -> 9  (because -(1/10) is truncated towards next smaller integer, which is -1,
                        and -1 multiplied by 10 gives -10, so we have to add 9 to get the original -1).
        -10 \\ 3 -> 2 (because -(10/3) is truncated towards next smaller integer, which is -4,
                        and -4 * 4 gives -12, so we need to add 2 to get the original -10.

     See #rem: which is the corresponding remainder for division via #quo:.

     Redefined here for speed."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.remainder( aNumber ));
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

    INT dividend, divisor, rem;

    if (__isSmallInteger(aNumber)
        && (divisor = __intVal(aNumber)) != 0) {
        /*
         * Note that the sign of something modulo a negative number is undefined
         * in C!
         */
        dividend = __intVal(self);
        rem = dividend % divisor;
        if (rem) {
            if ((rem ^ divisor) < 0) {
                /* sign of remainder is different from sign of divisor */
                rem = -rem;
            }
            if ((dividend ^ divisor) < 0) {
                /* different signs, so division would have returned a
                 * negative number.
                 * C rounds toward zero, this code will simulate
                 * rounding towards negative infinity.
                 */
                rem = divisor - rem;
            }
        }
        RETURN ( __mkSmallInteger(rem) );
    }
#endif /* not __SCHTEAM__ */
%}.
    (aNumber = 0) ifTrue:[
        ^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ aNumber moduloFromInteger:self

    "
     9 \\ 4  == 1 ifFalse:[self halt].
     -9 \\ 4 == 3 ifFalse:[self halt].
     9 \\ -4 == -3 ifFalse:[self halt].
     -9 \\ -4 == -1 ifFalse:[self halt].
     (9 rem:4) == 1 ifFalse:[self halt].
     (-9 rem:4) == -1 ifFalse:[self halt].
     1000 \\ 3600000 == 1000 ifFalse:[self halt]
    "

    "Modified: / 12-02-2012 / 20:43:40 / cg"
!

abs
    "return the absolute value of the receiver
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.abs());
#else
    INT val = __intVal(self);

    if (val >= 0) {
        RETURN (self);
    }
    if (val != _MIN_INT) {
        RETURN ( __mkSmallInteger(-val) );
    }
    /* only reached for minVal */
    RETURN( __MKLARGEINT(-_MIN_INT));
#endif
%}.
    ^ super abs
!

negated
    "return the negative value of the receiver
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.negated());
#else
    INT val = __intVal(self);

    if (val != _MIN_INT) {
        RETURN ( __mkSmallInteger(- val) );
    }
    /* only reached for minVal */
    RETURN (__MKLARGEINT( -_MIN_INT));
#endif
%}.
    ^ 0 - self
!

quo:aNumber
    "return the integer part of the quotient of the receiver's value
     and the argument's value. The result is truncated towards zero
     and negative, if the operands signs differ..
     The following is always true:
        (receiver quo: aNumber) * aNumber + (receiver rem: aNumber) = receiver
     For positive results, this is the same as #//,
     for negative results, the remainder is ignored.
     I.e.: '9 // 4 = 2' and '-9 // 4 = -3'
     in contrast: '9 quo: 4 = 2' and '-9 quo: 4 = -2'"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.quotient(aNumber));
#else
    if (__isSmallInteger(aNumber)) {
        INT val = __intVal(aNumber);
        if (val != 0) {
            RETURN ( __mkSmallInteger(__intVal(self) / val) );
        }
    } else {
        if (__isFractionLike(aNumber)) {
            OBJ t = __FractionInstPtr(aNumber)->f_numerator;
            if (__isSmallInteger(t)) {
                INT num = __intVal(t);
                t = __FractionInstPtr(aNumber)->f_denominator;
                if (__isSmallInteger(t)) {
                    INT den = __intVal(t);
                    INT myself = __intVal(self);
                    INT prod;
#if 0 && defined(__GNUC__) // supported from GCC 5
                    if (__builtin_mul_overflow(myself, den, &prod)) {
                        RETURN ( __mkSmallInteger(prod / num ));
                    }
#else
                    prod = myself * den;
                    // make sure, that no overflow occurred
                    if (prod / den == myself) {
                        RETURN ( __mkSmallInteger(prod / num ));
                    }
#endif
                }
            }
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    (aNumber = 0) ifTrue:[
        ^ ZeroDivide raiseRequestWith:thisContext.
    ].
    ^ self retry:#quo: coercing:aNumber

    "
     9 // 4
     -9 // 4
     9 quo:4
     -9 quo:4

     -7 // (4/3)
     -7 quo: (4/3)

     7 // (-4/3)
     7 quo: (-4/3)
    "
! !



!SmallInteger methodsFor:'bit operators'!

bitAnd:anInteger
    "return the bitwise-and of the receiver and the argument, anInteger"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.bitAnd(anInteger));
#else
    /* anding the tags doesn't change it */
    if (__isSmallInteger(anInteger)) {
        RETURN ( ((OBJ) ((INT)self & (INT)anInteger)) );
    }
#endif /* not __SCHTEAM__ */
%}.
    anInteger class == LargeInteger ifTrue:[
        ^ anInteger bitAnd:self
    ].
    ^ self retry:#bitAnd: coercing:anInteger

    "(2r001010100 bitAnd:2r00001111) radixPrintStringRadix:2"
!

bitClear:anInteger
    "return the bitwise-and of the receiver and the complement of the argument, anInteger,
     returning the receiver with bits of the argument cleared.
     (i.e. the same as self bitAnd:aMaskInteger bitInvert).
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitCleared:"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.bitClear(anInteger));
#else
    /* anding the tags doesn't change it */
    if (__isSmallInteger(anInteger)) {
        RETURN ( ((OBJ) (((INT)self & ~(INT)anInteger) | TAG_INT)) );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ self retry:#bitClear: coercing:anInteger

    "
     (2r001010100 bitClear:2r00001111) radixPrintStringRadix:2
     (2r111111111 bitClear:2r00001000) radixPrintStringRadix:2

     (2r001010100 bitAnd:2r00001111 bitInvert) radixPrintStringRadix:2
    "
!

bitCount
    "return the number of 1-bits in the receiver"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    long _v1, _v2;
    long _self = self.longValue();
    long _cnt;

    _v1 = _self & 0xFFFFFFFF;
    _v1 = _v1 - ((_v1 >> 1) & 0x55555555);
    _v1 = (_v1 & 0x33333333) + ((_v1 >> 2) & 0x33333333);
    _v1 = ((_v1 + (_v1 >> 4)) & 0x0F0F0F0F);

    _v2 = (_self >> 32) & 0xFFFFFFFF;
    _v2 = _v2 - ((_v2 >> 1) & 0x55555555);
    _v2 = (_v2 & 0x33333333) + ((_v2 >> 2) & 0x33333333);
    _v2 = ((_v2 + (_v2 >> 4)) & 0x0F0F0F0F);

    _cnt = ((_v1 * 0x01010101) >> 24) + ((_v2 * 0x01010101) >> 24);
    return __c__._RETURN( STInteger._qnew( (byte)(_cnt) ) );
#else
    unsigned int _cnt;

    // popcnt is slower
# if 0 // defined(__GNUC__) && (defined(__x86__) || defined(__x86_64__))
#  define ALGORIHTM_4
# else
#  define ALGORIHTM_3
# endif

# ifdef ALGORITHM_1
    // old k&r code; might be better if only one or two bits are set

    unsigned INT _self = __intVal(self);

    _cnt = 0;
    while (_self) {
        _cnt++;
        _self = _self & (_self - 1);
    }
# else

#  ifdef ALGORITHM_2
    // seems to be faster on the average (and has better worst case)

    static unsigned char table[] = { 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 };
    unsigned INT _self = __intVal(self);

    _cnt = 0;
    while (_self) {
        _cnt += table[ _self & 0x0F ];
        _self >>= 4;
    }
#  else

#   ifdef ALGORIHTM_3
    // the fastest, but hard (impossible) to understand (google for fastest bit count)
    unsigned INT _self = __intVal(self);

#    if __POINTER_SIZE__ == 8
    unsigned int _v1, _v2;

    _v1 = _self & 0xFFFFFFFF;
    _v1 = _v1 - ((_v1 >> 1) & 0x55555555);
    _v1 = (_v1 & 0x33333333) + ((_v1 >> 2) & 0x33333333);
    _v1 = ((_v1 + (_v1 >> 4)) & 0x0F0F0F0F);

    _v2 = (unsigned int)(_self >> 32);
    _v2 = _v2 - ((_v2 >> 1) & 0x55555555);
    _v2 = (_v2 & 0x33333333) + ((_v2 >> 2) & 0x33333333);
    _v2 = ((_v2 + (_v2 >> 4)) & 0x0F0F0F0F);

    _cnt = ((_v1 * 0x01010101) >> 24) + ((_v2 * 0x01010101) >> 24);
#    else
    _cnt = _self - ((_self >> 1) & 0x55555555);
    _cnt = (_cnt & 0x33333333) + ((_cnt >> 2) & 0x33333333);
    _cnt = ((_cnt + (_cnt >> 4)) & 0x0F0F0F0F);
    _cnt = (_cnt * 0x01010101) >> 24;
#    endif
#   else

#    ifdef ALGORIHTM_4
     // using the popcnt instruction (x86 only); strange enough, this is slower than ALGO3
#     if __POINTER_SIZE__ == 8
    unsigned INT _v;

#    define _POPCNT(__op)                      \
    ({                                          \
        INT __rslt;                             \
        asm("xor     %%rax,%%rax        \n      \
             popcnt %1,%%rax           \n      \
                        "  : "=a" (__rslt)      \
                           : "g" ((INT)(__op))    \
                           : "cc");             \
        (OBJ)__rslt;                            \
     })

    _v = (INT)self;
    _cnt = _POPCNT(_v);
    _cnt--; // one too many due to tag
#     else
#    define _POPCNT(__op)                      \
    ({                                          \
        INT __rslt;                             \
        asm("xor     %%eax,%%eax        \n      \
             popcnt  %1,%%eax           \n      \
                        "  : "=a" (__rslt)      \
                           : "g" ((INT)(__v))   \
                           : "cc");             \
        (OBJ)__rslt;                            \
     })

    _v = (INT)self;
    _cnt = _POPCNT(_v);
    _cnt--; // one too many due to tag
#     endif
#    else
      error error error
#    endif
#   endif
#  endif
# endif

    RETURN ( __MKSMALLINT(_cnt));
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitCount.

    "

     1 to:1000000 do:[:n |
        self assert:(n bitCount = ((n printStringRadix:2) occurrencesOf:$1))
     ].

     #( 16r00000000
        16r00010000 16r00100000 16r01000000 16r10000000
        16r00020000 16r00200000 16r02000000 16r20000000
        16r00040000 16r00400000 16r04000000 16r40000000
        16r00080000 16r00800000 16r08000000 16r80000000

        16rFFFFFFFF 16r7FFFFFFF 16r3FFFFFFF 16r1FFFFFFF
        16rEEEEEEEE 16r7EEEEEEE 16r3EEEEEEE 16r1EEEEEEE
        16rDDDDDDDD 16r7DDDDDDD 16r3DDDDDDD 16r1DDDDDDD
        16rCCCCCCCC 16r7CCCCCCC 16r3CCCCCCC 16r1CCCCCCC

        16r8000000000010000 16r8000000000100000 16r8000000001000000 16r8000000010000000
        16r8000000000020000 16r8000000000200000 16r8000000002000000 16r8000000020000000
        16r8000000000040000 16r8000000000400000 16r8000000004000000 16r8000000040000000
        16r8000000000080000 16r8000000000800000 16r8000000008000000 16r8000000080000000

        16r80000000FFFFFFFF 16r800000007FFFFFFF 16r800000003FFFFFFF 16r800000001FFFFFFF
        16r80000000EEEEEEEE 16r800000007EEEEEEE 16r800000003EEEEEEE 16r800000001EEEEEEE
        16r80000000DDDDDDDD 16r800000007DDDDDDD 16r800000003DDDDDDD 16r800000001DDDDDDD
        16r80000000CCCCCCCC 16r800000007CCCCCCC 16r800000003CCCCCCC 16r800000001CCCCCCC

        16rFFFFFFFFFFFFFFFF 16r7FFFFFFFFFFFFFFF 16r3FFFFFFFFFFFFFFF 16r1FFFFFFFFFFFFFFF
     ) do:[:n |
        self assert:(n bitCount = ((n printStringRadix:2) occurrencesOf:$1))
     ]

     1 to:10000000 do:[:n |
        (n bitCount)
     ]
    "

    "Modified: / 09-01-2012 / 19:12:41 / cg"
!

bitInvert
    "return the value of the receiver with all bits inverted.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Could be named #withBitsInverted"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    long _self = self.longValue();
    return __c__._RETURN( STInteger._new( ~_self ) );
#else
    /* invert anything except tag bits */
    RETURN ( ((OBJ) ((INT)self ^ ~TAG_MASK)) );
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitInvert
!

bitInvertByte
    "return a new integer, where the low 8 bits are masked and complemented.
     This returns an unsigned version of what bitInvert would return.
     (i.e. same as self bitInvert bitAnd:16rFF)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    long _self = self.longValue();
    return __c__._RETURN( STInteger._new( ~_self & 0xFF) );
#else
    /* invert anything except tag bits */
    RETURN ( (OBJ) (((INT)self ^ ~TAG_MASK) & (INT)(__mkSmallInteger(0xFF))) );
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitInvertByte

    "
     16r7f bitInvert
     16r7f bitInvertByte

     16r80 bitInvert
     16r80 bitInvertByte

     16rff bitInvert
     16rff bitInvertByte
    "
!

bitOr:anInteger
    "return the bitwise-or of the receiver and the argument, anInteger"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.bitOr( anInteger ));
#else
    /* oring the tags doesn't change it */
    if (__isSmallInteger(anInteger)) {
        RETURN ( ((OBJ) ((INT)self | (INT)anInteger)) );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ self retry:#bitOr: coercing:anInteger

    "
     (2r000000100 bitOr:2r00000011) radixPrintStringRadix:2
     (0 bitOr:16r20000000) hexPrintString
     (0 bitOr:16r40000000) hexPrintString
     (0 bitOr:16r80000000) hexPrintString
    "
!

bitReversed
    "swap (i.e. reverse) bits in an integer
     i.e. a.b.c.d....x.y.z -> z.y.x...b.a.d.c."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self);

# if __POINTER_SIZE__ == 8
    // swap odd and even bits
    v = ((v >> 1) & 0x5555555555555555) | ((v & 0x5555555555555555) << 1);
    // swap consecutive pairs
    v = ((v >> 2) & 0x3333333333333333) | ((v & 0x3333333333333333) << 2);
    // swap nibbles ...
    v = ((v >> 4) & 0x0F0F0F0F0F0F0F0F) | ((v & 0x0F0F0F0F0F0F0F0F) << 4);
    // swap bytes
    v = ((v >> 8) & 0x00FF00FF00FF00FF) | ((v & 0x00FF00FF00FF00FF) << 8);
    // swap 2-byte pairs
    v = ((v >> 16) & 0x0000FFFF0000FFFF) | (( v & 0x0000FFFF0000FFFF) << 16);
    // swap 4-byte long pairs
    v = ((v >> 32) & 0x00000000FFFFFFFF) | (( v & 0x00000000FFFFFFFF) << 32);
# else
    // swap odd and even bits
    v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
    // swap consecutive pairs
    v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
    // swap nibbles ...
    v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);
    // swap bytes
    v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);
    // swap 2-byte long pairs
    v = ((v >> 16) & 0x0000FFFF) | ((v & 0x0000FFFF) << 16);
# endif

    if (v <= _MAX_INT) {
        RETURN ( __mkSmallInteger(v) );
    }
    RETURN (__MKUINT(v));
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitReversed

    "
     2r1001 bitReversed printStringRadix:2
     2r100111010011 bitReversed printStringRadix:2
     -1 bitReversed printStringRadix:2
    "
!

bitReversed16
    "swap (i.e. reverse) the low 16 bits in an integer
     the high bits are ignored and clear in the result
     i.e. xxx.a.b.c.d....x.y.z -> 000.z.y.x...b.a.d.c."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self) & 0xFFFF;

    // swap odd and even bits
    v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
    // swap consecutive pairs
    v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
    // swap nibbles ...
    v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);
    // swap bytes
    v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);

    if (v <= _MAX_INT) {
        RETURN ( __mkSmallInteger(v) );
    }
    RETURN (__MKUINT(v));
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitReversed16

    "
     2r1001 bitReversed16 printStringRadix:2
     2r100111010011 bitReversed16 printStringRadix:2
     -1 bitReversed16 printStringRadix:2
    "
!

bitReversed32
    "swap (i.e. reverse) the low 32 bits in an integer
     the high bits are ignored and clear in the result
     i.e. xxx.a.b.c.d....x.y.z -> 000.z.y.x...b.a.d.c."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self) & 0xFFFFFFFF;

    // swap odd and even bits
    v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
    // swap consecutive pairs
    v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
    // swap nibbles ...
    v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);
    // swap bytes
    v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);
    // swap 2-byte long pairs
    v = ((v >> 16) & 0x0000FFFF) | ((v & 0x0000FFFF) << 16);

    if (v <= _MAX_INT) {
        RETURN ( __mkSmallInteger(v) );
    }
    RETURN (__MKUINT(v));
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitReversed32

    "
     2r1001 bitReversed32 printStringRadix:2
     2r100111010011 bitReversed32 printStringRadix:2
     -1 bitReversed32 printStringRadix:2
    "
!

bitReversed8
    "swap (i.e. reverse) the low 8 bits in an integer
     the high bits are ignored and clear in the result
     i.e. xxx.a.b.c.d....x.y.z -> 000.z.y.x...b.a.d.c."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self) & 0xFF;

    // swap odd and even bits
    v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
    // swap consecutive pairs
    v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
    // swap nibbles ...
    v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);

    if (v <= _MAX_INT) {
        RETURN ( __mkSmallInteger(v) );
    }
    RETURN (__MKUINT(v));
#endif /* not __SCHTEAM__ */
%}.
    ^ super bitReversed8

    "
     2r1001 bitReversed8 printStringRadix:2
     2r10011101 bitReversed8 printStringRadix:2
     2r111110011101 bitReversed8 printStringRadix:2
     -1 bitReversed8 printStringRadix:2
    "
!

bitShift:shiftCount
    "return the value of the receiver shifted by shiftCount bits;
     leftShift if shiftCount > 0; rightShift otherwise.
     Notice: the result of bitShift: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers).
             However, ST/X preserves the sign."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.bitShift( shiftCount ));
#else
    INT bits, count;

    if (__isSmallInteger(shiftCount)) {
        bits = __intVal(self);
        if (bits == 0) {
            RETURN (self);
        }
        count = __intVal(shiftCount);

        if (count > 0) {
            INT sign = 1;
            if (bits < 0) {
                bits = -bits;
                sign = -1;
            }
            /*
             * a left shift
             */
# if defined(USE_LONGLONG_FOR_SHIFT)
            if (count <= N_INT_BITS) {
                unsigned LONGLONG result;

                result = (unsigned LONGLONG)bits;
                result <<= count;
                if (result <= _MAX_INT) {
                    if (sign < 0) {
                        RETURN ( __MKINT(-result) );
                    }
                    RETURN ( __mkSmallInteger(result) );
                }
                {
                    RETURN (__MKLARGEINT64(sign, (INT)(result >> 32), (INT)(result & 0xFFFFFFFF)));
                }
            }
# else
            /*
             * check for overflow
             */
            if (count < (N_INT_BITS-1)) {
                if (! (bits >> (N_INT_BITS - 1 - count))) {
                    INT result = bits << count;

                    if (sign < 0) {
                        RETURN ( __MKINT(-result) );
                    }
                    RETURN ( __mkSmallInteger(result) );
                }
                /*
                 * so, there is an overflow ...
                 * handle it as largeInteger
                 */
                /* FALL THROUGH */
            }
# endif
        } else {
            if (count == 0) {
                RETURN (self);
            }

            /*
             * right shifts cannot overflow
             *
             * some machines ignore shifts bigger than
             * the number of bits in an int ...
             */
            count = -count;
            if (count > (N_INT_BITS-1)) {
                RETURN (__mkSmallInteger(0));
            }

            RETURN ( __mkSmallInteger(bits >> count) );
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    (shiftCount isMemberOf:SmallInteger) ifTrue:[
        ^ (LargeInteger value:self) bitShift:shiftCount
    ].
    ^ self bitShift:shiftCount asInteger   "/ is this a good idea ?
!

bitTest:aMask
    "return true, if any bit from aMask is set in the receiver.
     I.e. true, if the bitwise-AND of the receiver and the argument, anInteger
     is non-0, false otherwise."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN(
            ( self.bitAnd( aMask ) == STInteger._0 )
            ? STObject.False : STObject.True );
    /* NOTREACHED */
#else
    /* and all bits except tag */
    if (__isSmallInteger(aMask)) {
        RETURN ( ((INT)self & ((INT)aMask & ~TAG_MASK)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    aMask class == LargeInteger ifTrue:[
        ^ (aMask bitAnd:self) ~~ 0
    ].
    ^ self retry:#bitTest: coercing:aMask

    "
     2r10001 bitTest:2r00001
     2r10001 bitTest:2r00010
     2r10001 bitTest:2r00100
     2r10001 bitTest:2r01000
     2r10001 bitTest:2r10000
     2r10001 bitTest:2r10001
     2r10001 bitTest:2r10010
    "
!

bitXor:anInteger
    "return the bitwise-exclusive-or of the receiver and the argument, anInteger"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.bitXor( anInteger ));
#else
    /* xoring the tags turns it off - or it in again */
    if (__isSmallInteger(anInteger)) {
        RETURN ( (OBJ)( ((INT)self ^ (INT)anInteger) | TAG_INT) );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ self retry:#bitXor: coercing:anInteger
!

highBit
    "return the bitIndex of the highest bit set.
     The returned bitIndex starts at 1 for the least significant bit.
     Returns 0 if no bit is set."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
        long bits = self.longValue();
        int bitNr = 0;

        if (bits != 0) {
            if ((bits & 0xFFFFFFFF00000000L) != 0) {
                bitNr += 32; bits >>= 32;
            }
            if ((bits & 0xFFFF0000L) != 0) {
                bitNr += 16; bits >>= 16;
            }
            if ((bits & 0xFF00) != 0) {
                bitNr += 8; bits >>= 8;
            }
            if ((bits & 0xF0) != 0) {
                bitNr += 4; bits >>= 4;
            }
            if ((bits & 0xC) != 0) {
                bitNr += 2; bits >>= 2;
            }
            if ((bits & 0x2) != 0) {
                bitNr += 1; bits >>= 1;
            }
            bitNr += 1;
        }
        return context._RETURN( STInteger._new(bitNr) );
    }
    /* NOTREACHED */
#else
    unsigned INT bits;
    int index;

    bits = __intVal(self);
    if (bits == 0) {
        RETURN ( __mkSmallInteger(0) );
    }

# ifdef __BSR
    /*
     * so much for CISC CPUS:
     * the following code is not faster on a PIII-400
     * (but saves a few code-bytes, though)
     */
    index = __BSR(bits);
# else

    index = 0;

#  if __POINTER_SIZE__ == 8
    if (bits & 0xFFFFFFFF00000000L) {
        index += 32; bits >>= 32;
    }
#  endif
    if (bits & 0xFFFF0000L) {
        index += 16; bits >>= 16;
    }
    if (bits & 0xFF00) {
        index += 8; bits >>= 8;
    }
    if (bits & 0xF0) {
        index += 4; bits >>= 4;
    }
    if (bits & 0xC) {
        index += 2; bits >>= 2;
    }
    if (bits & 0x2) {
        index += 1; bits >>= 1;
    }
# endif /* no BSR instruction */

    RETURN ( __mkSmallInteger(index+1) );
#endif /* not __SCHTEAM__ */
%}.
    ^ super highBit

    "
     2r0 highBit
     2r1 highBit
     2r10 highBit
     2r100 highBit
     2r1000 highBit
     2r100000000000 highBit

     ((0 to:64) collect:[:s | 1 bitShift:s])
        collect:[:n | n highBit]

     (((0 to:64) collect:[:s | 1 bitShift:s])
        collect:[:n | n highBit]) = (1 to:65)
    "

    "
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r1 highBit
        ]
     ]
    "
    "
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r1111 highBit
        ]
     ]
    "
    "
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r11111111111111 highBit
        ]
     ]
    "
    "
     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r11111111111111111111111111 highBit
        ]
     ]
    "

    "
     2r000100 highBit
     2r010100 highBit
     2r000001 highBit
     0 highBit
     SmallInteger maxVal highBit
    "
!

lowBit
    "return the bitIndex of the lowest bit set. The returned bitIndex
     starts at 1 for the least significant bit.
     Returns 0 if no bit is set."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    long bits = self.longValue();
    int index = 0;

    if (bits != 0) {
        if ((bits & 0xFFFFFFFFL)==0) {
            index += 32; bits >>= 32;
        }
        if ((bits & 0xFFFFL)==0) {
            index += 16; bits >>= 16;
        }
        if ((bits & 0xFFL)==0) {
            index += 8; bits >>= 8;
        }
        if ((bits & 0xFL)==0) {
            index += 4; bits >>= 4;
        }
        if ((bits & 0x3L)==0) {
            index += 2; bits >>= 2;
        }
        if ((bits & 0x1L)==0) {
            index += 1;
        }
    }
    return __c__._RETURN( STInteger._qnew( index ) );
#else
    unsigned INT bits;
    int index;

    bits = __intVal(self);
    if (bits == 0) {
        RETURN ( __mkSmallInteger(0) );
    }

# ifdef __BSF
    /*
     * so much for CISC CPUS:
     * the following code is only marginally faster on a PIII-400
     * (and not at all faster on an Athlon...)
     * but saves a few code-bytes, though.
     */
    index = __BSF(bits);
    RETURN ( __mkSmallInteger(index + 1) );
# else

    index = 1;

#  if __POINTER_SIZE__ == 8
    if ((bits<<32) == 0) {
        index += 32; bits >>= 32;
    }
#  endif

    if ((bits & 0xFFFF)==0) {
        index += 16; bits >>= 16;
    }
    if ((bits & 0xFF)==0) {
        index += 8; bits >>= 8;
    }
    if ((bits & 0xF)==0) {
        index += 4; bits >>= 4;
    }
    if ((bits & 0x3)==0) {
        index += 2; bits >>= 2;
    }
    if ((bits & 0x1)==0) {
        index += 1;
    }
# endif

    RETURN ( __mkSmallInteger(index) );
#endif /* not __SCHTEAM__ */
%}.
    self primitiveFailed "/ must be implemented (or else: recursion)

    "
     0 lowBit
     2r0001 lowBit
     2r0010 lowBit
     2r0100 lowBit
     2r1000 lowBit

     2r000100 lowBit
     2r010010 lowBit
     2r100001 lowBit
     16r1000 lowBit
     16r1000000 lowBit
     16r1000000000000000 lowBit

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r1000 lowBit
        ]
     ]

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r11110000000 lowBit
        ]
     ]

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r1000000000000 lowBit
        ]
     ]

     Time millisecondsToRun:[
        1000000 timesRepeat:[
            2r1000000000000000000000000000 lowBit
        ]
     ]
    "
!

rightShift:shiftCount
    "return the value of the receiver shifted by shiftCount bits;
     right shift if shiftCount > 0; left shift  otherwise.
     Notice: the result of bitShift: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers).
             However, ST/X preserves the sign."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
#else
    INT bits, count;

    if (__isSmallInteger(shiftCount)) {
        bits = __intVal(self);
        if (bits == 0) {
            RETURN (self);
        }

        count = __intVal(shiftCount);

        if (count < 0) {
            /*
             * a left shift
             */
            count = -count;
# if defined(USE_LONGLONG_FOR_SHIFT)
            if (count <= N_INT_BITS) {
                unsigned LONGLONG result;

                result = (unsigned LONGLONG)bits;
                result <<= count;
                if (result <= _MAX_INT) {
                    RETURN ( __mkSmallInteger(result) );
                }
                {
                    RETURN (__MKLARGEINT64(1, (INT)(result >> 32), (INT)(result & 0xFFFFFFFF)));
                }
            }
# else
            /*
             * check for overflow
             */
            if (count < (N_INT_BITS-1)) {
                if (! (bits >> (N_INT_BITS - 1 - count))) {
                    RETURN ( __mkSmallInteger(bits << count) );
                }
                /*
                 * so, there is an overflow ...
                 * handle it as largeInteger
                 */
                /* FALL THROUGH */
            }
# endif
        } else {
            if (count == 0) {
                RETURN (self);
            }

            /*
             * right shifts cannot overflow
             *
             * some machines ignore shifts bigger than
             * the number of bits in an int ...
             */
            if (count > (N_INT_BITS-1)) {
                RETURN (__mkSmallInteger(0));
            }

            RETURN ( __mkSmallInteger(bits >> count) );
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    (shiftCount isMemberOf:SmallInteger) ifTrue:[
        ^ (LargeInteger value:self) rightShift:shiftCount
    ].
    ^ self rightShift:shiftCount asInteger   "/ is this a good idea ?


    "
        16 rightShift:2
         4 rightShift:-2
    "
! !

!SmallInteger methodsFor:'bit operators - indexed'!

bitAt:anIntegerIndex
    "return the value of the index's bit (index starts at 1) as 0 or 1.
     Notice: the result of bitAt: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.bitAt(anIntegerIndex));
#else
    if (__isSmallInteger(anIntegerIndex)) {
        INT idx = __smallIntegerVal(anIntegerIndex);
        if (idx > 0) {
            if (idx > N_INT_BITS) {
                RETURN(__mkSmallInteger(0));
            }
            RETURN((__smallIntegerVal(self) & ((INT)1 << (idx-1))) ? __mkSmallInteger(1) : __mkSmallInteger(0));
        }
    }
#endif /* not __SCHTEAM__ */
%}.

    ^ SubscriptOutOfBoundsError
            raiseRequestWith:anIntegerIndex
            errorString:'index out of bounds'

    "
     16r000000001 bitAt:0 -> error
     16r000000001 bitAt:1
     16r000000001 bitAt:2
     16r000008000 bitAt:16
     16r000800000 bitAt:24
     16r008000000 bitAt:28
     16r010000000 bitAt:29
     16r020000000 bitAt:30
     16r040000000 bitAt:31
     16r080000000 bitAt:32
     16r100000000 bitAt:33
    "

" Smalltalk implementation:
    |mask|

    anIntegerIndex <= 0 ifTrue:[
        ^ SubscriptOutOfBoundsSignal
                raiseRequestWith:anIntegerIndex
                errorString:'index out of bounds'
    ].
    (anIntegerIndex > SmallInteger maxBits) ifTrue:[^ 0].
    mask := 1 bitShift:(anIntegerIndex - 1).
    ((self bitAnd:mask) == 0) ifTrue:[^ 0].
    ^ 1
"
!

clearBit:anInteger
    "return a new integer where the specified bit is off.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitCleared:"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    if (__isSmallInteger(anInteger)) {
        int index = __intVal(anInteger);

        if (index > 0) {
# if __POINTER_SIZE__ == 8
            if (index <= 62)
# else
            if (index <= 30)
# endif
            {
                INT mask = __MASKSMALLINT( ((INT)1 << (index-1)));

                RETURN ( ((OBJ) ((INT)self & ~(INT)mask)) );
            }
            RETURN (self);  /* nothing to do ... */
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super clearBit:anInteger

    "
     (16r401 clearBit:1     ) hexPrintString
     (16r401 clearBit:0     ) hexPrintString
     (16r3fffffff clearBit:1) hexPrintString
     (16r3fffffff clearBit:29) hexPrintString
     (16r3fffffff clearBit:30) hexPrintString
     (16r3fffffff clearBit:31) hexPrintString
     (16r3fffffff bitAt:29) hexPrintString
     (16r3fffffff bitAt:30) hexPrintString
     (16r3fffffff bitAt:31) hexPrintString
     (16r40000001 clearBit:1) hexPrintString
     (16rF0000001 clearBit:29) hexPrintString
     (16rF0000001 clearBit:30) hexPrintString
     (16rF0000001 clearBit:31) hexPrintString
     (16rF0000001 clearBit:32) hexPrintString
     (16r1F0000001 clearBit:33) hexPrintString
    "
!

invertBit:anInteger
    "return a new number where the specified bit is inverted.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitInverted:"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    if (__isSmallInteger(anInteger)) {
        int index = __intVal(anInteger);

        if (index > 0) {
# if __POINTER_SIZE__ == 8
            if (index <= 62)
# else
            if (index <= 30)
# endif
            {
                INT mask = __MASKSMALLINT((INT)1 << (index-1));

                RETURN ( ((OBJ) ((INT)self ^ (INT)mask)) );
            }
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super invertBit:anInteger

    "
     (16r401 invertBit:2     ) hexPrintString
     (16r401 invertBit:1     ) hexPrintString
     (16r30000000 invertBit:1) hexPrintString
     (16r40000000 invertBit:0) hexPrintString
     (16r0 invertBit:29) hexPrintString
     (16r0 invertBit:30) hexPrintString
     (16r0 invertBit:31) hexPrintString
     (16r0 invertBit:32) hexPrintString
     (16r0 invertBit:33) hexPrintString
     (16r0 invertBit:100) hexPrintString
    "
!

setBit:anInteger
    "return a new integer where the specified bit is on.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitSet:"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    if (__isSmallInteger(anInteger)) {
        int index = __intVal(anInteger);

        if (index > 0) {
# if __POINTER_SIZE__ == 8
            if (index <= 62)
# else
            if (index <= 30)
# endif
            {
                INT mask = __MASKSMALLINT((INT)1 << (index-1));

                RETURN ( ((OBJ) ((INT)self | (INT)mask)) );
            }
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super setBit:anInteger

    "
     (16r401 setBit:2     ) hexPrintString
     (16r30000000 setBit:1) hexPrintString
     (16r40000000 setBit:0) hexPrintString
     (16r0 setBit:29) hexPrintString
     (16r0 setBit:30) hexPrintString
     (16r0 setBit:31) hexPrintString
     (16r0 setBit:32) hexPrintString
     (16r0 setBit:33) hexPrintString
     (16r0 setBit:100) hexPrintString
    "
! !

!SmallInteger methodsFor:'byte access'!

byteSwapped
    "lsb -> msb;
     i.e. a.b.c.d -> d.c.b.a"

    SmallInteger maxBytes == 8 ifTrue:[
        ^ self byteSwapped64
    ] ifFalse:[
        ^ self byteSwapped32
    ].

    "
     16r11223344 byteSwapped hexPrintString
     16r44332211 byteSwapped hexPrintString
    "

    "Created: / 09-01-2012 / 23:01:33 / cg"
!

byteSwapped16
    "for 16bit values only:
     lsb -> msb;
     i.e. a.b -> b.a"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self);
    unsigned INT swapped;

    swapped = ((v>>8)&0xFF) | ((v & 0xFF)<<8);
    RETURN (__mkSmallInteger(swapped));
#endif /* not __SCHTEAM__ */
%}.
    ^ super byteSwapped16

    "
     16r1122 byteSwapped16 hexPrintString
     16r2211 byteSwapped16 hexPrintString
     16r332211 byteSwapped16 hexPrintString
    "
!

byteSwapped32
    "for 32bit values only:
     lsb -> msb;
     i.e. a.b.c.d -> d.c.b.a"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self);
    unsigned INT swapped;

# undef HAVE_BSWAP
# if __POINTER_SIZE__ == 4

#  if defined(USE_BSWAP) && defined(__BORLANDC__)
#   define HAVE_BSWAP

    _asm {
        mov eax, v
        bswap eax
        mov swapped, eax
    };
#  endif
#  if defined(USE_BSWAP) && defined(__VISUALC__)
#   define HAVE_BSWAP

    _asm {
        mov eax, v
        xchg al, ah
        rol eax, 16
        xchg al, ah
        mov swapped, eax
    };
#  endif
#  if defined(USE_BSWAP) && defined(__GNUC__)
#   define HAVE_BSWAP

    asm("movl %1, %%eax \n\
         bswap %%eax    \n\
         movl %%eax, %0 \n\
        "
        : "=rm"  (swapped)
        : "rm"   (v));
#  endif
# endif /* __POINTER_SIZE__ == 4 */

# if __POINTER_SIZE__ == 8
    v &= 0xFFFFFFFF;

#  if defined(__x86_64__) && defined(__GNUC__) && !defined(__CLANG__)
#   define HAVE_BSWAP

    asm("movq %1, %%rax \n\
         bswap %%eax    \n\
         movq %%rax, %0 \n\
        "
        : "=rm"  (swapped)
        : "rm"   (v));
#  endif
# endif

# ifndef HAVE_BSWAP
    swapped = ((v>>24) | ((v>>8)&0xFF00) | ((v & 0xFF00)<<8) | ((v & 0xFF)<<24));
# endif

    RETURN (__MKUINT(swapped));
#endif /* not __SCHTEAM__ */
%}.
    ^ super byteSwapped32

    "
     16r11223344 byteSwapped32 hexPrintString
     16r44332211 byteSwapped32 hexPrintString
    "

    "Created: / 09-01-2012 / 23:01:33 / cg"
!

byteSwapped64
    "for 64bit values only:
     lsb -> msb;
     i.e. a.b.c.d.e.f.g.h -> h.g.f.e.d.c.b.a"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self);
    unsigned INT swapped;

# if __POINTER_SIZE__ == 4
    //   xxxxxxxx 00000000 00000000 00000000 -> 00000000 00000000 00000000 xxxxxxxx
    //            xxxxxxxx                                        xxxxxxxx
    //                     xxxxxxxx                      xxxxxxxx
    //                              xxxxxxxx    xxxxxxxx
    swapped = (v>>24) | ((v>>8)&0xFF00) | ((v & 0xFF00)<<8) | ((v & 0xFF)<<24);
    RETURN(__MKLARGEINT64(1, 0, swapped));
# else
    //   xxxxxxxx 00000000 00000000 00000000 -> 00000000 00000000 00000000 xxxxxxxx
    //            xxxxxxxx                                        xxxxxxxx
    //                     xxxxxxxx                      xxxxxxxx
    //                              xxxxxxxx    xxxxxxxx
    swapped =  (v>>56) | ((v>>40)&0xFF00) | ((v>>24) & 0xFF0000) | ((v>>8) & 0xFF000000)
                | ((v & 0xFF000000)<<8) | ((v & 0x00FF0000)<<24) | ((v & 0x0000FF00)<<40)
                | ((v & 0xFF)<<56);
# endif
    RETURN(__MKUINT( swapped ));
#endif /* not __SCHTEAM__ */
%}.
    ^ super byteSwapped64

    "
     16r11223344 byteSwapped64 hexPrintString
     16r44332211 byteSwapped64 hexPrintString
    "

    "Created: / 09-01-2012 / 23:01:33 / cg"
!

digitAt:index
    "return 8 bits of value, starting at byte index"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    int idx0Based = index.intValue() - 1;

    if (idx0Based <= 7) {
        long myVal = self.longValue();
        if (myVal < 0) {
            myVal = -myVal;
        }
        int byteVal = (int)((myVal >> (idx0Based * 8)) & 0xFF);
        return __c__._RETURN( STInteger._qnew(byteVal) );
    }
    if (idx0Based > 0) {
        return __c__._RETURN( STInteger._0 );
    }
#else
    REGISTER INT val;
    INT idx;

    if (__isSmallInteger(index)) {
        val = __intVal(self);
        if (val < 0)
            val = -val;
        switch (idx = __intVal(index)) {
            case 1:
                break;
            case 2:
                val = (val >> 8);
                break;
            case 3:
                val = (val >> 16);
                break;
            case 4:
                val = (val >> 24);
                break;
# if __POINTER_SIZE__ == 8
            case 5:
                val = (val >> 32);
                break;
            case 6:
                val = (val >> 40);
                break;
            case 7:
                val = (val >> 48);
                break;
            case 8:
                val = (val >> 56);
                break;
# endif
            default:
                if (idx < 1)
                    goto bad;   /* sorry */
                RETURN (__mkSmallInteger(0));
        }
        RETURN ( __mkSmallInteger( val & 0xFF) );
    }
  bad: ;
#endif /* not __SCHTEAM__ */
%}.
    index > 0 ifFalse:[
        "
         index less than 1 - not allowed
        "
        ^ self primitiveFailed
    ].
    ^ 0

    "
     (16r12345678 digitAt:1) printStringRadix:16
     (16r12345678 digitAt:3) printStringRadix:16
     (16r12345678 digitAt:15) printStringRadix:16
     (16r12345678 digitAt:0) printStringRadix:16
     (16r12345678 digitAt:-10) printStringRadix:16
    "
!

digitByteAt:index
    "return 8 bits of my signed value, starting at byte index.
     For positive receivers, this is the same as #digitAt:;
     for negative ones, the actual bit representation is returned."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    int idx0Based = index.intValue() - 1;
    long myVal = self.longValue();

    if (idx0Based <= 7) {
        int byteVal = (int)((myVal >> (idx0Based * 8)) & 0xFF);
        return __c__._RETURN( STInteger._qnew(byteVal) );
    }
    if (idx0Based > 0) {
        if (myVal < 0) {
            return __c__._RETURN( STInteger._M1 );
        } else {
            return __c__._RETURN( STInteger._0 );
        }
    }
#else
    REGISTER INT val;
    INT idx;

    if (__isSmallInteger(index)) {
        val = __intVal(self);
        switch (idx = __intVal(index)) {
            case 1:
                break;
            case 2:
                val = (val >> 8);
                break;
            case 3:
                val = (val >> 16);
                break;
            case 4:
                val = (val >> 24);
                break;
# if __POINTER_SIZE__ == 8
            case 5:
                val = (val >> 32);
                break;
            case 6:
                val = (val >> 40);
                break;
            case 7:
                val = (val >> 48);
                break;
            case 8:
                val = (val >> 56);
                break;
# endif
            default:
                if (idx < 1)
                    goto bad;   /* sorry */
                if (val < 0) {
                    RETURN (__mkSmallInteger(0xFF));
                }
                RETURN (__mkSmallInteger(0));
        }
        RETURN ( __mkSmallInteger( val & 0xFF) );
    }
  bad: ;
#endif /* not __SCHTEAM__ */
%}.
    index > 0 ifFalse:[
        "
         index less than 1 - not allowed
        "
        ^ self primitiveFailed
    ].
    ^ 0

    "
     (10 digitByteAt:1) printStringRadix:16
     (10 digitByteAt:3) printStringRadix:16
     (-10 digitByteAt:1) printStringRadix:16
     (-10 digitByteAt:3) printStringRadix:16
    "
!

digitBytes
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     least significant byte is first"

    |absValue
     b1 "{ Class: SmallInteger }"
     b2 "{ Class: SmallInteger }"
     b3 "{ Class: SmallInteger }"
     b4 "{ Class: SmallInteger }"
     b5 "{ Class: SmallInteger }"
     b6 "{ Class: SmallInteger }"
     b7 "{ Class: SmallInteger }" digitByteArray|

    "
     could have simply created a 4-byte largeinteger and normalize it.
     The code below does the normalize right away, avoiding the
     overhead of producing any intermediate byte-arrays (and the scanning)
    "
    self == 0 ifTrue: [
        ^ ByteArray with:0.
    ].

    self < 0 ifTrue: [
        absValue := self negated
    ] ifFalse: [
        absValue := self.
    ].

    b1 := absValue bitAnd:16rFF.
    absValue := absValue bitShift:-8.
    absValue == 0 ifTrue:[
        digitByteArray := ByteArray with:b1
    ] ifFalse:[
        b2 := absValue bitAnd:16rFF.
        absValue := absValue bitShift:-8.
        absValue == 0 ifTrue:[
            digitByteArray := ByteArray with:b1 with:b2
        ] ifFalse:[
            b3 := absValue bitAnd:16rFF.
            absValue := absValue bitShift:-8.
            absValue == 0 ifTrue:[
                digitByteArray := ByteArray with:b1 with:b2 with:b3
            ] ifFalse:[
                b4 := absValue bitAnd:16rFF.
                absValue := absValue bitShift:-8.
                absValue == 0 ifTrue:[
                    digitByteArray := ByteArray with:b1 with:b2 with:b3 with:b4
                ] ifFalse:[
                    b5 := absValue bitAnd:16rFF.
                    absValue := absValue bitShift:-8.
                    absValue == 0 ifTrue:[
                        digitByteArray := ByteArray new:5.
                        digitByteArray at:1 put:b1.
                        digitByteArray at:2 put:b2.
                        digitByteArray at:3 put:b3.
                        digitByteArray at:4 put:b4.
                        digitByteArray at:5 put:b5.
                    ] ifFalse:[
                        b6 := absValue bitAnd:16rFF.
                        absValue := absValue bitShift:-8.
                        absValue == 0 ifTrue:[
                            digitByteArray := ByteArray new:6.
                            digitByteArray at:1 put:b1.
                            digitByteArray at:2 put:b2.
                            digitByteArray at:3 put:b3.
                            digitByteArray at:4 put:b4.
                            digitByteArray at:5 put:b5.
                            digitByteArray at:6 put:b6.
                        ] ifFalse:[
                            b7 := absValue bitAnd:16rFF.
                            absValue := absValue bitShift:-8.
                            absValue == 0 ifTrue:[
                                digitByteArray := ByteArray new:7.
                                digitByteArray at:1 put:b1.
                                digitByteArray at:2 put:b2.
                                digitByteArray at:3 put:b3.
                                digitByteArray at:4 put:b4.
                                digitByteArray at:5 put:b5.
                                digitByteArray at:6 put:b6.
                                digitByteArray at:7 put:b7.
                            ] ifFalse:[
                                digitByteArray := ByteArray new:8.
                                digitByteArray at:1 put:b1.
                                digitByteArray at:2 put:b2.
                                digitByteArray at:3 put:b3.
                                digitByteArray at:4 put:b4.
                                digitByteArray at:5 put:b5.
                                digitByteArray at:6 put:b6.
                                digitByteArray at:7 put:b7.
                                digitByteArray at:8 put:absValue.
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    ^ digitByteArray

    "
      16r12 digitBytes hexPrintString
      16r1234 digitBytes hexPrintString
      16r12345678 digitBytes hexPrintString
    "
!

digitBytesMSB
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     most significant byte is first"

    |absValue
     b1 "{ Class: SmallInteger }"
     b2 "{ Class: SmallInteger }"
     b3 "{ Class: SmallInteger }"
     b4 "{ Class: SmallInteger }"
     b5 "{ Class: SmallInteger }"
     b6 "{ Class: SmallInteger }"
     b7 "{ Class: SmallInteger }" digitByteArray|

    "
     could have simply created a 4-byte largeinteger and normalize it.
     The code below does the normalize right away, avoiding the
     overhead of producing any intermediate byte-arrays (and the scanning)
    "
    self == 0 ifTrue: [
        ^ ByteArray with:0.
    ].

    self < 0 ifTrue: [
        absValue := self negated
    ] ifFalse: [
        absValue := self.
    ].

    b1 := absValue bitAnd:16rFF.
    absValue := absValue bitShift:-8.
    absValue == 0 ifTrue:[
        digitByteArray := ByteArray with:b1
    ] ifFalse:[
        b2 := absValue bitAnd:16rFF.
        absValue := absValue bitShift:-8.
        absValue == 0 ifTrue:[
            digitByteArray := ByteArray with:b2 with:b1
        ] ifFalse:[
            b3 := absValue bitAnd:16rFF.
            absValue := absValue bitShift:-8.
            absValue == 0 ifTrue:[
                digitByteArray := ByteArray with:b3 with:b2 with:b1
            ] ifFalse:[
                b4 := absValue bitAnd:16rFF.
                absValue := absValue bitShift:-8.
                absValue == 0 ifTrue:[
                    digitByteArray := ByteArray with:b4 with:b3 with:b2 with:b1
                ] ifFalse:[
                    b5 := absValue bitAnd:16rFF.
                    absValue := absValue bitShift:-8.
                    absValue == 0 ifTrue:[
                        digitByteArray := ByteArray new:5.
                        digitByteArray at:1 put:b5.
                        digitByteArray at:2 put:b4.
                        digitByteArray at:3 put:b3.
                        digitByteArray at:4 put:b2.
                        digitByteArray at:5 put:b1.
                    ] ifFalse:[
                        b6 := absValue bitAnd:16rFF.
                        absValue := absValue bitShift:-8.
                        absValue == 0 ifTrue:[
                            digitByteArray := ByteArray new:6.
                            digitByteArray at:1 put:b6.
                            digitByteArray at:2 put:b5.
                            digitByteArray at:3 put:b4.
                            digitByteArray at:4 put:b3.
                            digitByteArray at:5 put:b2.
                            digitByteArray at:6 put:b1.
                        ] ifFalse:[
                            b7 := absValue bitAnd:16rFF.
                            absValue := absValue bitShift:-8.
                            absValue == 0 ifTrue:[
                                digitByteArray := ByteArray new:7.
                                digitByteArray at:1 put:b7.
                                digitByteArray at:2 put:b6.
                                digitByteArray at:3 put:b5.
                                digitByteArray at:4 put:b4.
                                digitByteArray at:5 put:b3.
                                digitByteArray at:6 put:b2.
                                digitByteArray at:7 put:b1.
                            ] ifFalse:[
                                digitByteArray := ByteArray new:8.
                                digitByteArray at:1 put:absValue.
                                digitByteArray at:2 put:b7.
                                digitByteArray at:3 put:b6.
                                digitByteArray at:4 put:b5.
                                digitByteArray at:5 put:b4.
                                digitByteArray at:6 put:b3.
                                digitByteArray at:7 put:b2.
                                digitByteArray at:8 put:b1.
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    ^ digitByteArray

    "
      16r12 digitBytesMSB hexPrintString
      16r1234 digitBytesMSB hexPrintString
      16r12345678 digitBytesMSB hexPrintString
    "
!

digitLength
    "return the number of bytes needed for the unsigned binary representation of the receiver.
     For negative receivers, the result is not defined by the language standard.
     ST/X returns the digitLength of its absolute value."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    long val = self.longValue();
    int offs = 0;

    if (val < 0) val = -val;
    if ((val & 0xFFFFFFFF00000000L) != 0) {
        val >>= 32;
        offs = 4;
    }
    if ((val & 0xFFFF0000) != 0) {
        if ((val & 0xFF000000) != 0) {
            offs += 4;
        } else {
            offs += 3;
        }
    } else {
        if ((val & 0x0000FF00)!= 0) {
            offs += 2;
        } else {
            offs += 1;
        }
    }
    return __c__._RETURN( STInteger._qnew(offs) );
#else
    INT val = __intVal(self);
    int offs = 0;

    if (val < 0) {
        val = -val;
    }
# if __POINTER_SIZE__ == 8
    if (val & 0xFFFFFFFF00000000L) {
        val >>= 32;
        offs = 4;
    }
# endif

    if (val & 0xFFFF0000) {
        if (val & 0xFF000000) {
            RETURN ( __mkSmallInteger(4+offs));
        } else {
            RETURN ( __mkSmallInteger(3+offs));
        }
    } else {
        if (val & 0x0000FF00) {
            RETURN ( __mkSmallInteger(2+offs));
        } else {
            RETURN ( __mkSmallInteger(1+offs));
        }
    }
#endif /* not SCHTEAM */
%}.
    ^ self abs highBit - 1 // 8 + 1

    "
     16rFF00000000000000 digitLength
     -16rFF00000000000000 digitLength

     16rFF000000 digitLength
     16rFF0000 digitLength
     16rFF00 digitLength
     16rFF digitLength
     -16rFF000000 digitLength
     -16rFF0000 digitLength
     -16rFF00 digitLength
     -16rFF digitLength
    "
!

swapBytes
    "swap bytes pair-wise in a positive integer
     i.e. a.b.c.d -> b.a.d.c.
     The name may be misleading; actually a new integer is returned,
     and the receiver is not modified.

     Redefined here for speed.
     Swapping of negative integers is undefined and therefore not supported.
     This case is handled in the superclass."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v = __intVal(self);

    if ((INT)v >= 0) {
        unsigned INT swapped;

# if __POINTER_SIZE__ == 8
        swapped = ((v >> 8) & 0x00FF00FF00FF00FF) | ((v & 0x00FF00FF00FF00FF) << 8);
# else
        swapped = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);
# endif /* __POINTER_SIZE__ */

        //if (__ISVALIDINTEGER(swapped)) {   // sorry, but this does not work here if (INT)swapped would be negative
        if (swapped <= _MAX_INT) {
            RETURN ( __mkSmallInteger(swapped) );
        }
        RETURN (__MKUINT(swapped));
    }
#endif
%}.
    ^ super swapBytes

    "
     -1 swapBytes hexPrintString
     16r11223344 swapBytes hexPrintString
     16r44332211 swapBytes hexPrintString
     self maxVal swapBytes hexPrintString
     self maxVal swapBytes swapBytes hexPrintString
     16r1122334455667788 swapBytes hexPrintString
     16r11223344556677889900 swapBytes hexPrintString
    "

    "Created: / 09-01-2012 / 23:01:33 / cg"
! !

!SmallInteger methodsFor:'catching messages'!

basicAt:index
    "catch indexed access - report an error
     defined here since basicAt: in Object ommits the SmallInteger check."

    ^ self notIndexed
!

basicAt:index put:anObject
    "catch indexed access - report an error
     defined here since basicAt:put: in Object ommits the SmallInteger check."

    self notIndexed
!

basicSize
    "return the number of indexed instvars - SmallIntegers have none.
     Defined here since basicSize in Object ommits the SmallInteger check."

    ^ 0
!

size
    "return the number of indexed instvars - SmallIntegers have none."

    ^ 0
! !

!SmallInteger methodsFor:'coercing & converting'!

asCharacter
    "Return a character with the receiver as ascii (actually: unicode) value"

    ^ Character value:self

    "
     Character value:16r61
     Character value:16r161
    "
!

asFloat
    "return a Float with same value as the receiver.
     Redefined for performance (machine can do it faster)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STDouble._new((double)(self.longValue())) );
#else
    OBJ newFloat;
    double dVal = (double)__intVal(self);

    __qMKFLOAT(newFloat, dVal);
    RETURN ( newFloat );
#endif
%}.
    ^ self primitiveFailed
!

asLargeInteger
    "return a LargeInteger with same value as receiver.
     Not for general use:
       Notice, that this returns an unnormalized large int (i.e. a large with a smallint value),
       which are normally not present in the system, and not handled correctly by many functions.
       This exists only as a helper for some algorithms and converters"

    ^ LargeInteger value:self
!

asShortFloat
    "return a ShortFloat with same value as receiver.
     Redefined for performance (machine can do it faster)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STFloat._new((float)(self.longValue())) );
#else
    OBJ dummy = @global(ShortFloat);
    OBJ newFloat;
    float fVal = (float)__intVal(self);

    __qMKSFLOAT(newFloat, fVal);
    RETURN ( newFloat );
#endif
%}.
    ^ self primitiveFailed
!

asUnsignedInt
    "return an integer representing my unsigned INT value.
     Notice, that the returned integer's size
     depends heavily on the underlying INT size;
     You will get 16rFFFFFFFF on 32bit machines,
     but 16rFFFFFFFFFFFFFFFF on 64 bit machines.
     So use this only for printing or certain bit operations (emulating C semantics)."

%{  /* NOCONTEXT */
    INT iVal = __intVal(self);
    OBJ uiVal;

    uiVal = __MKUINT( (unsigned INT)iVal );
    RETURN ( uiVal );
%}.
    ^ self primitiveFailed

    "
     -1 asUnsignedInt hexPrintString -> 'FFFFFFFFFFFFFFFF'
     -16r8000 asUnsignedInt hexPrintString -> ''FFFFFFFFFFFF8000''
    "
!

codePoint
    "for compatibility with Characters.
     (Allows for integers to be stored into U16/U32 strings)"

    ^ self
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asInteger
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 20
!

signExtended24BitValue
    "return a smallInteger from sign-extending the 24'th bit.
     May be useful for communication interfaces"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT i = __intVal(self);

    if (i & 0x800000L) {
        i = i | ~((INT)0xFFFFFF);
    } else {
        i = i & 0x7FFFFF;
    }

    RETURN (__mkSmallInteger(i));
#endif
%}.
    ^ self primitiveFailed

    "
     16rFFFFFF signExtended24BitValue
     16r800000 signExtended24BitValue
     16r7FFFFF signExtended24BitValue
    "
!

signExtendedByteValue
    "return a smallInteger from sign-extending the 8'th bit.
     May be useful for communication interfaces"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT i = __intVal(self);

    if (i & 0x80) {
        i = i | ~((INT)0xFF);
    } else {
        i = i & 0x7F;
    }

    RETURN (__mkSmallInteger(i));
#endif
%}.
    ^ self primitiveFailed

    "
     16rFF signExtendedByteValue
     16r80 signExtendedByteValue
     16r7F signExtendedByteValue
    "
!

signExtendedLongValue
    "return a smallInteger from sign-extending the 32'th bit.
     May be useful for communication interfaces"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT i = __intVal(self);

    if (i & 0x80000000L) {
        i = i | ~((INT)0xFFFFFFFF);
    } else {
        i = i & 0x7FFFFFFFL;
    }

    RETURN (__MKINT(i));
#endif
%}.
    ^ self primitiveFailed

    "
     16rFFFFFFFF signExtendedLongValue -> -1
     16r80000000 signExtendedLongValue -> -2147483648
     16r7FFFFFFF signExtendedLongValue -> 2147483647
    "
!

signExtendedShortValue
    "return a smallInteger from sign-extending the 16'th bit.
     May be useful for communication interfaces"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT i = __intVal(self);

    if (i & 0x8000) {
        i = i | ~((INT)0xFFFF);
    } else {
        i = i & 0x7FFF;
    }

    RETURN (__mkSmallInteger(i));
#endif
%}.
    ^ self primitiveFailed

    "
     16rFFFF signExtendedShortValue
     16r8000 signExtendedShortValue
     16r7FFF signExtendedShortValue
    "
! !

!SmallInteger methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater than the receiver"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.ltP( aNumber ));
#else
    if (__isSmallInteger(aNumber)) {
# ifdef POSITIVE_ADDRESSES
        RETURN ( (__intVal(self) < __intVal(aNumber)) ? true : false );
# else
        /* tag bit does not change ordering */
        RETURN ( ((INT)self < (INT)aNumber) ? true : false );
# endif
    }
    if (__isFloatLike(aNumber)) {
        RETURN ( ((double)__intVal(self) < __floatVal(aNumber)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ aNumber lessFromInteger:self
    "^ self retry:#< coercing:aNumber"
!

<= aNumber
    "return true, if the argument is greater or equal"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.leP( aNumber ));
#else

    if (__isSmallInteger(aNumber)) {
# ifdef POSITIVE_ADDRESSES
        RETURN ( (__intVal(self) <= __intVal(aNumber)) ? true : false );
# else
        /* tag bit does not change ordering */
        RETURN ( ((INT)self <= (INT)aNumber) ? true : false );
# endif
    }
    if (__isFloatLike(aNumber)) {
        RETURN ( ((double)__intVal(self) <= __floatVal(aNumber)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ (self > aNumber) not

    "Modified: / 31.7.2002 / 10:07:17 / cg"
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
        return context._RETURN( aNumber.eqvP( self.longValue() ));
    }
#else

    if (aNumber == self) {
        RETURN ( true );
    }
    if (! __isNonNilObject(aNumber)) {
        /* a smallint or nil */
        RETURN ( false );
    }

    if (__qIsFloatLike(aNumber)) {
        RETURN ( ((double)__intVal(self) == __floatVal(aNumber)) ? true : false );
    }
    if (__qIsShortFloat(aNumber)) {
        RETURN ( ((double)__intVal(self) == __shortFloatVal(aNumber)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ aNumber equalFromInteger:self
!

> aNumber
    "return true, if the argument is less than the receiver"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.gtP( aNumber ));
#else

    if (__isSmallInteger(aNumber)) {
# ifdef POSITIVE_ADDRESSES
        RETURN ( (__intVal(self) > __intVal(aNumber)) ? true : false );
# else
        /* tag bit does not change ordering */
        RETURN ( ((INT)self > (INT)aNumber) ? true : false );
# endif
    }
    if (__isFloatLike(aNumber)) {
        RETURN ( ((double)__intVal(self) > __floatVal(aNumber)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ (aNumber < self)

    "Modified: / 31.7.2002 / 10:07:05 / cg"
!

>= aNumber
    "return true, if the argument is less or equal"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.geP( aNumber ));
#else

    if (__isSmallInteger(aNumber)) {
# ifdef POSITIVE_ADDRESSES
        RETURN ( (__intVal(self) >= __intVal(aNumber)) ? true : false );
# else
        /* tag bit does not change ordering */
        RETURN ( ((INT)self >= (INT)aNumber) ? true : false );
# endif
    }
    if (__isFloatLike(aNumber)) {
        RETURN ( ((double)__intVal(self) >= __floatVal(aNumber)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ (self < aNumber) not

    "Modified: / 31.7.2002 / 10:07:11 / cg"
!

hash
    "return an integer useful for hashing on value"

    self >= 0 ifTrue:[^ self].
    ^ self negated
!

hashMultiply
    "used in some squeak code to generate an alternative hash value for integers"

    |low|

    low := self bitAnd: 16r3FFF.
    ^ (9741 * low
      + ((9741 * (self bitShift: -14) + (101 * low) bitAnd: 16383) * 16384))
        bitAnd: 16r0FFFFFFF

    "
     1 hashMultiply
     2 hashMultiply
     3 hashMultiply
     100 hashMultiply
    "
!

identityHash
    "return an integer useful for hashing on identity"

     self >= 0 ifTrue:[^ self].
     ^ self negated

    "Modified: 11.11.1996 / 18:42:14 / cg"
!

max:aNumber
    "return the receiver or the argument, whichever is greater"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__

    if (__isSmallInteger(aNumber)) {
# if TAG_INT == 1
        /* tag bit does not change ordering */
        if ((INT)(self) > (INT)(aNumber))
# else
        if (__intVal(self) > __intVal(aNumber))
# endif
        {
            RETURN ( self );
        }
        RETURN ( aNumber );
    }
    if (__isFloatLike(aNumber)) {
        if ( (double)__intVal(self) > __floatVal(aNumber) ) {
            RETURN ( self );
        }
        RETURN ( aNumber );
    }
#endif /* not __SCHTEAM__ */
%}.
    "/ fallback for non-smallInteger argument

    (self > aNumber) ifTrue:[^ self].
    ^ aNumber
!

min:aNumber
    "return the receiver or the argument, whichever is smaller"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__

    if (__isSmallInteger(aNumber)) {
# if TAG_INT == 1
        /* tag bit does not change ordering */
        if ((INT)(self) < (INT)(aNumber))
# else
        if (__intVal(self) < __intVal(aNumber))
# endif
        {
            RETURN ( self );
        }
        RETURN ( aNumber );
    }
    if (__isFloatLike(aNumber)) {
        if ( (double)__intVal(self) < __floatVal(aNumber) ) {
            RETURN ( self );
        }
        RETURN ( aNumber );
    }
#endif /* not __SCHTEAM__ */
%}.
    "/ fallback for non-smallInteger argument

    (self < aNumber) ifTrue:[^ self].
    ^ aNumber
!

~= aNumber
    "return true, if the arguments value is not equal to mine"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aNumber.isNumber()) {
        return context._RETURN( (aNumber.isEqv( self.longValue() )) ? STObject.False : STObject.True);
        /* NOTREACHED */
    }
#else

    if (aNumber == self) {
        RETURN ( false );
    }
    if (! __isNonNilObject(aNumber)) {
        /* a smallint or nil */
        RETURN ( true );
    }

    if (__qIsFloatLike(aNumber)) {
        RETURN ( ((double)__intVal(self) != __floatVal(aNumber)) ? true : false );
    }
    if (__qIsShortFloat(aNumber)) {
        RETURN ( ((double)__intVal(self) != __shortFloatVal(aNumber)) ? true : false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ (self = aNumber) not
! !

!SmallInteger methodsFor:'copying'!

deepCopy
    "return a deep copy of myself
     - reimplemented here since smallintegers are unique"

    ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of myself
     - reimplemented here since smallintegers are unique"

    ^ self
!

shallowCopy
    "return a shallow copy of myself
     - reimplemented here since smallintegers are unique"

    ^ self
!

simpleDeepCopy
    "return a deep copy of myself
     - reimplemented here since smallintegers are unique"

    ^ self
! !


!SmallInteger methodsFor:'iteration'!

timesRepeat:aBlock
    "evaluate the argument, aBlock self times.
     Reimplemented as primitive for speed"

%{
#ifndef __SCHTEAM__
    REGISTER INT tmp;
    static struct inlineCache blockVal = __ILC0(0);

    tmp = __intVal(self);
    if (tmp > 0) {
        if (__isBlockLike(aBlock)
         && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(0))) {
            {
                REGISTER OBJFUNC codeVal;

                /*
                 * specially tuned version for compiled blocks,
                 * (the most common case)
                 */
                if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
# ifdef PARANOIA
                 && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))
# endif
                ) {
#                   define BLOCK_ARG  aBlock
                    {
# ifdef __UNROLL_LOOPS__

                        /*
                         * you are not supposed to program like this - I know what I do
                         */
                        while (tmp > 8) {
                            if (InterruptPending != nil) goto interrupted0;
        continue0:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted1;
        continue1:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted2;
        continue2:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted3;
        continue3:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted4;
        continue4:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted5;
        continue5:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted6;
        continue6:
                            (*codeVal)(BLOCK_ARG);
                            if (InterruptPending != nil) goto interrupted7;
        continue7:
                            (*codeVal)(BLOCK_ARG);
                            tmp -= 8;
                        }
# endif /* __UNROLL_LOOPS__ */
                        do {
                            if (InterruptPending != nil) goto interruptedX;
        continueX:
                            (*codeVal)(BLOCK_ARG);
                        } while(--tmp);

                        RETURN (self);
                        if (0) {
# ifdef __UNROLL_LOOPS__
                            interrupted0:
                                                __interruptL(@line); goto continue0;
                            interrupted1:
                                                __interruptL(@line); goto continue1;
                            interrupted2:
                                                __interruptL(@line); goto continue2;
                            interrupted3:
                                                __interruptL(@line); goto continue3;
                            interrupted4:
                                                __interruptL(@line); goto continue4;
                            interrupted5:
                                                __interruptL(@line); goto continue5;
                            interrupted6:
                                                __interruptL(@line); goto continue6;
                            interrupted7:
                                                __interruptL(@line); goto continue7;
# endif /* __UNROLL_LOOPS__ */
                            interruptedX:
                                                __interruptL(@line); goto continueX;
                        }
                    }
                }
            }

#           undef BLOCK_ARG

#           define BLOCK_ARG  aBlock
#           define IBLOCK_ARG nil

            /*
             * sorry - must check for the blocks code within the loops;
             * it could be recompiled or flushed (in the interrupt)
             */
            do {
                REGISTER OBJFUNC codeVal;

                if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                    /*
                     * arg is a compiled block with code -
                     * directly call it without going through Block>>value
                     * however, if there is an interrupt, refetch the code pointer.
                     */
                    /* stay here, while no interrupts are pending ... */
                    do {
                        (*codeVal)(BLOCK_ARG);
                        if (InterruptPending != nil) goto outerLoop;
                    } while (--tmp);
                    RETURN (self);
                } else {
                    if (InterruptPending != nil) __interruptL(@line);

                    if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                        /*
                         * arg is a compiled block with bytecode -
                         * directly call interpreter without going through Block>>value
                         */
                        __interpret(aBlock, 0, nil, IBLOCK_ARG, nil, nil);
                    } else {
                        /*
                         * arg is something else - call it with #value
                         */
                        (*blockVal.ilc_func)(aBlock, @symbol(value), nil, &blockVal);
                    }
                }
    outerLoop: ;
            } while (--tmp);

#           undef BLOCK_ARG
#           undef IBLOCK_ARG

            RETURN (self);
        }

        /*
         * not a block-like thingy - call it with #value
         */
        do {
            if (InterruptPending != nil) __interruptL(@line);
            (*blockVal.ilc_func)(aBlock, @symbol(value), nil, &blockVal);
        } while(--tmp);
        RETURN (self);
    }
#endif
%}.
    ^ super timesRepeat:aBlock

"/    |count "{ Class: SmallInteger }" |
"/
"/    count := self.
"/    [count > 0] whileTrue:[
"/        aBlock value.
"/        count := count - 1
"/    ]
!

to:stop by:incr do:aBlock
    "reimplemented as primitive for speed"

%{
#ifndef __SCHTEAM__
    REGISTER INT tmp, step;
    REGISTER INT final;
    static struct inlineCache blockVal = __ILC1(0);

    if (__bothSmallInteger(incr, stop)) {
        tmp = __intVal(self);
        final = __intVal(stop);
        step = __intVal(incr);

        if (__isBlockLike(aBlock)
         && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
            {
                REGISTER OBJFUNC codeVal;

                /*
                 * specially tuned version for static compiled blocks, called with
                 * home on the stack (the most common case)
                 */
                if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
# ifdef PARANOIA
                 && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))
# endif
                ) {

#                   define BLOCK_ARG  aBlock
                    {
                        if (step < 0) {
                            if (step == -1) {
                                while (tmp >= final) {
                                    if (InterruptPending != nil) __interruptL(@line);
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                                    tmp--;
                                }
                            } else {
                                while (tmp >= final) {
                                    if (InterruptPending != nil) __interruptL(@line);
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                                    tmp += step;
                                }
                            }
                        } else {
                            if (step == 1) {
                                while (tmp <= final) {
                                    if (InterruptPending != nil) __interruptL(@line);
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                                    tmp++;
                                }
                            } else {
                                while (tmp <= final) {
                                    if (InterruptPending != nil) __interruptL(@line);
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                                    tmp += step;
                                }
                            }
                        }
                        RETURN (self);
                    }
                }
            }

            /*
             * sorry - must check for the blocks code within the loops;
             * it could be recompiled or flushed (in the interrupt)
             */

#           undef BLOCK_ARG

#           define BLOCK_ARG  aBlock
#           define IBLOCK_ARG nil

            if (step < 0) {
                while (tmp >= final) {
                    REGISTER OBJFUNC codeVal;

                    if (InterruptPending != nil) __interruptL(@line);

                    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                        /*
                         * arg is a compiled block with code -
                         * directly call it without going through Block>>value
                         */
                        (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                    } else {
                        if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                            /*
                             * arg is a compiled block with bytecode -
                             * directly call interpreter without going through Block>>value
                             */
# ifdef PASS_ARG_POINTER
                            {
                                OBJ idx;

                                idx = __mkSmallInteger(tmp);
                                __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &idx);
                            }
# else
                            __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, __mkSmallInteger(tmp));
# endif

                        } else {
                            /*
                             * arg is something else - call it with #value
                             */
                            (*blockVal.ilc_func)(aBlock, @symbol(value:), nil, &blockVal, __mkSmallInteger(tmp));
                        }
                    }
                    tmp += step;
                }
            } else {
                while (tmp <= final) {
                    REGISTER OBJFUNC codeVal;

                    if (InterruptPending != nil) __interruptL(@line);

                    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                        /*
                         * arg is a compiled block with code -
                         * directly call it without going through Block>>value
                         */
                        (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                    } else {
                        if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                            /*
                             * arg is a compiled block with bytecode -
                             * directly call interpreter without going through Block>>value
                             */
# ifdef PASS_ARG_POINTER
                            {
                                OBJ idx;

                                idx = __mkSmallInteger(tmp);
                                __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &idx);
                            }
# else
                            __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, __mkSmallInteger(tmp));
# endif

                        } else {
                            /*
                             * arg is something else - call it with #value:
                             */
                            (*blockVal.ilc_func)(aBlock, @symbol(value:), nil, &blockVal, __mkSmallInteger(tmp));
                        }
                    }
                    tmp += step;
                }
            }

#           undef BLOCK_ARG
#           undef IBLOCK_ARG

        } else {
            /*
             * arg is something else - call it with #value:
             */
            if (step < 0) {
                while (tmp >= final) {
                    if (InterruptPending != nil) __interruptL(@line);

                    (*blockVal.ilc_func)(aBlock,
                                         @symbol(value:),
                                         nil, &blockVal,
                                         __mkSmallInteger(tmp));
                    tmp += step;
                }
            } else {
                while (tmp <= final) {
                    if (InterruptPending != nil) __interruptL(@line);

                    (*blockVal.ilc_func)(aBlock,
                                         @symbol(value:),
                                         nil, &blockVal,
                                         __mkSmallInteger(tmp));
                    tmp += step;
                }
            }
        }
        RETURN ( self );
    }
#endif
%}.
    "/
    "/ arrive here if stop is not a smallInteger
    "/ pass on to super ...

    ^ super to:stop by:incr do:aBlock

    "
     1 to:10 by:3 do:[:i | i printNewline]
    "
!

to:stop do:aBlock
    "evaluate aBlock for every integer between (and including) the receiver
     and the argument, stop.
     Reimplemented as primitive for speed"

%{
#ifndef __SCHTEAM__
    REGISTER INT tmp;
    INT final;
    static struct inlineCache blockVal = __ILC1(0);

    if (__isSmallInteger(stop)) {
        tmp = __intVal(self);
        final = __intVal(stop);

        if (__isBlockLike(aBlock)
         && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
            {
                /*
                 * specially tuned version for the most common case,
                 * where called with home on the stack
                 */
                REGISTER OBJFUNC codeVal;

                if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {

#                   define BLOCK_ARG  aBlock
                    {

# ifdef PARANOIA
                        if (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))
# endif
                        {
                            /*
                             * static compiled blocks ...
                             */
# ifdef __UNROLL_LOOPS__
                            /*
                             * The following code is designed to run as fast as possible;
                             *  - taken branches only if interrupts are pending
                             *  - only forward branches (which are usually predicted as not taken)
                             *  - unrolled the loop
                             *
                             * you are not supposed to program like this - I know what I do
                             */
#  if TAG_INT==1
                            INT t8 = (INT)(__mkSmallInteger(tmp+8));
                            tmp = (INT)(__mkSmallInteger(tmp));
                            final = (INT)(__mkSmallInteger(final));
#  else
                            INT t8 = tmp+8;
#  endif

                            for (;;) {

                                while (t8 <= final) {
#  if TAG_INT==1
                                    t8 += (INT)(__MASKSMALLINT(8));
#  else
                                    t8 += 8;
#  endif
                                    if (InterruptPending != nil) goto interrupted0;
        continue0:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp);
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
#  endif
                                    if (InterruptPending != nil) goto interrupted1;
        continue1:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(1)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+1));
#  endif
                                    if (InterruptPending != nil) goto interrupted2;
        continue2:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(2)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+2));
#  endif
                                    if (InterruptPending != nil) goto interrupted3;
        continue3:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(3)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+3));
#  endif
                                    if (InterruptPending != nil) goto interrupted4;
        continue4:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(4)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+4));
#  endif
                                    if (InterruptPending != nil) goto interrupted5;
        continue5:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(5)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+5));
#  endif
                                    if (InterruptPending != nil) goto interrupted6;
        continue6:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(6)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+6));
#  endif
                                    if (InterruptPending != nil) goto interrupted7;
        continue7:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp+(INT)(__MASKSMALLINT(7)) );
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp+7));
#  endif

#  if TAG_INT==1
                                    tmp += (INT)(__MASKSMALLINT(8));
#  else
                                    tmp += 8;
#  endif
                                }
                                while (tmp <= final) {
                                    if (InterruptPending != nil) goto interruptedX;
        continueX:
#  if TAG_INT==1
                                    (*codeVal)(BLOCK_ARG, tmp);
                                    tmp += (INT)(__MASKSMALLINT(1));
#  else
                                    (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                                    tmp++;
#  endif
                                }
                                RETURN (self);

                                if (0) {
                                    /*
                                     * no discussion about those gotos ...
                                     * ... its better for your CPU's pipelines
                                     * (if you don't understand why, just don't argue).
                                     */
                                    interrupted7:
                                                    __interruptL(@line); goto continue7;
                                    interrupted6:
                                                    __interruptL(@line); goto continue6;
                                    interrupted5:
                                                    __interruptL(@line); goto continue5;
                                    interrupted4:
                                                    __interruptL(@line); goto continue4;
                                    interrupted3:
                                                    __interruptL(@line); goto continue3;
                                    interrupted2:
                                                    __interruptL(@line); goto continue2;
                                    interrupted1:
                                                    __interruptL(@line); goto continue1;
                                    interrupted0:
                                                    __interruptL(@line); goto continue0;
                                    interruptedX:
                                                    __interruptL(@line); goto continueX;
                                }
                            }
# else
                            while (tmp <= final) {
                                if (InterruptPending != nil) __interruptL(@line);
                                (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                                tmp ++;
                            }
                            RETURN (self);
# endif /* __UNROLL_LOOPS__ */
                        }

                        /*
                         * mhmh - seems to be a block with dynamic code
                         * must refetch, to allow dynamic recompilation or code flush.
                         */
                        while (tmp <= final) {
                            if (InterruptPending != nil) __interruptL(@line);
                            if ((codeVal = __BlockInstPtr(aBlock)->b_code) == (OBJFUNC)nil) break;
                            (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                            tmp ++;
                        }

                        if (tmp > final) {
                            RETURN (self);
                        }
                    }
                }
            }

#           undef BLOCK_ARG

#           define BLOCK_ARG  aBlock
#           define IBLOCK_ARG nil

            /*
             * sorry - must check for the blocks code within the loops;
             * it could be recompiled or flushed (in the interrupt)
             */
            while (tmp <= final) {
                REGISTER OBJFUNC codeVal;

                if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
                    /*
                     * arg is a compiled block with code -
                     * directly call it without going through Block>>value
                     */

                    /* stay here, while no interrupts are pending ... */
                    do {
                        (*codeVal)(BLOCK_ARG, __mkSmallInteger(tmp));
                        if (InterruptPending != nil) goto outerLoop;
                        tmp++;
                    } while (tmp <= final);
                    RETURN (self);
                } else {
                    if (InterruptPending != nil) __interruptL(@line);

                    if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
                        /*
                         * arg is a compiled block with bytecode -
                         * directly call interpreter without going through Block>>value
                         */
# ifdef PASS_ARG_POINTER
                        {
                            OBJ idx;

                            idx = __mkSmallInteger(tmp);
                            __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &idx);
                        }
# else
                        __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, __mkSmallInteger(tmp));
# endif

                    } else {
                        /*
                         * arg is something else - call it with #value:
                         */
                        (*blockVal.ilc_func)(aBlock, @symbol(value:), nil, &blockVal, __mkSmallInteger(tmp));
                    }
                }
            outerLoop: ;
                tmp++;
            }

#           undef BLOCK_ARG
#           undef IBLOCK_ARG

            RETURN (self);
        }
        /*
         * arg is something else - call it with #value:
         */
        while (tmp <= final) {
            if (InterruptPending != nil) __interruptL(@line);

            (*blockVal.ilc_func)(aBlock,
                                         @symbol(value:),
                                         nil, &blockVal,
                                         __mkSmallInteger(tmp));
            tmp++;
        }
        RETURN ( self );
    }
#endif /* not __SCHTEAM__ */
%}.

    "/
    "/ arrive here if stop is not a smallInteger
    "/ pass on to super ...
    "/
    ^ super to:stop do:aBlock

    "
     1 to:10 do:[:i | i printNewline]
    "
! !

!SmallInteger methodsFor:'misc math'!

bernoulli
    "returns the nth Bernoulli number.
     The series runs this:
         1/6, 1/30, 1/42, 1/30, 5/66, 691/2730, etc
     Uses a table of the first 20 bernoulli numbers.
     So bernoulli(42) will fail for now.
     Used with taylor series for tan"

    |table p|

    table := #(
                (1 6)
                (-1 30)
                (1 42)
                (-1 30)
                (5 66)
                (-691 2730)
                (7 6)
                (-3617 510)
                (43867 798)
                (-174611 330)
                (854513 138)
                (-236364091 2730)
                (8553103 6)
                (-23749461029 870)
                (8615841276005 14322)
                (-7709321041217 510)
                (2577687858367 6)
                (-26315271553053477373 1919190)
                (2929993913841559 6)
                (-261082718496449122051 13530)
              ).

    self even ifTrue:[
        self == 0 ifTrue:[^1].
        p := table at:(self / 2).
        ^ Fraction numerator:(p first) denominator:(p second).
    ].
    self == 1 ifTrue:[ ^ (1 / 2) ].
    ^ 0.

    "
     0 bernoulli
     1 bernoulli
     2 bernoulli
     3 bernoulli
     4 bernoulli
     5 bernoulli
     6 bernoulli
     8 bernoulli
     38 bernoulli
     40 bernoulli
     41 bernoulli
     42 bernoulli
    "
!

divMod:aNumber
    "return an array filled with
        (self // aNumber) and (self \\ aNumber).
     The returned remainder has the same sign as aNumber.
     The following is always true:
        (receiver // something) * something + (receiver \\ something) = receiver

     Be careful with negative results: 9 // 4 -> 2, while -9 // 4 -> -3.
     Especially surprising:
        -1 \\ 10 -> 9  (because -(1/10) is truncated towards next smaller integer, which is -1,
                        and -1 multiplied by 10 gives -10, so we have to add 9 to get the original -1).
        -10 \\ 3 -> 2 (because -(10/3) is truncated towards next smaller integer, which is -4,
                        and -4 * 4 gives -12, so we need to add 2 to get the original -10.

     This is redefined here for more performance"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT val, div, mod, mySelf;

    if (__isSmallInteger(aNumber)
     && ((val = __intVal(aNumber)) > 0)
     && ((mySelf = __intVal(self)) >= 0)) {
        div = mySelf / val;
        mod = mySelf % val;

        RETURN (__ARRAY_WITH2( __mkSmallInteger(div), __mkSmallInteger(mod)));
    }
#endif
%}.
    ^ super divMod:aNumber

    "
     10 // 3           -> 3
     10 \\ 3           -> 1

     10 // -3          -> -4
     10 \\ -3          -> -2

     -10 // 3          -> -4
     -10 \\ 3          -> 2

     -10 // -3         -> 3
     -10 \\ -3         -> -1

     -78 \\ 10         2
     -78 // 10         -8

     10 divMod:3       -> #(3 1)   because 3*3 + 1 = 10
     10 divMod:-3      -> #(-4 -2) because -4*-3 + (-2) = 10
     -10 divMod:3      -> #(-4 2)  because -4*3 + 2 = -10
     -10 divMod:-3     -> #(3 -1)  because -3*3 + (-1) = -10

     1000000000000000000000 divMod:3   -> #(333333333333333333333 1)
     1000000000000000000000 divMod:-3  -> #(-333333333333333333334 -2)
     -1000000000000000000000 divMod:3  -> #(-333333333333333333334 2)
     -1000000000000000000000 divMod:-3 -> #(333333333333333333333 -1)
     100 factorial divMod:103
    "
!

gcd:anInteger
    "return the greatest common divisor (Euclid's algorithm).
     This has been redefined here for more speed since due to the
     use of gcd in Fraction code, it has become time-critical for
     some code. (thanx to MessageTally)"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    if (__isSmallInteger(anInteger)) {
        INT orgArg, ttt, selfInt, orgSelfInt, temp;

        ttt = orgArg = __intVal(anInteger);
        if (ttt) {
            selfInt = orgSelfInt = __intVal(self);
            while (ttt != 0) {
                temp = selfInt % ttt;
                selfInt = ttt;
                ttt = temp;
            }
            /*
             * since its not defined in C, what the sign of
             * a modulus result is when the arg is negative,
             * change it explicitely here ...
             */
            if (orgArg < 0) {
                /* result should be negative */
                if (orgSelfInt > 0) selfInt = -selfInt;
            } else {
                /* result should be positive */
                if (orgSelfInt < 0) selfInt = -selfInt;
            }
            RETURN ( __mkSmallInteger(selfInt) );
        }
    }
#endif
%}.
    ^ super gcd:anInteger
!

gcd_helper:anInteger
    "same as gcd - see knuth & Integer>>gcd:"

    ^ self gcd:anInteger

    "Created: 1.3.1997 / 16:58:01 / cg"
!

intlog10
    "return the truncation of log10 of the receiver.
     The same as (self log:10) floor.
     Stupid implementation, which is used to find out the number of digits needed
     to print a number/and for conversion to a LargeInteger.
     Implemented that way, to allow for tiny systems (PDAs) without a Float class
     (i.e. without log)."

    self > 0 ifTrue:[
        self < 10000 ifTrue:[
            self < 10 ifTrue:[^ 0].
            self < 100 ifTrue:[^ 1].
            self < 1000 ifTrue:[^ 2].
            ^ 3
        ].
        self < 100000000 ifTrue:[
            self < 100000 ifTrue:[^ 4].
            self < 1000000 ifTrue:[^ 5].
            self < 10000000 ifTrue:[^ 6].
            ^ 7
        ].
        self < 1000000000 ifTrue:[^ 8].
        SmallInteger maxBytes == 4 ifTrue:[
            "/ on a 32 bit machine, SmallInt cannot be larger
            ^ 9
        ].

        "/ 64 bit machine
        self < 100000000000000 ifTrue:[
            self < 10000000000 ifTrue:[^ 9].
            self < 100000000000 ifTrue:[^ 10].
            self < 1000000000000 ifTrue:[^ 11].
            self < 10000000000000 ifTrue:[^ 12].
            ^ 13
        ].
        self < 1000000000000000 ifTrue:[^ 14].
        self < 10000000000000000 ifTrue:[^ 15].
        self < 100000000000000000 ifTrue:[^ 16].
        self < 1000000000000000000 ifTrue:[^ 17].
        ^ 18.
    ].

    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#intlog10
        arguments:#()
        errorString:'logarithm of negative integer'

    "
      99 intlog10
      100 intlog10
      101 intlog10
      (101 log:10) floor
      120 intlog10
      -1 intlog10
    "
! !

!SmallInteger methodsFor:'printing & storing'!

asBCD
    "return an integer which represents the BCD encoded value of the receiver;
     that is: each digit of its decimal representation is placed into a nibble
     of the result. (aka 162 -> 0x162). The BCD hex string looks like the original decimal.
     This conversion is useful for some communication protocols,
     or control systems, which represent numbers this way..."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    // the following code is a leftover from times when division was expensive;
    // in modern cpu's, conditional branches are often more expensive than divisions,
    // so it is questionable, if the effort below is still worth it.
    // (and asBCD is really used seldom in some serial communication protocols
    // for control systems)
    int i;
    INT _10000000s = 0, _1000000s = 0;
    INT _100000s = 0, _10000s = 0, _1000s = 0;
    INT _100s = 0, _10s = 0, _1s = 0;
    INT b = __intVal(self);
    unsigned INT rslt;

    if (b <= 99999999) {
        if (b <= 255) {
            // the most common case: convert bytes
            for (i=7; i>=0; i--) {
                if (_100s >= 5)       _100s += 3;
                if (_10s >= 5)        _10s += 3;
                if (_1s >= 5)         _1s += 3;

                _100s    =    (_100s<<1)       | (_10s >> 3 & 1);       _100s &= 0xF;
                _10s     =    (_10s<<1)        | (_1s >> 3 & 1);        _10s &= 0xF;
                _1s      =    (_1s<<1)         | (b >> 7 & 1);          _1s &= 0xF;
                b <<= 1;
            }
            rslt = (_100s<<8) | (_10s<<4) | _1s;
            RETURN (__MKSMALLINT( rslt) );
        }

        for (i=26; i>=0; i--) {
            if (_10000000s >= 5)  _10000000s += 3;
            if (_1000000s >= 5)   _1000000s += 3;
            if (_100000s >= 5)    _100000s += 3;
            if (_10000s >= 5)     _10000s += 3;
            if (_1000s >= 5)      _1000s += 3;
            if (_100s >= 5)       _100s += 3;
            if (_10s >= 5)        _10s += 3;
            if (_1s >= 5)         _1s += 3;

            _10000000s =  (_10000000s<<1)  | (_1000000s >> 3 & 1);  _10000000s &= 0xF;
            _1000000s =   (_1000000s<<1)   | (_100000s >> 3 & 1);   _1000000s &= 0xF;
            _100000s =    (_100000s<<1)    | (_10000s >> 3 & 1);    _100000s &= 0xF;
            _10000s  =    (_10000s<<1)     | (_1000s >> 3 & 1);     _10000s &= 0xF;
            _1000s   =    (_1000s<<1)      | (_100s >> 3 & 1);      _1000s &= 0xF;
            _100s    =    (_100s<<1)       | (_10s >> 3 & 1);       _100s &= 0xF;
            _10s     =    (_10s<<1)        | (_1s >> 3 & 1);        _10s &= 0xF;
            _1s      =    (_1s<<1)         | (b >> 26 & 1);         _1s &= 0xF;
            b <<= 1;
        }

        rslt = (_10000000s<<28)
               | (_1000000s<<24) | (_100000s<<20) | (_10000s<<16)
               | (_1000s<<12) | (_100s<<8) | (_10s<<4) | _1s;
        RETURN (__MKUINT( rslt) );
    }
#endif
%}.
    ^ super asBCD.

    "
      99999999 asBCD hexPrintString
      12812345 asBCD hexPrintString
      128123 asBCD hexPrintString
      128901 asBCD hexPrintString
      12890 asBCD hexPrintString
      1289 asBCD hexPrintString
      999 asBCD hexPrintString
      256 asBCD hexPrintString
      255 asBCD hexPrintString
      128 asBCD hexPrintString
      162 asBCD hexPrintString

      999999999 asBCD hexPrintString
      128123456 asBCD hexPrintString

    "
!

printOn:aStream
    "append my printstring (base 10) to aStream."

    aStream nextPutAll:(self printString)
!

printOn:aStream base:base showRadix:showRadix
    "append a string representation of the receiver in the specified numberBase to aStream
     (if showRadix is true, with initial XXr)
     The base argument should be between 2 and 36."

    |absBase|

    (base isInteger and:[absBase := base abs. absBase between:2 and:36]) ifTrue:[
        showRadix ifTrue:[
            absBase printOn:aStream.
            aStream nextPut:$r.
        ].
        aStream nextPutAll:(self printStringRadix:base)
    ] ifFalse:[
        super printOn:aStream base:base showRadix:true.
    ].

    "Created: / 07-09-2001 / 13:54:40 / cg"
    "Modified: / 02-08-2010 / 12:25:20 / cg"
!

printString
    "return my printstring (base 10)"

    "since this was heavily used in some applications,
     here is an exception to the rule of basing printString
     upon the printOn: method."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( new STString( java.lang.Long.toString(self.longValue()) ));
#else
    char buffer[30];    /* enough for 64 bit integers (21 would be enough)  */
    char *cp;
    OBJ newString = nil;
    INT myValue;
    int negative = 0;

    if (self == __MKSMALLINT(0)) {
        RETURN (@global(ZeroString));
//        RETURN (__MKSTRING_L("0", 1));
    }
    myValue = __intVal(self);
    if (myValue < 0) {
        negative = 1;
        myValue = -myValue;
    }
    cp = buffer + sizeof(buffer) - 1;
    *cp-- = '\0';
    for ( ; myValue != 0; cp--) {
        *cp = '0' + (myValue % 10);
        myValue /= 10;
    }
    if (negative) {
        *cp-- = '-';
    }
    newString = __MKSTRING_L(cp+1, (buffer + sizeof(buffer) - 2 - cp));
    if (newString != nil) {
        RETURN (newString);
    }
#endif /* not __SCHTEAM__ */
%}.
    "/ only arrive here,
    "/  when having memory problems (i.e. no space for string) ...
    ^ super printString

    "
     1234 printString
     0    printString
     -100 printString

    Time millisecondsToRun:[ 1000000 timesRepeat:[ 123456789012 printString ]] 180 180 180 170 180
    Time millisecondsToRun:[ 1000000 timesRepeat:[ 12345678 printString ]]     140 150 140 150 140
    Time millisecondsToRun:[ 1000000 timesRepeat:[ 1234 printString ]]         130 140 130 130 130
    Time millisecondsToRun:[ 1000000 timesRepeat:[ 12 printString ]]           130 120 120 120 110
    Time millisecondsToRun:[ 1000000 timesRepeat:[ 5 printString ]]            110 110 100 110 90
    Time millisecondsToRun:[ 1000000 timesRepeat:[ 0 printString ]]             60
    "
!

printStringRadix:base
    "return my printstring (optimized for bases 16, 10 and 8).
     Print digits > 0 as uppercase chars if base > 0,
     as lowercase chars if base < 0."

    |s|

%{
#ifdef __SCHTEAM__
    int __base = base.intValue().abs();
    long myValue = self.longValue();
    java.lang.String __s;

    switch (__base) {
        case 2:
            __s = java.lang.Long.toBinaryString(myValue);
            break;

        case 8:
            __s = java.lang.Long.toOctalString(myValue);
            break;

        case 10:
            __s = java.lang.Long.toString(myValue);
            break;

        case 16:
            __s = java.lang.Long.toHexString(myValue);
            break;

        default:
        {
            boolean negative = false;
            __s = "";

            if ((__base > 36) || (__base < 2)) {
                throw new SmalltalkError("invalid base: ", base);
            }
            if (myValue < 0) {
                negative = true;
                myValue = -myValue;
            }
            while (myValue != 0) {
                int digit;
                char ch;

                digit = (int)(myValue % __base);
                if (digit <= 9) {
                    ch = (char)('0' + digit);
                } else {
                    ch = (char)('A' + digit - 10);
                }
                __s = ch + __s;
                myValue = myValue / __base;
            }
            if (negative) {
                __s = "-" + __s;
            }
            break;
        }
    }
    return context._RETURN( new STString( __s ));
#else
    static char ucDigits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    static char lcDigits[] = "0123456789abcdefghijklmnopqrstuvwxyz";

    if (__isSmallInteger(base)) {
        char *digits;
        INT __base;

        if (self == __MKSMALLINT(0)) {
            RETURN (@global(ZeroString));
        }
        __base = __intVal(base);
        if (__base < 0) {
            __base = - __base;
            digits = lcDigits;
        } else {
            digits = ucDigits;
        }

        if ((__base < sizeof(ucDigits)) && (__base > 1)) {
            char buffer[64+5];  /* for 64bit machines, base 2, plus sign, plus 0-byte */
            char *cp;
            OBJ newString;
            int negative = 0;
            INT myValue = __intVal(self);

            if (myValue < 0) {
                negative = 1;
                myValue = -myValue;
            }
            cp = buffer + sizeof(buffer) - 1;
            *cp-- = '\0';
            for (; myValue != 0; cp--) {
                *cp = digits[myValue % __base];
                myValue /= __base;
            }
            if (negative) {
                *cp-- = '-';
            }
            newString = __MKSTRING_L(cp+1, (buffer + sizeof(buffer) - 2 - cp));
            if (newString != nil) {
                RETURN (newString);
            }
        }
    }
#endif /* not __SCHTEAM__ */
%}.
    "/ arrive here, for bad base,
    "/ or when having memory problems (i.e. no space for string) ...

    "/
    "/ fall back for seldom used bases
    "/ Notice: cannot use super>>printStringRadix: here,
    "/ since that would lead to endless recursion ...
    "/ (a consequence of reversing printOn / printString functionality)

    s := WriteStream on:(String new:10).
    super printOn:s base:base.
    ^ s contents.

    "
      127 printStringRadix:16
      127 printStringRadix:-16
      -127 printStringRadix:16
      -127 printStringRadix:-16
      123 printStringRadix:12
      123 printStringRadix:10
      123 printStringRadix:8
      123 printStringRadix:3
      123 printStringRadix:2
      123 printStringRadix:1
      35 printStringRadix:36
      123 printStringRadix:37

      -127 printStringRadix:16
      -123 printStringRadix:12
      -123 printStringRadix:10
      -123 printStringRadix:8
      -123 printStringRadix:3
      -123 printStringRadix:2

      16r3FFFFFFF printStringRadix:16
      16r7FFFFFFF printStringRadix:16
      16rFFFFFFFF printStringRadix:16
      16r3FFFFFFFFFFFFFFF printStringRadix:16
      16r7FFFFFFFFFFFFFFF printStringRadix:16
      16rFFFFFFFFFFFFFFFF printStringRadix:16

      -16r3FFFFFFF printStringRadix:16
      -16r40000000 printStringRadix:16
      -16r7FFFFFFF printStringRadix:16
      -16r80000000 printStringRadix:16
      -16rFFFFFFFF printStringRadix:16
      -16r3FFFFFFFFFFFFFFF printStringRadix:16
      -16r7FFFFFFFFFFFFFFF printStringRadix:16
      -16rFFFFFFFFFFFFFFFF printStringRadix:16
      -16r4000000000000000 printStringRadix:16
      -16r8000000000000000 printStringRadix:16
    "
!

printfPrintString:formatString
    "non-standard, but sometimes useful.
     return a printed representation of the receiver
     as specified by formatString, which is defined by the C-function 'printf'.
     No checking for string overrun - the resulting string
     must be shorter than 256 chars or else ...
     This method is NONSTANDARD and may be removed without notice;
     it is provided to allow special conversions in very special situations.
     Notice that a conversion may not be portable; for example,
     to correctly convert an int on a 64-bit alpha, a %ld is required,
     on 64bit mingw or visualc, %lld is required,
     while other systems may be happy with a %d.
     You cannot use lld unconditionally, because some (old) c printfs do not support it!!)
     Use at your own risk (if at all).
     WARNNG: this goes directly to the C-printf function and may therefore be inherently unsafe.
     Please use the printf: method, which is safe as it is completely implemented in Smalltalk."

%{  /* STACK: 400 */
#ifndef __SCHTEAM__
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

        len = snprintf(buffer, sizeof(buffer), __stringVal(formatString), __intVal(self));

        __END_PROTECT_REGISTERS__

        if (len < 0) goto fail;

        s = __MKSTRING_L(buffer, len);
        if (s != nil) {
            RETURN (s);
        }
    }
fail: ;
#endif /* not __SCHTEAM__ */
%}.
    self primitiveFailed

    "
        123 printfPrintString:'%%d -> %d'
        123 printfPrintString:'%%6d -> %6d'
        123 printfPrintString:'%%x -> %x'
        123 printfPrintString:'%%4x -> %4x'
        123 printfPrintString:'%%04x -> %04x'
    "
! !

!SmallInteger methodsFor:'private'!

setSign:aNumber
    "private: for protocol completeness with LargeIntegers.
     Returns a smallInteger with my absValue and the sign of the argument.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned."

    |absVal|

    absVal := self abs.
    aNumber < 0 ifTrue:[
        ^ absVal negated
    ].
    aNumber == 0 ifTrue:[^ 0].
    ^ absVal

    "
     -4 sign:-1
     -4 sign:0
     -4 sign:1
     -4 sign:-1
     -4 sign:0
     -4 sign:1
    "
!

sign:aNumber
    <resource: #obsolete>
    "private: for protocol completeness with LargeIntegers.
     Returns a smallInteger with my absValue and the sign of the argument.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned."

    ^ self setSign:aNumber

    "
     -4 sign:-1
     -4 sign:0
     -4 sign:1
     -4 sign:-1
     -4 sign:0
     -4 sign:1
    "
! !

!SmallInteger methodsFor:'special modulo arithmetic'!

plus32:aNumber
    "return the sum of the receiver and the argument, as SmallInteger.
     The argument must be another SmallInteger.
     If the result overflows the 32 bit range, the value modulo 16rFFFFFFFF is returned.
     This is of course not always correct, but allows for C/Java behavior to be emulated."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT sum;

    sum =  __unsignedLongIntVal(self) + __unsignedLongIntVal(aNumber);
# if __POINTER_SIZE__ == 8
    sum &= 0xFFFFFFFFL;
# endif
    RETURN ( __MKUINT(sum));
#endif /* not __SCHTEAM__ */
%}.
    self primitiveFailed

    "
     16r7FFFFFFF + 1          2147483648
     16r7FFFFFFF plus32: 1
    "
!

plus:aNumber
    "return the sum of the receiver and the argument, as SmallInteger.
     The argument must be another SmallInteger.
     If the result overflows the smallInteger range, the value modulo the
     smallInteger range is returned (i.e. the low bits of the sum).
     This is of course not always correct, but some code does a modulo anyway
     and can therefore speed things up by not going through LargeIntegers."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
        long myValue = self.longValue();
        long otherValue = aNumber.longValue();
        long sum = myValue + otherValue;
        return context._RETURN( STInteger._new(sum) );
    }
    /* NOT REACHED */
#else
    if (__isSmallInteger(aNumber)) {
        INT sum;

        sum =  __intVal(self) + __intVal(aNumber);
        if (!__ISVALIDINTEGER(sum)) {
            /* keep the sign */
            sum %= _MAX_INT;
        }
        RETURN ( __mkSmallInteger(sum));
    }
#endif
%}.
    self primitiveFailed

    "
        5 plus:-1
        5 plus:1
        1 plus:-5
        self maxVal plus:1
        self maxVal + 1
    "
!

subtract:aNumber
    "return the difference of the receiver and the argument, as SmallInteger.
     The argument must be another SmallInteger.
     If the result overflows the smallInteger range, the value modulo the
     smallInteger range is returned (i.e. the low bits of the sum).
     This is of course not always correct, but some code does a modulo anyway
     and can therefore speed things up by not going through LargeIntegers."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
        long myValue = self.longValue();
        long otherValue = aNumber.longValue();
        long diference = myValue - otherValue;
        return context._RETURN( STInteger._new(diference) );
    }
    /* NOT REACHED */
#else

    if (__isSmallInteger(aNumber)) {
        INT diff;

        diff = __intVal(self) - __intVal(aNumber);
        if (!__ISVALIDINTEGER(diff)) {
            /* keep the sign */
            diff %= _MAX_INT;
        }
        RETURN ( __mkSmallInteger(diff));
    }
#endif
%}.
    self primitiveFailed

    "
        -1 subtract:5
        5 subtract:1
        1 subtract:-5
        self minVal subtract:1
        self minVal - 1
    "
!

times:aNumber
    "return the product of the receiver and the argument, as SmallInteger.
     The argument must be another SmallInteger.
     If the result overflows the smallInteger range, the value modulo the
     smallInteger range is returned (i.e. the low bits of the product).
     This is of course not always correct, but some code does a modulo anyway
     and can therefore speed things up by not going through LargeIntegers."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
        long myValue = self.longValue();
        long otherValue = aNumber.longValue();
        long product = myValue * otherValue;
        return context._RETURN( STInteger._new(product) );
    }
    /* NOT REACHED */
#else
    INT myValue, otherValue;
    unsigned INT productLow, productHi;
    int negative;

#   define low16Bits(foo)  ((foo) & 0xFFFF)
#   define hi16Bits(foo)   ((foo) >> 16)
#   define low32Bits(foo)  ((foo) & 0xFFFFFFFFL)
#   define hi32Bits(foo)   ((foo) >> 32)

    /*
     * can we use long long arithmetic ?
     *
     * long-long arithmetic seems to be buggy with some systems
     * (took me a while to find this out :-(
     * (try 10000 * 10000)
     */
# if defined(__sparc__) && defined(__GNUC__) && (__GNUC__ >= 2)
#  define USE_LONGLONG_FOR_MUL
# endif

# if defined(__i386__) && defined(__GNUC__) && (__GNUC__ >= 2)
#  define USE_LONGLONG_FOR_MUL
# endif

    if (__isSmallInteger(aNumber)) {
        myValue = __intVal(self);
        otherValue = __intVal(aNumber);

# if defined(USE_LONGLONG_FOR_MUL)
        {
#  if defined(__alpha__) && !defined(__alpha64__)
#   define LONGLONG      INT64
#  else
#   define LONGLONG      long long
#  endif
            LONGLONG product;

            product = (LONGLONG)myValue * (LONGLONG)otherValue;
            if (product < 0) {
                RETURN ( __mkSmallInteger(-(INT)(-product & _MAX_INT)));
            }
            RETURN ( __mkSmallInteger((INT)(product & _MAX_INT)));
        }
# else /* no long-long */
        negative = 1;
        if (myValue < 0) {
            negative = -1;
            myValue = -myValue;
        }
        if (otherValue < 0) {
            negative = -negative;
            otherValue = -otherValue;
        }

#  if defined(__GNUC__) && defined(__mc68k__)
        asm ("mulu%.l %3,%1:%0"
                : "=d"  ((unsigned long)(productLow)),
                  "=d"  ((unsigned long)(productHi))
                : "%0"  ((unsigned long)(myValue)),
                  "dmi" ((unsigned long)(otherValue)));
#  else
#   if defined (__GNUC__) && defined(__x86__)
        asm ("mull %3"
                : "=a"  ((unsigned long)(productLow)),
                  "=d"  ((unsigned long)(productHi))
                : "%0"  ((unsigned long)(myValue)),
                  "rm"  ((unsigned long)(otherValue)));
#   else
#    if defined(__win32__) && defined(__BORLANDC__)
        asm {
            mov   eax, myValue
            mov   edx, otherValue
            mul   edx
            mov   productLow, eax
            mov   productHi, edx
        }
#    else /* generic */
        {
            unsigned INT pHH, pHL, pLH, pLL;
            unsigned INT low1, low2, hi1, hi2;
            unsigned INT t;

            /* unsigned multiply myValue * otherValue -> productHi, productLow
             *
             * this is too slow:
             * since most machines can do 32*32 to 64 bit multiply,
             * (or at least 32*32 with Overflow check)
             * - need more assembler (inline) functions here
             */
#     if __POINTER_SIZE__ == 8
            low1 = low32Bits((unsigned INT)myValue);
            hi1 = hi32Bits((unsigned INT)myValue);
            low2 = low32Bits((unsigned INT)otherValue);
            hi2 = hi32Bits((unsigned INT)otherValue);
#      undef LLMASK
#      define LLMASK 0xC000000000000000LL
#     else
            low1 = low16Bits((unsigned INT)myValue);
            hi1 = hi16Bits((unsigned INT)myValue);
            low2 = low16Bits((unsigned INT)otherValue);
            hi2 = hi16Bits((unsigned INT)otherValue);
#      define LLMASK 0xC0000000
#     endif

            pLH = low1 * hi2;
            pHL = hi1 * low2;
            pLL = low1 * low2;
            pHH = hi1 * hi2;

            /*
             * the common case ...
             */
            if ((pHL == 0)
             && (pLH == 0)
             && (pHH == 0)
             && ((pLL & LLMASK) == 0)) {
                if (negative < 0) {
                    RETURN ( __mkSmallInteger(- ((INT)pLL)) );
                }
                RETURN ( __mkSmallInteger((INT)pLL) );
            }

            /*
             *   pHH |--------|--------|
             *   pLH          |--------|--------|
             *   pHL          |--------|--------|
             *   pLL                   |--------|--------|
             */

#     if __POINTER_SIZE__ == 8
            t = low32Bits(pLH) + low32Bits(pHL) + hi32Bits(pLL);
            productLow = (t << 32) + low32Bits(pLL);
            productHi = pHH + hi32Bits(t) + hi32Bits(pHL) + hi32Bits(pLH);
#     else
            t = low16Bits(pLH) + low16Bits(pHL) + hi16Bits(pLL);
            productLow = (t << 16) + low16Bits(pLL);
            productHi = pHH + hi16Bits(t) + hi16Bits(pHL) + hi16Bits(pLH);
#     endif
        }
#    endif /* ! __win32__ */
#   endif /* ! (__GNUC__ && __x86__) */
#  endif /* ! (__GNUC__ && __mc68k__) */

        if (negative < 0) {
            RETURN ( __mkSmallInteger(-(INT)(productLow & _MAX_INT)));
        }
        RETURN ( __mkSmallInteger((INT)(productLow & _MAX_INT)));
# endif /* ! USE_LONGLONG */
    }
#endif /* not __SCHTEAM__ */
%}.

    self primitiveFailed

    "
        5 times:-1
        5 times:1
        self maxVal-1 times:2
        self maxVal-1 times:-2
        self maxVal-1 * 2  bitAnd:16r3fffffff
    "
! !

!SmallInteger methodsFor:'special modulo bit operators'!

bitInvert32
    "return the value of the receiver with all bits inverted in 32bit signed int space
     (changes the sign)"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    unsigned INT v;

    v = __intVal(self);
    v = ~v;
# if __POINTER_SIZE__ == 8
    v &= 0xFFFFFFFFL;
# endif
    RETURN ( __MKUINT(v) );
#endif
%}.
    ^ self primitiveFailed

    "
     1 bitInvert32
     16r40000000 bitInvert32
     16r80000000 bitInvert32
    "
!

bitRotate32:shiftCount
    "return the value of the receiver rotated by shiftCount bits,
     but only within 32 bits, rotating left for positive, right for negative counts.
     Rotates through the sign bit.
     Useful for crypt algorithms, or to emulate C/Java semantics."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__

    unsigned INT bits;
    int count;

    if (__isSmallInteger(shiftCount)) {
        count = __intVal(shiftCount);
        count = count % 32;

        bits = __intVal(self);
        if (count > 0) {
            bits = (bits << count) | (bits >> (32-count));
        } else {
            bits = (bits >> (-count)) | (bits << (32-(-count)));
        }
# if __POINTER_SIZE__ == 8
        bits &= 0xFFFFFFFFL;
# endif
        RETURN (__MKUINT(bits));
    }
#endif
%}.
    ^ self primitiveFailed

    "
     128 rotate32:1

     1 rotate32:1
     1 rotate32:2
     1 rotate32:31
     1 rotate32:32

     1 rotate32:-1
     1 rotate32:-2
     1 rotate32:-3
     1 rotate32:-32
    "
!

bitShift32:shiftCount
    "return the value of the receiver shifted by shiftCount bits,
     but only within 32 bits, shifting into/out-of the sign bit.
     May be useful for communication interfaces, to create ST-numbers
     from a signed 32bit int value given as individual bytes,
     or to emulate C/Java semantics."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__

    INT bits, count;

    if (__isSmallInteger(shiftCount)) {
        count = __intVal(shiftCount);
        if (count >= 32) {
            RETURN (__mkSmallInteger(0));
        }

        bits = __intVal(self);
        if (count > 0) {
            bits = bits << count;
        } else {
            bits = bits >> (-count);
        }
# if __POINTER_SIZE__ == 8
        bits &= 0xFFFFFFFFL;
# endif
        RETURN (__MKINT(bits));
    }
#endif
%}.
    ^ self primitiveFailed

    "
     128 bitShift:24
     128 bitShift32:24

     1 bitShift:31
     1 bitShift32:31
    "
!

bitXor32:aNumber
    "return the xor of the receiver and the argument.
     The argument must be another SmallInteger or a 4-byte LargeInteger.
     If the result overflows the 32 bit range, the value modulo 16rFFFFFFFF is returned.
     This is of course not always correct, but allows for C/Java behavior to be emulated."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT rslt;

    rslt =  __unsignedLongIntVal(self) ^ __unsignedLongIntVal(aNumber);
# if __POINTER_SIZE__ == 8
    rslt &= 0xFFFFFFFFL;
# endif
    RETURN ( __MKUINT(rslt));
#endif
%}.
    self primitiveFailed

    "
     16r7FFFFFFF bitXor: 16r80000000          4294967295
     16r7FFFFFFF bitXor32: 16r80000000
    "
!

unsignedBitShift32:shiftCount
    "return the value of the receiver shifted by shiftCount bits,
     but only within 32 unsigned bits.
     May be useful for communication interfaces, to create ST-numbers
     from an unsigned 32bit int value given as individual byte,
     or to emulate C/Java semantics."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__

    unsigned INT bits;
    INT count;

    if (__isSmallInteger(shiftCount)) {
        count = __intVal(shiftCount);
        if (count >= 32) {
            RETURN (__mkSmallInteger(0));
        }

        bits = __intVal(self);
        if (count > 0) {
            bits = bits << count;
        } else {
            bits = bits >> (-count);
        }
# if __POINTER_SIZE__ == 8
        bits &= 0xFFFFFFFFL;
# endif
        RETURN (__MKUINT(bits));
    }
#endif
%}.
    ^ self primitiveFailed

    "
     128 unsignedBitShift:24
     128 unsignedBitShift32:24

     1 unsignedBitShift:31
     1 unsignedBitShift32:31

     -1 unsignedBitShift32:-1
     -1 unsignedBitShift32:1
    "
! !

!SmallInteger methodsFor:'testing'!

between:min and:max
    "return true if the receiver is greater than or equal to the argument min
     and less than or equal to the argument max.
     - reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (STObject.bothSmallInteger(min, max)) {
        long myVal = ((STInteger)self).longValue();

        if (myVal >= ((STInteger)min).longValue()) {
            if (myVal <= ((STInteger)max).longValue()) {
                return __c__._RETURN_true();
            }
        }
        return __c__._RETURN_false();
    }
#else /* not SCHTEAM */
    if (__bothSmallInteger(min, max)) {
# if TAG_INT == 1
        // tag bit does not change the magnitude order
        if ((INT)self < (INT)(min)) {
             RETURN ( false );
        }
        if ((INT)self > (INT)(max)) {
             RETURN ( false );
        }
        RETURN ( true );
# else
        REGISTER INT selfVal;

        selfVal = __intVal(self);
        if (selfVal < __intVal(min)) {
             RETURN ( false );
        }
        if (selfVal > __intVal(max)) {
             RETURN ( false );
        }
        RETURN ( true );
# endif
    }
#endif /* not SCHTEAM */
%}.
    (self < min) ifTrue:[^ false].
    (max < self) ifTrue:[^ false].
    ^ true
!

even
    "return true, if the receiver is even"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.isEven() ? STObject.True : STObject.False );
    /* NOTREACHED */
#else
    RETURN ( ((INT)self & (INT)__MASKSMALLINT(1)) ? false : true );
#endif /* not SCHTEAM */
%}.
    ^ super even
!

isPowerOfTwo
    "return true, if the receiver is a power of 2"

    "/ 0 is not a power of two, because ld(0) is -INF
    ^ ((self bitAnd:(self - 1)) == 0) and:[self ~~ 0]

    "
     0 isPowerOfTwo
     1 isPowerOfTwo
     2 isPowerOfTwo
     3 isPowerOfTwo
     4 isPowerOfTwo
     5 isPowerOfTwo
     16r8000000000000000 isPowerOfTwo
     16r8000000000000001 isPowerOfTwo
     16r40000000 isPowerOfTwo
     16r80000000 isPowerOfTwo
     16r100000000 isPowerOfTwo

     10000 factorial isPowerOfTwo
     |n| n := 10000 factorial. Time millisecondsToRun:[1000 timesRepeat:[ n isPowerOfTwo]]
    "

    "Modified: / 20-06-2011 / 12:41:18 / cg"
!

negative
    "return true, if the receiver is less than zero
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.isLt_0() ? STObject.True : STObject.False);
    /* NOTREACHED */
#else
# if TAG_INT == 1
    /* tag bit does not change sign */
    RETURN ( ((INT)(self) < 0) ? true : false );
# else
    RETURN ( (__intVal(self) < 0) ? true : false );
# endif
#endif
%}.
    ^ self < 0
!

nextPowerOf2
    "return the power of 2 at or above the receiver.
     Useful for padding.
     Notice, that for a powerOf2, the receiver is returned.
     Also notice, that (because it is used for padding),
     0 is returned for zero."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    INT x;

    x = __intVal(self) - 1;
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
# if __POINTER_SIZE__ == 8
    x |= (x >> 32);
# endif
    RETURN (__MKINT(x + 1));
#endif
%}.
    ^ super nextPowerOf2

    "
     0 nextPowerOf2
     1 nextPowerOf2
     2 nextPowerOf2
     3 nextPowerOf2
     4 nextPowerOf2
     5 nextPowerOf2
     6 nextPowerOf2
     7 nextPowerOf2
     8 nextPowerOf2
     9 nextPowerOf2

     22 nextPowerOf2
     32 nextPowerOf2
     16rFFFF nextPowerOf2 = 16r10000 
     16rFFFFFFFF nextPowerOf2 = 16r100000000 
     16r1FFFFFFFFFFFFFFF nextPowerOf2 = 16r2000000000000000 
     16r3FFFFFFFFFFFFFFF nextPowerOf2 = 16r4000000000000000 
     16r7FFFFFFFFFFFFFFF nextPowerOf2 = 16r8000000000000000 
     16rFFFFFFFFFFFFFFFF nextPowerOf2 = 16r10000000000000000 
     10 factorial nextPowerOf2
     20 factorial nextPowerOf2
     100 factorial nextPowerOf2
    "
!

odd
    "return true, if the receiver is odd"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.isEven() ? STObject.False : STObject.True );
    /* NOTREACHED */
#else
    RETURN ( ((INT)self & (INT)__MASKSMALLINT(1)) ? true : false );
#endif
%}.
    ^ super odd
!

parityOdd
    "return true, if an odd number of bits are set in the receiver, false otherwise.
     (i.e. true for odd parity)
     Undefined for negative values (smalltalk does not require the machine to use 2's complement)"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__

    // tricky, but very fast (google for it, to understand)
    unsigned INT v = __intVal(self);

# if __POINTER_SIZE__ == 8
    v ^= v >> 32;
# endif
    v ^= v >> 16;
    v ^= v >> 8;
    v ^= v >> 4;
    v &= 0xf;
    RETURN ( ( (0x6996 >> v) & 1 ) ? true : false );
#endif
%}.
    ^ super parityOdd

    "
        self assert:
         (((0 to:255) collect:[:i | i parityOdd ifTrue:1 ifFalse:0])
            asByteArray collect:[:c | c + $0 asciiValue]) asString
         =
            '0110100110010110100101100110100110010110011010010110100110010110100101100110100101101001100101100110100110010110100101100110100110010110011010010110100110010110011010011001011010010110011010010110100110010110100101100110100110010110011010010110100110010110'

        self assert:(16r0FFFFFFF parityOdd = 16r0FFFFFFF bitCount odd).
        self assert:(16r1FFFFFFF parityOdd = 16r1FFFFFFF bitCount odd).
        self assert:(16r3FFFFFFF parityOdd = 16r3FFFFFFF bitCount odd).
        self assert:(16r7FFFFFFF parityOdd = 16r7FFFFFFF bitCount odd).
        self assert:(16rFFFFFFFF parityOdd = 16rFFFFFFFF bitCount odd).
        self assert:(16r3FFFFFFFFFFFFFFF parityOdd = 16r3FFFFFFFFFFFFFFF bitCount odd).
        self assert:(16r7FFFFFFFFFFFFFFF parityOdd = 16r7FFFFFFFFFFFFFFF bitCount odd).
        self assert:(16rFFFFFFFFFFFFFFFF parityOdd = 16rFFFFFFFFFFFFFFFF bitCount odd).
    "

    "Modified (comment): / 09-01-2012 / 19:55:37 / cg"
!

positive
    "return true, if the receiver is greater or equal to zero (not negative)
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.isGe_0() ? STObject.True : STObject.False);
    /* NOTREACHED */
#else

# if TAG_INT == 1
    /* tag bit does not change sign */
    RETURN ( ((INT)(self) >= 0) ? true : false );
# else
    RETURN ( (__intVal(self) >= 0) ? true : false );
# endif
#endif
%}.
    ^ super positive
!

sign
    "return the sign of the receiver (-1, 0 or 1).
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
# if TAG_INT <= 1 /* tag in low bit */
    RETURN ( __mkSmallInteger( (((INT)self) > TAG_INT) - (((INT)self) < 0) ) );
# else
    INT val = __intVal(self);

    RETURN ( __mkSmallInteger( (val > 0) - (val < 0) ) );
# endif
#endif
%}.
    ^ super sign

    "
     -5 sign
     -1 sign
     0 sign
     1 sign
     5 sign
    "
!

strictlyPositive
    "return true, if the receiver is greater than zero
     reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.isGt_0() ? STObject.True : STObject.False);
    /* NOTREACHED */
#else

# if TAG_INT == 1
    /* tag bit does not change sign */
    RETURN ( ((INT)(self) > (INT)(__mkSmallInteger(0))) ? true : false );
# else
    RETURN ( (__intVal(self) > 0) ? true : false );
# endif
#endif
%}.
    ^ super strictlyPositive

    "
     0 strictlyPositive
     1 strictlyPositive
     -1 strictlyPositive
    "
! !

!SmallInteger class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


SmallInteger initialize!

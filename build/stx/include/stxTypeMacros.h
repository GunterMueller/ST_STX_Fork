/*
 * COPYRIGHT (c) 1998 by Claus Gittinger
 *              All Rights Reserved
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice.   This software may not
 * be provided or otherwise made available to, or used by, any
 * other person.  No title to or ownership of the software is
 * hereby transferred.
 *
 * $Header$
 *
 * These used to be located in stc.h; now, they are included.
 * (To avoid excessive recompilations due to makefile dependencies)
 */

#include "stxAsmMacros.h"

#ifndef int32
# if (__POINTER_SIZE__ == 4)
#   define int32        int
# else
#  if defined(__GNUC__) && defined(__osx__)
#   define int32        int
#  else
#   if defined(__GNUC__) && defined(__x86_64__)
#    define int32        int
#   else
#    define int32        long
#   endif
#  endif
# endif
#endif

/*
 * __qIsXXX macros:
 *      expect a non-nil, non-smallInt argument;
 *      will crash, if either nil or a smallInt is passed.
 *
 * __isXXX macros:
 *      these check for the argument being a valid non-nil, non-smallInt object
 *      Can be used with any OBJ-arg.
 */

#define __qIsMeta(o)             ((__qClass(o)==Metaclass) || (__qClass(o)==PrivateMetaclass) || (__qClass(o)==AutoloadMetaclass) || (__qClass(o)==JavaMetaclass))
#define __isMeta(o)             (__isNonNilObject(o) && __qIsMeta(o))
#define __qIsFloat(o)           (__qClass(o)==Float)
#define __isFloat(o)            (__isNonNilObject(o) && __qIsFloat(o))
#define __qIsShortFloat(o)      (__qClass(o)==ShortFloat)
#define __isShortFloat(o)       (__isNonNilObject(o) && __qIsShortFloat(o))
#define __isFraction(o)         (__isNonNilObject(o) && (__qClass(o)==Fraction))
#define __isFractionLike(o)     (__isNonNilObject(o) && ((__qClass(o)==Fraction) || (__qClass(o)==FixedPoint)))
#define __qIsString(o)          (__qClass(o)==String)
#define __qIsStringLike(o)      (__qClass(o)==String || __qClass(o)==Symbol || __qClass(o)==ImmutableString)
#define __isString(o)           (__isNonNilObject(o) && __qIsString(o))
#define __isStringLike(o)       (__isNonNilObject(o) && __qIsStringLike(o))
#define __qIsTwoByteString(o)   (__qClass(o)==TwoByteString)
#define __isTwoByteString(o)    (__isNonNilObject(o) && __qIsTwoByteString(o))
#define __qIsUnicode16String(o) (__qClass(o)==Unicode16String)
#define __isUnicode16String(o)  (__isNonNilObject(o) && __qIsUnicode16String(o))
#define __qIsArray(o)           (__qClass(o)==Array)
#define __isArray(o)            (__isNonNilObject(o) && __qIsArray(o))
#define __qIsArrayLike(o)       (__qClass(o)==Array || __qClass(o)==ImmutableArray)
#define __isArrayLike(o)        (__isNonNilObject(o) && __qIsArrayLike(o))
#define __qIsByteArray(o)       (__qClass(o)==ByteArray)
#define __isByteArray(o)        (__isNonNilObject(o) && __qIsByteArray(o))
#define __qIsByteArrayLike(o)   (__qClass(o)==ByteArray || __qClass(o)==ImmutableByteArray)
#define __isByteArrayLike(o)    (__isNonNilObject(o) && __qIsByteArrayLike(o))
#define __qIsFloatArray(o)      (__qClass(o)==FloatArray)
#define __isFloatArray(o)       (__isNonNilObject(o) && __qIsFloatArray(o))
#define __qIsDoubleArray(o)     (__qClass(o)==DoubleArray)
#define __isDoubleArray(o)      (__isNonNilObject(o) && __qIsDoubleArray(o))
#define __qIsWordArray(o)       (__qClass(o)==WordArray)
#define __isWordArray(o)        (__isNonNilObject(o) && __qIsWordArray(o))
#define __isSignedWordArray(o)  (__isNonNilObject(o) && (__qClass(o)==SignedWordArray))
#define __isIntegerArray(o)     (__isNonNilObject(o) && (__qClass(o)==IntegerArray))
#define __isSignedIntegerArray(o)  (__isNonNilObject(o) && (__qClass(o)==SignedIntegerArray))
#define __qIsSymbol(o)          (__qClass(o)==Symbol)
#define __isSymbol(o)           (__isNonNilObject(o) && __qIsSymbol(o))
#define __isCharacter(o)        (__isNonNilObject(o) && (__qClass(o)==Character))
#define __isSingleByteCharacter(o) (__isCharacter(o) && ((unsigned INT)(__characterVal(o)) <=(unsigned INT)(__MKSMALLINT(0xFF))))
#define __isPoint(o)            (__isNonNilObject(o) && (__qClass(o)==Point))
#define __isBlock(o)            (__isNonNilObject(o) && (__qClass(o)==Block))
#define __isExternalBytes(o)    (__isNonNilObject(o) && (__qClass(o)==ExternalBytes))
#define __isExternalFunction(o) (__isNonNilObject(o) && (__qClass(o)==ExternalFunction))
#define __isExternalAddress(o)  (__isNonNilObject(o) && (__qClass(o)==ExternalAddress))
#define __isNil(o)              ((o) == nil)
#define __isLargeInteger(o)     (__isNonNilObject(o) && (__qClass(o)==LargeInteger))
#define __isInteger(o)          (__isSmallInteger(o) || ((o != nil) && (__qClass(o) == LargeInteger)))

/*
 * check if it has indexed (non-weak) pointer instvars
 */
#define __qIsPointers(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
     == __MASKSMALLINT(POINTERARRAY))

#define __isPointers(o) \
    (__isNonNilObject(o) && __qIsPointers(o))

/*
 * check if byteArray or subclass (if it has indexed byte instvars)
 */
#define __qIsBytes(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
     == __MASKSMALLINT(BYTEARRAY))

#define __isBytes(o) \
    (__isNonNilObject(o) && __qIsBytes(o))

/*
 * check if wordArray or subclass (especially: twoByteString-like)
 */
#define __qIsWords(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
      == __MASKSMALLINT(WORDARRAY))

#define __isWords(o) \
    (__isNonNilObject(o) && __qIsWords(o))

/*
 * check if longArray or subclass (especially: fourByteString-like)
 */
#define __qIsLongs(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
      == __MASKSMALLINT(LONGARRAY))

#define __isLongs(o) \
    (__isNonNilObject(o) && __qIsLongs(o))

/*
 * check if signedLongArray or subclass
 */
#define __qIsSignedLongs(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
      == __MASKSMALLINT(SLONGARRAY))

#define __isSignedLongs(o) \
    (__isNonNilObject(o) && __qIsSignedLongs(o))

/*
 * check if floatArray or subclass
 */
#define __qIsFloats(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
      == __MASKSMALLINT(FLOATARRAY))

#define __isFloats(o) \
    (__isNonNilObject(o) && __qIsFloats(o))

/*
 * check if doubleArray or subclass
 */
#define __qIsDoubles(o) \
    (((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(ARRAYMASK)) \
      == __MASKSMALLINT(DOUBLEARRAY))

#define __isDoubles(o) \
    (__isNonNilObject(o) && __qIsDoubles(o))

/*
 * check if symbol or subclass
 */
#define __qIsSymbolLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(SYMBOL_INSTS))

#define __isSymbolLike(o) \
    (__isNonNilObject(o) && __qIsSymbolLike(o))


/*
 * check if externalAddress or subclass (if it has a pointer to anythng at slot1)
 */
#define __qIsSubclassOfExternalAddress(cls) \
    ((INT)(__ClassInstPtr(cls)->c_flags) & __MASKSMALLINT(NONOBJECT_INSTS))

#define __qIsExternalAddressLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(NONOBJECT_INSTS))

#define __isExternalAddressLike(o) \
    (__isNonNilObject(o) && __qIsExternalAddressLike(o))

/*
 * check if externalBytes or subclass (if it has a pointer to indexed bytes at slot1)
 */
#define __qIsSubclassOfExternalBytes(cls) \
    ((INT)(__ClassInstPtr(cls)->c_flags) & __MASKSMALLINT(EXTERNALBYTES_INSTS))

#define __qIsExternalBytesLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(EXTERNALBYTES_INSTS))

#define __isExternalBytesLike(o) \
    (__isNonNilObject(o) && __qIsExternalBytesLike(o))

/*
 * check if method or subclass
 */
#define __qIsMethodLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(METHOD_INSTS))

#define __isMethodLike(o) \
    (__isNonNilObject(o) && __qIsMethodLike(o))

/*
 * check if block or subclass
 */
#define __qIsBlockLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(BLOCK_INSTS | BLOCKLIKE_INSTS))

#define __isBlockLike(o) \
    (__isNonNilObject(o) && __qIsBlockLike(o))

/*
 * check if javaMethod or subclass
 */
#define __qIsJavaMethodLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(JMETHOD_INSTS))

#define __isJavaMethodLike(o) \
    (__isNonNilObject(o) && __qIsJavaMethodLike(o))

/*
 * check if javaClass or subclass
 */
#define __qIsJavaBehaviorLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(JCLASS_INSTS))

#define __isJavaBehaviorLike(o) \
    (__isNonNilObject(o) && __qIsJavaBehaviorLike(o))

#define __isJavaType(o) \
    (__isJavaBehaviorLike(o) || __isBehaviorLike(o))
/* TODO: name all primitive types here */

/*
 * check if instance of java.lang.String
 */
#define __qIsJavaString(o)      (__qClass(o)==Java_java_lang_String)
#define __isJavaString(o)        (__isNonNilObject(o) && __qIsJavaString(o))


/*
 * check if float or subclass
 */
#define __qIsFloatLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(FLOAT_INSTS))

#define __isFloatLike(o) \
    (__isNonNilObject(o) && __qIsFloatLike(o))

/*
 * check if behavior or subclass (i.e. a class)
 */
#define __qIsBehaviorLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(BEHAVIOR_INSTS))

#define __isBehaviorLike(o) \
    (__isNonNilObject(o) && __qIsBehaviorLike(o))

/*
 * check if context or subclass
 */
#define __qIsContextLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(CONTEXT_INSTS | BCONTEXT_INSTS))

#define __isContextLike(o) \
    (__isNonNilObject(o) && __qIsContextLike(o))

/*
 * check if block context or subclass
 */
#define __qIsBlockContextLike(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(BCONTEXT_INSTS))

#define __isBlockContextLike(o) \
    (__isNonNilObject(o) && __qIsBlockContextLike(o))

/*
 * check if Java context
 */
#define __qIsJavaContext(o) \
    (__qClass(o) == JavaContext)

#define __isJavaContext(o) \
    (__isNonNilObject(o) && __qIsJavaContextLike(o))

/*
 * check if Java array
 */
#define __qIsJavaArray(o) \
    ((INT)(__ClassInstPtr(__qClass(o))->c_flags) & __MASKSMALLINT(JARRAY_INSTS))

#define __isJavaArray(o) \
    (__isNonNilObject(o) && __qIsJavaArray(o))

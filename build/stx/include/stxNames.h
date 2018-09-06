/* WIN32 only
 * this is needed for msc-compiled-dll vs. bcc-compiled-dll compatibility.
 * a big sigh here !
 *
 * sigh - in order for visual-.def files to be able to rename
 * entries (for borland-dll compatibility), all global
 * names must begin with a lowercase character
 * (i.e. it is NOT possible to add an alias such as __FOO = _FOO)
 * I guess, that's a "feature" (not a bug) in ms's linker.
 * Here, are the relevant symbols redefined to lower-case names.
 *
 * Notice: in order for borland and visual-C dlls to be usabale
 * together, this translation is done for all compilers.
 */

#if (defined(__win32__) || defined(WIN32)) && !defined(__MINGW__)

# if !defined(__STX_NAMES_H__)
#  define __STX_NAMES_H__

#define _SEND0                  stx_SEND0
#define _SEND1                  stx_SEND1
#define _SEND2                  stx_SEND2
#define _SEND3                  stx_SEND3
#define _SEND4                  stx_SEND4
#define _SEND5                  stx_SEND5
#define _SEND6                  stx_SEND6
#define _SEND7                  stx_SEND7
#define _SEND8                  stx_SEND8
#define _SEND9                  stx_SEND9
#define _SEND10                 stx_SEND10
#define _SEND11                 stx_SEND11
#define _SEND12                 stx_SEND12
#define _SEND13                 stx_SEND13
#define _SEND14                 stx_SEND14
#define _SEND15                 stx_SEND15
#define __WEAK_READ__           stx__WEAK_READ
#define __WEAK_WRITE__          stx__WEAK_WRITE
#define __STX___new             stx__STX___new
#define __MKLARGEINT            stx__mkLargeInteger
#define __MKULARGEINT           stx__mkUnsignedLargeInteger
#define __MKINT                 stx__mkInteger
#define __MKUINT                stx__mkUnsignedInteger
#define __MKREALCONTEXT3        stx__MKREALCONTEXT3
#define __INTERRUPTPENDING      stx__INTERRUPTPENDING
#define __BLOCKINTERRUPTS       stx__BLOCKINTERRUPTS
#define __UNBLOCKINTERRUPTS     stx__UNBLOCKINTERRUPTS
#define __INTERRUPTS_BLOCKED    stx__INTERRUPTS_BLOCKED
#define __MKFLOAT               stx__mkFloat
#define __MKEXTERNALADDRESS     stx__mkExternalAddress
#define __MKEXTERNALFUNCTION            stx__mkExternalFunction
#define __MKEXTERNALLIBRARYFUNCTION     stx__mkExternalLibraryFunction
#define __MKEXTERNALLIBRARYFUNCTION_V   stx__mkExternalLibraryFunction_V
#define __MKSTRING              stx__mkString
#define __MKEMPTYSTRING         stx__mkEmptyString
#define __MKSTRING_L            stx__mkString_L
#define __MKSTRING_ST           stx__mkStringST
#define __MKSTRING_ST_L         stx__mkStringST_L
#define __MKSTRING_ST_OL        stx__mkStringST_OL
#define __MKSTRING_INIT         stx__mkString_INIT
#define __MKSTRING_2L_INIT      stx__mkString_2L_INIT
#define __SYMBOL_OR_NIL         stx__SYMBOL_OR_NIL
#define __INTERNSYMBOL          stx__INTERNSYMBOL
#define __KNOWNASSYMBOL         stx__KNOWNASSYMBOL
#define __MKSYMBOL              stx__mkSymbol
#define __GLOBALS_SIZE          stx__GLOBALS_SIZE
#define __GLOBALKEYS_DO         stx__GLOBALKEYS_DO
#define __GLOBALS_DO            stx__GLOBALS_DO
#define __GLOBAL_GET            stx__GLOBAL_GET
#define __GLOBAL_GETCELL        stx__GLOBAL_GETCELL
#define __GLOBAL_KEYKNOWN       stx__GLOBAL_KEYKNOWN
#define __GLOBAL_REMOVE         stx__GLOBAL_REMOVE
#define __GLOBAL_SET            stx__GLOBAL_SET
#define __RESUMECONTEXT__       stx__RESUMECONTEXT
#define __PATCHUPCONTEXT        stx__PATCHUPCONTEXT
#define __PATCHUPCONTEXTS       stx__PATCHUPCONTEXTS
#define __UNNAMEDGLOBAL         stx__UNNAMEDGLOBAL
#define __MAKEGLOBAL            stx__MAKEGLOBAL
#define __REGISTRATION_DO_BLOCK    stx__REGISTRATION_DO_BLOCK
#define __REGISTRATION_DO_BLOCK5__ stx__REGISTRATION_DO_BLOCK5__
#define __INVALIDATE_BY_ID      stx__INVALIDATE_BY_ID
#define __REVALIDATE_BY_ID      stx__REVALIDATE_BY_ID
#define __SET_MODULE_ID         stx__SET_MODULE_ID
#define __UNREGISTER_BY_ID      stx__UNREGISTER_BY_ID
#define __MKLARGEINT64          stx__mkLargeInteger64
#define __FETCHSELECTOR         stx__FETCHSELECTOR
#define __BYTEARRAY_UNINITIALIZED_NEW_INT       stx__ByteArray_UNINITIALIZED_new_INT
#define __BYTEARRAY_NEW_INT                     stx__ByteArray_new_INT
#define __BYTEARRAY_NEW                         stx__ByteArray_new
#define __MKPOINT_INT           stx__mkPoint_INT
#define __MKINT64               stx__mkInteger64
#define __MKUINT64              stx__mkUnsignedInteger64
#define __MKEXTERNALBYTES       stx__mkExternalBytes
#define __MKEXTERNALBYTES_N     stx__mkExternalBytes_N
#define __MKPOINT_DOUBLE        stx__mkPoint_DOUBLE
#define __ARRAY_NEW             stx__Array_new
#define __ARRAY_NEW_INT         stx__Array_new_INT
#define __ARRAY_UNITITIALIZED_NEW_INT   stx__Array_UNITITIALIZED_new_INT
#define __MKBYTEARRAY           stx__mkByteArray
#define __STRING_NEW            stx__String_new
#define __STRING_NEW_INT        stx__String_new_INT
#define __ARRAY_WITH1           stx__Array_with_1
#define __ARRAY_WITH2           stx__Array_with_2
#define __ARRAY_WITH3           stx__Array_with_3
#define __ARRAY_WITH4           stx__Array_with_4
#define __ARRAY_WITH5           stx__Array_with_5
#define __BASICNEW              stx__BASICNEW
#define __BASICNEW_INT          stx__BASICNEW_INT
#define __NEW                   stx__NEW
#define __NEW_INT               stx__NEW_INT
#define __SIZE                  stx__SIZE
#define __ISKINDOF_             stx__ISKINDOF
#define __MD5Init               stx__MD5Init
#define __MD5Final              stx__MD5Final
#define __MD5Update             stx__MD5Update
#define __UNFIXCONTEXT          stx__UNFIXCONTEXT
#define __CONTEXTLINENOS        stx__CONTEXTLINENOS
#define __MKUTF8STRING          stx__mkUTF8String
#define __GLOBAL_GET_BY_NAME    stx__GLOBAL_GET_BY_NAME
#define __MKU16STRING           stx__mkU16String
#define __MKU16STRING_MAXLEN    stx__mkU16String_maxlen
#define __mkStringOrU16String_maxlen stx__mkStringOrU16String_maxlen
#define __MKEMPTYU16STRING      stx__mkEmptyU16String
#define __STX_AddTimeout        stx__AddTimeout
#define __STX_RemoveTimeout     stx__RemoveTimeout
#define __STX_SignalSemaphore   stx__SignalSemaphore

#define __REGISTER_MMODULE4__   stx__REGISTER_MMODULE4

# endif /* __STX_NAMES_H__ */
#endif /* WIN32 */

"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

ExternalFunction subclass:#ExternalLibraryFunction
	instanceVariableNames:'flags moduleName returnType argumentTypes owningClass'
	classVariableNames:'CALLTYPE_API CALLTYPE_C CALLTYPE_MASK CALLTYPE_OLE
		CALLTYPE_UNIX64 CALLTYPE_V8 CALLTYPE_V9 DLLPATH DllMapping
		FLAG_ASYNC FLAG_NONVIRTUAL FLAG_OBJECTIVEC FLAG_RETVAL_IS_CONST
		FLAG_UNLIMITEDSTACK FLAG_VIRTUAL LastModuleHandleHolder
		LastModuleHandleName Verbose'
	poolDictionaries:''
	category:'System-Support'
!

!ExternalLibraryFunction primitiveDefinitions!
%{
#include "stxOSDefs.h"

#define VERBOSE

#ifdef VERBOSE
# include <stdio.h>
#endif
#ifdef VERBOSE
#  define DEBUGCODE_IF(flag, code) if ((flag) == true) {  code }
# else
#  define DEBUG_IF(flag, code) /* nothing */
# endif

#ifdef HAVE_FFI

# include <ffi.h>
# define MAX_ARGS    128

#if ! defined( __MINGW__ )
#  define __get_ffi_type_sint() &ffi_type_sint
#  define __get_ffi_type_sint8() &ffi_type_sint8
#  define __get_ffi_type_sint16() &ffi_type_sint16
#  define __get_ffi_type_sint32() &ffi_type_sint32
#  define __get_ffi_type_sint64() &ffi_type_sint64
#  define __get_ffi_type_uint() &ffi_type_uint
#  define __get_ffi_type_uint8() &ffi_type_uint8
#  define __get_ffi_type_uint16() &ffi_type_uint16
#  define __get_ffi_type_uint32() &ffi_type_uint32
#  define __get_ffi_type_uint64() &ffi_type_uint64
#  define __get_ffi_type_float() &ffi_type_float
#  define __get_ffi_type_double() &ffi_type_double
#  define __get_ffi_type_void() &ffi_type_void
#  define __get_ffi_type_pointer() &ffi_type_pointer

# else

   extern ffi_type *__get_ffi_type_sint();
   extern ffi_type *__get_ffi_type_sint8();
   extern ffi_type *__get_ffi_type_sint16();
   extern ffi_type *__get_ffi_type_sint32();
   extern ffi_type *__get_ffi_type_sint64();
   extern ffi_type *__get_ffi_type_uint();
   extern ffi_type *__get_ffi_type_uint8();
   extern ffi_type *__get_ffi_type_uint16();
   extern ffi_type *__get_ffi_type_uint32();
   extern ffi_type *__get_ffi_type_uint64();
   extern ffi_type *__get_ffi_type_float();
   extern ffi_type *__get_ffi_type_double();
   extern ffi_type *__get_ffi_type_void();
   extern ffi_type *__get_ffi_type_pointer();
   extern INTLFUNC __get_ffi_prep_cif();
   extern INTLFUNC __get_ffi_call();
#  ifdef _MINGW__
#   define ffi_prep_cif (*(__get_ffi_prep_cif()))
#   define ffi_call     (*(__get_ffi_call()))
#  endif
# endif

# define TYPE_UINT      __get_ffi_type_uint()
# define TYPE_UINT8     __get_ffi_type_uint8()
# define TYPE_UINT16    __get_ffi_type_uint16()
# define TYPE_UINT32    __get_ffi_type_uint32()
# define TYPE_UINT64    __get_ffi_type_uint64()

# define TYPE_SINT      __get_ffi_type_sint()
# define TYPE_SINT8     __get_ffi_type_sint8()
# define TYPE_SINT16    __get_ffi_type_sint16()
# define TYPE_SINT32    __get_ffi_type_sint32()
# define TYPE_SINT64    __get_ffi_type_sint64()

# define TYPE_POINTER   __get_ffi_type_pointer()
# define TYPE_FLOAT     __get_ffi_type_float()
# define TYPE_DOUBLE    __get_ffi_type_double()
# define TYPE_VOID      __get_ffi_type_void()

/*
 * In eXept's Smalltalk/X, these #defines are defined
 * right in ffi.h - YES, Claus modified third-party library
 * header! Too bad. 
 * We (Jan) don't want this, period. We don't want to keep this 
 * in mind and hack the headers each time we upgrade libffi.
 * 
 * See: http://www.commitstrip.com/en/2016/05/17/coder-dilemma-9-the-upgrade/
 * 
 * So, NO! We define all the neccessary extra defines here! 
 */

/* ---- Intel x86 Win32 ---------- */
#define CALLTYPE_FFI_SYSV FFI_SYSV
#ifdef X86_WIN32
# define CALLTYPE_FFI_STDCALL FFI_STDCALL
#elif defined(X86_WIN64)
# define CALLTYPE_FFI_STDCALL FFI_WIN64  
#else
# define CALLTYPE_FFI_UNIX64 FFI_UNIX64
#endif

#else /* NO FFI */

# define MAX_ARGS    15
# define TYPE_UINT      1
# define TYPE_UINT8     2
# define TYPE_UINT16    3
# define TYPE_UINT32    4
# define TYPE_UINT64    5

# define TYPE_SINT      11
# define TYPE_SINT8     12
# define TYPE_SINT16    13
# define TYPE_SINT32    14
# define TYPE_SINT64    15

# define TYPE_POINTER   20
# define TYPE_FLOAT     30
# define TYPE_DOUBLE    31
# define TYPE_VOID      40

# define FFI_DEFAULT_ABI        0
# define CALLTYPE_FFI_STDCALL   0

#endif

%}
! !

!ExternalLibraryFunction class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    instances of me are used to interface to external library functions (as found in a dll/shared object).
    Foreign function calls are based on the FFI library if available.
    A limited fallback implementation is provided for systems with no libffi.
    (this may have limitations on the supported argument types; for example,
     the x86_64 fallback does not support float/double arguments).
    Therefore the fallback should be considered a temporary workaround,
    until libffi has been ported.

    Inside a method, when a special external-call pragma such as:
	<api: bool MessageBeep(uint)>

    is encountered by the parser, the compiler generates a call via
	<correspondingExternalLibraryFunctionObject> invokeWithArguments: argumentArray.
    and the correspondingExternalLibraryFunctionObject is kept in the literal array.

    In the invoke method, the library is checked to be loaded (and loaded if not already),
    the arguments are converted to C and pushed onto the C-stack, the function is called,
    and finally, the return value is converted back from C to a smalltalk object.

    The parser supports the call-syntax of various other smalltalk dialects:
	Squeak / ST-X:
	    <cdecl:   [async] [virtual|nonVirtual][const] returnType functionNameStringOrIndex ( argType1..argTypeN ) module: moduleName >
	    <apicall: [async] [virtual|nonVirtual][const] returnType functionNameStringOrIndex ( argType1..argTypeN ) module: moduleName >

	Dolphin:
	    <stdcall: [virtual|nonVirtual][const] returnType functionNameStringOrIndex argType1..argTypeN>
	    <cdecl:   [virtual|nonVirtual][const] returnType functionNameStringOrIndex argType1..argTypeN>

	ST/V:
	    <api: functionName argType1 .. argTypeN returnType>
	    <ccall: functionName argType1 .. argTypeN returnType>
	    <ole: vFunctionIndex argType1 .. argTypeN returnType>

	VisualWorks:
	    <c: ...>
	    <c: #define NAME value>
"
!

example
"
								[exBegin]
	|f|

	f := ExternalLibraryFunction new.
	f beCallTypeWINAPI.

	f name:'MessageBeep'
	  module:'user32.dll'
	  returnType:#boolean
	  argumentTypes:#(uint).

	f invokeWith:1.
								[exEnd]

  Synchronous vs. Asynchronous calls:

    by default, foreign function calls are synchronous, effectively blocking the whole ST/X system
    (that is by purpose,because most C-code is not prepared for being interrupted, and also, normal
     code is not prepared for a garbage collector to move objects around, while another C thread might
     access the data...).
    Therefore, the following will block all ST/X activity for 10 seconds
    (try interacting with the launcher while the Sleep is performing):

								[exBegin]
	|f|

	f := ExternalLibraryFunction new.
	f beCallTypeWINAPI.

	f name:'Sleep'
	  module:'kernel32.dll'
	  returnType:#void
	  argumentTypes:#(uint).

	f invokeWith:10000.
								[exEnd]

    if you know what you do and you do not pass any possibly moving objects (such as strings) as argument,
    the call can be made asynchronous. In that case, ONLY the calling thread will be blocked; all other smalltalk
    threads wil continue to execute.
    (try interacting now with the launcher while the Sleep is performing):
								[exBegin]
	|f|

	f := ExternalLibraryFunction new.
	f beCallTypeWINAPI.
	f beAsync.

	f name:'Sleep'
	  module:'kernel32.dll'
	  returnType:#void
	  argumentTypes:#(uint).

	f invokeWith:10000.
								[exEnd]

"
! !

!ExternalLibraryFunction class methodsFor:'instance creation'!

name:functionName module:moduleName returnType:returnType argumentTypes:argTypes
    ^ self new
	name:functionName module:moduleName
	returnType:returnType argumentTypes:argTypes

    "Created: / 01-08-2006 / 15:19:08 / cg"
! !

!ExternalLibraryFunction class methodsFor:'class initialization'!

addToDllPath:aDirectoryPathName
    "can be used during initialization, to add more places for dll-loading"

    |oldPath newPath|

    oldPath := self dllPath.
    (oldPath includes:aDirectoryPathName) ifFalse:[
	newPath := oldPath asOrderedCollection.
	newPath add:aDirectoryPathName.
	self dllPath:newPath
    ]

    "
     self addToDllPath:'c:\matrix\API\dll'
    "
!

dllMapping
    "allows for dll's to be replaced,
     for example, if you want to use the mozilla sqlite dll
	C:\Program Files\Mozilla Firefox\mozsqlite3.dll
     for the sqlite3, execute:
	ExternalLibraryFunction
	    dllMapping at:'sqlite3'
	    put: 'C:\Program Files\Mozilla Firefox\mozsqlite3.dll'
     for mingw:
	ExternalLibraryFunction
	    dllMapping at:'sqlite3'
	    put:'C:\mingw64\opt\bin\libsqlite3-0.dll'
    "

    DllMapping isNil ifTrue:[
	DllMapping := Dictionary new.
    ].
    ^ DllMapping

    "Created: / 10-04-2012 / 12:21:45 / cg"
!

dllMapping:aDictionary
    "allows for dll's to be replaced,
     for example, if you want to use the mozilla sqlite dll
        C:\Program Files\Mozilla Firefox\mozsqlite3.dll
     for the sqlite3, execute:
        ExternalLibraryFunction
            dllMapping at:'sqlite3'
            put: 'C:\Program Files\Mozilla Firefox\mozsqlite3.dll'
     for mingw:
        ExternalLibraryFunction
            dllMapping at:'sqlite3'
            put:'C:\mingw64\opt\bin\libsqlite3-0.dll'
    "

    DllMapping := aDictionary

    "Created: / 26-11-2016 / 04:06:14 / cg"
!

dllMappingAt:baseLibname put:aNameOrPath
    "allows for dll's to be replaced,
     for example, if you want to use the mozilla sqlite dll
	C:\Program Files\Mozilla Firefox\mozsqlite3.dll
     for the sqlite3, execute:
	ExternalLibraryFunction
	    dllMappingAt:'sqlite3'
	    put: 'C:\Program Files\Mozilla Firefox\mozsqlite3.dll'
     for mingw:
	ExternalLibraryFunction
	    dllMappingAt:'sqlite3'
	    put:'C:\mingw64\opt\bin\libsqlite3-0.dll'
    "

    self dllMapping at:baseLibname put: aNameOrPath
!

dllPath
    "provide a default dllPath, where external libraries are searched for"

    ^ DLLPATH
!

dllPath:aCollectionOfDirectoryPathNames
    "provide a default dllPath, where external libraries are searched for"

    DLLPATH := aCollectionOfDirectoryPathNames
!

flushModuleHandlesForLibrary:aLibraryName
    self flushModuleHandlesForWhich:[:fn | fn moduleName = aLibraryName].

    "
     self flushModuleHandlesForLibrary:'ole32.dll'
    "

    "Created: / 12-11-2016 / 11:49:09 / cg"
!

flushModuleHandlesForWhich:aBlock
    self allInstancesDo:[:fn |
        (aBlock value:fn) ifTrue:[
            fn setModuleHandle:nil.
        ]
    ].

    "
     self flushModuleHandlesForLibrary:'ole32.dll'
    "

    "Created: / 12-11-2016 / 11:48:32 / cg"
!

initialize
    "using inline access to corresponding c--defines to avoid duplicate places of knowledge"

    DLLPATH isNil ifTrue:[
	DLLPATH := #('.').
    ].
%{
#ifndef __SCHTEAM__
    @global(FLAG_VIRTUAL) = __MKSMALLINT(__EXTL_FLAG_VIRTUAL);                  // a virtual c++ call
    @global(FLAG_NONVIRTUAL) = __MKSMALLINT(__EXTL_FLAG_NONVIRTUAL);            // a non-virtual c++ call
    @global(FLAG_OBJECTIVEC) = __MKSMALLINT(__EXTL_FLAG_OBJECTIVEC);            // an objectiveC message send
    @global(FLAG_UNLIMITEDSTACK) = __MKSMALLINT(__EXTL_FLAG_UNLIMITEDSTACK);    // unlimitedstack under unix
    @global(FLAG_ASYNC) = __MKSMALLINT(__EXTL_FLAG_ASYNC);                      // async under win32
    @global(FLAG_RETVAL_IS_CONST) = __MKSMALLINT(__EXTL_FLAG_RETVAL_IS_CONST);  // retvalue is not to be registered for finalization

    @global(CALLTYPE_API) = __MKSMALLINT(__EXTL_CALLTYPE_API);                  // WINAPI-call (win32 only)
    @global(CALLTYPE_C) = __MKSMALLINT(__EXTL_CALLTYPE_C);                      // regular C-call (the default)
    @global(CALLTYPE_V8) = __MKSMALLINT(__EXTL_CALLTYPE_V8);                    // v8 call (sparc only)
    @global(CALLTYPE_V9) = __MKSMALLINT(__EXTL_CALLTYPE_V9);                    // v9 call (sparc only)
    @global(CALLTYPE_UNIX64) = __MKSMALLINT(__EXTL_CALLTYPE_UNIX64);            // unix64 call (alpha only)

    @global(CALLTYPE_MASK) = __MKSMALLINT(__EXTL_CALLTYPE_MASK);
#endif
%}.

    "
     self initialize
    "

    "Modified: / 03-10-2006 / 21:27:47 / cg"
!

removeFromDllPath:aDirectoryPathName
    "remove added places from dll-loading"

    |oldPath|

    oldPath := self dllPath.
    self dllPath:(oldPath asOrderedCollection copyWithout:aDirectoryPathName)

    "
     self dllPath.
     self addToDllPath:'C:\aaa\bbb'.
     self dllPath.
     self removeFromDllPath:'C:\aaa\bbb'.
     self dllPath.
    "
! !

!ExternalLibraryFunction class methodsFor:'constants'!

callTypeAPI
    ^ CALLTYPE_API

    "Modified: / 01-08-2006 / 13:44:41 / cg"
!

callTypeC
    ^ CALLTYPE_C

    "Modified: / 01-08-2006 / 13:44:49 / cg"
!

callTypeCDecl
    ^ CALLTYPE_C

    "Modified: / 01-08-2006 / 13:44:52 / cg"
!

callTypeMASK
    ^ CALLTYPE_MASK

    "Modified: / 01-08-2006 / 13:44:57 / cg"
!

callTypeOLE
    ^ CALLTYPE_OLE

    "Modified: / 01-08-2006 / 13:44:57 / cg"
! !

!ExternalLibraryFunction class methodsFor:'debugging'!

verbose:aBoolean
    "turn on/off tracing of calls"

    Verbose := aBoolean

    "
     ExternalLibraryFunction verbose:true
    "

    "Created: / 30-03-2016 / 17:28:23 / cg"
! !

!ExternalLibraryFunction class methodsFor:'type name mapping'!

ffiTypeSymbolForType:aType
    "map type to one of the ffi-supported ones:
        sint8, sint16, sint32, sint64
        uint8, uint16, uint32, uint64
        long ulong int uint
        bool float double void pointer handle
    "

    aType == #sint8           ifTrue:[^ aType ].
    aType == #sint16          ifTrue:[^ aType ].
    aType == #sint32          ifTrue:[^ aType ].
    aType == #sint64          ifTrue:[^ aType ].
    aType == #uint8           ifTrue:[^ aType ].
    aType == #uint16          ifTrue:[^ aType ].
    aType == #uint32          ifTrue:[^ aType ].
    aType == #uint64          ifTrue:[^ aType ].
    aType == #double          ifTrue:[^ aType ].
    aType == #float           ifTrue:[^ aType ].
    aType == #char            ifTrue:[^ aType ].
    aType == #void            ifTrue:[^ aType ].
    aType == #bool            ifTrue:[^ aType ].
    aType == #pointer         ifTrue:[^ aType ].
    aType == #charPointer     ifTrue:[^ aType ].
    aType == #wcharPointer    ifTrue:[^ aType ].

    aType == #int8            ifTrue:[^ #sint8 ].
    aType == #int16           ifTrue:[^ #sint16 ].
    aType == #int32           ifTrue:[^ #sint32 ].
    aType == #int64           ifTrue:[^ #sint64 ].

    aType == #voidPointer         ifTrue:[^ #pointer ].
    aType == #uint8Pointer        ifTrue:[^ #pointer ].
    aType == #voidPointerPointer  ifTrue:[^ #pointer ].

    aType == #short           ifTrue:[^ #sint16 ].
    aType == #long            ifTrue:[^ #long ].
    aType == #int             ifTrue:[^ #int ].
    aType == #uint            ifTrue:[^ #uint ].
    aType == #ushort          ifTrue:[^ #uint16 ].
    aType == #unsignedShort   ifTrue:[^ #uint16 ].
    aType == #ulong           ifTrue:[^ #ulong ].
    aType == #unsignedLong    ifTrue:[^ #ulong ].
    aType == #uchar           ifTrue:[^ #uint8 ].
    aType == #unsignedChar    ifTrue:[^ #uint8 ].
    aType == #byte            ifTrue:[^ #uint8 ].
    aType == #longlong        ifTrue:[^ #sint64 ].
    aType == #longLong        ifTrue:[^ #sint64 ].
    aType == #ulonglong       ifTrue:[^ #uint64 ].
    aType == #ulongLong       ifTrue:[^ #uint64 ].

    "/ windefs
    aType == #dword           ifTrue:[^ #uint32 ].
    aType == #sdword          ifTrue:[^ #sint32 ].
    aType == #word            ifTrue:[^ #uint16 ].
    aType == #sword           ifTrue:[^ #sint16 ].
    aType == #handle          ifTrue:[^ #pointer ].
    aType == #lpstr           ifTrue:[^ #charPointer ].
    "/ aType == #hresult         ifTrue:[^ #uint32 ].  -- keep this; it is translated later (in invoke)
    aType == #boolean         ifTrue:[^ #bool ].
    "/ care for 64bit machines
    aType == #ulongReturn     ifTrue:[^ ExternalAddress pointerSize == 8 ifTrue:[#uint64] ifFalse:[#uint32]].
    aType == #none            ifTrue:[^ #void ].
    aType == #struct          ifTrue:[^ #pointer ].
    aType == #structIn        ifTrue:[^ #pointer ].
    aType == #structOut       ifTrue:[^ #pointer ].
    aType == #structInOut     ifTrue:[^ #pointer ].
    aType == #unsigned        ifTrue:[^ #uint ].

    aType == #ATOM            ifTrue:[^ #uint16 ].
    aType == #BOOL            ifTrue:[^ #int ].
    aType == #BOOLEAN         ifTrue:[^ #uint8 ].
    aType == #BYTE            ifTrue:[^ #uint8 ].
    aType == #DWORD           ifTrue:[^ #uint32 ].
    aType == #HANDLE          ifTrue:[^ #pointer ].
    aType == #HRESULT         ifTrue:[^ #hresult ].

    aType == #BSTR            ifTrue:[^ #wcharPointer].

    "/ care for 64bit machines
    aType == #SIZE_T          ifTrue:[^ ExternalAddress pointerSize == 8 ifTrue:[#uint64] ifFalse:[#uint32]].

    (aType isString or:[aType isSymbol]) ifFalse:[
        CType isNil ifTrue:[
            self error:'unknown type'.
        ].
        ^ aType typeSymbol.
    ].

    (aType endsWith:'*') ifTrue:[
        ^ #pointer.
    ].
    (aType endsWith:'Pointer') ifTrue:[
        ^ #pointer.
    ].
    ^ aType

    "Modified (format): / 30-03-2016 / 13:45:09 / cg"
! !

!ExternalLibraryFunction methodsFor:'accessing'!

argumentTypes
    ^ argumentTypes
!

argumentTypesString
    ^ String
	streamContents:[:s |
	    argumentTypes do:[:eachArgType |
		eachArgType printOn:s.
	    ] separatedBy:[
		s nextPutAll:','.
	    ].
	].
!

beAsync
    "let this execute in a separate thread, in par with the other execution thread(s).
     Ignored under unix/linux (until those support multiple threads too)."

    flags := (flags ? 0) bitOr: FLAG_ASYNC.

    "Created: / 01-08-2006 / 13:42:38 / cg"
!

beCallTypeAPI
    flags := (flags ? 0) bitOr: CALLTYPE_API.

    "Created: / 01-08-2006 / 15:12:40 / cg"
!

beCallTypeC
    flags := (flags ? 0) bitOr: CALLTYPE_C.

    "Created: / 01-08-2006 / 15:12:40 / cg"
!

beCallTypeOLE
    flags := (flags ? 0) bitOr: FLAG_VIRTUAL.

    "Created: / 01-08-2006 / 15:12:40 / cg"
!

beCallTypeUNIX64
    flags := (flags ? 0) bitOr: CALLTYPE_UNIX64.

    "Created: / 01-08-2006 / 15:13:38 / cg"
!

beCallTypeV8
    flags := (flags ? 0) bitOr: CALLTYPE_V8.

    "Created: / 01-08-2006 / 15:13:28 / cg"
!

beCallTypeV9
    flags := (flags ? 0) bitOr: CALLTYPE_V9.

    "Created: / 01-08-2006 / 15:13:31 / cg"
!

beCallTypeWINAPI
    self beCallTypeAPI

    "Modified: / 01-08-2006 / 15:14:02 / cg"
!

beConstReturnValue
    "specify that a pointer return value is not to be finalized
     (i.e. points to static data or data which is freed by c)"

    flags := (flags ? 0) bitOr: FLAG_RETVAL_IS_CONST.

    "Created: / 01-08-2006 / 13:56:48 / cg"
!

beNonVirtualCPP
    "specify this as a non-virtual c++-function"

    flags := (flags ? 0) bitOr: FLAG_NONVIRTUAL.

    "Created: / 01-08-2006 / 13:56:44 / cg"
!

beObjectiveC
    "specify this as an objective-c message send"

    flags := (flags ? 0) bitOr: FLAG_OBJECTIVEC.

    "Created: / 01-08-2006 / 13:56:48 / cg"
!

beUnlimitedStack
    "let this execute on the c-stack (as opposed to the thread-stack)
     for unlimited auto-sized-stack under unix/linux.
     Ignored under windows."

    flags := (flags ? 0) bitOr: FLAG_UNLIMITEDSTACK.

    "Created: / 01-08-2006 / 13:41:54 / cg"
!

beVirtualCPP
    "specify this as a virtual c++-function"

    flags := (flags ? 0) bitOr: FLAG_VIRTUAL.

    "Created: / 01-08-2006 / 13:56:48 / cg"
!

callTypeNumber
    ^ (flags ? 0) bitAnd: CALLTYPE_MASK.

    "Created: / 01-08-2006 / 15:12:10 / cg"
!

isAsync
    "is this executed in a separate thread, in par with the other execution thread(s) ?"

    ^ (flags ? 0) bitTest: FLAG_ASYNC.

    "Created: / 01-08-2006 / 13:46:53 / cg"
!

isCPPFunction
    "is this a virtual or non-virtual c++-function ?"

    ^ (flags ? 0) bitTest: (FLAG_VIRTUAL bitOr: FLAG_NONVIRTUAL).

    "Created: / 01-08-2006 / 13:56:54 / cg"
!

isCallTypeAPI
    "is this a windows API-call linkage call.
     Attention: this uses a different call API (callee unwinds the stack),
     and MUST be declared as such for many Kernel functions.
     The calltype API is one of the worst historic garbage kept by MS..."

    ^ ((flags ? 0) bitAnd: CALLTYPE_MASK) == CALLTYPE_API.

    "Created: / 01-08-2006 / 15:21:16 / cg"
!

isCallTypeC
    "is this a regular C-call (attention: on windows, there are two kinds of calls)"

    ^ ((flags ? 0) bitAnd: CALLTYPE_MASK) == CALLTYPE_C.

    "Created: / 01-08-2006 / 15:21:23 / cg"
!

isCallTypeOLE
    "is this an OLE-object call ? (eg. a virtual c++ call; same as isCallTypeCPP)"

    ^ (flags ? 0) bitTest: FLAG_VIRTUAL.

    "Created: / 01-08-2006 / 15:21:23 / cg"
    "Modified (format): / 12-11-2016 / 11:37:38 / cg"
!

isConstReturnValue
    "is the pointer return value not to be finalized
     (i.e. points to static data or data which is freed by c)"

    ^ (flags ? 0) bitTest: FLAG_RETVAL_IS_CONST.

    "Created: / 01-08-2006 / 13:56:48 / cg"
!

isNonVirtualCPP
    "is this a non-virtual c++-function ?"

    ^ (flags ? 0) bitTest: FLAG_NONVIRTUAL.

    "Created: / 01-08-2006 / 13:56:51 / cg"
!

isObjectiveC
    "is this an objective-C message?"

    ^ (flags ? 0) bitTest: FLAG_OBJECTIVEC.
!

isUnlimitedStack
    "will this execute on the c-stack (as opposed to the thread-stack)
     for unlimited auto-sized-stack under unix/linux.
     Ignored under windows."

    ^ (flags ? 0) bitTest: FLAG_UNLIMITEDSTACK.

    "Created: / 01-08-2006 / 14:17:07 / cg"
!

isVirtualCPP
    "is this a virtual c++-function (same as isCallTypeOLE) ?"

    ^ (flags ? 0) bitTest: FLAG_VIRTUAL.

    "Created: / 01-08-2006 / 13:56:54 / cg"
!

moduleName
    ^ moduleName
!

returnType
    ^ returnType
!

vtableIndex
    name isNumber ifFalse:[^ nil].
    ^ name.
! !


!ExternalLibraryFunction methodsFor:'invoking'!

invoke
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeFFIwithArguments:nil forCPPInstance:nil
!

invokeCPPVirtualOn:anInstance
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeCPPVirtualFFIOn:anInstance withArguments:nil
!

invokeCPPVirtualOn:instance with:arg
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeCPPVirtualFFIOn:instance withArguments:(Array with:arg)
!

invokeCPPVirtualOn:instance with:arg1 with:arg2
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeCPPVirtualFFIOn:instance withArguments:(Array with:arg1 with:arg2)
!

invokeCPPVirtualOn:instance with:arg1 with:arg2 with:arg3
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeCPPVirtualFFIOn:instance withArguments:(Array with:arg1 with:arg2 with:arg3)
!

invokeCPPVirtualOn:instance with:arg1 with:arg2 with:arg3 with:arg4
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeCPPVirtualFFIOn:instance withArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4)
!

invokeCPPVirtualOn:instance withArguments:args
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeCPPVirtualFFIOn:instance withArguments:args
!

invokeWith:arg
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeFFIwithArguments:(Array with:arg) forCPPInstance:nil
!

invokeWith:arg1 with:arg2
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeFFIwithArguments:(Array with:arg1 with:arg2) forCPPInstance:nil
!

invokeWith:arg1 with:arg2 with:arg3
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeFFIwithArguments:(Array with:arg1 with:arg2 with:arg3) forCPPInstance:nil
!

invokeWith:arg1 with:arg2 with:arg3 with:arg4
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeFFIwithArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4) forCPPInstance:nil
!

invokeWithArguments:argArray
    self hasCode ifFalse:[
	self prepareInvoke.
    ].
    ^ self invokeFFIwithArguments:argArray forCPPInstance:nil

    "Modified: / 01-08-2006 / 16:04:08 / cg"
! !

!ExternalLibraryFunction methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'<'.
    self isCallTypeAPI ifTrue:[
	'API:' printOn:aStream.
    ] ifFalse:[
	self isCallTypeOLE ifTrue:[
	    'OLE:' printOn:aStream.
	] ifFalse:[
	    self isCallTypeC ifTrue:[
		'C:' printOn:aStream.
	    ] ifFalse:[
		self error.
	    ].
	].
    ].
    aStream nextPutAll:' '.
    name printOn:aStream.
    moduleName notNil ifTrue:[
	aStream nextPutAll:' module:'.
	moduleName printOn:aStream.
    ].
    aStream nextPutAll:'>'.

    "Modified: / 25-09-2012 / 12:06:14 / cg"
! !

!ExternalLibraryFunction methodsFor:'private'!

adjustTypes
    "map all those existing type names to a small number of definite ffi type names.
     This is needed, because there are so many different C-type names found in code imported
     from various Smalltalk dialects' library function call declarations.
     For example: all of word, WORD, unsignedShort, ushort, uShort etc. will map to uint16.
     Also, this deals with pointer size differences."

    argumentTypes notEmptyOrNil ifTrue:[
	argumentTypes := argumentTypes collect:[:argType | self class ffiTypeSymbolForType:argType].
    ].
    returnType := self class ffiTypeSymbolForType:returnType.

    "Modified: / 07-07-2015 / 22:18:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linkToModule
    "link this function to the external module.
     I.e. retrieve the module handle and the code pointer."

    |handle moduleNameUsed functionName|

    name isNumber ifTrue:[
        self isCPPFunction ifTrue:[
            "/ no need to load a dll.
            ^ self
        ]
    ].

    "/ in some other smalltalks, there is no moduleName in the ffi-spec;
    "/ instead, the class provides the libraryName...
    (moduleNameUsed := moduleName) isNil ifTrue:[
        owningClass isNil ifTrue:[
            self error:'Missing moduleName'.
        ].
        moduleNameUsed := owningClass theNonMetaclass libraryName asSymbol.
    ].
    moduleHandle isNil ifTrue:[
        "/ speedup. in 95% of all calls, the same moduleName is resolved here
        (LastModuleHandleHolder isNil
        or:[ (handle := LastModuleHandleHolder at:1) isNil
        or:[ handle == -1
        or:[ LastModuleHandleName ~= moduleNameUsed ]]]) ifTrue:[

            handle := self loadLibrary:moduleNameUsed.
            handle isNil ifTrue:[ self error:'Failed to load library: ',moduleNameUsed].
            LastModuleHandleHolder := WeakArray with:handle.
            LastModuleHandleName := moduleNameUsed.
        ].
        self assert:(handle isInteger not).
        moduleHandle := handle.
    ].
    name isNumber ifFalse:[
        functionName := name.
        (moduleHandle getFunctionAddress:functionName into:self) isNil ifTrue:[
            (moduleHandle getFunctionAddress:('_', functionName) into:self) isNil ifTrue:[
                moduleHandle := nil.
                LastModuleHandleHolder := LastModuleHandleName := nil.
                self error:'Missing function: ', name, ' in module: ', moduleNameUsed.
            ].
        ].
    ].

    "Modified: / 12-11-2016 / 11:40:03 / cg"
!

loadLibrary:dllName
    "load a dll.
     Notice the dllMapping mechanism, which can be used to silently load different dlls.
     This is useful, if some code has a hardcoded dll-name in it, which needs to be changed,
     but you do not want or cannot recompile the methods (i.e. no source avail)"

    |handle nameString filename dllPaths|

    (ObjectFileLoader notNil and:[ObjectFileLoader canLoadObjectFiles]) ifFalse:[
        self error:('ObjectFileLoader cannot load dll/module: "%1"' bindWith:nameString).
    ].

    filename := dllName.
    DllMapping notNil ifTrue:[
        filename := DllMapping at:filename ifAbsent:[ filename ]
    ].

    filename := filename asFilename.
    nameString := filename name.

    "try to load, maybe the system knows where to find the dll"
    handle := ObjectFileLoader loadDynamicObject:filename.
    handle notNil ifTrue:[^ handle ].

    filename isAbsolute ifFalse:[
        "First ask the class defining the ExternalFunction for the location of the dlls ..."
        dllPaths := #().
        owningClass notNil ifTrue:[
            dllPaths := owningClass dllPath.
        ].
        ".. then ask the system"
        dllPaths := dllPaths, self class dllPath.
        dllPaths do:[:eachDirectory |
            |libraryName|

            libraryName := eachDirectory asFilename construct:nameString.
            handle := ObjectFileLoader loadDynamicObject:libraryName.
            handle notNil ifTrue:[^ handle ].
        ].
    ].

    filename suffix isEmpty ifTrue:[
        "/ try again with the OS-specific dll-extension
        ^ self loadLibrary:(filename withSuffix:ObjectFileLoader sharedLibrarySuffix)
    ].

    self
        error:('Cannot find or load dll/module: "%1"' bindWith:nameString)
        mayProceed:true.
    ^ nil

    "Modified: / 12-11-2016 / 11:27:23 / cg"
!

prepareInvoke
    "called before invoked.
     When called the very first time, moduleHandle is nil,
     and we ensure that the dll is loaded, the function address is extracted"

    (moduleHandle isNil or:[self hasCode not]) ifTrue:[
	self linkToModule.
	self adjustTypes.
    ].
! !

!ExternalLibraryFunction methodsFor:'private-accessing'!

name:functionNameOrVirtualIndex module:aModuleName returnType:aReturnType argumentTypes:argTypes
    name := functionNameOrVirtualIndex.
    functionNameOrVirtualIndex isNumber ifTrue:[
	self beVirtualCPP.
    ].
    moduleName := aModuleName.
    returnType := aReturnType.
    argumentTypes := argTypes.

    "Created: / 01-08-2006 / 15:19:52 / cg"
    "Modified: / 02-08-2006 / 17:20:13 / cg"
!

owningClass
    ^ owningClass
!

owningClass:aClass
    owningClass := aClass.

    "Created: / 01-08-2006 / 15:22:50 / cg"
!

setModuleName:aModuleName
    aModuleName ~= moduleName ifTrue:[
	self code:nil.
	moduleHandle := nil.
	moduleName := aModuleName.
    ].

    "Created: / 07-06-2007 / 10:20:17 / cg"
! !

!ExternalLibraryFunction methodsFor:'private-invoking'!

invokeCPPVirtualFFIOn:instance withArguments:arguments
    ^ self invokeFFIwithArguments:arguments forCPPInstance:instance

    "Modified: / 01-08-2006 / 13:55:30 / cg"
!

invokeFFIWithArguments:arguments
    ^ self invokeFFIwithArguments:arguments forCPPInstance:nil

    "Modified: / 01-08-2006 / 13:55:35 / cg"
!

invokeFFIwithArguments:argumentsOrNil forCPPInstance:aReceiverOrNil
    "basic invoke mechanism. Calls the function represented by the receiver with argumentsOrNil.
     For cplusplus, aReceiverOrNil is required to be an externalStructure like object;
     for objectiveC, it must be an ObjectiveC object"

    |argTypeSymbols returnTypeSymbol failureCode failureArgNr failureInfo returnValue stClass vtOffset
     virtual objectiveC async unlimitedStack callTypeNumber returnValueClass argValueClass
     oldReturnType oldArgumentTypes|

    argTypeSymbols := argumentTypes.
    returnTypeSymbol := returnType.
    returnTypeSymbol isSymbol ifTrue:[ 
        | returnValueClass0 |

        returnValueClass0 := Smalltalk at: returnTypeSymbol.
        returnValueClass0 isBehavior ifTrue:[
            returnValue := returnValueClass0 basicNew.
        ] 
    ].

    virtual := self isVirtualCPP.
    objectiveC := self isObjectiveC.
    (virtual "or:[self isNonVirtualCPP]") ifTrue:[
        aReceiverOrNil isNil ifTrue:[
            "/ must have a c++ object instance
            self primitiveFailed.
        ].

        "/ and it must be a kind of ExternalStructure !!
        (aReceiverOrNil isKindOf:ExternalStructure) ifFalse:[
            self primitiveFailed.
        ].
        virtual ifTrue:[
            vtOffset := name.
            (vtOffset between:0 and:10000) ifFalse:[
                self primitiveFailed.
            ]
        ].
    ] ifFalse:[
        objectiveC ifTrue:[
            aReceiverOrNil isNil ifTrue:[
                "/ must have an objective-c object instance
                self primitiveFailed.
            ].
            (aReceiverOrNil isObjectiveCObject) ifFalse:[
                self primitiveFailed
            ]
        ] ifFalse:[
            aReceiverOrNil notNil ifTrue:[
                "/ must NOT have a c++/objectiveC object instance
                self primitiveFailed.
            ]
        ].
    ].
    async := self isAsync.
    unlimitedStack := self isUnlimitedStack.
    callTypeNumber := self callTypeNumber.
    "/ Transcript show:name; show:' async:'; showCR:async.

%{  /* STACK: 100000 */

#define VERBOSE

#ifdef HAVE_FFI

# ifdef __GNUC__
#  ifndef HAS_LONGLONG
#   define HAS_LONGLONG
#  endif
# endif
# if defined(__BORLANDC__) || defined(__VISUALC__)
#  define HAS_INT64
#  ifndef __LO32
#   define __LO32(ll) ((ll) & 0xFFFFFFFFL)
#   define __HI32(ll) (((ll)>>32) & 0xFFFFFFFFL)
#  endif
# endif


    ffi_cif __cif;
    ffi_type *__argTypesIncludingThis[MAX_ARGS+1];
    ffi_type **__argTypes = __argTypesIncludingThis;
    ffi_type *__returnType = NULL;
    ffi_type *thisType;
    ffi_abi __callType = FFI_DEFAULT_ABI;

#else

    int __argTypesIncludingThis[MAX_ARGS+1];
    int *__argTypes = __argTypesIncludingThis;
    int __returnType = 0;
    int thisType;
    int __callType = FFI_DEFAULT_ABI;    

#endif

    int __numFloatOrDoubleArgs = 0;

    union u {
        INT iVal;
        float fVal;
        double dVal;
        void *pointerVal;
# if 0 && defined(HAS_LONGLONG)
        long long longLongVal;
# else
        __int64__ longLongVal;
# endif
    };
    union u __argValuesIncludingThis[MAX_ARGS+1];
    union u *__argValues = __argValuesIncludingThis;
    union u __returnValue;
    void *__argValuePointersIncludingThis[MAX_ARGS+1];
    void **__argValuePointers = __argValuePointersIncludingThis;
    void *__returnValuePointer;
    int __numArgs, __numArgsIncludingThis;
    static INT null = 0;
    int i = -1;
    voidFUNC codeAddress = (voidFUNC)__INST(code_);
    int __numArgsWanted;

#   define __FAIL__(fcode) \
    { \
        failureCode = fcode; failureArgNr = __mkSmallInteger(i+1); goto getOutOfHere; \
    }

    if (argumentsOrNil == nil) {
        __numArgs = 0;
    } else if (__isArray(argumentsOrNil)) {
        __numArgs = __arraySize(argumentsOrNil);
    } else {
        __FAIL__(@symbol(BadArgumentVector))
    }
    if (argTypeSymbols == nil) {
        __numArgsWanted = 0;
    } else if (__isArray(argTypeSymbols)) {
        __numArgsWanted = __arraySize(argTypeSymbols);
    } else {
        __FAIL__(@symbol(BadArgumentTypeVector))
    }

    if (__numArgs != __numArgsWanted) {
        __FAIL__(@symbol(ArgumentCountMismatch))
    }
    if (__numArgs > MAX_ARGS) {
        __FAIL__(@symbol(TooManyArguments))
    }

    /*
     * validate the return type and map it to an ffi_type
     */
    __returnValuePointer = &__returnValue;

    if (returnTypeSymbol == @symbol(voidPointer)) {
        returnTypeSymbol = @symbol(handle);
    } else if (returnTypeSymbol == @symbol(hresult)) {
        returnTypeSymbol = @symbol(uint32);
    }

    if (returnTypeSymbol == @symbol(int)) {
        __returnType = TYPE_SINT;
    } else if (returnTypeSymbol == @symbol(uint)) {
        __returnType = TYPE_UINT;
    } else if (returnTypeSymbol == @symbol(uint8)) {
        __returnType = TYPE_UINT8;
    } else if (returnTypeSymbol == @symbol(uint16)) {
        __returnType = TYPE_UINT16;
    } else if (returnTypeSymbol == @symbol(uint32)) {
        __returnType = TYPE_UINT32;
    } else if (returnTypeSymbol == @symbol(uint64)) {
        __returnType = TYPE_UINT64;

    } else if (returnTypeSymbol == @symbol(sint)) {
        __returnType = TYPE_SINT;
    } else if (returnTypeSymbol == @symbol(sint8)) {
        __returnType = TYPE_SINT8;
    } else if (returnTypeSymbol == @symbol(sint16)) {
        __returnType = TYPE_SINT16;
    } else if (returnTypeSymbol == @symbol(sint32)) {
        __returnType = TYPE_SINT32;
    } else if (returnTypeSymbol == @symbol(sint64)) {
        __returnType = TYPE_SINT64;

    } else if (returnTypeSymbol == @symbol(long)) {
        if (sizeof(long) == 4) {
           returnTypeSymbol = @symbol(sint32);
           __returnType = TYPE_SINT32;
        } else if (sizeof(long) == 8) {
           returnTypeSymbol = @symbol(sint64);
           __returnType = TYPE_SINT64;
        } else {
            __FAIL__(@symbol(UnknownReturnType))
        }

    } else if (returnTypeSymbol == @symbol(ulong)) {
        if (sizeof(long) == 4) {
           returnTypeSymbol = @symbol(uint32);
           __returnType = TYPE_UINT32;
        }else if (sizeof(long) == 8) {
           returnTypeSymbol = @symbol(uint64);
           __returnType = TYPE_UINT64;
        } else {
            __FAIL__(@symbol(UnknownReturnType))
        }

    } else if (returnTypeSymbol == @symbol(bool)) {
        __returnType = TYPE_UINT;

    } else if (returnTypeSymbol == @symbol(float)) {
        __returnType = TYPE_FLOAT;
    } else if (returnTypeSymbol == @symbol(double)) {
        __returnType = TYPE_DOUBLE;

    } else if (returnTypeSymbol == @symbol(void)) {
        __returnType = TYPE_VOID;
        __returnValuePointer = NULL;
    } else if ((returnTypeSymbol == @symbol(pointer))
               || (returnTypeSymbol == @symbol(handle))
               || (returnTypeSymbol == @symbol(charPointer))
               || (returnTypeSymbol == @symbol(bytePointer))
               || (returnTypeSymbol == @symbol(floatPointer))
               || (returnTypeSymbol == @symbol(doublePointer))
               || (returnTypeSymbol == @symbol(intPointer))
               || (returnTypeSymbol == @symbol(shortPointer))
               || (returnTypeSymbol == @symbol(wcharPointer))) {
        __returnType = TYPE_POINTER;
    } else {
        if (__isSymbol(returnTypeSymbol)
         && ((returnValueClass = __GLOBAL_GET(returnTypeSymbol)) != nil)) {
            if (! __isBehaviorLike(returnValueClass)) {
                __FAIL__(@symbol(NonBehaviorReturnType))
            }
            if (! __qIsSubclassOfExternalAddress(returnValueClass)) {
                __FAIL__(@symbol(NonExternalAddressReturnType))
            }
            __returnType = TYPE_POINTER;
            returnTypeSymbol = @symbol(pointer);
        } else {
            __FAIL__(@symbol(UnknownReturnType))
        }
    }

    /*
     * validate the c++ object
     */
    if (aReceiverOrNil != nil) {
        struct cPlusPlusInstance {
            void **vTable;
        };
        struct cPlusPlusInstance *inst;

        if (__isExternalAddressLike(aReceiverOrNil)) {
            inst = (void *)(__externalAddressVal(aReceiverOrNil));
        } else if (__isExternalBytesLike(aReceiverOrNil)) {
            inst = (void *)(__externalBytesVal(aReceiverOrNil));
        } else {
            __FAIL__(@symbol(InvalidInstance))
        }
        __argValues[0].pointerVal = inst;
        __argValuePointersIncludingThis[0] = &(__argValues[0]);
        __argTypes[0] = TYPE_POINTER;

        __argValuePointers = &__argValuePointersIncludingThis[1];
        __argTypes = &__argTypesIncludingThis[1];
        __argValues = &__argValuesIncludingThis[1];
        __numArgsIncludingThis = __numArgs + 1;

        if (virtual == true) {
            if (! __isSmallInteger(vtOffset)) {
                __FAIL__(@symbol(InvalidVTableIndex))
            }
            codeAddress = inst->vTable[__intVal(vtOffset)];
            DEBUGCODE_IF( @global(Verbose), {
                printf("virtual %"_ld_" codeAddress: %"_lx_"\n", (INT)(__intVal(vtOffset)), (INT)codeAddress);
            })
        }
    } else {
        __numArgsIncludingThis = __numArgs;
        DEBUGCODE_IF( @global(Verbose), {
            printf("codeAddress: %"_lx_"\n", (INT)codeAddress);
        })
    }

    /*
     * validate all arg types, map each to an ffi_type, and setup arg-buffers
     */
    for (i=0; i<__numArgs; i++) {
        void *argValuePtr;
        OBJ typeSymbol;
        OBJ arg;

        failureInfo = __mkSmallInteger(i+1);   /* in case there is one */

        typeSymbol = __ArrayInstPtr(argTypeSymbols)->a_element[i];
        arg = __ArrayInstPtr(argumentsOrNil)->a_element[i];

        if (typeSymbol == @symbol(handle)) {
            typeSymbol = @symbol(pointer);
        } else if (typeSymbol == @symbol(voidPointer)) {
            typeSymbol = @symbol(pointer);
        } else if (returnTypeSymbol == @symbol(hresult)) {
            typeSymbol = @symbol(uint32);
        }

        if (typeSymbol == @symbol(long)) {
            if (sizeof(long) == sizeof(int)) {
                typeSymbol = @symbol(sint);
            } else {
                if (sizeof(long) == 4) {
                    typeSymbol = @symbol(sint32);
                } else if (sizeof(long) == 8) {
                    typeSymbol = @symbol(sint64);
                }
            }
        }
        if (typeSymbol == @symbol(ulong)) {
            if (sizeof(unsigned long) == sizeof(unsigned int)) {
                typeSymbol = @symbol(uint);
            } else {
                if (sizeof(long) == 4) {
                    typeSymbol = @symbol(uint32);
                } else if (sizeof(long) == 8) {
                    typeSymbol = @symbol(uint64);
                }
            }
        }

        if (typeSymbol == @symbol(int) || typeSymbol == @symbol(sint)) {
            thisType = TYPE_SINT;
            if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __signedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d sint value out of range [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(uint)) {
            thisType = TYPE_UINT;

            if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __unsignedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d uint value out of range [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(uint8)) {
            thisType = TYPE_UINT8;
            if (! __isSmallInteger(arg)) {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d uint8 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            __argValues[i].iVal = __intVal(arg);
            if (((unsigned)(__argValues[i].iVal)) > 0xFF) {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d uint8 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(sint8)) {
            thisType = TYPE_SINT8;
            if (! __isSmallInteger(arg)) {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d sint8 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            __argValues[i].iVal = __intVal(arg);
            if (((__argValues[i].iVal) < -0x80) || ((__argValues[i].iVal) > 0x7F))  {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d sint8 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(uint16)) {
            thisType = TYPE_UINT16;
            if (! __isSmallInteger(arg)) {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d uint16 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            __argValues[i].iVal = __intVal(arg);
            if (((unsigned)(__argValues[i].iVal)) > 0xFFFF) {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d uint16 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(sint16)) {
            thisType = TYPE_SINT16;
            if (! __isSmallInteger(arg)) {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d sint16 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            __argValues[i].iVal = __intVal(arg);
            if (((__argValues[i].iVal) < -0x8000) || ((__argValues[i].iVal) > 0x7FFF))  {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d sint16 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(uint32)) {
            thisType = TYPE_UINT32;
            if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __unsignedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d uint32 value out of range [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
# if __POINTER_SIZE__ == 8
            if ((__argValues[i].iVal) < 0)  {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d uint32 value out of range [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
# endif
            argValuePtr = &(__argValues[i].iVal);

         } else if (typeSymbol == @symbol(sint32)) {
            thisType = TYPE_SINT32;
            if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __signedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d sint32 value out of range [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
# if __POINTER_SIZE__ == 8
            if (((__argValues[i].iVal) < -0x80000000LL) || ((__argValues[i].iVal) > 0x7FFFFFFFLL))  {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d sint32 value (%"_lx_") out of range [%d]\n", i+1, __argValues[i].iVal, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
# endif
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(uint64)) {
            thisType = TYPE_UINT64;
            if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __unsignedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d uint64 value out of range [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].iVal);

         } else if (typeSymbol == @symbol(sint64)) {
            thisType = TYPE_SINT64;
            if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __signedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d sint64 value out of range [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].iVal);

        } else if (typeSymbol == @symbol(float)) {
            thisType = TYPE_FLOAT;
            if (__isSmallInteger(arg)) {
                __argValues[i].fVal = (float)(__intVal(arg));
            } else if (__isFloat(arg)) {
                __argValues[i].fVal = (float)(__floatVal(arg));
            } else if (__isShortFloat(arg)) {
                __argValues[i].fVal = (float)(__shortFloatVal(arg));
            } else {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d non float value [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].fVal);
        } else if (typeSymbol == @symbol(double)) {
            thisType = TYPE_DOUBLE;
            if (__isSmallInteger(arg)) {
                __argValues[i].dVal = (double)(__intVal(arg));
            } else if (__isFloat(arg)) {
                __argValues[i].dVal = (double)(__floatVal(arg));
            } else if (__isShortFloat(arg)) {
                __argValues[i].dVal = (double)(__shortFloatVal(arg));
            } else {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d non double value [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].dVal);

        } else if (typeSymbol == @symbol(void)) {
            thisType = TYPE_VOID;
            argValuePtr = &null;

        } else if (typeSymbol == @symbol(charPointer)) {
            thisType = TYPE_POINTER;
            if (__isStringLike(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__stringVal(arg));
            } else if (__isBytes(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__byteArrayVal(arg));
            } else if (__isExternalAddressLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalAddressVal(arg));
            } else if (__isExternalBytesLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalBytesVal(arg));
            } else {
                if (arg == nil) {
                    __argValues[i].pointerVal = (void *)0;
                } else {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d non charPointer value [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].pointerVal);;

        } else if (typeSymbol == @symbol(wcharPointer)) {
            thisType = TYPE_POINTER;
            if (__isUnicode16String(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__unicode16StringVal(arg));
            } else if (__isBytes(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__byteArrayVal(arg));
            } else if (__isExternalAddressLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalAddressVal(arg));
            } else if (__isExternalBytesLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalBytesVal(arg));
            } else {
                if (arg == nil) {
                    __argValues[i].pointerVal = (void *)0;
                } else {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d non wcharPointer value [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].pointerVal);;

        } else if (typeSymbol == @symbol(floatPointer)) {
            thisType = TYPE_POINTER;
            if (__isBytes(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__byteArrayVal(arg));
            } else if (__isExternalAddressLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalAddressVal(arg));
            } else if (__isExternalBytesLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalBytesVal(arg));
            } else if (__isFloats(arg)) {
                char *p = (char *)(__FloatArrayInstPtr(arg)->f_element);
                int nInstBytes;
                OBJ cls;

                if (async == true) goto badArgForAsyncCall;
                cls = __qClass(arg);
                nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
                p = p + nInstBytes;
                __argValues[i].pointerVal = p;
            } else {
                if (arg == nil) {
                    __argValues[i].pointerVal = (void *)0;
                } else {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d non floatPointer value [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].pointerVal);;

        } else if (typeSymbol == @symbol(doublePointer)) {
            thisType = TYPE_POINTER;
            if (__isBytes(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__byteArrayVal(arg));
            } else if (__isExternalAddressLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalAddressVal(arg));
            } else if (__isExternalBytesLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalBytesVal(arg));
            } else if (__isDoubles(arg)) {
                char *p = (char *)(__DoubleArrayInstPtr(arg)->d_element);
                int nInstBytes;
                OBJ cls;

                if (async == true) goto badArgForAsyncCall;
                cls = __qClass(arg);
                nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
                p = p + nInstBytes;
# ifdef __NEED_DOUBLE_ALIGN
                if ((INT)(__DoubleArrayInstPtr(arg)->d_element) & (__DOUBLE_ALIGN-1)) {
                    int delta = __DOUBLE_ALIGN - ((INT)p & (__DOUBLE_ALIGN-1));

                    p += delta;
                }
# endif
                __argValues[i].pointerVal = p;
            } else {
                if (arg == nil) {
                    __argValues[i].pointerVal = (void *)0;
                } else {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d non doublePointer value [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].pointerVal);;

        } else if (typeSymbol == @symbol(pointer)) {
    commonPointerTypeArg: ;
            thisType = TYPE_POINTER;
            if (arg == nil) {
                __argValues[i].pointerVal = NULL;
            } else if (__isExternalAddressLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalAddressVal(arg));
            } else if (__isExternalBytesLike(arg)) {
                __argValues[i].pointerVal = (void *)(__externalBytesVal(arg));
            } else if (__isByteArrayLike(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__byteArrayVal(arg));
            } else if (__isWordArray(arg) || __isSignedWordArray(arg)
                    || __isIntegerArray(arg) || __isSignedIntegerArray(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__integerArrayVal(arg));
            } else if (__isFloatArray(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__FloatArrayInstPtr(arg)->f_element);
            } else if (__isDoubleArray(arg)) {
                if (async == true) goto badArgForAsyncCall;
                __argValues[i].pointerVal = (void *)(__DoubleArrayInstPtr(arg)->d_element);
            } else if (__isStringLike(arg)) {
                if (async == true) {
badArgForAsyncCall: ;
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d not allowed for async call [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(BadArgForAsyncCall))
                }
                __argValues[i].pointerVal = (void *)(__stringVal(arg));
            } else if (__isBytes(arg) || __isWords(arg) || __isLongs(arg)) {
                char *p = (char *)(__byteArrayVal(arg));
                int nInstBytes;
                OBJ cls;

                if (async == true) goto badArgForAsyncCall;
                cls = __qClass(arg);
                nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
                __argValues[i].pointerVal = p + nInstBytes;
            } else {
                DEBUGCODE_IF( @global(Verbose), {
                    printf("invalidArgument: arg%d non pointer value [%d]\n", i+1, __LINE__);
                })
                __FAIL__(@symbol(InvalidArgument))
            }
            argValuePtr = &(__argValues[i].pointerVal);;

        } else if (typeSymbol == @symbol(bool)) {
            thisType = TYPE_UINT;

            if (arg == true) {
                __argValues[i].iVal = 1;
            } else if (arg == false) {
                __argValues[i].iVal = 0;
            } else if (__isSmallInteger(arg)) {
                __argValues[i].iVal = __intVal(arg);
            } else {
                __argValues[i].iVal = __unsignedLongIntVal(arg);
                if (__argValues[i].iVal == 0) {
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("invalidArgument: arg%d non bool value [%d]\n", i+1, __LINE__);
                    })
                    __FAIL__(@symbol(InvalidArgument))
                }
            }
            argValuePtr = &(__argValues[i].iVal);
        } else {
            if (__isSymbol(typeSymbol)
             && ((argValueClass = __GLOBAL_GET(typeSymbol)) != nil)) {
                if (! __isBehaviorLike(argValueClass)) {
                    __FAIL__(@symbol(NonBehaviorArgumentType))
                }
                if (! __qIsSubclassOfExternalAddress(argValueClass)) {
                    __FAIL__(@symbol(NonExternalAddressArgumentType))
                }
                goto commonPointerTypeArg; /* sorry */
            } else {
                __FAIL__(@symbol(UnknownArgumentType))
            }
        }

        __argTypes[i] = thisType;
        __argValuePointers[i] = argValuePtr;

        if ((thisType == TYPE_FLOAT) || (thisType == TYPE_DOUBLE)) {
            __numFloatOrDoubleArgs++;
        }
        DEBUGCODE_IF( @global(Verbose), {
            printf("arg%d: %"_lx_" type:%"_lx_"\n", i+1, (INT)(__argValues[i].iVal), (INT)thisType);
        })
    }
    failureInfo = nil;

    if (callTypeNumber == @global(CALLTYPE_API)) {
#  ifdef __MINGW64__
        __callType = FFI_DEFAULT_ABI;
#  else
#   ifdef CALLTYPE_API
        __callType = CALLTYPE_API;
#   else
#    ifdef CALLTYPE_FFI_STDCALL
        __callType = CALLTYPE_FFI_STDCALL;
#    else
        DEBUGCODE_IF( @global(Verbose), {
            printf("STDCALL\n");
        })
        failureCode = @symbol(FFICallTypeNotSupported);
        goto getOutOfHere;
#    endif
#   endif
#  endif
    }

    // these calltypes are only supported on some systems; others report an error
    if (callTypeNumber == @global(CALLTYPE_V8)) {
#  ifdef CALLTYPE_FFI_V8
        __callType = CALLTYPE_FFI_V8;
#  else
        failureCode = @symbol(FFICallTypeNotSupported);
        goto getOutOfHere;
#  endif
    }

    if (callTypeNumber == @global(CALLTYPE_V9)) {
#  ifdef CALLTYPE_FFI_V9
        __callType = CALLTYPE_FFI_V9;
#  else
        failureCode = @symbol(FFICallTypeNotSupported);
        goto getOutOfHere;
#  endif
    }

    if (callTypeNumber == @global(CALLTYPE_UNIX64)) {
#  ifdef CALLTYPE_FFI_UNIX64
        __callType = CALLTYPE_FFI_UNIX64;
#  else
        failureCode = @symbol(FFICallTypeNotSupported);
        goto getOutOfHere;
#  endif
    }

# ifdef HAVE_FFI
#  ifdef VERBOSE
    if (@global(Verbose) == true) {
        printf("prep: numargs=%d\n", __numArgsIncludingThis);
    }
#  endif

    if (ffi_prep_cif(&__cif, __callType, __numArgsIncludingThis, __returnType, __argTypesIncludingThis) != FFI_OK) {
        __FAIL__(@symbol(FFIPrepareFailed))
    }
    if (async == true) {
        DEBUGCODE_IF( @global(Verbose), {
            printf("async call 0x%"_lx_"\n", (INT)codeAddress);
        })
#  ifdef __win32__
        __STX_C_CALL4( "ffi_call", ffi_call, &__cif, codeAddress, __returnValuePointer, __argValuePointersIncludingThis);
#  else
        __BEGIN_INTERRUPTABLE__
        ffi_call(&__cif, codeAddress, __returnValuePointer, __argValuePointersIncludingThis);
        __END_INTERRUPTABLE__
#  endif
    } else {
        if (unlimitedStack == true) {
            DEBUGCODE_IF( @global(Verbose), {
                printf("UNLIMITEDSTACKCALL call 0x%"_lx_"\n", (INT)codeAddress);
            })
            __UNLIMITEDSTACKCALL4__((OBJFUNC)ffi_call, (INT)(&__cif), (INT)codeAddress, (INT)__returnValuePointer, (INT)__argValuePointersIncludingThis);
        } else {
            DEBUGCODE_IF( @global(Verbose), {
                printf("call 0x%"_lx_"\n", (INT)codeAddress);
            })
            ffi_call(&__cif, codeAddress, __returnValuePointer, __argValuePointersIncludingThis);
        }
    }

# else /* NO FFI */

    // this is a fallback; simply assume that pointer and regular args
    // can be passed in the same registers, and that all args are casted to the same
    // (pointer-) size.
    // Also, that float/doubles are passed down in regular registers,
    // and the return types float and double are handled diferently from ints.
    // If that is not correct for your CPU/architecture, an ifndef is required here.
    // No longer limited to non-double args: for x86_64, sort by non-float/float args and
    // pass down separately.

    {
        VOIDPTRFUNC fi = (VOIDPTRFUNC)codeAddress;
        DOUBLEFUNC fd = (DOUBLEFUNC)codeAddress;
        int rI[MAX_ARGS], dI[MAX_ARGS];
        int i;

        // sort the float/double args into a separate arglist and pass them AFTER the regular args.
        // This is possible, because all doubles are passed in floating-pnt registers,
        // no matter where they are in the arglist.
        int argI = 0, nonDoubleI = 0, doubleI = 0;

        for (argI=0; argI<__numArgsIncludingThis; argI++) {
#  if defined(__x86_64__)
            if ((__argTypesIncludingThis[argI] == TYPE_DOUBLE)
             || (__argTypesIncludingThis[argI] == TYPE_FLOAT)) {
                dI[doubleI++] = argI;
            } else
#  endif // __x86_64__
            {
                rI[nonDoubleI++] = argI;
            }
        }
        for (i=doubleI; i<__numArgsIncludingThis; i++) dI[doubleI++] = 0;
        for (i=nonDoubleI; i<__numArgsIncludingThis; i++) rI[nonDoubleI++] = 0;

        DEBUGCODE_IF( @global(Verbose), {
            printf("call %p with %d args (%d regular, %d double)\n", codeAddress, __numArgsIncludingThis,
                                                                     nonDoubleI, doubleI);
        })
        if (doubleI == 0) {
            // no double args
            switch (__returnType) {
                case TYPE_FLOAT:
                case TYPE_DOUBLE:
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("non-double arg; double retval\n");
                    })
                    switch (__numArgsIncludingThis) {
                        case 0:
                            __returnValue.dVal = (*fd)();
                            break;
                        case 1:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal );
                            break;
                        case 2:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal );
                            break;
                        case 3:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal );
                            break;
                        case 4:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal );
                            break;
                        case 5:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal );
                            break;
                        case 6:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal );
                            break;
                        case 7:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal );
                            break;
                        case 8:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal );
                            break;
                        case 9:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal );
                            break;
                        case 10:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal );
                            break;
                        case 11:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal );
                            break;
                        case 12:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal );
                            break;
                        case 13:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[rI[12]].pointerVal );
                            break;
                        case 14:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal );
                            break;
                        case 15:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal,
                                                        __argValues[rI[14]].pointerVal );
                            break;
                        default:
                            failureCode = @symbol(TooManyArguments);
                            goto getOutOfHere;
                    }
                    break;

                default:
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("non-double arg; non-double retval\n");
                    })
                    switch (__numArgsIncludingThis) {
                        case 0:
                            __returnValue.pointerVal = (*fi)();
                            break;
                        case 1:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal );
                            break;
                        case 2:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal );
                            break;
                        case 3:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal );
                            break;
                        case 4:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal );
                            break;
                        case 5:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal );
                            break;
                        case 6:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal );
                            break;
                        case 7:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal );
                            break;
                        case 8:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal );
                            break;
                        case 9:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal );
                            break;
                        case 10:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal,
                                                             __argValues[rI[9]].pointerVal );
                            break;
                        case 11:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal,
                                                             __argValues[rI[9]].pointerVal, __argValues[rI[10]].pointerVal );
                            break;
                        case 12:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal,
                                                             __argValues[rI[9]].pointerVal, __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal );
                            break;
                        case 13:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal,
                                                             __argValues[rI[9]].pointerVal, __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                             __argValues[rI[12]].pointerVal );
                            break;
                        case 14:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal,
                                                             __argValues[rI[9]].pointerVal, __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                             __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal );
                            break;
                        case 15:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal, __argValues[rI[2]].pointerVal,
                                                             __argValues[rI[3]].pointerVal, __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                             __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal, __argValues[rI[8]].pointerVal,
                                                             __argValues[rI[9]].pointerVal, __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                             __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal, __argValues[rI[14]].pointerVal );
                            break;
                        default:
                            failureCode = @symbol(TooManyArguments);
                            goto getOutOfHere;
                    }
            }
        } else {
            // has double args
            switch (__returnType) {
                case TYPE_FLOAT:
                case TYPE_DOUBLE:
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("double arg(s); double retval\n");
                    })
                    switch (__numArgsIncludingThis) {
                        case 0:
                            __returnValue.dVal = (*fd)( );
                            break;
                        case 1:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal,
                                                        __argValues[dI[0]].dVal );
                            break;
                        case 2:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal
                                                      );
                            break;
                        case 3:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal
                                                      );
                            break;
                        case 4:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal
                                                      );
                            break;
                        case 5:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal
                                                      );
                            break;
                        case 6:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal
                                                      );
                            break;
                        case 7:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal
                                                      );
                            break;
                        case 8:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal
                                                      );
                            break;
                        case 9:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal
                                                      );
                            break;
                        case 10:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal, __argValues[dI[9]].dVal
                                                      );
                            break;
                        case 11:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                        __argValues[dI[10]].dVal
                                                      );
                            break;
                        case 12:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                        __argValues[dI[10]].dVal, __argValues[dI[11]].dVal
                                                      );
                            break;
                        case 13:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[rI[12]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                        __argValues[dI[10]].dVal, __argValues[dI[11]].dVal,
                                                        __argValues[dI[12]].dVal
                                                      );
                            break;
                        case 14:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                        __argValues[dI[10]].dVal, __argValues[dI[11]].dVal,
                                                        __argValues[dI[12]].dVal, __argValues[dI[13]].dVal
                                                      );
                            break;
                        case 15:
                            __returnValue.dVal = (*fd)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                        __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                        __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                        __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                        __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                        __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                        __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal,
                                                        __argValues[rI[14]].pointerVal,
                                                        __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                        __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                        __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                        __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                        __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                        __argValues[dI[10]].dVal, __argValues[dI[11]].dVal,
                                                        __argValues[dI[12]].dVal, __argValues[dI[13]].dVal,
                                                        __argValues[dI[14]].dVal
                                                      );
                            break;
                        default:
                            failureCode = @symbol(TooManyArguments);
                            goto getOutOfHere;
                    }
                    break;

                default:
                    DEBUGCODE_IF( @global(Verbose), {
                        printf("double arg(s); non-double retval\n");
                    })
                    switch (__numArgsIncludingThis) {
                        case 0:
                            __returnValue.pointerVal = (*fi)( );
                            break;
                        case 1:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal,
                                                              __argValues[dI[0]].dVal );
                            break;
                        case 2:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal
                                                            );
                            break;
                        case 3:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal
                                                            );
                            break;
                        case 4:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal
                                                            );
                            break;
                        case 5:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal
                                                            );
                            break;
                        case 6:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal
                                                            );
                            break;
                        case 7:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal
                                                            );
                            break;
                        case 8:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal
                                                            );
                            break;
                        case 9:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal
                                                            );
                            break;
                        case 10:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal, __argValues[dI[9]].dVal
                                                            );
                            break;
                        case 11:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                              __argValues[rI[10]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                              __argValues[dI[10]].dVal
                                                            );
                            break;
                        case 12:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                              __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                              __argValues[dI[10]].dVal, __argValues[dI[11]].dVal
                                                            );
                            break;
                        case 13:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                              __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                              __argValues[rI[12]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                              __argValues[dI[10]].dVal, __argValues[dI[11]].dVal,
                                                              __argValues[dI[12]].dVal
                                                            );
                            break;
                        case 14:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                              __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                              __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                              __argValues[dI[10]].dVal, __argValues[dI[11]].dVal,
                                                              __argValues[dI[12]].dVal, __argValues[dI[13]].dVal
                                                            );
                            break;
                        case 15:
                            __returnValue.pointerVal = (*fi)( __argValues[rI[0]].pointerVal, __argValues[rI[1]].pointerVal,
                                                              __argValues[rI[2]].pointerVal, __argValues[rI[3]].pointerVal,
                                                              __argValues[rI[4]].pointerVal, __argValues[rI[5]].pointerVal,
                                                              __argValues[rI[6]].pointerVal, __argValues[rI[7]].pointerVal,
                                                              __argValues[rI[8]].pointerVal, __argValues[rI[9]].pointerVal,
                                                              __argValues[rI[10]].pointerVal, __argValues[rI[11]].pointerVal,
                                                              __argValues[rI[12]].pointerVal, __argValues[rI[13]].pointerVal,
                                                              __argValues[rI[14]].pointerVal,
                                                              __argValues[dI[0]].dVal, __argValues[dI[1]].dVal,
                                                              __argValues[dI[2]].dVal, __argValues[dI[3]].dVal,
                                                              __argValues[dI[4]].dVal, __argValues[dI[5]].dVal,
                                                              __argValues[dI[6]].dVal, __argValues[dI[7]].dVal,
                                                              __argValues[dI[8]].dVal, __argValues[dI[9]].dVal,
                                                              __argValues[dI[10]].dVal, __argValues[dI[11]].dVal,
                                                              __argValues[dI[12]].dVal, __argValues[dI[13]].dVal,
                                                              __argValues[dI[14]].dVal
                                                            );
                            break;
                        default:
                            failureCode = @symbol(TooManyArguments);
                            goto getOutOfHere;
                    }
            }
        }
    }
# endif // alternative to FFI

    DEBUGCODE_IF( @global(Verbose), {
        printf("retval is %"_ld_" (0x%"_lx_")\n", (INT)(__returnValue.iVal), (INT)(__returnValue.iVal));
    })

    if ((returnTypeSymbol == @symbol(int))
     || (returnTypeSymbol == @symbol(sint))
     || (returnTypeSymbol == @symbol(sint8))
     || (returnTypeSymbol == @symbol(sint16))
     || (returnTypeSymbol == @symbol(sint32))) {
        DEBUGCODE_IF( @global(Verbose), {
            printf("return int: %"_lx_"\n", (INT)(__returnValue.iVal));
        })
        RETURN ( __MKINT(__returnValue.iVal) );
    }
    if ((returnTypeSymbol == @symbol(uint))
     || (returnTypeSymbol == @symbol(uint8))
     || (returnTypeSymbol == @symbol(uint16))
     || (returnTypeSymbol == @symbol(uint32))) {
        DEBUGCODE_IF( @global(Verbose), {
            printf("return uint: %"_lx_"\n", (INT)(__returnValue.iVal));
        })
        RETURN ( __MKUINT(__returnValue.iVal) );
    }
    if (returnTypeSymbol == @symbol(bool)) {
        RETURN ( __returnValue.iVal ? true : false );
    }
    if (returnTypeSymbol == @symbol(float)) {
        RETURN ( __MKFLOAT(__returnValue.fVal ));
    }
    if (returnTypeSymbol == @symbol(double)) {
        RETURN ( __MKFLOAT(__returnValue.dVal ));
    }
    if (returnTypeSymbol == @symbol(void)) {
        RETURN ( nil );
    }
    if (returnTypeSymbol == @symbol(char)) {
        RETURN ( __MKCHARACTER(__returnValue.iVal & 0xFF) );
    }
    if (returnTypeSymbol == @symbol(wchar)) {
        RETURN ( __MKUCHARACTER(__returnValue.iVal & 0xFFFF) );
    }
    if (returnTypeSymbol == @symbol(sint64)) {
# if (__POINTER_SIZE__ == 8)

        DEBUGCODE_IF( @global(Verbose), {
            printf("return sint64: %"_lx_"\n", (INT)(__returnValue.longLongVal));
        })
        RETURN ( __MKINT(__returnValue.longLongVal) );
# else
        DEBUGCODE_IF( @global(Verbose), {
            printf("return sint64: %lx%08lx\n", __HI32(__returnValue.longLongVal), __LO32(__returnValue.longLongVal));
        })
        RETURN ( __MKINT64(&__returnValue.longLongVal) );
# endif
    }
    if (returnTypeSymbol == @symbol(uint64)) {
# if (__POINTER_SIZE__ == 8)
        DEBUGCODE_IF( @global(Verbose), {
            printf("return uint64: %"_lx_"\n", (unsigned INT)(__returnValue.longLongVal));
        })
        RETURN ( __MKUINT(__returnValue.longLongVal) );
# else
        DEBUGCODE_IF( @global(Verbose), {
            printf("return sint64: %lx%08lx\n", __HI32(__returnValue.longLongVal), __LO32(__returnValue.longLongVal));
        })
        RETURN ( __MKUINT64(&__returnValue.longLongVal) );
# endif
    }

    DEBUGCODE_IF( @global(Verbose), {
        printf("return pointer: %"_lx_"\n", (INT)(__returnValue.pointerVal));
    })
    if (returnTypeSymbol == @symbol(handle) || returnTypeSymbol == @symbol(pointer)) {
        if (__returnValue.pointerVal == NULL) {
            RETURN ( nil );
        } else {
            if (returnValue != nil) {
            	static struct inlineCache _initialize_ilc = _ILC0;
                __externalAddressVal(returnValue) = __returnValue.pointerVal;
                /* Call initialize */
                (_initialize_ilc.ilc_func)(returnValue, @symbol(initialize), nil, &_initialize_ilc);
                RETURN ( returnValue );
            } else {
	returnValue = __MKEXTERNALADDRESS(__returnValue.pointerVal);
            }
        }
    } else if (returnTypeSymbol == @symbol(bytePointer)) {
        returnValue = __MKEXTERNALBYTES(__returnValue.pointerVal);
    } else if (returnTypeSymbol == @symbol(charPointer)) {
        returnValue = __MKSTRING(__returnValue.pointerVal);
    } else if (returnTypeSymbol == @symbol(wcharPointer)) {
        returnValue = __MKU16STRING(__returnValue.pointerVal);
    } else {
        __FAIL__(@symbol(UnknownReturnType2))
    }

getOutOfHere: ;
%}.
    failureCode notNil ifTrue:[
        (failureCode == #UnknownReturnType or:[ failureCode == #UnknownArgumentType ]) ifTrue:[
            oldReturnType := returnType.
            oldArgumentTypes := argumentTypes.
            self adjustTypes.
            ((oldReturnType ~= returnType) or:[oldArgumentTypes ~= argumentTypes]) ifTrue:[
                thisContext restart
            ].
        ].
        (failureCode == #BadArgForAsyncCall) ifTrue:[
            ^ self tryAgainWithAsyncSafeArguments:argumentsOrNil forCPPInstance:aReceiverOrNil
        ].
        (failureCode == #FFINotSupported) ifTrue:[
            self primitiveFailed:'FFI support missing in this build'.
        ].

        self primitiveFailed.   "see failureCode and failureInfo for details"
        ^ nil
    ].

    returnType isSymbol ifTrue:[
        returnValueClass notNil ifTrue:[
            self isConstReturnValue ifTrue:[
                returnValue changeClassTo:returnValueClass.
                ^ returnValue
            ].
            ^ returnValueClass fromExternalAddress:returnValue.
        ].
    ] ifFalse:[
        returnType isCPointer ifTrue:[
            returnType baseType isCStruct ifTrue:[
                stClass := Smalltalk classNamed:returnType baseType name.
                stClass notNil ifTrue:[
                    self isConstReturnValue ifTrue:[
                        returnValue changeClassTo:returnValueClass.
                        ^ returnValue
                    ].
                    ^ stClass fromExternalAddress:returnValue.
                ].
            ].
            returnType baseType isCChar ifTrue:[
                ^ returnValue stringAt:1
            ].
        ].
    ].

    ^ returnValue

    "Created: / 01-08-2006 / 13:56:23 / cg"
    "Modified: / 26-08-2016 / 15:36:35 / cg"
    "Modified: / 07-07-2015 / 22:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tryAgainWithAsyncSafeArguments:argumentsOrNil forCPPInstance:aReceiverOrNil
    "invoked by the call primitive, iff GC-unsave arguments where passed to the call.
     Here, allocate non-movable blocks of memory and copy the arguments into them,
     then try the call again, copy changed values back, and release the memeory."

    |saveArguments anyBadArg result originalToSaveArgMapping|

    argumentsOrNil isNil ifTrue:[
	^ self primitiveFailed
    ].
    thisContext isRecursive ifTrue: [^self primitiveFailed].

    anyBadArg := false.
    originalToSaveArgMapping := IdentityDictionary new.

    saveArguments := argumentsOrNil
			collect:[:eachArg |
			    |saveArg|

			    (originalToSaveArgMapping includesKey:eachArg) ifTrue:[
				saveArg := originalToSaveArgMapping at:eachArg
			    ] ifFalse:[
				eachArg isString ifTrue:[
				    saveArg := (ExternalBytes fromString:eachArg) register.
				    anyBadArg := true.
				    originalToSaveArgMapping at:eachArg put:saveArg.
				] ifFalse:[
				    eachArg isByteCollection ifTrue:[
					saveArg := (ExternalBytes from:eachArg) register.
					originalToSaveArgMapping at:eachArg put:saveArg.
					anyBadArg := true.
				    ] ifFalse:[
					saveArg := eachArg
				    ]
				].
			    ].
			    saveArg
			].

    anyBadArg ifFalse:[
	"avoid recursion..."
	^ self primitiveFailed
    ].

    result := self invokeFFIwithArguments:saveArguments forCPPInstance:aReceiverOrNil.

    "/ copy back !!
    originalToSaveArgMapping keysAndValuesDo:[:arg :saveArg |
	arg isSymbol ifFalse:[
	    arg replaceFrom:1 to:(arg size) with:saveArg startingAt:1.
	].
	saveArg free.
    ].
    ^ result.

    "Modified (format): / 06-11-2012 / 10:52:41 / anwild"
! !

!ExternalLibraryFunction methodsFor:'testing'!

isExternalLibraryFunction
    "return true, if the receiver is some kind of externalLibrary function;
     true is returned here"

    ^true

    "Created: / 07-06-2007 / 10:36:40 / cg"
! !

!ExternalLibraryFunction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/ExternalLibraryFunction.st,v 1.97 2015-04-20 10:48:54 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ ' Id: ExternalLibraryFunction.st 10643 2011-06-08 21:53:07Z vranyj1  '
! !


ExternalLibraryFunction initialize!

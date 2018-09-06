"
 COPYRIGHT (c) 2007 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

ExternalFunction subclass:#ExternalFunctionCallback
	instanceVariableNames:'returnType argumentTypes flags action'
	classVariableNames:'CallBackRegistry'
	poolDictionaries:''
	category:'System-Support'
!

!ExternalFunctionCallback primitiveDefinitions!
%{
#include <stdlib.h>
#include <stdio.h>

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
# endif

#endif

%}
! !

!ExternalFunctionCallback primitiveFunctions!
%{

#ifdef HAVE_FFI
#define xxVERBOSE

void
ExternalFunctionCallback__closure_wrapper_fn(ffi_cif* cif, void* resp, void** args, void* userdata)
{
    INT actionIndex = (INT)userdata;
    int i;
    OBJ st_argVector = nil;
    OBJ st_actionVector, st_callBack = nil, st_result;
    OBJFUNC code;
    ffi_type *retType;
    INT sintResult;
    unsigned INT uintResult;
    float floatResult;
    double doubleResult;

    if (@global(ExternalFunctionCallback:Verbose) == true) {
	fprintf(stderr, "ExternalFunctionCallback(wrapper): actionIndex=%"_ld_" resp*=%"_lx_"\n", actionIndex, (INT)resp);
	fflush(stderr);
	fprintf(stderr, "ExternalFunctionCallback(wrapper): nargs=%d\n", cif->nargs);
	fflush(stderr);
    }

    st_argVector = __ARRAY_NEW_INT(cif->nargs);

    for (i=0; i<cif->nargs; i++) {
	ffi_type *argType;
	OBJ st_arg = nil;

	__PROTECT__(st_argVector);

	argType = cif->arg_types[i];
	if (argType == __get_ffi_type_sint()) {
	    st_arg = __MKINT( *(int *)(args[i]) );
	} else if (argType == __get_ffi_type_uint()) {
	    st_arg = __MKUINT( *(unsigned int *)(args[i]) );
	} else if (argType == __get_ffi_type_uint8()) {
	    st_arg = __MKSMALLINT( *(unsigned char *)(args[i]) );
	} else if (argType == __get_ffi_type_sint8()) {
	    st_arg = __MKSMALLINT( *(char *)(args[i]) );
	} else if (argType == __get_ffi_type_uint16()) {
	    st_arg = __MKSMALLINT( *(unsigned short *)(args[i]) );
	} else if (argType == __get_ffi_type_sint16()) {
	    st_arg = __MKSMALLINT( *(short *)(args[i]) );
	} else if (argType == __get_ffi_type_uint32()) {
	    st_arg = __MKUINT( *(unsigned int *)(args[i]) );
	} else if (argType == __get_ffi_type_sint32()) {
	    st_arg = __MKINT( *(int *)(args[i]) );
	} else if (argType == __get_ffi_type_float()) {
	    st_arg = __MKSFLOAT( *(float *)(args[i]) );
	} else if (argType == __get_ffi_type_double()) {
	    st_arg = __MKFLOAT( *(double *)(args[i]) );
	} else if (argType == __get_ffi_type_pointer()) {
	    st_arg = __MKEXTERNALADDRESS( *(void **)(args[i]) );
	} else {
	    if (@global(ExternalFunctionCallback:Verbose) == true) {
		fprintf(stderr, "ExternalFunctionCallback(wrapper): invalid argument type %"_lx_" - arg %d\n", (INT)argType, i);
	    }
	}

	__UNPROTECT__(st_argVector);

	if (@global(ExternalFunctionCallback:Verbose) == true) {
	    fprintf(stderr, "ExternalFunctionCallback(wrapper): st-arg for %"_lx_" is %"_lx_"\n", *(unsigned INT *)(args[i]), (INT)st_arg);
	}
	__ArrayInstPtr(st_argVector)->a_element[i] = st_arg; __STORE(st_argVector, st_arg);
    }

    /* the action ... */
    st_actionVector = @global(ExternalFunctionCallback:CallBackRegistry);
    if (st_actionVector != nil) {
	OBJ cls = __Class(st_actionVector);

	if ((cls == Array) || (cls==WeakArray)) {
	    actionIndex += /* nInstVars */ __intVal(__ClassInstPtr(cls)->c_ninstvars);

	    if (__arraySize(st_actionVector) <= actionIndex) {
		st_callBack = __ArrayInstPtr(st_actionVector)->a_element[actionIndex-1];
	    }
	}
    }
    if (st_callBack == nil) {
	if (@global(ExternalFunctionCallback:Verbose) == true) {
	    fprintf(stderr, "ExternalFunctionCallback(wrapper): ignored nil callback\n");
	}
	*(void **)resp = 0;
	return;
    }

    if (@global(ExternalFunctionCallback:Verbose) == true) {
	fprintf(stderr, "ExternalFunctionCallback(wrapper): sending value: to %"_lx_"..\n", (INT)st_callBack);
    }
    {
	static struct inlineCache value_snd = __DUMMYILC1((@line+1));
	st_result = _SEND1(st_callBack, @symbol(callFromCWith:), nil, &value_snd, st_argVector);
    }
    if (@global(ExternalFunctionCallback:Verbose) == true) {
	fprintf(stderr, "ExternalFunctionCallback(wrapper): result is %"_lx_"\n", (INT)st_result);
    }

    retType = cif->rtype;

    if (st_result == true) {
	sintResult = uintResult = 1;
    } else if (st_result == false) {
	sintResult = uintResult = 0;
    } else if (st_result == nil) {
	sintResult = uintResult = 0;
    } else {
	sintResult = __signedLongIntVal(st_result);
	uintResult = __unsignedLongIntVal(st_result);
    }

    if (retType == __get_ffi_type_sint()) {
	*(int *)resp = sintResult;
    } else if (retType == __get_ffi_type_uint()) {
	*(int *)resp = uintResult;
    } else if (retType == __get_ffi_type_uint8()) {
	*(unsigned char *)resp = uintResult;
    } else if (retType == __get_ffi_type_sint8()) {
	*(char *)resp = sintResult;
    } else if (retType == __get_ffi_type_uint16()) {
	*(unsigned short *)resp = uintResult;
    } else if (retType == __get_ffi_type_sint16()) {
	*(short *)resp = sintResult;
    } else if (retType == __get_ffi_type_uint32()) {
	*(int *)resp = uintResult;
    } else if (retType == __get_ffi_type_sint32()) {
	*(int *)resp = sintResult;
    } else if (retType == __get_ffi_type_float()) {
	if (__isFloat(st_result)) {
	    *(float *)resp = (float)__floatVal(st_result);
	} else {
	    if (__isShortFloat(st_result)) {
		*(float *)resp = __shortFloatVal(st_result);
	    } else {
		*(float *)resp = (float)sintResult;
	    }
	}
    } else if (retType == __get_ffi_type_double()) {
	if (__isFloat(st_result)) {
	    *(double *)resp = __floatVal(st_result);
	} else {
	    if (__isShortFloat(st_result)) {
		*(double *)resp = (double)__shortFloatVal(st_result);
	    } else {
		*(double *)resp = (double)sintResult;
	    }
	}
    } else if (retType == __get_ffi_type_pointer()) {
	*(void **)resp = (void *)__externalAddressVal( st_result );
    } else {
	if (@global(ExternalFunctionCallback:Verbose) == true) {
	    fprintf(stderr, "ExternalFunctionCallback(wrapper): invalid result type %"_ld_"\n", (INT)retType);
	}
	*(void **)resp = 0;
    }
}

void
ExternalFunctionCallback__test_call_closure(INTLFUNC f)
{
    INT result = 0;

    printf("doCall_closure: calling closure %"_lx_"(123)...\n", (INT)f);
    result = (*f)(123);
    printf("doCall_closure: back; result is %"_lx_"...\n", (INT)result);
}
#endif /* HAVE_FFI */

%}
! !

!ExternalFunctionCallback class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    an ExternalFunctionCallback wraps a block into a C-callable function;
    i.e. it creates a closure, which as seen from C-code looks like an ordinary
    function pointer, but when invoked evaluates a smalltalk block.

    A callback is created with:
       cb := ExternalFunctionCallback new.
    the arguments (as passed from the C-caller into ST)
    and the returnValue (from ST to the C-caller) are specified with:
       cb returnType:#bool argumentTypes:#(uint).
    Then, the code is generated with:
       cb generateClosure.

    After that, the callBack-functions address can be acquired with:
       cb address.  'can be passed to C'.
    and handed out to C. (you can also hand out the callBack directly - as it is a subclass of
    ExternalBytes.
    The actual action of the callback can be changed (at any time later) with:
	cb action:[:args | Transcript showCR:args. true].

    Eventually, the callback MUST be released:
	cb release.

    [author:]
	Claus Gittinger
"
!

examples
"
    |cb|

    cb := ExternalFunctionCallback new.
    cb returnType:#bool argumentTypes:#(uint).
    cb beCallTypeWINAPI.
    cb generateClosure.
    cb action:[:args | Transcript showCR:args. true].
    cb code.  'can be passed to C'.

    ExternalFunctionCallback testCall:cb withArgument:123.

    cb action:[:args | Transcript show:'hello '; showCR:args. true].

    ExternalFunctionCallback testCall:cb withArgument:123.

    cb release
"
! !

!ExternalFunctionCallback class methodsFor:'instance creation'!

callbackFor:aBlock returnType:returnType argumentTypes:argumentTypes
    "generate a callback for the ErrorCallbackProc signature:
	ErrorCallbackProc(HWND hWnd, int nErrID, LPTSTR lpErrorText)
     which, can be given to an external API call and which invokes the
     three arg block when clled.
     Do not forget to eventually release the callback to avoid a memory leak."

    |cb|

    self assert:(aBlock numArgs == argumentTypes size).

    cb := ExternalFunctionCallback new.
    cb returnType:returnType argumentTypes:argumentTypes.
    cb beCallTypeWINAPI.
    cb generateClosure.
    cb action:aBlock.
    "/ ^ cb code.  'can be passed to C'.
    ^ cb

    "
     |cb|

     cb := self errorCallbackProcFor:[:a1 :a2 :a3 | Transcript showCR:('%1 %2 %3' bindWith:a1 with:a2 with:a3)].
     ExternalFunctionCallback testCall:cb withArguments:#(#[1 2 3] 456 'hello').
     cb release
    "
!

errorCallbackProcFor:aThreeArgBlock
    "generate a callback for the ErrorCallbackProc signature:
	ErrorCallbackProc(HWND hWnd, int nErrID, LPTSTR lpErrorText)
     which, can be given to an external API call and which invokes the
     three arg block when clled.
     Do not forget to eventually release the callback to avoid a memory leak."

    ^ self
	callbackFor:aThreeArgBlock
	returnType:#long
	argumentTypes:#(handle int charPointer)

    "
     |cb|

     cb := self errorCallbackProcFor:[:a1 :a2 :a3 | Transcript showCR:('%1 %2 %3' bindWith:a1 with:a2 with:a3)].
     ExternalFunctionCallback testCall:cb withArguments:#(#[1 2 3] 456 'hello').
     cb release
    "
! !

!ExternalFunctionCallback class methodsFor:'constants'!

callTypeAPI
    ^ ExternalLibraryFunction callTypeAPI
!

callTypeC
    ^ ExternalLibraryFunction callTypeC
!

callTypeCDecl
    ^ ExternalLibraryFunction callTypeCDecl
!

callTypeMASK
    ^ ExternalLibraryFunction callTypeMASK
!

callTypeOLE
    ^ ExternalLibraryFunction callTypeOLE
! !

!ExternalFunctionCallback class methodsFor:'helpers'!

closureIndexFor:aCallBack
    CallBackRegistry isNil ifTrue:[
	CallBackRegistry := WeakArray with:aCallBack.
    ] ifFalse:[
	CallBackRegistry := CallBackRegistry copyWith:aCallBack.
    ].
    ^ CallBackRegistry size.
!

testCall:aCallback withArgument:arg
    "a simple test, if I can be called"

    self testCall:aCallback withArguments:(Array with:arg)
!

testCall:aCallback withArguments:args
    "a simple test, if I can be called"
%{
#   define MAX_CALLBACK_ARGS 5
    INTLFUNC f = __externalAddressVal(aCallback);
    INT result;
    int i;
    void *c_args[MAX_CALLBACK_ARGS];

    if (! __isArray(args))
	goto badArg;
    if (__arraySize(args) > MAX_CALLBACK_ARGS)
	goto badArg;

    for (i=0; i < __arraySize(args); i++) {
	OBJ arg = __ArrayInstPtr(args)->a_element[i];

	if (__isSmallInteger(arg)) {
	    c_args[i] = (void *)(__intVal(arg));
	} else if (arg == true) {
	    c_args[i] = (void *)1;
	} else if (arg == false) {
	    c_args[i] = (void *)0;
	} else if (__isStringLike(arg)) {
	    c_args[i] = (void *)__stringVal(arg);
	} else if (__isByteArrayLike(arg)) {
	    c_args[i] = (void *)__byteArrayVal(arg);
	} else
	    goto badArg;
    }
    fprintf(stderr, "ExternalFunctionCallback: calling callBack %"_lx_"(%"_lx_", %"_lx_")\n", (INT)f, (INT)(c_args[0]), (INT)(c_args[1]));
    result = (*f)(c_args[0], c_args[1], c_args[2], c_args[3], c_args[4]);
    fprintf(stderr, "ExternalFunctionCallback: result from callBack is %"_lx_"\n", (INT)result);
    RETURN(true);

badArg: ;
%}.
    self error:'bad argument'
! !

!ExternalFunctionCallback methodsFor:'accessing'!

action:aBlock
    "set the action-block, to be evaluated when C calls me.
     The C-arguments will be passed as arguments to the block.
     The value returned by the block will be returned to the C-caller."

    action := aBlock.
!

beCallTypeAPI
    flags := (flags ? 0) bitOr: (self class callTypeAPI).

    "Created: / 01-08-2006 / 15:12:40 / cg"
!

beCallTypeC
    flags := (flags ? 0) bitOr: (self class callTypeC).

    "Created: / 01-08-2006 / 15:12:40 / cg"
!

beCallTypeOLE
    flags := (flags ? 0) bitOr: (self class callTypeOLE).

    "Created: / 01-08-2006 / 15:12:40 / cg"
!

beCallTypeWINAPI
    self beCallTypeAPI

    "Modified: / 01-08-2006 / 15:14:02 / cg"
!

callTypeNumber
    ^ (flags ? 0) bitAnd: (self class callTypeMASK)

    "Created: / 01-08-2006 / 15:12:10 / cg"
!

isCallTypeAPI
    ^ ((flags ? 0) bitAnd: (self class callTypeMASK)) == (self class callTypeAPI)

    "Created: / 01-08-2006 / 15:21:16 / cg"
!

isCallTypeC
    ^ ((flags ? 0) bitAnd: (self class callTypeMASK)) == (self class callTypeC)
!

isCallTypeOLE
    ^ ((flags ? 0) bitAnd: (self class callTypeMASK)) == (self class callTypeOLE)
! !

!ExternalFunctionCallback methodsFor:'callback'!

callFromCWith:argList
    "invoked by the C-code, to which we have given out the code-ptr.
     Because this is evaluated from C, we probably should not block or abort or do
     any other things which confuse C
     (its probably a good idea to write something into a queue here)"

    action notNil ifTrue:[
	^ action valueWithArguments:argList
    ].
    ^ nil
! !

!ExternalFunctionCallback methodsFor:'generation'!

code
    self hasCode ifFalse:[
	self generateClosure
    ].
    ^ super code

    "Created: / 11-06-2007 / 15:53:00 / cg"
! !

!ExternalFunctionCallback methodsFor:'private-accessing'!

returnType:aReturnType argumentTypes:argTypes
    "see generateClosure for valid return types"

    returnType := aReturnType.
    argumentTypes := argTypes.

    "Created: / 11-06-2007 / 15:52:01 / cg"
    "Modified: / 19-09-2007 / 18:14:59 / cg"
! !

!ExternalFunctionCallback methodsFor:'private-generation'!

generateClosure
    |argTypeSymbols returnTypeSymbol failureCode failureInfo
     callTypeNumber returnValueClass argValueClass callBackIndex|

    argTypeSymbols := argumentTypes.
    returnTypeSymbol := returnType.
    callBackIndex := self class closureIndexFor:self.
    callTypeNumber := self callTypeNumber.
%{
#ifdef HAVE_FFI
    ffi_cif *pcif;
    ffi_type *__returnType = NULL;
    static int null = 0;
    int i;
    ffi_abi __callType = FFI_DEFAULT_ABI;
    int __numArgsWanted;
    struct closurePlusCIF {
	ffi_closure closure;
	ffi_cif cif;
	ffi_type *argTypes[MAX_ARGS];
    } *closurePlusCIFp;
    ffi_closure *pcl;
    ffi_cif *cif;
    ffi_type **argTypePtrs;

    closurePlusCIFp = (struct closurePlusCIF *) malloc(sizeof(struct closurePlusCIF));
    cif = &(closurePlusCIFp->cif);
    argTypePtrs = closurePlusCIFp->argTypes;
    pcl = &(closurePlusCIFp->closure);

#define __FAIL__(fcode) \
    { \
	failureCode = fcode; free(closurePlusCIFp); goto getOutOfHere; \
    }

    if (argTypeSymbols == nil) {
	__numArgsWanted = 0;
    } else if (__isArray(argTypeSymbols)) {
	__numArgsWanted = __arraySize(argTypeSymbols);
    } else {
	__FAIL__(@symbol(BadArgumentTypeVector))
    }

    if (__numArgsWanted > MAX_ARGS) {
	__FAIL__(@symbol(TooManyArguments))
    }

    /*
     * validate the return type
     */
    if (returnTypeSymbol == @symbol(voidPointer)) {
	returnTypeSymbol = @symbol(handle);
    }

    if (returnTypeSymbol == @symbol(int)) {
	__returnType = __get_ffi_type_sint();
    } else if (returnTypeSymbol == @symbol(uint)) {
	__returnType = __get_ffi_type_uint();
    } else if (returnTypeSymbol == @symbol(uint8)) {
	__returnType = __get_ffi_type_uint8();
    } else if (returnTypeSymbol == @symbol(uint16)) {
	__returnType = __get_ffi_type_uint16();
    } else if (returnTypeSymbol == @symbol(uint32)) {
	__returnType = __get_ffi_type_uint32();
    } else if (returnTypeSymbol == @symbol(uint64)) {
	__returnType = __get_ffi_type_uint64();

    } else if (returnTypeSymbol == @symbol(sint)) {
	__returnType = __get_ffi_type_sint();
    } else if (returnTypeSymbol == @symbol(sint8)) {
	__returnType = __get_ffi_type_sint8();
    } else if (returnTypeSymbol == @symbol(sint16)) {
	__returnType = __get_ffi_type_sint16();
    } else if (returnTypeSymbol == @symbol(sint32)) {
	__returnType = __get_ffi_type_sint32();
    } else if (returnTypeSymbol == @symbol(sint64)) {
	__returnType = __get_ffi_type_sint64();

    } else if (returnTypeSymbol == @symbol(long)) {
	if (sizeof(long) == 4) {
	   returnTypeSymbol = @symbol(sint32);
	   __returnType = __get_ffi_type_sint32();
	} else if (sizeof(long) == 8) {
	   returnTypeSymbol = @symbol(sint64);
	   __returnType = __get_ffi_type_sint64();
	} else {
	    __FAIL__(@symbol(UnknownReturnType))
	}

    } else if (returnTypeSymbol == @symbol(ulong)) {
	if (sizeof(long) == 4) {
	   returnTypeSymbol = @symbol(uint32);
	   __returnType = __get_ffi_type_uint32();
	}else if (sizeof(long) == 8) {
	   returnTypeSymbol = @symbol(uint64);
	   __returnType = __get_ffi_type_uint64();
	} else {
	    __FAIL__(@symbol(UnknownReturnType))
	}

    } else if (returnTypeSymbol == @symbol(bool)) {
	__returnType = __get_ffi_type_uint();

    } else if (returnTypeSymbol == @symbol(float)) {
	__returnType = __get_ffi_type_float();
    } else if (returnTypeSymbol == @symbol(double)) {
	__returnType = __get_ffi_type_double();

    } else if (returnTypeSymbol == @symbol(void)) {
	__returnType = __get_ffi_type_void();
    } else if ((returnTypeSymbol == @symbol(pointer))
	       || (returnTypeSymbol == @symbol(handle))
	       || (returnTypeSymbol == @symbol(charPointer))
	       || (returnTypeSymbol == @symbol(bytePointer))
	       || (returnTypeSymbol == @symbol(floatPointer))
	       || (returnTypeSymbol == @symbol(doublePointer))
	       || (returnTypeSymbol == @symbol(intPointer))
	       || (returnTypeSymbol == @symbol(shortPointer))
	       || (returnTypeSymbol == @symbol(wcharPointer))) {
	__returnType = __get_ffi_type_pointer();
    } else {
	if (__isSymbol(returnTypeSymbol)
	 && ((returnValueClass = __GLOBAL_GET(returnTypeSymbol)) != nil)) {
	    if (! __isBehaviorLike(returnValueClass)) {
		__FAIL__(@symbol(NonBehaviorReturnType))
	    }
	    if (! __qIsSubclassOfExternalAddress(returnValueClass)) {
		__FAIL__(@symbol(NonExternalAddressReturnType))
	    }
	    __returnType = __get_ffi_type_pointer();
	    returnTypeSymbol = @symbol(pointer);
	} else {
	    __FAIL__(@symbol(UnknownReturnType))
	}
    }

    /*
     * setup arg-buffers
     */
    for (i=0; i<__numArgsWanted; i++) {
	ffi_type *thisType;
	void *argValuePtr;
	OBJ typeSymbol;

	failureInfo = __mkSmallInteger(i+1);   /* in case there is one */

	typeSymbol = __ArrayInstPtr(argTypeSymbols)->a_element[i];

	if (typeSymbol == @symbol(handle)) {
	    typeSymbol = @symbol(pointer);
	} else if (typeSymbol == @symbol(voidPointer)) {
	    typeSymbol = @symbol(pointer);
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

	if (typeSymbol == @symbol(int)) {
	    thisType = __get_ffi_type_sint();
	} else if (typeSymbol == @symbol(uint)) {
	    thisType = __get_ffi_type_uint();
	} else if (typeSymbol == @symbol(uint8)) {
	    thisType = __get_ffi_type_uint8();
	} else if (typeSymbol == @symbol(sint8)) {
	    thisType = __get_ffi_type_sint8();
	} else if (typeSymbol == @symbol(uint16)) {
	    thisType = __get_ffi_type_uint16();
	} else if (typeSymbol == @symbol(sint16)) {
	    thisType = __get_ffi_type_sint16();
	} else if ((typeSymbol == @symbol(uint32)) || (typeSymbol == @symbol(sint32))) {
	    thisType = __get_ffi_type_uint32();
	} else if (typeSymbol == @symbol(float)) {
	    thisType = __get_ffi_type_float();
	} else if (typeSymbol == @symbol(double)) {
	    thisType = __get_ffi_type_double();
	} else if (typeSymbol == @symbol(void)) {
	    thisType = __get_ffi_type_void();
	} else if (typeSymbol == @symbol(charPointer)) {
	    thisType = __get_ffi_type_pointer();
	} else if (typeSymbol == @symbol(floatPointer)) {
	    thisType = __get_ffi_type_pointer();
	} else if (typeSymbol == @symbol(doublePointer)) {
	    thisType = __get_ffi_type_pointer();
	} else if (typeSymbol == @symbol(pointer)) {
commonPointerTypeArg: ;
	    thisType = __get_ffi_type_pointer();
	} else if (typeSymbol == @symbol(bool)) {
	    thisType = __get_ffi_type_uint();
	} else if (__isSymbol(typeSymbol)
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

	closurePlusCIFp->argTypes[i] = thisType;
    }
    failureInfo = nil;

    __callType = FFI_DEFAULT_ABI;

    if (callTypeNumber != nil) {
#ifdef CALLTYPE_FFI_STDCALL
	if (callTypeNumber == @global(ExternalLibraryFunction:CALLTYPE_API)) {
	    __callType = CALLTYPE_FFI_STDCALL;
	}
#endif
#ifdef CALLTYPE_FFI_V8
	if (callTypeNumber == @global(ExternalLibraryFunction:CALLTYPE_V8)) {
	    __callType = CALLTYPE_FFI_V8;
	}
#endif
#ifdef CALLTYPE_FFI_V9
	if (callTypeNumber == @global(ExternalLibraryFunction:CALLTYPE_V9)) {
	    __callType = CALLTYPE_FFI_V9;
	}
#endif
#ifdef CALLTYPE_FFI_UNIX64
	if (callTypeNumber == @global(ExternalLibraryFunction:CALLTYPE_UNIX64)) {
	    __callType = CALLTYPE_FFI_UNIX64;
	}
#endif
    }

    if (@global(ExternalFunctionCallback:Verbose) == true) {
	printf("prep_cif cif-ptr=%"_lx_"\n", (INT)cif);
    }

    if (ffi_prep_cif(cif, __callType, __numArgsWanted, __returnType, argTypePtrs) != FFI_OK) {
	__FAIL__(@symbol(FFIPrepareFailed))
    }

    if (@global(ExternalFunctionCallback:Verbose) == true) {
	printf("closure is 0x%"_lx_" (%d bytes)\n", (INT)pcl, (int)sizeof(ffi_closure));
	printf("index is %"_ld_"\n", __intVal(callBackIndex));
    }
    if (ffi_prep_closure(pcl, cif, ExternalFunctionCallback__closure_wrapper_fn, (void *)(__intVal(callBackIndex)) /* userdata */) != FFI_OK) {
	__FAIL__(@symbol(FFIPrepareClosureFailed))
    }
    if (@global(ExternalFunctionCallback:Verbose) == true) {
	printf("pcl->cif is 0x%"_lx_"\n", (INT)(pcl->cif));
	printf("pcl->fun is 0x%"_lx_"\n", (INT)(pcl->fun));
	printf("pcl code at %"_lx_" is:\n", (INT)pcl);
	printf("  %02x %02x %02x %02x\n", ((unsigned char *)pcl)[0],((unsigned char *)pcl)[1],((unsigned char *)pcl)[2],((unsigned char *)pcl)[3]);
	printf("  %02x %02x %02x %02x\n", ((unsigned char *)pcl)[4],((unsigned char *)pcl)[5],((unsigned char *)pcl)[6],((unsigned char *)pcl)[7]);
	printf("  %02x %02x %02x %02x\n", ((unsigned char *)pcl)[8],((unsigned char *)pcl)[9],((unsigned char *)pcl)[10],((unsigned char *)pcl)[11]);
	printf("  %02x %02x %02x %02x\n", ((unsigned char *)pcl)[12],((unsigned char *)pcl)[13],((unsigned char *)pcl)[14],((unsigned char *)pcl)[15]);
    }
    __INST(code_) = (OBJ)pcl;

#if 0
    ExternalFunctionCallback__test_call_closure((INTLFUNC)pcl);
#endif

#else /* no FFI support */
    failureCode = @symbol(FFINotSupported);
#endif /* HAVE_FFI */
getOutOfHere: ;
%}.
    failureCode notNil ifTrue:[
	self primitiveFailed:(failureCode->failureInfo).   "see failureCode and failureInfo for details"
	^ nil
    ].

    "Created: / 11-06-2007 / 21:53:02 / cg"
! !

!ExternalFunctionCallback methodsFor:'private-releasing'!

release
    |idx|

    idx := CallBackRegistry identityIndexOf:self.
    CallBackRegistry at:idx put:nil.
%{
    void *pcl = (void *)__INST(code_);

    __INST(code_) = 0;
    if (pcl) {
	free(pcl);
	RETURN(self);
    }
%}.
    self invalidateReference.
! !

!ExternalFunctionCallback class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


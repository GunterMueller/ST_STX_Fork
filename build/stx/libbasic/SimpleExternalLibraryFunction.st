"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ExternalLibraryFunction subclass:#SimpleExternalLibraryFunction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!SimpleExternalLibraryFunction class methodsFor:'documentation'!

documentation
"
    instances of me are used for very simple functions, with all integer or
    equivalent arguments.
    These avoid the realively expensive ffi- arg setup, and jump directly to the
    target function.
    Can be used for a subset of all external functions and only on some machines.
    Only for tuning; the superclass must provide a fallback for all calls
"
! !

!SimpleExternalLibraryFunction methodsFor:'private invoking'!

invokeFFIwithArguments:argumentsOrNil forCPPInstance:aReceiverOrNil
    "the caller must have already checked, if instances of me are appropriate.
     May only be used for up to 10 args, with INT-sized non-float, non-struct arguments,
     and int-sized, non-float, non-struct return value.
     Now, all I do is convert the arguments and transfer directly; without the expensive ffi..."

    |argTypeSymbols returnTypeSymbol failureCode failureArgNr failureInfo returnValue stClass vtOffset
     virtual objectiveC async unlimitedStack callTypeNumber returnValueClass argValueClass
     oldReturnType oldArgumentTypes|

    virtual := self isVirtualCPP.
    objectiveC := self isObjectiveC.
    (virtual "or:[self isNonVirtualCPP]") ifTrue:[
	aReceiverOrNil isNil ifTrue:[
	    "/ must have a c++ object instance
	    self primitiveFailed.
	].

	"/ and it must be a kind of ExternalStructure !!
	(aReceiverOrNil isExternalStructure) ifFalse:[
	    self primitiveFailed.
	].
	virtual ifTrue:[
	    vtOffset := name.
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

%{  /* STACK: 100000 */

#define VERBOSE
#define MAX_ARGS 10

    int __numArgs, __numArgsIncludingThis;
    static INT null = 0;
    INT __args[MAX_ARGS+1];
    INT retVal;
    int i = -1;
    int argIdx = 0;
    INTLFUNC codeAddress = (voidFUNC)__INST(code_);
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
    if (__numArgs != __numArgsWanted) {
	__FAIL__(@symbol(ArgumentCountMismatch))
    }
    if (__numArgs > MAX_ARGS) {
	__FAIL__(@symbol(TooManyArguments))
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
	__args[0] = (INT)inst;
	__numArgsIncludingThis = __numArgs + 1;
	argIdx = 1;

	if (virtual == true) {
	    if (! __isSmallInteger(vtOffset)) {
		__FAIL__(@symbol(InvalidVTableIndex))
	    }
	    codeAddress = inst->vTable[__intVal(vtOffset)];
# ifdef VERBOSE
	    if (@global(Verbose) == true) {
		printf("virtual %d codeAddress: %"_lx_"\n", __intVal(vtOffset), (INT)codeAddress);
	    }
# endif
	}
    } else {
	__numArgsIncludingThis = __numArgs;
# ifdef VERBOSE
	if (@global(Verbose) == true) {
	    printf("codeAddress: %"_lx_"\n", (INT)codeAddress);
	}
# endif
    }

    /*
     * validate all arg types, map each to an ffi_type, and setup arg-buffers
     */
    for (i=0; i<__numArgs; i++, argIdx++) {
	OBJ arg;

	failureInfo = __mkSmallInteger(i+1);   /* in case there is one */

	arg = __ArrayInstPtr(argumentsOrNil)->a_element[i];

	if (__isSmallInteger(arg)) {
	    __args[argIdx] = __intVal(arg);
	} else {
	   INT iv = __signedLongIntVal(arg);
	   if (iv != 0) {
		__args[argIdx]  = iv;
	    } else {
		unsigned INT iv = __unsignedLongIntVal(arg);
		if (iv != 0) {
		    __args[argIdx] = iv;
		} else {
		    if (__isStringLike(arg)) {
			__args[argIdx] = (INT)(__stringVal(arg));
		    } else {
			if (__isBytes(arg)) {
			    __args[argIdx] = (INT)(__byteArrayVal(arg));
			    if (arg == NULL) {
				__args[argIdx] = (INT)0;
			    } else {
				if (__isExternalAddressLike(arg)) {
				    __args[argIdx] = (INT)(__externalAddressVal(arg));
				} else {
				    if (__isExternalBytesLike(arg)) {
					__args[argIdx] = (INT)(__externalBytesVal(arg));
				    } else {
					__FAIL__(@symbol(InvalidArgument))
				    }
				}
			    }
			}
		    }
		}
	    }
	}
    }
    failureInfo = nil;

    retVal = (*codeAddress)(__args[0], __args[1], __args[2], __args[3], __args[4], __args[5], __args[6],
			    __args[7], __args[8], __args[9], __args[10]);

# ifdef VERBOSE
    if (@global(Verbose) == true) {
	printf("retval is %"_ld_" (0x%"_lx_")\n", retVal, retVal);
    }
# endif

    if ((returnTypeSymbol == @symbol(int))
     || (returnTypeSymbol == @symbol(sint))
     || (returnTypeSymbol == @symbol(sint8))
     || (returnTypeSymbol == @symbol(sint16))
     || (returnTypeSymbol == @symbol(sint32))) {
# ifdef VERBOSE
	if (@global(Verbose) == true) {
	    printf("return int: %x\n", retVal);
	}
# endif
	RETURN ( __MKINT(retVal) );
    }
    if ((returnTypeSymbol == @symbol(uint))
     || (returnTypeSymbol == @symbol(uint8))
     || (returnTypeSymbol == @symbol(uint16))
     || (returnTypeSymbol == @symbol(uint32))) {
# ifdef VERBOSE
	if (@global(Verbose) == true) {
	    printf("return uint: %x\n", retVal);
	}
# endif
	RETURN ( __MKUINT(retVal) );
    }
    if (returnTypeSymbol == @symbol(bool)) {
	RETURN ( retVal ? true : false );
    }
    if (returnTypeSymbol == @symbol(void)) {
	RETURN ( nil );
    }
    if (returnTypeSymbol == @symbol(char)) {
	RETURN ( __MKCHARACTER(retVal & 0xFF) );
    }
    if (returnTypeSymbol == @symbol(wchar)) {
	RETURN ( __MKUCHARACTER(retVal & 0xFFFF) );
    }

# ifdef VERBOSE
    if (@global(Verbose) == true) {
	printf("return pointer: %"_lx_"\n", (INT)(retVal));
    }
# endif
    if (returnTypeSymbol == @symbol(handle)) {
	returnValue = __MKEXTERNALADDRESS(retVal);
    } else if (returnTypeSymbol == @symbol(pointer)) {
	returnValue = __MKEXTERNALBYTES(retVal);
    } else if (returnTypeSymbol == @symbol(bytePointer)) {
	returnValue = __MKEXTERNALBYTES(retVal);
    } else if (returnTypeSymbol == @symbol(charPointer)) {
	returnValue = __MKSTRING(retVal);
    } else if (returnTypeSymbol == @symbol(wcharPointer)) {
	returnValue = __MKU16STRING(retVal);
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
    "Modified: / 31-03-2016 / 00:03:03 / cg"
! !

!SimpleExternalLibraryFunction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


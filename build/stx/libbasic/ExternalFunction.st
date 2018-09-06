"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

ExecutableFunction subclass:#ExternalFunction
	instanceVariableNames:'name moduleHandle'
	classVariableNames:'InvalidCustomFunctionSignal'
	poolDictionaries:''
	category:'System-Support'
!

!ExternalFunction primitiveDefinitions!
%{
typedef INT  (*LINTFUNC)();
%}
! !

!ExternalFunction primitiveFunctions!
%{

/*
 * given an ST-object, make something useful for C
 * cast it to an int
 *
 * CAVEAT: floats are not allowed.
 */
INT
convertST_to_C(stObj)
    OBJ stObj;
{
	INT flags, nInst;
	OBJ *oP;

	if (__isString(stObj) || __isSymbol(stObj)) {
	    return (INT)(__stringVal(stObj));
	}
	if (__isByteArray(stObj)) {
	    return (INT)(__ByteArrayInstPtr(stObj)->ba_element);
	}
	if (__isExternalBytes(stObj)) {
	    return (INT)(__externalBytesAddress(stObj));
	}
	if (__isExternalAddress(stObj)) {
	    return (INT)(__externalAddressVal(stObj));
	}
	if (__isExternalFunction(stObj)) {
	    return (INT)(__externalFunctionVal(stObj));
	}
	if (__isSmallInteger(stObj)) {
	    return (INT)(__intVal(stObj));
	}
	if (__isLargeInteger(stObj)) {
	    return (INT)(__signedLongIntVal(stObj));
	}
	if (__isCharacter(stObj)) {
	    return (INT)(__intVal(__characterVal(stObj)));
	}
	if (stObj == nil) {
	    return 0;
	}

	if (__qClass(stObj) == @global(ShortFloat)) {
	    return (INT)(__shortFloatVal(stObj));
	}

	flags = __intVal(__ClassInstPtr(__qClass(stObj))->c_flags) & ARRAYMASK;
	nInst = __intVal(__ClassInstPtr(__qClass(stObj))->c_ninstvars);
	oP = (OBJ *)__InstPtr(stObj)->i_instvars[nInst];

	if (flags & FLOATARRAY) {
	    return (INT)(oP);
	}
	if (flags & DOUBLEARRAY) {
	    return (INT)(oP);
	}
	if (flags & DOUBLEARRAY) {
	    return (INT)(oP);
	}
	if (flags & BYTEARRAY) {
	    return (INT)(oP);
	}
	if (flags & WORDARRAY) {
	    return (INT)(oP);
	}
	if (flags & LONGARRAY) {
	    return (INT)(oP);
	}
	if (flags & SWORDARRAY) {
	    return (INT)(oP);
	}
	if (flags & SLONGARRAY) {
	    return (INT)(oP);
	}

	if (stObj == true) {
	    return 1;
	}
	if (stObj == false) {
	    return 0;
	}
	return 0;
}

%}
! !

!ExternalFunction class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Instances of this class represent external (non-Smalltalk) functions.

    (Obsolete) Custom Functions:
        This class also provides access to custom functions.
        These custom functions enable you to call c functions
        even if no stc compiler is available (they are kind of what user-primitives are in ST-80).
        You can register your own custom C-functions in a private main.c and relink ST/X from the binaries.
        (see the demo functions provided in main.c).
        Notice, that custom functions are ugly and inflexible.
        They are to be considered obsolete and support for them will vanish.

    If you have the stc compiler, we recommend using either inline primitive
    code or the new external function call interface which is based upon libffi.
    Both are easier to enter, compile, debug and maintain.
    (especially, to maintain, since the primitive code is contained
     in the classes source/object file - while custom functions are
     external to the classLibraries).

    Non custom externalFunctions are created, when a non-ST shared library is loaded,
    and returned by the ObjectFileHandles>>getFunction: method.

    The C functions contained in that lib are callable (instances of myself)
    with the call / callWith: methods.

    ST-arguments are converted to C as follows:
        ST class            C argument
        ------------------------------
        SmallInteger        int
        LargeInteger        int (must be 4-byte unsigned largeInteger)
        String              char *
        Symbol              char *
        Character           int
        ExternalBytes       char *
        ExternalAddress     char *
        ExternalFunction    char *
        FloatArray          float *
        DoubleArray         double *
        ByteArray           char *
        ShortFloat          float
        true                1
        false               0

    The returned value is converted to an unsigned integer (smallInteger or largeInteger).

    Notice, that no doubles can be passed; the reason is that the calling
    conventions (on stack, in registers, in FPU registers etc.) are so different among
    machines (and even compilers), that a general solution is not possible (difficult)
    to program here. To pass doubles, either use shortFloats, or pack them into a DoubleArray.
    For functions with up to 2 double arguments, specialized call methods are provided.
    Sorry for that inconvenience.


    - This is still in construction and NOT yet published for
      general use. For now, use inline C-code.

    [author:]
        Claus Gittinger

    [see also:]
        ExternalAddress ExternalBytes
        ( how to write primitive code :html: programming/primitive.html )
"
!

examples
"
    see a sample demo c file in doc/coding/cModules;
    compile and link (shared) it to an object module.
    Load it into the system:

	handle := ObjectFileLoader loadDynamicObject:'demo1.o'.

    get a C-function (an instance of ExternalFunction):

	f := handle getFunction:'function1'.

    call it:

	f callWith:999
"
! !

!ExternalFunction class methodsFor:'initialization'!

initialize
    "create signals"

    InvalidCustomFunctionSignal isNil ifTrue:[
	InvalidCustomFunctionSignal := ExecutionError newSignalMayProceed:true.
	InvalidCustomFunctionSignal nameClass:self message:#invalidCustomFunctionSignal.
	InvalidCustomFunctionSignal notifierString:'attempt to execute unknown custom function'.
    ]

    "Modified: 22.4.1996 / 18:08:55 / cg"
! !

!ExternalFunction class methodsFor:'Signal constants'!

invalidCustomFunctionSignal
    "return the signal raised when a non existent custom function is
     called for."

    ^ InvalidCustomFunctionSignal
! !

!ExternalFunction class methodsFor:'calling custom functions'!

callCustomFunction:nr
    "call the custom function #nr without arguments.
     See main.c for examples."

    ^ self callCustomFunction:nr withArguments:#()

    "
     ExternalFunction callCustomFunction:0
     ExternalFunction callCustomFunction:999
    "

    "Modified: 22.4.1996 / 18:06:52 / cg"
!

callCustomFunction:nr with:arg
    "call the custom function #nr with a single argument.
     See main.c for examples."

    ^ self callCustomFunction:nr withArguments:(Array with:arg)

    "
     ExternalFunction callCustomFunction:1 with:'hello world'
    "

    "Modified: 22.4.1996 / 18:07:03 / cg"
!

callCustomFunction:nr with:arg1 with:arg2
    "call the custom function #nr with two arguments.
     See main.c for examples."

    ^ self callCustomFunction:nr withArguments:(Array with:arg1 with:arg2)

    "
     ExternalFunction callCustomFunction:2 with:(Float pi) with:1.0
    "

    "Modified: 22.4.1996 / 18:07:11 / cg"
!

callCustomFunction:nr with:arg1 with:arg2 with:arg3
    "call the custom function #nr with three arguments.
     See main.c for examples."

    ^ self callCustomFunction:nr
		withArguments:(Array with:arg1 with:arg2 with:arg3)

    "Modified: 22.4.1996 / 18:07:18 / cg"
!

callCustomFunction:nr withArguments:argArray
    "call the custom function #nr with arguments from argArray.
     See main.c for examples."

    |retVal called errCode|

%{
#ifndef __stxNCustomFunctions__
    extern int __stxNCustomFunctions__;
    extern CUSTOMFUNCTION __stxCustomFunctions__[];
#endif
    int (* func)();

    called = false;
    if (__isSmallInteger(nr) && __isArray(argArray)) {
	int nargs = __arraySize(argArray);
	int functionNr;

	functionNr = __intVal(nr);
	if ((functionNr >= 0) && (functionNr < __stxNCustomFunctions__)) {
	    /*
	     * now, call the function; passing nargs and arg-vector
	     */
	    func = __stxCustomFunctions__[functionNr].func;
	    if (func) {
		int ok;

		retVal = self;
		ok = (*func)(nargs, &retVal, __ArrayInstPtr(argArray)->a_element);
		if (ok == 0) {
		    RETURN (retVal);
		}
		errCode = __mkSmallInteger(ok);
		called = true;
	    }
	}
    }
%}.
    called ifTrue:[
	"
	 the customFunction returned non-0 (failure)
	    PRIM_OK         0
	    PRIM_FAIL       -1
	    PRIM_ARGCOUNT   -2
	    PRIM_ARGTYPE    -3
	"
	errCode == -2 ifTrue:[
	    ^ self primitiveFailed:'argument count'
	].
	errCode == -3 ifTrue:[
	    ^ self primitiveFailed:'argument type'
	].
	^ self primitiveFailed
    ].

    "
     an invalid customFunction-nr was given,
    "
    InvalidCustomFunctionSignal raise

    "
     ExternalFunction callCustomFunction:2 withArguments:#(1.0 1.0)
     ExternalFunction callCustomFunction:999 withArguments:#(1.0 1.0)
    "
!

callCustomFunctionNamed:name withArguments:argArray
    "call a custom function by name with arguments from argArray"

    |index|

    index := self indexOfCustomFunctionNamed:name.
    index notNil ifTrue:[
	^ self callCustomFunction:index withArguments:argArray
    ].
    "
     no such function exists
    "
    InvalidCustomFunctionSignal raise

    "
     ExternalFunction callCustomFunctionNamed:'demoFunction0'
				withArguments:#()
    "

    "Modified: 22.4.1996 / 18:08:09 / cg"
!

indexOfCustomFunctionNamed:functionName
    "return the index of a named custom function"

%{  /* NOCONTEXT */
#ifndef __stxNCustomFunctions__
    extern int __stxNCustomFunctions__;
    extern CUSTOMFUNCTION __stxCustomFunctions__[];
#endif

    if (__isStringLike(functionName)) {
	char *nm;
	int i;

	nm = (char *)__stringVal(functionName);
	for (i=0; i < __stxNCustomFunctions__; i++) {
	   if (strcmp(__stxCustomFunctions__[i].name, nm) == 0) {
		RETURN (__mkSmallInteger(i));
	   }
	}
    }
%}.
    ^ nil

    "
     ExternalFunction indexOfCustomFunctionNamed:'demoFunction0'
     ExternalFunction indexOfCustomFunctionNamed:'fooBar'
    "
! !

!ExternalFunction class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == ExternalFunction

    "Created: 16.4.1996 / 11:24:50 / cg"
    "Modified: 23.4.1996 / 15:58:55 / cg"
! !

!ExternalFunction methodsFor:'accessing'!

moduleHandle
    "return the function's moduleHandle 
     (nil if not loaded dynamically)"

    ^ moduleHandle
!

name
    "return the function's name"

    ^ name
! !

!ExternalFunction methodsFor:'function calling'!

call
    "call the underlying C function, passing no argument.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	retVal = (*func)();
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callByRefWith:arg
    "call the underlying C function, passing a single argument by reference.
     The pointer of the argument is passed. Use this if you want to call a
     function with call-by-refernece semantics, like in fortran.
     The argument arg is converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;
    INT cArg;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	cArg = convertST_to_C(arg);
	retVal = (*func)(&cArg);
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callByRefWith:arg with:arg2
    "call the underlying C function, passing two args.
     The pointer of the arguments are passed. Use this if you want to call a
     function with call-by-refernece semantics, like in fortran.
     The arguments are converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;
    INT cArg, cArg2;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	cArg = convertST_to_C(arg);
	cArg2 = convertST_to_C(arg2);
	retVal = (*func)(&cArg, &cArg2);
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callByRefWith:arg with:arg2 with:arg3
    "call the underlying C function, passing three args.
     The pointer of the arguments are passed. Use this if you want to call a
     function with call-by-refernece semantics, like in fortran.
     The arguments are converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;
    INT cArg, cArg2, cArg3;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	cArg = convertST_to_C(arg);
	cArg2 = convertST_to_C(arg2);
	cArg3 = convertST_to_C(arg3);
	retVal = (*func)(&cArg, &cArg2, &cArg3);
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callByRefWithArguments:argArray
    "call the underlying C function, passing up to 10 arguments by reference.
     The arguments are converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
#   define NUMARGS 10
    INT args[NUMARGS];
    INT retVal;
    OBJ *ap;
    INT convertST_to_C();

    func = (LINTFUNC) __INST(code_);
    if (func && __isArray(argArray)) {
	int n = __arraySize(argArray);
	int i;

	if (n <= 10) {
	    ap = __ArrayInstPtr(argArray)->a_element;
	    for (i=0; i<NUMARGS; i++) {
		args[i] = convertST_to_C(*ap++);
	    }
	}
	switch (n) {
	    case 0:
		retVal = (*func)();
		break;
	    case 1:
		retVal = (*func)(&args[0]);
		break;
	    case 2:
		retVal = (*func)(&args[0], &args[1]);
		break;
	    case 3:
		retVal = (*func)(&args[0], &args[1], &args[2]);
		break;
	    case 4:
		retVal = (*func)(&args[0], &args[1], &args[2], &args[3]);
		break;
	    case 5:
		retVal = (*func)(&args[0], &args[1], &args[2], &args[3],
				 &args[4]);
		break;
	    case 6:
		retVal = (*func)(&args[0], &args[1], &args[2], &args[3],
				 &args[4], &args[5]);
		break;
	    case 7:
		retVal = (*func)(&args[0], &args[1],& args[2], &args[3],
				 &args[4], &args[5], &args[6]);
		break;
	    case 8:
		retVal = (*func)(&args[0], &args[1], &args[2], &args[3],
				 &args[4], &args[5], &args[6], &args[7]);
		break;
	    case 9:
		retVal = (*func)(&args[0], &args[1], &args[2], &args[3],
				 &args[4], &args[5], &args[6], &args[7],
				 &args[8]);
		break;
	    case 10:
		retVal = (*func)(&args[0], &args[1], &args[2], &args[3],
				 &args[4], &args[5], &args[6], &args[7],
				 &args[8], &args[9]);
		break;
	    default:
		goto err;
	}
	RETURN (__MKINT(retVal));
    }
  err: ;
%}.
    self primitiveFailed
!

callO
    "call the underlying C function, passing no argument.
     The return value must be a valid object.

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    OBJFUNC func;
    OBJ retVal;

    func = (OBJFUNC) __INST(code_);
    if (func) {
	retVal = (*func)();
	RETURN (retVal);
    }
%}.
    self primitiveFailed
!

callOWith:arg
    "call the underlying C function, passing a single object argument.
     The return value must be a valid object.

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    OBJFUNC func;
    OBJ retVal;

    func = (OBJFUNC) __INST(code_);
    if (func) {
	retVal = (*func)(arg);
	RETURN (retVal);
    }
%}.
    self primitiveFailed
!

callOWith:arg1 with:arg2
    "call the underlying C function, passing two args.
     The return value must be a valid object.

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    OBJFUNC func;
    OBJ retVal;

    func = (OBJFUNC) __INST(code_);
    if (func) {
	retVal = (*func)(arg1, arg2);
	RETURN (retVal);
    }
%}.
    self primitiveFailed
!

callOWith:arg1 with:arg2 with:arg3
    "call the underlying C function, passing three args.
     The return value must be a valid object.

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    OBJFUNC func;
    OBJ retVal;

    func = (OBJFUNC) __INST(code_);
    if (func) {
	retVal = (*func)(arg1, arg2, arg3);
	RETURN (retVal);
    }
%}.
    self primitiveFailed
!

callWith:arg
    "call the underlying C function, passing a single argument.
     The argument arg is converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	retVal = (*func)(convertST_to_C(arg));
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callWith:arg1 with:arg2
    "call the underlying C function, passing two args.
     The arguments are converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	retVal = (*func)(convertST_to_C(arg1), convertST_to_C(arg2));
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callWith:arg1 with:arg2 with:arg3
    "call the underlying C function, passing three args.
     The arguments are converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
    INT retVal;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	retVal = (*func)(convertST_to_C(arg1), convertST_to_C(arg2), convertST_to_C(arg3));
	RETURN (__MKINT(retVal));
    }
%}.
    self primitiveFailed
!

callWithArguments:argArray
    "call the underlying C function, passing up to 10 arguments.
     The arguments are converted to a corresponding C data type,
     as defined in the convertST_to_C() function.
     The return value is interpreted as an integer
     (and must be converted to an externalBytes object,
      if it is a pointer to something).

     DANGER alert: This is an unprotected low-level entry.
     Not for normal application usage.
    "
%{
    LINTFUNC func;
#   define NUMARGS 10
    INT args[NUMARGS];
    INT retVal;
    OBJ *ap;
    INT convertST_to_C();

    func = (LINTFUNC) __INST(code_);
    if (func && __isArray(argArray)) {
	int n = __arraySize(argArray);
	int i;

	if (n <= 10) {
	    ap = __ArrayInstPtr(argArray)->a_element;
	    for (i=0; i<NUMARGS; i++) {
		args[i] = convertST_to_C(*ap++);
	    }
	}
	switch (n) {
	    case 0:
		retVal = (*func)();
		break;
	    case 1:
		retVal = (*func)(args[0]);
		break;
	    case 2:
		retVal = (*func)(args[0], args[1]);
		break;
	    case 3:
		retVal = (*func)(args[0], args[1], args[2]);
		break;
	    case 4:
		retVal = (*func)(args[0], args[1], args[2], args[3]);
		break;
	    case 5:
		retVal = (*func)(args[0], args[1], args[2], args[3],
				 args[4]);
		break;
	    case 6:
		retVal = (*func)(args[0], args[1], args[2], args[3],
				 args[4], args[5]);
		break;
	    case 7:
		retVal = (*func)(args[0], args[1], args[2], args[3],
				 args[4], args[5], args[6]);
		break;
	    case 8:
		retVal = (*func)(args[0], args[1], args[2], args[3],
				 args[4], args[5], args[6], args[7]);
		break;
	    case 9:
		retVal = (*func)(args[0], args[1], args[2], args[3],
				 args[4], args[5], args[6], args[7],
				 args[8]);
		break;
	    case 10:
		retVal = (*func)(args[0], args[1], args[2], args[3],
				 args[4], args[5], args[6], args[7],
				 args[8], args[9]);
		break;
	    default:
		goto err;
	}
	RETURN (__MKINT(retVal));
    }
  err: ;
%}.
    self primitiveFailed
!

callWithDouble:aFloatArg returnsDouble:doubleFlag
    "call the underlying C function, passing a single double argument.
     The returnsDouble flag specifies if the returnValue is a double; if false,
     an integer returnValue is assumed."
%{
    typedef double  (*DOUBLEFUNC)();
    LINTFUNC func;
    DOUBLEFUNC dfunc;
    double arg, dretVal;
    INT retVal;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	if (__isFloat(aFloatArg)) {
	    arg = __floatVal(aFloatArg);
	} else if (__isShortFloat(aFloatArg)) {
	    arg = (double)(__shortFloatVal(aFloatArg));
	} else {
	    arg = (double)(__signedLongIntVal(aFloatArg));
	}
	if (doubleFlag == true) {
	    dfunc = (DOUBLEFUNC)func;
	    dretVal = (*dfunc)(arg);
	    RETURN (__MKFLOAT(dretVal));
	} else {
	    retVal = (*func)(arg);
	    RETURN (__MKINT(retVal));
	}
    }
%}.
    self primitiveFailed
!

callWithDouble:aFloatArg1 withDouble:aFloatArg2 returnsDouble:doubleFlag
    "call the underlying C function, passing two double arguments.
     The returnsDouble flag specifies if the returnValue is a double; if false,
     an integer returnValue is assumed."
%{
    typedef double  (*DOUBLEFUNC)();
    LINTFUNC func;
    DOUBLEFUNC dfunc;
    double arg1, arg2, dretVal;
    int retVal;

    func = (LINTFUNC) __INST(code_);
    if (func) {
	if (__isFloat(aFloatArg1)) {
	    arg1 = __floatVal(aFloatArg1);
	} else if (__isShortFloat(aFloatArg1)) {
	    arg1 = (double)(__shortFloatVal(aFloatArg1));
	} else {
	    arg1 = (double)(__signedLongIntVal(aFloatArg1));
	}
	if (__isFloat(aFloatArg2)) {
	    arg2 = __floatVal(aFloatArg2);
	} else if (__isShortFloat(aFloatArg2)) {
	    arg2 = (double)(__shortFloatVal(aFloatArg2));
	} else {
	    arg2 = (double)(__signedLongIntVal(aFloatArg2));
	}
	if (doubleFlag == true) {
	    dfunc = (DOUBLEFUNC)func;
	    dretVal = (*dfunc)(arg1, arg2);
	    RETURN (__MKFLOAT(dretVal));
	} else {
	    retVal = (*func)(arg1, arg2);
	    RETURN (__MKINT(retVal));
	}
    }
%}.
    self primitiveFailed
! !

!ExternalFunction methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    |addr|

    name isNil ifTrue:[^ super printOn:aStream].

    aStream nextPutAll:self class name; nextPutAll:'(name: ''';
	    nextPutAll:name; nextPutAll:''' address: '.

    addr := self code.
    addr isNil ifTrue:[
	aStream nextPutAll:'** unloaded **'
    ] ifFalse:[
	aStream nextPutAll:'0x';
		nextPutAll:(addr hexPrintString)
    ].

    moduleHandle notNil ifTrue:[
	aStream nextPutAll:' from: ''';
		nextPutAll:(moduleHandle pathName asFilename baseName);
		nextPutAll:''''.
    ].

    aStream nextPutAll:')'

    "Modified: 12.7.1996 / 23:31:49 / cg"
! !

!ExternalFunction methodsFor:'private-loader access'!

invalidate
    super invalidate.
    moduleHandle := nil.
!

setModuleHandle:aHandle
    "set the moduleHandle.
     This is a private interface for the objectFileLoader; not for public use."

    moduleHandle := aHandle
!

setName:aString moduleHandle:aHandle
    "set the name & moduleHandle.
     This is a private interface for the objectFileLoader; not for public use."

    name := aString.
    moduleHandle := aHandle
! !

!ExternalFunction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ExternalFunction initialize!

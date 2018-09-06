"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
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

ExecutableFunction variableSubclass:#CompiledCode
	instanceVariableNames:'flags byteCode'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!CompiledCode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
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
    This is an abstract class, to merge common attributes of Blocks and
    Methods i.e. describe all objects consisting of either compiled or
    interpreted code.

    Instances of CompiledCode are not to be created by user code
    (the compilers create Blocks, Methods etc.)


    [Instance variables:]

      flags       <SmallInteger>    special flag bits coded in a number
      byteCode    <ByteArray>       bytecode if its an interpreted codeobject

      The block/methods literals are stored in the indexed instance variables.
      If there is only one indexed instvar, it contains a reference to an
      Object containing the literals.


    [Class variables:]

      NoByteCodeSignal              raised if a codeObject is about to be executed
				    which has neither code nor byteCode (i.e. both are nil)
      InvalidByteCodeSignal         raised if byteCode is not an instance of ByteArray
      InvalidInstructionSignal      raised if an invalid instruction opcode is encountered
      BadLiteralsSignal             raised if literalArray is not an array
      NonBooleanReceiverSignal      raised for conditional jumps where receiver is not a boolean
      ArgumentSignal                raised if argument count is not what the codeObject expects

    all of these signals are children of ExecutionErrorSignal.

    NOTICE: layout known by runtime system and compiler - do not change

    [author:]
	Claus Gittinger
"
! !

!CompiledCode class methodsFor:'instance creation'!

new
    "create a new method with an indirect literal array
     stored in the first and only indexed instvar"

    ^ self basicNew:1.

    "Created: / 24.6.1996 / 17:21:46 / stefan"
    "Modified: / 23.1.1998 / 16:31:28 / stefan"
!

new:numberOfLiterals
    "create a new method with numberOfLiterals.
     Implementation note:
	If (self size) == 1, the only literal is an indirect literal
	containing an array of literals. Otherwise the literals
	are stored in self.
    "

    |nlits|

    nlits := numberOfLiterals.
    nlits <= 1 ifTrue:[
	nlits := nlits + 1.
    ].
    ^ self basicNew:nlits.

    "Created: 24.6.1996 / 17:20:13 / stefan"
    "Modified: 25.6.1996 / 14:25:14 / stefan"
! !

!CompiledCode class methodsFor:'Signal constants'!

wongNumberOfArgumentsSignal
    "return the signal raised when the number of arguments is wrong in a call"

    ^ WrongNumberOfArgumentsError
! !

!CompiledCode class methodsFor:'queries'!

isAbstract
    ^ self == CompiledCode
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == CompiledCode

    "Modified: 23.4.1996 / 15:57:03 / cg"
!

maxNumberOfArguments
    "return the maximum number of arguments a method can have.
     This is a limit in the VM, which may be removed in one of
     the next versions ..."

%{  /* NOCONTEXT */
    RETURN (__mkSmallInteger(MAX_METHOD_ARGS));
%}.
    "/ fallback if no VM limit

    "/ actually: this limit is due to the single-byte encoding
    "/ in the send bytecode.
    ^ 255
!

numArgsMaskInFlags

%{  /* NOCONTEXT */
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger(F_NARGS));
%}.
    ^ nil "/ fallback if no primitive code

    "
     self numArgsMaskInFlags
    "
!

numArgsShiftInFlags

%{  /* NOCONTEXT */
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger(F_NARGSHIFT));
%}.
    ^ nil "/ fallback if no primitive code

    "
     self numArgsShiftInFlags
    "
!

numVarsMaskInFlags

%{  /* NOCONTEXT */
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger(F_NVARS));
%}.
    ^ nil "/ fallback if no primitive code

    "
     self numVarsMaskInFlags
    "
!

numVarsShiftInFlags

%{  /* NOCONTEXT */
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger(F_NVARSHIFT));
%}.
    ^ nil "/ fallback if no primitive code

    "
     self numVarsShiftInFlags
    "
! !

!CompiledCode methodsFor:'Compatibility-ANSI'!

argumentCount
    "ANSI alias for numArgs: return the number of arguments, the method expects."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.getNumberOfArguments() );
#else
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger((__intVal(__INST(flags)) & F_NARGS) >> F_NARGSHIFT));
#endif
%}.
    "
     The old implementation simply counted the arguments from
     the methods source - new versions include this information
     in the flag instVar, for more security in #perform:
    "

    "
     (Method compiledMethodAt:#source) numArgs
     (Method compiledMethodAt:#source:) numArgs
    "
! !

!CompiledCode methodsFor:'Compatibility-ST80'!

getSource
    "return the code objects source code, nil if none is available"

    ^ self source.

    "Created: 19.6.1997 / 16:32:15 / cg"
!

getSourceForUserIfNone:aBlock
    "return the code objects source code.
     If none is available, return the result from evaluating aBlock."

    |src|

    Screen current shiftDown ifTrue:[^ aBlock value].
    src := self source.
    src isNil ifTrue:[^ aBlock value].
    ^ src withoutTrailingSeparators

    "Modified: 19.6.1997 / 16:31:53 / cg"
!

initialPC
    ^ 1
!

methodClass
    "return the class I am defined in"

    ^ self mclass.

    "Created: 19.6.1997 / 16:32:15 / cg"
!

sourceString
    "return the code objects source code, nil if none is available"

    ^ self source.

    "Created: 19.6.1997 / 16:32:15 / cg"
!

withAllBlockMethodsDo:aBlock
    aBlock value:self

    "Created: 18.4.1997 / 20:42:07 / cg"
! !

!CompiledCode methodsFor:'Compatibility-V''Age'!

bytecodes
    ^ self byteCode

    "Created: / 05-03-2012 / 15:51:48 / cg"
! !

!CompiledCode methodsFor:'accessing'!

allLiterals
    "return a collection of all literals (includes all block literals)"

    ^ self literals ? #()

    "Modified: 19.6.1997 / 17:37:52 / cg"
!

allSymbolLiterals
    "return a collection of all symbol-literals"

    ^ self allLiterals select:[:lit | lit isSymbol]

    "Modified: / 19.6.1997 / 17:37:52 / cg"
    "Created: / 1.11.1997 / 13:14:44 / cg"
!

byteCode
    "return the bytecode (a ByteArray)"

    ^ byteCode
!

changeLiteral:aLiteral to:newLiteral
    "change aLiteral to newLiteral"

    |lits nLits "{ Class: SmallInteger }" |

    self size == 1 ifTrue:[
	lits := self at:1.
    ] ifFalse:[
	lits := self.
    ].

    nLits := lits size.
    1 to:nLits do:[:i|
	(lits at:i) == aLiteral ifTrue:[
	    lits at:i put:newLiteral.
	    ^ true.
	].
    ].
    ^ false.

    "Created: 24.6.1996 / 15:08:11 / stefan"
    "Modified: 24.6.1996 / 17:07:56 / stefan"
    "Modified: 4.7.1996 / 11:12:39 / cg"
!

decompiledSource
    "reconstruct some synthetic source by decompiling by byteCode"

    |s|

    s := String writeStream.
    self decompileTo:s.
    ^ s contents

    "Modified: / 30.1.1999 / 14:53:30 / cg"
    "Created: / 30.1.1999 / 14:54:09 / cg"
!

decompilerClass
    ^ Decompiler

    "Created: 30.7.1997 / 16:36:40 / cg"
!

do:aBlock
    "same as #literalsDo:, in order to get common protocol with Array"

    ^ self literalsDo:aBlock

    "Modified: 25.6.1996 / 22:16:44 / stefan"
!

flags
    "return the flags (number of method variables, stacksize etc.).
     Don't depend on the values in the flag field - its interpretations
     may change without notice."

    ^ flags

    "Modified: / 30.1.1999 / 14:51:59 / cg"
!

homeMethod
    "for common protocol with blocks: if the receiver is a method,
     return the receiver; otherwise, if its a block, return its home
     method."

    ^ self
!

literalAt:index
    "return a literal element"

    ^ self literalAt:index ifAbsent:[self error:'bad literal index']
!

literalAt:index ifAbsent:exceptionalValue
    "return a literal element"

    |lits numLits "{ Class: SmallInteger }"|

    numLits := self size.
    numLits == 0 ifTrue:[
	^ exceptionalValue value
    ].
    numLits == 1 ifTrue:[
	lits := self at:1.
	lits isArray ifFalse:[
	    index == 1 ifTrue:[^ lits].
	    ^ exceptionalValue value
	].
	^ lits at:index.
    ].

    "there may be a dummy (nil) literal to make the size > 1"
    (self at:2) isNil ifTrue:[
	index == 1 ifTrue:[^ self at:1].
	^ exceptionalValue value
    ].

    ^ self at:index
!

literalAt:index put:newValue
    "change a literal slots value.
     WARNING: dangerous internal interface; only for knowledgable users"

    |lits numLits "{ Class: SmallInteger }"|

    numLits := self size.
    numLits == 0 ifTrue:[
	self error:'bad literal index'
    ].
    numLits == 1 ifTrue:[
	lits := self at:1.
	lits isArray ifFalse:[
	    index == 1 ifTrue:[^ self at:1 put:newValue.].
	    self error:'bad literal index'
	].
	^ lits at:index put:newValue.
    ].

    "there may be a dummy (nil) literal to make the size > 1"
    (self at:2) isNil ifTrue:[
	index == 1 ifTrue:[^ self at:1 put:newValue].
	self error:'bad literal index'.
    ].

    ^ self at:index put:newValue

    "Created: / 16-07-2006 / 13:01:15 / cg"
!

literals
    "return the literals as an array"

    |lits numLits "{ Class: SmallInteger }"|

    numLits := self size.
    numLits == 0 ifTrue:[
	^ #()
    ].
    numLits == 1 ifTrue:[
	lits := self at:1.
	lits isArray ifFalse:[
	    ^ Array with:lits.
	].
	^ lits.
    ].

    "there may be a dummy (nil) literal to make the size > 1"
    (self at:2) isNil ifTrue:[
	numLits := 1.
    ].

    lits := Array new:numLits.
    1 to:numLits do:[:i|
	lits at:i put:(self at:i).
    ].
    ^ lits.

    "
     (CompiledCode compiledMethodAt:#literals) literals
    "

    "Modified: / 30.1.1997 / 17:09:06 / cg"
    "Modified: / 23.1.1998 / 16:30:07 / stefan"
!

literalsDetect:aBlock ifNone:exceptionBlock
    "execute a one arg block for each of our literals.
     Return the first literal for which aBlock returns true,
     or the value from exceptionBlock, if either no literals or
     none satisfied the block"

    self literalsDo:[:eachLiteral |
	(aBlock value:eachLiteral) ifTrue:[
	    ^ eachLiteral
	]
    ].
    ^ exceptionBlock value.

    "Created: / 24.6.1996 / 14:27:35 / stefan"
    "Modified: / 30.1.1997 / 16:24:04 / cg"
    "Modified: / 23.1.1998 / 17:08:37 / stefan"
!

literalsDo:aBlock
    "execute a one arg block for each of our literals"

    |lits numLits "{ Class: SmallInteger }" |

    numLits := self size.
    numLits == 0 ifTrue:[
	^ self
    ].
    numLits == 1 ifTrue:[
	lits := self at:1.
	numLits := lits size.

	lits isArray ifFalse:[
	    lits := self.
	    numLits := 1.
	]
    ] ifFalse:[
	lits := self.
	"there may be a dummy (nil) literal to make the size > 1"
	(self at:2) isNil ifTrue:[
	    numLits := 1.
	].
    ].

    1 to:numLits do:[:i |
	aBlock value:(lits at:i).
    ].

    "Created: / 24.6.1996 / 14:17:12 / stefan"
    "Modified: / 30.1.1997 / 17:08:05 / cg"
    "Modified: / 23.1.1998 / 16:39:17 / stefan"
!

mclass
    "return the class of the receiver's home method.
     That's the class of the method where the block was compiled."

    ^ self homeMethod mclass

    "Modified: 19.6.1997 / 16:24:58 / cg"
    "Created: 19.6.1997 / 16:27:34 / cg"
!

numLiterals
    "return the number of literals I have"

    |lits numLits "{ Class: SmallInteger }" |

    numLits := self size.
    numLits == 1 ifTrue:[
	lits := self at:1.
	numLits := lits size.

	lits isArray ifFalse:[
	    lits := self.
	    numLits := 1.
	]
    ] ifFalse:[
	lits := self.
	"there may be a dummy (nil) literal to make the size > 1"
	(self at:2) isNil ifTrue:[
	    numLits := 1.
	].
    ].
    ^ numLits

    "Created: / 07-06-2007 / 10:08:01 / cg"
!

numberOfMethodArgs
    <resource: #obsolete>
    "return the number of arguments, the method expects.
     This method is left for backward compatibility - use #argumentCount."

    "/ self obsoleteMethodWarning:'use argumentCount'.
    ^ self argumentCount

    "Modified: / 30.1.1999 / 14:55:27 / cg"
    "Created: / 30.1.1999 / 14:55:47 / cg"
!

numberOfMethodVars
    "return the number of method local variables.
     This method is left for backward compatibility - use #numVars."

    "/ self obsoleteMethodWarning:'use numVars'.
    ^ self numVars

    "Modified: / 30.1.1999 / 14:55:42 / cg"
    "Created: / 30.1.1999 / 14:55:51 / cg"
!

source
    ^ self subclassResponsibility.
! !

!CompiledCode methodsFor:'compiler interface'!

compilerClass
    "who is responsible to parse the source code?
     Fetch it from the class"

    ^ self programmingLanguage compilerClass

    "
     (Object compiledMethodAt:#at:) compilerClass
    "
!

parserClass
    "who is responsible to parse the source code?
     Fetch it from the class"

    ^ self programmingLanguage parserClass

    "
     (Object compiledMethodAt:#at:) parserClass
    "
!

programmingLanguage
    "/ the following is correct, but might be too slow...
    "/ we have language-specific Method subclasses anyway,
    "/ so simply redefine there.
    "/    |mclass|
    "/
    "/    mclass := self mclass.
    "/    mclass isNil ifTrue:[^ SmalltalkLanguage].
    "/    ^ mclass programmingLanguage
    ^  SmalltalkLanguage instance

    "
     (Object compiledMethodAt:#at:) parserClass
    "

    "Modified (comment): / 01-06-2012 / 21:10:56 / cg"
!

syntaxHighlighterClass
    "if #askClass is returned here, my owning class will be asked for the syntaxHighlighter.
     if nil is returned, no syntaxHighlighting will be done.
     Can be redefined in subclasses (MetaMethod) which use special syntax."

    ^ self programmingLanguage syntaxHighlighterClass
! !

!CompiledCode methodsFor:'converting'!

makeRealMethod
    "by default, we are a real method.
     Subclasses (e.g. LazyMethod) may redefine this"

    ^ self

    "Created: 7.6.1996 / 12:45:50 / stefan"
! !

!CompiledCode methodsFor:'debugging'!

breakPointAfter:countInvocations
    "arrange for a breakpoint-debugger to be opened when this method
     was invoked countInvocations times."

    MessageTracer trapMethod:self after:countInvocations.

!

breakPointIf:conditionBlock
    "arrange for a breakpoint-debugger to be opened when this method
     is invoked AND conditionBlock evaluates to true."

    MessageTracer trapMethod:self if:conditionBlock

    "Created: / 18.8.2000 / 22:09:59 / cg"
!

breakPointInProcess:aProcess
    "arrange for a breakpoint-debugger to be opened when this method
     is invoked from withn aProcess."

    MessageTracer trapMethod:self inProcess:aProcess.

    "Modified: / 12.1.1998 / 18:22:39 / cg"
    "Created: / 30.1.1999 / 14:50:01 / cg"
!

clearBreakPoint
    "remove any break/trace-point on this method"

    MessageTracer unwrapMethod:self.

    "Modified: / 12.1.1998 / 18:22:14 / cg"
    "Created: / 30.1.1999 / 14:49:53 / cg"
!

isCounted
    "obsolete - replaced by isCountingMemoryUsage"

    ^ MessageTracer notNil
      and:[MessageTracer isCountingMemoryUsage:self]

    "Modified: / 27.7.1998 / 11:05:36 / cg"
    "Created: / 30.1.1999 / 14:48:57 / cg"
!

isCounting
    "return true, if invokations of this method are counted"

    ^ MessageTracer notNil and:[MessageTracer isCounting:self]

    "Modified: / 27.7.1998 / 11:06:00 / cg"
    "Created: / 30.1.1999 / 14:49:19 / cg"
!

isCountingByReceiverClass
    "return true, if invokations of this method are counted"

    ^ MessageTracer notNil and:[MessageTracer isCountingByReceiverClass:self]
!

isCountingMemoryUsage
    "return true, if memory allocations done by this method (and callees)
     are counted"

    ^ MessageTracer notNil
      and:[MessageTracer isCountingMemoryUsage:self]

    "Modified: / 27.7.1998 / 11:06:23 / cg"
    "Created: / 30.1.1999 / 14:49:26 / cg"
!

isTiming
    "return true, if timiing statistics are being gathered on this method."

    ^ MessageTracer notNil
      and:[MessageTracer isTiming:self]
!

resetCountingStatistics
    "reset count statistics of the receiver"

    MessageTracer resetCountOfMethod:self

    "Modified: / 12.1.1998 / 18:24:30 / cg"
    "Created: / 30.1.1999 / 14:50:19 / cg"
!

resetMemoryUsageStatistics
    "reset count statistics of the receiver"

    MessageTracer resetMemoryUsageOfMethod:self

    "Modified: / 12.1.1998 / 18:24:30 / cg"
    "Created: / 30.1.1999 / 14:50:22 / cg"
!

resetTimingStatistics
    "reset timing statistics of the receiver"

    MessageTracer resetExecutionTimesOfMethod:self

    "Modified: / 12.1.1998 / 18:24:30 / cg"
    "Created: / 30.1.1999 / 14:50:25 / cg"
!

setBreakPoint
    "arrange for a breakpoint-debugger to be opened when this method
     is invoked."

    MessageTracer trapMethod:self.

    "Modified: / 12.1.1998 / 18:22:36 / cg"
    "Created: / 30.1.1999 / 14:50:27 / cg"
!

setTraceFullPoint
    "arrange for a full-backtrace to be sent to the standard-error stream
     when this method is invoked."

    MessageTracer traceMethodFull:self on:Transcript

    "Modified: / 12.1.1998 / 18:23:11 / cg"
    "Created: / 30.1.1999 / 14:50:30 / cg"
!

setTracePoint
    "arrange for a trace-message to be sent to the standard-error stream
     when this method is invoked."

    MessageTracer traceMethod:self on:Transcript

    "Modified: / 12.1.1998 / 18:23:23 / cg"
    "Created: / 30.1.1999 / 14:50:33 / cg"
!

setTraceSenderPoint
    "arrange for a sender-trace-message to be sent to the standard-error stream
     when this method is invoked."

    MessageTracer traceMethodSender:self on:Transcript

    "Modified: / 12.1.1998 / 18:23:31 / cg"
    "Created: / 30.1.1999 / 14:50:36 / cg"
!

startCounting
    "start counting invokations of the receiver"

    MessageTracer countMethod:self

    "Modified: / 12.1.1998 / 18:23:45 / cg"
    "Created: / 30.1.1999 / 14:50:38 / cg"
!

startCountingByReceiverClass
    "start counting invokations of the receiver"

    MessageTracer countMethodByReceiverClass:self

    "Modified: / 12.1.1998 / 18:23:45 / cg"
    "Created: / 30.1.1999 / 14:50:38 / cg"
!

startCountingMemoryUsage
    "start counting memory usage of the receiver (and every callee)"

    MessageTracer countMemoryUsageOfMethod:self

    "Modified: / 27.7.1998 / 11:06:55 / cg"
    "Created: / 30.1.1999 / 14:50:41 / cg"
!

startTiming
    "start timing the receiver"

    MessageTracer timeMethod:self

    "Modified: / 12.1.1998 / 18:24:05 / cg"
    "Created: / 30.1.1999 / 14:50:44 / cg"
!

stopCounting
    "stop counting calls of the receiver"

    MessageTracer stopCountingMethod:self

    "Modified: / 12.1.1998 / 18:24:15 / cg"
    "Created: / 30.1.1999 / 14:50:47 / cg"
!

stopCountingMemoryUsage
    "stop counting memory usage of the receiver"

    MessageTracer stopCountingMemoryUsageOfMethod:self

    "Modified: / 12.1.1998 / 18:24:22 / cg"
    "Created: / 30.1.1999 / 14:50:51 / cg"
!

stopTiming
    "stop timing of the receiver"

    MessageTracer stopTimingMethod:self

    "Modified: / 12.1.1998 / 18:24:30 / cg"
    "Created: / 30.1.1999 / 14:50:54 / cg"
! !

!CompiledCode methodsFor:'enumeration'!

breakpointsDo:aBlock
    "Evaluate `aBlock` for every breakpoint installed in this method"

    "Created: / 23-02-2015 / 14:46:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompiledCode methodsFor:'error handling'!

badArgumentArray:argsGiven
    "{ Pragma: +optSpace }"

    "this error is triggered, if a non-array is passed to
     #valueWithReceiver:.. type of methods"

    ^ ArgumentError
	raiseRequestWith:self
	errorString:' - argumentArray is not an Array'

    "Modified: 4.11.1996 / 22:46:52 / cg"
!

badLiteralTable
    "{ Pragma: +optSpace }"

    "this error is triggered, when a block/method is called with a bad literal
     array (i.e. non-array) - this can only happen, if the
     compiler is broken or someone played around with a blocks/methods
     literal table or the GC is broken and corrupted it."

    ^ BadLiteralsError raise.

    "Modified: 4.11.1996 / 22:46:55 / cg"
!

interpretWithReceiver:aReceiver
    "invoked by VM for non-Smalltalk-methods (MetaMethods)"

    self subclassResponsibility
!

interpretWithReceiver:aReceiver arg:arg1
    "invoked by VM for non-Smalltalk-methods (MetaMethods)"

    self subclassResponsibility
!

interpretWithReceiver:aReceiver arg:arg1 arg:arg2
    "invoked by VM for non-Smalltalk-methods (MetaMethods)"

    self subclassResponsibility
!

interpretWithReceiver:aReceiver arg:arg1 arg:arg2 arg:arg3
    "invoked by VM for non-Smalltalk-methods (MetaMethods)"

    self subclassResponsibility
!

interpretWithReceiver:aReceiver arguments:argVector
    "invoked by VM for non-Smalltalk-methods (MetaMethods)"

    self subclassResponsibility
!

invalidByteCode
    "{ Pragma: +optSpace }"

    "this error is triggered when the interpreter tries to execute a
     code object, where the byteCode is nonNil, but not a ByteArray.
     Can only happen when Compiler/runtime system is broken or
     someone played around with a blocks/methods code."

    ^ InvalidByteCodeError raise.

    "Modified: 4.11.1996 / 22:46:59 / cg"
!

invalidInstruction
    "{ Pragma: +optSpace }"

    "this error is triggered when the bytecode-interpreter tries to
     execute an invalid bytecode instruction.
     Can only happen when Compiler/runtime system is broken or
     someone played around with a blocks/methods code."

    ^ InvalidInstructionError raise.

    "Modified: 4.11.1996 / 22:47:03 / cg"
!

noByteCode
    "{ Pragma: +optSpace }"

    "this error is triggered when the interpreter tries to execute a
     code object, where both the code and byteCode instances are nil.
     This can happen if:
	- the Compiler/runtime system is broken, (should not happen)

	- someone played around with a block/method, (you should not do this)

	- compilation of a lazy method failed
	  (i.e. the lazy method contains an error or
	   it contains primitive code and there is no stc compiler available)

	- an unloaded object modules method is called for.

     Only the first case is to be considered serious
     - it should not happen if the system is used correctly."

    ^ NoByteCodeError raiseRequest.

    "Modified: 4.11.1996 / 22:47:07 / cg"
!

receiverNotBoolean:anObject
    "{ Pragma: +optSpace }"

    "this error is triggered when the bytecode-interpreter tries to
     execute ifTrue:/ifFalse or whileTrue: - type of expressions where the
     receiver is neither true nor false.
     Machine compiled code does not detect this, and may behave undeterministec."

    ^ NonBooleanReceiverError raise.

    "Modified: 4.11.1996 / 22:47:11 / cg"
!

tooManyArguments
    "{ Pragma: +optSpace }"

    "this error is triggered, when a method/block tries to perform a send with
     more arguments than supported by the interpreter.
     This can only happen, if the compiler has been changed without
     updating the VM, since the compiler checks for allowed number of
     arguments."

    ^ WrongNumberOfArgumentsError
	raiseRequestWith:self
	errorString:' - too many args in send'

    "Modified: 4.11.1996 / 22:47:14 / cg"
!

wrongNumberOfArguments:numArgsGiven
    "{ Pragma: +optSpace }"

    "this error is triggered by the VM, if a method is called with a wrong number
     of arguments.
     This only applies to #valueWithReceiverXXX and #perform:withArguments: - sends.
     With a normal send, this error cannot happen."

    ^ WrongNumberOfArgumentsError
	raiseRequestWith:self
	errorString:(' - %1 got %2 arg(s) where %3 expected'
			bindWith:self printString "/ self class name
			with:numArgsGiven
			with:self argumentCount)

    "
     2 perform:#+
    "

    "Modified: 1.8.1997 / 00:23:10 / cg"
! !

!CompiledCode methodsFor:'executing'!

valueWithReceiver:anObject arguments:argArray
    "low level call of a methods code - BIG DANGER ALERT.
     Perform the receiver-method on anObject as receiver and argArray as
     arguments. This does NO message lookup at all and mimics a
     traditional function call.
     This method is provided for debugging- and breakpoint-support
     (replacing a method by a stub and recalling the original), or to implement
     experimental MI implementations - it is not for general use.

     The receiver must be a method compiled in anObjects class or one of its
     superclasses and also, the number of arguments given must match the methods
     expectations -
     - otherwise strange things (and also strange crashes) can occur.
     The system is NOT always detecting a wrong method/receiver combination.
     YOU HAVE BEEN WARNED."

    ^ self
	valueWithReceiver:anObject
	arguments:argArray
	selector:nil
	search:nil
	sender:nil

    "Modified: 4.4.1997 / 23:33:56 / cg"
    "Created: 30.7.1997 / 12:04:52 / cg"
!

valueWithReceiver:anObject arguments:argArray selector:aSymbol
    "low level call of a methods code - BIG DANGER ALERT.
     Perform the receiver-method on anObject as receiver and argArray as
     arguments. This does NO message lookup at all and mimics a
     traditional function call.
     This method is provided for debugging- and breakpoint-support
     (replacing a method by a stub and recalling the original), or to implement
     experimental MI implementations - it is not for general use.

     The receiver must be a method compiled in anObjects class or one of its
     superclasses and also, the number of arguments given must match the methods
     expectations -
     - otherwise strange things (and also strange crashes) can occur.
     The system is NOT always detecting a wrong method/receiver combination.
     YOU HAVE BEEN WARNED."

    ^ self
	valueWithReceiver:anObject
	arguments:argArray
	selector:aSymbol
	search:nil
	sender:nil

    "Modified: 4.4.1997 / 23:34:08 / cg"
    "Created: 30.7.1997 / 12:04:49 / cg"
!

valueWithReceiver:anObject arguments:argArray selector:aSymbol search:aClass
    "low level call of a methods code - BIG DANGER ALERT.
     Perform the receiver-method on anObject as receiver and argArray as
     arguments. This does NO message lookup at all and mimics a
     traditional function call.
     This method is provided for debugging- and breakpoint-support
     (replacing a method by a stub and recalling the original), or to implement
     experimental MI implementations - it is not for general use.

     The receiver must be a method compiled in anObjects class or one of its
     superclasses and also, the number of arguments given must match the methods
     expectations -
     - otherwise strange things (and also strange crashes) can occur.
     The system is NOT always detecting a wrong method/receiver combination.
     YOU HAVE BEEN WARNED."

    ^ self
	valueWithReceiver:anObject
	arguments:argArray
	selector:aSymbol
	search:nil
	sender:nil

    "Modified: 4.4.1997 / 23:34:19 / cg"
    "Created: 30.7.1997 / 12:04:46 / cg"
!

valueWithReceiver:anObject arguments:argArray selector:aSymbol search:aClass sender:virtualSender
    "low level call of a methods code - BIG DANGER ALERT.
     Perform the receiver-method on anObject as receiver and argArray as arguments.
     This does NO message lookup at all and mimics a traditional function call.
     This method is provided for debugging- and breakpoint-support
     (replacing a method by a stub and recalling the original), or to implement
     experimental MI implementations - it is not for general use.

     The receiver must be a method compiled in anObject's class or one of its
     superclasses and also, the number of arguments given must match the methods
     expectations -
     - otherwise strange things (and also strange crashes) can occur.
     The system is NOT always detecting a wrong method/receiver combination.
     YOU HAVE BEEN WARNED."

%{
#ifdef __SCHTEAM__
    {
	int numArgs = 0;
	STVector v = null;

	if (argArray != STObject.Nil) {
	    v = argArray.asSTVector();
	    numArgs = v.vectorLength();
	}

	STCallable me = (STCompiledMethod)self.smalltalkCheckNumberOfArgs(1+numArgs);

	__c__.push(anObject);
	for (int i=0; i<numArgs; i++) {
	    __c__.push( v.vectorRef(i) );
	}
	// the selector and searchClass args are not needed/passed
	// the virtualSender is (currently) not supported
	// (this is cosmetics only; therefore it's done later)
	return __c__.TAILCALL_nPUSHED( me, 1+numArgs);
    }
    /* NOT REACHED */
#else
    OBJFUNC code;
    OBJ searchClass;
    static struct inlineCache dummy = __DUMMYILC0(0);
    int nargs;
    OBJ *ap;

    /*
     * args must be an array, or nil
     */
    if (__isArrayLike(argArray)) {
	nargs = __arraySize(argArray);
	ap = __ArrayInstPtr(argArray)->a_element;
    } else {
	if (argArray != nil) {
	    goto badArgs;
	}
	nargs = 0;
	ap = (OBJ *)0;
    }

# ifdef F_NARGS
    if (((__intVal(__INST(flags)) & F_NARGS) >> F_NARGSHIFT) == nargs)
# endif
    {
	code = __MethodInstPtr(self)->m_code;
	if (aClass == nil) {
	    searchClass = dummy.ilc_class = __Class(anObject);
	} else {
	    searchClass = dummy.ilc_class = aClass;
	}

	if (nargs <= 15) {
	  OBJ rslt;
# ifdef CONTEXT_DEBUG
	  OBJ sav = __thisContext;
# endif

	  /*
	   * add virtual sender (unwinding) here later,
	   * to allow hiding contexts in lazy methods.
	   * (this is cosmetics only; therefore its done later)
	   */
	  if (code) {
	    /* compiled code */
	    switch (nargs) {
		case 0:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy);
		    break;

		case 1:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy, ap[0]);
		    break;

		case 2:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy, ap[0], ap[1]);
		    break;

		case 3:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy, ap[0], ap[1], ap[2]);
		    break;

		case 4:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3]);
		    break;

		case 5:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4]);
		    break;

		case 6:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5]);
		    break;

		case 7:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6]);
		    break;

		case 8:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7]);
		    break;

		case 9:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8]);
		    break;

		case 10:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8],
				 ap[9]);
		    break;

		case 11:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8],
				 ap[9], ap[10]);
		    break;

		case 12:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8],
				 ap[9], ap[10], ap[11]);
		    break;

		case 13:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8],
				 ap[9], ap[10], ap[11], ap[12]);
		    break;

		case 14:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8],
				 ap[9], ap[10], ap[11], ap[12], ap[13]);
		    break;

		case 15:
		    rslt = (*code)(anObject, aSymbol, searchClass, &dummy,
				 ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6], ap[7], ap[8],
				 ap[9], ap[10], ap[11], ap[12], ap[13], ap[14]);
		    break;
	    }
	  } else {
	    /* interpreted code */
# ifdef PASS_ARG_POINTER
	    rslt = __interpret(self, nargs, anObject, aSymbol, searchClass, &dummy, ap);
# else
	    switch (nargs) {
		case 0:
		    rslt = __interpret(self, 0, anObject, aSymbol, searchClass, &dummy);
		    break;

		case 1:
		    rslt = __interpret(self, 1, anObject, aSymbol, searchClass, &dummy,
				   ap[0]);
		    break;

		case 2:
		    rslt = __interpret(self, 2, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1]);
		    break;

		case 3:
		    rslt = __interpret(self, 3, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2]);
		    break;

		case 4:
		    rslt = __interpret(self, 4, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3]);
		    break;

		case 5:
		    rslt = __interpret(self, 5, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4]);
		    break;

		case 6:
		    rslt = __interpret(self, 6, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5]);
		    break;

		case 7:
		    rslt = __interpret(self, 7, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6]);
		    break;

		case 8:
		    rslt = __interpret(self, 8, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7]);
		    break;

		case 9:
		    rslt = __interpret(self, 9, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8]);
		    break;

		case 10:
		    rslt = __interpret(self, 10, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8], ap[9]);
		    break;

		case 11:
		    rslt = __interpret(self, 11, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8], ap[9], ap[10]);
		    break;

		case 12:
		    rslt = __interpret(self, 12, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8], ap[9], ap[10], ap[11]);
		    break;

		case 13:
		    rslt = __interpret(self, 13, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8], ap[9], ap[10], ap[11], ap[12]);
		    break;

		case 14:
		    rslt = __interpret(self, 14, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8], ap[9], ap[10], ap[11], ap[12], ap[13]);
		    break;

		case 15:
		    rslt = __interpret(self, 15, anObject, aSymbol, searchClass, &dummy,
				   ap[0], ap[1], ap[2], ap[3], ap[4], ap[5], ap[6],
				   ap[7], ap[8], ap[9], ap[10], ap[11], ap[12], ap[13], ap[14]);
		    break;
	    }
# endif
	  }
# ifdef CONTEXT_DEBUG
	  if (sav != __thisContext) {
	      if (code) {
		  printf("CONTEXT BOTCH after execution of %x\n", code);
	      } else {
		  printf("CONTEXT BOTCH after execution of interpreted method\n");
		  printf("code now: %x\n", __MethodInstPtr(self)->m_code);
	      }
	      printf("context before:\n");
	      __dumpObject__(sav, __LINE__);
	      printf("context now:\n");
	      __dumpObject__(__thisContext, __LINE__);
	  }
# endif
	  RETURN (rslt);
	}
    }
    badArgs: ;
#endif /* not SCHTEAM */
%}.
    (argArray isArray) ifFalse:[
	(self argumentCount ~~ 0
	 or:[argArray notNil]) ifTrue:[
	    "
	     arguments must be either nil or an array
	    "
	    ^ self badArgumentArray:argArray
	]
    ].

    (argArray size ~~ self numArgs) ifTrue:[
	"
	 the method expects a different number of arguments
	"
	^ self wrongNumberOfArguments:argArray size
    ].

    "/ if the VM only supports a limited number of arguments in sends (ST/X: 15)
    argArray size > self class maxNumberOfArguments ifTrue:[
	^ self tooManyArguments
    ].
    ^ self primitiveFailed

    "
     (Float compiledMethodAt:#+)
	valueWithReceiver:1.0 arguments:#(2.0)

     'the next example is a wrong one - which is detected by True's method ...'.
     (True compiledMethodAt:#printString)
	valueWithReceiver:false arguments:nil

     'the next example is a wrong one - it is nowhere detected
      and a wrong value returned ...'.
     (Point compiledMethodAt:#x)
	valueWithReceiver:(1->2) arguments:nil

     'the next example is VERY bad one - it is nowhere detected
      and may crash the system WARNING: save your work before doing this ...'.
     (Point compiledMethodAt:#x)
	valueWithReceiver:(Object new) arguments:nil

     'the next example is a wrong one - which is detected here ...'.
     (Object compiledMethodAt:#printOn:)
	valueWithReceiver:false arguments:nil

     'the next example is a wrong one - which is detected here ...'.
     (Object compiledMethodAt:#printOn:)
	valueWithReceiver:false arguments:#()
    "

    "Modified: / 07-10-2011 / 13:58:21 / cg"
! !

!CompiledCode methodsFor:'private-accessing'!

byteCode:aByteArray
    "set the bytecode field - DANGER ALERT"

    byteCode := aByteArray
!

checked:aBoolean
    "set/clear the flag bit stating that this method has already been checked
     by the just-in-time compiler.
     Setting the flag prevents it from trying any compilation.
     Not for public use - for VM debugging only."

%{  /* NOCONTEXT */

    INT newFlags = __intVal(__INST(flags));

    /* made this a primitive to get define in stc.h */
    if (aBoolean == true)
	newFlags |= F_CHECKED;
    else
	newFlags &= ~F_CHECKED;

    __INST(flags) = __mkSmallInteger(newFlags);
%}
!

clearJittedCodeAndForceJittingAgain
    "clear the method's jitted code and clear the flag bit stating that this method has already been checked
     by the just-in-time compiler. Thus, it will be recompiled when called the next time.
     Not for public use - for VM debugging only."

%{  /* NOCONTEXT */
    __INST(flags) = (OBJ)((INT)__INST(flags) & ~__MASKSMALLINT(F_CHECKED));
    // prevent clearing code of non-jitted code (static library)
    if ( (INT)(__INST(flags)) & __MASKSMALLINT(F_DYNAMIC)) {
	__INST(code_) = nil;
    }
%}
!

dynamic
    "return the flag stating that the machine code was created
     dynamically (from bytecode) or loaded dynamically from an objectFile
     (i.e. has machineCode, but is not in the executable)."

    "/ obsolete
    ^ self isDynamic

    "Modified: / 20.7.1998 / 14:22:35 / cg"
!

literals:aLiteralArray
    "set the literal array for evaluation - DANGER ALERT"

    |i|

    aLiteralArray isNil ifTrue:[
	^ self.
    ].

    self size == 1 ifTrue:[
	self at:1 put:(aLiteralArray asArray).
    ] ifFalse:[
	i := 1.
	aLiteralArray do:[:literal|
	    self at:i put:literal.
	    i := i + 1.
	].
    ].

    "Modified: / 25.6.1996 / 22:13:08 / stefan"
    "Modified: / 5.3.1998 / 02:05:56 / cg"
!

markFlag
    "return the mark bits value as a boolean.
     This bit is not used by the VM, but instead free to mark codeObjects
     for any (debugging/tracing) use. For example, the coverage test uses
     these to mark reached methods. (inspired by a note in c.l.s)"

%{  /* NOCONTEXT */

    /* made this a primitive to get define in stc.h */

    RETURN (( (INT)(__INST(flags)) & __MASKSMALLINT(F_MARKBIT)) ? true : false);
%}
!

markFlag:aBoolean
    "set/clear the mark flag bit.
     This bit is not used by the VM, but instead free to mark codeObjects
     for any (debugging/tracing) use. For example, the coverage test uses
     these to mark reached methods. (inspired by a note in c.l.s)"

%{  /* NOCONTEXT */

    INT newFlags = __intVal(__INST(flags));

    /* made this a primitive to get define in stc.h */
    if (aBoolean == true)
	newFlags |= F_MARKBIT;
    else
	newFlags &= ~F_MARKBIT;

    __INST(flags) = __mkSmallInteger(newFlags);
%}
! !

!CompiledCode methodsFor:'private-compiler interface'!

contextMustBeReturnable:aBoolean
%{  /* NOCONTEXT */
    /* made this a primitive to get define in stc.h */
    if (aBoolean == true) {
	__INST(flags) = (OBJ)( (INT)__INST(flags) | __MASKSMALLINT(F_RETURNABLE));
    } else {
	__INST(flags) = (OBJ)( (INT)__INST(flags) & ~__MASKSMALLINT(F_RETURNABLE));
    }
%}

!

flags:newFlags
    "set the flags (number of method variables, stacksize).
     WARNING: for internal use by the compiler only.
              playing around here with incorrect values
              may crash smalltalk badly.

     Don't depend on the values in the flag field - its interpretations
     may change without notice."

    "/ protect myself a bit - putting in an object would crash me ...

    (newFlags isMemberOf:SmallInteger) ifTrue:[
        flags := newFlags
    ]

    "Modified: 8.3.1996 / 13:26:05 / cg"
    "Created: 13.4.1997 / 00:01:11 / cg"
!

marked: aBoolean

    "Sets the mark bit. You may use it for whatever you want. Actually,
     it's used for marking profiled methods"

    self markFlag:aBoolean.

    "/ duplicate code...

    "/%{  /* NOCONTEXT */
    "/
    "/    INT newFlags = __intVal(__INST(flags));
    "/
    "/    /* made this a primitive to get define in stc.h */
    "/    if (aBoolean == true)
    "/        newFlags |= F_MARKBIT;
    "/    else
    "/        newFlags &= ~F_MARKBIT;
    "/
    "/    __INST(flags) = __mkSmallInteger(newFlags);
    "/%}
    "/
    "/    "Created: / 29-11-2010 / 21:20:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberOfArgs:aNumber
    "set the number of arguments, the codeObject expects.
     WARNING: for internal use by the compiler only.
	      playing around here with incorrect values
	      may (will ?)  crash smalltalk badly.

     The limitation in the max. number of arguments is due to the
     missing SENDxx functions in the VM and cases in #perform. This too
     will be removed in a later release, allowing any number of arguments."

    (aNumber between:0 and:self class maxNumberOfArguments) ifFalse:[
	self error:('ST/X only supports up to a maximum of ' ,
		    self class maxNumberOfArguments printString ,
		    ' method arguments').
	^ self
    ].
%{
#ifdef __SCHTEAM__
    self.setNumberOfArguments( aNumber.intValue() );
#else
    /* made this a primitive to get define in stc.h */
# ifdef F_NARGS
    __INST(flags) = __mkSmallInteger( (__intVal(__INST(flags)) & ~F_NARGS) | (__intVal(aNumber) << F_NARGSHIFT) );
# endif
#endif
%}


!

numberOfVars:aNumber
    "set the number of local variables - for use by compiler only.
     WARNING: for internal use by the compiler only.
	      playing around here with incorrect values
	      may (will ?)  crash smalltalk badly."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    self.setNumberOfLocals( aNumber.intValue() );
#else
    INT f = __intVal(__INST(flags));

    /* made this a primitive to get define in stc.h */
    if (__isSmallInteger(aNumber)) {
	f = (f & ~F_NVARS) | (__intVal(aNumber) << F_NVARSHIFT);
	__INST(flags) = __mkSmallInteger(f);
    }
#endif
%}


!

stackSize
    "return thedepth of the local stack in the context.

     WARNING: for internal use by ST/X debuggers only.
	      This method may be removed without notice."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.getNumberOfStackTemporaries() );
#else
    INT n = (__intVal(__INST(flags)) & F_NSTACK) >> F_NSTACKSHIFT;

    /* made this a primitive to get define in stc.h */
    RETURN (__mkSmallInteger(n));
#endif
%}

!

stackSize:aNumber
    "set the depth of the local stack.

     WARNING: for internal use by the compiler only.
	      playing around here with incorrect values
	      may crash smalltalk badly.
	      if the runtime library was compiled with DEBUG,
	      a bad stack will be detected and triggers an error
	      (by default, the VM is compiled with this option)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    self.setNumberOfStackTemporaries( aNumber.intValue() );
#else
    INT f = __intVal(__INST(flags));

    /* made this a primitive to get define in stc.h */
    if (__isSmallInteger(aNumber)) {
	f = (f & ~F_NSTACK) | (__intVal(aNumber) << F_NSTACKSHIFT);
	__INST(flags) = __mkSmallInteger(f);
    }
#endif
%}

! !

!CompiledCode methodsFor:'queries'!

decompileTo:aStream
    |decompilerClass decompiler|

    decompilerClass := self decompilerClass.
    decompilerClass isNil ifTrue:[
	^ false
    ].

    Autoload autoloadFailedSignal handle:[:ex |
	^ false.
    ] do:[
	decompilerClass autoload.
    ].

    decompiler := decompilerClass new.
    decompiler targetClass:self mclass.
    decompiler decompile:self to:aStream.
    ^ true

    "Created: 16.4.1996 / 20:25:40 / cg"
    "Modified: 30.7.1997 / 16:37:14 / cg"
!

hasAnnotation: key
    "Return false here, as a fallback"

    ^ false
!

isChecked
    "return true, if this method has been analyzed for jitting"

%{  /* NOCONTEXT */

    /* made this a primitive to get define in stc.h */

    RETURN (( (INT)(__INST(flags)) & __MASKSMALLINT(F_CHECKED)) ? true : false);
%}.
    ^ true "/ an arbtrary return value as fallback

    "Created: / 29-11-2010 / 21:16:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDynamic
    "return true, if the machine code was created
     dynamically (from bytecode); false if the machine code was
     already present in an objectFile
     (i.e. has JIT-compiled machineCode, as opposed to stc-compiled code)."

%{  /* NOCONTEXT */

    /* made this a primitive to get define in stc.h */

    RETURN (( (INT)(__INST(flags)) & __MASKSMALLINT(F_DYNAMIC)) ? true : false);
%}.
    ^ false "/ an arbitrary return value as fallback
!

isExecutable
    "return true, if this method is executable.
     I.e. neither an invalidated nor an unloaded method"

    self isInvalid ifTrue:[^ false].
    ^ self byteCode notNil or:[self hasCode]

    "Created: / 16.4.1996 / 17:52:16 / cg"
    "Modified: / 13.11.1998 / 23:18:01 / cg"
!

isExtension
    "return true, if this method is an extension (i.e. package ~= classes' package)"

    ^ false

    "Created: / 07-09-2011 / 09:28:57 / cg"
!

isMarked
    "return true, if this method has been marked (for whatever reason)"

    ^ self markFlag

    "/ duplicate code:

    "/%{  /* NOCONTEXT */
    "/
    "/    /* made this a primitive to get define in stc.h */
    "/
    "/    RETURN (( (INT)(__INST(flags)) & __MASKSMALLINT(F_MARKBIT)) ? true : false);
    "/%}
    "/
    "/ "Created: / 29-11-2010 / 21:17:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnloaded
    "return true, if the methods machine code has been unloaded
     from the system (i.e. it is not executable)."

    ^ (self hasCode not and:[self byteCode isNil])

    "Created: / 16.4.1996 / 17:51:47 / cg"
    "Modified: / 13.11.1998 / 23:18:18 / cg"
!

messages
    "return a Set of all symbols referenced by this thingy.
     (this is more than the message selectors, since also global names
     and symbols found in immediate arrays are included)."

    |symbolSet|

    symbolSet := IdentitySet new.
    self literalsDo: [ :lit |
	lit isSymbol ifTrue: [
	    symbolSet add: lit
	] ifFalse: [
	    lit isArray ifTrue: [
		lit traverse: [ :el |
		    el isSymbol ifTrue: [symbolSet add: el]
		]
	    ]
	]
    ].
    ^ symbolSet

    "
     (CompiledCode compiledMethodAt:#messages) messages
    "

    "Modified: 25.6.1996 / 22:24:20 / stefan"
!

numArgs
    "return the number of arguments, the method expects.
     Please use argumentCount for ANSI compatibility."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.getNumberOfArguments() );
#else
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger((__intVal(__INST(flags)) & F_NARGS) >> F_NARGSHIFT));
#endif
%}.
    "
     The old implementation simply counted the arguments from
     the methods source - new versions include this information
     in the flag instVar, for more security in #perform:
    "

    "
     (Method compiledMethodAt:#source) numArgs
     (Method compiledMethodAt:#source:) numArgs
    "
!

numVars
    "return the number of block local variables.
     Do not depend on the returned value - future optimizations
     may change things here (i.e. when moving locals into
     surrounding context for inlining).
     - for debugging only."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.getNumberOfLocals() );
#else
    /* made this a primitive to get define in stc.h */

    RETURN (__mkSmallInteger((__intVal(__INST(flags)) & F_NVARS) >> F_NVARSHIFT));
#endif
%}



!

referencesGlobal:aGlobalSymbol
    "return true, if this method references the global named aGlobalSymbol.
     For now, this is the same as #referencesLiteral:,
     but this might change in the future to perform a deeper
     analyzes on the bytecodes, to detect implicit global
     refs (as done by some special bytecodes)"

    ^ self referencesLiteral:aGlobalSymbol

    "
     (CompiledCode compiledMethodAt:#referencesGlobal:) referencesGlobal:#referencesLiteral:
     (CompiledCode compiledMethodAt:#referencesGlobal:) referencesGlobal:#bla
    "

    "Modified: / 24.6.1996 / 15:41:59 / stefan"
    "Modified: / 9.11.1999 / 17:03:44 / cg"
!

referencesGlobalMatching:aMatchPattern
    "return true, if this method references the given a literal symbol,
     which matches the given pattern."

    ^ (self literalsDetect:[:mthdLit|
				(mthdLit isMemberOf:Symbol)
				  and:[aMatchPattern match:mthdLit]
			   ] ifNone:[false]) ~~ false.

    "
     (CompiledCode compiledMethodAt:#referencesGlobalMatching:) referencesGlobalMatching:'*atch*'
     (CompiledCode compiledMethodAt:#referencesGlobalMatching:) referencesGlobalMatching:'*batch*'
    "

    "Modified: / 9.11.1999 / 17:03:16 / cg"
!

referencesLiteral:aLiteral
    "return true, if this method references the given literal directly
     (i.e. a flat search, which does not look deeper into literal arrays)."

    |lit|

    lit := aLiteral.
    aLiteral isAssociation ifTrue:[
        "/ for ST80 compatibility (where variableBindings are used...)
        lit := lit key
    ].
    ^ (self literalsDetect:[:mthdLit| mthdLit == lit] ifNone:[nil]) notNil.

    "
     (CompiledCode compiledMethodAt:#referencesLiteral:) referencesGlobal:#literalsDetect:ifNone:
     (CompiledCode compiledMethodAt:#referencesLiteral:) referencesGlobal:#bla
    "

    "Modified: / 24.6.1996 / 15:41:59 / stefan"
    "Created: / 28.10.1997 / 13:09:40 / cg"
    "Modified: / 18.8.2000 / 21:18:51 / cg"
!

refersToLiteral:aLiteral
    "return true if the receiver, or recursively any array element in the receiver,
     refers to aLiteral (i.e. a deep search)"

    self literalsDo: [ :el |
        el == aLiteral ifTrue:[^true].
        el isArray ifTrue:[
            (el refersToLiteral: aLiteral) ifTrue: [^true]
        ]
    ].
    ^ false

    "
     (CompiledCode compiledMethodAt:#refersToLiteral:) refersToLiteral:#foo
     (CompiledCode compiledMethodAt:#refersToLiteral:) refersToLiteral:#class
    "

    "Modified: / 03-03-1998 / 00:02:28 / stefan"
    "Modified: / 26-07-2012 / 15:44:33 / cg"
!

refersToLiteralMatching:aMatchPattern
    "return true if the receiver, or recursively any array element in the receiver,
     is symbolic and matches aMatchPattern (i.e. a deep search)"

    self literalsDo: [ :el |
        (el isSymbol and:[ aMatchPattern match: el]) ifTrue:[^true].
        el isArray ifTrue:[
            (el refersToLiteralMatching: aMatchPattern) ifTrue: [^true]
        ]
    ].
    ^ false

    "
     (CompiledCode compiledMethodAt:#refersToLiteralMatching:) refersToLiteral:'is*'
     (CompiledCode compiledMethodAt:#refersToLiteralMatching:) refersToLiteral:'foo*'
    "

    "Modified: / 03-03-1998 / 00:02:28 / stefan"
    "Modified: / 18-08-2000 / 21:17:47 / cg"
    "Created: / 26-07-2012 / 15:37:23 / cg"
! !

!CompiledCode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: CompiledCode.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !


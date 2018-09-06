"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

CompiledCode variableSubclass:#Block
	instanceVariableNames:'home nargs sourcePos initialPC'
	classVariableNames:'InvalidNewSignal'
	poolDictionaries:''
	category:'Kernel-Methods'
!

!Block class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    Blocks are pieces of executable code which can be evaluated by sending
    them a value-message (''value'', ''value:'', ''value:value:'' etc).

    In smalltalk, Blocks provide the basic (and heavily used) mechanism
    for looping, enumerating collection elements, visitors, exception
    handling, unwinding, delayed execution and processes.

    Blocks are never created explicitely; the only creation
    is done by the compilers, when some sourceCode is compiled to either
    machine or byteCode.

    In the code, blocks are written as:
        [
            expression1. 
            ...
            expressionN 
        ]
    It represents the computation inside the brackets,
    and can be passed around as argument, assigned to variables or returned from a block or method.
    Creation of a block does NOT evaluate its expressions. You have to give the block to someone,
    who asks it to evaluate itself. This is done by sending #value to the block.
    i.e.
        foo := [ Transcript showCR:'Hello World'].
        ...
        foo value

    Blocks are used in many many ways; one particular use is as callback:
        |b|
        
        b := Button label:'Press me'.
        b action:[ Transcript showCR:'Hello'].
        b open.

    Blocks with arguments need a message of type ''value:arg1 ... value:argn''
    for evaluation; the number of arguments passed when evaluating must match
    the number of arguments the block was declared with otherwise an error is
    raised. 
    Blocks without args need a ''value'' message for evaluation.

    another use of blocks is in the enumeration protocols:
        |coll|

        coll := #( 'one' 'two' 'three').
        coll do:[:eachElement | Transcript showCR:eachElement ].
    
    Blocks keep a reference to the context where it was declared -
    this allows blocks to access the methods arguments and/or variables.
    This is still true after the method has returned - since the
    block keeps this reference, the methods context will NOT die in this case.
    (for experts: Smalltalk blocks are technically lambdas/closures)

    A return (via ^-statement) out of a block will force a return from the
    block's method context (if it is still living).
    This is effectively a kind of long-jumps out of the method which declared the block
    and makes control structures and loops possible.
    If the method is not alive (i.e. has already returned), a return out of the
    block will trigger an error.

    Long-jump is done by defining a catchBlock as ''[^ self]''
    somewhere up in the calling-tree. Then, to do the long-jump from out of some
    deeply nested method, simply do: ''catchBlock value''.

    [Instance variables:]

      home        <Context>         the context where this block was created (i.e. defined)
                                    this may be a blockContext or a methodContext
      nargs       <SmallInteger>    the number of arguments the block expects
      sourcePos   <SmallInteger>    the character position of its source, in chars
                                    relative to methods source beginning
      initialPC   <SmallInteger>    the start position within the byteCode
                                    for compiled blocks, this is nil.


    [Class variables:]

      InvalidNewSignal              raised if a Block is tried to be created
                                    with new (which is not allowed).
                                    Only the VM is allowed to create Blocks.


    NOTICE: layout known by runtime system and compiler - do not change

    [author:]
        Claus Gittinger

    [see also:]
        Process Context
        Collection
        ( contexts. blocks & unwinding : programming/contexts.html)
"
!

examples
"
    define a block and evaluate it:
									[exBegin]
	|b|

	b := [ Transcript showCR:'hello' ].

	Transcript showCR:'now evaluating the block ...'.
	b value.
									[exEnd]



    even here, blocks are involved:
    (although, the compiler optimizes things if possible)
									[exBegin]
	Transcript showCR:'now evaluating one of two blocks ...'.
	1 > 4 ifTrue:[
	    Transcript showCR:'foo'
	] ifFalse:[
	    Transcript showCR:'bar'
	]
									[exEnd]



    here things become obvious:
									[exBegin]
	|yesBlock noBlock|

	yesBlock := [ Transcript showCR:'foo' ].
	noBlock := [ Transcript showCR:'bar' ].

	Transcript showCR:'now evaluating one of two blocks ...'.
	1 > 4 ifTrue:yesBlock
	      ifFalse:noBlock
									[exEnd]



    simple loops:
      not very objectOriented:
									[exBegin]
	|i|

	i := 1.
	[i < 10] whileTrue:[
	    Transcript showCR:i.
	    i := i + 1
	]
									[exEnd]


      using integer protocol:
									[exBegin]
	1 to:10 do:[:i |
	    Transcript showCR:i.
	]
									[exEnd]


      interval protocol:
									[exBegin]
	(1 to:10) do:[:i |
	    Transcript showCR:i.
	]
									[exEnd]



    looping over collections:

      bad code:
      (only works with numeric-indexable collections)
									[exBegin]
	|i coll|

	coll := #(9 8 7 6 5).
	i := 1.
	[i <= coll size] whileTrue:[
	    Transcript showCR:(coll at:i).
	    i := i + 1.
	]
									[exEnd]



      just as bad (well, marginally better ;-):
      (only works with numeric-indexable collections)
									[exBegin]
	|coll|

	coll := #(9 8 7 6 5).
	1 to:coll size do:[:i |
	    Transcript showCR:(coll at:i).
	]
									[exEnd]



      the smalltalk way:
      (works with any collection)
									[exBegin]
	|coll|

	coll := #(9 8 7 6 5).
	coll do:[:element |
	    Transcript showCR:element.
	]
									[exEnd]

    Rule: use enumeration protocol of the collection instead of
	  manually indexing it. [with few exceptions]



    processes:

      forking a lightweight process (thread):
									[exBegin]
	[
	    Transcript showCR:'waiting ...'.
	    Delay waitForSeconds:2.
	    Transcript showCR:'here I am'.
	] fork
									[exEnd]



      some with low prio:
									[exBegin]
	[
	    Transcript showCR:'computing ...'.
	    10000 factorial.
	    Transcript showCR:'here I am'.
	] forkAt:(Processor userBackgroundPriority)
									[exEnd]



    handling exceptions:
									[exBegin]
	Error handle:[:ex |
	    Transcript showCR:'exception handler forces return'.
	    ex return
	] do:[
	    Transcript showCR:'now, doing something bad ...'.
	    1 / 0.
	    Transcript showCR:'not reached'
	]
									[exEnd]



    performing cleanup actions:
									[exBegin]
	Error handle:[:ex |
	    Transcript showCR:'exception handler forces return'.
	    ex return
	] do:[
	    [
		Transcript showCR:'doing something bad ...'.
		1 / 0.
		Transcript showCR:'not reached'
	    ] ifCurtailed:[
		Transcript showCR:'cleanup'
	    ]
	]
									[exEnd]


    delayed execution (visitor pattern):
    (looking carefully into the example,
     C/C++ programmers may raise their eyes ;-)
									[exBegin]
	|showBlock countBlock
	 howMany
	 top panel b1 b2|

	howMany := 0.

	showBlock := [ Transcript showCR:howMany ].
	countBlock := [ howMany := howMany + 1 ].

	top := StandardSystemView extent:200@200.
	panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

	b1 := Button label:'count up' in:panel.
	b1 action:countBlock.

	b2 := Button label:'show value' in:panel.
	b2 action:showBlock.

	top open.

	Transcript showCR:'new process started;'.
	Transcript showCR:'notice: the blocks can still access the'.
	Transcript showCR:'        howMany local variable.'.
									[exEnd]
"
! !

!Block class methodsFor:'initialization'!

initialize
    "create signals raised by various errors"

    InvalidNewSignal isNil ifTrue:[
	InvalidNewSignal := Error newSignalMayProceed:false.
	InvalidNewSignal nameClass:self message:#invalidNewSignal.
	InvalidNewSignal notifierString:'blocks are only created by the system'.
    ]

    "Modified: 22.4.1996 / 16:34:20 / cg"
! !

!Block class methodsFor:'instance creation'!

byteCode:bCode numArgs:numArgs numStack:nStack sourcePosition:sourcePos initialPC:initialPC literals:literals
    "create a new cheap (homeless) block.
     Not for public use - this is a special hook for the compiler."

    ^ self
	byteCode:bCode numArgs:numArgs numVars:0 numStack:nStack sourcePosition:sourcePos initialPC:initialPC literals:literals
!

byteCode:bCode numArgs:numArgs numVars:numVars numStack:nStack sourcePosition:sourcePos initialPC:initialPC literals:literals
    "create a new cheap (homeless) block.
     Not for public use - this is a special hook for the compiler."

    |newBlock|

    newBlock := (super basicNew:(literals size))
			   byteCode:bCode
			   numArgs:numArgs
			   numVars:numVars
			   numStack:nStack
		     sourcePosition:sourcePos
			  initialPC:initialPC
			   literals:literals.
    ^ newBlock

    "Modified: 24.6.1996 / 12:36:48 / stefan"
    "Created: 13.4.1997 / 00:04:09 / cg"
!

new
    "catch creation of blocks - only the system creates blocks.
     If you really need a block (assuming, you are some compiler),
     use basicNew and setup the instance carefully"

    ^ InvalidNewSignal raise.
!

new:size
    "catch creation of blocks - only the system creates blocks"

    ^ InvalidNewSignal raise.
! !

!Block class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Block

    "Modified: 23.4.1996 / 15:55:58 / cg"
! !


!Block methodsFor:'Compatibility-ANSI'!

argumentCount
    "VisualAge/ANSI compatibility: alias for #numArgs.
     return the number of arguments I expect for evaluation"

    ^ nargs

    "Created: 15.11.1996 / 11:22:02 / cg"
!

ensure:aBlock
    "VisualAge/ANSI compatibility:
     evaluate the receiver and return its result.
     After evaluation, also evaluate aBlock but ignore its result.
     aBlock is also evaluated in case of abnormal termination.
     (the same as #valueNowOrOnUnwindDo:)"

    <exception: #unwind>

    |v|

    v := self value.       "the real logic is in Context>>unwind"
    thisContext unmarkForUnwind.
    aBlock value.
    ^ v

    "/ the above is the same as in #valueNowOrOnUnwindDo:
    "/ (actually, the previous implementation was:
    "/ ^ self valueNowOrOnUnwindDo:aBlock

    "
     [
	[
	    Transcript showCR:'one'.
	    Processor activeProcess terminate.
	    Transcript showCR:'two'.
	] ensure:[
	    Transcript showCR:'three'.
	].
     ] fork.
    "

    "
     [
	[
	    Transcript showCR:'one'.
	    Transcript showCR:'two'.
	] ensure:[
	    Transcript showCR:'three'.
	].
     ] fork.
    "
!

ifCurtailed:aBlock
    "VisualAge/ANSI compatibility:
     evaluate the receiver - when some method sent within unwinds (i.e. does
     a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions (for example closing files etc.) are
     executed regardless of error actions.
     This is the same as #valueOnUnwindDo:"

    <exception: #unwind>

    |v|

    "/ thisContext markForUnwind. -- same as above pragma
    v := self value.       "the real logic is in Context>>unwind"
    thisContext unmarkForUnwind.
    ^ v

    "
     |s|

     s := 'Makefile' asFilename readStream.
     [
	^ self
     ] ifCurtailed:[
	Transcript showCR:'closing the stream - even though a return occurred'.
	s close
     ]
    "
    "
     [
	 |s|

	 s := 'Makefile' asFilename readStream.
	 [
	    Processor activeProcess terminate
	 ] ifCurtailed:[
	    Transcript showCR:'closing the stream - even though process was terminated'.
	    s close
	 ]
     ] fork
    "
! !

!Block methodsFor:'Compatibility-Dolphin'!

deferredValue
    "Dolphin compatibility method - do not use in new code.
     Dolphin's alias for futureValue"

    ^ Future new block:self

    "Modified: / 04-10-2011 / 14:56:27 / cg"
!

deferredValueAt:priority
    "Dolphin compatibility method - do not use in new code.
     Dolphin's alias for futureValue"

    ^ Future new
	priority:priority block:self

    "Created: / 04-10-2011 / 14:55:56 / cg"
! !

!Block methodsFor:'Compatibility-Squeak'!

cull: optionalFirstArg
    "activate the receiver with one or zero arguments.
     Squeak compatibility, but also present in VW Smalltalk"

    nargs >= 1 ifTrue:[^ self value:optionalFirstArg].
    ^ self value
!

cull: optionalFirstArg cull: optionalSecondArg
    "activate the receiver with two or less arguments.
     Squeak compatibility, but also present in VW Smalltalk"

    nargs >= 2 ifTrue:[^ self value:optionalFirstArg value:optionalSecondArg].
    nargs = 1 ifTrue:[^ self value:optionalFirstArg].
    ^ self value
!

cull: optionalFirstArg cull: optionalSecondArg cull: optionalThirdArg
    "activate the receiver with three or less arguments.
     Squeak compatibility, but also present in VW Smalltalk"

    nargs >= 2 ifTrue:[
	nargs >= 3 ifTrue:[
	    ^ self value:optionalFirstArg value:optionalSecondArg value:optionalThirdArg
	].
	^ self value:optionalFirstArg value:optionalSecondArg
    ].
    nargs = 1 ifTrue:[^ self value:optionalFirstArg].
    ^ self value
!

ifError:handlerBlock
    "squeak compatibility:
     Evaluate the receiver block and return its value, if no error occurs.
     If an error is raised, return the value from handlerBlock.
     The handlerBlock may take 0,1 or 2 args.
     (1 arg  -> the exception;
      2 args -> the errorString and the erroneous receiver)"

    |numArgs|

    numArgs := handlerBlock isBlock ifTrue:[handlerBlock argumentCount] ifFalse:[0].
    numArgs == 1 ifTrue:[
        ^ self on:Error do:handlerBlock
    ].

    ^ self
        on:Error
        do:[:ex |
            |errString errReceiver|

            numArgs == 0 ifTrue:[
                ex return:handlerBlock value
            ] ifFalse:[
                errString := ex description.
                errReceiver := ex suspendedContext receiver.
                ex return:(handlerBlock value:errString value:errReceiver)
            ].
        ]

    "
     |a|

     a := 0.
     [ 123 / a ] ifError:[:msg :rec | self halt]
    "

    "
     |a|

     a := 0.
     [ 123 / a ] ifError:[:ex | self halt]
    "

    "
     |a|

     a := 0.
     [ 123 / a ] ifError:[self halt]
    "
!

timeToRun
    "squeak compatibility: same as millisecondsToRun:"

    ^ Time millisecondsToRun:self
!

valueWithPossibleArgs:argArray
    "squeak compatibility: same as valueWithOptionalArguments:"

     ^ self valueWithOptionalArguments:argArray
! !

!Block methodsFor:'Compatibility-V''Age'!

apply:aCollection from:start to:end
    "VisualAge compatibility:
     Evaluate the receiver for each variable slot of aCollection from start to end.
     Answer aCollection."

    aCollection from:start to:end do:self.
    ^ aCollection

    "
     [:i | Transcript showCR:i ]
	apply:#(10 20 30 40 50 60) from:2 to:4
    "

    "Created: / 16-05-2012 / 11:20:55 / cg"
!

applyWithIndex:aCollection from:start to:end
    "VisualAge compatibility:
     Evaluate the receiver for each variable slot and index of aCollection from start to end.
     Answer aCollection."

    aCollection from:start to:end doWithIndex:self.
    ^ aCollection

    "
     [:el :i | Transcript showCR:(i -> el) ]
	applyWithIndex:#(10 20 30 40 50 60) from:2 to:4
    "

    "Created: / 16-05-2012 / 11:22:01 / cg"
!

value:arg1 onReturnDo:aBlock
    "VisualAge compatibility: alias for #ensure:
     evaluate the receiver - when the block returns either a local return
     or an unwind (i.e. does a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions
     (for example closing files etc.) are executed regardless of error actions."

    ^ [self value:arg1] ensure:aBlock

    "Created: / 16-05-2012 / 11:29:30 / cg"
!

value:arg1 value:arg2 onReturnDo:aBlock
    "VisualAge compatibility: alias for #ensure:
     evaluate the receiver - when the block returns either a local return
     or an unwind (i.e. does a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions
     (for example closing files etc.) are executed regardless of error actions."

    ^ [self value:arg1 value:arg2] ensure:aBlock

    "Created: / 16-05-2012 / 11:29:46 / cg"
!

value:arg1 value:arg2 value:arg3 onReturnDo:aBlock
    "VisualAge compatibility: alias for #ensure:
     evaluate the receiver - when the block returns either a local return
     or an unwind (i.e. does a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions
     (for example closing files etc.) are executed regardless of error actions."

    ^ [self value:arg1 value:arg2 value:arg3] ensure:aBlock

    "Created: / 16-05-2012 / 11:29:59 / cg"
!

valueOnReturnDo:aBlock
    "VisualAge compatibility: alias for #ensure:
     evaluate the receiver - when the block returns either a local return
     or an unwind (i.e. does a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions
     (for example closing files etc.) are executed regardless of error actions."

    ^ self ensure:aBlock

    "Created: / 15-11-1996 / 11:38:37 / cg"
!

when:exceptionClassOrSignal do:handler
    "VisualAge compatibility:"

    ^ self on:exceptionClassOrSignal do:handler

    "Created: / 28-08-2010 / 14:41:15 / cg"
! !



!Block methodsFor:'accessing'!

home
    "return the receiver's home context (the context where it was
     created). For cheap blocks, nil is returned"

    ^ home
!

homeMethod
    "return the receiver's home method.
     That's the method where the block was created."

    |m|

    home notNil ifTrue:[
        m := home method.
        m notNil ifTrue:[^ m].
    ].
    m := self literalAt:1 ifAbsent:nil.
    m isMethod ifTrue:[^ m].
    ^ nil

    "Created: 19.6.1997 / 16:14:57 / cg"
!

method
    "return the receiver's method
     (the method where the block was created).
     Obsolete: use #homeMethod for ST80 compatibility."

    <resource: #obsolete>

    ^ self homeMethod

    "Modified: 19.6.1997 / 16:15:24 / cg"
!

methodHome
    "return the receiver's method home context (the context where it was
     defined). For cheap blocks, nil is returned"

    home notNil ifTrue:[
	^ home methodHome
    ].
    ^ nil
!

numArgs
    "return the number of arguments I expect for evaluation.
     Please use argumentCount for ANSI compatibility"

"/    <resource: #obsolete>

    ^ nargs
! !


!Block methodsFor:'compatibility-Cola & Pepsi'!

arity
    ^ self argumentCount
! !

!Block methodsFor:'conversion'!

asVarArgBlock
    "convert myself into a varArg block;
     this one has 1 formal argument, which gets the list
     of actual arguments when evaluated."

    nargs ~~ 1 ifTrue:[
	self error:'vararg blocks must take exactly 1 argument - the arg list'.
	^ nil
    ].

    self changeClassTo:VarArgBlock.
    ^ self

    "
     |b|

     b := [:argList | Transcript
			show:'invoked with args:';
			showCR:argList
	  ] asVarArgBlock.
     b value.
     b value:'arg1'.
     b value:'arg1' value:'arg2' value:'arg3' value:'arg4'
    "

    "Created: 23.1.1997 / 13:35:28 / cg"
    "Modified: 23.1.1997 / 13:35:48 / cg"
!

beCurryingBlock
    "make myself a currying block;
     that's a block which, if invoked with less-than-expected arguments,
     returns another block which provides the provided argument(s) and expects the remaining args.
     Read any book on functional programming, if you don't understand this."

    self changeClassTo:CurryingBlock.
    ^ self

    "
     |b b1 b2 b3|

     b := [:a :b :c | a + b + c] beCurryingBlock.
     b numArgs.
     b value:1 value:2 value:3.

     b1 := b value:10.
     b1 numArgs.
     b1 value:2 value:3.

     b2 := b value:10 value:20.
     b2 numArgs.
     b2 value:3.

     b3 := b1 value:20.
     b3 numArgs.
     b3 value:3.
    "

    "Modified: / 10-05-2010 / 12:56:20 / cg"
!

beVarArg
    "convert myself into a varArg block;
     this one has 1 formal argument, which gets the list
     of actual arguments when evaluated."

    ^ self asVarArgBlock.

    "
     |b|

     b := [:argList | argList printCR] beVarArg.
     b value.
     b value:'arg1' value:'arg2' value:'arg3' value:'arg4'
    "

    "Created: 23.1.1997 / 13:35:28 / cg"
    "Modified: 23.1.1997 / 13:35:48 / cg"
! !

!Block methodsFor:'copying'!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    |copyOfHome copyOfMe|

    home isNil ifTrue:[
	^ super deepCopyUsing:aDictionary postCopySelector:postCopySelector
    ].
    copyOfHome := home deepCopyUsing:aDictionary.
    copyOfMe := self shallowCopy.
    copyOfMe setHome:copyOfHome.
    copyOfMe perform:postCopySelector withOptionalArgument:self and:aDictionary.
    ^ copyOfMe

    "Created: / 31-03-1998 / 15:46:17 / cg"
    "Modified: / 21-07-2011 / 13:30:12 / cg"
! !

!Block methodsFor:'debugging'!

benchmark:anInfoString
    "evaluate myseld and show the timing info on Transcript"

    |startTime endTime startCycles endCycles overhead overheadCycles 
     micros millis cycles|

    startTime := OperatingSystem getMicrosecondTime.
    startCycles := OperatingSystem getCPUCycleCount.
    [123] value.
    endCycles := OperatingSystem getCPUCycleCount.
    endTime := OperatingSystem getMicrosecondTime.
    overhead := endTime - startTime.
    "/ just in case, the OS does not support cpu cycles
    overheadCycles := endCycles - startCycles.
    
    startTime := OperatingSystem getMicrosecondTime.
    startCycles := OperatingSystem getCPUCycleCount.
    self value.
    endCycles := OperatingSystem getCPUCycleCount.
    endTime := OperatingSystem getMicrosecondTime.

    micros := (endTime - startTime - overhead) max:0.
    cycles := (endCycles - startCycles - overheadCycles) max:0. 
    
    Transcript show:anInfoString.
    micros < 1000 ifTrue:[
        "/ too stupid: many fonts do not have a mu,
        "/ so I output it as us here.
        Transcript show:micros; show:' s'.
    ] ifFalse:[
        micros < 100000 ifTrue:[
            millis := (micros / 1000.0) asFixedPointRoundedToScale:2.
            Transcript show:millis; show:' ms'.
        ] ifFalse:[
            millis := micros // 1000.
            Transcript show:(TimeDuration milliseconds:millis).
        ].
    ].
    cycles ~~ 0 ifTrue:[
        Transcript show:' ('; show:cycles; show:' cycles)'.
    ].
    Transcript cr.

    "
     be aware that if you evaluate the following,
     the blocks will be interpreted by the doIt. 
     Thus you will get on-realistic values.
     Better compile those expressions into a method and call that
     for realistic measurements.
     
     [] benchmark:'empty block:'        - this is a pre-compiled block
     [123] benchmark:'empty block:'     - the rest are interpreted blocks
     [10 factorial] benchmark:'10 factorial:'
     [10 factorial] benchmark:'11 factorial:'
     [100 factorial] benchmark:'100 factorial:'
    "
! !

!Block methodsFor:'error handling'!

invalidCodeObject
    "{ Pragma: +optSpace }"

    "this error is triggered by the interpreter when a non-Block object
     is about to be executed.
     In this case, the VM sends this to the bad method (the receiver).
     Can only happen when the Compiler/runtime system is broken or
     someone played around."

    ^ InvalidCodeError
	raiseRequestWith:self
	errorString:'invalid block - not executable'

    "Modified: 4.11.1996 / 22:46:39 / cg"
! !

!Block methodsFor:'evaluation'!

value
    "evaluate the receiver with no block args.
     The receiver must be a block without arguments."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL0( self.asSTCallable() );
    /* NOTREACHED */
#else
    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(0)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif

	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    /* compiled machine code */
	    RETURN ( (*thecode)(self) );
	}
	/* interpreted code */
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 0, nil, nil, nil, nil) );
#  else
	RETURN ( __interpret(self, 0, nil, nil, nil, nil) );
#  endif
    }
#endif /* not SCHTEAM */
%}.
    ^ self wrongNumberOfArguments:0
!

value:arg
    "evaluate the receiver with one argument.
     The receiver must be a 1-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL1( self.asSTCallable(), arg );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(1)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg) );
	}
	/* interpreted code */
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 1, nil, nil, nil, nil, &arg) );
#  else
	RETURN ( __interpret(self, 1, nil, nil, nil, nil, arg) );
#  endif
    }
#endif /* not SCHTEAM */
%}.
    ^ self wrongNumberOfArguments:1
!

value:arg1 optionalArgument:arg2
    "evaluate the receiver.
     Optionally pass up one or to two arguments (if the receiver is a one/two arg block)."

    nargs == 2 ifTrue:[
	^ self value:arg1 value:arg2
    ].
    ^ self value:arg1

    "
     |block|

     block := [:arg | Transcript showCR:arg ].
     block value:2 optionalArgument:3.

     block := [:arg1 :arg2 | Transcript show:arg1; space; showCR:arg2 ].
     block value:2 optionalArgument:3.
    "
!

value:arg1 optionalArgument:arg2 and:arg3
    "evaluate the receiver.
     Optionally pass up one, two or three arguments (if the receiver is a 1/2/3-arg block)."

    nargs == 3 ifTrue:[
	^ self value:arg1 value:arg2 value:arg3
    ].
    nargs == 2 ifTrue:[
	^ self value:arg1 value:arg2
    ].
    ^ self value:arg1

    "
     |block|

     block := [:arg | Transcript showCR:arg ].
     block value:2 optionalArgument:3.

     block := [:arg1 :arg2 | Transcript show:arg1; space; showCR:arg2 ].
     block value:2 optionalArgument:3.
    "
!

value:arg1 optionalArgument:arg2 and:arg3 and:arg4
    "evaluate the receiver.
     Optionally pass up one, two, three or four arguments 
     (if the receiver is a 1/2/3/4-arg block)."

    nargs == 4 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4
    ].
    nargs == 3 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3
    ].
    nargs == 2 ifTrue:[
        ^ self value:arg1 value:arg2
    ].
    ^ self value:arg1

    "
     |block|

     block := [:arg | Transcript showCR:arg ].
     block value:1 optionalArgument:2 and:3 and:4.

     block := [:arg1 :arg2 | Transcript show:arg1; space; showCR:arg2 ].
     block value:1 optionalArgument:2 and:3 and:4.

     block := [:arg1 :arg2 :arg3 :arg4 | Transcript showCR:{arg1 . arg2 . arg3 . arg4}].
     block value:1 optionalArgument:2 and:3 and:4.
    "
!

value:arg1 optionalArgument:arg2 and:arg3 and:arg4 and:arg5
    "evaluate the receiver.
     Optionally pass up five arguments 
     (if the receiver is a 1..5-arg block)."

    nargs == 5 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4 value:arg5
    ].
    nargs == 4 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4
    ].
    nargs == 3 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3
    ].
    nargs == 2 ifTrue:[
        ^ self value:arg1 value:arg2
    ].
    ^ self value:arg1

    "
     |block|

     block := [:arg | Transcript showCR:arg ].
     block value:1 optionalArgument:2 and:3 and:4 and:5.

     block := [:arg1 :arg2 | Transcript show:arg1; space; showCR:arg2 ].
     block value:1 optionalArgument:2 and:3 and:4 and:5.

     block := [:arg1 :arg2 :arg3 :arg4 :arg5 | Transcript showCR:{arg1 . arg2 . arg3 . arg4 . arg5}].
     block value:1 optionalArgument:2 and:3 and:4 and:5.
    "
!

value:arg1 optionalArgument:arg2 and:arg3 and:arg4 and:arg5 and:arg6
    "evaluate the receiver.
     Optionally pass up six arguments 
     (if the receiver is a 1..6-arg block)."

    nargs == 6 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6
    ].
    nargs == 5 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4 value:arg5
    ].
    nargs == 4 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4
    ].
    nargs == 3 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3
    ].
    nargs == 2 ifTrue:[
        ^ self value:arg1 value:arg2
    ].
    ^ self value:arg1

    "
     |block|

     block := [:arg | Transcript showCR:arg ].
     block value:1 optionalArgument:2 and:3 and:4 and:5 and:6.

     block := [:arg1 :arg2 | Transcript show:arg1; space; showCR:arg2 ].
     block value:1 optionalArgument:2 and:3 and:4 and:5 and:6.

     block := [:arg1 :arg2 :arg3 :arg4 :arg5 :arg6 | Transcript showCR:{arg1 . arg2 . arg3 . arg4 . arg5 . arg6}].
     block value:1 optionalArgument:2 and:3 and:4 and:5 and:6.
    "
!

value:arg1 value:arg2
    "evaluate the receiver with two arguments.
     The receiver must be a 2-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL2( self.asSTCallable(), arg1, arg2 );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(2)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2) );
	}
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 2, nil, nil, nil, nil, &arg1) );
#  else
	RETURN ( __interpret(self, 2, nil, nil, nil, nil, arg1, arg2) );
#  endif
    }
#endif /* not SCHTEAM */
%}.
    ^ self wrongNumberOfArguments:2
!

value:arg1 value:arg2 optionalArgument:arg3
    "evaluate the receiver.
     Optionally pass two or threearguments (if the receiver is a 2/3-arg block)."

    nargs == 3 ifTrue:[
	^ self value:arg1 value:arg2 value:arg3
    ].
    ^ self value:arg1 value:arg2
!

value:arg1 value:arg2 value:arg3
    "evaluate the receiver with three arguments.
     The receiver must be a 3-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL3( self.asSTCallable(), arg1, arg2, arg3 );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(3)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3) );
	}
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 3, nil, nil, nil, nil, &arg1) );
#  else
	RETURN ( __interpret(self, 3, nil, nil, nil, nil, arg1, arg2, arg3) );
#  endif
    }
#endif /* not SCHTEAM */
%}.
    ^ self wrongNumberOfArguments:3
!

value:arg1 value:arg2 value:arg3 optionalArgument:arg4
    "evaluate the receiver.
     Optionally pass three or four arguments (if the receiver is a 3/4-arg block)."

    nargs == 4 ifTrue:[
        ^ self value:arg1 value:arg2 value:arg3 value:arg4
    ].
    ^ self value:arg1 value:arg2 value:arg3
!

value:arg1 value:arg2 value:arg3 value:arg4
    "evaluate the receiver with four arguments.
     The receiver must be a 4-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL4( self.asSTCallable(), arg1, arg2, arg3, arg4 );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(4)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4) );
	}
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 4, nil, nil, nil, nil, &arg1) );
#  else
	RETURN ( __interpret(self, 4, nil, nil, nil, nil, arg1, arg2, arg3, arg4) );
#  endif
    }
#endif
%}.
    ^ self wrongNumberOfArguments:4
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5
    "evaluate the receiver with five arguments.
     The receiver must be a 5-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL5( self.asSTCallable(), arg1, arg2, arg3, arg4, arg5 );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(5)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5) );
	}
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 5, nil, nil, nil, nil, &arg1) );
#  else
	RETURN ( __interpret(self, 5, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5) );
#  endif
    }
#endif /* not SCHTEAM */
%}.
    ^ self wrongNumberOfArguments:5
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6
    "evaluate the receiver with six arguments.
     The receiver must be a 6-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL6( self.asSTCallable(), arg1, arg2, arg3, arg4, arg5, arg6 );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(6)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6) );
	}
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 6, nil, nil, nil, nil, &arg1) );
#  else
	RETURN ( __interpret(self, 6, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6) );
#  endif
    }
#endif /* not SCHTEAM */
%}.
    ^ self wrongNumberOfArguments:6
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7
    "evaluate the receiver with seven arguments.
     The receiver must be a 7-arg block."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context.TAILCALL7( self.asSTCallable(), arg1, arg2, arg3, arg4, arg5, arg6, arg7 );
    /* NOTREACHED */
#else

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(7)) {
# if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
# endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7) );
	}
#  ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 7, nil, nil, nil, nil, &arg1) );
#  else
	RETURN ( __interpret(self, 7, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7) );
#  endif
    }
#endif
%}.
    ^ self wrongNumberOfArguments:7
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8
    "evaluate the receiver with eight arguments.
     The receiver must be a 8-arg block."

%{  /* NOCONTEXT */

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(8)) {
#if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) );
	}
# ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 8, nil, nil, nil, nil, &arg1) );
# else
	RETURN ( __interpret(self, 8, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) );
# endif
    }
%}.
    ^ self wrongNumberOfArguments:8
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8 value:arg9
    "evaluate the receiver with 9 arguments.
     The receiver must be a 9-arg block."

%{  /* NOCONTEXT */

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(9)) {
#if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) );
	}
# ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 9, nil, nil, nil, nil, &arg1) );
# else
	RETURN ( __interpret(self, 9, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) );
# endif
    }
%}.
    ^ self wrongNumberOfArguments:9
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8 value:arg9 value:arg10
    "evaluate the receiver with 10 arguments.
     The receiver must be a 10-arg block."

%{  /* NOCONTEXT */

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(10)) {
#if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) );
	}
# ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 10, nil, nil, nil, nil, &arg1) );
# else
	RETURN ( __interpret(self, 10, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) );
# endif
    }
%}.
    ^ self wrongNumberOfArguments:10
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8 value:arg9 value:arg10 value:arg11
    "evaluate the receiver with 11 arguments.
     The receiver must be a 11-arg block."

%{  /* NOCONTEXT */

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(11)) {
#if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11) );
	}
# ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 11, nil, nil, nil, nil, &arg1) );
# else
	RETURN ( __interpret(self, 11, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11) );
# endif
    }
%}.
    ^ self wrongNumberOfArguments:11
!

value:arg1 value:arg2 value:arg3 value:arg4 value:arg5 value:arg6 value:arg7 value:arg8 value:arg9 value:arg10 value:arg11 value:arg12
    "evaluate the receiver with 12 arguments.
     The receiver must be a 12-arg block."

%{  /* NOCONTEXT */

    REGISTER OBJFUNC thecode;
    OBJ home;

    if (__INST(nargs) == __mkSmallInteger(12)) {
#if defined(THIS_CONTEXT)
	if (__ISVALID_ILC_LNO(__pilc))
	    __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
	thecode = __BlockInstPtr(self)->b_code;
	if (thecode != (OBJFUNC)nil) {
	    RETURN ( (*thecode)(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) );
	}
# ifdef PASS_ARG_POINTER
	RETURN ( __interpret(self, 12, nil, nil, nil, nil, &arg1) );
# else
	RETURN ( __interpret(self, 12, nil, nil, nil, nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) );
# endif
    }
%}.
    ^ self wrongNumberOfArguments:12
!

valueAt:priority
    "evaluate the receiver, at the given prioriy;
     i.e. change the priority for the execution of the receiver.
     Bad name: should be called evaluateWithPriority: or similar"

    |oldPrio retVal activeProcess|

    activeProcess := Processor activeProcess.
    oldPrio := Processor activePriority.
    [
	activeProcess priority:priority.
	retVal := self value.
    ] ensure:[
	activeProcess priority:oldPrio
    ].
    ^ retVal

    "
     [
	 1000 timesRepeat:[
	     1000 factorial
	 ]
     ] valueAt:3
    "

    "Created: / 29.7.1998 / 19:19:48 / cg"
!

valueWithArguments:argArrayIn
    "evaluate the receiver with arguments taken from argArray.
     ArgArray must be either an Array or nil.
     The size of the argArray must match the number of arguments the receiver expects."

    |argArray a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15|

    argArray := argArrayIn.
    (argArray notNil and:[(argArray class ~~ Array) and:[argArray isArray not]]) ifTrue:[
        argArray isCollection ifFalse:[
            ^ self badArgumentArray:argArray
        ].
        argArray := argArray asArray.
    ].
    (argArray size ~~ nargs) ifTrue:[
        ^ self wrongNumberOfArguments:argArray size
    ].

%{
    REGISTER OBJFUNC thecode;
    OBJ home;
    REGISTER OBJ *ap;
    OBJ nA;

#if defined(THIS_CONTEXT)
    if (__ISVALID_ILC_LNO(__pilc))
            __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
    thecode = __BlockInstPtr(self)->b_code;

    nA = __INST(nargs);

    if (nA != __mkSmallInteger(0)) {
        ap = __arrayVal(argArray);   /* nonNil after above test (size is known to be ok) */
        switch ((INT)nA) {
            default:
                goto error;
            case (INT)__mkSmallInteger(15):
                a15 = ap[14];
            case (INT)__mkSmallInteger(14):
                a14 = ap[13];
            case (INT)__mkSmallInteger(13):
                a13 = ap[12];
            case (INT)__mkSmallInteger(12):
                a12 = ap[11];
            case (INT)__mkSmallInteger(11):
                a11 = ap[10];
            case (INT)__mkSmallInteger(10):
                a10 = ap[9];
            case (INT)__mkSmallInteger(9):
                a9 = ap[8];
            case (INT)__mkSmallInteger(8):
                a8 = ap[7];
            case (INT)__mkSmallInteger(7):
                a7 = ap[6];
            case (INT)__mkSmallInteger(6):
                a6 = ap[5];
            case (INT)__mkSmallInteger(5):
                a5 = ap[4];
            case (INT)__mkSmallInteger(4):
                a4 = ap[3];
            case (INT)__mkSmallInteger(3):
                a3 = ap[2];
            case (INT)__mkSmallInteger(2):
                a2 = ap[1];
            case (INT)__mkSmallInteger(1):
                a1 = ap[0];
            case (INT)__mkSmallInteger(0):
                break;
        }
    }

    if (thecode != (OBJFUNC)nil) {
        RETURN ( (*thecode)(self, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) );
    }
# ifdef PASS_ARG_POINTER
    RETURN ( __interpret(self, __intVal(nA), nil, nil, nil, nil, &a1) );
# else
    RETURN ( __interpret(self, __intVal(nA), nil, nil, nil, nil, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) );
# endif
error: ;
%}.
    "
     the above code only supports up-to 15 arguments
    "
    ^ ArgumentError
        raiseRequestWith:self
        errorString:'only blocks with up-to 15 arguments supported'

    "
        [:a :b :c | Transcript showCR:a; showCR:b; showCR:c] valueWithArguments:#(1 2 3).
        [:a :b :c | Transcript showCR:a; showCR:b; showCR:c] valueWithArguments:#(1 2 3) asOrderedCollection.
    "
!

valueWithOptionalArgument:arg
    "evaluate the receiver.
     Optionally pass an argument (if the receiver is a one arg block)."

    nargs == 1 ifTrue:[
	^ self value:arg
    ].
    ^ self value

    "
     |block|

     block := [ Transcript showCR:'hello' ].
     block valueWithOptionalArgument:2.

     block := [:arg | Transcript showCR:arg ].
     block valueWithOptionalArgument:2.
    "
!

valueWithOptionalArgument:arg1 and:arg2
    "evaluate the receiver.
     Optionally pass up to two arguments (if the receiver is a one/two arg block)."

    nargs == 2 ifTrue:[
	^ self value:arg1 value:arg2
    ].
    nargs == 1 ifTrue:[
	^ self value:arg1
    ].
    ^ self value

    "
     |block|

     block := [ Transcript showCR:'hello' ].
     block valueWithOptionalArgument:2.

     block := [:arg | Transcript showCR:arg ].
     block valueWithOptionalArgument:2.

     block := [:arg1 :arg2 | Transcript showCR:arg1. Transcript showCR:arg2 ].
     block valueWithOptionalArgument:10 and:20.
    "
!

valueWithOptionalArgument:arg1 and:arg2 and:arg3
    "evaluate the receiver.
     Optionally pass up to three arguments (if the receiver is a one/two/three arg block)."

    nargs == 3 ifTrue:[
	^ self value:arg1 value:arg2 value:arg3
    ].
    nargs == 2 ifTrue:[
	^ self value:arg1 value:arg2
    ].
    nargs == 1 ifTrue:[
	^ self value:arg1
    ].
    ^ self value

    "
     |block|

     block := [ Transcript showCR:'hello' ].
     block valueWithOptionalArgument:2.

     block := [:arg | Transcript showCR:arg ].
     block valueWithOptionalArgument:2.

     block := [:arg1 :arg2 | Transcript showCR:arg1. Transcript showCR:arg2 ].
     block valueWithOptionalArgument:10 and:20.
    "
!

valueWithOptionalArgument:arg1 and:arg2 and:arg3 and:arg4
    "evaluate the receiver.
     Optionally pass up to four arguments (if the receiver is a one/two/three/four arg block)."

    nargs == 4 ifTrue:[
	^ self value:arg1 value:arg2 value:arg3 value:arg4
    ].
    nargs == 3 ifTrue:[
	^ self value:arg1 value:arg2 value:arg3
    ].
    nargs == 2 ifTrue:[
	^ self value:arg1 value:arg2
    ].
    nargs == 1 ifTrue:[
	^ self value:arg1
    ].
    ^ self value

    "
     |block|

     block := [ Transcript showCR:'hello' ].
     block valueWithOptionalArgument:2.

     block := [:arg | Transcript showCR:arg ].
     block valueWithOptionalArgument:2.

     block := [:arg1 :arg2 | Transcript showCR:arg1. Transcript showCR:arg2 ].
     block valueWithOptionalArgument:10 and:20.
    "
!

valueWithOptionalArguments:argArrayIn
    "evaluate the receiver with arguments as required taken from argArray.
     Only the required number of arguments is taken from argArray or nil;
     (i.e. argArray may be larger than the required number).
     If the size of the argArray is smaller than the number of arguments, an error is raised."

    |argArray numArgsProvided a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15|

    argArray := argArrayIn.
    (argArray notNil and:[(argArray class ~~ Array) and:[argArray isArray not]]) ifTrue:[
        argArray isCollection ifFalse:[
            ^ self badArgumentArray:argArray
        ].
        argArray := argArray asArray.
    ].

    (argArray size < nargs) ifTrue:[
        ^ self wrongNumberOfArguments:argArray size
    ].
%{
    REGISTER OBJFUNC thecode;
    OBJ home;
    REGISTER OBJ *ap;
    OBJ nA;
    int __numArgsProvided = __intVal(numArgsProvided);

#if defined(THIS_CONTEXT)
    if (__ISVALID_ILC_LNO(__pilc))
            __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
    thecode = __BlockInstPtr(self)->b_code;

    nA = __INST(nargs);

    if (argArray == nil) {
        ap = 0;
    } else {
        ap = __arrayVal(argArray);   /* nonNil after above test (size is known to be ok) */
    }
    if (nA != __mkSmallInteger(0)) {
        ap = __arrayVal(argArray);   /* nonNil after above test (size is known to be ok) */
        switch ((INT)nA) {
            default:
                goto error;
            case (INT)__mkSmallInteger(15):
                a15 = ap[14];
            case (INT)__mkSmallInteger(14):
                a14 = ap[13];
            case (INT)__mkSmallInteger(13):
                a13 = ap[12];
            case (INT)__mkSmallInteger(12):
                a12 = ap[11];
            case (INT)__mkSmallInteger(11):
                a11 = ap[10];
            case (INT)__mkSmallInteger(10):
                a10 = ap[9];
            case (INT)__mkSmallInteger(9):
                a9 = ap[8];
            case (INT)__mkSmallInteger(8):
                a8 = ap[7];
            case (INT)__mkSmallInteger(7):
                a7 = ap[6];
            case (INT)__mkSmallInteger(6):
                a6 = ap[5];
            case (INT)__mkSmallInteger(5):
                a5 = ap[4];
            case (INT)__mkSmallInteger(4):
                a4 = ap[3];
            case (INT)__mkSmallInteger(3):
                a3 = ap[2];
            case (INT)__mkSmallInteger(2):
                a2 = ap[1];
            case (INT)__mkSmallInteger(1):
                a1 = ap[0];
            case (INT)__mkSmallInteger(0):
                break;
        }
    }
    if (thecode != (OBJFUNC)nil) {
        RETURN ( (*thecode)(self, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) );
    }
# ifdef PASS_ARG_POINTER
    RETURN ( __interpret(self, __intVal(nA), nil, nil, nil, nil, &a1) );
# else
    RETURN ( __interpret(self, __intVal(nA), nil, nil, nil, nil, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) );
# endif
error: ;
%}.
    "
     the above code only supports up-to 15 arguments
    "
    ^ ArgumentError
        raiseRequestWith:self
        errorString:'only blocks with up-to 15 arguments supported'


    "
        [:a :b :c | Transcript showCR:a; showCR:b; showCR:c] valueWithOptionalArguments:#(1 2 3 4).
        [:a :b :c | Transcript showCR:a; showCR:b; showCR:c] valueWithOptionalArguments:#(1 2 3 4) asOrderedCollection.
    "
!

valueWithPossibleArguments:argArrayIn
    "evaluate the receiver with arguments as required taken from argArray.
     If argArray provides less than the required number of arguments,
     nil is assumed for any remaining argument.
     (i.e. argArray may be smaller than the required number).
     Only the required number of arguments is taken from argArray or nil;
     (i.e. argArray may be larger than the required number)."

    |argArray numArgsProvided a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15|

    argArray := argArrayIn.
    (argArray notNil and:[(argArray class ~~ Array) and:[argArray isArray not]]) ifTrue:[
        argArray isCollection ifFalse:[
            ^ self badArgumentArray:argArray
        ].
        argArray := argArray asArray.
    ].
    numArgsProvided := argArray size.
%{
    REGISTER OBJFUNC thecode;
    OBJ home;
    REGISTER OBJ *ap;
    OBJ nA;
    int __numArgsProvided = __intVal(numArgsProvided);

#if defined(THIS_CONTEXT)
    if (__ISVALID_ILC_LNO(__pilc))
            __ContextInstPtr(__thisContext)->c_lineno = __ILC_LNO_AS_OBJ(__pilc);
#endif
    thecode = __BlockInstPtr(self)->b_code;

    nA = __INST(nargs);

    if (argArray == nil) {
        ap = 0;
    } else {
        ap = __arrayVal(argArray);   /* nonNil after above test (size is known to be ok) */
    }
    switch (__numArgsProvided) {
        default:
        case 15: a15 = ap[14];
        case 14: a14 = ap[13];
        case 13: a13 = ap[12];
        case 12: a12 = ap[11];
        case 11: a11 = ap[10];
        case 10: a10 = ap[9];
        case 9: a9 = ap[8];
        case 8: a8 = ap[7];
        case 7: a7 = ap[6];
        case 6: a6 = ap[5];
        case 5: a5 = ap[4];
        case 4: a4 = ap[3];
        case 3: a3 = ap[2];
        case 2: a2 = ap[1];
        case 1: a1 = ap[0];
        case 0: ;
    }
    if (thecode != (OBJFUNC)nil) {
        RETURN ( (*thecode)(self, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) );
    }
# ifdef PASS_ARG_POINTER
    RETURN ( __interpret(self, __intVal(nA), nil, nil, nil, nil, &a1) );
# else
    RETURN ( __interpret(self, __intVal(nA), nil, nil, nil, nil, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) );
# endif
error: ;
%}.
    "
     the above code only supports up-to 15 arguments
    "
    ^ ArgumentError
        raiseRequestWith:self
        errorString:'only blocks with up-to 15 arguments supported'

    "
        [:a :b :c :d| Transcript showCR:a; showCR:b; showCR:c; showCR:d] valueWithPossibleArguments:#(1 2 3).
        [:a :b :c :d| Transcript showCR:a; showCR:b; showCR:c; showCR:d] valueWithPossibleArguments:#(1 2 3 4 5).
        [:a :b :c :d| Transcript showCR:a; showCR:b; showCR:c; showCR:d] valueWithPossibleArguments:#(1 2 3) asOrderedCollection.
    "
! !

!Block methodsFor:'exception handling'!

on:aSignalOrSignalSetOrException do:exceptionBlock
    "added for ANSI compatibility; evaluate the receiver,
     handling aSignalOrSignalSetOrException.
     If the signal is raised during evaluation,
     the 2nd argument, exceptionBlock is evaluated (and its value returned"

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ self value. "the real logic is in Exception>>doRaise"

    "
     [
        1 foo
     ] on:MessageNotUnderstood do:[:ex | self halt]

     [
        1 foo
     ] on:(MessageNotUnderstood , AbortOperationRequest) do:[:ex | self halt]

     [
        1 foo
     ] on:SignalSet anySignal do:[:ex| 2 bar. self halt]

     [
        1 foo
     ] on:Error do:[:ex| 2 ]   
    "

    "Modified: / 26.7.1999 / 15:30:48 / stefan"
!

on:aSignalOrSignalSetOrException do:exceptionBlock ensure:ensureBlock
    "added for ANSI compatibility; evaluate the receiver,
     handling aSignalOrSignalSetOrException.
     The 2nd argument, exceptionBlock is evaluated
     if the signal is raised during evaluation.
     The 3rd argument, ensureBlock is evaluated in any case - even if the activity
     was unwound due to an unhandled exception."

    <context: #return>
    <exception: #handle>
    <exception: #unwind>

    |v|

    v := self value.       "the real logic is in Context>>unwind and Exception>>doRaise"
    thisContext unmarkForUnwind.
    ensureBlock value.
    ^ v

    "
     |e|

     e := 0.
     [
	1 foo
     ] on:MessageNotUnderstood
     do:[:ex | self halt]
     ensure:[ e := 1 ].
     self assert:(e == 1).
    "

    "
     |e|

     e := 0.
     [
	1 negated
     ] on:MessageNotUnderstood
     do:[:ex | self halt]
     ensure:[ e := 1 ].
     self assert:(e == 1).
    "
!

on:aSignalOrSignalSetOrException do:exceptionBlock ifCurtailed:curtailBlock
    "evaluate the receiver,
     handling aSignalOrSignalSetOrException.
     The 2nd argument, exceptionBlock is evaluated
     if the signal is raised during evaluation.
     The 3rd argument, curtailBlock is evaluated if the activity
     was unwound due to an unhandled exception in the receiver block
     (but not in the exceptionBlock)."

    <context: #return>
    <exception: #handle>
    <exception: #unwind>

    |v|

    v := self value.       "the real logic is in Context>>unwind and Exception>>doRaise"
    thisContext unmarkForUnwind.
    ^ v

    "
     |e|

     e := 0.
     [
        1 foo
     ] on:MessageNotUnderstood
     do:[:ex | e := 1]
     ifCurtailed:[ e := 2 ].
     self assert:(e == 1).
    "

    "
     abort the debugger to perform the ifCurtailedBlock...
     continue the debugger to go to the end   

     |e|

     e := 0.
     [
        #[] at:2
     ] on:MessageNotUnderstood
     do:[:ex | e := 1]
     ifCurtailed:[ e := 2. e inspect ].
     self assert:(e == 0).
    "

    "
     |e|

     e := 0.
     [
        1 negated
     ] on:MessageNotUnderstood
     do:[:ex | self halt]
     ifCurtailed:[ e := 1 ].
     self assert:(e == 0).
    "
!

on:anExceptionHandler do:exceptionBlock on:anExceptionHandler2 do:anExceptionBlock2
    "added for ANSI compatibility; evaluate the receiver,
     handling aSignalOrSignalSetOrException.
     The 2nd argument, exceptionBlock is evaluated
     if the signal is raised during evaluation."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ self value. "the real logic is in Exception>>doRaise"

    "
     [
	1 foo
     ] on:MessageNotUnderstood do:[:ex | self halt:'Got MessageNotUnderstood']
       on:Error do:[:ex| self halt:'Got Error']

     [
	1 // 0
     ] on:MessageNotUnderstood do:[:ex | self halt:'Got MessageNotUnderstood']
       on:Error do:[:ex| self halt:'Got Error']
    "

    "Modified: / 26.7.1999 / 15:30:48 / stefan"
!

valueWithExceptionHandler:handler
    "evaluate myself. If any of the signals in handler is raised,
     evaluate the corresponding handler block."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ self value. "the real logic is in Exception>>doRaise"

    "Created: / 26.7.1999 / 11:23:45 / stefan"
    "Modified: / 26.7.1999 / 11:24:06 / stefan"
!

valueWithTimeout:aTimeDurationOrIntegerSeconds
    "execute the receiver, but abort the evaluation after aTimeDuration if still running.
     Return the receiver's value, or nil if aborted."

    |milliseconds|

    milliseconds := aTimeDurationOrIntegerSeconds isTimeDuration
                        ifTrue:[ aTimeDurationOrIntegerSeconds asMilliseconds ]
                        ifFalse:[ (aTimeDurationOrIntegerSeconds * 1000) truncated].
    ^ self valueWithWatchDog:[^ nil] afterMilliseconds:milliseconds

    "
     [
        1 to:15 do:[:round |
            Transcript showCR:round.
            Delay waitForMilliseconds:20.
        ].
        true
     ] valueWithTimeout:(TimeDuration seconds:1)
    "

    "
     [
        1 to:100 do:[:round |
            Transcript showCR:round.
            Delay waitForMilliseconds:20.
        ].
        true
     ] valueWithTimeout:(TimeDuration seconds:1)
    "
!

valueWithWatchDog:exceptionBlock afterMilliseconds:aTimeLimit
    "a watchdog on a block's execution. If the block does not finish its
     evaluation after aTimeLimit milliseconds, it is interrupted (aborted) and
     exceptionBlock's value is returned. The receiver's code must be prepared
     for premature returning (by adding ensure blocks, as required)"

    |showStopper me retVal done inError|

    done := false.
    me := Processor activeProcess.

    showStopper :=
	[
	    done ifFalse:[
		me interruptWith:[
		    (Processor activeProcess state ~~ #debug) ifTrue:[
			done ifFalse:[ TimeoutNotification raiseRequest ]
		    ]
		]
	    ]
	].

    TimeoutNotification handle:[:ex |
	inError ifTrue:[
	    ex proceed
	].
	retVal := exceptionBlock value.
    ] do:[
	NoHandlerError handle:[:ex |
	    inError := true.
	    ex reject.
	] do:[
	    [
		Processor
		    addTimedBlock:showStopper
		    for:me
		    afterMilliseconds:aTimeLimit.

		retVal := self value.
		done := true.
	    ] ensure:[
		Processor removeTimedBlock:showStopper
	    ].
	]
    ].
    ^ retVal

    "
     [
	Delay waitForSeconds:5.
	true
     ] valueWithWatchDog:[false] afterMilliseconds:2000
    "

    "Modified: / 21-05-2010 / 12:19:57 / sr"
    "Modified: / 18-01-2011 / 19:24:13 / cg"
! !

!Block methodsFor:'exception handling private'!

exceptionHandlerFor:anException in:aContext
    "answer the exceptionHandler (the Error or signal) for anException from aContext."

    aContext selector == #on:do:on:do: ifTrue:[
	|exceptionCreator exceptionHandlerInContext|

	exceptionCreator := anException creator.
	exceptionHandlerInContext := aContext argAt:1.
	exceptionHandlerInContext isExceptionHandler ifFalse:[
	    exceptionHandlerInContext isNil ifTrue:[
		'Block [warning]: nil ExceptionHandler in on:do:on:do:-context' errorPrintCR.
	    ] ifFalse:[
		(exceptionHandlerInContext isBehavior
		and:[exceptionHandlerInContext isLoaded not]) ifTrue:[
		    "If the exception class is still autoloaded,
		     it does not accept our exception. Raising the exception would load the class"
		    ^ nil
		] ifFalse:[
		    'Block [warning]: non-ExceptionHandler in on:do:on:do:-context' errorPrintCR.
		]
	    ].
	    aContext fullPrintString errorPrintCR.
	    self breakPoint:#cg.
	    ^ nil.
	].
	(exceptionHandlerInContext accepts:exceptionCreator) ifTrue:[
	    ^ exceptionHandlerInContext.
	].

	exceptionHandlerInContext := aContext argAt:3.
	exceptionHandlerInContext isExceptionHandler ifFalse:[
	    exceptionHandlerInContext isNil ifTrue:[
		'Block [warning]: nil ExceptionHandler in on:do:on:do:-context' errorPrintCR.
	    ] ifFalse:[
		(exceptionHandlerInContext isBehavior
		and:[exceptionHandlerInContext isLoaded not]) ifTrue:[
		    "If the exception class is still autoloaded,
		     it does not accept our exception. Raising the exception would load the class"
		    ^ nil
		] ifFalse:[
		    'Block [warning]: non-ExceptionHandler in on:do:on:do:-context' errorPrintCR.
		]
	    ].
	    aContext fullPrintString errorPrintCR.
	    self breakPoint:#cg.
	    ^ nil.
	].
	(exceptionHandlerInContext accepts:exceptionCreator) ifTrue:[
	    ^ exceptionHandlerInContext.
	].
	^ nil.
    ].

    "aContext selector must be #on:do: , #on:do:ensure: or #valueWithExceptionHandler:"
    ^ aContext argAt:1.
!

handlerForSignal:exceptionCreator context:theContext originator:originator
    "answer the handler block for the exceptionCreator from originator.
     The handler block is retrieved from aContext.
     Answer nil if the exceptionCreator is not handled."

    |selector exceptionHandlerInContext|

    selector := theContext selector.

    (selector == #on:do:
     or:[ selector == #on:do:ensure: 
     or:[ selector == #on:do:ifCurtailed: ]]
     ) ifTrue:[
        exceptionHandlerInContext := theContext argAt:1.
        exceptionHandlerInContext isExceptionHandler ifFalse:[
            exceptionHandlerInContext isNil ifTrue:[
                'Block [warning]: nil ExceptionHandler in on:do:on:do:-context' errorPrintCR.
            ] ifFalse:[(exceptionHandlerInContext isBehavior
                        and:[exceptionHandlerInContext isLoaded not]) ifTrue:[
                "If the exception class is still autoloaded,
                 it does not accept our exception. Raising the exception would load the class"
                ^ nil
            ] ifFalse:[
                'Block [warning]: non-ExceptionHandler in on:do:-context' errorPrintCR.
            ]].
            theContext fullPrint.
            ^ nil.
        ].
        (exceptionHandlerInContext == exceptionCreator
         or:[exceptionHandlerInContext accepts:exceptionCreator]) ifTrue:[
            selector == #on:do:ifCurtailed: ifTrue:[
                theContext unmarkForUnwind.     "if there is a handler, no unwind block has to be performed"
            ].
            ^ (theContext argAt:2) ? [nil].
        ].
        ^ nil
    ].

    selector == #on:do:on:do: ifTrue:[
        exceptionHandlerInContext := theContext argAt:1.
        exceptionHandlerInContext isExceptionHandler ifFalse:[
            exceptionHandlerInContext isNil ifTrue:[
                'Block [warning]: nil ExceptionHandler in on:do:on:do:-context' errorPrintCR.
            ] ifFalse:[(exceptionHandlerInContext isBehavior
                        and:[exceptionHandlerInContext isLoaded not]) ifTrue:[
                "If the exception class is still autoloaded,
                 it does not accept our exception. Raising the exception would load the class"
                ^ nil
            ] ifFalse:[
                'Block [warning]: non-ExceptionHandler in on:do:on:do:-context' errorPrintCR.
            ]].
            theContext fullPrint.
            ^ nil.
        ].
        (exceptionHandlerInContext == exceptionCreator
         or:[exceptionHandlerInContext accepts:exceptionCreator]) ifTrue:[
            ^ (theContext argAt:2) ? [nil].
        ].

        exceptionHandlerInContext := theContext argAt:3.
        exceptionHandlerInContext isExceptionHandler ifFalse:[
            exceptionHandlerInContext isNil ifTrue:[
                'Block [warning]: nil ExceptionHandler in on:do:on:do:-context' errorPrintCR.
            ] ifFalse:[(exceptionHandlerInContext isBehavior
                        and:[exceptionHandlerInContext isLoaded not]) ifTrue:[
                "If the exception class is still autoloaded,
                 it does not accept our exception. Raising the exception would load the class"
                ^ nil
            ] ifFalse:[
                'Block [warning]: non-ExceptionHandler in on:do:on:do:-context' errorPrintCR.
            ]].
            theContext fullPrint.
            ^ nil.
        ].
        (exceptionHandlerInContext == exceptionCreator
         or:[exceptionHandlerInContext accepts:exceptionCreator]) ifTrue:[
            ^ (theContext argAt:4) ? [nil].
        ].
        ^ nil
    ].

    selector == #valueWithExceptionHandler: ifTrue:[
        ^ (theContext argAt:1) handlerForSignal:exceptionCreator.
    ].

    "/ mhmh - should not arrive here
    ^ nil

    "Created: / 25.7.1999 / 19:52:58 / stefan"
    "Modified: / 26.7.1999 / 14:30:42 / stefan"
!

handlerProtectedBlock:doBlock inContext:context
    "set the block that is protected by an exception handler in context.
     This is the receiver of the #on:do: or #valueWithExceptionHandler:.
     Needed for #restartDo:"

    context receiver:doBlock

    "
      [1/0] on:Error do:[:ex| ex restartDo:[55]]
    "
! !


!Block methodsFor:'looping'!

doUntil:aBlock
    "repeat the receiver block until aBlock evaluates to true.
     The receiver is evaluated at least once.
     This is the same as '... doWhile:[... not]' "

    "this implementation is for purists ... :-)"

    self value.
    aBlock value ifTrue:[^ nil].
    thisContext restart

    "
     |n|

     n := 1.
     [n printCR] doUntil:[ (n := n + 1) > 5 ]
    "
!

doWhile:aBlock
    "repeat the receiver block until aBlock evaluates to false.
     The receiver is evaluated at least once."

    "this implementation is for purists ... :-)"

    self value.
    aBlock value ifFalse:[^ nil].
    thisContext restart

    "
     |n|

     n := 1.
     [n printCR] doWhile:[ (n := n + 1) <= 5 ]
    "
!

loop
    "repeat the receiver forever
     (the receiver block should contain a return somewhere).
     The implementation below was inspired by a corresponding Self method."

    self value.
    thisContext restart

    "
     |n|

     n := 1.
     [
	n printCR.
	n >= 10 ifTrue:[^ nil].
	n := n + 1
     ] loop
    "

    "Modified: 18.4.1996 / 13:50:40 / cg"
!

loopWithExit
    "the receiver must be a block of one argument.  It is evaluated in a loop forever,
     and is passed a block, which, if sent a value:-message, will exit the receiver block,
     returning the parameter of the value:-message. Used for loops with exit in the middle.
     Inspired by a corresponding Self method."

    |exitBlock|

    exitBlock := [:exitValue | ^ exitValue].
    [self value:exitBlock] loop.

    "
     |i|
     i := 1.
     [:exit |
	Transcript showCR:i.
	i == 5 ifTrue:[exit value:'thats it'].
	i := i + 1
     ] loopWithExit
    "
!

repeat
    "repeat the receiver forever - same as loop, for ST-80 compatibility.
      (the receiver block should contain a return somewhere)."

    self value.
    thisContext restart

    "Modified: 18.4.1996 / 13:50:55 / cg"
!

repeat:n
    "repeat the receiver n times - similar to timesRepeat, but optionally passes the
     loop counter as argument"

    self argumentCount == 0 ifTrue:[
        n timesRepeat:self
    ] ifFalse:[
        1 to:n do:self
    ].

    "
      [ Transcript showCR:'hello' ] repeat:3
      [:i | Transcript showCR:'hello',i printString ] repeat:3
    "
!

valueWithExit
    "the receiver must be a block of one argument.  It is evaluated, and is passed a block,
     which, if sent a value:-message, will exit the receiver block, returning the parameter of the
     value:-message. Used for premature returns to the caller.
     Taken from a manchester goody (a similar construct also appears in Self)."

    ^ self value:[:exitValue | ^exitValue]

    "
     [:exit |
	1 to:10 do:[:i |
	    Transcript showCR:i.
	    i == 5 ifTrue:[exit value:'thats it']
	].
	'regular block-value; never returned'
     ] valueWithExit
    "

    "Modified: 18.4.1996 / 13:51:38 / cg"
!

valueWithRestart
    "the receiver must be a block of one argument.  It is evaluated, and is passed a block,
     which, if sent a value-message, will restart the receiver block from the beginning"

    |myContext restartAction|

    myContext := thisContext.
    restartAction := [ myContext unwindAndRestart ].
    ^ self value:restartAction.

    "
     [:restart |
	(self confirm:'try again ?') ifTrue:[
	    restart value.
	]
     ] valueWithRestart
    "

    "Modified: / 25.1.2000 / 21:47:50 / cg"
!

valueWithRestartAndExit
    "the receiver must be a block of two arguments, a restart and an exit block.
     See description of valueWithExit and valueWithRestart for their use"

    |myContext restartAction|

    myContext := thisContext.
    restartAction := [ myContext unwindAndRestart ].
    ^ self value:restartAction value:[:exitValue | ^exitValue].

    "
     [:restart :exit |
	|i|

	i := 0.
	[
	    i := i + 1.
	    (self confirm:('i is ',i printString,'; start over ?')) ifTrue:[
		restart value.
	    ].
	    (self confirm:'enough ?') ifTrue:[
		exit value:nil.
	    ].
	] loop
     ] valueWithRestartAndExit
    "
!

whileFalse
    "evaluate the receiver while it evaluates to false (ST80 compatibility)"

    "this implementation is for purists ... :-)"

    self value ifTrue:[^ nil].
    thisContext restart

    "
     |n|

     n := 1.
     [n printCR. (n := n + 1) > 10] whileFalse
    "
!

whileFalse:aBlock
    "evaluate the argument, aBlock while the receiver evaluates to false.
     - usually open coded by compilers, but needed here for #perform
       and expression evaluation."

    "this implementation is for purists ... :-)"

    self value ifTrue:[^ nil].
    aBlock value.
    thisContext restart

    "
     |n|

     n := 1.
     [n > 10] whileFalse:[
	n printCR.
	n := n + 1
     ]
    "
!

whileTrue
    "evaluate the receiver while it evaluates to true (ST80 compatibility)"

    "this implementation is for purists ... :-)"

    self value ifFalse:[^ nil].
    thisContext restart

    "
     |n|

     n := 1.
     [n printCR. (n := n + 1) <= 10] whileTrue
    "
!

whileTrue:aBlock
    "evaluate the argument, aBlock while the receiver evaluates to true.
     - usually open coded by compilers, but needed here for #perform
       and expression evaluation."

    "this implementation is for purists ... :-)"

    self value ifFalse:[^ nil].
    aBlock value.
    thisContext restart

    "
     |n|

     n := 1.
     [n <= 10] whileTrue:[
	n printCR.
	n := n + 1
     ]
    "
! !

!Block methodsFor:'parallel evaluation'!

futureValue
    "Fork a synchronised evaluation of myself.
     Starts the evaluation in parallel now, but synchronizes
     any access to wait until the result is computed."

    ^ Future new block:self
!

futureValue:aValue
    "Fork a synchronised evaluation of myself.
     Starts the evaluation in parallel now, but synchronizes
     any access to wait until the result is computed."

    ^ Future new block:self value:aValue
!

futureValue:aValue value:anotherValue
    "Fork a synchronised evaluation of myself.
     Starts the evaluation in parallel now, but synchronizes
     any access to wait until the result is computed."

    ^ Future new
	block:self
	value:aValue
	value:anotherValue
!

futureValue:aValue value:anotherValue value:bValue
    "Fork a synchronised evaluation of myself.
     Starts the evaluation in parallel now, but synchronizes
     any access to wait until the result is computed."

    ^ Future new
	block:self
	value:aValue
	value:anotherValue
	value:bValue
!

futureValueWithArguments:anArray
    "Fork a synchronised evaluation of myself.
     Starts the evaluation in parallel now, but synchronizes
     any access to wait until the result is computed."

    ^ Future new
	block:self
	valueWithArguments:anArray

    "Modified (format): / 04-10-2011 / 14:55:40 / cg"
!

lazyValue
    "Fork a synchronised evaluation of myself. Only starts
     the evaluation when the result is requested."

    ^ Lazy new block:self
!

lazyValue:aValue
    "Fork a synchronised evaluation of myself. Only starts
     the evaluation when the result is requested."

    ^ Lazy new block:self value:aValue
!

lazyValue:aValue value:anotherValue
    "Fork a synchronised evaluation of myself. Only starts
     the evaluation when the result is requested."

    ^ Lazy new
	block:self
	value:aValue
	value:anotherValue
!

lazyValue:aValue value:anotherValue value:bValue
    "Fork a synchronised evaluation of myself. Only starts
     the evaluation when the result is requested."

    ^ Lazy new
	block:self
	value:aValue
	value:anotherValue
	value:bValue
!

lazyValueWithArguments:anArray
    "Fork a synchronised evaluation of myself. Only starts
     the evaluation when the result is requested."

    ^ Lazy new block:self valueWithArguments:anArray
! !

!Block methodsFor:'printing & storing'!

printBlockBracketsOn:aStream
    aStream nextPutAll:'[]'.
!

printOn:aStream
    "append a a printed representation of the block to aStream"

    |h sel methodClass|

    "cheap blocks have no home context, but a method instead"

    (home isNil or:[home isContext not]) ifTrue:[
	aStream nextPutAll:'[] in '.

	"
	 currently, some cheap blocks don't know where they have been created
	"
	aStream nextPutAll:' ??? (optimized)'.
	^ self
    ].

    "a full blown block (with home, but without method)"
    self printBlockBracketsOn:aStream.
    aStream nextPutAll:' in '.
    h := self methodHome.
    sel := h selector.
"/ old:
"/    home receiver class name printOn:aStream.
"/ new:
"/    (h searchClass whichClassImplements:sel) name printOn:aStream.
    methodClass := h methodClass.
    methodClass isNil ifTrue:[
	'UnboundMethod' printOn:aStream.
    ] ifFalse:[
	methodClass name printOn:aStream.
    ].
    aStream nextPutAll:'>>'.
    sel printOn:aStream.

"/
"/    aStream nextPutAll:'[] in '.
"/    homeClass := home containingClass.
"/    homeClass notNil ifTrue:[
"/      homeClass name printOn:aStream.
"/      aStream space.
"/      (homeClass selectorForMethod:home) printOn:aStream
"/    ] ifFalse:[
"/      aStream nextPutAll:' ???'
"/    ]
"/
!

storeOn:aStream
    MethodNotAppropriateError raiseRequestErrorString:'Blocks cannot be stored (yet)'.
    self printOn:aStream.
! !

!Block methodsFor:'private-accessing'!

byteCode:bCode numArgs:numArgs numVars:numVars  numStack:numStack sourcePosition:srcPos initialPC:iPC literals:lits
    "set all relevant internals.
     DANGER ALERT: this interface is strictly private."

    byteCode := bCode.
    nargs := numArgs.
    sourcePos := srcPos.
    initialPC := iPC.
    flags := 0.
    self stackSize:numStack.
    self literals:lits.
    self numberOfArgs:numArgs.   "/ must set the compiledCode flags as well
    self numberOfVars:numVars.   "/ must set the compiledCode flags as well

    "Modified: 23.4.1996 / 16:05:30 / cg"
    "Modified: 24.6.1996 / 12:37:37 / stefan"
    "Created: 13.4.1997 / 00:00:57 / cg"
!

initialPC
    "return the initial pc for evaluation."

    ^ initialPC
!

initialPC:initial
    "set the initial pc for evaluation.
     DANGER ALERT: this interface is for the compiler only."

    initialPC := initial

    "Modified: 23.4.1996 / 16:05:39 / cg"
!

numArgs:numArgs
    "set the number of arguments the receiver expects for evaluation.
     DANGER ALERT: this interface is for the compiler only."

    nargs := numArgs

    "Modified: 23.4.1996 / 16:05:52 / cg"
!

setHome:aContext
    home := aContext
!

source
    |m|

    sourcePos isString ifTrue:[    "/ misuses the sourcePosition slot
	^ sourcePos
    ].
    m := self method.
    m notNil ifTrue:[
	^ m source
    ].
    ^ nil
!

source:aString
    "set the source - only to be used, if the block is not contained in a method.
     This interface is for knowledgable users only."

    sourcePos := aString  "/ misuse the sourcePosition slot
!

sourcePosition
    "Returns the source position withing method's source.
     The position is 1-based offset of opening bracket.
     If the source position is not known (because of lack of
     support in compiler and/or virtual machine or anut other 
     reason, nil is returned"

    ^ sourcePos

    "Created: / 01-06-2015 / 13:05:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!   

sourcePosition:position
    "set the position of the source within my method.
     This interface is for the compiler only."

    sourcePos := position

    "Modified: 23.4.1996 / 16:06:19 / cg"
! !

!Block methodsFor:'privileged evaluation'!

valueUninterruptably
    "evaluate the receiver with interrupts blocked.
     This does not prevent preemption by a higher priority processes
     if any becomes runnable due to the evaluation of the receiver
     (i.e. if a semaphore is signalled)."

    "we must keep track of blocking-state if this is called nested"
    (OperatingSystem blockInterrupts) ifTrue:[
	"/ already blocked.
	^ self value
    ].

    ^ self ensure:[OperatingSystem unblockInterrupts].
!

valueUnpreemptively
    "evaluate the receiver without the possiblity of preemption
     (i.e. at a very high priority)"

    |oldPrio activeProcess|

    activeProcess := Processor activeProcess.
    oldPrio := activeProcess changePriority:(Processor highestPriority).
    ^ self ensure:[
	activeProcess priority:oldPrio
    ]
! !

!Block methodsFor:'process creation'!

fork
    "create a new process executing the receiver at the current priority."

    ^ self newProcess resume
!

forkAt:priority
    "create a new process executing the receiver at a different priority."

    ^ (self newProcess priority:priority) resume
!

forkNamed:aString
    "create a new process, give it a name and let it start
     executing the receiver at the current priority."

    ^ self newProcess
        name:aString;
        resume;
        yourself.

    "Modified: / 27-01-2017 / 18:10:16 / stefan"
!

forkWith:argArray
    "create a new process executing the receiver,
     passing elements in argArray as arguments to the receiver block."

    ^ [self valueWithArguments:argArray] fork.
!

newProcess
    "create a new (unscheduled) process executing the receiver"

    ^ Process for:self priority:(Processor activePriority)
!

newProcessWithArguments:argArray
    "create a new (unscheduled) process executing the receiver,
     passing the elements in argArray as arguments to the receiver block."

    ^ [self valueWithArguments:argArray] newProcess
!

promise
    "create a promise on the receiver. The promise will evaluate the
     receiver and promise to return the value with the #value message.
     The evaluation will be performed as a separate process.
     Asking the promise for its value will either block the asking process
     (if the evaluation has not yet been finished) or return the value
     immediately."

    ^ Promise value:self

    "
     |p|

     p := [1000 factorial] promise.
     'do something else ...'.
     p value
    "
!

promiseAt:prio
    "create a promise on the receiver. The promise will evaluate the
     receiver and promise to return the value with the #value message.
     The evaluation will be performed as a separate process running at prio.
     Asking the promise for its value will either block the asking process
     (if the evaluation has not yet been finished) or return the value
     immediately."

    ^ Promise value:self priority:prio
! !

!Block methodsFor:'testing'!

isBlock
    "return true, if this is a block - yes I am"

    ^ true
!

isCheapBlock
    ^ false
!

isVarArgBlock
    "return true, if this block accepts a variable number of arguments"

    ^ false

    "Created: 23.1.1997 / 04:59:51 / cg"
! !

!Block methodsFor:'unwinding'!

unwindHandlerInContext:aContext
    "given a context which has been marked for unwind,
     retrieve the handler block.
     This avoids hardwiring access to the first argument in
     #unwind methods (and theoretically allows for other unwinding
     methods to be added)"

    |selector|

    selector := aContext selector.
    selector == #'value:onUnwindDo:' ifTrue:[
        ^ aContext argAt:2
    ].
    (selector == #'on:do:ensure:'
     or:[selector == #'on:do:ifCurtailed:'])ifTrue:[
        ^ aContext argAt:3
    ].

    "/ for now, only #valueNowOrOnUnwindDo:
    "/          or   #valueOnUnwindDo:
    "/          or   #ensure:
    "/          or   #ifCurtailed:

    ^ aContext argAt:1
! !

!Block methodsFor:'unwinding-old'!

value:arg onUnwindDo:aBlock
    "evaluate the receiver, passing it one argument
     - when some method sent within unwinds (i.e. does
     a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions (for example closing files etc.) are
     executed regardless of error actions"

    <exception: #unwind>

    |v|

    "/ thisContext markForUnwind. -- same as above pragma
    v := self value:arg.       "the real logic is in Context>>unwind"
    thisContext unmarkForUnwind.
    ^ v

    "
     |s|

     s := 'Makefile' asFilename readStream.
     [:arg |
	^ self
     ] value:12345 onUnwindDo:[
	Transcript showCR:'closing the stream - even though a return occurred'.
	s close
     ]
    "
    "
     [
	 |s|

	 s := 'Makefile' asFilename readStream.
	 [:arg |
	    Processor activeProcess terminate
	 ] value:12345 onUnwindDo:[
	    Transcript showCR:'closing the stream - even though process was terminated'.
	    s close
	 ]
     ] fork
    "

!

valueNowOrOnUnwindDo:aBlock
    "evaluate the receiver - after that, or when some method sent within unwinds (i.e. does
     a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions (for example closing files etc.) are
     executed regardless of error actions.
     Same as the more modern, ANSI standardized #ensure:, 
     which should be used instead for portability."

    <exception: #unwind>

    |v|

    "/ thisContext markForUnwind. -- same as above pragma
    v := self value.       "the real logic is in Context>>unwind"
    thisContext unmarkForUnwind.
    aBlock value.
    ^ v

    "
     in the following example, f will be closed even if the block
     returns with 'oops'. There are many more applications of this kind
     found in the system.
    "
    "
     |f|

     f := 'Makefile' asFilename readStream.
     [
        l := f nextLine.
        l isNil ifTrue:[^ 'oops']
     ] valueNowOrOnUnwindDo:[
        f close
     ]
    "

    "Modified: 16.4.1996 / 11:05:26 / stefan"
!

valueOnUnwindDo:aBlock
    "evaluate the receiver - when some method sent within unwinds (i.e. does
     a long return), evaluate the argument, aBlock.
     This is used to make certain that cleanup actions (for example closing files etc.) are
     executed regardless of error actions.
     Same as the more modern, ANSI standardized #ifCurtailed:, 
     which should be used instead for portability."

    <exception: #unwind>

    |v|

    "/ thisContext markForUnwind. -- same as above pragma
    v := self value.       "the real logic is in Context>>unwind"
    thisContext unmarkForUnwind.
    ^ v

    "
     |s|

     s := 'Makefile' asFilename readStream.
     [
        ^ self
     ] valueOnUnwindDo:[
        Transcript showCR:'closing the stream - even though a return occurred'.
        s close
     ]
    "
    "
     [
         |s|

         s := 'Makefile' asFilename readStream.
         [
            Processor activeProcess terminate
         ] valueOnUnwindDo:[
            Transcript showCR:'closing the stream - even though process was terminated'.
            s close
         ]
     ] fork
    "
! !

!Block methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitBlock:with: to aVisitor"

    ^ aVisitor visitBlock:self with:aParameter
! !

!Block class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Block initialize!

"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2015-2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No t itle to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object variableSubclass:#Context
	instanceVariableNames:'flags sender* home receiver selector searchClass method lineNr
		retvalTemp handle*'
	classVariableNames:'SingleStepInterruptRequest'
	poolDictionaries:''
	category:'Kernel-Methods'
!

!Context class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2011 Jan Vrany
 COPYRIGHT (c) 2015-2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No t itle to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Contexts represent the stack frame objects, which keep the processing
    state of a method or block (i.e. its local variables, temporaries etc.)
    Every message send adds a context to a chain, which can be traced back via
    the sender field. The context of the currently active method is always
    accessible via the pseuodoVariable called 'thisContext'.
    The actual implementation uses the machines stack for this, building real
    contexts on demand only, whenever a contexts is needed. Also, initially these are
    allocated on the stack and only moved to the heap, when a context outlives its
    activation.

    For both method- and block-contexts, the layout is the same.
    For method contexts, the home-field is nil, while for block contexts the home-
    field is either the context of its surrounding block (i.e. the context of the
    block, in which the receiving block was created, if its a nested block) or of
    its home method.

    Cheap blocks are blocks which do not refer to any locals or the receiver (currently),
    but only access globals, class vars or arguments (for example: [:a :b | a < b] is a cheap block).
    Cheap blocks do not need a home and therefore never require that their home context be moved
    to the heap. Contexts of cheap blocks do not have a home context - their home field is also nil.

    LineNumbers vs. program counter:

    Due to the compilation to machine code, methods and/or block do not
    always (actually: do seldom) contain bytecodes. Thus, there is no such concept
    as a bytecode p-counter. To support debugging, the linenumber within the
    original source is instead remembered when a send or loop entry is performed.
    Since linenumbers are not always sufficient for debugging (multiple sends in one
    line), this may be changed in future versions to a character offset, giving
    the position of the selector in the source.

    Restartable / Returnable contexts:

    In previous versions (up to ST/X 2.10.5), every method stored enough
    information in the context for that one to be restartable later (for example,
    via the debugger's restart button). As stc is supposed to generate portable C-code,
    this means that technically, a setjmp needs to be done at the beginning of the method
    in order to have a resumable (and portable) state (however, inline asm code does this setjmp,
    so it is much faster than the libc-setjmo, which stores a lot of additional state, not needed here).
    With 2.10.6, this is now an stc-compiler option, and the system as delivered is compiled
    to only create restartable contexts for those which contain blocks or are marked as special
    via a directive.
    This resulted in an overall speedup of roughly 10-20% percent, depending on the type of CPU.
    However, it makes most methods non-restartable (however, abort, signal handling and unwind blocks
    work as usual).
    In practice, this was reported to be not a severe limitation and all users were happy
    to trade the increased performance for that slight inconvenience.
    (during development, this is seldom a problem, since interpreted methods are always
     returnable and restartable)
    If you do not like this, you should recompile all classes with stc's '-optContext' flag.

    Resuming contexts:

    Strictly speaking, ST/X does not support a context to be resumed (because the setjmp is
    not done on the caller side, but in the callee).
    However, it does support a forced return (i.e. non-local-return) from a context.
    Thus, resume of a context is implemented by forcing a return from the context
    which was created by the method called from the first one. The effect is the same.

    Returning from a dead method:

    Block-return from an outlived context (i.e. its home method has already returned)
    is now rewarded by an invalidReturn exception - it used to be a noop in previous
    releases. The blue book described this to be a noop, but other Smalltalk implementations
    changed this to be an invalid operation - a good decision, as it makes debugging much easier.


    [instance variables:]
        flags       <SmallInteger>          used by the VM; never touch.
                                            contains info about number of args,
                                            locals and temporaries.

        sender      <Context>               the 'calling / sending' context
                                            This is not directly accessible, since it may
                                            be a lazy context (i.e. an empty frame).
                                            The #sender method cares for this.

        home        <Context>               the context, where this block was
                                            created, or nil if its a method context
                                            There are also cheap blocks, which do
                                            not need a reference to the home context,
                                            for those, its nil too.

        receiver    <Object>                the receiver of this message

        selector    <Symbol>                the selector of this message

        searchClass <Class>                 the class, where the message lookup started
                                            (for super sends) or nil, for regular sends.

        lineNr      <SmallInteger>          the position where the context left off
                                            (kind of p-counter). Only the low 16bits
                                             are valid.

        retValTemp  nil                     temporary - always nil, when you see the context
                                            (used in the VM as temporary)

        handle      *noObject*              used by the VM; not accessible, not an object

        method                              the corresponding method

        <indexed>                           arguments of the send followed by
                                            locals of the method/block followed by
                                            temporaries.

    [errors:]
        CannotReturnError                   raised when a block tries
                                            to return ('^') from a method context
                                            which itself has already returned
                                            (i.e. there is no place to return to)

    WARNING: layout and size known by the compiler and runtime system - do not change.


    [author:]
        Claus Gittinger

    [see also:]
        Block Process Method
        ( contexts, stacks & unwinding : programming/contexts.html)
"
! !

!Context class methodsFor:'initialization'!

initialize
    CannotReturnError notifierString:'invalid return; method cannot return twice'.
    CannotResumeError notifierString:'invalid resume'.

    SingleStepInterruptRequest isNil ifTrue:[
	SingleStepInterruptRequest := QuerySignal new.
	SingleStepInterruptRequest nameClass:self message:#singleStepInterruptRequest.
	SingleStepInterruptRequest notifierString:'single step'.
    ]

    "Modified: 6.5.1996 / 16:46:03 / cg"
! !

!Context class methodsFor:'Signal constants'!

cannotResumeSignal
    "return the signal used when a method is tried to be resumed, which cannot"

    ^ CannotResumeError
!

cannotReturnSignal
    "return the signal used when a method is tried to be returned twice
     or, when some dead context is unwound or restarted."

    ^ CannotReturnError
!

invalidReturnSignal
    "return the signal used when a method is tried to be returned twice
     or, when some dead context is unwound or restarted."

    <resource: #obsolete>
    self obsoleteMethodWarning:'use #cannotReturnSignal'.
    ^ self cannotReturnSignal.
!

singleStepInterruptRequest
    "return the dummy query signal to ask for single stepping"

    ^ SingleStepInterruptRequest

    "Created: 6.5.1996 / 16:46:32 / cg"
! !

!Context class methodsFor:'error handling'!

showWhereWeCameFrom
    "show the stack backtrace: at least 4 levels, or until the first
     send to a non-collection object (because we want to know,
     which non-collection send invoked a bad collection-method)."

    |con count|

    con := thisContext sender sender.
    count := 0.
    [
	('    from ' , con printString) errorPrintCR.
	con := con sender.
	count := count + 1.
    ] doWhile:[con notNil and:[count < 5 or:[con receiver isCollection]]].
    "/ one more
    con notNil ifTrue:[
	('    from ' , con printString) errorPrintCR.
    ].

    "
      #() asSet add:nil
    "
! !

!Context class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned."

    ^ true

    "Modified: 23.4.1996 / 15:58:00 / cg"
! !

!Context class methodsFor:'special searching'!

findFirstSpecialHandle:searchForHandle raise:searchForRaise
    |c|

%{
#ifdef __SCHTEAM__
    c = __c__.currentContinuation.sender();
    if (c == null) c = STObject.Nil;
#else
    OBJ __c__;

    __c__ = __ContextInstPtr(__thisContext)->c_sender;
    if (!__isNonNilObject(__c__)) {
	RETURN(nil)
    }
    if (__isLazy(__c__)) {
	__PATCHUPCONTEXT(__c__);
    }
    c = __c__;
#endif
%}.
    ^ c findSpecialHandle:searchForHandle raise:searchForRaise
! !

!Context methodsFor:'Compatibility-Squeak'!

longStack
    ^ self fullPrintAllString
! !

!Context methodsFor:'Compatibility-VW'!

resumeWith:value
    "same as #resume: - visualWorks compatibility"

    self resume:value
! !

!Context methodsFor:'accessing'!

arg1Index
    "return the index of the 1st arg (redefined in JavaContext)"

    ^ 1
!

argAt:n
    "return the n'th argument"

    n > self argumentCount ifTrue:[
        ^ self subscriptBoundsError:n.
    ].
    ^ self at:n

    "Modified: 12.10.1996 / 21:44:28 / cg"
!

argAt:n put:value
    "set the n'th argument - useful when the receiver should be restarted"

    n > self argumentCount ifTrue:[
        ^ self subscriptBoundsError:n.
    ].
    self at:n put:value.
    ^ value

    "Modified: 12.10.1996 / 21:44:32 / cg"
!

args
    "return an array filled with the arguments of this context"

    |n|

    n := self argumentCount.
    n == 0 ifTrue:[
        "/ little optimization here - avaoid creating empty containers
        ^ #()
    ].
    ^ (Array new:n) replaceFrom:1 to:n with:self.
!

argsAndVars
    "return an array filled with the arguments and variables of this context"

    |n|

    n := self argumentCount + self numVars.
    n == 0 ifTrue:[
        "/ little optimization here - avoid creating empty containers
        ^ #()
    ].
    ^ (Array new:n) replaceFrom:1 to:n with:self.

    "Modified: 23.10.1996 / 16:19:41 / cg"
!

argumentCount
    "ANSI alias for numArgs: return the number of arguments to the Block/Method"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STInteger._new( self.asSTContinuation().numStArgs() ) );
#else
    RETURN ( __mkSmallInteger( (__intVal(__INST(flags)) >> __NARG_SHIFT) & __NARG_MASK) );
#endif
%}
!

at:n put:value
    super at:n put:value.

    "/ need some aid for optimized code -
    "/ some machines have the arguments/receiver etc. kept in register vars ...
    "/ the unfix updates the machine-stack version of the receiver.
%{
#ifndef __SCHTEAM__
    __UNFIXCONTEXT(self, 0);
#endif
%}.
    ^ value
!

home
    "return the immediate home of the receiver.
     for block contexts, this is the methodcontext, where the block was created,
     for nested block contexts, it's the surrounding block's context.
     for method-contexts this is nil."

    ^ nil "home"
!

homeReceiver
    "return the receiver from the context, where the receiver was defined"

    ^ receiver

    "Created: / 5.3.1998 / 16:18:26 / stefan"
!

instVarAt:index
    "have to catch instVar access to retVal and handle - they are invalid.
     Notice, that one of the next ST/X versions might get some syntactic
     extension to get this automatically)."

    |what|

%{
#ifdef __SCHTEAM__
    {
	int idx = index.intValue("[instVarAt:]");

	if (idx == I_sender) {
	    STContinuation c = self.sender();
	    if (c == null) {
		return __c__._RETURN_nil();
	    }
	    return __c__._RETURN( c );
	}
	if (idx == I_retvalTemp) {
	    return __c__._RETURN( Nil );
	}
	if (idx == I_handle) {
	    return __c__._RETURN( Nil );
	}
    }
#else
    if (index == __MKSMALLINT(__SLOT_CONTEXT_SENDER)) {                 // sender - must be accessed specially
	 what = @symbol(sender);
    } else if (index == __MKSMALLINT(__SLOT_CONTEXT_RETVAL)) {          // retvalTemp - invisible
	 RETURN (nil);
    } else if (index == __MKSMALLINT(__SLOT_CONTEXT_HANDLE)) {          // handle to machine stack - invisible
	 RETURN ( __MKUINT ( (unsigned INT)(__ContextInstPtr(self)->c_pSelf) ) );
    }
#endif
%}.
    what == #sender ifTrue:[
	^ self sender
    ].
    ^ super instVarAt:index
!

instVarAt:index put:value
    "have to catch instVar access to retVal and handle - they are invalid.
     Notice, that one of the next ST/X versions might get some syntactic
     extension to get this automatically)."

%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    if (index == __MKSMALLINT(__SLOT_CONTEXT_SENDER)) {                 // sender - not allowed to change
	 RETURN (nil);
    } else if (index == __MKSMALLINT(__SLOT_CONTEXT_RETVAL)) {          // retvalTemp - not allowed to change
	 RETURN (nil);
    } else if (index == __MKSMALLINT(__SLOT_CONTEXT_HANDLE)) {          // handle to machine stack - not allowed to change
	 RETURN (nil);
    }
#endif
%}.
    super instVarAt:index put:value.

    "/ need some aid for optimized code -
    "/ some machines have the arguments kept in register vars ...
    "/ the unfix updates the machine-stack version of the receiver.
%{
#ifndef __SCHTEAM__
    __UNFIXCONTEXT(self, 0);
#endif
%}.
    ^ value
!

javaLineNumber
    |nr pc|

    lineNr notNil ifTrue:[
	pc := lineNr bitAnd:16rFFFF.
    ].

"/ 'ask line for pc:' print. pc printCR.
    pc isNil ifTrue:[
	nr := self lineNumberFromMethod.
	nr notNil ifTrue:[
	    ^ nr
	].
	" '-> 0 [a]' printCR. "
	^0
    ].

    nr := self method lineNumberForPC:pc.
    nr isNil ifTrue:[
	nr := self lineNumberFromMethod.
	nr notNil ifTrue:[
	    ^ nr
	].
	" '-> 0 [b]' printCR. "
	^ 0
    ].
"/ '-> ' print. nr printCR.
     ^ nr.

!

lineNumber
    "this returns the lineNumber within the methods source, where the context was
     interrupted or called another method. (currently, sometimes this information
     is not available - in this case 0 is returned)"

    |l|

    receiver isJavaObject ifTrue:[
        "/ chances are good that I am a javContext ...
        self method isJavaMethod ifTrue:[
            ^ self javaLineNumber
        ]
    ].

    lineNr notNil ifTrue:[
        l := lineNr bitAnd:16rFFFF.
    ].

"/    self isJavaContext ifTrue:[ |nr m|
"/        m := self method.
"/        l isNil ifTrue:[
"/            m notNil ifTrue:[
"/                nr := m lineNumber
"/            ].
"/            nr notNil ifTrue:[
"/                ^ nr
"/            ].
"/            ^0
"/        ].
"/        nr := self method lineNumberForPC:l.
"/        nr isNil ifTrue:[
"/            m notNil ifTrue:[
"/                nr := m lineNumber
"/            ].
"/            nr notNil ifTrue:[
"/                ^ nr
"/            ].
"/            ^ 0
"/        ].
"/         ^ nr.
"/    ].

    ^ l

    "Modified: / 10.11.1998 / 13:19:48 / cg"
!

lineNumberFromMethod
   ^ 1
!

message
    ^ Message selector:selector arguments:self args

    "
     thisContext methodHome message
     thisContext message
    "
!

messageSend
    ^ MessageSend receiver:receiver selector:selector arguments:self args

    "
     thisContext methodHome messageSend
     thisContext messageSend
    "
!

method
    "return the method for which the receiver was created.
     Change with ST/X vsn 6:
	In older versions, the method was not stored in the context, but a lookup
	was simulated using selector and class.
	(which occasionally returned the wrong method - especially in the debugger,
	when the debugged method was changed).
	This has been changed - especially to support Jan's meta-object protocol.
	It is now stored in the context"

    |c sender sendersSelector m|

    (method notNil and:[method isMethod]) ifTrue:[
	^ method
    ].

    "mhmh - maybe I am a context for an unbound method (as generated by doIt);
     look in the sender's context. Consider this a kludge.
     Future versions of ST/X's message lookup may store the method in
     the context.
    "
    sender := self sender.
    sender notNil ifTrue:[
	sendersSelector := sender selector.
	sendersSelector notNil ifTrue:[
	    (sendersSelector startsWith:'valueWithReceiver:') ifTrue:[
		m := sender receiver.
		m isMethod ifTrue:[
		    method := m.
		    ^ m
		]
	    ]
	]
    ].

    c := self searchClass.
    "
     the below cannot happen in normal circumstances
     (added to avoid recursive errors in case of a broken sender chain)
    "
    c isBehavior ifFalse:[
	'Context [error]: non class in searchClass' errorPrintCR.
	'      selector: ' errorPrint. selector errorPrint.
	' receiver: ' errorPrint. receiver errorPrintCR.
	^ nil
    ].

    c := c whichClassIncludesSelector:selector.
    c notNil ifTrue:[
	method := c compiledMethodAt:selector.
	^ method
    ].

    ^ nil

    "Modified: / 28-06-2011 / 20:23:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-07-2012 / 14:46:37 / cg"
!

methodClass
    "return the class in which the method for which the receiver was created is."

    |cls m|

    method notNil ifTrue:[
	method isMethod ifTrue:[
	    ^ method mclass
	]
    ].

    cls := self searchClass.
    (cls isMeta
     and:[cls soleInstance isJavaClass]) ifTrue:[
	cls := cls soleInstance
    ].

    [cls notNil] whileTrue:[
	cls := cls whichClassIncludesSelector:selector.
	cls isNil ifTrue:[^ nil].

	m := cls compiledMethodAt:selector.
	m notNil ifTrue:[
	    m isIgnored ifFalse:[^ cls].
	].
	cls := cls superclass
    ].
    ^ cls

    "Modified: / 5.11.1998 / 19:07:43 / cg"
!

methodHome
    "return the method-home - for method contexts this is the receiver"

    ^ self
!

methodSelector
    "return the method's (or home method's) selector"

    ^ self methodHome selector
!

ntemp
    "return the number of temporary variables of the Block/Method.
     (for debugging only).
     I don't like the name of this method; its here for compatibility."

    ^ self numTemps

    "Modified: 23.10.1996 / 16:19:06 / cg"
!

numArgs
    "return the number of arguments to the Block/Method"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN(STInteger._new(self.asSTContinuation().numStArgs()));
#else
    RETURN ( __mkSmallInteger( (__intVal(__INST(flags)) >> __NARG_SHIFT) & __NARG_MASK) );
#endif
%}
!

numTemps
    "return the number of temporary variables of the Block/Method.
     (for debugging only)"

    ^ self size - self argumentCount - self numVars

    "Created: 23.10.1996 / 16:19:10 / cg"
    "Modified: 23.10.1996 / 16:19:48 / cg"
!

numVars
    "return the number of local variables of the Block/Method"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN(STInteger._new(self.asSTContinuation().numLocals(context)));
#else
    RETURN ( __mkSmallInteger( (__intVal(__INST(flags)) >> __NVAR_SHIFT) & __NVAR_MASK) );
#endif
%}
!

nvars
    "return the number of local variables of the Block/Method.
     I don't like the name of this method; its here for compatibility."

    ^ self numVars

    "Modified: 23.10.1996 / 16:18:44 / cg"
!

programmingLanguage

    ^method notNil
	ifTrue:[method programmingLanguage]
	ifFalse:[SmalltalkLanguage instance]

    "Created: / 17-03-2011 / 10:17:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-08-2011 / 09:23:39 / cg"
!

receiver
    "return the receiver of the context"
%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.asSTContinuation().stSelf(context) );
#endif
%}.
    ^ receiver
!

receiver:aCompiledCode
    "set the receiver of the message"

    receiver := aCompiledCode.

    "/ need some aid for optimized code -
    "/ some machines have the arguments kept in register vars ...
    "/ the unfix updates the machine-stack version of the receiver.
%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    __UNFIXCONTEXT(self, 0);
#endif
%}.

!

searchClass
    "this is the class where the method-lookup started;
     for normal sends, it is nil (or sometimes the receiver's class).
     For supersends, its the superclass of the one, in which the
     caller was defined."

    searchClass notNil ifTrue:[^ searchClass].
    ^ receiver class
!

selector
    "return the selector of the method for which the context was created"

    ^ selector
!

sender
    "return the sender of the context"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STContinuation sender = self.sender();
    if (sender == null) {
	return __c__._RETURN_nil();
    }
    return __c__._RETURN(sender);
    /* NOTREACHED */
#else
    OBJ theContext;

    theContext = __INST(sender_);
    /*
     * this special nil test is for the very first context (startup-context);
     * actually, its cosmetics, to avoid a visible nil>>nil context in the debugger.
     */
    if (__isNonNilObject(theContext)) {

	if (__isLazy(theContext)) {
	    /*
	     * this cannot happen
	     */
	    __PATCHUPCONTEXT(theContext);
	}
	if (! __isNonLIFO(theContext)) {
	    __markNonLIFO(theContext);
	}
    }
    RETURN (theContext);
#endif
%}
!

senderIsNil
    "return true, if I have no sender.
     This little ugly piece of code is needed (instead of the obvious
     'sender isNil') because sender is a protected field, which cannot be
     directly accessed by smalltalk code. The reason is that the sender field
     is lazily filled in by the VM, in the sender-accessor, and is usually
     invalid until needed."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (((STContinuation)self).caller == null) {
	return __c__._RETURN_true();
    }
    return __c__._RETURN_false();
    /* NOTREACHED */
#else
    if ( __INST(sender_) == nil ) {
	RETURN (true);
    }
    RETURN (false);
#endif
%}.
    ^ self sender isNil
!

setLineNumber:aNumber
    "private entry for uncompiledCodeObject ..."

    lineNr := aNumber
!

setNumArgs:nA numVars:nV
    "set the number of arguments and variables"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    INT flg;

    flg = __intVal(__INST(flags));
    flg = flg & ~(__NARG_MASK << __NARG_SHIFT);
    flg = flg & ~(__NVAR_MASK << __NVAR_SHIFT);
    flg = flg | __intVal(nA) << __NARG_SHIFT;
    flg = flg | __intVal(nV) << __NVAR_SHIFT;
    __INST(flags) = __mkSmallInteger(flg);
#endif
%}
!

tempAt:index
    "return the n'th stack-temporary variable"

    ^ self at:index
!

temporaries
    "return an array filled with the temporaries of this context"

    |nonTemps mySize|

    nonTemps := self argumentCount + self numVars.
    mySize := self numTemps.
    mySize == 0 ifTrue:[
        "/ little optimization here - avaoid creating empty containers
        ^ #()
    ].
    ^ (Array new:mySize) replaceFrom:1 to:mySize with:self startingAt:nonTemps+1

    "Modified: 23.10.1996 / 16:20:00 / cg"
!

varAt:n
    "return the n'th local variable"

    ^ self at:(n + self argumentCount)
!

varAt:n put:value
    "set the n'th local variable - useful when the receiver should be restarted
     or continued"

    self at:(n + self argumentCount) put:value
!

vars
    "return an array filled with the local variables of this context"

    |nonVars mySize|

    nonVars := self argumentCount.
    mySize := self numVars.
    mySize == 0 ifTrue:[
        "/ little optimization here - avaoid creating empty containers
        ^ #()
    ].
    ^ (Array new:mySize) replaceFrom:1 to:mySize with:self startingAt:nonVars+1

    "Modified: 23.10.1996 / 16:20:06 / cg"
! !

!Context methodsFor:'copying'!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    |copyOfMe|

    copyOfMe := self shallowCopy.
    copyOfMe setSender:nil.
    copyOfMe perform:postCopySelector withOptionalArgument:self and:aDictionary.
    ^ copyOfMe

    "Created: / 31-03-1998 / 15:51:14 / cg"
    "Modified: / 21-07-2011 / 13:30:21 / cg"
! !

!Context methodsFor:'enumerating'!

withAllSendersDo:aBlock
    "evaluate aBlock for me and all contexts of my sender chain"

    self withSendersUpToContextForWhich:[:con | false] do:aBlock
!

withSendersThroughContextForWhich:checkBlock do:aBlock
    "evaluate aBlock for me and all contexts of my sender chain, 
     until checkBlock returns true (incl. that last one)"

    |con|

    con := self.
    [ con notNil ] whileTrue:[
        aBlock value:con.
        (checkBlock value:con) ifTrue:[^ self].
        con := con sender.
    ]
!

withSendersUpToContextForWhich:checkBlock do:aBlock
    "evaluate aBlock for me and all contexts of my sender chain, 
     until checkBlock returns true, excl. that context."

    |con|

    con := self.
    [ con notNil ] whileTrue:[
        (checkBlock value:con) ifTrue:[^ self].
        aBlock value:con.
        con := con sender.
    ]
! !

!Context methodsFor:'error handling'!

invalidReturn:returnValue
    "this message is sent by the VM, when a methods context
     which has already returned is about to return again.
     (i.e. about to execute a return from an already returned
      method in a block).
    We raise a signal here, to allow catching of that situation."

    "
     in previous versions of ST/X and ST-80, this was no error;
     (instead, a normal blockreturn was performed to the value-sender).
     From a note in comp.lang.smalltalk, I conclude that new ST-80 versions
     now raise an error if this happens.
     Comment out the raise below to get that (old) behavior
     BETTER REWRITE YOUR APPLICATION
    "
"/ old behavior:
"/  ^ returnValue

"/ new behavior:

    "/ if this context is one of another process,
    "/ use another error message.

    (home notNil and:[home sender notNil]) ifTrue:[
	^ CannotReturnError
	    raiseRequestWith:returnValue
	    errorString:'cannot return from another process''s context'.
    ].

    ^ CannotReturnError
	raiseRequestWith:returnValue.

    "Modified: / 2.2.1998 / 15:19:52 / cg"
!

invalidReturnOrRestart:returnValue
    "this message is sent by the VM, when a method's or block's context
     which was compiled non-returnable is about to return again,
     or a non-restartable context is tried to be restarted.
     In ST/X, not all contexts are restartable/returnable.
     We raise a signal here, to allow catching of that situation."

    ^ CannotReturnError
	raiseRequestWith:returnValue
	errorString:'method was compiled non-resumable'
!

invalidReturnOrRestartError:how with:value
    "common error reporter for restart/return errors"

    self canReturn ifTrue:[
	"
	 tried to return from/restart a context which is already dead
	 (i.e. the method/block has already executed a return)
	"
	^ CannotReturnError
	      raiseRequestWith:value
	      errorString:(how , ' context not on calling chain')
    ].
    "
     tried to return from/restart a context of a method which was compiled
     unrestartable or of a block (which is never restartable)
    "
    ^ CannotReturnError
	  raiseRequestWith:value
	  errorString:(how , ' context cannot be restarted/returned from')
! !

!Context methodsFor:'fixups'!

fixAllLineNumbers
%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    __PATCHUPCONTEXTS(__thisContext);
    __CONTEXTLINENOS(self);
#endif
%}
! !

!Context methodsFor:'minidebugger printing'!

fullPrint
    "print the receiver, selector and args of the context
     - used only for MiniDebugger's walkback print"

    self receiverPrintString _errorPrint. ' ' _errorPrint. selector _errorPrint.
    self argumentCount ~~ 0 ifTrue: [
        ' ' _errorPrint. self argsDisplayString _errorPrint
    ].
    ' [' _errorPrint. self lineNumber _errorPrint. ']' _errorPrintCR

    "
     thisContext fullPrint
    "

    "Modified: 20.5.1996 / 10:27:14 / cg"
!

fullPrintAll
    "print a full walkback starting at the receiver
     - used only for MiniDebugger's walkback print"

    self withAllSendersDo:[:con | con fullPrint].

    "
     thisContext fullPrintAll
    "
!

fullPrintAllLevels:nOrNil
    "print a full walkback starting at the receiver, only print n levels
     - used only for MiniDebugger's walkback print"

    |context count|

    count := 0.
    context := self.
    [context notNil] whileTrue: [
        context fullPrint.
        context := context sender.
        nOrNil notNil ifTrue:[
            (count := count+1) > nOrNil ifTrue:[^self].
        ]
    ]

    "
     thisContext fullPrintAllLevels:5
    "

    "Created: / 3.9.1999 / 14:02:38 / ps"
!

printAll
    "print a full walkback starting at the receiver, only print n levels
     - used only for MiniDebugger's walkback print"

    self printAllLevels:nil

    "
     thisContext printAll
    "
!

printAllLevels:nOrNil
    "print a full walkback starting at the receiver, only print n levels
     - used only for MiniDebugger's walkback print"

    |context count|

    count := 0.
    context := self.
    '--------------------------' errorPrintCR.
    [context notNil] whileTrue: [
        context errorPrintCR.
        context := context sender.
        nOrNil notNil ifTrue:[
            (count := count+1) > nOrNil ifTrue:[
                '--------------------------' errorPrintCR.
                ^ self
            ].
        ]
    ].
    '--------------------------' errorPrintCR.

    "
     thisContext printAllLevels:5
    "
! !

!Context methodsFor:'non local control flow'!

evaluateUnwindActionsUpTo:aContext
    "walk up the calling chain, looking for unwind-cleanup actions to
     be performed. This depends upon those contexts being specially
     marked using #markForUnwind.
     Returns the argument (i.e. non-nil), if all went well,
     nil if aContext is not on the caller chain (definitely an error)"

    |con unwindBlock|

    "
     start with this context, moving up, looking for unwind actions
    "
    con := self findNextUnwindContextOr:aContext.
    [con notNil and:[con ~~ aContext]] whileTrue:[
	unwindBlock := con receiver unwindHandlerInContext:con.
	con unmarkForUnwind.
	unwindBlock value.

	con := con findNextUnwindContextOr:aContext.
    ].
    "/ mhmh - the just unwound context could itself be markedForUnwind
    (con notNil and:[con isMarkedForUnwind]) ifTrue:[
	unwindBlock := con receiver unwindHandlerInContext:con.
	con unmarkForUnwind.
	unwindBlock value.
    ].
    ^ con
!

resend
    "EXPERIMENTAL: resend the context's message (to the same receiver).
     if the method's implementation has been changed in the meanwhile (for example, in the debugger),
     the new code is executed. Otherwise the same code is reexecuted from the start."

    self returnDoing:[ receiver perform:selector withArguments:(self args) ].

    "
     when we arrive here, something went wrong.
     debugging ...
    "
    ^ self invalidReturnOrRestartError:#'resend' with:nil
!

restart
    "restart the receiver - i.e. the method is evaluated again.
     if the context to restart already died, trigger an error.
     This is a low level helper for unwindAndRestart.

     NOTICE:
	 NO unwind actions are performed - this is usually not
	 what you want (see Context>>unwindAndRestart).

     LIMITATION:
	 currently a context can only be restarted by
	 the owning process - not from outside.
	 Also, the compiler has an option (+optcontext) to create
	 non-restartable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__.RESTART(self);
    /* NOTREACHED */
#else
    if (__INST(sender_) == nil) {
	RETURN(nil);
    } else {
	__RESUMECONTEXT__(self, RESTART_VALUE, 0);
    }
#endif
%}.

    "
     when we arrive here, something went wrong.
     debugging ...
    "
    ^ self invalidReturnOrRestartError:#restart with:nil
!

resume
    "resume execution in this context. I.e. as if the method called
     last by the receiver did a ^ nil.
     If the context has already returned, report an error.

     NOTICE:
	 NO unwind actions are performed (see Context>>unwind).

     LIMITATION:
	 currently a context can only be resumed by
	 the owning process - not from outside.
	 Also, the compiler has an option (+optcontext) to create
	 non-resumable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    ^ self resume:nil
!

resume:value
    "resume the receiver - as if it got 'value' from whatever
     it called. This continues execution in the receiver's method
     after the point where it did its last send.
     If the context has already returned - report an error.

     NOTICE:
         NO unwind actions are performed (see Context>>unwind:).

     LIMITATION:
         currently a context can only be resumed by
         the owning process - not from outside.
         Also, the compiler has an option (+optcontext) to create
         non-resumable contexts (which are faster).
         If such a context is restarted, a runtime error is raised."

    |theContext|

    "
     starting with this context, find the one below
     (i.e. the one that I have called) and return from it.
    "

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_TO(value, self.asSTContinuation());
    /* NOTREACHED */
#else
    OBJ sndr;

    theContext = __thisContext;
    while (theContext != nil) {
        sndr = __ContextInstPtr(theContext)->c_sender;
        if (sndr == self) break;
        theContext = sndr;
    }
    if (theContext != nil) {
        if (__isLazy(theContext)) {
            __PATCHUPCONTEXT(theContext);
        }
    }
#endif
%}.

    theContext isNil ifTrue:[
        "
         tried to resume in context which is already dead
         (i.e. the method/block has already executed a return)
        "
        ^ thisContext invalidReturnOrRestartError:#'resume:' with:value
    ].
    ^ theContext return:value
!

resumeIgnoringErrors:value
    "resume the receiver - as if it got 'value' from whatever
     it called. This continues execution in the receiver's method
     after the point where it did its last send.
     If the context has already returned - simply return.

     NOTICE:
         NO unwind actions are performed (see Context>>unwind:).

     LIMITATION:
         currently a context can only be resumed by
         the owning process - not from outside.
         Also, the compiler has an option (+optcontext) to create
         non-resumable contexts (which are faster).
         If such a context is restarted, a runtime error is raised."

    "
     starting with this context, find the one below
     (i.e. the one that I have called) and return from it.
    "

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_TO(value, self.asSTContinuation());
    /* NOTREACHED */
#else
    OBJ theContext, sndr;

    theContext = __thisContext;
    while (theContext != nil) {
        sndr = __ContextInstPtr(theContext)->c_sender;
        if (sndr == self) break;
        theContext = sndr;
    }
    if (theContext != nil) {
        if (__ContextInstPtr(theContext)->c_sender) {
            if (!((INT)(__ContextInstPtr(theContext)->c_flags) & __MASKSMALLINT(__CANNOT_RETURN))) {
                __RESUMECONTEXT__(theContext, value, 0);
            }
        }
    }
#endif
%}.

    "/ no error reporting
!

resumeOnErrorProceed:value
    "resume the receiver - as if it got 'value' from whatever
     it called. This continues execution in the receiver's method
     after the point where it did its last send.
     If the context has already returned - simply return.

     NOTICE:
         NO unwind actions are performed (see Context>>unwind:).

     LIMITATION:
         currently a context can only be resumed by
         the owning process - not from outside.
         Also, the compiler has an option (+optcontext) to create
         non-resumable contexts (which are faster).
         If such a context is restarted, a runtime error is raised."

    "
     starting with this context, find the one below
     (i.e. the one that I have called) and return from it.
    "

%{
#ifdef __SCHTEAM__
    return __c__._RETURN_TO(value, self.asSTContinuation());
    /* NOTREACHED */
#else
    OBJ theContext, sndr;

    theContext = __thisContext;
    while (theContext != nil) {
        sndr = __ContextInstPtr(theContext)->c_sender;
        if (sndr == self) break;
        theContext = sndr;
    }
    if (theContext != nil) {
        if (__ContextInstPtr(theContext)->c_sender) {
            __RESUMECONTEXT__(theContext, value, 0);
        }
    }
#endif
%}.

    "/ no error reporting
!

return
    "return from this context with nil. I.e. as if it did a ^ nil.
     NOTICE:
	 NO unwind actions are performed - this is usually not
	 what you want (See Context>>unwind).
	 This is a low level method - a helper for unwind.

     LIMITATION:
	 currently a context can only be returned by
	 the owning process - not from outside.
	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    ^ self return:nil
!

return:value
    "return from this context as if it did a '^ value'.
     NOTICE:
	 NO unwind actions are performed - this is usually not
	 what you want (See Context>>unwind:).
	 This is a low level method - a helper for unwind.

     LIMITATION:
	 currently a context can only be returned by
	 the owning process - not from outside.
	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN_FROM(value, self.asSTContinuation());
    /* NOTREACHED */
#else
    if (__INST(sender_) == nil) {
	RETURN(nil);
    } else {
	__RESUMECONTEXT__(self, value, 0);
    }
#endif
%}.

    "
     when we arrive here, something went wrong.
     debugging ...
    "
    ^ self invalidReturnOrRestartError:#'return' with:value
!

returnDoing:aBlock
    "return from this context as if it did a '^ aBlock value'.
     The block is evaluated as if called by the receiver context;
     NOT the true executing context.
     NOTICE:
	 NO unwind actions are performed - this is usually not
	 what you want (See Context>>unwindThenDo:).
	 This is a low level method - a helper for unwind.

     LIMITATION:
	 currently a context can only be returned by
	 the owning process - not from outside.
	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

%{
#ifdef __SCHTEAM__
    ERROR("unimplemented");
#else
    if (__INST(sender_) == nil) {
	RETURN(nil);
    } else {
	__RESUMECONTEXT__(self, aBlock, 2);
    }
#endif
%}.

    "
     when we arrive here, something went wrong.
     debugging ...
    "
    ^ self invalidReturnOrRestartError:#'returnDoing' with:aBlock
!

unwind
    "return nil from the receiver - i.e. simulate a '^ nil'.
     If the context has already returned, report an error.
     Evaluate all unwind-blocks as specified in Block>>valueNowOrOnUnwind:
     and Block>>valueOnUnwindDo: on the way.

     LIMITATION:
	 currently a context can only be unwound by
	 the owning process - not from outside.
	 i.e. it is not possible for one thread to unwind
	 another threads context - which does not make sense anyway.
	 However, you can force another thread to do this in its own process
	 context, by giving it an interrupt action - this does make sense.

	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    ^ self unwind:nil
!

unwind:value
    "return value from the receiver - i.e. simulate a '^ value'.
     If the context has already returned , report an error.
     Evaluate all unwind-blocks as specified in Block>>valueNowOrOnUnwind:
     and Block>>valueOnUnwindDo: on the way.

     LIMITATION:
	 currently a context can only be unwound by
	 the owning process - not from outside.
	 i.e. it is not possible for one thread to unwind
	 another threads context - which does not make sense anyway.
	 However, you can force another thread to do this in its own process
	 context, by giving it an interrupt action - this does make sense.

	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    |con|

    self senderIsNil ifFalse:[
	con := thisContext evaluateUnwindActionsUpTo:self.
    ].

    "oops, if nil, I am not on the calling chain;
     (bad bad, unwind action have already been performed.
      should we check for this situation first and NOT evaluate
      the unwind actions in this case ?)
    "
    con isNil ifTrue:[
	"
	 tried to return to a context which is already dead
	 (i.e. the method/block has already executed a return)
	"
	^ self invalidReturnOrRestartError:#'unwind:' with:value
    ].
    "
     now, that all unwind-actions are done, I can use the
     low-level return ...
    "
    ^ self return:value
!

unwindAndRestart
    "restart the receiver - i.e. the method is evaluated again.
     if the context to restart already did report an error.
     Evaluate all unwind-blocks as specified in Block>>valueNowOrOnUnwind:
     and Block>>valueOnUnwindDo: before restarting.

     LIMITATION:
	 a context can only be restarted by
	 the owning process - not from outside.
	 i.e. it is not possible for one thread to unwindAndRestart
	 another threads context - which does not make sense anyway.
	 However, you can force another thread to do this in its own process
	 context, by giving it an interrupt action - this does make sense.

	 Also, the compiler has an option (+optcontext) to create
	 non-restartable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    |con|

    self senderIsNil ifFalse:[
	con := thisContext evaluateUnwindActionsUpTo:self.
    ].

    "oops, if nil, I am not on the calling chain;
     (bad bad, unwind action have already been performed.
      should we check for this situation first and NOT evaluate
      the unwind actions in this case ?)
    "
    con isNil ifTrue:[
	"
	 tried to return to a context which is already dead
	 (i.e. the method/block has already executed a return)
	"
	^ self invalidReturnOrRestartError:#'unwindAndRestart:' with:nil
    ].
    "
     now, that all unwind-actions are done, I can use the
     low-level restart ...
    "
    ^ self restart
!

unwindAndResume:value
    "resume execution in the the receiver - i.e. simulate a '^ value'
     from whatever it called last.
     If the context has already returned , report an error.
     Evaluate all unwind-blocks as specified in Block>>valueNowOrOnUnwind:
     and Block>>valueOnUnwindDo: on the way.

     LIMITATION:
	 currently a context can only be unwound by
	 the owning process - not from outside.
	 i.e. it is not possible for one thread to unwind
	 another threads context - which does not make sense anyway.
	 However, you can force another thread to do this in its own process
	 context, by giving it an interrupt action - this does make sense.

	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    |con|

    self senderIsNil ifFalse:[
	con := thisContext evaluateUnwindActionsUpTo:self.
    ].

    "oops, if nil, I am not on the calling chain;
     (bad bad, unwind action have already been performed.
      should we check for this situation first and NOT evaluate
      the unwind actions in this case ?)
    "
    con isNil ifTrue:[
	"
	 tried to return to a context which is already dead
	 (i.e. the method/block has already executed a return)
	"
	^ self invalidReturnOrRestartError:#'unwindAndResume:' with:value
    ].
    "
     now, that all unwind-actions are done, I can use the
     low-level resume ...
    "
    ^ self resume:value
!

unwindThenDo:aBlock
    "return the value of aBlock from the receiver - i.e. simulate a '^ aBlock value'.
     If the context has already returned, report an error.
     Evaluate all unwind-blocks as specified in Block>>valueNowOrOnUnwind:
     and Block>>valueOnUnwindDo: on the way.
     The block is evaluated AFTER all unwind actions are performed
     (i.e. the block's sender will be the receiving context, not the
      currently executing context)

     LIMITATION:
	 currently a context can only be unwound by
	 the owning process - not from outside
	 i.e. it is not possible for one thread to unwindThenDo
	 another threads context - which does not make sense anyway.
	 However, you can force another thread to do this in its own process
	 context, by giving it an interrupt action - this does make sense.

	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    |con|

    self senderIsNil ifFalse:[
	con := thisContext evaluateUnwindActionsUpTo:self.
    ].

    "oops, if nil, I am not on the calling chain;
     (bad bad, unwind action have already been performed.
      should we check for this situation first and NOT evaluate
      the unwind actions in this case ?)
    "
    con isNil ifTrue:[
	"
	 tried to return to a context which is already dead
	 (i.e. the method/block has already executed a return)
	"
	^ self invalidReturnOrRestartError:#'unwindThenDo:' with:aBlock
    ].
    "
     now, that all unwind-actions are done, I can use the
     low-level return ...
    "
    ^ self returnDoing:aBlock
!

unwindThenResend
    "EXPERIMENTAL: resend the context's message (to the same receiver).
     if the method's implementation has been changed in the meanwhile (for example, in the debugger),
     the new code is executed. Otherwise the same code is reexecuted from the start.
     Evaluate all unwind-blocks as specified in Block>>valueNowOrOnUnwind:
     and Block>>valueOnUnwindDo: on the way.
     The resend happens AFTER all unwind actions are performed

     LIMITATION:
	 currently a context can only be unwound by
	 the owning process - not from outside
	 i.e. it is not possible for one thread to unwindThenDo
	 another threads context - which does not make sense anyway.
	 However, you can force another thread to do this in its own process
	 context, by giving it an interrupt action - this does make sense.

	 Also, the compiler has an option (+optcontext) to create
	 non-returnable contexts (which are faster).
	 If such a context is restarted, a runtime error is raised."

    |con|

    self senderIsNil ifFalse:[
	con := thisContext evaluateUnwindActionsUpTo:self.
    ].

    "oops, if nil, I am not on the calling chain;
     (bad bad, unwind action have already been performed.
      should we check for this situation first and NOT evaluate
      the unwind actions in this case ?)
    "
    con isNil ifTrue:[
	"
	 tried to return to a context which is already dead
	 (i.e. the method/block has already executed a return)
	"
	^ self invalidReturnOrRestartError:#'unwindThenResend' with:nil
    ].

    "/ now, that all unwind-actions are done, I can use the low-level resend...
    ^ self resend
! !

!Context methodsFor:'printing & storing'!

argStringFor:someObject
    |s|
%{
#ifndef __SCHTEAM__
    /*
     * special handling for (invalid) free objects.
     * these only appear if some primitiveCode does not correctly use SEND macros,
     * which may lead to sends to free objects. In normal operation, this 'cannot' happen.
     * However, these print methods are also invoked for low-level pointer errors, so better be prepared...
     */
    if (__isNonNilObject(someObject) && (__qClass(someObject)==nil)) {
	s = __MKSTRING("FreeObject");
    }
#endif /* not SCHTEAM */
%}.
    s isNil ifTrue:[
	s := someObject displayString.
	s isNil ifTrue:[
	    ^ '**************** nil displayString of ',(someObject class name ? '??')
	].
    ].
"/    JV@2013-04-26: Following is rubbish, the callers must handle string output correctly.
"/    moreover storeString does not work on self-referencing structures, but that doesn't matter
"/    for wide strings.
"/    SV@2013-08-19: I checked/fixed the callers to use CharacterWriteStreams.
"/    s isWideString ifTrue:[
"/        "make sure that the object really returns something we can stream into a string"
"/        s := someObject storeString.
"/    ].
    ^ s
!

argsDisplayString
    ^ String streamContents:[:s | self displayArgsOn:s ].

    "Modified (format): / 07-03-2012 / 13:11:17 / cg"
!

displayArgsOn:aStream
    | n "{ Class: SmallInteger }"
      s |

    n := self argumentCount.
    1 to:n do:[:index |
        Error handle:[:ex |
            s := '*Error in argString*'.
        ] do:[
            s := self argStringFor:(self at:index).
            s := s contractTo:100.
        ].

        aStream nextPutAll:s asString string.
        index ~~ n ifTrue:[ aStream space ].
    ].

    "Modified: / 07-03-2012 / 13:09:17 / cg"
!

displayOn:aGCOrStream
    "return a string to display the receiver - for display in Inspector"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
	^ super displayOn:aGCOrStream
    ].

    aGCOrStream
	nextPutAll:self class name;
	nextPut:$(.
    self printOn:aGCOrStream.
    aGCOrStream nextPut:$).
!

fullPrintAllOn:aStream
    "print a full walkback (incl arguments) starting at the receiver"

    self withAllSendersDo:[:con | con fullPrintOn:aStream. aStream cr].

    "
     thisContext fullPrintAllOn:Transcript
    "

    "Created: 15.1.1997 / 18:09:05 / cg"
!

fullPrintAllOn:aStream throughContextForWhich:aBlock
    "print a full walkback (incl arguments) starting at the receiver"

    self withSendersThroughContextForWhich:aBlock do:[:con |
        con fullPrintOn:aStream. aStream cr.
    ].

    "
     thisContext fullPrintAllOn:Transcript throughContextForWhich:[:con | con selector == #doIt].
    "
!

fullPrintAllOn:aStream upToContextForWhich:aBlock
    "print a full walkback (incl arguments) starting at the receiver"

    self withSendersUpToContextForWhich:aBlock do:[:con |
        con fullPrintOn:aStream. aStream cr.
    ].

    "
     thisContext fullPrintAllOn:Transcript upToContextForWhich:[:con | con selector == #doIt].
    "
!

fullPrintAllString
    "return a string containing the full walkback (incl. arguments)"

    |s|

    s := WriteStream on:''.
    self fullPrintAllOn:s.
    ^ s contents

    "
     thisContext fullPrintAllString
    "

    "Created: / 21-08-2011 / 07:37:36 / cg"
!

fullPrintOn:aStream
    "append a verbose description (incl. arguments) of the receiver onto aStream"

    self printReceiverOn:aStream.
    aStream nextPutAll:' >> '.
    self selector printOn:aStream.    "show as string (as symbol looks too ugly in browser ...)"
    "/ self selector storeOn:aStream.    "show as symbol"

    self size ~~ 0 ifTrue: [
	aStream space.
	self displayArgsOn:aStream
    ].
    aStream nextPutAll:' {'.
    self identityHash printOn:aStream.
    aStream nextPut:$}.

    aStream nextPutAll:' ['.
    self lineNumber printOn:aStream.
    aStream nextPut:$].

    "
     thisContext fullPrintOn:Transcript
    "

    "Modified: 20.5.1996 / 10:27:14 / cg"
    "Created: 15.1.1997 / 18:09:06 / cg"
!

fullPrintString
    "return a string describing the context - this includes the linenumber,
     receiver printString and argument printString"

    ^ String streamContents:[:s | self fullPrintOn:s]

    "
     thisContext fullPrintString
    "
!

methodPrintString
    "return a string describing the contexts method as 'implementorClass>>selector'"

    |mthd who|

    mthd := self method.
    mthd notNil ifTrue:[
	who := mthd who.
	who notNil ifTrue:[
	    ^ who methodClass name , ' >> #' , who methodSelector
	]
    ].
    ^ mthd displayString.

    "
     thisContext methodPrintString
     thisContext sender methodPrintString
    "

    "Modified: 1.11.1996 / 16:21:49 / cg"
!

printAllOn:aStream
    "print a brief walkback (excl. arguments) starting at the receiver"

    self withAllSendersDo:[:con | con printOn:aStream. aStream cr].

    "
     thisContext printAllOn:Transcript
    "

    "Created: 15.1.1997 / 18:09:05 / cg"
!

printAllOn:aStream throughContextForWhich:aBlock
    "print a short walkback (excl. arguments) starting at the receiver"

    self withSendersThroughContextForWhich:aBlock do:[:con |
        con printOn:aStream. aStream cr.
    ].

    "
     thisContext printAllOn:Transcript throughContextForWhich:[:con | con selector == #doIt].
    "
!

printAllOn:aStream upToContextForWhich:aBlock
    "print a short walkback (excl. arguments) starting at the receiver"

    self withSendersUpToContextForWhich:aBlock do:[:con |
        con printOn:aStream. aStream cr.
    ].

    "
     thisContext printAllOn:Transcript upToContextForWhich:[:con | con selector == #withCursor:do:].
    "
!

printAllString
    "return a string containing the walkback (excl. arguments)"

    |s|

    s := WriteStream on:''.
    self printAllOn:s.
    ^ s contents

    "
     thisContext printAllString
    "

    "Created: / 21-08-2011 / 07:38:05 / cg"
!

printClassNameOf:aClass on:aStream
    "helper for printing"

    | nonMeta |

    (nonMeta := aClass theNonMetaclass) isJavaClass ifTrue:[
       nonMeta javaName printOn: aStream
    ] ifFalse:[
	(aClass name ? '????') printOn:aStream.
    ].

    "Modified: / 08-08-2014 / 09:39:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a brief description (excl. arguments) of the receiver onto aStream"

    | m |

    self printReceiverOn:aStream.
    "/ aStream nextPutAll:' '.
    aStream nextPutAll:' >> '.

    aStream bold.
    m := self method.
    m isJavaMethod ifTrue:[
	aStream nextPutAll: (m printStringForBrowserWithSelector: self selector).
    ] ifFalse:[
	self selector printOn:aStream.    "show as string (as symbol looks too ugly in browser ...)"
	"/ self selector storeOn:aStream.    "show as symbol"
    ].
    aStream normal.

    (method notNil and:[method isWrapped]) ifTrue:[
	aStream nextPutAll:' (wrapped) '
    ].
    aStream nextPutAll:' ['.
    m isJavaMethod ifTrue:[
	aStream nextPutAll: self method mclass sourceFile ? '???' .
	m isNative ifTrue:[
	    aStream nextPutAll: ':in native code'
	] ifFalse:[
	    aStream nextPut: $:.
	    (m lineNumberForPC0: lineNr) ? '???' printOn: aStream.
	].
    ] ifFalse:[
	self lineNumber printOn: aStream
    ].
    aStream nextPut:$].

    "Modified: / 05-08-2012 / 12:00:00 / cg"
    "Modified: / 08-08-2014 / 07:37:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printReceiverOn:aStream
    "print description of the receiver of the context to aStream"

    |receiverClass receiverClassName implementorClass|

    receiverClassName := self safeReceiverClassNameIfInvalid.
    receiverClassName notNil ifTrue:[
	"if we come here, this is a context with an illegal class"
	receiverClassName printOn:aStream.
	^ self.
    ].

    receiverClass := receiver class.

    (receiverClass == SmallInteger or:[receiverClass == Float]) ifTrue:[
	aStream nextPut:$(. receiver printOn:aStream. aStream nextPutAll:') '.
    ].
    self printClassNameOf:receiverClass on:aStream.

    (selector notNil or:[method notNil]) ifTrue:[
	"/ implementorClass := self searchClass whichClassIncludesSelector:selector.

	"
	 kludge to avoid slow search for containing class
	"
	(method notNil
	 or:[selector ~~ #doIt and:[selector ~~ #doIt:]]) ifTrue:[
	    implementorClass := self methodClass.
	    implementorClass isNil ifTrue:[
		"
		 kludge for the frame called by a wrappedmethod;
		 the wrappedmethod is in the class, so its mclass is correct.
		 however, the originalmethod is invoked via performMethod, and its mclass
		 is nil. Care for this here. Think about keeping the mclass in the original method.
		"
		(method notNil and:[method isWrapped not]) ifTrue:[
		    WrappedMethod notNil ifTrue:[
			WrappedMethod allWrappedMethodsDo:[:wrapped |
			    wrapped originalMethodIfWrapped == method ifTrue:[
				implementorClass := wrapped mclass.
			    ].
			].
		    ].
		]
	    ].
	].

	implementorClass notNil ifTrue: [
	    (implementorClass ~~ receiverClass) ifTrue: [
		aStream nextPut:$(.
		self printClassNameOf:implementorClass on:aStream.
		aStream nextPut:$).
	    ]
	] ifFalse:[
	    | srchClass where |

	    srchClass := self searchClass.
	    srchClass ~~ receiverClass ifTrue:[
		aStream nextPut:$(.
		self printClassNameOf:srchClass on:aStream.
		aStream nextPut:$).
	    ].
	    "
	     kludge for doIt - these unbound methods are not
	     found in the classes methodDictionary
	    "
	    true "(selector ~~ #doIt and:[selector ~~ #doIt:])" ifTrue:[
		"
		 kludge for methods invoked explicitly via valueWithReceiver...
		"
		(self sender notNil
		and:[ self sender receiver isMethod
		and:[ self sender selector startsWith:'valueWithReceiver:' ]]) ifTrue:[
		    where := '(**DIRECTED**)'.
		] ifFalse:[
		    where := '(**NONE**)'.
		].
		aStream nextPutAll:where
	    ]
	]
    ].

    "Created: / 23-10-2013 / 11:13:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2014 / 17:50:33 / cg"
!

receiverPrintString
    "return a string describing the receiver of the context"

    |s|

    s := WriteStream on:''.
    self printReceiverOn:s.
    ^ s contents

    "
	thisContext receiverPrintString
    "
!

safeReceiverClassNameIfInvalid
    "if the receiver refers to an invalid object,
     return a replacement string. otherwise nil.
     This cares for invalid (free) objects which may appear with bad primitive code,
     and prevents a crash in such a case."

%{
#ifdef __SCHTEAM__
    return __c__._RETURN( ((STContinuation)self).stSelf(__c__) );
#else
    /*
     * special handling for (invalid) free objects.
     * these only appear if some primitiveCode does not correctly use SEND macros,
     * which may lead to sends to free objects. In normal operation, this 'cannot' happen.
     */
    if (__isNonNilObject(__INST(receiver)) && (__qClass(__INST(receiver))==nil)) {
	RETURN( __MKSTRING("FreeObject") );
    }
#endif /* not SCHTEAM */
%}.
    ^ nil

    "Created: / 21-05-2007 / 13:19:37 / cg"
! !

!Context methodsFor:'private-accessing'!

isMarkedForUnwind
    "true if the mark for unwind flag is set in the receiver.
     The VM needs this to know that some special action is to be performed with
     this context - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN ( ((STContinuation)self).isMarkedForUnwind() );
#else
    RETURN ( ((INT)__INST(flags) & __MASKSMALLINT(__UNWIND_MARK)) ? true : false );
#endif
%}
    "
     thisContext isMarkedForUnwind
    "
!

markForHandle
    "set the mark for exception handle flag in the receiver.
     The VM needs this to know that some special action is to be performed with
     this context - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).markForHandle();
#else
     __INST(flags) = (OBJ)((INT)__INST(flags) | __MASKSMALLINT(__HANDLE_MARK));
#endif
%}

    "Modified: 13.12.1995 / 19:05:22 / cg"
!

markForInterrupt
    "set the interrupt flag.
     The VM needs this to know that some special action is to be performed with
     this context upon return - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).markForInterrupt();
#else
     __markInterrupted(__ContextInstPtr(self));
#endif
%}
!

markForInterruptOnUnwind
    "set the interrupt-on-unwind flag in the receiver.
     The VM will generate a stepInterrupt, when this context returns or
     is unwound. This is used by the debugger for faster single-stepping;
     - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).markForInterruptOnUnwind();
#else
     __INST(flags) = (OBJ)((INT)__INST(flags) | __MASKSMALLINT(__IRQ_ON_UNWIND));
#endif
%}
!

markForRaise
    "set the mark for exception raise flag in the receiver.
     The VM needs this to know that some special action is to be performed with
     this context - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).markForRaise();
#else
     __INST(flags) = (OBJ)((INT)__INST(flags) | __MASKSMALLINT(__RAISE_MARK));
#endif
%}

    "Modified: 13.12.1995 / 19:05:22 / cg"
!

markForUnwind
    "set the mark for unwind flag in the receiver.
     The VM needs this to know that some special action is to be performed with
     this context - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).markForUnwind();
#else
     __INST(flags) = (OBJ)((INT)__INST(flags) | __MASKSMALLINT(__UNWIND_MARK));
#endif
%}

    "Modified: 13.12.1995 / 19:05:22 / cg"
!

setHome:aContext
    "set the homeContext.
     DANGER: this is for experimental, internal use only (byteCode interpreters)"

    home := aContext.
!

setSender:aContext
    "set the sender of the context.
     DANGER: this is for experimental, internal use only (byteCode interpreters)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).caller = aContext.asSTContinuation();
#else
    __INST(sender_) = aContext;
#endif
%}
!

unmarkForUnwind
    "clear the mark for unwind flag in the receiver.
     The VM needs this to know that some special action is to be performed with
     this context - a highly internal mechanism and not for public use."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    ((STContinuation)self).unmarkForUnwind();
#else
    __INST(flags) = (OBJ)((INT)__INST(flags) & ~__MASKSMALLINT(__UNWIND_MARK));
#endif
%}
! !

!Context methodsFor:'searching'!

findExceptional
    "walk along the sender chain (starting with the sender),
     for a context which is marked as handle or raise context.
     This non-standard interface is only to be used by exception"

    "/ this could have been (actually: was) implemented as:
    "/
    "/  |con|
    "/
    "/  con := self.
    "/  [con notNil] whileTrue:[
    "/      [con isHandleContext] ifTrue:[^con].
    "/      [con isRaiseContext] ifTrue:[^con].
    "/      con := con sender.
    "/  ].
    "/  ^ nil
    "/
    "/ and the code below does exactly this (somewhat faster, though).
    "/
    "/ (it avoids referencing all intermediate contexts, which would mark them special,
    "/  although they aren't really - this is expert knowledge, no need to understand that ...)

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	STContinuation lastCallee = (STContinuation)self;
	STContinuation caller = lastCallee.caller;

	while (caller != null) {
	    if (caller.isExceptionalSmalltalkContext()) {
		caller = lastCallee.sender();   // exposed
		return context._RETURN(caller);
	    }
	    lastCallee = caller;
	    caller = lastCallee.caller;
	}
	return context._RETURN( STObject.Nil );
    }
    /* NOTREACHED */
#else
    OBJ theContext;

    theContext = self;
    while (__isNonNilObject(theContext)) {
	if ((INT)(__ContextInstPtr(theContext)->c_flags) & __MASKSMALLINT(__HANDLE_MARK|__RAISE_MARK)) {
	    if (__isLazy(theContext)) {
		__PATCHUPCONTEXT(theContext);
	    }
	    RETURN (theContext);
	}
	theContext = __ContextInstPtr(theContext)->c_sender;
    }
#endif /* not SCHTEAM */
%}.
    ^ nil
!

findNextContextWithSelector:selector1 or:selector2 or:selector3
    "walk along the sender chain (starting with the sender),
     for a context with either one of the given selectors.
     This non-standard interface is only to be used by exception"

    "/ this could have been (actually: was) implemented as:
    "/
    "/  |con|
    "/
    "/  con := self sender.
    "/  [con notNil] whileTrue:[
    "/      con selector == aSelector ifTrue:[^ con].
    "/      con := con sender.
    "/  ].
    "/  ^ nil
    "/
    "/ and the code below does exactly this (somewhat faster, though).
    "/
    "/ (it avoids referencing all intermediate contexts, which would mark them special,
    "/  although they aren't really - this is expert knowledge, no need to understand that ...)

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	STContinuation lastCallee = (STContinuation)self;
	STContinuation cont = lastCallee.caller;

	STObject sel1 = context.stArg(0);
	STObject sel2 = context.stArg(1);
	STObject sel3 = context.stArg(2);

	while (cont != null) {
	    if (cont.isSmalltalkContext()) {
		STObject thisSelector = cont.contextSelector();

		if ((thisSelector == sel1)
		 || (thisSelector == sel2)
		 || (thisSelector == sel3)) {
		    break;
		}
	    }
	    lastCallee = cont;
	    cont = lastCallee.caller;
	}
	if (cont == null) {
	    return __c__._RETURN_nil();
	}
	cont = lastCallee.sender();     // exposed
	return __c__._RETURN(cont);
    }
    /* NOTREACHED */
#else
    OBJ theContext;
    OBJ sel;
    OBJ __FETCHSELECTOR();

    theContext = __INST(sender_);
    while (__isNonNilObject(theContext)) {
	if (__isLazy(theContext)) {
# ifdef TRADITIONAL_STACK_FRAME
	    sel = __FETCHSELECTOR(theContext);
# else
	    /* mhmh - not really needed */
	    __PATCHUPCONTEXT(theContext);
	    sel = __ContextInstPtr(theContext)->c_selector;
# endif
	} else {
	    sel = __ContextInstPtr(theContext)->c_selector;
	}

	if ((sel == selector1)
	 || ((selector2 != nil) && (sel == selector2))
	 || ((selector3 != nil) && (sel == selector3))) {
	    if (__isLazy(theContext)) {
		__PATCHUPCONTEXT(theContext);
	    }
	    RETURN (theContext);
	}
	theContext = __ContextInstPtr(theContext)->c_sender;
    }
    RETURN (nil);
#endif
%}.
    "
     |con sel|

     con := self sender.
     [con notNil] whileTrue:[
	sel := con selector.
	sel == selector1 ifTrue:[^ con].
	(selector2 notNil and:[sel == selector2]) ifTrue:[^ con].
	(selector3 notNil and:[sel == selector3]) ifTrue:[^ con].
	con := con sender.
     ].
     ^ nil
    "
!

findNextUnwindContextOr:aContext
    "walk along the sender chain (starting at the sender),
     for a context marked for unwindAction or aContext.
     This non-standard interface is only to be used by mySelf"

    "/ this could have been (actually: was) implemented as:
    "/
    "/  |con|
    "/
    "/  con := self sender.
    "/  [con notNil
    "/   and:[con ~~ aContext
    "/   and:[con isUnwindContext not]]] whileTrue:[con := con sender].
    "/  ^ con
    "/
    "/ and the code below does exactly this (somewhat faster, though).
    "/ (it avoids referencing all intermediate contexts, which would mark them special,
    "/  although they aren't really - this is expert knowledge, no need to understand that ...)

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	if (self == aContext) {
	    return __c__._RETURN(self);
	}

	STContinuation lastCallee = (STContinuation)self;
	STContinuation theContext = lastCallee.caller;

	while (theContext != null) {
	    if ((theContext == aContext)
	     || theContext.isMarkedForUnwind()) {
		theContext = lastCallee.sender();   // exposed
		return __c__._RETURN(theContext);
	    }
	    lastCallee = theContext;
	    theContext = lastCallee.caller;
	}
    }
#else
    OBJ theContext;

    if (self == aContext) {
	RETURN (self);
    }

    theContext = __INST(sender_);
    while (__isNonNilObject(theContext)) {
	if ((theContext == aContext)
	 || ((INT)(__ContextInstPtr(theContext)->c_flags) & __MASKSMALLINT(__UNWIND_MARK))) {
	    if (__isLazy(theContext)) {
		__PATCHUPCONTEXT(theContext);
	    }
	    RETURN (theContext);
	}
	theContext = __ContextInstPtr(theContext)->c_sender;
    }
#endif
%}.
    ^ nil
!

findSpecialHandle:findHandleContext raise:findRaiseContext
    "walk along the sender chain (starting with the sender),
     for a context which is marked as handle or raise context.
     This non-standard interface is only to be used by exception"

    "/ this could have been (actually: was) implemented as:
    "/
    "/  |con|
    "/
    "/  con := self sender.
    "/  [con notNil] whileTrue:[
    "/      (findHandleContext and:[con isHandleContext]) ifTrue:[^con].
    "/      (findRaiseContext and:[con isRaiseContext]) ifTrue:[^con].
    "/      con := con sender.
    "/  ].
    "/  ^ nil
    "/
    "/ and the code below does exactly this (somewhat faster, though).
    "/
    "/ (it avoids referencing all intermediate contexts, which would mark them special,
    "/  although they aren't really - this is expert knowledge, no need to understand that ...)

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	STContinuation lastCallee = (STContinuation)self;
	STContinuation theContext = lastCallee.caller;

	while (theContext != null) {
	    if (theContext.isMarkedSpecial()) {
		if ((findHandleContext == STObject.True)
		    && theContext.isMarkedForHandle()) {
		    theContext = lastCallee.sender();   // exposed
		    return __c__._RETURN(theContext);
		}
		if ((findRaiseContext == STObject.True)
		    && theContext.isMarkedForRaise()) {
		    theContext = lastCallee.sender();   // exposed
		    return __c__._RETURN(theContext);
		}
	    }
	    lastCallee = theContext;
	    theContext = lastCallee.caller;
	}
    }
#else
    OBJ theContext;
    int flagMask = 0;
    INT mask;

    if (findHandleContext == true)
	flagMask = __HANDLE_MARK;
    if (findRaiseContext == true)
	flagMask |= __RAISE_MARK;

    mask = __MASKSMALLINT(flagMask);
    theContext = __INST(sender_);
    while (__isNonNilObject(theContext)) {
	if ((INT)(__ContextInstPtr(theContext)->c_flags) & mask) {
	    if (__isLazy(theContext)) {
		__PATCHUPCONTEXT(theContext);
	    }
	    RETURN (theContext);
	}
	theContext = __ContextInstPtr(theContext)->c_sender;
    }
#endif
%}.
    ^ nil
! !

!Context methodsFor:'special accessing'!

argAndVarNames
    "helper: given a context, return a collection of arg&var names"

    |homeContext homeMethod block numArgs numVars m src
     sel isDoIt blocksLineNr extractFromBlock sender|

    numArgs := self argumentCount.
    numVars := self numVars.
    (numArgs == 0 and:[numVars == 0]) ifTrue:[^ #()].

    homeContext := self methodHome.
    homeContext notNil ifTrue:[
        sel := homeContext selector.
        homeMethod := homeContext method.
    ].

    extractFromBlock :=
        [
            |blockNode argNames varNames vars args blocksHome|

            blockNode := Compiler
                            blockAtLine:blocksLineNr
                            in:m
                            orSource:src
                            numArgs:numArgs
                            numVars:numVars.

            blockNode notNil ifTrue:[
                "/ a kludge
                blockNode lineNumber == blocksLineNr ifTrue:[
                    blocksHome := blockNode home.
                    (blocksHome notNil and:[blocksHome isBlock]) ifTrue:[
                        (blocksHome numArgs == numArgs
                        and:[ blocksHome numVars == numVars ]) ifTrue:[
                            blockNode := blocksHome
                        ].
                    ].
                ].

                argNames := #().
                varNames := #().

                numArgs > 0 ifTrue:[
                    vars := blockNode arguments.
                    vars notEmptyOrNil ifTrue:[
                        argNames := vars collect:[:var | var name]
                    ]
                ].
                numVars > 0 ifTrue:[
                    vars := blockNode variablesIncludingInlined: (homeMethod hasCode and:[homeMethod isDynamic not]).
                    vars notEmptyOrNil ifTrue:[
                        varNames := vars collect:[:var | var name].
                    ]
                ].
                ^ argNames , varNames
            ].
        ].

    "/ #doIt needs special handling below
    isDoIt := (sel == #'doIt') or:[sel == #'doIt:'].
    self isBlockContext ifFalse:[
        isDoIt ifTrue:[
            homeMethod notNil ifTrue:[
                "/ special for #doIt
                m := nil.
                src := ('[' , homeMethod source , '\]') withCRs.
                "/ blocksLineNr := self lineNumber.
                blocksLineNr := (self home ? self) lineNumber.
                extractFromBlock value.
            ]
        ].

        homeMethod notNil ifTrue:[
            ^ homeMethod methodArgAndVarNamesInContext: self.
        ].
        ^ #()
    ].

    homeMethod notNil ifTrue:[
        isDoIt ifTrue:[
            "/ special for #doIt
            "/ my source is found in the method.
            m := nil.
            src := ('[' , homeMethod source , '\]') withCRs.
        ] ifFalse:[
            m := homeMethod.
            src := nil.
        ].
        blocksLineNr := self lineNumber.
        extractFromBlock value.
        blocksLineNr := self home lineNumber.
        extractFromBlock value.
    ].

    blocksLineNr isNil ifTrue:[
        self isBlockContext ifTrue:[
            sender := self sender.
            (sender notNil
            and:[sender receiver isBlock
            and:[sender selector startsWith:'value']])
            ifTrue:[
                block := sender receiver.
                src := block source.
                src isNil ifTrue:[
                    self error:'no source'.
                ].
                blocksLineNr := 1.
                extractFromBlock value.
            ].
            sender := nil.
        ].
    ].

    ^ #()

    "Modified: / 26-12-2015 / 08:20:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canResume
    "return true, if the receiver allows to be resumed.
     In ST/X, due to the implementation, this requires that the context which
     is right below the receiver is returnable and still active."

    |theContext|

    "
     starting with this context, find the one below
     (i.e. the one that I have called) and return from it.
    "
%{
#ifdef __SCHTEAM__
    // in the SCHTEAM-engine, all contexts are resumable
    return context._RETURN_true();
#else
    OBJ sndr;

    theContext = __thisContext;
    while (theContext != nil) {
	sndr = __ContextInstPtr(theContext)->c_sender;
	if (sndr == self) break;
	theContext = sndr;
    }
    if (theContext != nil) {
	if (__isLazy(theContext)) {
	    __PATCHUPCONTEXT(theContext);
	}
    }
#endif
%}.
    theContext isNil ifTrue:[
	^ false
    ].
    ^ theContext canReturn
!

canReturn
    "return true, if the receiver allows returning through it.
     Blocks, (currently) always return false.
     Methods which contain a (non-inlined) block are always
     returnable - for other methods, it depends on how the system
     was compiled (stc flag +/-optContext).
     If it was compiled with +optContext, methods are compiled
     non returnable, unless a return-pragma was present in the method.
     Since this saves some administrative work in every method
     invocation and makes overall execution faster, the system classes
     are all compiled with this flag turned on.
     This means, that by default, it is not possible to walk up the
     calling chain and return to an arbitrary context.
     For contexts which are known to require this (i.e. handlers as found
     by the exception walkers, these are marked specially (markForReturn),
     so compilers know that they should create full featured contexts."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    // in the SCHTEAM-engine, all contexts can be returned from
    return context._RETURN_true();
#else
    RETURN ( ((INT)(__INST(flags)) & __MASKSMALLINT(__CANNOT_RETURN)) ? false : true );
#endif
%}.
    ^ true
!

hasStackToShow
    "private interface to the debugger.
     Smalltalk contexts return false here - other language frames
     (i.e. Java frames) may want to show the evaluation stack"

    ^ false

    "Created: 28.6.1996 / 14:48:39 / cg"
    "Modified: 13.5.1997 / 16:31:12 / cg"
!

isHandleContext
    "return true, if this is a context with exception-handle flag set"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN ( ((STContinuation)self).isMarkedForHandle() );
#else
     RETURN ( ((INT)__INST(flags) & __MASKSMALLINT(__HANDLE_MARK)) ? true : false );
#endif
%}
!

isNonLifo
    "return true, if this is a nonLifo context.
     A nonLifo context is one that is still on the machine stack,
     but has a reference taken and needs to be converted to a real
     object (in objectMemory) when the method/block returns.
     You don't have to understand this - this is a special ST/X
     debug query, which may be removed without notice."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN ( ((STContinuation)self).isNonLifo() );
#else
     RETURN ( ((INT)__INST(flags) & __MASKSMALLINT(__NONLIFO)) ? true : false );
#endif
%}
!

isOnMachineStack
    "return true, if this is a machine stack context as opposed to a
     real heap context (i.e. if it has not been captured and returned from).
     You don't have to understand this - this is a special ST/X
     debug query, which may be removed without notice."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN ( ! ((STContinuation)self).isCopiedToHeap() );
#else
    RETURN ( (__qSpace(self) >= STACKSPACE) ? true : false );
#endif
%}
!

isRaiseContext
    "return true, if this is a context with exception-raise flag set"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN ( ((STContinuation)self).isMarkedForRaise() );
#else
    RETURN ( ((INT)__INST(flags) & __MASKSMALLINT(__RAISE_MARK)) ? true : false );
#endif
%}
!

isSpecial
    "return true, if this is either a nonLifo or interrupted context"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN ( ((STContinuation)self).isMarkedSpecial() );
#else
    RETURN ( ((INT)__INST(flags) & __MASKSMALLINT(__SPECIAL)) ? true : false );
#endif
%}
!

isUnwindContext
    "return true, if this is an unwindContext"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN ( ((STContinuation)self).isMarkedForUnwind() );
#else
    RETURN ( ((INT)__INST(flags) & __MASKSMALLINT(__UNWIND_MARK)) ? true : false );
#endif
%}
!

tempNames
    "helper: given a context, return a collection of arg, var and temporary names"

    |names nTemps|

    names := self argAndVarNames.
    (nTemps := self numTemps) > 0 ifTrue:[
	^ names , ((1 to:nTemps) collect:[:idx | '_tmp' , idx printString]).
    ].
    ^ names.
! !

!Context methodsFor:'testing'!

isBlockContext
    "return true, iff the receiver is a BlockContext, false otherwise"

    ^ false
!

isCheapBlockContext
    "return true, iff the receiver is a BlockContext, for a cheap block, false otherwise.
     Cheap blocks do not refer to their home"

    ^ false

    "Created: / 19-07-2012 / 11:22:38 / cg"
!

isContext
    "return true, iff the receiver is a Context, false otherwise"

    ^ true
!

isReallyRecursive
    "return true, if this context is one of a recursive send of the same
     selector AND same argument(s) to the same receiver before.
     Here, different arguments are NOT ignored"

    |c count "{Class: SmallInteger }" sameArgs|

    count := 0.

    c := self findNextContextWithSelector:selector or:nil or:nil.
    [c notNil] whileTrue:[
        (c receiver == receiver) ifTrue:[
            c method == self method ifTrue:[
                sameArgs := true.
                1 to:self argumentCount do:[:i |
                    (c argAt:1) ~~ (self argAt:i)ifTrue:[
                        sameArgs := false
                    ]
                ].
                sameArgs ifTrue:[^ true].
            ]
        ].
        c := c findNextContextWithSelector:selector or:nil or:nil.

        "
         this special test was added to get out after a while
         if the sender chain is corrupt - this gives us at least
         a chance to find those errors.
        "
        count := count + 1.
        count >= 100000 ifTrue:[
            'Context [warning]: bad context chain' errorPrintCR.
            ^ true
        ]
    ].
    ^ false
!

isRecursive
    "return true, if this context is one of a recursive send of the same
     selector to the same receiver before.
     Here, different arguments are ignored - i.e. only the same method
     counts for recursiveness.
     Used to detect recursive errors or recursive printing - for example."

    |c count "{Class: SmallInteger }"|

    count := 0.

    c := self findNextContextWithSelector:selector or:nil or:nil.
    [c notNil] whileTrue:[
	(c receiver == receiver) ifTrue:[
"/            "
"/             stupid: the current ST/X context does not include
"/             the method, but the class, in which the search started ...
"/            "
"/            myMethodsClass isNil ifTrue:[
"/                myMethodsClass := self methodClass.
"/            ].
"/            c methodClass == myMethodsClass ifTrue:[
"/                ^ true
"/            ].
	    "/ now it does!!
	    c method == self method ifTrue:[^ true].
	].
	c := c findNextContextWithSelector:selector or:nil or:nil.

	"
	 this special test was added to get out after a while
	 if the sender chain is corrupt - this gives us at least
	 a chance to find those errors.
	"
	count := count + 1.
	count >= 100000 ifTrue:[
	    'Context [warning]: bad context chain' errorPrintCR.
	    ^ true
	]
    ].
    ^ false

    "Modified: 10.1.1997 / 17:34:26 / cg"
! !

!Context class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id: Context.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !


Context initialize!

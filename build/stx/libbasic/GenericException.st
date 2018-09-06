"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

Object subclass:#GenericException
	instanceVariableNames:'signal parameter messageText suspendedContext raiseContext
		handlerContext rejected originator proceedable'
	classVariableNames:'StrictRaising'
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

GenericException class instanceVariableNames:'NotifierString'

"
 No other class instance variables are inherited by this class.
"
!

!GenericException class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    Note:
        The instance based Signal framework is being replaced by
        class based exceptions.
        I.e. what used to be instances of Signal/QuerySignal is being
        rewritten into subclasses of Exception/Error/Query and Warning.
        Although the functionality is basically unchanged, the new
        class based exceptions are easier to instantiate (no need for
        creation in a classes initialize method), easier to use (no real
        need for Signal-constant accessors) and allow for easier parameter
        passing (not only a single parameter, but allows for individual
        exception subclasses to add additional state).

    GenericException and its subclasses implement the same protocol as Signal.
    So class based exceptions may be implemented as subclasses of GenericException.

    Normally all exceptions are subclasses of Exception. Exceptions, that are
    used for debugging or that are signalling errors in the exception system itself
    are direct subclasses of GenericException.

    Instances of Exception are passed to a Signal handling block as argument.
    The handler block may perform various actions by sending corresponding messages
    to the exception object. The following actions are possible:

        reject          - don't handle this signal;
                          another handler will be searched for,
                          upper in the calling hierarchy

        proceed         - return from the Signal>>raise, with nil as value

        proceedWith:val - same, but return val from Signal>>raise

        return          - return from the Signal>>handle:do:, with nil as value

        returnWith:val  - same, but return val from Signal>>handle:do:
                          (this is also the handler's default,
                           if it falls through; taking the handlerBlocks value
                           as return value)

        restart         - restart the Signal>>handle:do:, after repairing

    Via the Exception object, the handler can also query the state of execution:
    where the Signal was raised, where the handler is, the signal which caused
    the error and the messageText passed when the signal was raised. Also, an optional
    parameter can be passed - the use is signal specific.

    [instance variables:]
        signal           <Signal>     the signal which caused the exception

        parameter        <Object>     a parameter (if any) which was passed when raising
                                      the signal (only if raised with #raiseWith:aParameter)

        messageText      <String>     an messageText
                                      (usually the signals own messageText, but sometimes
                                       changed explicitely in #raiseWith:errorString:)

        suspendedContext <Context>    the context in which the raise occurred

        handlerContext   <Context>    the context of the handler (if any)

    In case of an unhandled signal raise, Exceptions EmergenyHandler will be evaluated.
    The default emergeny handler will enter the debugger.

    For applications, which do not want Debuggers to come up, other handlers are
    possible.
    For example, to get the typical C++ behavior, use:
        Exception emergencyHandler:[:ex | Smalltalk exitWithCoreDump]


    Raising:
        two different raising messages are to be used,
        depending on whether the exception is proceedable or not

        For some stupid reason, someone decided that the raise-code checks if
        the raising messages matches to what the signal thinks is its proceedability.
        (i.e. not only do both the sender and the signal itself specify proceedability,
         this is checked by the raise code and a warning is generated if there is a mismatch)
        This used to be even worse (WrongProceedabilityError), but we relaxed this to
        a message sent to stderr.

        That means, that PROCEEDABLE signals must be raised with:
            raiseRequest
        and NON-PROCEEDABLE signals must be raised with:
            raise

        If you don't know/care as a raiser, you can use
            raiseSignal
        which checks for proceedability and sends the appropriate message.
        (sigh)

    all of the 3 messages above come in various flavours:
        raiseXXX                - do not pass any additional parameter;
                                  default messageText

        raiseXXXWith:           - pass additional parameter;
                                  default messageText

        raiseXXXErrorString:    - do not pass any additional parameter;
                                  given errorString

        raiseXXXWith:errorString:
                                - pass any additional parameter;
                                  AND given errorString


    [see also:]
        Signal  SignalSet QuerySignal
        Context Block
        Object DebugView
        (``Exception handling and signals'': programming/exceptions.html)

    [author:]
        Claus Gittinger
"
!

examples
"
    Examples on Exception-raising & handling are found in the doc/coding
    section (CodingExamples).

    The emergencyHandler stuff is very useful, to prevent endUser applications
    from entering the debugger. See the examples in NoHandlerError.
"
! !

!GenericException class methodsFor:'initialization'!

initialize
    NotifierString := 'unknown exception'.
    "force strict signal checking in Smalltalk development - nobody cares otherwise"
    StrictRaising := Smalltalk isStandAloneApp not.     "set to true to check whether a signal may be raised proceedable"

    "Modified: / 04-08-1999 / 09:06:26 / stefan"
    "Modified: / 17-11-2010 / 17:53:13 / cg"
! !

!GenericException class methodsFor:'instance creation'!

new
    "{ Pragma: +inlineNew }"

    ^ self basicNew initialize creator:self.

    "Modified: / 23.7.1999 / 13:53:12 / stefan"
    "Created: / 24.7.1999 / 13:21:13 / stefan"
!

newException
    "{ Pragma: +inlineNew }"

    ^ self basicNew initialize creator:self.

    "Created: / 23.7.1999 / 13:45:49 / stefan"
    "Modified: / 24.7.1999 / 13:21:25 / stefan"
! !


!GenericException class methodsFor:'Compatibility-ANSI'!

signal
    "raise a signal proceedable or nonproceedable (whichever is right).
     ANSI compatibility."

    ^ self raiseSignal

    "Created: / 20-11-2006 / 14:00:09 / cg"
!

signalWith:messageText
    "raise a signal proceedable or nonproceedable (whichever is right).
     The argument is used as messageText.
     ANSI compatibility."

    <resource: #skipInDebuggersWalkBack>

    self raiseErrorString:messageText
! !


!GenericException class methodsFor:'accessing'!

errorString
    "#errorString is deprecated, use description instead"

    <resource:#obsolete>

    ^ self description
!

handlerBlock
    "Compatibility with Signal. Class based exceptions do not have a handler
     block. They redefine the #action method instead"

    ^ nil

    "Created: / 23.7.1999 / 14:43:18 / stefan"
    "Modified: / 24.7.1999 / 20:52:10 / stefan"
!

notifierString:aString

    NotifierString := aString
! !

!GenericException class methodsFor:'backward compatibility'!

abortingEmergencyHandler
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError abortingEmergencyHandler
!

dumpingEmergencyHandler
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError dumpingEmergencyHandler
!

emergencyHandler
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError emergencyHandler.
!

emergencyHandler:aOneArgBlock
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError emergencyHandler:aOneArgBlock
!

mailingEmergencyHandler
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError mailingEmergencyHandler
!

notifyingEmergencyHandler
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError notifyingEmergencyHandler
!

notifyingEmergencyHandlerForUserProcesses
    "WARNING: this method belongs to NoHandlerError, and has been moved there"
    <resource: #obsolete>

    ^ NoHandlerError notifyingEmergencyHandlerForUserProcesses
! !

!GenericException class methodsFor:'child signal creation'!

newSignal
    "create a new signal, using the receiver as a prototype and
     setting the parent of the new signal to the receiver."

    ^ self newSignalMayProceed:self mayProceed

    "Created: / 23.7.1999 / 20:13:23 / stefan"
!

newSignalMayProceed:mayProceedBoolean
    "create a new signal, using the receiver as a prototype and
     setting the parent of the new signal to the receiver."

    |sig|

    self isQuerySignal ifTrue:[
	sig := QuerySignal basicNew.
	mayProceedBoolean ifFalse:[
	    'Exception [warning]: nonProceedable queries do not make sense' infoPrintCR.
	].
    ] ifFalse:[
	sig := Signal basicNew.
    ].
    ^ sig
	mayProceed:mayProceedBoolean;
	notifierString:NotifierString;
	parent:self

    "Created: / 23.7.1999 / 20:12:43 / stefan"
! !

!GenericException class methodsFor:'converting'!

, anExceptionHandler
    "return a SignalSet with myself and anExceptionHandler"

    ^ SignalSet with:self with:anExceptionHandler
! !


!GenericException class methodsFor:'printing'!

description
    "return the notifier string.
     If the notifier string starts with space, prepend
     the parents notifier string.
     Subclasses may redefine this method."

    |parent|

    NotifierString isNil ifTrue:[
	^ self nameForDescription asString
    ].
    (NotifierString startsWith:Character space) ifTrue:[
	(parent := self parent) notNil ifTrue:[
	    ^ parent description, NotifierString
	].
    ].
    ^ NotifierString

    "
     Object errorSignal description
    "

    "Created: / 23-07-1999 / 14:22:25 / stefan"
    "Modified: / 10-02-2011 / 12:29:07 / cg"
!

nameForDescription
    "if no notifierString is specified, this is used.
     Can be redfined to hide the namespace in subclasses"

    ^ self name

    "Created: / 10-02-2011 / 12:28:51 / cg"
! !

!GenericException class methodsFor:'queries'!

accepts:aSignal
    "return true, if the receiver accepts the argument, aSignal.
     (i.e. the receiver is aSignal or a parent of it). False otherwise."

    |s|

    self == aSignal ifTrue:[^ true].
    aSignal isQuerySignal ifTrue:[^ false].

    s := aSignal parent.
    [s notNil] whileTrue:[
	self == s ifTrue:[^ true].
	s := s parent
    ].
    ^ false

    "Created: / 23.7.1999 / 14:00:47 / stefan"
!

exception:anException isHandledIn:aContext
    "return true, if there is a handler for anException in the
     contextChain starting with aContext."

    ^ (self handlerContextForException:anException in:aContext) notNil
!

exceptionHandlerFor:anException in:aContext
    "answer the exceptionHandler-block for anException from aContext."

    |sel|

    sel := aContext selector.
    (sel == #'handle:from:do:'
     or:[sel == #'handle:do:']) ifTrue:[
	^ aContext receiver
    ].

    ^ nil
!

handlerContextForException:anException in:aContext
    "return a handlerContext for anException in the
     contextChain starting with aContext.
     Returns nil, if there is no handler."

    |theContext ex1 con1|

    theContext := aContext findExceptional.
    [theContext notNil] whileTrue:[
	theContext isRaiseContext ifTrue:[
	    "skip all the contexts between the raise and the sender of #handle:do"
	    ex1 := theContext receiver.              "exception, that has been raised"
	    con1 := ex1 handlerContext.              "the context of the #handle:do:"
	    con1 notNil ifTrue:[
		"handlerContext may be nil, if this is a default action"
		theContext := con1.
	    ].
	    ex1 := con1 := nil.
	] ifFalse:[ |r|
	    ((r := theContext receiver) notNil
	     and:[(r handlerForSignal:anException context:theContext originator:nil) notNil]
	    ) ifTrue:[
		"found a handler context"
		^ theContext
	    ].
	].
	theContext notNil ifTrue:[
	    theContext := theContext findSpecialHandle:true raise:true.
	].
    ].

    ^ nil
!

handlerForSignal:signal context:theContext originator:originator
    "answer the handler block for the signal from originator.
     The block is retrieved from aContext.
     Answer nil if the signal is not handled"

    (theContext selector ~~ #'handle:from:do:'
     or:[(theContext argAt:2) == originator]) ifTrue:[
	(self == signal or:[self accepts:signal]) ifTrue:[
	    ^ (theContext argAt:1) ? [nil]
	]
    ].

    ^ nil

    "Created: / 25.7.1999 / 19:52:58 / stefan"
!

handlerProtectedBlock:doBlock inContext:context
    "set the handlerProtectedBlock in context"

    |sel|

    sel := context selector.
    sel == #handle:do: ifTrue:[
	context argAt:2 put:doBlock.
    ] ifFalse:[sel == #handle:from:do: ifTrue:[
	context argAt:3 put:doBlock.
    ]].
!

handles:anException
    "return true, if the receiver handles the argument, anException.
     (i.e. the receiver is anExceptions signal or a parent of it)"

    |signal|

    signal := anException creator.

    self == signal ifTrue:[^ true].               "quick check"
    anException isNotification ifTrue:[^ false].  "speed up queries by not traversing the parent chain"

    [(signal := signal parent) notNil] whileTrue:[
	self == signal ifTrue:[^ true].
    ].
    ^ false
!

isHandled
    "return true, if there is a handler for the receiver signal.
     Raising an unhandled signal will usually lead into the debugger,
     but can be caught globally by setting Exceptions EmergencyHandler."

    ^ self exception:self isHandledIn:(thisContext sender).

    "Created: / 23.7.1999 / 14:03:50 / stefan"
!

isHandledIn:aContext
    "return true, if there is a handler for the receiver signal in the
     contextChain starting with aContext."

    ^ self exception:self isHandledIn:aContext
!

parent
    "return the parent Signal/Exception of myself.
     Subclasses may redefine this to install themself as child of
     existing Signals."

    self == GenericException ifTrue:[
	^ nil
    ].

    ^ self superclass

    "Created: / 23.7.1999 / 14:01:29 / stefan"
    "Modified: / 23.7.1999 / 16:15:38 / stefan"
! !

!GenericException class methodsFor:'raising'!

raise
    "raise a signal nonproceedable.
     The signals notifierString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseIn:thisContext sender

    "Created: / 23-07-1999 / 14:07:17 / stefan"
    "Modified: / 10-08-2010 / 09:30:42 / cg"
!

raiseAsQuery
    "utility to avoid code duplication.
     raise the exception as a query. This means, that if it is unhandled,
     a default value is returned (i.e. an implicit resume).
     Return the handler's value (if there is one), or the default value, if not.
     Invoking the handler is exactly the functionality of Signal>>raiseRequest,
     but we can do it faster here (avoiding the construction of an exception instance)."

    |con signal ret|

    self isQuerySignal ifFalse:[ self error:'this may only be used by queries' ].

    con := Context findFirstSpecialHandle:true raise:false.
    [con notNil] whileTrue:[
        (con selector == #answer:do:) ifTrue:[
            signal := con receiver.
            signal == self ifTrue:[
                ret := con argAt:1.
                con := nil.
                ^ ret
            ].
            signal isNil ifTrue:[
                self error:'nil receiver in #answer:do: - send'.
            ].
            (signal accepts:self) ifTrue:[
                ret := con argAt:1.
                con := nil.
                ^ ret
            ].
        ] ifFalse:[
            "ask the receiver of the #handle:do: or #on:do: or whatever- message for the handler.
             nil is returned, if the signal is not accepted"
            |r|
            r := con receiver.     "receiver of #handle:do: or #on:do:"
            (r notNil and:[(r handlerForSignal:self
                                 context:con
                                 originator:thisContext sender homeReceiver) notNil]
            ) ifTrue:[
                "there is another handler block, maybe it will return the answer.
                 Call it via raiseRequest"
                con := nil.
                ^ here raiseRequest  "/ <- notice the here, to avoid recursion due
                                     "/ to redefined raiseRequest in Query
            ].
        ].
        con := con findSpecialHandle:true raise:false.
    ].

    "/ no handler found - return the default value
    ^ self defaultAnswer

    "Modified: / 15-06-1998 / 21:27:37 / cg"
    "Modified: / 25-07-1999 / 23:15:16 / stefan"
    "Modified: / 11-03-2015 / 11:26:45 / sr"
!

raiseErrorString:aString
    "raise a signal nonproceedable.
     The argument is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseErrorString:aString
	in:thisContext sender

    "Created: / 23-07-1999 / 14:07:33 / stefan"
    "Modified: / 10-08-2010 / 09:34:37 / cg"
!

raiseErrorString:aString in:aContext
    "raise a signal nonproceedable.
     The argument is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseErrorString:aString in:aContext

    "Created: / 23-07-1999 / 14:07:33 / stefan"
    "Modified: / 10-08-2010 / 09:35:37 / cg"
!

raiseFrom:something
    "raise a signal nonproceedable.
     The argument, something is passed both as parameter and originator."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender parameter:something originator:something)
	raise

    "Modified: / 2.5.1996 / 16:36:38 / cg"
    "Modified: / 5.3.1998 / 16:49:55 / stefan"
    "Created: / 23.7.1999 / 14:07:59 / stefan"
!

raiseIn:aContext
    "raise a signal nonproceedable.
     The signals notifierString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseIn:aContext

    "Created: / 27-01-2011 / 17:28:53 / cg"
!

raiseRequest
    "raise a signal proceedable.
     The signals notifierString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestIn:thisContext sender

    "Created: / 23-07-1999 / 14:08:24 / stefan"
    "Modified: / 10-08-2010 / 09:37:06 / cg"
!

raiseRequestErrorString:aString
    "raise a signal proceedable.
     The argument, aString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestErrorString:aString in:thisContext sender

    "Modified: / 10-08-2010 / 09:40:38 / cg"
!

raiseRequestFrom:something
    "raise a signal proceedable.
     The argument, something is passed both as parameter and originator."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender parameter:something originator:something)
	raiseRequest

    "Modified: / 2.5.1996 / 16:36:38 / cg"
    "Modified: / 5.3.1998 / 16:52:46 / stefan"
    "Created: / 23.7.1999 / 14:08:36 / stefan"
!

raiseRequestIn:aContext
    "raise a signal proceedable.
     The signals notifierString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestIn:aContext

    "Created: / 27-01-2011 / 17:28:53 / cg"
!

raiseRequestWith:aParameter
    "raise a signal proceedable.
     The signals notifierString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestWith:aParameter in:thisContext sender

    "Created: / 23-07-1999 / 14:08:48 / stefan"
    "Modified: / 10-08-2010 / 09:57:14 / cg"
!

raiseRequestWith:aParameter errorString:aString
    "raise a signal proceedable.
     The argument, aString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestWith:aParameter errorString:aString in:thisContext sender

    "Created: / 23-07-1999 / 14:08:57 / stefan"
    "Modified: / 10-08-2010 / 09:56:55 / cg"
!

raiseRequestWith:aParameter errorString:aString in:aContext
    "raise a signal proceedable.
     The argument, aString is used as messageText.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestWith:aParameter errorString:aString in:aContext

    "Created: / 23-07-1999 / 14:09:07 / stefan"
    "Modified: / 10-08-2010 / 09:56:36 / cg"
!

raiseRequestWith:aParameter in:aContext
    "raise a signal proceedable.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseRequestWith:aParameter in:aContext

    "Modified: / 10-08-2010 / 09:56:12 / cg"
!

raiseSignal
    "raise a signal (proceedable or not, whatever the proceedability is).
     The signals notifierString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender)
	raiseSignal

    "Modified: / 10.11.2001 / 15:13:34 / cg"
!

raiseSignal:errorMessage
    "ANSI: raise a signal (proceedable or not, whatever the proceedability is).
     The argument, errorMessage is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender errorString:errorMessage)
	raiseSignal.

    "Modified: / 07-08-2004 / 19:24:00 / stefan"
!

raiseSignal:errorMessage with:aParameter
    "ANSI: raise a signal (proceedable or not, whatever the proceedability is).
     The argument, errorMessage is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender parameter:aParameter errorString:errorMessage)
	raiseSignal.

    "Modified: / 07-08-2004 / 19:10:40 / stefan"
!

raiseSignalErrorString:aString
    "raise a signal (proceedable or not, whatever the proceedability is).
     The argument, aString is used as messageText."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender errorString:aString)
	raiseSignal.
!

raiseSignalWith:aParameter
    "raise a signal (proceedable or not, whatever the proceedability is).
     The argument, aParameter is passed as parameter."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender parameter:aParameter)
	raiseSignal.
!

raiseSignalWith:aParameter errorString:aString
    "raise a signal (proceedable or not, whatever the proceedability is).
     The argument, aString is used as messageText,
     aParameter is passed as exception parameter."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ (self newException
	suspendedContext:thisContext sender parameter:aParameter errorString:aString)
	raiseSignal.
!

raiseWith:aParameter
    "raise a signal nonproceedable.
     The argument, aParameter is passed as parameter."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseWith:aParameter in:thisContext sender

    "Created: / 23-07-1999 / 14:09:27 / stefan"
    "Modified: / 10-08-2010 / 09:51:11 / cg"
!

raiseWith:aParameter errorString:aString
    "raise a signal nonproceedable.
     The argument, aString is used as messageText,
     aParameter is passed as exception parameter."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	  raiseWith:aParameter errorString:aString in:thisContext sender.

    "Created: / 23-07-1999 / 14:09:36 / stefan"
    "Modified: / 10-08-2010 / 09:52:59 / cg"
!

raiseWith:aParameter errorString:aString in:aContext
    "raise a signal nonproceedable.
     The argument, aString is used as messageText, aParameter is passed
     as exception parameter.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	  raiseWith:aParameter errorString:aString in:aContext.

    "Created: / 23-07-1999 / 14:09:46 / stefan"
    "Modified: / 10-08-2010 / 09:52:10 / cg"
!

raiseWith:aParameter in:aContext
    "raise a signal nonproceedable.
     The argument, aParameter is passed as exception parameter.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    ^ self basicNew
	raiseWith:aParameter in:aContext

    "Modified: / 10-08-2010 / 09:52:38 / cg"
! !

!GenericException class methodsFor:'save evaluation'!

catch:aBlock
    "evaluate the argument, aBlock.
     If the receiver-exception is raised during evaluation, abort
     the evaluation and return true; otherwise return false.
     This is the catch & throw mechanism found in other languages,
     where the returned value indicates if an exception occurred."

    |raiseOccurred|

    raiseOccurred := false.
    self handle:[:ex | raiseOccurred := true. ex return] do:aBlock.
    ^ raiseOccurred

    "
     Object messageNotUnderstoodSignal catch:[
        123 size open
     ]
    "

    "Created: / 23-07-1999 / 14:06:01 / stefan"
    "Modified: / 07-12-2006 / 17:05:17 / cg"
!

deferAfter:aBlock
    "evaluate the argument, aBlock.
     Ignore the receiver-exception during evaluation - i.e. simply continue,
     but remember if the signal was raised.
     After the block evaluation, finally raise the signal - if it was raised in the block.
     If the signal is raised multiple times, only the first raises parameter is remembered,
     and only a single raise is performed after the blocks evaluation.

     Deferring makes sense for some signals, such as UserInterrupt or AbortSignal,
     which must occasionally be delayed temporarily until a save place is reached
     (especially when packages are sent across a communication channel, and you don't want
      partial packages to be generated by user interruptions)."

    |caughtException result|

    self handle:[:ex |
        caughtException isNil ifTrue:[
            caughtException := ex.
        ].
        ex proceedWith:nil
    ] do:[
        result := aBlock value.
    ].
    caughtException notNil ifTrue:[
        caughtException suspendedContext:thisContext.

        "/ the exception was raised during the execution of aBlock above.
        "/ Raise it now (delayed).
        caughtException raiseSignal.
    ].
    ^ result

    "
     UserInterrupt deferAfter:[
         Transcript showCR:'1 - now raising, but will be deferred.'.
         UserInterrupt raiseRequestWith:'hello'.
         Transcript showCR:'2 - after the raise, deferred exception will be handled soon.'.
     ].
     Transcript showCR:'3 - here after the protected block.'.
    "

    "Modified: / 07-12-2006 / 17:05:28 / cg"
!

evaluate:aBlock ifRaised:exceptionValue
    "evaluate the argument, aBlock and return its value.
     If the receiver-signal is raised during evaluation, abort
     the evaluation and return the value from exceptionValue.
     This is similar to the catch & throw mechanism found in other languages"

    ^ self handle:[:ex | exceptionValue value] do:aBlock.

    "
     Object messageNotUnderstoodSignal
	evaluate:[ 123 size open ]
	ifRaised:345
    "
!

handle:handleBlock do:aBlock
    "evaluate the argument, aBlock.
     If the receiver-exception is raised during evaluation,
     evaluate the handleBlock passing it an Exception argument.
     The handler may decide how to react to the signal by sending
     a corresponding message to the exception (see there).
     If the signal is not raised, return the value of evaluating
     aBlock."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ aBlock value  "the real logic is in Exception>>doRaise"

    "
     Object messageNotUnderstoodSignal handle:[:ex |
	'oops' printNL.
	ex return
     ] do:[
	123 size open
     ]
     "

     "
      |num|

      num := 0.
      Number divisionByZeroSignal handle:[:ex |
	  'oops' printNL.
	  ex return
      ] do:[
	  123 / num
      ]
     "

    "Created: / 23-07-1999 / 14:06:13 / stefan"
    "Modified: / 25-07-1999 / 19:44:05 / stefan"
    "Modified: / 07-12-2006 / 17:05:30 / cg"
!

handle:handleBlock from:anObject do:aBlock
    "evaluate the argument, aBlock.
     If the receiver-exception is raised during evaluation,
     and the exception originated from anObject,
     evaluate the handleBlock passing it an Exception argument.
     The handler may decide how to react to the signal by sending
     a corresponding message to the exception (see there).
     If the signal is not raised, return the value of evaluating
     aBlock."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ aBlock value  "the real logic is in Exception>>doRaise"

    "
     the first open will be caught; the second not:

     |o1 o2|

     o1 := 123.
     o2 := nil.
     Object messageNotUnderstoodSignal
	 handle:
		[:ex |
		    'oops' printNL.
		    ex proceed
		]
	 from:o1
	 do:
		[
		    o1 open.
		    o2 open
		]
    "

    "Created: / 23-07-1999 / 14:06:26 / stefan"
    "Modified: / 25-07-1999 / 19:44:13 / stefan"
    "Modified: / 07-12-2006 / 17:05:33 / cg"
!

ignoreIn:aBlock
    "evaluate the argument, aBlock.
     Ignore the receiver-exception during evaluation - i.e. simply continue.
     This makes only sense for some signals, such as UserInterrupt
     or AbortSignal, because continuing after an exception without any cleanup
     often leads to followup-errors."

    ^ self handle:[:ex | ex proceedWith:nil] do:aBlock.

    "
     Object messageNotUnderstoodSignal ignoreIn:[
	123 size open
     ]
    "

    "Created: / 23-07-1999 / 14:06:40 / stefan"
    "Modified: / 07-12-2006 / 17:05:35 / cg"
! !

!GenericException class methodsFor:'testing'!

isAbstract
    ^ self == GenericException
!

isControlInterrupt
    ^ false

    "Created: / 16.11.2001 / 16:11:54 / cg"
!

isExceptionCreator
    "return true, if the receiver can create exceptions,
     this includes #raise, #raiseRequest as well as the behavior of
     an exception handler, such as the #accepts: and #handles: messages"

    ^ true
!

isExceptionHandler
    "return true, if the receiver responds to the exception handler protocol,
     especially to the #accepts: and #handles: messages"

    ^ true

    "Created: / 23.7.1999 / 13:49:59 / stefan"
!

isProgramError
    "redefined in all exceptions which are programmer's errors,
     and which should probably not be ignored.
     I.e. a global error handler should reject and let a debugger get control."

    ^ false
!

isQuerySignal
    "return true, if this is a querySignal - always return false here"

    ^ false

    "Created: / 23.7.1999 / 13:50:16 / stefan"
!

mayProceed
    "return true, if the exception handler is allowed to proceed
     the execution where the exception occurred.

     Subclasses may redefine this."

    ^ true

    "Modified: / 23.7.1999 / 14:50:11 / stefan"
! !


!GenericException methodsFor:'Compatibility-ANSI'!

pass
    "same as reject - for ANSI compatibility"

    ^ self reject
!

retry
    "same as #restart - ANSI & VW compatibility"

    self restart

    "Created: / 7.9.2001 / 13:31:02 / cg"
!

retryUsing: alternativeBlock
    "Abort an exception handler and evaluate a new block in place of the handler's protected block."

    "/ self mustBeHandled ifFalse: [ ^self ].

    ^ self restartDo:alternativeBlock
!

signalWith:messageTextArg
    "raise a signal proceedable or nonproceedable (whichever is right).
     The argument is used as messageText.
     ANSI compatibility."

    self messageText:messageTextArg.
    ^ self raise
! !

!GenericException methodsFor:'Compatibility-Dolphin'!

stackTrace:numberOfFrames
    "return a backtrace information string"

    |con|

    con := suspendedContext.
    ^ ((1 to:numberOfFrames)
	collect:[:idx |
	    |s|

	    s := con printString.
	    con := con sender.
	    s
	]) asStringWith:Character cr.

    "
     Error handle:[:ex |
	(ex stackTrace:20) inspect.
     ] do:[
	self error
     ].
    "
! !

!GenericException methodsFor:'Compatibility-Squeak'!

signalerContext
    "return the context in which the raise occurred.
     Same as suspendedContext, for squeak compatibility"
     
    ^ self suspendedContext
! !

!GenericException methodsFor:'Compatibility-V''Age'!

exitWith:value
    "return with a value.
     V'AGE compatibility."

    ^ self return:value

    "Created: / 28-08-2010 / 14:43:23 / cg"
! !

!GenericException methodsFor:'accessing'!

catchInDebugger
    "if set, the debugger will handle this signal in its event loop and will close itself
     without asking for close-confirmation.
     This allows for debugged processes to be terminated without a user confirmation dialog
     (for now, this is used in expecco's hard-terminate function to shut down any open debuggers
      together with the test-process).
     Dummy here"

    ^ false
!

catchInDebugger:aBoolean
    "if set, the debugger will handle this signal in its event loop and will close itself
     without asking for close-confirmation.
     This allows for debugged processes to be terminated without a user confirmation dialog
     (for now, this is used in expecco's hard-terminate function to shut down any open debuggers
      together with the test-process).
     Dummy here"

    "/ ignored
!

creator
    "return the creator of the exception.
     For class based exceptions, that is the exception class;
     for signals, that is the signal itself.
     This used to be called 'signal' in earlier versions,
     but due to the conflict with VSE, Squeak and others,
     where 'signal' means 'raise', 'signal' was obsoleted by this method."

    signal notNil ifTrue:[^ signal] ifFalse:[^ self class]
!

errorString
    "return the errorString passsed with the signal raise
     (or nil, if there was none).
     #errorString is deprecated, use description instead"

    <resource:#obsolete>

    ^ self description

    "Modified: / 12.3.1998 / 15:13:28 / stefan"
!

errorString:aString
    "set the messageText.
     If it starts with a space, the signals messageText is prepended,
     if it ends with a space, it is appended.
     #errorString: is deprecated, use messageText: instead"

    <resource:#obsolete>

    messageText := aString

    "Created: / 5.3.1998 / 16:45:29 / stefan"
    "Modified: / 12.3.1998 / 15:30:45 / stefan"
!

handler
    "return the exception handler (Signal or SignalSet or ExceptionHandlerSet or Exception)
     that handles the exception.
     This is only valid during handler evaluation, and answers
     the object which accepted the actual exception."

    handlerContext isNil ifTrue:[
	^ nil.
    ].
    ^ handlerContext receiver exceptionHandlerFor:self in:handlerContext.

    "
      [
	  2 // 0
      ] on:Error do:[:ex| ex handler inspect]

      [
	  2 // 0
      ] on:ArithmeticError, Error do:[:ex| ex handler inspect]

      [
	  2 // 0
      ] on:MessageNotUnderstood do:[:ex| ex handler inspect]
	on:Error do:[:ex| ex handler inspect]
    "
!

handlerContext
    "return the context of the handler"

    ^ handlerContext
!

handlingException
    <resource: #obsolete>
    ^ self handler
!

isResumable
    "return true, if the exception is resumable"

    ^ self mayProceed

    "Modified: / 2.3.1998 / 12:20:43 / stefan"
!

isResumable:aBoolean
    proceedable := aBoolean
!

messageText
    "return the explicit given messageText - nil, if signaler did not provide one."

    ^ messageText
!

messageText:aString
    "set the messageText.
     If it starts with a space, the signal's original messageText is prepended,
     if it ends with a space, it is appended."

    messageText := aString

    "Created: / 05-03-1998 / 16:45:29 / stefan"
    "Modified: / 12-03-1998 / 15:30:45 / stefan"
    "Modified (comment): / 30-07-2013 / 21:04:43 / cg"
!

originalSignal
    "return the signal/exception which was originally raised.
     For noHandler, that is my unhandled signal; for others, that's the exception itself."

    ^ self.
!

originator
    "return the originator passsed with the signal raise
     (or nil, if there was none)"

    ^ originator
!

originator:anObject
    "set the originator"

    originator := anObject

    "Created: / 5.3.1998 / 16:34:56 / stefan"
!

parameter
    "return the parameter passsed with the signal raise
     (or nil, if there was none)"

    ^ parameter
!

parameter:anObject
    "set the parameter of the exception"

    parameter := anObject

    "Created: / 5.3.1998 / 16:34:22 / stefan"
!

proceedable:aBoolean
    "explicitly change the proceedability.
     Normally this gets initialized from the classes idea of whether this makes sense"

    proceedable := aBoolean
!

raiseContext
    ^ raiseContext
!

rejected
    "return true, if any other of the exception's handlers has rejected
     Uncertain, if this is really interesting to anybody.
     This is only valid during handler execution.
     (i.e. an outer handler can find out, if any other handler has already rejected).
     Currently only used to change the 'unhandled-exception' messageText
     into 'rejected-exception' for the information, that there was a handler which rejected.
    "

    ^ rejected == true
!

returnableSuspendedContext
    "return a nearest returnable context above suspendedContext in the sender chain.
     We know, that raiseContext is always returnable, so if suspendedContext
     is non-returnable, start there"

    |returnableContext nextContext|

    returnableContext := suspendedContext.
    returnableContext canReturn ifFalse:[
        "the context that triggered the exception cannot return.
         This is a fallback: return the context of the raise*.
         We know, that this context is returnable"

        returnableContext := nextContext := raiseContext.
        "find the returnable context that is the nearest in the sender chain
         to suspendedContext...."
        [
            nextContext := nextContext sender.
            nextContext isNil ifTrue:[
                "suspendedContext appears to not exist on sender chain..."
                ^ raiseContext.
            ].
            nextContext canReturn ifTrue:[
                returnableContext := nextContext.
            ].
            nextContext ~~ suspendedContext.
        ] whileTrue.
    ].
    ^ returnableContext
!

searchFrom:raisingContext
    suspendedContext := raisingContext
!

suspendedContext
    "return the context in which the raise occurred"

    ^ suspendedContext
!

suspendedContext:something
    "set the value of the instance variable 'suspendedContext' (automatically generated)"

    suspendedContext := something.

    "Created: / 2.3.1998 / 12:43:20 / stefan"
!

willProceed
    "return true, if the exception is proceedable"

    ^ self isResumable

    "Modified: / 2.3.1998 / 12:20:43 / stefan"
! !

!GenericException methodsFor:'copying'!

postCopy
    "set the internal state to nil"

    raiseContext := suspendedContext := handlerContext := rejected := nil

    "Created: / 2.3.1998 / 12:30:06 / stefan"
!

postDeepCopy
    "set the internal state to nil"

    suspendedContext := handlerContext := rejected := nil

    "Created: / 2.3.1998 / 12:30:06 / stefan"
! !

!GenericException methodsFor:'default actions'!

defaultAction
    "perform a action for the exception if it hasn't been catched
     We arrive here, if either no handler was found, or none of the
     handlers did a return (i.e. every handler rejected).

     The default is to evaluate the signal's handlerBlock or
     to raise the noHandlerSignal.
     Subclasses may redefine this."

    <context: #return>

    |handlerBlock|

    "
     try per signal handler
    "
    (handlerBlock := self creator handlerBlock) notNil ifTrue:[
	"... and call it"
	^ handlerBlock value:self.
    ].

    ^ self noHandler.

    "Created: / 23.7.1999 / 14:38:03 / stefan"
    "Modified: / 4.8.1999 / 08:11:05 / stefan"
!

mayProceed
    "return true, if the exception handler is allowed to proceed
     the execution where the exception occurred.

     Subclasses may redefine this."

    proceedable notNil ifTrue:[^ proceedable].
    signal notNil ifTrue:[^ signal mayProceed].
    ^ self class mayProceed.

    "Created: / 23-07-1999 / 14:48:26 / stefan"
    "Modified: / 10-08-2010 / 09:39:15 / cg"
!

noHandler
    "raise the NoHandlerError.
     NohandlerError redefines this method to avoid recursive invocations"

    <context: #return>

    |msg|

    rejected == true ifTrue:[
	msg := 'unhandled (rejected)'
    ] ifFalse:[
	msg := 'unhandled'
    ].
    msg := msg , ' exception: (' , self description , ')'.
    self mayProceed ifTrue:[
	^ NoHandlerError
	      raiseRequestWith:self
	      errorString:msg
	      in:suspendedContext.
    ].
    ^ NoHandlerError
	  raiseWith:self
	  errorString:msg
	  in:suspendedContext.
! !

!GenericException methodsFor:'default values'!

defaultResumeValue
    "the default answer, if no one handles the query and the exception is resumed"

    ^ nil
!

defaultReturnValue
    ^ nil
! !

!GenericException methodsFor:'handler actions'!

exit
    "either resume or return - depending on the receiver's resumability.
     VW compatibility."

    self isResumable ifTrue:[
	self proceedWith:(self defaultResumeValue)
    ] ifFalse:[
	self return:(self defaultReturnValue)
    ]

    "Modified: / 7.9.2001 / 13:28:54 / cg"
!

exit:value
    "either resume or return - depending on the receiver's resumability.
     VW compatibility."

    self isResumable ifTrue:[
	self proceedWith:value
    ] ifFalse:[
	self return:value
    ]

    "Created: / 7.9.2001 / 13:29:55 / cg"
    "Modified: / 7.9.2001 / 13:30:00 / cg"
!

proceed
    "Continue after the raise - the raise returns nil"

    self proceedWith:(self defaultResumeValue).

    "cg: a strange example:
	there are two caught errors here - can you spot them ?

     Error handle:[:ex|
	 'proceeding' printCR.
	 ex proceed
     ] do:[
	 Error raiseRequest
     ].
    "

    "Modified: / 4.8.1999 / 08:42:12 / stefan"
    "Modified: / 7.9.2001 / 13:29:08 / cg"
!

proceedWith:value
    "Continue after the raise - the raise returns value"

    |con rCon|

    (StrictRaising and:[proceedable not]) ifTrue:[
	"proceed from ProceedError to recover from this error"
	ProceedError raiseRequestWith:self.
	proceedable := true.
    ].

    thisContext evaluateUnwindActionsUpTo:suspendedContext.

    con := suspendedContext.
    rCon := raiseContext.
    handlerContext := suspendedContext := raiseContext := nil.
    con resumeIgnoringErrors:value.

    "we arrive here, if suspendedContext is not resumable -
     resume our raise context ...
      ... consider this a fallBack kludge, for the case that
	  a raising context is not returnable."

    rCon return:value.

    "Modified: / 27.3.1997 / 16:45:57 / cg"
    "Modified: / 4.8.1999 / 08:42:17 / stefan"
!

reject
    "handler decided not to handle this signal -
     system will look for another handler"

    |con|

    "find the last doCallXX: context"
    con := Context findFirstSpecialHandle:false raise:true.
    [con notNil
     and:[con receiver ~~ self]] whileTrue:[
	con := con findSpecialHandle:false raise:true.
    ].

    "returning form the doCallXX: signals a reject"
    rejected := true.
    con unwind:nil.

    "
     Error handle:[:ex |
	'1' printCR.
	ex reject
     ] do:[
	Error handle:[:ex |
	    '2' printCR.
	    ex reject
	] do:[
	    #() at:1
	]
     ]
    "
!

resignalAs:anotherException
    "resignal anotherException, as if it was raised in the first place"

    |con|

    con := self returnableSuspendedContext.
    thisContext evaluateUnwindActionsUpTo:con.
    handlerContext := suspendedContext := raiseContext := nil.
    con returnDoing:[anotherException raiseSignal]

    "
     |rslt|

     ZeroDivide handle:[:ex |
	ex resignalAs:DomainError
     ] do:[
	rslt := 5 // 0
     ].
     rslt
    "

    "
     |rslt|

     MessageNotUnderstood handle:[:ex |
	ex resignalAs:Number domainErrorSignal
     ] do:[
	rslt := 1 perform:#foo
     ].
     rslt
    "

    "
     |rslt firstTime|

     firstTime := true.
     ZeroDivide handle:[:ex |
	firstTime ifTrue:[
	    Dialog information:'again...'.
	    firstTime := false.
	    ex resignalAs:ZeroDivide.
	].
	Dialog information:'arrived here again...'.
     ] do:[
	rslt := 5 // 0
     ].
     rslt
    "
!

restart
    "restart the handle:do: - usually after some repair work is done
     in the handler"

    |con|

    con := handlerContext.
    handlerContext := suspendedContext := raiseContext := nil.
    con unwindAndRestart.

"/    thisContext evaluateUnwindActionsUpTo:con.
"/    handlerContext := suspendedContext := raiseContext := nil.
"/    con restart

    "
     |rslt n|

     Error handle:[:ex |
	Transcript showCR:'fixing divisor ...'.
	n := 1.
	ex restart.
     ] do:[
	rslt := 5 / n.
     ].
     rslt
    "
!

restartDo:aBlock
    "restart the handle:do: but execute the argument, aBlock instead of the
     original do-block - usually after some repair work is done in handler"

    |con|

    con := handlerContext.

"/    handlerContext unwindThenDo:[
"/        handlerContext receiver
"/            handle:(handlerContext argAt:1)
"/            do:aBlock
"/    ].

    con receiver handlerProtectedBlock:aBlock inContext:con.
"/    thisContext evaluateUnwindActionsUpTo:con.
"/    handlerContext := suspendedContext := raiseContext := nil.
"/    con restart
    handlerContext := suspendedContext := raiseContext := nil.
    con unwindAndRestart.

    "
     |sig rslt|

     sig := Signal new.

     sig handle:[:ex |
	Transcript showCR:'exchanging do-block ...'.
	ex restartDo:[ rslt := 999 ]
     ] do:[
	rslt := 0.
	sig raise
     ].
     Transcript showCR:rslt
    "

    "
     |sig rslt|

     Object errorSignal handle:[:ex |
	ex restartDo:[ rslt := 999 ]
     ] do:[
	rslt := nil foo.

     ].
     Transcript showCR:rslt
    "

    "
     |sig rslt|

     Object errorSignal handle:[:ex |
	ex restartDo:[ 'handler' printCR. rslt := nil foo ]
     ] do:[
	rslt := nil foo.

     ].
     Transcript showCR:rslt
    "

    "Modified: / 8.11.1997 / 18:52:28 / cg"
!

resume
    "Continue after the raise - the raise returns defaultResumeValue - ANSI"

    self proceedWith:(self defaultResumeValue)

    "Modified: / 2.3.1998 / 10:51:55 / stefan"
    "Modified: / 7.9.2001 / 13:28:34 / cg"
!

resume:value
    "Continue after the raise - the raise returns value - ANSI"

    self proceedWith:value

    "Modified: / 7.9.2001 / 13:28:49 / cg"
!

resumeWith:value
    "Continue after the raise - the raise returns value - ANSI"

    self proceedWith:value

    "Modified: / 2.3.1998 / 10:51:48 / stefan"
    "Modified: / 7.9.2001 / 13:29:26 / cg"
!

return
    "Continue after the handle:do: - the handle:do: returns nil"

    |con value|

    con := handlerContext.
    "/ cg: moving the following clearing of the handlerContext
    "/ to before the evalUnwindActions allows for the exception
    "/ to be handled during the unwind.
    "/ It can be discussed, whether this is correct or not;
    "/ I think, that the unwind actions should behave just the same as
    "/ when a normal return is done. As unwind actions are called,
    "/ these are unmarkedForUnwind anyway, so there should be no danger
    "/ for endless recursion here... (i.e. each unwind action can at most
    "/ reraise that exception once).
    value := self defaultReturnValue.   "/ evaluate before unwinding
    handlerContext := suspendedContext := raiseContext := nil.
    thisContext evaluateUnwindActionsUpTo:con.
    "/ handlerContext := suspendedContext := raiseContext := nil.
    con return:value

    "Modified: / 7.9.2001 / 13:29:34 / cg"
!

return:value
    "Continue after the handle:do: - the handle:do: returns value"

    |con|

    con := handlerContext.
    "/ cg: moving the following clearing of the handlerContext
    "/ to before the evalUnwindActions allows for the exception
    "/ to be handled during the unwind.
    "/ It can be discussed, whether this is correct or not;
    "/ I think, that the unwind actions should behave just the same as
    "/ when a normal return is done. As unwind actions are called,
    "/ these are unmarkedForUnwind anyway, so there should be no danger
    "/ for endless recursion here... (i.e. each unwind action can at most
    "/ reraise that exception once).
    handlerContext := suspendedContext := raiseContext := nil.
    thisContext evaluateUnwindActionsUpTo:con.
    "/ handlerContext := suspendedContext := raiseContext := nil.
    con return:value.

    "Modified: 27.3.1997 / 16:46:51 / cg"
!

returnDoing:aBlock
    "Continue after the handle:do: - the handle:do: returns aBlock value
     Be careful when debugging. You cannot see the context with #returnDoing:
     in the debugger if aBlock raises a signal"

    |con|

    con := handlerContext.
    "/ cg: moving the following clearing of the handlerContext
    "/ to before the evalUnwindActions allows for the exception
    "/ to be handled during the unwind.
    "/ It can be discussed, whether this is correct or not;
    "/ I think, that the unwind actions should behave just the same as
    "/ when a normal return is done. As unwind actions are called,
    "/ these are unmarkedForUnwind anyway, so there should be no danger
    "/ for endless recursion here... (i.e. each unwind action can at most
    "/ reraise that exception once).
    handlerContext := suspendedContext := raiseContext := nil.
    thisContext evaluateUnwindActionsUpTo:con.
    "/ handlerContext := suspendedContext := raiseContext := nil.
    con returnDoing:aBlock

    "
	[
	    5 // 0
	] on:Error do:[:ex|
	    ex returnDoing:[self halt. 47*11].
	]
    "
!

returnWith:value
    "Continue after the handle:do: - the handle:do: returns value"

    self return:value
! !

!GenericException methodsFor:'printing & storing'!

description
    "return the description string of the signal"

    |sigDescr|

    sigDescr := self creator description.
    (messageText isNil or:[messageText isString not])
    ifTrue:[
	^ sigDescr
    ].
    (messageText startsWith:Character space) ifTrue:[
	^ sigDescr, messageText.
    ].
    (messageText endsWith:Character space) ifTrue:[
	^ messageText, sigDescr.
    ].

    ^ messageText

    "
      (Error new messageText:'bla') description
      (Error new messageText:' bla') description
      (Error new messageText:'bla ') description
    "

    "Modified: / 12.3.1998 / 15:13:28 / stefan"
!

descriptionForDebugger
    "return the description string of the signal which is used in the
     debugger title area"

    ^ self description.
!

printOn:aStream
    aStream nextPutAll:self description
! !

!GenericException methodsFor:'private'!

checkProceedable
    "helper for all raiseRequest methods"

    self mayProceed ifFalse:[
	StrictRaising ifTrue:[
	    "/ proceeding from wrongProceedabilitySignal grants the raiseRequest
	    WrongProceedabilityError raiseRequestWith:self creator.
	] ifFalse:[
	    self class name infoPrint.
	    ' [warning]: raised with wrong proceedability' infoPrintCR.
	]
    ].

    "Created: / 10-08-2010 / 09:54:41 / cg"
!

doCallAction
    "call the action proper
     - needed an extra method to have a raise-marked context around
       i.e. do not inline this into #doRaise !!
       (see implementation of #reject and #proceed)."

    <context: #return>
    <exception: #raise>

    ^ self defaultAction
!

doCallHandler:aHandlerBlock
    "call the handler proper - if the handler falls through, return the handler's value
     - an extra method is needed to have a raise-marked context around.
       i.e. do not inline this into #doRaise !!
       (see implementation of #reject and #proceed).
     - also redefinable (see CascadingNotification)"

    <context: #return>
    <exception: #raise>

    |val|

    aHandlerBlock argumentCount == 0 ifTrue:[
	"0-arg handler or any object - not interested in the exception argument"
	val := aHandlerBlock value
    ] ifFalse:[
	"1-arg handler - pass myself as exception argument"
	val := aHandlerBlock value:self.
    ].

    "handler fall through - is just like a #return:(aHandlerBlock value)"

    self return:val
!

doRaise
    "search through the context-calling chain for a handle-context
     to the raising signal, a parent of it, or a SignalSet which includes
     the raising signal.
     If found, ask the receiver for the handler and evaluate
     it with the receiver exception as argument.
     If no handler is found, perform the default #action method.

     ATTENTION: the code below depends on being called by #raise or
     #raiseRequest for proper operation (it skips the sending context)."

    <context: #return>

    |currentContext|

    "is nil a valid originator? If so, we need an extra
     instanceVariable to record the originator setting"
    originator isNil ifTrue:[
        originator := suspendedContext homeReceiver
    ].

    signal isNil ifTrue:[
        signal := self class
    ] ifFalse:[
        signal isExceptionCreator ifFalse:[
            "not an exception or Signal - there is something wrong here..."
            SignalError raiseWith:signal errorString:'unexpected non-ExceptionCreator in calling context'.
        ]
    ].

    "now, start searching for a handler.
     Start search above the last active handler.
     Skip raise contexts.
     If nil, then there is no handler and we can directly proceed
     to the unhandled code below."

    currentContext := suspendedContext findExceptional.
    [currentContext notNil] whileTrue:[
        (currentContext isRaiseContext) ifTrue:[
            |ex1 con1|

            "skip all the contexts between the raise and the sender of #handle:do"
            ex1 := currentContext receiver.     "exception, that has been raised"
            con1 := ex1 handlerContext.         "the context of the #handle:do:"

            con1 isNil ifTrue:[
                "the handlerContext is nil if an exception's default action is performed.
                 Start search at the sending context.
                 Maybe we should better treat a default action like a #handle:do:
                 at the outest level. But the DebugView currently can't handle this,
                 because it tries to raise e.g. AbortOperationRequest even if it has bee invoked
                 by e.g. NoHandlerError.

                 Note that if raiseContext is nil, the exception
                 did already return."

                (ex1 creator == signal and:[ex1 raiseContext notNil]) ifTrue:[
                    "the same exception that has been caught by a default action is raised again.
                     don't recurse"
                    ^ self noHandler.
                ].
            ] ifFalse:[
                "skip to the raised exception's handleContext"
                currentContext := con1.
            ].
            ex1 := con1 := nil.
        ] ifFalse:[ "currentContext is a handleContext"
            |r handler|

            "ask the receiver of the #handle:do: or #on:do: or whatever- message for the handler.
             nil is returned, if the signal is not accepted"
            r := currentContext receiver.     "receiver of #handle:do: or #on:do:"
            (r notNil and:[(handler := r handlerForSignal:signal
                                         context:currentContext
                                         originator:originator) notNil]
            ) ifTrue:[
                "call the handler"

                handlerContext := currentContext.
                currentContext := nil.
                self doCallHandler:handler.

                "if the handler rejects, we arrive here
                 continue search for another handler"
                currentContext := handlerContext.
                handler := handlerContext := nil.
            ].
            r := handler := nil.
        ].
        currentContext notNil ifTrue:[
            currentContext := currentContext findSpecialHandle:true raise:true. "search starts at currentContext sender"
        ].
    ].

    "
     we arrive here, if either no handler was found,
     or every handler rejected.
    "
    ^ self doCallAction

    "Created: / 12-05-1996 / 15:09:39 / cg"
    "Modified: / 03-08-1999 / 11:20:41 / stefan"
    "Modified: / 10-08-2010 / 09:26:14 / cg"
! !

!GenericException methodsFor:'raising'!

raise
    "actually raise a non-proceedable exception"

    <context: #return>

    raiseContext := thisContext.
    (suspendedContext isNil or:[handlerContext notNil]) ifTrue:[
        suspendedContext := raiseContext sender
    ].

    proceedable := false.
    ^ self doRaise

    "Modified: / 12.5.1996 / 15:09:47 / cg"
    "Modified: / 3.8.1999 / 13:33:01 / stefan"
!

raiseErrorString:aString
    "raise the signal nonproceedable.
     The argument, aString is used as messageText"

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := thisContext sender.
    messageText := aString.
    proceedable := false.

    ^ self doRaise
!

raiseErrorString:aString in:aContext
    "raise the signal nonproceedable.
     The argument, aString is used as messageText"

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    messageText := aString.
    proceedable := false.

    ^ self doRaise

    "Created: / 10-08-2010 / 09:33:43 / cg"
!

raiseIn:aContext
    "actually raise a non-proceedable exception"

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    proceedable := false.

    ^ self doRaise

    "Modified: / 03-08-1999 / 13:33:01 / stefan"
    "Created: / 10-08-2010 / 09:30:19 / cg"
!

raiseRequest
    "actually raise a proceedable exception."

    <context: #return>

    raiseContext := thisContext.
    (suspendedContext isNil or:[handlerContext notNil]) ifTrue:[
        handlerContext := nil.
        suspendedContext := raiseContext sender
    ].

    self checkProceedable.

    proceedable := true.
    ^ self doRaise

    "Modified: / 04-08-1999 / 08:05:12 / stefan"
    "Modified: / 10-08-2010 / 09:55:00 / cg"
!

raiseRequestErrorString:errorString in:aContext
    "actually raise a proceedable exception."

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    messageText := errorString.

    self checkProceedable.

    proceedable := true.
    ^ self doRaise

    "Modified: / 04-08-1999 / 08:05:12 / stefan"
    "Created: / 10-08-2010 / 09:40:05 / cg"
!

raiseRequestIn:aContext
    "actually raise a proceedable exception."

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.

    self checkProceedable.

    proceedable := true.
    ^ self doRaise

    "Modified: / 04-08-1999 / 08:05:12 / stefan"
    "Created: / 10-08-2010 / 09:36:45 / cg"
!

raiseRequestWith:aParameter errorString:aString
    "raise the signal proceedable.
     The argument, aString is used as messageText,
     aParameter is passed as exception parameter."

    <context: #return>

    ^ (self
	suspendedContext:thisContext sender parameter:aParameter errorString:aString)
	raiseRequest.
    "Created: / 23.7.1999 / 14:08:57 / stefan"
!

raiseRequestWith:aParameter errorString:aString in:aContext
    "actually raise a proceedable exception."

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    parameter := aParameter.
    messageText := aString.

    self checkProceedable.

    proceedable := true.
    ^ self doRaise

    "Modified: / 04-08-1999 / 08:05:12 / stefan"
    "Created: / 10-08-2010 / 09:55:48 / cg"
!

raiseRequestWith:aParameter in:aContext
    "actually raise a proceedable exception."

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    parameter := aParameter.

    self checkProceedable.

    proceedable := true.
    ^ self doRaise

    "Modified: / 04-08-1999 / 08:05:12 / stefan"
    "Created: / 10-08-2010 / 09:53:51 / cg"
!

raiseSignal
    "actually raise an exception (whatever the proceedability is)."

    <context: #return>
    <resource: #skipInDebuggersWalkBack>


    raiseContext := thisContext.
    (suspendedContext isNil or:[handlerContext notNil]) ifTrue:[
        suspendedContext := raiseContext sender
    ].
    proceedable := self mayProceed.
    ^ self doRaise

    "Modified: / 19-04-2013 / 09:37:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

raiseWith:aParameter errorString:aString
    "raise the signal nonproceedable.
     The argument, aString is used as messageText,
     aParameter is passed as exception parameter."

    <context: #return>

    ^ (self
	suspendedContext:thisContext sender parameter:aParameter errorString:aString)
	raise.
!

raiseWith:aParameter errorString:aString in:aContext
    "raise the signal nonproceedable.
     The argument, aString is used as messageText"

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    messageText := aString.
    parameter := aParameter.
    proceedable := false.

    ^ self doRaise

    "Created: / 10-08-2010 / 09:51:51 / cg"
!

raiseWith:aParameter in:aContext
    "raise the signal nonproceedable.
     The argument, aString is used as messageText"

    <context: #return>

    raiseContext := thisContext.
    suspendedContext := aContext.
    parameter := aParameter.
    proceedable := false.

    ^ self doRaise

    "Created: / 10-08-2010 / 09:50:54 / cg"
! !

!GenericException methodsFor:'setup'!

creator:aSignal
    "set the fields usable for inspection by the handler
     - only to be sent from the signal when raising."

    signal := aSignal.
!

suspendedContext:sContext errorString:aString
    "set required fields
     - only to be sent from the signal when raising"

    messageText := aString.
    suspendedContext := sContext.
!

suspendedContext:aContext messageText:aString parameter:aParameter originator:anOriginator
    suspendedContext := aContext.
    messageText := aString.
    parameter := aParameter.
    originator := anOriginator.
!

suspendedContext:sContext parameter:aParameter
    "set required fields
     - only to be sent from the signal when raising"

    parameter := aParameter.
    suspendedContext := sContext.
!

suspendedContext:sContext parameter:aParameter errorString:aString
    "set required fields
     - only to be sent from the signal when raising"

    parameter := aParameter.
    messageText := aString.
    suspendedContext := sContext.
!

suspendedContext:aContext parameter:aParameter originator:anOriginator
    suspendedContext := aContext.
    parameter := aParameter.
    originator := anOriginator.
! !

!GenericException methodsFor:'testing'!

isError
    ^ false
!

isException
    ^ true

    "Created: / 17.11.2001 / 18:37:27 / cg"
!

isNotification
    ^ false
!

isProgramError
    "redefined in all exceptions which are programmer's errors,
     and which should probably not be ignored.
     I.e. a global error handler should reject and let a debugger get control."
     
    ^ self class isProgramError
! !

!GenericException class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


GenericException initialize!

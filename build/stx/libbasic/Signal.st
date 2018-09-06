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

Object subclass:#Signal
	instanceVariableNames:'mayProceed notifierString nameClass message handlerBlock parent'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!Signal class methodsFor:'documentation'!

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
        The instance based Signal framework is being replaced by class based exceptions.
        I.e. what used to be instances of Signal/QuerySignal is being
        rewritten into subclasses of Exception/Error/Query and Warning.

        Although the functionality is basically unchanged, the new
        class based exceptions are easier to instantiate (no need for
        creation in a classes initialize method), easier to use (no real
        need for Signal-constant accessors) and allow for easier parameter
        passing (not only a single parameter, but allows for individual
        exception subclasses to add additional state).

        However, the old Signal hierarchy will remain in existance, since it allows
        funny instance-specific and anonymous exception handling schemes to be
        implemented, which are hard to built using class-based exceptions.

    Signal and Exception provide a framework for exception handling.

    A Signal object is usually defined somewhere up in the calling chain
    and associated with some abnormal event. Many signals are also
    created at startup time and reused.

    When the event is raised (by Signal>>raise) the control will be either
    given to a debugger or - if a handler was defined - to the handler.
    The handler will get a description of what (and where) happened in an
    Exception object and can decide how to react on the situation (i.e.
    proceed, return or restart).

    There is also a companion class called SignalSet, which allows handling
    multiple signals with one handler (for example all arithmetic signals).
    And, finally there is a very special SignalSet which allows catching
    any signal (SignalSet>>anySignal).

    Since there is no official documentation on signal handling (i.e. none
    of the books describes it), this Signal implementation has been modeled
    after what some PD programs seem to expect and what alpha/beta testers told
    me it should look like.
    It may not be perfect and undergo minor changes.

    special:

    In addition to the nested catch & throw mechanism, signals can also be
    used when no such handler scope exists. To support this, signals can be
    assigned a handlerBlock, which gets evaluated with the exception as argument
    in case no handler was found (on the stack).

    If no handler was found (i.e. neither a handler context on the stack, nor
    a static handler block), the NoHandlerSignal will be raised instead,
    passing it the original exception in its exception-parameter.
    This NoHandlerSignal can be handled just like any other signal.
    (therefore, it is possible to catch any error by catching NoHandlerSignal.

    When the NoHandler signal is raised, and neither a handler-context, nor
    a handler block is defined for it, an emergencyHandler(-block) is evaluated.
    This block is either provided by the current process
    (see Process>>emergencySignalHandler) or as a global default by the Exception
    class (see Exception>>emergencyHandler).
    The default emergencyHandlerBlock (from Exception) will bring up a debugger.

    HandlerBlocks allow a global (if its the EmergencyHandler in Exception)
    or per-process signal handling to be added. Even to code which was never
    planned to handle signals.

    See samples in 'doc/coding' and actual raise code in Exception.

    [Instance variables:]

        mayProceed      <Boolean>       hint for the debugger - program may
                                        proceed (currently not honored by the
                                        debugger)

        notifierString  <String>        error message to be output

        nameClass       <Class>         for the printOn-implementation; nameClass
                                        is the class, to which message (below)
                                        should be sent to create the receiver.

        message         <Symbol>        for the printOn-implementation; message
                                        is the selector, which should be sent to
                                        nameClass (above) to create the receiver.

        handlerBlock    <Block>         if nonNil, a 1-arg block to be
                                        evaluated when no handler context is
                                        found. The block gets the exception
                                        object as argument. This will play the role
                                        of an on-stack handler.

    [author:]
        Claus Gittinger

    [see also:]
        GenericException
        SignalSet QuerySignal
        Object
        (``Exception handling and signals'': programming/exceptions.html)
"
! !

!Signal class methodsFor:'instance creation'!

new
    "return a new signal"

    ^ (self basicNew) notifierString:'signal'; mayProceed:true

    "
     Signal new
    "

    "Modified: 8.10.1997 / 11:51:39 / cg"
! !

!Signal class methodsFor:'Signal constants'!

genericSignal
    "return the generic signal - that's the parent of all signals
     in the system."

    ^ GenericException

    "Created: / 8.10.1997 / 11:46:28 / cg"
    "Modified: / 8.10.1997 / 11:47:08 / cg"
    "Modified: / 4.8.1999 / 08:54:33 / stefan"
!

noHandlerSignal
    "return the signal used to handle unhandled signals"

    ^ NoHandlerError

    "Modified: / 4.8.1999 / 08:10:09 / stefan"
! !

!Signal methodsFor:'Compatibility-ANSI'!

signalWith:messageText
    "ANSI compatibility"

    self raiseErrorString:messageText
! !

!Signal methodsFor:'Compatibility-VW'!

messageText:aString
    ^ self notifierString:aString
!

new
    "create a new signal, using the receiver as a prototype and
     setting the parent of the new signal to the receiver."

    ^ self newSignal
! !

!Signal methodsFor:'accessing'!

creator
    "return the creator of the exception (for exception protocol compatibilty).
     For class based exceptions, that is the exception class;
     for signals, that is the signal itself.
     This used to be called 'signal' in earlier versions,
     but due to the conflict with VSE, Squeak and others, 
     where 'signal' means 'raise', 'signal' was obsoleted by this method."

    ^ self
!

errorString
    "errorString is deprecated, use description instead"

    <resource:#obsolete>

    ^ self description
!

handlerBlock
    "return the handlerblock - if non-nil, this will be evaluated with the exception
     object as argument, if no #handle:do: context was found on the stack."

    ^ handlerBlock
!

handlerBlock:aOneArgBlock
    "set the handlerblock - this will be evaluated with the exception
     object as argument, if no #handle:do: context was found on the stack."

    handlerBlock := aOneArgBlock
!

mayProceed
    "return the signals ability to proceed.
     This flag is (currently) not checked by the system;
     be prepared for changes here, to eventually have nonProceedable
     signals refuse to let you continue execution."

    ^ mayProceed
!

mayProceed:aBoolean
    "set/clear the signals ability to proceed.
     This flag is (currently) not checked by the system;
     be prepared for changes here, to eventually have nonProceedable
     signals refuse to let you continue execution."

    mayProceed := aBoolean
!

nameClass:aClass message:aSelector
    "this sets the class & selector of a method which returns
     that signal - this is simply for documentation purposes -
     see Signal>>printOn: implementation.
     (took me a while to find that one out ;-)"

    nameClass := aClass.
    message := aSelector
!

notifierString
    "return the notifier string"

    ^ notifierString
!

notifierString:aString
    "set the notifier string"

    notifierString := aString
!

originalSignal
    "return the signal/exception which was originally raised.
     For noHandler, that is my unhandled signal; for others, that's the exception itself."

    ^ self.
!

parent
    "return the parent-signal of the receiver"

    ^ parent
!

parent:aSignal
    "set the parent-signal of the receiver."

    parent := aSignal
!

parent:aSignal mayProceed:aBoolean
    "set the parent-signal and the mayProceed flag of the receiver."

    parent := aSignal.
    mayProceed := aBoolean.

    "Modified: 8.10.1997 / 11:56:11 / cg"
! !

!Signal methodsFor:'converting'!

, anExceptionHandler
    "return a SignalSet with myself and anExceptionHandler"

    ^ SignalSet with:self with:anExceptionHandler
! !

!Signal methodsFor:'copying'!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "raise an error - deepCopy is not allowed for signals"

    ^ self deepCopyError

    "Created: / 31.3.1998 / 15:43:01 / cg"
! !

!Signal methodsFor:'exception creation'!

newException
    "{ Pragma: +inlineNew }"
    "answer a new exception object for this signal.
     Subclasses may redefine this method"

    |exception|

    parent notNil ifTrue:[
        "parent may be a class based signal"
        exception := parent newException.
    ] ifFalse:[
        exception := Exception basicNew.
    ].
        
    ^ exception creator:self

    "Created: / 26.2.1998 / 19:53:56 / stefan"
    "Modified: / 23.7.1999 / 13:41:00 / stefan"
! !

!Signal methodsFor:'instance creation'!

newSignal
    "create a new signal, using the receiver as a prototype and
     setting the parent of the new signal to the receiver."

    ^ (self copy) parent:self

    "Modified: 8.10.1997 / 11:53:06 / cg"
!

newSignalMayProceed:aBoolean
    "create a new signal, using the receiver as a prototype and
     setting the parent of the new signal to the receiver."

    ^ (self copy) parent:self mayProceed:aBoolean

    "Modified: 8.10.1997 / 11:57:13 / cg"
! !

!Signal methodsFor:'printing & storing'!

description
    "return the notifier string.
     If the notifier string starts with space, prepend
     the parents notifier string"

    |s|

    notifierString isNil ifTrue:[
	^ parent description
    ].
    s := notifierString asString.
    (s startsWith:Character space) ifTrue:[
	^ parent description, s
    ].
    ^ s

    "
     Error description
    "

    "Modified: / 12.3.1998 / 15:04:41 / stefan"
!

descriptionForDebugger
    "return the description string of the signal which is used in the
     debugger title area"

    ^ self description.
!

printOn:aStream
    "append a printed representation of the receiver on aStream"

    nameClass notNil ifTrue:[
	nameClass isBehavior ifTrue:[
	    aStream nextPutAll:nameClass name.
	] ifFalse:[
	    nameClass printOn:aStream.
	].
	aStream space.
	aStream nextPutAll:message.
	^ self
    ].
    ^ super printOn:aStream
! !

!Signal methodsFor:'queries'!

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

    "Modified: / 22.3.1999 / 12:45:42 / stefan"
!

catchInDebugger
    "if set, the debugger will handle this signal in its event loop and will close itself
     without asking for close-confirmation.
     This allows for debugged processes to be terminated without a user confirmation dialog
     (for now, this is used in expecco's hard-terminate function to shut down any open debuggers
      together with the test-process)"

    ^ false
!

exceptionHandlerFor:anException in:aContext
    "answer the exceptionHandler for anException from aContext."

    ^ self
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

    "Created: / 25.7.1999 / 19:55:43 / stefan"
!

handlerProtectedBlock:doBlock inContext:context
    "set the handlerProtectedBlock in context"

    context selector == #handle:do: ifTrue:[
	context argAt:2 put:doBlock.
    ] ifFalse:[context selector == #handle:from:do: ifTrue:[
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

inheritsFrom:anotherSignal
    "return true, if the receiver is a child of anotherSignal
     (i.e. if handling anotherSignal also handles the receiver)
     This is almost the same as accepts, but returns false, if
     the receiver is identical to anotherSignal."

    <resource: #obsolete>

    self == anotherSignal ifTrue:[^ false].
    ^ anotherSignal accepts:self

    "Modified: / 6.6.1998 / 20:37:47 / cg"
!

isControlInterrupt
    ^ false

    "Created: / 16.11.2001 / 16:12:20 / cg"
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
!

isHandled
    "return true, if there is a handler for the receiver signal.
     Raising an unhandled signal will usually lead into the debugger,
     but can be caught globally by setting Exceptions EmergencyHandler."

    ^ GenericException exception:self isHandledIn:(thisContext sender).
!

isHandledIn:aContext
    "return true, if there is a handler for the receiver signal in the
     contextChain starting with aContext."

    ^ GenericException exception:self isHandledIn:aContext
!

isQuerySignal
    "return true, if this is a querySignal - always return false here"

    ^ false

    "Modified: 22.4.1996 / 13:45:06 / cg"
! !

!Signal methodsFor:'raising'!

raise
    "raise a signal nonproceedable.
     The signals notifierString is used as messageText."

    <context: #return>

    ^ self newException
	raiseIn:thisContext sender

    "Created: / 23-07-1999 / 14:07:17 / stefan"
    "Modified: / 10-08-2010 / 09:58:57 / cg"
!

raiseErrorString:aString
    "raise a signal nonproceedable.
     The argument is used as messageText."

    <context: #return>

    ^ self newException
	raiseErrorString:aString in:thisContext sender

    "Created: / 23-07-1999 / 14:07:33 / stefan"
    "Modified: / 10-08-2010 / 09:59:22 / cg"
!

raiseErrorString:aString in:aContext
    "raise a signal nonproceedable.
     The argument is used as messageText."

    <context: #return>

    ^ self newException
	raiseErrorString:aString in:aContext

    "Created: / 23-07-1999 / 14:07:33 / stefan"
    "Modified: / 10-08-2010 / 09:59:58 / cg"
!

raiseFrom:something
    "raise a signal nonproceedable.
     The argument, something is passed both as parameter and originator."

    <context: #return>

    ^ (self newException
	    suspendedContext:(thisContext sender) parameter:something originator:something)
	raise

    "Created: / 23-07-1999 / 14:07:59 / stefan"
    "Modified: / 10-08-2010 / 09:58:36 / cg"
!

raiseRequest
    "raise a signal proceedable.
     The signals notifierString is used as messageText."

    <context: #return>

    ^ self newException
	raiseRequestIn:thisContext sender

    "Created: / 23-07-1999 / 14:08:24 / stefan"
    "Modified: / 10-08-2010 / 10:00:13 / cg"
!

raiseRequestErrorString:aString
    "raise a signal proceedable.
     The argument, aString is used as messageText."

    <context: #return>

    ^ self newException
	raiseRequestErrorString:aString in:thisContext sender

    "Modified: / 10-08-2010 / 10:00:40 / cg"
!

raiseRequestFrom:something
    "raise a signal proceedable.
     The argument, something is passed both as parameter and originator."

    <context: #return>

    ^ (self newException
	suspendedContext:(thisContext sender) parameter:something originator:something)
	raiseRequest

    "Modified: / 2.5.1996 / 16:36:38 / cg"
    "Modified: / 5.3.1998 / 16:52:46 / stefan"
    "Created: / 23.7.1999 / 14:08:36 / stefan"
!

raiseRequestWith:aParameter
    "raise a signal proceedable.
     The signals notifierString is used as messageText."

    <context: #return>

    ^ self newException
	raiseRequestWith:aParameter in:thisContext sender

    "Created: / 23-07-1999 / 14:08:48 / stefan"
    "Modified: / 10-08-2010 / 10:01:00 / cg"
!

raiseRequestWith:aParameter errorString:aString
    "raise a signal proceedable.
     The argument, aString is used as messageText."

    <context: #return>

    ^ self newException
	raiseRequestWith:aParameter errorString:aString in:thisContext sender

    "Created: / 23-07-1999 / 14:08:57 / stefan"
    "Modified: / 10-08-2010 / 10:01:38 / cg"
!

raiseRequestWith:aParameter errorString:aString in:aContext
    "raise a signal proceedable.
     The argument, aString is used as messageText.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>

    ^ self newException
	raiseRequestWith:aParameter errorString:aString in:aContext

    "Created: / 23-07-1999 / 14:09:07 / stefan"
    "Modified: / 10-08-2010 / 10:02:08 / cg"
!

raiseRequestWith:aParameter in:aContext
    "raise a signal proceedable.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>

    ^ self newException
	raiseRequestWith:aParameter in:aContext

    "Modified: / 10-08-2010 / 10:02:26 / cg"
!

raiseSignal
    "raise a signal (proceedable or not, whatever the proceedability is).
     The signals notifierString is used as messageText."

    <context: #return>

    ^ (self newException
	suspendedContext:thisContext sender)
	raiseSignal

    "Modified: / 10.11.2001 / 15:13:34 / cg"
!

raiseSignal:errorMessage
    "ANSI: raise a signal (proceedable or not, whatever the proceedability is).
     The argument, errorMessage is used as messageText."

    <context: #return>

    ^ (self newException
	suspendedContext:(thisContext sender) errorString:errorMessage)
	raiseSignal.

    "Modified: / 07-08-2004 / 19:24:00 / stefan"
!

raiseSignal:errorMessage with:aParameter
    "ANSI: raise a signal (proceedable or not, whatever the proceedability is).
     The argument, errorMessage is used as messageText."

    <context: #return>

    ^ (self newException
	suspendedContext:(thisContext sender) parameter:aParameter errorString:errorMessage)
	raiseSignal.

    "Modified: / 07-08-2004 / 19:10:40 / stefan"
!

raiseSignalErrorString:aString
    "raise a signal (proceedable or not, whatever the proceedability is).
     The argument, aString is used as messageText."

    <context: #return>

    ^ (self newException
	suspendedContext:(thisContext sender) errorString:aString)
	raiseSignal.
!

raiseSignalWith:aParameter
    "raise a signal (proceedable or not, whatever the proceedability is).
     The argument, aParameter is passed as parameter."

    <context: #return>

    ^ (self newException
	suspendedContext:(thisContext sender) parameter:aParameter)
	raiseSignal.
!

raiseSignalWith:aParameter errorString:aString
    "raise a signal (proceedable or not, whatever the proceedability is).
     The argument, aString is used as messageText,
     aParameter is passed as exception parameter."

    <context: #return>

    ^ (self newException
	suspendedContext:(thisContext sender) parameter:aParameter errorString:aString)
	raiseSignal.
!

raiseWith:aParameter
    "raise a signal nonproceedable.
     The argument, aParameter is passed as parameter."

    <context: #return>

    ^ self newException
	raiseWith:aParameter in:thisContext sender

    "Created: / 23-07-1999 / 14:09:27 / stefan"
    "Modified: / 10-08-2010 / 10:02:51 / cg"
!

raiseWith:aParameter errorString:aString
    "raise a signal nonproceedable.
     The argument, aString is used as messageText,
     aParameter is passed as exception parameter."

    <context: #return>

    ^ self newException
	raiseWith:aParameter errorString:aString in:thisContext sender

    "Created: / 23-07-1999 / 14:09:36 / stefan"
    "Modified: / 10-08-2010 / 10:03:29 / cg"
!

raiseWith:aParameter errorString:aString in:aContext
    "raise a signal nonproceedable.
     The argument, aString is used as messageText, aParameter is passed
     as exception parameter.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>

    ^ self newException
	raiseWith:aParameter errorString:aString in:aContext

    "Created: / 23-07-1999 / 14:09:46 / stefan"
    "Modified: / 10-08-2010 / 10:03:19 / cg"
!

raiseWith:aParameter in:aContext
    "raise a signal nonproceedable.
     The argument, aParameter is passed as parameter.
     The additional context is passed as the context responsible for the raise,
     allowing a raise to mimicri the exception happened somewhere else."

    <context: #return>

    ^ self newException
	raiseWith:aParameter in:aContext

    "Modified: / 10-08-2010 / 10:03:05 / cg"
! !

!Signal methodsFor:'save evaluation'!

catch:aBlock
    "evaluate the argument, aBlock.
     If the receiver-signal is raised during evaluation, abort
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
!

deferAfter:aBlock
    " evaluate the argument, aBlock.
     Ignore the receiver-signal during evaluation - i.e. simply continue,
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

        "/ the signal was raised during the execution of aBlock above.
        "/ Raise it now (delayed).
        caughtException raiseSignal
    ].
    ^ result

     "
      |s|

      s := Signal new mayProceed:true.
      s deferAfter:[
         s raiseRequestWith:'hello' errorString:'eeee'
      ]
     "
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
	ifRaised:[ self halt ]
    "
!

handle:handleBlock do:aBlock
    "evaluate the argument, aBlock.
     If the receiver-signal is raised during evaluation,
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

    "Modified: / 25.7.1999 / 19:43:01 / stefan"
!

handle:handleBlock from:anObject do:aBlock
    "evaluate the argument, aBlock.
     If the receiver-signal is raised during evaluation,
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

    "Modified: / 25.7.1999 / 19:43:40 / stefan"
!

ignoreIn:aBlock
    "evaluate the argument, aBlock.
     Ignore the receiver-signal during evaluation - i.e. simply continue.
     This makes only sense for some signals, such as UserInterrupt
     or AbortSignal, because continuing after an exception without any cleanup
     often leads to followup-errors."

     ^ self handle:[:ex | ex proceedWith:nil] do:aBlock.

     "
      Object messageNotUnderstoodSignal ignoreIn:[
	 123 size open
      ]
     "
! !

!Signal class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


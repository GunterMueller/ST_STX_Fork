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

IdentitySet subclass:#SignalSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

SignalSet subclass:#SetOfAnySignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SignalSet
!

SignalSet::SetOfAnySignal class instanceVariableNames:'theOneAndOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

!SignalSet class methodsFor:'documentation'!

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
    SignalSet allows catching of multiple signals. A SignalSet consists of
    a number of signals and also implements the #handle:do: and #catch: methods
    just as signals do.
    However, any signal from the SignalSet will, if signalled, lead into the handler.

    There is also a special signalSet, which can be used to catch any
    signal in the system - but this should no longer be used, since catching
    Object>>errorSignal has now the same effect.

    For more detail, see comment in Signal and examples in doc/coding.

    Notice: SignalSets are not needed when a group of children of a common signal
    (such as arithmeticSignal) is to be handled; the parent signal of those will
    also handle all children.
    Use signalSets if totally unrelated signals should be handled by one common
    handler.


    [author:]
	Claus Gittinger

    [see also:]
	Exception
	Signal QuerySignal
	Object
"
! !

!SignalSet class methodsFor:'instance creation'!

anySignal
    "return a special signalSet for catching any signal.
     Questionable:
	you should use 'Object>>errorSignal' for that purpose;
	however, the anySignal-set also catches nonChilds of the ErrorSignal
	(i.e. highly private, strange signals)."

    ^ SetOfAnySignal new

    "Modified: 27.1.1997 / 20:31:08 / cg"
! !

!SignalSet methodsFor:'adding'!

, anException
    "add anException to the set"

    self add:anException
!

add:anExceptionHandler
    "Check, that only exceptionHandlers are added.
     Very bad (recursive) things may happen if e.g. #accepts: is called
     and raises a MessageNotUnderstood error."

    anExceptionHandler isExceptionHandler ifFalse:[
	SignalError raiseWith:anExceptionHandler errorString:' - trying to add a non-exceptionHandler to a SignalSet'.
    ].
    ^ super add:anExceptionHandler.
! !

!SignalSet methodsFor:'queries'!

accepts:anExceptionHandler
    "return true, if the receiver accepts the argument, aSignal.
     (i.e. if any of the receiver's elements is aSignal or a parent of it).
     False otherwise."

    self do:[:eachExceptionHandler |
        (eachExceptionHandler==anExceptionHandler
         or:[eachExceptionHandler accepts:anExceptionHandler]) ifTrue:[^ true].
    ].
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

    |selector arg|

    selector := theContext selector.
    (selector ~~ #'handle:from:do:'
     or:[(theContext argAt:2) == originator]) ifTrue:[
	(self == signal or:[self accepts:signal]) ifTrue:[
	    arg := theContext argAt:1.
	    selector == #answer:do: ifTrue:[
		^ [:ex| ex proceedWith:arg].
	    ] ifFalse:[
		^ arg ? [nil].
	    ].
	]
    ].
    ^ nil

    "Created: / 25.7.1999 / 23:46:48 / stefan"
!

handlerProtectedBlock:doBlock inContext:context
    "set the handlerProtectedBlock in context"

    context selector == #handle:do: ifTrue:[
	context argAt:2 put:doBlock.
    ] ifFalse:[context selector == #handle:from:do: ifTrue:[
	context argAt:3 put:doBlock.
    ]].

    "
      SignalSet anySignal
	  handle:[:ex| ex restartDo:[55]] do:[1 // 0]
    "


    "Created: / 25.7.1999 / 23:46:48 / stefan"
!

handles:anException
    "return true, if the receiver handles the argument, anException.
     (i.e. if any of the receiver's elements handles anException)."

    self do:[:eachExceptionHandler|
        (eachExceptionHandler handles:anException) ifTrue:[^ true]
    ].
    ^ false
!

isExceptionHandler
    "return true, if the receiver responds to the exception handler protocol,
     especially to the #accepts: and #handles: messages"

    ^ true
! !

!SignalSet methodsFor:'save evaluation'!

answer:someAnswer do:aBlock
    "evaluate the argument, aBlock.
     If the receiver is queried during evaluation, answer and proceed with someAnswer.
     This is a wrapper for #handle:do: for lazy typists; no new functionality."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ aBlock value.  "the real logic is in Exception>>doRaise"
!

catch:aBlock
    "evaluate the argument, aBlock.
     If any of the signals in the receiver is raised during evaluation,
     abort the evaluation and return true; otherwise return false.
     With the special anySignal, evaluation can be performed totally save
     from signals - but who (beside radical c++ fans) would do that ?"

    |raiseOccurred|

    raiseOccurred := false.
    self handle:[:ex | raiseOccurred := true. ex return] do:aBlock.
    ^ raiseOccurred

     "
      SignalSet anySignal catch:[
	 (#(1 2 3 4) at:5) / 0.0
      ]
     "
!

deferAfter:aBlock
    "evaluate the argument, aBlock.
     Ignore the receiver-signal during evaluation - i.e. simply continue,
     but remember if the signal was raised.
     After the block evaluation, finally raise the signal - if it was raised in the block.
     If the signal is raised multiple times, only the first raises parameter is remembered,
     and only a single raise is performed after the blocks evaluation.

     Deferring makes sense for some signals, such as UserInterrupt or AbortSignal,
     which must occasionally be delayed temprarily until a save place is reached
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

        "/ a signal was raised during the execution of aBlock above.
        "/ Raise it now (delayed).
        caughtException raiseSignal
    ].
    ^ result

    "
     (UserInterrupt , AbortOperationRequest) deferAfter:[
         Transcript showCR:'1 - now raising, but will be deferred.'.
         UserInterrupt raiseRequestWith:'hello'.
         Transcript showCR:'2 - after the raise, deferred exception will be handled soon.'.
     ].
     Transcript showCR:'3 - here after the protected block.'.
    "
!

handle:handleBlock do:aBlock
    "evaluate the argument, aBlock.
     If any of the signals in the receiver is raised during evaluation,
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
     SignalSet anySignal handle:[:ex |
        ex errorString print. ' occurred in: ' print. ex suspendedContext printNL.
        ex return
     ] do:[
        (#(1 2 3 4) at:5) / 0.0
     ]

     SignalSet anySignal handle:[:ex |
        ex errorString print. ' occurred in: ' print. ex suspendedContext printNL.
        self bar.
        ex return
     ] do:[
        (#(1 2 3 4) at:5) / 0.0
     ]
    "

    "Modified: / 26.7.1999 / 00:03:13 / stefan"
!

handle:handleBlock from:anObject do:aBlock
    "evaluate the argument, aBlock.
     If any of the signals in the receiver is raised during evaluation,
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

    "Modified: / 26.7.1999 / 00:03:06 / stefan"
!

ignoreIn:aBlock
    "evaluate the argument, aBlock.
     Ignore the any signals from the receiver during evaluation - i.e. simply
     continue. This makes only sense for some signals, such as UserInterrupt
     or AbortSignals, because continuing after an exception without any cleanup
     will often lead to followup-errors."

     ^ self handle:[:ex | ex proceedWith:nil] do:aBlock.

     "
      SignalSet anySignal ignoreIn:[
	 123 size open
      ]
     "

     "Created: / 27.1.1997 / 20:32:50 / cg"
     "Modified: / 4.3.1998 / 16:36:30 / cg"
! !

!SignalSet::SetOfAnySignal class methodsFor:'instance creation'!

flushSingleton
    "flushes the cached singleton"

    theOneAndOnlyInstance := nil

    "
     self flushSingleton
    "
!

new
    "returns a singleton"

    ^ self theOneAndOnlyInstance.
!

theOneAndOnlyInstance
    "returns a singleton"

    theOneAndOnlyInstance isNil ifTrue:[
	theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.
! !

!SignalSet::SetOfAnySignal methodsFor:'blocked methods'!

add:anElement
    "do not allow to add anything"

    ^ self shouldNotImplement
! !

!SignalSet::SetOfAnySignal methodsFor:'queries'!

accepts:anExceptionHandler
    "return true, if the receiver accepts the argument, aSignal.
     (i.e. if any of the receiver's elements is aSignal or a parent of it).
     False otherwise. I, the special SetOfAnySignal accepts any (non-query) signal."

    ^ anExceptionHandler isExceptionHandler and:[anExceptionHandler isQuerySignal not]
!

handles:anException
    "return true, if the receiver handles the argument, anException.
     (i.e. if any of the receiver's elements handles anException).
     I, the special SetOfAnySignal handle any (non-query) signal."

    ^ anException isNotification not
!

includes:anExceptionHandler
    "return true, if the receiver contains the argument, anExceptionHandler.
     I, the special SetOfAnySignal include any (non-query) ExceptionHandler."

    ^ anExceptionHandler isExceptionHandler and:[anExceptionHandler isQuerySignal not]
! !

!SignalSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


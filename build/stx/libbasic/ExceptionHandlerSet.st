"
 COPYRIGHT (c) 1999 by eXept Software AG
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

IdentityDictionary subclass:#ExceptionHandlerSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!ExceptionHandlerSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    An ExceptionHandlerSet allows a group of unrelated signals to be handled
    by individual handlers - their evaluation is equivalent to a corresponding
    number of nested signal handlers, but more efficient and
    somwehat easier to program.

    [author:]
        Stefan Vogel

    [see also:]
        Exception Signal SignalSet
"
!

examples
"
                                                                [exBegin]
         |h num|

         h := ExceptionHandlerSet new.
         h on:ZeroDivide
           do:[:ex | 'division by zero' printCR. ex proceed].

         h on:HaltInterrupt
           do:[:ex | 'halt encountered ' printCR. ex proceed].

         h on:DomainError
           do:[:ex | 'domain error  ' printCR. ex proceed].

         h handleDo:[
            num := 0.

            'now dividing' printCR.
            1 // num.

            'now doing bad arcSin' printCR.
            num := 50.
            num arcSin.

            'now halting' printCR.
            self halt.
         ]
                                                                [exEnd]

                                                                [exBegin]
         |h num|

         h := ExceptionHandlerSet new.
         h on:ZeroDivide
           do:[:ex | 'division by zero' printCR. ex proceed].

         h on:HaltInterrupt
           do:[:ex | 'halt encountered ' printCR. ex proceed].

         h on:DomainError
           do:[:ex | 'domain error ' printCR. ex proceed].

         [
            num := 0.

            'now dividing' printCR.
            1 // num.

            'now doing bad arcSin' printCR.
            num := 50.
            num arcSin.

            'now halting' printCR.
            self halt.
         ] valueWithExceptionHandler:h
                                                                [exEnd]
"
! !


!ExceptionHandlerSet methodsFor:'Compatibility-VW5.4'!

on:aSignalOrException handle:aHandler
    "add a handler for aSignal to the set"

    self on:aSignalOrException do:aHandler

    "Created: / 26.7.1999 / 09:51:37 / stefan"
! !


!ExceptionHandlerSet methodsFor:'adding'!

on:anExceptionHandler do:aHandlerBlock
    "add a handler for aSignal to the set"

    anExceptionHandler isBehavior ifTrue:[
        "load class, if not yet loaded"
        anExceptionHandler autoload.
    ].
    anExceptionHandler isExceptionHandler ifFalse:[
        SignalError raiseWith:anExceptionHandler errorString:' - trying to add a non-exceptionHandler to a SignalSet'.
    ].
    self at:anExceptionHandler put:aHandlerBlock
! !


!ExceptionHandlerSet methodsFor:'queries'!

accepts:anExceptionHandler
    "return true, if the receiver accepts the argument, aSignal.
     (i.e. if any of the receiver's elements is aSignal or a parent of it)."

    self keysDo:[:eachExceptionHandler |
        (eachExceptionHandler==anExceptionHandler
         or:[eachExceptionHandler accepts:anExceptionHandler]) ifTrue:[^ true].
    ].
    ^ false

    "Created: / 26.7.1999 / 09:53:09 / stefan"
!

exceptionHandlerFor:anException in:aContext
    "answer the exceptionHandler for anException from aContext."

    ^ self
!

handlerForSignal:signal
    "answer the handler block for signal"

    self keysAndValuesDo:[:sig :handler|
        (sig == signal or:[sig accepts:signal]) ifTrue:[
            ^ handler.
        ].
    ].

    ^ nil

    "Modified: / 26.7.1999 / 09:59:43 / stefan"
    "Created: / 26.7.1999 / 11:29:29 / stefan"
!

handlerForSignal:signal context:theContext originator:originator
    "answer the handler block for the signal from originator.
     The block is retrieved from aContext.
     Answer nil if the signal is not handled"


    (theContext selector ~~ #'handleDo:from:'
     or:[(theContext argAt:2) == originator]) ifTrue:[
        self keysAndValuesDo:[:sig :handler|
            (sig == signal or:[sig accepts:signal]) ifTrue:[
                ^ handler ? [nil].
            ].
        ].
    ].

    ^ nil

    "Created: / 26.7.1999 / 09:53:28 / stefan"
    "Modified: / 26.7.1999 / 09:59:43 / stefan"
!

handlerProtectedBlock:doBlock inContext:context
    "set the handlerProtectedBlock in context"

    context argAt:1 put:doBlock.

    "
      |s|

      s := ExceptionHandlerSet new.
      s at:Error put:[:ex| ex restartDo:[55]].

      s handleDo:[1 // 0]
    "

!

handles:anException
    "return true, if the receiver handles the argument, anException.
     (i.e. if any of the receiver's elements handles anException)."

    self keysDo:[:eachExceptionHandler|
        (eachExceptionHandler handles:anException) ifTrue:[^ true]
    ].
    ^ false
! !


!ExceptionHandlerSet methodsFor:'save evaluation'!

handleDo:aBlock
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
    |h num|

    h := ExceptionHandlerSet new.
    h on:(Number divisionByZeroSignal)
      handle:[:ex | 'division by zero' printNL. ex proceed].

    h on:(Object haltSignal)
      handle:[:ex | 'halt encountered ' printNL. ex proceed].

    h on:(Float domainErrorSignal)
      handle:[:ex | 'domain error  ' printNL. ex proceed].

    h handleDo:[
       num := 0.

       'now dividing' printNL.
       1 // num.

       'now doing bad arcSin' printNL.
       num := 50.
       num arcSin.

       'now halting' printNL.
       self halt.
    ]
    "

    "Created: / 26.7.1999 / 09:56:44 / stefan"
    "Modified: / 26.7.1999 / 11:01:53 / stefan"
!

handleDo:aBlock from:originator
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
    |h num|

    h := ExceptionHandlerSet new.
    h on:(Number divisionByZeroSignal)
      handle:[:ex | 'division by zero' printNL. ex proceed].

    h on:(Object haltSignal)
      handle:[:ex | 'halt encountered ' printNL. ex proceed].

    h on:(Float domainErrorSignal)
      handle:[:ex | 'domain error  ' printNL. ex proceed].

    h handleDo:[
       'now halting' printNL.
       self halt.

       'the following exceptions are not handled.
        A debugger is opened' printNL.

       'now dividing' printNL.
       num := 0.
       1 // num.

       'now doing bad arcSin' printNL.
       num := 50.
       num arcSin.
    ] from:self
    "

    "Created: / 26.7.1999 / 09:56:44 / stefan"
    "Modified: / 26.7.1999 / 11:36:47 / stefan"
! !


!ExceptionHandlerSet methodsFor:'testing'!

isExceptionHandler
    "return true, if the receiver responds to the exception handler protocol,
     especially to the #accepts: and #handles: messages"

    ^ true
! !


!ExceptionHandlerSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: ExceptionHandlerSet.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


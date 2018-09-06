"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Signal subclass:#QuerySignal
	instanceVariableNames:'defaultAnswer hasDefault'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!QuerySignal class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Notice: 
        Signals have been replaced by class based Exceptions.
        They are provided for compatibility, but new code should use Exceptions
        (in this case: Query)

    QuerySignals are like signals, except that they are not accepted
    by handlers for ordinary signals.
    I.e. a signal handler for a normal signal will not handle a query
    signal. Thus, these bypass anySignal handlers.

    However, if unhandled, no error is raised, instead they are simply ignored
    and nil is returned from the raise
    (as opposed to normal signals, which raise an unhandled signal exception).
    QuerySignals are also ignored, if a handler exists, but rejects.

    Their main use is to implement upQueries via signals, that work even 
    if intermediate errorSignal handlers are present 
    (which is not possible with ordinary signals, since errorSignal handlers 
     would catch those signals).

    Code deep down in the calling hierarchy can post such an up-Query to ask
    for some information or to pass some information upward. 

    For example, the activityNotification mechanism is built on top of this:
    everyone can send such a notification which is either handled by someone
    up in the hierarchy (to show it in the windows info area) or simply
    ignored.

    Using QuerySignals for this (instead of regular Signals) helps in documenting
    the intended usage of those signals.

    Another use of querySignals is to provide additional information to
    deeply nested methods, which is only required in the uncommon case;
    or if another parameter is required by some method, which was not planned
    for in the beginning, and you do not want to hand this value (via an
    additional argument) through all intermediate levels.
    A highly elegant solution to this problem is to provide a handler somewhere
    at the top of the calling hierarchy, and raise an upQuery from whereever
    that value is required.
    A concrete application can be found in the windowGroup-lastEvent
    queries. If anyone is interested in the windowEvent which was responible for 
    being invoked, all he needs to do is to raise the lastEventQuerySignal, 
    which returns that event.
    No intermediate methods are required to know anything about that.
    Another example is found in the way Metaclass asks for the nameSpace
    when new classes are to be installed. A Browser may simply answer such
    a query and provide a namespace (no need to pass that information down
    the calling chain).

    A final note (to C++ and Java fans):
        such upQueries are only possible, if the exception handling mechanism
        does not automatically unwind the stack for the handler invokation.
        Since the handler must be able to proceed the execution and return
        a value to the raiser ....
        ... another demonstration of why ST's exception mechanisms are superior.

    [see also:]
        Signal SignalSet Exception
        Object
        (``Exception handling and signals'': programming/exceptions.html)

    [author:]
        Claus Gittinger
"
!

examples 
"
  an up-query from a deeply nested operation to a higher level:
                                                                        [exBegin]
    |querySignal zero|

    zero := 0.
    querySignal := QuerySignal new.
    querySignal handle:[:ex |
        Transcript showCR:'query'.
        ex proceedWith:true
    ] do:[
        'nesting'.
        [
            [
                Object errorSignal handle:[:ex |
                    Transcript showCR:'some error: ' , ex errorString.
                    ex proceed
                ] do:[
                    [
                        1 // zero.  'an error which is caught in the handler'.
                        (querySignal query) == true ifTrue:[
                            Transcript showCR:'query says: ok'.
                        ] ifFalse:[
                            Transcript showCR:'query says: no'
                        ]
                    ] value
                ]
            ] value
        ] value
    ]
                                                                        [exEnd]
  for lazy typists, a more compact interface is also provided
  (which is also easier to read):
                                                                        [exBegin]
    |querySignal|

    querySignal := QuerySignal new.
    querySignal answer:true do:[
        'nesting'.
        [
            [
                (querySignal query) == true ifTrue:[
                    Transcript showCR:'query says: ok'.
                ] ifFalse:[
                    Transcript showCR:'query says: no'
                ]
            ] value
        ] value
    ]
                                                                        [exEnd]
  an up-query from a deeply nested operation, for which there
  is no handler:
  (notice, this would not work with normal signals, which would raise
   another unhandled exception-exception;
   also notice the == check #raise's return value being true,
   instead of a simple ifTrue; this handles a nil-value from
   the unhandled query)
                                                                        [exBegin]
    |querySignal zero|

    zero := 0.
    querySignal := QuerySignal new.

    [
        'nesting'.
        [
            [
                Object errorSignal handle:[:ex |
                    Transcript showCR:'some error: ' , ex errorString.
                    ex proceed
                ] do:[
                    [
                        1 // zero.  'an error which is caught in the handler'.
                        (querySignal raise) == true ifTrue:[
                            Transcript showCR:'query says: ok'.
                        ] ifFalse:[
                            Transcript showCR:'query says: no'
                        ]
                    ] value
                ]
            ] value
        ] value
    ] value
                                                                         [exEnd]
  counter-example, just to show that things would not work this way
  with regular signals:
                                                                        [exBegin]
    |signal|

    signal := Signal new.
    'nesting deeply'.
    [
        [
            [
                [
                    [
                        (signal raise) == true ifTrue:[
                            Transcript showCR:'query says: ok'.
                        ] ifFalse:[
                            Transcript showCR:'query says: no'
                        ]
                    ] value
                ] value
            ] value
        ] value
    ] value
                                                                         [exEnd]

   except, by handling the unhandled exception
   (but we think, that querySignals are easier to use and
    better document the intent):
                                                                        [exBegin]
    |signal|

    signal := Signal new.
    'nesting deeply'.
    [
        [
            [
                [
                    [
                        Signal noHandlerSignal handle:[:ex |
                            ex proceedWith:nil
                        ] do:[
                            (signal raise) == true ifTrue:[
                                Transcript showCR:'query says: ok'.
                            ] ifFalse:[
                                Transcript showCR:'query says: no'
                            ]
                        ]
                    ] value
                ] value
            ] value
        ] value
    ] value
                                                                         [exEnd]
"
! !

!QuerySignal methodsFor:'answering queries'!

answer:someAnswer do:aBlock
    "evaluate the argument, aBlock.
     If the receiver is queried during evaluation, answer and proceed with someAnswer.
     This is a wrapper for #handle:do: for lazy typists; no new functionality."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ aBlock value.  "the real logic is in Exception>>doRaise"

    "
     |q|

     q := QuerySignal new.

     q answer:true do:[
        Transcript showCR:'query answers: ' , (q query printString).
     ]
    "

    "
     |q|

     q := QuerySignal new.

     q answer:false do:[
        Transcript showCR:'first query answers: ' , (q query printString).
        q answer:true do:[
            Transcript showCR:'second query answers: ' , (q query printString).
        ]
     ]
    "

    "Created: / 10.7.1996 / 15:08:20 / cg"
    "Modified: / 14.10.1996 / 16:59:18 / cg"
    "Modified: / 25.7.1999 / 23:34:02 / stefan"
! !

!QuerySignal methodsFor:'exception creation'!

newException
    "{ Pragma: +inlineNew }"
    "answer a new exception object for this signal"

    ^ Query basicNew creator:self.

    "
      |querySignal|
      querySignal := QuerySignal new.
      querySignal handle:[:ex| self halt] do:[querySignal raiseRequest].
    "
! !

!QuerySignal methodsFor:'initialization'!

defaultAnswer:someValue
    "define the queries defaultAnswer to be someValue.
     This is the same as defining an appropriate handlerBlock."

    |handler|

    defaultAnswer := someValue.
    hasDefault := true.

    "/ avoid creating a fullBlock, in the most common cases
    "/ therefore, do not replace the code below by
    "/     handler := [:ex | ex proceedWith:someValue]
    "/ although it is semantically equivalent.

    someValue == true ifTrue:[
        handler := [:ex | ex proceedWith:true]
    ] ifFalse:[
        someValue == false ifTrue:[
            handler := [:ex | ex proceedWith:false]
        ] ifFalse:[
            someValue isNil ifTrue:[
                handler := [:ex | ex proceedWith:nil]
            ] ifFalse:[
                handler := [:ex | ex proceedWith:someValue value].
            ]
        ]
    ].
    self handlerBlock:handler.

    "
     QuerySignal new query
     (QuerySignal new defaultAnswer:true) query 
     (QuerySignal new defaultAnswer:false) query
    "

    "
     |sig rslt|

     sig := QuerySignal new.
     sig defaultAnswer:false.
     rslt := sig query.
     Transcript showCR:rslt.
    "

    "
     |sig rslt|

     sig := QuerySignal new.
     sig defaultAnswer:false.
     sig answer:true 
     do:[
         rslt := sig query
     ].
     Transcript showCR:rslt.
    "

    "Modified: / 3.1.1997 / 15:14:40 / cg"
    "Modified: / 2.3.1998 / 10:42:14 / stefan"
! !

!QuerySignal methodsFor:'queries'!

accepts:aSignal
    "return true, if the receiver accepts the argument, aSignal.
     (i.e. the receiver is aSignal or a parent of it). False otherwise."

    |s|

    self == aSignal ifTrue:[^ true].
    aSignal isQuerySignal ifFalse:[^ false].

    s := aSignal parent.
    [s notNil] whileTrue:[
        self == s ifTrue:[^ true].
        s := s parent
    ].
    ^ false

    "Modified: / 22.3.1999 / 12:45:32 / stefan"
!

defaultAnswer
    ^ defaultAnswer

    "Created: / 29-07-2011 / 19:58:58 / cg"
!

handlerForSignal:signal context:theContext originator:originator
    "answer the handler block for the signal from originator.
     The block is retrieved from aContext.
     Answer nil if the signal is not handled"

    |arg|

    theContext selector == #answer:do: ifTrue:[
        (self == signal or:[self accepts:signal]) ifTrue:[
            arg := theContext argAt:1.
            ^ [:ex| ex proceedWith:arg].
        ]
    ] ifFalse:[
        ^ super handlerForSignal:signal context:theContext originator:originator.
    ].

    ^ nil

    "Created: / 25.7.1999 / 23:33:05 / stefan"
!

handles:anException
    "return true, if the receiver handles the argument, anException.
     (i.e. the receiver is anExceptions signal or a parent of it)"

    |signal|

    signal := anException creator.

    self == signal ifTrue:[^ true].               "quick check"
    anException isNotification ifFalse:[^ false]. "speed up non-queries by not traversing the parent chain"

    [(signal := signal parent) notNil] whileTrue:[
        self == signal ifTrue:[^ true].
    ].
    ^ false
!

isQuerySignal
    "return true, if this is a querySignal - always return true here"

    ^ true

    "Modified: 22.4.1996 / 13:45:10 / cg"
! !

!QuerySignal methodsFor:'raising'!

query
    "raise the query - return the handler's value, or the default
     value, if there is no handler."

    ^ self raiseRequest
!

queryWith:aParameter
    "raise the query passing a parameter 
     - return the handler's value, or the default value, if there is no handler."

    ^ self raiseRequestWith:aParameter
!

raise
    "QuerySignals are proceedable by definition,
     so they should be raised with #query or #raiseRequest"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #query or #raiseRequest'.    
    ^ self raiseRequest

    "Modified: / 18.3.1999 / 18:33:57 / stefan"
!

raiseRequest
    "raise the query - return the handler's value, or the default
     value, if there is no handler.
     Invoking the handler is exactly the functionality of Signal>>raiseRequest,
     but we can do it faster here, by avoiding the creation of a full-blown
     exception object."

    |con sel sig|

    con := Context findFirstSpecialHandle:true raise:false.
    [con notNil] whileTrue:[
        sel := con selector.
        sel == #answer:do: ifTrue:[
            sig := con receiver.
            sig == self ifTrue:[
                ^ con argAt:1
            ].
            sig isNil ifTrue:[
                self error:'nil receiver in #answer:do: - send'.
            ].
            (sig accepts:self) ifTrue:[
                ^ con argAt:1
            ].
        ] ifFalse:[
            (sel ~~ #handle:do:
             or:[(sig := con receiver) == self
             or:[sig accepts:self]]) ifTrue:[
                ^ super raiseRequest
            ].
        ].
        con := con findSpecialHandle:true raise:false.
    ].

    "/ no handler found - return the default value
    hasDefault == true ifTrue:[
        ^ defaultAnswer value
    ].
    handlerBlock isNil ifTrue:[
        ^ nil
    ].
    ^ super raiseRequest

    "Modified: / 15.6.1998 / 21:27:37 / cg"
    "Modified: / 25.7.1999 / 23:35:11 / stefan"
! !

!QuerySignal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/QuerySignal.st,v 1.48 2013-08-22 13:01:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/QuerySignal.st,v 1.48 2013-08-22 13:01:24 cg Exp $'
! !


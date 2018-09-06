"
 COPYRIGHT (c) 2002 by eXept Software AG
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

Notification subclass:#Query
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!Query class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    Query is an abstract superclass for queries.

    A query is an exception which by default proceeds if unhandled and returns
    a default value.
    As a class based reimplementation, it replaces and obsoletes the old 
    QuerySignal instance based mechanism.

    Note:
        Query does not add/refine any functionality from its superclass.
        It exists for the more descriptive class name only.

    Queries are like exceptions, except that they are not accepted
    by handlers for ordinary exceptions.
    I.e. a handler for a normal exception will not handle a query. 
    Thus, these bypass all normal exception handlers.

    However, if unhandled, no error is raised, instead it is simply ignored
    and nil is returned from the raise
    (as opposed to normal exceptions, which raise an unhandled exception error).
    Queries are also ignored, if a handler exists, but rejects.

    The main use of Queries is to implement an upQuery, which works even 
    if intermediate errorSignal handlers are present. 

    Code deep down in the calling hierarchy can post such an up-Query to ask
    for some information or to pass some information upward. 

    For example, the activityNotification mechanism is built on top of this:
    everyone can send such a notification which is either handled by someone
    up in the hierarchy (to show it in the windows info area) or simply
    ignored.

    Using Queries for this (instead of regular Signals) helps in documenting
    the intended usage of those signals.

    Another use of queries is to provide additional information to
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

    [author:]
        Claus Gittinger

    [see also:]
        Notification Warning Signal QuerySignal
        (``Exception handling and signals'': programming/exceptions.html)
"
!

examples
"
                                                                        [exBegin]
    Query answer:'hello'
    do:[
        Transcript showCR:(Query query)
    ]
                                                                        [exEnd]


  an up-query from a deeply nested operation to a higher level:
  the example below demonstrates that a Query is not an Error
  (i.e. the Error-handler does not interfere with Queries)
                                                                        [exBegin]
    |zero|

    zero := 0.
    Query handle:[:ex |
        Transcript showCR:'query'.
        ex proceedWith:true
    ] do:[
        'nesting'.
        [
            [
                Error handle:[:ex |
                    Transcript showCR:'some error: ' , ex errorString.
                    ex proceed
                ] do:[
                    [
                        1 // zero.  'an error which is caught in the handler'.
                        (Query query) == true ifTrue:[
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
  for lazy typists, a more compact interface for query-answerign
  is also provided (which is also easier to read):
                                                                        [exBegin]
    Query answer:true do:[
        'nesting'.
        [
            [
                (Query query) == true ifTrue:[
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
    |zero|

    zero := 0.
    [
        'nesting'.
        [
            [
                Error handle:[:ex |
                    Transcript showCR:'some error: ' , ex errorString.
                    ex proceed
                ] do:[
                    [
                        1 // zero.  'an error which is caught in the handler'.
                        (Query raise) == true ifTrue:[
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

!Query class methodsFor:'initialization'!

initialize

    NotifierString := 'Query'.

    "
     self initialize
    "
! !


!Query class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Query initialize!

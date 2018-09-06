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

GenericException subclass:#Notification
	instanceVariableNames:'tag'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!Notification class methodsFor:'documentation'!

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
    Notification is the superclass of all notification signals in the system.
    contrast to regular exceptions, Notifications are ignored, if no handler is present
    and a default value is returned from the raise.
    When a handler finishes, the do-block is proceeded with the exception handler's value
    (an Exception does a return in this case.).

    Thanks to proceedable exceptions, Notifications allow for non-GUI model code to provide
    user notifications which are optionally shown.
    Very useful, for example to provide progress information from a method which can be
    invoked both from a GUI-Tool (where notifications are wanted) and also from the system,
    where such notifications are not desired.

    [author:]
        Stefan Vogel

    [see also:]
        Signal QuerySignal Query
"
!

examples 
"
  an up-notification from a deeply nested operation to a higher level:
                                                                        [exBegin]
    |zero|

    zero := 0.
    Notification handle:[:n |
        Transcript showCR:'Please note that: ' , n description.
        n proceedWith:true
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
                        Notification notify:'hello world'
                    ] value
                ]
            ] value
        ] value
    ]
                                                                        [exEnd]
"
! !

!Notification class methodsFor:'initialization'!

initialize

    NotifierString := 'Notification:'
! !

!Notification class methodsFor:'answering queries'!

answer:someAnswer do:aBlock
    "evaluate the argument, aBlock.
     If the receiver is queried during evaluation, answer and proceed with someAnswer.
     This is a wrapper for #handle:do: for lazy typists; no new functionality."

    <context: #return>
    <exception: #handle>

    "/ thisContext markForHandle. -- same as above pragma
    ^ aBlock value.  "the real logic is in Exception>>doRaise"

    "
     Notification answer:true do:[
        Transcript showCR:'query answers: ' , (Query query printString).
     ]
    "

    "
     Notification answer:false do:[
        Transcript showCR:'first query answers: ' , (Query query printString).
        Query answer:true do:[
            Transcript showCR:'second query answers: ' , (Query query printString).
        ]
     ]
    "

    "Created: / 10.7.1996 / 15:08:20 / cg"
    "Modified: / 14.10.1996 / 16:59:18 / cg"
    "Modified: / 25.7.1999 / 23:12:19 / stefan"
! !


!Notification class methodsFor:'queries'!

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
    "Created: / 23.7.1999 / 15:18:00 / stefan"
!

defaultAnswer
    "Return the default answer to the Query. This method is called,
     if nobody catches the signal.

     Subclasses may redefine this method."

    "Calling raiseRequest here will execute the exception's action method
     which returns the defaultResumeValue."    

    ^ super raiseRequest

    "Created: / 23.7.1999 / 15:16:03 / stefan"
!

handlerForSignal:signal context:theContext originator:originator
    "answer the handler block for the signal from originator.
     The block is retrieved from aContext.
     Answer nil if the signal is not handled"

    |arg|

    theContext selector == #'answer:do:' ifTrue:[
        (self == signal or:[self accepts:signal]) ifTrue:[
            arg := theContext argAt:1.
            ^ [:ex| ex proceedWith:arg].
        ]
    ] ifFalse:[
        ^ super handlerForSignal:signal context:theContext originator:originator.
    ].

    ^ nil

    "Created: / 25.7.1999 / 23:11:55 / stefan"
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

    "Created: / 23.7.1999 / 14:59:50 / stefan"
!

notify:aMessageString
    "raise the query - return the handler's value, or the default
     value, if there is no handler."

    "/ cg: must be redefined, so we get a reasonable originator
    "/ some apps depend on aoriginator being the non-exception context here.
    "/ (do not do a self raiseRequestErrorString: here)
    ^ self basicNew
        raiseRequestErrorString:aMessageString in:thisContext sender
!

notify:aMessageString with:aParameter
    "raise the query - return the handler's value, or the default
     value, if there is no handler."

    "/ cg: must be redefined, so we get a reasonable originator
    "/ some apps depend on an originator being the non-exception context here.
    "/ (do not do a self raiseRequestErrorString: here)
    ^ self basicNew
        parameter:aParameter;
        raiseRequestErrorString:aMessageString in:thisContext sender
!

query
    "raise the query - return the handler's value, or the default
     value, if there is no handler.
     Invoking the handler is exactly the functionality of Signal>>raiseRequest,
     but we can do it faster here (avoiding the construction of an exception instance)."

    ^ self raiseAsQuery
!

raise
    "Notifications are proceedable by definition,
     so they should be raised with #query or #raiseRequest"

    ^ self shouldNotImplement

    "Created: / 23.7.1999 / 15:19:17 / stefan"
!

raiseRequest
    "redefined to use #query"

    ^ self raiseAsQuery

    "Created: / 25.7.1999 / 23:25:59 / stefan"
! !

!Notification class methodsFor:'utilities'!

deprecated
    "invoked by some open source packages (SOAP and YAXO, for example)"

    self notify:'called deprecated interface'
! !

!Notification methodsFor:'accessing'!

tag
    "for squeak compatibility"

    ^ tag

    "Modified (comment): / 11-09-2011 / 16:40:54 / cg"
!

tag:aSzmbol
    "for squeak compatibility"

    tag := aSzmbol.

    "Modified (format): / 11-09-2011 / 16:41:01 / cg"
! !

!Notification methodsFor:'default actions'!

defaultAction
    "the default action is to return the default value.
     Subclasses may redefine this"

    |handlerBlock|

    "try per signal handler.
     I may have been created from a QuerySignal"

    (handlerBlock := self creator handlerBlock) notNil ifTrue:[
        "... and call it"
        ^ handlerBlock value:self.
    ].
    ^ self defaultResumeValue

    "Modified: / 23.7.1999 / 15:13:34 / stefan"
! !

!Notification methodsFor:'helpers'!

hasDialog
    "answer true, if we can use a Dialog window"

    (Smalltalk isInitialized 
     and:[Dialog notNil
     and:[Screen notNil
     and:[Screen current notNil
     and:[Screen current isOpenAndDispatching
    ]]]]) ifTrue:[
        Dialog autoload.        "in case its autoloaded"
        ^ true.
    ].
    ^ false
! !

!Notification methodsFor:'queries'!

notify
    "notice the implementation on the class-side: if no additional parameters are to be passed,
     we do not even arrive here, because query has inlined the raiseRequest code"

    ^ self raiseRequestIn:thisContext sender
!

notify:aMessageString
    "notice the implementation on the class-side: if no additional parameters are to be passed,
     we do not even arrive here, because query has inlined the raiseRequest code"

    ^ self raiseRequestErrorString:aMessageString in:thisContext sender
!

query
    "notice the implementation on the class-side: if no additional parameters are to be passed,
     we do not even arrive here, because query has inlined the raiseRequest code"

    ^ self raiseRequestIn:thisContext sender
! !

!Notification methodsFor:'testing'!

isNotification
    ^ true
! !

!Notification class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Notification initialize!

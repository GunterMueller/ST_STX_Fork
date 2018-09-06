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

GenericException subclass:#NoHandlerError
	instanceVariableNames:''
	classVariableNames:'EmergencyHandler'
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!NoHandlerError class methodsFor:'documentation'!

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
    NoHandlerError is raised, if there is no exception handler
    or default action for an exception.

    The parameter is the unhandled exception.

    [Class variables:]
        EmergencyHandler <Block>    this block is evaluated, if no handler was defined
                                    for a signal (i.e. this one is responsible for the
                                    unhandled exception debugger).
                                    Having this being a block allows to globally catch
                                    these errors - even when no enclosing handler-scope
                                    around the erroneous code exists.
                                    (as the catch/through does).


    [see also:]
        GenericException
        (``Exception handling and signals'': programming/exceptions.html)
"
!

examples
"
    The emergencyHandler stuff is very useful, to prevent endUser applications
    from entering the debugger.

    Some commonly used (useful) emergency handlers are provided in the
    'useful handlers' section; try them to learn more
    (especially, the mailingHandler is fun).

    Of course, these are only examples - you may define your own handler
    block and pass it to the #emergencyHandler: method.

    BTW: the Launchers 'source & debugger' settings menu allows you
	 to install either a default or the notifying handler.


    A handler which shows a box, then aborts - (no more debuggers):
								[exBegin]
	NoHandlerError emergencyHandler:(NoHandlerError abortingEmergencyHandler)
								[exEnd]


    A handler which aborts - (no box, no debugger):
								[exBegin]
	NoHandlerError emergencyHandler:[:ex | AbortSignal raise]
								[exEnd]


    try some exception (for demonstration, in some other process):
								[exBegin]
	[
	    #(1 2 3) at:4
	] fork.
								[exEnd]

    cleanup (switch back to the regular handler, which enters the debugger):
								[exBegin]
	NoHandlerError emergencyHandler:nil
								[exEnd]


    A handler which shows a warnBox and asks for debugging:
								[exBegin]
	NoHandlerError emergencyHandler:(NoHandlerError notifyingEmergencyHandler)
								[exEnd]



    A handler which dumps information to a file (watch the file 'errorTrace.stx'):
								[exBegin]
	NoHandlerError emergencyHandler:(NoHandlerError dumpingEmergencyHandler)
								[exEnd]



    A handler which sends you mail:
								[exBegin]
	NoHandlerError emergencyHandler:(NoHandlerError mailingEmergencyHandler)
								[exEnd]
"

! !

!NoHandlerError class methodsFor:'initialization'!

initialize

    NotifierString := 'unhandled exception'.

    "
     self initialize
    "


! !

!NoHandlerError class methodsFor:'accessing emergencyHandler'!

emergencyHandler
    "return the handler used for unhandled exceptions.

     If no EmergencyHandler has been set, a handler which enters the
     debugger is returned.
     The debugger is opened by asking the signal for a debug action,
     this allows to provide other debuggers in specialized (subclass-instances)
     of Signal (if that is ever needed)"

    "
     set it up, when called the first time
    "
    EmergencyHandler isNil ifTrue:[
	EmergencyHandler :=
	    [:ex |
		"
		 sending it to the signal allows per-signal specific
		 debuggers to be implemented in the future
		 (for example, segv in primitive code could show things
		  on the C-level ..)
		"
		ex creator openDebuggerOnException:ex.

		"if we arrive here, the debugger did proceed.
		 the value returned by #openDebuggerOnException: is the exceptions value ..."
	    ]
    ].

    ^ EmergencyHandler

    "
     NoHandlerError emergencyHandler:[:ex | Transcript showCR:ex description.
					    ex signal openDebuggerOnException:ex].
    "
!

emergencyHandler:aOneArgBlock
    "set the handler used for unhandled exceptions.
     The default (a nil-handler) leads to a debugger to be shown."

    EmergencyHandler := aOneArgBlock

    "ST-80 behavior of first showing a notifier:
     (I prefer to get right into the debugger, though)

     NoHandlerError
	emergencyHandler:
	    [:ex | self errorNotify:ex description ]
    "

    "ST-X behavior of going right into the debugger:

     NoHandlerError
	emergencyHandler:nil
    "

    "automatically aborting current operation, on error:
     (may be useful for end-user apps; make certain,
      you have abortSignal handlers at appropriate places)

     NoHandlerError
	emergencyHandler:
	    [:ex | AbortOperationRequest raise. ex return. ]
    "

    "finally, traditional language system behavior; dump core ;-)

     NoHandlerError
	emergencyHandler:
	    [:ex | Smalltalk exitWithCoreDump. ]
    "

    "Modified: 15.1.1997 / 20:49:06 / cg"
! !

!NoHandlerError class methodsFor:'useful emergency handlers'!

abortingEmergencyHandler
    "return a block (usable as an emergency handler),
     which aborts after showing a warnBox.
     This is useful for endUser applications."

    ^ [:ex | self warn:'Error: ' , ex description.
	     AbortOperationRequest raise
      ]

    "test with (try a few halts or CTRL-C's):
     NoHandlerError emergencyHandler:(NoHandlerError abortingEmergencyHandler)
    "

    "back with:
     NoHandlerError emergencyHandler:(NoHandlerError notifyingEmergencyHandler)
     NoHandlerError emergencyHandler:nil
    "

    "Created: 15.1.1997 / 20:13:06 / cg"
    "Modified: 15.1.1997 / 20:15:02 / cg"
!

dumpingEmergencyHandler
    "return a block (usable as an emergency handler),
     which dumps the stackBacktrace to a trace file and
     aborts after showing a warnBox.
     This is useful, for endUser application, which are still being
     debugged (i.e. the programmers may have a look at the traceFile
     from time to time).

     Notice:
	 The code below is just an example; you may want to change the
	 name of the error-file in your application
	 (but please: copy the code; do not modify here)"

    ^ [:ex |
	     |str printedException|

	     ex creator == NoHandlerError ifTrue:[
		printedException := ex exception.
	     ] ifFalse:[
		printedException := ex
	     ].

	     "/ user interruption is handled specially:
	     "/ allow user to choose between proceeding or aborting
	     "/ but never dump that information to the file.

	     printedException creator == Object userInterruptSignal ifTrue:[
		  (self confirm:'abort current action ?') ifTrue:[
		      AbortOperationRequest raise
		  ].
		  ex proceedWith:nil
	     ].

	     "/
	     "/ dump it to 'errorTrace.stx'
	     "/
	     str := 'errorTrace.stx' asFilename appendingWriteStream.

	     str nextPutLine:('******************************* '
			      , Timestamp now printString
			      , ' *******************************').
	     str cr.

	     str nextPutLine:('** Error: ' , printedException description).
	     str nextPutLine:('** Signal: ' , printedException creator printString).
	     str nextPutLine:('** Parameter: ' , printedException parameter printString).
	     str nextPutLine:('** Process: ' , Processor activeProcess printString).
	     str nextPutLine:('** Backtrace:').
	     str cr.

	     printedException suspendedContext fullPrintAllOn:str.
	     str cr.
	     str cr.
	     str close.

	     "/ send a line to stdErr

	     ('[warning]: ignored error: ' , printedException description) errorPrintCR.
	     ('[warning]:    error information appended to ''errorTrace.stx''') errorPrintCR.

	     AbortOperationRequest raise
      ]

    "test with (try a few halts or CTRL-C's):
     NoHandlerError emergencyHandler:(NoHandlerError dumpingEmergencyHandler)
    "

    "back with:
     NoHandlerError emergencyHandler:(NoHandlerError notifyingEmergencyHandler)
     NoHandlerError emergencyHandler:nil
    "

    "Created: / 15.1.1997 / 20:14:52 / cg"
    "Modified: / 24.1.1997 / 20:36:21 / cg"
    "Modified: / 4.8.1999 / 08:11:20 / stefan"
!

mailingEmergencyHandler
    "return a block (usable as an emergency handler),
     which shows a warnBox and optionally mails a stackBacktrace to a maintainer.
     This is useful, for endUser application, which are still being
     debugged (i.e. the programmers may have a look at the errors).

     Notice: the stuff here is a demonstration only; it should be modified
	     for your particular environment ...
	     ... but please: copy the code and modify there;
	     leave the stuff below as it is."

    ^ [:ex |
	    |str printedException doMail emergencyMailReceiver pipe|

	    ex creator == NoHandlerError ifTrue:[
	       printedException := ex exception.
	    ] ifFalse:[
	       printedException := ex
	    ].

	     "/ user interruption is handled specially:
	     "/ allow user to choose between proceeding or aborting
	     "/ but never dump that information to the file.

	     printedException creator == UserInterrupt ifTrue:[
		  (self confirm:'abort current action ?') ifTrue:[
		      AbortOperationRequest raise
		  ].
		  ex proceedWith:nil
	     ].

	    "/ somehow get the name of the guy to receive the mail
	    "/ you have to implement that yourself.

	    "/ emergencyMailReceiver := OneOfYourClass getEmergencyMailReceiver.
	    emergencyMailReceiver := OperatingSystem getLoginName.

	    emergencyMailReceiver isNil ifTrue:[
		self warn:(printedException description
			   , '\\No mailing to service people possible.') withCRs.
		doMail := false.
	    ] ifFalse:[
		doMail := self confirm:(printedException description
					, '\\Mail error information to the service people ('
					, emergencyMailReceiver , ') ?') withCRs
	    ].
	    doMail ifTrue:[
		str := '' writeStream.

		str nextPutLine:('Error notification from '
				, OperatingSystem getLoginName
				, '@'
				, OperatingSystem getHostName).
		str cr.

		str nextPutLine:('Time: ' , Timestamp now printString).
		str nextPutLine:('Error: ', printedException description).
		str nextPutLine:('Signal: ', printedException creator printString).
		str nextPutLine:('Parameter: ', printedException parameter printString).
		str nextPutLine:('Process: ', Processor activeProcess printString).
		str nextPutLine:'Backtrace:'.
		str cr.

		printedException suspendedContext fullPrintAllOn:str.
		str cr;cr.

		str close.

		pipe := PipeStream
			    writingTo:'mail ', emergencyMailReceiver.
		pipe notNil ifTrue:[
		    pipe nextPutLine:'Subject: automatic error report'.
		    pipe nextPutAll:str contents.
		    pipe cr.
		    pipe close.
		]
	     ].

	     AbortOperationRequest raise.
	     "not reached"
      ]

    "test with (try a few halts or CTRL-C's):
     NoHandlerError emergencyHandler:(NoHandlerError mailingEmergencyHandler)
    "

    "back with:
     NoHandlerError emergencyHandler:(NoHandlerError notifyingEmergencyHandler)
     NoHandlerError emergencyHandler:nil
    "

    "Created: / 15.1.1997 / 20:14:52 / cg"
    "Modified: / 15.1.1997 / 21:10:28 / cg"
    "Modified: / 4.8.1999 / 08:11:26 / stefan"
!

notifyingEmergencyHandler
    "return a block (usable as an emergency handler for exceptions),
     which does errorNotification before going into the debugger.
     Halts and breakpoints go directly into the debugger (without asking)"

    ^ [:ex |
	|message|

	message := ex descriptionForDebugger.

	(ex creator == NoHandlerError
	 and:[(ControlInterrupt handles:ex exception)
	 and:[(ControlInterrupt ~~ ex exception creator) ]]) ifTrue:[
	    "/ go directly into the debugger ...
	    ^ Debugger
		enter:ex returnableSuspendedContext
		withMessage:message
		mayProceed:ex mayProceed.
	].
	"/ ask, and maybe go into the debugger ...
	^ nil
	    errorNotify:message
	    from:ex returnableSuspendedContext
	    allowDebug:true
	    mayProceed:ex mayProceed.
      ]

    "test with (NOTE: halt, breakpoints or CTRL-C's still go straight into the debugger):
     NoHandlerError emergencyHandler:(NoHandlerError notifyingEmergencyHandler).
     Object bla.
    "

    "back with:
     NoHandlerError emergencyHandler:nil
    "

    "Modified: / 16.11.2001 / 16:07:05 / cg"
!

notifyingEmergencyHandlerForUserProcesses
    "return a block (usable as an emergency handler for exceptions),
     which does errorNotification before going into the debugger,
     but only for exceptions occurring in user processes;
     systemProcesses are not debugged.
     Halts and breakpoints go directly into the debugger (without asking)"

    ^ [:ex |

	|theException message|

	Processor activeProcessIsSystemProcess ifTrue:[
	    'EmergencyHandler [info]: exception caught: ' errorPrint.
	    ex creator == NoHandlerError ifTrue:[
		theException := ex exception.
	    ] ifFalse:[
		theException := ex
	    ].
	    theException description errorPrintCR.
	    AbortOperationRequest raise.
	] ifFalse:[
	    message := ex descriptionForDebugger.

	    (ex creator == NoHandlerError
	    and:[ (ControlInterrupt handles:ex exception)
	    and:[ (ControlInterrupt ~~ ex exception creator) ]]) ifTrue:[
		"/ go directly into the debugger ...
		^ Debugger
		    enter:ex returnableSuspendedContext
		    withMessage:message
		    mayProceed:ex mayProceed.
	    ].
	    "/ ask, and maybe go into the debugger ...
	    ^ nil
		errorNotify:message
		from:ex returnableSuspendedContext
		allowDebug:true
		mayProceed:ex mayProceed.
	]
      ]

    "test with:
     NoHandlerError emergencyHandler:(NoHandlerError notifyingEmergencyHandlerForUserProcesses)
     Object bla.
    "

    "back with:
     NoHandlerError emergencyHandler:nil
    "

    "Modified: / 16.11.2001 / 16:06:54 / cg"
! !

!NoHandlerError methodsFor:'accessing'!

exception
    "the original exception, which was responsible for this.
     ANSI compatibility"

    ^ parameter
!

originalSignal
    "return the signal/exception which was originally raised.
     For noHandler, that is my unhandled signal; for others, that's the exception itself."

    ^ parameter originalSignal.
!

unhandledException
    <resource: #obsolete>
    "the original exception, which was responsible for this.
     Obsolete: use #exception for ANSI comatibility."

    ^ parameter
! !

!NoHandlerError methodsFor:'default actions'!

defaultAction
    "This action is performed, if nobody handles the NoHandlerError.
     Look for either a per-process emergencyHandlerBlock
     or the global emergencyHandler ..."

    |block|

    Processor notNil ifTrue:[
	"care for signal during startup (Processor not yet created)"
	block := Processor activeProcess emergencySignalHandler.
    ].
    block isNil ifTrue:[
	block := self class emergencyHandler.
	block isNil ifTrue:[
	    "care for error during startup (Exception not yet initialized)"
	    ^ MiniDebugger
		enterWithMessage:self description
		mayProceed:self mayProceed
	].
    ].

    ^ block value:self
!

noHandler
    "redefined to avoid recursive invocations"

    ^ self
! !

!NoHandlerError methodsFor:'printing & storing'!

descriptionForDebugger
    "return the description string of the signal which is used in the
     debugger title area"

    ^ parameter description.
! !

!NoHandlerError methodsFor:'queries'!

mayProceed
    "return true, if the exception handler is allowed to proceed
     the execution where the exception occurred."

    ^ parameter isNil or:[parameter mayProceed].
! !

!NoHandlerError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


NoHandlerError initialize!

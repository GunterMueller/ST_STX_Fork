"{ NameSpace: CodingExamples }"

Object subclass:#SignalHandlingExample
	instanceVariableNames:''
	classVariableNames:'PrivateSignal Flag'
	poolDictionaries:''
	category:'examples-Exceptions'
!

!SignalHandlingExample class methodsFor:'documentation'!

documentation
"
    demonstrates handling of various exceptions
"

! !

!SignalHandlingExample class methodsFor:'examples'!

example1
    "the handler will proceed, thus continuing in the raising 
     method and returning its normal value"

    |val|

    '' printNL. 'example1:' printNL.
    PrivateSignal := Signal new mayProceed:true.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler; now resuming ..' printNL.

            ex proceed
        ] do:[
            self exampleHelper
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example1
    "

    "Modified: 27.1.1997 / 15:34:31 / cg"
!

example10
    "shows how to handle arithmetic signals with one handler.
     The handler just prints what happens (i.e. what type of signal) and
     proceeds."

    |val|

    '' printNL. 'example10:' printNL.
    (Float arithmeticSignal) handle:[:ex |
        '    in handler, got signal: ' print.
        ex signal notifierString print.
        '; continue' printNL.
        ex proceedWith:0
    ] do:[
        '  1 ..' printNL.
        self computation1:0.   "raises a domain error"
        '  2 ..' printNL.
        self computation2:5.   "raises a domain error"
        '  3 ..' printNL.
        self computation3:0.   "raises a division by zero"
        '  now at end of block' printNL
    ]

    "
     SignalHandlingExample example10
    "

    "Modified: 27.1.1997 / 15:34:37 / cg"
!

example11
    "shows non nested signal handling.
     The handling block shows a warnBox and proceeds."

    |val mySignal|

    '' printNL. 'example11:' printNL.

    mySignal := Signal new.
    mySignal handlerBlock:[:ex |
        self warn:'a private Signal occured'.
    ].

    mySignal raise.

    "
     SignalHandlingExample example11
    "

    "Modified: 27.1.1997 / 15:34:44 / cg"
!

example12
    "shows non nested signal handling.
     The handling block shows a warnBox and proceeds."

    |val mySignal|

    '' printNL. 'example12:' printNL.

    mySignal := Signal new.
    mySignal handlerBlock:[:ex |
        self warn:'a private Signal occured'.
    ].

    [
        (Delay forSeconds:3) wait.
        mySignal raise.
    ] fork.

    "
     SignalHandlingExample example12
    "

    "Modified: 27.1.1997 / 15:34:50 / cg"
!

example13
    "shows non nested signal combined with nested signal handling.
     The handling block shows a warnBox and proceeds, while
     a handlercontext handles the signal by returning. 
     Thus, the static block handler will not be called and no box will be shown."

    |val mySignal|

    '' printNL. 'example13:' printNL.

    mySignal := Signal new.
    mySignal handlerBlock:[:ex |
        self warn:'a private Signal occured'.
    ].

    [
        (Delay forSeconds:3) wait.
        mySignal handle:[:ex |
            '  handler took it' printNL.
            ex return
        ] do:[
            (Delay forSeconds:1) wait.
            mySignal raise.
        ]
    ] fork.

    "
     SignalHandlingExample example13
    "

    "Modified: 27.1.1997 / 15:34:58 / cg"
!

example14
    "shows non nested signal combined with nested signal handling.
     The handling block shows a warnBox and proceeds, while
     a handlercontext rejects the signal.
     Thus, the static block handler will be called and a box will be shown."

    |val mySignal|

    '' printNL. 'example14:' printNL.
    mySignal := Signal new.
    mySignal handlerBlock:[:ex |
        self warn:'a privateSignal occured'.
    ].

    [
        (Delay forSeconds:3) wait.
        mySignal handle:[:ex |
            'handler rejects ...' printNL.
            ex reject
        ] do:[
            (Delay forSeconds:1) wait.
            mySignal raise.
        ]
    ] fork.

    "
     SignalHandlingExample example14
    "

    "Modified: 27.1.1997 / 15:35:05 / cg"
!

example15
    "shows non nested signal combined with nested signal handling.
     The handling block shows a warnBox and proceeds, while
     a handlercontext handles the signal, and retruns.
     Thus, the static block handler will NOT be called."

    |val mySignal|

    '' printNL. 'example15:' printNL.

    mySignal := Signal new.
    mySignal handlerBlock:[:ex  |
        self warn:'a privateSignal occured'.
    ].

    [
        (Delay forSeconds:3) wait.
        mySignal handle:[:ex |
            '  handler falls through ...' printNL.
        ] do:[
            (Delay forSeconds:1) wait.
            mySignal raise.
        ]
    ] fork.

    "
     SignalHandlingExample example15
    "

    "Modified: 27.1.1997 / 15:35:11 / cg"
!

example16
    "not handling a UNIX signal:
     Install a private signal to be raised when the unix-signal arrives.
     fork a process, to send a signal after 3 seconds.
     The signal is not handled - thus leading into debugger."

    |mySignal command childId|

    '' printNL. 'example16:' printNL.

    "install a signal, which is not handled"
    mySignal := Signal new.
    OperatingSystem operatingSystemSignal:(OperatingSystem sigUSR1) install:mySignal.

    "let them come ..."
    OperatingSystem enableSignal:(OperatingSystem sigUSR1).

    "fork off the process"
    command := 'sleep 3 ; kill -USR1 ' , OperatingSystem getProcessId printString.
    (childId := OperatingSystem fork) == 0 ifTrue:[
        "I am the child"
        OperatingSystem executeCommand:command.
        OperatingSystem exit.
    ].

    "father (mother ;-) leaves ..."

    "
     SignalHandlingExample example16
    "

    "Modified: 27.1.1997 / 15:35:25 / cg"
!

example17
    "handling a UNIX signal:
     fork a process, to send a signal after 3 seconds.
     the signal is handled."

    |mySignal command childId|

    '' printNL. 'example17:' printNL.

    "install a signal,"
    mySignal := Signal new.
    OperatingSystem operatingSystemSignal:(OperatingSystem sigUSR1) install:mySignal.

    "which is handled"
    mySignal handlerBlock:[:ex |
        self warn:'a signal arrived'.
        "uninstall"
        OperatingSystem operatingSystemSignal:(OperatingSystem sigUSR1) install:nil.
    ].

    "let them come ..."
    OperatingSystem enableSignal:(OperatingSystem sigUSR1).

    "fork off the process"
    command := 'sleep 3 ; kill -USR1 ' , OperatingSystem getProcessId printString.
    (childId := OperatingSystem fork) == 0 ifTrue:[
        "I am the child"
        OperatingSystem executeCommand:command.
        OperatingSystem exit.
    ].

    "father (mother ;-) leaves ..."

    "
     SignalHandlingExample example17
    "

    "Modified: 27.1.1997 / 15:35:41 / cg"
!

example18
    "trigger a semaphore on arrival of a UNIX signal:
     fork a process, to send a signal after 3 seconds.
     the signal is globally handled, by triggering a semaphore, on which we wait here"

    |USR1Semaphore mySignal command childId|

    '' printNL. 'example18:' printNL.

    "create the semaphore"
    USR1Semaphore := Semaphore new.

    "install a signal,"
    mySignal := Signal new.
    OperatingSystem operatingSystemSignal:(OperatingSystem sigUSR1) install:mySignal.

    "which is handled - and wakes up my semaphore"
    mySignal handlerBlock:[:ex  |
        '  here signal handler; now trigger sema' printNL.
        USR1Semaphore signal.
        "uninstall"
        OperatingSystem operatingSystemSignal:(OperatingSystem sigUSR1) install:nil.
    ].

    "let them come ..."
    OperatingSystem enableSignal:(OperatingSystem sigUSR1).

    "fork off the process"
    command := 'sleep 3 ; kill -USR1 ' , OperatingSystem getProcessId printString.
    (childId := OperatingSystem fork) == 0 ifTrue:[
        "I am the child"
        OperatingSystem executeCommand:command.
        OperatingSystem exit.
    ].

    "I fork off a process to wait"

    [
        'process waits on sema ...' printNL.
        USR1Semaphore wait.
        'I got the signal - Hello there !!' printNL.
    ] fork.

    'father does whatever ...' printNL.

    "
     SignalHandlingExample example18
    "

    "Modified: 27.1.1997 / 15:35:59 / cg"
!

example19
    "demonstrates recursion overflow signals;
     see more on this in 'doc/coding/Signal-stackoverflow.st'"

    '' printNL. 'example19:' printNL.

    Object recursionInterruptSignal handle:[:ex |
        '  oops too much recursion' printNL.
        ex return
    ] do:[
        'start ...' printNL.
        10000 factorial.
        'done ...' printNL.
    ].
    'thats it' printNL

    "
     SignalHandlingExample example19
    "

    "Modified: 27.1.1997 / 15:36:05 / cg"
!

example2
    "the handler will proceed, thus continuing in the raising method 
     and returning its normal value"

    |val|

    '' printNL. 'example2:' printNL.
    PrivateSignal := Signal new.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler; now resuming ..' printNL.

            ex proceedWith:'handlers value'
        ] do:[
            self exampleHelper
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example2
    "

    "Modified: 27.1.1997 / 15:36:12 / cg"
!

example20
    "demonstrates use of exceptions for save evaluation.
     Any error will be caught ...
     End-user programs should include something like this when
     evaluated user-entered expressions. (try entering 1 fooBar)"

    '' printNL. 'example20:' printNL.

    SignalSet anySignal handle:[:ex |
        self warn:'an error occured'.
        ex return
    ] do:[
        |line|

        line := DialogView request:'any expression (may be faulty):'.
        Compiler evaluate:line.
        'after evaluation' printNL.
    ].
    'thats it' printNL

    "
     SignalHandlingExample example20
    "

    "Modified: 27.1.1997 / 15:36:19 / cg"
!

example3
    "the handler will return, thus aborting the raising method 
     and returning nil from the computation"

    |val|

    '' printNL. 'example3:' printNL.
    PrivateSignal := Signal new.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler; now returning ..' printNL.

            ex return
        ] do:[
            self exampleHelper
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example3
    "

    "Modified: 27.1.1997 / 15:36:24 / cg"
!

example4
    "the handler will return with a value, thus aborting the raising method 
     and returning the handlers value from the computation"

    |val|

    '' printNL. 'example4:' printNL.
    PrivateSignal := Signal new.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler; now returning ..' printNL.

            ex returnWith:'handlers value'
        ] do:[
            self exampleHelper
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example4
    "

    "Modified: 27.1.1997 / 15:36:31 / cg"
!

example5
    "the handler will reject - thus leading into the debugger"

    |val|

    '' printNL. 'example4:' printNL.
    PrivateSignal := Signal new.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler; rejecting' printNL.

            ex reject
        ] do:[
            self exampleHelper
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example5
    "

    "Modified: 27.1.1997 / 15:36:38 / cg"
!

example6
    "two handlers; the inner handler will reject - thus leading to the outer
     handler; the outer handler returns (nil)."

    |val|

    '' printNL. 'example6:' printNL.
    PrivateSignal := Signal new.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler1; returning ..' printNL.

            ex return
        ] do:[
            self exampleHandler
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example6
    "

    "Modified: 27.1.1997 / 15:36:43 / cg"
!

example6b
    "two handlers; the inner handler falls through - thus returning from
     the exception."

    |val|

    '' printNL. 'example6b:' printNL.
    PrivateSignal := Signal new.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler1; returning ..' printNL.

            ex return
        ] do:[
            self exampleHandler2
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example6b
    "

    "Modified: 27.1.1997 / 15:36:49 / cg"
!

example7
    "the handler will do some cleanup action (setting Flag) and restart the
     computation (which will not fail the second time)."

    |val|

    '' printNL. 'example7:' printNL.
    PrivateSignal := Signal new.
    Flag := false.
    val :=
        PrivateSignal handle:[:ex |
            '    in handler1; cleanup and restart ..' printNL.

            Flag := true.
            ex restart
        ] do:[
            self trapIfFlagIsFalse
        ].

    '  final return value: ' print. val printNL

    "
     SignalHandlingExample example7
    "

    "Modified: 27.1.1997 / 15:36:55 / cg"
!

example8
    "shows how to handle multiple signals (a SignalSet) with one handler.
     The handler just prints what happens (i.e. what type of signal) and
     proceeds."

    |val signals|

    '' printNL. 'example8:' printNL.

    PrivateSignal := Signal new notifierString:'my private signal'.
    signals := SignalSet with:PrivateSignal
                         with:Float divisionByZeroSignal.

    val :=
        signals handle:[:ex |
            '    in handler, got signal: ' print.
            (ex signal notifierString) printNL.
            ex proceed
        ] do:[
            '  starting ..' printNL.
            self exampleHelper.
            '  now dividing by zero ...' printNL.
            self badDivision:0.
            '  now at end of block' printNL
        ].

    '  thats it' printNL

    "
     SignalHandlingExample example8
    "

    "Modified: 27.1.1997 / 15:37:05 / cg"
!

example9
    "shows how to handle multiple signals (the parent of anySignal)
     with one handler.
     The handler just prints what happens (i.e. what type of signal) and
     proceeds."

    |val|

    '' printNL. 'example9:' printNL.
    PrivateSignal := Object errorSignal newSignal notifierString:'my private signal'.

    Object errorSignal handle:[:ex |
        '    in handler, got signal: ' print.
        ex signal notifierString printNL.
        ex proceed
    ] do:[
        'now raising my signal ..' printNL.
        self exampleHelper.

        '  now dividing by zero ...' printNL.
        self badDivision:0.

        '  now sending something not understood ...' printNL.
        self perform:#fooBarBaz.

        '  now at end of block' printNL
    ]

    "
     SignalHandlingExample example9
    "

    "Modified: 27.1.1997 / 15:37:15 / cg"
! !

!SignalHandlingExample class methodsFor:'helpers'!

badDivision:arg
    ^ 3 / arg
!

computation1:arg
    arg log      "will raise a domain error if arg is zero"
!

computation2:arg
    arg arcSin   "will raise a domain error for some arguments"
!

computation3:arg
    3.0 / arg    "will raise a divisionByZero signal for zero arg"
!

"---------------------------------- no more examples, but helpers ---------------------------"

exampleHandler
    |val|

    val :=
	PrivateSignal handle:[:ex |
	    '    in handler2; rejecting ..' printNL.

	    ex reject
	] do:[
	    self exampleHelper
	].

    '  exampleHandler return value: ' print. val printNL
!

exampleHandler2
    |val|

    val :=
	PrivateSignal handle:[:ex |
	    '    in handler2; fall through ..' printNL.
	    'thats it'
	] do:[
	    self exampleHelper
	].

    '  exampleHandler2 return value: ' print. val printNL.
    ^ val
!

exampleHelper
    |val|

    '  in raising method - raising signal ..' printNL.

    val := PrivateSignal raiseRequest.

    '  in raising method after raise; ' print.
    '  raise returned: ' print. val printNL.
    '  return from raising method ...' printNL.

    ^ 'normal value'
!

trapIfFlagIsFalse
    Flag ifTrue:[
	'  in processing method - all ok; return ..' printNL.
	^ 'normal value'
    ].

    '  in processing method - raising signal ..' printNL.

    PrivateSignal raise.

    "not reached if handler restarts ..."
    '  return from raising method ...' printNL.

    ^ 'normal value'
! !

!SignalHandlingExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Signal-handling.st,v 1.8 1999-10-18 21:20:31 stefan Exp $'
! !

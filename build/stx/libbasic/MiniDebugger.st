"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

Object subclass:#MiniDebugger
	instanceVariableNames:'tracing stepping traceBlock command commandArg commandCount
		enteringContext dot nesting inputStream'
	classVariableNames:'NotFirstTimeEntered'
	poolDictionaries:''
	category:'System-Debugging-Support'
!

!MiniDebugger class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    a primitive (non graphical) debugger for use on systems without
    graphics or when the real debugger dies 
    (i.e. an error occurs in the graphical debugger or the UI/event handler is broken).
    This one is also called for, if an interrupt occurs within the debuger, 
    or if CTRL-C is pressed in the controlling tty/console.
    Needs a console.

        MiniDebugger enter

    Attention:
        all printing is done via lowLevel _errorPrint messages,
        to ensure that output is to stderr, even if a logger is present, 
        or Stderr has been set to some other stream (Transcript).
        Also to avoid the logger's interfering and adding imestamp information.
        
    [author:]
        Claus Gittinger
"
! !

!MiniDebugger class methodsFor:'instance creation'!

enter
    "enter a miniDebugger"

    ^ self
        enter:thisContext sender
        withMessage:'MiniDebugger'
        mayProceed:true
        input:nil

    "
     MiniDebugger enter
    "
!

enter:aContext withMessage:aString mayProceed:mayProceed
    "enter a miniDebugger"

    ^ self 
        enter:aContext 
        withMessage:aString 
        mayProceed:mayProceed 
        input:nil
!

enter:aContext withMessage:aString mayProceed:mayProceed input:inputStreamOrNil
    "enter a miniDebugger"

    |active con sender|

    StepInterruptPending := nil.

    Error handle:[:ex |
        ex return
    ] do:[
        thisContext isRecursive ifTrue:[
            "/ 'recursive _error in debugger ignored' _errorPrintCR.
            ^ self
        ].

        aString _errorPrintCR.
        Processor notNil ifTrue:[
            active := Processor activeProcess.
            'process: id=' _errorPrint. active id _errorPrint.
            ' name=' _errorPrint. active name _errorPrintCR.

            'context: ' _errorPrint. aContext printString _errorPrintCR.
            (con := aContext) notNil ifTrue:[
                con := con sender.
                ' ......: ' _errorPrint. con printString _errorPrintCR.
                [con notNil] whileTrue:[
                    sender := con sender.
                    (sender notNil and:[sender selector == con selector]) ifTrue:[
                        ' ......: ' _errorPrint. sender printString _errorPrintCR.
                        ' ......:  [** intermediate recursive contexts skipped **]' _errorPrintCR.
                        [sender notNil
                         and:[sender selector == con selector
                         and:[sender method == con method]]] whileTrue:[
                            con := sender.
                            sender := con sender.
                        ].
                    ].
                    con := sender.
                    ' ......: ' _errorPrint. con printString _errorPrintCR.
                ]
            ]
        ].
        NotFirstTimeEntered ~~ true ifTrue:[
            NotFirstTimeEntered := true.
            'Type "c" to proceed, "?" for help' _errorPrintCR.
        ].
    ].

    OperatingSystem hasConsole ifFalse:[
        Error handle:[:ex |
            ex return
        ] do:[
            self warn:('Unexpected _error:\' , aString , '\\No MiniDebugger functionality available') withCRs .
        ].

        Error handle:[:ex |
            'cannot raise Abort - exiting ...' _errorPrintCR.
            OperatingSystem exit:10.
        ] do:[
            AbortOperationRequest raise.
        ]
    ] ifTrue:[
        self new 
            inputStream:inputStreamOrNil;
            enter:aContext mayProceed:mayProceed.
    ].
    mayProceed ifFalse:[
        AbortOperationRequest raise
    ].
    ^ nil

    "Modified: / 19.5.1999 / 18:14:33 / cg"
!

enterException:ex
    "enter a debugger; if this is a recursive invocation, enter
     a MiniDebugger instead.
     This is the standard way of entering the debugger;
     sent from error- and halt messages."

    ^ self
        enter:ex returnableSuspendedContext
        withMessage:(ex creator name,': ',ex descriptionForDebugger)
        mayProceed:(ex mayProceed)
        input:nil
!

enterWithMessage:aString mayProceed:mayProceed
    "enter a miniDebugger"

    ^ self
        enter:thisContext sender
        withMessage:aString
        mayProceed:mayProceed
        input:nil

    "Modified: / 19.5.1999 / 18:14:33 / cg"
!

new
    "redefined to make certain that there is only one miniDebugger
     in the system"

    ^ self basicNew initialize.

"/    TheOneAndOnlyDebugger isNil ifTrue:[
"/        TheOneAndOnlyDebugger := self basicNew initialize
"/    ].
"/    ^ TheOneAndOnlyDebugger

    "
     TheOneAndOnlyDebugger := nil
    "

    "Modified: / 31.7.1998 / 17:08:07 / cg"
!

openOn:aProcess
    "enter a miniDebugger"

    ^ self
        enter:thisContext sender
        withMessage:'MiniDebugger [info]: Attention - process debugging not possible.'
        mayProceed:true
        input:nil

    "Modified: / 19.5.1999 / 18:14:33 / cg"
!

singleStep:aBlock
    |aDebugger|

    aDebugger := self new stepping.
    ObjectMemory stepInterruptHandler:aDebugger.
    ObjectMemory flushInlineCaches.
    StepInterruptPending := 1.
    InterruptPending := 1.
    aBlock value.
    StepInterruptPending := nil.
    ObjectMemory stepInterruptHandler:nil
!

trace:aBlock
    self trace:aBlock with:[:where | where _errorPrintCR]

    "Modified: 20.5.1996 / 10:27:37 / cg"
!

trace:aBlock on:aStream
    self trace:aBlock with:[:where | where printString printOn:aStream.
				     aStream cr]
!

trace:aBlock with:aTraceBlock
    |aDebugger|

    aDebugger := self new tracingWith:aTraceBlock.
    ObjectMemory stepInterruptHandler:aDebugger.
    ObjectMemory flushInlineCaches.
    StepInterruptPending := 1.
    InterruptPending := 1.
    aBlock value.
    ObjectMemory stepInterruptHandler:nil.
    StepInterruptPending := nil.
    ^ nil
! !

!MiniDebugger methodsFor:'accessing'!

inputStream:aStream
    "if non-nil, the debugger will read its input from there.
     This allows for a miniDebugger to be used in a telnet stream (scripting)"
     
    inputStream := aStream.
! !

!MiniDebugger methodsFor:'entering'!

enter:aContext mayProceed:mayProceed
    "regular entry, via unhandled exception"

    |c leaveCmd stillHere yesNo|

    Display notNil ifTrue:[
        Display ungrabKeyboard; ungrabPointer.
    ].
    
    enteringContext := dot := aContext.
    nesting := 0.
    c := aContext.
    [c notNil] whileTrue:[
        c selector == #enter:mayProceed: ifTrue:[
            nesting := nesting + 1.
        ].
        c := c sender.
    ].

    stillHere := true.
    [stillHere] whileTrue:[
        AbortOperationRequest handle:[:ex |
            '** Abort caught - back in previous debugLevel' _errorPrintCR.
        ] do:[
            Error handle:[:ex |
                StreamError handle:[:ex|
                    "You won't see this probably - but you will see it when doing a syscall trace"
                    'Error while processing _error in MiniDebugger (Stdout closed?):' _errorPrintCR.
                    ex description _errorPrintCR.
                    OperatingSystem exit:10.
                ] do:[
                    'Error while executing MiniDebugger command: ' _errorPrint.
                    ex description _errorPrintCR.
                    yesNo := self getCommand:'- (i)gnore / (p)roceed / (d)ebug / b(acktrace) ? '.
                    yesNo == $d ifTrue:[
                        MiniDebugger enterWithMessage:'Debugging debugger' mayProceed:true.
                        ex proceed
                    ].
                    yesNo == $p ifTrue:[
                        ex proceed
                    ].
                    yesNo == $b ifTrue:[
                        ex suspendedContext fullPrintAll.
                        ex proceed
                    ].
                ].
            ] do:[
                [
                    leaveCmd := self commandLoop.
                ] valueUnpreemptively.
            ].
        ].

        (leaveCmd == $s) ifTrue: [
            self stepping.
            ObjectMemory flushInlineCaches.
            ObjectMemory stepInterruptHandler:self.
            stillHere := false.
            StepInterruptPending := 1.
            InterruptPending := 1
        ].
        (leaveCmd == $t) ifTrue: [
            traceBlock := [:where | self printContext:where].
            ObjectMemory flushInlineCaches.
            ObjectMemory stepInterruptHandler:self.
            stillHere := false.
            StepInterruptPending := 1.
            InterruptPending := 1
        ].
        (leaveCmd == $c) ifTrue: [
            traceBlock := nil.
            ObjectMemory flushInlineCaches.
            ObjectMemory stepInterruptHandler:nil.
            stillHere := false.
            stepping := false.
            tracing := false.
            StepInterruptPending := nil.
            InterruptPending := nil
        ].
        ((leaveCmd == $a) or:[(leaveCmd == $Y)]) ifTrue: [
            "abort"
            traceBlock := nil.
            ObjectMemory flushInlineCaches.
            ObjectMemory stepInterruptHandler:nil.
            stepping := false.
            tracing := false.
            StepInterruptPending := nil.
            InterruptPending := nil.
            self doAbort.
            stillHere := true.
            "failed abort"
        ].
    ].
    enteringContext := dot := nil.
    ^ nil

    "Modified (comment): / 29-09-2011 / 09:05:57 / cg"
!

stepInterrupt
    "entry via single stepinterrupt"

    |where|

    where := thisContext.        "where is stepInterrupt context"
    where notNil ifTrue:[
        where := where sender    "where is now interrupted methods context"
    ].
    stepping ifTrue:[
        where notNil ifTrue:[
            self printContext:where
        ] ifFalse:[
            'stepInterrupt: no context' _errorPrintCR
        ].
        self enter:where mayProceed:true
    ] ifFalse:[
        where notNil ifTrue:[
            traceBlock notNil ifTrue:[
                traceBlock value:where
            ]
        ] ifFalse:[
            'traceInterrupt: no context' _errorPrintCR
        ].
        ObjectMemory flushInlineCaches.
        StepInterruptPending := 1.
        InterruptPending := 1
    ]

    "Modified: / 20-05-1996 / 10:23:11 / cg"
    "Modified (comment): / 29-09-2011 / 09:06:29 / cg"
! !

!MiniDebugger methodsFor:'initialization'!

initialize
    traceBlock := nil.
    tracing := false.
    stepping := false
! !

!MiniDebugger methodsFor:'private'!

findContext:aSelector
    |con|

    con := thisContext sender.
    [con notNil] whileTrue:[
	(con isBlockContext not and:[con selector == aSelector]) ifTrue:[
	    "got it"
	    ^ con
	].
	con := con sender
    ].
    ^ nil
!

garbageCollectCommand:id
    id == 3 ifTrue:[
	ObjectMemory reclaimSymbols.
	ObjectMemory compressOldSpace.
    ] ifFalse:[
	id == 2 ifTrue:[
	    ObjectMemory reclaimSymbols.
	] ifFalse:[
	    ObjectMemory garbageCollect.
	]
    ]
!

getCharacter
    inputStream isNil ifTrue:[
        "/ globally blocking
        ^ Character fromUser
    ].
    ^ inputStream next
!

getContext
    |backtrace|

    backtrace := thisContext.
    (backtrace notNil) ifTrue: [
	[backtrace selector ~~ #commandLoop] whileTrue:[
	    backtrace := backtrace sender.
	].
	"remove Debugger commandLoop frame"
	backtrace := backtrace sender.
	"remove Debugger enter frame"
	backtrace := backtrace sender
    ].
    ^ backtrace

    "Modified: / 29-09-2011 / 09:00:14 / cg"
!

moveDotDown
    "/ sigh - must search
    |c|

    c := enteringContext.
    [ c notNil and:[ c sender ~~ dot ] ] whileTrue:[
        c := c sender.
    ].
    c notNil ifTrue:[
        dot := c.
        "/ dot fullPrint.
    ] ifFalse:[
        '** dot is the bottom of the calling chain' _errorPrintCR.
    ].
!

moveDotUp
    |sender|
    
    (sender := dot sender) notNil ifTrue:[
        dot := sender.
        "/ dot fullPrint.
    ] ifFalse:[
        '** dot is the top of the calling chain' _errorPrintCR.
    ].
!

printBacktraceFrom:aContext
    |context n|

    aContext isNil ifTrue:[
        'no context' _errorPrintCR.
        ^ self
    ].

    context := aContext.
    n := commandCount.
    [context notNil] whileTrue: [
        self printContext:context.
        context := context sender.
        n notNil ifTrue:[
            n := n - 1.
            n <= 0 ifTrue:[
                ^ self
            ]
        ]
    ]
!

printContext:aContext
    "print the receiver, selector and args of the context"

    "/ aContext fullPrint.

    aContext receiverPrintString _errorPrint. ' ' _errorPrint. 
    aContext selector asString _errorPrint.
    aContext argumentCount ~~ 0 ifTrue: [
        ' ' _errorPrint. aContext argsDisplayString _errorPrint
    ].
    ' [' _errorPrint. 
    aContext lineNumber asString _errorPrint. 
    ']' _errorPrintCR
!

printDot
    |mthd argNames varNames|
    
    '' _errorPrintCR.
    
    self printContext:dot.
    '  receiver: ' _errorPrint. dot receiver printString _errorPrintCR.
    '  selector: ' _errorPrint. dot selector _errorPrintCR.

    dot isBlockContext ifFalse:[
        (mthd := dot method) notNil ifTrue:[
            Error ignoreIn:[    
                argNames := mthd methodArgNames.
            ].
            Error ignoreIn:[
                varNames := mthd methodVarNames
            ].    
        ].
    ].
    "/ '  args: ' _errorPrint. (argNames ? #() asStringWith:$;) _errorPrintCR.
    "/ '  vars: ' _errorPrint. (varNames ? #() asStringWith:$;) _errorPrintCR.
    
    '  args: ' _errorPrintCR.
    dot args keysAndValuesDo:[:idx :eachArg |
        '    ' _errorPrint. 
        argNames notNil ifTrue:[
            (argNames at:idx) _errorPrint.
        ] ifFalse:[    
            'arg' _errorPrint. idx _errorPrint. 
        ].
        ': ' _errorPrint. eachArg printString _errorPrintCR.
    ].
    
    '  vars: ' _errorPrintCR.
    dot vars keysAndValuesDo:[:idx :eachVar |
        '    ' _errorPrint. 
        varNames notNil ifTrue:[
            (varNames at:idx) _errorPrint.
        ] ifFalse:[    
            'var' _errorPrint. idx _errorPrint. 
        ].
        ': ' _errorPrint. eachVar printString _errorPrintCR.
    ].
    
    '' _errorPrintCR.
!

printDotsMethodSource
    self printDotsMethodSource:false
!

printDotsMethodSource:full
    |home mthd src pcLineNr startLnr stopLnr|

    home := dot methodHome.
    mthd := home method.
    mthd isNil ifTrue:[
        '** no source **' _errorPrintCR.
        ^ self.
    ].
    src := mthd source.
    src isNil ifTrue:[
        '** no source **' _errorPrintCR.
        ^ self.
    ].
    pcLineNr := dot lineNumber.

    src := src asCollectionOfLines.
    full ifTrue:[
        startLnr := 1.
        stopLnr := src size.
    ] ifFalse:[
        startLnr := pcLineNr-10 max:1.
        stopLnr := pcLineNr+10 min:src size.
    ].
    startLnr to:stopLnr do:[:lNr |
        lNr == pcLineNr ifTrue:[
            '>> ' _errorPrint.
        ] ifFalse:[
            '   ' _errorPrint.
        ].
        (lNr printStringLeftPaddedTo:3) _errorPrint. '| ' _errorPrint.
        (src at:lNr) asString _errorPrintCR.
    ]
!

stepping
    traceBlock := nil.
    tracing := false.
    stepping := true
!

tracingWith:aBlockOrNil
    traceBlock := aBlockOrNil.
    stepping := false.
    tracing := true
! !

!MiniDebugger methodsFor:'user commands'!

commandLoop
    "read-eval commands, until one of the continue, abort or single step commands is entered;
     return the last command character"

    |cmd done|

    done := false.
    [done] whileFalse:[
	cmd := self getCommand:nil.
	cmd isNil ifTrue:[   "/ EOF is treated like continue command
	    cmd := $c
	].
	done := self doCommand:cmd.
    ].
    ^ cmd

    "Modified (comment): / 29-09-2011 / 09:02:24 / cg"
!

doAbort
    |con sig|

    (sig := AbortOperationRequest) isHandled ifTrue:[
        sig raise.
        'abort raise failed' _errorPrintCR.
    ].

    "TEMPORARY kludge - find event handler context
     this will be removed, once real debugging is possible
    "
    con := self findContext:#processEvent.
    con isNil ifTrue:[
        con := self findContext:#dispatch.
    ].
    con notNil ifTrue:[
        "got it"
        con return.
        'return failed' _errorPrintCR.
    ].

    'found no context to resume' _errorPrintCR.

    "Modified: / 16.11.2001 / 17:39:14 / cg"
!

doCommand:cmd
    "a single command;
     return true, if command loop should be finished"

    |id proc bool|

    commandArg notEmptyOrNil ifTrue:[
        id := Number readFrom:commandArg onError:nil.
        id notNil ifTrue:[
            proc := Process allSubInstances detect:[:p | p id == id] ifNone:nil.
            proc == Processor activeProcess ifTrue:[
                id := proc := nil
            ]
        ] ifFalse:[
            commandArg = '-' ifTrue:[
                bool := false
            ] ifFalse:[
                commandArg = '+' ifTrue:[
                    bool := true
                ]
            ]
        ]
    ].

    (cmd == $w) ifTrue:[
        proc notNil ifTrue:[
            '-------- walkback of process ' _errorPrint. id _errorPrint. ' -------' _errorPrintCR.
            self printBacktraceFrom:(proc suspendedContext)
        ] ifFalse:[
            id notNil ifTrue:[
                'no process with id: ' _errorPrint. id _errorPrintCR.
            ] ifFalse:[
                '-------- walkback of current process -------' _errorPrintCR.
                self printBacktraceFrom:(self getContext)
            ]
        ].
        ^ false
    ].

    (cmd == $b) ifTrue:[
        proc notNil ifTrue:[
            '-------- VM walkback of process ' _errorPrint. id _errorPrint. ' -------' _errorPrintCR.
            (Processor activeProcess environmentAt:#Stderr ifAbsent:Stderr) == Stderr ifTrue:[
                ObjectMemory printStackBacktraceFrom:(proc suspendedContext)
            ] ifFalse:[
                self printBacktraceFrom:(proc suspendedContext)
                "/ proc suspendedContext fullPrintAllOn:(Processor activeProcess environmentAt:#Stderr)
            ].    
        ] ifFalse:[
            id notNil ifTrue:[
                'no process with id: ' _errorPrint. id _errorPrintCR.
            ] ifFalse:[
                '-------- VM walkback of current process -------' _errorPrintCR.
                (Processor activeProcess environmentAt:#Stderr ifAbsent:Stderr) == Stderr ifTrue:[
                    ObjectMemory printStackBacktrace
                ] ifFalse:[
                    "/ self printBacktraceFrom:(self getContext)
                    thisContext fullPrintAllOn:(Processor activeProcess environmentAt:#Stderr)
                ]
            ]
        ].
        ^ false
    ].

    (cmd == $S) ifTrue:[
        'saving "crash.img"...' _errorPrint.
        ObjectMemory writeCrashImage.
        'done.' _errorPrintCR.
        ^ false
    ].
    (cmd == $C) ifTrue:[
        |changesFilename|

        changesFilename := Timestamp now
             printStringFormat:'changes_%(year)-%(month)-%(day)__%h:%m:%s.chg'.
        OperatingSystem isMSWINDOWSlike ifTrue:[ changesFilename replaceAll:$: with:$_ ].

        ChangeSet current fileOutAs: changesFilename.
        ('saved session changes to "',changesFilename,'".') _errorPrintCR.
        ^ false
    ].

    (cmd == $B) ifTrue:[
        self printAllBacktraces.
        ^ false
    ].

    (cmd == $P) ifTrue:[
        self showProcesses:#all.
        ^ false
    ].
    (cmd == $p) ifTrue:[
        self showProcesses:#live.
        ^ false
    ].

    (cmd == $r) ifTrue:[
        dot receiver _errorPrintCR.
        ^ false
    ].

    (cmd == $i) ifTrue:[
        |inspectedObject|
        
        (commandArg ? '') withoutSeparators notEmpty ifTrue:[
            inspectedObject := (Parser evaluate:commandArg).
        ] ifFalse:[
            inspectedObject := (dot receiver).
        ].
        MiniInspector openOn:inspectedObject input:inputStream.
        ^ false
    ].

    (cmd == $I) ifTrue:[
        self interpreterLoopWith:nil.
        ^ false
    ].
    (cmd == $E) ifTrue:[
        Parser evaluate:commandArg.
        ^ false
    ].
    (cmd == $e) ifTrue:[
        (Parser evaluate:commandArg) _errorPrintCR.
        ^ false
    ].

    (cmd == $c) ifTrue:[^ true].
    (cmd == $s) ifTrue:[^ true].
    (cmd == $t) ifTrue:[^ true].
    (cmd == $a) ifTrue:[^ true].

    (cmd == $u) ifTrue:[
        stepping := false.
        tracing := false.
        Processor activeProcess vmTrace:false.
        ^ false
    ].

    (cmd == $h) ifTrue:[
        (bool notNil) ifTrue:[
            Smalltalk ignoreHalt:bool not.
        ].
        'halts are ' _errorPrint. (Smalltalk ignoreHalt ifTrue:['disabled'] ifFalse:['enabled']) _errorPrintCR.
        ^ false
    ].

    (cmd == $R) ifTrue:[
        proc notNil ifTrue:[
            proc resume.
        ].
        ^ false
    ].

    (cmd == $T) ifTrue:[
        proc notNil ifTrue:[
            proc terminate.
        ] ifFalse:[
            id notNil ifTrue:[
                'no process with id: ' _errorPrint. id _errorPrintCR.
            ] ifFalse:[
                Processor terminateActive
            ]
        ].
        ^ false
    ].

    (cmd == $W) ifTrue:[
        proc notNil ifTrue:[
            'stopping process id: ' _errorPrint. id _errorPrintCR.
            proc stop.
        ] ifFalse:[
            'invalid process id: ' _errorPrint. id _errorPrintCR.
        ].
        ^ false
    ].

    (cmd == $a) ifTrue:[
        "without id-arg, this is handled by caller"
        proc notNil ifTrue:[
            'aborting process id: ' _errorPrint. id _errorPrintCR.
            proc interruptWith:[AbortOperationRequest raise]
        ] ifFalse:[
            'aborting' _errorPrintCR.
        ].
        ^ false
    ].

    (cmd == $Q) ifTrue:[
        proc notNil ifTrue:[
            proc terminateNoSignal.
        ] ifFalse:[
            id notNil ifTrue:[
                'no process with id: ' _errorPrint. id _errorPrintCR.
            ] ifFalse:[
                Processor terminateActiveNoSignal
            ]
        ].
        ^ false
    ].

    (cmd == $g) ifTrue:[
        self garbageCollectCommand:id.
        ^ false
    ].

    (cmd == $U) ifTrue:[
        MessageTracer unwrapAllMethods.
        ^ false
    ].
    (cmd == $D) ifTrue:[
        Breakpoint disableAllBreakpoints.
        ^ false
    ].
    (cmd == $X) ifTrue:[
        Smalltalk fatalAbort.
        "/ not reached
        ^ false
    ].
    (cmd == $x) ifTrue:[
        OperatingSystem exit.
        "/ not reached
        ^ false
    ].
    (cmd == $Y) ifTrue:[
        Display := nil.
        Smalltalk openDisplay.
        NewLauncher open.
        ^ true
    ].

    (cmd == $.) ifTrue:[self printDot. ^ false ].
    (cmd == $l) ifTrue:[self printDotsMethodSource:false. ^ false ].
    (cmd == $L) ifTrue:[self printDotsMethodSource:true. ^ false ].
    (cmd == $-) ifTrue:[self moveDotUp. self printDot. ^ false ].
    (cmd == $+) ifTrue:[self moveDotDown. self printDot. ^ false ].
    (cmd == $?) ifTrue:[
        commandArg notEmpty ifTrue:[
            self helpOn:commandArg. ^ false
        ]
    ].

    "/ avoid usage print if return was typed ...
    ((cmd == Character return)
    or:[cmd == Character linefeed]) ifTrue:[^ false].

    self showValidCommandHelp.
    ^ false.

    "Created: / 29-09-2011 / 08:58:47 / cg"
!

getCommand:prompt
"/    Screen notNil ifTrue:[
"/        Screen allScreens do:[:aScreen |
"/            aScreen ungrabPointer.
"/            aScreen ungrabKeyboard.
"/        ].
"/    ].

    Display notNil ifTrue:[
        Display ungrabPointer.
        Display ungrabKeyboard.
    ].

    (prompt
        ? (nesting == 0 ifTrue:[
            'MiniDebugger> '
          ] ifFalse:[
            'MiniDebugger' , nesting printString , '>'
          ])) _errorPrint.

    UserInterrupt handle:[:ex |
        ex restart
    ] do:[
        |c cmd arg cnt|

        cmd := self getCharacter.
        cmd isNil ifTrue:[
            '<EOF>' _errorPrintCR.
            "
             mhmh end-of-file;
             return a 'c' (for continue); hope that's ok.
            "
            cmd := $c
        ].

        cnt := nil.
        (cmd isDigit) ifTrue:[
            cnt := 0.
            [
                cnt := (cnt * 10) + cmd digitValue.
                cmd := self getCharacter
            ] doWhile:[cmd notNil and:[cmd isDigit]].
            [cmd notNil and:[cmd == Character space]] whileTrue:[
                cmd := self getCharacter
            ].
            cmd isNil ifTrue:[ '<EOF>' _errorPrintCR ].
        ].

        "
         collect to end-of-line in arg
        "
        c := cmd.
        arg := ''.
        [c isNil or:[c isEndOfLineCharacter]] whileFalse: [
            arg := arg copyWith:c.
            c := self getCharacter.
            c isNil ifTrue:[ '<EOF>' _errorPrintCR ].
        ].
        commandArg := (arg copyFrom:2) withoutSeparators.
        command := cmd.
        commandCount := cnt.
    ].
    ^ command

    "Modified: / 31.7.1998 / 16:11:01 / cg"
!

helpOn:commandArg
    |args className sym val match showMethod|

    commandArg withoutSeparators isEmpty ifTrue:[
        'usage: H className [methodPattern]' _errorPrintCR.
        ^self
    ].
    args := commandArg asCollectionOfWords.
    className := args first.

    (sym := className asSymbolIfInterned) isNil ifTrue:[
        'no such class' _errorPrintCR.
        ^ self.
    ].
    val := Smalltalk at:sym ifAbsent:['no such class' _errorPrintCR. ^ self.].
    val isBehavior ifFalse:[
        'not a class: ' _errorPrint. className _errorPrintCR.
        val := val class.
        'showing help for ' _errorPrint. val name _errorPrintCR.
    ].
    args size > 1 ifTrue:[
        match := args at:2
    ] ifFalse:[
        match := '*'
    ].

    showMethod :=
        [:sel :cls |
            |mthd|

            ((match includesMatchCharacters and:[ sel matches:match caseSensitive:false])
            or:[ sel asLowercase startsWith:match asLowercase ]) ifTrue:[
                mthd := cls compiledMethodAt:sel.
                mthd category ~= 'documentation' ifTrue:[
                    sel _errorPrintCR.
                    (mthd comment ? '') asStringCollection do:[:l |
                        '    ' _errorPrint. l withoutSeparators _errorPrintCR.
                    ].
                    '' _errorPrintCR
                ].
            ].
        ].

    val theMetaclass selectors copy sort do:[:sel |
        showMethod value:sel value:val theMetaclass
    ].
    val theNonMetaclass selectors copy sort do:[:sel |
        showMethod value:sel value:val theNonMetaclass
    ].
!

interpreterLoopWith:anObject
    'MinDebugger read-eval-print loop; exit with "#exit"; help with "?"' printCR.
    ReadEvalPrintLoop new
        prompt:'mDBG > ';
        doChunkFormat:false;
        error:(Processor activeProcess stderr);
        readEvalPrintLoop.

"/    |line done rslt|
"/
"/    'read-eval-print loop; exit with empty line' printCR.
"/    '' printCR.
"/
"/    done := false.
"/    [done] whileFalse:[
"/        '> ' print.
"/
"/        line := Stdin nextLine.
"/        (line size == 0) ifTrue:[
"/            done := true
"/        ] ifFalse:[
"/            "/ rslt := Compiler evaluate:line
"/            "/                  receiver:anObject
"/            "/                  notifying:nil.
"/
"/            rslt := Compiler
"/                evaluate:line
"/                in:dot
"/                receiver:dot receiver
"/                notifying:self "/ nil
"/                ifFail:[].
"/            rslt printCR.
"/        ]
"/    ]

    "Modified: / 31.7.1998 / 16:01:47 / cg"
!

printAllBacktraces
    Process allInstancesDo:[:p |
        (p isActive not
        and:[p isDead not]) ifTrue:[
            '---------------------------------------------------------' _errorPrintCR.
            '  proc id=' _errorPrint. p id asString _errorPrint.
            ' name=''' _errorPrint. p name asString _errorPrint.
            ''' createdBy: ' _errorPrint. p creatorId asString _errorPrint.
            ' state=' _errorPrint.  p state asString _errorPrint.
            ' prio=' _errorPrint. p priority asString _errorPrintCR.
            '' _errorPrintCR. '' _errorPrintCR.

            self printBacktraceFrom:(p suspendedContext)
        ]
    ]
!

showProcesses
    self showProcesses:#all
!

showProcesses:how
    |active|

    active := Processor activeProcess.
    'current id=' _errorPrint. 
    active id printString _errorPrint. 
    ' name=''' _errorPrint. active name _errorPrint. '''' _errorPrintCR.

    (Process allSubInstances sort:[:a :b | (a id ? -1)<(b id ? -1)]) do:[:p |
        |doShow|

        doShow := (how == #all) or:[ (how == #dead) == ( p isDead ) ]. 
        doShow ifTrue:[
            'id=' _errorPrint. (p id printStringPaddedTo:6) _errorPrint.
            (p state printStringPaddedTo:10) _errorPrint.
            ' pri=' _errorPrint. (p priority printStringPaddedTo:2) _errorPrint.
            ' creator:' _errorPrint. (p creatorId printStringPaddedTo:5) _errorPrint.
            ' group:' _errorPrint. (p processGroupId printStringPaddedTo:5) _errorPrint.
            "/ ' sys:' _errorPrint. (p isSystemProcess ifTrue:'y' ifFalse:'n') _errorPrint.
            "/ ' ui:' _errorPrint. (p isGUIProcess ifTrue:'y' ifFalse:'n') _errorPrint.
            (p isGUIProcess 
                ifTrue:[' ui']
                ifFalse:[p isSystemProcess 
                    ifTrue:['sys'] 
                    ifFalse:['usr']]) _errorPrint.
            ' name=''' _errorPrint. p name _errorPrint.
            '''' _errorPrintCR.
        ]
    ]

    "Modified: / 31.7.1998 / 16:30:19 / cg"
!

showValidCommandHelp
        'valid commands:
   c ........ continue
   s ........ step
   t ........ trace (continue with trace)
   a [id] ... abort (i.e. raise abort signal) in (current) process
   T [id] ... terminate (current) process
   W [id] ... stop (current) process
   R [id] ... resume (current) process
   Q [id] ... quick terminate (current) process - no unwinds or cleanup

   p ........ list processes ("P" for full list)
   w [id] ... walkback (of current/process with id)
   b [id] ... full (VM) backtrace with more detail
   B ........ backtrace for all processes

   U ........ unwrap all traced/breakpointed methods
   D ........ disable all line breakpoints
   h [-/+] .. disable/enable halts
   g ........ collect all garbage
   g 2 ...... collect all garbage & reclaim symbols
   g 3 ...... collect all garbage, reclaim symbols and compress

   S ........ save snapshot into "crash.img"
   C ........ save session changes to a separate change file
   x ........ exit Smalltalk ("X" to exit with core dump)
   Y ........ reopen display, reopen launcher

   . ........ print dot (the current context)
   - ........ move dot up (sender)
   + ........ move dot down (called context)
   l ........ list dot''s method source around PC ("L" for full list)

   r ........ receiver (in dot) printString
   i [expr] . inspect expression (or receiver in dot)
   I ........ interpreter (expression evaluator)
   e expr ... evaluate expression & print result ("E" to not print)
   ? c [p] .. help on class c (selectors matching p)
'  _errorPrintCR.

   (XWorkstation notNil and:[ Screen default isKindOf:XWorkstation ]) ifTrue:[
'   To repair a broken X-Connection, enter an interpreter (enter "I") and evaluate:
      Display := XWorkstation new.
      Display initializeFor:''localhost:0''.
      Display startDispatch.
      NewLauncher openOnDevice:Display.
      #exit
    then enter "c" to continue; a NewLauncher should pop up soon.
'  _errorPrintCR
    ]

    "Modified: / 03-02-2014 / 10:38:36 / cg"
! !

!MiniDebugger class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


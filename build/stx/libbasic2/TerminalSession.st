"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TerminalSession
	instanceVariableNames:'inStream outStream errStream readerProcess shellPid shellCommand
		shellDirectory readerDelay pluggableCheckBeforeReadAction
		pluggableProcessInputAction execFDArray stxToStdinPipe
		stdOutToStxPipe pty ptyName terminatedAction collectedOutput
		promptActions'
	classVariableNames:'Debug'
	poolDictionaries:''
	category:'Views-TerminalViews'
!

!TerminalSession class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    This keeps the state and API to interact with another program
    via a terminal session. Under Unix, a pseudo-tty connection
    is used; other operating systems might use other mechanisms.

    This is (currently) used by the GDBApplication, to interact
    with gdb, cscope and the program.
    It can be used wherever more control is needed than a simple pipe
    offers (such as terminal emulation, window size, CTRL-c support etc.)

    A major feature is a mechanism to catch certain prompt strings of the output
    and get a notification.
    This is very useful, if a program's output is to be shown both in a terminalview,
    and also to be analyzed for robot actions.
    Applications for this are telnet like interaction, interactions with a debugger
    or monitor (gdb, android-adb) etc.,

    A lot of code has been extracted from TerminalView, 
    which will be refactored, once this is stable. 
    For now, there is some code duplication (as of Summer 2014).

    outStream   - the controlled program's output (a pty-half)
    inStream    - the controlled program's input (a pty-half)
    errStream   - the controlled program's output (a pty-half)
"
! !

!TerminalSession class methodsFor:'initialization'!

initialize

    Debug := false.

    "
     self initialize
    "
! !

!TerminalSession methodsFor:'accessing'!

errStream
    ^ errStream
!

inStream
    ^ inStream
!

outStream
    ^ outStream
!

pluggableCheckBeforeReadAction:something
    pluggableCheckBeforeReadAction := something.
!

pluggableProcessInputAction:something
    pluggableProcessInputAction := something.
!

pty
    ^ pty
!

ptyName
    ^ ptyName
!

shellCommand
    ^ shellCommand
!

shellDirectory
    ^ shellDirectory
!

shellPid
    ^ shellPid
!

terminatedAction:something
    terminatedAction := something.
! !

!TerminalSession methodsFor:'initialization & release'!

closeDownShell
    "shut down my shell process and stop the background reader thread."

    |pid|

    (pid := shellPid) notNil ifTrue:[
        Debug ifTrue:[
            Transcript show:'killing shell pid='; showCR:pid.
        ].
        OperatingSystem isMSWINDOWSlike ifFalse:[
            OperatingSystem terminateProcessGroup:pid.
        ].    
        OperatingSystem terminateProcess:pid.
        Delay waitForSeconds:0.2.
        shellPid notNil ifTrue:[
            "/ Delay waitForSeconds:1.
            OperatingSystem isMSWINDOWSlike ifFalse:[
                OperatingSystem killProcessGroup:pid.
            ].
            OperatingSystem killProcess:pid.
            shellPid := nil.
        ].
        OperatingSystem closePid:pid.
    ].

    "Modified: / 5.5.1999 / 18:43:02 / cg"
!

closeStreams
    self stopReaderProcess.

    inStream notNil ifTrue:[
        inStream isStream ifTrue:[inStream close].
        inStream := nil
    ].
    outStream notNil ifTrue:[
        outStream close.
        outStream := nil
    ].
    errStream notNil ifTrue:[
        errStream close.
        errStream := nil
    ].
!

createTerminalConnectionAndSetupWith:setupBlock
    "create a terminal conenction (pseudo terminal or pipe)"

    |slaveFD master slave ptyTriple|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        "use two pipes to COMMAND.COM"
        stxToStdinPipe := NonPositionableExternalStream makePipe.
        stxToStdinPipe isNil ifTrue:[
            self error:(self class classResources string:'Could not create pipe to COMMAND.COM.') mayProceed:true. 
            ^ self.
        ].

        stdOutToStxPipe := NonPositionableExternalStream makePipe.
        stdOutToStxPipe isNil ifTrue:[
            self error:(self class classResources classResources string:'Could not create pipe from COMMAND.COM.') mayProceed:true. 
            ^ self.
        ].

        "/ pipe readSide is p at:1;
        "/      writeSide is p at:2

        slaveFD := (stdOutToStxPipe at:2) fileDescriptor.
        execFDArray := Array 
                         with:(stxToStdinPipe at:1) fileDescriptor        "stdin"
                         with:slaveFD                                       "stdout"
                         with:slaveFD.                                      "stderr"

        outStream := stdOutToStxPipe at:1.
        inStream  := stxToStdinPipe at:2.
    ] ifFalse:[
        "Use a pseudo-tty"
        ptyTriple := OperatingSystem makePTY.
        ptyTriple isNil ifTrue:[
            self warn:'Cannot open pty.'.
            ^ self.
        ].

        ptyName := ptyTriple at:3.

        "/ pty at:1 is the master;
        "/ pty at:2 is the slave
        master := NonPositionableExternalStream forReadWriteToFileDescriptor:(ptyTriple at:1).
        master buffered:false.

        slave := NonPositionableExternalStream forReadWriteToFileDescriptor:(ptyTriple at:2).
        slave buffered:false.

        pty := { master . slave }.

        inStream := outStream := master.
        setupBlock value.
        "/ fork a shell process on the slave-side
        slaveFD := (ptyTriple at:2).
        execFDArray := Array with:slaveFD with:slaveFD with:slaveFD.
    ].
!

killShell
    "shut down my shell process and stop the background reader thread."

    |pid|

    (pid := shellPid) notNil ifTrue:[
        Debug ifTrue:[
            Transcript show:'killing shell pid='; showCR:pid.
        ].
        OperatingSystem terminateProcessGroup:pid.
        OperatingSystem terminateProcess:pid.
        Delay waitForSeconds:1.
        shellPid notNil ifTrue:[
            OperatingSystem isMSWINDOWSlike ifFalse:[
                OperatingSystem killProcessGroup:pid.
            ].
            OperatingSystem killProcess:pid.
            shellPid := nil.
        ].
        OperatingSystem closePid:pid.
    ].
!

reinitialize
    shellPid := nil.
    inStream := outStream := errStream := nil.
!

startCommand:aCommand in:aDirectory environment:envIn setupTerminalWith:setupBlock terminatedAction:terminatedActionArg
    "start a command on a pseudo terminal. If the command arg is nil,
     a shell is started. If aDirectory is not nil, the command is
     executed in that directory.
     Also fork a reader process, to read the shell's output and
     tell me, whenever something arrives"

    |blocked exitStatus 
     cmd shell args env shellAndArgs didOpenTerminal|

    shellCommand := aCommand.
    shellDirectory := aDirectory.
    terminatedAction := terminatedActionArg.
    didOpenTerminal := false.

    (inStream isNil or:[outStream isNil]) ifTrue:[
        self createTerminalConnectionAndSetupWith:setupBlock.
        didOpenTerminal := true.
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        shellAndArgs := OperatingSystem commandAndArgsForOSCommand:aCommand.
        shell := shellAndArgs at:1.
        args  := (shellAndArgs at:2) ? ''.
    ] ifFalse:[
        aCommand isNil ifTrue:[
            shell := OperatingSystem getEnvironment:'SHELL'.
            shell size == 0 ifTrue:[
                shell := '/bin/sh'.
            ].
            cmd := shell asFilename baseName.
            args := (Array with:cmd).
        ] ifFalse:[
            shell := '/bin/sh'.
            args := (Array with:'sh' with:'-c' with:aCommand).
        ].
        env := Dictionary new.
        env declareAllFrom:envIn.
        env at:'SHELL' put:shell.
    ].

    blocked := OperatingSystem blockInterrupts.

    shellPid := Processor
               monitor:[
                  OperatingSystem
                      exec:shell
                      withArguments:args
                      environment:env
                      fileDescriptors:execFDArray
                      fork:true
                      newPgrp:true
                      inDirectory:aDirectory
                      showWindow:false.
               ]
               action:[:status |
                    Debug ifTrue:[
                        Transcript show:'pid:'; showCR:status pid.
                        Transcript show:'status:'; showCR:status status.
                        Transcript show:'code:'; showCR:status code.
                        Transcript show:'core:'; showCR:status core.
                    ].
                    status stillAlive ifFalse:[
                        exitStatus := status.
                        OperatingSystem closePid:shellPid.
                        shellPid := nil.
                        terminatedAction valueWithOptionalArgument:status
                    ].
               ].

    blocked ifFalse:[
        OperatingSystem unblockInterrupts
    ].

    "close the slave side of the pty/pipes (only used by the child)"
    pty notNil ifTrue:[
        (pty at:2) close.
    ].

    didOpenTerminal ifTrue:[
        stdOutToStxPipe notNil ifTrue:[
            (stdOutToStxPipe at:2) close.
            (stxToStdinPipe at:1) close.
        ].

        shellPid isNil ifTrue:[
        "/ self warn:'Cannot start shell'.
            outStream notNil ifTrue:[outStream close].
            inStream notNil ifTrue:[inStream close].
            inStream := outStream := nil.
        ].
    ].
    ^ shellPid

    "Created: / 20-07-1998 / 18:19:32 / cg"
    "Modified: / 01-08-2013 / 20:38:37 / cg"
! !

!TerminalSession methodsFor:'input / output'!

paste:someText
    "paste - redefined to send the chars to the shell instead
     of pasting into the view"

    |s nLines|

    s := someText.
    s isString ifTrue:[
        s := s asStringCollection
    ] ifFalse:[
        (s isKindOf:StringCollection) ifFalse:[
            self warn:'selection (' , s class name , ') is not convertable to Text'.
            ^ self
        ]
    ].
    (nLines := s size) == 0 ifTrue:[^ self].
    (nLines == 1 and:[(s at:1) size == 0]) ifTrue:[^ self].
    s keysAndValuesDo:[:idx :line |
        line notNil ifTrue:[inStream nextPutAll:line].
        idx ~~ nLines ifTrue:[
            self sendLineEnd.
        ]
    ].

    "Modified: / 12.6.1998 / 22:12:47 / cg"
!

sendCharacter:aCharacter
    inStream nextPut:aCharacter.
!

sendLine:aString
    inStream nextPutAll:aString.
    self sendLineEnd
!

sendLineEnd
    OperatingSystem isMSDOSlike ifTrue:[
        inStream nextPut:Character return.
        inStream nextPut:Character linefeed.
    ] ifFalse:[
        inStream nextPut:Character return.
    ].
! !

!TerminalSession methodsFor:'misc'!

collectedOutput
    "return any collected output, so far"

    collectedOutput isNil ifTrue:[^ nil].
    ^ collectedOutput contents
!

defineWindowSizeLines:numberOfLines columns:numberOfColumns
    | delta prevNumCols prevNumLines|

    "/ any idea, how to do this under windows ?

    OperatingSystem isUNIXlike ifTrue:[
        "/
        "/ tell the pty;
        "/ tell the shell;
        "/
        (inStream notNil 
        and:[inStream isExternalStream
        and:[inStream isOpen]]) ifTrue:[
            Debug ifTrue:[
                Transcript showCR:'TerminalSession [info]: changed len to ', numberOfLines printString.
            ].
            (OperatingSystem 
                setWindowSizeOnFileDescriptor:inStream fileDescriptor
                width:numberOfColumns
                height:numberOfLines) ifFalse:[
                Debug ifTrue:[
                    Transcript showCR:'TerminalSession [warning]: cannot change windowSize'.
                ].
            ].

        ].
        shellPid notNil ifTrue:[
            OperatingSystem sendSignal:OperatingSystem sigWINCH to:shellPid
        ]
    ].

    "Created: / 11.6.1998 / 22:51:39 / cg"
    "Modified: / 5.5.1999 / 19:45:09 / cg"
!

forgetPrompt:aString
    "/ Transcript show:'forget prompt: '; showCR:aString.
    promptActions removeKey:aString ifAbsent:[].
    "/ Transcript show:'prompts now: '; showCR:promptActions.
!

onPrompt:aString do:aBlock
    "remember what to do, when a prompt arrives;
     notice: will only start checking for prompt, when startCollectingOutput
     has been called."

    "/ Transcript show:'add prompt: '; showCR:aString.
    promptActions isNil ifTrue:[promptActions := Dictionary new].
    promptActions at:aString put:aBlock
!

onPrompt:string1 do:block1 onPrompt:string2 do:block2
    "remember what to do, when a prompt arrives;
     notice: will only start checking for prompt, when startCollectingOutput
     has been called."

    "/ Transcript show:'add prompt: '; showCR:string1.
    "/ Transcript show:'add prompt: '; showCR:string2.
    promptActions isNil ifTrue:[promptActions := Dictionary new].
    promptActions 
        at:string1 put:block1;
        at:string2 put:block2.
!

outputFromAction:aBlock prompt:prompt timeout:seconds
    "evaluate aBlock and wait for the prompt.
     return gdb output as string collection"

    ^ self
        outputFromAction:aBlock 
        prompt:prompt 
        timeout:seconds
        to:nil
!

outputFromAction:aBlock prompt:prompt timeout:seconds to:aStreamOrNil
    "evaluate aBlock and wait for the prompt.
     return gdb output as string collection"

    |sema output lastSize gotPrompt|

    sema := Semaphore new.
    aStreamOrNil isNil ifTrue:[
        self startCollectingOutput.
    ] ifFalse:[
        self startCollectingOutputTo:aStreamOrNil
    ].
    self onPrompt:prompt do:[:strings | output := strings. sema signal. ].

    aBlock value.

    lastSize := 0.
    [
        |newSize|

        (gotPrompt := (sema waitWithTimeout:seconds) notNil) ifFalse:[
            newSize := collectedOutput size.
            Transcript show:'timeout - output size is: '; showCR:newSize.
            newSize > 100000 ifTrue:[
                self stopCollectingOutput.
                self onPrompt:nil do:nil.
                collectedOutput := nil.
                TimeoutError raiseRequestErrorString:'GDB output too big'.
            ].
            newSize = lastSize ifTrue:[
                "/ self information:'Error: command timeout.'.
                self stopCollectingOutput.
                self onPrompt:nil do:nil.
                TimeoutError raiseRequestErrorString:'GDB command timeout'.
            ].
            lastSize := newSize.
        ].  
    ] doWhile:[ gotPrompt not ].

    output notEmptyOrNil ifTrue:[
        output first isEmpty ifTrue:[
            "/ self halt.
            output := output copyFrom:2
        ].
    ].
    ^ output
!

outputFromCommand:aCommand prompt:prompt timeout:seconds
    "return a command's output as string collection"

    ^ self
        outputFromCommand:aCommand 
        prompt:prompt 
        timeout:seconds 
        to:nil
!

outputFromCommand:aCommand prompt:prompt timeout:seconds to:aStreamOrNil
    "return a command's output as string collection"

    |output firstLine|

    output := self 
                outputFromAction:[ self sendLine:aCommand ]
                prompt:prompt 
                timeout:seconds
                to:aStreamOrNil.
    output isEmptyOrNil ifTrue:[^ output].

    "/ the first line of output is the echo
    firstLine := output first withoutLeadingSeparators.
    firstLine ~= aCommand ifTrue:[
        (aCommand startsWith:firstLine) ifTrue:[
            "/ sigh - it is sometimes truncated (to be investigated)
            self breakPoint:#cg.
            ^ output.
        ].
        "/ self halt.
        ^ output.
    ].
    ^ output copyFrom:2
!

sendInterruptSignal
    "send an INT-signal to the shell (UNIX only)"

    shellPid notNil ifTrue:[
        OperatingSystem interruptProcessGroup:shellPid.
        OperatingSystem interruptProcess:shellPid.
    ].

    "Modified: / 10.6.1998 / 17:49:49 / cg"
!

sendKillSignal
    "send a KILL-signal to the shell (UNIX only)"

    shellPid notNil ifTrue:[
        OperatingSystem killProcessGroup:shellPid.
        OperatingSystem killProcess:shellPid.
        OperatingSystem childProcessWait:false pid:shellPid.
    ]
!

startCollectingOutput
    "start collecting output in a collecting stream"

    self startCollectingOutputTo:(WriteStream on:(String new:1000)).
!

startCollectingOutputTo:aStream
    "start collecting output into a collecting (or other) stream"

    collectedOutput := aStream.
!

stopCollectingOutput
    "start collecting output in a collecting stream"

    collectedOutput := nil.
! !

!TerminalSession methodsFor:'reader process'!

collectOutputAndCheckForPrompt:buffer count:n
    |string collectedString collectedLines i i2 lastLine|

    collectedOutput isNil ifTrue:[^ self].

    string := buffer copyTo:n.
    collectedOutput nextPutAll:string.

    "/ Transcript showCR:'prompts: '; showCR:promptActions.
    promptActions notNil ifTrue:[
        collectedString := collectedOutput contents.
        i := collectedString lastIndexOf:Character lf.
        i ~~ 0 ifTrue:[
            lastLine := (collectedString copyFrom:i+1) withoutTrailingSeparators.
            lastLine isEmpty ifTrue:[
                i2 := collectedString lastIndexOf:Character lf startingAt:(i-1).
                i2 ~~ 0 ifTrue:[
                    lastLine := (collectedString copyFrom:i2+1 to:i-1) withoutTrailingSeparators.
                ].
            ].
            "/ Transcript show:' got: <'; show:lastLine; showCR:'>'. "/ ; showCR:lastLine asByteArray.
            promptActions keysAndValuesDo:[:expectedPrompt :promptAction |
                "/ Transcript show:'  looking for: '; showCR:expectedPrompt.
                ((lastLine endsWith:expectedPrompt) 
                or:[ (lastLine startsWith:expectedPrompt) ]) ifTrue:[
                    "/ ('found prompt; call ',promptAction printString) printCR.

                    "/ perform the promptaction
                    collectedLines := collectedString asStringCollection 
                                        collect:[:each | 
                                            (each endsWith:String crlf) 
                                                    ifTrue:[ each copyButLast:2 ]
                                                    ifFalse:[
                                                        (each endsWith:Character return) 
                                                            ifTrue:[ each copyButLast ]
                                                            ifFalse:[ each ]]].
                    collectedLines removeLast.  "/ the prompt itself
                    promptAction value: collectedLines.
                ].
            ].
        ].
    ].
!

readAnyAvailableData
    "read data from the stream,
     and sends me #processInput:n: events if something arrived.
     Returns the amount of data read."

    |buffer bufferSize n|

    outStream isNil ifTrue:[^ 0].   "/ already closed

    bufferSize := 1024.
    buffer := String new:bufferSize.

    StreamError handle:[:ex |
        n := 0
    ] do:[
        |line|

        collectedOutput class == ActorStream ifTrue:[
            (outStream readWaitWithTimeout:0.5) ifTrue:[
                n := 0
            ] ifFalse:[
                line := outStream nextLine,Character cr.
                n := line size.
                pluggableProcessInputAction notNil ifTrue:[
                    pluggableProcessInputAction value:line value:n.
                ].
                collectedOutput notNil ifTrue:[
                    self collectOutputAndCheckForPrompt:line count:n.
                ]
            ]
        ] ifFalse:[
            n := outStream nextAvailableBytes:bufferSize into:buffer startingAt:1.
            n > 0 ifTrue:[
                pluggableProcessInputAction notNil ifTrue:[
                    pluggableProcessInputAction value:buffer value:n.
                ].
                collectedOutput notNil ifTrue:[
                    self collectOutputAndCheckForPrompt:buffer count:n
                ].
            ].
        ].
    ].
    ^ n
!

readerProcessLoop
    "look for the session's output"

    StreamError handle:[:ex |
        Transcript show:'Terminal(PTY-reader) [error]: '; showCR:ex description.
    ] do:[
        [true] whileTrue:[
            AbortOperationRequest handle:[:ex |
                ^ self
            ] do:[
                |n sensor|

                readerDelay notNil ifTrue:[ Delay waitForSeconds:readerDelay].
                outStream isNil ifTrue:[^ self].
                outStream readWait.

                (pluggableCheckBeforeReadAction isNil
                or:[pluggableCheckBeforeReadAction value]) ifTrue:[
                    n := self readAnyAvailableData.
                    n == 0 ifTrue:[
                        "/ Windows IPC has a bug - it always
                        "/ returns 0 (when the command is idle)
                        "/ and says it's at the end (sigh)

                        OperatingSystem isMSWINDOWSlike ifTrue:[
                            Delay waitForSeconds:0.1
                        ] ifFalse:[
                            outStream atEnd ifTrue:[
                                outStream close. outStream := nil.
                                inStream close.  inStream := nil.
                                Processor activeProcess terminate.
                            ] ifFalse:[
                                "/ this should not happen.

                                Delay waitForSeconds:0.1
                            ]
                        ].
                    ]
                ]
            ]
        ]
    ]
!

startReaderProcess
    "Start a reader process, which looks for the commands output,
     and sends me #processInput:n: events whenever something arrives."

    readerProcess isNil ifTrue:[
        readerProcess := [
            [
                self readerProcessLoop.
            ] ifCurtailed:[
                readerProcess := nil    
            ]
        ] fork. "/ forkAt:9.
        readerProcess name:'pty reader'.
    ]

    "
     VT100TerminalView openShell
    "

    "Modified: / 5.5.1999 / 17:58:02 / cg"
    "Modified: / 28.1.2002 / 21:10:13 / micha"
!

stopReaderProcess
    "stop the background reader thread"

    |p|

    (p := readerProcess) notNil ifTrue:[
        readerProcess := nil.
        p terminate.
        "/ give it a chance to really terminate
        Processor yield.
    ].
! !

!TerminalSession class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


TerminalSession initialize!

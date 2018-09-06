"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#OSProcess
	instanceVariableNames:'pid command environment directory inStream outStream errorStream
		auxStream showWindow lineWise newPgrp exitStatus finishSema
		shufflerProcesses streamsToClose terminateActionBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!OSProcess class methodsFor:'documentation'!

documentation
"
    Instances of OSProcess represent operating system processes thatr can be executed.
    (as opposed to Smalltalk processes).

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        pid         SmallInteger    the process id
        command     String          the command line of the running command.

    [class variables:]

    [see also:]
        Process

"
!

examples
    "
        |outStream|

        outStream := '' writeStream.

        self new 
            command:'ls -l';
            inStream:'abc' readStream;
            outStream:outStream;
            lineWise:true;
            execute.

        outStream contents
    "

    "
        |outStream|

        outStream := '' writeStream.

        self new 
            command:'ls -l; sleep 10; echo =================================; echo hallo after 10s; echo >&2 +++++++++++++++++++++; cat >&2';
            inStream:'abc' readStream;
            outStream:outStream;
            errorStream:outStream;
            startProcess.

        outStream inspect
    "

    "
        |outStream|

        outStream := '' writeStream.

        self new 
            command:'ls -l & ls -l >&2';
            inStream:'abc' readStream;
            outStream:outStream;
            errorStream:outStream;
            startProcess.

        outStream inspect
    "
! !

!OSProcess class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!OSProcess class methodsFor:'initialize'!

initialize
    "Backward compatibility"
    Win32Process := self.
! !

!OSProcess methodsFor:'accessing'!

auxStream
    ^ auxStream
!

auxStream:something
    "set an auxilliary input stream that will be available to the command as
     file descriptor 3"

    auxStream := something.
!

command
    "return the value of the instance variable 'command' (automatically generated)"

    ^ command

    "Created: / 10.11.1998 / 21:27:07 / cg"
!

command:aStringOrArray
    "set the command to be executed.
     If aStringOrArray is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.exe' in your Windows manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case."

    command := aStringOrArray.
!

directory
    "return the value of the instance variable 'directory' (automatically generated)"

    ^ directory

    "Created: / 10.11.1998 / 21:21:52 / cg"
!

directory:aString
    "set the directory that will be set as the current directory of the command to be executed"

    directory := aString.
!

environment
    "return the value of the instance variable 'environment' (automatically generated)"

    ^ environment

    "Created: / 10.11.1998 / 21:26:34 / cg"
!

environment:aDictionary
    "set the environment variables of the command to be executed"

    environment := aDictionary.
!

errorStream
    "return the value of the instance variable 'errorStream' (automatically generated)"

    ^ errorStream

    "Created: / 10.11.1998 / 21:26:34 / cg"
!

errorStream:aStream
    "set the stream where the stderr output of the command is directed to"

    errorStream := aStream.
!

exitStatus
    "answer the exit status of the command or nil, if the command has not yet been finished"

    ^ exitStatus
!

exitStatus:something
    "set the value of the instance variable 'exitStatus' (automatically generated)"

    exitStatus := something.

    "Created: / 10.11.1998 / 21:24:55 / cg"
!

finishSema
    "wait on this semaphore if yo want to wait until the os process has finished.
     There may be multiple waiters, so it is a good idea to do a #waitUncounted"

    ^ finishSema
!

inStream
    "return the value of the instance variable 'inStream' (automatically generated)"

    ^ inStream

    "Created: / 10.11.1998 / 21:26:34 / cg"
!

inStream:aStream
    "set the stream where the stdin input of the command is read from"

    inStream := aStream.
!

lineWise
    ^ lineWise
!

lineWise:aBoolean
    "When setting to true, read linewise from the command's output and error.
     This is a bit slower than lineWise = false.

     You may use it also when streaming to e.g. Transcript"

    lineWise := aBoolean.
!

newPgrp
    ^ newPgrp
!

newPgrp:aBoolean
    "if aBoolean is true, a new process group will be created for the command and its subprocesses"

    newPgrp := aBoolean.
!

outStream
    "return the value of the instance variable 'outStream' (automatically generated)"

    ^ outStream

    "Created: / 10.11.1998 / 21:26:34 / cg"
!

outStream:aStream
    "set the stream where the stdout output of the command is directed to"

    outStream := aStream.
!

pid
    "answer the pid of the process the command is running in or nil, if the command has not yet been started."

    ^ pid
!

pid:something
    pid := something.
!

showWindow
    ^ showWindow
!

showWindow:aBooleanOrNil
    "This parameter is ignored on Unix systems.

     You can control (have to - sigh) if a window should be shown for the command or not.
     This is the OS's H_SHOWWINDOW argument.
     If you pass nil as showWindow-argument, the OS's default is used for the particular
     command, which is correct most of the time: i.e. a notepad will open its window, other (non-UI)
     executables will not.
     However, some command-line executables show a window, even if they should not.
     (and also, there seems to be an inconsistency between windows7 and newer windows: in newer,
     a shell command opens a cmd-window, whereas in windows7 it did not)
     In this case, pass an explicit false argument to suppress it."

    showWindow := aBooleanOrNil.
!

terminateActionBlock
    ^ terminateActionBlock
!

terminateActionBlock:aBlock
    "set the block that will be executed when the command has been finished or terminated."

    terminateActionBlock := aBlock.
! !

!OSProcess methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    showWindow := false.    "/ for backward compatibility
    lineWise := false.
    newPgrp := true.
! !

!OSProcess methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:self className;
        nextPut:$(.
    pid printOn:aStream.
    aStream space.
    command printOn:aStream.
    aStream nextPut:$)
! !

!OSProcess methodsFor:'private'!

setupShufflerForInput:aStream
    "if aStream is an internal Stream, set up a pipe for the command input.
     Start a process that shuffles tha data fron the internal stream into the pipe
     (and into the command's input)."

    |pipe externalStream shuffledStream shufflerProcess|

    (aStream isNil or:[aStream isExternalStream]) ifTrue:[
        ^ aStream.
    ].

    pipe := NonPositionableExternalStream makePipe.
    externalStream := pipe at:1.
    shuffledStream := pipe at:2.
    lineWise ifFalse:[
        shuffledStream blocking:false.
    ].
    aStream isBinary ifTrue:[
        shuffledStream binary.
    ].

    "/ start a reader process, shuffling data from the given
    "/ inStream to the pipe (which is connected to the commands input)
    shufflerProcess := [
            [
                lineWise ifTrue:[
                    "shuffle until end-of-input"
                    [aStream atEnd] whileFalse:[
                        |data|

                        data := aStream nextLine.
                        data notNil ifTrue:[
                            shuffledStream nextPutLine:data.
                            shuffledStream flush.
                        ].
                    ].
                ] ifFalse:[
                    aStream copyToEndInto:shuffledStream.
                ].
            ] on:WriteError do:[:ex|
                "ignore"
            ] ensure:[
                shuffledStream close.
            ]
        ] newProcess
            name:'OSProcess input shuffler';
"/                beSystemProcess;
            resume.

    shufflerProcesses add:shufflerProcess.
    streamsToClose add:externalStream.

    ^ externalStream

    "Modified: / 31-01-2017 / 16:50:39 / stefan"
!

setupShufflerForOutput:aStream
    "if aStream is an internal Stream, set up a pipe for the command output.
     Start a process that shuffles the data fron the pipe into the internal stream."

    |pipe externalStream shuffledStream shufflerProcess|

    (aStream isNil or:[aStream isExternalStream]) ifTrue:[
        ^ aStream.
    ].

    pipe := NonPositionableExternalStream makePipe.
    externalStream := pipe at:2.
    shuffledStream := pipe at:1.
    aStream isBinary ifTrue:[
        shuffledStream binary.
    ].

    shufflerProcess := [
            [
                "shuffle until the pipe closes"
                lineWise ifTrue:[
                    [shuffledStream atEnd] whileFalse:[
                        |data|

                        data := shuffledStream nextLine.
                        data notNil ifTrue:[
                            aStream nextPutLine:data
                        ].
                    ].
                ] ifFalse:[
                    shuffledStream copyToEndInto:aStream.
                ].
            ] on:WriteError do:[:ex |
                "ignore" 
            ] ensure:[
                shuffledStream close.
            ].
        ] newProcess
            priority:(Processor userSchedulingPriority "+ 1");
            name:'OSProcess output shuffler';
"/                beSystemProcess;
            resume.

    shufflerProcesses add:shufflerProcess.
    streamsToClose add:externalStream.

    ^ externalStream

    "Modified: / 31-01-2017 / 16:57:25 / stefan"
! !

!OSProcess methodsFor:'queries'!

finishedWithSuccess
    ^ exitStatus notNil and:[exitStatus success].
!

isAlive
    "answer true, if the process is still alive"

    ^ pid notNil and:[exitStatus isNil]
!

isDead
    "answer true, if the process is no longer alive"

    ^ self isAlive not
! !

!OSProcess methodsFor:'starting'!

execute
    "execute the command. 
     Wait until is is finished.
     Abort the execution if I am interrupted.
     Answer true if the terminated succesfully, 
     false if it could not be started or terminated with error."

    |ok|

    [
        ok := self startProcess.
        ok ifTrue:[
            self waitUntilFinished.
            ok := self finishedWithSuccess.
        ].
    ] ifCurtailed:[
        "/ we were interrupted -
        "/ terminate the os-command (and all of its forked commands)
        pid notNil ifTrue:[
            self terminateGroup.
        ].
    ].
    ^ ok.
!

startProcess
    "If there are non-external streams, setup transfer (shuffler) processes
     to transfer data from a pipe to the internal stream.
     Start the command.
     Answer true if the command could be started, false if not.
     Return immediately (do not wait until the command is finished)." 

    |externalInStream externalAuxStream externalErrorStream externalOutStream|

    shufflerProcesses := OrderedCollection new:4.
    streamsToClose := OrderedCollection new:2.

    externalInStream := self setupShufflerForInput:inStream.
    externalAuxStream := self setupShufflerForInput:auxStream.
    externalOutStream := self setupShufflerForOutput:outStream.
    errorStream == outStream ifTrue:[
        externalErrorStream := externalOutStream.
    ] ifFalse:[
        externalErrorStream := self setupShufflerForOutput:errorStream.
    ].

    "start the command"
    finishSema := EventSemaphore new.

    Processor 
        monitor:[
            pid := OperatingSystem
                        startProcess:command
                        inputFrom:externalInStream
                        outputTo:externalOutStream
                        errorTo:externalErrorStream
                        auxFrom:externalAuxStream
                        environment:environment
                        inDirectory:directory
                        newPgrp:newPgrp
                        showWindow:showWindow.
        ] 
        action:[:status |
            status stillAlive ifFalse:[
                exitStatus := status.
                pid notNil ifTrue:[
                    OperatingSystem closePid:pid.
                ].
"/                shufflerProcesses do:[:eachProcess|
"/                    "terminate the shuffler processes.
"/                     They close the local side of the pipe when being terminated"
"/                    eachProcess terminate.
"/                ].
                finishSema signal.
                terminateActionBlock value.
            ].
        ].

    "we can close the remote side of the pipes after the os process has been started (after the fork)"
    streamsToClose do:[:eachStream | eachStream close].
    streamsToClose := nil.

    pid isNil ifTrue:[
        "process could not be started - terminate shufflers"
        shufflerProcesses do:[:eachProcess|
            eachProcess terminate.
        ].
        shufflerProcesses := nil.
        exitStatus := OperatingSystem osProcessStatusClass processCreationFailure.
        finishSema signal.
        ^ false.
    ].

    ^ true.
! !

!OSProcess methodsFor:'terminating'!

kill
    "kill the process - the process does not get the chance to clean up"
    
    pid notNil ifTrue:[
        OperatingSystem killProcess:pid.
    ].
!

killGroup
    "kill the processGroup - the processes do not get the chance to clean up"

    pid notNil ifTrue:[
        OperatingSystem 
            killProcessGroup:pid;
            killProcess:pid.
    ].
!

terminate
    "terminate the process gracefully"

    pid notNil ifTrue:[
        OperatingSystem terminateProcess:pid.
    ].
!

terminateGroup
    "terminate the process group.
     Under Windows, these is the same as terminateWithhAllChildren,
     under unix, this terminates a subset of all children"

    pid notNil ifTrue:[
        OperatingSystem 
            terminateProcessGroup:pid;
            terminateProcess:pid.
    ].
! !

!OSProcess methodsFor:'waiting'!

waitUntilFinished
    ^ self waitUntilFinishedWithTimeout:nil
!

waitUntilFinishedWithTimeout:timeout
    |processList|

    (finishSema waitWithTimeout:timeout) isNil ifTrue:[
        "timed out"
        ^ nil.
    ].

    "have to wait until the shufflers have finished their work"
    processList := shufflerProcesses.
    processList notEmptyOrNil ifTrue:[
        processList do:[:eachProcess | 
            eachProcess waitUntilTerminated.
        ].
        shufflerProcesses := nil.
    ].
! !

!OSProcess class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


OSProcess initialize!

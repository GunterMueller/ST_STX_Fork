"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

Object subclass:#HGCommandServer
	instanceVariableNames:'repository pid input output state readerwriter encoder channel_o
		channel_e channel_r channel_d channel_I channel_L channel_M
		command'
	classVariableNames:'IdleTimeout'
	poolDictionaries:'HGDebugFlags'
	category:'SCM-Mercurial-Internal'
!

ReadStream subclass:#InputChannel
	instanceVariableNames:'server id lock rlock binary closed'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommandServer
!

WriteStream subclass:#OutputChannel
	instanceVariableNames:'server id lock rlock'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommandServer
!

!HGCommandServer class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGCommandServer class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    IdleTimeout"[ms]":= 1000 * 60   "= 1min"

    "Modified: / 09-03-2013 / 22:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGCommandServer methodsFor:'accessing'!

repository:anHGRepository
    repository := anHGRepository.

    "Modified: / 05-03-2013 / 19:35:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer methodsFor:'executing'!

execute: anHGCommand
    "Executes an HG command"

    | spin status result |

    state ~~ #connected ifTrue:[
        "/spin-lock wait...
        [ #(disconnected connected) includes: state ] whileFalse:[
            Delay waitForMilliseconds: 15.
        ].
        state == #disconnected ifTrue:[
            self start
        ]
    ].

    repository synchronized:[
        command := anHGCommand.
        anHGCommand initialize.


        self runcommand: command.

        spin := SemaphoreSet with: channel_r readSemaphore with: anHGCommand errors readSemaphore.

        status := [
            [ spin wait ~~ channel_r readSemaphore ] whileTrue:[ anHGCommand signal ].
            OperatingSystem osProcessStatusClass pid:nil status: #exit code: channel_r nextLongNet core:false.
        ] ensure:[
            "/Close channels
            channel_o close.
            channel_e close.

            "/Command terminated - this match signaling in HGCommand>>execute
            command blocker signal. 

            "/Signal blockers if workers hasn't been at all spawned...
            command outputReader isNil ifTrue:[command blocker signal].
            command errorReader isNil ifTrue:[command blocker signal].

            "/Wait for eventual workers to finish"
            command blocker wait.

            "/Reset streams...
            Trace ifTrue:[
                Logger log: 'cmdsrv: channel o content: ' , channel_o contents printString severity: #trace facility: 'HG'.
            ].
            channel_e reset.
            Trace ifTrue:[
               Logger log: 'cmdsrv: channel e content: ' , channel_e contents printString severity: #trace facility: 'HG'.
            ].
            channel_o reset.
            Trace ifTrue:[
                Logger log: 'cmdsrv: runcommand finished' severity: #trace facility: 'HG'.
            ].
            channel_r reset.
        ].
        anHGCommand signal.
        command := nil.
        result := anHGCommand status: status result: anHGCommand result.
    ].
    ^result.

    "Created: / 24-02-2013 / 15:10:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-03-2013 / 00:34:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

old_execute: anHGCommand
    "Executes an HG command"

    | spin status blocker result |

    state ~~ #connected ifTrue:[
        "/spin-lock wait...
        [ #(disconnected connected) includes: state ] whileFalse:[
            Delay waitForMilliseconds: 15.
        ].
        state == #disconnected ifTrue:[
            self start
        ]
    ].

    repository synchronized:[
        command := anHGCommand.
        anHGCommand initialize.
        blocker := command blocker.

        self runcommand: command.

        anHGCommand spawn: [ 
            status := OperatingSystem osProcessStatusClass pid:nil status: #exit code: channel_r nextLongNet core:false.

            channel_e close.
            channel_o close.
            command outputReader isNil ifTrue:[
                Trace ifTrue:[
                    Logger log: 'cmdsrv: no output reader, signalling blocker' severity: #trace facility: 'HG'.
                ].
                blocker signal
            ].
            command errorReader isNil ifTrue:[
                Trace ifTrue:[
                    Logger log: 'cmdsrv: no error reader, signalling blocker' severity: #trace facility: 'HG'.
                ].
                blocker signal
            ].
        ] name: 'command server result reader'.
        spin := SemaphoreSet with: blocker with: anHGCommand errors readSemaphore.

        [
            [ spin wait ~~ blocker ] whileTrue:[ anHGCommand signal ]
        ] ensure:[
            Trace ifTrue:[
                Logger log: 'cmdsrv: channel o content: ' , channel_o contents printString severity: #trace facility: 'HG'.
            ].
            Trace ifTrue:[
                Logger log: 'cmdsrv: reseting channel o' severity: #trace facility: 'HG'.
            ].
            channel_e reset.
            Trace ifTrue:[
                Logger log: 'cmdsrv: channel e content: ' , channel_o contents printString severity: #trace facility: 'HG'.
            ].
            Trace ifTrue:[
                Logger log: 'cmdsrv: reseting channel e' severity: #trace facility: 'HG'.
            ].
            channel_o reset.
            Trace ifTrue:[
                Logger log: 'cmdsrv: runcommand finished' severity: #trace facility: 'HG'.
            ].
            command outputReader notNil ifTrue:[command outputReader terminate].
            command errorReader notNil ifTrue:[command errorReader terminate].
        ].

        anHGCommand signal.
        command := nil.
        result := anHGCommand status: status result: anHGCommand result.
    ].
    ^result.

    "Created: / 05-03-2013 / 23:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ repository := nil.
    "/ pid := nil.
    "/ input := nil.
    "/ output := nil.
    state := #disconnected.
    "/ readerwriter := nil.
    "/ encoder := nil.
    "/ channel_o := nil.
    "/ channel_e := nil.
    "/ channel_r := nil.
    "/ channel_d := nil.
    "/ channel_I := nil.
    "/ channel_L := nil.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 24-02-2013 / 14:55:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer methodsFor:'private'!

arguments
    ^{
        HGCommand hgCommand .
"/        '--debug' . '--verbose'.
        '--cwd' . repository pathName  .
        '--config' . 'ui.interactive=True' .
        'serve' .
        '--cmdserver' . 'pipe' .
    }

    "Created: / 24-02-2013 / 12:02:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2013 / 19:37:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

channelWithId: channelId
    channelId == $o codePoint ifTrue:[
        ^ channel_o
    ].
    channelId == $e codePoint ifTrue:[
        ^ channel_e
    ].
    channelId == $r codePoint ifTrue:[
        ^ channel_r
    ].
    channelId == $d codePoint ifTrue:[
        ^ channel_d
    ].
    channelId == $I codePoint  ifTrue:[
        ^ channel_I
    ] .
    channelId == $L codePoint  ifTrue:[
        ^ channel_L
    ].
    channelId == $M codePoint ifTrue:[
        ^ channel_M
    ].
    self error: 'Invalid channel: ', channelId

    "Created: / 24-02-2013 / 12:59:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 14:14:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

connect

    | label |

    state := #connecting.
    Trace ifTrue:[
        Logger log: 'cmdsrv: connecting...' severity: #trace facility: 'HG'.
    ].
    label := channel_o next: 13.
    label = 'capabilities:' ifFalse:[
        HGCommandError raiseErrorString: 'Invalid hello message: ', label.
    ].
    channel_o nextLine.
    label := channel_o next: 9.
    label = 'encoding:' ifFalse:[
        HGCommandError raiseErrorString: 'Expected ''encoding:'' message, got: ''', label , ''''.
    ].
    encoder := CharacterEncoder encoderFor: (channel_o nextAvailable: 1000).
    channel_o reset.
    state := #connected.
    Trace ifTrue:[
        Logger log: 'cmdsrv: connected...' severity: #trace facility: 'HG'.
    ].

    "Created: / 24-02-2013 / 12:19:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 00:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runcommand: anHGCommand
    "Issue runcommand command to the server"

    | args argslen |

    args := OrderedCollection streamContents:[:s|
        anHGCommand workingDirectory notNil ifTrue:[
            s nextPut: '--cwd'; nextPut: anHGCommand workingDirectory.
        ].
        anHGCommand argumentsGlobalOn:s.
        s nextPut:anHGCommand command.
        anHGCommand argumentsCommandOn:s.
    ].

    Trace ifTrue:[
        Logger log: 'cmdsrv: runcommand: ' , (args asStringWith:Character space)  severity: #trace facility: 'HG'.
    ].

    args := String streamContents:[:s|
        args 
            do:[:e|s nextPutAll: (encoder encodeString: e)]
            separatedBy:[s nextPut: (Character codePoint: 0)]].

    argslen := args size.

    output 
        nextPutLine:'runcommand';
        nextPutLongNet: argslen;
        nextPutAll: args

    "Created: / 03-03-2013 / 16:38:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 02:30:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startReaderWriter

    "Initialize channels"

    channel_o := InputChannel id: $o server: self.
    channel_e := InputChannel id: $e server: self.
    channel_r := InputChannel id: $r server: self.
    channel_r binary.
    channel_d := InputChannel id: $d server: self.

    channel_I := OutputChannel id: $I server: self.
    channel_L := OutputChannel id: $L server: self.
    channel_M := OutputChannel id: $M server: self.

    readerwriter := [
        [ state ~~ #disconnecting and:[ input isOpen ] ] whileTrue:[
            (input readWaitWithTimeoutMs: IdleTimeout) ifTrue:[
                "Timeouted. Stop the readwrite process, but only if no command is
                 running!!"
                command isNil ifTrue:[
                    Trace ifTrue:[
                        Logger log: 'cmdsrv: inactive for too long' severity: #trace facility: 'HG'.
                    ].
                    self stop
                ]
            ] ifFalse:[
                "Data available"
                input isOpen not ifFalse:[
                    self update
                ].
            ].
        ].
    ] newProcess.

    readerwriter addExitAction:[
        input := nil.
        output := nil.
        readerwriter := nil.
        state := #disconnected.
    ].
    readerwriter name: 'HG Reader/Writer: ', repository pathName.
    readerwriter resume.

    "Created: / 24-02-2013 / 12:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 02:08:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update
    "Reads from input stream and updates corresponding channel"

    | channel len data id |

    input readWait.
    id := input next.
    channel := self channelWithId: id.
    (channel == channel_I or:[channel == channel_L]) ifTrue:[
        self shouldImplement.
    ].
    len := input nextUnsignedLongNet.
    data := input next: len.
    channel update: data encoder: encoder.
    command notNil ifTrue:[
        channel == channel_o ifTrue:[
            command spawnOutputReaderOn: channel_o
        ] ifFalse:[channel == channel_e ifTrue:[
            command spawnErrorReaderOn: channel_e
        ]].
    ].

    "Created: / 24-02-2013 / 14:06:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2013 / 00:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer methodsFor:'start & stop'!

start
    "Starts the server and returns"

    | inputPipe outputPipe environment args |

    state := #starting.
    inputPipe := NonPositionableExternalStream makePipe.
    input := inputPipe first.
    input binary.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        input lineEndTransparent.
    ].

    outputPipe := NonPositionableExternalStream makePipe.
    output := outputPipe second.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        output lineEndTransparent.
    ].
"/    output binary.

    args := self arguments.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        args := String streamContents:[:s|
            args
                do:[:each | s nextPut:$"; nextPutAll: each; nextPut: $"]
                separatedBy: [ s space ]
        ]
    ].


    environment := OperatingSystem isUNIXlike
                    ifTrue:[OperatingSystem getEnvironment copy]
                    ifFalse:[environment := Dictionary new].
    environment at: 'HGEDITOR' put: 'true'.
    environment at:'LANG' put:'C'.

    Processor monitor:[
        pid := OperatingSystem exec:(HGCommand hgCommand) withArguments: args
                environment:environment
                fileDescriptors:{outputPipe first fileDescriptor . inputPipe second fileDescriptor . 3}
                fork:true
                newPgrp:false
                inDirectory: Filename currentDirectory pathName.
        Trace ifTrue:[
            Logger log: 'cmdsrv: server started' severity: #trace facility: 'HG'.
        ].
        pid.
    ] action:[:stat |
        Trace ifTrue:[
            Logger log: 'cmdsrv: server terminated' severity: #trace facility: 'HG'.
        ].
    ].


    inputPipe second close.
    outputPipe first close.
    pid isNil ifTrue:[
        HGCommandError raiseErrorString: 'Cannot start command server'.
        input close.
        output close.
        ^ self.
    ].

    encoder := CharacterEncoder encoderFor:#ascii.
    self startReaderWriter.
    self connect.

    "Created: / 24-02-2013 / 11:40:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2013 / 09:29:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop
    state == #disconnected ifFalse:[
        Trace ifTrue:[
            Logger log: 'cmdsrv: server terminating' severity: #trace facility: 'HG'.
        ].
        state := #disconnecting.
        readerwriter terminate.
        input close.
        output close.
    ].

    "Created: / 24-02-2013 / 14:20:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2013 / 19:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel class methodsFor:'documentation'!

documentation
"
    An input channel (hg serve --> smalltalk)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGCommandServer::InputChannel class methodsFor:'instance creation'!

id: id server: server
    ^self basicNew setId: id server: server

    "Created: / 24-02-2013 / 12:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'accessing'!

contents
    ^collection copyTo: readLimit

    "Created: / 05-03-2013 / 22:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

id
    ^ id
!

readSemaphore
    ^rlock

    "Created: / 03-03-2013 / 16:40:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'initialization'!

reset
    closed := false.
    collection := (binary ifTrue:[ByteArray new: 4] ifFalse:[String new: 100]). 
    position := 0.
    readLimit := 0.
    writeLimit := 0.
    rlock count > 0 ifTrue:[rlock consume: rlock count].

    "Created: / 03-03-2013 / 13:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 00:25:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setId: aCharacter server: anHGCommandServer    
    id := aCharacter.
    server := anHGCommandServer.
    lock := Semaphore forMutualExclusion.
    rlock := Semaphore new:0.
    binary := false.
    self reset.

    "Created: / 24-02-2013 / 12:51:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 00:25:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'misc'!

binary
    "switch to binary mode. In binary mode, reading of text streams
     returns byte-valued integers instead of characters; writing expects
     byte-valued integers respectively.
     Ignored here, but added to make internalStreams protocol compatible 
     with externalStreams."

    binary := true.
    collection := collection asByteArray

    "Created: / 03-03-2013 / 14:20:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

close
    lock critical:[
        closed := true.
    ].
    self readSignal

    "Created: / 03-03-2013 / 15:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 17:25:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'private'!

growCollection:minNewSize
    "grow the streamed collection to at least minNewSize"

    |oldSize newSize newColl|

    oldSize := collection size.
    (oldSize == 0) ifTrue:[
	newSize := minNewSize
    ] ifFalse:[
	newSize := oldSize * 2.
	(newSize < minNewSize) ifTrue:[newSize := minNewSize].
    ].
    collection isFixedSize ifTrue:[
	newColl := collection species new:newSize.
	newColl replaceFrom:1 to:oldSize with:collection startingAt:1.
	collection := newColl
    ] ifFalse:[
	collection grow:newSize
    ].

    "Modified: 19.8.1997 / 17:53:11 / cg"
!

trace: message
    HGDebugFlags trace ifTrue:[
        Logger log: ('cmdsrv-ichannel[', id, '] {', Processor activeProcess id printString, '}: ', message) severity: #trace facility: 'HG'.
    ]

    "Created: / 03-03-2013 / 18:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-03-2013 / 22:14:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'reading'!

next
    ^self readWaitWithTimeoutMs: nil do: [ super next ].

    "Created: / 24-02-2013 / 13:30:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 19:17:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextByte    
    self assert: binary.
    ^self next

    "Created: / 03-03-2013 / 14:21:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextOrNil
    ^self readWaitWithTimeoutMs: nil do: [ super nextOrNil ].

    "Created: / 03-03-2013 / 15:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 19:18:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peek
    ^self readWaitWithTimeoutMs: nil do: [ super peek ].

    "Created: / 24-02-2013 / 13:30:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 19:18:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'testing'!

atEnd
    ^self readWaitWithTimeoutMs: nil do:[
        closed and:[((position-ZeroPosition+1) > readLimit)]
    ].

    "Created: / 03-03-2013 / 15:36:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 19:57:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'updating'!

update: bytes encoder: encoder

    | string |


    self assert: closed not.
    string := binary 
                ifTrue:[bytes] 
                ifFalse:[encoder decodeString: bytes].

    lock critical:[
        | len |

        len := string size.
        readLimit + len > collection size ifTrue:[
            self growCollection:readLimit + len.
        ].
        collection replaceFrom: readLimit + 1 count: len with:string startingAt:1.
        readLimit := readLimit + len.
        self trace: 'read ' ,bytes size printString, ' bytes'.
        self readSignal.
    ].

    "Created: / 03-03-2013 / 14:01:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 19:23:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::InputChannel methodsFor:'waiting for I/O'!

readSignal
    self trace: 'signalling data'.

    rlock signal.

    "Created: / 03-03-2013 / 17:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 00:35:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readWaitWithTimeoutMs:millis
    ^self readWaitWithTimeoutMs: millis do:[]

    "Created: / 03-03-2013 / 17:23:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 19:17:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readWaitWithTimeoutMs:millis do: block
    [
        lock critical:[
            (closed or:[((position-ZeroPosition+1) <= readLimit)]) ifTrue:[
                ^block value
            ].

        ].
        self trace: 'waiting for data'.
        rlock waitWithTimeoutMs:millis.
        self trace: 'data ready'.
    ] loop

    "Created: / 03-03-2013 / 19:16:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::OutputChannel class methodsFor:'documentation'!

documentation
"
    An input channel (smalltalk --> hg server)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGCommandServer::OutputChannel class methodsFor:'instance creation'!

id: id server: server
    ^self basicNew setId: id server: server

    "Created: / 24-02-2013 / 12:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer::OutputChannel methodsFor:'accessing'!

id
    ^ id
! !

!HGCommandServer::OutputChannel methodsFor:'initialization'!

setId: aCharacter server: anHGCommandServer
    id := aCharacter.
    server := anHGCommandServer.
    lock := Semaphore forMutualExclusion.
    rlock := Semaphore new:0.
    collection := String new: 100.
    position := 0.
    readLimit := 0.
    writeLimit := 0.

    "Created: / 24-02-2013 / 12:51:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandServer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


HGCommandServer initialize!

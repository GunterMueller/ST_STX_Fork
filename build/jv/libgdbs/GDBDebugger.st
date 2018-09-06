"{ Encoding: utf8 }"

"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

Object subclass:#GDBDebugger
	instanceVariableNames:'connection commandSequenceNumber inferiorStateSequenceNumber
		inferiors breakpoints selectedInferior selectedThread
		selectedFrame prettyPrintingEnabled frameFiltersEnabled
		finalizationRegistry debuggerFeatures targetFeatures directories'
	classVariableNames:''
	poolDictionaries:'GDBCommandStatus GDBFeatures'
	category:'GDB-Core'
!

!GDBDebugger class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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

!GDBDebugger class methodsFor:'instance creation'!

new    
    ^ self newWithProcess: GDBProcess new

    "Modified: / 12-12-2017 / 21:15:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWithProcess: aGDBProcess
    ^ self basicNew initializeWithProcess: aGDBProcess

    "Created: / 20-06-2014 / 21:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'accessing'!

announcer
    ^ connection eventAnnouncer.

    "Created: / 02-06-2014 / 23:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

breakpointForId: id
    self breakpoints do:[:bp |
        bp number = id ifTrue:[ ^ bp ].
        bp locations do: [ :loc |
            loc number = id ifTrue:[ ^ loc ].
        ].
    ].
    self error: ('No breakpoint with id ''%1'' found!!' bindWith: id)

    "Created: / 18-05-2018 / 13:39:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2018 / 15:03:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

breakpoints
    breakpoints isNil ifTrue:[ 
        breakpoints := List new.
    ].
    ^ breakpoints

    "Created: / 06-07-2017 / 16:06:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleInput
    ^ connection consoleInput

    "Created: / 31-05-2017 / 23:20:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2017 / 23:13:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    ^ connection consoleOutput

    "Created: / 31-05-2017 / 23:20:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2017 / 23:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directories
    "Return a list of directories where GDB looks for source code and an Array.
     Variables such as $cdir and $cwd are NOT expanded.
    "
    | result |

    directories isNil ifTrue:[
        result := self send: (GDBMI_gdb_show arguments: #('directories')).

        OperatingSystem isMSWINDOWSlike ifTrue:[ 
            "/ On Windows, GDB uses cygwin paths (i.e., slashed, unix-like paths). 
            "/ Convert them to Windows paths as used in Smalltalk/X:
            directories := ((result propertyAt: #value) tokensBasedOn: $;) 
                                collect: [ :d | (Filename cygNamed:d) pathName ]
                                as: Array.
        ] ifFalse:[ 
            directories := ((result propertyAt: #value) tokensBasedOn: $:) asArray
        ].
    ].
    ^ directories

    "Created: / 09-03-2018 / 12:05:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2018 / 21:14:45 / jv"
!

features
    "Return a list of features supported ty this version og GDB.
     See 
            * GDBFeatures` pool
            * https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Support-Commands.html,
              command `-list-features`
    "
    ^ debuggerFeatures , (targetFeatures ? connection nativeTargetFeatures)

    "Created: / 07-02-2018 / 10:50:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:35:22 / jv"
    "Modified: / 09-04-2018 / 15:39:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inferiorForId: id
    ^ inferiors ? #() detect:[:e | e id = id ] ifNone:[ 
        self error: ('No inferior (thread group) with id ''%1'' found!!' bindWith: id)
    ].

    "Created: / 07-09-2014 / 21:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inferiorStderr
    ^ connection inferiorPTY master

    "Created: / 09-06-2014 / 10:01:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2014 / 18:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inferiorStdin
    ^ connection inferiorPTY master

    "Created: / 09-06-2014 / 10:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2014 / 18:27:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inferiorStdout
    ^ connection inferiorPTY master

    "Created: / 09-06-2014 / 10:01:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2014 / 18:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inferiors
    ^ inferiors ? #()

    "Modified: / 06-07-2017 / 16:06:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedInferior
    selectedInferior isNil ifTrue:[ 
        inferiors size == 1 ifTrue:[ 
            ^ inferiors anElement.
        ].
    ].
    ^ selectedInferior

    "Created: / 07-09-2014 / 23:02:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

threadForId: id
    inferiors ? #() do:[:tg |
        tg threads do:[:t | 
            t id = id ifTrue:[ ^ t ]
        ].
    ].
    self error: ('No thread with id ''%1'' found!!' bindWith: id)

    "Created: / 04-02-2018 / 21:37:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'accessing-private'!

connectionTrace
    ^ connection trace

    "Created: / 09-03-2018 / 10:04:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentInferiorStateSequnceNumber
    ^ inferiorStateSequenceNumber

    "Created: / 19-06-2014 / 22:22:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalizationRegistry
    ^ finalizationRegistry
!

nextCommandSequnceNumber
    commandSequenceNumber := commandSequenceNumber + 1.
    commandSequenceNumber == SmallInteger maxVal ifTrue:[ 
        commandSequenceNumber := 0.
    ].
    ^ commandSequenceNumber

    "Created: / 02-06-2014 / 23:48:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextInferiorStateSequnceNumber
    inferiorStateSequenceNumber := inferiorStateSequenceNumber + 1.
    inferiorStateSequenceNumber == SmallInteger maxVal ifTrue:[
        inferiorStateSequenceNumber := 0.
    ].
    ^ inferiorStateSequenceNumber

    "Created: / 02-06-2014 / 23:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'commands'!

send: command
    "Execute given `command` and wait until it finishes and return its result.
     `command` may be either a GDBCommand or string, in which case it will
     be parsed into a GDBCommand. 
   "
    ^ self send:command andWait:true.

    "Created: / 03-06-2014 / 00:10:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-03-2015 / 05:50:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

send:command andWait:wait 
    "Sends given `command` to GDB. If `wait` is true, wait for
     command to finish and return the command result.  
     Otherwise, return nil immediately.

     If `wait` is true and if command results in an error GDBError
     is thrown.

     `command` may be either a GDBCommand or string, in which case it will
     be parsed into a GDBCommand.           
    "
    
    | blocker result |

    self assert: self isConnected.
    ^ wait ifTrue:[
        blocker := Semaphore new.
        self send: command andWithResultDo: [ :r | 
            result := r.
            blocker signal
        ].
        blocker wait.
        result isError ifTrue:[
            GDBCommandFailedError raiseForResult: result.
        ].
        result.
    ]
    ifFalse:[
        | cmd |

        cmd := command.
        cmd isString ifTrue:[
            cmd := GDBCLICommand new value:cmd.
        ].    
        cmd token: self nextCommandSequnceNumber.
        connection pushEvent:(GDBCommandEvent new command:cmd).
        nil.
    ]

    "Created: / 02-06-2014 / 23:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2018 / 00:21:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:19:59 / jv"
!

send:command andWaitFor:eventHandlers
    "Sends given `command` to GDB and then wait for events mathing 
     `eventHandlers`. 

     Params:
     `command`      may be either a GDBCommand or string, in which case it will
                    be parsed into a GDBCommand.
     `eventHandler` may be either nil or event class or one arg block or collection
                    of event classes or blocks.
                    - If nil then do not wait for anything (use nil for async send)
                    - If event class, then wait for an event of that class. Note, that
                      subclasses are handled too.
                    - If block, then wait for an event for which the block returns true.
                    - If collectio, then wait for a sequence of events, each matched as above.

     Returns:       a matching event or events (in case a collection of handlers has been passes)"

    ^ self send: command andWaitFor: eventHandlers withTimeoutMs: nil

    "Created: / 08-03-2015 / 06:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

send:command andWaitFor:eventHandlers withTimeoutMs:timeout 
    "Sends given `command` to GDB and then wait for events mathing 
     `eventHandlers`. Raise a TimeoutError if expected events don't arrive
     in specified time.

     Params:
     `command`      may be either a GDBCommand or string, in which case it will
                    be parsed into a GDBCommand.
     `eventHandler` may be either nil or event class or one arg block or collection
                    of event classes or blocks.
                    - If nil then do not wait for anything (use nil for async send)
                    - If event class, then wait for an event of that class. Note, that
                      subclasses are handled too.
                    - If block, then wait for an event for which the block returns true.
                    - If collectio, then wait for a sequence of events, each matched as above.
     `timeout`       wait at most that much milliseconds, throw TimeoutError otherwise. If `timeout` == mil
                    then wait for indefinitly

     Returns:       a matching event or events (in case a collection of handlers has been passes)"
    
    | commandObject |

    self assert: self isConnected.
    command isString ifTrue:[
        commandObject := (GDBMIParser on:command) parseCommand.
        commandObject token:self nextCommandSequnceNumber.
    ] ifFalse:[
        commandObject := command.
        commandObject token isNil ifTrue:[
            commandObject token:self nextCommandSequnceNumber.
        ].
    ].
    ^ self 
        do:[ connection pushEvent:(GDBCommandEvent new command: commandObject) ] 
        andWaitFor: eventHandlers 
        withTimeoutMs: timeout

    "Created: / 07-03-2015 / 11:38:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-02-2018 / 00:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

send:command andWithResultDo: block
    "Sends given `command` to GDB and return nil immediately. Once the command
     is processed and result returned, evaluate `block` passing the
     result (as instance of GDBCommandResult)

     The `command` may be either a GDBCommand or string, in which case it will
     be parsed into a GDBCommand.

     When calling this method from a UI code, i.e., from an UI even loop, keep
     in mind that the block will be evaluated from within GDB's internal event
     dispatch loop.

     It's is a gooc practice not to do anything real within the block but just
     grab the result and lt it processed within UI event loop, e.g.

         doSomeAction

             debugger send: (GDBMI_data_read_memory arguments:...) 
                      andWithResultDo:[ :result | self sensor pushUserEvent: #updateWithReslt: with: result ].
    "
    
    | cmd  token handler1  handler2  result |

    self assert: self isConnected.
    cmd := command.
    cmd isString ifTrue:[
        cmd := GDBCLICommand new value:cmd.
    ].
    token := self nextCommandSequnceNumber.
    cmd token:token.
    handler1 := [:ev | 
        ev token == token ifTrue:[
            connection eventAnnouncer unsubscribe:handler1.
            result := ev result.
            connection eventAnnouncerInternal when:GDBEventSetProcessingFinished
                do:handler2.
        ]
    ].
    handler2 := [:ev | 
        connection eventAnnouncerInternal unsubscribe:handler2.
        block value: result.
    ].
    connection eventAnnouncer when:GDBCommandResultEvent do:handler1.
    connection pushEvent:(GDBCommandEvent new command:cmd).
    ^ nil

    "Created: / 26-01-2018 / 21:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-02-2018 / 00:20:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:48:02 / jv"
! !

!GDBDebugger methodsFor:'commands - API'!

attach: aStringOrInteger
    "Attach to a running process.
     API equivalent to CLI command:

        (gdb) attach <aStringOrInteger>
    "
    self send:(GDBMI_target_attach arguments:(Array with: aStringOrInteger asString)).

    "Created: / 05-06-2017 / 17:08:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-01-2018 / 23:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

disassembleFile: file line: line count: count
    "
    Disassemble `count` source lines from `file` starting at line `line`.
    Returns a list of GDBInstructionsAndSourceLine objects.

    If `count` is nil, then disassemble entire function at given
    source `file` and `line`.
    "

    | cmd result disassembly |

    self assert: file isString.
    self assert: line isInteger.
    self assert:(count isNil or:[ count isInteger ]).

    count notNil ifTrue:[ 
        cmd := GDBMI_data_disassemble arguments: (Array with: '-f' with: file with: '-l' with: line with: '-n' with: count with: '--' with: 5)
    ] ifFalse:[ 
        cmd := GDBMI_data_disassemble arguments: (Array with: '-f' with: file with: '-l' with: line                        with: '--' with: 5)
    ].
    result := self send: cmd.

    disassembly := result propertyAt: 'asm_insns'
.   disassembly do:[:each | each setDebugger: self ].
    ^ disassembly

    "Created: / 22-06-2018 / 11:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

disassembleFunction: address
    "
    Disassemble function at given `address` (given as String). Address
    might be any expression evaluable by GDB or function name (as it 
    appears in debug info)

    WARNING: This requires feature 'data-disassemble-a-option'.
    This feature is not present in GDB as of 8.1 and likely won't be in
    8.2.
    "

    | result disassembly |

    self assert: address isString.

    self ensureFeature: 'data-disassemble-a-option'.

    result := self send: (GDBMI_data_disassemble arguments: (Array with: '-a' with: address with: '--' with: 5)).

    disassembly := result propertyAt: 'asm_insns'
.   disassembly do:[:each | each setDebugger: self ].
    ^ disassembly

    "Created: / 03-07-2018 / 14:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enableFrameFilters
    "Enables frame filters & frame decorators for MI interface. Once enabled,
     cannot be turned off.

     @see GDBMI_enable_frame_filters"

    | result |

    self ensureFeature: DebuggerFeaturePython.  
    result := self send: GDBMI_enable_frame_filters new.
    result isDone ifTrue:[ 
        frameFiltersEnabled := true.
    ] ifFalse:[ 
        GDBError raiseErrorString: 'failed to enable frame filters'
    ].

    "Created: / 12-06-2017 / 09:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2018 / 09:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enablePrettyPrinting
    "Enables pretty printing for MI interface. Once enabled,
     cannot be turned off.

     @see GDBMI_enable_pretty_printing"

    | result |

    self ensureFeature: DebuggerFeaturePython.  
    result := self send: GDBMI_enable_pretty_printing new.
    result isDone ifTrue:[ 
        prettyPrintingEnabled := true.
    ] ifFalse:[ 
        GDBError raiseErrorString: 'failed to enable pretty printing'
    ].

    "Created: / 12-06-2017 / 09:29:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2018 / 13:55:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluate: expression
    "Evaluates passed `expression` (in target language) in current thread.
     Returns the result as `GDBVariableObject`,"

    ^ self evaluate: expression in: nil

    "Created: / 20-03-2018 / 22:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluate: expression in: frame
    "Evaluates passed `expression` (in target language). If
     `frame` (as `GDBFrame`) is given, evaluate expression in
     context of that `frame`.

     Returns the result as `GDBVariableObject`,"

    | result varobj |

    frame notNil ifTrue:[
        result := self send: (GDBMI_var_create new arguments: (Array with: '--thread' with: frame thread id with: '--frame' with: frame level with: '-' with: '*' with: expression)).
    ] ifFalse:[
        result := self send: (GDBMI_var_create new arguments: (Array with: '-' with: '*' with: expression)).
    ].
    varobj := result value.
    varobj 
        setDebugger: self; 
        setExpression: expression;
        setFrame: frame;
        registerForFinalization. 
    ^ varobj

    "Created: / 13-02-2018 / 22:21:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 20-03-2018 / 22:55:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executable: aStringOrFilename
    "Sets the executable to debug. 
     API equivalent to CLI command:

        (gdb) exec-file <aStringOrFilename>
    "
    self executable: aStringOrFilename arguments: nil

    "Created: / 28-02-2015 / 00:19:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-06-2017 / 17:06:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executable: aStringOrFilename arguments: anArray"of String"
    "Sets the executable to debug and argument to pass to it.
     API equivalent to CLI command:

        (gdb) exec-file <aStringOrFilename>   
        (gdb) set args <anArray>
    "
    self send:(GDBMI_file_exec_and_symbols arguments: (Array with: aStringOrFilename asString)).
    anArray notEmptyOrNil ifTrue:[ 
        self send: (GDBMI_exec_arguments arguments: anArray).
    ].

    "Created: / 05-06-2017 / 17:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2018 / 09:44:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectFrame: aGDBFrame
    "
    Set the context frame to given frame. This frame is then
    the contex frame for other commands, like finish, info frame
    and so on
      "
    self send:(GDBMI_thread_select new arguments:(Array with:aGDBFrame thread id))andWait:false.
    self send:(GDBMI_stack_select_frame new arguments:(Array with:aGDBFrame level)) andWait:false.

    "Created: / 01-02-2018 / 22:27:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectThread: aGDBThread
    "
    Set the context thread to given thread. This thread is then
    the contex thread for other commands (if no thread id is given)
    "
    self send:(GDBMI_thread_select new arguments:(Array with:aGDBThread id))andWait:false.

    "Created: / 01-02-2018 / 22:25:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

targetConnect: type parameters: parameters
    "Connect to the remote target. `type` is the type of target, 
     for instance ‘extended-remote=’. `parameters` are device names, 
     host names and the like.

     See https://sourceware.org/gdb/onlinedocs/gdb/Target-Commands.html#Target-Commands
    "
    self send:(GDBMI_target_select arguments:(Array with: type) , parameters).

    "Created: / 26-07-2018 / 21:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'evaluating'!

do: block andWaitFor:eventHandlers
    "Evaluates a given block and then wait for events.
     `eventHandlers`. 
     Params:
     `block`        block to evaluate
     `eventHandler` may be either nil or event class or one arg block or collection
                    of event classes or blocks.
                    - If nil then do not wait for anything (use nil for async send)
                    - If event class, then wait for an event of that class. Note, that
                      subclasses are handled too.
                    - If block, then wait for an event for which the block returns true.
                    - If collection, then wait for a sequence of events, each matched as above.
     Returns:       a matching event or events (in case a collection of handlers has been passed)"

    ^ self do: block andWaitFor: eventHandlers withTimeoutMs: nil

    "Created: / 08-03-2015 / 07:30:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-06-2017 / 09:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

do: block andWaitFor:eventHandlers withTimeoutMs:timeout 
    "Evaluates a given block and then wait for events.
     `eventHandlers`. Raise a TimeoutError if expected events don't arrive
     in specified time.

     Params:
     `block`        block to evaluate
     `eventHandler` may be either nil or event class or one arg block or collection
                    of event classes or blocks.
                    - If nil then do not wait for anything (use nil for async send)
                    - If event class, then wait for an event of that class. Note, that
                      subclasses are handled too.
                    - If block, then wait for an event for which the block returns true.
                    - If collectio, then wait for a sequence of events, each matched as above.
     `timeout`       wait at most that much milliseconds, throw TimeoutError otherwise. If `timeout` == mil
                    then wait for indefinitly

     Returns:       a matching event or events (in case a collection of handlers has been passes)"
    
    | handlersArray handlerFinal eventsArray blocker |

    eventHandlers isNil ifTrue:[
        "/ Asynchronous send...
        self assert:timeout isNil.
        block value.
        ^ nil
    ].
    "/ Synchronous send...
    self assert:Processor activeProcess ~~ connection eventDispatchProcess
        message:'Cannot send commands from within event dispatching process. Would deadlock'.
    eventHandlers isCollection 
        ifTrue:[ handlersArray := eventHandlers ]
        ifFalse:[ handlersArray := Array with:eventHandlers ].
    eventsArray := Array new:handlersArray size.
    1 to:handlersArray size do:[:i | 
        | handler |

        handler := handlersArray at:i.
        handlersArray at:i
            put:[:event | 
                | matches |

                matches := handler isBlock ifTrue:[ handler value:event ] ifFalse:[ event isKindOf:handler ].
                (matches and:[ i == 1 or:[ (eventsArray at:i - 1) notNil ] ]) ifTrue:[
                    eventsArray at:i put:event.
                    self announcer unsubscribe:(handlersArray at:i).
                    i == handlersArray size ifTrue:[
                        connection eventAnnouncerInternal when: GDBEventSetProcessingFinished do: handlerFinal.
                    ].
                ].
            ].
        self announcer when:GDBEvent do:(handlersArray at:i).
    ].
    handlerFinal := [ :event | connection eventAnnouncerInternal unsubscribe: handlerFinal. blocker signal ].  
    blocker := Semaphore new.
    block value.
    [
        (blocker waitWithTimeoutMs:timeout) isNil ifTrue:[
            eventsArray := nil.
        ].
    ] ensure:[
        handlersArray do:[:handler | 
            handler notNil ifTrue:[
                self announcer unsubscribe:handler
            ]
        ].
    ].
    eventsArray isNil ifTrue:[
        (TimeoutError newException)
            parameter:timeout;
            raise.
    ].
    ^ eventHandlers isCollection ifTrue:[ eventsArray ] ifFalse:[ eventsArray first ]

    "Created: / 08-03-2015 / 07:28:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'event handling'!

onBreakpointCreatedEvent: aGDBBreakpointCreatedEvent
    | breakpoint |

    breakpoints isNil ifTrue:[ 
        breakpoints := List new.
    ].

    "/ Care for breakpoints with multiple locations. 
    "/ 
    "/.If the breakpoint created has multiple locations,
    "/ the breakppints contains an instance of GDBBreakpoint
    "/ for the top-level breakpoint, followed by a GDBBreakpoint
    "/ for each location.

    breakpoint := aGDBBreakpointCreatedEvent breakpoints first.
    aGDBBreakpointCreatedEvent breakpoints size > 1 ifTrue:[ 
        breakpoint locations: (aGDBBreakpointCreatedEvent breakpoints copyFrom: 2)
    ].
    breakpoint setDebugger: self.    
    breakpoints add: breakpoint.

    "Created: / 06-07-2017 / 16:08:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2018 / 14:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onBreakpointDeletedEvent: aGDBBreakpointDeletedEvent
    | breakpoint |

    breakpoint := self breakpointForId: aGDBBreakpointDeletedEvent id.
    breakpoint setDebugger: nil.
    breakpoints remove: breakpoint.

    "Created: / 06-07-2017 / 16:26:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2018 / 14:58:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onBreakpointModifiedEvent: aGDBBreakpointModifiedEvent
    aGDBBreakpointModifiedEvent breakpoints do:[:new | 
        | old |    

        old := self breakpointForId: new number.
        old updateFrom: new.
    ].

    "Created: / 06-07-2017 / 16:28:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 23:11:52 / jv"
    "Modified: / 18-05-2018 / 14:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onCmdParamChangedEvent: aGDBCmdParamChangedEvent
    (aGDBCmdParamChangedEvent name = 'directories') ifTrue:[ 
        directories := nil.
    ].

    "Created: / 09-03-2018 / 12:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onCommandEvent:aGDBCommandEvent 
    connection send:aGDBCommandEvent command.

    "Created: / 02-06-2014 / 23:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 22:09:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onExitEvent:aGDBExitEvent 
    self release.

    "Created: / 03-06-2014 / 00:36:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2014 / 09:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onRunningEvent: aGDBRunningEvent
    | threads threadId |

    self nextInferiorStateSequnceNumber.        
    threadId := aGDBRunningEvent threadId.
    threadId = 'all' ifFalse:[ 
        threadId := threadId asInteger.
    ].
    threads := Set new.
    inferiors do:[:inferior | 
        inferior threads do:[:thread | 
            (threadId isString or:[thread id = threadId]) ifTrue:[ 
                threads add: thread.
            ].
        ].
    ].
    aGDBRunningEvent setThreads: threads.
    threads do:[:thread | 
        thread onRunningEvent: aGDBRunningEvent.
    ].

    "Created: / 07-09-2014 / 23:34:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-07-2017 / 13:48:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onStoppedEvent: aGDBStoppedEvent
    | threads threadIds |

    self nextInferiorStateSequnceNumber.  
    threadIds := aGDBStoppedEvent stoppedThreadIds.
    threadIds = 'all' ifFalse:[ 
        threadIds := threadIds collect:[:e | e asInteger ].
    ].
    threads := Set new.
    inferiors do:[:inferior | 
        inferior threads do:[:thread | 
            (threadIds isString or:[threadIds includes: thread id]) ifTrue:[ 
                threads add: thread.
            ].
        ].
    ].
    aGDBStoppedEvent setThreads: threads.
    threads do:[:thread | 
        thread onStoppedEvent: aGDBStoppedEvent.
    ].

    "/ Initialize target features properly
    targetFeatures isNil ifTrue:[
        self send: GDBMI_list_target_features new 
             andWithResultDo:[ :result | targetFeatures := result propertyAt: #features ].
    ].

    "Created: / 07-09-2014 / 23:34:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2018 / 15:42:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadCreatedEvent:aGDBThreadCreatedEvent 
    | inferior |

    inferior := self inferiorForId:aGDBThreadCreatedEvent threadGroupId.
    inferior onThreadCreatedEvent:aGDBThreadCreatedEvent.

    "Created: / 07-09-2014 / 21:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadExitedEvent:aGDBThreadExitedEvent 
    | inferior |

    self nextInferiorStateSequnceNumber.  
    inferior := self inferiorForId:aGDBThreadExitedEvent threadGroupId.
    inferior onThreadExitedEvent:aGDBThreadExitedEvent.

    "/ reset target features
    targetFeatures := nil.

    "Created: / 07-09-2014 / 21:20:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2018 / 15:42:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadGroupAddedEvent:aGDBThreadGroupAddedEvent 
    | inferior |

    inferiors isNil ifTrue:[
        inferiors := List new.
    ].
    inferior := GDBThreadGroup newWithDebugger:self
            id:aGDBThreadGroupAddedEvent threadGroupId.
    inferiors add:inferior.
    aGDBThreadGroupAddedEvent setThreadGroup:inferior.

    "Modified: / 26-03-2018 / 21:46:51 / jv"
    "Modified: / 09-04-2018 / 15:36:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadGroupExitedEvent:aGDBThreadGroupExitedEvent 
    | inferior |

    self nextInferiorStateSequnceNumber.        
    inferior := self inferiorForId:aGDBThreadGroupExitedEvent threadGroupId.
    inferior setExitCode:aGDBThreadGroupExitedEvent exitCode.
    aGDBThreadGroupExitedEvent setThreadGroup:inferior

    "Created: / 06-09-2014 / 02:37:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2015 / 13:57:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onThreadGroupStartedEvent:aGDBThreadGroupStartedEvent 
    | inferior |

    inferior := self inferiorForId:aGDBThreadGroupStartedEvent threadGroupId.
    inferior setPid:aGDBThreadGroupStartedEvent pid.
    aGDBThreadGroupStartedEvent setThreadGroup:inferior.

    "Created: / 06-09-2014 / 02:37:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-02-2018 / 12:50:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:33:11 / jv"
!

onThreadSelectedEvent: aGDBThreadSelectedEvent 
    | inferior |

    inferior := self selectedInferior.
    inferior onThreadSelectedEvent:aGDBThreadSelectedEvent.

    "Created: / 29-07-2018 / 22:20:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'finalization'!

finalize
    self release.

    "Created: / 26-05-2014 / 21:23:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'initialize & release'!

initializeWithProcess: aGDBProcess
    | result |

    self registerForFinalization.

    finalizationRegistry := Registry new.
    connection := GDBConnection newWithProcess: aGDBProcess.

    commandSequenceNumber := 0.
    inferiorStateSequenceNumber := 0.

    self subscribe.        

    connection eventPumpStart.
    connection eventDispatchStart.
    Delay waitForMilliseconds:100.  

    connection inferiorPTY notNil ifTrue:[
        self send: (GDBMI_inferior_tty_set arguments: (Array with: connection inferiorPTY name)).
    ].
    self send: (GDBMI_gdb_set arguments: #('target-async' 'on')).

    result := self send: GDBMI_list_features new.
    debuggerFeatures := result propertyAt: #features.
    targetFeatures := nil.

    prettyPrintingEnabled := false.
    frameFiltersEnabled := false.

    "Created: / 20-06-2014 / 21:45:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2018 / 21:36:31 / jv"
    "Modified: / 09-04-2018 / 15:38:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    connection notNil ifTrue:[ 
        self unsubscribe.
        connection release.
        connection := nil.
    ].

    "Created: / 26-05-2014 / 21:24:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 22:08:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subscribe
    connection eventAnnouncerInternal
        when: GDBCommandEvent               send: #onCommandEvent:           to: self;
        when: GDBExitEvent                  send: #onExitEvent:              to: self;

        when: GDBThreadGroupAddedEvent      send: #onThreadGroupAddedEvent:  to: self;
        when: GDBThreadGroupStartedEvent    send: #onThreadGroupStartedEvent: to: self;
        when: GDBThreadGroupExitedEvent     send: #onThreadGroupExitedEvent: to: self;

        when: GDBThreadCreatedEvent         send: #onThreadCreatedEvent:      to: self;
        when: GDBThreadExitedEvent          send: #onThreadExitedEvent:       to: self;

        when: GDBThreadSelectedEvent        send: #onThreadSelectedEvent:     to: self;

        when: GDBRunningEvent               send: #onRunningEvent:            to: self;
        when: GDBStoppedEvent               send: #onStoppedEvent:            to: self;

        when: GDBBreakpointCreatedEvent     send: #onBreakpointCreatedEvent:  to: self;
        when: GDBBreakpointModifiedEvent    send: #onBreakpointModifiedEvent: to: self;
        when: GDBBreakpointDeletedEvent     send: #onBreakpointDeletedEvent:  to: self;

        when: GDBCmdParamChangedEvent       send: #onCmdParamChangedEvent:    to: self.

    "Created: / 20-06-2014 / 22:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2018 / 22:18:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsubscribe
    connection eventAnnouncerInternal unsubscribe: self

    "Created: / 20-06-2014 / 22:07:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'inspecting'!

inspector2TabGDBMITrace
    <inspector2Tab>
    ^ (self newInspector2Tab)
        label:'GDB/MI Trace';
        priority:50;
        application:[ GDBMITraceViewer new debugger:self ];
        yourself

    "Modified (format): / 09-03-2018 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'queries'!

hasFeature: feature
    "Return true, if this debugger support given feature, false otherwise.
     See GDBFeatures pool for available features.

     Note however, that newer versions og GDB may have more features.
    "
    ^ self features includes: feature

    "Created: / 07-02-2018 / 11:32:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-02-2018 / 12:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFeatureAsync
    "Indicates that the target is capable of asynchronous command execution, which means 
     that GDB will accept further commands while the target is running." 

    targetFeatures notNil ifTrue:[ 
        ^ targetFeatures includes: 'async'
    ] ifFalse:[ 
        ^ connection nativeTargetFeatures includes: 'async'.
    ].

    "Created: / 09-04-2018 / 15:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'testing'!

isConnected
    ^ connection notNil

    "Created: / 20-06-2014 / 22:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFrameFiltersEnabled
    ^ frameFiltersEnabled

    "Created: / 12-06-2017 / 09:41:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPrettyPrintingEnabled
    ^ prettyPrintingEnabled

    "Created: / 12-06-2017 / 09:40:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger methodsFor:'utilities'!

ensureFeature: feature
    "No-op if this debugger supports given `feature`, otherwise
     throw an error"

    (self hasFeature: feature) ifFalse:[ 
        GDBUnsupportedFeatureError newException
            parameter: self -> feature;
            messageText:'Unssuported feature: ' , feature printString;
            raise.                               
    ].

    "Created: / 07-02-2018 / 11:34:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebugger class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


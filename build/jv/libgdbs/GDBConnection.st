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

Object subclass:#GDBConnection
	instanceVariableNames:'process inferiorPTY eventAnnouncer eventAnnouncerInternal
		eventQueue eventQueueLock eventQueueNotifier eventDispatchProcess
		eventPumpProcess outstandingCommands recorder'
	classVariableNames:''
	poolDictionaries:'GDBDebugFlags'
	category:'GDB-Private'
!

!GDBConnection class methodsFor:'documentation'!

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

!GDBConnection class methodsFor:'instance creation'!

new
    ^ self shouldNotImplement.

    "Created: / 20-06-2014 / 21:45:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWithProcess: aGDBProcess
    ^ self basicNew initializeWithProcess: aGDBProcess

    "Created: / 20-06-2014 / 21:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection methodsFor:'accessing'!

consoleInput
    ^ process consoleInput

    "Created: / 02-06-2017 / 23:34:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    ^ process consoleOutput

    "Created: / 02-06-2017 / 23:35:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eventAnnouncer
    ^ eventAnnouncer
!

eventAnnouncerInternal
    ^ eventAnnouncerInternal

    "Created: / 19-06-2014 / 22:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inferiorPTY
    ^ inferiorPTY
!

nativeTargetFeatures
    ^ process nativeTargetFeatures

    "Created: / 09-04-2018 / 15:40:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recorder
    ^ recorder
!

recorder:aGDBSessionRecorder
    recorder := aGDBSessionRecorder.
!

trace
    "Returns a GDB.MI record (trrace). Used for debugging GDB/MI communication."
    
    ^ self recorder trace

    "Created: / 09-03-2018 / 09:49:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection methodsFor:'commands'!

send: command
    | commandString |

    commandString := command asString.

    outstandingCommands add: command.
    recorder notNil ifTrue:[ 
        recorder recordCommand: commandString
    ].  
    process debuggerInput nextPutLine: commandString.

    "Created: / 20-06-2014 / 22:09:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 22:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection methodsFor:'event dispatching'!

eventDispatchLoop
    "raise an error: this method should be implemented (TODO)"

    [  
        | eventQueueEmpty |

        eventQueueEmpty := false.
        [ eventQueueEmpty ] whileFalse:[
            | event |

            event := nil.
            eventQueueLock critical:[ 
                eventQueueEmpty := eventQueue isEmpty.
                eventQueueEmpty ifFalse:[ 
                    event := eventQueue removeFirst.
                ]
            ].
            eventQueueEmpty ifFalse:[
                (AbortOperationRequest , AbortAllOperationRequest) ignoreIn:[
                    self eventDispatchSingle: event.
                ]
            ].
        ].
        process pid isNil ifTrue:[ 
            "/ gdb process terninated
            (process debuggerOutput isNil or:[ process debuggerOutput atEnd ]) ifTrue:[ 
                "/ No unprocessed output in stream...
                ^ self
            ]
        ]. 
        eventQueueNotifier wait.
    ] loop.

    "Created: / 02-06-2014 / 22:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2014 / 22:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2018 / 21:54:32 / jv"
!

eventDispatchProcess
    ^ eventDispatchProcess
!

eventDispatchSingle: aGDBEvent
    TraceEvents ifTrue:[ 
        Logger log: ('event loop: broadcasting %1 (%2)' bindWith: aGDBEvent class name with: aGDBEvent token) severity: #trace facility: 'GDB' originator: self attachment: aGDBEvent
    ].
    eventAnnouncerInternal announce: aGDBEvent.
    eventAnnouncer announce: aGDBEvent

    "Created: / 02-06-2014 / 22:58:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 09:49:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eventDispatchStart
    eventDispatchProcess isNil ifTrue:[
        eventDispatchProcess := [
                TraceEvents ifTrue:[
                    Logger log: 'event loop: starting' severity: #trace facility: 'GDB'
                ].
                self eventDispatchLoop.
            ] newProcess.
        eventDispatchProcess name:('GDB Event dispatcher (%1)' bindWith:process pid).
        eventDispatchProcess priority:Processor userBackgroundPriority.
        eventDispatchProcess addExitAction:[ 
            eventDispatchProcess := nil. 
            TraceEvents ifTrue:[
                Logger log: 'event loop: terminated' severity: #trace facility: 'GDB'
            ].
        ].
        eventDispatchProcess resume.
    ].

    "Created: / 02-06-2014 / 22:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 21:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eventDispatchStop
    | t |

    t := eventDispatchProcess.
    (t notNil and:[ t isDead not]) ifTrue:[ 
        eventDispatchProcess := nil.
        t terminate.
         "/ raise its prio to make it terminate quickly
        t priority:(Processor userSchedulingPriority + 1)                       
    ].

    "Created: / 02-06-2014 / 22:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection methodsFor:'event pump'!

eventPumpLoop
    | parser done |

    parser := GDBMIParser on:process debuggerOutput.
    parser 
        token2CommandMappingBlock:[:token | 
            | command |

            command := outstandingCommands 
                    detect:[:cmd | cmd token == token ]
                    ifNone:[ nil ].
            command notNil ifTrue:[
                outstandingCommands remove:command
            ].
            command
        ].
    parser recorder:recorder.
    parser parsePostStartHeader.
    done := false.
    [
        [
            done or:[ process debuggerOutput atEnd ]
        ] on: TerminateProcessRequest do:[:request| 
            done := true.    
        ].
    ] whileFalse:[
        | eventset |

        [
            [
                eventset := parser parseOutput.
                (eventset contains:[:each | each isCommandResultEvent and:[ each status == #exit] ]) ifTrue:[ 
                    done := true.
                ].
            ] on:StreamNotOpenError do:[ ^ self. ].
            self pushEventSet:eventset.
        ] on:AbortOperationRequest do:[
            | terminator  i  c |

            terminator := '(gdb)'.
            i := 1.
            process debuggerOutput notNil ifTrue:[
                [
                    process debuggerOutput atEnd not and:[ i <= terminator size ]
                ] whileTrue:[
                    c := process debuggerOutput next.
                    c == (terminator at:i) ifTrue:[
                        i := i + 1.
                    ] ifFalse:[ i := 1. ].
                ].
                process debuggerOutput next.
                "/ read nl.
            ] ifFalse:[ ^ self. ].
        ]
    ]

    "Created: / 02-06-2014 / 22:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 22:22:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eventPumpStart
    eventPumpProcess isNil ifTrue:[
        eventPumpProcess := [
                TraceEvents ifTrue:[
                    Logger log: 'event pump: starting' severity: #trace facility: 'GDB'
                ].
                self eventPumpLoop
            ] newProcess.
        eventPumpProcess name:('GDB Event pump (%1)' bindWith:process pid).
        eventPumpProcess priority:Processor userBackgroundPriority.
        eventPumpProcess addExitAction:[ 
            TraceEvents ifTrue:[
                Logger log: 'event pump: terminated' severity: #trace facility: 'GDB'
            ].
            eventPumpProcess := nil. 
        ].
        eventPumpProcess resume.
    ].

    "Created: / 02-06-2014 / 22:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-06-2014 / 21:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eventPumpStop
    | t |

    t := eventPumpProcess.
    (t notNil and:[ t isDead not]) ifTrue:[ 
        eventPumpProcess := nil.
        t terminate.
         "/ raise its prio to make it terminate quickly
        t priority:(Processor userSchedulingPriority + 1)                       
    ].

    "Created: / 02-06-2014 / 22:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection methodsFor:'events'!

pushEvent: aGDBEvent
    eventQueueLock critical:[
        eventQueue add: aGDBEvent.
        eventQueueNotifier signalForAll.
    ].

    "Created: / 02-06-2014 / 22:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2018 / 10:28:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pushEventSet: aGDBEventSet
    eventQueueLock critical:[
        eventQueue add: (GDBEventSetProcessingStarted new setEventSet: aGDBEventSet).  
        eventQueue addAll: aGDBEventSet.
        eventQueue add: (GDBEventSetProcessingFinished new setEventSet: aGDBEventSet).
        eventQueueNotifier signalForAll.
    ].

    "Created: / 02-06-2014 / 22:42:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2018 / 10:28:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection methodsFor:'initialize & release'!

initializeWithProcess:aGDBProcess 
    process := aGDBProcess.
    OperatingSystem isUNIXlike ifTrue:[
        inferiorPTY := GDBPTY new.
    ].
    eventQueue := OrderedCollection new.
    eventQueueLock := RecursionLock new.
    eventQueueNotifier := Semaphore new.
    eventAnnouncer := Announcer new.
    eventAnnouncer subscriptionRegistry 
        subscriptionClass:GDBEventSubscription.
    eventAnnouncerInternal := Announcer new.
    outstandingCommands := Set new.
    recorder := GDBMITracer new.
    aGDBProcess connection:self.

    "Created: / 20-06-2014 / 21:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2014 / 00:11:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 00:12:25 / jv"
!

release
    | pid |
    pid := process pid.
    (pid notNil and:[pid > 1]) ifTrue:[
        OperatingSystem sendSignal:(OperatingSystem sigTERM) to:process pid.       
    ]

    "Created: / 26-05-2014 / 21:30:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2014 / 22:20:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 15:09:00 / jv"
!

released: status
    self pushEvent: (GDBExitEvent new setStatus: status; setTrace: recorder; yourself).  
    status success ifFalse:[ 
        Logger log: ('gdb process: exited with status %1 code %2' bindWith: status status with: status code)  severity: #error facility: 'GDB'.
    ].
    TraceProcesses ifTrue:[ 
        Logger log: ('gdb process: exited') severity: #trace facility: 'GDB'.
        Logger log: 'gdb process: waiting for event pump to finish' severity: #trace facility: 'GDB'.
    ].
    self eventPumpStop.
    eventQueueNotifier signalForAll.           
    process release.
    inferiorPTY release.

    "Created: / 26-05-2014 / 21:31:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-05-2018 / 22:59:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBConnection class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


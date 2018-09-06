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

GDBProcess subclass:#GDBWindowsProcess
	instanceVariableNames:'debuggerError errorPumpProcess'
	classVariableNames:''
	poolDictionaries:'GDBDebugFlags'
	category:'GDB-Private'
!

!GDBWindowsProcess class methodsFor:'documentation'!

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

!GDBWindowsProcess methodsFor:'accessing'!

nativeTargetFeatures
    ^ #()

    "Created: / 09-04-2018 / 15:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBWindowsProcess methodsFor:'error pump'!

errorPumpLoop
    [ debuggerError atEnd ] whileFalse:[
        debuggerError readWait.
        debuggerError atEnd ifFalse:[
            | line |

            line := debuggerError nextLine.
            line notNil ifTrue:[ 
                Logger log: line severity: #error facility: 'GDB'
            ].
        ].
    ]

    "Created: / 15-01-2018 / 09:31:39 / jv"
!

errorPumpStart
    errorPumpProcess isNil ifTrue:[
        errorPumpProcess := [
                TraceEvents ifTrue:[
                    Logger log: 'error pump: starting' severity: #trace facility: 'GDB'
                ].
                self errorPumpLoop
            ] newProcess.
        errorPumpProcess name:('GDB Error pump (%1)' bindWith:pid pid).
        errorPumpProcess priority:Processor userBackgroundPriority.
        errorPumpProcess addExitAction:[ 
            TraceEvents ifTrue:[
                Logger log: 'error pump: terminated' severity: #trace facility: 'GDB'
            ].
            errorPumpProcess := nil. 
        ].
        errorPumpProcess resume.
    ].

    "Created: / 15-01-2018 / 09:28:06 / jv"
!

errortPumpStop
    | t |

    t := errorPumpProcess.
    (t notNil and:[ t isDead not]) ifTrue:[ 
        errorPumpProcess := nil.
        t terminate.
         "/ raise its prio to make it terminate quickly
        t priority:(Processor userSchedulingPriority + 1)                       
    ].

    "Created: / 15-01-2018 / 09:29:49 / jv"
! !

!GDBWindowsProcess methodsFor:'initialization & release'!

initialize
    | inputPipe  input  outputPipe  output errorPipe error args |

    inputPipe := NonPositionableExternalStream makePipe.
    input := inputPipe second.
    outputPipe := NonPositionableExternalStream makePipe.
    output := outputPipe first.
    errorPipe := NonPositionableExternalStream makePipe.
    error := outputPipe first.
    
    args := (Array new: 7)
             at: 1 put: self class gdbExecutable ? (ExternalAddress pointerSize == 8 ifTrue:['C:\msys64\mingw64\bin\gdb.exe'] ifFalse:['C:\msys64\mingw32\bin\gdb.exe'])  ;
             at: 2 put: '-q';
             at: 3 put: '-nx';
             at: 4 put: '--interpreter';
             at: 5 put: 'mi2';
             at: 6 put: '-ex';
             at: 7 put: 'set new-console on';
             yourself.
    Processor 
        monitor:[
            pid := OperatingSystem 
                    exec:args first
                    withArguments:args
                    environment:OperatingSystem getEnvironment
                    fileDescriptors: (Array
                            with: inputPipe first fileDescriptor
                            with: outputPipe second fileDescriptor
                            with: errorPipe second fileDescriptor
                        )
                    fork:true
                    newPgrp:false
                    inDirectory:Filename currentDirectory
                    showWindow: false.      
            debuggerInput := input.
            debuggerOutput := output.
            debuggerError := error.
            pid.
        ]
        action:[:stat | self exited:stat. ].
    inputPipe first close.
    outputPipe second close.
    errorPipe second close.
    pid isNil ifTrue:[
        input close.
        output close.
        error close.
        self error:'Failed to launch gdb'.
    ].

    "Created: / 12-12-2017 / 21:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 09:35:03 / jv"
    "Modified: / 03-09-2018 / 09:23:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    pid := connection := nil.
    debuggerInput notNil ifTrue:[ debuggerInput close ].
    debuggerOutput notNil ifTrue:[ debuggerOutput close ].

    "Created: / 20-06-2014 / 21:35:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2017 / 23:59:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBWindowsProcess class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

GDBProcess subclass:#GDBUnixProcess
	instanceVariableNames:'debuggerPTY consolePTY'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBUnixProcess class methodsFor:'documentation'!

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

!GDBUnixProcess methodsFor:'accessing'!

consoleInput
    ^ consolePTY master

    "Created: / 02-06-2017 / 23:36:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    ^ consolePTY master

    "Created: / 02-06-2017 / 23:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nativeTargetFeatures
    ^ #('async')

    "Created: / 09-04-2018 / 15:40:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBUnixProcess methodsFor:'initialization & release'!

initialize
    | conpty dbgpty args |

    conpty := GDBPTY new.

    dbgpty := GDBPTY new.
    dbgpty setLocalEcho: false.
    dbgpty setOutputCRLF: false.

    args := (Array new: 6)
                at: 1 put: self class gdbExecutable ? '/usr/bin/gdb';
                at: 2 put: '-q';
                at: 3 put: '-ex';
                at: 4 put: 'new-ui mi ', dbgpty name;
                at: 5 put: '-ex';
                at: 6 put: 'set pagination off';
                yourself.
    Processor
        monitor:[
            pid := OperatingSystem
                    exec:args first
                    withArguments:args
                    environment:OperatingSystem getEnvironment
                    fileDescriptors:{
                            conpty slave fileDescriptor.
                            conpty slave fileDescriptor.
                            conpty slave fileDescriptor
                        }
                    fork:true
                    newPgrp:false
                    inDirectory:Filename currentDirectory
                    showWindow: false.
            consolePTY := conpty.
            debuggerPTY := dbgpty.
            debuggerInput := debuggerOutput := debuggerPTY master.
            pid.
        ]
        action:[:stat | self exited:stat ].
    pid isNil ifTrue:[
        conpty close.
        dbgpty close.
        self error:'Failed to launch gdb'.
    ].

    "Modified: / 03-09-2018 / 09:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    debuggerPTY notNil ifTrue:[
        debuggerPTY release.
        debuggerInput := debuggerOutput := nil
    ].
    consolePTY notNil ifTrue:[
        consolePTY release.
    ].
    super release

    "Created: / 02-06-2017 / 23:33:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2017 / 23:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBUnixProcess class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


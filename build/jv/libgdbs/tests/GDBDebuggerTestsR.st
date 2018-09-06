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
"{ Package: 'jv:libgdbs/tests' }"

"{ NameSpace: Smalltalk }"

GDBDebuggerTestCase subclass:#GDBDebuggerTestsR
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Tests'
!

!GDBDebuggerTestsR class methodsFor:'documentation'!

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
!

documentation
"
    Tests for GDBDebugger (using real test programs)         

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!GDBDebuggerTestsR class methodsFor:'accessing'!

resources
    ^ Array with: GDBDebuggeesResource

    "Created: / 28-02-2015 / 00:45:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebuggerTestsR methodsFor:'tests - basic'!

test_02
    | inferior1 thread1 frame1 frame2  seqNo1 seqNo2 |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    debugger send: 'b factorial'.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.

    self assert: debugger inferiors size == 1.
    inferior1 := debugger inferiors anElement.
    "/ Windows (starting with Windows 10) introduced a new
    "/ multi-threaded program loader so it can load .dll
    "/ faster, supposedly. Therefore there may be couple other
    "/ threads. Hence in windows, only assert that there is
    "/ at least on thread.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        self assert: inferior1 threads notEmpty.
    ] ifFalse:[ 
        self assert: inferior1 threads size == 1
    ].
    thread1 := inferior1 threads anElement.
    self assert: thread1 stack size == 2.
    self assert: thread1 status isStopped.
    frame1 := thread1 stack first.
    frame2 := thread1 stack second.
    self assert: frame1 variables size == 1.
    self assert: frame1 variables first name = 'i'.
    self assert: frame1 variables first value = '5'.


    self assert: frame2 variables size == 4.
    self assert: frame2 variables first name = 'argc'.
    self assert: frame2 variables second name = 'argv'.
    self assert: frame2 variables third name = 'i'.
    self assert: frame2 variables fourth name = 'f'.

    seqNo1 := debugger currentInferiorStateSequnceNumber.

    debugger send: 'd'.
    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.

    self assert: thread1 isDead.
    seqNo2 := debugger currentInferiorStateSequnceNumber.
    self assert: seqNo1 ~~ seqNo2.

    debugger send: 'quit' andWait: false.

    "Created: / 28-02-2015 / 00:55:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2018 / 09:23:24 / jv"
!

test_03
    | inferior1 thread1 |

    self skipIf: OperatingSystem isMSWINDOWSlike  description: 'Skipped since we cannot interact with inferor on Windows (no TTY support)'.

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryPressAnyKey.

    debugger send: (GDBMI_exec_run new).

    self assert: debugger inferiors size == 1.
    inferior1 := debugger inferiors anElement.
    self assert: inferior1 threads size == 1.
    thread1 := inferior1 threads anElement.
    self assert: thread1 isRunning.

    debugger send: (GDBMI_exec_interrupt new arguments: #('--all')) andWaitFor: GDBStoppedEvent.

    self assert: thread1 isRunning not.

    debugger inferiorStdin nextPutLine:'X'.  

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.

    debugger send: 'quit' andWait: false

    "Created: / 08-03-2015 / 07:42:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 22:30:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 14:53:19 / jv"
!

test_basic_01
    | timeToExit eventPumpProcess eventDispatchProcess|

    debugger := GDBDebugger new.
    timeToExit := 0.
    eventPumpProcess := (debugger instVarNamed: #connection) instVarNamed: #eventPumpProcess.
    eventDispatchProcess := (debugger instVarNamed: #connection) instVarNamed: #eventDispatchProcess.
    self assert: debugger isConnected.
    self assert: eventPumpProcess isDead not.
    self assert: eventDispatchProcess isDead not.
    debugger send: (GDBMI_gdb_exit new) andWait: false.      
    [ debugger isConnected and:[timeToExit < 2000] ] whileTrue:[
        Logger trace:'Still connected...'.
        Delay waitForMilliseconds: 200.  
        timeToExit := timeToExit + 200.
    ].
    self assert: timeToExit < 2000.
    self assert: debugger isConnected not.
    self assert: eventPumpProcess isDead.
    self assert: eventDispatchProcess isDead.

    "Created: / 24-06-2014 / 09:06:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2017 / 22:42:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 15:29:08 / jv"
!

test_breakpoints_01a
    |  |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b factorial'.
    self assert: debugger breakpoints size == 1.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints first func = 'factorial'.


    debugger send: 'del'.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'quit' andWait: false.

    "Created: / 07-07-2017 / 12:25:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_breakpoints_01b
    |  |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b factorial'.
    self assert: debugger breakpoints size == 1.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints first func = 'factorial'.


    debugger send: 'dis ', debugger breakpoints anElement number printString.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints anElement enabled == false.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.

    debugger send: 'quit' andWait: false.

    "Created: / 07-07-2017 / 12:27:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_breakpoints_01c
    |  |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b factorial'.
    self assert: debugger breakpoints size == 1.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints first func = 'factorial'.


    debugger breakpoints anElement enabled: false.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints anElement enabled == false.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.

    debugger send: 'quit' andWait: false.

    "Created: / 07-07-2017 / 12:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_breakpoints_03a

    self skipIf: OperatingSystem isMSWINDOWSlike  description: 'Skipped since we don;t have separate console TTY (no TTY support)'.

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger consoleInput nextPutLine: 'b factorial'.
    Delay waitForSeconds: 1.  
    self assert: debugger breakpoints size == 1.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints first func = 'factorial'.


    debugger consoleInput nextPutLine: 'del 1'.
    Delay waitForSeconds: 1.  
    self assert: debugger breakpoints isEmpty.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'quit' andWait: false.

    "Created: / 10-07-2017 / 22:05:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 11:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 14:57:37 / jv"
!

test_breakpoints_04a
    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b factorial'.
    self assert: debugger breakpoints size == 1.

    debugger breakpoints first script: 'printf "factorial\n"
disable ', debugger breakpoints first number asString.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    self assert: debugger breakpoints size == 1.
    "/ We need to wait a until breakpoint-modifed
    "/ event is received.
    Delay waitForMilliseconds: 200.  
    self assert: debugger breakpoints first enabled == false.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.

    debugger send: 'quit' andWait: false.

    "Created: / 11-07-2017 / 20:35:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 11-07-2017 / 23:31:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_breakpoints_05a
    "
    This tests breakpoints with multiple locations. Due to a bug in
    GDB (up to 8.1), this test fails with stock GDB.

    Patches has been sent to GDB, see:

        * https://sourceware.org/ml/gdb/2018-05/msg00024.html
        * https://sourceware.org/ml/gdb-patches/2018-05/msg00836.html

    Meanwhile, this test is skipped.
    "    

    self skipIf: true description: 'Known to fail due to a bug in GDB'.
        debugger := GDBDebugger new.

    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryBreakpoints1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b add'.
    self assert: debugger breakpoints size == 1.
    self assert: debugger breakpoints first locations size > 1.
    self assert: debugger breakpoints first enabled.
    self assert: debugger breakpoints first locations first enabled.

    debugger send: 'dis 1'.
    debugger send: 'dis 1.1'.
    self assert: debugger breakpoints first enabled not.
    self assert: debugger breakpoints first locations first enabled not.

    debugger send: 'en 1'.
    debugger send: 'en 1.1'.
    self assert: debugger breakpoints first enabled.
    self assert: debugger breakpoints first locations first enabled.

    debugger breakpoints first enabled: false.
    debugger breakpoints first locations first enabled: false.    
    self assert: debugger breakpoints first enabled not.
    self assert: debugger breakpoints first locations first enabled not.    

    debugger breakpoints first enabled: true.
    debugger breakpoints first locations first enabled: true.    
    self assert: debugger breakpoints first enabled.
    self assert: debugger breakpoints first locations first enabled.    

    debugger send: 'del 1'.
    self assert: debugger breakpoints size == 0.

    debugger send: 'quit' andWait: false.

    "Created: / 18-05-2018 / 10:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2018 / 10:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_directories
    | directories current |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    directories := debugger directories.
    self assert: directories isArray.
    self assert: directories notEmpty.

    "/ GDB uses cygwin paths, so convert Windows path to Cygwin paths
    "/ on Windows.
    OperatingSystem isMSWINDOWSlike ifTrue:[ 
        current := Filename currentDirectory cygName
    ] ifFalse:[ 
        current := Filename currentDirectory pathName
    ].

    debugger send: ('set directories "%1"' bindWith: current).
    directories := debugger directories.
    self assert: directories isArray.
    self assert:(directories includes: Filename currentDirectory pathName).

    "Created: / 09-03-2018 / 12:28:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2018 / 21:08:26 / jv"
!

test_disassembly_01
    | asm |

    debugger := GDBDebugger new.
    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    debugger send: 'r' andWaitFor: GDBThreadGroupExitedEvent.

    asm := debugger disassembleFile: 'factorial1.c' line: 3 count: nil.

    self assert: asm isSequenceable.
    self assert:(asm first isKindOf: GDBInstructionsAndSourceLine).

    debugger send: 'quit' andWait: false.

    "Created: / 22-06-2018 / 11:52:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_features

    debugger := GDBDebugger new.
    self assert: debugger isConnected.
    self assert: debugger features isArray.
    self assert: debugger features notEmpty.
    self assert: (debugger hasFeature: debugger features anyOne).
    self assert: (debugger hasFeature: 'bla bla') not.
    self shouldnt:[ debugger ensureFeature: debugger features anyOne ] raise: Error.
    self should:  [ debugger ensureFeature: 'bla bla' ] raise: GDBUnsupportedFeatureError.
    debugger send: 'quit' andWait: false.

    "Created: / 07-02-2018 / 10:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stack_01a
    "Tests that stack frames object are preserved amonh run/stop cycles
     if they 're still valid"

    | stack1 stack2 |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.
    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    debugger send: 'b factorial'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.

    stack1 := debugger selectedInferior threads first stack.
    debugger send: 'c' andWaitFor: GDBStoppedEvent.
    stack2 := debugger selectedInferior threads first stack.
    self assert: stack1 size == 2.
    self assert: stack2 size == 3.
    self assert: stack1 first  == stack2 second.
    self assert: stack1 second == stack2 third.
    self assert: stack2 first line == 4.
    self assert: stack2 second line == 7.

    stack1 := debugger selectedInferior threads first stack.
    debugger send: 'c' andWaitFor: GDBStoppedEvent.
    stack2 := debugger selectedInferior threads first stack.
    self assert: stack1 size == 3.
    self assert: stack2 size == 4.
    self assert: stack1 first  == stack2 second.
    self assert: stack1 second == stack2 third.
    self assert: stack1 third == stack2 fourth.
    self assert: stack2 first line == 4.
    self assert: stack2 second line == 7.
    self assert: stack2 third line == 7.


    debugger send: 'd'.
    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 06-08-2018 / 15:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stack_01b
    "Tests that stack frames object are preserved amonh run/stop cycles
     if they 're still valid"

    | stack1 pc1 stack2 pc2 |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.
    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    debugger send: 'b factorial'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.

    stack1 := debugger selectedInferior threads first stack.
    pc1 := stack1 first address.
    debugger send: 'stepi' andWaitFor: GDBStoppedEvent.
    stack2 := debugger selectedInferior threads first stack.
    pc2 := stack2 first address.
    self assert: stack1 size == 2.
    self assert: stack2 size == 2.
    self assert: pc1 ~= pc2.
    self assert: stack1 first  == stack1 first.
    self assert: stack1 second == stack2 second.

    debugger send: 'd'.
    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 06-08-2018 / 15:07:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stack_02
    | stack1 stack2 |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.
    debugger executable: GDBDebuggeesResource current binaryVariables1.
    debugger send: 'b set_data_i'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.

    stack1 := debugger selectedInferior threads first stack.
    debugger send: 'c' andWaitFor: GDBStoppedEvent.
    stack2 := debugger selectedInferior threads first stack.
    self assert: stack1 size == 2.
    self assert: stack2 size == 2.
    self assert: stack1 first ~~ stack2 first.

    debugger send: 'd'.
    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 12-02-2018 / 21:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2018 / 09:16:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_stack_03
    "Tests that CLI commands 'up', 'down' and 'frame' emit GDBThreadSelected event
     and its thread and frame is properly set."

    | stack2 selection |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.
    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    debugger send: 'b factorial'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    debugger send: 'c' andWaitFor: GDBStoppedEvent.

    stack2 := debugger selectedInferior threads first stack.
    debugger announcer when: GDBThreadSelectedEvent do: [:e | selection := e ].
    selection := nil.
    debugger send: 'up'.
    self assert: selection notNil.
    self assert: selection thread == debugger selectedInferior threads first.
    self assert: selection frame == stack2 second.

    debugger send: 'down'.
    self assert: selection notNil.
    self assert: selection thread == debugger selectedInferior threads first.
    self assert: selection frame == stack2 first.

    debugger send: 'frame 2'.
    self assert: selection notNil.
    self assert: selection thread == debugger selectedInferior threads first.
    self assert: selection frame == stack2 third.

    "Created: / 30-07-2018 / 07:07:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_01
    | thread frame variables d |

    debugger := GDBDebugger new.
    debugger executable: GDBDebuggeesResource current binaryVariables1.

    debugger send: 'b main'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    debugger send: 's' andWaitFor: GDBStoppedEvent.

    thread := debugger selectedInferior threads first.
    frame := thread stack first.
    variables :=  frame variables.

    self assert: variables size = 3. "/ argc, argv, d.
    self assert: variables first name = 'argc'.
    self assert: variables first varobj expression = 'argc'.
    self assert: variables first varobj thread == thread.
    self assert: variables first varobj frame == frame.

    self assert: variables second name = 'argv'.
    self assert: variables second varobj expression = 'argv'.

    self assert: variables third name = 'd'.
    self assert: variables third varobj expression = 'd'.

    d := variables third varobj.
    self assert: d hasChildren.
    self assert: d children size = 3.

    self assert: d children first parent == d.
    self assert: d children first hasChildren not.
    self assert: d children first children = #().
    self assert: d children first expression = 'i'.
    self assert: d children first value = '1'.
    self assert: d children first thread == thread.
    self assert: d children first frame == frame.
    

    self assert: d children third hasChildren.
    self assert: d children third children size = 2.
    self assert: d children third children first expression = 'as_i'.
    self assert: d children third children second expression = 'as_f'.

    self assert: d children third children first hasChildren.
    self assert: d children third children first children size = 2.
    self assert: d children third children first children first expression = 'a'.
    self assert: d children third children first children first value = '10'.
    self assert: d children third children first children second expression = 'b'.
    self assert: d children third children first children second value = '20'.
    
    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 30-01-2018 / 10:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2018 / 22:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_02
    "
    This test ensures that GDBVariable objects are preserved
    across multiple run-stop cycles
    "    
    | variables1 variables2 |

    debugger := GDBDebugger new.
    debugger executable: GDBDebuggeesResource current binaryVariables1.

    debugger send: 'b main'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    debugger send: 's' andWaitFor: GDBStoppedEvent.

    variables1 := debugger selectedInferior threads first stack first variables.
    debugger send: 'next' andWaitFor: GDBStoppedEvent.
    variables2 := debugger selectedInferior threads first stack first variables.

    self assert: variables1 size = 3.
    self assert: variables2 size = 3.
    variables1 with: variables2 do:[:var1 :var2 | 
        self assert: var1 == var2    
    ].

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 01-02-2018 / 21:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_03
    "
    This test tests GDBVariableObject >> hasChanged
    " 
    | variables d d_i |

    debugger := GDBDebugger new.
    debugger executable: GDBDebuggeesResource current binaryVariables1.

    debugger send: 'b set_data_i'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    debugger send: 'del'.

    self assert: debugger selectedInferior threads first stack second func = 'main'.
    variables := debugger selectedInferior threads first stack second variables.
    self assert: variables third name = 'd'.
    self assert: variables third varobj expression = 'd'.   
    d := variables third varobj.
    self assert: d hasChildren.
    self assert: d expression = 'd'.
    self assert: d children size = 3.   
    d_i := d children first.
    self assert: d_i expression = 'i'.
    self assert: d_i value = '1'.
    self assert: d_i hasChanged not.
    self assert: d_i hasChildren not .   

    debugger selectFrame: debugger selectedInferior threads first stack first.
    debugger send: 'finish' andWaitFor: GDBStoppedEvent.
    self assert: debugger selectedInferior threads first stack first func = 'main'.
    self assert: d_i value = '12'.
    self assert: d_i hasChanged.
    self assert: d_i hasChanged.
    self assert: d_i hasChanged.

    debugger send: 's' andWaitFor: GDBStoppedEvent.
    self assert: d_i value = '12'.
    self assert: d_i hasChanged not.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 01-02-2018 / 21:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:36:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_04
    "
    Tests that the variable object get's invalid after
    inferior terminated.
    " 
    | variables d d_as_i_a events seqNo1 seqNo2 |

    debugger := GDBDebugger new.
    events := OrderedCollection new.
    debugger announcer when: GDBEvent send: #add: to: events.

    debugger executable: GDBDebuggeesResource current binaryVariables1.


    debugger send: 'b set_data_i'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    seqNo1 := debugger currentInferiorStateSequnceNumber.

    self assert: debugger selectedInferior threads first stack second func = 'main'.
    variables := debugger selectedInferior threads first stack second variables.
    d := variables third varobj.
    self assert: d expression = 'd'.
    self assert: d isValid.
    d_as_i_a := d children third children first children first.
    self assert: d_as_i_a expression = 'a'.
    self assert: d_as_i_a isValid.

    debugger send: 'dis 1'. 
    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    seqNo2 := debugger currentInferiorStateSequnceNumber.

    self assert: seqNo1 ~~ seqNo2.
    self assert: d isValid not.
    self assert: d value = '<invalid>'.
    self assert: d children isEmpty.
    self assert: d_as_i_a isValid not.    
    self assert: d_as_i_a value = '<invalid>'.
    self assert: debugger isConnected.

    debugger send: 'quit' andWait: false.

    "Created: / 04-02-2018 / 22:04:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2018 / 10:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_05
    "
    Tests that the variable object get's invalid after
    frame returned
    " 
    | variables d |

    debugger := GDBDebugger new.
    debugger executable: GDBDebuggeesResource current binaryVariables1.

    debugger send: 'b set_data_i'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.

    self assert: debugger selectedInferior threads first stack first func = 'set_data_i'.
    variables := debugger selectedInferior threads first stack first variables.
    d := variables second varobj.
    self assert: d expression = 'i'.
    self assert: d isValid.
    self assert: d inScope.

    debugger send: 'finish' andWaitFor: GDBStoppedEvent.

    self assert: d isValid.
    self assert: d inScope not.
    self assert: d hasChanged.
    self assert: d value = '<out-of-scope>'.

    debugger send: 'continue' andWaitFor: GDBStoppedEvent.  

    self assert: d isValid.
    self assert: d inScope.
    self assert: d hasChanged.
    self assert: d value = '24'.
    self assert: debugger isConnected.

    debugger send: 'quit' andWait: false.

    "Created: / 12-02-2018 / 21:34:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_06
    "
    This test tests GDBVariableObject >> duplicate
    " 
    | variables d1 d_i1 d_i2 |

    debugger := GDBDebugger new.
    debugger executable: GDBDebuggeesResource current binaryVariables1.

    debugger send: 'b set_data_i'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    debugger send: 'del'.

    self assert: debugger selectedInferior threads first stack second func = 'main'.
    variables := debugger selectedInferior threads first stack second variables.
    self assert: variables third name = 'd'.
    self assert: variables third varobj expression = 'd'.   
    d1 := variables third varobj.
    self assert: d1 hasChildren.
    self assert: d1 expression = 'd'.
    self assert: d1 children size = 3.   
    d_i1 := d1 children first.
    self assert: d_i1 expression = 'i'.
    self assert: d_i1 value = '1'.
    self assert: d_i1 hasChanged not.
    self assert: d_i1 hasChildren not .

    d_i2 := d_i1 duplicate.
    self assert: d_i2 expression = '(d).i'.
    self assert: d_i2 path = '(d).i'.
    self assert: d_i2 value = '1'.
    self assert: d_i2 hasChanged not.
    self assert: d_i2 hasChildren not .
    

    debugger selectFrame: debugger selectedInferior threads first stack first.
    debugger send: 'finish' andWaitFor: GDBStoppedEvent.
    self assert: debugger selectedInferior threads first stack first func = 'main'.
    self assert: d_i2 value = '12'.
    self assert: d_i2 hasChanged.
    self assert: d_i2 hasChanged.
    self assert: d_i2 hasChanged.

    debugger send: 's' andWaitFor: GDBStoppedEvent.
    self assert: d_i2 value = '12'.
    self assert: d_i2 hasChanged not.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    debugger send: 'quit' andWait: false.

    "Created: / 13-02-2018 / 22:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_07
    | stack v1 v2 v3 |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b factorial'.
    self assert: debugger breakpoints size == 1.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    debugger send: 'c' andWaitFor: GDBStoppedEvent.

    stack := debugger selectedInferior threads first stack.   

    debugger selectFrame: stack third.
    v1 := debugger evaluate: 'i'  in: stack first.
    v2 := debugger evaluate: 'i'  in: stack second.
    self assert: v1 value = '4'.
    self assert: v2 value = '5'.

    debugger selectFrame: stack first.
    v3 := debugger evaluate: 'i'.
    self assert: v3 value = '4'.  

    debugger send: 'del'.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'quit' andWait: false.

    "Created: / 20-03-2018 / 22:32:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_08
    "
    This tests -var-info-path-expression on dynamic varobjs.
    "
    | c1 c1_cdr c1_cdr_cdr |



    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryPyVarobj.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'source ', ((Smalltalk getPackageDirectoryForPackage:self class package)
            / 'c' / 'py-varobj.py') pathName.
    debugger enablePrettyPrinting.
    debugger send: 'b py-varobj.c:22'.
    debugger send: 'r'.

    c1 := debugger evaluate: '&c1'.
    self assert: c1 isDynamic.
    self assert: c1 path = '&c1'.

    c1_cdr := c1 children second.
    self assert: c1_cdr expression = 'cdr'.
    self assert: c1_cdr isDynamic.
    self assert: c1_cdr parent == c1.
    self should: [ c1_cdr path ] raise: GDBError.

    c1_cdr_cdr := c1_cdr children second.
    self assert: c1_cdr_cdr expression = 'cdr'.
    self assert: c1_cdr_cdr isDynamic.
    self assert: c1_cdr_cdr parent == c1_cdr.
    self should: [ c1_cdr_cdr path ] raise: GDBError.      

    debugger send: 'quit' andWait: false.

    "Created: / 01-06-2018 / 16:27:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-06-2018 / 11:02:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_09
    "
    Test #duplicate on children of a dynamic varobj
    "
    | c1 c1_cdr c1_cdr_d  c1_cdr_d_cdr c1_cdr_d_cdr_d |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryPyVarobj.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'source ', ((Smalltalk getPackageDirectoryForPackage:self class package)
            / 'c' / 'py-varobj.py') pathName.
    debugger enablePrettyPrinting.
    debugger send: 'b py-varobj.c:22'.
    debugger send: 'r'.

    c1 := debugger evaluate: '&c1'.
    self assert: c1 isDynamic.
    self assert: c1 path = '&c1'.

    c1_cdr := c1 children second.
    self assert: c1_cdr expression = 'cdr'.
    self assert: c1_cdr isDynamic.
    self assert: c1_cdr parent == c1.

    c1_cdr_d := c1_cdr duplicate.
    self assert: c1_cdr_d ~= c1_cdr.
    self assert: c1_cdr_d parent ~= c1_cdr parent.

    c1_cdr_d_cdr := c1_cdr_d children second.
    self assert: c1_cdr_d_cdr expression = 'cdr'.
    self assert: c1_cdr_d_cdr isDynamic.
    self assert: c1_cdr_d_cdr parent == c1_cdr_d
.
    c1_cdr_d_cdr_d := c1_cdr_d_cdr duplicate.
    self assert: c1_cdr_d_cdr_d ~= c1_cdr_d_cdr.
    self assert: c1_cdr_d_cdr_d parent ~= c1_cdr_d_cdr parent.

    debugger send: 'quit' andWait: false.

    "Created: / 04-06-2018 / 15:08:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_variables_10a
    "
    Test 'synthatic' variables
    "
    | stack |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'source ', ((Smalltalk getPackageDirectoryForPackage:self class package)
            / 'c' / 'py-framedecorator.py') pathName.
    debugger enableFrameFilters.
    debugger send: 'b factorial'.
    debugger send: 'r' andWaitFor: GDBStoppedEvent.

    stack := debugger selectedInferior threads first stack.
    self assert: stack first variables size == 7.
    self assert: stack first variables first name = 'syntheticArg0'.
    self assert: stack first variables first varobj isNil.
    self assert: stack first variables fourth name = 'i'.
    self assert: stack first variables fourth varobj notNil.
    "
    VDBFrameApplication new
        debugger: debugger;
        frame: stack first;
        open.
    "
    debugger send: 'quit' andWait: false.

    "Created: / 05-07-2018 / 11:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBDebuggerTestsR class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


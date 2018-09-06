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

TestCase subclass:#GDBDebuggerTestCase
	instanceVariableNames:'debugger'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Tests'
!

!GDBDebuggerTestCase class methodsFor:'documentation'!

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

!GDBDebuggerTestCase class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == GDBDebuggerTestCase.
! !

!GDBDebuggerTestCase methodsFor:'running'!

tearDown
    (debugger notNil and:[ debugger isConnected ]) ifTrue:[ 
        debugger send: 'quit' andWait: false.
    ].

    "Created: / 19-01-2018 / 09:18:42 / jv"
! !

!GDBDebuggerTestCase methodsFor:'tests - basic'!

test_breakpoints_02
    |  |

    debugger := GDBDebugger new.
    self assert: debugger isConnected.

    debugger executable: GDBDebuggeesResource current binaryFactorial1.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'b main'.
    self assert: debugger breakpoints size == 1.

    debugger send: 'r' andWaitFor: GDBStoppedEvent.
    self assert: debugger breakpoints size == 1.

    debugger send: 'del'.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'c' andWaitFor: GDBThreadGroupExitedEvent.
    self assert: debugger breakpoints isEmpty.

    debugger send: 'quit' andWait: false.

    "Created: / 07-07-2017 / 11:53:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 22:04:46 / jv"
! !

!GDBDebuggerTestCase class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

SharedPool subclass:#GDBFeatures
	instanceVariableNames:''
	classVariableNames:'DebuggerFeatureFrozenVarObjs DebuggerFeaturePendingBreakpoint
		DebuggerFeaturePython DebuggerFeatureThreadInfo
		DebuggerFeatureDataReadMemoryBytes
		DebuggerFeatureBreakpointNotifications DebuggerFeatureAdaTaskInfo
		DebuggerFeatureLanguageOption DebuggerFeatureInfoGDBMICommand
		DebuggerFeatureUndefinedCommandErrorCode
		DebuggerFeatureExecRunStartOption TargetFeatureAsync
		TargetFeatureReverse'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBFeatures class methodsFor:'documentation'!

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
    A set of GDB features. Use this in `#ensureFeature:` and `#hasFeature:`

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Support-Commands.html, -list-features

"
! !

!GDBFeatures class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    DebuggerFeatureFrozenVarObjs := 'frozen-varobjs'.
    DebuggerFeaturePendingBreakpoint := 'pending-breakpoints' .
    DebuggerFeaturePython := 'python'.
    DebuggerFeatureThreadInfo := 'thread-info' .
    DebuggerFeatureDataReadMemoryBytes := 'data-read-memory-bytes' .
    DebuggerFeatureBreakpointNotifications := 'breakpoint-notifications' .
    DebuggerFeatureAdaTaskInfo := 'ada-task-info' .
    DebuggerFeatureLanguageOption := 'language-option' .
    DebuggerFeatureInfoGDBMICommand := 'info-gdb-mi-command' .
    DebuggerFeatureUndefinedCommandErrorCode := 'undefined-command-error-code' .
    DebuggerFeatureExecRunStartOption := 'exec-run-start-option' .
    TargetFeatureAsync := 'async'.
    TargetFeatureReverse := 'reverse'.

    "Modified: / 07-02-2018 / 12:51:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


GDBFeatures initialize!

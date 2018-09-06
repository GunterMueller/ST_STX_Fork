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

SharedPool subclass:#GDBStopReasons
	instanceVariableNames:''
	classVariableNames:'SignalReceived BreakpointHit WatchpointTrigger EndSteppingRange'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBStopReasons class methodsFor:'documentation'!

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

!GDBStopReasons class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    SignalReceived := 'signal-received'.
    BreakpointHit := 'breakpoint-hit'.
    WatchpointTrigger := 'watchpoint-trigger'.
    EndSteppingRange := 'end-stepping-range'.

    "Modified: / 31-08-2018 / 23:18:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


GDBStopReasons initialize!

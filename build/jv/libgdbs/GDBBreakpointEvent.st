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

GDBNotificationEvent subclass:#GDBBreakpointEvent
	instanceVariableNames:'bkpt'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBBreakpointEvent class methodsFor:'documentation'!

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

!GDBBreakpointEvent class methodsFor:'accessing - GDB value descriptors'!

description
    | desc bkpt |

    desc := super description.
    bkpt := desc define:#bkpt as:Array of: GDBBreakpoint.
    bkpt allowOmmitedBrackets: true.
    ^ desc

    "Created: / 06-09-2014 / 01:52:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2017 / 17:21:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpointEvent methodsFor:'accessing'!

breakpoints
    ^ bkpt

    "Created: / 12-11-2017 / 20:16:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpointEvent methodsFor:'accessing-properties'!

_bkpt: aCollection
    bkpt := aCollection

    "Created: / 12-11-2017 / 17:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2017 / 20:33:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


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

GDBInternalEvent subclass:#GDBExitEvent
	instanceVariableNames:'status trace'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBExitEvent class methodsFor:'documentation'!

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

!GDBExitEvent methodsFor:'accessing'!

status
    "Return the GDB process exit status (if known)"

    ^ status

    "Modified (comment): / 04-02-2018 / 20:24:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trace
    ^ trace
! !

!GDBExitEvent methodsFor:'initialization'!

setStatus: anOSProcessStatus
    status := anOSProcessStatus

    "Created: / 04-02-2018 / 20:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setTrace: GDBMITrace
    trace:= GDBMITrace

    "Created: / 28-05-2018 / 22:58:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBExitEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


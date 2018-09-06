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

GDBEvent subclass:#GDBCommandResultEvent
	instanceVariableNames:'result'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Events'
!

!GDBCommandResultEvent class methodsFor:'documentation'!

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

!GDBCommandResultEvent methodsFor:'accessing'!

result
    ^ result
!

result:something
    result := something.
!

status
    ^ result status

    "Created: / 04-06-2014 / 09:30:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommandResultEvent methodsFor:'displaying'!

displayString
    ^ '%1 [finished, %2]' bindWith: result command asString with: result status

    "Created: / 01-03-2015 / 08:56:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommandResultEvent methodsFor:'testing'!

isCommandResultEvent
    ^ true
! !

!GDBCommandResultEvent class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


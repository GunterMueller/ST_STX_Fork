"{ Encoding: utf8 }"

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

GDBDebuggerObject subclass:#GDBVariableObjectChange
	instanceVariableNames:'name value in_scope type_changed new_type new_num_children
		displayhint has_more dynamic new_children'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBVariableObjectChange class methodsFor:'documentation'!

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

!GDBVariableObjectChange class methodsFor:'*magritte-model-accessing'!

description
    ^ super description
        define: #in_scope as: Boolean;
        yourself

    "Created: / 12-02-2018 / 22:11:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObjectChange methodsFor:'accessing'!

id
    ^ name

    "Created: / 29-01-2018 / 22:01:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value
    ^ value
! !

!GDBVariableObjectChange methodsFor:'testing'!

inScope
    "Return true, if variable object’s current value is valid. false otherwise.
     If `false` is returned, variable object does not currently hold a valid value 
     but it may hold one in the future if its associated expression comes back 
     into scope."

    ^ in_scope

    "Created: / 12-02-2018 / 22:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInvalid
    "Return true, of the variable object no longer holds a valid value. 
     This can occur when the executable file being debugged has changed, 
     either through recompilation or by using the GDB file command. The 
     front end should normally choose to delete these variable objects."

    ^ in_scope = 'invalid'

    "Created: / 29-01-2018 / 22:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


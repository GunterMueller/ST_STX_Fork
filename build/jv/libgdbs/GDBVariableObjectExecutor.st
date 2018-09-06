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

GDBDebuggerObject subclass:#GDBVariableObjectExecutor
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBVariableObjectExecutor class methodsFor:'documentation'!

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

!GDBVariableObjectExecutor methodsFor:'finalization'!

finalize
    debugger isConnected ifTrue:[
        debugger send: (GDBMI_var_delete arguments: (Array with: '-c' with: name))
    ].

    "Created: / 28-01-2018 / 23:26:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-02-2018 / 23:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObjectExecutor methodsFor:'initialization'!

setId: aString
    name := aString

    "Created: / 28-01-2018 / 23:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBVariableObjectExecutor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


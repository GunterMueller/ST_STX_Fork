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

GDBMICommand subclass:#GDBMI_target_attach
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_target_attach class methodsFor:'documentation'!

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
The `-target-attach' Command
----------------------------

Synopsis
........

      -target-attach PID | GID | FILE

   Attach to a process PID or a file FILE outside of {No value for
`GDBN'}, or a thread group GID.  If attaching to a thread group, the id
previously returned by `-list-thread-groups --available' must be used.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `attach'.

Example
.......

     (gdb)
     -target-attach 34
     =thread-created,id='1'
     *stopped,thread-id='1',frame={addr='0xb7f7e410',func='bar',args=[]}
     ^done
     (gdb)


"
! !

!GDBMI_target_attach methodsFor:'accessing'!

operation
	^ 'target-attach'
! !

!GDBMI_target_attach class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


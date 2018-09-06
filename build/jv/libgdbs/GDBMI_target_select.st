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

GDBMICommand subclass:#GDBMI_target_select
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_target_select class methodsFor:'documentation'!

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
The `-target-select' Command
----------------------------

Synopsis
........

      -target-select TYPE PARAMETERS ...

   Connect {No value for `GDBN'} to the remote target.  This command
takes two args:

`TYPE'
     The type of target, for instance `remote', etc.

`PARAMETERS'
     Device names, host names and the like.  *Note Commands for
     Managing Targets: Target Commands, for more details.

   The output is a connection notification, followed by the address at
which the target program is, in the following form:

     ^connected,addr='ADDRESS',func='FUNCTION NAME',
       args=[ARG LIST]

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `target'.

Example
.......

     (gdb)
     -target-select remote /dev/ttya
     ^connected,addr='0xfe00a300',func='??',args=[]
     (gdb)


"
! !

!GDBMI_target_select methodsFor:'accessing'!

operation
	^ 'target-select'
! !


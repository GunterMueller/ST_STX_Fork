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

GDBMICommand subclass:#GDBMI_exec_next_instruction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_next_instruction class methodsFor:'documentation'!

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
The `-exec-next-instruction' Command
------------------------------------

Synopsis
........

      -exec-next-instruction [--reverse]

   Executes one machine instruction.  If the instruction is a function
call, continues until the function returns.  If the program stops at an
instruction in the middle of a source line, the address will be printed
as well.

   If the `--reverse' option is specified, resumes reverse execution of
the inferior program, stopping at the previous instruction.  If the
previously executed instruction was a return from another function, it
will continue to execute in reverse until the call to that function
(from the current stack frame) is reached.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `nexti'.

Example
.......

     (gdb)
     -exec-next-instruction
     ^running

     (gdb)
     *stopped,reason='end-stepping-range',
     addr='0x000100d4',line='5',file='hello.c'
     (gdb)


"
! !

!GDBMI_exec_next_instruction methodsFor:'accessing'!

operation
	^ 'exec-next-instruction'
! !


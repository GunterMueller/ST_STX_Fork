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

GDBMICommand subclass:#GDBMI_exec_step_instruction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_step_instruction class methodsFor:'documentation'!

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
The `-exec-step-instruction' Command
------------------------------------

Synopsis
........

      -exec-step-instruction [--reverse]

   Resumes the inferior which executes one machine instruction.  If the
`--reverse' option is specified, resumes reverse execution of the
inferior program, stopping at the previously executed instruction.  The
output, once {No value for `GDBN'} has stopped, will vary depending on
whether we have stopped in the middle of a source line or not.  In the
former case, the address at which the program stopped will be printed
as well.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `stepi'.

Example
.......

     (gdb)
     -exec-step-instruction
     ^running

     (gdb)
     *stopped,reason='end-stepping-range',
     frame={func='foo',args=[],file='try.c',
     fullname='/home/foo/bar/try.c',line='10'}
     (gdb)
     -exec-step-instruction
     ^running

     (gdb)
     *stopped,reason='end-stepping-range',
     frame={addr='0x000100f4',func='foo',args=[],file='try.c',
     fullname='/home/foo/bar/try.c',line='10'}
     (gdb)


"
! !

!GDBMI_exec_step_instruction methodsFor:'accessing'!

operation
	^ 'exec-step-instruction'
! !


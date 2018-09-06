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

GDBMICommand subclass:#GDBMI_exec_step
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_step class methodsFor:'documentation'!

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
The `-exec-step' Command
------------------------

Synopsis
........

      -exec-step [--reverse]

   Resumes execution of the inferior program, stopping when the
beginning of the next source line is reached, if the next source line
is not a function call.  If it is, stop at the first instruction of the
called function.  If the `--reverse' option is specified, resumes
reverse execution of the inferior program, stopping at the beginning of
the previously executed source line.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `step'.

Example
.......

Stepping into a function:

     -exec-step
     ^running
     (gdb)
     *stopped,reason='end-stepping-range',
     frame={func='foo',args=[{name='a',value='10'},
     {name='b',value='0'}],file='recursive2.c',
     fullname='/home/foo/bar/recursive2.c',line='11'}
     (gdb)

   Regular stepping:

     -exec-step
     ^running
     (gdb)
     *stopped,reason='end-stepping-range',line='14',file='recursive2.c'
     (gdb)


"
! !

!GDBMI_exec_step methodsFor:'accessing'!

operation
	^ 'exec-step'
! !

!GDBMI_exec_step class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


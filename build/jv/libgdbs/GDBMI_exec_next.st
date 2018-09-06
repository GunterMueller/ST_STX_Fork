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

GDBMICommand subclass:#GDBMI_exec_next
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_next class methodsFor:'documentation'!

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
The `-exec-next' Command
------------------------

Synopsis
........

      -exec-next [--reverse]

   Resumes execution of the inferior program, stopping when the
beginning of the next source line is reached.

   If the `--reverse' option is specified, resumes reverse execution of
the inferior program, stopping at the beginning of the previous source
line.  If you issue this command on the first line of a function, it
will take you back to the caller of that function, to the source line
where the function was called.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `next'.

Example
.......

     -exec-next
     ^running
     (gdb)
     *stopped,reason='end-stepping-range',line='8',file='hello.c'
     (gdb)


"
! !

!GDBMI_exec_next methodsFor:'accessing'!

operation
	^ 'exec-next'
! !

!GDBMI_exec_next class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


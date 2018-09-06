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

GDBMICommand subclass:#GDBMI_exec_finish
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_finish class methodsFor:'documentation'!

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
The `-exec-finish' Command
--------------------------

Synopsis
........

      -exec-finish [--reverse]

   Resumes the execution of the inferior program until the current
function is exited.  Displays the results returned by the function.  If
the `--reverse' option is specified, resumes the reverse execution of
the inferior program until the point where current function was called.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `finish'.

Example
.......

Function returning `void'.

     -exec-finish
     ^running
     (gdb)
     @hello from foo
     *stopped,reason='function-finished',frame={func='main',args=[],
     file='hello.c',fullname='/home/foo/bar/hello.c',line='7'}
     (gdb)

   Function returning other than `void'.  The name of the internal {No
value for `GDBN'} variable storing the result is printed, together with
the value itself.

     -exec-finish
     ^running
     (gdb)
     *stopped,reason='function-finished',frame={addr='0x000107b0',func='foo',
     args=[{name='a',value='1'],{name='b',value='9'}},
     file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='14'},
     gdb-result-var='$1',return-value='0'
     (gdb)


"
! !

!GDBMI_exec_finish methodsFor:'accessing'!

operation
	^ 'exec-finish'
! !


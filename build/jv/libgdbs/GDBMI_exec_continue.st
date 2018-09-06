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

GDBMICommand subclass:#GDBMI_exec_continue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_continue class methodsFor:'documentation'!

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
The `-exec-continue' Command
----------------------------

Synopsis
........

      -exec-continue [--reverse] [--all|--thread-group N]

   Resumes the execution of the inferior program, which will continue
to execute until it reaches a debugger stop event.  If the `--reverse'
option is specified, execution resumes in reverse until it reaches a
stop event.  Stop events may include
   * breakpoints or watchpoints

   * signals or exceptions

   * the end of the process (or its beginning under `--reverse')

   * the end or beginning of a replay log if one is being used.
   In all-stop mode (*note All-Stop Mode::), may resume only one
thread, or all threads, depending on the value of the
`scheduler-locking' variable.  If `--all' is specified, all threads (in
all inferiors) will be resumed.  The `--all' option is ignored in
all-stop mode.  If the `--thread-group' options is specified, then all
threads in that thread group are resumed.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} corresponding is `continue'.

Example
.......

     -exec-continue
     ^running
     (gdb)
     @Hello world
     *stopped,reason='breakpoint-hit',disp='keep',bkptno='2',frame={
     func='foo',args=[],file='hello.c',fullname='/home/foo/bar/hello.c',
     line='13'}
     (gdb)


"
! !

!GDBMI_exec_continue methodsFor:'accessing'!

operation
	^ 'exec-continue'
! !

!GDBMI_exec_continue class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


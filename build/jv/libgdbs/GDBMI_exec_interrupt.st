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

GDBMICommand subclass:#GDBMI_exec_interrupt
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_interrupt class methodsFor:'documentation'!

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
The `-exec-interrupt' Command
-----------------------------

Synopsis
........

      -exec-interrupt [--all|--thread-group N]

   Interrupts the background execution of the target.  Note how the
token associated with the stop message is the one for the execution
command that has been interrupted.  The token for the interrupt itself
only appears in the `^done' output.  If the user is trying to interrupt
a non-running program, an error message will be printed.

   Note that when asynchronous execution is enabled, this command is
asynchronous just like other execution commands.  That is, first the
`^done' response will be printed, and the target stop will be reported
after that using the `*stopped' notification.

   In non-stop mode, only the context thread is interrupted by default.
All threads (in all inferiors) will be interrupted if the `--all'
option is specified.  If the `--thread-group' option is specified, all
threads in that group will be interrupted.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `interrupt'.

Example
.......

     (gdb)
     111-exec-continue
     111^running

     (gdb)
     222-exec-interrupt
     222^done
     (gdb)
     111*stopped,signal-name='SIGINT',signal-meaning='Interrupt',
     frame={addr='0x00010140',func='foo',args=[],file='try.c',
     fullname='/home/foo/bar/try.c',line='13'}
     (gdb)

     (gdb)
     -exec-interrupt
     ^error,msg='mi_cmd_exec_interrupt: Inferior not executing.'
     (gdb)


"
! !

!GDBMI_exec_interrupt methodsFor:'accessing'!

operation
	^ 'exec-interrupt'
! !

!GDBMI_exec_interrupt class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


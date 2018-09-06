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

GDBMICommand subclass:#GDBMI_exec_run
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_run class methodsFor:'documentation'!

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
The `-exec-run' Command
-----------------------

Synopsis
........

      -exec-run [ --all | --thread-group N ] [ --start ]

   Starts execution of the inferior from the beginning.  The inferior
executes until either a breakpoint is encountered or the program exits.
In the latter case the output will include an exit code, if the program
has exited exceptionally.

   When neither the `--all' nor the `--thread-group' option is
specified, the current inferior is started.  If the `--thread-group'
option is specified, it should refer to a thread group of type
`process', and that thread group will be started.  If the `--all'
option is specified, then all inferiors will be started.

   Using the `--start' option instructs the debugger to stop the
execution at the start of the inferior's main subprogram, following the
same behavior as the `start' command (*note Starting::).

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `run'.

Examples
........

     (gdb)
     -break-insert main
     ^done,bkpt={number='1',addr='0x0001072c',file='recursive2.c',line='4'}
     (gdb)
     -exec-run
     ^running
     (gdb)
     *stopped,reason='breakpoint-hit',disp='keep',bkptno='1',
     frame={func='main',args=[],file='recursive2.c',
     fullname='/home/foo/bar/recursive2.c',line='4'}
     (gdb)

Program exited normally:

     (gdb)
     -exec-run
     ^running
     (gdb)
     x = 55
     *stopped,reason='exited-normally'
     (gdb)

Program exited exceptionally:

     (gdb)
     -exec-run
     ^running
     (gdb)
     x = 55
     *stopped,reason='exited',exit-code='01'
     (gdb)

   Another way the program can terminate is if it receives a signal
such as `SIGINT'.  In this case, GDB/MI displays this:

     (gdb)
     *stopped,reason='exited-signalled',signal-name='SIGINT',
     signal-meaning='Interrupt'


"
! !

!GDBMI_exec_run methodsFor:'accessing'!

operation
	^ 'exec-run'
! !

!GDBMI_exec_run class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


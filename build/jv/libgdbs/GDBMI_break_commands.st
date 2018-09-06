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

GDBMICommand subclass:#GDBMI_break_commands
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_break_commands class methodsFor:'documentation'!

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
The `-break-commands' Command
-----------------------------

Synopsis
........

      -break-commands NUMBER [ COMMAND1 ... COMMANDN ]

   Specifies the CLI commands that should be executed when breakpoint
NUMBER is hit.  The parameters COMMAND1 to COMMANDN are the commands.
If no command is specified, any previously-set commands are cleared.
*Note Break Commands::.  Typical use of this functionality is tracing a
program, that is, printing of values of some variables whenever
breakpoint is hit and then continuing.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `commands'.

Example
.......

     (gdb)
     -break-insert main
     ^done,bkpt={number='1',type='breakpoint',disp='keep',
     enabled='y',addr='0x000100d0',func='main',file='hello.c',
     fullname='/home/foo/hello.c',line='5',thread-groups=['i1'],
     times='0'}
     (gdb)
     -break-commands 1 'print v' 'continue'
     ^done
     (gdb)


"
! !

!GDBMI_break_commands methodsFor:'accessing'!

operation
	^ 'break-commands'
! !

!GDBMI_break_commands class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


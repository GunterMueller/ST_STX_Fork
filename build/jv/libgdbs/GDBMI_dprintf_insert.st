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

GDBMICommand subclass:#GDBMI_dprintf_insert
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_dprintf_insert class methodsFor:'documentation'!

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
The `-dprintf-insert' Command
-----------------------------

Synopsis
........

      -dprintf-insert [ -t ] [ -f ] [ -d ]
         [ -c CONDITION ] [ -i IGNORE-COUNT ]
         [ -p THREAD-ID ] [ LOCATION ] [ FORMAT ]
         [ ARGUMENT ]

If specified, LOCATION, can be one of:

   * FUNCTION

   * FILENAME:LINENUM

   * FILENAME:function

   * *ADDRESS

   The possible optional parameters of this command are:

`-t'
     Insert a temporary breakpoint.

`-f'
     If LOCATION cannot be parsed (for example, if it refers to unknown
     files or functions), create a pending breakpoint.  Without this
     flag, {No value for `GDBN'} will report an error, and won't create
     a breakpoint, if LOCATION cannot be parsed.

`-d'
     Create a disabled breakpoint.

`-c CONDITION'
     Make the breakpoint conditional on CONDITION.

`-i IGNORE-COUNT'
     Set the ignore count of the breakpoint (*note ignore count:
     Conditions.)  to IGNORE-COUNT.

`-p THREAD-ID'
     Restrict the breakpoint to the specified THREAD-ID.

Result
......

*Note GDB/MI Breakpoint Information::, for details on the format of the
resulting breakpoint.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `dprintf'.

Example
.......

     (gdb)
     4-dprintf-insert foo 'At foo entry\n'
     4^done,bkpt={number='1',type='dprintf',disp='keep',enabled='y',
     addr='0x000000000040061b',func='foo',file='mi-dprintf.c',
     fullname='mi-dprintf.c',line='25',thread-groups=['i1'],
     times='0',script={'printf \'At foo entry\\n\'','continue'},
     original-location='foo'}
     (gdb)
     5-dprintf-insert 26 'arg=%d, g=%d\n' arg g
     5^done,bkpt={number='2',type='dprintf',disp='keep',enabled='y',
     addr='0x000000000040062a',func='foo',file='mi-dprintf.c',
     fullname='mi-dprintf.c',line='26',thread-groups=['i1'],
     times='0',script={'printf \'arg=%d, g=%d\\n\', arg, g','continue'},
     original-location='mi-dprintf.c:26'}
     (gdb)


"
! !

!GDBMI_dprintf_insert methodsFor:'accessing'!

operation
	^ 'dprintf-insert'
! !


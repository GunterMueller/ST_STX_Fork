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

GDBMICommand subclass:#GDBMI_break_insert
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_break_insert class methodsFor:'documentation'!

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
The `-break-insert' Command
---------------------------

Synopsis
........

      -break-insert [ -t ] [ -h ] [ -f ] [ -d ] [ -a ]
         [ -c CONDITION ] [ -i IGNORE-COUNT ]
         [ -p THREAD-ID ] [ LOCATION ]

If specified, LOCATION, can be one of:

   * function

   * filename:linenum

   * filename:function

   * *address

   The possible optional parameters of this command are:

`-t'
     Insert a temporary breakpoint.

`-h'
     Insert a hardware breakpoint.

`-f'
     If LOCATION cannot be parsed (for example if it refers to unknown
     files or functions), create a pending breakpoint. Without this
     flag, {No value for `GDBN'} will report an error, and won't create
     a breakpoint, if LOCATION cannot be parsed.

`-d'
     Create a disabled breakpoint.

`-a'
     Create a tracepoint.  *Note Tracepoints::.  When this parameter is
     used together with `-h', a fast tracepoint is created.

`-c CONDITION'
     Make the breakpoint conditional on CONDITION.

`-i IGNORE-COUNT'
     Initialize the IGNORE-COUNT.

`-p THREAD-ID'
     Restrict the breakpoint to the specified THREAD-ID.

Result
......

*Note GDB/MI Breakpoint Information::, for details on the format of the
resulting breakpoint.

   Note: this format is open to change.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} commands are `break', `tbreak',
`hbreak', and `thbreak'.

Example
.......

     (gdb)
     -break-insert main
     ^done,bkpt={number='1',addr='0x0001072c',file='recursive2.c',
     fullname='/home/foo/recursive2.c,line='4',thread-groups=['i1'],
     times='0'}
     (gdb)
     -break-insert -t foo
     ^done,bkpt={number='2',addr='0x00010774',file='recursive2.c',
     fullname='/home/foo/recursive2.c,line='11',thread-groups=['i1'],
     times='0'}
     (gdb)
     -break-list
     ^done,BreakpointTable={nr_rows='2',nr_cols='6',
     hdr=[{width='3',alignment='-1',col_name='number',colhdr='Num'},
     {width='14',alignment='-1',col_name='type',colhdr='Type'},
     {width='4',alignment='-1',col_name='disp',colhdr='Disp'},
     {width='3',alignment='-1',col_name='enabled',colhdr='Enb'},
     {width='10',alignment='-1',col_name='addr',colhdr='Address'},
     {width='40',alignment='2',col_name='what',colhdr='What'}],
     body=[bkpt={number='1',type='breakpoint',disp='keep',enabled='y',
     addr='0x0001072c', func='main',file='recursive2.c',
     fullname='/home/foo/recursive2.c,'line='4',thread-groups=['i1'],
     times='0'},
     bkpt={number='2',type='breakpoint',disp='del',enabled='y',
     addr='0x00010774',func='foo',file='recursive2.c',
     fullname='/home/foo/recursive2.c',line='11',thread-groups=['i1'],
     times='0'}]}
     (gdb)


"
! !

!GDBMI_break_insert methodsFor:'accessing'!

operation
	^ 'break-insert'
! !


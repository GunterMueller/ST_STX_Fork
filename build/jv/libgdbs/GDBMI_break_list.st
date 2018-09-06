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

GDBMICommand subclass:#GDBMI_break_list
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_break_list class methodsFor:'documentation'!

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
The `-break-list' Command
-------------------------

Synopsis
........

      -break-list

   Displays the list of inserted breakpoints, showing the following
fields:

`Number'
     number of the breakpoint

`Type'
     type of the breakpoint: `breakpoint' or `watchpoint'

`Disposition'
     should the breakpoint be deleted or disabled when it is hit: `keep'
     or `nokeep'

`Enabled'
     is the breakpoint enabled or no: `y' or `n'

`Address'
     memory location at which the breakpoint is set

`What'
     logical location of the breakpoint, expressed by function name,
     file name, line number

`Thread-groups'
     list of thread groups to which this breakpoint applies

`Times'
     number of times the breakpoint has been hit

   If there are no breakpoints or watchpoints, the `BreakpointTable'
`body' field is an empty list.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `info break'.

Example
.......

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
     addr='0x000100d0',func='main',file='hello.c',line='5',thread-groups=['i1'],
     times='0'},
     bkpt={number='2',type='breakpoint',disp='keep',enabled='y',
     addr='0x00010114',func='foo',file='hello.c',fullname='/home/foo/hello.c',
     line='13',thread-groups=['i1'],times='0'}]}
     (gdb)

   Here's an example of the result when there are no breakpoints:

     (gdb)
     -break-list
     ^done,BreakpointTable={nr_rows='0',nr_cols='6',
     hdr=[{width='3',alignment='-1',col_name='number',colhdr='Num'},
     {width='14',alignment='-1',col_name='type',colhdr='Type'},
     {width='4',alignment='-1',col_name='disp',colhdr='Disp'},
     {width='3',alignment='-1',col_name='enabled',colhdr='Enb'},
     {width='10',alignment='-1',col_name='addr',colhdr='Address'},
     {width='40',alignment='2',col_name='what',colhdr='What'}],
     body=[]}
     (gdb)


"
! !

!GDBMI_break_list methodsFor:'accessing'!

operation
	^ 'break-list'
! !


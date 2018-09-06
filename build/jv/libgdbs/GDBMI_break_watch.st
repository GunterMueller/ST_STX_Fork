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

GDBMICommand subclass:#GDBMI_break_watch
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_break_watch class methodsFor:'documentation'!

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
The `-break-watch' Command
--------------------------

Synopsis
........

      -break-watch [ -a | -r ]

   Create a watchpoint.  With the `-a' option it will create an
'access' watchpoint, i.e., a watchpoint that triggers either on a read
from or on a write to the memory location.  With the `-r' option, the
watchpoint created is a 'read' watchpoint, i.e., it will trigger only
when the memory location is accessed for reading.  Without either of
the options, the watchpoint created is a regular watchpoint, i.e., it
will trigger when the memory location is accessed for writing.  *Note
Setting Watchpoints: Set Watchpoints.

   Note that `-break-list' will report a single list of watchpoints and
breakpoints inserted.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} commands are `watch', `awatch',
and `rwatch'.

Example
.......

Setting a watchpoint on a variable in the `main' function:

     (gdb)
     -break-watch x
     ^done,wpt={number='2',exp='x'}
     (gdb)
     -exec-continue
     ^running
     (gdb)
     *stopped,reason='watchpoint-trigger',wpt={number='2',exp='x'},
     value={old='-268439212',new='55'},
     frame={func='main',args=[],file='recursive2.c',
     fullname='/home/foo/bar/recursive2.c',line='5'}
     (gdb)

   Setting a watchpoint on a variable local to a function.  {No value
for `GDBN'} will stop the program execution twice: first for the
variable changing value, then for the watchpoint going out of scope.

     (gdb)
     -break-watch C
     ^done,wpt={number='5',exp='C'}
     (gdb)
     -exec-continue
     ^running
     (gdb)
     *stopped,reason='watchpoint-trigger',
     wpt={number='5',exp='C'},value={old='-276895068',new='3'},
     frame={func='callee4',args=[],
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='13'}
     (gdb)
     -exec-continue
     ^running
     (gdb)
     *stopped,reason='watchpoint-scope',wpnum='5',
     frame={func='callee3',args=[{name='strarg',
     value='0x11940 \'A string argument.\''}],
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='18'}
     (gdb)

   Listing breakpoints and watchpoints, at different points in the
program execution.  Note that once the watchpoint goes out of scope, it
is deleted.

     (gdb)
     -break-watch C
     ^done,wpt={number='2',exp='C'}
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
     addr='0x00010734',func='callee4',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/devo/gdb/testsuite/gdb.mi/basics.c'line='8',thread-groups=['i1'],
     times='1'},
     bkpt={number='2',type='watchpoint',disp='keep',
     enabled='y',addr='',what='C',thread-groups=['i1'],times='0'}]}
     (gdb)
     -exec-continue
     ^running
     (gdb)
     *stopped,reason='watchpoint-trigger',wpt={number='2',exp='C'},
     value={old='-276895068',new='3'},
     frame={func='callee4',args=[],
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='13'}
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
     addr='0x00010734',func='callee4',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/devo/gdb/testsuite/gdb.mi/basics.c',line='8',thread-groups=['i1'],
     times='1'},
     bkpt={number='2',type='watchpoint',disp='keep',
     enabled='y',addr='',what='C',thread-groups=['i1'],times='-5'}]}
     (gdb)
     -exec-continue
     ^running
     ^done,reason='watchpoint-scope',wpnum='2',
     frame={func='callee3',args=[{name='strarg',
     value='0x11940 \'A string argument.\''}],
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='18'}
     (gdb)
     -break-list
     ^done,BreakpointTable={nr_rows='1',nr_cols='6',
     hdr=[{width='3',alignment='-1',col_name='number',colhdr='Num'},
     {width='14',alignment='-1',col_name='type',colhdr='Type'},
     {width='4',alignment='-1',col_name='disp',colhdr='Disp'},
     {width='3',alignment='-1',col_name='enabled',colhdr='Enb'},
     {width='10',alignment='-1',col_name='addr',colhdr='Address'},
     {width='40',alignment='2',col_name='what',colhdr='What'}],
     body=[bkpt={number='1',type='breakpoint',disp='keep',enabled='y',
     addr='0x00010734',func='callee4',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/devo/gdb/testsuite/gdb.mi/basics.c',line='8',
     thread-groups=['i1'],times='1'}]}
     (gdb)


"
! !

!GDBMI_break_watch methodsFor:'accessing'!

operation
	^ 'break-watch'
! !

!GDBMI_break_watch class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


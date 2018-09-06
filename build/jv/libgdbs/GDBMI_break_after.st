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

GDBMICommand subclass:#GDBMI_break_after
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_break_after class methodsFor:'documentation'!

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
The `-break-after' Command
--------------------------

Synopsis
........

      -break-after NUMBER COUNT

   The breakpoint number NUMBER is not in effect until it has been hit
COUNT times.  To see how this is reflected in the output of the
`-break-list' command, see the description of the `-break-list' command
below.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `ignore'.

Example
.......

     (gdb)
     -break-insert main
     ^done,bkpt={number='1',type='breakpoint',disp='keep',
     enabled='y',addr='0x000100d0',func='main',file='hello.c',
     fullname='/home/foo/hello.c',line='5',thread-groups=['i1'],
     times='0'}
     (gdb)
     -break-after 1 3
     ~
     ^done
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
     addr='0x000100d0',func='main',file='hello.c',fullname='/home/foo/hello.c',
     line='5',thread-groups=['i1'],times='0',ignore='3'}]}
     (gdb)


"
! !

!GDBMI_break_after methodsFor:'accessing'!

operation
	^ 'break-after'
! !


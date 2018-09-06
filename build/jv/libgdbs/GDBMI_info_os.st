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

GDBMICommand subclass:#GDBMI_info_os
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_info_os class methodsFor:'documentation'!

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
The `-info-os' Command
----------------------

Synopsis
........

     -info-os [ TYPE ]

   If no argument is supplied, the command returns a table of available
operating-system-specific information types.  If one of these types is
supplied as an argument TYPE, then the command returns a table of data
of that type.

   The types of information available depend on the target operating
system.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `info os'.

Example
.......

When run on a GNU/Linux system, the output will look something like
this:

     {No value for `GDBP'}
     -info-os
     ^done,OSDataTable={nr_rows='9',nr_cols='3',
     hdr=[{width='10',alignment='-1',col_name='col0',colhdr='Type'},
          {width='10',alignment='-1',col_name='col1',colhdr='Description'},
          {width='10',alignment='-1',col_name='col2',colhdr='Title'}],
     body=[item={col0='processes',col1='Listing of all processes',
                 col2='Processes'},
           item={col0='procgroups',col1='Listing of all process groups',
                 col2='Process groups'},
           item={col0='threads',col1='Listing of all threads',
                 col2='Threads'},
           item={col0='files',col1='Listing of all file descriptors',
                 col2='File descriptors'},
           item={col0='sockets',col1='Listing of all internet-domain sockets',
                 col2='Sockets'},
           item={col0='shm',col1='Listing of all shared-memory regions',
                 col2='Shared-memory regions'},
           item={col0='semaphores',col1='Listing of all semaphores',
                 col2='Semaphores'},
           item={col0='msg',col1='Listing of all message queues',
                 col2='Message queues'},
           item={col0='modules',col1='Listing of all loaded kernel modules',
                 col2='Kernel modules'}]}
     {No value for `GDBP'}
     -info-os processes
     ^done,OSDataTable={nr_rows='190',nr_cols='4',
     hdr=[{width='10',alignment='-1',col_name='col0',colhdr='pid'},
          {width='10',alignment='-1',col_name='col1',colhdr='user'},
          {width='10',alignment='-1',col_name='col2',colhdr='command'},
          {width='10',alignment='-1',col_name='col3',colhdr='cores'}],
     body=[item={col0='1',col1='root',col2='/sbin/init',col3='0'},
           item={col0='2',col1='root',col2='[kthreadd]',col3='1'},
           item={col0='3',col1='root',col2='[ksoftirqd/0]',col3='0'},
           ...
           item={col0='26446',col1='stan',col2='bash',col3='0'},
           item={col0='28152',col1='stan',col2='bash',col3='1'}]}
     (gdb)

   (Note that the MI output here includes a `'Title'' column that does
not appear in command-line `info os'; this column is useful for MI
clients that want to enumerate the types of data, such as in a popup
menu, but is needless clutter on the command line, and `info os' omits
it.)


"
! !

!GDBMI_info_os methodsFor:'accessing'!

operation
	^ 'info-os'
! !

!GDBMI_info_os class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


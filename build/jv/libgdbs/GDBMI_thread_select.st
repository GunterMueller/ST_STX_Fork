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

GDBMICommand subclass:#GDBMI_thread_select
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_thread_select class methodsFor:'documentation'!

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
The `-thread-select' Command
----------------------------

Synopsis
........

      -thread-select THREADNUM

   Make THREADNUM the current thread.  It prints the number of the new
current thread, and the topmost frame for that thread.

   This command is deprecated in favor of explicitly using the
`--thread' option to each command.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `thread'.

Example
.......

     (gdb)
     -exec-next
     ^running
     (gdb)
     *stopped,reason='end-stepping-range',thread-id='2',line='187',
     file='../../../devo/gdb/testsuite/gdb.threads/linux-dp.c'
     (gdb)
     -thread-list-ids
     ^done,
     thread-ids={thread-id='3',thread-id='2',thread-id='1'},
     number-of-threads='3'
     (gdb)
     -thread-select 3
     ^done,new-thread-id='3',
     frame={level='0',func='vprintf',
     args=[{name='format',value='0x8048e9c \'%*s%c %d %c\\n\''},
     {name='arg',value='0x2'}],file='vprintf.c',line='31'}
     (gdb)


"
! !

!GDBMI_thread_select methodsFor:'accessing'!

operation
	^ 'thread-select'
! !


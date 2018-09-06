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

GDBMICommand subclass:#GDBMI_ada_task_info
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_ada_task_info class methodsFor:'documentation'!

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
The `-ada-task-info' Command
----------------------------

Synopsis
........

      -ada-task-info [ TASK-ID ]

   Reports information about either a specific Ada task, if the TASK-ID
parameter is present, or about all Ada tasks.

{No value for `GDBN'} Command
.............................

The `info tasks' command prints the same information about all Ada
tasks (*note Ada Tasks::).

Result
......

The result is a table of Ada tasks.  The following columns are defined
for each Ada task:

`current'
     This field exists only for the current thread.  It has the value
     `*'.

`id'
     The identifier that {No value for `GDBN'} uses to refer to the Ada
     task.

`task-id'
     The identifier that the target uses to refer to the Ada task.

`thread-id'
     The identifier of the thread corresponding to the Ada task.

     This field should always exist, as Ada tasks are always implemented
     on top of a thread.  But if {No value for `GDBN'} cannot find this
     corresponding thread for any reason, the field is omitted.

`parent-id'
     This field exists only when the task was created by another task.
     In this case, it provides the ID of the parent task.

`priority'
     The base priority of the task.

`state'
     The current state of the task.  For a detailed description of the
     possible states, see *note Ada Tasks::.

`name'
     The name of the task.


Example
.......

     -ada-task-info
     ^done,tasks={nr_rows='3',nr_cols='8',
     hdr=[{width='1',alignment='-1',col_name='current',colhdr=''},
     {width='3',alignment='1',col_name='id',colhdr='ID'},
     {width='9',alignment='1',col_name='task-id',colhdr='TID'},
     {width='4',alignment='1',col_name='thread-id',colhdr=''},
     {width='4',alignment='1',col_name='parent-id',colhdr='P-ID'},
     {width='3',alignment='1',col_name='priority',colhdr='Pri'},
     {width='22',alignment='-1',col_name='state',colhdr='State'},
     {width='1',alignment='2',col_name='name',colhdr='Name'}],
     body=[{current='*',id='1',task-id='   644010',thread-id='1',priority='48',
     state='Child Termination Wait',name='main_task'}]}
     (gdb)


"
! !

!GDBMI_ada_task_info methodsFor:'accessing'!

operation
	^ 'ada-task-info'
! !


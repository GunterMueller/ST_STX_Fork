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

GDBMICommand subclass:#GDBMI_thread_list_ids
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_thread_list_ids class methodsFor:'documentation'!

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
The `-thread-list-ids' Command
------------------------------

Synopsis
........

      -thread-list-ids

   Produces a list of the currently known {No value for `GDBN'} thread
ids.  At the end of the list it also prints the total number of such
threads.

   This command is retained for historical reasons, the `-thread-info'
command should be used instead.

{No value for `GDBN'} Command
.............................

Part of `info threads' supplies the same information.

Example
.......

     (gdb)
     -thread-list-ids
     ^done,thread-ids={thread-id='3',thread-id='2',thread-id='1'},
     current-thread-id='1',number-of-threads='3'
     (gdb)


"
! !

!GDBMI_thread_list_ids methodsFor:'accessing'!

operation
	^ 'thread-list-ids'
! !

!GDBMI_thread_list_ids methodsFor:'accessing-descriptors'!

resultDescription     
    ^ (super resultDescription)
        define:#'thread-ids' as:Array of:Integer;
        define:#'current-thread-id' as: Integer;
        define:#'number-of-threads' as: Integer;
        yourself

    "
    GDBMI_thread_list_ids new resultDescription
    "

    "Created: / 19-03-2015 / 08:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


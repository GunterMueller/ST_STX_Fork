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

GDBMICommand subclass:#GDBMI_thread_info
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_thread_info class methodsFor:'documentation'!

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
The `-thread-info' Command
--------------------------

Synopsis
........

      -thread-info [ THREAD-ID ]

   Reports information about either a specific thread, if the THREAD-ID
parameter is present, or about all threads.  When printing information
about all threads, also reports the current thread.

{No value for `GDBN'} Command
.............................

The `info thread' command prints the same information about all threads.

Result
......

The result is a list of threads.  The following attributes are defined
for a given thread:

`current'
     This field exists only for the current thread.  It has the value
     `*'.

`id'
     The identifier that {No value for `GDBN'} uses to refer to the
     thread.

`target-id'
     The identifier that the target uses to refer to the thread.

`details'
     Extra information about the thread, in a target-specific format.
     This field is optional.

`name'
     The name of the thread.  If the user specified a name using the
     `thread name' command, then this name is given.  Otherwise, if {No
     value for `GDBN'} can extract the thread name from the target,
     then that name is given.  If {No value for `GDBN'} cannot find the
     thread name, then this field is omitted.

`frame'
     The stack frame currently executing in the thread.

`state'
     The thread's state.  The `state' field may have the following
     values:

    `stopped'
          The thread is stopped.  Frame information is available for
          stopped threads.

    `running'
          The thread is running.  There's no frame information for
          running threads.


`core'
     If {No value for `GDBN'} can find the CPU core on which this
     thread is running, then this field is the core identifier.  This
     field is optional.


Example
.......

     -thread-info
     ^done,threads=[
     {id='2',target-id='Thread 0xb7e14b90 (LWP 21257)',
        frame={level='0',addr='0xffffe410',func='__kernel_vsyscall',
                args=[]},state='running'},
     {id='1',target-id='Thread 0xb7e156b0 (LWP 21254)',
        frame={level='0',addr='0x0804891f',func='foo',
                args=[{name='i',value='10'}],
                file='/tmp/a.c',fullname='/tmp/a.c',line='158'},
                state='running'}],
     current-thread-id='1'
     (gdb)


"
! !

!GDBMI_thread_info methodsFor:'accessing'!

operation
	^ 'thread-info'
! !

!GDBMI_thread_info methodsFor:'accessing-descriptors'!

resultDescription     
    ^ (super resultDescription)
        define:#threads
            as:Array
            of:GDBThreadInfo;
        yourself

    "
    GDBMI_thread_info new resultDescription
    "

    "Created: / 17-09-2014 / 00:00:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 08:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-03-2015 / 17:05:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMI_thread_info class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


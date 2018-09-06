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

GDBMICommand subclass:#GDBMI_list_thread_groups
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_list_thread_groups class methodsFor:'documentation'!

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
The `-list-thread-groups' Command
---------------------------------

Synopsis
--------

     -list-thread-groups [ --available ] [ --recurse 1 ] [ GROUP ... ]

   Lists thread groups (*note Thread groups::).  When a single thread
group is passed as the argument, lists the children of that group.
When several thread group are passed, lists information about those
thread groups.  Without any parameters, lists information about all
top-level thread groups.

   Normally, thread groups that are being debugged are reported.  With
the `--available' option, {No value for `GDBN'} reports thread groups
available on the target.

   The output of this command may have either a `threads' result or a
`groups' result.  The `thread' result has a list of tuples as value,
with each tuple describing a thread (*note GDB/MI Thread
Information::).  The `groups' result has a list of tuples as value,
each tuple describing a thread group.  If top-level groups are
requested (that is, no parameter is passed), or when several groups are
passed, the output always has a `groups' result.  The format of the
`group' result is described below.

   To reduce the number of roundtrips it's possible to list thread
groups together with their children, by passing the `--recurse' option
and the recursion depth.  Presently, only recursion depth of 1 is
permitted.  If this option is present, then every reported thread group
will also include its children, either as `group' or `threads' field.

   In general, any combination of option and parameters is permitted,
with the following caveats:

   * When a single thread group is passed, the output will typically be
     the `threads' result.  Because threads may not contain anything,
     the `recurse' option will be ignored.

   * When the `--available' option is passed, limited information may
     be available.  In particular, the list of threads of a process
     might be inaccessible.  Further, specifying specific thread groups
     might not give any performance advantage over listing all thread
     groups.  The frontend should assume that `-list-thread-groups
     --available' is always an expensive operation and cache the
     results.


   The `groups' result is a list of tuples, where each tuple may have
the following fields:

`id'
     Identifier of the thread group.  This field is always present.
     The identifier is an opaque string; frontends should not try to
     convert it to an integer, even though it might look like one.

`type'
     The type of the thread group.  At present, only `process' is a
     valid type.

`pid'
     The target-specific process identifier.  This field is only present
     for thread groups of type `process' and only if the process exists.

`num_children'
     The number of children this thread group has.  This field may be
     absent for an available thread group.

`threads'
     This field has a list of tuples as value, each tuple describing a
     thread.  It may be present if the `--recurse' option is specified,
     and it's actually possible to obtain the threads.

`cores'
     This field is a list of integers, each identifying a core that one
     thread of the group is running on.  This field may be absent if
     such information is not available.

`executable'
     The name of the executable file that corresponds to this thread
     group.  The field is only present for thread groups of type
     `process', and only if there is a corresponding executable file.


Example
-------

     {No value for `GDBP'}
     -list-thread-groups
     ^done,groups=[{id='17',type='process',pid='yyy',num_children='2'}]
     -list-thread-groups 17
     ^done,threads=[{id='2',target-id='Thread 0xb7e14b90 (LWP 21257)',
        frame={level='0',addr='0xffffe410',func='__kernel_vsyscall',args=[]},state='running'},
     {id='1',target-id='Thread 0xb7e156b0 (LWP 21254)',
        frame={level='0',addr='0x0804891f',func='foo',args=[{name='i',value='10'}],
                file='/tmp/a.c',fullname='/tmp/a.c',line='158'},state='running'}]]
     -list-thread-groups --available
     ^done,groups=[{id='17',type='process',pid='yyy',num_children='2',cores=[1,2]}]
     -list-thread-groups --available --recurse 1
      ^done,groups=[{id='17', types='process',pid='yyy',num_children='2',cores=[1,2],
                     threads=[{id='1',target-id='Thread 0xb7e14b90',cores=[1]},
                              {id='2',target-id='Thread 0xb7e14b90',cores=[2]}]},..]
     -list-thread-groups --available --recurse 1 17 18
     ^done,groups=[{id='17', types='process',pid='yyy',num_children='2',cores=[1,2],
                    threads=[{id='1',target-id='Thread 0xb7e14b90',cores=[1]},
                             {id='2',target-id='Thread 0xb7e14b90',cores=[2]}]},...]


"
! !

!GDBMI_list_thread_groups methodsFor:'accessing'!

operation
	^ 'list-thread-groups'
! !

!GDBMI_list_thread_groups methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#groups as:Array of:GDBThreadGroup; 
        define:#threads as:Array of:GDBThread; 
        yourself

    "Created: / 06-06-2017 / 00:10:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


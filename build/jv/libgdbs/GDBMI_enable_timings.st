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

GDBMICommand subclass:#GDBMI_enable_timings
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_enable_timings class methodsFor:'documentation'!

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
The `-enable-timings' Command
-----------------------------

Synopsis
--------

     -enable-timings [yes | no]

   Toggle the printing of the wallclock, user and system times for an MI
command as a field in its output.  This command is to help frontend
developers optimize the performance of their code.  No argument is
equivalent to `yes'.

{No value for `GDBN'} Command
-----------------------------

No equivalent.

Example
-------

     (gdb)
     -enable-timings
     ^done
     (gdb)
     -break-insert main
     ^done,bkpt={number='1',type='breakpoint',disp='keep',enabled='y',
     addr='0x080484ed',func='main',file='myprog.c',
     fullname='/home/nickrob/myprog.c',line='73',thread-groups=['i1'],
     times='0'},
     time={wallclock='0.05185',user='0.00800',system='0.00000'}
     (gdb)
     -enable-timings no
     ^done
     (gdb)
     -exec-run
     ^running
     (gdb)
     *stopped,reason='breakpoint-hit',disp='keep',bkptno='1',thread-id='0',
     frame={addr='0x080484ed',func='main',args=[{name='argc',value='1'},
     {name='argv',value='0xbfb60364'}],file='myprog.c',
     fullname='/home/nickrob/myprog.c',line='73'}
     (gdb)

28 {No value for `GDBN'} Annotations
************************************

This chapter describes annotations in {No value for `GDBN'}.
Annotations were designed to interface {No value for `GDBN'} to
graphical user interfaces or other similar programs which want to
interact with {No value for `GDBN'} at a relatively high level.

   The annotation mechanism has largely been superseded by GDB/MI
(*note GDB/MI::).


"
! !

!GDBMI_enable_timings methodsFor:'accessing'!

operation
	^ 'enable-timings'
! !

!GDBMI_enable_timings class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


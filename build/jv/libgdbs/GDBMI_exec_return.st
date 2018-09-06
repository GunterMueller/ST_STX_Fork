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

GDBMICommand subclass:#GDBMI_exec_return
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_return class methodsFor:'documentation'!

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
The `-exec-return' Command
--------------------------

Synopsis
........

      -exec-return

   Makes current function return immediately.  Doesn't execute the
inferior.  Displays the new current frame.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `return'.

Example
.......

     (gdb)
     200-break-insert callee4
     200^done,bkpt={number='1',addr='0x00010734',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',line='8'}
     (gdb)
     000-exec-run
     000^running
     (gdb)
     000*stopped,reason='breakpoint-hit',disp='keep',bkptno='1',
     frame={func='callee4',args=[],
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='8'}
     (gdb)
     205-break-delete
     205^done
     (gdb)
     111-exec-return
     111^done,frame={level='0',func='callee3',
     args=[{name='strarg',
     value='0x11940 \'A string argument.\''}],
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='18'}
     (gdb)


"
! !

!GDBMI_exec_return methodsFor:'accessing'!

operation
	^ 'exec-return'
! !

!GDBMI_exec_return class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


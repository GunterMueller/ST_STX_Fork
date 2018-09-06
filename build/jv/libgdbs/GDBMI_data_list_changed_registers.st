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

GDBMICommand subclass:#GDBMI_data_list_changed_registers
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_list_changed_registers class methodsFor:'documentation'!

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
The `-data-list-changed-registers' Command
------------------------------------------

Synopsis
........

      -data-list-changed-registers

   Display a list of the registers that have changed.

{No value for `GDBN'} Command
.............................

{No value for `GDBN'} doesn't have a direct analog for this command;
`gdbtk' has the corresponding command `gdb_changed_register_list'.

Example
.......

On a PPC MBX board:

     (gdb)
     -exec-continue
     ^running

     (gdb)
     *stopped,reason='breakpoint-hit',disp='keep',bkptno='1',frame={
     func='main',args=[],file='try.c',fullname='/home/foo/bar/try.c',
     line='5'}
     (gdb)
     -data-list-changed-registers
     ^done,changed-registers=['0','1','2','4','5','6','7','8','9',
     '10','11','13','14','15','16','17','18','19','20','21','22','23',
     '24','25','26','27','28','30','31','64','65','66','67','69']
     (gdb)


"
! !

!GDBMI_data_list_changed_registers methodsFor:'accessing'!

operation
	^ 'data-list-changed-registers'
! !

!GDBMI_data_list_changed_registers class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


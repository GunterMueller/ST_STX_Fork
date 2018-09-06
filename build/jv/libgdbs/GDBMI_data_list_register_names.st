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

GDBMICommand subclass:#GDBMI_data_list_register_names
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_list_register_names class methodsFor:'documentation'!

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
The `-data-list-register-names' Command
---------------------------------------

Synopsis
........

      -data-list-register-names [ ( REGNO )+ ]

   Show a list of register names for the current target.  If no
arguments are given, it shows a list of the names of all the registers.
If integer numbers are given as arguments, it will print a list of the
names of the registers corresponding to the arguments.  To ensure
consistency between a register name and its number, the output list may
include empty register names.

{No value for `GDBN'} Command
.............................

{No value for `GDBN'} does not have a command which corresponds to
`-data-list-register-names'.  In `gdbtk' there is a corresponding
command `gdb_regnames'.

Example
.......

For the PPC MBX board:
     (gdb)
     -data-list-register-names
     ^done,register-names=['r0','r1','r2','r3','r4','r5','r6','r7',
     'r8','r9','r10','r11','r12','r13','r14','r15','r16','r17','r18',
     'r19','r20','r21','r22','r23','r24','r25','r26','r27','r28','r29',
     'r30','r31','f0','f1','f2','f3','f4','f5','f6','f7','f8','f9',
     'f10','f11','f12','f13','f14','f15','f16','f17','f18','f19','f20',
     'f21','f22','f23','f24','f25','f26','f27','f28','f29','f30','f31',
     '', 'pc','ps','cr','lr','ctr','xer']
     (gdb)
     -data-list-register-names 1 2 3
     ^done,register-names=['r1','r2','r3']
     (gdb)


"
! !

!GDBMI_data_list_register_names methodsFor:'accessing'!

operation
	^ 'data-list-register-names'
! !


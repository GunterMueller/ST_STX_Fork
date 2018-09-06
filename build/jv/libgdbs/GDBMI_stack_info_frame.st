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

GDBMICommand subclass:#GDBMI_stack_info_frame
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_stack_info_frame class methodsFor:'documentation'!

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
The `-stack-info-frame' Command
-------------------------------

Synopsis
........

      -stack-info-frame

   Get info on the selected frame.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `info frame' or
`frame' (without arguments).

Example
.......

     (gdb)
     -stack-info-frame
     ^done,frame={level='1',addr='0x0001076c',func='callee3',
     file='../../../devo/gdb/testsuite/gdb.mi/basics.c',
     fullname='/home/foo/bar/devo/gdb/testsuite/gdb.mi/basics.c',line='17'}
     (gdb)


"
! !

!GDBMI_stack_info_frame methodsFor:'accessing'!

operation
	^ 'stack-info-frame'
! !

!GDBMI_stack_info_frame methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#frame as:GDBFrame;
        yourself

    "Created: / 19-03-2015 / 08:29:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMI_stack_info_frame class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


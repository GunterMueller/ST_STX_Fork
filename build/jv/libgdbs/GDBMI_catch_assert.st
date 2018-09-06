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

GDBMICommand subclass:#GDBMI_catch_assert
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_catch_assert class methodsFor:'documentation'!

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
The `-catch-assert' Command
---------------------------

Synopsis
........

      -catch-assert [ -c CONDITION] [ -d ] [ -t ]

   Add a catchpoint for failed Ada assertions.

   The possible optional parameters for this command are:

`-c CONDITION'
     Make the catchpoint conditional on CONDITION.

`-d'
     Create a disabled catchpoint.

`-t'
     Create a temporary catchpoint.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `catch assert'.

Example
.......

     -catch-assert
     ^done,bkptno='5',bkpt={number='5',type='breakpoint',disp='keep',
     enabled='y',addr='0x0000000000404888',what='failed Ada assertions',
     thread-groups=['i1'],times='0',
     original-location='__gnat_debug_raise_assert_failure'}
     (gdb)


"
! !

!GDBMI_catch_assert methodsFor:'accessing'!

operation
	^ 'catch-assert'
! !


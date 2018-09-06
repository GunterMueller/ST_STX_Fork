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

GDBMICommand subclass:#GDBMI_symbol_list_lines
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_symbol_list_lines class methodsFor:'documentation'!

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
The `-symbol-list-lines' Command
--------------------------------

Synopsis
........

      -symbol-list-lines FILENAME

   Print the list of lines that contain code and their associated
program addresses for the given source filename.  The entries are
sorted in ascending PC order.

{No value for `GDBN'} Command
.............................

There is no corresponding {No value for `GDBN'} command.

Example
.......

     (gdb)
     -symbol-list-lines basics.c
     ^done,lines=[{pc='0x08048554',line='7'},{pc='0x0804855a',line='8'}]
     (gdb)


"
! !

!GDBMI_symbol_list_lines methodsFor:'accessing'!

operation
	^ 'symbol-list-lines'
! !

!GDBMI_symbol_list_lines class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

GDBMICommand subclass:#GDBMI_file_exec_file
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_file_exec_file class methodsFor:'documentation'!

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
The `-file-exec-file' Command
-----------------------------

Synopsis
........

      -file-exec-file FILE

   Specify the executable file to be debugged.  Unlike
`-file-exec-and-symbols', the symbol table is _not_ read from this
file.  If used without argument, {No value for `GDBN'} clears the
information about the executable file.  No output is produced, except a
completion notification.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `exec-file'.

Example
.......

     (gdb)
     -file-exec-file /kwikemart/marge/ezannoni/TRUNK/mbx/hello.mbx
     ^done
     (gdb)


"
! !

!GDBMI_file_exec_file methodsFor:'accessing'!

operation
	^ 'file-exec-file'
! !

!GDBMI_file_exec_file class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


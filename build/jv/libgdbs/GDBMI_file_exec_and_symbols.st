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

GDBMICommand subclass:#GDBMI_file_exec_and_symbols
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_file_exec_and_symbols class methodsFor:'documentation'!

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
The `-file-exec-and-symbols' Command
------------------------------------

Synopsis
........

      -file-exec-and-symbols FILE

   Specify the executable file to be debugged.  This file is the one
from which the symbol table is also read.  If no file is specified, the
command clears the executable and symbol information.  If breakpoints
are set when using this command with no arguments, {No value for
`GDBN'} will produce error messages.  Otherwise, no output is produced,
except a completion notification.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `file'.

Example
.......

     (gdb)
     -file-exec-and-symbols /kwikemart/marge/ezannoni/TRUNK/mbx/hello.mbx
     ^done
     (gdb)


"
! !

!GDBMI_file_exec_and_symbols methodsFor:'accessing'!

operation
	^ 'file-exec-and-symbols'
! !


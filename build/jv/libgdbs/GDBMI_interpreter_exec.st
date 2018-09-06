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

GDBMICommand subclass:#GDBMI_interpreter_exec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_interpreter_exec class methodsFor:'documentation'!

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
The `-interpreter-exec' Command
-------------------------------

Synopsis
--------

     -interpreter-exec INTERPRETER COMMAND
Execute the specified COMMAND in the given INTERPRETER.

{No value for `GDBN'} Command
-----------------------------

The corresponding {No value for `GDBN'} command is `interpreter-exec'.

Example
-------

     (gdb)
     -interpreter-exec console 'break main'
     &'During symbol reading, couldn't parse type; debugger out of date?.\n'
     &'During symbol reading, bad structure-type format.\n'
     ~'Breakpoint 1 at 0x8074fc6: file ../../src/gdb/main.c, line 743.\n'
     ^done
     (gdb)


"
! !

!GDBMI_interpreter_exec methodsFor:'accessing'!

operation
	^ 'interpreter-exec'
! !

!GDBMI_interpreter_exec class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


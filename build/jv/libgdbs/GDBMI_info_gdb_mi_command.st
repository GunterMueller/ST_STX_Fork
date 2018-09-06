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

GDBMICommand subclass:#GDBMI_info_gdb_mi_command
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_info_gdb_mi_command class methodsFor:'documentation'!

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
The `-info-gdb-mi-command' Command
----------------------------------

Synopsis
........

      -info-gdb-mi-command CMD_NAME

   Query support for the GDB/MI command named CMD_NAME.

   Note that the dash (`-') starting all GDB/MI commands is technically
not part of the command name (*note GDB/MI Input Syntax::), and thus
should be omitted in CMD_NAME.  However, for ease of use, this command
also accepts the form with the leading dash.

{No value for `GDBN'} Command
.............................

There is no corresponding {No value for `GDBN'} command.

Result
......

The result is a tuple.  There is currently only one field:

`exists'
     This field is equal to `'true'' if the GDB/MI command exists,
     `'false'' otherwise.


Example
.......

Here is an example where the GDB/MI command does not exist:

     -info-gdb-mi-command unsupported-command
     ^done,command={exists='false'}

And here is an example where the GDB/MI command is known to the
debugger:

     -info-gdb-mi-command symbol-list-lines
     ^done,command={exists='true'}


"
! !

!GDBMI_info_gdb_mi_command methodsFor:'accessing'!

operation
	^ 'info-gdb-mi-command'
! !

!GDBMI_info_gdb_mi_command class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


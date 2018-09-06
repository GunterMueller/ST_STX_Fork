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

GDBMICommand subclass:#GDBMI_list_features
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_list_features class methodsFor:'documentation'!

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
The `-list-features' Command
----------------------------

Returns a list of particular features of the MI protocol that this
version of gdb implements.  A feature can be a command, or a new field
in an output of some command, or even an important bugfix.  While a
frontend can sometimes detect presence of a feature at runtime, it is
easier to perform detection at debugger startup.

   The command returns a list of strings, with each string naming an
available feature.  Each returned string is just a name, it does not
have any internal structure.  The list of possible feature names is
given below.

   Example output:

     (gdb) -list-features
     ^done,result=['feature1','feature2']

   The current list of features is:

`frozen-varobjs'
     Indicates support for the `-var-set-frozen' command, as well as
     possible presense of the `frozen' field in the output of
     `-varobj-create'.

`pending-breakpoints'
     Indicates support for the `-f' option to the `-break-insert'
     command.

`python'
     Indicates Python scripting support, Python-based pretty-printing
     commands, and possible presence of the `display_hint' field in the
     output of `-var-list-children'

`thread-info'
     Indicates support for the `-thread-info' command.

`data-read-memory-bytes'
     Indicates support for the `-data-read-memory-bytes' and the
     `-data-write-memory-bytes' commands.

`breakpoint-notifications'
     Indicates that changes to breakpoints and breakpoints created via
     the CLI will be announced via async records.

`ada-task-info'
     Indicates support for the `-ada-task-info' command.

`language-option'
     Indicates that all GDB/MI commands accept the `--language' option
     (*note Context management::).

`info-gdb-mi-command'
     Indicates support for the `-info-gdb-mi-command' command.

`undefined-command-error-code'
     Indicates support for the 'undefined-command' error code in error
     result records, produced when trying to execute an undefined
     GDB/MI command (*note GDB/MI Result Records::).

`exec-run-start-option'
     Indicates that the `-exec-run' command supports the `--start'
     option (*note GDB/MI Program Execution::).


"
! !

!GDBMI_list_features methodsFor:'accessing'!

operation
	^ 'list-features'
! !


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

GDBMICommand subclass:#GDBMI_list_target_features
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_list_target_features class methodsFor:'documentation'!

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
The `-list-target-features' Command
-----------------------------------

Returns a list of particular features that are supported by the target.
Those features affect the permitted MI commands, but unlike the
features reported by the `-list-features' command, the features depend
on which target GDB is using at the moment.  Whenever a target can
change, due to commands such as `-target-select', `-target-attach' or
`-exec-run', the list of target features may change, and the frontend
should obtain it again.  Example output:

     (gdb) -list-target-features
     ^done,result=['async']

   The current list of features is:

`async'
     Indicates that the target is capable of asynchronous command
     execution, which means that {No value for `GDBN'} will accept
     further commands while the target is running.

`reverse'
     Indicates that the target is capable of reverse execution.  *Note
     Reverse Execution::, for more information.



"
! !

!GDBMI_list_target_features methodsFor:'accessing'!

operation
	^ 'list-target-features'
! !

!GDBMI_list_target_features class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

GDBMICommand subclass:#GDBMI_stack_list_variables
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_stack_list_variables class methodsFor:'documentation'!

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
The `-stack-list-variables' Command
-----------------------------------

Synopsis
........

      -stack-list-variables [ --no-frame-filters ] [ --skip-unavailable ] PRINT-VALUES

   Display the names of local variables and function arguments for the
selected frame.  If PRINT-VALUES is 0 or `--no-values', print only the
names of the variables; if it is 1 or `--all-values', print also their
values; and if it is 2 or `--simple-values', print the name, type and
value for simple data types, and the name and type for arrays,
structures and unions.  If the option `--no-frame-filters' is supplied,
then Python frame filters will not be executed.

   If the `--skip-unavailable' option is specified, local variables and
arguments that are not available are not listed.  Partially available
arguments and local variables are still displayed, however.

Example
.......

     (gdb)
     -stack-list-variables --thread 1 --frame 0 --all-values
     ^done,variables=[{name='x',value='11'},{name='s',value='{a = 1, b = 2}'}]
     (gdb)


"
! !

!GDBMI_stack_list_variables methodsFor:'accessing'!

operation
	^ 'stack-list-variables'
! !

!GDBMI_stack_list_variables methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#variables
            as:Array
            of:GDBVariable;
        yourself

    "Created: / 17-09-2014 / 00:00:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 14:58:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMI_stack_list_variables class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


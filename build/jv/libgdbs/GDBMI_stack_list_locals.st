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

GDBMICommand subclass:#GDBMI_stack_list_locals
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_stack_list_locals class methodsFor:'documentation'!

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
The `-stack-list-locals' Command
--------------------------------

Synopsis
........

      -stack-list-locals [ --no-frame-filters ] [ --skip-unavailable ] PRINT-VALUES

   Display the local variable names for the selected frame.  If
PRINT-VALUES is 0 or `--no-values', print only the names of the
variables; if it is 1 or `--all-values', print also their values; and
if it is 2 or `--simple-values', print the name, type and value for
simple data types, and the name and type for arrays, structures and
unions.  In this last case, a frontend can immediately display the
value of simple data types and create variable objects for other data
types when the user wishes to explore their values in more detail.  If
the option `--no-frame-filters' is supplied, then Python frame filters
will not be executed.

   If the `--skip-unavailable' option is specified, local variables
that are not available are not listed.  Partially available local
variables are still displayed, however.

   This command is deprecated in favor of the `-stack-list-variables'
command.

{No value for `GDBN'} Command
.............................

`info locals' in {No value for `GDBN'}, `gdb_get_locals' in `gdbtk'.

Example
.......

     (gdb)
     -stack-list-locals 0
     ^done,locals=[name='A',name='B',name='C']
     (gdb)
     -stack-list-locals --all-values
     ^done,locals=[{name='A',value='1'},{name='B',value='2'},
       {name='C',value='{1, 2, 3}'}]
     -stack-list-locals --simple-values
     ^done,locals=[{name='A',type='int',value='1'},
       {name='B',type='int',value='2'},{name='C',type='int [3]'}]
     (gdb)


"
! !

!GDBMI_stack_list_locals methodsFor:'accessing'!

operation
	^ 'stack-list-locals'
! !


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

GDBMICommand subclass:#GDBMI_info_ada_exceptions
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_info_ada_exceptions class methodsFor:'documentation'!

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
The `-info-ada-exceptions' Command
----------------------------------

Synopsis
........

      -info-ada-exceptions [ REGEXP]

   List all Ada exceptions defined within the program being debugged.
With a regular expression REGEXP, only those exceptions whose names
match REGEXP are listed.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `info exceptions'.

Result
......

The result is a table of Ada exceptions.  The following columns are
defined for each exception:

`name'
     The name of the exception.

`address'
     The address of the exception.


Example
.......

     -info-ada-exceptions aint
     ^done,ada-exceptions={nr_rows='2',nr_cols='2',
     hdr=[{width='1',alignment='-1',col_name='name',colhdr='Name'},
     {width='1',alignment='-1',col_name='address',colhdr='Address'}],
     body=[{name='constraint_error',address='0x0000000000613da0'},
     {name='const.aint_global_e',address='0x0000000000613b00'}]}

Catching Ada Exceptions
-----------------------

The commands describing how to ask {No value for `GDBN'} to stop when a
program raises an exception are described at *note Ada Exception GDB/MI
Catchpoint Commands::.


"
! !

!GDBMI_info_ada_exceptions methodsFor:'accessing'!

operation
	^ 'info-ada-exceptions'
! !


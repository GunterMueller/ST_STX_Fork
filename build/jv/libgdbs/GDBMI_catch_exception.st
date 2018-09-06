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

GDBMICommand subclass:#GDBMI_catch_exception
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_catch_exception class methodsFor:'documentation'!

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
The `-catch-exception' Command
------------------------------

Synopsis
........

      -catch-exception [ -c CONDITION] [ -d ] [ -e EXCEPTION-NAME ]
         [ -t ] [ -u ]

   Add a catchpoint stopping when Ada exceptions are raised.  By
default, the command stops the program when any Ada exception gets
raised.  But it is also possible, by using some of the optional
parameters described below, to create more selective catchpoints.

   The possible optional parameters for this command are:

`-c CONDITION'
     Make the catchpoint conditional on CONDITION.

`-d'
     Create a disabled catchpoint.

`-e EXCEPTION-NAME'
     Only stop when EXCEPTION-NAME is raised.  This option cannot be
     used combined with `-u'.

`-t'
     Create a temporary catchpoint.

`-u'
     Stop only when an unhandled exception gets raised.  This option
     cannot be used combined with `-e'.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} commands are `catch exception'
and `catch exception unhandled'.

Example
.......

     -catch-exception -e Program_Error
     ^done,bkptno='4',bkpt={number='4',type='breakpoint',disp='keep',
     enabled='y',addr='0x0000000000404874',
     what='`Program_Error' Ada exception', thread-groups=['i1'],
     times='0',original-location='__gnat_debug_raise_exception'}
     (gdb)


"
! !

!GDBMI_catch_exception methodsFor:'accessing'!

operation
	^ 'catch-exception'
! !

!GDBMI_catch_exception class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


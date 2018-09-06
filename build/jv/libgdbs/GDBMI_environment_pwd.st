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

GDBMICommand subclass:#GDBMI_environment_pwd
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_environment_pwd class methodsFor:'documentation'!

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
The `-environment-pwd' Command
------------------------------

Synopsis
........

      -environment-pwd

   Show the current working directory.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `pwd'.

Example
.......

     (gdb)
     -environment-pwd
     ^done,cwd='/kwikemart/marge/ezannoni/flathead-dev/devo/gdb'
     (gdb)


"
! !

!GDBMI_environment_pwd methodsFor:'accessing'!

operation
	^ 'environment-pwd'
! !

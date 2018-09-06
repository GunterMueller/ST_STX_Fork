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

GDBMICommand subclass:#GDBMI_exec_until
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_exec_until class methodsFor:'documentation'!

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
The `-exec-until' Command
-------------------------

Synopsis
........

      -exec-until [ LOCATION ]

   Executes the inferior until the LOCATION specified in the argument
is reached.  If there is no argument, the inferior executes until a
source line greater than the current one is reached.  The reason for
stopping in this case will be `location-reached'.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `until'.

Example
.......

     (gdb)
     -exec-until recursive2.c:6
     ^running
     (gdb)
     x = 55
     *stopped,reason='location-reached',frame={func='main',args=[],
     file='recursive2.c',fullname='/home/foo/bar/recursive2.c',line='6'}
     (gdb)


"
! !

!GDBMI_exec_until methodsFor:'accessing'!

operation
	^ 'exec-until'
! !


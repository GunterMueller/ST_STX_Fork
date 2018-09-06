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

GDBMICommand subclass:#GDBMI_catch_unload
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_catch_unload class methodsFor:'documentation'!

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
The `-catch-unload' Command
---------------------------

Synopsis
........

      -catch-unload [ -t ] [ -d ] REGEXP

   Add a catchpoint for library unload events.  If the `-t' option is
used, the catchpoint is a temporary one (*note Setting Breakpoints: Set
Breaks.).  If the `-d' option is used, the catchpoint is created in a
disabled state.  The `regexp' argument is a regular expression used to
match the name of the unloaded library.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `catch unload'.

Example
.......

     -catch-unload -d bar.so
     ^done,bkpt={number='2',type='catchpoint',disp='keep',enabled='n',
     what='load of library matching bar.so',catch-type='unload',times='0'}
     (gdb)


"
! !

!GDBMI_catch_unload methodsFor:'accessing'!

operation
	^ 'catch-unload'
! !


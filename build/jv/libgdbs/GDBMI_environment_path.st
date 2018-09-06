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

GDBMICommand subclass:#GDBMI_environment_path
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_environment_path class methodsFor:'documentation'!

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
The `-environment-path' Command
-------------------------------

Synopsis
........

      -environment-path [ -r ] [ PATHDIR ]+

   Add directories PATHDIR to beginning of search path for object files.
If the `-r' option is used, the search path is reset to the original
search path that existed at gdb start-up.  If directories PATHDIR are
supplied in addition to the `-r' option, the search path is first reset
and then addition occurs as normal.  Multiple directories may be
specified, separated by blanks.  Specifying multiple directories in a
single command results in the directories added to the beginning of the
search path in the same order they were presented in the command.  If
blanks are needed as part of a directory name, double-quotes should be
used around the name.  In the command output, the path will show up
separated by the system directory-separator character.  The
directory-separator character must not be used in any directory name.
If no directories are specified, the current path is displayed.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `path'.

Example
.......

     (gdb)
     -environment-path
     ^done,path='/usr/bin'
     (gdb)
     -environment-path /kwikemart/marge/ezannoni/flathead-dev/ppc-eabi/gdb /bin
     ^done,path='/kwikemart/marge/ezannoni/flathead-dev/ppc-eabi/gdb:/bin:/usr/bin'
     (gdb)
     -environment-path -r /usr/local/bin
     ^done,path='/usr/local/bin:/usr/bin'
     (gdb)


"
! !

!GDBMI_environment_path methodsFor:'accessing'!

operation
	^ 'environment-path'
! !


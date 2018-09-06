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

GDBMICommand subclass:#GDBMI_stack_info_depth
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_stack_info_depth class methodsFor:'documentation'!

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
The `-stack-info-depth' Command
-------------------------------

Synopsis
........

      -stack-info-depth [ MAX-DEPTH ]

   Return the depth of the stack.  If the integer argument MAX-DEPTH is
specified, do not count beyond MAX-DEPTH frames.

{No value for `GDBN'} Command
.............................

There's no equivalent {No value for `GDBN'} command.

Example
.......

For a stack with frame levels 0 through 11:

     (gdb)
     -stack-info-depth
     ^done,depth='12'
     (gdb)
     -stack-info-depth 4
     ^done,depth='4'
     (gdb)
     -stack-info-depth 12
     ^done,depth='12'
     (gdb)
     -stack-info-depth 11
     ^done,depth='11'
     (gdb)
     -stack-info-depth 13
     ^done,depth='12'
     (gdb)


"
! !

!GDBMI_stack_info_depth methodsFor:'accessing'!

operation
	^ 'stack-info-depth'
! !

!GDBMI_stack_info_depth methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#depth as:Integer;
        yourself

    "Created: / 16-09-2014 / 23:37:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMI_stack_info_depth class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

GDBMICommand subclass:#GDBMI_var_set_format
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_set_format class methodsFor:'documentation'!

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
The `-var-set-format' Command
-----------------------------

Synopsis
........

      -var-set-format NAME FORMAT-SPEC

   Sets the output format for the value of the object NAME to be
FORMAT-SPEC.

   The syntax for the FORMAT-SPEC is as follows:

      FORMAT-SPEC ==>
      {binary | decimal | hexadecimal | octal | natural}

   The natural format is the default format choosen automatically based
on the variable type (like decimal for an `int', hex for pointers,
etc.).

   For a variable with children, the format is set only on the variable
itself, and the children are not affected.


"
! !

!GDBMI_var_set_format methodsFor:'accessing'!

operation
	^ 'var-set-format'
! !

!GDBMI_var_set_format class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


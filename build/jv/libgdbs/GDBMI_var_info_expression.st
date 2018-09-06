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

GDBMICommand subclass:#GDBMI_var_info_expression
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_info_expression class methodsFor:'documentation'!

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
The `-var-info-expression' Command
----------------------------------

Synopsis
........

      -var-info-expression NAME

   Returns a string that is suitable for presenting this variable
object in user interface.  The string is generally not valid expression
in the current language, and cannot be evaluated.

   For example, if `a' is an array, and variable object `A' was created
for `a', then we'll get this output:

     (gdb) -var-info-expression A.1
     ^done,lang='C',exp='1'

Here, the value of `lang' is the language name, which can be found in
*note Supported Languages::.

   Note that the output of the `-var-list-children' command also
includes those expressions, so the `-var-info-expression' command is of
limited use.


"
! !

!GDBMI_var_info_expression methodsFor:'accessing'!

operation
	^ 'var-info-expression'
! !

!GDBMI_var_info_expression class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

GDBMICommand subclass:#GDBMI_var_info_path_expression
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_info_path_expression class methodsFor:'documentation'!

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
The `-var-info-path-expression' Command
---------------------------------------

Synopsis
........

      -var-info-path-expression NAME

   Returns an expression that can be evaluated in the current context
and will yield the same value that a variable object has.  Compare this
with the `-var-info-expression' command, which result can be used only
for UI presentation.  Typical use of the `-var-info-path-expression'
command is creating a watchpoint from a variable object.

   This command is currently not valid for children of a dynamic varobj,
and will give an error when invoked on one.

   For example, suppose `C' is a C++ class, derived from class `Base',
and that the `Base' class has a member called `m_size'.  Assume a
variable `c' is has the type of `C' and a variable object `C' was
created for variable `c'.  Then, we'll get this output:
     (gdb) -var-info-path-expression C.Base.public.m_size
     ^done,path_expr=((Base)c).m_size)


"
! !

!GDBMI_var_info_path_expression methodsFor:'accessing'!

operation
	^ 'var-info-path-expression'
! !

!GDBMI_var_info_path_expression class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


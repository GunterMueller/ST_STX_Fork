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

GDBMICommand subclass:#GDBMI_data_evaluate_expression
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_evaluate_expression class methodsFor:'documentation'!

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
The `-data-evaluate-expression' Command
---------------------------------------

Synopsis
........

      -data-evaluate-expression EXPR

   Evaluate EXPR as an expression.  The expression could contain an
inferior function call.  The function call will execute synchronously.
If the expression contains spaces, it must be enclosed in double quotes.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} commands are `print', `output',
and `call'.  In `gdbtk' only, there's a corresponding `gdb_eval'
command.

Example
.......

In the following example, the numbers that precede the commands are the
'tokens' described in *note GDB/MI Command Syntax: GDB/MI Command
Syntax.  Notice how GDB/MI returns the same tokens in its output.

     211-data-evaluate-expression A
     211^done,value='1'
     (gdb)
     311-data-evaluate-expression &A
     311^done,value='0xefffeb7c'
     (gdb)
     411-data-evaluate-expression A+3
     411^done,value='4'
     (gdb)
     511-data-evaluate-expression 'A + 3'
     511^done,value='4'
     (gdb)


"
! !

!GDBMI_data_evaluate_expression methodsFor:'accessing'!

operation
	^ 'data-evaluate-expression'
! !


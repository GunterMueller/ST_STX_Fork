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

GDBMICommand subclass:#GDBMI_var_set_frozen
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_set_frozen class methodsFor:'documentation'!

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
The `-var-set-frozen' Command
-----------------------------

Synopsis
........

      -var-set-frozen NAME FLAG

   Set the frozenness flag on the variable object NAME.  The FLAG
parameter should be either `1' to make the variable frozen or `0' to
make it unfrozen.  If a variable object is frozen, then neither itself,
nor any of its children, are implicitly updated by `-var-update' of a
parent variable or by `-var-update *'.  Only `-var-update' of the
variable itself will update its value and values of its children.
After a variable object is unfrozen, it is implicitly updated by all
subsequent `-var-update' operations.  Unfreezing a variable does not
update it, only subsequent `-var-update' does.

Example
.......

     (gdb)
     -var-set-frozen V 1
     ^done
     (gdb)


"
! !

!GDBMI_var_set_frozen methodsFor:'accessing'!

operation
	^ 'var-set-frozen'
! !


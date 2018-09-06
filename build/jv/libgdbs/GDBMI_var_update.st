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

GDBMICommand subclass:#GDBMI_var_update
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_update class methodsFor:'documentation'!

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
The `-var-update' Command
-------------------------

Synopsis
........

      -var-update [PRINT-VALUES] {NAME | '*'}

   Reevaluate the expressions corresponding to the variable object NAME
and all its direct and indirect children, and return the list of
variable objects whose values have changed; NAME must be a root
variable object.  Here, 'changed' means that the result of
`-var-evaluate-expression' before and after the `-var-update' is
different.  If `*' is used as the variable object names, all existing
variable objects are updated, except for frozen ones (*note
-var-set-frozen::).  The option PRINT-VALUES determines whether both
names and values, or just names are printed.  The possible values of
this option are the same as for `-var-list-children' (*note
-var-list-children::).  It is recommended to use the `--all-values'
option, to reduce the number of MI commands needed on each program stop.

   With the `*' parameter, if a variable object is bound to a currently
running thread, it will not be updated, without any diagnostic.

   If `-var-set-update-range' was previously used on a varobj, then
only the selected range of children will be reported.

   `-var-update' reports all the changed varobjs in a tuple named
`changelist'.

   Each item in the change list is itself a tuple holding:

`name'
     The name of the varobj.

`value'
     If values were requested for this update, then this field will be
     present and will hold the value of the varobj.

`in_scope'
     This field is a string which may take one of three values:

    `'true''
          The variable object's current value is valid.

    `'false''
          The variable object does not currently hold a valid value but
          it may hold one in the future if its associated expression
          comes back into scope.

    `'invalid''
          The variable object no longer holds a valid value.  This can
          occur when the executable file being debugged has changed,
          either through recompilation or by using the {No value for
          `GDBN'} `file' command.  The front end should normally choose
          to delete these variable objects.

     In the future new values may be added to this list so the front
     should be prepared for this possibility.  *Note GDB/MI Development
     and Front Ends: GDB/MI Development and Front Ends.

`type_changed'
     This is only present if the varobj is still valid.  If the type
     changed, then this will be the string `true'; otherwise it will be
     `false'.

     When a varobj's type changes, its children are also likely to have
     become incorrect.  Therefore, the varobj's children are
     automatically deleted when this attribute is `true'.  Also, the
     varobj's update range, when set using the `-var-set-update-range'
     command, is unset.

`new_type'
     If the varobj's type changed, then this field will be present and
     will hold the new type.

`new_num_children'
     For a dynamic varobj, if the number of children changed, or if the
     type changed, this will be the new number of children.

     The `numchild' field in other varobj responses is generally not
     valid for a dynamic varobj - it will show the number of children
     that {No value for `GDBN'} knows about, but because dynamic
     varobjs lazily instantiate their children, this will not reflect
     the number of children which may be available.

     The `new_num_children' attribute only reports changes to the
     number of children known by {No value for `GDBN'}.  This is the
     only way to detect whether an update has removed children (which
     necessarily can only happen at the end of the update range).

`displayhint'
     The display hint, if any.

`has_more'
     This is an integer value, which will be 1 if there are more
     children available outside the varobj's update range.

`dynamic'
     This attribute will be present and have the value `1' if the
     varobj is a dynamic varobj.  If the varobj is not a dynamic varobj,
     then this attribute will not be present.

`new_children'
     If new children were added to a dynamic varobj within the selected
     update range (as set by `-var-set-update-range'), then they will
     be listed in this attribute.

Example
.......

     (gdb)
     -var-assign var1 3
     ^done,value='3'
     (gdb)
     -var-update --all-values var1
     ^done,changelist=[{name='var1',value='3',in_scope='true',
     type_changed='false'}]
     (gdb)


"
! !

!GDBMI_var_update methodsFor:'accessing'!

operation
	^ 'var-update'
! !

!GDBMI_var_update methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define: #changelist as: Array of: GDBVariableObjectChange;
        yourself

    "Created: / 29-01-2018 / 20:30:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


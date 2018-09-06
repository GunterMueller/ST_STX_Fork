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

GDBMICommand subclass:#GDBMI_var_list_children
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_list_children class methodsFor:'documentation'!

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
The `-var-list-children' Command
--------------------------------

Synopsis
........

      -var-list-children [PRINT-VALUES] NAME [FROM TO]
Return a list of the children of the specified variable object and
create variable objects for them, if they do not already exist.  With a
single argument or if PRINT-VALUES has a value of 0 or `--no-values',
print only the names of the variables; if PRINT-VALUES is 1 or
`--all-values', also print their values; and if it is 2 or
`--simple-values' print the name and value for simple data types and
just the name for arrays, structures and unions.

   FROM and TO, if specified, indicate the range of children to report.
If FROM or TO is less than zero, the range is reset and all children
will be reported.  Otherwise, children starting at FROM (zero-based)
and up to and excluding TO will be reported.

   If a child range is requested, it will only affect the current call
to `-var-list-children', but not future calls to `-var-update'.  For
this, you must instead use `-var-set-update-range'.  The intent of this
approach is to enable a front end to implement any update approach it
likes; for example, scrolling a view may cause the front end to request
more children with `-var-list-children', and then the front end could
call `-var-set-update-range' with a different range to ensure that
future updates are restricted to just the visible items.

   For each child the following results are returned:

NAME
     Name of the variable object created for this child.

EXP
     The expression to be shown to the user by the front end to
     designate this child.  For example this may be the name of a
     structure member.

     For a dynamic varobj, this value cannot be used to form an
     expression.  There is no way to do this at all with a dynamic
     varobj.

     For C/C++ structures there are several pseudo children returned to
     designate access qualifiers.  For these pseudo children EXP is
     `public', `private', or `protected'.  In this case the type and
     value are not present.

     A dynamic varobj will not report the access qualifying
     pseudo-children, regardless of the language.  This information is
     not available at all with a dynamic varobj.

NUMCHILD
     Number of children this child has.  For a dynamic varobj, this
     will be 0.

TYPE
     The type of the child.  If `print object' (*note set print object:
     Print Settings.) is set to `on', the _actual_ (derived) type of
     the object is shown rather than the _declared_ one.

VALUE
     If values were requested, this is the value.

THREAD-ID
     If this variable object is associated with a thread, this is the
     thread id.  Otherwise this result is not present.

FROZEN
     If the variable object is frozen, this variable will be present
     with a value of 1.

DISPLAYHINT
     A dynamic varobj can supply a display hint to the front end.  The
     value comes directly from the Python pretty-printer object's
     `display_hint' method.  *Note Pretty Printing API::.

DYNAMIC
     This attribute will be present and have the value `1' if the
     varobj is a dynamic varobj.  If the varobj is not a dynamic varobj,
     then this attribute will not be present.


   The result may have its own attributes:

`displayhint'
     A dynamic varobj can supply a display hint to the front end.  The
     value comes directly from the Python pretty-printer object's
     `display_hint' method.  *Note Pretty Printing API::.

`has_more'
     This is an integer attribute which is nonzero if there are children
     remaining after the end of the selected range.

Example
.......

     (gdb)
      -var-list-children n
      ^done,numchild=N,children=[child={name=NAME,exp=EXP,
      numchild=N,type=TYPE},(repeats N times)]
     (gdb)
      -var-list-children --all-values n
      ^done,numchild=N,children=[child={name=NAME,exp=EXP,
      numchild=N,value=VALUE,type=TYPE},(repeats N times)]


"
! !

!GDBMI_var_list_children methodsFor:'accessing'!

operation
	^ 'var-list-children'
! !

!GDBMI_var_list_children methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#children
            as:Array
            of:GDBVariableObject;
        yourself

    "Created: / 27-01-2018 / 22:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


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

GDBMICommand subclass:#GDBMI_var_create
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_var_create class methodsFor:'documentation'!

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
The `-var-create' Command
-------------------------

Synopsis
........

      -var-create {NAME | '-'}
         {FRAME-ADDR | '*' | '@'} EXPRESSION

   This operation creates a variable object, which allows the
monitoring of a variable, the result of an expression, a memory cell or
a CPU register.

   The NAME parameter is the string by which the object can be
referenced.  It must be unique.  If `-' is specified, the varobj system
will generate a string 'varNNNNNN' automatically.  It will be unique
provided that one does not specify NAME of that format.  The command
fails if a duplicate name is found.

   The frame under which the expression should be evaluated can be
specified by FRAME-ADDR.  A `*' indicates that the current frame should
be used.  A `@' indicates that a floating variable object must be
created.

   EXPRESSION is any expression valid on the current language set (must
not begin with a `*'), or one of the following:

   * `*ADDR', where ADDR is the address of a memory cell

   * `*ADDR-ADDR' -- a memory address range (TBD)

   * `$REGNAME' -- a CPU register name

   A varobj's contents may be provided by a Python-based
pretty-printer.  In this case the varobj is known as a 'dynamic
varobj'.  Dynamic varobjs have slightly different semantics in some
cases.  If the `-enable-pretty-printing' command is not sent, then {No
value for `GDBN'} will never create a dynamic varobj.  This ensures
backward compatibility for existing clients.

Result
......

This operation returns attributes of the newly-created varobj.  These
are:

`name'
     The name of the varobj.

`numchild'
     The number of children of the varobj.  This number is not
     necessarily reliable for a dynamic varobj.  Instead, you must
     examine the `has_more' attribute.

`value'
     The varobj's scalar value.  For a varobj whose type is some sort of
     aggregate (e.g., a `struct'), or for a dynamic varobj, this value
     will not be interesting.

`type'
     The varobj's type.  This is a string representation of the type, as
     would be printed by the {No value for `GDBN'} CLI.  If `print
     object' (*note set print object: Print Settings.) is set to `on',
     the _actual_ (derived) type of the object is shown rather than the
     _declared_ one.

`thread-id'
     If a variable object is bound to a specific thread, then this is
     the thread's identifier.

`has_more'
     For a dynamic varobj, this indicates whether there appear to be any
     children available.  For a non-dynamic varobj, this will be 0.

`dynamic'
     This attribute will be present and have the value `1' if the
     varobj is a dynamic varobj.  If the varobj is not a dynamic varobj,
     then this attribute will not be present.

`displayhint'
     A dynamic varobj can supply a display hint to the front end.  The
     value comes directly from the Python pretty-printer object's
     `display_hint' method.  *Note Pretty Printing API::.

   Typical output will look like this:

      name='NAME',numchild='N',type='TYPE',thread-id='M',
       has_more='HAS_MORE'


"
! !

!GDBMI_var_create methodsFor:'accessing'!

operation
	^ 'var-create'
! !

!GDBMI_var_create methodsFor:'accessing-descriptors'!

resultDescription
    ^ GDBVariableObject description

    "Created: / 27-02-2015 / 17:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMI_var_create class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


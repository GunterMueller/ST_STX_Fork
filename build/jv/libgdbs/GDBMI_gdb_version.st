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

GDBMICommand subclass:#GDBMI_gdb_version
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_gdb_version class methodsFor:'documentation'!

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
The `-gdb-version' Command
--------------------------

Synopsis
........

      -gdb-version

   Show version information for {No value for `GDBN'}.  Used mostly in
testing.

{No value for `GDBN'} Command
.............................

The {No value for `GDBN'} equivalent is `show version'.  {No value for
`GDBN'} by default shows this information when you start an interactive
session.

Example
.......

     (gdb)
     -gdb-version
     ~GNU gdb 5.2.1
     ~Copyright 2000 Free Software Foundation, Inc.
     ~GDB is free software, covered by the GNU General Public License, and
     ~you are welcome to change it and/or distribute copies of it under
     ~ certain conditions.
     ~Type 'show copying' to see the conditions.
     ~There is absolutely no warranty for GDB.  Type 'show warranty' for
     ~ details.
     ~This GDB was configured as
      '--host=sparc-sun-solaris2.5.1 --target=ppc-eabi'.
     ^done
     (gdb)


"
! !

!GDBMI_gdb_version methodsFor:'accessing'!

operation
	^ 'gdb-version'
! !


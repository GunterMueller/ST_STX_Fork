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

GDBMICommand subclass:#GDBMI_file_list_exec_source_files
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_file_list_exec_source_files class methodsFor:'documentation'!

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
The `-file-list-exec-source-files' Command
------------------------------------------

Synopsis
........

      -file-list-exec-source-files

   List the source files for the current executable.

   It will always output both the filename and fullname (absolute file
name) of a source file.

{No value for `GDBN'} Command
.............................

The {No value for `GDBN'} equivalent is `info sources'.  `gdbtk' has an
analogous command `gdb_listfiles'.

Example
.......

     (gdb)
     -file-list-exec-source-files
     ^done,files=[
     {file=foo.c,fullname=/home/foo.c},
     {file=/home/bar.c,fullname=/home/bar.c},
     {file=gdb_could_not_find_fullpath.c}]
     (gdb)


"
! !

!GDBMI_file_list_exec_source_files methodsFor:'accessing'!

operation
	^ 'file-list-exec-source-files'
! !

!GDBMI_file_list_exec_source_files class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


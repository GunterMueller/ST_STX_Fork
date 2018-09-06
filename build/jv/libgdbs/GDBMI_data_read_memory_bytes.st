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

GDBMICommand subclass:#GDBMI_data_read_memory_bytes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_read_memory_bytes class methodsFor:'documentation'!

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
The `-data-read-memory-bytes' Command
-------------------------------------

Synopsis
........

      -data-read-memory-bytes [ -o BYTE-OFFSET ]
        ADDRESS COUNT

where:

`ADDRESS'
     An expression specifying the address of the first memory word to be
     read.  Complex expressions containing embedded white space should
     be quoted using the C convention.

`COUNT'
     The number of bytes to read.  This should be an integer literal.

`BYTE-OFFSET'
     The offsets in bytes relative to ADDRESS at which to start
     reading.  This should be an integer literal.  This option is
     provided so that a frontend is not required to first evaluate
     address and then perform address arithmetics itself.


   This command attempts to read all accessible memory regions in the
specified range.  First, all regions marked as unreadable in the memory
map (if one is defined) will be skipped.  *Note Memory Region
Attributes::.  Second, {No value for `GDBN'} will attempt to read the
remaining regions.  For each one, if reading full region results in an
errors, {No value for `GDBN'} will try to read a subset of the region.

   In general, every single byte in the region may be readable or not,
and the only way to read every readable byte is to try a read at every
address, which is not practical.   Therefore, {No value for `GDBN'} will
attempt to read all accessible bytes at either beginning or the end of
the region, using a binary division scheme.  This heuristic works well
for reading accross a memory map boundary.  Note that if a region has a
readable range that is neither at the beginning or the end, {No value
for `GDBN'} will not read it.

   The result record (*note GDB/MI Result Records::) that is output of
the command includes a field named `memory' whose content is a list of
tuples.  Each tuple represent a successfully read memory block and has
the following fields:

`begin'
     The start address of the memory block, as hexadecimal literal.

`end'
     The end address of the memory block, as hexadecimal literal.

`offset'
     The offset of the memory block, as hexadecimal literal, relative to
     the start address passed to `-data-read-memory-bytes'.

`contents'
     The contents of the memory block, in hex.


{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `x'.

Example
.......

     (gdb)
     -data-read-memory-bytes &a 10
     ^done,memory=[{begin='0xbffff154',offset='0x00000000',
                   end='0xbffff15e',
                   contents='01000000020000000300'}]
     (gdb)


"
! !

!GDBMI_data_read_memory_bytes methodsFor:'accessing'!

operation
	^ 'data-read-memory-bytes'
! !


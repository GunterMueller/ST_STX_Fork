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

GDBMICommand subclass:#GDBMI_data_write_memory_bytes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_write_memory_bytes class methodsFor:'documentation'!

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
The `-data-write-memory-bytes' Command
--------------------------------------

Synopsis
........

      -data-write-memory-bytes ADDRESS CONTENTS
      -data-write-memory-bytes ADDRESS CONTENTS [COUNT]

where:

`ADDRESS'
     An expression specifying the address of the first memory word to be
     read.  Complex expressions containing embedded white space should
     be quoted using the C convention.

`CONTENTS'
     The hex-encoded bytes to write.

`COUNT'
     Optional argument indicating the number of bytes to be written.
     If COUNT is greater than CONTENTS' length, {No value for `GDBN'}
     will repeatedly write CONTENTS until it fills COUNT bytes.


{No value for `GDBN'} Command
.............................

There's no corresponding {No value for `GDBN'} command.

Example
.......

     (gdb)
     -data-write-memory-bytes &a 'aabbccdd'
     ^done
     (gdb)

     (gdb)
     -data-write-memory-bytes &a 'aabbccdd' 16e
     ^done
     (gdb)


"
! !

!GDBMI_data_write_memory_bytes methodsFor:'accessing'!

operation
	^ 'data-write-memory-bytes'
! !


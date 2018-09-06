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

GDBMICommand subclass:#GDBMI_data_read_memory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_read_memory class methodsFor:'documentation'!

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
The `-data-read-memory' Command
-------------------------------

This command is deprecated, use `-data-read-memory-bytes' instead.

Synopsis
........

      -data-read-memory [ -o BYTE-OFFSET ]
        ADDRESS WORD-FORMAT WORD-SIZE
        NR-ROWS NR-COLS [ ASCHAR ]

where:

`ADDRESS'
     An expression specifying the address of the first memory word to be
     read.  Complex expressions containing embedded white space should
     be quoted using the C convention.

`WORD-FORMAT'
     The format to be used to print the memory words.  The notation is
     the same as for {No value for `GDBN'}'s `print' command (*note
     Output Formats: Output Formats.).

`WORD-SIZE'
     The size of each memory word in bytes.

`NR-ROWS'
     The number of rows in the output table.

`NR-COLS'
     The number of columns in the output table.

`ASCHAR'
     If present, indicates that each row should include an ASCII dump.
     The value of ASCHAR is used as a padding character when a byte is
     not a member of the printable ASCII character set (printable ASCII
     characters are those whose code is between 32 and 126,
     inclusively).

`BYTE-OFFSET'
     An offset to add to the ADDRESS before fetching memory.

   This command displays memory contents as a table of NR-ROWS by
NR-COLS words, each word being WORD-SIZE bytes.  In total, `NR-ROWS *
NR-COLS * WORD-SIZE' bytes are read (returned as `total-bytes').
Should less than the requested number of bytes be returned by the
target, the missing words are identified using `N/A'.  The number of
bytes read from the target is returned in `nr-bytes' and the starting
address used to read memory in `addr'.

   The address of the next/previous row or page is available in
`next-row' and `prev-row', `next-page' and `prev-page'.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `x'.  `gdbtk' has
`gdb_get_mem' memory read command.

Example
.......

Read six bytes of memory starting at `bytes+6' but then offset by `-6'
bytes.  Format as three rows of two columns.  One byte per word.
Display each word in hex.

     (gdb)
     9-data-read-memory -o -6 -- bytes+6 x 1 3 2
     9^done,addr='0x00001390',nr-bytes='6',total-bytes='6',
     next-row='0x00001396',prev-row='0x0000138e',next-page='0x00001396',
     prev-page='0x0000138a',memory=[
     {addr='0x00001390',data=['0x00','0x01']},
     {addr='0x00001392',data=['0x02','0x03']},
     {addr='0x00001394',data=['0x04','0x05']}]
     (gdb)

   Read two bytes of memory starting at address `shorts + 64' and
display as a single word formatted in decimal.

     (gdb)
     5-data-read-memory shorts+64 d 2 1 1
     5^done,addr='0x00001510',nr-bytes='2',total-bytes='2',
     next-row='0x00001512',prev-row='0x0000150e',
     next-page='0x00001512',prev-page='0x0000150e',memory=[
     {addr='0x00001510',data=['128']}]
     (gdb)

   Read thirty two bytes of memory starting at `bytes+16' and format as
eight rows of four columns.  Include a string encoding with `x' used as
the non-printable character.

     (gdb)
     4-data-read-memory bytes+16 x 1 8 4 x
     4^done,addr='0x000013a0',nr-bytes='32',total-bytes='32',
     next-row='0x000013c0',prev-row='0x0000139c',
     next-page='0x000013c0',prev-page='0x00001380',memory=[
     {addr='0x000013a0',data=['0x10','0x11','0x12','0x13'],ascii='xxxx'},
     {addr='0x000013a4',data=['0x14','0x15','0x16','0x17'],ascii='xxxx'},
     {addr='0x000013a8',data=['0x18','0x19','0x1a','0x1b'],ascii='xxxx'},
     {addr='0x000013ac',data=['0x1c','0x1d','0x1e','0x1f'],ascii='xxxx'},
     {addr='0x000013b0',data=['0x20','0x21','0x22','0x23'],ascii=' !!\'#'},
     {addr='0x000013b4',data=['0x24','0x25','0x26','0x27'],ascii='$%&''},
     {addr='0x000013b8',data=['0x28','0x29','0x2a','0x2b'],ascii='()*+'},
     {addr='0x000013bc',data=['0x2c','0x2d','0x2e','0x2f'],ascii=',-./'}]
     (gdb)


"
! !

!GDBMI_data_read_memory methodsFor:'accessing'!

operation
	^ 'data-read-memory'
! !

!GDBMI_data_read_memory methodsFor:'accessing-descriptors'!

resultDescription
    ^ GDBMemoryDump description

    "Created: / 25-01-2018 / 08:39:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


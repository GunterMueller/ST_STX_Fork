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

GDBMICommand subclass:#GDBMI_data_disassemble
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_disassemble class methodsFor:'documentation'!

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
The `-data-disassemble' Command
-------------------------------

Synopsis
........

      -data-disassemble
         [ -s START-ADDR -e END-ADDR ]
       | [ -f FILENAME -l LINENUM [ -n LINES ] ]
       -- MODE

Where:

`START-ADDR'
     is the beginning address (or `$pc')

`END-ADDR'
     is the end address

`FILENAME'
     is the name of the file to disassemble

`LINENUM'
     is the line number to disassemble around

`LINES'
     is the number of disassembly lines to be produced.  If it is -1,
     the whole function will be disassembled, in case no END-ADDR is
     specified.  If END-ADDR is specified as a non-zero value, and
     LINES is lower than the number of disassembly lines between
     START-ADDR and END-ADDR, only LINES lines are displayed; if LINES
     is higher than the number of lines between START-ADDR and
     END-ADDR, only the lines up to END-ADDR are displayed.

`MODE'
     is either 0 (meaning only disassembly), 1 (meaning mixed source and
     disassembly), 2 (meaning disassembly with raw opcodes), or 3
     (meaning mixed source and disassembly with raw opcodes).

Result
......

The result of the `-data-disassemble' command will be a list named
`asm_insns', the contents of this list depend on the MODE used with the
`-data-disassemble' command.

   For modes 0 and 2 the `asm_insns' list contains tuples with the
following fields:

`address'
     The address at which this instruction was disassembled.

`func-name'
     The name of the function this instruction is within.

`offset'
     The decimal offset in bytes from the start of `func-name'.

`inst'
     The text disassembly for this `address'.

`opcodes'
     This field is only present for mode 2.  This contains the raw
     opcode bytes for the `inst' field.


   For modes 1 and 3 the `asm_insns' list contains tuples named
`src_and_asm_line', each of which has the following fields:

`line'
     The line number within `file'.

`file'
     The file name from the compilation unit.  This might be an absolute
     file name or a relative file name depending on the compile command
     used.

`fullname'
     Absolute file name of `file'.  It is converted to a canonical form
     using the source file search path (*note Specifying Source
     Directories: Source Path.)  and after resolving all the symbolic
     links.

     If the source file is not found this field will contain the path as
     present in the debug information.

`line_asm_insn'
     This is a list of tuples containing the disassembly for `line' in
     `file'.  The fields of each tuple are the same as for
     `-data-disassemble' in MODE 0 and 2, so `address', `func-name',
     `offset', `inst', and optionally `opcodes'.


   Note that whatever included in the `inst' field, is not manipulated
directly by GDB/MI, i.e., it is not possible to adjust its format.

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} command is `disassemble'.

Example
.......

Disassemble from the current value of `$pc' to `$pc + 20':

     (gdb)
     -data-disassemble -s $pc -e '$pc + 20' -- 0
     ^done,
     asm_insns=[
     {address='0x000107c0',func-name='main',offset='4',
     inst='mov  2, %o0'},
     {address='0x000107c4',func-name='main',offset='8',
     inst='sethi  %hi(0x11800), %o2'},
     {address='0x000107c8',func-name='main',offset='12',
     inst='or  %o2, 0x140, %o1\t!! 0x11940 <_lib_version+8>'},
     {address='0x000107cc',func-name='main',offset='16',
     inst='sethi  %hi(0x11800), %o2'},
     {address='0x000107d0',func-name='main',offset='20',
     inst='or  %o2, 0x168, %o4\t!! 0x11968 <_lib_version+48>'}]
     (gdb)

   Disassemble the whole `main' function.  Line 32 is part of `main'.

     -data-disassemble -f basics.c -l 32 -- 0
     ^done,asm_insns=[
     {address='0x000107bc',func-name='main',offset='0',
     inst='save  %sp, -112, %sp'},
     {address='0x000107c0',func-name='main',offset='4',
     inst='mov   2, %o0'},
     {address='0x000107c4',func-name='main',offset='8',
     inst='sethi %hi(0x11800), %o2'},
     [...]
     {address='0x0001081c',func-name='main',offset='96',inst='ret '},
     {address='0x00010820',func-name='main',offset='100',inst='restore '}]
     (gdb)

   Disassemble 3 instructions from the start of `main':

     (gdb)
     -data-disassemble -f basics.c -l 32 -n 3 -- 0
     ^done,asm_insns=[
     {address='0x000107bc',func-name='main',offset='0',
     inst='save  %sp, -112, %sp'},
     {address='0x000107c0',func-name='main',offset='4',
     inst='mov  2, %o0'},
     {address='0x000107c4',func-name='main',offset='8',
     inst='sethi  %hi(0x11800), %o2'}]
     (gdb)

   Disassemble 3 instructions from the start of `main' in mixed mode:

     (gdb)
     -data-disassemble -f basics.c -l 32 -n 3 -- 1
     ^done,asm_insns=[
     src_and_asm_line={line='31',
     file='../../../src/gdb/testsuite/gdb.mi/basics.c',
     fullname='/absolute/path/to/src/gdb/testsuite/gdb.mi/basics.c',
     line_asm_insn=[{address='0x000107bc',
     func-name='main',offset='0',inst='save  %sp, -112, %sp'}]},
     src_and_asm_line={line='32',
     file='../../../src/gdb/testsuite/gdb.mi/basics.c',
     fullname='/absolute/path/to/src/gdb/testsuite/gdb.mi/basics.c',
     line_asm_insn=[{address='0x000107c0',
     func-name='main',offset='4',inst='mov  2, %o0'},
     {address='0x000107c4',func-name='main',offset='8',
     inst='sethi  %hi(0x11800), %o2'}]}]
     (gdb)


"
! !

!GDBMI_data_disassemble methodsFor:'accessing'!

operation
	^ 'data-disassemble'
! !

!GDBMI_data_disassemble methodsFor:'accessing-descriptors'!

resultDescription
    ^ (super resultDescription)
        define:#'asm_insns'
            as:Array of:GDBInstructionsAndSourceLine whenTaggedBy: 'src_and_asm_line'
                     or:GDBInstruction               whenTaggedBy: nil;
        yourself

    "
     Magritte::MADescriptionBuilder default flush.
     GDBMI_data_disassemble new resultDescription"

    "Created: / 22-06-2018 / 10:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 17:17:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


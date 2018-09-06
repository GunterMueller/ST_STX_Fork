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

GDBMICommand subclass:#GDBMI_data_list_register_values
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands-MI'
!

!GDBMI_data_list_register_values class methodsFor:'documentation'!

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
The `-data-list-register-values' Command
----------------------------------------

Synopsis
........

      -data-list-register-values
         [ `--skip-unavailable' ] FMT [ ( REGNO )*]

   Display the registers' contents.  The format according to which the
registers' contents are to be returned is given by FMT, followed by an
optional list of numbers specifying the registers to display.  A
missing list of numbers indicates that the contents of all the
registers must be returned.  The `--skip-unavailable' option indicates
that only the available registers are to be returned.

   Allowed formats for FMT are:

`x'
     Hexadecimal

`o'
     Octal

`t'
     Binary

`d'
     Decimal

`r'
     Raw

`N'
     Natural

{No value for `GDBN'} Command
.............................

The corresponding {No value for `GDBN'} commands are `info reg', `info
all-reg', and (in `gdbtk') `gdb_fetch_registers'.

Example
.......

For a PPC MBX board (note: line breaks are for readability only, they
don't appear in the actual output):

     (gdb)
     -data-list-register-values r 64 65
     ^done,register-values=[{number='64',value='0xfe00a300'},
     {number='65',value='0x00029002'}]
     (gdb)
     -data-list-register-values x
     ^done,register-values=[{number='0',value='0xfe0043c8'},
     {number='1',value='0x3fff88'},{number='2',value='0xfffffffe'},
     {number='3',value='0x0'},{number='4',value='0xa'},
     {number='5',value='0x3fff68'},{number='6',value='0x3fff58'},
     {number='7',value='0xfe011e98'},{number='8',value='0x2'},
     {number='9',value='0xfa202820'},{number='10',value='0xfa202808'},
     {number='11',value='0x1'},{number='12',value='0x0'},
     {number='13',value='0x4544'},{number='14',value='0xffdfffff'},
     {number='15',value='0xffffffff'},{number='16',value='0xfffffeff'},
     {number='17',value='0xefffffed'},{number='18',value='0xfffffffe'},
     {number='19',value='0xffffffff'},{number='20',value='0xffffffff'},
     {number='21',value='0xffffffff'},{number='22',value='0xfffffff7'},
     {number='23',value='0xffffffff'},{number='24',value='0xffffffff'},
     {number='25',value='0xffffffff'},{number='26',value='0xfffffffb'},
     {number='27',value='0xffffffff'},{number='28',value='0xf7bfffff'},
     {number='29',value='0x0'},{number='30',value='0xfe010000'},
     {number='31',value='0x0'},{number='32',value='0x0'},
     {number='33',value='0x0'},{number='34',value='0x0'},
     {number='35',value='0x0'},{number='36',value='0x0'},
     {number='37',value='0x0'},{number='38',value='0x0'},
     {number='39',value='0x0'},{number='40',value='0x0'},
     {number='41',value='0x0'},{number='42',value='0x0'},
     {number='43',value='0x0'},{number='44',value='0x0'},
     {number='45',value='0x0'},{number='46',value='0x0'},
     {number='47',value='0x0'},{number='48',value='0x0'},
     {number='49',value='0x0'},{number='50',value='0x0'},
     {number='51',value='0x0'},{number='52',value='0x0'},
     {number='53',value='0x0'},{number='54',value='0x0'},
     {number='55',value='0x0'},{number='56',value='0x0'},
     {number='57',value='0x0'},{number='58',value='0x0'},
     {number='59',value='0x0'},{number='60',value='0x0'},
     {number='61',value='0x0'},{number='62',value='0x0'},
     {number='63',value='0x0'},{number='64',value='0xfe00a300'},
     {number='65',value='0x29002'},{number='66',value='0x202f04b5'},
     {number='67',value='0xfe0043b0'},{number='68',value='0xfe00b3e4'},
     {number='69',value='0x20002b03'}]
     (gdb)


"
! !

!GDBMI_data_list_register_values methodsFor:'accessing'!

operation
	^ 'data-list-register-values'
! !

!GDBMI_data_list_register_values class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


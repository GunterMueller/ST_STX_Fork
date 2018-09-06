"{ Encoding: utf8 }"

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

SharedPool subclass:#GDBOutputFormats
	instanceVariableNames:''
	classVariableNames:'FormatAddress FormatBinary FormatCharacterConstant
		FormatFloatingPoint FormatHexadecimal FormatOctal
		FormatPaddedHexadecimal FormatRaw FormatSignedDecimal
		FormatString FormatUnsignedDecimal'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBOutputFormats class methodsFor:'documentation'!

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
    GDBOutputFormats pool defines constants for output formats
    supported by GDB.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        https://sourceware.org/gdb/onlinedocs/gdb/Output-Formats.html#Output-Formats

"
! !

!GDBOutputFormats class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ See https://sourceware.org/gdb/onlinedocs/gdb/Output-Formats.html#Output-Formats

    FormatHexadecimal := GDBOutputFormat format: $x name: 'Hexadecimal' description: 'Regard the bits of the value as an integer, and print the integer in hexadecimal.'.
    FormatSignedDecimal := GDBOutputFormat format: $d name: 'Signed decimal' description: 'Print as integer in signed decimal.'.
    FormatUnsignedDecimal := GDBOutputFormat format: $u name: 'Unsigned decimal' description: 'Print as integer in unsigned decimal.'.
    FormatOctal := GDBOutputFormat format: $o name: 'Octal' description: 'Print as integer in octal.'.
    FormatBinary := GDBOutputFormat format: $t name: 'Binary' description: 'Print as integer in binary.'.
    FormatAddress := GDBOutputFormat format: $a name: 'Address' description: 'Print as an address, both absolute in hexadecimal and as an offset from the nearest preceding symbol. You can use this format used to discover where (in what function) an unknown address is located:

(gdb) p/a 0x54320
$3 = 0x54320 <_initialize_vx+396>

The command info symbol 0x54320 yields similar results. See info symbol. '.
    FormatCharacterConstant := GDBOutputFormat format: $c name: 'Character constant' description: '    Regard as an integer and print it as a character constant. This prints both the numerical value and its character representation. The character representation is replaced with the octal escape ‘\nnn’ for characters outside the 7-bit ASCII range.

    Without this format, GDB displays char, unsigned char, and signed char data as character constants. Single-byte members of vectors are displayed as integer data.
'.
    FormatFloatingPoint := GDBOutputFormat format: $f name: 'Floating point' description: 'Regard the bits of the value as a floating point number and print using typical floating point syntax. '.
    FormatString := GDBOutputFormat format: $s name: 'String' description: 'Regard as a string, if possible. With this format, pointers to single-byte data are displayed as null-terminated strings and arrays of single-byte data are displayed as fixed-length strings. Other values are displayed in their natural types.

Without this format, GDB displays pointers to and arrays of char, unsigned char, and signed char as strings. Single-byte members of a vector are displayed as an integer array. '.
    FormatPaddedHexadecimal := GDBOutputFormat format: $x name: 'Padded hexadecimal' description: 'Like ‘x’ (hexadecimal) formatting, the value is treated as an integer and printed as hexadecimal, but leading zeros are printed to pad the value to the size of the integer type. '.
    FormatRaw := GDBOutputFormat format: $r name: 'Raw' description: 'Print using the ‘raw’ formatting. By default, GDB will use a Python-based pretty-printer, if one is available (see Pretty Printing). This typically results in a higher-level display of the value’s contents. The ‘r’ format bypasses any Python pretty-printer which might exist. '.

    "Modified: / 25-01-2018 / 09:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBOutputFormats class methodsFor:'accessing'!

all
    ^ self classVariables collect:[:name | self classVarAt: name ]

    "Created: / 26-01-2018 / 00:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


GDBOutputFormats initialize!

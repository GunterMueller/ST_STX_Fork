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

Object subclass:#GDBOutputFormat
	instanceVariableNames:'format name description'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBOutputFormat class methodsFor:'documentation'!

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
    GDBOutputFormat is a reification of one of output formats
    defined by GDB. 

    Do not use this class directly in user code, use constants 
    defined `GDBOutputFormats`

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        GDBOutputFormats
        https://sourceware.org/gdb/onlinedocs/gdb/Output-Formats.html#Output-Formats

"
! !

!GDBOutputFormat class methodsFor:'instance creation'!

format:formatArg name:nameArg description:descriptionArg 
    ^ self new format:formatArg name:nameArg description:descriptionArg 
! !

!GDBOutputFormat methodsFor:'accessing'!

description
    ^ description
!

format
    ^ format
!

name
    ^ name
! !

!GDBOutputFormat methodsFor:'displaying'!

displayString
    ^ name

    "Created: / 26-01-2018 / 00:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBOutputFormat methodsFor:'initialization'!

format:formatArg name:nameArg description:descriptionArg 
    format := formatArg.
    name := nameArg.
    description := descriptionArg.
! !


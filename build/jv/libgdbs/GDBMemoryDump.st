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

GDBObject subclass:#GDBMemoryDump
	instanceVariableNames:'addr nr_bytes total_bytes next_row prev_row next_page prev_page
		memory'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBMemoryDump class methodsFor:'documentation'!

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
    GDBMemoryDump object represents a memory dump as produced by
    `x` or `-data-read-memory` commands.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        GDBMI_data_read_memory
        https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Data-Manipulation.html

"
! !

!GDBMemoryDump class methodsFor:'accessing-magritte'!

description
    ^ (super description)
        define:#addr as:String;
        define:#nr_bytes as:Integer;
        define:#total_bytes as:Integer;
        define:#memory as: Array of: GDBMemoryDumpRow;
        yourself

    "Created: / 25-01-2018 / 08:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 17:06:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMemoryDump methodsFor:'accessing'!

addr
    ^ addr
!

memory
    ^ memory
! !

!GDBMemoryDump methodsFor:'displaying'!

displayOn: aStream
    | addrW colW |

    addrW := addr size.
    colW := memory inject: 0 into:[:w1 :r | r data inject: w1 into: [ :w2 :val | w2 max: val size ] ].
    memory do:[:row|
        aStream nextPutAll: '0x'.
        row addr printOn: aStream base: 16 size: 16 fill: $0.
        aStream nextPut: $;; space.
        row data do:[:each | 
            aStream nextPutAll: each; next: colW - each size + 2 put: Character space.
        ].
        row ascii notNil ifTrue:[ 
            aStream space; nextPutAll: row ascii.
        ].
        aStream cr.
    ].

    "Created: / 25-01-2018 / 23:07:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-07-2018 / 14:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMemoryDump methodsFor:'inspecting'!

inspector2TabCondition
    <inspector2Tab>

    ^ Tools::Inspector2Tab new
            priority: 90;
            label:'Memory';  
            text: [ self displayString ]
            yourself.

    "Created: / 25-01-2018 / 23:16:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


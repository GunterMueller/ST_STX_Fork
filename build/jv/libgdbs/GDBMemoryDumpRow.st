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

GDBObject subclass:#GDBMemoryDumpRow
	instanceVariableNames:'addr data ascii'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBMemoryDumpRow class methodsFor:'documentation'!

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
! !

!GDBMemoryDumpRow class methodsFor:'accessing-magritte'!

description
    ^ super description
        define: #addr as: Integer;
        define: #data as: Array of: String;
        define: #ascii as: String;
        yourself

    "Created: / 25-01-2018 / 08:55:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-01-2018 / 22:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMemoryDumpRow methodsFor:'accessing'!

addr
    ^ addr

    "Created: / 25-01-2018 / 08:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ascii
    ^ ascii
!

data
    ^ data
! !

!GDBMemoryDumpRow methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'(0x'.
    addr printOn:aStream base: 16 size: 16 fill: $0.
    aStream nextPutAll:': '.
    data do:[:each | each printOn: aStream ] separatedBy:[ aStream space ].
    ascii notNil ifTrue:[ 
        aStream space.
        aStream nextPutAll: ascii
    ].
    aStream nextPutAll:')'.

    "Modified: / 04-07-2018 / 13:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMemoryDumpRow class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


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

Magritte::MAElementDescription subclass:#GDBMAByteArrayDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Support'
!

!GDBMAByteArrayDescription class methodsFor:'documentation'!

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

!GDBMAByteArrayDescription class methodsFor:'accessing'!

label
	^ 'String'
! !

!GDBMAByteArrayDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!GDBMAByteArrayDescription methodsFor:'accessing'!

kind
    ^ ByteArray

    "Modified: / 22-06-2018 / 11:17:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAByteArrayDescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ aGDBMIParser parseValueAsByteArray

    "Created: / 23-09-2014 / 22:24:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2018 / 11:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAByteArrayDescription methodsFor:'testing'!

isSortable
    ^ true

    "Modified (format): / 22-06-2018 / 11:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAByteArrayDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
    aVisitor visitByteArrayDescription: self

    "Modified: / 22-06-2018 / 11:18:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


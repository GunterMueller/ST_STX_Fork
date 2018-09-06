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

GDBDebuggerObject subclass:#GDBInstruction
	instanceVariableNames:'address offset func_name inst opcodes arch dissection'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBInstruction class methodsFor:'documentation'!

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

!GDBInstruction class methodsFor:'accessing-magritte'!

descriptionContainer
    ^ super descriptionContainer
        define: #address as: Integer;
        define: #offset as: Integer;
        define: #opcodes as: ByteArray;  
        yourself

    "Created: / 22-06-2018 / 11:10:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 14:40:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstruction methodsFor:'accessing'!

address
    ^ address
!

arch
    ^ arch
!

assembly
    ^ inst

    "Created: / 22-06-2018 / 11:13:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchTarget
    dissection isNil ifTrue:[
        self dissect
    ].
    ^ dissection branchTarget

    "Created: / 16-08-2018 / 11:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 14:11:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

func
    ^ func_name

    "Created: / 22-06-2018 / 11:13:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

offset
    ^ offset
!

opcodes
    ^ opcodes
! !

!GDBInstruction methodsFor:'enumerating'!

instructionsDo: aBlock
    aBlock value: self

    "Created: / 16-08-2018 / 11:32:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstruction methodsFor:'initialization & release'!

setArchitecture: aGDBArchitecture
    arch := aGDBArchitecture

    "Created: / 16-08-2018 / 09:38:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstruction methodsFor:'private'!

dissect
    "raise an error: this method should be implemented (TODO)"

    dissection := self arch disassemble1: opcodes pc: self address

    "Created: / 16-08-2018 / 10:28:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstruction methodsFor:'testing'!

isBranch
    dissection isNil ifTrue:[
        self dissect
    ].
    ^ dissection isBranch

    "Created: / 03-07-2018 / 14:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 10:28:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isReturn
    dissection isNil ifTrue:[
        self dissect
    ].
    ^ dissection isReturn

    "Created: / 03-07-2018 / 14:39:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 14:11:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstruction class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


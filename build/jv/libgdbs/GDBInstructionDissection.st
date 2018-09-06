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

Object subclass:#GDBInstructionDissection
	instanceVariableNames:''
	classVariableNames:'Null'
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBInstructionDissection class methodsFor:'documentation'!

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

!GDBInstructionDissection class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Null := self new

    "Modified: / 16-08-2018 / 10:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionDissection class methodsFor:'accessing'!

null
    ^ Null

    "Created: / 16-08-2018 / 10:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionDissection methodsFor:'accessing'!

branchTarget
    "Return and address of next instruction if branch is taken.
     Assumes that this instruction is a branch instruction."

    self shouldNeverBeSent "since isBranchInstruction returns false"

    "Created: / 16-08-2018 / 10:33:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-08-2018 / 14:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInstructionDissection methodsFor:'testing'!

isBranch
    "Return `true` is this instruction is some sort of branch instruction."
    ^ false

    "Created: / 03-07-2018 / 14:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-08-2018 / 14:02:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isReturn
    "Return `true` is this instruction is a return"
    ^ false

    "Created: / 03-07-2018 / 14:39:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-08-2018 / 14:02:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


GDBInstructionDissection initialize!

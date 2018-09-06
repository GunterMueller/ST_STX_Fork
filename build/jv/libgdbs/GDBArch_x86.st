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

GDBArchitecture subclass:#GDBArch_x86
	instanceVariableNames:'mode disassembler buffer'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBArch_x86 class methodsFor:'documentation'!

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

!GDBArch_x86 class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    (Smalltalk includesKey:#UDIS86) ifFalse:[ 
        Smalltalk loadPackage: 'jv:dragonfly/udis86sx'.
    ].

    "/ please change as required (and remove this comment)

    "Modified: / 16-08-2018 / 13:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_x86 methodsFor:'accessing'!

name
    ^ mode == 64 ifTrue:[ 'x86_64' ] ifFalse:[ 'i386' ]

    "Created: / 16-08-2018 / 07:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 11:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_x86 methodsFor:'initialization'!

setMode: anInteger
    self assert: (anInteger == 32 or:[ anInteger == 64 ]).
    mode := anInteger.
    (Smalltalk includesKey:#UDIS86) ifTrue:[
        disassembler := (Smalltalk at:#UDIS86) new.
        disassembler mode: mode.
        buffer := ExternalBytes unprotectedNew: 16
    ].

    "Created: / 16-08-2018 / 11:00:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2018 / 07:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_x86 methodsFor:'queries'!

sizeofPointer
    ^ 8

    "Created: / 16-08-2018 / 09:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_x86 methodsFor:'utilities'!

disassemble1: bytes pc: pc
    "
    Disassemble one instruction from given bytes (as ByteArray)
    and return the instruction dissection. Returned object must
    conform to GDBInstructionDissection protocol.

    @see GDBInstructionDissection
    "
    disassembler isNil ifTrue:[ 
        "/ UDIS86 not available.
        ^ super disassemble1: bytes pc: pc
    ].
    buffer replaceBytesFrom: 1  to: bytes size with: bytes startingAt: 1.
    disassembler buffer: buffer pc: pc.
    ^ disassembler disassemble

    "Created: / 16-08-2018 / 11:07:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2018 / 14:00:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_x86 class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBArch_x86 initialize!

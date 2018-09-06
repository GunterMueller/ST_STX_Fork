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

Object subclass:#GDBArchitecture
	instanceVariableNames:''
	classVariableNames:'Architectures'
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBArchitecture class methodsFor:'documentation'!

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
    Sub-instances of GDBArchitecture models a target 
    architecture such as x86_64, PowerPC or RISC-V and
    provides architecture-specific services.

    In GDB, each frame has associated architecture (and
    may differ from architecture of other frames!!)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!GDBArchitecture class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Architectures := Dictionary new
			at: 'i386'        put: (GDBArch_x86 new setMode: 32; yourself);
			at: 'i386:x86-64' put: (GDBArch_x86 new setMode: 64; yourself);
			yourself.

    "Modified: / 16-08-2018 / 11:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArchitecture class methodsFor:'instance creation'!

named: aString
    Architectures isEmptyOrNil ifTrue:[self initialize].
    ^ Architectures 
        at: aString 
        ifAbsentPut:[GDBArch_unknown new setName: aString ].

    "
    GDBArchitecture named: 'i386:x86-64'
    GDBArchitecture named: 'mips'
    "

    "Created: / 16-08-2018 / 08:57:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-08-2018 / 11:12:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArchitecture methodsFor:'accessing'!

name
    ^ self subclassResponsibility

    "Created: / 16-08-2018 / 07:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArchitecture methodsFor:'printing & storing'!

printOn:aStream
    super printOn:aStream.
    aStream 
        nextPut: $(;
        nextPutAll: self name;
        nextPut: $).

    "Modified: / 16-08-2018 / 09:01:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArchitecture methodsFor:'queries'!

sizeofPointer
    self subclassResponsibility

    "Created: / 16-08-2018 / 09:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArchitecture methodsFor:'utilities'!

disassemble1: bytes pc: pc
    "
    Disassemble one instruction from given bytes (as ByteArray)
    and return the instruction dissection. Returned object must
    conform to GDBInstructionDissection protocol.

    @see GDBInstructionDissection
    "
    ^ GDBInstructionDissection null

    "Created: / 16-08-2018 / 10:56:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


GDBArchitecture initialize!

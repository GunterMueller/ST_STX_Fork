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

Object subclass:#GDBPTY
	instanceVariableNames:'name master slave'
	classVariableNames:''
	poolDictionaries:'TTYConstants'
	category:'GDB-Private'
!

!GDBPTY class methodsFor:'documentation'!

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

!GDBPTY class methodsFor:'instance creation'!

new
    "return an initialized instance"

    self assert: OperatingSystem isUNIXlike.
    ^ self basicNew initialize.

    "Modified: / 11-01-2018 / 22:59:14 / jv"
! !

!GDBPTY methodsFor:'accessing'!

master
    ^ master
!

name
    ^ name
!

slave
    ^ slave
! !

!GDBPTY methodsFor:'initialization & release'!

initialize
    | triplet |

    OperatingSystem isUNIXlike ifTrue:[ 
        | attrs |

        "Use a pseudo-tty"
        triplet := OperatingSystem makePTY.

        name := triplet at:3.

        "/ pty at:1 is the master;
        "/ pty at:2 is the slave
        master := NonPositionableExternalStream forReadWriteToFileDescriptor:(triplet at:1).
        master buffered:false.

        slave := NonPositionableExternalStream forReadWriteToFileDescriptor:(triplet at:2).
        slave buffered:false.
    ] ifFalse:[ 
        OperatingSystem isMSWINDOWSNTlike ifTrue:[ 
            self error: 'Windows are not (yet) supported'
        ] ifFalse:[ 
            self error: 'Operating system not supported'
        ]
    ].

    "Modified: / 31-05-2017 / 20:14:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    name := nil.
    master notNil ifTrue:[ 
        master close.
        master := nil.
    ].
    slave notNil ifTrue:[ 
        slave close.
        slave := nil.
    ].

    "Created: / 09-06-2014 / 18:25:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBPTY methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    name printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 31-05-2017 / 20:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBPTY methodsFor:'setup'!

setLocalEcho: aBoolean
    | attrs |

    attrs := master getTTYAttributes.
    aBoolean ifTrue:[ 
        attrs c_lflag: (attrs c_lflag bitOr: ECHO).
    ] ifFalse:[ 
        attrs c_lflag: (attrs c_lflag bitClear: ECHO).
    ].
    master setTTYAttributes: attrs.

    "Created: / 31-05-2017 / 20:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setOutputCRLF: aBoolean
    | attrs |

    attrs := master getTTYAttributes.
    aBoolean ifTrue:[ 
        attrs c_oflag: (attrs c_oflag bitOr: ONLCR).
    ] ifFalse:[ 
        attrs c_oflag: (attrs c_oflag bitClear: ONLCR).
    ].
    master setTTYAttributes: attrs.

    "Created: / 31-05-2017 / 20:20:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBPTY class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


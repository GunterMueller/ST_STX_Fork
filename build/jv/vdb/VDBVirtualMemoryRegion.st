"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

Object subclass:#VDBVirtualMemoryRegion
	instanceVariableNames:'address size protection comment'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Tools'
!

!VDBVirtualMemoryRegion class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBVirtualMemoryRegion methodsFor:'accessing'!

address
    ^ address
!

address:something
    address := something.
!

comment
    ^ comment
!

comment:something
    comment := something.
!

protection
    ^ protection
!

protection:something
    protection := something.
!

size
    ^ size
!

size:something
    size := something.
! !

!VDBVirtualMemoryRegion methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    | end |

    super printOn:aStream.
    aStream nextPut: $(.

    aStream nextPutAll: '0x'.
    address printOn: aStream base: 16 size: ExternalAddress sizeOfPointer * 2 fill: $0.
    end := address + size.
    aStream nextPutAll: ' - 0x'.
    end printOn: aStream base: 16 size: ExternalAddress sizeOfPointer * 2 fill: $0.


    aStream nextPut: $).

    "Modified: / 13-10-2017 / 12:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVirtualMemoryRegion class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


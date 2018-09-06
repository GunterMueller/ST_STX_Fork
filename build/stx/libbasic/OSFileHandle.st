"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

OSHandle subclass:#OSFileHandle
	instanceVariableNames:''
	classVariableNames:'ConcreteClass'
	poolDictionaries:''
	category:'System-Support'
!

!OSFileHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!OSFileHandle class methodsFor:'initialization'!

initialize
    "initialize for the OS we are running on"

    self initializeConcreteClass

    "
     self initialize
    "


!

initializeConcreteClass
    "initialize for the OS we are running on"

    OperatingSystem isMSDOSlike ifTrue:[
        ConcreteClass := Win32FILEHandle
    ] ifFalse:[
        OperatingSystem isVMSlike ifTrue:[
            ConcreteClass := OpenVMSFileHandle
        ] ifFalse:[
            OperatingSystem isUNIXlike ifTrue:[
                ConcreteClass := UnixFileHandle
            ] ifFalse:[
                ConcreteClass := nil
            ]
        ]
    ]

    "
     self initializeConcreteClass
    "

    "Modified: 7.9.1997 / 23:32:37 / cg"


!

reinitialize
    "initialize for the OS we are running on"

    self initializeConcreteClass

    "
     self reinitialize
    "

! !

!OSFileHandle methodsFor:'finalization'!

finalize
    "a filedescriptor was garbage collected - close the underlying file"

    "/ with timeout to avoid blocking in a bad pty/socket
    [
        self closeFile
    ] valueWithTimeout:30 seconds
! !

!OSFileHandle methodsFor:'input/output'!

readBytes:count into:aByteBuffer startingAt:startAddress
    "read count bytes into a byte-buffer;
     Return the number of bytes read (negative on error)"

    ^ self subclassResponsibility

!

writeBytes:count from:aByteBuffer startingAt:startAddress
    "write count bytes from a byte-buffer;
     Return the number of bytes written (negative on error)"

    ^ self subclassResponsibility

! !

!OSFileHandle methodsFor:'release'!

close
    "close the file"

    self closeFile.
    self unregisterForFinalization.
!

closeFile
    "close the underlying file"

    self subclassResponsibility

! !

!OSFileHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/OSFileHandle.st,v 1.8 2014-06-07 15:08:16 cg Exp $'
! !


OSFileHandle initialize!

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

"{ NameSpace: Smalltalk }"

ExternalAddress subclass:#OSHandle
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!OSHandle class methodsFor:'documentation'!

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
!

documentation
"
    Ongoing work: 
        extract handle specific operations and rewrite Streams, Sockets etc.
        to pass all work to these handles.

    [author:]
        Claus Gittinger
"
! !

!OSHandle class methodsFor:'initialization'!

initialize
    Lobby := Registry new.
! !

!OSHandle class methodsFor:'Compatibility-VW'!

currentOS
    "ST-80 compatibility."

    "/ mhmh what does ST80/VW returned here ?

    OperatingSystem isUNIXlike ifTrue:[^ #unix].
    OperatingSystem isOS2like  ifTrue:[^ #os2].
    OperatingSystem isMSWINDOWSlike  ifTrue:[^ #windows].
    ^ #unknown

    "
     OSHandle currentOS
    "
!

currentProcessID
    "ST-80 compatibility."

    ^ OperatingSystem getProcessId

    "
     OSHandle currentProcessID
    "

    "Created: / 30.10.2001 / 17:31:55 / cg"
! !

!OSHandle methodsFor:'finalization'!

finalizationLobby
    "answer a Registry used for finalization."

    ^ Lobby
!

finalize
    self subclassResponsibility
! !

!OSHandle methodsFor:'queries'!

handleType
    ^ self subclassResponsibility
!

isValid
     ^ self address ~~ 0
! !

!OSHandle methodsFor:'testing'!

isOsHandle
    ^ true
!

isSocketHandle
    ^ false
! !

!OSHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/OSHandle.st,v 1.15 2015-03-27 13:24:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/OSHandle.st,v 1.15 2015-03-27 13:24:38 cg Exp $'
! !


OSHandle initialize!

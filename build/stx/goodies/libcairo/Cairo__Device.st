"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ExternalAddress subclass:#Device
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Constants'
!

!Device class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libcairo.so.2'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'cairo.dll'].

    self error:'Library name for host OS is not known'
!

sizeof
    "Returns size of undelaying structure in bytes"

    ^0
! !


"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ExternalAddress subclass:#RectangleInt
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Constants'
!

!RectangleInt class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libcairo.so.2'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'cairo.dll'].

    self error:'Library name for host OS is not known'
!

sizeof
    "Returns size of undelaying structure in bytes"

    ^16
! !

!RectangleInt methodsFor:'accessing'!

height
    "Returns int32"

    ^self longAt:1 + 12
!

height: value

    self longAt:1 + 12 put:value
!

width
    "Returns int32"

    ^self longAt:1 + 8
!

width: value

    self longAt:1 + 8 put:value
!

x
    "Returns int32"

    ^self longAt:1 + 0
!

x: value

    self longAt:1 + 0 put:value
!

y
    "Returns int32"

    ^self longAt:1 + 4
!

y: value

    self longAt:1 + 4 put:value
! !


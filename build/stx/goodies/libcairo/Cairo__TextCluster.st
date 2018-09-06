"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ExternalAddress subclass:#TextCluster
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Constants'
!


!TextCluster class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libcairo.so.2'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'cairo.dll'].

    self error:'Library name for host OS is not known'
!

sizeof
    "Returns size of undelaying structure in bytes"

    ^8
! !

!TextCluster methodsFor:'accessing'!

numBytes
    "Returns int32"

    ^self longAt:1 + 0
!

numBytes: value

    self longAt:1 + 0 put:value
!

numGlyphs
    "Returns int32"

    ^self longAt:1 + 4
!

numGlyphs: value

    self longAt:1 + 4 put:value
! !

!TextCluster class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


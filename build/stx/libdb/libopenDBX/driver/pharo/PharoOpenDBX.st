"{ Package: 'stx:libdb/libopenDBX/driver/pharo' }"

OpenDBX subclass:#PharoOpenDBX
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverPharo-Dialect'
!


!PharoOpenDBX class methodsFor:'accessing'!

ffiImplementationForOS
	| platformName |
	platformName := Smalltalk os platformName.
	platformName = 'Win32' ifTrue:[ ^OpenDBXWin32 basicNew initialize].
	platformName = 'unix' ifTrue:[ ^OpenDBXUnix basicNew initialize].
	platformName = 'Mac OS' ifTrue:[ ^OpenDBXMacOSX basicNew initialize].
	self error: 'Cannot identify platform'.
!

setFFIExternalCallImplementation
		Current := self ffiImplementationForOS
!

setOpenDBXPluginImplementation
		"Current := OpenDBXPlugin new"
! !

!PharoOpenDBX class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/PharoOpenDBX.st,v 1.2 2013-04-15 13:15:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/PharoOpenDBX.st,v 1.2 2013-04-15 13:15:01 cg Exp $'
! !


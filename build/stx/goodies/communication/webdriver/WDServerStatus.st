"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDServerObject subclass:#WDServerStatus
	instanceVariableNames:'sessionId status build os'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDServerStatus comment:'Represents the server status'
!


!WDServerStatus class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!WDServerStatus methodsFor:'accessing'!

build
	^build
!

os
	^os 
! !

!WDServerStatus methodsFor:'initialization'!

initialize
	super 	initialize.
	self os: WDServerPlatform new.
	self build: WDServerBuild new
! !

!WDServerStatus methodsFor:'private - accessing'!

build: aBuild

	build := aBuild
!

os: aPlatform
	
	os := aPlatform 
! !

!WDServerStatus methodsFor:'private - initialization'!

initFromDictionary: aDictionary
 
	aDictionary at: 'value' ifPresent: [:valueDictionary | 
		valueDictionary at: 'build' ifPresent: [:buildDictionary | self build: (WDServerBuild fromDictionary: buildDictionary)].
		valueDictionary at: 'os' ifPresent: [:osDictionary | self os: (WDServerPlatform fromDictionary: osDictionary)]]
	
	
	
! !

!WDServerStatus class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerStatus.st,v 1.1 2018-06-17 06:39:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerStatus.st,v 1.1 2018-06-17 06:39:47 cg Exp $'
! !


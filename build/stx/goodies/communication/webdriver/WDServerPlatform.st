"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDServerObject subclass:#WDServerPlatform
	instanceVariableNames:'arch name version'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDServerPlatform comment:'A server operating system'
!


!WDServerPlatform class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!WDServerPlatform methodsFor:'accessing'!

arch
	"Return the current system architecture"
	
	^arch
!

arch: aString

	arch := aString
!

name
	"Return the name of the operating system the server is currently running on: 'windows', 'linux', etc"

	^name
!

name: aString

	name := aString
!

version
	"Return operating system version."
	
	 ^version
!

version: aString

	version := aString
! !

!WDServerPlatform methodsFor:'initialization'!

initialize
	super initialize.
	self 
		arch: '';
		name: '';
		version: ''
! !

!WDServerPlatform methodsFor:'private initialization'!

initFromDictionary: aDictionary
	aDictionary at: 'arch' ifPresent: [:a | self arch: a ].
	aDictionary at: 'name' ifPresent: [:n | self name: n ].
	aDictionary at: 'version' ifPresent: [:v | self version: v ].
	
	
	
! !

!WDServerPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerPlatform.st,v 1.1 2018-06-17 06:39:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerPlatform.st,v 1.1 2018-06-17 06:39:33 cg Exp $'
! !


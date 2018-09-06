"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDServerObject subclass:#WDServerBuild
	instanceVariableNames:'version revision time'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDServerBuild comment:'A server build'
!


!WDServerBuild class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!WDServerBuild methodsFor:'accessing'!

revision

	^revision
!

revision: aString

	revision := aString
!

time

	^time
!

time: aString

	time := aString
!

version

	^version
!

version: aString

	version := aString
! !

!WDServerBuild methodsFor:'initialization'!

initialize
	super initialize.
	self 
		version: '';
		revision: '';
		time: ''
! !

!WDServerBuild methodsFor:'private - initialization'!

initFromDictionary: aDictionary
	aDictionary at: 'version' ifPresent: [:v | self version: v ].
	aDictionary at: 'revision' ifPresent: [:r | self revision: r ].
	aDictionary at: 'time' ifPresent: [:t | self time: t ].
	
	
	
! !

!WDServerBuild class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerBuild.st,v 1.1 2018-06-17 06:37:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerBuild.st,v 1.1 2018-06-17 06:37:18 cg Exp $'
! !


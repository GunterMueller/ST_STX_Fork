"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDWebDriver subclass:#WDChromeDriver
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Drivers'
!

WDChromeDriver comment:'A driver for chrome'
!


!WDChromeDriver class methodsFor:'defaults'!

defaultDesiredCapabilities 

	^WDDesiredCapabilities chrome 
! !

!WDChromeDriver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDChromeDriver.st,v 1.1 2018-06-17 06:35:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDChromeDriver.st,v 1.1 2018-06-17 06:35:37 cg Exp $'
! !


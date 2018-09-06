"{ Package: 'stx:goodies/communication/webdriver/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#WDDesiredCapabilitiesTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Tests-Core-Base'
!

WDDesiredCapabilitiesTest comment:'A unit test for WDDesiredCapabilities'
!


!WDDesiredCapabilitiesTest methodsFor:'tests'!

testChrome
	
	|instance|
	instance := WDDesiredCapabilities chrome.
	self assert: (instance browserName) equals: 'chrome'
!

testFirefox
	
	|instance|
	instance := WDDesiredCapabilities firefox.
	self assert: (instance browserName) equals: 'firefox'
!

testSafari
	
	|instance|
	instance := WDDesiredCapabilities safari.
	self assert: (instance browserName) equals: 'safari'
! !

!WDDesiredCapabilitiesTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/tests/WDDesiredCapabilitiesTest.st,v 1.1 2018-06-17 06:55:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/tests/WDDesiredCapabilitiesTest.st,v 1.1 2018-06-17 06:55:11 cg Exp $'
! !


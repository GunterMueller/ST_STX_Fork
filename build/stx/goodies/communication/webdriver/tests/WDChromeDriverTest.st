"{ Package: 'stx:goodies/communication/webdriver/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#WDChromeDriverTest
	instanceVariableNames:'driver'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Tests-Core-Base-Drivers'
!

WDChromeDriverTest comment:'A unit test for WDChromeDriver class'
!


!WDChromeDriverTest methodsFor:'running'!

setUp
	super setUp.
	driver := WDChromeDriver new 
!

tearDown 
	driver quit.
	driver := nil.
	super tearDown 
! !

!WDChromeDriverTest methodsFor:'tests'!

testBaseDriverURL

	self assert: driver baseDriverURL equals: 'http://127.0.0.1:9515/'
!

testBaseStatusURL

	self assert: driver baseStatusURL equals: 'http://127.0.0.1:9515/status'
!

testInstanceCreation

	|instance|
	instance := WDChromeDriver new.
	self assert: instance isRunning.
	instance quit.
!

testRetrieveStatusObject

	self assert: driver status notNil
! !

!WDChromeDriverTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/tests/WDChromeDriverTest.st,v 1.1 2018-06-17 06:55:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/tests/WDChromeDriverTest.st,v 1.1 2018-06-17 06:55:04 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

TestCase subclass:#SptHTTPProxySettingsTest
	instanceVariableNames:'settings'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPProxySettingsTest methodsFor:'set up'!

setUp
	super setUp.
	settings := SptHTTPProxySettings new
! !

!SptHTTPProxySettingsTest methodsFor:'unit tests'!

testEmpty
	self deny: SptHTTPProxySettings new useProxy
!

testLazy
	self assert: settings proxyHost = 'localhost'.
	self assert: settings proxyPort = 8000.
!

testSetting
	settings proxyHost: 'foo'.
	settings proxyPort: 1234.
	self assert: settings proxyHost = 'foo'.
	self assert: settings proxyPort = 1234.
!

testUseProxy
	settings useProxy: true.
	self assert: settings useProxy.
	settings useProxy: false.
	self deny: settings useProxy.
! !

!SptHTTPProxySettingsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPProxySettingsTest.st,v 1.2 2011-09-23 17:58:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPProxySettingsTest.st,v 1.2 2011-09-23 17:58:55 cg Exp $'
! !

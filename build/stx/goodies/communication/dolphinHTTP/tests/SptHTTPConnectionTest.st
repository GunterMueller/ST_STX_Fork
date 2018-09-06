"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPConnectionTest
	instanceVariableNames:'connection sentClose'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPConnectionTest methodsFor:'accessing'!

cancel
	sentClose := true
! !

!SptHTTPConnectionTest methodsFor:'set up'!

setUp
	super setUp.
	connection := (SptHTTPConnection new)
				port: 80 host: 'www.foo.org';
				yourself.
	sentClose := false.
	connection socket: self
! !

!SptHTTPConnectionTest methodsFor:'unit tests'!

testCheckTimeout
	self assert: connection timeoutState = #off.
	connection checkTimeout.
	self deny: sentClose.
	self assert: connection timeoutState = #off.
	connection beTimeoutOn.
	self assert: connection timeoutState = #on.
	connection checkTimeout.
	self deny: sentClose.
	self assert: connection timeoutState = #wait.
	connection checkTimeout.
	self assert: sentClose
!

testCheckTimeoutOff
	connection beTimeoutOn.
	connection checkTimeout.
	self deny: sentClose.
	self assert: connection timeoutState = #wait.
	connection beTimeoutOff.
	connection checkTimeout.
	self assert: connection timeoutState = #off.
	self deny: sentClose
!

testHostPortString
	self assert: connection hostPortString = 'www.foo.org:80'
!

testIsStale
	self assert: connection isStale.
	connection setKeepAliveTime.
	self deny: connection isStale
! !

!SptHTTPConnectionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPConnectionTest.st,v 1.2 2011-09-23 17:58:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPConnectionTest.st,v 1.2 2011-09-23 17:58:35 cg Exp $'
! !

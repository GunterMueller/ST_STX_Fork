"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptBasicCredentialsTest
	instanceVariableNames:'credentials'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptBasicCredentialsTest methodsFor:'set up'!

setUp
	| challenge |
	super setUp.
	challenge := (SptHTTPChallenge readAllFrom: 'Basic realm="WallyWorld"' readStream) first.
	challenge absoluteUrl: 'http://www.foo.org/bar/index.html'.
	credentials := challenge 
				credentialsFor: (SptHTTPUser username: 'wally' password: 'world')
! !

!SptBasicCredentialsTest methodsFor:'unit tests'!

testHttpHeaderValue
	self assert: credentials httpHeaderValue = 'Basic d2FsbHk6d29ybGQ='
!

testIsInProtectionSpace
	self deny: (credentials isInProtectionSpace: 'http://www.foo.org/').
	self assert: (credentials isInProtectionSpace: 'http://www.foo.org/bar/baz')
! !

!SptBasicCredentialsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptBasicCredentialsTest.st,v 1.1 2011-09-23 14:37:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptBasicCredentialsTest.st,v 1.1 2011-09-23 14:37:19 cg Exp $'
! !

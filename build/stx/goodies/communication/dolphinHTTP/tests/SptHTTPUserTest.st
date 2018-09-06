"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPUserTest
	instanceVariableNames:'user'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPUserTest methodsFor:'unit tests'!

setUp
	super setUp.
	user := SptHTTPUser username: 'steve' password: 'dolphin'
!

testConstruction
	self assert: user username = 'steve'.
	self assert: user password = 'dolphin'
!

testUsers
	SptHTTPUser 
		addRealm: 'foo'
		host: 'www.bar.org'
		username: 'steve'
		password: 'dolphin'.
	user := SptHTTPUser userFor: 'foo' host: 'www.bar.org'.
	self assert: user username = 'steve'.
	self assert: user password = 'dolphin'.
	self assert: (SptHTTPUser userFor: 'bar' host: 'www.bar.org') isNil.
	self assert: (SptHTTPUser userFor: 'foo' host: 'www.foo.org') isNil
! !

!SptHTTPUserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPUserTest.st,v 1.1 2011-09-23 14:37:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPUserTest.st,v 1.1 2011-09-23 14:37:43 cg Exp $'
! !

"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPSessionStateTest
	instanceVariableNames:'state'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPSessionStateTest methodsFor:'accessing'!

setProxy
        state proxySettings: ((SptHTTPProxySettings new)
                                useProxy: true;
                                "/ proxyHost: 'aHost';
                                proxyHost: 'sixtyfour';
                                "/ proxyPort: 4321;
                                proxyPort: 3128;
                                yourself)

    "Modified: / 04-10-2011 / 14:40:48 / cg"
! !

!SptHTTPSessionStateTest methodsFor:'set up'!

setUp
	super setUp.
	state := SptHTTPSessionState new
! !

!SptHTTPSessionStateTest methodsFor:'unit tests'!

testAddCookie
	state addCookie: self getFooBarCookie.
	self assert: state cookieJar numberOfCookies = 1
!

testCookieHeaderFor
	| url |
	url := SptHTTPUrl fromString: 'http://www.foo.org/bar'.
	self assert: (state cookieHeaderFor: url) = ''.
	state addCookie: self getFooBarCookie.
	self assert: (state cookieHeaderFor: url) = 'n2=v2'
!

testInitializationDefaults
	self assert: state cookieJar class == SptHTTPCookieJar.
	self assert: state proxySettings isNil.
	self assert: state credentials isNil.
	self assert: state timeout = SptHTTPSessionState defaultTimeout.
	self assert: state maxRedirects = SptHTTPSessionState defaultMaxRedirects
!

testShouldAuthenticate
	state 
		username: 'Aladdin'
		password: 'open sesame'
		for: 'http://www.foo.org/bar/index.html'.
	self assert: (state shouldAuthenticate: 'http://www.foo.org/bar/index.html').
	self assert: (state shouldAuthenticate: 'http://www.foo.org/bar/index2.html').
	self assert: (state shouldAuthenticate: 'http://www.foo.org/bar/').
	self deny: (state shouldAuthenticate: 'http://www.foo.org/bar').
	self deny: (state shouldAuthenticate: 'http://www.foo.org/foo/index.html').
	self deny: (state shouldAuthenticate: 'http://www.NOTfoo.org/bar/index.html')
!

testUseProxy
	self deny: state useProxy.
	self setProxy.
	self assert: state useProxy.
	state proxySettings useProxy: false.
	self deny: state useProxy
!

testUsernamePasswordFor
	state 
		username: 'Aladdin'
		password: 'open sesame'
		for: 'http://www.foo.org/bar'.
	self assert: state credentials username = 'Aladdin'.
	self assert: state credentials password = 'open sesame'.
	self assert: state authorizationHeader = 'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='.
	state 
		username: 'Aladdin1'
		password: 'open sesame1'
		for: 'http://www.foo.org/bar'.
	self assert: state credentials username = 'Aladdin1'.
	self assert: state credentials password = 'open sesame1'
! !

!SptHTTPSessionStateTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPSessionStateTest.st,v 1.3 2011-10-04 13:12:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPSessionStateTest.st,v 1.3 2011-10-04 13:12:18 cg Exp $'
! !

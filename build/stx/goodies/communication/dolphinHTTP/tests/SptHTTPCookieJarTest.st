"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPCookieJarTest
	instanceVariableNames:'jar'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPCookieJarTest methodsFor:'accessing'!

getFooBarMultiplesCookie
	^SptHTTPCookie fromCookieString: 'n2=v2; n3=v3; path=/bar'
		url: (SptHTTPUrl fromString: 'http://www.foo.org/bar')
!

getFooRootCookie
	^SptHTTPCookie fromCookieString: 'n1=v1; path=/'
		url: (SptHTTPUrl fromString: 'http://www.foo.org/bar')
! !

!SptHTTPCookieJarTest methodsFor:'set up'!

setUp
	super setUp.
	jar := SptHTTPCookieJar new
! !

!SptHTTPCookieJarTest methodsFor:'unit tests'!

testCookiesFor
	| cookies |
	jar addCookie: self getFooRootCookie.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookies size = 1.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/').
	self assert: cookies size = 1
!

testCookiesForExclusion
	| cookies |
	jar addCookie: self getFooBarCookie.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookies size = 1.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/').
	self assert: cookies isEmpty.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/foo').
	self assert: cookies isEmpty
!

testCookiesForMultiples
	| cookies |
	jar addCookie: self getFooRootCookie.
	jar addCookie: self getFooBarCookie.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookies size = 2.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/').
	self assert: cookies size = 1.
	cookies := jar cookiesFor: (SptHTTPUrl fromString: 'http://www.foo.org/foo').
	self assert: cookies size = 1
!

testHeadersFor
	| cookieString |
	jar addCookie: self getFooRootCookie.
	jar addCookie: self getFooBarCookie.
	cookieString := jar headerFor: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookieString size = 'n1=v1;n2=v2' size.
	self assert: ((cookieString subStrings: $;) includes: 'n1=v1').
	self assert: ((cookieString subStrings: $;) includes: 'n2=v2').
	self assert: (jar headerFor: (SptHTTPUrl fromString: 'http://www.foo.org/')) = 'n1=v1'
!

testHeadersForMultiples
	| cookieString |
	jar addCookie: self getFooRootCookie.
	jar addCookie: self getFooBarMultiplesCookie.
	cookieString := jar headerFor: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: ((cookieString subStrings: $;) includes: 'n1=v1').
	self assert: ((cookieString subStrings: $;) includes: 'n2=v2').
	self assert: ((cookieString subStrings: $;) includes: 'n3=v3')
!

testReplaceMatching
	jar addCookie: self getFooRootCookie.
	self assert: jar numberOfCookies = 1.
	jar addCookie: (SptHTTPCookie fromCookieString: 'n=v; path=/;domain=.foo.org'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar')).
	self assert: jar numberOfCookies = 1.
	self assert: jar cookies asOrderedCollection first domain = '.foo.org'
!

testReplaceSame
	jar addCookie: self getFooRootCookie.
	self assert: jar numberOfCookies = 1.
	jar addCookie: self getFooRootCookie.
	self assert: jar numberOfCookies = 1
!

testReplaceSameNot
	jar addCookie: self getFooRootCookie.
	self assert: jar numberOfCookies = 1.
	jar addCookie: self getFooBarCookie.
	self assert: jar numberOfCookies = 2
! !

!SptHTTPCookieJarTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPCookieJarTest.st,v 1.2 2011-09-23 17:59:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPCookieJarTest.st,v 1.2 2011-09-23 17:59:09 cg Exp $'
! !

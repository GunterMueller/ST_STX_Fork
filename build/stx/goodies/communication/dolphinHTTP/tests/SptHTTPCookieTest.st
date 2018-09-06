"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPCookieTest
	instanceVariableNames:'cookie'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPCookieTest methodsFor:'unit tests'!

testAllFromMultiple
	| cookies |
	cookies := SptHTTPCookie 
				allFromSetCookieString: 'session-id=002-7620309-1728015; path=/; domain=.amazon.com; expires=Wednesday, 08-Jan-2003 08:00:00 GMT, session-id-time=1042012800; path=/; domain=.amazon.com; expires=Wednesday, 08-Jan-2003 08:00:00 GMT, obidos_path_continue-shopping=continue-shopping-url=/subst/home/home.html/002-7620309-1728015&continue-shopping-post-data=&continue-shopping-description=generic.gateway.default; path=/; domain=.amazon.com'
				url: (SptHTTPUrl fromString: 'http://www.amazon.com').
	self assert: cookies size = 3
!

testAllFromSingle
	| cookies |
	cookies := SptHTTPCookie 
				allFromSetCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=.foo.org.au'
				url: (SptHTTPUrl fromString: 'http://www.foo.org.au/bar').
	self assert: cookies size = 1
!

testDomainNotSpecialInvalid1
	self should: 
			[SptHTTPCookie fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=foo.org.au'
				url: (SptHTTPUrl fromString: 'http://www.foo.org.au/bar')]
		raise: Error.
	self should: 
			[SptHTTPCookie fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=org.au'
				url: (SptHTTPUrl fromString: 'http://www.foo.org.au/bar')]
		raise: Error
!

testDomainNotSpecialValid
	cookie := SptHTTPCookie 
				fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=.foo.org.au'
				url: (SptHTTPUrl fromString: 'http://www.foo.org.au/bar').
	self assert: cookie domain = '.foo.org.au'
!

testDomainSame
	cookie := SptHTTPCookie 
				fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=www.foo.org'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookie domain = 'www.foo.org'
!

testDomainSpecialInvalid1
	self should: 
			[SptHTTPCookie fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=foo.org'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar')]
		raise: Error
!

testDomainSpecialValid
	cookie := SptHTTPCookie 
				fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=.foo.org'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookie domain = '.foo.org'
!

testExample
	cookie := SptHTTPCookie 
				fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; expires=Wednesday, 09-Nov-99 23:12:40 GMT'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookie domain = 'www.foo.org'.
	self assert: cookie path = '/'.
	self assert: (cookie atName: 'CUSTOMER') = 'WILE_E_COYOTE'
!

testIgnoreNoEquals
	cookie := SptHTTPCookie fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; junk'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookie domain = 'www.foo.org'.
	self assert: cookie path = '/'.
	self assert: (cookie atName: 'CUSTOMER') = 'WILE_E_COYOTE'.
	self should: [cookie atName: 'junk'] raise: Error
!

testIsDomainMatch
	cookie := SptHTTPCookie newForUrl: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	#('wwww.foo.org' 'www.www.foo.org' 'www.foo.org' 'WWW.foo.org' 'foo.org') 
		do: [:each | self assert: (cookie isDomainMatch: each)].
	#('www.foo.or' 'foo.org.bar' 'foo') do: [:each | self deny: (cookie isDomainMatch: each)]
!

testIsPathMatch
	cookie := SptHTTPCookie newForUrl: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	#('/bar' '/barNoKidding' '/bar/' '/bar/foo') 
		do: [:each | self assert: (cookie isPathMatch: each)].
	#('/' '/foo' '/foo/bar' '/foobar') do: [:each | self deny: (cookie isPathMatch: each)]
!

testIsSpecialDomain
	#('www.foo.com' '.foo.com' '.foo.COM' '.foo.edu' '.foo.net' '.foo.org' '.foo.gov' '.foo.mil' '.foo.int') 
		do: [:each | self assert: (SptHTTPCookie isSpecialDomain: each)].
	#('foo.com' '.com' 'com') do: [:each | self deny: (SptHTTPCookie isSpecialDomain: each)]
!

testIsValidDomain
	#('www.abc.foo.us' '.abc.foo.us') 
		do: [:each | self assert: (SptHTTPCookie isValidDomain: each)].
	#('abc.foo.us' 'foo.us') do: [:each | self deny: (SptHTTPCookie isValidDomain: each)]
!

testMultipleNames
	cookie := SptHTTPCookie 
				fromCookieString: 'CUSTOMER=WILE_E_COYOTE; PART_NUMBER=ROCKET_LAUNCHER_0001; path=/; expires=Wednesday, 09-Nov-99 23:12:40 GMT'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookie domain = 'www.foo.org'.
	self assert: cookie path = '/'.
	self assert: (cookie atName: 'CUSTOMER') = 'WILE_E_COYOTE'.
	self assert: (cookie atName: 'PART_NUMBER') = 'ROCKET_LAUNCHER_0001'
!

testNoPath
	cookie := SptHTTPCookie fromCookieString: 'CUSTOMER=WILE_E_COYOTE'
				url: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self assert: cookie domain = 'www.foo.org'.
	self assert: cookie path = '/bar'.
	self assert: (cookie atName: 'CUSTOMER') = 'WILE_E_COYOTE'
! !

!SptHTTPCookieTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPCookieTest.st,v 1.1 2011-09-23 14:38:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPCookieTest.st,v 1.1 2011-09-23 14:38:11 cg Exp $'
! !

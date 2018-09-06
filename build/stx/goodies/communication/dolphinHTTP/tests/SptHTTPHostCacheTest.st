"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPHostCacheTest
	instanceVariableNames:'cache'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPHostCacheTest methodsFor:'accessing'!

addEntries
	cache cache at: 'www.foo.org' put: (cache newEntryForIP: #[1 2 3 4]).
	cache cache at: 'www.foo.com' put: (cache newEntryForIP: #[5 6 7 8])
!

ipAddressFromString: aString
	^#[1 1 1 1]
! !

!SptHTTPHostCacheTest methodsFor:'set up'!

setUp
	super setUp.
	cache := SptHTTPHostCache new.
	cache ipFactory: self
! !

!SptHTTPHostCacheTest methodsFor:'unit tests'!

testExpired
	self addEntries.
	(cache cache at: 'www.foo.org') at: 1
		put: Delay millisecondClockValue - (cache freshMilliseconds * 2).
	self assert: (cache ipAddressFor: 'www.foo.org') = #[1 1 1 1]
!

testIPAddrressFor
	self addEntries.
	self assert: (cache ipAddressFor: 'www.foo.org') = #[1 2 3 4].
	self assert: (cache ipAddressFor: 'www.foo.com') = #[5 6 7 8].
	self assert: (cache ipAddressFor: 'www.Notfoo.com') = #[1 1 1 1]
! !

!SptHTTPHostCacheTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPHostCacheTest.st,v 1.2 2011-09-23 17:58:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPHostCacheTest.st,v 1.2 2011-09-23 17:58:59 cg Exp $'
! !

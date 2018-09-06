"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

TestCase subclass:#SptHTTPTests
	instanceVariableNames:'usersSingleton'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPTests class methodsFor:'testing'!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self name asString last = $s
! !

!SptHTTPTests methodsFor:'accessing'!

getConnectionReading: aString
	^SptHTTPConnection new socketStream: (SZReadWriteSocketStream testStreamReading: aString)
!

getTestConfDeaf
        ^(SptHTTPConfiguration newDefault)
                httpConnectionClass: Dolphin::DeafObject current;
                httpsConnectionClass: Dolphin::DeafObject current;
                progressClass: SptHTTPTestProgress;
                yourself
! !

!SptHTTPTests methodsFor:'public'!

crlf
	^String lineDelimiter
!

getFooBarCookie
	^SptHTTPCookie fromCookieString: 'n2=v2; path=/bar'
		url: (SptHTTPUrl fromString: 'http://www.foo.org/bar')
!

setUp
	super setUp.
	usersSingleton := SptHTTPUser users.
	SptHTTPUser users: LookupTable new
!

tearDown
	super tearDown.
	SptHTTPUser users: usersSingleton
! !

!SptHTTPTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPTests.st,v 1.2 2011-09-23 17:58:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPTests.st,v 1.2 2011-09-23 17:58:44 cg Exp $'
! !

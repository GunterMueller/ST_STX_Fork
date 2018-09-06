"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPChallengeTest
	instanceVariableNames:'challenges challenge'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPChallengeTest methodsFor:'unit tests'!

assertCredentials: credentials
	self assert: (credentials isKindOf: SptBasicCredentials).
	self assert: credentials challenge == challenge.
	self assert: credentials username = 'wally'.
	self assert: credentials password = 'world'
!

testAbsoluteUrl
	challenge := SptHTTPChallenge new.
	challenge absoluteUrl: 'http://www.foo.org/'.
	self assert: challenge rootUri = 'http://www.foo.org'.
	self assert: challenge domain = '/'.
	challenge := SptHTTPChallenge new.
	challenge absoluteUrl: 'http://www.foo.org/foo'.
	self assert: challenge rootUri = 'http://www.foo.org'.
	self assert: challenge domain = '/foo'
!

testAccessing
	| auth |
	challenge := SptHTTPChallenge new.
	challenge realm: 'foo'.
	challenge scheme: 'Basic'.
	auth := SptHTTPNotAuthorized new challenge: challenge.
	self assert: auth realm = 'foo'
!

testBasic
	challenges := SptHTTPChallenge readAllFrom: 'Basic realm="WallyWorld"' readStream.
	self assert: challenges size = 1.
	challenge := challenges first.
	self assert: challenge realm = 'WallyWorld'.
	self assert: challenge isBasic.
	self assert: challenge params isEmpty
!

testBasicParams
	challenges := SptHTTPChallenge 
				readAllFrom: 'Basic realm="WallyWorld",foo1="bar1",foo2="bar2" ' readStream.
	self assert: challenges size = 1.
	challenge := challenges first.
	self assert: challenge realm = 'WallyWorld'.
	self assert: challenge isBasic.
	self assert: (challenge params at: 'foo1') = 'bar1'.
	self assert: (challenge params at: 'foo2') = 'bar2'
!

testCredentialsFor
	| credentials |
	challenge := (SptHTTPChallenge readAllFrom: 'Basic realm="WallyWorld"' readStream) first.
	credentials := challenge 
				credentialsFor: (SptHTTPUser username: 'wally' password: 'world').
	self assertCredentials: credentials.
	credentials := challenge credentialsForUsername: 'wally' password: 'world'.
	self assertCredentials: credentials
!

testDigest
	challenges := SptHTTPChallenge 
				readAllFrom: 'Digest realm="testrealm@host.com", qop="auth,auth-int", nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093", opaque="5ccc069c403ebaf9f0171e9517f40e41"' 
						readStream.
	self assert: challenges size = 1.
	challenge := challenges first.
	self assert: challenge realm = 'testrealm@host.com'.
	self assert: challenge qop = 'auth,auth-int'.
	self assert: challenge nonce = 'dcd98b7102dd2f0e8b11d0f600bfb0c093'.
	self assert: challenge opaque = '5ccc069c403ebaf9f0171e9517f40e41'
!

testIsInProtectionSpace
	challenge := SptHTTPChallenge new.
	challenge rootUri: 'http://www.foo.org'.
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/').
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar').
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar/').
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar/foo').
	self deny: (challenge isInProtectionSpace: 'http://www.NOTfoo.org/bar')
!

testIsInProtectionSpaceWithDomain
	challenge := SptHTTPChallenge new.
	challenge rootUri: 'http://www.foo.org'.
	#('/' '/bar' 'bar' '/ /bar') do: 
			[:each | 
			challenge params at: 'domain' put: each.
			self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar').
			self assert: (challenge isInProtectionSpace: 'http://www.foo.org/baz').
			self deny: (challenge isInProtectionSpace: 'http://www.NOTfoo.org/bar')].
	#('/bar/' '/bar/foo') do: 
			[:each | 
			challenge params at: 'domain' put: each.
			self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar/foo').
			self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar/foo/').
			self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar/foo/foo').
			self deny: (challenge isInProtectionSpace: 'http://www.foo.org/baz').
			self deny: (challenge isInProtectionSpace: 'http://www.NOTfoo.org/bar')].
	challenge params at: 'domain' put: '/bar /baz'.
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar').
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/baz').
	self deny: (challenge isInProtectionSpace: 'http://www.NOTfoo.org/bar').
	challenge params at: 'domain' put: 'http://www.foo.org/bar/baz'.
	self assert: (challenge isInProtectionSpace: 'http://www.foo.org/bar/baz').
	self deny: (challenge isInProtectionSpace: 'http://www.foo.org/baz').
	self deny: (challenge isInProtectionSpace: 'http://www.NOTfoo.org/bar')
!

testTwoChallenges
	challenges := SptHTTPChallenge 
				readAllFrom: 'Basic realm="WallyWorld",foo1="bar1",foo2="bar2",Digest realm="WallyLand",foo3="bar3",foo4="bar4"' 
						readStream.
	self assert: challenges size = 2.
	challenge := challenges first.
	self assert: challenge realm = 'WallyWorld'.
	self assert: challenge isBasic.
	self assert: (challenge params at: 'foo1') = 'bar1'.
	self assert: (challenge params at: 'foo2') = 'bar2'.
	challenge := challenges second.
	self assert: challenge realm = 'WallyLand'.
	self deny: challenge isBasic.
	self assert: (challenge params at: 'foo3') = 'bar3'.
	self assert: (challenge params at: 'foo4') = 'bar4'
! !

!SptHTTPChallengeTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPChallengeTest.st,v 1.1 2011-09-23 14:37:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPChallengeTest.st,v 1.1 2011-09-23 14:37:13 cg Exp $'
! !

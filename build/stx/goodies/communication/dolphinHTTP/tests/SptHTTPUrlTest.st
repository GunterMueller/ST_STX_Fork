"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPUrlTest
	instanceVariableNames:'url'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPUrlTest methodsFor:'accessing'!

assert: aCString isCanonicalOf: aString
	| aStringCanonical aCStringUncanonical |
	aStringCanonical := SptHTTPUrl canonicalize: aString.
	self assert: aStringCanonical = aCString.
	aCStringUncanonical := SptHTTPUrl uncanonicalize: aCString.
	self assert: aCStringUncanonical = aString
!

setFoo1234Bar
	url := SptHTTPUrl fromString: 'http://www.foo.org:1234/bar'
!

setFooBar
	url := SptHTTPUrl fromString: 'http://www.foo.org/bar'
!

setUrlString: aString
	url := SptHTTPUrl fromString: aString
!

setUrlString: aString previousString: aString2
	| prev |
	prev := SptHTTPUrl fromString: aString2.
	url := SptHTTPUrl fromString: aString previous: prev
!

testComparison
	self setFooBar.
	self assert: url = (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	self deny: url = (SptHTTPUrl fromString: 'http://www.Notfoo.org/bar').
	self deny: url = (SptHTTPUrl fromString: 'http://www.foo.org/not').
	self deny: url = (SptHTTPUrl fromString: 'http://www.foo.org/bar/not').
	self deny: url = (SptHTTPUrl fromString: 'http://www.foo.org:900/bar').
	url hash
! !

!SptHTTPUrlTest methodsFor:'asserting'!

assertIsFoo1234
	self assert: url host = 'www.foo.org'.
	self assert: url port = 1234
!

assertIsFoo80
	self assert: url host = 'www.foo.org'.
	self assert: url port = 80
! !

!SptHTTPUrlTest methodsFor:'unit tests'!

testCanonicalize
	self assert: 'http://www.foo.org/bar' isCanonicalOf: 'http://www.foo.org/bar'.
	self assert: 'http://www.foo.org/b%20ar' isCanonicalOf: 'http://www.foo.org/b ar'
!

testContainerOf
	#(#('http://www.foo.org/' nil) #('http://www.foo.org/foo' 'http://www.foo.org/') #('http://www.foo.org/foo/' 'http://www.foo.org/') #('http://www.foo.org/foo/bar' 'http://www.foo.org/foo/') #('http://www.foo.org/foo/bar/' 'http://www.foo.org/foo/')) 
		do: [:each | self assert: (SptHTTPUrl containerOf: each first) = each second].
	#(#('/' nil) #('/foo' '/') #('/foo/' '/') #('/foo/bar' '/foo/') #('/foo/bar/' '/foo/')) 
		do: [:each | self assert: (SptHTTPUrl containerOf: each first) = each second]
!

testDoesHostMatch
	#(#('www.foo.org' 'cache.foo.org') #('www.foo.org.au' 'cache.foo.org.au') #('www.FOO.org' 'cache.foo.org')) 
		do: 
			[:each | 
			self assert: (SptHTTPUrl doesHost: each first match: each second).
			self assert: (SptHTTPUrl doesHost: each second match: each first)].
	#(#('' 'cache.foo.org') #('foo' 'cache.foo.org') #('org' 'cache.foo.org') #('www.foo.au' 'cache.foo.au')) 
		do: 
			[:each | 
			self deny: (SptHTTPUrl doesHost: each first match: each second).
			self deny: (SptHTTPUrl doesHost: each second match: each first)]
!

testExtensionOf
	#(#('http://www.foo.org/' nil) #('http://www.foo.org/foo' nil) #('http://www.foo.org/foo.' '') #('http://www.foo.org/foo.bar' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl extensionOf: each first) = each second]
!

testHasUserInfo
	self setUrlString: 'http://u:p@www.foo.org'.
	self assert: url hasUserInfo.
	self assert: url userInfo = 'u:p'.
	self setUrlString: 'http://@www.foo.org'.
	self assert: url hasUserInfo.
	self assert: url userInfo = ''.
	self setUrlString: 'http://www.foo.org'.
	self deny: url hasUserInfo.
	self assert: url userInfo isNil
!

testHost
	self setUrlString: 'http://www.foo.org'.
	self assertIsFoo80.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org/'.
	self assertIsFoo80.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org/bar'.
	self assertIsFoo80.
	self assert: url path = '/bar'.
	self should: [self setUrlString: 'www.foo.org/bar'] raise: Error
!

testHostWithUserInfo
	self setUrlString: 'http://u:p@www.foo.org'.
	self assertIsFoo80.
	self assert: url path = '/'
!

testIsAbsolute
	#('http://foo/bar/baz' 'https://foo/bar/baz') 
		do: [:each | self assert: (SptHTTPUrl isAbsolute: each)].
	#('/foo/bar/' '/f' '/' '') do: [:each | self deny: (SptHTTPUrl isAbsolute: each)]
!

testIsChild
	#(#('http://foo/bar/baz' 'http://foo/bar/') #('http://foo/bar/baz/' 'http://foo/bar/') #('/foo' '/')) 
		do: [:each | self assert: (SptHTTPUrl is: each first childOf: each second)].
	#(#('http://foo/bar/baz/foo' 'http://foo/bar/') #('http://foo/bar/' 'http://foo/bar/') #('/' '/') #('http://foo/bar/' 'http://foo/baz/')) 
		do: [:each | self deny: (SptHTTPUrl is: each first childOf: each second)]
!

testIsCommonNonHTTPScheme
	#('http://foo/bar/baz' 'https://foo/bar/' '/q=:no' '/foo' '/' '') 
		do: [:each | self deny: (SptHTTPUrl isCommonNonHTTPScheme: each)].
	#('ftp://foo' 'FTP://foo' 'emailto:you' 'mailto:you' 'telnet://you' 'gopher://you/' 'news:you' 'NEWS:you' 'javascript:eeck') 
		do: [:each | self assert: (SptHTTPUrl isCommonNonHTTPScheme: each)]
!

testIsDescendent
	#(#('http://foo/bar/baz' 'http://foo/bar/') #('http://foo/bar/baz/foo' 'http://foo/bar/') #('/foo' '/') #('/foo/bar' '/') #('/foo/bar/' '/')) 
		do: [:each | self assert: (SptHTTPUrl is: each first descendentOf: each second)].
	#(#('http://foo/bar/' 'http://foo/bar/') #('/' '/') #('http://foo/bar/' 'http://foo/baz/')) 
		do: [:each | self deny: (SptHTTPUrl is: each first descendentOf: each second)]
!

testIsDescendentOrSelf
	#(#('http://foo/bar/baz' 'http://foo/bar/') #('http://foo/bar/baz/foo' 'http://foo/bar/') #('/foo' '/') #('/foo/bar' '/') #('/foo/bar/' '/') #('http://foo/bar/' 'http://foo/bar/') #('/' '/')) 
		do: [:each | self assert: (SptHTTPUrl is: each first descendentOrSelfOf: each second)].
	#(#('http://foo/bar/' 'http://foo/baz/')) 
		do: [:each | self deny: (SptHTTPUrl is: each first descendentOrSelfOf: each second)]
!

testLastSegment
	#(#('http://host/' '/') #('http://host/foo' 'foo') #('http://host/foo/' 'foo') #('http://host/foo/bar' 'bar') #('http://host/foo/bar/' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl fromString: each first) lastSegment = each second].
	#(#('http://host/foo/bar' 'bar') #('http://host/foo/bar?boo' 'bar') #('http://host/foo/bar?boo/' 'bar') #('http://host/foo/bar?boo/boo' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl fromString: each first) lastSegment = each second]
!

testLastSegmentAndQuery
	#(#('http://host/' '/') #('http://host/foo' 'foo') #('http://host/foo/' 'foo') #('http://host/foo/bar' 'bar') #('http://host/foo/bar/' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl fromString: each first) lastSegmentAndQuery = each second].
	#(#('http://host/foo/bar' 'bar') #('http://host/foo/bar?boo' 'bar?boo') #('http://host/foo/bar?boo/' 'bar?boo/') #('http://host/foo/bar?boo/boo' 'bar?boo/boo')) 
		do: [:each | self assert: (SptHTTPUrl fromString: each first) lastSegmentAndQuery = each second]
!

testLastSegmentOf
	#(#('/' '/') #('/foo' 'foo') #('/foo/' 'foo') #('/foo/bar' 'bar') #('/foo/bar/' 'bar') #('http://host/' '/') #('http://host/foo' 'foo') #('http://host/foo/' 'foo') #('http://host/foo/bar' 'bar') #('http://host/foo/bar/' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl lastSegmentOf: each first) = each second].
	#(#('http://host/foo/bar' 'bar') #('http://host/foo/bar?boo' 'bar') #('http://host/foo/bar?boo/' 'bar') #('http://host/foo/bar?boo/boo' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl lastSegmentOf: each first) = each second]
	"#(#('http://host/foo/bar' 'bar') #('http://host/foo/bar#boo' 'bar') #('http://host/foo/bar#boo/' 'bar') #('http://host/foo/bar#boo/boo' 'bar')) 
		do: [:each | self assert: (SptHTTPUrl lastSegmentOf: each first) = each second]"
!

testMakeAbsoluteAbsolute
	self setUrlString: 'http://www.foo.org/bar' previousString: 'http://www.foo.org/bar'.
	self assertIsFoo80.
	self assert: url absolutePath = '/bar'.
	self setUrlString: 'http://www.foo.org/bar?q=v' previousString: 'http://www.foo.org/bar'.
	self assertIsFoo80.
	self assert: url absolutePath = '/bar?q=v'
!

testMakeAbsoluteAbsolutePath
	self setUrlString: 'bar2' previousString: 'http://www.foo.org/baz/bar'.
	self assertIsFoo80.
	self assert: url absolutePath = '/baz/bar2'.
	self setUrlString: 'bar2?q1=v1' previousString: 'http://www.foo.org/baz/bar?q=v'.
	self assertIsFoo80.
	self assert: url absolutePath = '/baz/bar2?q1=v1'
!

testMakeAbsoluteAbsolutePathQuery
	self setUrlString: 'bar2' previousString: 'http://www.foo.org/baz/bar?q=s'.
	self assertIsFoo80.
	self assert: url path = '/baz/bar2'.
	self assert: url absolutePath = '/baz/bar2'
!

testMakeAbsoluteAbsolutePathSeg
	self setUrlString: 'bar2' previousString: 'http://www.foo.org/baz/bar#s'.
	self assertIsFoo80.
	self assert: url absolutePath = '/baz/bar2'
!

testMakeAbsoluteAbsolutePathSlash
	self setUrlString: 'bar2' previousString: 'http://www.foo.org/baz/bar/'.
	self assertIsFoo80.
	self assert: url absolutePath = '/baz/bar/bar2'
!

testMakeAbsoluteLocal
	self setUrlString: '/bar2' previousString: 'http://www.foo.org/baz/bar'.
	self assertIsFoo80.
	self assert: url absolutePath = '/bar2'
!

testMakeAbsoluteLocalQuery
	self setUrlString: '/bar2' previousString: 'http://www.foo.org/baz/bar?q=v'.
	self assertIsFoo80.
	self assert: url absolutePath = '/bar2'
!

testMakeAbsoluteRel
	self setUrlString: '../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/x'.
	self setUrlString: '../../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/x'.
	self setUrlString: '../../../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: '../foo' previousString: 'http://www.foo.org/bar/a1'.
	self assert: url urlString = 'http://www.foo.org/foo'
!

testMakeAbsoluteRelDotSlash
	self setUrlString: './x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/b/x'.
	self setUrlString: './../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/x'.
	self setUrlString: './x/..' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/b/x'
!

testMakeAbsoluteRelError
	self setUrlString: '../x' previousString: 'http://www.ics.uci.edu/Test'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: '../../x' previousString: 'http://www.ics.uci.edu/Test/a'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'
!

testMakeAbsoluteRelRoot
	self setUrlString: 'x' previousString: 'http://www.ics.uci.edu/'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: '../x' previousString: 'http://www.ics.uci.edu/'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: './x' previousString: 'http://www.ics.uci.edu/'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: '././x' previousString: 'http://www.ics.uci.edu/'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: 'x.' previousString: 'http://www.ics.uci.edu/'.
	self assert: url urlString = 'http://www.ics.uci.edu/x.'
!

testMakeAbsoluteRelUp
	self setUrlString: '../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/x'.
	self setUrlString: '../../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/x'.
	self setUrlString: '../../../x' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/x'.
	self setUrlString: '../x.' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/x.'.
	self setUrlString: '../x/.' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/x/'.
	self setUrlString: '../x/..' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/x'.
	self setUrlString: 'x/..' previousString: 'http://www.ics.uci.edu/Test/a/b/c'.
	self assert: url urlString = 'http://www.ics.uci.edu/Test/a/b/x'
!

testMakeUrlRefString
	#(#('http://foo/bar/baz' 'http://foo/bar/baz') #('https://foo/bar/baz' 'https://foo/bar/baz') #('HTTP://foo/bar/baz' 'http://foo/bar/baz') #('HTTPS://foo/bar/baz' 'https://foo/bar/baz')) 
		do: [:each | self assert: (SptHTTPUrl makeUrlRefString: each first) = each second].
	#(#('www.foo/bar/baz' 'http://www.foo/bar/baz') #('WWW.foo/bar/baz' 'http://WWW.foo/bar/baz') #('foo/bar/baz' 'http://www.foo/bar/baz')) 
		do: [:each | self assert: (SptHTTPUrl makeUrlRefString: each first) = each second]
!

testPath
	self setUrlString: 'http://www.foo.org'.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org/'.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org/?q'.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org/bar?q'.
	self assert: url path = '/bar'.
	self setUrlString: 'http://www.foo.org/bar/?q'.
	self assert: url path = '/bar/'
!

testPort
	self setUrlString: 'http://www.foo.org:1234'.
	self assertIsFoo1234.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org:1234/'.
	self assertIsFoo1234.
	self assert: url path = '/'.
	self setUrlString: 'http://www.foo.org:1234/bar'.
	self assertIsFoo1234.
	self assert: url path = '/bar'.
	self setUrlString: 'http://www.foo.org:1234/bar?baz'.
	self assertIsFoo1234.
	self assert: url absolutePath = '/bar?baz'.
	self assert: url path = '/bar'.
	self should: [self setUrlString: 'www.foo.org:1234/bar'] raise: Error
!

testPortHTTPS
	self setUrlString: 'https://www.foo.org:1234'.
	self assert: url port = 1234.
	self setUrlString: 'https://www.foo.org/'.
	self assert: url port = 443
!

testQueryStringsMultiple
	| ans |
	url := SptHTTPUrl fromString: 'http://foo/bar/baz?a=b&c'.
	ans := url queryStrings.
	self assert: ans size = 2.
	self assert: ans first = ('a' -> 'b').
	self assert: ans second = ('c' -> nil).
	""
	url := SptHTTPUrl fromString: 'http://foo/bar/baz?a=b&c=d'.
	ans := url queryStrings.
	self assert: ans size = 2.
	self assert: ans first = ('a' -> 'b').
	self assert: ans second = ('c' -> 'd')
!

testQueryStringsNone
	url := SptHTTPUrl fromString: 'http://foo/bar/baz'.
	self assert: url queryStrings isEmpty.
	url := SptHTTPUrl fromString: 'http://foo/bar/baz?'.
	self assert: url queryStrings isEmpty
!

testQueryStringsOne
	| ans |
	url := SptHTTPUrl fromString: 'http://foo/bar/baz?a'.
	ans := url queryStrings.
	self assert: ans size = 1.
	self assert: ans first = ('a' -> nil).
	""
	url := SptHTTPUrl fromString: 'http://foo/bar/baz?a=b'.
	ans := url queryStrings.
	self assert: ans size = 1.
	self assert: ans first = ('a' -> 'b')
!

testQueryStringsWithQ
	| ans |
	url := SptHTTPUrl fromString: 'http://foo/bar/baz?a=b?c'.
	ans := url queryStrings.
	self assert: ans size = 1.
	self assert: ans first = ('a' -> 'b?c')
!

testSplitExtension
	#(#('http://foo/bar' nil) #('http://foo/bar.' '') #('http://foo/bar.html' 'html') #('http://foo/bar/' nil) #('http://foo/bar/baz.html' 'html')) 
		do: [:each | self assert: (SptHTTPUrl extensionOf: each first) = each second]
!

testSplitFragment
	self assert: (SptHTTPUrl splitFragmentOf: 'http://foo/bar') = #('http://foo/bar' nil).
	self assert: (SptHTTPUrl splitFragmentOf: 'http://foo/bar#') = #('http://foo/bar' '').
	self 
		assert: (SptHTTPUrl splitFragmentOf: 'http://foo/bar#baz') = #('http://foo/bar' 'baz').
	self assert: (SptHTTPUrl splitFragmentOf: '#baz') = #('' 'baz')
! !

!SptHTTPUrlTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPUrlTest.st,v 1.2 2011-09-23 17:58:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPUrlTest.st,v 1.2 2011-09-23 17:58:40 cg Exp $'
! !

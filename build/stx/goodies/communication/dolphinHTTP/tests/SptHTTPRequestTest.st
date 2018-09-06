"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPRequestTest
	instanceVariableNames:'request sentClose'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPRequestTest methodsFor:'accessing'!

addResponseParsing: aString
	self setConnectionReading: aString.
	request readResponse
!

addUserAladdin
	SptHTTPUser 
		addRealm: 'WallyWorld'
		host: 'www.foo.org'
		username: 'Aladdin'
		password: 'open sesame'
!

cancel
	sentClose := true
!

close
	sentClose := true
!

getSampleCookie
	^SptHTTPCookie fromCookieString: 'CUSTOMER=WILE_E_COYOTE; path=/; domain=www.foo.org'
		url: (SptHTTPUrl fromString: 'http://www.foo.org/bar')
!

getSentString
	^request socketStream writeStream contents asString
!

openGetFoo1234Bar
	request openGetTo: 'http://www.foo.org:1234/bar'
!

openGetFooBar
	request openGetTo: 'http://www.foo.org/bar'
!

progressMessages
	^request progress sentMessages
!

proxyHost
    "/ ^ 'aHost'
    ^ 'sixtyfour'

    "Created: / 04-10-2011 / 14:44:26 / cg"
!

proxyPort
    "/ ^ 4321
    ^ 3128

    "Created: / 04-10-2011 / 14:44:41 / cg"
!

setAuthenticateResponse
	self openGetFooBar.
	request responses add: SptHTTPResponse new.
	request lastResponse statusLine: 'HTTP/1.1 401'.
	request lastResponse parseHeaderLine: 'WWW-Authenticate: Basic realm="WallyWorld"'
!

setConnectionReading: aString
	request connection: (self getConnectionReading: aString)
!

setNewProgressRequest
	request := SptHTTPRequest newFor: self getTestConfDeaf.
	self openGetFooBar.
	self setConnectionReading: ''
!

setNewRequest
	request := SptHTTPRequest new
!

setProxy
        request proxySettings: (SptHTTPProxySettings new
                useProxy: true;
                proxyHost: self proxyHost;
                proxyPort: self proxyPort;
                yourself)

    "Modified: / 04-10-2011 / 14:44:56 / cg"
!

testAddCookie
	self openGetFooBar.
	request state addCookie: self getSampleCookie.
	request addRequiredHeaders.
	self assert: (request headers at: 'Cookie') = 'CUSTOMER=WILE_E_COYOTE'
!

testAddCookieNot
	self openGetFooBar.
	request state addCookie: self getSampleCookie.
	request isUseCookies: false.
	request addRequiredHeaders.
	self deny: (request headers includesKey: 'Cookie')
!

testEntityString
	request entityString: 'Hi'.
	self assert: request entity class = SptHTTPEntity.
	self assert: request entity stream contents asString = 'Hi'.
	self assert: request entity contentLength = 2.
	self deny: request entity hasContentType
! !

!SptHTTPRequestTest methodsFor:'asserting'!

assertIsFoo1234
	self assert: request url host = 'www.foo.org'.
	self assert: request url port = 1234
!

assertIsFoo80
	self assert: request url host = 'www.foo.org'.
	self assert: request url port = 80
!

assertSentString: aString
	| sentString |
	self assert: (sentString := self getSentString) = aString
! !

!SptHTTPRequestTest methodsFor:'set up'!

setUp
	super setUp.
	self setNewRequest.
	sentClose := false
!

tearDown
	super tearDown.
	request notNil ifTrue: [request terminateTimeoutLoop]
! !

!SptHTTPRequestTest methodsFor:'unit tests'!

testCanRangeRetry
	self addResponseParsing: 'HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Length: 0

'.
	self assert: request canRangeRetry
!

testCanRangeRetryNoResponse
	self deny: request canRangeRetry
!

testCanRangeRetryNot
	self 
		addResponseParsing: 'HTTP/1.1 200 OK
Accept-Ranges: bytes
transfer-encoding: chunked

0

'.
	self deny: request canRangeRetry
!

testCanRangeRetryNot2
	self addResponseParsing: 'HTTP/1.1 404 NF
Accept-Ranges: bytes

'.
	self deny: request canRangeRetry
!

testConfAccessing
	| conf |
	conf := SptHTTPConfiguration newDefault.
	conf sendEntityBufferSize: 1.
	conf readEntityBufferSize: 2.
	request := SptHTTPRequest newFor: conf.
	self assert: request sendEntityBufferSize = 1.
	self assert: request readEntityBufferSize = 2
!

testHost
	request urlString: 'http://www.foo.org'.
	self assertIsFoo80.
	self assert: request url absolutePath = '/'.
	request urlString: 'http://www.foo.org/'.
	self assertIsFoo80.
	self assert: request url absolutePath = '/'.
	request urlString: 'http://www.foo.org/bar'.
	self assertIsFoo80.
	self assert: request url absolutePath = '/bar'
!

testImmediatesWithProxy
        request urlString: 'http://www.foo.org:1234'.
        self setProxy.
        self assert: request immediateHost = (self proxyHost).
        self assert: request immediatePort = (self proxyPort).
        request proxySettings useProxy: false.
        self assert: request immediateHost = 'www.foo.org'.
        self assert: request immediatePort = 1234

    "Modified: / 04-10-2011 / 14:45:15 / cg"
!

testIsIdempotent
	request := SptHTTPRequest new open: 'GET' to: 'http://www.foo.org/'.
	self assert: request isIdempotent.
	request := SptHTTPRequest new open: 'OPTIONS' to: 'http://www.foo.org/'.
	self assert: request isIdempotent.
	request := SptHTTPRequest new open: 'POST' to: 'http://www.foo.org/'.
	self deny: request isIdempotent
!

testPort
	request urlString: 'http://www.foo.org:1234'.
	self assertIsFoo1234.
	self assert: request url absolutePath = '/'.
	request urlString: 'http://www.foo.org:1234/'.
	self assertIsFoo1234.
	self assert: request url absolutePath = '/'.
	request urlString: 'http://www.foo.org:1234/bar'.
	self assertIsFoo1234.
	self assert: request url absolutePath = '/bar'.
	request urlString: 'http://www.foo.org:1234/bar?baz'.
	self assertIsFoo1234.
	self assert: request url absolutePath = '/bar?baz'
!

testPortWithProxy
        self setProxy.
        request urlString: 'http://www.foo.org:1234'.
        self assert: request immediateHost = (self proxyHost).
        self assert: request immediatePort = (self proxyPort)

    "Modified: / 04-10-2011 / 14:45:49 / cg"
!

testPrepareAuthorizeNoUser
	self setAuthenticateResponse.
	self should: [request prepareForAuthorize] raise: SptHTTPNotAuthorized
!

testPrepareAuthorizeUser
	self setAuthenticateResponse.
	self addUserAladdin.
	request prepareForAuthorize.
	self assert: request state authorizationHeader = 'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
!

testPrepareAuthorizeUserTwice
	self setAuthenticateResponse.
	request addHeader: 'Authorization' value: 'doesntmatter'.
	self addUserAladdin.
	self should: [request prepareForAuthorize] raise: SptHTTPNotAuthorized
!

testPrepareForRetryNoRange
	self openGetFooBar.
	request addRequiredHeaders.
	request okBodyStream: ByteArray writeStream.
	"Ignore the error as it is part of the setup"
	
	[self addResponseParsing: 'HTTP/1.1 200
Content-Length: 10000

' 
				, (String new: 5000 withAll: $a)] 
			on: Error
			do: [:e | ].
	request prepareForRetry.
	self deny: request isRangeRequest.
	self deny: (request headers includesKey: 'Range').
	self assert: request okBodyStream position = 0
!

testPrepareForRetryNoneRead
	self openGetFooBar.
	request addRequiredHeaders.
	request okBodyStream: ByteArray writeStream.
	"Ignore the error as it is part of the setup"
	[self addResponseParsing: 'HTTP/1.1 200
Content-Length: 10
Accept-Ranges: bytes

'] 
		on: Error
		do: [:e | ].
	request prepareForRetry.
	self deny: request isRangeRequest.
	self deny: (request headers includesKey: 'Range').
	self assert: request okBodyStream position = 0
!

testPrepareForRetryRange
	self openGetFooBar.
	request addRequiredHeaders.
	request okBodyStream: ByteArray writeStream.
	"Ignore the error as it is part of the setup"
	
	[self addResponseParsing: 'HTTP/1.1 200
Content-Length: 10000
Accept-Ranges: bytes

' 
				, (String new: 5000 withAll: $a)] 
			on: Error
			do: [:e | ].
	request prepareForRetry.
	self assert: request isRangeRequest.
	"mmm this depends on SptHTTPResponse(class)>>readEntityChunkSize"
	self assert: (request headerAt: 'Range') = 'bytes=4096-9999'.
	self assert: request okBodyStream position = 0
!

testPrepareRedirectDiffHost
	self openGetFooBar.
	request username: 'Aladdin' password: 'open sesame'.
	request addRequiredHeaders.
	self assert: (request headers includesKey: 'Authorization').
	self addResponseParsing: 'HTTP/1.0 301
Location: http://www.Notfoo.org/baz

Hi Wrong'.
	request prepareForRedirect.
	self deny: (request headers includesKey: 'Authorization')
!

testPrepareRedirectLoop
	| coll |
	coll := OrderedCollection new.
	self openGetFooBar.
	coll add: request urlString.
	self addResponseParsing: 'HTTP/1.0 301
Location: http://www.foo.org/bar

Hi Wrong'.
	"SW 20021212 ... changed so that same site can have two requests"
	request prepareNextMessage: coll.
	coll add: 'http://www.foo.org/bar'.
	request prepareNextMessage: coll.
	coll add: 'http://www.foo.org/bar'.
	self should: [request prepareNextMessage: coll] raise: Error
!

testPrepareRedirectNone
	| coll |
	coll := OrderedCollection new.
	self openGetFooBar.
	self addResponseParsing: 'HTTP/1.0 200

Hi'.
	self deny: (request prepareNextMessage: coll).
	self assert: request status = 200.
	self assert: request responseBody = 'Hi'
!

testPrepareRedirectOne
	| coll |
	coll := OrderedCollection new.
	self openGetFooBar.
	coll add: request urlString.
	self addResponseParsing: 'HTTP/1.0 301
Location: http://www.foo.org/baz

Hi Wrong'.
	self assert: (request prepareNextMessage: coll).
	self assert: request status = 301
	"self assert: request responseBody isNil.
	self assert: request responseHeaders isEmpty"
!

testProgressConnect
	self setNewProgressRequest.
	request connect.
	self assert: self progressMessages first selector = #onConnecting.
	self assert: self progressMessages second selector = #onConnected
!

testProgressMessageBody
	self setNewProgressRequest.
	request setEntityOn: 'abc123'.
	request sendMessageBody.
	self assert: self progressMessages first selector = #onSendingEntity.
	self assert: self progressMessages second selector = #sent:of:.
	self assert: self progressMessages second arguments = #(6 6).
	self assert: self progressMessages third selector = #onSentEntity
!

testProgressMessageHeaders
	self setNewProgressRequest.
	request sendMessageHeaders.
	self assert: self progressMessages first selector = #onSendingHeaders.
	self assert: self progressMessages second selector = #onSentHeaders
!

testSendAbsentHeader
	self setConnectionReading: ''.
	request addIfAbsentHeader: 'abc' value: 'def'.
	self assert: (request headers at: 'abc') = 'def'.
	self setConnectionReading: ''.
	request addHeader: 'abc' value: 123.
	request addIfAbsentHeader: 'abc' value: 'def'.
	self assert: (request headers at: 'abc') = 123
!

testSendGetRequest
        | contents |
        self openGetFooBar.
        self setConnectionReading: ''.
        request sendMessageStart.
        request sendMessageHeaders.
        contents := self getSentString.
        self assert: (contents beginsWith: 'GET /bar HTTP/1.1').
        self deny: ('*Content-Length:*' match: contents ignoreCase: true)

    "Modified (format): / 23-09-2011 / 21:08:29 / cg"
!

testSendGetRequestEntity
        | contents |
        self openGetFooBar.
        self setConnectionReading: ''.
        request setEntityOn: 'abc123'.
        request sendMessageStart.
        request sendMessageHeaders.
        self assert: request hasEntity.
        request sendMessageBody.
        contents := self getSentString.
        self assert: (contents beginsWith: 'GET /bar HTTP/1.1').
        self assert: ('*abc123*' match: contents ignoreCase: true).
        self assert: ('*Content-Length: 6*' match: contents ignoreCase: true)

    "Modified: / 23-09-2011 / 21:08:35 / cg"
!

testSendGetRequestEntityCT
        | contents |
        self openGetFooBar.
        self setConnectionReading: ''.
        request setEntityOn: 'abc123'.
        request entity contentType: 'text/html'.
        request sendMessageStart.
        request sendMessageHeaders.
        self assert: request hasEntity.
        request sendMessageBody.
        contents := self getSentString.
        self assert: (contents beginsWith: 'GET /bar HTTP/1.1').
        self assert: ('*abc123*' match: contents ignoreCase: true).
        self assert: ('*Content-Length: 6*' match: contents ignoreCase: true).
        self assert: ('*Content-Type: text/html*' match: contents ignoreCase: true)

    "Modified: / 23-09-2011 / 21:08:43 / cg"
!

testSendHeader
        self setConnectionReading: ''.
        request sendHeader: 'abc' -> 'def'.
        self assertSentString: ('abc: def
' copyReplaceString:Character cr asString withString:String crlf).
        self setConnectionReading: ''.
        request sendHeader: 'abc' -> 123.
        self assertSentString: ('abc: 123
' copyReplaceString:Character cr asString withString:String crlf)

    "Modified: / 04-10-2011 / 14:43:10 / cg"
!

testSendMessageStart10
        self openGetFooBar.
        request beVersion10.
        self setConnectionReading: ''.
        request sendMessageStart.
        self assertSentString: ('GET /bar HTTP/1.0
' copyReplaceString:Character cr asString withString:String crlf)

    "Modified: / 04-10-2011 / 14:42:57 / cg"
!

testSendMessageStartGET
        self openGetFooBar.
        self setConnectionReading: ''.
        request sendMessageStart.
        self assertSentString: ('GET /bar HTTP/1.1
' copyReplaceString:Character cr asString withString:String crlf)

    "Modified: / 04-10-2011 / 14:42:35 / cg"
!

testSendPostRequestEntity
        | contents |
        request openPostTo: 'http://www.foo.org/bar'.
        self setConnectionReading: ''.
        request setEntityOn: 'abc123'.
        request sendMessageStart.
        request sendMessageHeaders.
        request sendMessageBody.
        contents := self getSentString.
        self assert: (contents beginsWith: 'POST /bar HTTP/1.1').
        self assert: ('*abc123*' match: contents ignoreCase: true).
        self assert: ('*Content-Length: 6*' match: contents ignoreCase: true)

    "Modified: / 23-09-2011 / 21:08:47 / cg"
!

testSendToNonDefaultPort
        self openGetFoo1234Bar.
        self setConnectionReading: ''.
        request setEntityOn: 'abc'.
        request addHeader: 'User-Agent' value: 'Test'.
        request sendMessageStart.
        request sendMessageHeaders.
        self 
                assertSentString: ('GET /bar HTTP/1.1
Host: www.foo.org:1234
User-Agent: Test
Content-Length: 3

' copyReplaceString:Character cr asString withString:String crlf)

    "Modified: / 04-10-2011 / 14:42:19 / cg"
!

testSendToProxy
        self setProxy.
        self openGetFooBar.
        self setConnectionReading: ''.
        request setEntityOn: 'abc'.
        request addHeader: 'User-Agent' value: 'Test'.
        request sendMessageStart.
        request sendMessageHeaders.
        self 
                assertSentString: ('GET http://www.foo.org/bar HTTP/1.1
Host: www.foo.org
User-Agent: Test
Content-Length: 3

' copyReplaceString:Character cr asString withString:String crlf)

    "Modified: / 04-10-2011 / 14:42:03 / cg"
!

testSendWithAuthenticate
        | contents |
        self openGetFooBar.
        self setConnectionReading: ''.
        request username: 'Aladdin' password: 'open sesame'.
        request sendMessageStart.
        request sendMessageHeaders.
        contents := self getSentString.
        self assert: ('*Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==*' match: contents ignoreCase: true)

    "Modified: / 23-09-2011 / 21:08:50 / cg"
!

testSendWithEntity
        self openGetFooBar.
        self setConnectionReading: ''.
        request setEntityOn: 'abc'.
        request addHeader: 'User-Agent' value: 'Test'.
        request sendMessageStart.
        request sendMessageHeaders.
        self 
                assertSentString: ('GET /bar HTTP/1.1
Host: www.foo.org
User-Agent: Test
Content-Length: 3

' copyReplaceString:Character cr asString withString:String crlf).

    "Modified: / 04-10-2011 / 14:30:41 / cg"
!

testStatus
	self addResponseParsing: 'HTTP/1.1 500 NotGood

'.
	self assert: request status = 500.
	self assert: request statusText = 'NotGood'
!

testTimeoutLoopSyncEx
	request startTimeoutLoop.
	self should: [request startTimeoutLoop] raise: Error
!

testTimeoutLoopTerminate
	request startTimeoutLoop.
	self assert: request timeoutLoop notNil.
	request terminateTimeoutLoop.
	self assert: request timeoutLoop isNil.
	request terminateTimeoutLoop.
	request terminateTimeoutLoop
!

testUseProxy
	self deny: request useProxy.
	request proxySettings: SptHTTPProxySettings new.
	self deny: request useProxy.
	request proxySettings: (SptHTTPProxySettings new useProxy: true;yourself).
	self assert: request useProxy.
!

testUsernamePassword
	request urlString: 'http://www.foo.org/bar/index.html'.
	request username: 'Aladdin' password: 'open sesame'.
	self assert: request state credentials user username = 'Aladdin'.
	self assert: request state credentials user password = 'open sesame'.
	self assert: (request state shouldAuthenticate: 'http://www.foo.org/bar/index.html').
	self assert: (request state shouldAuthenticate: 'http://www.foo.org/bar/baz/index.html').
	self deny: (request state shouldAuthenticate: 'http://www.foo.org/baz').
	self assert: request state authorizationHeader = 'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='
!

testWaitNoTiming
	request timeout: nil.
	request connection: (SptHTTPConnection new socket: self).
	request deferredSend: [100 factorial] deferredValue.
	self assert: request waitOnReady = 100 factorial.
	self deny: sentClose
!

testWaitTiming
	| conn |
	request connection: (conn := SptHTTPConnection new socket: self).
	request timeout: 200.
	conn timeoutState: #off.
	request deferredSend: 
			[(Delay forMilliseconds: 600) wait.
			1] deferredValue.
	self assert: request waitOnReady = 1.
	self deny: sentClose.
	conn timeoutState: #on.
	request deferredSend: 
			[(Delay forMilliseconds: 4000) wait.
			1] deferredValue.
	request waitOnReady.
	self assert: sentClose
!

testWaitTimingEarly
        | conn x |
        request connection: (conn := SptHTTPConnection new socket: self).
        request timeout: 200.
        conn timeoutState: #on.
        x := [1] deferredValue.
        request deferredSend: [1] deferredValue.
        self assert: request waitOnReady = 1.
        self deny: sentClose

    "Modified: / 04-10-2011 / 17:28:02 / cg"
!

testWaitTimingMilliseconds
	| conn |
	request timeout: 20000.
	self assert: request waitTimingMilliseconds = 3000.
	request connection: (conn := SptHTTPConnection new socket: self).
	self assert: request waitTimingMilliseconds = 3000.
	conn timeoutState: #on.
	self assert: request waitTimingMilliseconds = 3000.
	conn checkTimeout.
	self assert: request waitTimingMilliseconds = 20000
! !

!SptHTTPRequestTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPRequestTest.st,v 1.5 2011-10-04 16:48:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPRequestTest.st,v 1.5 2011-10-04 16:48:17 cg Exp $'
! !

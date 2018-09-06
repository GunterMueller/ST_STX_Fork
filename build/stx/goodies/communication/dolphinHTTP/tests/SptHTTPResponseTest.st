"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPResponseTest
	instanceVariableNames:'response'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPResponseTest methodsFor:'accessing'!

setResponseOn: aString
	response readResponse: (self getConnectionReading: aString)
! !

!SptHTTPResponseTest methodsFor:'asserting'!

assertHeader: aHeaderLine isKey: aKeyString value: aValueString
	response := SptHTTPResponse new.
	response parseHeaderLine: aHeaderLine.
	self assert: (response headerAt: aKeyString) = aValueString
!

setTestProgress
	| request |
	request := SptHTTPRequest newFor: self getTestConfDeaf.
	response request: request
!

setUp
	super setUp.
	response := SptHTTPResponse new
! !

!SptHTTPResponseTest methodsFor:'unit tests'!

progressMessages
	^response progress sentMessages
!

testAddResponseHeaderLine
	self 
		assertHeader: 'Content-Length: 456'
		isKey: 'Content-Length'
		value: '456'.
	self 
		assertHeader: 'Content-Length:  456'
		isKey: 'Content-Length'
		value: '456'.
	self 
		assertHeader: 'Content-Length: 456 '
		isKey: 'Content-Length'
		value: '456'.
	self 
		assertHeader: 'CONTENT-LENGTH: 456'
		isKey: 'Content-Length'
		value: '456'
!

testBasicChallenge
	response statusLine: 'HTTP/1.1 401'.
	self assert: response basicChallenge isNil.
	response parseHeaderLine: 'WWW-Authenticate: Basic realm="WallyWorld"'.
	self assert: response basicChallenge realm = 'WallyWorld'.
	response 
		parseHeaderLine: 'WWW-Authenticate: Digest realm="WallyWorld", nonce="eb6c05fd7dd274e003a58dfc5092b305"'.
	self assert: response basicChallenge realm = 'WallyWorld'
!

testBasicChallengeCase
	response statusLine: 'HTTP/1.1 401'.
	self assert: response basicChallenge isNil.
	response parseHeaderLine: 'WWW-Authenticate: BASIC realm="WallyWorld"'.
	self assert: response basicChallenge realm = 'WallyWorld'
!

testBasicChallengeLast
	response statusLine: 'HTTP/1.1 401'.
	self assert: response basicChallenge isNil.
	response 
		parseHeaderLine: 'WWW-Authenticate: Digest realm="WallyWorld", nonce="eb6c05fd7dd274e003a58dfc5092b305"'.
	response parseHeaderLine: 'WWW-Authenticate: Basic realm="WallyWorld"'.
	self assert: response basicChallenge realm = 'WallyWorld'
!

testCombiningHeaders
	self 
		setResponseOn: 'HTTP/1.1 200
WWW-Authenticate: BASIC realm="www.sharemation.com"
WWW-Authenticate: Digest realm="www.sharemation.com", nonce="eb6c05fd7dd274e003a58dfc5092b305"
Content-Length: 0

'.
	self assert: (response headerAt: 'WWW-Authenticate') 
				= 'BASIC realm="www.sharemation.com", Digest realm="www.sharemation.com", nonce="eb6c05fd7dd274e003a58dfc5092b305"'
!

testContentRangeInterval
	response headers at: 'Content-Length' put: 10000.
	""
	response headers at: 'Content-Range' put: 'bytes 0-499/1234'.
	self assert: response contentRangeInterval = (0 to: 499).
	""
	response headers at: 'Content-Range' put: 'bytes 500-999/1234'.
	self assert: response contentRangeInterval = (500 to: 999).
	""
	response headers at: 'Content-Range' put: 'bytes 500-999/*'.
	self assert: response contentRangeInterval = (500 to: 999).
	""
	response headers at: 'Content-Range' put: 'bytes  500-999/*'.
	self assert: response contentRangeInterval = (500 to: 999)
!

testDefaultIsConnectionClose
	response statusLine: 'HTTP/1.1 200 OK'.
	self deny: response defaultIsConnectionClose.
	response statusLine: 'HTTP/1.0 200 OK'.
	self assert: response defaultIsConnectionClose
!

testHasContentLength
	self deny: response hasContentLength.
	response parseHeaderLine: 'Content-Length: 456'.
	self assert: response hasContentLength
!

testHasContentLengthCase
	self deny: response hasContentLength.
	response parseHeaderLine: 'CONTENT-LENGTH: 456'.
	self assert: response hasContentLength
!

testIsAcceptRangesBytes
	response statusLine: 'HTTP/1.1 200 OK'.
	response parseHeaderLine: 'Accept-Ranges: bytes'.
	self assert: response isAcceptRangesBytes
!

testIsChunkedTransferCoding
	response statusLine: 'HTTP/1.1 200 OK'.
	self deny: response isChunkedTransferEncoding.
	response parseHeaderLine: 'transfer-encoding: chunked'.
	self assert: response isChunkedTransferEncoding
!

testIsConnectionClose
	response statusLine: 'HTTP/1.1 200 OK'.
	self deny: response isConnectionClose.
	response parseHeaderLine: 'Connection: close'.
	self assert: response isConnectionClose
!

testIsConnectionCloseEx
	response statusLine: 'HT'.
	self assert: response isConnectionClose.
	response statusLine: nil.
	self assert: response isConnectionClose
!

testIsConnectionCloseLC
	response statusLine: 'HTTP/1.1 200 OK'.
	response parseHeaderLine: 'Connection: Close'.
	self assert: response isConnectionClose
!

testIsInformational
	response statusLine: 'HTTP/1.1 100 Continue'.
	self assert: response isInformational.
	response statusLine: 'HTTP/1.1 200 OK'.
	self deny: response isInformational
!

testIsRedirect
	response statusLine: 'HTTP/1.1 301 Moved Permanently'.
	self deny: response isRedirect.
	response parseHeaderLine: 'Location: http://www.foo.org/baz'.
	self assert: response isRedirect.
	response statusLine: 'HTTP/1.1 200 OK'.
	self deny: response isRedirect
!

testIsRedirectCase
	response statusLine: 'HTTP/1.1 301 Moved Permanently'.
	response parseHeaderLine: 'loCatIon: http://www.foo.org/baz'.
	self assert: response isRedirect
!

testIsUnauthorized
	response statusLine: 'HTTP/1.1 401 Unauthorized'.
	self assert: response isUnauthorized
!

testNextLineFrom
	| stream |
	stream := SZReadWriteSocketStream testStreamReading: 'abc' , String lineDelimiter.
	self assert: stream upToCRLF = 'abc'.
	stream := SZReadWriteSocketStream testStreamReading: String lineDelimiter.
	self assert: stream upToCRLF isEmpty
!

testProgressReadBodyToEnd
	| body |
	body := String new: 10000 withAll: $a.
	self setTestProgress.
	response readBodyToEnd: (self getConnectionReading: body).
	self assert: self progressMessages first selector = #onReadingBody.
	self assert: self progressMessages second selector = #read:of:.
	self assert: self progressMessages second arguments 
				= (Array with: response readEntityBufferSize with: nil).
	self assert: self progressMessages third selector = #read:of:.
	self assert: self progressMessages third arguments 
				= (Array with: response readEntityBufferSize * 2 with: nil).
	self assert: self progressMessages last selector = #onReadBody
!

testProgressReadChunkedCoding
	self setTestProgress.
	response readChunkedEncodedBody: (self getConnectionReading: '3
abc
2
de
0

').
	self assert: self progressMessages first selector = #onReadingBody.
	self assert: self progressMessages second selector = #read:of:.
	self assert: self progressMessages second arguments = #(3 nil).
	self assert: self progressMessages third selector = #read:of:.
	self assert: self progressMessages third arguments = #(5 nil).
	self assert: self progressMessages last selector = #onReadBody
!

testProgressReadContentLength1
	response parseHeaderLine: 'Content-Length: 3' , self crlf.
	self setTestProgress.
	response readContentLengthBody: (self getConnectionReading: 'abc').
	self assert: self progressMessages first selector = #onReadingBody.
	self assert: self progressMessages second selector = #read:of:.
	self assert: self progressMessages second arguments = #(3 3).
	self assert: self progressMessages last selector = #onReadBody
!

testProgressReadContentLength2
	| body |
	body := String new: 10000 withAll: $a.
	response parseHeaderLine: 'Content-Length: 10000' , self crlf.
	self setTestProgress.
	response readContentLengthBody: (self getConnectionReading: body).
	self assert: self progressMessages first selector = #onReadingBody.
	self assert: self progressMessages second selector = #read:of:.
	self assert: self progressMessages second arguments 
				= (Array with: response readEntityBufferSize with: 10000).
	self assert: self progressMessages third selector = #read:of:.
	self assert: self progressMessages third arguments 
				= (Array with: response readEntityBufferSize * 2 with: 10000).
	self assert: self progressMessages last selector = #onReadBody
!

testProgressReadMessageHeaders
	self setTestProgress.
	response 
		readMessageHeaders: (self getConnectionReading: 'HTTP/1.1 200
Content-Length: 3

').
	self assert: self progressMessages first selector = #onReadingHeaders.
	self assert: self progressMessages last selector = #onReadHeaders
!

testProgressReadMessageStatus
	self setTestProgress.
	response readMessageStatus: (self getConnectionReading: 'HTTP/1.1 401' , self crlf).
	self assert: self progressMessages first selector = #onReadingStatus.
	self assert: self progressMessages last selector = #onReadStatus
!

testRangeInterval
	response headers at: 'Content-Length' put: '10000'.
	""
	response headers at: 'Range' put: 'bytes=0-499'.
	self assert: response rangeInterval = (0 to: 499).
	""
	response headers at: 'Range' put: 'bytes=500-999'.
	self assert: response rangeInterval = (500 to: 999).
	""
	response headers at: 'Range' put: 'bytes=-500'.
	self assert: response rangeInterval = (9500 to: 9999).
	""
	response headers at: 'Range' put: 'bytes=9500-'.
	self assert: response rangeInterval = (9500 to: 9999)
!

testReadChunkedCoding
	self setResponseOn: 'HTTP/1.1 200
transfer-encoding: chunked

3
abc
2
de
0

'.
	self assert: response body = 'abcde'
!

testReadChunkedSizeFrom
        | stream n ch |
        stream := SZReadWriteSocketStream testStreamReading: '5
abcde'.
        self assert: (n := response chunkSizeFrom: stream) = 5.
        self assert: (ch := stream next) = $a.
        stream := SZReadWriteSocketStream testStreamReading: '5;foo
abcde'.
        self assert: (response chunkSizeFrom: stream) = 5.
        self assert: stream next = $a.
        stream := SZReadWriteSocketStream testStreamReading: 'A
abcde'.
        self assert: (response chunkSizeFrom: stream) = 10.
        self assert: stream next = $a.
        stream := SZReadWriteSocketStream testStreamReading: 'a
abcde'.
        self assert: (response chunkSizeFrom: stream) = 10.
        self assert: stream next = $a

    "Modified: / 23-09-2011 / 22:33:39 / cg"
!

testReadContentLength
	self setResponseOn: 'HTTP/1.1 200
Content-Length: 3

123'.
	self assert: response body = '123'
!

testReadContentRangeBody
        | request stream |
        request := SptHTTPRequest new.
        "Set-up a request as if we had a partial read error retry"
        request isRangeRequest: true.
        stream := String "ByteArray" writeStream.
        stream nextPutAll: 'hello' "asByteArray".
        "/ stream reset.
        request okBodyStream: stream.
        request responses add: response.
        response request: request.
        self 
                setResponseOn: 'HTTP/1.1 206 PC
Content-Length: 5
Content-Range: bytes 5-9/10

again'.
        "Retry"
        self assert: stream contents asString = 'helloagain'

    "Modified: / 23-09-2011 / 22:32:51 / cg"
!

testReadContentRangeBodyAll
	| request stream |
	request := SptHTTPRequest new.
	"Set-up a request as if we had read nothing of previous request"
	request isRangeRequest: true.
	stream := ByteArray writeStream.
	request okBodyStream: stream.
	request responses add: response.
	response request: request.
	self 
		setResponseOn: 'HTTP/1.1 206 PC
Content-Length: 10
Content-Range: bytes 0-9/10

helloagain'.
	"Retry"
	self assert: stream contents asString = 'helloagain'
!

testReadToEnd
	self setResponseOn: 'HTTP/1.0 200

123'.
	self assert: response body = '123'
!

testResponseContentLength
	response parseHeaderLine: 'Content-Length: 456'.
	self assert: response contentLength = 456
!

testSetCookieHeaders
	self setTestProgress.
	response request setUrl: (SptHTTPUrl fromString: 'http://www.foo.org/bar').
	response parseHeaderLine: 'Set-Cookie: CUSTOMER=WILE_E_COYOTE; path=/'.
	self assert: response request cookieJar numberOfCookies = 1.
	response parseHeaderLine: 'Set-Cookie: second=2; path=/bar'.
	self assert: response request cookieJar numberOfCookies = 2
! !

!SptHTTPResponseTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPResponseTest.st,v 1.3 2011-09-23 20:39:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPResponseTest.st,v 1.3 2011-09-23 20:39:10 cg Exp $'
! !

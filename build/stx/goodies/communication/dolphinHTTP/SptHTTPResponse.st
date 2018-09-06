"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPResponse
	instanceVariableNames:'statusLine headers bodyStream request'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPResponse comment:'I am an HTTP Response message.

I can read responses that either;
  1/ Have a content-Length
  2/ Use chunked transer encoding
  3/ Have a Content-Range
  Or (if HTTP 1.0)  I will read the socket until it is closed by the server

Notes:
 - I will lazily initialize bodyStream to be a <WriteStream> on a ByteArray, however when I read a 200 response, I will ask my <SptHTTPRequest> request for its okBodyStream and if not nil, I will stream to it.

 - If 
        1/ I receive a ''Content-Range'' response (typically in response to a request with a ''Range'' header) and If
        2/ My Request answers true to isRangeRequest
   Then I will set the position of the bodyStream to the start of the Content-Range



Instance Variables:
	statusLine	<String>
	headers		<PluggableLookupTable> (case-insensitive)
	cookies		<OrderedCollection> of <SptHTTPCookie>s
	bodyStream	<WriteStream>
	request		<SptHTTPRequest>

'
!


!SptHTTPResponse class methodsFor:'public'!

fromConnection: anSptHTTPConnection request: anObject
	#deprecated.
	^(self new)
		request: anObject;
		readResponse: anSptHTTPConnection;
		yourself
!

new
        ^self basicNew initialize

    "Modified: / 23-09-2011 / 18:04:39 / cg"
!

readEntityBufferSize
	Notification deprecated.
	^1024
! !

!SptHTTPResponse methodsFor:'accessing'!

bodyStreamSize
	^bodyStream size
!

defaultIsConnectionClose
	^[self isVersion11 not] on: Error do: [:e | true]
!

makingProgress
        "Answer the request's <SptHTTPProgress> progress.

        Inform the <SptHTTPRequest> request that we are 'making progress' ...
                (ie we have either read or written something to the socket.

        Note: DeafObject is used for UnitTesting purposes "

        ^request isNil ifTrue: [Dolphin::DeafObject current] ifFalse: [request makingProgress]
!

progress
        "Note: DeafObject is used for UnitTesting purposes "

        ^request isNil ifTrue: [Dolphin::DeafObject current] ifFalse: [request progress]
!

putHeaderReportOn: stream
	stream
		nextPutAll: '===In';
		cr;
		display: statusLine;
		cr.
	headers keysAndValuesDo: 
			[:k :v | 
			stream
				display: k;
				nextPut: $:;
				display: v;
				cr]
!

readEntityBufferSize
	request ifNil: 
			["For UnitTests"

			^1024].
	^request readEntityBufferSize
!

request
	^request
!

request: aSptHTTPRequest
	request := aSptHTTPRequest
! !

!SptHTTPResponse methodsFor:'accessing-content'!

body
	"Answer the body of the response as a <String>"

	^bodyStream contents asString
!

bodyBytes
	"Answer the body of the response as a <ByteArray>"

	^bodyStream contents
!

bodyStream
	^bodyStream
! !

!SptHTTPResponse methodsFor:'accessing-headers'!

basicChallenge
	| header challenges |
	header := headers at: 'WWW-Authenticate' ifAbsent: [^nil].
	challenges := SptHTTPChallenge readAllFrom: header readStream.
	^challenges detect: [:each | each isBasic] ifNone: []
!

contentLength
	^(headers at: 'Content-Length') asNumber
!

contentRangeInterval
        | header stream rangeStart rangeEnd instanceLength |
        header := (self headerAt: 'Content-Range') trimBlanks.
        stream := header readStream.
        (stream upTo: $ ) trimBlanks = 'bytes' 
                ifFalse: [self error: 'Unexpected Content-Range header: ' , header asString "displayString"].
        rangeStart := (stream upTo: $-) trimBlanks.
        rangeEnd := (stream upTo: $/) trimBlanks.
        instanceLength := stream upToEnd trimBlanks.
        "Ignore the instanceLength ... we only need the range"
        ^rangeStart asNumber to: rangeEnd asNumber

    "Modified: / 23-09-2011 / 22:16:46 / cg"
!

contentType
	^headers at: 'Content-Type' ifAbsent: ['*']
!

contentTypeOrNil
	^headers at: 'Content-Type' ifAbsent: []
!

headerAt: aString
	^headers at: aString
!

headerAt: aString ifAbsent: operation
	^headers at: aString ifAbsent: operation
!

headers
	"Answer a table of response headers"

	^headers
!

location
	^headers at: 'Location'
!

rangeInterval
        | header stream rangeStart rangeEnd cl |
        cl := self contentLength.
        header := self headerAt: 'Range'.
        "We can only handle a single range"
        (header includes: $,) 
                ifTrue: [self error: 'Unexpected range header: ' , header asString "displayString"].
        stream := header readStream.
        (stream upTo: $=) trimBlanks = 'bytes' 
                ifFalse: [self error: 'Unexpected range header: ' , header asString "displayString"].
        rangeStart := (stream upTo: $-) trimBlanks.
        rangeEnd := stream upToEnd trimBlanks.
        "The final 500 bytes (byte offsets 9500-9999, inclusive): bytes=-500"
        rangeStart isEmpty ifTrue: [^cl - rangeEnd asNumber to: cl - 1].
        "The final 500 bytes ... Or bytes=9500- "
        rangeEnd isEmpty ifTrue: [^rangeStart asNumber to: cl - 1].
        ^rangeStart asNumber to: rangeEnd asNumber

    "Modified: / 23-09-2011 / 22:16:50 / cg"
! !

!SptHTTPResponse methodsFor:'accessing-status'!

httpStatus
	^SptHTTPStatus fromString: statusLine
!

status
	"Answer the status code of the response"

	^self httpStatus status
!

statusCode
	"Answer the status code of the response"

	^self httpStatus statusCode
!

statusCodeString
	"Answer the status string of the response"

	^self httpStatus statusCodeString
!

statusLine
	"Answer the response status line"

	^statusLine
!

statusLine: aString
	"For example 'HTTP/1.1 200 OK'"

	statusLine := aString
!

statusText
	"Answer the Status text of the response"

	^self httpStatus statusText
! !

!SptHTTPResponse methodsFor:'event handling'!

onReadHeaders
	Notification deprecated
! !

!SptHTTPResponse methodsFor:'exceptions'!

httpException
	"Answer an exception instance that describes the error"

	"See SptHTTPStatus>>httpException"

	^self httpStatus httpException
! !

!SptHTTPResponse methodsFor:'helpers'!

chunkSizeFrom: stream
	| chunkString |
	chunkString := (stream upToCRLF readStream upTo: $;) asUppercase.
	"Transcript
		nextPutAll: chunkString;
		cr."
	^Integer readFrom: chunkString readStream radix: 16
! !

!SptHTTPResponse methodsFor:'initializing'!

initialize
        super initialize.
        headers := Dolphin::PluggableLookupTable new searchPolicy: Dolphin::SearchPolicy caseInsensitive.
        bodyStream := ByteArray writeStream

    "Modified: / 23-09-2011 / 14:09:02 / cg"
! !

!SptHTTPResponse methodsFor:'operations'!

parseCookie: aString
	"Note: aString may contain multiple cookies separated by a $,"

	| allCookies |
	(request isNil or: [request isUseCookies not]) ifTrue: [^nil].
	"Note: an error parsing any of the cookies, means we reject all cookies"
	allCookies := [SptHTTPCookie allFromSetCookieString: aString url: request url] on: Error
				do: 
					[:e | 
					SptHTTPRequest logDebug: 'Cookie rejected: ' , e description.
					nil].
	allCookies notNil ifTrue: [allCookies do: [:cookie | request state addCookie: cookie]]
!

parseHeaderLine: aString
	| stream key value |
	stream := aString readStream.
	key := stream upTo: $:.
	value := stream upToEnd.
	"cookies are a special-case ... we need to parse them to make sure they are valid
	before blindly returning them in a new request"
	key asLowercase = 'set-cookie' ifTrue: [self parseCookie: value].
	(headers includesKey: key) ifTrue: [value := (headers at: key) , ',' , value].
	headers at: key put: value trimBlanks
!

readBodyToEnd: aConnection
        "Read the socket until it is closed (ie HTTP1.0 semantics.
        Note: read readEntityChunkSize bytes at a time so that we can update any progress/status objects."

        | inStream read |
        self makingProgress onReadingBody.
        read := 0.
        inStream := aConnection socketStream.

        [inStream atEnd] whileFalse:[
            |each|

            each := inStream nextByte.
            bodyStream nextPut: each.
            read := read + 1.
            read \\ self readEntityBufferSize = 0 ifTrue: [self makingProgress read: read of: nil]
        ].
            
"/        [inStream doBytes: 
"/                        [:each | 
"/                        bodyStream nextPut: each.
"/                        read := read + 1.
"/                        read % self readEntityBufferSize = 0 ifTrue: [self makingProgress read: read of: nil]]
"/        ] on: StreamError "SocketClosed" , ReadStream endOfStreamSignal
"/        do: [:e | ].
        self makingProgress onReadBody

    "Modified: / 04-10-2011 / 18:41:17 / cg"
!

readChunkedEncodedBody: aConnection
        "The response is using chunked encoding
                ... read the chunks"

        | chunkSize stream read |
        self makingProgress onReadingBody.
        stream := aConnection socketStream.
        read := 0.
        
        [chunkSize := self chunkSizeFrom: stream.
        chunkSize > 0] whileTrue: 
                                [| crlf |
                                bodyStream nextPutAll: (stream next: "nextBytes:" chunkSize).
                                crlf := stream next: 2.
                                self assert: [crlf = String lineDelimiter].
                                self makingProgress read: (read := read + chunkSize) of: nil].
        self readMessageHeaders: aConnection.
        self makingProgress onReadBody

    "Modified: / 23-09-2011 / 22:34:31 / cg"
!

readContentLengthBody: aConnection
	"Read Content-Length bytes from the socket (ie HTTP1.1 semantics).
	Note: read readEntityChunkSize bytes at a time so that we can update any progress/status objects."

	| total read bytes |
	self makingProgress onReadingBody.
	total := self contentLength.
	read := 0.
	[read >= total] whileFalse: 
			[bodyStream nextPutAll: (aConnection socketStream 
						nextBytes: (bytes := self readEntityBufferSize min: total - read)).
			read := read + bytes.
			self makingProgress read: read of: total].
	self makingProgress onReadBody
!

readContentRangeBody: aConnection
        "Read Content-Length bytes from the socket (ie HTTP1.1 semantics).
        Note: read readEntityChunkSize bytes at a time so that we can update any progress/status objects."

        | total range read bytes |
        #todo.  "Refactor with readContentLengthBody"
        self makingProgress onReadingBody.
        range := self contentRangeInterval.

        "If the request isRangeRequest, set the position of the okBodyStream"
        request isRangeRequest ifTrue: [bodyStream position: range start].
        total := range stop - range start + 1.
        read := 0.
        [read >= total] whileFalse: 
                        [bodyStream nextPutAll: (aConnection socketStream 
                                                next: "Bytes:" (bytes := self readEntityBufferSize min: total - read)).
                        read := read + bytes.
                        self makingProgress read: read of: total].
        self makingProgress onReadBody

    "Modified: / 23-09-2011 / 22:32:20 / cg"
!

readMessageBody: aConnection
	self isSuccessful ifTrue: [self setRequestBodyStream].
	self isChunkedTransferEncoding ifTrue: [^self readChunkedEncodedBody: aConnection].
	self hasContentRange ifTrue: [^self readContentRangeBody: aConnection].
	self hasContentLength ifTrue: [^self readContentLengthBody: aConnection].
	"Only read to socket close if HTTP1.0. It is valid to have a response with no body"
	(self isVersion11 not or: [self isConnectionClose]) 
		ifTrue: 
			[^self readBodyToEnd: aConnection
			"mmm ... no body?"]
!

readMessageHeaders: aConnection
        | line stream |
        self makingProgress onReadingHeaders.
        stream := aConnection socketStream.
        [(line := stream upToCRLF) isEmptyOrNil] whileFalse: [self parseHeaderLine: line].
        self makingProgress onReadHeaders

    "Modified: / 23-09-2011 / 21:19:21 / cg"
!

readMessageStatus: aConnection
        | line stream |
        stream := aConnection socketStream.
        self makingProgress onReadingStatus.
        [(line := stream upToCRLF) notNil and:[line isEmpty]] whileTrue: [line := stream upToCRLF].
        statusLine := line.
        self makingProgress onReadStatus

    "Modified: / 23-09-2011 / 22:36:51 / cg"
!

readResponse: aConnection
	| startT |
	#stayDown.
	"startT := Delay millisecondClockValue."
	
	[self readMessageStatus: aConnection.
	self readMessageHeaders: aConnection.
	self isInformational] 
			whileTrue.
	self readMessageBody: aConnection

	"Transcript
		display: (Delay millisecondClockValue - startT) displayString;
		cr."
!

setRequestBodyStream
	request isNil ifTrue: [^nil].
	"If the <SptHTTPRequest> has a nonNil bodyStream use it, otherwise set it"
	request okBodyStream notNil 
		ifTrue: [bodyStream := request okBodyStream]
		ifFalse: [request okBodyStream: bodyStream]
! !

!SptHTTPResponse methodsFor:'testing'!

canRangeRetry
	"Answer whether we can retry the request, only asking for the range of bytes we dont have"

	#todo.	"handle ChunkedTransferEncoding responses?"
	^self hasStatus and: 
			[self isSuccessful and: 
					[self isAcceptRangesBytes 
						and: [self isChunkedTransferEncoding not and: [self hasContentLength]]]]
!

hasContentLength
	^headers includesKey: 'Content-Length'
!

hasContentRange
	^headers includesKey: 'Content-Range'
!

hasRange
	Notification deprecated.
	^headers includesKey: 'Range'
!

hasStatus
	^statusLine notNil and: [statusLine trimBlanks notEmpty]
!

isAcceptRangesBytes
	^(self headerAt: 'Accept-Ranges' ifAbsent: [^false]) trimBlanks = 'bytes'
!

isChunkedTransferEncoding
	^(headers at: 'transfer-encoding' ifAbsent: [^false]) = 'chunked'
!

isClientOrServerError
	^self httpStatus isClientOrServerError
!

isConnectionClose
	^(headers at: 'Connection' ifAbsent: [^self defaultIsConnectionClose]) asLowercase 
		= 'close'
!

isHTMLContentType
	^(self headerAt: 'Content-Type' ifAbsent: [^false]) beginsWith: 'text/html'
!

isImageContentType
	^(self headerAt: 'Content-Type' ifAbsent: [^false]) beginsWith: 'image/'
!

isInformational
	^self httpStatus isInformational
!

isRedirect
	^self status >= 300 and: [self status < 400 and: [headers includesKey: 'Location']]
!

isSuccessful
	^self httpStatus isSuccessful
!

isUnauthorized
	^self status = 401
!

isVersion11
	^self httpStatus isVersion11
! !

!SptHTTPResponse methodsFor:'unit tests'!

setStatus: aString headers: aLookupTable body: aString2
	"Private - For Unit tests"

	statusLine := aString.
	headers := aLookupTable.
	bodyStream := ByteArray writeStream.
	bodyStream nextPutAll: aString2 asByteArray
!

setStatusCode: aString headers: aLookupTable body: aString2
	"Private - For Unit tests"

	self 
		setStatus: 'HTTP/1.1 ' , aString
		headers: aLookupTable
		body: aString2
! !

!SptHTTPResponse class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPResponse.st,v 1.5 2011-10-04 16:41:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPResponse.st,v 1.5 2011-10-04 16:41:31 cg Exp $'
! !

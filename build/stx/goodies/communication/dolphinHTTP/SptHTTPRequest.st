"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPRequest
	instanceVariableNames:'connection url method headers responses entity deferredSend
		okBodyStream state flags progress conf timeoutLoop'
	classVariableNames:'IsAuthenticateMask IsFollowRedirectsMask IsRangeRequestMask
		IsUseCookiesMask IsVersion11Mask'
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPRequest comment:'I am a single request and response http message send in a background process.

I am a single request and response http message send in a background process.

==========
Features:
	Each feature of the HTTPClient is demonstrated in one of the class #example* methods

==========
Instance Variables:
	connection 	<SptHTTPConnection>
	url		<SptHTTPUrl> 
	method		<String>. (HTTP method)
	headers		<Dictionary> (HTTP request headers)
	entity 		<SptHTTPEntity> or nil (content to be sent with PUT/POST etc)
	responses 	<Collection> of <SptHTTPResponse>s
	okBodyStream 	<WriteStream> or nil 
	state 		<SptSessionState>
	flags		<Integer>
	progess		<SptHTTPProgress>
	conf		<SptHTTPConfiguration>

==========
Debugging

	See #send

==========
Flags
	IsAuthenticateMask 
		(true) controls whether an Authorization header can be added 
	IsFollowRedirectsMask 
		(true) controls whether 300 responses are automatically resent to the new Location 
	IsRangeRequestMask
		(false) controls whether the okBodyStream is set to the start position of a Range interval 
	IsUseCookiesMask
		(true) controls whether Cookies are added to a Request
	IsVersion11Mask
		(true) controls whether the request is sent as 1.1 and whether connections are resused

==========
How it works

	1) Set-Up
	 - A new instance is created for each request that you want to send to a server. You set
	the url/method/entity/flags and any additonal headers into the request. You can also set existing
	state <SptHTTPSessionState> into the request (which holds information usually needed
	across a series of requests)

	2) Sending
	 - The #send method starts the request in a background process and returns immediately.
	- In this background process the request is sent, and the response is read. Certain responses
	may create the need to send a new request (for example redirection), and therefore a single
	request may have multiple responses.

	3) Waiting
	 - You can use the #isReady message to check if the request has finished, or ...
	 - You can block using one of the #waitOnReady* methods. The #waitOnReady* methods
	can make use of a timeoutLoop to limit the time that the process blocks.
	
	4) Timeouts
	 - It was necessary to implement a timeoutLoop as WinSock1 does not have configurable
	OS layer timeouts.
	 - If a timeout is activated, a SocketWaitCancelled error will be signalled in the process
	blocked in the #waitOnReady* method
	
	5) Finishing
	- Access the #lastResponse, or use the methods in the accessing-response category.
	- If you are making a series of requests, you may want to store the #state


==========
Notes

	- The multiple-process design of this class (ie the deferredSend and the timeoutLoop)
	was driven by the lack of configurable WinSock1 OS-level timeouts. 
	- WinSock2 does have timeouts, and would allow much of the process synchronization code
	to be removed.
	 
	- I have used this class heavily over the past six months; I  have a queue class (not included) that
	processes 4-5 requests concurrently. 
	
	-What I have not used heavily (and may be a more likely source of bugs)
		- The authorization/authentication code
 		- Cookies
		- Range Requests are a new feature

		

	
	
	



'
!


!SptHTTPRequest class methodsFor:'instance creation'!

new
	^self newFor: SptHTTPConfiguration newDefault
!

newFor: aConfiguration
	^super new initializeFor: aConfiguration
! !

!SptHTTPRequest class methodsFor:'constants'!

defaultUserAgent
	"^'Test'"

	^'sw-dol/0.60'
!

generalHeaders
	^#('cache-control' 'connection' 'date' 'pragma' 'transfer-encoding' 'upgrade' 'via')
!

icon
	^Icon fromId: 179 in: ShellLibrary default
!

requestHeaders
	^#('accept' 'accept-charset' 'accept-encoding' 'accept-language' 'authorization' 'from' 'host' 'if-modified-since' 'if-match' 'if-none-match' 'if-range' 'if-unmodified-since' 'max-forwards' 'proxy-authorization' 'range' 'referer' 'user-agent')
!

sendEntityBufferSize
	Notification deprecated.
	^1024
! !

!SptHTTPRequest class methodsFor:'helpers'!

headerRankOf: aString
	| aLowercaseString |
	aLowercaseString := aString asLowercase.
	(self generalHeaders includes: aLowercaseString) ifTrue: [^1].
	(self requestHeaders includes: aLowercaseString) ifTrue: [^2].
	^3
!

logDebug: aString
	Transcript
		nextPutAll: 'SptHTTPRequest warning: ' , aString;
		cr
! !

!SptHTTPRequest class methodsFor:'helpers-sorting'!

numArgs
        "Private - The receiver acts as the default sort block for HTTP Headers"

        ^ 2

    "Created: / 23-09-2011 / 22:08:21 / cg"
!

value: header1 value: header2
	"Private - The receiver acts as the default sort block for HTTP Headers"

	| rank1 rank2 |
	(rank1 := self headerRankOf: header1) < (rank2 := self headerRankOf: header2) 
		ifTrue: [^true].
	rank1 = rank2 ifTrue: [^header1 <= header2].
	^false
! !

!SptHTTPRequest class methodsFor:'initializing'!

initialize
	"
	self initialize
	"

	IsVersion11Mask := 1.
	IsFollowRedirectsMask := 2.
	IsAuthenticateMask := 4.
	IsUseCookiesMask := 8.
	IsRangeRequestMask := 16
! !

!SptHTTPRequest class methodsFor:'spray examples'!

example
	"
		Using the HTTPClient - general principles
	"

	" 1) Create the instance"

	| request |
	request := SptHTTPRequest new.

	" 2) Set the instance with the url and HTTP method"
	request openGetTo: 'http://www.dolphinharbor.org/'.

	"3) Set optional information (like headers/cookies/authorization/timeouts)"
	request addHeader: 'Accept' value: '*/*'.

	"4) Send the request (in a background process)"
	request send.

	"5) Wait (blocking) on the request to finish (or poll it)"
	request waitOnReady.

	"6) Access the response"
	request responseBody.	"Inspect It"
	request responseHeaders.	"Inspect It "
	request status.	"Inspect It "
	request statusText	"Inspect It "
!

exampleAuthentication
	"
		The HTTPClient currently only supports basic authentication.

		If a request's state includes credentials for the request's url, an Authorization header
		will be automatically added to the request.
		 
	"

	| request |
	request := SptHTTPRequest new.
	request
		openGetTo: 'http://www.dolphinharbor.org/authtest/index.html';
		addHeader: 'Accept' value: '*/*'.
	"This is a helper method which associates the username/password with the request's url"
	request username: 'user1' password: 'pass1'.
	request
		send;
		waitOnReady.
	request lastResponse body.

	"Or ... Accessing the state directly"
	request := SptHTTPRequest new.
	request
		openGetTo: 'http://www.dolphinharbor.org/authtest/index.html';
		addHeader: 'Accept' value: '*/*'.
	request state 
		username: 'user1'
		password: 'pass1'
		for: 'http://www.dolphinharbor.org/'.
	request
		send;
		waitOnReady.
	request lastResponse body.

	"Incorrect, or missing credentials will cause a SptHTTPNotAuthorized to be signalled.
		-See #exampleAuthorizationDialog"
	request := SptHTTPRequest new.
	request
		openGetTo: 'http://www.dolphinharbor.org/authtest/index.html';
		addHeader: 'Accept' value: '*/*'.
	request username: 'user1' password: 'NotPass1'.
	request
		send;
		waitOnReady
!

exampleAuthenticationDialog
	"
		A Dialog is included that can be used to ask the user for Auth information.
		 
	"

	| request |
	request := SptHTTPRequest new.
	request
		openGetTo: 'http://www.dolphinharbor.org/authtest/index.html';
		addHeader: 'Accept' value: '*/*'.

	"use: user1/pass1"
	request doAuthorizing: 
			[request
				send;
				waitOnReady].
	request lastResponse body
!

exampleBestPractice
	"
		Using the HTTPClient - best practice
	"

	| request |
	request := SptHTTPRequest new.
	"setup"
	request
		openGetTo: 'http://www.dolphinharbor.org/';
		addHeader: 'Accept' value: '*/*';
		addHeader: 'Accept-Encoding' value: ''.
	"sending"
	request
		send;
		waitOnReadySpecRetrying: 2.
	"accessing"
	^(request lastResponse hasStatus and: [request lastResponse isSuccessful]) 
		ifTrue: [request lastResponse body]
		ifFalse: ['']
!

exampleCommonHeaders
	"
		The HTTPClient will automatically add some headers (if they have not already been added)
		including: Content-Length,Host, Content-Type, User-Agent , Authorization , Cookie 

		Some other headers that may be useful are:

		See <http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html> for more info
	"

	| request |
	(request := SptHTTPRequest new) openGetTo: 'http://www.dolphinharbor.org/ns3/test'.

	"Use the Accept header to limit what content-type(s) you will accept. 
		The value '*/*' indicates any response is acceptable."
	request addHeader: 'Accept' value: '*/*'.

	"Use the Accept-Encoding header to limit the content-codings you will accept. 
		To avoid receiving responses that are gzipped or compressed use the following"
	request addHeader: 'Accept-Encoding' value: ''.

	"To force caches to revalidate use both"
	request addHeader: 'Pragma' value: 'no-cache'.
	request addHeader: 'Cache-Control' value: 'no-cache'
!

exampleConfiguration
	"

		You can use a <SptHTTPConfiguration> instance to customize requests to:
			-Use your own connection classes (advanced)
			-Use your own progress class (more typical).
	"

	| conf request1 request2 |
	conf := SptHTTPConfiguration newDefault.
	conf progressClass: SptHTTPValueProgress.
	request1 := SptHTTPRequest newFor: conf.
	" ... use it etc"
	request2 := SptHTTPRequest newFor: conf
	" ... use it etc"
!

exampleCookies
	"
		A <SptHTTPSessionState> instance can be used to store information needed across multiple requests.
		A <SptHTTPSessionState> includes a cookieJar which can be used to store cookies.

		- Cookies are parsed from responses and stored in the CookieJar.
		- Before a request is sent, it checks the CookieJar for any cookies
			that should be sent with the request.

		If you dont re-use a <SptHTTPSessionState> instance, cookies will not be sent"

	| request1 request2 |
	request1 := SptHTTPRequest new.
	request1 openGetTo: 'http://www.amazon.com/'.
	request1 send.
	"Will block until complete"
	request1 waitOnReady.

	"Inspect the following, it should contain a Set-Cookie header"
	request1 lastResponse headers.

	"Inspect the following, and look in the cookieJar, there should be one cookie
		Note: (multiple cookies can be set from a single Set-Cookie header)"
	request1 state.

	"state <SptHTTPSessionState> contains information that can be used over multiple requests."
	request2 := SptHTTPRequest new.
	"re-use the <SptHTTPSessionState> instance"
	request2 state: request1 state.
	request2 openGetTo: 'http://www.amazon.com/'.
	request2 send.
	"Will block until complete"
	request2 waitOnReady.

	"Inspect the following, it should contain the cookie header we sent to the server"
	request2 headers
!

exampleDebuging
	"
		The HTTPClient provides a number of tools to aid debuging.

		1) Wire Logging. Everything sent/received on all sockets can be logged to the Transcript.
			To enable this see the SptHTTPConnection class methed #beLoggingWireToTranscript.

		2) SptHTTPTranscriptProgress is a progress class that prints all progress events
			to the transcript. 

		For debuging the SptHTTPRequest itself see the method #send
	"

	| request |
	SptHTTPConnection beLoggingWireToTranscript.	"Note: this is a global setting that remains until turned off"
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/dh/index.html';
		addHeader: 'Accept' value: '*/*'.
	request send.
	request waitOnReady.
	SptHTTPConnection beNotLoggingWire.

	"
		Using SptHTTPTranscriptProgress 
	"
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/dh/index.html';
		addHeader: 'Accept' value: '*'.
	request setProgress: SptHTTPTranscriptProgress new.
	request send.
	request waitOnReady
!

exampleHeadRequest
	"
		'HEAD' requests have no body
	"

	| request |
	request := SptHTTPRequest new.
	request
		open: 'HEAD' to: 'http://www.dolphinharbor.org/';
		addHeader: 'Accept' value: '*/*';
		isFollowRedirects: false.
	request
		send;
		waitOnReady.
	"Inspect It"
	request lastResponse
!

exampleHeaders
	"
		The HTTPClient will automatically add required headers, but *only* if they have not
		been added by the user. This gives the user full control, but care must be taken for
		certain headers.

		Headers that are automatically added:
			Content-Length (if an entity is to be sent)
			Host 
			Content-Type (if an entity is to be sent, and it contains a Content-Type)
			User-Agent (defaults to the class constant #defaultUserAgent)
			Authorization (if credentials are supplied that match the url)
			Cookie (if a cookie-jar is supplied with cookies that match the url)
	"

	| request stream |
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/ns3/test';
		addHeader: 'Accept' value: '*/*'.
	"Note: the above url is for a page that echoes the headers we send"
	request send.
	request waitOnReady.	"Will block until response received"
	stream := request responseBody readStream.
	stream upToAll: 'HTTP_USER_AGENT'.
	stream next: 40.	"Should answer the default #defaultUserAgent"

	"
		This time manually add the User-Agent header		
	"
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/ns3/test';
		addHeader: 'Accept' value: '*/*';
		addHeader: 'User-Agent' value: 'A test Agent'.
	request send.
	request waitOnReady.	"Will block until response received"
	stream := request responseBody readStream.
	stream upToAll: 'HTTP_USER_AGENT'.
	stream next: 40
!

examplePersistentConnections
	"
		The HTTPClient supports HTTP 1.1's persistent connections.

		To disable this for a request, evaluate:
			request isVersion11: false

		Connections are only reused within 5 seconds (see SptHTTPConnection(class)>>staleMilliseconds.
			This takes advantage of being able to send a series of requests, and minimizes the
			probability that the server will kill the connection 
	
	"

	"Enable wire logging in order to see the connection being reused"

	| request |
	SptHTTPConnection beLoggingWireToTranscript.
	2 timesRepeat: 
			[(request := SptHTTPRequest new)
				openGetTo: 'http://www.dolphinharbor.org/dh/index.html';
				addHeader: 'Accept' value: '*/*'.
			request send.
			request waitOnReady].

	"On the Transcript, you should see the same Socket (ie '  a Socket(xyz) '  being used for both requests.
	(Note: if this is not the case, ensure that the server did not include a Connection: close header)"
	SptHTTPConnection beNotLoggingWire
!

exampleProcessSync
	"
		The HTTPClient sends the request and reads responses in a background process.

		There are various methods that you can use to block 
			another process until the request completes (or times out)
	
	"

	| request |
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.chartexplorer.com/dh/projects/spray/docs/google/ssGoogleResults.jpg';
		addHeader: 'Accept' value: '*/*'.

	"Send it"
	request send.	"returns immedaitely"

	"Then use either:"
	request isReady.	"returns immedaitely"

	"Or ... block"
	request waitOnReady.

	"Or ... block, if the blocked process is curtailed (ie terminated) ensure the request is closed"
	request waitOnReadyCancelling.

	"Or ... block, retrying the request if the server closes the connection
		before any response is received"
	request waitOnReadySpecRetrying: 2.

	"Or ... block, retrying the request if the server closes the connection
		If a partial response has been read, this method will attempt
		a partial range request"
	request waitOnReadyRetrying: 2
!

exampleProgress
	"
		The HTTPClient will send progress messages to a <SptHTTPProgress> instance.

		The default progress class has empty stubs for these messages. Create your own
			subclass and override these methods, for customized progress.

		*Important* The progress messages are sent from the background process.
	"

	| request progress presenter1 presenter2 transcriptProgress |
	progress := SptHTTPValueProgress new.
	presenter1 := TextPresenter showOn: progress stateValue.
	presenter2 := NumberPresenter showOn: progress percentageValue.
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.chartexplorer.com/dh/projects/spray/docs/google/ssGoogleResults.jpg';
		addHeader: 'Accept' value: '*/*';
		setProgress: progress.
	request
		send;
		waitOnReady.

	"
		For debuging purposes, the SptHTTPTranscriptProgress can be chained
		to a second progress.

		(Note: the following example needs to be evaluated with the presenters still open
			from the above example)

	"
	(transcriptProgress := SptHTTPTranscriptProgress new) nextProgress: progress.
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.chartexplorer.com/dh/projects/spray/docs/google/ssGoogleResults.jpg';
		addHeader: 'Accept' value: '*';
		setProgress: transcriptProgress.
	request
		send;
		waitOnReady.

	"clean up"
	presenter1 topShell exit.
	presenter2 topShell exit
!

exampleProgressControl
	"
		A progress instance <SptHTTPProgress> can also  be used to control a request:		

		Please review  #exampleProgress before this example.

		1) It provides access to the request, and you can send the request the #cancelConnection
		message at any time (and from any process) to shutdown the request.

		2) (Advanced) The progress messages are sent within the background
		process. Therefore, with a customized progress class, you can alter
		how a request is processed

	"

	| progress request |
	progress := SptHTTPTranscriptProgress new.
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.chartexplorer.com/dh/projects/spray/docs/google/ssGoogleResults.jpg';
		addHeader: 'Accept' value: '*/*'.
	request setProgress: progress.
	request send.

	"Instead of blocking on the request, wait a couple of seconds and evaluate:"
	progress request cancelConnection.

	"A copy of the exception will be signalled in any waiting process.
		for example:"
	request waitOnReady
!

exampleProxy
	"
		The HTTPClient can be configured to use a proxy. 

		A Dialog is provided to get this information from the user

		The SptHTTPProxySettings instance is set into the request, but
			is stored in the request's 'state' <SptHTTPSessionState> instance variable.
			This state can be used across multiple requests. (see #exampleState)
	"

	| request proxySettings |
	proxySettings := SptProxySettingDialog showModal.
	SptHTTPConnection beLoggingWireToTranscript.	"Note: this is a global setting that remains until turned off"
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/dh/index.html';
		addHeader: 'Accept' value: '*/*';
		proxySettings: proxySettings.
	request send.
	request waitOnReady.

	"Clean up"
	SptHTTPConnection beNotLoggingWire
!

exampleRedirection
	"
		The HTTPClient can automatically follow redirection responses.

		Following redirects can be fully disabled using the #isFollowRedirects setting.

		If this is enabled (the default):
			1/ It will check for redirection loops and signal an error if a url is visited more than twice.
			2/ The #maxRedirects: setting puts a limit on how many redirections will be followed.
				The default is SptHTTPSessionState(class)>>defaultMaxRedirects (5)
	"

	| request |
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/';
		addHeader: 'Accept' value: '*'.
	request send.
	request waitOnReady.	"Will block until response received"
	request status.	"Inspect It ... should be a 200"
	"Inspect the last response received"
	request lastResponse.
	"Inspect all responses received ... should have two response, the first being the redirection."
	request responses.

	"
		To disable redirection:
	"
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/';
		addHeader: 'Accept' value: '*/*';
		isFollowRedirects: false.
	request send.
	request waitOnReady.	"Will block until response received"
	request status.	"Inspect It ... should be a 302"
	"Inspect the last response received"
	request lastResponse.
	"Inspect all responses received ... should ony have one response"
	request responses
!

exampleSSL
	#todo
!

exampleState
	"
		A <SptHTTPSessionState> instance can be used to store information needed across multiple requests.
		including
			-Cookies
			-Timeouts
			-Authentication information
			-Proxy settings
	"

	| state request1 request2 |
	state := SptHTTPSessionState new.
	state timeout: nil.	"nil disables timeouts"
	state maxRedirects: 6.	"maximum number of redirects that will be automatically followed"
	state proxySettings: (SptHTTPProxySettings useHost: 'localhost' port: 8000).
	"Note: the following will cause an Authorization header only for urls in the http://www.foo.org/ namespace"
	state 
		username: 'steve'
		password: 'steve'
		for: 'http://www.foo.org/'.


	"This state can then be reused across requests"
	request1 := SptHTTPRequest new openGetTo: 'http://www.foo.org/1'.
	request1 state: state.
	"Do stuff"
	request2 := SptHTTPRequest new openGetTo: 'http://www.foo.org/2'.
	request2 state: state
!

exampleStreaming
	"
		The HTTPClient can be configured to either
			1/ Stream an entity to a server as part of request (typically a POST or PUT)
			2/ Stream an entity from a server (typically a GET)

		When streaming from a server, only a successful response (200) will use the stream
	"

	| request myStream |
	(request := SptHTTPRequest new)
		openGetTo: 'http://www.dolphinharbor.org/';
		addHeader: 'Accept' value: '*/*'.

	"Create the stream and set it into the request"
	myStream := FileStream 
				write: (FileLocator default localFileSpecFor: 'spt_stream_test.html')
				text: false.
	request okBodyStream: myStream.
	
	[request
		send;
		waitOnReady] ensure: [myStream close].

	"Notice that the first response received (a 302 redirection) was not streamed to 'myStream'"
	request responses
!

exampleTimeouts
	"
		The HTTPClient will process a request in a background process.

		The #waitOnReady message will block the active process until the background
			process completes. A timeout can be used to set a limit on how long the
			active process will block. (without any progress being made in the request)

		The #waitOnReadyCancelling message behaves the same as #waitOnReady except
			if the waiting process is terminated, the request will be cancelled.

		Timeouts are tied into the HTTPClients progress messages. Everytime a progress
			message is sent, the timeout is reset.

		A timeout value of 0 or nil will disable timeouts

		
	"

	#todo
! !

!SptHTTPRequest methodsFor:'Dolphin methods'!

userId: aStringOrNil
	Notification deprecated.
	self halt.
	url userId: aStringOrNil
! !

!SptHTTPRequest methodsFor:'accessing'!

bodyStream
	Notification deprecated.
	^okBodyStream
!

connection
	"Answer a <SptHTTPConnection>"

	^connection
!

entity
	"Answer a <SptHTTPEntity>"

	^entity
!

headerAt: aString
	"Answer the <String> value of the request header"

	^headers at: aString
!

headerReportString
	| stream |
	stream := String writeStream.
	stream
		nextPutAll: '===Out';
		cr.
	self putMessageStartOn: stream.
	self putSortedHeadersOn: stream.
	stream cr.
	responses do: 
			[:each | 
			each putHeaderReportOn: stream.
			stream
				cr;
				cr].
	^stream contents
!

headers
	"Answer a <PluggableLookupTable >"

	^headers
!

host
	Notification deprecated.
	self halt
	"^self useProxy ifTrue: [proxySettings proxyHost] ifFalse: [self url host]"
!

httpVersionString
	^self isVersion11 ifTrue: ['HTTP/1.1'] ifFalse: ['HTTP/1.0']
!

immediateHost
	"Answer the <String> host that the connection's socket should connect to."

	^state useProxy ifTrue: [self proxySettings proxyHost] ifFalse: [url host]
!

immediatePort
	"Answer the <Integer> port that the connection's socket should connect to."

	^state useProxy ifTrue: [self proxySettings proxyPort] ifFalse: [url port]
!

makingProgress
        "Answer the <SptHTTPProgress>.
        - Reset any timeouts"

        connection notNil ifTrue: [connection beTimeoutOn].
        ^progress

    "Modified: / 23-09-2011 / 21:18:52 / cg"
!

maxRedirects
	"Answer the maximum number of redirections that can automatically be followed"

	^state maxRedirects
!

method
	"Private - Answer the <String> method of the request (ie 'GET', 'POST' etc)"

	^method
!

okBodyStream
	"Answer the <WriteStream> that any OK response (ie 2xx) will be streamed to"

	^okBodyStream
!

port
	Notification deprecated.
	self halt
	"^self useProxy ifTrue: [proxySettings proxyPort] ifFalse: [self url port]"
!

progress
	"Answer a <SptHTTPProgress>"

	^progress
!

progress: aSptHTTPProgress
	progress := aSptHTTPProgress
!

proxySettings
	^state proxySettings
!

readEntityBufferSize
	^conf readEntityBufferSize
!

requestURI
	^self useProxy ifTrue: [self urlString] ifFalse: [url absolutePath]
!

sendEntityBufferSize
	^conf sendEntityBufferSize
!

socketStream
	^connection socketStream
!

state
	"Answer a <SptHTTPSessionState>"

	^state
!

state: aSptHTTPSessionState
	state := aSptHTTPSessionState
!

timeout
	^state timeout
!

url
	"Private - Answer the <SptHTTPUrl> url.
	If a redirect was followed, this will be the actual url of the resource."

	^url
!

url: aString
	"Must be of the form 'http://host/resource'"

	Notification deprecated.
	self urlString: aString
!

urlString
        ^url displayString

    "Modified: / 23-09-2011 / 22:20:01 / cg"
! !

!SptHTTPRequest methodsFor:'accessing-msxml'!

open: aMethodString bstrUrl: aUrl varAsync: aBool bstrUser: s1 bstrPassword: s2
	"MSXML IXMLHTTPRequest compatibility method"

	#deprecated.
	self urlString: aUrl.
	method := aMethodString.
	((s1 isNil or: [s1 isEmpty]) and: [s2 isNil or: [s2 isEmpty]]) 
		ifFalse: [self username: s1 password: s2]
!

send: aString
	"Use #setEntityOn: "

	#deprecated.
	self setEntityOn: aString.
	self send
!

setRequestHeader: aHeaderString bstrValue: aHeaderValue
	"MSXML IXMLHTTPRequest compatibility method"

	#deprecated.
	self addHeader: aHeaderString value: aHeaderValue
!

setTimeouts: t1 connectTimeout: t2 sendTimeout: t3 receiveTimeout: t4
	"MSXML IXMLHTTPRequest compatibility method"

	"On the receive timeout is used. See class comments."

	#deprecated.
	self timeout: t4
! !

!SptHTTPRequest methodsFor:'accessing-request'!

addHeader: aHeaderString value: aHeaderValue
	"Add the HTTP header to the request. 
	Note: do *not* include the colon in aHeaderString, (it will be added)"

	headers at: aHeaderString put: aHeaderValue
!

addIfAbsentHeader: aName value: aValue
	headers at: aName ifAbsentPut: [aValue]
!

entity: aSptHTTPEntity
	entity := aSptHTTPEntity
!

entityString: aString
	entity := SptHTTPEntity fromString: aString
!

method: aString
	"Set the HTTP method of the request (ie GET POST etc)"

	method := aString
!

okBodyStream: aByteWriteStream
	"Optional, Set the <WriteStream> (on a ByteArray)  that a 200 response will stream to"

	okBodyStream := aByteWriteStream
!

open: aMethodString to: aUrlString
	"Set the receiver to send a request using the HTTP method (typically GET or POST), to the url"

	self urlString: aUrlString.
	method := aMethodString
!

openGetTo: aUrlString
	"Set the receiver to send a GET request to the url"

	self open: 'GET' to: aUrlString
!

openPostTo: aUrlString
	"Set the receiver to send a POST request to the url"

	self open: 'POST' to: aUrlString
!

setEntityOn: aString
	entity := SptHTTPEntity fromByteObject: aString
!

setProgress: aSptHTTPProgress
	progress := aSptHTTPProgress.
	progress request: self
!

setUrl: aSptHTTPUrl
	"aSptHTTPUrl isDifferentAuthority ifTrue: [self removeAuthorizationHeader]."

	url := aSptHTTPUrl
!

urlString: aString
	self setUrl: (SptHTTPUrl fromString: aString previous: url)
! !

!SptHTTPRequest methodsFor:'accessing-response'!

lastResponse
	"Answer the last <SptHTTPResponse> received (previous responses may be
	redirects/not authorized responses that are automatically resent"

	^responses isEmpty ifTrue: [nil] ifFalse: [responses last]
!

responseBody
	"Answer a the response entity <String>"

	^self lastResponse body
!

responseHeaders
	"Answer a table of response headers"

	^self lastResponse headers
!

responses
	"Answer a collection of <SptHTTPResponse>s"
	^responses
!

status
	"Answer the status code <Integer> of the last response"

	^self lastResponse status
!

statusText
	"Answer the Status text of the response"

	^self lastResponse statusText
! !

!SptHTTPRequest methodsFor:'accessing-settings'!

conf
	"Answer a <SptHTTPConfiguration>"

	^conf
!

conf: aSptHTTPConfiguration
	conf := aSptHTTPConfiguration
!

cookieJar
	^state cookieJar
!

cookieJar: aSptHTTPCookieJar
	state cookieJar: aSptHTTPCookieJar
!

credentials: aSptCredentials
	state credentials: aSptCredentials
!

isAuthenticate: aBoolean
	flags := flags mask: IsAuthenticateMask set: aBoolean
!

isFollowRedirects: aBoolean
	flags := flags mask: IsFollowRedirectsMask set: aBoolean
!

isRangeRequest: aBoolean
	"Set if this is a range request.
		-If so, on a successful response, the okBodyStream's position 
		will be set to the starting byte position"

	flags := flags mask: IsRangeRequestMask set: aBoolean
!

isUseCookies: aBoolean
	flags := flags mask: IsUseCookiesMask set: aBoolean
!

isVersion11: aBoolean
	flags := flags mask: IsVersion11Mask set: aBoolean
!

maxRedirects: aNumber
	state maxRedirects: aNumber
!

proxySettings: aSptHTTPProxySettings
	state proxySettings: aSptHTTPProxySettings
!

timeout: millisecondsOrNil
	"Set the timeout value. 
	Note: The actual time before timing out will be somewhere between milliseconds and milliseconds * 2.
	nil disables the receiver's timeouts and relies on win socket timeouts"

	state timeout: millisecondsOrNil
!

username: aUsernameString password: aPasswordString
	(url isNil or: [url isNullUrl]) 
		ifTrue: [self error: 'Error: no url for the authentication, please set the url first'].
	state 
		username: aUsernameString
		password: aPasswordString
		for: self urlString
! !

!SptHTTPRequest methodsFor:'exceptions'!

errorAuthenticationFailed
	self 
		error: 'Authentication failed. No Basic Authentication challenge, Digest is not supported'
!

errorInternalError
	"Private - If this error is signalled, something has gone wrong with the 
	synchronisation  of the multiple processes the reciever uses"

	self error: 'HTTPClient internal synchronisation error'
!

errorMaximumRedirections
	self error: 'Maximum number of redirections reached'
!

errorRedirectionLoop
	self error: 'Redirection loop detected'
!

errorRetryNonIdempotentMethod
	self error: 'Should not automatically retry non-Idempotent methods'
! !

!SptHTTPRequest methodsFor:'initializing'!

initializeFor: aConfiguration
        headers := Dolphin::PluggableLookupTable new searchPolicy: Dolphin::SearchPolicy caseInsensitive.
        responses := OrderedCollection new.
        conf := aConfiguration.
        url := SptHTTPUrl new.
        state := SptHTTPSessionState new.
        progress := aConfiguration newProgressFor: self.
        flags := IsVersion11Mask | IsFollowRedirectsMask | IsAuthenticateMask | IsUseCookiesMask

    "Modified: / 23-09-2011 / 16:22:57 / cg"
! !

!SptHTTPRequest methodsFor:'modes'!

beVersion10
	"This effectively stops connections from being re-used"

	self isVersion11: false
! !

!SptHTTPRequest methodsFor:'operations-closing'!

cancelConnection
	"This cancels the socket.
	-If  the DeferredValue send is blocked reading, an error will be signalled in that process (which will cause the socket to be closed)
	-An error will also be signalled in any client processes blocking on #waitOnReady"

	connection notNil ifTrue: [connection cancelSocket]
!

close
	"With persistent connections, the meaning of this message can be ambiguous.
	
		If you want to cancel the background processing of the request, use the method #cancelConnection
		
	"

	Notification deprecated.
	self cancelConnection
! !

!SptHTTPRequest methodsFor:'operations-reading'!

closeOrKeepAliveConnection
        "Use the block temporary so that another process (possibly trying to cancel the connection)
                doesnt interupt the close-down sequence"

        |conn|

        (conn := connection) notNil ifTrue:[
                        connection := nil.
                        conn beTimeoutOff.
                        self terminateTimeoutLoop.
                        conn dumpWireLog.
                        (self isVersion11 not or: 
                                        [responses isEmpty or: 
                                                        [self lastResponse hasStatus not 
                                                                or: [self lastResponse isConnectionClose or: [self isConnectionClose]]]]) 
                                ifTrue: [conn closeSocket]
                                ifFalse: [conn keepAliveIfOpen]]

    "Modified: / 23-09-2011 / 22:54:32 / cg"
!

readResponse
	"Create a new response object, add it to our responses collection, then ask it to read the response.
	Note: adding the response to responses before reading it, allows it to be accessed through me.
		-Progress classes can take advantage of this."

	| response |
	self responses add: (response := conf newResponseFor: self).
	response readResponse: connection
! !

!SptHTTPRequest methodsFor:'operations-resending'!

prepareForAuthorize
        | basicChallenge user |
        self assert: [self isAuthenticate].
        (basicChallenge := self lastResponse basicChallenge) isNil 
                ifTrue: [self errorAuthenticationFailed].
        "Info required for Digest authentication (but not yet implemented)"
        basicChallenge rootUri: self url rootBaseUrlString.
        basicChallenge digestUri: self requestURI.
        "Note: we must check if we have previously sent authorization. If so, only resend if we get new info"
        ((headers includesKey: 'Authorization') 
                or: [(user := SptHTTPUser userFor: basicChallenge realm host: url host) isNil]) 
                        ifTrue: 
                                [((SptHTTPNotAuthorized new)
                                        challenge: basicChallenge;
                                        target: self) raiseRequest "signal"]
                        ifFalse: [self credentials: (basicChallenge credentialsFor: user)].
        ^true

    "Modified: / 23-09-2011 / 21:22:24 / cg"
!

prepareForRedirect
	"Set the new url
		-remove any authentication or cookie headers.
		- add any new authentication or cookie headers for the new url."

	self urlString: self lastResponse location.
	self removeAuthorizationHeader.
	(state shouldAuthenticate: self urlString) ifTrue: [self addAuthorizationHeader].
	self removeCookieHeader.
	self isUseCookies ifTrue: [self addCookieHeader].
	self makingProgress onRedirecting
!

prepareForRetry
        "There was an error retry the request.
                -make sure we *can* send a Range request, and whether it makes sense"

        (self canRangeRetry and: [self lastResponse bodyStreamSize > 0]) 
                ifTrue: 
                        ["Setting the beRangeRequest  mode means that if a response is read with a 'Range' header,
                                the SptHTTPResponse instance will set the position of the okBodyStream to
                                the start of the range interval."

                        self isRangeRequest: true.
                        "eg The second 500 bytes (byte offsets 500-999, inclusive): bytes=500-999 "
                        self addHeader: 'Range'
                                value: 'bytes=' , self lastResponse bodyStreamSize asString "displayString" , '-' 
                                                , (self lastResponse contentLength - 1) asString "displayString"].
        "Reset the bodyStream regardless ... we cant count on a server returning a range "
        okBodyStream notNil ifTrue: [okBodyStream reset]

    "Modified: / 23-09-2011 / 22:16:36 / cg"
!

prepareForSpecRetry
	"Prepare for a simple retry based on 
		<http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html#sec8.2.4>

	Unlike #prepareForRetry, dont attempt a 'Range' request ... this is intended for
		situations where the server closes the connection before we see any request "

	"mmm, maybe we dont need to do anything in this method?"

	okBodyStream notNil ifTrue: [okBodyStream reset]
!

prepareNextMessage: visited
	(self lastResponse isRedirect and: [self isFollowRedirects]) 
		ifTrue: 
			["I default to a low number of maxRedirects, but there is no standard maximum"

			visited size > self maxRedirects ifTrue: [self errorMaximumRedirections].
			self prepareForRedirect.
			"Allow the same url to be visted twice, but not three times.
			This allows sites that redirect back to the original url after setting a cookie."
			(visited select: [:each | each = self urlString]) size > 2 
				ifTrue: [self errorRedirectionLoop].
			^true].
	(self lastResponse isUnauthorized and: [self isAuthenticate]) 
		ifTrue: [^self prepareForAuthorize].
	^false
! !

!SptHTTPRequest methodsFor:'operations-sending'!

addAuthorizationHeader
	self addIfAbsentHeader: 'Authorization' value: state authorizationHeader
!

addCookieHeader
	| header |
	header := state cookieHeaderFor: url.
	(header notNil and: [header notEmpty]) 
		ifTrue: [self addIfAbsentHeader: 'Cookie' value: header]
!

addRequiredHeaders
	"Add any required headers, **only** if they have not been manually added"

	self addHeader: 'Host' value: self url hostPort.
	self addIfAbsentHeader: 'User-Agent' value: self class defaultUserAgent.
	(state shouldAuthenticate: self urlString) ifTrue: [self addAuthorizationHeader].
	self isUseCookies ifTrue: [self addCookieHeader].
	self hasEntity 
		ifTrue: [self addIfAbsentHeader: 'Content-Length' value: entity contentLength].
	(self hasEntity and: [self entity hasContentType]) 
		ifTrue: [self addIfAbsentHeader: 'Content-Type' value: entity contentType]
!

connect
	self progress onConnecting.
	connection := (url isSecure 
				ifTrue: [conf httpsConnectionClass]
				ifFalse: [conf httpConnectionClass]) 
					port: self immediatePort
					host: self immediateHost
					reuse: self isVersion11.
	self makingProgress onConnected
!

doAuthorizing: operation
	^operation on: SptHTTPNotAuthorized
		do: 
			[:e | 
			self removeAuthorizationHeader.
			e target: state.
			e site: self urlString.
			^(SptHTTPAuthorizationDialog showOnException: e) 
				ifTrue: [self doAuthorizing: operation]
				ifFalse: [self error: 'Authorization canceled']]
!

putHeaderName: nameString value: valueString on: aStream
        aStream
                nextPutAll: nameString;
                nextPutAll: ': ';
                nextPutAll: valueString asString "displayString";
                crlf

    "Modified: / 23-09-2011 / 22:16:38 / cg"
!

putMessageStartOn: aStream
	aStream
		nextPutAll: method;
		space;
		nextPutAll: self requestURI;
		space;
		nextPutAll: self httpVersionString;
		crlf
!

putSortedHeadersOn: aStream
	self sortedHeadersAndValuesDo: 
			[:name :value | 
			self 
				putHeaderName: name
				value: value
				on: aStream]
!

removeAuthorizationHeader
	headers removeKey: 'Authorization' ifAbsent: []
!

removeCookieHeader
	headers removeKey: 'Cookie' ifAbsent: []
!

send
        "Send the request with no entity (typical for a GET Request).
        This method returns immediately.
        You can either:
                -test with #isReady (and when true access the #responseBody).
                -wait (block) on #waitOnReady or  #waitOnReadyCancelling (and then access #responseBody)"

        "Note: If you are debuging an exception that occurs in the deferred send, you can
        uncomment the 'self halt' to open a debugger on the problem"

        deferredSend := 
                        [[self sendMessages] on: Error
                                do: 
                                        [:e | 
                                        self halt.

                                        e]] 
                                        deferredValue

    "Modified: / 04-10-2011 / 17:28:51 / cg"
!

sendAndRead
	"Private ... send the message and read the response.
	If this is curtailed, close the socket. This is not strictly necessary as. the socket
		would be closed anyway, however the 'contents' of the socket (consider 
		peristent connections) may now
		be in an inconsistent state. Closing the socket ensures an error is signalled
		if we try to read/write from it again."

	
	[self sendMessage.
	self readResponse] 
			ifCurtailed: [connection notNil ifTrue: [connection closeSocket]]
!

sendHeader: anAssoc
        (self socketStream)
                nextPutAll: anAssoc key;
                nextPutAll: ': ';
                nextPutAll: anAssoc value asString "displayString";
                crlf

    "Modified: / 23-09-2011 / 22:16:41 / cg"
!

sendMessage
	self connect.
	self sendMessageStart.
	self sendMessageHeaders.
	self hasEntity ifTrue: [self sendMessageBody].
	self socketStream flush
!

sendMessageBody
	| sent total chunk |
	self makingProgress onSendingEntity.
	sent := 0.
	total := entity contentLength.
	[entity stream atEnd] whileFalse: 
			[self socketStream 
				nextPutAll: (chunk := entity stream nextAvailable: self sendEntityBufferSize).
			self makingProgress sent: (sent := sent + chunk size) of: total].
	self makingProgress onSentEntity
!

sendMessageHeaders
	self makingProgress onSendingHeaders.
	self addRequiredHeaders.
	self putSortedHeadersOn: self socketStream.
	self socketStream crlf.
	self makingProgress onSentHeaders
!

sendMessageStart
	self putMessageStartOn: self socketStream
!

sendMessages
	"sent in the deferred process(thread)"

	| visited |
	visited := OrderedCollection new.
	
	[visited add: self urlString.
	[self sendAndRead] ensure: [self closeOrKeepAliveConnection].
	self prepareNextMessage: visited] 
			whileTrue.
	self makingProgress onCompleted
!

sortedHeadersAndValuesDo: aTwoArgBlock
	| keys |
	keys := headers keys asSortedCollection: self class.	"collect: [:each | each asLowercase]"
	keys do: [:each | aTwoArgBlock value: each value: (headers at: each)]
! !

!SptHTTPRequest methodsFor:'process synchronisation'!

startTimeoutLoop
	"
	-Fork a second process that repeats until terminated. It sends the receiver the #checkTimeout message. 
	This method firstly checks whether the receiver is in a state that can timeout (See #checkTimeout comment) , 
		and if so closes the socket. (See #close comment)"

	timeoutLoop isNil ifFalse: [self errorInternalError].
	timeoutLoop := 
			[
			[(Delay forMilliseconds: self waitTimingMilliseconds) wait.
			connection notNil ifTrue: [connection checkTimeout ifTrue: [progress onTimeout]].
			true] 
					whileTrue] 
					forkAt: 6.
	timeoutLoop name: 'Timeout for: ' , self urlString
!

terminateTimeoutLoop
	timeoutLoop isNil ifTrue: [^nil].
	timeoutLoop terminate.
	timeoutLoop := nil
!

waitOnReady
        "Block the active process until the request has been processed. 
        -This will signal an error in the active process if one occurs in the background process.
        "

        Smalltalk isSmalltalkX ifFalse:[
            #todo.  "Should timeout of 0 return immediately?"
            "Necessary if sent from the main process"
            Processor forkMainIfMain.
        ].

        ^
        [(self timeout isNil or: [self timeout = 0]) 
                ifFalse: 
                        ["-Fork a second process that repeats until terminated. It sends the receiver the #checkTimeout message. 
                                This method firstly checks whether the receiver is in a state that can timeout 
                                (See #checkTimeout comment) , and if so closes the socket. (See #close comment)"

                        self startTimeoutLoop].
        deferredSend value] 
                        ensure: [self terminateTimeoutLoop]

    "Modified: / 23-09-2011 / 16:23:55 / cg"
!

waitOnReadyCancelling
	"Same as #waitOnReady except if the waiting process is terminated,
		cancel the connection (which will cause the deferredSends process to terminate)"

	[self waitOnReady] ifCurtailed: [self cancelConnection]
!

waitOnReadyRetrying: aNumber
	"This will retry a request if the server closes the connection.
	It is *not* an implementation of 
		<http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html#sec8.2.4>
		8.2.4 Client Behavior if Server Prematurely Closes Connection 

		-It doesnt do a time back-off
		-It will retry even if a partial response has been read.

	See #prepareForRetry comment"

	| shouldRetry |
	self isIdempotent ifFalse: [self errorRetryNonIdempotentMethod].
	shouldRetry := false.
	[self waitOnReady] on: SocketClosed
		do: [:e | aNumber = 0 ifTrue: [e pass] ifFalse: [shouldRetry := true]].
	shouldRetry ifFalse: [^aNumber].
	"self reportPreRetry: aNumber."
	deferredSend hasValue ifFalse: [self errorInternalError].
	"This will check to see if we can use a 'Range' request"
	self prepareForRetry.
	"self reportPostRetry."
	self send.
	^self waitOnReadyRetrying: aNumber - 1
!

waitOnReadySpecRetrying: aNumber
	"This will retry a request if the server closes the connection before we receive any status from the server
	It is a loose implementation of 
		<http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html#sec8.2.4>
		8.2.4 Client Behavior if Server Prematurely Closes Connection 

		-It doesnt do a time back-off.

	Note: this method is more robust than #waitOnReadyRetrying: which attempts to retry requests that
		have been partially received (and also attempts to use a 'Range' Request"

	| shouldRetry |
	shouldRetry := false.
	[self waitOnReady] on: SocketClosed
		do: 
			[:e | 
			"Can only retry if we dont receive any status from the server"

			(aNumber = 0 or: [self lastResponse hasStatus]) 
				ifTrue: [e pass]
				ifFalse: [shouldRetry := true]].
	shouldRetry ifFalse: [^aNumber].
	deferredSend hasValue ifFalse: [self errorInternalError].
	self prepareForSpecRetry.
	"The spec suggests using a 'binary exponential backoff' algorithm, but a constant looks fine to me.
	Note: This delay should occur after sending the headers, but before sending any entity"
	[Delay forSeconds: 5] wait.
	self send.
	^self waitOnReadyRetrying: aNumber - 1
!

waitTimingMilliseconds
	^(connection notNil and: [connection isTimeoutWaiting]) 
		ifTrue: [self timeout]
		ifFalse: [3000]
! !

!SptHTTPRequest methodsFor:'test accessing'!

connection: aSptHTTPConnection
	"Unit Test helper method"

	connection := aSptHTTPConnection
!

deferredSend: anObject
        "Unit Test helper method"

        deferredSend := anObject.
"/ Stderr show:'deferredSend is '; showCR:deferredSend class.

    "Modified: / 04-10-2011 / 18:41:41 / cg"
!

timeoutLoop
	"Unit Test helper method"

	^timeoutLoop
!

timeoutLoop: anObject
	"Unit Test helper method"

	timeoutLoop := anObject
! !

!SptHTTPRequest methodsFor:'testing'!

canRangeRetry
	"Answer whether we can retry the request, only asking for the range of bytes we dont have"

	^responses notEmpty and: [self lastResponse canRangeRetry]
!

hasEntity
	^entity notNil	"and: [entity contentLength ~= 0]"
!

isAuthenticate
	^flags anyMask: IsAuthenticateMask
!

isConnectionClose
	"Answer whether the user added a Connection: close header to the request.
	-The server should respond with the same header, but use the fact that the user added it to ensure the
	connection is not re-used"

	^(headers at: 'Connection' ifAbsent: [^false]) = 'close'
!

isFollowRedirects
	^flags anyMask: IsFollowRedirectsMask
!

isIdempotent
	^#('GET' 'HEAD' 'PUT' 'DELETE' 'OPTIONS' 'TRACE') includes: method
!

isRangeRequest
	"Answer if this is a range request.
		-If so, on a successful response, the okBodyStream's position 
		will be set to the starting byte position"

	^flags anyMask: IsRangeRequestMask
!

isReady
	"Answer whether the response has been fully read."

	^deferredSend hasValue
		
		
!

isUseCookies
	^flags anyMask: IsUseCookiesMask
!

isVersion11
	^flags anyMask: IsVersion11Mask
!

useProxy
	^state useProxy
! !

!SptHTTPRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPRequest.st,v 1.6 2011-10-04 16:48:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPRequest.st,v 1.6 2011-10-04 16:48:33 cg Exp $'
! !

SptHTTPRequest initialize!

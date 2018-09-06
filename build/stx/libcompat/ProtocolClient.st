"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ProtocolClient
	instanceVariableNames:'stream connectInfo lastResponse pendingResponses
		progressObservers'
	classVariableNames:''
	poolDictionaries:''
	category:'Network-Protocols'
!

ProtocolClient comment:'ProtocolClient is the abstract super class for a variety of network protocol clients.
It uses a stream rather than the direct network access so it could also work for streams on serial connections etc.

Structure:
	stream				stream representing the connection to and from the server
	connectInfo			information required for opening a connection
	lastResponse			remembers the last response from the server.
	progressObservers 	any object understanding #show: can be registered as a progress observer (login, transfer, etc)'
!


!ProtocolClient class methodsFor:'instance creation'!

openOnHost: hostIP port: portNumber
	^self new openOnHost: hostIP port: portNumber
!

openOnHostNamed: hostName
	"If the hostname uses the colon syntax to express a certain portnumber
	we use that instead of the default port number."

	| i |
	i := hostName indexOf: $:.
	i = 0 ifTrue: [
			^self openOnHostNamed: hostName port: self defaultPortNumber]
		ifFalse: [
			| s p | 
			s := hostName truncateTo: i - 1.
			p := (hostName copyFrom: i + 1 to: hostName size) asInteger.
			^self openOnHostNamed: s port: p]
	
!

openOnHostNamed: hostName port: portNumber
	| serverIP |
	serverIP := NetNameResolver addressForName: hostName timeout: 20.
	^self openOnHost: serverIP port: portNumber
! !

!ProtocolClient class methodsFor:'accessing'!

defaultPortNumber
	self subclassResponsibility
!

logFlag
	self subclassResponsibility
! !

!ProtocolClient methodsFor:'accessing'!

logProgressToTranscript
	self progressObservers add: Transcript
!

messageText
	^super messageText
		ifNil: [self response]
!

response
	^self protocolInstance lastResponse
!

stream
	^stream
!

stream: aStream
	stream := aStream
! !

!ProtocolClient methodsFor:'actions'!

close
	self stream
		ifNotNil: [
			self stream close.
			stream := nil]
!

reopen
	self ensureConnection
! !

!ProtocolClient methodsFor:'private'!

connectionInfo
	connectInfo ifNil: [connectInfo := Dictionary new].
	^connectInfo
!

defaultPortNumber
	^self class defaultPortNumber
!

ensureConnection
	self isConnected
		ifTrue: [^self].
	self stream
		ifNotNil: [self stream close].

	self stream: (SocketStream openConnectionToHost: self host port: self port).
	self checkResponse.
	self login
!

host
	^self connectionInfo at: #host
!

host: hostId
	^self connectionInfo at: #host put: hostId
!

lastResponse
	^lastResponse
!

lastResponse: aString
	lastResponse := aString.
!

logFlag
	^self class logFlag
!

logProgress: aString
	self progressObservers do: [:each | each show: aString].
!

openOnHost: hostIP port: portNumber
	self host: hostIP.
	self port: portNumber.
	self ensureConnection
!

password
	^self connectionInfo at: #password
!

password: aString
	^self connectionInfo at: #password put: aString
!

pendingResponses
	pendingResponses ifNil: [pendingResponses := OrderedCollection new].
	^pendingResponses
!

popResponse
	| pendingResponse |
	pendingResponse := self pendingResponses removeFirst.
	pendingResponses isEmpty
		ifTrue: [pendingResponses := nil].
	^pendingResponse
!

port
	^self connectionInfo at: #port
!

port: aPortNumber
	^self connectionInfo at: #port put: aPortNumber
!

progressObservers
	progressObservers ifNil: [progressObservers := OrderedCollection new].
	^progressObservers
!

pushResponse: aResponse
	self pendingResponses add: aResponse
!

resetConnectionInfo
	connectInfo := nil
!

user
	^self connectionInfo at: #user ifAbsent: [nil]
!

user: aString
	^self connectionInfo at: #user put: aString
! !

!ProtocolClient methodsFor:'private protocol'!

checkForPendingError
	"If data is waiting, check it to catch any error reports.
	In case the response is not an error, push it back."

	self stream isDataAvailable
		ifFalse: [^self].
	self fetchNextResponse.
	self
		checkResponse: self lastResponse
		onError: [:response | (TelnetProtocolError protocolInstance: self) signal]
		onWarning: [:response | (TelnetProtocolError protocolInstance: self) signal].
	"if we get here, it wasn't an error"
	self pushResponse: self lastResponse
!

checkResponse
	self
		checkResponseOnError: [:response | (TelnetProtocolError protocolInstance: self)
				signal: response]
		onWarning: [:response | (TelnetProtocolError protocolInstance: self)
				signal: response]
!

checkResponse: aResponse onError: errorBlock onWarning: warningBlock
	"Get the response from the server and check for errors. Invoke one of the blocks if an error or warning is encountered. See class comment for classification of error codes."

	self responseIsError
		ifTrue: [errorBlock value: aResponse].
	self responseIsWarning
		ifTrue: [warningBlock value: aResponse].
!

checkResponseOnError: errorBlock onWarning: warningBlock
	"Get the response from the server and check for errors. Invoke one of the blocks if an error or warning is encountered. See class comment for classification of error codes."

	self fetchPendingResponse.
	self checkResponse: self lastResponse onError: errorBlock onWarning: warningBlock
!

fetchNextResponse
	self lastResponse: self stream nextLine
!

fetchPendingResponse
	^pendingResponses
		isNil ifTrue: [self fetchNextResponse. self lastResponse]
		ifFalse: [self popResponse].
!

sendCommand: aString
	self stream sendCommand: aString.
!

sendStreamContents: aStream
	self stream sendStreamContents: aStream
! !

!ProtocolClient methodsFor:'private testing'!

responseIsError
	self subclassResponsibility
!

responseIsWarning
	self subclassResponsibility
! !

!ProtocolClient methodsFor:'testing'!

isConnected
	^stream notNil
		and: [stream isConnected]
! !

!ProtocolClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ProtocolClient.st,v 1.2 2018-05-14 07:36:26 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/ProtocolClient.st,v 1.2 2018-05-14 07:36:26 stefan Exp $'
! !


"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPConnection
	instanceVariableNames:'host port socket socketStream timeoutState keepAliveTime'
	classVariableNames:'IsLoggingWire WireLogStream'
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPConnection class instanceVariableNames:'keepAlives'

"
 No other class instance variables are inherited by this class.
"
!

SptHTTPConnection comment:'SptHTTPConnection

I am a connection to an HTTP server.

I can be reused, which is the default in HTTP 1.1. To avoid problems of the server closing a connection via a time-out, and having to resend the request, I will only be reused within 5 seconds of my last use. The keepAliveTime instanceVariable is used to store the millisecondClockValue of my last use.

The class mode; #beLoggingWire (#beNotLoggingWire) can be used to dump full logs of all characters received/sent over each connection to the Transcript.

See #checkTimeout for info on timeoutState


Instance Variables
	host            <String> (eg ''www.yahoo.com'')
	port            <Integer> (eg 80)
	socket          <Socket>
	socketStream    <SZReadWriteSocketStream>
	timeoutState    <Symbol>
	keepAliveTime   <Integer>


'
!


!SptHTTPConnection class methodsFor:'instance creation'!

new
	^super new initialize
!

newOnPort: aSmallInteger host: aString
	^(self new)
		port: aSmallInteger host: aString;
		connect;
		yourself
!

port: aSmallInteger host: aString reuse: aBoolean
	"Answer an instance.
	Note: an exisiting instance will be answered if resuse is true,
		and we have a connection that we are keeping alive for the host/port"

	^aBoolean
		ifTrue: [self reuseOnPort: aSmallInteger host: aString]
		ifFalse: [self newOnPort: aSmallInteger host: aString]
!

reuseOnPort: aSmallInteger host: aString
	"Note: Need to be careful that two requests (each in forked process)
		dont think they can re-use the same connection"

	self removeStaleKeepAlives.
	^keepAlives removeKey: aString , ':' , aSmallInteger displayString
		ifAbsent: [self newOnPort: aSmallInteger host: aString]

    "Modified: / 23-09-2011 / 22:18:53 / cg"
! !

!SptHTTPConnection class methodsFor:'accessing'!

isLoggingWire: aBoolean
	IsLoggingWire := aBoolean
!

keepAlive: aConnection
	"Add the instance to our table of connection to (possibly) re-use"

	aConnection beTimeoutOff.
	aConnection setKeepAliveTime.
	keepAlives at: aConnection hostPortString put: aConnection
!

socketStreamClass
    IsLoggingWire ifTrue: [
        self assert: SZLoggingSocketStream notNil.
        ^ SZLoggingSocketStream
    ] ifFalse: [
        self assert: SZReadWriteSocketStream notNil.
        ^ SZReadWriteSocketStream
    ]

    "Modified: / 04-10-2011 / 18:42:10 / cg"
!

wireLogStream
	^WireLogStream
!

wireLogStream: aWriteStream
	WireLogStream := aWriteStream
! !

!SptHTTPConnection class methodsFor:'constants'!

staleMilliseconds
	"FWIW: I believe that Apache defaults to 20seconds, so this
	should be low enough to keep us under the radar screen while
	still being high enough to satisfy rapid fire multiple requests"

	^5000
! !

!SptHTTPConnection class methodsFor:'event handling'!

onImageSaveStarting
	"Avoid saving any instances into an image"

	| temp |
	temp := keepAlives.
	keepAlives := Dolphin::SharedLookupTable new.
	temp values do: [:each | each closeSilently]

    "Modified: / 23-09-2011 / 22:45:09 / cg"
! !

!SptHTTPConnection class methodsFor:'initializing'!

initialize
	"
	self initialize
	"

	keepAlives := Dolphin::SharedLookupTable new.
	IsLoggingWire := false.
"/        SessionManager current
"/                when: #imageSaveStarting
"/                send: #onImageSaveStarting
"/                to: self

    "Modified: / 23-09-2011 / 22:45:01 / cg"
!

uninitialize
	"
	self uninitialize
	"

	keepAlives := nil.
	WireLogStream := nil
! !

!SptHTTPConnection class methodsFor:'modes'!

beLoggingWire
	"
	self beLoggingWire.
	self wireLogStream: Transcript.
	"

	IsLoggingWire := true.
	self removeKeepAlives
!

beLoggingWireToTranscript
	"
	self beLoggingWireToTranscript.
	"

	self beLoggingWire.
	self wireLogStream: (self environment at: #Transcript)
!

beNotLoggingWire
	"
	self beNotLoggingWire
	"

	IsLoggingWire := false.
	self removeKeepAlives
! !

!SptHTTPConnection class methodsFor:'operations'!

removeKeepAlives
	"
	self removeKeepAlives.
	keepAlives
	"

	| removes |
	removes := keepAlives values asOrderedCollection.
	removes
		do: [:each | (keepAlives removeKey: each ifAbsent: [Dolphin::DeafObject current]) closeSilently]
!

removeStaleKeepAlives
	"
	self removeStaleKeepAlives.
	keepAlives
	"

	| removes |
	removes := OrderedCollection new.
	keepAlives keysAndValuesDo: [:key :value | value isStale ifTrue: [removes add: key]].
	removes
		do: [:each | (keepAlives removeKey: each ifAbsent: [Dolphin::DeafObject current]) closeSilently]
! !

!SptHTTPConnection class methodsFor:'testing'!

isLoggingWire
	^IsLoggingWire
! !

!SptHTTPConnection methodsFor:'accessing'!

host
	^host
!

host: aHostString
	host := aHostString
!

hostPortString
	self assert: [port >= 0].
	^host , ':' , port displayString

    "Modified: / 23-09-2011 / 22:19:01 / cg"
!

logWire: aString
	| stream |
	stream := String writeStream.
	stream
		cr;
		nextPutAll: '=======';
		cr;
		print: socket;
		cr;
		nextPutAll: aString.

	[(self class wireLogStream ifNil: [Transcript])
		nextPutAll: stream contents;
		cr]
			on: Error
			do: [:e | ]
!

port
	^port
!

port: anObject
	port := anObject
!

port: aSmallInteger host: aString
	port := aSmallInteger.
	host := aString
!

setKeepAliveTime
	keepAliveTime := Delay millisecondClockValue
!

socket
	^socket
!

socketStream
	^socketStream
!

socketStream: aSZReadWriteSocketStream
	socketStream := aSZReadWriteSocketStream
! !

!SptHTTPConnection methodsFor:'initializing'!

initialize
	super initialize.
	timeoutState := #off
! !

!SptHTTPConnection methodsFor:'modes'!

beTimeoutNotWaiting
	"See #checkTimeout"

	Notification deprecated.
	timeoutState == #wait ifTrue: [timeoutState := #on]
!

beTimeoutOff
	"See #checkTimeout"

	timeoutState := #off
!

beTimeoutOn
	"See #checkTimeout"

	timeoutState := #on
! !

!SptHTTPConnection methodsFor:'operations'!

cancelSocket
	"Cancel the socket.
	See SptHTTPRequest>>cancelConnection "

	socket notNil ifTrue: [socket cancel]
!

checkTimeout
	"If the timeoutState is #wait, then we activate the timeout by cancelling the socket.
		(This will cause a timeout SocketError exception to be signaled in
		the process that is blocked trying to read (or write) from the socket)

	If the timeoutState is #on, we move it to #wait (so the next time we check, we may timeout).

	See SptHTTPRequest>>makingProgress ... which resets the timeoutState to #on each time
	we read or write to the socket"

	timeoutState == #off ifTrue: [^false].
	timeoutState == #wait
		ifTrue:
			[timeoutState := #off.
			self cancelSocket.
			^ true]
		ifFalse:
			[timeoutState := #wait.
			^ false]
!

close
	"Close the socket.
	-If  the DeferredValue send is blocked reading, an error will be signalled in that process (which will cause the socket to be closed)
	-An error will also be signalled in any client processes blocking on #waitOnReady"

	Notification deprecated.
	self cancelSocket
!

closeSilently
	[self closeSocket] on: Error do: [:e | ]
!

closeSocket
	"Close the socket.

	This can safely be sent to a socket that is already closed"

	socket notNil ifTrue: [socket close]
!

connect
	self connectSocket.
	socketStream := self class socketStreamClass socket: socket
!

connectSocket
	| address retry |
	address := (SptHTTPHostCache current ipAddressFor: self host).
	"/ address := InternetAddress ipAddress: (SptHTTPHostCache current ipAddressFor: self host).
	socket := nil.
	"The retry is necessary to handle what I understand to be a WinSock bug.
	-It will only show if many small requests are made quickly. ( I can reproduce on my local network by forking 10 processes each sending 200 requests to the same address).
	-See <http://www.cygwin.com/ml/cygwin-developers/2001-11/msg00080.html> for a discussion of the problem"

	"Update: 20021113 ... this may have been caused by waiting for finalization to close sockets.
	I have not seen the Notifcation since making the changes to manually close sockets"
	retry := 5.
	[socket isNil and: [retry > 0]] whileTrue:
			[
			    "/ [(socket := Socket port: self port address: address) connect]
			    [ socket := Socket newTCPclientToAddress:address port: self port ]
				on: StreamError "SocketError"
				do:
					[:e |
					e errorCode = 10048
						ifTrue:
							[socket close.
							socket := nil.
							Notification signal: 'SptHTTPConnection connect  WSAEADDRINUSE'.
							(retry := retry - 1) = 0 ifTrue: [e pass]]
						ifFalse: [e pass]]].
	^socket

    "Modified: / 23-09-2011 / 22:51:09 / cg"
!

dumpWireLog
	self class isLoggingWire
		ifTrue:
			[self logWire: socketStream log.
			socketStream resetLogStream]
!

isTimeoutWaiting
	^timeoutState == #wait
!

keepAliveIfOpen
	(socket notNil and: [socket isOpen]) ifTrue: [self class keepAlive: self]
! !

!SptHTTPConnection methodsFor:'test accessing'!

socket: aSocket
	"Unit Test helper method"

	socket := aSocket
!

timeoutState
	"Unit Test helper method"

	^timeoutState
!

timeoutState: anObject
	"Unit Test helper method"

	timeoutState := anObject
! !

!SptHTTPConnection methodsFor:'testing'!

isStale
	keepAliveTime isNil ifTrue: [^true].
	^Delay millisecondClockValue - keepAliveTime > self class staleMilliseconds
! !

!SptHTTPConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPConnection.st,v 1.6 2011-10-04 16:42:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPConnection.st,v 1.6 2011-10-04 16:42:17 cg Exp $'
! !

SptHTTPConnection initialize!

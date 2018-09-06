"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkLayer subclass:#SocketThunk
	instanceVariableNames:'stack serverProcess socket primitiveFailedError'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

SocketThunk comment:'I am an endpoint for network communication.  I am also a ProtocolLayer and I therefore expect to be inserted as the lowest element in a LayeredProtocol stack.Structure:	socket			(Socket)	-- the socket on which I communicate.'
!


!SocketThunk class methodsFor:'examples'!

newConnection: host port: port

	| s addr |
	Socket initializeNetwork.
	(addr := NetNameResolver addressForName: host) isNil
		ifTrue: [^nil].
	(s := Socket newTCP)
		connectTo: addr port: port waitForConnectionFor: 5.
	s isWaitingForConnection
		ifTrue: [s destroy. ^nil].
	^self newSocket: s
!

newSocket: sock

	^self new initializeOnSocket: sock
! !

!SocketThunk methodsFor:'accessing'!

stack

	^ stack
! !

!SocketThunk methodsFor:'control'!

run
	"Spawn a background process running the serverLoop."

	super run.
	serverProcess := [self serverLoop] forkAt: Processor userInterruptPriority.
!

serverLoop
        "I sit in a loop (usually in a background Process) waiting for data to arrive on my underlying connection then pass anything received up to my high protocol.  When #getData answers nil to inform me that my underlying connection has been destroyed I close down the entire endpoint, inform my session of the fact and then exit.  See also ProtocolEndpoint>>run."

        [ 
            [ 
                |bytes|

                (bytes := self getData) ifNotNil: [
                    stack
                        upcall: (Frame onHeader: RawData new payload: bytes)
                        from: self
                ].
                self isConnected 
            ] whileTrue 
        ] ensure: [
            serverProcess := nil.
            stack ifNotNil: [ stack shutdown ] ].
! !

!SocketThunk methodsFor:'initialize-release'!

initializeOnSocket: sock

	self initialize.
	stack := ThunkStack on: self.
	socket := sock.
	primitiveFailedError := (Smalltalk hasClassNamed: #NotImplemented)
		ifTrue: [Smalltalk classNamed: #NotImplemented]
		ifFalse: [Smalltalk classNamed: #PrimitiveFailed].
! !

!SocketThunk methodsFor:'protocol'!

close

	socket notNil ifTrue: [[socket closeAndDestroy: 10] on: SocketPrimitiveFailed do: [:e | ] ].
	serverProcess isNil
		ifFalse:
			[serverProcess terminate.
			 serverProcess := nil].
	super close.
!

getData

	| count buffer |
	buffer := ByteArray new: 12288 withAll: 0.
	Processor yield.
	[ socket dataAvailable
		ifTrue: [
			[ count := socket receiveDataInto: buffer ] on: Exception do: [:ex | ex pass].
			 ^buffer copyFrom: 1 to: count]
		ifFalse: [ [ [ [ socket waitForDataFor: 1 ]
				on: primitiveFailedError do: [:ex | socket isConnected ifTrue: [ex pass] ] ]
				on: NetworkError do: [:ex | ] ]
				on: SocketPrimitiveFailed do: [:ex | socket isConnected ifTrue: [ex pass] ] ].
	socket isConnected] whileTrue.
	^nil
!

isConnected

	^ socket isConnected
! !

!SocketThunk methodsFor:'thunk - accessing'!

doesPop

	^ false
!

doesPush

	^ false
!

downThunk

	^ [:frame |
		socket isConnected
			ifTrue: [	socket sendData: frame payload. frame]
			ifFalse: [socket closeAndDestroy. nil] ].
! !

!SocketThunk class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SocketThunk.st,v 1.2 2018-05-14 00:24:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SocketThunk.st,v 1.2 2018-05-14 00:24:09 cg Exp $'
! !


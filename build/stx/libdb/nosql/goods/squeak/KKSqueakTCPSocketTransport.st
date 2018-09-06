"{ Package: 'stx:libdb/nosql/goods/squeak' }"

KKTransport subclass:#KKSqueakTCPSocketTransport
	instanceVariableNames:'socket'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Platform-Squeak'
!


!KKSqueakTCPSocketTransport class methodsFor:'class initialization'!

initialize
	"self initialize"
	self makeDefault
! !

!KKSqueakTCPSocketTransport methodsFor:'api'!

close
	"Close this transport"
	socket closeAndDestroy.
	socket := nil
!

isConnected
	"Answer true if the transport is connected to another endpoint and can send data, false otherwise."
	^socket notNil and: [socket isValid and: [socket isConnected]]
!

isDataAvailable
	"Answer true if there is data that can be read from the socket without blocking, false otherwise."
	^socket dataAvailable
!

receiveDataInto: aBuffer startingAt: i
	"Read available data into aBuffer starting at index i either until aBuffer is full or no data remains to be read.  Answer the number of bytes read or zero to indicate that the connection was closed by the other end."
	^socket receiveDataInto: aBuffer startingAt: i
!

sendData: aByteArray
	"Send the specified byte array to the server.  This should be an unbuffered Smalltalk-process blocking call."
	socket sendData: aByteArray
! !

!KKSqueakTCPSocketTransport methodsFor:'initialize-release'!

initializeHost: hostname port: portNumber
	"Create and connect to specified host and port number."
	Socket initializeNetwork.
	socket := Socket newTCP
				connectTo: (NetNameResolver addressForName: hostname)
				port: portNumber.
	(Delay forMilliseconds: 10) wait.
! !

!KKSqueakTCPSocketTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/KKSqueakTCPSocketTransport.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/KKSqueakTCPSocketTransport.st,v 1.2 2013-03-28 10:38:50 cg Exp $'
! !


KKSqueakTCPSocketTransport initialize!

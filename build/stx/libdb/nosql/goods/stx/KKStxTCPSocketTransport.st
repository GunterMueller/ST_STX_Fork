"{ Package: 'stx:libdb/nosql/goods/stx' }"

KKTransport subclass:#KKStxTCPSocketTransport
	instanceVariableNames:'socket'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Platform-Stx'
!


!KKStxTCPSocketTransport class methodsFor:'class initialization'!

initialize
	"self initialize"
	self makeDefault
! !

!KKStxTCPSocketTransport methodsFor:'api'!

close
	"Close this transport"
	socket close. "/ AndDestroy.
	socket := nil
!

isConnected
	"Answer true if the transport is connected to another endpoint and can send data, false otherwise."
	^socket notNil and: ["socket isValid and: ["socket isConnected]"]"
!

isDataAvailable
	"Answer true if there is data that can be read from the socket without blocking, false otherwise."
	^socket dataAvailable
!

receiveDataInto: aBuffer startingAt: i
	"Read available data into aBuffer starting at index i either until aBuffer is full or no data remains to be read.  Answer the number of bytes read or zero to indicate that the connection was closed by the other end."
	^socket nextAvailableBytes:aBuffer size into:aBuffer startingAt: i
"/        ^socket receiveDataInto: aBuffer startingAt: i
!

sendData: aByteArray
	"Send the specified byte array to the server.  This should be an unbuffered Smalltalk-process blocking call."
	socket sendData: aByteArray
! !

!KKStxTCPSocketTransport methodsFor:'initialize-release'!

initializeHost: hostname port: portNumber
        |connected|

        "Create and connect to specified host and port number."

        socket := Socket newTCP.
        connected := socket
                        connectTo:hostname
                        port:portNumber
                        withTimeout:("connectTimeout ?" 10) * 1000.   "/ 10 seconds.
        connected ifFalse:[
             KKConnectError raiseErrorString:('cannot connect to goods server: %1:%2' bindWith:hostname with:portNumber)
        ]
! !

!KKStxTCPSocketTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx/KKStxTCPSocketTransport.st,v 1.3 2013-04-01 17:53:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx/KKStxTCPSocketTransport.st,v 1.3 2013-04-01 17:53:55 cg Exp $'
! !


KKStxTCPSocketTransport initialize!

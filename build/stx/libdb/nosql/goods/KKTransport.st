"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKTransport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Protocol'
!

KKTransport comment:'I define an socket-like API for concrete implementations.'
!


!KKTransport class methodsFor:'instance creation'!

hostname: hostname port: portNumber
	^self new initializeHost: hostname port: portNumber
! !

!KKTransport class methodsFor:'default transport'!

makeDefault

	KKDatabase defaultTransportClass: self
! !

!KKTransport methodsFor:'api'!

close
	"Close this transport"
!

isConnected
	"Answer true if the transport is connected to another endpoint and can send data, false otherwise."
!

isDataAvailable
	"Answer true if there is data that can be read from the socket without blocking, false otherwise."
!

receiveDataInto: aBuffer startingAt: i
	"Read available data into aBuffer starting at index i either until aBuffer is full or no data remains to be read.  Answer the number of bytes read or zero to indicate that the connection was closed by the other end."
!

sendData: aByteArray
	"Send the specified byte array to the server.  This should be an unbuffered Smalltalk-process blocking call."
! !

!KKTransport methodsFor:'initialize-release'!

initializeHost: hostname port: portNumber
	"Create and connect to specified host and port number."
! !

!KKTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKTransport.st,v 1.3 2013-03-31 12:18:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKTransport.st,v 1.3 2013-03-31 12:18:23 cg Exp $'
! !


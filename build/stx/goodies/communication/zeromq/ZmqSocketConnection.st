"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocketAssociation subclass:#ZmqSocketConnection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqSocketConnection comment:''
!


!ZmqSocketConnection methodsFor:'as yet unclassified'!

associationTypeName 
	^'connetion'
! !

!ZmqSocketConnection methodsFor:'operations'!

associateSocket:  aZmqSocket
	aZmqSocket zmqApi connectSocket: aZmqSocket socketPointer to: target.
! !

!ZmqSocketConnection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocketConnection.st,v 1.1 2018-05-08 19:45:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocketConnection.st,v 1.1 2018-05-08 19:45:48 cg Exp $'
! !


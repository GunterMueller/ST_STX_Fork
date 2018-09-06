"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqRequestSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqRequestSocket comment:''
!


!ZmqRequestSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqReq.
! !

!ZmqRequestSocket methodsFor:'as yet unclassified'!

needsPoller 
	  ^ true
!

socketTypeName
	^'REQ'
! !

!ZmqRequestSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqRequestSocket.st,v 1.1 2018-05-08 19:45:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqRequestSocket.st,v 1.1 2018-05-08 19:45:35 cg Exp $'
! !


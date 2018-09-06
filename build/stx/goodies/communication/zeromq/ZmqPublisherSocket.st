"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqPublisherSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqPublisherSocket comment:''
!


!ZmqPublisherSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqPub.
! !

!ZmqPublisherSocket methodsFor:'as yet unclassified'!

socketTypeName
	^'PUB'
! !

!ZmqPublisherSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPublisherSocket.st,v 1.1 2018-05-08 19:45:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPublisherSocket.st,v 1.1 2018-05-08 19:45:19 cg Exp $'
! !


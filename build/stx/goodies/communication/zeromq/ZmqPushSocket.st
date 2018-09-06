"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqPushSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqPushSocket comment:''
!


!ZmqPushSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqPush.
! !

!ZmqPushSocket methodsFor:'as yet unclassified'!

socketTypeName
	^'PUSH'
! !

!ZmqPushSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPushSocket.st,v 1.1 2018-05-08 19:45:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPushSocket.st,v 1.1 2018-05-08 19:45:44 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqRouterSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqRouterSocket comment:''
!


!ZmqRouterSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqRouter.
! !

!ZmqRouterSocket methodsFor:'as yet unclassified'!

needsPoller 
	  ^ true
!

socketTypeName
	^'ROUTER'
! !

!ZmqRouterSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqRouterSocket.st,v 1.1 2018-05-08 19:44:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqRouterSocket.st,v 1.1 2018-05-08 19:44:50 cg Exp $'
! !


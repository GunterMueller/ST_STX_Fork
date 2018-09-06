"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqPullSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqPullSocket comment:''
!


!ZmqPullSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqPull.
! !

!ZmqPullSocket methodsFor:'as yet unclassified'!

needsPoller
	 ^true
!

socketTypeName
	^'PULL'
! !

!ZmqPullSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPullSocket.st,v 1.1 2018-05-08 19:45:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPullSocket.st,v 1.1 2018-05-08 19:45:15 cg Exp $'
! !


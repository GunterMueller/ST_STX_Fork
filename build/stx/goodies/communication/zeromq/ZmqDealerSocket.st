"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqDealerSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqDealerSocket comment:''
!


!ZmqDealerSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqDealer
! !

!ZmqDealerSocket methodsFor:'as yet unclassified'!

needsPoller 
	  ^ true
!

socketTypeName
	^'DEALER'
! !

!ZmqDealerSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqDealerSocket.st,v 1.1 2018-05-08 19:45:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqDealerSocket.st,v 1.1 2018-05-08 19:45:03 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqResponseSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqResponseSocket comment:''
!


!ZmqResponseSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqRep.
! !

!ZmqResponseSocket methodsFor:'as yet unclassified'!

needsPoller 
	  ^ true
!

socketTypeName
	^'RES'
! !

!ZmqResponseSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqResponseSocket.st,v 1.1 2018-05-08 19:46:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqResponseSocket.st,v 1.1 2018-05-08 19:46:16 cg Exp $'
! !


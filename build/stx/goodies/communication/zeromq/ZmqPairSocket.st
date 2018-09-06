"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqPairSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqPairSocket comment:''
!


!ZmqPairSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqPair.
! !

!ZmqPairSocket methodsFor:'as yet unclassified'!

socketTypeName
	^'PAIR'
! !

!ZmqPairSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPairSocket.st,v 1.1 2018-05-08 19:45:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPairSocket.st,v 1.1 2018-05-08 19:45:31 cg Exp $'
! !


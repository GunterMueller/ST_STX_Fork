"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocketAssociation subclass:#ZmqSocketBind
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqSocketBind comment:''
!


!ZmqSocketBind methodsFor:'as yet unclassified'!

associationTypeName 
	^'bind'
! !

!ZmqSocketBind methodsFor:'operations'!

associateSocket:  aZmqSocket
	aZmqSocket zmqApi bindSocket: aZmqSocket socketPointer to: target.
! !

!ZmqSocketBind class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocketBind.st,v 1.1 2018-05-08 19:45:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSocketBind.st,v 1.1 2018-05-08 19:45:57 cg Exp $'
! !


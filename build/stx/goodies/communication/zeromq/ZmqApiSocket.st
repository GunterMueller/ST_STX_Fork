"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiSocket
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

ZmqApiSocket comment:''
!


!ZmqApiSocket class methodsFor:'field definition'!

fields
	^#()
! !

!ZmqApiSocket methodsFor:'controlling'!

close
	ZmqApi apiZmqClose: self.
! !

!ZmqApiSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiSocket.st,v 1.1 2018-05-08 19:49:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiSocket.st,v 1.1 2018-05-08 19:49:30 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiContext
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

ZmqApiContext comment:''
!


!ZmqApiContext class methodsFor:'field definition'!

fields
	^#()
! !

!ZmqApiContext methodsFor:'controlling'!

terminate
	ZmqApi apiZmqTerm: self.
! !

!ZmqApiContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiContext.st,v 1.1 2018-05-08 19:49:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiContext.st,v 1.1 2018-05-08 19:49:48 cg Exp $'
! !


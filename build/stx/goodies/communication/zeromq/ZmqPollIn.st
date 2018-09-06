"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqEventFilter subclass:#ZmqPollIn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqPollIn comment:''
!


!ZmqPollIn class methodsFor:'as yet unclassified'!

eventMask
	^ZmqApiConstants zmqPollIn.
! !

!ZmqPollIn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPollIn.st,v 1.1 2018-05-08 19:44:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPollIn.st,v 1.1 2018-05-08 19:44:28 cg Exp $'
! !


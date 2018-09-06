"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqEventFilter subclass:#ZmqPollOut
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqPollOut comment:''
!


!ZmqPollOut class methodsFor:'as yet unclassified'!

eventMask
	^ZmqApiConstants zmqPollOut.
! !

!ZmqPollOut class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPollOut.st,v 1.1 2018-05-08 19:45:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqPollOut.st,v 1.1 2018-05-08 19:45:27 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqApiConstants
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

ZmqApiConstants comment:''
!


!ZmqApiConstants class methodsFor:'Socket options'!

zmqDealer
	^5
!

zmqHwm
	^1
!

zmqIdentity
	^5
!

zmqRate
	^8
!

zmqSubscribe
	^6
!

zmqSwap
	^3
!

zmqUnsubscribe
	^7
! !

!ZmqApiConstants class methodsFor:'Socket types'!

zmqPair
	^0
!

zmqPub
	^1
!

zmqPull
	^7
!

zmqPush
	^8
!

zmqRep
	^4
!

zmqReq
	^3
!

zmqRouter
	^6
!

zmqSub
	^2
!

zmqXPub
	^9
!

zmqXSub
	^10
! !

!ZmqApiConstants class methodsFor:'as yet unclassified'!

zmqAffinity
	^4
!

zmqNoBlock 
	^1
!

zmqPollErr
	^4
!

zmqPollIn
	^1
!

zmqPollOut
	^2
!

zmqSendMore
	^2
! !

!ZmqApiConstants class methodsFor:'errno codes'!

errnoEAGAIN
	"Try again"
	^11
!

errnoEINTR
	"Interrupted system call"
	 ^4.
! !

!ZmqApiConstants class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiConstants.st,v 1.1 2018-05-08 19:49:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiConstants.st,v 1.1 2018-05-08 19:49:26 cg Exp $'
! !


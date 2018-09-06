"{ Package: 'stx:goodies/communication/zeromq/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#ZmqBaseTest
	instanceVariableNames:'createdSockets'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Tests'
!

ZmqBaseTest comment:''
!


!ZmqBaseTest methodsFor:'convenience'!

closeSockets
	createdSockets do:[:zmqSocket | zmqSocket close].
!

newPairSocket
	^createdSockets add: ZmqPairSocket new.
!

newPublisherSocket
	^createdSockets add: ZmqPublisherSocket new.
!

newPullSocket
	^createdSockets add: ZmqPullSocket new.
!

newPushSocket
	^createdSockets add: ZmqPushSocket new.
!

newRepSocket
	^createdSockets add: ZmqResponseSocket new.
!

newReqSocket
	^createdSockets add: ZmqRequestSocket new.
!

newSubscriberSocket
	^createdSockets add: ZmqSubscriberSocket new.
! !

!ZmqBaseTest methodsFor:'running'!

setUp
	ZmqContext new.
	createdSockets := OrderedCollection new.
!

tearDown 
	self closeSockets.
	ZmqContext terminate.
! !

!ZmqBaseTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqBaseTest.st,v 1.1 2018-05-08 19:50:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqBaseTest.st,v 1.1 2018-05-08 19:50:53 cg Exp $'
! !


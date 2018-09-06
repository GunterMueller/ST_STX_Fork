"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqSocket subclass:#ZmqSubscriberSocket
	instanceVariableNames:'subscriptions'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqSubscriberSocket comment:''
!


!ZmqSubscriberSocket class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ZmqSubscriberSocket class methodsFor:'as yet unclassified'!

socketType
	^ZmqApiConstants zmqSub.
! !

!ZmqSubscriberSocket methodsFor:'as yet unclassified'!

needsPoller 
	^ true.
!

socketTypeName
	^'SUB'
! !

!ZmqSubscriberSocket methodsFor:'initialization'!

initialize
	super initialize.
	subscriptions := OrderedCollection new.
! !

!ZmqSubscriberSocket methodsFor:'operations'!

subscribe: aByteArray
	self privateSubscribe: aByteArray.		  
	subscriptions add: aByteArray.
!

subscribeAll
	self subscribe: ''.
! !

!ZmqSubscriberSocket methodsFor:'private'!

privateSubscribe: aByteArray
	self context zmqApi setSocketOption: ZmqApiConstants zmqSubscribe forSocket: self socketPointer to: aByteArray.  
! !

!ZmqSubscriberSocket methodsFor:'system startup'!

reinitialize
	super reinitialize.
	subscriptions do:[:subscription| self privateSubscribe: subscription ].
! !

!ZmqSubscriberSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSubscriberSocket.st,v 1.1 2018-05-08 19:45:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqSubscriberSocket.st,v 1.1 2018-05-08 19:45:53 cg Exp $'
! !


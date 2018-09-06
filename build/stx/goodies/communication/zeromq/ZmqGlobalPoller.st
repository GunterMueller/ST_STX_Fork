"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ZmqResource subclass:#ZmqGlobalPoller
	instanceVariableNames:'pollerProcess poller'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ'
!

ZmqGlobalPoller comment:''
!


!ZmqGlobalPoller class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ZmqGlobalPoller methodsFor:'as yet unclassified'!

context
	^ ZmqContext current.
!

ensurePollerRuns
	pollerProcess ifNil: [ self startPolling ]
!

giveOtherThreadsTimeToRun
	^ (Delay forMilliseconds: 1) wait
!

poll
	^ self poller pollEventsAndSocketsDo: [ :events :socket | events ifReadEvent: [ socket dataAvailable ] ]
!

pollInSocket: aZmqSocket
	poller pollSocket: aZmqSocket forEvents: ZmqPollIn.
	self ensurePollerRuns.
!

poller
	^ poller ifNil:[poller := ZmqPoller new].
!

removeSocket: aZmqSocket
	poller removeSocket: aZmqSocket
!

socketsCount
	^ self poller size.
!

startPolling
	pollerProcess ifNotNil: [ Error signal: 'Poller already started!!' ].
	pollerProcess := [ 
	[ 
	[ 
	self poll > 0
		ifFalse: [ self giveOtherThreadsTimeToRun ].
	self socketsCount > 0 ] whileTrue ]
		ensure: [ pollerProcess := nil ] ] forkAt: Processor highIOPriority.
	pollerProcess name: 'Zmq Poller'
!

stopPolling
	pollerProcess ifNotNil: [ pollerProcess terminate ]
!

zmqApi
	^ self context zmqApi.
! !

!ZmqGlobalPoller methodsFor:'initialization'!

initialize 
	super initialize.
	poller := ZmqPoller new.
! !

!ZmqGlobalPoller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqGlobalPoller.st,v 1.1 2018-05-08 19:45:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqGlobalPoller.st,v 1.1 2018-05-08 19:45:10 cg Exp $'
! !


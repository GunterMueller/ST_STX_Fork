"{ Package: 'stx:goodies/communication/zeromq/tests' }"

"{ NameSpace: Smalltalk }"

ZmqBaseTest subclass:#ZmqPollerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Tests'
!

ZmqPollerTest comment:''
!


!ZmqPollerTest methodsFor:'as yet unclassified'!

testPollerEvents
	| poller socket1 socket2 |
	poller := ZmqPoller new.
	socket1 := self newReqSocket.
	socket2 := self newRepSocket.
	socket1 bind: 'inproc://#1'.
	socket2 connect: 'inproc://#1'.
	poller pollSocket: socket1 forEvents: ZmqPollIn , ZmqPollOut.
	poller pollSocket: socket2 forEvents: ZmqPollIn , ZmqPollOut.
	poller
		pollFor: 1 milliSeconds
		withEventsAndSocketsDo: [ :events :socket | 
			self assert: socket equals: socket1.
			self assert: events isPollOut.
			socket send: 'message' asByteArray ].
	poller
		pollFor: 1 milliSeconds
		withEventsAndSocketsDo: [ :events :socket | 
			self assert: socket equals: socket2.
			self assert: events isPollIn ]
!

testPollerWhenInEvent
	| poller req rep |
	poller := ZmqPoller new.
	rep := self newRepSocket.
	req := self newReqSocket.
	rep bind: 'inproc://#1'.	
	req connect: 'inproc://#1'.
	req send: 'request' asByteArray.
	poller pollSocket: rep forEvents: ZmqPollIn.
	self assert: (poller pollFor: 1 milliSeconds) equals: 1.
	
!

testPollerWhenNoEvents
	| poller req |
	poller := ZmqPoller new.
	req := self newReqSocket.
	poller pollSocket: req forEvents: ZmqPollIn.
	self assert: (poller pollFor: 1 milliSeconds) equals: 0.
	
!

testPollerWhenOutEvent
	| poller req rep |
	poller := ZmqPoller new.
	rep := self newRepSocket.
	req := self newReqSocket.
	rep bind: 'inproc://#1'.	
	req connect: 'inproc://#1'.
	poller pollSocket: req forEvents: ZmqPollOut.
	self assert: (poller pollFor: 1 milliSeconds) equals: 1.
	
!

testSocketIndexIsReturned
	| poller socket1 socket2 socket3 index1 index2 index3|
	poller := ZmqPoller new.
	socket1 := self newRepSocket.
	socket2 := self newReqSocket.
	socket3 := self newPullSocket.
	index1 := poller pollSocket: socket1 forEvents: ZmqPollIn.
	index2 := poller pollSocket: socket2 forEvents: ZmqPollIn.
	index3 := poller pollSocket: socket3 forEvents: ZmqPollIn.
	self assert: index1 equals: 1.
	self assert: index2 equals: 2.
	self assert: index3 equals: 3.
	
!

testSocketIsReturnedUsingIndex
	| poller socket1 socket2 socket3 index1 index2 index3|
	poller := ZmqPoller new.
	socket1 := self newRepSocket.
	socket2 := self newReqSocket.
	socket3 := self newPullSocket.
	index1 := poller pollSocket: socket1 forEvents: ZmqPollIn.
	index2 := poller pollSocket: socket2 forEvents: ZmqPollIn.
	index3 := poller pollSocket: socket3 forEvents: ZmqPollIn.
	self assert: (poller socketAt: index1) equals: socket1.
	self assert: (poller socketAt: index2) equals: socket2.
	self assert: (poller socketAt: index3) equals: socket3.
	
	
! !

!ZmqPollerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqPollerTest.st,v 1.1 2018-05-08 19:51:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqPollerTest.st,v 1.1 2018-05-08 19:51:24 cg Exp $'
! !


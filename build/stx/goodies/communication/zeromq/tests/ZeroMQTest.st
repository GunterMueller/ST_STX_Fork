"{ Package: 'stx:goodies/communication/zeromq/tests' }"

"{ NameSpace: Smalltalk }"

ZmqBaseTest subclass:#ZeroMQTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Tests'
!

ZeroMQTest comment:''
!


!ZeroMQTest methodsFor:'tests'!

testPairInproc
	|pair1 pair2 result|
	pair1 := self newPairSocket bind: 'inproc://#1'.
	pair2 := self newPairSocket connect: 'inproc://#1'.
	pair1 send: 'OK' asByteArray.
	result := pair2 receive.

	self assert: result asString = 'OK'.
	
	
!

testPublisherInproc
	| publisher subscriber1 subscriber2 fromSub1 fromSub2 message1 |
	publisher := self newPublisherSocket bind: 'inproc://#1'.
	subscriber1 := self newSubscriberSocket connect: 'inproc://#1'.
	subscriber2 := self newSubscriberSocket connect: 'inproc://#1'.
	subscriber1 subscribeAll.
	subscriber2 subscribeAll.	
	message1 := 'Message1' asByteArray.
	publisher send: message1.
	fromSub1 := subscriber1 receive.
	fromSub2 := subscriber2 receive.	

	self assert: fromSub1 equals: message1.
	self assert: fromSub2 equals: message1.
!

testPullAndPushInproc
	| push pull1 pull2 message1 message2 fromPull1 fromPull2 |
	push := self newPushSocket bind: 'inproc://asdasd'.
	pull1 := self newPullSocket connect: 'inproc://asdasd'.
	pull2 := self newPullSocket connect: 'inproc://asdasd'.
	message1 := 'Message1' asByteArray.
	message2 := 'Message2' asByteArray.	
	push send: message1.
	push send: message2.	
	fromPull1 := pull1 receive.
	fromPull2 := pull2 receive.	

	self assert: fromPull1 equals: message1.
	self assert: fromPull2 equals: message2.
!

testPullWithResultDo
	| push pull resultReceived message1 |
	resultReceived := false.
	push := self newPushSocket  bind: 'inproc://pullwithresults'.
	pull := self newPullSocket connect: 'inproc://pullwithresults'.
	pull withResultDo: [ resultReceived := true ].
	message1 := 'Message1' asByteArray.
	push send: message1.
	Transcript show: 'asd'.
	self should: [
		[(Delay forMilliseconds: 1) wait.  resultReceived] whileFalse.
		] notTakeMoreThanMilliseconds: 50.
!

testReqRepWithResultDo
	| resultReceived req rep s |
	resultReceived := false.
	s := 'inproc://1234'.
	req := self newReqSocket bind: s.
	rep := self newRepSocket connect: s.
	req
		withResultDo: [ 
			resultReceived := true.
			].
	rep
		withResultDo: [ :r | 
			Transcript show: 'got stuff'.
			rep send: r asByteArray ].
	req send: 'viesti' asByteArray.
	self should: [
		[(Delay forMilliseconds: 1) wait.  resultReceived] whileFalse.
		] notTakeMoreThanMilliseconds: 50.
	self should: resultReceived
!

testVersion
	self assert: ZmqApi zmqVersion notNil description: 'Could not get version'.
	self assert: ZmqApi zmqVersion >= (ZmqVersion major: 2 minor: 1 patch: 7) description: 'This is developed for 2.1.7 version or higher'.
! !

!ZeroMQTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZeroMQTest.st,v 1.1 2018-05-08 19:51:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZeroMQTest.st,v 1.1 2018-05-08 19:51:05 cg Exp $'
! !


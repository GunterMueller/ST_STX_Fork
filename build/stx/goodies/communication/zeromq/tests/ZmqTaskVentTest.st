"{ Package: 'stx:goodies/communication/zeromq/tests' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqTaskVentTest
	instanceVariableNames:'workers createdSockets'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Tests'
!


!ZmqTaskVentTest methodsFor:'as yet unclassified'!

numberOfWorkers
	^50
! !

!ZmqTaskVentTest methodsFor:'convenience'!

closeSockets
	createdSockets do:[:zmqSocket | zmqSocket close].
! !

!ZmqTaskVentTest methodsFor:'initialization'!

setUp
	ZmqContext new.
	createdSockets := OrderedCollection new.
!

startWorkers
	workers := OrderedCollection new.
	1 to: self numberOfWorkers do:[:w|
		workers add: self newWorker.
	]	
! !

!ZmqTaskVentTest methodsFor:'instance creation'!

newPullSocket
	^createdSockets add: ZmqPullSocket new.
!

newPushSocket
	^createdSockets add: ZmqPushSocket new.
!

newWorker
	
	^ [|receiver sender data run|
		run := true.
		receiver := self newPullSocket.
		receiver connect: 'tcp://localhost:5557'.
		sender := self newPushSocket.
		sender connect: 'tcp://localhost:5558'.
		[run] whileTrue:[
			data := receiver receive.
			data isEmpty 
						ifTrue:[
							Processor yield]
						ifFalse:[
							Transcript show:('Rec:',data asString);cr.
							sender send: data asByteArray.
							Transcript show:('Waiting for:',data asString);cr.
							Processor yield.
							(Delay forMilliseconds: (Integer readFrom: data asString) ) wait]]
						
	 ] fork
	
! !

!ZmqTaskVentTest methodsFor:'running'!

tearDown 

	workers do:[:w| w terminate].
	workers :=OrderedCollection new.
	self closeSockets.
	"ZmqContext terminate."
! !

!ZmqTaskVentTest methodsFor:'tests'!

testTaskVent
	| sender sink gen totalMilliseconds workLoad |
	self setUp.
	sender := self newPushSocket.
	sender bind:'tcp://*:5557'.
	sink :=  self newPushSocket.
	sink connect: 'tcp://localhost:5558'.
	sink send:'0'asByteArray.
	gen := Random seed: 2000.
	totalMilliseconds := 0.
	workLoad := 0.
	self startWorkers.
	(Delay forMilliseconds: 3000) wait.
	0 to:self numberOfWorkers do:[:each|
		workLoad :=	(gen nextInt:100) + 1.
		totalMilliseconds := totalMilliseconds + workLoad.
		Transcript show:( totalMilliseconds asString); cr.
		sender send:workLoad asString asByteArray].
! !

!ZmqTaskVentTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqTaskVentTest.st,v 1.1 2018-05-11 00:06:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/tests/ZmqTaskVentTest.st,v 1.1 2018-05-11 00:06:52 cg Exp $'
! !


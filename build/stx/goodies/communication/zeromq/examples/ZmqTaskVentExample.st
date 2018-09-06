"{ Package: 'stx:goodies/communication/zeromq/examples' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ZmqTaskVentExample
	instanceVariableNames:'workers'
	classVariableNames:''
	poolDictionaries:''
	category:'ZeroMQ-Examples'
!


!ZmqTaskVentExample methodsFor:'as yet unclassified'!

numberOfWorkers
	^50
! !

!ZmqTaskVentExample methodsFor:'initialization'!

setUp
	super setUp.
	workers := OrderedCollection new.
	1 to: self numberOfWorkers do:[:w|
		workers add: self newWorker.
	]	
!

tearDown 

	workers do:[:w| w terminate].
	self closeSockets.
	"ZmqContext terminate."
! !

!ZmqTaskVentExample methodsFor:'instance creation'!

newWorker
	
	^ [|receiver sender data|
		receiver := self newPullSocket.
		receiver connect: 'tcp://localhost:5557'.
		sender := self newPushSocket.
		sender connect: 'tcp://localhost:5557'.
		[true] whileTrue:[
			data := receiver receive.
			sender send: data.
			Transcript show:('Waiting for:',data asString);crlf.
			Processor yield.
			(Delay forMilliseconds: (Integer newFrom: data) ) wait ]
	 ] fork
	
! !

!ZmqTaskVentExample methodsFor:'tests'!

taskVent
	| sender sink gen totalMilliseconds workLoad |
	sender := self newPushSocket.
	sender bind:'tcp://*:5557'.
	sink :=  self newPushSocket.
	sink connect: 'tcp://localhost:5558'.
	sink send:'0'asByteArray.
	gen := Random seed: 2000.
	totalMilliseconds := 0.
	workLoad := 0.
	0 to:self numberOfWorkers do:[:each|
		workLoad :=	(gen nextInt:100) + 1.
		totalMilliseconds := totalMilliseconds + workLoad.
		Transcript show:( totalMilliseconds asString); cr.
		sink send:workLoad asString asByteArray]
	
!

testTaskVent
	| sender sink gen totalMilliseconds workLoad |
	sender := self newPushSocket.
	sender bind:'tcp://*:5557'.
	sink :=  self newPushSocket.
	sink connect: 'tcp://localhost:5558'.
	sink send:'0'asByteArray.
	gen := Random seed: 2000.
	totalMilliseconds := 0.
	workLoad := 0.
	0 to:self numberOfWorkers do:[:each|
		workLoad :=	(gen nextInt:100) + 1.
		totalMilliseconds := totalMilliseconds + workLoad.
		Transcript show:( totalMilliseconds asString); crlf.
		sink send:workLoad asString asByteArray]
	
! !

!ZmqTaskVentExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/examples/ZmqTaskVentExample.st,v 1.1 2018-05-10 23:45:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/examples/ZmqTaskVentExample.st,v 1.1 2018-05-10 23:45:56 cg Exp $'
! !


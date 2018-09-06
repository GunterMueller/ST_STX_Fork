"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#SessionAgent
	instanceVariableNames:'portalKey portalMap connectionQueue process'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk'
!

SessionAgent comment:'Smalltalk listLoadedModulesSmalltalk listBuiltinModules| vat |SecureSessionTerminal allInstances do: [:e | e shutdown].SecureSessionServer allInstances do: [:e | e stop].ConnectionHandler allInstances do: [:e | e stop].Socket allInstances do: [:e | e closeAndDestroy].vat := SecureSessionServer newOnVatIdentity: SecureSessionRSAIdentity sampleVatId2.vat when: #connectionRunning evaluate: [ :conn | 	Transcript cr; show: (''Connection running''); cr.	conn when: #dataReceived evaluate: [ :data | 		Transcript cr; show: (''Message received: '', data asString); cr].	conn when: #connectionClosed evaluate: [ :connA | 		Transcript cr; show: (''Connection closed, told by terminal''); cr].	Transcript cr; show: (''sending message: hello world from Squeak''); cr.	conn sendBytes: ''hello world from Squeak'' asByteArray].vat when: #connectionClosed evaluate: [ :conn | 	Transcript cr; show: (''Connection closed, told by server''); cr].vat traceMonitor enableDomain: #StackTraffic.vat traceMonitor enableDomain: #ProtocolMsgs.vat traceMonitor enableDomain: #Secrets.vat| keys conn |keys := SecureSessionRSAIdentity generateKeySet.conn := self connectToVatIdentity: (SecureSessionRSAIdentity 	newOnHostPortString: ''192.168.2.4:10011'' 	vatId: ''YqvtMoziv6OVpVvf9bmM1SSQ8Sk='').conn when: #connectionRunning evaluate: [ :localConn | 	Transcript cr; show: (''Connection running''); cr.	localConn when: #dataReceived evaluate: [ :data | 		Transcript cr; show: (''Message received: '', data asString); cr].	localConn when: #connectionClosed evaluate: [ :connA | 		Transcript cr; show: (''Connection closed, told by terminal''); cr].	Transcript cr; show: (''sending message: hello world from Squeak''); cr.	conn sendBytes: ''hello world from Squeak'' asByteArray].conn'
!


!SessionAgent class methodsFor:'instance creation'!

newOnKey: key map: map

	Socket initializeNetwork.
	^ self new 
		initializeOnKey: key map: map;
		yourself
! !

!SessionAgent class methodsFor:'class initialization'!

initialize

	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self.
	self startUp: false.
!

shutDown: quitting
!

startUp: quitting

	InetSocketAddress initialize.
	SessionIdentity initialize.
	PhaseHeader initialize.

! !

!SessionAgent methodsFor:'accessing'!

localIdentity

	^self portalKey
!

portalKey

	^ portalKey
!

portalMap

	^ portalMap
!

vatId

	^self portalKey vatId
! !

!SessionAgent methodsFor:'connect'!

connectToKey: farKey

	| conn |
	conn := Session
		connectToFarKey: farKey 
		portal: self.
	self registerConnection: conn.
	conn call.
	^ conn
!

deregisterConnection: conn

	conn releaseActionMap.

!

newInboundSocket: socket

	| conn bone farKey |
	farKey := SessionIdentity
		newOnAddress: socket remoteAddress 
		port: socket remotePort.
	bone := SocketThunk newSocket: socket.
	conn := Session
		onSource: bone 
		farKey: farKey 
		portal: self.
	self registerConnection: conn.
	conn answer.
!

registerConnection: conn

	conn when: #connectionClosed send: #deregisterConnection: to: self with: conn.

! !

!SessionAgent methodsFor:'connection callbacks'!

connectionRunning: conn

	self triggerEvent: #connectionRunning with: conn.
! !

!SessionAgent methodsFor:'initialize-release'!

doAwaitInbound

	| socket |
	[
		socket := connectionQueue getConnectionOrNilLenient.
		socket 
			ifNil: [(Delay forMilliseconds: 50) wait]
			ifNotNil: [self newInboundSocket: socket]
	] repeat
!

finalize

	self stop.
!

initializeOnKey: aKey map: aMap

	portalKey := aKey.
	portalMap := aMap. 
	self start.
!

printOn: stream

	super printOn: stream.
	stream nextPut: $(.
	connectionQueue notNil
		ifTrue: [stream nextPutAll: '<running>']
		ifFalse: [stream nextPutAll: '<stopped>'].
	stream nextPut: $).
	stream nextPutAll: ' : '.
	stream nextPutAll: self vatId.
	
!

start

	self startServices.
!

startServices

	"start this broker"
	
	Socket initializeNetwork.
	connectionQueue notNil ifTrue: [^self].
	connectionQueue := ConnectionQueue portNumber: self portalKey port queueLength: 8.
	process := [self doAwaitInbound] newProcess.
	process priority: Processor highIOPriority.
	process resume.
	self triggerEvent: #PortalOpened.
	(Delay forMilliseconds: 30) wait.
!

stop

	self stopServices.
!

stopServices

	process ifNotNil: [process terminate. process := nil].
	connectionQueue ifNotNil: [connectionQueue destroy. connectionQueue := nil].
	portalMap release.
	self triggerEvent: #PortalClosed.
	self releaseActionMap.
! !

!SessionAgent methodsFor:'querying'!

isPortalOpen

	^ connectionQueue notNil
! !

!SessionAgent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionAgent.st,v 1.1 2018-05-14 00:17:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__SessionAgent.st,v 1.1 2018-05-14 00:17:26 cg Exp $'
! !


SessionAgent initialize!

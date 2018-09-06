"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

SSDPParticipant subclass:#SSDPClient
	instanceVariableNames:'availableHandler unavailableHandler serviceType receiveWindow
		cache listenerProcesses cachePruningProcess'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Client'
!

SSDPClient comment:''
!

!SSDPClient class methodsFor:'documentation'!

documentation
"
  An SSDPClient listens to changes in available resources that provide services,
  using the SSDP protocol.

  An SSDP client can be used to send a single type of message;
  used to discover available resources when first starting up,
  or getting an up to date list of the available resources,
  if resources it cares about, has exceeded the max cache period,
  without receiving a notification that service is still avaiable.
  There are three SSDP events that need handling;
  - Service discovered.
  - Service available/changed.
  - Service about to be unavailable.

  As a Service's USN will always identify it uniquely,
  we hold a cache of the current status of Services (if the events can be cached),
  and, if an event signifies an addition or removal, pass this info on.

  Thus, a user must initialize me with the service type it is interested in and two callbacks.
  Sample usage:

  |client|
  client := SSDPClient v4SiteLocal.
  client
	filter: 'ssdp:all'
	whenAvailable: [ :resource |
		resource printOn: Transcript.
		'is available' printOn: Transcript.
		Transcript nextPut: Character cr. ]
	whenUnavailable: [ :resource |
		resource printOn: Transcript.
		'is becoming unavailable' printOn: Transcript.
		Transcript nextPut: Character cr.  ].

  Care must be taken when disposing existing entities of SSDPClient in order
  to play nice with the garbage collector,
  since an SSDPClient creates everlasting processes that reference it.

  If no different handlers are required, an the intent is to refresh the sockets
  instance listens on, a user should call shutDown;startUp on an existing instance
  rather than replacing it.

  If a replacement with different handlers is required,
  the user MUST call shutDown on the old server before replacement happens.
  A user is also responsible for ensuring shutDown/startUp methods are called
  at image startup/shutdown, so processes are terminated correctly,
  and no lingering sockets will exist.
"
! !

!SSDPClient class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SSDPClient methodsFor:'accessing'!

receiveWindow: aDuration
	receiveWindow := aDuration
! !

!SSDPClient methodsFor:'debugging'!

inspectMissing: aDatagram
	"If missing messages, uncomment halt here to see if we parse it correctly"
	"self halt"
! !

!SSDPClient methodsFor:'initialize - release'!

initialize
	"By default, receive all responses in less than a second. Increasing this will spread out processing of responses, as each service will delay for (0 to: receiveWindow) atRandom before responding"
	super initialize.

	receiveWindow := 3 seconds.

!

shutDown
	listenerProcesses
		ifNotNil: [ listenerProcesses do: #terminate.
			cachePruningProcess terminate ].
	"Notify clients that the services will no longer be available"
	[cache isNil or: [cache isEmpty]] whileFalse:[
		unavailableHandler value:(cache removeService:cache first) ]
!

startUp
	|discoveryProcesses|
	super startUp.

	cache := SSDPCache for: serviceType.
	discoveryProcesses := sendingSockets collect: [:discoverySocket |
			self
			discoveryProcessFor: serviceType
			on: discoverySocket
			available: availableHandler].
	listenerProcesses := listeningSockets
		collect:
			[ :aSocket |
			self
				listenerProcessFor: serviceType
				on: aSocket
				available: availableHandler
				unavailable: unavailableHandler  ].
	cachePruningProcess := self cacheExpulsionProcess: unavailableHandler.
	discoveryProcesses do: #resume.
	listenerProcesses do: #resume.
	cachePruningProcess resume
! !

!SSDPClient methodsFor:'private - discovery'!

discover: aServiceType available: aHandler
	"Send an explicit message indicating that services implementing aType should notify me they are available"
		"This is the only process of the client that sends data over the multicast address"

	| buffer |
	buffer := ByteString new: 1024.
	sendingSockets
		do:
			[ : discoverySocket | | latestArrivalTime|
			[discoverySocket
				sendUDPData:
					(self
						discoveryRequest: aServiceType
						receivingAnswersIn: receiveWindow)
				toHost: multicastInfo host
				port: multicastInfo port] on: PrimitiveFailed do: ["Socket will be invalid when interface disappears, or after waking up from sleep mode and failing to send (due to multicast socket opts not being preserver, I think). This means listening socket is also not receiving notifications properly, so the best we can do, afte deferring handling to user defined block, is to restart client automatically, recreating valid sockets and repopulating available services."
					[ self shutDown.
					socketFailHandler
						ifNotNil: [socketFailHandler cull: self cull: serviceType cull: discoverySocket]
						ifNil: [ self startUp ]] forkAt: Processor activeProcess priority - 1].

			latestArrivalTime := (DateAndTime now
				+ (receiveWindow * 2)).

			[ |  timedOut|
			timedOut := false.
			discoverySocket
				waitForDataForMsecs: (latestArrivalTime - DateAndTime now) asMilliSeconds
				ifClosed: nil "Never gonna happen, UDP baby"
				ifTimedOut: [timedOut := true ].
				timedOut] whileFalse: [
			|datagram service|
			datagram :=  self
				readDatagramFrom: discoverySocket
				using: buffer.
			(service:=((SSDPDiscoveryReply fromDatagram: datagram) serviceChangeIn: cache))
				ifNotNil: [ aHandler value: service ] ] ]
!

discover: aServiceType on: discoverySocket available: aHandler
        "Send an explicit message indicating that services implementing aType should notify me they are available"
                "This is the only process of the client that sends data over the multicast address"

        | buffer latestArrivalTime|
        buffer := ByteString new: 1024.
        discoverySocket
                sendUDPData:
                        (self
                                discoveryRequest: aServiceType
                                receivingAnswersIn: receiveWindow)
                toHost: multicastInfo host
                port: multicastInfo port.

        latestArrivalTime := (DateAndTime now
                + (receiveWindow * 2)).

        [ |  timedOut|
                timedOut := false.
                discoverySocket
                        waitForDataForMsecs: (latestArrivalTime - DateAndTime now) asMilliSeconds
                        ifClosed: nil "Never gonna happen, UDP baby"
                        ifTimedOut: [timedOut := true ].
                timedOut] whileFalse: [         |datagram service|
                        datagram :=  self
                                readDatagramFrom: discoverySocket
                                using: buffer.
                        Transcript showCR:datagram.        
                        (service:=((SSDPDiscoveryReply fromDatagram: datagram) serviceChangeIn: cache))
                                ifNotNil: [aHandler value: service ] 
                ]
! !

!SSDPClient methodsFor:'private - requests'!

discoveryRequest: searchTarget receivingAnswersIn: receiveWindowSeconds
	"Nothing but headers, and a blank line"

	"TODO: Rewrite to use multicastInfo for host"
	^('M-SEARCH * HTTP/1.1
HOST: 239.255.255.250:1900
MAN: "ssdp:discover"
MX:', receiveWindowSeconds asSeconds asString, '
ST:', searchTarget, '

') withInternetLineEndings
! !

!SSDPClient methodsFor:'processes'!

cacheExpulsionProcess: byebyeHandler
	^ [
	| service  expiredService|
	[[
	(service := cache first) validDuration.
	service validDuration > 3 seconds ] whileTrue: [ (service validDuration - 1 second) wait ].     "See if we are able to re-discover the service"
	self discover: service serviceType available: [ :aService |  ].
	service validDuration < 3 seconds
		ifTrue: [
			"if not found in cache, ignore "
			(expiredService := cache removeService: service)
				ifNotNil: [byebyeHandler value: expiredService ] ] ] repeat ]
		newProcess name: 'SSDP<client:' , cache serviceType , '> Cache pruning '
!

discoveryProcessFor: aServiceType on: aSocket available: aHandler
	"Use a separate process running discovery; don't wait for receiveWindow to expire before starting listening to Availability updates.
	Will terminate some time after receiveWindow expires"

	^ [ self discover: aServiceType on: aSocket available: aHandler ] newProcess
		name: 'SSDP<client:' , aServiceType , '> discovery process on ', aSocket localAddress
!

listenerProcessFor: aSearchTarget on: aSocket available: whenAvailable unavailable: whenByeBye
    ^ [ | buffer |

        buffer := String new: 1024.
        [ | datagram  notification service|
        aSocket waitForDataIfClosed: [].

        datagram := self readDatagramFrom: aSocket using: buffer.
Transcript showCR:datagram.
        (notification := SSDPMessage from: datagram)
                ifNil: [
                        self inspectMissing: datagram ]
                ifNotNil: [
                (service := notification serviceChangeIn: cache)
                        ifNotNil:
                        [
                        notification deliver: service
                                ifAvailable: whenAvailable
                                ifUnavailable: whenByeBye ]]
                                 ] repeat
    ] newProcess
        name: 'SSDP<client:', aSearchTarget, '> change listener';
        priority: Processor userBackgroundPriority;
        yourself
! !

!SSDPClient methodsFor:'starting'!

filter: aSearchTarget whenAvailable: aHandler whenUnavailable: anotherHandler
	^ self
		filter: aSearchTarget
		whenAvailable: aHandler
		whenUnavailable: anotherHandler
		onSocketFail: nil
!

filter: aSearchTarget whenAvailable: aHandler whenUnavailable: anotherHandler onSocketFail: aSocketFailHandler
	self shutDown.
	serviceType := aSearchTarget.
	availableHandler := aHandler.
	unavailableHandler := anotherHandler.
	socketFailHandler := aSocketFailHandler.
	self startUp.
!

onAllInterfacesFilter: aSearchTarget whenAvailable: aHandler whenUnavailable: anotherHandler onSocketFail: aSocketFailHandler
	self shutDown.
	serviceType := aSearchTarget.
	availableHandler := aHandler.
	unavailableHandler := anotherHandler.
	socketFailHandler := aSocketFailHandler.
	self startUpOnAll.
! !

!SSDPClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPClient.st,v 1.5 2018-05-14 20:41:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPClient.st,v 1.5 2018-05-14 20:41:34 cg Exp $'
! !


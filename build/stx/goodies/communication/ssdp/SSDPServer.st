"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

SSDPParticipant subclass:#SSDPServer
	instanceVariableNames:'service delayGenerator discoveryProcesses keepAliveProcesses
		replySockets'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Server'
!

SSDPServer comment:''
!

!SSDPServer class methodsFor:'documentation'!

documentaion
"
    An SSDPServer know how to announce to clients that there is a service available.
    It implements the server-part of SSDP, specifically:
    - Responding to M-SEARCH requests to the SSDP multicast address
    - Sending ssdp:alive messages to refresh cache-expiry in clients.
    - Sending ssdp:byebye messages to explicitly tell clients the service is no longer available

    These messages are sent three times at first use.
    While it may seem strange to send three in a row without any kind of delay, it helps on wireless
    networks, where packet loss is much more transient than one would otherwise expect.

    At the moment, for simplicity, there''s a 1-1 mapping between server and services; if more should be available, use multiple servers.

    Sample usage:

    |server|
    server := SSDPServer v4SiteLocal.
    server
            offerServiceType: ''ssdp:testService''
            atLocation: ''http:/test.local/''.
    server shutDown.

    Care must be taken when disposing existing entities of SSDPServer in order to play nice with the garbage collector,  
    since an SSDPServer creates everlasting processes that reference it.
    If no different handlers are required, and the intent is to refresh the sockets instance listens on, 
    a user should call shutDown;startUp on an existing instance rather than replacing it.
    If a replacement with different handlers is required, the user MUST call shutDown on the old server before replacement happens.
    A user is also responsible for ensuring shutDown/startUp methods are called at image startup/shutdown, so processes are terminated correctly, and no lingering sockets will exist.
"
! !

!SSDPServer methodsFor:'accessing'!

service
	^service
!

versionInfo
        "Only pretend we support SSDP draft spec.
        uPnP 1.1 has additional requirements, like BOOTID.UPNP.ORG fields in keep-alive messages"

        "return something like: 'MacOS/1011.3 ssdp/0.9 Pharo/6.0'"

        Smalltalk isSmalltalkX ifTrue:[
            ^ ('%1/%2 ssdp/0.9 SmalltalkX %3.%4'
                    bindWith:OperatingSystem platformName
                    with:1
                    with:Smalltalk majorVersionNr 
                    with:Smalltalk minorVersionNr)
        ] ifFalse:[
            | os systemVersion |

            os := Smalltalk os.
            systemVersion := SystemVersion current.
            ^ (os platformName reject: [:e | e = Character space]) , '/' , os version ,
            ' ssdp/0.9 ' ,
            systemVersion type , '/' , systemVersion dottedMajorMinor
        ].
! !

!SSDPServer methodsFor:'initialize - release'!

initialize
	super   initialize.
	delayGenerator := Random new.
!

initializeSocketsForInterface: localInterface
	"Setup sockets that can listen and send data to the multicast address on the subnet of localInterface"

	^ (super initializeSocketsForInterface: localInterface)
		and:
			[ | replySocket |
			replySocket := Socket newUDP.
			replySocket bindTo: localInterface port: 0.
			replySockets add: replySocket.
			 true ]
!

initializeSocketsOn: localInterfaces
	"A server needs sockets not bound to the multicast address when replying to discovery requests"
	replySockets := OrderedCollection new.
	^super initializeSocketsOn: localInterfaces
!

shutDown
	service ifNotNil: [
		discoveryProcesses do: #terminate.
		keepAliveProcesses do: #terminate.]
!

startUp
	super startUp.
	self startUpSecondaryProcesses
!

startUpOnAll
	super startUpOnAll.
	self startUpSecondaryProcesses
!

startUpSecondaryProcesses
	discoveryProcesses := listeningSockets
		collect:
			[ :discoverySocket | self discoveryListeningProcessOn: discoverySocket ].
	keepAliveProcesses := sendingSockets
		collect:
			[ :keepAliveSocket | self aliveAnnouncingProcessOn: keepAliveSocket ].
	discoveryProcesses do: #resume.
	keepAliveProcesses do: #resume
! !

!SSDPServer methodsFor:'private - available'!

aliveAnnouncingProcessOn: aSendingSocket
        "Keep telling the client our service is available until we are not, and the thread is terminated."
        "First time through, send packet three times, so there's less chance of missing it due to single dropped packet"

        ^ [ [ [|announceAlive|
                        announceAlive :=
                                [ aSendingSocket
                sendUDPData: (service aliveResponseFor: multicastInfo)
                toHost: multicastInfo host
                port: multicastInfo port.
        "Give clients three opportunities to catch the announcement in the period before we are evicted from caches"
        ].
        2 timesRepeat: announceAlive.
        [announceAlive value. (service maxAge // 4) wait  ] repeat ]
                on: (PrimitiveFailed,WriteError)
                do: ["If we failed, it probably means my interface is no longer valid.
                        Run shutdown of server, which will signal byebye on still running interfaces by ensure: block.
                        Primitive fail from that is handled below"
                                 self shutDown ] ]
                ensure:
                        [[  "All good things are three.
                                Prefer some duplicated traffic over having to wait for cache timeout when a single packet fails delivery.)"
                                3 timesRepeat: [aSendingSocket
                                sendUDPData: (service byebyeResponseFor: multicastInfo)
                                toHost: multicastInfo host
                                port: multicastInfo port ]]
                                on: (PrimitiveFailed,WriteError)
                                do:
                                        [
                                        ["Termination triggered on this socket due to unavailability.
                                        Let the user handle this, if not, do a restart (which will scan and start on currently available interfaces)"
                                        socketFailHandler
                                                ifNotNil: [socketFailHandler cull: self cull: service cull: aSendingSocket]
                                                ifNil: [ self offerService: service ]] forkAt: Processor activeProcess priority - 1 ]   ] ]
                         newProcess name: 'SSDP<server:', service serviceType,'> keepalive process'
! !

!SSDPServer methodsFor:'private - discovery'!

discoveryListeningProcessOn: aListeningSocket
	^ [ | buffer senderAndDatagram request|
	buffer := ByteArray new: 1024.
	[ aListeningSocket waitForDataIfClosed: [  ] .
	senderAndDatagram := self
		readSenderAndDatagramFrom: aListeningSocket
		using: buffer.
	(request := self discoveryRequestFrom: senderAndDatagram value)
		ifNotNil:
			[
			| replySocket |
			"Reply using the socket bound to same interface as we are listening on"
			replySocket := replySockets
				at: (listeningSockets indexOf: aListeningSocket).
			self
				replyToDiscoveryRequest: request
				from: senderAndDatagram key
				on: replySocket ] ] repeat ] newProcess
		name: 'SSDP<server:' , service serviceType , '> discovery listener'
!

discoveryRequestFrom: aDatagram
	|request|
	^ (request := SSDPDiscoveryRequest
		fromDatagram: aDatagram)
		ifNotNil: [
				(service matchesType: request)
				ifTrue: [ request ] ]
!

handleDiscoveryRequest: request receivedOn: aSocket
	| destAddress destPort |
	"We fork off delivery, so we need to remember where we can send reply to client"
	destAddress := aSocket remoteAddress.
	destPort := aSocket remotePort.

	[ "We send our response at some random time before the discovery interval elapses, so client isn't flooded with replies from multiple servers at the same time"
		(request timeout * delayGenerator next ) wait.
	"Send the packet 3 times, to be more reliable on wireless. If it still fails, client will still
	see us, as soon as it manages to receive the first alive notification"
	3 timesRepeat: [aSocket
		sendUDPData: service discoveryResponse
		toHost: destAddress
		port: destPort ]] forkAt: Processor activeProcess priority + 1
!

replyToDiscoveryRequest: request from: aSender on: aReplySocket

	"We should send our response at some random time before the discovery interval elapses"
	[
		(request timeout * delayGenerator next ) wait.
	aReplySocket
		sendUDPData: service discoveryResponse
		toHost: aSender host
		port: aSender port ] forkAt: Processor activeProcess priority + 1
! !

!SSDPServer methodsFor:'starting'!

offerService: anSSDPService
	^self offerService: anSSDPService onSocketFail: nil
!

offerService: anSSDPService onSocketFail: aSocketFailHandler
	self shutDown.
	service := anSSDPService.
	service serverInfo: self versionInfo.
	socketFailHandler := aSocketFailHandler.
	self startUp.
!

offerServiceType: aServiceType atLocation: aLocation
	^ self
		offerServiceType: aServiceType
		atLocation: aLocation
		onSocketFail: nil
!

offerServiceType: aServiceType atLocation: aLocation onSocketFail: aSocketFailHandler
	^ self
		offerService:
			(SSDPService
				ofType: aServiceType
				atLocation: aLocation)
		onSocketFail: aSocketFailHandler
! !

!SSDPServer methodsFor:'starting - all'!

onAllInterfacesOfferService: anSSDPService
	^self onAllInterfacesOfferService: anSSDPService onSocketFail: nil
!

onAllInterfacesOfferService: anSSDPService onSocketFail: aSocketFailHandler
	self shutDown.
	service := anSSDPService.
	service serverInfo: self versionInfo.
	socketFailHandler := aSocketFailHandler.
	self startUpOnAll.
!

onAllInterfacesOfferServiceType: aServiceType atLocation: aLocation
	^ self
		onAllInterfacesOfferServiceType: aServiceType
		atLocation: aLocation
		onSocketFail: nil
!

onAllInterfacesOfferServiceType: aServiceType atLocation: aLocation onSocketFail: aSocketFailHandler
	^ self
		onAllInterfacesOfferService:
			(SSDPService
				ofType: aServiceType
				atLocation: aLocation)
		onSocketFail: aSocketFailHandler
! !

!SSDPServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPServer.st,v 1.5 2018-05-15 07:59:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPServer.st,v 1.5 2018-05-15 07:59:08 cg Exp $'
! !


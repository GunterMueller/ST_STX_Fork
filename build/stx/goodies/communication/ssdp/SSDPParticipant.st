"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SSDPParticipant
	instanceVariableNames:'listeningSockets sendingSockets multicastInfo runningOn
		socketFailHandler'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Core'
!

SSDPParticipant comment:''
!


!SSDPParticipant class methodsFor:'as yet unclassified'!

v4SiteLocal
	^self new initializev4SiteLocal
!

v6Global
	^self new initializev6Global
!

v6LinkLocal
	^self new initializev6LinkLocal
!

v6OrganizationLocal
	^self new initializev6OrganizationLocal
!

v6SiteLocal
	^self new initializev6SiteLocal
! !

!SSDPParticipant methodsFor:'accessing'!

multicastInfoPort
	^multicastInfo port
! !

!SSDPParticipant methodsFor:'initialize - release'!

initializeSocketsForInterface: localInterface
        "Setup sockets that can listen and send data to the multicast address on the subnet of localInterface"
| listeningSocket sendingSocket validMulticast |
                        listeningSocket := Socket newUDP.
                        listeningSocket setOption: 'SO_REUSEADDR' value: true.
                        "Add to multicast group so the OS doesn't block the traffic we're interested in"
                        listeningSocket
                            setOption: 'IP_ADD_MEMBERSHIP'
                            value: (multicastInfo host , localInterface).
                        
                        (Smalltalk os platformName asLowercase = 'win32') 
                        ifFalse:[ "To receive traffic sent to multicast address, OSX must be bound to the multicast address"
                                    "Do the same on *nix, not sure if needed, but save the extra branch unless found necessary"
                                    listeningSocket bindTo: multicastInfo host port: multicastInfo port ] 
                            ifTrue: [ "Windows on the other hand, does not allow binding to multicast addresses, but will receive multicast traffic when bound to a local interface. Though, it also must be bound to the correct port"
                                    listeningSocket bindTo: localInterface port: multicastInfo port ].

                        
                                
                "Theoretically, on Windows, there's no technical reason why we could not use the same socket to send, but since in the actual subclasses we use processes waiting on data from sending/listening sockets, with different handlers, it's more convenient to just create separate sockets here for Windows as well."              
                        sendingSocket := Socket newUDP.
                                "Sending sockets also need to be added to the multicast group, otherwise network interface will only deliver packets we send locally."
                        sendingSocket
                            setOption: 'IP_ADD_MEMBERSHIP'
                            value: multicastInfo host , localInterface.

                        "We want to send data from the specific local interface"
                        sendingSocket bindTo: localInterface port: 0.
                        
                
                        "If we can't send data through this interface, exclude it from those we communicate with.
                        (For instance, it fails for virtual interfaces created by non-running Parallels VM's on OSX)"
                        validMulticast := [ 
                                "Probing with an empty package causes listening sockets to end up in ConnectedButClosedByOtherSide, so send a packet with length=1"
                                sendingSocket
                                sendUDPData: #[0]
                                toHost: multicastInfo host
                                port: multicastInfo port.
                        true ]
                                on: PrimitiveFailed
                                do: [ false ].
                        
                        validMulticast
                                ifTrue: [ listeningSockets add: listeningSocket.
                                        sendingSockets add: sendingSocket ].
                ^validMulticast
!

initializeSocketsOn: localInterfaces
	listeningSockets := OrderedCollection new.
	sendingSockets := OrderedCollection new.
	^localInterfaces
		select:
			[ :localInterfaceAddress | 
			self initializeSocketsForInterface: localInterfaceAddress ]
!

initializev4SiteLocal
	"Set up a socket to listen/send search requests on the IPv4 site local multicast address 239.255.255.250"

	multicastInfo := ProtocolClient new host: #[239 255 255 250]; port: 1900; yourself.
	
!

initializev6Global
	"Set up a socket to listen/send search requests on the IPv6 global multicast address [FF0E::C]"
	^self notYetImplemented 
!

initializev6LinkLocal
"Set up a socket to listen/send search requests on the IPv6 link local multicast address [FF02::C]"
	^self notYetImplemented 
!

initializev6OrganizationLocal
"Set up a socket to listen/send search requests on the IPv6 organization local multicast address [FF08::C]"
	^self notYetImplemented 
!

initializev6SiteLocal
"Set up a socket to listen/send search requests on the IPv6 site local multicast address [FF05::C]"
	^self notYetImplemented 
!

startUp
	"Let socket finalization handle release of resources; but ensure sockets are valid when we start up"
	runningOn := 
	self initializeSocketsOn: (self localAddressesFor: multicastInfo host).
	
!

startUpOnAll
	"Let socket finalization handle release of resources; but ensure sockets are valid when we start up"
	runningOn := 
	self initializeSocketsOn: (self allLocalAddressesFor: multicastInfo host).
	
! !

!SSDPParticipant methodsFor:'private'!

hostName
	|host domainIx|
	"Remember to set UseOldNetworking to false when running on Squeak, otherwise localHostName is likely to return a helpful '127.0.0.1' or similar"
	NetNameResolver initializeNetwork.
	host := NetNameResolver localHostName.
	"Strip out any subdomains, to get the most available interfaces, local if none in name so we do a dns lookup, instead of returning loopback ip"
	"if host is just an ip address do nothing"
	(host copyUpTo: $.) isAllDigits
		ifFalse: [
	Smalltalk os platformName = 'Mac OS' ifFalse: [domainIx := host lastIndexOf: $..
	domainIx > 0 
		ifTrue: [host := (host copyUpTo: $.) ] .
	host := host, '.local'].].
	^host
!

ipv4Port
	^1900
!

ipv6LegacyPort
	"XP > "
	^5000
!

ipv6Port
	^2869
!

readDatagramFrom: aSocket using: buffer
        | fullDatagram status read |
        "Receiving data will change remoteAddress to the actual sender.
        Senders who care about aSockets values of these are responsible for preserving/restoring them."

        fullDatagram := buffer.
        status := aSocket receiveUDPDataInto: buffer.
        SSDPService verbose ifTrue:[
            Transcript showCR:'status: ' with:status.
        ].
        read := status at: 1.
        (status at: 4)
                ifTrue: [ fullDatagram := buffer copyFrom: 1 to: read ].
        [ status at: 4 ]
                whileTrue:
                        [ status := aSocket receiveUDPDataInto: buffer.
                        read := read + (status at: 1).
                        fullDatagram := fullDatagram
                                , (buffer copyFrom: 1 to: (status at: 1)) ].
        "We can safely return the fullDatagram without the amount read, since all SSDP messages use http header format, which
        are always terminated with an empty line. So there's no chance for a compliant header parser to mistakenly read past that point"
        SSDPService verbose == true ifTrue:[
            Transcript showCR:fullDatagram.
        ].
        ^fullDatagram.
!

readSenderAndDatagramFrom: aSocket using: buffer
        | fullDatagram status read |
        "Use this method to read datagrams for which the sender expects a reply; normally receiveUDPDataInto: sets remoteAddress/port to this info; but not for multicast sockets. Nor is it very thread-safe to fork of replies... "

        fullDatagram := buffer.
        status := aSocket receiveUDPDataInto: buffer.
        SSDPService verbose ifTrue:[
            Transcript showCR:'status: ' with:status.
        ].
        read := status at: 1.
        (status at: 4)
                ifTrue: [ fullDatagram := buffer copyFrom: 1 to: read ].
        [ status at: 4 ]
                whileTrue:
                        [ status := aSocket receiveUDPDataInto: buffer.
                        read := read + (status at: 1).
                        fullDatagram := fullDatagram
                                , (buffer copyFrom: 1 to: (status at: 1)) ].
        "We can safely return the fullDatagram without the amount read, since all SSDP messages use http header format, which
        are always terminated with an empty line. So there's no chance for a compliant header parser to mistakenly read past that point"
        ^(ProtocolClient new host: status second; port: status third; yourself) -> fullDatagram.
! !

!SSDPParticipant methodsFor:'private - interface enumeration'!

allLocalAddressesFor: aMulticastAddress
	^ aMulticastAddress size = 4
		ifTrue: [ self allLocalV4Addresses ]
		ifFalse: [ self allLocalV6Addresses ]
!

allLocalV4Addresses
	"Pharo has removed all support classes and calls to the ipv6-aware primitives, 
	amongst them the ones needed to find local interfaces.
	Inline their use here, so it works for both Pharo and Squeak"
	^self localAddresses: 2 port: self ipv4Port.
!

allLocalV6Addresses
	^self notYetImplemented 
!

defaultLocalV4Addresses
	"A meta-address used to let the system determine which interface to bind a port on"
	^#(#[0 0 0 0])
!

defaultLocalV6Addresses
	"A meta-address used to let the system determine which interface to bind a port on"
	^self notYetImplemented 
!

localAddresses: aFamily port: aPort
	"Pharo has removed all support classes and calls to the ipv6-aware primitives, 
	amongst them the ones needed to find local interfaces.
	Inline their use here, so it works for both Pharo and Squeak
	Remember to set UseOldNetwork to false when running on Squeak, or localHostname is likely to return
	a helpful result such as '127.0.0.1' instead of the actual hostname.
	Assume distinct hostnames on the network, otherwise, we may return the ip address of another machine with the same name..."

	"aFamily:
	1 = ipv6
	2 = ipv4"

	| ipOffsets protocol type host result |
	"ipv4 address found from 13-16 in address object, ipv6 from 15-32 "
	ipOffsets := #(#[ 15 32 ] #[ 13 16 ]).
	"Protocol:
	1 = TCP
	2 = UDP
	Type:
	1 = Streaming
	2 = Datagram"
	protocol := 2.
	type := protocol.
	"Obviously, we can't just pass in '' to mean all local addresses, that either resolves to the 'let OS decide' or loopback address depending on flags... So we need to jump some hoops to get the actual network interfaces based on localHostName."
	host := self hostName.
	
	NetNameResolver
		primGetAddressInfoHost: host
		service: aPort asString
		flags: 0
		family: aFamily
		type: type
		protocol: protocol.	"Obviously, the port number must be passed to primitive as string, lest the primitive crash"	"IPv4"
	result := OrderedCollection new.
	"For now, don't guard the prim call to collect addresses, and the subsequent ones reading the results from outside interference"
	[ | addrSize addr rawAddress |
	addrSize := NetNameResolver primGetAddressInfoSize.
	addrSize < 0
		ifTrue: [ ^ result ].
	addr := ByteArray new: addrSize.
	NetNameResolver primGetAddressInfoResult: addr.
	rawAddress := addr copyFrom: (ipOffsets at: aFamily) first to: (ipOffsets at: aFamily) last.
	NetNameResolver primGetAddressInfoNext.
	"Observed duplicate entries when disabling/enabling networks on OSX; remove any such just in case"
	(result includes: rawAddress) ifFalse: [result add: rawAddress] ] repeat
!

localAddressesFor: aMulticastAddress
	^ aMulticastAddress size = 4
		ifTrue: [ self defaultLocalV4Addresses ]
		ifFalse: [ self defaultLocalV6Addresses ]
! !

!SSDPParticipant class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPParticipant.st,v 1.5 2018-05-14 20:26:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPParticipant.st,v 1.5 2018-05-14 20:26:50 cg Exp $'
! !


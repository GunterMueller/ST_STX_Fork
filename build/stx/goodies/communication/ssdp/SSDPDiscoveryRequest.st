"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

SSDPMessage subclass:#SSDPDiscoveryRequest
	instanceVariableNames:'timeout'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Core'
!

SSDPDiscoveryRequest comment:'This message is sent by a client to the multicast address in order to trigger responses from available servers that implement the serviceType the client is interested in.'
!


!SSDPDiscoveryRequest class methodsFor:'testing'!

represents: aDatagram
	"Discovery responses must always have status 200 OK"
	^aDatagram beginsWith: 'M-SEARCH * HTTP/1.1'
! !

!SSDPDiscoveryRequest methodsFor:'accessing'!

timeout
	^timeout
! !

!SSDPDiscoveryRequest methodsFor:'handling'!

serviceChangeIn: aCache
	"Discovery requests are not to be handled as an entry to cache"
	^nil
! !

!SSDPDiscoveryRequest methodsFor:'initialize - release'!

initializeFrom: aDatagram
| stream headers  |
	stream := aDatagram asString readStream.
	stream nextLine trim = 'M-SEARCH * HTTP/1.1' ifFalse: [ ^nil ].
	headers := ZnHeaders readFrom: stream.
	(headers at: 'Man') = '"ssdp:discover"' ifFalse: [ ^nil ].
	serviceType :=  headers at: 'St'.
	"Reply required within timeout, default within 1 second. 
	Squeak Number >> #asDuration gives nanoseconds, not seconds, so set duration as seconds explicitly"
	timeout := Duration seconds: (headers at:'Mx' ifAbsent: [1]) asNumber.
	
! !

!SSDPDiscoveryRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPDiscoveryRequest.st,v 1.2 2018-05-14 20:26:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPDiscoveryRequest.st,v 1.2 2018-05-14 20:26:47 cg Exp $'
! !


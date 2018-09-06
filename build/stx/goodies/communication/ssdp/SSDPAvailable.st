"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

SSDPMessage subclass:#SSDPAvailable
	instanceVariableNames:'location serverInfo discoveryTime maxAge'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Core'
!

SSDPAvailable comment:'This message  is sent by a server to the multicast address both when the server starts, to signal existing clients that a new service is available, and after that at intervals less than the maxAge of the service, so that clients won''t signal interested parties that the service has become unavailable unneccessarily.'
!


!SSDPAvailable class methodsFor:'testing'!

represents: aDatagram
	"Available responses must always use the NOTIFY method"

	|ntsIndex| "Hacky, potentially wrong if there's two fields of value ssdp:alive, but let's not do full header parsing twice..."
	^ (aDatagram
		beginsWith: 'NOTIFY * HTTP/1.1')
		and:
			[
			(ntsIndex := aDatagram indexOfSubCollection: 'ssdp:alive') > 0
			and: [
			    "We reuse buffers, make sure we're not matching remnants of old datagram by checking against endofheaders sequence"
			    ntsIndex < (aDatagram indexOfSubCollection: String crlf, String crlf) ]]
! !

!SSDPAvailable methodsFor:'accessing'!

discoveryTime
	^discoveryTime
!

location
	^location
!

maxAge
	^maxAge
!

serverInfo
	^serverInfo
! !

!SSDPAvailable methodsFor:'conversion'!

asService
	^SSDPService new merge: self
! !

!SSDPAvailable methodsFor:'handling'!

deliver: service ifAvailable: whenAvailable ifUnavailable: whenByeBye
	whenAvailable value: service
!

serviceChangeIn: aCache

	^aCache updateServiceFor: self
! !

!SSDPAvailable methodsFor:'initialize - release'!

initializeFrom: aDatagram
| stream headers cacheParams locString|
	stream := aDatagram readStream.
	stream nextLine trim = 'NOTIFY * HTTP/1.1' ifFalse: [ ^nil ].
	headers := ZnHeaders readFrom: stream.
	(headers at: 'Nts') = 'ssdp:alive' ifFalse: [ ^nil ].
	"Obligatory SSDP notify fields"
	serviceType :=  headers at: 'Nt'.
	uniqueServiceName :=  headers at: 'Usn'.
	"Cache control fields"
	"TODO: Convert to DateAndTime if actually present"
	discoveryTime :=  headers at:'Date' ifAbsent: [ DateAndTime now].
	cacheParams := ( headers at: 'Cache-control' ifAbsent: ['']) splitOn: ',' .
	"Could also be communicated through Expiry field, only support maxAge for now"
	maxAge := (  (cacheParams detect: [:one | one beginsWith: 'max-age'] ifNone: '0') splitOn: '=') last trim asNumber seconds.
	"Common SSDP notify fields"

	serverInfo :=  headers at: 'Server' ifAbsent: nil.
	location :=  (locString := headers at: 'Location' ifAbsent: nil)
			    ifNotNil: [locString asUrl].

! !

!SSDPAvailable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPAvailable.st,v 1.3 2018-05-14 20:26:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPAvailable.st,v 1.3 2018-05-14 20:26:38 cg Exp $'
! !


"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

SSDPMessage subclass:#SSDPUnavailable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Core'
!

SSDPUnavailable comment:'This message  is sent to the multicast address by a server when a service is purposefully shut down, and clients can be notified that it will no longer be available.'
!


!SSDPUnavailable class methodsFor:'testing'!

represents: aDatagram
	"Available responses must always use the NOTIFY method"

	|ntsIndex|
	^ (aDatagram
		beginsWith: 'NOTIFY * HTTP/1.1')
		and:
			[
 "Hacky, potentially wrong if there's two fields of value ssdp:alive, but let's not do full header parsing twice..."
			(ntsIndex := aDatagram indexOfSubCollection: 'ssdp:byebye') > 0 and: ["We reuse buffers, make sure we're not matching remnants of old datagram by checking against endofheaders sequence" ntsIndex < (aDatagram indexOfSubCollection: String crlf, String crlf) ]]
! !

!SSDPUnavailable methodsFor:'handling'!

deliver: service ifAvailable: whenAvailable ifUnavailable: whenByeBye
	whenByeBye value: service
!

serviceChangeIn: aCache
	^aCache removeServiceFor: self
! !

!SSDPUnavailable methodsFor:'initialize - release'!

initializeFrom: aDatagram
	| stream headers |
	stream := aDatagram readStream.
	stream nextLine trim = 'NOTIFY * HTTP/1.1' ifFalse: [ ^nil ].
	headers := ZnHeaders readFrom: stream.
	(headers at: 'Nts') = 'ssdp:byebye' ifFalse: [ ^nil ].
	"Obligatory SSDP notify fields"
	serviceType :=  headers at: 'Nt'.
	uniqueServiceName :=  headers at: 'Usn'.
! !

!SSDPUnavailable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPUnavailable.st,v 1.3 2018-05-14 20:26:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPUnavailable.st,v 1.3 2018-05-14 20:26:48 cg Exp $'
! !


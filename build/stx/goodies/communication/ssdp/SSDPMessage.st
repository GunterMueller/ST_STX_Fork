"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SSDPMessage
	instanceVariableNames:'serviceType uniqueServiceName'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Core'
!

SSDPMessage comment:'An SSDPMessage  subclass represents a distinct unit of communication between servers and clients, as defined by the protocol.
!


!SSDPMessage class methodsFor:'instance creation'!

from: aDatagram
	| notificationClass |
	notificationClass := self subclasses 
		detect: [ :one | (one represents: aDatagram) ] 
		ifNone: [ "Not an SSDP datagram" ^nil ].
	^notificationClass fromDatagram: aDatagram
!

fromDatagram: aDatagram
	
	^self new initializeFrom: aDatagram
! !

!SSDPMessage class methodsFor:'testing'!

represents: aDatagram
	^self subclassResponsibility
! !

!SSDPMessage methodsFor:'accessing'!

serviceType
	^serviceType
!

uniqueServiceName
	^uniqueServiceName
! !

!SSDPMessage methodsFor:'initialize - release'!

initializeFrom: aDatagram
	^self subclassResponsibility
!

relatedTo: aService
	^aService uniqueServiceName = uniqueServiceName 
! !

!SSDPMessage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPMessage.st,v 1.2 2018-05-14 20:26:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPMessage.st,v 1.2 2018-05-14 20:26:41 cg Exp $'
! !

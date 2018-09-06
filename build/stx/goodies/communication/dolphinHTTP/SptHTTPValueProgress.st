"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPProgress subclass:#SptHTTPValueProgress
	instanceVariableNames:'percentageValue stateValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptHTTPValueProgress methodsFor:'public'!

initialize
	super initialize.
	percentageValue := ValueHolder new.
	stateValue := ValueHolder new
!

onCompleted
	percentageValue value: 0.
	stateValue value: ''
!

onConnected
	stateValue value: 'Connected'
!

onConnecting
	stateValue value: 'Connecting'
!

onReadingBody
	stateValue value: 'Reading'
!

onReadingHeaders
	stateValue value: 'Reading'
!

onSendingEntity
	stateValue value: 'Sending'
!

onSendingHeaders
	stateValue value: 'Sending'
!

percentageValue
	^percentageValue
!

percentageValue: anObject
	percentageValue := anObject
!

progressChanged: aNumber
	percentageValue value: aNumber
!

read: cumulativeNumOfBytes of: totalNumOfBytes
	"totalNumOfBytesOrNil will be nil unless we received a content-length header.
		-For HTTP1.0 this can be common ... we are expected to read from the server until it closes its end of the socket
		-For HTTP1.1 this will occur if the server is using chunked transfer-encoding"

	| total |
	total := totalNumOfBytes isNil ifTrue: [50000] ifFalse: [totalNumOfBytes].
	self progressChanged: cumulativeNumOfBytes * 100 // total
!

sent: cumulativeNumOfBytes of: totalNumOfBytes
	self progressChanged: cumulativeNumOfBytes * 100 // totalNumOfBytes
!

stateValue
	^stateValue
!

stateValue: anObject
	stateValue := anObject
! !

!SptHTTPValueProgress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPValueProgress.st,v 1.2 2011-10-04 12:17:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPValueProgress.st,v 1.2 2011-10-04 12:17:18 cg Exp $'
! !

"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPProgress subclass:#SptHTTPTriggerProgress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptHTTPTriggerProgress methodsFor:'public'!

progressChanged: aNumber
	request trigger: #progressChanged: with: aNumber
	"valueModel value: aNumber"
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
! !

!SptHTTPTriggerProgress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPTriggerProgress.st,v 1.2 2011-10-04 12:17:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPTriggerProgress.st,v 1.2 2011-10-04 12:17:18 cg Exp $'
! !

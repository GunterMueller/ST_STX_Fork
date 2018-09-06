"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPProgressAbstract subclass:#SptHTTPProgress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPProgress comment:'
This is a stub class that implements all the messages a request''s progress can receive.

	See: SptHTTPRequest(class)>>exampleProgress

Subclasses can implement the methods that they are interested in.

Two subclasses are provided:
	SptHTTPTriggerProgress ... for triggering notifications of the % of a download/upload complete
	SptHTTPValueProgress ... sets string descriptions of progress into a value model

'
!


!SptHTTPProgress methodsFor:'public'!

initialize
	super initialize
!

onCompleted
	
!

onConnected
	
!

onConnecting
	
!

onReadBody
	
!

onReadHeaders
	"Note: In the case of chunked transfer encoding, this will be sent both before and after reading the body"

	
!

onReadStatus
	"Note: This may be sent more than once if the server sends a informational CONTINUE response, "

	
!

onReadingBody
	
!

onReadingHeaders
	"Note: In the case of chunked transfer encoding, this will be sent both before and after reading the body"

	
!

onReadingStatus
	"Note: This may be sent more than once if the server sends a informational CONTINUE response, "

	
!

onRedirecting
	
!

onSendingEntity
	
!

onSendingHeaders
	
!

onSentEntity
	
!

onSentHeaders
	
!

onTimeout
	
!

progressChanged: aNumber
	Notification deprecated
!

read: cumulativeNumOfBytes of: totalNumOfBytesOrNil
	"totalNumOfBytesOrNil will be nil unless we received a content-length header.
		-For HTTP1.0 this can be common ... we are expected to read from the server until it closes its end of the socket
		-For HTTP1.1 this will occur if the server is using chunked transfer-encoding"

	
!

sent: cumulativeNumOfBytes of: totalNumOfBytes
	
! !

!SptHTTPProgress class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPProgress.st,v 1.1 2011-09-23 13:41:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPProgress.st,v 1.1 2011-09-23 13:41:24 cg Exp $'
! !

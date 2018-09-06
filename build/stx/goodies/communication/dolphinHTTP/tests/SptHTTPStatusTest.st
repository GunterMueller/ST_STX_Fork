"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

SptHTTPTests subclass:#SptHTTPStatusTest
	instanceVariableNames:'status'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!


!SptHTTPStatusTest methodsFor:'accessing'!

setStatusOn: aString
	status := SptHTTPStatus fromString: aString
! !

!SptHTTPStatusTest methodsFor:'set up'!

setUp
	super setUp.
	status := SptHTTPStatus fromString: 'HTTP/1.1 200 OK'
! !

!SptHTTPStatusTest methodsFor:'unit tests'!

statusCodeString
	self setStatusOn: 'HTTP/1.1 200 OK'.
	self assert: status statusCodeString = '200'
!

testHttpClientException
        self setStatusOn: 'HTTP/1.1 404'.
        self 
                should: [status httpException raiseRequest "signal"]
                raise: SptHTTPClientError
                description: 'Client Error  HTTP/1.1 404'

    "Modified: / 23-09-2011 / 21:22:32 / cg"
!

testHttpServerException
        self setStatusOn: 'HTTP/1.1 500'.
        self 
                should: [status httpException raiseRequest "signal"]
                raise: SptHTTPServerError
                description: 'Server Error  HTTP/1.1 500'

    "Modified: / 23-09-2011 / 21:22:37 / cg"
!

testIsClientOrServerError
	self setStatusOn: 'HTTP/1.1 200 OK'.
	self deny: status isClientOrServerError.
	self deny: status isClientError.
	self deny: status isServerError.
	self setStatusOn: 'HTTP/1.1 404'.
	self assert: status isClientOrServerError.
	self assert: status isClientError.
	self deny: status isServerError.
	self setStatusOn: 'HTTP/1.1 500'.
	self assert: status isClientOrServerError.
	self deny: status isClientError.
	self assert: status isServerError
!

testIsInformational
	self setStatusOn: 'HTTP/1.1 200 OK'.
	self deny: status isInformational.
	self setStatusOn: 'HTTP/1.1 100'.
	self assert: status isInformational.
	self setStatusOn: 'HTTP/1.1 102'.
	self assert: status isInformational
!

testIsSuccess
	self setStatusOn: 'HTTP/1.1 200 OK'.
	self assert: status isSuccessful.
	self setStatusOn: 'HTTP/1.1 207'.
	self assert: status isSuccessful.
	self setStatusOn: 'HTTP/1.1 404'.
	self deny: status isSuccessful
!

testIsVersion11
	self setStatusOn: 'HTTP/1.1 200 OK'.
	self assert: status isVersion11.
	self setStatusOn: 'HTTP/1.0 200 OK'.
	self deny: status isVersion11
!

testStatusCode
	self setStatusOn: 'HTTP/1.1 200 OK'.
	self assert: (status statusCode isKindOf: Integer)
! !

!SptHTTPStatusTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPStatusTest.st,v 1.3 2011-09-23 20:22:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPStatusTest.st,v 1.3 2011-09-23 20:22:54 cg Exp $'
! !

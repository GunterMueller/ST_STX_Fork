"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPStatus
	instanceVariableNames:'statusLine'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPStatus comment:'I am the status of an HTTP Response message

Instance Variables:
	statusLine	<String>'
!


!SptHTTPStatus class methodsFor:'instance creation'!

fromString: aString
	^self new statusLine: aString
! !

!SptHTTPStatus methodsFor:'accessing'!

status
	"Answer the status code of the response"

	"
	(self fromString: 'HTTP/1.1 404 Not Found') status
		404
	"

	^self statusCodeString asNumber
!

statusCode
	"Answer the status code of the response"

	"
	(self fromString: 'HTTP/1.1 404 Not Found') statusCode
		404
	"

	^self status
!

statusCodeString
	"Answer the status code of the response"

	"
	(self fromString: 'HTTP/1.1 404 Not Found') statusCodeString
		'404'
	"

	| stream |
	stream := statusLine readStream.
	stream upTo: Character space.
	^stream upTo: Character space
!

statusLine
	"Answer the response status line"

	^statusLine
!

statusText
	"Answer the Status text of the response"

	"
	(self fromString: 'HTTP/1.1 404 Not Found') statusText
		'Not Found'
	"

	| stream |
	stream := statusLine readStream.
	stream upTo: Character space.
	stream upTo: Character space.
	^stream upToEnd
! !

!SptHTTPStatus methodsFor:'displaying'!

displayOn: stream
	statusLine displayOn: stream
! !

!SptHTTPStatus methodsFor:'exceptions'!

httpException
	"Answer an exception instance that describes the error"

	"
	(self fromString: 'HTTP/1.1 404 Not Found') httpException signal
	"

	| exClass |
	exClass := self httpExceptionClass.
	^(exClass new)
		httpStatus: self;
		yourself
!

httpExceptionClass
	^self isClientError 
		ifTrue: [SptHTTPClientError]
		ifFalse: 
			[self isServerError 
				ifTrue: [SptHTTPServerError]
				ifFalse: 
					["? If you say so"

					SptHTTPError]]
! !

!SptHTTPStatus methodsFor:'test accessing'!

statusLine: aString
	statusLine := aString
! !

!SptHTTPStatus methodsFor:'testing'!

isClientError
	^self statusCodeString first = $4
!

isClientOrServerError
	^self statusCode >= 400
!

isInformational
	^self statusCodeString first = $1
!

isServerError
	^self statusCodeString first = $5
!

isSuccessful
	^self statusCodeString first = $2
!

isVersion11
	| stream |
	stream := statusLine readStream.
	self assert: [(stream next: 5) = 'HTTP/'].
	^(stream upTo: Character space) = '1.1'
! !

!SptHTTPStatus class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPStatus.st,v 1.2 2011-09-23 18:55:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPStatus.st,v 1.2 2011-09-23 18:55:11 cg Exp $'
! !

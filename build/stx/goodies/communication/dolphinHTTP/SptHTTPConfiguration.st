"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPConfiguration
	instanceVariableNames:'httpConnectionClass httpsConnectionClass responseClass
		progressClass sendEntityBufferSize readEntityBufferSize'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPConfiguration comment:'SptHTTPConfiguration

I am a configuration class that can be used to modify what classes an <SptHTTPRequest> uses.

Typical use would be to create your own subclass which answers your own classes, and then create requests like:

	
	request := SptHTTPRequest newFor: (MyHTTPConfiguration newDefault)



Instance Variables:
	httpConnectionClass	<Class>
	httpsConnectionClass	<Class>
	responseClass		<Class>
	progressClass		<Class>
	sendEntityBufferSize	<Integer> (1024 is good for frequent progress, 4096 is better for performance)
	readEntityBufferSize		<Integer>'
!


!SptHTTPConfiguration class methodsFor:'instance creation'!

newDefault
	^(self new)
		httpConnectionClass: SptHTTPConnection;
		httpsConnectionClass: SptHTTPSConnection;
		responseClass: SptHTTPResponse;
		progressClass: SptHTTPProgress;
		sendEntityBufferSize: 1024;
		readEntityBufferSize: 1024;
		yourself
! !

!SptHTTPConfiguration methodsFor:'accessing'!

httpConnectionClass
	^httpConnectionClass
!

httpConnectionClass: anObject
	httpConnectionClass := anObject
!

httpsConnectionClass
	^httpsConnectionClass
!

httpsConnectionClass: anObject
	httpsConnectionClass := anObject
!

newProgressFor: aRequest
	^(self progressClass new)
		request: aRequest;
		yourself
!

newResponseFor: aRequest
	^(self responseClass new)
		request: aRequest;
		yourself
!

progressClass
	^progressClass
!

progressClass: anObject
	progressClass := anObject
!

readEntityBufferSize
	^readEntityBufferSize
!

readEntityBufferSize: anObject
	readEntityBufferSize := anObject
!

responseClass
	^responseClass
!

responseClass: anObject
	responseClass := anObject
!

sendEntityBufferSize
	^sendEntityBufferSize
!

sendEntityBufferSize: anInteger
	sendEntityBufferSize := anInteger
! !

!SptHTTPConfiguration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPConfiguration.st,v 1.2 2011-09-23 18:54:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPConfiguration.st,v 1.2 2011-09-23 18:54:32 cg Exp $'
! !

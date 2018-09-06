"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPMessageProcessor
	instanceVariableNames:'zmqSocket stop wireMessage'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Core'
!

IPMessageProcessor comment:''
!


!IPMessageProcessor class methodsFor:'instance creation'!

new: aZmqSocket
	| i |
	i :=	self new.
	i zmqSocket: aZmqSocket.
	^ i startThread 
! !

!IPMessageProcessor methodsFor:'accessing'!

stop
	stop := true
!

threadName
	self subclassResponsibility 
!

wireMessage
	^ wireMessage
!

zmqSocket
	^ zmqSocket
		
!

zmqSocket: aZmqSocket
	zmqSocket := aZmqSocket
		
! !

!IPMessageProcessor methodsFor:'as yet unclassified'!

messageDelimiter 
	^'<IDS|MSG>'
!

processMessage
	|response|
	wireMessage isFull ifTrue:[

	response := wireMessage hmacIsValid 
												ifTrue:[self execute:wireMessage]
												ifFalse:[IPHMACException signal:'Wrong HMAC'].

	wireMessage := IPWireMessage new].


						
	
!

publish: aResult
	(IPharoKernel instance processors at:#iopub) publish:  aResult
!

startThread
	[	|more|
		wireMessage := IPWireMessage new.
		self threadStarted.
		more := 1.
		[ self isStopping ] whileFalse:[
			self zmqSocket receiveIfAvailable: [ :messageData|  
							more:= self zmqSocket getOption: ZmqApiConstants zmqRcvMore.
							messageData size > 0 ifTrue:[self pushMessageFrame:messageData].
							more = 0 ifTrue: [ self processMessage ]].	
			Processor yield].
			] forkAt: Processor userSchedulingPriority named: self threadName
!

threadStarted
	"do nothing"
! !

!IPMessageProcessor methodsFor:'hooks'!

debug: anError
	Transcript show: anError asString;cr
!

execute: anIPMessage
	self subclassResponsibility 
! !

!IPMessageProcessor methodsFor:'parsing'!

pushMessageFrame:messageData 
	Transcript show: '-', messageData asString;cr.
	(messageData =  (self messageDelimiter asByteArray))
				ifFalse:[wireMessage push:messageData ]

						
	
! !

!IPMessageProcessor methodsFor:'running'!

respond: anIPResponse
	| aResponse |
	aResponse := IPWireMessage newFromMessage: anIPResponse.
	self zmqSocket  
				send: aResponse uuid flags:ZmqApiConstants  zmqSendMore;
	 			send: self messageDelimiter asByteArray flags:ZmqApiConstants  zmqSendMore;
 				send: aResponse calculateHMAC hex asByteArray flags:ZmqApiConstants  zmqSendMore;
 				send: aResponse header flags:ZmqApiConstants  zmqSendMore;
				send: aResponse parentHeader flags:ZmqApiConstants  zmqSendMore;
 				send: aResponse metadata flags:ZmqApiConstants  zmqSendMore;
				send: aResponse content 
! !

!IPMessageProcessor methodsFor:'testing'!

isStopping
	^ stop ifNil:[stop:=false]
! !

!IPMessageProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPMessageProcessor.st,v 1.2 2018-05-14 00:47:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPMessageProcessor.st,v 1.2 2018-05-14 00:47:34 cg Exp $'
! !

